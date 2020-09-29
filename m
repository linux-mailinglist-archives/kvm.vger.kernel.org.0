Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBA227D232
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731389AbgI2PKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 11:10:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729881AbgI2PKK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 11:10:10 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601392207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f/uU3U+x9LIWXQcmC4v7SrioQYfC8JwG40W6R74JAF8=;
        b=dHTYf6c6ZMVp1LDT5b+QzoOI153fM26WKxLhxLMPFRLSJHnRcZh5QmDB7fOR/P9SDQj4n4
        fqVVaFw++XxKNjhVs6mr8JzRcJCMxewPil/6IvIfEmUYXl5ZRrDCpqXwZyiL0Mll++ZIF1
        Mcv8DDbX03+ClQNqCk/htLUMp1qvTUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-xJWIlXQIPU6wQ2lZf1cLJA-1; Tue, 29 Sep 2020 11:10:04 -0400
X-MC-Unique: xJWIlXQIPU6wQ2lZf1cLJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DE131084D67;
        Tue, 29 Sep 2020 15:09:51 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CF6D81C40;
        Tue, 29 Sep 2020 15:09:47 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl
Date:   Tue, 29 Sep 2020 17:09:43 +0200
Message-Id: <20200929150944.1235688-2-vkuznets@redhat.com>
In-Reply-To: <20200929150944.1235688-1-vkuznets@redhat.com>
References: <20200929150944.1235688-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_GET_SUPPORTED_HV_CPUID is a vCPU ioctl but its output is now
independent from vCPU and in some cases VMMs may want to use it as a system
ioctl instead. In particular, QEMU doesn CPU feature expansion before any
vCPU gets created so KVM_GET_SUPPORTED_HV_CPUID can't be used.

Convert KVM_GET_SUPPORTED_HV_CPUID to 'dual' system/vCPU ioctl with the
same meaning.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst | 16 ++++++++----
 arch/x86/kvm/hyperv.c          |  6 ++---
 arch/x86/kvm/hyperv.h          |  4 +--
 arch/x86/kvm/vmx/evmcs.c       |  3 +--
 arch/x86/kvm/x86.c             | 45 ++++++++++++++++++++--------------
 include/uapi/linux/kvm.h       |  3 ++-
 6 files changed, 46 insertions(+), 31 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 425325ff4434..d79f496875ea 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4455,9 +4455,9 @@ that KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is present.
 4.118 KVM_GET_SUPPORTED_HV_CPUID
 --------------------------------
 
-:Capability: KVM_CAP_HYPERV_CPUID
+:Capability: KVM_CAP_HYPERV_CPUID (vcpu), KVM_CAP_SYS_HYPERV_CPUID (system)
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: system ioctl, vcpu ioctl
 :Parameters: struct kvm_cpuid2 (in/out)
 :Returns: 0 on success, -1 on error
 
@@ -4502,9 +4502,6 @@ Currently, the following list of CPUID leaves are returned:
  - HYPERV_CPUID_SYNDBG_INTERFACE
  - HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES
 
-HYPERV_CPUID_NESTED_FEATURES leaf is only exposed when Enlightened VMCS was
-enabled on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
-
 Userspace invokes KVM_GET_SUPPORTED_HV_CPUID by passing a kvm_cpuid2 structure
 with the 'nent' field indicating the number of entries in the variable-size
 array 'entries'.  If the number of entries is too low to describe all Hyper-V
@@ -4515,6 +4512,15 @@ number of valid entries in the 'entries' array, which is then filled.
 'index' and 'flags' fields in 'struct kvm_cpuid_entry2' are currently reserved,
 userspace should not expect to get any particular value there.
 
+Note, vcpu version of KVM_GET_SUPPORTED_HV_CPUID is currently deprecated. Unlike
+system ioctl which exposes all supported feature bits unconditionally, vcpu
+version has the following quirks:
+- HYPERV_CPUID_NESTED_FEATURES leaf and HV_X64_ENLIGHTENED_VMCS_RECOMMENDED
+  feature bit are only exposed when Enlightened VMCS was previously enabled
+  on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
+- HV_STIMER_DIRECT_MODE_AVAILABLE bit is only exposed with in-kernel LAPIC.
+  (presumes KVM_CREATE_IRQCHIP has already been called).
+
 4.119 KVM_ARM_VCPU_FINALIZE
 ---------------------------
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 67a4f60a89b5..532aa259e7a3 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1951,8 +1951,8 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
 	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
 }
 
-int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-				struct kvm_cpuid_entry2 __user *entries)
+int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
+		     struct kvm_cpuid_entry2 __user *entries)
 {
 	uint16_t evmcs_ver = 0;
 	struct kvm_cpuid_entry2 cpuid_entries[] = {
@@ -2037,7 +2037,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			 * Direct Synthetic timers only make sense with in-kernel
 			 * LAPIC
 			 */
-			if (lapic_in_kernel(vcpu))
+			if (!vcpu || lapic_in_kernel(vcpu))
 				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 
 			break;
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index e68c6c2e9649..6d7def2b0aad 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -126,7 +126,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
 void kvm_hv_init_vm(struct kvm *kvm);
 void kvm_hv_destroy_vm(struct kvm *kvm);
 int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
-int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
-				struct kvm_cpuid_entry2 __user *entries);
+int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
+		     struct kvm_cpuid_entry2 __user *entries);
 
 #endif
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index e5325bd0f304..220301577fea 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -327,7 +327,6 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa)
 
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	/*
 	 * vmcs_version represents the range of supported Enlightened VMCS
 	 * versions: lower 8 bits is the minimal version, higher 8 bits is the
@@ -335,7 +334,7 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	 * KVM_EVMCS_VERSION.
 	 */
 	if (kvm_cpu_cap_get(X86_FEATURE_VMX) &&
-	    vmx->nested.enlightened_vmcs_enabled)
+	    (!vcpu || to_vmx(vcpu)->nested.enlightened_vmcs_enabled))
 		return (KVM_EVMCS_VERSION << 8) | 1;
 
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..6e517c023eb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3591,6 +3591,27 @@ static inline bool kvm_can_mwait_in_guest(void)
 		boot_cpu_has(X86_FEATURE_ARAT);
 }
 
+static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
+					    struct kvm_cpuid2 __user *cpuid_arg)
+{
+	struct kvm_cpuid2 cpuid;
+	int r;
+
+	r = -EFAULT;
+	if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
+		return r;
+
+	r = kvm_get_hv_cpuid(vcpu, &cpuid, cpuid_arg->entries);
+	if (r)
+		return r;
+
+	r = -EFAULT;
+	if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
+		return r;
+
+	return 0;
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -3627,6 +3648,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_HYPERV_TLBFLUSH:
 	case KVM_CAP_HYPERV_SEND_IPI:
 	case KVM_CAP_HYPERV_CPUID:
+	case KVM_CAP_SYS_HYPERV_CPUID:
 	case KVM_CAP_PCI_SEGMENT:
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
@@ -3811,6 +3833,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	case KVM_GET_MSRS:
 		r = msr_io(NULL, argp, do_get_msr_feature, 1);
 		break;
+	case KVM_GET_SUPPORTED_HV_CPUID:
+		r = kvm_ioctl_get_supported_hv_cpuid(NULL, argp);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -4880,25 +4905,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
-	case KVM_GET_SUPPORTED_HV_CPUID: {
-		struct kvm_cpuid2 __user *cpuid_arg = argp;
-		struct kvm_cpuid2 cpuid;
-
-		r = -EFAULT;
-		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
-			goto out;
-
-		r = kvm_vcpu_ioctl_get_hv_cpuid(vcpu, &cpuid,
-						cpuid_arg->entries);
-		if (r)
-			goto out;
-
-		r = -EFAULT;
-		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
-			goto out;
-		r = 0;
+	case KVM_GET_SUPPORTED_HV_CPUID:
+		r = kvm_ioctl_get_supported_hv_cpuid(vcpu, argp);
 		break;
-	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 58f43aa1fc21..415eb290bcf7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1052,6 +1052,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_STEAL_TIME 187
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
+#define KVM_CAP_SYS_HYPERV_CPUID 190
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1510,7 +1511,7 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
 
-/* Available with KVM_CAP_HYPERV_CPUID */
+/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
 
 /* Available with KVM_CAP_ARM_SVE */
-- 
2.25.4

