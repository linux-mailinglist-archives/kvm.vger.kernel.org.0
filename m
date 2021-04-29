Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4AF36E907
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 12:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbhD2KsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 06:48:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240469AbhD2KsB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 06:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619693235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/PX0WeAlS70FLjOp8WzYfhsjXzW9oamybcuRYPYrhU=;
        b=Ru+q0BKKh8rZ7T0KXZmlswktZIW1foO2NSptF5/woiwf/ieRiFl8LCDo5wsi1AqTLV3CZp
        mVwBNp5WPJBTw8XItya7YM0Q2Vm2iju3a97tYfFwPaMhESkUUY9PlYA51ZmKtD+S/Es88d
        Sy0U75NL3KfYuzeA68cnnTKMXywnaU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-XOGKQh5NOmmNqPfjtR2TVw-1; Thu, 29 Apr 2021 06:47:11 -0400
X-MC-Unique: XOGKQh5NOmmNqPfjtR2TVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A47938042A1;
        Thu, 29 Apr 2021 10:47:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0357F4EC68;
        Thu, 29 Apr 2021 10:47:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     srutherford@google.com, seanjc@google.com, joro@8bytes.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com,
        ashish.kalra@amd.com
Subject: [PATCH v3 1/2] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
Date:   Thu, 29 Apr 2021 06:47:06 -0400
Message-Id: <20210429104707.203055-2-pbonzini@redhat.com>
In-Reply-To: <20210429104707.203055-1-pbonzini@redhat.com>
References: <20210429104707.203055-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new MSR that can be used to communicate whether the page
encryption status bitmap is up to date and therefore whether live
migration of an encrypted guest is possible.

The MSR should be processed by userspace if it is going to live
migrate the guest; the default implementation does nothing.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     |  3 +++
 Documentation/virt/kvm/msr.rst       |  9 +++++++++
 arch/x86/include/asm/kvm-x86-ops.h   |  1 +
 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/svm/svm.c               |  1 +
 arch/x86/kvm/vmx/vmx.c               |  7 +++++++
 arch/x86/kvm/x86.c                   | 14 ++++++++++++++
 9 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index cf62162d4be2..c53d7e2b8ff4 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -96,6 +96,9 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
                                                before using extended destination
                                                ID bits in MSI address bits 11-5.
 
+KVM_FEATURE_MIGRATION_CONTROL      16          guest checks this feature bit before
+                                               using MSR_KVM_MIGRATION_CONTROL
+
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                                per-cpu warps are expected in
                                                kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..57fc4090031a 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -376,3 +376,12 @@ data:
 	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
 	and check if there are more notifications pending. The MSR is available
 	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
+
+MSR_KVM_MIGRATION_CONTROL:
+        0x4b564d08
+
+data:
+        This MSR is available if KVM_FEATURE_MIGRATION_CONTROL is present in
+        CPUID.  Bit 0 represents whether live migration of the guest is allowed.
+        When a guest is started, bit 0 will be 1 if the guest has encrypted
+        memory and 0 if the guest does not have encrypted memory.
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 323641097f63..5b19abc1b86f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -111,6 +111,7 @@ KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_NULL(mem_enc_op)
 KVM_X86_OP_NULL(mem_enc_reg_region)
 KVM_X86_OP_NULL(mem_enc_unreg_region)
+KVM_X86_OP(has_encrypted_memory)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad22d4839bcc..5491fc617451 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1364,6 +1364,7 @@ struct kvm_x86_ops {
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
+	bool (*has_encrypted_memory)(struct kvm *kvm);
 	int (*mem_enc_op)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 950afebfba88..21390fccfb90 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_MIGRATION_CONTROL	16
 
 #define KVM_HINTS_REALTIME      0
 
@@ -54,6 +55,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -90,6 +92,8 @@ struct kvm_clock_pairing {
 /* MSR_KVM_ASYNC_PF_INT */
 #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
 
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_MIGRATION_READY		(1 << 0)
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e9d644147bf5..f765bf7a529c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -892,7 +892,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_MIGRATION_CONTROL);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a7271f31df47..e75bfbf3e65a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4591,6 +4591,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.pre_leave_smm = svm_pre_leave_smm,
 	.enable_smi_window = svm_enable_smi_window,
 
+	.has_encrypted_memory = sev_guest,
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10b610fc7bbc..54843fbc12f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7670,6 +7670,11 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static bool vmx_has_encrypted_memory(struct kvm *kvm)
+{
+	return false;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -7800,6 +7805,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.has_encrypted_memory = vmx_has_encrypted_memory,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf3b67679cf0..e9c40be9235c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3275,6 +3275,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
+			return 1;
+
+		if (data != !static_call(kvm_x86_has_encrypted_memory)(vcpu->kvm))
+			return 1;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3568,6 +3576,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = 0;
 		break;
+	case MSR_KVM_MIGRATION_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
+			return 1;
+
+		msr_info->data = !static_call(kvm_x86_has_encrypted_memory)(vcpu->kvm);
+		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
 			return 1;
-- 
2.26.2


