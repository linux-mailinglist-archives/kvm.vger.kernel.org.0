Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7909E4A77BB
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346606AbiBBSS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:18:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346577AbiBBSSV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 13:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643825901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCkmVYi4zqDPYm75x/aIL8dnazRAyGfaINH0ttQQ4CU=;
        b=CNPZfnpKDCF5LQeEaglsrWuYvyAd03aqqEcpntKCOOKdota5+LX8VctEHCU+6BwOKI1YwL
        GtL7aa4YuY0X1COwLUK9ZqQv7x6vlogiKD+Qe4GO9Z3OYal8M9IPXmW/RP0LNyXl9c2rwC
        QxtNDvqcTSCY5BM++Bqvzoi4f7RAZkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-oxKSJTTWM8yqPx13UbJ2Eg-1; Wed, 02 Feb 2022 13:18:18 -0500
X-MC-Unique: oxKSJTTWM8yqPx13UbJ2Eg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31931835B4B;
        Wed,  2 Feb 2022 18:18:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0C727744F;
        Wed,  2 Feb 2022 18:18:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 5/5] KVM: x86: allow defining return-0 static calls
Date:   Wed,  2 Feb 2022 13:18:13 -0500
Message-Id: <20220202181813.1103496-6-pbonzini@redhat.com>
In-Reply-To: <20220202181813.1103496-1-pbonzini@redhat.com>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few vendor callbacks are only used by VMX, but they return an integer
or bool value.  Introduce KVM_X86_OP_RET0 for them: a NULL value in
struct kvm_x86_ops will be changed to __static_call_return0.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 13 +++++++------
 arch/x86/include/asm/kvm_host.h    |  4 ++++
 arch/x86/kvm/svm/avic.c            |  5 -----
 arch/x86/kvm/svm/svm.c             | 26 --------------------------
 arch/x86/kvm/x86.c                 |  2 +-
 5 files changed, 12 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 843bd9efd2ae..89fa5dd21f34 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -13,7 +13,7 @@ BUILD_BUG_ON(1)
 KVM_X86_OP(hardware_enable)
 KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
-KVM_X86_OP(cpu_has_accelerated_tpr)
+KVM_X86_OP_RET0(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
@@ -76,15 +76,15 @@ KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP_NULL(hwapic_irr_update)
 KVM_X86_OP_NULL(hwapic_isr_update)
-KVM_X86_OP_NULL(guest_apic_has_interrupt)
+KVM_X86_OP_RET0(guest_apic_has_interrupt)
 KVM_X86_OP(load_eoi_exitmap)
 KVM_X86_OP(set_virtual_apic_mode)
 KVM_X86_OP_NULL(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_NULL(sync_pir_to_irr)
-KVM_X86_OP(set_tss_addr)
-KVM_X86_OP(set_identity_map_addr)
-KVM_X86_OP(get_mt_mask)
+KVM_X86_OP_RET0(set_tss_addr)
+KVM_X86_OP_RET0(set_identity_map_addr)
+KVM_X86_OP_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
@@ -102,7 +102,7 @@ KVM_X86_OP_NULL(vcpu_unblocking)
 KVM_X86_OP_NULL(pi_update_irte)
 KVM_X86_OP_NULL(pi_start_assignment)
 KVM_X86_OP_NULL(apicv_post_state_restore)
-KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_RET0(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_NULL(set_hv_timer)
 KVM_X86_OP_NULL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
@@ -126,3 +126,4 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
+#undef KVM_X86_OP_RET0
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 61faeb57889c..e7e5bd9a984d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1540,6 +1540,7 @@ extern struct kvm_x86_ops kvm_x86_ops;
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
 #define KVM_X86_OP_NULL KVM_X86_OP
+#define KVM_X86_OP_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 static inline void kvm_ops_static_call_update(void)
@@ -1548,6 +1549,9 @@ static inline void kvm_ops_static_call_update(void)
 	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
 #define KVM_X86_OP(func) \
 	WARN_ON(!kvm_x86_ops.func); KVM_X86_OP_NULL(func)
+#define KVM_X86_OP_RET0(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
+			   (typeof(kvm_x86_ops.func)) __static_call_return0);
 #include <asm/kvm-x86-ops.h>
 }
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b49ee6f34fe7..c82457793fc8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -707,11 +707,6 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	return 0;
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
index ab50d73b1e2e..5f75f50b861c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3479,16 +3479,6 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
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
@@ -3863,11 +3853,6 @@ static int __init svm_check_processor_compat(void)
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
@@ -3890,11 +3875,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
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
@@ -4470,7 +4450,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
-	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
@@ -4542,10 +4521,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.load_eoi_exitmap = avic_load_eoi_exitmap,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
-	.set_tss_addr = svm_set_tss_addr,
-	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_mt_mask = svm_get_mt_mask,
-
 	.get_exit_info = svm_get_exit_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
@@ -4570,7 +4545,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.nested_ops = &svm_nested_ops,
 
 	.deliver_interrupt = svm_deliver_interrupt,
-	.dy_apicv_has_pending_interrupt = avic_dy_apicv_has_pending_interrupt,
 	.pi_update_irte = avic_pi_update_irte,
 	.setup_mce = svm_setup_mce,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a527cffd0a2b..2daca3dd128a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -129,6 +129,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
 				*(((struct kvm_x86_ops *)0)->func));
 #define KVM_X86_OP_NULL KVM_X86_OP
+#define KVM_X86_OP_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
@@ -12057,7 +12058,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	return (is_guest_mode(vcpu) &&
-			kvm_x86_ops.guest_apic_has_interrupt &&
 			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
 }
 
-- 
2.31.1

