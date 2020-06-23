Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABAD204A06
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 08:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgFWGgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 02:36:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:5416 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730540AbgFWGgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 02:36:47 -0400
IronPort-SDR: nsmTi8ocRiUWvXLoPH8IMlCJmhc1CUCkBdAz69f7SSeVRvbX312vZC0lpgb7DocI0FC7GYQh3N
 PZK0a168hk9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="143043212"
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="143043212"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 23:36:42 -0700
IronPort-SDR: tX/2AxVwRB59zBI8qq+V05rF3uOKO4vT9Qt+z5oG4lsarvbMhj1J34QrUC3Nhu+0UsMxtUsklG
 Rbcl5daCwLQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="scan'208";a="478750232"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jun 2020 23:36:38 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.huang2@amd.com,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Li RongQing <lirongqing@baidu.com>,
        Chai Wen <chaiwen@baidu.com>, Jia Lina <jialina01@baidu.com>
Subject: [PATCH] KVM: X86: Emulate APERF/MPERF to report actual VCPU frequency
Date:   Tue, 23 Jun 2020 14:35:30 +0800
Message-Id: <20200623063530.81917-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The aperf/mperf are used to report current CPU frequency after 7d5905dc14a
"x86 / CPU: Always show current CPU frequency in /proc/cpuinfo". But guest
kernel always reports a fixed VCPU frequency in the /proc/cpuinfo, which
may confuse users especially when turbo is enabled on the host.

Emulate guest APERF/MPERF capability based their values on the host.

Co-developed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Chai Wen <chaiwen@baidu.com>
Reviewed-by: Jia Lina <jialina01@baidu.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 12 ++++++
 arch/x86/kvm/cpuid.c            |  8 +++-
 arch/x86/kvm/x86.c              | 76 ++++++++++++++++++++++++++++++++-
 3 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f852ee350beb..c48b9a0a086e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -539,6 +539,16 @@ struct kvm_vcpu_hv_stimer {
 	bool msg_pending;
 };
 
+/* vCPU thermal and power context */
+struct kvm_vcpu_hwp {
+	/* Hardware Coordination Feedback Capability (Presence of APERF/MPERF) */
+	bool hw_coord_fb_cap;
+	/* MPERF increases with a fixed frequency */
+	u64 mperf;
+	/* APERF increases with the current/actual frequency */
+	u64 aperf;
+};
+
 /* Hyper-V synthetic interrupt controller (SynIC)*/
 struct kvm_vcpu_hv_synic {
 	u64 version;
@@ -829,6 +839,8 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	struct kvm_vcpu_hwp hwp;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8a294f9747aa..7057809e7cfd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -78,6 +78,11 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
 	}
 
+	best = kvm_find_cpuid_entry(vcpu, 0x6, 0);
+	if (best && best->function == 0x6 &&
+	    boot_cpu_has(X86_FEATURE_APERFMPERF) && (best->ecx & 0x1))
+		vcpu->arch.hwp.hw_coord_fb_cap = true;
+
 	best = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
@@ -561,7 +566,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 6: /* Thermal management */
 		entry->eax = 0x4; /* allow ARAT */
 		entry->ebx = 0;
-		entry->ecx = 0;
+		/* allow aperf/mperf to report the true VCPU frequency. */
+		entry->ecx = boot_cpu_has(X86_FEATURE_APERFMPERF) ? 0x1 : 0;
 		entry->edx = 0;
 		break;
 	/* function 7 has additional index. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..d220d9cc904a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3056,6 +3056,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
+	case MSR_IA32_MPERF:
+		if (!msr_info->host_initiated && !vcpu->arch.hwp.hw_coord_fb_cap)
+			return 1;
+		vcpu->arch.hwp.mperf = 0;
+		return 0;
+	case MSR_IA32_APERF:
+		if (!msr_info->host_initiated && !vcpu->arch.hwp.hw_coord_fb_cap)
+			return 1;
+		vcpu->arch.hwp.aperf = 0;
+		return 0;
 	default:
 		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
 			return xen_hvm_config(vcpu, data);
@@ -3323,6 +3333,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_HWCR:
 		msr_info->data = vcpu->arch.msr_hwcr;
 		break;
+	case MSR_IA32_MPERF:
+		if (!msr_info->host_initiated && !vcpu->arch.hwp.hw_coord_fb_cap)
+			return 1;
+		msr_info->data = vcpu->arch.hwp.mperf;
+		break;
+	case MSR_IA32_APERF:
+		if (!msr_info->host_initiated && !vcpu->arch.hwp.hw_coord_fb_cap)
+			return 1;
+		msr_info->data = vcpu->arch.hwp.aperf;
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -8300,6 +8320,50 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+static inline void get_host_amperf(u64 *mperf, u64 *aperf)
+{
+	rdmsrl(MSR_IA32_MPERF, *mperf);
+	rdmsrl(MSR_IA32_APERF, *aperf);
+}
+
+static inline u64 get_amperf_delta(u64 enter, u64 exit)
+{
+	return (exit >= enter) ? (exit - enter) : (ULONG_MAX - enter + exit);
+}
+
+static inline void vcpu_update_amperf(struct kvm_vcpu *vcpu, u64 adelta, u64 mdelta)
+{
+	u64 aperf_left, mperf_left, delta, tmp;
+
+	aperf_left = ULONG_MAX - vcpu->arch.hwp.aperf;
+	mperf_left = ULONG_MAX - vcpu->arch.hwp.mperf;
+
+	/* fast path when neither MSR overflows */
+	if (adelta <= aperf_left && mdelta <= mperf_left) {
+		vcpu->arch.hwp.aperf += adelta;
+		vcpu->arch.hwp.mperf += mdelta;
+		return;
+	}
+
+	/* when either MSR overflows, both MSRs are reset to zero and continue to increment. */
+	delta = min(adelta, mdelta);
+	if (delta > aperf_left || delta > mperf_left) {
+		tmp = max(vcpu->arch.hwp.aperf, vcpu->arch.hwp.mperf);
+		tmp = delta - (ULONG_MAX - tmp) - 1;
+		vcpu->arch.hwp.aperf = tmp + adelta - delta;
+		vcpu->arch.hwp.mperf = tmp + mdelta - delta;
+		return;
+	}
+
+	if (mdelta > adelta && mdelta > aperf_left) {
+		vcpu->arch.hwp.mperf = mdelta - mperf_left - 1;
+		vcpu->arch.hwp.aperf = 0;
+	} else {
+		vcpu->arch.hwp.mperf = 0;
+		vcpu->arch.hwp.aperf = adelta - aperf_left - 1;
+	}
+}
+
 /*
  * Returns 1 to let vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -8312,7 +8376,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
-
+	u64 enter_mperf = 0, enter_aperf = 0, exit_mperf = 0, exit_aperf = 0;
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
@@ -8516,8 +8580,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
+	if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap))
+		get_host_amperf(&enter_mperf, &enter_aperf);
+
 	exit_fastpath = kvm_x86_ops.run(vcpu);
 
+	if (unlikely(vcpu->arch.hwp.hw_coord_fb_cap)) {
+		get_host_amperf(&exit_mperf, &exit_aperf);
+		vcpu_update_amperf(vcpu, get_amperf_delta(enter_aperf, exit_aperf),
+			get_amperf_delta(enter_mperf, exit_mperf));
+	}
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
@@ -9482,6 +9555,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
+	vcpu->arch.hwp.hw_coord_fb_cap = false;
 
 	kvm_hv_vcpu_init(vcpu);
 
-- 
2.21.3

