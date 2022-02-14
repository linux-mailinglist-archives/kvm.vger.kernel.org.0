Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0317C4B5178
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiBNNQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:16:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354079AbiBNNQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:16:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2949E11E
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644844582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iqNmpg70p2b2V5lE1nmJofIjQpAsHoyhWq+TCOBlI0Q=;
        b=RXAsX3zLnceerj+U7x/pQQY0OeXsE+K0NpBVQR+mPrYKogMCrbHZyjeHCFJybE0NLbtnWo
        GkwzwTnYuDDXXf8vmppYP8rj+1u3DPiW/2I8EqgqCLtpAU46A+hww6VrXxfpgo9RXf3x5/
        zzHWth44nyjsR26kxAGiIrDZOxaxwlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-9ttHUNPCPK-fK_AABUPCAQ-1; Mon, 14 Feb 2022 08:16:19 -0500
X-MC-Unique: 9ttHUNPCPK-fK_AABUPCAQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 093F81853026;
        Mon, 14 Feb 2022 13:16:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADD08106F75B;
        Mon, 14 Feb 2022 13:16:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 5/5] KVM: x86: allow defining return-0 static calls
Date:   Mon, 14 Feb 2022 08:16:14 -0500
Message-Id: <20220214131614.3050333-6-pbonzini@redhat.com>
In-Reply-To: <20220214131614.3050333-1-pbonzini@redhat.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few vendor callbacks are only used by VMX, but they return an integer
or bool value.  Introduce KVM_X86_OP_RET0 for them: a NULL value in
struct kvm_x86_ops will be changed to __static_call_return0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 20 +++++++++++++-------
 arch/x86/include/asm/kvm_host.h    |  4 ++++
 arch/x86/kvm/svm/avic.c            |  5 -----
 arch/x86/kvm/svm/svm.c             | 26 --------------------------
 arch/x86/kvm/x86.c                 |  2 +-
 kernel/static_call.c               |  1 +
 6 files changed, 19 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 0a074354aaf7..ad75ff5ac220 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -6,14 +6,19 @@ BUILD_BUG_ON(1)
 /*
  * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
  * "static_call()"s. They are also intended for use when defining
- * the vmx/svm kvm_x86_ops. KVM_X86_OP_OPTIONAL() can be used for those
+ * the vmx/svm kvm_x86_ops.
+ *
+ * KVM_X86_OP_OPTIONAL() can be used for those
  * functions that can have a NULL definition, for example if
  * "static_call_cond()" will be used at the call sites.
+ * KVM_X86_OP_OPTIONAL_RET0() can be used likewise to make
+ * a definition optional, but in this case the default will 
+ * be __static_call_return0.
  */
 KVM_X86_OP(hardware_enable)
 KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
-KVM_X86_OP(cpu_has_accelerated_tpr)
+KVM_X86_OP_OPTIONAL_RET0(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
@@ -76,15 +81,15 @@ KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP_OPTIONAL(hwapic_irr_update)
 KVM_X86_OP_OPTIONAL(hwapic_isr_update)
-KVM_X86_OP_OPTIONAL(guest_apic_has_interrupt)
+KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
 KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
 KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
-KVM_X86_OP(set_tss_addr)
-KVM_X86_OP(set_identity_map_addr)
-KVM_X86_OP(get_mt_mask)
+KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
+KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
+KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
@@ -102,7 +107,7 @@ KVM_X86_OP_OPTIONAL(vcpu_unblocking)
 KVM_X86_OP_OPTIONAL(pi_update_irte)
 KVM_X86_OP_OPTIONAL(pi_start_assignment)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
-KVM_X86_OP_OPTIONAL(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
@@ -126,3 +131,4 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
+#undef KVM_X86_OP_OPTIONAL_RET0
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5dce6fbd9ab6..a0d2925b6651 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1542,12 +1542,16 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
 #define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 static inline void kvm_ops_static_call_update(void)
 {
 #define KVM_X86_OP_OPTIONAL(func) \
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
+#define KVM_X86_OP_OPTIONAL_RET0(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
+			   (void *) __static_call_return0);
 #define KVM_X86_OP(func) \
 	WARN_ON(!kvm_x86_ops.func); KVM_X86_OP_OPTIONAL(func)
 #include <asm/kvm-x86-ops.h>
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4245cb99b497..d4fa8c4f3a9a 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -650,11 +650,6 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	avic_set_pi_irte_mode(vcpu, activated);
 }
 
-bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
-{
-	return false;
-}
-
 static void svm_ir_list_del(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4fa385490f22..7038c76fa841 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3528,16 +3528,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
 }
 
-static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
-{
-	return 0;
-}
-
-static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
-{
-	return 0;
-}
-
 static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3912,11 +3902,6 @@ static int __init svm_check_processor_compat(void)
 	return 0;
 }
 
-static bool svm_cpu_has_accelerated_tpr(void)
-{
-	return false;
-}
-
 /*
  * The kvm parameter can be NULL (module initialization, or invocation before
  * VM creation). Be sure to check the kvm parameter before using it.
@@ -3939,11 +3924,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	return true;
 }
 
-static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
-{
-	return 0;
-}
-
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4529,7 +4509,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
@@ -4599,10 +4578,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
-	.set_tss_addr = svm_set_tss_addr,
-	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_mt_mask = svm_get_mt_mask,
-
 	.get_exit_info = svm_get_exit_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
@@ -4627,7 +4602,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_interrupt = svm_deliver_interrupt,
-	.dy_apicv_has_pending_interrupt = avic_dy_apicv_has_pending_interrupt,
 	.pi_update_irte = avic_pi_update_irte,
 	.setup_mce = svm_setup_mce,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c921d68fc244..9a9006226501 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -131,6 +131,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
 				*(((struct kvm_x86_ops *)0)->func));
 #define KVM_X86_OP_OPTIONAL KVM_X86_OP
+#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
@@ -12018,7 +12019,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	return (is_guest_mode(vcpu) &&
-			kvm_x86_ops.guest_apic_has_interrupt &&
 			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
 }
 
diff --git a/kernel/static_call.c b/kernel/static_call.c
index 43ba0b1e0edb..76abd46fe6ee 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -503,6 +503,7 @@ long __static_call_return0(void)
 {
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__static_call_return0)
 
 #ifdef CONFIG_STATIC_CALL_SELFTEST
 
-- 
2.31.1

