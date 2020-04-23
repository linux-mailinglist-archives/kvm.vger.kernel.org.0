Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5A51B571F
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgDWIR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:17:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgDWIR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:17:56 -0400
IronPort-SDR: qOTfylekv5fXuQyADb4zg25ld+uVXmD+o4sQFbq6tgks8ANx4LjH7wpn3CZTGTxxotzKtde9WO
 qe2wi1bWiT9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:17:55 -0700
IronPort-SDR: gEu3Z0Puerp7hhMLH9HOl0g2BU2ctP67/JbxkKfllkdwo2dElKy090ueqUCvSPveY4qFCAjf0T
 eD8AX251qWuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910090"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:17:52 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v10 06/11] KVM: x86: Add KVM_CAP_X86_GUEST_LBR to dis/enable LBR from user-space
Date:   Thu, 23 Apr 2020 16:14:07 +0800
Message-Id: <20200423081412.164863-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR feature is model specific. Introduce KVM_CAP_X86_GUEST_LBR to
control per-VM enablement of the guest LBR feature (disabled by default).

For enable_cap ioctl, the first input parameter is whether LBR feature
should be enabled or not, and the second parameter is the pointer to
the userspace memory to save the LBR records information. If the
second parameter is invalid or the guest/host cpu model doesn't match,
it returns -EINVAL which means the LBR feature cannot be enabled.

For check_extension ioctl, the return value could help userspace calculate
the total size of the complete guest LBR entries for compatibility check.

Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 Documentation/virt/kvm/api.rst  | 28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              |  8 ++++++++
 arch/x86/kvm/pmu.h              |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 17 +++++++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 7 files changed, 89 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..14f8d98c2651 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5802,6 +5802,34 @@ If present, this capability can be enabled for a VM, meaning that KVM
 will allow the transition to secure guest mode.  Otherwise KVM will
 veto the transition.
 
+7.20 KVM_CAP_X86_GUEST_LBR
+Architectures: x86
+Parameters: args[0] whether LBR feature should be enabled or not,
+  args[1] pointer to the userspace memory to save the LBR records information.
+
+the LBR records information is described by
+struct x86_pmu_lbr {
+	unsigned int	nr;
+	unsigned int	from;
+	unsigned int	to;
+	unsigned int	info;
+};
+
+@nr: number of LBR records entries;
+@from: index of the msr that stores a branch source address;
+@to: index of the msr that stores a branch destination address;
+@info: index of the msr that stores LBR related flags, such as misprediction.
+
+Enabling this capability allows guest accesses to the LBR feature. Otherwise,
+#GP will be injected to the guest when it accesses to the LBR registers.
+
+After the feature is enabled, before exiting to userspace, kvm handlers
+would fill the LBR records info into the userspace memory pointed by args[1].
+
+The return value of kvm_vm_ioctl_check_extension for KVM_CAP_X86_GUEST_LBR
+is the size of 'struct x86_pmu_lbr' and userspace could calculate the total
+size of the complete guest LBR entries for functional compatibility check.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f26df2cb0591..3a4433607773 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -985,6 +985,8 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	bool lbr_in_guest;
+	struct x86_pmu_lbr lbr;
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
 };
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a5078841bdac..c1f95b2f9559 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -518,3 +518,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+bool kvm_pmu_lbr_setup(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops.pmu_ops->lbr_setup)
+		return kvm_x86_ops.pmu_ops->lbr_setup(vcpu);
+
+	return false;
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a6c78a797cb1..971da6431d74 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -37,6 +37,7 @@ struct kvm_pmu_ops {
 	void (*refresh)(struct kvm_vcpu *vcpu);
 	void (*init)(struct kvm_vcpu *vcpu);
 	void (*reset)(struct kvm_vcpu *vcpu);
+	bool (*lbr_setup)(struct kvm_vcpu *vcpu);
 };
 
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
@@ -155,6 +156,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+bool kvm_pmu_lbr_setup(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7c857737b438..4056bd114844 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -300,6 +300,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	vcpu->kvm->arch.lbr_in_guest = false;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -397,6 +398,35 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+static bool intel_pmu_get_lbr(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (likely(kvm->arch.lbr.nr))
+		return true;
+
+	return !x86_perf_get_lbr(&kvm->arch.lbr);
+}
+
+static bool intel_pmu_lbr_setup(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_to_pmu(vcpu)->version < 2)
+		return false;
+
+	if (!intel_pmu_get_lbr(vcpu))
+		return false;
+
+	/*
+	 * As a first step, a guest could only enable LBR feature if its cpu
+	 * model is the same as the host because the LBR registers would
+	 * be passthrough to the guest and they're model specific.
+	 */
+	if (boot_cpu_data.x86_model != guest_cpuid_model(vcpu))
+		return false;
+
+	return true;
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_arch_event = intel_find_arch_event,
 	.find_fixed_event = intel_find_fixed_event,
@@ -411,4 +441,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.lbr_setup = intel_pmu_lbr_setup,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59958ce2b681..b5ce89016eeb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3391,6 +3391,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 		r = 1;
 		break;
+	case KVM_CAP_X86_GUEST_LBR:
+		r = sizeof(struct x86_pmu_lbr);
+		break;
 	case KVM_CAP_SYNC_REGS:
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
@@ -4899,6 +4902,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_GUEST_LBR:
+		r = -EINVAL;
+		if (!cap->args[0] || !kvm->vcpus[0])
+			break;
+		if (!kvm_pmu_lbr_setup(kvm->vcpus[0]))
+			break;
+		if (vcpu_to_pmu(kvm->vcpus[0])->version < 2)
+			break;
+		if (copy_to_user((void __user *)cap->args[1],
+			&kvm->arch.lbr, sizeof(struct x86_pmu_lbr)))
+			break;
+		kvm->arch.lbr_in_guest = !!cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..083a3d206f16 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1017,6 +1017,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_VCPU_RESETS 179
 #define KVM_CAP_S390_PROTECTED 180
 #define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_X86_GUEST_LBR 182
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.21.1

