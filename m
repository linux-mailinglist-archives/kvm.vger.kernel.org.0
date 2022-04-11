Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13D44FB976
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345386AbiDKKYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345500AbiDKKWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:52 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EE24248D;
        Mon, 11 Apr 2022 03:20:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j8so13422630pll.11;
        Mon, 11 Apr 2022 03:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85XR1oy4LBkCtYH9ETAjkpw33nFLxwRRhDVxIMq/Cpw=;
        b=D75lqgrvLpIwVtC0BaqNj6LIztshHN0pEzpLA2x1w3J/tL462hd7G9T5b4Th11R7TL
         ZYa9suuRuI/waImK2xxacqfBTGMLn6OHp5sJ1YbcgxrFSO504aCZL6T7OBTx5mp9UwT1
         eS9DqhHRH1VnQzfFoyO/DS0GOgxl2fbWp3ouChgGzHSAgZR5C0rhQ0EMAI7/JGDIiagC
         nivL2g/Q76/JZI4kD6QbUaAnIpnZhOBUNRg3K0sTEaIfC9KgvHRGeQta8aCjAR9qZYrm
         9FKprtYr6FLIkGOzJDwUCjk5lKYIeMWuTPQVrl/Fvp/TXgwIbAsRT3U/+LEw5Uw5scmX
         8HMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85XR1oy4LBkCtYH9ETAjkpw33nFLxwRRhDVxIMq/Cpw=;
        b=5ILvwxcRi0D5Zinn+QZVXS6vtfCTQ+p9aFsI2ePf/dZsl8WJLVms3V3QA3v7b5wqJn
         Dq5XkWa+7AjqU3C3DPX5Dlwppdg25+giAebIz2o4vkcWqGWVMeO1eE7M/ghkgZlrgRaw
         VVWR0nu1HKNqUJr/AyPGUmoWsTtNmavHMNqsAXjNLsPXlrVDqNfsTUXqNyPpkEHgFXgT
         v3BCkaTJXxrf5RSHIC8K6dMciuMgYNuANyFWYmsh0a+dMQNzQn9d18VOaYL7D4/T81GH
         yZw71Ae7o2FkKaJ3jsSMvx9olZePT9dRMIjOF1HURuH89JTnq4nAYCJP+cFtJHGWz2Qx
         i+RQ==
X-Gm-Message-State: AOAM5336Cu3oty+YHESqwPaYisRDrmApyVJ4UMpnS//SR1lr5r/OP2MZ
        4dn6rCkFkXD5ut5+z8rl7AGT83xLJjE=
X-Google-Smtp-Source: ABdhPJzvvT+7M6KMXh/27FOqO29cwnm66IR4wrAUCVnjMgUV+utpupW/TnEGrJAzn/6EO/OOhmUNAg==
X-Received: by 2002:a17:902:714d:b0:156:6f38:3323 with SMTP id u13-20020a170902714d00b001566f383323mr31380994plm.173.1649672437977;
        Mon, 11 Apr 2022 03:20:37 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:37 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 15/17] KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
Date:   Mon, 11 Apr 2022 18:19:44 +0800
Message-Id: <20220411101946.20262-16-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The information obtained from the interface perf_get_x86_pmu_capability()
doesn't change, so an exported "struct x86_pmu_capability" is introduced
for all guests in the KVM, and it's initialized before hardware_setup().

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c         | 27 ++++++++-------------------
 arch/x86/kvm/pmu.c           |  3 +++
 arch/x86/kvm/pmu.h           | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++---------
 arch/x86/kvm/x86.c           |  9 ++++-----
 5 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b24ca7f4ed7c..8fbedae87f0e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -883,34 +883,23 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
-		 * The guest architecture pmu is only supported if the architecture
-		 * pmu exists on the host and the module parameters allow it.
-		 */
-		if (!cap.version || !enable_pmu)
-			memset(&cap, 0, sizeof(cap));
-
-		eax.split.version_id = min(cap.version, 2);
-		eax.split.num_counters = cap.num_counters_gp;
-		eax.split.bit_width = cap.bit_width_gp;
-		eax.split.mask_length = cap.events_mask_len;
-
-		edx.split.num_counters_fixed =
-			min(cap.num_counters_fixed, KVM_PMC_MAX_FIXED);
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
index 122e4bb4fa47..b5d0c36b869b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -24,6 +24,9 @@
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
+struct x86_pmu_capability __read_mostly kvm_pmu_cap;
+EXPORT_SYMBOL_GPL(kvm_pmu_cap);
+
 /* NOTE:
  * - Each perf counter is defined as "struct kvm_pmc";
  * - There are two types of perf counters: general purpose (gp) and fixed.
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b51f804737bd..dbf4c83519a4 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -154,6 +154,24 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
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
+					     KVM_PMC_MAX_FIXED);
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
@@ -172,6 +190,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
+void kvm_init_pmu_capability(void);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fc3b837448a3..f2c94e9dfa4b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -519,8 +519,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
-
-	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
@@ -548,13 +546,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
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
 
@@ -564,9 +563,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_fixed_counters =
 			min3(ARRAY_SIZE(fixed_pmc_events),
 			     (size_t) edx.split.num_counters_fixed,
-			     (size_t) x86_pmu.num_counters_fixed);
-		edx.split.bit_width_fixed = min_t(int,
-			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
+			     (size_t)kvm_pmu_cap.num_counters_fixed);
+		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
+						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 		setup_fixed_pmc_eventsel(pmu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1887b7146da6..8562debc14ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6645,15 +6645,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
 static void kvm_init_msr_list(void)
 {
-	struct x86_pmu_capability x86_pmu;
 	u32 dummy[2];
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
 			 "Please update the fixed PMCs in msrs_to_saved_all[]");
 
-	perf_get_x86_pmu_capability(&x86_pmu);
-
 	num_msrs_to_save = 0;
 	num_emulated_msrs = 0;
 	num_msr_based_features = 0;
@@ -6705,12 +6702,12 @@ static void kvm_init_msr_list(void)
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
 		case MSR_IA32_XFD:
@@ -11676,6 +11673,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	kvm_init_pmu_capability();
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		return r;
-- 
2.35.1

