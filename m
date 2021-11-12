Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65DB44E43A
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhKLJy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbhKLJyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:54 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE748C061767;
        Fri, 12 Nov 2021 01:52:03 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so2526777plg.1;
        Fri, 12 Nov 2021 01:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=brF0DYStxhXsEwWOD3vo3umgC7ANl99kGXbRW01P4QQ=;
        b=BiXjxnFznhn0VPGM+CYzVXjHRwEI61w+t+lu6SBfLfItCUWsbqp2CGyNIDopwrO1tf
         h49aiM44xxZ7IVHugKTBk9ystV/Jin5L14fe4ekwSICw/UXcs3+5EbLnfhfclLucMWST
         hcvQY6X56sLbBNf5aiNfoTxmWc7xWb857nAAOGFq8XvOPuvipOQm1OzBHoWAGLnL/RFg
         5nrCSxm5C9Vplghfd2kt5Dl8epbQAnsyNZUQ4cTbURrkMiWExhAtUbVv3vmIQJyf6iqD
         a3S3ndocL7QboFmzkKafNNSmjUwm0TNSokA60+vdU02po/oPpVbNOZLemSnzEf5pkq64
         9NEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=brF0DYStxhXsEwWOD3vo3umgC7ANl99kGXbRW01P4QQ=;
        b=WqDTuLP9JgkOiJpp4VD1m9be6Gtm++IPAhkOj/1OjofznE5YnnF6P65WU8Gmes+7Qt
         NwlUqxQHkHYe63u5AFf+4acE9dsRg29LQJ2mU1OIkPYUu8PSpM1Tz/YJrgrgOlzV9JFR
         rNDYqxAh9yw5NFgLLBWldvPmuibsU5dKXFSzu+OvRkn3tAz8qBA6V1FgaJMlkrbVjhba
         8wgJcFXUAruZKSliUQi5WgcvYyW3GuPX3odNx4WVIQBZiAbgfdku0Wemlcw2IqfbhtMS
         JhrZJI5XMDlHxdNw0Qu4THX6dLyUDJnrj9McH3MsHR51ehHewNe+mMKXXgxyJPQFLxQy
         q45A==
X-Gm-Message-State: AOAM531figlC3j/jtx8lA/yqz3JljZf+8Tb93Vs/SyfYKD74pLBerAGf
        AR0m4cEllWf3hFvAHcPLoOs=
X-Google-Smtp-Source: ABdhPJyYoqKIPQzpRIiNiQsOdb8WvtW6rv8Vf5Dv56c8Im29o+e7rps8PHgzQg1E3xa9dIOx/lZI6A==
X-Received: by 2002:a17:90b:124d:: with SMTP id gx13mr34600093pjb.106.1636710723481;
        Fri, 12 Nov 2021 01:52:03 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.52.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:52:03 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 5/7] KVM: x86/pmu: Refactor pmu->available_event_types field using BITMAP
Date:   Fri, 12 Nov 2021 17:51:37 +0800
Message-Id: <20211112095139.21775-6-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Replace the explicit declaration of "unsigned available_event_types" with
the generic macro DECLARE_BITMAP and rename it to "avail_cpuid_events"
for better self-explanation.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..2e69dec3ad7b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -495,7 +495,6 @@ struct kvm_pmc {
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
-	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
 	u64 global_ctrl;
 	u64 global_status;
@@ -510,6 +509,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(reprogram_pmi, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
+	DECLARE_BITMAP(avail_cpuid_events, X86_PMC_IDX_MAX);
 
 	/*
 	 * The gate to release perf_events not marked in
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4f58c14efa61..db36e743c3cc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -96,7 +96,7 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 			continue;
 
 		if (is_intel_cpuid_event(event_select, unit_mask) &&
-		    !(pmu->available_event_types & BIT_ULL(i)))
+		    !test_bit(i, pmu->avail_cpuid_events))
 			return PERF_COUNT_HW_MAX + 1;
 
 		break;
@@ -125,7 +125,7 @@ static unsigned int intel_find_fixed_event(struct kvm_pmu *pmu, int idx)
 	event_type = intel_arch_events[event].event_type;
 
 	if (is_intel_cpuid_event(event_select, unit_mask) &&
-	    !(pmu->available_event_types & BIT_ULL(event_type)))
+	    !test_bit(event_type, pmu->avail_cpuid_events))
 		return PERF_COUNT_HW_MAX + 1;
 
 	return event_type;
@@ -497,6 +497,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	unsigned long avail_cpuid_events;
 
 	struct x86_pmu_capability x86_pmu;
 	struct kvm_cpuid_entry2 *entry;
@@ -527,8 +528,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	eax.split.bit_width = min_t(int, eax.split.bit_width, x86_pmu.bit_width_gp);
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
 	eax.split.mask_length = min_t(int, eax.split.mask_length, x86_pmu.events_mask_len);
-	pmu->available_event_types = ~entry->ebx &
-					((1ull << eax.split.mask_length) - 1);
+	avail_cpuid_events = ~entry->ebx & ((1ull << eax.split.mask_length) - 1);
+	bitmap_copy(pmu->avail_cpuid_events,
+		    (unsigned long *)&avail_cpuid_events,
+		    eax.split.mask_length);
 
 	if (pmu->version == 1) {
 		pmu->nr_arch_fixed_counters = 0;
-- 
2.33.0

