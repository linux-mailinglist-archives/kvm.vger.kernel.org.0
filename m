Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172F91F1897
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 14:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgFHMOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 08:14:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25029 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729628AbgFHMOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 08:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591618473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=n0WTesSFX4GdOnD7OP8HwiFpZRIS/BtZoZgv9wJXix0=;
        b=FpMLK4cysvzA2/JuboYEUkDTyjAIV/Pjs0/5abTN9g4cBO9GjgPWFXu9wfPrKFMuEhHN7e
        8bcUSoqcafEO8sxRlQNnrDCTrclmVmj6PCS24u/yG7Z67ZXPTACUyB/f57nZjXhjJ4GZVl
        58c5zFI+0E2uH6Y1CRF7fOsCw4fQrZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-MXyvpYL0M9uFpPHUudC0sA-1; Mon, 08 Jun 2020 08:14:31 -0400
X-MC-Unique: MXyvpYL0M9uFpPHUudC0sA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D50DB8014D4;
        Mon,  8 Jun 2020 12:14:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 326FC619C4;
        Mon,  8 Jun 2020 12:14:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Qian Cai <cai@lca.pw>
Subject: [PATCH] KVM: SVM: fix calls to is_intercept
Date:   Mon,  8 Jun 2020 08:14:28 -0400
Message-Id: <20200608121428.9214-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

is_intercept takes an INTERCEPT_* constant, not SVM_EXIT_*; because
of this, the compiler was removing the body of the conditionals,
as if is_intercept returned 0.

This unveils a latent bug: when clearing the VINTR intercept,
int_ctl must also be changed in the L1 VMCB (svm->nested.hsave),
just like the intercept itself is also changed in the L1 VMCB.
Otherwise V_IRQ remains set and, due to the VINTR intercept being clear,
we get a spurious injection of a vector 0 interrupt on the next
L2->L1 vmexit.

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Vitaly, can you give this a shot with Hyper-V?  I have already
	placed it on kvm/queue, it passes both svm.flat and KVM-on-KVM
	smoke tests.

 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/svm/svm.c    | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8a6db11dcb43..6bceafb19108 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -258,7 +258,7 @@ void sync_nested_vmcb_control(struct vcpu_svm *svm)
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;
 	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
-	    is_intercept(svm, SVM_EXIT_VINTR)) {
+	    is_intercept(svm, INTERCEPT_VINTR)) {
 		/*
 		 * In order to request an interrupt window, L0 is usurping
 		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9e333b91ff78..c8f5e87615d5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1378,6 +1378,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 	/* Drop int_ctl fields related to VINTR injection.  */
 	svm->vmcb->control.int_ctl &= mask;
 	if (is_guest_mode(&svm->vcpu)) {
+		svm->nested.hsave->control.int_ctl &= mask;
+
 		WARN_ON((svm->vmcb->control.int_ctl & V_TPR_MASK) !=
 			(svm->nested.ctl.int_ctl & V_TPR_MASK));
 		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl & ~mask;
@@ -1999,7 +2001,7 @@ void svm_set_gif(struct vcpu_svm *svm, bool value)
 		 */
 		if (vgif_enabled(svm))
 			clr_intercept(svm, INTERCEPT_STGI);
-		if (is_intercept(svm, SVM_EXIT_VINTR))
+		if (is_intercept(svm, INTERCEPT_VINTR))
 			svm_clear_vintr(svm);
 
 		enable_gif(svm);
-- 
2.26.2

