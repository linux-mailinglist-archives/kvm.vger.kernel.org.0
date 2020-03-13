Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DDB183F16
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 03:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCMCTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 22:19:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:25868 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbgCMCTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 22:19:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 19:19:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261743830"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 19:19:04 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Like Xu <like.xu@linux.intel.com>,
        linux-kernel@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>,
        Jann Horn <jannh@google.com>,
        Eric Hankland <ehankland@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v9 05/10] KVM: x86: Add KVM_CAP_X86_GUEST_LBR interface to dis/enable LBR feature
Date:   Fri, 13 Mar 2020 10:16:11 +0800
Message-Id: <20200313021616.112322-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200313021616.112322-1-like.xu@linux.intel.com>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LBR feature is model specific. Introduce KVM_CAP_X86_GUEST_LBR to
allow per-VM enabling of the guest LBR feature.

For enable_cap ioctl, the first input parameter is whether LBR feature
should be enabled or not, and the second parameter is the pointer to the
userspace memory to read the LBR stack information. If the second parameter
is invalid or the guest/host cpu model doesn't match, it returns -EINVAL
which means the LBR feature cannot be enabled. For check_extension ioctl,
the return value could help userspace calculate the total size of the
complete guest LBR entries and do functional compatibility check.

Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Jann Horn <jannh@google.com>
Cc: Eric Hankland <ehankland@google.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Co-developed-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 Documentation/virt/kvm/api.rst  | 28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              |  8 ++++++++
 arch/x86/kvm/pmu.h              |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c    | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 13 +++++++++++++
 include/uapi/linux/kvm.h        |  1 +
 tools/include/uapi/linux/kvm.h  |  1 +
 8 files changed, 84 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0adef66585b1..6d3f4d620f9e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5743,6 +5743,34 @@ it hard or impossible to use it correctly.  The availability of
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
 Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
 
+7.19 KVM_CAP_X86_GUEST_LBR
+Architectures: x86
+Parameters: args[0] whether LBR feature should be enabled or not
+            args[1] pointer to the userspace memory to load the LBR stack info
+
+the LBR stack information is described by
+struct x86_pmu_lbr {
+	unsigned int	nr;
+	unsigned int	from;
+	unsigned int	to;
+	unsigned int	info;
+};
+
+@nr: number of LBR stack entries
+@from: index of the msr that stores a branch source address
+@to: index of the msr that stores a branch destination address
+@info: index of the msr that stores LBR related flags, such as misprediction
+
+Enabling this capability allows guest accesses to the LBR feature. Otherwise,
+#GP will be injected to the guest when it accesses to the LBR related msrs.
+
+After the feature is enabled, before exiting to userspace, kvm handlers
+would fill the LBR stack info into the userspace memory pointed by args[1].
+
+The return value of kvm_vm_ioctl_check_extension for KVM_CAP_X86_GUEST_LBR
+is the size of 'struct x86_pmu_lbr' and userspace could calculate the total
+size of the complete guest LBR entries for functional compatibility check.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ac67b6d6692..b87d2ab28b0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -933,6 +933,7 @@ struct kvm_arch {
 	bool hlt_in_guest;
 	bool pause_in_guest;
 	bool cstate_in_guest;
+	bool lbr_in_guest;
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
@@ -982,6 +983,7 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
+	struct x86_pmu_lbr lbr_stack;
 	struct task_struct *nx_lpage_recovery_thread;
 };
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d1f8ca57d354..970fb5574402 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -518,3 +518,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+bool kvm_pmu_lbr_setup(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops->pmu_ops->lbr_setup)
+		return kvm_x86_ops->pmu_ops->lbr_setup(vcpu);
+
+	return false;
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index d7da2b9e0755..4842a417afe9 100644
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
index e933541751fb..4f529e1de5d2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -397,6 +397,34 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmu->global_ovf_ctrl = 0;
 }
 
+static bool intel_pmu_get_lbr_stack(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (likely(kvm->arch.lbr_stack.nr))
+		return true;
+
+	return !x86_perf_get_lbr(&kvm->arch.lbr_stack);
+}
+
+static bool intel_pmu_setup_lbr(struct kvm_vcpu *vcpu)
+{
+	if (!intel_pmu_get_lbr_stack(vcpu))
+		return false;
+
+	if (vcpu_to_pmu(vcpu)->version < 2)
+		return false;
+
+	/*
+	 * As a first step, a guest could only enable LBR feature if its cpu
+	 * model is the same as the host since LBR is model-specific for now.
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
@@ -411,4 +439,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
 	.refresh = intel_pmu_refresh,
 	.init = intel_pmu_init,
 	.reset = intel_pmu_reset,
+	.lbr_setup = intel_pmu_setup_lbr,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a69f7bf020d9..51c62d14809a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3357,6 +3357,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 		r = 1;
 		break;
+	case KVM_CAP_X86_GUEST_LBR:
+		r = sizeof(struct x86_pmu_lbr);
+		break;
 	case KVM_CAP_SYNC_REGS:
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
@@ -4866,6 +4869,16 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_GUEST_LBR:
+		r = -EINVAL;
+		if (cap->args[0] && !kvm_pmu_lbr_setup(kvm->vcpus[0]))
+			break;
+		if (copy_to_user((void __user *)cap->args[1],
+			&kvm->arch.lbr_stack, sizeof(struct x86_pmu_lbr)))
+			break;
+		kvm->arch.lbr_in_guest = cap->args[0];
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d8499d935954..721510b2789a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1010,6 +1010,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
 #define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_X86_GUEST_LBR 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f0a16b4adbbd..3c094ca5bef4 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1009,6 +1009,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
 #define KVM_CAP_ARM_NISV_TO_USER 177
 #define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_X86_GUEST_LBR 180
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.21.1

