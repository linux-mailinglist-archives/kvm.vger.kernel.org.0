Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B84E4BAB8C
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbiBQVEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243861AbiBQVEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E13001017EF
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=31iQ22wsRKZ1WzBCnkFcq5Zu4wTNEFOLwesoT4L8SYI=;
        b=f/uW3t5OXRRjvebnvWVYum4H5z4BhvPeiE4TMcj8NWf0dJeLseCNGmyAfMlyHv2ujGhoE/
        g4qVWICoRi5Bx8/YVDPXWyM7M8bNUJFuRn5T0diecrytoYHsghlHciU95vgzbxMBS4OmXg
        iELZbs8kCf5O7/hisQ+Xl+BsxdIkTS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-cb2CIOjkPdSQLWPCg5vjOw-1; Thu, 17 Feb 2022 16:03:48 -0500
X-MC-Unique: cb2CIOjkPdSQLWPCg5vjOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD001801AC5;
        Thu, 17 Feb 2022 21:03:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E3936AB9D;
        Thu, 17 Feb 2022 21:03:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 13/18] KVM: x86: reset and reinitialize the MMU in __set_sregs_common
Date:   Thu, 17 Feb 2022 16:03:35 -0500
Message-Id: <20220217210340.312449-14-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do a full unload of the MMU in KVM_SET_SREGS and KVM_SEST_REGS2, in
preparation for not doing so in kvm_mmu_reset_context.  There is no
need to delay the reset until after the return, so do it directly in
the __set_sregs_common function and remove the mmu_reset_needed output
parameter.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6aefd7ac7039..f10878aa5b20 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10730,7 +10730,7 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 }
 
 static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
-		int *mmu_reset_needed, bool update_pdptrs)
+			      int update_pdptrs)
 {
 	struct msr_data apic_base_msr;
 	int idx;
@@ -10755,29 +10755,31 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	static_call(kvm_x86_set_gdt)(vcpu, &dt);
 
 	vcpu->arch.cr2 = sregs->cr2;
-	*mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
+
+	if (vcpu->arch.efer != sregs->efer ||
+	    kvm_read_cr0(vcpu) != sregs->cr0 ||
+	    vcpu->arch.cr3 != sregs->cr3 || !update_pdptrs ||
+	    kvm_read_cr4(vcpu) != sregs->cr4)
+		kvm_mmu_unload(vcpu);
+
 	vcpu->arch.cr3 = sregs->cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 	static_call_cond(kvm_x86_post_set_cr3)(vcpu, sregs->cr3);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-	*mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
 	static_call(kvm_x86_set_efer)(vcpu, sregs->efer);
 
-	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
 	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
-	*mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
 	static_call(kvm_x86_set_cr4)(vcpu, sregs->cr4);
 
+	kvm_init_mmu(vcpu);
 	if (update_pdptrs) {
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		if (is_pae_paging(vcpu)) {
+		if (is_pae_paging(vcpu))
 			load_pdptrs(vcpu, kvm_read_cr3(vcpu));
-			*mmu_reset_needed = 1;
-		}
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	}
 
@@ -10805,15 +10807,11 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	int pending_vec, max_bits;
-	int mmu_reset_needed = 0;
-	int ret = __set_sregs_common(vcpu, sregs, &mmu_reset_needed, true);
+	int ret = __set_sregs_common(vcpu, sregs, true);
 
 	if (ret)
 		return ret;
 
-	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
-
 	max_bits = KVM_NR_INTERRUPTS;
 	pending_vec = find_first_bit(
 		(const unsigned long *)sregs->interrupt_bitmap, max_bits);
@@ -10828,7 +10826,6 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 {
-	int mmu_reset_needed = 0;
 	bool valid_pdptrs = sregs2->flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
 	bool pae = (sregs2->cr0 & X86_CR0_PG) && (sregs2->cr4 & X86_CR4_PAE) &&
 		!(sregs2->efer & EFER_LMA);
@@ -10840,8 +10837,7 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 	if (valid_pdptrs && (!pae || vcpu->arch.guest_state_protected))
 		return -EINVAL;
 
-	ret = __set_sregs_common(vcpu, (struct kvm_sregs *)sregs2,
-				 &mmu_reset_needed, !valid_pdptrs);
+	ret = __set_sregs_common(vcpu, (struct kvm_sregs *)sregs2, !valid_pdptrs);
 	if (ret)
 		return ret;
 
@@ -10850,11 +10846,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 			kvm_pdptr_write(vcpu, i, sregs2->pdptrs[i]);
 
 		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
-		mmu_reset_needed = 1;
 		vcpu->arch.pdptrs_from_userspace = true;
+		/* kvm_mmu_reload will be called on the next entry.  */
 	}
-	if (mmu_reset_needed)
-		kvm_mmu_reset_context(vcpu);
 	return 0;
 }
 
-- 
2.31.1


