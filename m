Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BC94CD0C0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiCDJHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbiCDJGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:30 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7271A1C5C;
        Fri,  4 Mar 2022 01:05:31 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y11so7108158pfa.6;
        Fri, 04 Mar 2022 01:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oTDLRQ7GSPh/VYgQs6jT+HPfBnnhO81F4+/NH150J44=;
        b=fjk2aeBb8dShDQa3RJG/Mj3KaDChxlU47sexJ8pggwyak46kpmO0JUD0iQpDcoImo+
         wsvfBwryXjXprfjfyyFOE7aBpOHYStw7dfvF4p2fOEws4ravnn1PFlqVquaaiHxOocrZ
         wROLalHMzvtr64kFSehMhYE+0o/+YpNS1d0lRFitQnMSDKRNtYxNM5qgGNZpNxrXafRU
         wPA3gr5dwil8IwkYb9ONEDPdJUV2y4ZePBUqyui30V/ecwD5Wtw0d52b62g0DER/NaEr
         yAcqmSvAO3yilGvZ+Jr4v+wNzZBSDXsBthWJUWkZl9JEdRaA8lDeOrAHjETujFD+u2aL
         9N1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oTDLRQ7GSPh/VYgQs6jT+HPfBnnhO81F4+/NH150J44=;
        b=wRvKroP5451Bx0lNwd+fHo/wf9CZGQRgdXNbNarQNsrNr5/GmVrZfKRrCbcpekefLq
         5mwZtNaWQRECA8pkSZlQ+Ieq+5blUB7rKxZP/vNF2s47Rd0UooJak1oLWP3I9LlD7lbD
         EKsRHIMfAWY4rCCe6hznqx0h4edVOZwHUJeYKZsesahxyEWLidAy16Dr+Y5NvmXrLipe
         ral5ZChH0F4EcAo2vD9Hb3miuu/+EJT1b9xvNRdCDn+u9arI/7vXsnYYx1k0YYJ9d1PX
         8Kenv2RvdSoV/NssQmgTKJZ5pDlrbMNse5kTqRKRuwbZ22/lfNKl9Sd6zgHRXhnj8WT+
         J8tQ==
X-Gm-Message-State: AOAM533k1bDReLDpofLuSTQaZNa0x2cn0esn/3yOT+Z5GVJkalz2B03r
        03Hlhbo/SObLU35mMNm9BEw=
X-Google-Smtp-Source: ABdhPJzG33KZqi0iurlecaEw6fv3KfgOEbCJPWOIFvl9dwi5vJpppLiJ46OL4bt/w86OsAojbwGf2Q==
X-Received: by 2002:a63:d23:0:b0:364:f37b:947d with SMTP id c35-20020a630d23000000b00364f37b947dmr33634831pgl.263.1646384730866;
        Fri, 04 Mar 2022 01:05:30 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:30 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 15/17] KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
Date:   Fri,  4 Mar 2022 17:04:25 +0800
Message-Id: <20220304090427.90888-16-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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
 arch/x86/kvm/cpuid.c         | 26 ++++++++------------------
 arch/x86/kvm/pmu.c           |  3 +++
 arch/x86/kvm/pmu.h           | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 17 ++++++++---------
 arch/x86/kvm/x86.c           |  9 ++++-----
 5 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ff756cdc31ce..896e70f6bf7d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -866,33 +866,23 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index 917d2cbb9ede..883a52ced637 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -21,6 +21,9 @@
 #include "lapic.h"
 #include "pmu.h"
 
+struct x86_pmu_capability __read_mostly kvm_pmu_cap;
+EXPORT_SYMBOL_GPL(kvm_pmu_cap);
+
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 386c8120d4ee..e717955a5a19 100644
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
@@ -176,6 +194,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
+void kvm_init_pmu_capability(void);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e877e1d0a147..7707ec01fb1f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -514,8 +514,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
-
-	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
@@ -542,13 +540,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
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
 
@@ -558,9 +557,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		pmu->nr_arch_fixed_counters =
 			min3(ARRAY_SIZE(fixed_pmc_events),
 			     (size_t) edx.split.num_counters_fixed,
-			     (size_t) x86_pmu.num_counters_fixed);
-		edx.split.bit_width_fixed = min_t(int,
-			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
+			     (size_t) kvm_pmu_cap.num_counters_fixed);
+		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
+						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 		setup_fixed_pmc_eventsel(pmu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41b25412bad4..174fd582e51e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6569,15 +6569,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 
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
@@ -6629,12 +6626,12 @@ static void kvm_init_msr_list(void)
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
@@ -11513,6 +11510,8 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		rdmsrl(MSR_IA32_XSS, host_xss);
 
+	kvm_init_pmu_capability();
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		return r;
-- 
2.35.1

