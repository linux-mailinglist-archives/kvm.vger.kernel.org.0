Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024FA44E43E
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhKLJzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbhKLJzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:55:04 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAA6C061205;
        Fri, 12 Nov 2021 01:52:09 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso7168748pjb.2;
        Fri, 12 Nov 2021 01:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z9lU273cXN8E0lW1RNkQnfL/m2oRGI6p2rKNyP0vEws=;
        b=nx/9EUBDA3Ji9VTcVFcslQZ9P9x33CZLt8gWjQNnZt9p/PC5W+4XHAhtelABVpYb3A
         CtVmUhOclSvCXN7nvyOfQRXtpBivYipaW9RNCBuT8KRFWsz8hiLhCbrclW5PxygwBxhu
         uD2Em2LuxWVJuJbmLXEOcEd1N5A61rVjNan6y1JGXsj8M4tWsyGBiBJTY3LserCnGeKD
         XfqkV4ncWwAqjjoDOZTDFxNOgA5+hCYPs9vFnq7eSD8fa7kl9tvmv64ORtgmGIN6BkS9
         q91BVRhisCF5P+7r49xS7VVq+WkK8byqoVikWc7t6ml6uNmmz7akKgIPhjSmnhPMzqDK
         j2bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z9lU273cXN8E0lW1RNkQnfL/m2oRGI6p2rKNyP0vEws=;
        b=r2iGxF74GxT2rbTkvpYi8c4TMt91froWWi+3KU79vODkuHVzeuMuWKKGO6o0dwKYKh
         hRKJMa9yylj2txzhOWBHuzFz1vQT4vKLtZelbpFOq4uHhGnsvco5Nn6Pf9ZxRLYAvGEg
         X/gqNQYdRdaLa3U3OPKU6On77uRL4bq9T1cV6xcS7Nr3AnoQGicW+g/rGXoWF6nC0Olb
         ZsS6yzTv/6druPJDwvkUWRSI/enFzrsefstHmq7zSzZn2zy1oOM5SOt4lmsuPF5NJR4A
         UgXC6oVVmxuif+7u+V3JV2abLvwlBa0Kf3zd2teRyGZv3I/rFHTA1S3YEJBPMSSM0/OL
         PfzQ==
X-Gm-Message-State: AOAM530VROalALwaIAlXnzetL/ED6100THfG1D7HDqzASbyZwdB5WxhJ
        7Yj5Tx3ZFL8phxPVjeUG2Xw=
X-Google-Smtp-Source: ABdhPJzYX0hPMLk6+QStzvvm7tPenOVYikga4zYDi+Ulj1CjxlWbtl74s6g3/0fDGqbG2JEPmG0OrA==
X-Received: by 2002:a17:902:76c4:b0:143:6f27:391b with SMTP id j4-20020a17090276c400b001436f27391bmr6703760plt.76.1636710728534;
        Fri, 12 Nov 2021 01:52:08 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.52.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:52:08 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 7/7] KVM: x86/pmu: Setup the {inte|amd}_event_mapping[] when hardware_setup
Date:   Fri, 12 Nov 2021 17:51:39 +0800
Message-Id: <20211112095139.21775-8-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The current amd_event_mapping[] is only valid for "K7 and later, up to and
including Family 16h" and it needs amd_f17h_perfmon_event_mapp[] for
"Family 17h and later". It's proposed to fix it in a more generic approach.

For AMD platforms, the new introduced interface perf_get_hw_event_config()
could be applied to fill up the new introduced global kernel_arch_events[].

For Intel platforms, we need to distinguish the "kernel_arch_events"
(which is defined based on the kernel generic "enum perf_hw_id" )
and "intel_cpuid_events" (which is defined based on the Intel CPUID).

To keep the validation check function for Intel cpuid events, the
get_perf_hw_id_from_cpuid_idx() is added to correcte the bit index
in the pmu->avail_cpuid_events based on "enum perf_hw_id" when
the original strictly ordered intel_arch_events[] is replaced
by the new strictly ordered kernel_arch_events[].

When the kernel_arch_events[] is initialized, the original 8-element array
is replaced by a new 10-element array, and the eventsel and unit_mask of
the two new members of will be zero, which makes the call to "perf_hw_id"
in the find_arch_event() very confusing. In this case, KVM will not query
kernel_arch_events[] when the trapped event_select and unit_mask are
both 0, it will fall back to PERF_TYPE_RAW mode to program the perf_event.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 24 ++++++++++++-
 arch/x86/kvm/pmu.h           |  2 ++
 arch/x86/kvm/svm/pmu.c       | 22 +++---------
 arch/x86/kvm/vmx/pmu_intel.c | 70 +++++++++++++++++++++++-------------
 arch/x86/kvm/x86.c           |  1 +
 5 files changed, 76 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3b47bd92e7bb..03d28912309a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,6 +19,9 @@
 #include "lapic.h"
 #include "pmu.h"
 
+struct kvm_event_hw_type_mapping kernel_arch_events[PERF_COUNT_HW_MAX];
+EXPORT_SYMBOL_GPL(kernel_arch_events);
+
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
@@ -217,7 +220,9 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
 	unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
+	/* Fall back to PERF_TYPE_RAW mode if event_select and unit_mask are both 0. */
+	if ((event_select | unit_mask) &&
+	    !(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
 			  ARCH_PERFMON_EVENTSEL_INV |
 			  ARCH_PERFMON_EVENTSEL_CMASK |
 			  HSW_IN_TX |
@@ -499,6 +504,23 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_reset(vcpu);
 }
 
+/* Initialize common hardware events mapping based on enum perf_hw_id. */
+void kvm_pmu_hw_events_mapping_setup(void)
+{
+	u64 config;
+	int i;
+
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
+		config = perf_get_hw_event_config(i) & 0xFFFFULL;
+
+		kernel_arch_events[i] = (struct kvm_event_hw_type_mapping){
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
index fe29537b1343..688b784f1e26 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -160,8 +160,10 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 
+void kvm_pmu_hw_events_mapping_setup(void);
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
+extern struct kvm_event_hw_type_mapping kernel_arch_events[];
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 3ee8f86d9ace..68814b3b6e27 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -32,18 +32,6 @@ enum index {
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
@@ -140,15 +128,15 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++)
+		if (kernel_arch_events[i].eventsel == event_select &&
+		    kernel_arch_events[i].unit_mask == unit_mask)
 			break;
 
-	if (i == ARRAY_SIZE(amd_event_mapping))
+	if (i == PERF_COUNT_HW_MAX)
 		return PERF_COUNT_HW_MAX;
 
-	return amd_event_mapping[i].event_type;
+	return kernel_arch_events[i].event_type;
 }
 
 /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index db36e743c3cc..40b4112aefa4 100644
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
+ * mapping between fixed pmc index and kernel_arch_events array
+ *
+ * PERF_COUNT_HW_INSTRUCTIONS
+ * PERF_COUNT_HW_CPU_CYCLES
+ * PERF_COUNT_HW_REF_CPU_CYCLES
+ */
+static int fixed_pmc_events[] = {1, 0, 9};
 
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
@@ -90,9 +84,9 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
-		if (intel_arch_events[i].eventsel != event_select ||
-		    intel_arch_events[i].unit_mask != unit_mask)
+	for (i = 0; i < PERF_COUNT_HW_MAX; i++) {
+		if (kernel_arch_events[i].eventsel != event_select ||
+		    kernel_arch_events[i].unit_mask != unit_mask)
 			continue;
 
 		if (is_intel_cpuid_event(event_select, unit_mask) &&
@@ -102,10 +96,10 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 		break;
 	}
 
-	if (i == ARRAY_SIZE(intel_arch_events))
+	if (i == PERF_COUNT_HW_MAX)
 		return PERF_COUNT_HW_MAX;
 
-	return intel_arch_events[i].event_type;
+	return kernel_arch_events[i].event_type;
 }
 
 static unsigned int intel_find_fixed_event(struct kvm_pmu *pmu, int idx)
@@ -120,9 +114,9 @@ static unsigned int intel_find_fixed_event(struct kvm_pmu *pmu, int idx)
 
 	event = fixed_pmc_events[array_index_nospec(idx, size)];
 
-	event_select = intel_arch_events[event].eventsel;
-	unit_mask = intel_arch_events[event].unit_mask;
-	event_type = intel_arch_events[event].event_type;
+	event_select = kernel_arch_events[event].eventsel;
+	unit_mask = kernel_arch_events[event].unit_mask;
+	event_type = kernel_arch_events[event].event_type;
 
 	if (is_intel_cpuid_event(event_select, unit_mask) &&
 	    !test_bit(event_type, pmu->avail_cpuid_events))
@@ -493,6 +487,33 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static inline int get_perf_hw_id_from_cpuid_idx(int bit)
+{
+	switch (bit) {
+	case 0:
+	case 1:
+		return bit;
+	case 2:
+		return PERF_COUNT_HW_BUS_CYCLES;
+	case 3:
+	case 4:
+	case 5:
+	case 6:
+		return --bit;
+	}
+
+	return PERF_COUNT_HW_MAX;
+}
+
+static inline void setup_available_kernel_arch_events(struct kvm_pmu *pmu,
+	unsigned int avail_cpuid_events, unsigned int mask_length)
+{
+	int bit;
+
+	for_each_set_bit(bit, (unsigned long *)&avail_cpuid_events, mask_length)
+		__set_bit(get_perf_hw_id_from_cpuid_idx(bit), pmu->avail_cpuid_events);
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -529,9 +550,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	eax.split.mask_length = min_t(int, eax.split.mask_length, x86_pmu.events_mask_len);
 	avail_cpuid_events = ~entry->ebx & ((1ull << eax.split.mask_length) - 1);
-	bitmap_copy(pmu->avail_cpuid_events,
-		    (unsigned long *)&avail_cpuid_events,
-		    eax.split.mask_length);
+	setup_available_kernel_arch_events(pmu, avail_cpuid_events,
+					   eax.split.mask_length);
 
 	if (pmu->version == 1) {
 		pmu->nr_arch_fixed_counters = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..8f7e70f59665 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11317,6 +11317,7 @@ int kvm_arch_hardware_setup(void *opaque)
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 	kvm_ops_static_call_update();
 
+	kvm_pmu_hw_events_mapping_setup();
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
 
-- 
2.33.0

