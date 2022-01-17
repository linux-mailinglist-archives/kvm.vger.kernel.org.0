Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E124E49046E
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiAQIxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbiAQIx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:53:26 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C596EC061401;
        Mon, 17 Jan 2022 00:53:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o14-20020a17090ac08e00b001b4b55792aeso328243pjs.3;
        Mon, 17 Jan 2022 00:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zdQQr2hct2K3mq5K9nUq9f6Pj4UVuzhtStCZCvI42/k=;
        b=gkNgo9hM8zJcuFLoVpB8TO+AVqRPzitHyuUozxWaUlnujzMS3PGNC9U8mw/8jg8vdZ
         SY6q3mqlQB9rRU5pKChiKmKHrhIckdpvADOJlMRBHG/5Y6fLrsjAV59IRqbtxRa9H8vA
         fiYGxPLkiAhcdlChClPYYZO+B+spoBilA7MBuySrMVPqRCSjj1s+H7VbhunEc5R13w3p
         LdQwVf6snksOl4iXEwHcQ2NWo2tjPHITw+Z3ZElxsSk5pAUiw96+GkBrTQk/kFn5JNSr
         7HUZCkmRO0riZmh2X0bJu+3NRdedwJCsvxrmdCI3tczPJP8BruLMKqrlAy5I97p0lJWv
         pkqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdQQr2hct2K3mq5K9nUq9f6Pj4UVuzhtStCZCvI42/k=;
        b=qQ2vZuNBNvOAlozXDEz7LGjwnfAcrQ8+mdQwfNFw12FwnunjAapUAaQZFVBXCQE/3k
         AWIR1nhr/OX/VHeqk0UakA7g67rCFpK2BJPNM0ztb6zKGV/1/Ks3dzdFk8fbvLmXU3eS
         5/+H+7q0huxiJZg1yqbV6biz5m004QyLcRzu/yYFnx+badxtu3Jb4OQLiiDEBA1FxAUV
         6b22tkZS0/ejbdtvxP7P5+DSF0v2sUlxyuKv0zVj+4CZ/p49OQh69T8OCrS8niOrHOvP
         jy2YiDqcW8bdd4UtKeOuIsl8NfxPTWsGX1ERaeuIHUZmtalgOD0RXAnnZjPSIghLLUJz
         Dwcw==
X-Gm-Message-State: AOAM532PqXbHawzU3JdfrHGz6d2Pl0Ddb3wFLJ1KEeWmU6E9qQEUaCYu
        4lxWGIAEPsiyMVDzLMhSoJPE2TbcfS89Yw==
X-Google-Smtp-Source: ABdhPJx6Tz3xj9T+Q/urtmCAUkLqpaISQojCo29N5z9feAaFRaweZiRfJqXsOwGJ7niWvnHOkcMKQQ==
X-Received: by 2002:a17:90b:1906:: with SMTP id mp6mr26115195pjb.221.1642409606331;
        Mon, 17 Jan 2022 00:53:26 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q4sm13849686pfj.84.2022.01.17.00.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:53:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH kvm/queue v2 3/3] KVM: x86/pmu: Setup the {inte|amd}_event_mapping[] when hardware_setup
Date:   Mon, 17 Jan 2022 16:53:07 +0800
Message-Id: <20220117085307.93030-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220117085307.93030-1-likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The current amd_event_mapping[] is only valid for "K7 and later, up to and
including Family 16h" and it needs amd_f17h_perfmon_event_mapp[] for
"Family 17h and later". It's proposed to fix it in a more generic approach.

For both Intel and AMD platforms, the new introduced interface
perf_get_hw_event_config() could be applied to fill up the new global
kernel_hw_events[] array.

When the kernel_hw_events[] is initialized, the original 8-element
array is replaced by a new 10-element array, and the eventsel and
unit_mask of the two new members of will be zero and the event_type
value is invalid. In this case, KVM will not query kernel_hw_events[]
when the trapped event_select and unit_mask are both 0, it will fall
back to PERF_TYPE_RAW type to program the perf_event.

Fixes: 3fe3331bb2857 ("perf/x86/amd: Add event map for AMD Family 17h")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 25 ++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h           |  2 ++
 arch/x86/kvm/svm/pmu.c       | 23 ++++-------------------
 arch/x86/kvm/vmx/pmu_intel.c | 34 ++++++++++++++--------------------
 arch/x86/kvm/x86.c           |  1 +
 5 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e632693a2266..3b68fb4b3ece 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -22,6 +22,10 @@
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
+/* The event_type value is invalid if event_select and unit_mask are both 0. */
+struct kvm_event_hw_type_mapping kernel_hw_events[PERF_COUNT_HW_MAX];
+EXPORT_SYMBOL_GPL(kernel_hw_events);
+
 /* NOTE:
  * - Each perf counter is defined as "struct kvm_pmc";
  * - There are two types of perf counters: general purpose (gp) and fixed.
@@ -206,7 +210,9 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!allow_event)
 		return;
 
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
+	/* Fall back to PERF_TYPE_RAW type if event_select and unit_mask are both 0. */
+	if ((pmc->eventsel & 0xFFFFULL) &&
+	    !(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 			  ARCH_PERFMON_EVENTSEL_INV |
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
@@ -545,6 +551,23 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+/* Initialize common hardware events[] by iterating over the enum perf_hw_id. */
+void kvm_pmu_hw_events_mapping_setup(void)
+{
+	u64 config;
+	int i;
+
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
+		config = perf_get_hw_event_config(i) & 0xFFFFULL;
+
+		kernel_hw_events[i] = (struct kvm_event_hw_type_mapping){
+			.eventsel = config & ARCH_PERFMON_EVENTSEL_EVENT,
+			.unit_mask = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8,
+			.event_type = i,
+		};
+	}
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..0d8a63c5b20a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -160,7 +160,9 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
+void kvm_pmu_hw_events_mapping_setup(void);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
+extern struct kvm_event_hw_type_mapping kernel_hw_events[];
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 12d8b301065a..a39ef7e7302a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,18 +33,6 @@ enum index {
 	INDEX_ERROR,
 };
 
-/* duplicated from amd_perfmon_event_map, K7 and above should work. */
-static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
-	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x7d, 0x07, PERF_COUNT_HW_CACHE_REFERENCES },
-	[3] = { 0x7e, 0x07, PERF_COUNT_HW_CACHE_MISSES },
-	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[6] = { 0xd0, 0x00, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
-	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
-};
-
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -148,15 +136,12 @@ static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	if (WARN_ON(pmc_is_fixed(pmc)))
 		return PERF_COUNT_HW_MAX;
 
-	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++)
+		if (kernel_hw_events[i].eventsel == event_select &&
+		    kernel_hw_events[i].unit_mask == unit_mask)
 			break;
 
-	if (i == ARRAY_SIZE(amd_event_mapping))
-		return PERF_COUNT_HW_MAX;
-
-	return amd_event_mapping[i].event_type;
+	return (i == PERF_COUNT_HW_MAX) ? i : kernel_hw_events[i].event_type;
 }
 
 /* check if a PMC is enabled by comparing it against global_ctrl bits. Because
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1ba8f0f0098b..0fc6507cb72d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -20,20 +20,14 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
-static struct kvm_event_hw_type_mapping intel_arch_events[] = {
-	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x3c, 0x01, PERF_COUNT_HW_BUS_CYCLES  },
-	[3] = { 0x2e, 0x4f, PERF_COUNT_HW_CACHE_REFERENCES },
-	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
-	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	/* The above index must match CPUID 0x0A.EBX bit vector */
-	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
-};
-
-/* mapping between fixed pmc index and intel_arch_events array */
-static int fixed_pmc_events[] = {1, 0, 7};
+/*
+ * Mapping between fixed pmc index and kernel_hw_events array
+ *
+ * Fixed pmc 0 is PERF_COUNT_HW_INSTRUCTIONS,
+ * Fixed pmc 1 is PERF_COUNT_HW_CPU_CYCLES,
+ * Fixed pmc 2 is PERF_COUNT_HW_REF_CPU_CYCLES.
+ */
+static int fixed_pmc_events[] = {1, 0, 9};
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
@@ -76,13 +70,13 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	int i;
 	unsigned int event_type = PERF_COUNT_HW_MAX;
 
-	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
-		if (intel_arch_events[i].eventsel != event_select ||
-		    intel_arch_events[i].unit_mask != unit_mask)
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
+		if (kernel_hw_events[i].eventsel != event_select ||
+		    kernel_hw_events[i].unit_mask != unit_mask)
 			continue;
 
 		/* disable event that reported as not present by cpuid */
-		event_type = intel_arch_events[i].event_type;
+		event_type = kernel_hw_events[i].event_type;
 		if (!test_bit(event_type, pmu->avail_perf_hw_ids))
 			return PERF_COUNT_HW_MAX + 1;
 
@@ -463,8 +457,8 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		pmc = &pmu->fixed_counters[i];
 		event = fixed_pmc_events[array_index_nospec(i, size)];
-		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
-			intel_arch_events[event].eventsel;
+		pmc->eventsel = (kernel_hw_events[event].unit_mask << 8) |
+			kernel_hw_events[event].eventsel;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c194a8cbd25f..8591fd8b42d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11349,6 +11349,7 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
+	kvm_pmu_hw_events_mapping_setup();
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
-- 
2.33.1

