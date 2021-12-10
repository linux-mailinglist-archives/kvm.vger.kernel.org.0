Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A14701E0
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242231AbhLJNkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242239AbhLJNkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:40:05 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F439C061A32;
        Fri, 10 Dec 2021 05:36:30 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so6311422plg.2;
        Fri, 10 Dec 2021 05:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LoxJ8h/6mdbtB3YLjPwA8WpMej54qu8iLTjOBmd3ZGk=;
        b=V30dSYNye+3I2Yzg72RQXToWP95SXxrDeT8GDvpLxPqXCHtvTb6CZ2CW0RRu7rhOGG
         3eequQ6kz/lsgY9A/NvYbM3QvXxnZwIyGxqcAXLrkZ21H4eSVwsqvtrWTmD15LUlX0ph
         wAzezjBKGrSzczuSr9XXAVXTjRgKCdzX6bV7dAY0piCyQPl5mvruPPDZMs71VkNeeTZt
         3sTnvMWpTmkC3Qx0+UZEfJJkFoGtc54wcvaqsiQdZsdIBhlegTIwSi5vx+LBP+svsTzh
         kGEyJV7cjO3ro+E9AMqnlizbk+TVZuKsvE9hSC4beprYFMmPSvslMYlstf8wlNI9MlWs
         K5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LoxJ8h/6mdbtB3YLjPwA8WpMej54qu8iLTjOBmd3ZGk=;
        b=V+hsvtL5+q4lWEu7nFCykhYEhcB4nZ/7Upw1Xc9ssnkRcYPcDCvkPY3zKdC9DsjKBQ
         AOdTNLvFMO6rC0ggEVyxo0WLdYKKega+RrtcAI376AAA4fJJYhwJIL1fwhWK6QuCkJdi
         JQGSDIeOMyEZXxtjua7yQVL1rL09lWnwoSluUvZMbCmvMyioi5DIegvt0Bkry5FsFHDt
         cSEx69cSejxOVHDbw2xpIakP+MGk3KWepQX8IWxZtTJyhtYzsEh3sXGrSzuVUyFhph0T
         hrEJ5YY0Pw2IexRlK9+ZkZMVcanKhfj6P8SaMg/QXtaa2JLOr7jlMOHjgXORNqECenLe
         tumA==
X-Gm-Message-State: AOAM531rmHRRlf/ZPKKAhEo9+lRJgGsDTWtlbUpJbgy6u2dKB0jH9dTd
        MZIz9Kpd0uL1ucKyUXTJ+IM=
X-Google-Smtp-Source: ABdhPJwA+n8QWtJjLx4d2BciBbRDQD9KZi3xKuC5P8WvYHTONSI3Nivf6D03mNupflS2FW7UIojyKQ==
X-Received: by 2002:a17:902:9882:b0:143:91ca:ca6e with SMTP id s2-20020a170902988200b0014391caca6emr75769057plp.64.1639143389964;
        Fri, 10 Dec 2021 05:36:29 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:29 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 15/17] KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
Date:   Fri, 10 Dec 2021 21:35:23 +0800
Message-Id: <20211210133525.46465-16-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

The information obtained from the interface perf_get_x86_pmu_capability()
doesn't change, so an exported "struct x86_pmu_capability" is introduced
for all guests in the KVM, and it's initialized before hardware_setup().

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/cpuid.c         | 26 ++++++++------------------
 arch/x86/kvm/pmu.c           |  3 +++
 arch/x86/kvm/pmu.h           | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++---------
 arch/x86/kvm/x86.c           |  9 ++++-----
 5 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..ed1cbd408ef0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -763,33 +763,23 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 9:
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		struct x86_pmu_capability cap;
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
-		perf_get_x86_pmu_capability(&cap);
+		eax.split.version_id = kvm_pmu_cap.version;
+		eax.split.num_counters = kvm_pmu_cap.num_counters_gp;
+		eax.split.bit_width = kvm_pmu_cap.bit_width_gp;
+		eax.split.mask_length = kvm_pmu_cap.events_mask_len;
+		edx.split.num_counters_fixed = kvm_pmu_cap.num_counters_fixed;
+		edx.split.bit_width_fixed = kvm_pmu_cap.bit_width_fixed;
 
-		/*
-		 * Only support guest architectural pmu on a host
-		 * with architectural pmu.
-		 */
-		if (!cap.version)
-			memset(&cap, 0, sizeof(cap));
-
-		eax.split.version_id = min(cap.version, 2);
-		eax.split.num_counters = cap.num_counters_gp;
-		eax.split.bit_width = cap.bit_width_gp;
-		eax.split.mask_length = cap.events_mask_len;
-
-		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
-		edx.split.bit_width_fixed = cap.bit_width_fixed;
-		if (cap.version)
+		if (kvm_pmu_cap.version)
 			edx.split.anythread_deprecated = 1;
 		edx.split.reserved1 = 0;
 		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
-		entry->ebx = cap.events_mask;
+		entry->ebx = kvm_pmu_cap.events_mask;
 		entry->ecx = 0;
 		entry->edx = edx.full;
 		break;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 179b0b6af3b2..0fb222fe1b1d 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,6 +19,9 @@
 #include "lapic.h"
 #include "pmu.h"
 
+struct x86_pmu_capability __read_mostly kvm_pmu_cap;
+EXPORT_SYMBOL_GPL(kvm_pmu_cap);
+
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 3ad0f3901352..92b23ac0fbc0 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -158,6 +158,24 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+extern struct x86_pmu_capability kvm_pmu_cap;
+
+static inline void kvm_init_pmu_capability(void)
+{
+	perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+	/*
+	 * Only support guest architectural pmu on
+	 * a host with architectural pmu.
+	 */
+	if (!kvm_pmu_cap.version)
+		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+
+	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
+					     MAX_FIXED_COUNTERS);
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
@@ -175,9 +193,11 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_init_pmu_capability(void);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
+
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3bd53e6e93e3..26a6eee1a9f7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -506,8 +506,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
-
-	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
@@ -534,13 +532,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
-	perf_get_x86_pmu_capability(&x86_pmu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
-					 x86_pmu.num_counters_gp);
-	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
+					 kvm_pmu_cap.num_counters_gp);
+	eax.split.bit_width = min_t(int, eax.split.bit_width,
+				    kvm_pmu_cap.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
-	eax.split.mask_length = min_t(int, eax.split.mask_length, x86_pmu.events_mask_len);
+	eax.split.mask_length = min_t(int, eax.split.mask_length,
+				      kvm_pmu_cap.events_mask_len);
 	pmu->available_event_types = ~entry->ebx &
 					((1ull << eax.split.mask_length) - 1);
 
@@ -549,9 +548,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	} else {
 		pmu->nr_arch_fixed_counters =
 			min_t(int, edx.split.num_counters_fixed,
-			      x86_pmu.num_counters_fixed);
-		edx.split.bit_width_fixed = min_t(int,
-			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
+			      kvm_pmu_cap.num_counters_fixed);
+		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
+						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 		setup_fixed_pmc_eventsel(pmu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7201762c1b1..4557a667b09b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6383,15 +6383,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 static void kvm_init_msr_list(void)
 {
-	struct x86_pmu_capability x86_pmu;
 	u32 dummy[2];
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
 			 "Please update the fixed PMCs in msrs_to_saved_all[]");
 
-	perf_get_x86_pmu_capability(&x86_pmu);
-
 	num_msrs_to_save = 0;
 	num_emulated_msrs = 0;
 	num_msr_based_features = 0;
@@ -6443,12 +6440,12 @@ static void kvm_init_msr_list(void)
 			break;
 		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
 		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
 			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
+			    min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
 				continue;
 			break;
 		default:
@@ -11331,6 +11328,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	kvm_init_pmu_capability();
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		return r;
-- 
2.33.1

