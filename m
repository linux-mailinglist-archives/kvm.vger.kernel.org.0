Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D3444E438
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhKLJyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbhKLJyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:51 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5D3C061767;
        Fri, 12 Nov 2021 01:52:01 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id g18so8060353pfk.5;
        Fri, 12 Nov 2021 01:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RfCGghs890u1IfUjBiOG/GW0eq/HrLLY/fA6C10Whzk=;
        b=IwfURyHgLi3MOABPwuj2Z+uunm4xktM7eK9LlX931BLKNr2JGzhCD8Fh7LOxubGN28
         8ptA2Xko/NrUnayKTnQMhdKDDOlow4xA8x2eYmF5UfljLKeuyZrc8XivNAzUniUU2c3I
         1ApVWhX7IYLCHUzfqNkVVfNSqB0fay2S3EQJYqDjT+CzBbD9IkhewGqsz+P3UXIEnd4q
         +2PQe8MlhrhyRGWqO4R640IFrXDvCu/ZYxSD2B9v/qUKqWwKzM8cJPPyn+FlUreUhGCD
         kFsCTewQZTBB3RBDZLyExL2bQN9zJDN6Q42DRy0t5Ulh3xqfgIZPUh9yTFNRmq4xQ6hr
         XtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RfCGghs890u1IfUjBiOG/GW0eq/HrLLY/fA6C10Whzk=;
        b=omMVichlw/+TQjcyfaW7SRYqJRr5xBNp/uC0LOHLsUnP5ChAdtltCi1uepk82vxRT1
         /oPu/MNPXm+USpwMI8/XFVnN8XNpNco4rSOv5MYs/gd60zSROyIj24rSVbAZXlUkLFiJ
         J9OI/y9yHxhIuIA5xsdfqo8BHVoYJYkJqxxHMTY3OScU2P4cJN7oXjbHYHQuXCPPjOGy
         jDjpc4WUfJ33IhkOk4lyjckvOlK5XCKqZ+kblU2xieRZpizKeK7qTTxnCmPNCvxl6LJe
         W1rrYguFFGhgBza5jfsyhADWyfhKdjp6MZQYl3hKARLKQ1mG57LcnkENORqaWZyIF0rU
         NrWw==
X-Gm-Message-State: AOAM530DO5o+CS/0w9k6zbdtSaYIFLtFvy9rGUuNjJQ6FPVB7+vquSUO
        BizptKmYAOiSLHopkb/SCuU=
X-Google-Smtp-Source: ABdhPJwEhiGP8rsEREyJRRSH8ve1R2bndHeYu56OMnwX5QBvPFOiIACrI3d/7nl5bEuvXLJzFKQVjA==
X-Received: by 2002:a63:454:: with SMTP id 81mr8994340pge.24.1636710720788;
        Fri, 12 Nov 2021 01:52:00 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.51.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:51:59 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 4/7] KVM: x86/pmu: Avoid perf_event creation for invalid counter config
Date:   Fri, 12 Nov 2021 17:51:36 +0800
Message-Id: <20211112095139.21775-5-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

KVM needs to be fixed to avoid perf_event creation when the requested
hw event on a gp or fixed counter is marked as unavailable in the Intel
guest CPUID 0AH.EBX leaf.

It's proposed to use is_intel_cpuid_event() to distinguish whether the hw
event is an Intel pre-defined architecture event, so that we can decide to
reprogram it with PERF_TYPE_HARDWARE (for fixed and gp) or
PERF_TYPE_RAW (for gp only) perf_event, or just avoid creating perf_event.

If an Intel cpuid event is marked as unavailable by checking
pmu->available_event_types, the intel_find_[fixed|arch]_event() returns
a new special value of "PERF_COUNT_HW_MAX + 1" to tell the caller
to avoid creating perf_ event and not to use PERF_TYPE_RAW mode for gp.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  8 +++++++
 arch/x86/kvm/vmx/pmu_intel.c | 45 +++++++++++++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7093fc70cd38..3b47bd92e7bb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -111,6 +111,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 	};
 
+	/*
+	 * The "config > PERF_COUNT_HW_MAX" only appears when
+	 * the kernel generic event is marked as unavailable
+	 * in the Intel guest architecture event CPUID leaf.
+	 */
+	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
+		return;
+
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if (in_tx)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4c04e94ae548..4f58c14efa61 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,17 +68,39 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
+/* UMask and Event Select Encodings for Intel CPUID Events */
+static inline bool is_intel_cpuid_event(u8 event_select, u8 unit_mask)
+{
+	if ((!unit_mask && event_select == 0x3C) ||
+	    (!unit_mask && event_select == 0xC0) ||
+	    (unit_mask == 0x01 && event_select == 0x3C) ||
+	    (unit_mask == 0x4F && event_select == 0x2E) ||
+	    (unit_mask == 0x41 && event_select == 0x2E) ||
+	    (!unit_mask && event_select == 0xC4) ||
+	    (!unit_mask && event_select == 0xC5))
+		return true;
+
+	/* the unimplemented topdown.slots event check is kipped. */
+	return false;
+}
+
 static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 				      u8 event_select,
 				      u8 unit_mask)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
-		if (intel_arch_events[i].eventsel == event_select &&
-		    intel_arch_events[i].unit_mask == unit_mask &&
-		    ((i > 6) || pmu->available_event_types & (1 << i)))
-			break;
+	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
+		if (intel_arch_events[i].eventsel != event_select ||
+		    intel_arch_events[i].unit_mask != unit_mask)
+			continue;
+
+		if (is_intel_cpuid_event(event_select, unit_mask) &&
+		    !(pmu->available_event_types & BIT_ULL(i)))
+			return PERF_COUNT_HW_MAX + 1;
+
+		break;
+	}
 
 	if (i == ARRAY_SIZE(intel_arch_events))
 		return PERF_COUNT_HW_MAX;
@@ -90,12 +112,23 @@ static unsigned int intel_find_fixed_event(struct kvm_pmu *pmu, int idx)
 {
 	u32 event;
 	size_t size = ARRAY_SIZE(fixed_pmc_events);
+	u8 event_select, unit_mask;
+	unsigned int event_type;
 
 	if (idx >= size)
 		return PERF_COUNT_HW_MAX;
 
 	event = fixed_pmc_events[array_index_nospec(idx, size)];
-	return intel_arch_events[event].event_type;
+
+	event_select = intel_arch_events[event].eventsel;
+	unit_mask = intel_arch_events[event].unit_mask;
+	event_type = intel_arch_events[event].event_type;
+
+	if (is_intel_cpuid_event(event_select, unit_mask) &&
+	    !(pmu->available_event_types & BIT_ULL(event_type)))
+		return PERF_COUNT_HW_MAX + 1;
+
+	return event_type;
 }
 
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
-- 
2.33.0

