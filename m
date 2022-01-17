Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8149046A
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiAQIx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiAQIxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:53:20 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9B0C06161C;
        Mon, 17 Jan 2022 00:53:20 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g5so20497768plo.12;
        Mon, 17 Jan 2022 00:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tsV5GJ9S6ZkQ236GmJPjRkI1am3D8dD2WbpEaG7QKr8=;
        b=VGcFBwkFQSGZ5fW/x5PMpSsTrY9taHzcAEDISUW9XSufPWLBp6dmyTl8goHpsSJ8iz
         1HBI/osstnE9gQkZ3To54Hz7+XKZ5hErLyVCfudDeaxQqbtbJPrK50XazNyE941wyfU7
         HBqJdGLFtLcir/H6bvt69cFWskEUdzoWHU3a/iApFrZiReaHpDzhlLae4ppZSHP9wX00
         3MS0ZREjTMb3G8Wg3pY+8KrdI0Oh3IjnTKsIy9xuDLFDGr1GQzPPZJhlV8/qM6DI2ARe
         BwNIjHZ7d1eKpYQspdXkUR/vhvuPaERcgC5hKiOYNdX5srPmmeqfVvoj7lmf7/ylPmMH
         Fmfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tsV5GJ9S6ZkQ236GmJPjRkI1am3D8dD2WbpEaG7QKr8=;
        b=OfY/KgOOCHVbNCyCPalillhOk92j7Su4ysOUbtTmrWzXcTmCSPql4Tet/ZdMmHIijh
         ARTe6lN2hSntCq4neg2KaPpo7pz5gr48NMzYhK3vkph6fxp/XwDYxYdA3TTH1ktK5Cl3
         h5EfhiVehfJpdHwTtTskZQWtjN7a0X17euv5h8FVZpwNDXnAFSXCEtON5C/HixrmcH7+
         GWxfzacRn3izDRQjSkCT6rmWoLcbAGtyvF9ZLMZgjuj9rBNQ+oDkxRIyhKzU8D0jul7J
         rkcMOyrIRcGxTcCcmMos11iWcgFEHCGktijrHPb4/s7JFPFAoJ+6kYFoGPz76g3tiaCP
         rr1w==
X-Gm-Message-State: AOAM531OY7Gegx5u4hXOdrKSZOYxT3xARmV+QLY4PYdIDFYZAcVX96Py
        hsqqx+WqQu197nLczKpn0us=
X-Google-Smtp-Source: ABdhPJzeuthk0U2GmZLydJLuCI0QGXauZ1dJqBGTO+F7S5l/LRVIeylcYfHHjPw0m/GlCg6WS20CnA==
X-Received: by 2002:a17:902:6906:b0:149:7087:355c with SMTP id j6-20020a170902690600b001497087355cmr20820022plk.153.1642409600248;
        Mon, 17 Jan 2022 00:53:20 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q4sm13849686pfj.84.2022.01.17.00.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:53:20 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH kvm/queue v2 1/3] KVM: x86/pmu: Replace pmu->available_event_types with a new BITMAP
Date:   Mon, 17 Jan 2022 16:53:05 +0800
Message-Id: <20220117085307.93030-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220117085307.93030-1-likexu@tencent.com>
References: <20220117085307.93030-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Currently, KVM refuses to create a perf_event for a counter if its
requested hw event is prompted as unavailable according to the
Intel CPUID CPUID 0x0A.EBX bit vector. We replace the basis for
this validation with the kernel generic and common enum perf_hw_id{}.
This helps to remove the use of static {intel,amd}_arch_events[] later on,
as it is not constant across platforms.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 40 +++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d97f4adc1cb..03fabf22e167 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -501,7 +501,6 @@ struct kvm_pmc {
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
-	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
 	u64 global_ctrl;
 	u64 global_status;
@@ -516,6 +515,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
+	DECLARE_BITMAP(avail_perf_hw_ids, PERF_COUNT_HW_MAX);
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ffccfd9823c0..1ba8f0f0098b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -74,6 +74,7 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
+	unsigned int event_type = PERF_COUNT_HW_MAX;
 
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
 		if (intel_arch_events[i].eventsel != event_select ||
@@ -81,16 +82,14 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 			continue;
 
 		/* disable event that reported as not present by cpuid */
-		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
+		event_type = intel_arch_events[i].event_type;
+		if (!test_bit(event_type, pmu->avail_perf_hw_ids))
 			return PERF_COUNT_HW_MAX + 1;
 
 		break;
 	}
 
-	if (i == ARRAY_SIZE(intel_arch_events))
-		return PERF_COUNT_HW_MAX;
-
-	return intel_arch_events[i].event_type;
+	return event_type;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
@@ -469,6 +468,25 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 	}
 }
 
+/* Mapping between CPUID 0x0A.EBX bit vector and enum perf_hw_id. */
+static inline int map_unavail_bit_to_perf_hw_id(int bit)
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
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -478,6 +496,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	unsigned long available_cpuid_events;
+	int bit;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -503,8 +523,14 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	eax.split.mask_length = min_t(int, eax.split.mask_length, x86_pmu.events_mask_len);
-	pmu->available_event_types = ~entry->ebx &
-					((1ull << eax.split.mask_length) - 1);
+	/*
+	 * The number of valid EBX bits should be less than the number of valid perf_hw_ids.
+	 * Otherwise, we need to additionally determine if the event is rejected by KVM.
+	 */
+	available_cpuid_events = ~entry->ebx & ((1ull << eax.split.mask_length) - 1);
+	bitmap_fill(pmu->avail_perf_hw_ids, PERF_COUNT_HW_MAX);
+	for_each_clear_bit(bit, (unsigned long *)&available_cpuid_events, eax.split.mask_length)
+		__clear_bit(map_unavail_bit_to_perf_hw_id(bit), pmu->avail_perf_hw_ids);
 
 	if (pmu->version == 1) {
 		pmu->nr_arch_fixed_counters = 0;
-- 
2.33.1

