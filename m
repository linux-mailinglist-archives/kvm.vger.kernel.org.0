Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125421E8216
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgE2Pjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:39:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48004 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727948AbgE2Pju (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPharsad/CYJlDylaAbb7oFprvzkZzjHFUIEY3m/j00=;
        b=GwVBmuSMkbSOw7lF38T4gJHA9b/LItawBW49Y3INq4qkVEE6CvSHhC+c9soITcs5h87yVm
        UGC7d4KEsSxJ3k4+Lr58sDdw8sFnRaUKJom1n3B8BkQfEJ3uaq3SCXb6pxGmyBLwNSh1Mj
        x0u/4SmveLPrZKfhuoJT2yukjeu4h68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-vx4xJgr6MhCOR38DI-guhg-1; Fri, 29 May 2020 11:39:47 -0400
X-MC-Unique: vx4xJgr6MhCOR38DI-guhg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADC4D464;
        Fri, 29 May 2020 15:39:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6861B10013C2;
        Fri, 29 May 2020 15:39:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 20/30] KVM: SVM: preserve VGIF across VMCB switch
Date:   Fri, 29 May 2020 11:39:24 -0400
Message-Id: <20200529153934.11694-21-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is only one GIF flag for the whole processor, so make sure it is not clobbered
when switching to L2 (in which case we also have to include the V_GIF_ENABLE_MASK,
lest we confuse enable_gif/disable_gif/gif_set).  When going back, L1 could in
theory have entered L2 without issuing a CLGI so make sure the svm_set_gif is
done last, after svm->vmcb->control.int_ctl has been copied back from hsave.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7e4a506828c9..6c7f0bffdf01 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -293,6 +293,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
+	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
 	if (svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE)
 		nested_svm_init_mmu_context(&svm->vcpu);
 
@@ -308,7 +309,10 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
 
-	svm->vmcb->control.int_ctl             = svm->nested.ctl.int_ctl | V_INTR_MASKING_MASK;
+	svm->vmcb->control.int_ctl             =
+		(svm->nested.ctl.int_ctl & ~mask) |
+		(svm->nested.hsave->control.int_ctl & mask);
+
 	svm->vmcb->control.virt_ext            = svm->nested.ctl.virt_ext;
 	svm->vmcb->control.int_vector          = svm->nested.ctl.int_vector;
 	svm->vmcb->control.int_state           = svm->nested.ctl.int_state;
-- 
2.26.2


