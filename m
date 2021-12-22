Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF71C47D310
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 14:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245362AbhLVNel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 08:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbhLVNel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 08:34:41 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E301C061574;
        Wed, 22 Dec 2021 05:34:41 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m1so2380600pfk.8;
        Wed, 22 Dec 2021 05:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vwEPaRLgVEFX9cvucCEeB2RrI8G7Orc4VRY+V8vKAnY=;
        b=qnMdGnHjhrNhHXIxkOVCiD6R6SWlFLtqhmA08DK24tiOVsfwgDiMnGiooZZvnoIm58
         xRaS8xjMSDg8U/QHYs7RfR57+Inyq6TXock3msyDwWg475i5ayWRYOAgVwJiUYcCARXE
         r3C4XFiPIvw6BOqhjvoFICYWbVr25a1WgyWykZhiBbypHP5tdnyHmSy0Ci2aNbTQhcaF
         DxdGNBkI4TRIK6AidpXnVHTeFO893z3+Jxz+o+EXGzaE8dAP4smQuIsdm6IXBzycx9s2
         4hJpIKt/6dJKECZIixHJ5sdqb2syUm2fH+w+xc3ClGZIpqAUvo0AN6LoLhfk3vwbXXiz
         npJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vwEPaRLgVEFX9cvucCEeB2RrI8G7Orc4VRY+V8vKAnY=;
        b=xGA/3QTzidWzyKxLGPKRy5A29gu//SeaEFTMQJFHDVAAPB6GesUGhm5co7rYTk/213
         NYP1dapOAlw6c54hqOnOMlM5UozGSfaXFTBLYP5Qkyt7n64QGmGqchLqKhPwwDDsPARR
         7moSwpi7UWBOMB5kxy2j1iUyZeTYjjjK83KmODGjY5hSywV8GbH9TL0kH4hh6DYecQOK
         fIi/6Zd0vgar66dBfyFOl2fPnXgRaK6juGx5PWs1zBScuxeGD6ZQkkYuyhWryXWS2lKe
         fHDJQcy0gZpko05eQbFd7DPymUVu8HY86huFl2AxRk5zglir22rWoCVkUIJr2b782tZQ
         ZOjw==
X-Gm-Message-State: AOAM531XSBI8qvBFc7+62V592lucxn18y0IloEoTkkctEu7E/1S6A4Bs
        L9lRYv6UBuXJPSXifyLuqbjCQlTehF0aYrEAfrk=
X-Google-Smtp-Source: ABdhPJy+BFyewt7K6QgIabk+QHX5Szpsx7um2RNEtU5sA3LjOLuQst3kYoAjZGpMBM/XxrHg7Ytp2A==
X-Received: by 2002:a63:4f53:: with SMTP id p19mr2744525pgl.534.1640180080544;
        Wed, 22 Dec 2021 05:34:40 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z23sm2646959pfr.189.2021.12.22.05.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 05:34:40 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v2] KVM: X86: Emulate APERF/MPERF to report actual vCPU frequency
Date:   Wed, 22 Dec 2021 21:34:28 +0800
Message-Id: <20211222133428.59977-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The aperf/mperf are used to report current CPU frequency after 7d5905dc14a.
But guest kernel always reports a fixed vCPU frequency in the /proc/cpuinfo,
which may confuse users especially when turbo is enabled on the host or
when the vCPU has a noisy high power consumption neighbour task.

Most guests such as Linux will only read accesses to AMPERF msrs, where
we can passthrough registers to the vcpu as the fast-path (a performance win)
and once any write accesses are trapped, the emulation will be switched to
slow-path, which emulates guest APERF/MPERF values based on host values.
In emulation mode, the returned MPERF msr value will be scaled according
to the TSCRatio value.

As a minimum effort, KVM exposes the AMPERF feature when the host TSC
has CONSTANT and NONSTOP features, to avoid the need for more code
to cover various coner cases coming from host power throttling transitions.

The slow path code reveals an opportunity to refactor update_vcpu_amperf()
and get_host_amperf() to be more flexible and generic, to cover more
power-related msrs.

Requested-by: Dongli Cao <caodongli@kingsoft.com>
Requested-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Use MSR_TYPE_R to passthrough as a fast path;
- Use [svm|vmx]_set_msr for emulation as a slow path;
- Interact MPERF with TSC scaling (Jim Mattson);
- Drop bool hw_coord_fb_cap with cpuid check;
- Add TSC CONSTANT and NONSTOP cpuid check;
- Duplicate static_call(kvm_x86_run) to make the branch predictor happier;

Previous:
https://lore.kernel.org/kvm/20200623063530.81917-1-like.xu@linux.intel.com/

 arch/x86/include/asm/kvm_host.h | 12 +++++
 arch/x86/kvm/cpuid.c            |  3 ++
 arch/x86/kvm/cpuid.h            | 22 +++++++++
 arch/x86/kvm/svm/svm.c          | 15 ++++++
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 18 ++++++-
 arch/x86/kvm/x86.c              | 85 ++++++++++++++++++++++++++++++++-
 7 files changed, 153 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ce622b89c5d8..1cad3992439e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -39,6 +39,8 @@
 
 #define KVM_MAX_VCPUS 1024
 
+#define KVM_MAX_NUM_HWP_MSR 2
+
 /*
  * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs
  * might be larger than the actual number of VCPUs because the
@@ -562,6 +564,14 @@ struct kvm_vcpu_hv_stimer {
 	bool msg_pending;
 };
 
+/* vCPU thermal and power context */
+struct kvm_vcpu_hwp {
+	bool fast_path;
+	/* [0], APERF msr, increases with the current/actual frequency */
+	/* [1], MPERF msr, increases with a fixed frequency */
+	u64 msrs[KVM_MAX_NUM_HWP_MSR];
+};
+
 /* Hyper-V synthetic interrupt controller (SynIC)*/
 struct kvm_vcpu_hv_synic {
 	u64 version;
@@ -887,6 +897,8 @@ struct kvm_vcpu_arch {
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
 
+	struct kvm_vcpu_hwp hwp;
+
 	/* pv related cpuid info */
 	struct {
 		/*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..e20e5e8c2b3a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -739,6 +739,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = 0x4; /* allow ARAT */
 		entry->ebx = 0;
 		entry->ecx = 0;
+		/* allow aperf/mperf to report the true vCPU frequency. */
+		if (kvm_cpu_cap_has_amperf())
+			entry->ecx |=  (1 << 0);
 		entry->edx = 0;
 		break;
 	/* function 7 has additional index. */
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c99edfff7f82..741949b407b7 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -154,6 +154,28 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 	return x86_stepping(best->eax);
 }
 
+static inline bool kvm_cpu_cap_has_amperf(void)
+{
+	return boot_cpu_has(X86_FEATURE_APERFMPERF) &&
+		boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+		boot_cpu_has(X86_FEATURE_NONSTOP_TSC);
+}
+
+static inline bool guest_support_amperf(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	if (!kvm_cpu_cap_has_amperf())
+		return false;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x6, 0);
+	if (!best || !(best->ecx & 0x1))
+		return false;
+
+	best = kvm_find_cpuid_entry(vcpu, 0x80000007, 0);
+	return best && (best->edx & (1 << 8));
+}
+
 static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
 {
 	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5557867dcb69..2873c7f132bd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -114,6 +114,8 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
+	{ .index = MSR_IA32_MPERF,			.always = false },
+	{ .index = MSR_IA32_APERF,			.always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -1218,6 +1220,12 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		/* No need to intercept these MSRs */
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
+
+		if (guest_support_amperf(vcpu)) {
+			set_msr_interception(vcpu, svm->msrpm, MSR_IA32_MPERF, 1, 0);
+			set_msr_interception(vcpu, svm->msrpm, MSR_IA32_APERF, 1, 0);
+			vcpu->arch.hwp.fast_path = true;
+		}
 	}
 }
 
@@ -3078,6 +3086,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	case MSR_IA32_APERF:
+	case MSR_IA32_MPERF:
+		if (vcpu->arch.hwp.fast_path) {
+			set_msr_interception(vcpu, svm->msrpm, MSR_IA32_MPERF, 0, 0);
+			set_msr_interception(vcpu, svm->msrpm, MSR_IA32_APERF, 0, 0);
+		}
+		return kvm_set_msr_common(vcpu, msr);
 	default:
 		return kvm_set_msr_common(vcpu, msr);
 	}
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9f153c59f2c8..ad4659811620 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -27,7 +27,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	20
+#define MAX_DIRECT_ACCESS_MSRS	22
 #define MSRPM_OFFSETS	16
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1d53b8144f83..8998042107d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -576,6 +576,9 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
+	case MSR_IA32_MPERF:
+	case MSR_IA32_APERF:
+		/* AMPERF MSRs. These are passthrough when all access is read-only. */
 		return true;
 	}
 
@@ -2224,7 +2227,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
-
+	case MSR_IA32_APERF:
+	case MSR_IA32_MPERF:
+		if (vcpu->arch.hwp.fast_path) {
+			vmx_set_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_RW, true);
+			vmx_set_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_RW, true);
+		}
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -6928,6 +6938,12 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
 
+	if (guest_support_amperf(vcpu)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
+		vcpu->arch.hwp.fast_path = true;
+	}
+
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42bde45a1bc2..7a6355815493 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1376,6 +1376,8 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
+	MSR_IA32_APERF, MSR_IA32_MPERF,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -3685,6 +3687,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.msr_misc_features_enables = data;
 		break;
+	case MSR_IA32_APERF:
+	case MSR_IA32_MPERF:
+		/* Ignore meaningless value overrides from user space.*/
+		if (msr_info->host_initiated)
+			return 0;
+		if (!guest_support_amperf(vcpu))
+			return 1;
+		vcpu->arch.hwp.msrs[MSR_IA32_APERF - msr] = data;
+		vcpu->arch.hwp.fast_path = false;
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -4005,6 +4017,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_HWCR:
 		msr_info->data = vcpu->arch.msr_hwcr;
 		break;
+	case MSR_IA32_APERF:
+	case MSR_IA32_MPERF: {
+		u64 value;
+
+		if (!msr_info->host_initiated && !guest_support_amperf(vcpu))
+			return 1;
+		value = vcpu->arch.hwp.msrs[MSR_IA32_APERF - msr_info->index];
+		msr_info->data = (msr_info->index == MSR_IA32_APERF) ? value :
+			kvm_scale_tsc(vcpu, value, vcpu->arch.tsc_scaling_ratio);
+		break;
+	}
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
@@ -9688,6 +9711,53 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+static inline void get_host_amperf(u64 msrs[])
+{
+	rdmsrl(MSR_IA32_APERF, msrs[0]);
+	rdmsrl(MSR_IA32_MPERF, msrs[1]);
+}
+
+static inline u64 get_amperf_delta(u64 enter, u64 exit)
+{
+	if (likely(exit >= enter))
+		return exit - enter;
+
+	return ULONG_MAX - enter + exit;
+}
+
+static inline void update_vcpu_amperf(struct kvm_vcpu *vcpu, u64 adelta, u64 mdelta)
+{
+	u64 aperf_left, mperf_left, delta, tmp;
+
+	aperf_left = ULONG_MAX - vcpu->arch.hwp.msrs[0];
+	mperf_left = ULONG_MAX - vcpu->arch.hwp.msrs[1];
+
+	/* Fast path when neither MSR overflows */
+	if (adelta <= aperf_left && mdelta <= mperf_left) {
+		vcpu->arch.hwp.msrs[0] += adelta;
+		vcpu->arch.hwp.msrs[1] += mdelta;
+		return;
+	}
+
+	/* When either MSR overflows, both MSRs are reset to zero and continue to increment. */
+	delta = min(adelta, mdelta);
+	if (delta > aperf_left || delta > mperf_left) {
+		tmp = max(vcpu->arch.hwp.msrs[0], vcpu->arch.hwp.msrs[1]);
+		tmp = delta - (ULONG_MAX - tmp) - 1;
+		vcpu->arch.hwp.msrs[0] = tmp + adelta - delta;
+		vcpu->arch.hwp.msrs[1] = tmp + mdelta - delta;
+		return;
+	}
+
+	if (mdelta > adelta && mdelta > aperf_left) {
+		vcpu->arch.hwp.msrs[0] = 0;
+		vcpu->arch.hwp.msrs[1] = mdelta - mperf_left - 1;
+	} else {
+		vcpu->arch.hwp.msrs[0] = adelta - aperf_left - 1;
+		vcpu->arch.hwp.msrs[1] = 0;
+	}
+}
+
 /*
  * Returns 1 to let vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -9700,7 +9770,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
-
+	u64 before[2], after[2];
 	bool req_immediate_exit = false;
 
 	/* Forbid vmenter if vcpu dirty ring is soft-full */
@@ -9942,7 +10012,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
 
-		exit_fastpath = static_call(kvm_x86_run)(vcpu);
+		if (likely(vcpu->arch.hwp.fast_path)) {
+			exit_fastpath = static_call(kvm_x86_run)(vcpu);
+		} else {
+			get_host_amperf(before);
+			exit_fastpath = static_call(kvm_x86_run)(vcpu);
+			get_host_amperf(after);
+			update_vcpu_amperf(vcpu, get_amperf_delta(before[0], after[0]),
+					   get_amperf_delta(before[1], after[1]));
+		}
+
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -11138,6 +11217,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
 	}
 
+	memset(vcpu->arch.hwp.msrs, 0, sizeof(vcpu->arch.hwp.msrs));
+
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));
 	kvm_register_mark_dirty(vcpu, VCPU_REGS_RSP);
-- 
2.33.1

