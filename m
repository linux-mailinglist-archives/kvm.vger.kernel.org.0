Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E5832B5AB
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382647AbhCCHTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835984AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAGdwkv1QMhyVofOu8vQg3rgyEFvbBQjoShOLbn+SpU=;
        b=OnCji5kFirXILfmrnwBVKFJFQKFilsNOAUQVXbsOMMoGQcD1FX/cTUsjnvAPpW0yvUR3ye
        DuRq38+ihySaWlfOmCkmpHkpZQR6cJmdarDdzr/kqo5lv76mhjDB3A0PP7/AttQsgben6Q
        IBTnkY/XBoSIrXCj8EMQqdPY0eykMTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-nX6TZHI0O2G3wkZlRxdXgQ-1; Tue, 02 Mar 2021 14:33:52 -0500
X-MC-Unique: nX6TZHI0O2G3wkZlRxdXgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80A2E80402C;
        Tue,  2 Mar 2021 19:33:51 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27C6D60CC5;
        Tue,  2 Mar 2021 19:33:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 12/23] KVM: SVM: merge update_cr0_intercept into svm_set_cr0
Date:   Tue,  2 Mar 2021 14:33:32 -0500
Message-Id: <20210302193343.313318-13-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The logic of update_cr0_intercept is pointlessly complicated.
All svm_set_cr0 is compute the effective cr0 and compare it with
the guest value.

Inlining the function and simplifying the condition
clarifies what it is doing.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 54 +++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e7fcd92551e5..968d1a1f2927 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1718,37 +1718,10 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
 }
 
-static void update_cr0_intercept(struct vcpu_svm *svm)
-{
-	ulong gcr0;
-	u64 *hcr0;
-
-	/*
-	 * SEV-ES guests must always keep the CR intercepts cleared. CR
-	 * tracking is done using the CR write traps.
-	 */
-	if (sev_es_guest(svm->vcpu.kvm))
-		return;
-
-	gcr0 = svm->vcpu.arch.cr0;
-	hcr0 = &svm->vmcb->save.cr0;
-	*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
-		| (gcr0 & SVM_CR0_SELECTIVE_MASK);
-
-	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
-
-	if (gcr0 == *hcr0) {
-		svm_clr_intercept(svm, INTERCEPT_CR0_READ);
-		svm_clr_intercept(svm, INTERCEPT_CR0_WRITE);
-	} else {
-		svm_set_intercept(svm, INTERCEPT_CR0_READ);
-		svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
-	}
-}
-
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 hcr0 = cr0;
 
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
@@ -1766,7 +1739,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vcpu->arch.cr0 = cr0;
 
 	if (!npt_enabled)
-		cr0 |= X86_CR0_PG | X86_CR0_WP;
+		hcr0 |= X86_CR0_PG | X86_CR0_WP;
 
 	/*
 	 * re-enable caching here because the QEMU bios
@@ -1774,10 +1747,27 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	 * reboot
 	 */
 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
-	svm->vmcb->save.cr0 = cr0;
+		hcr0 &= ~(X86_CR0_CD | X86_CR0_NW);
+
+	svm->vmcb->save.cr0 = hcr0;
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
-	update_cr0_intercept(svm);
+
+	/*
+	 * SEV-ES guests must always keep the CR intercepts cleared. CR
+	 * tracking is done using the CR write traps.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return;
+
+	if (hcr0 == cr0) {
+		/* Selective CR0 write remains on.  */
+		svm_clr_intercept(svm, INTERCEPT_CR0_READ);
+		svm_clr_intercept(svm, INTERCEPT_CR0_WRITE);
+	} else {
+		svm_set_intercept(svm, INTERCEPT_CR0_READ);
+		svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
+	}
+
 }
 
 static bool svm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-- 
2.26.2


