Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1755484D45
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 06:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiAEFPW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 00:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbiAEFPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 00:15:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5DEC061761;
        Tue,  4 Jan 2022 21:15:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so2279584pjf.3;
        Tue, 04 Jan 2022 21:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iEonvTksUS7dJnsZ76vpEbyoty/J53mQJ1swr25QLf4=;
        b=Ez0magPReiSWrqVLENG9o6EaJrsyRnTE8l1Dwhn4clW2zn96JPbTId4FulldpxVpIB
         66C6L9M/tAZFLHvzGtlEHPQozzyX3EFmmZGf6Q6PCMJt3zic8DgsDq0iCFPRg6eU0Shy
         VSPKjo6pA3nIkmHh0HGiSQjEMuXeHdfpa8zeYp9+nBBClWKX6AMKyDGjWIagFlyVBgsl
         AmgwcUZeqYUxaYcvdsE48KBItxslQ/dKHBDW1l4zKiJSz7DYbhaDnJZFrMKU4DUvDsf2
         L0INxA4hNz5V5LjU3PeFYfUzQkNUO+vYaoA+hkAzmWSLOUN7ihrsCLYDSjarAZPim6XI
         JwTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iEonvTksUS7dJnsZ76vpEbyoty/J53mQJ1swr25QLf4=;
        b=qQZb5PcFawwN0dm1UWf+Y0gLkhJoDyBTHj111ife53JZN3C+x1iLl2cyN3CN8exldK
         HOQCshGvMW1KgxXblQT80m2CNTwQcLBrhFcm/jM/8LtOIYsFGBEcs1LjguxjtZXPM5wi
         UzA3wgsvXvCuSx2ShSRxuoG+BUD/TsTgL1awX4k2r7n1ZHYBDyJb5m/MkSAlpEwfEsLG
         jtU0f2E3Y2MlT5CWaUQjiexPxTcCv6PrRrMrByfROAGkLyPNNr+KKRI5NM7uzrg1/768
         FvAs4nVc73mLLxVJprVhSEBIGPzi3B+HMyy/NVDjtsTF5D7ryZErwNS7vxy7UTx51hly
         OHYA==
X-Gm-Message-State: AOAM532j5cLc3YhzNWtY0DyU1c5Uhb+KG0DZn8yuKalXv7814v/C6mx0
        uNLBpsz2f2F1K1Am6/nYQ0s=
X-Google-Smtp-Source: ABdhPJz64KkD1KekmVxaM4aXJb9USeUq8QofoE8WzsvQGaCT45zsPfYEk+NnPqCTkp8F3/ZlJoRGEQ==
X-Received: by 2002:a17:90b:3848:: with SMTP id nl8mr2102093pjb.167.1641359721099;
        Tue, 04 Jan 2022 21:15:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e3sm2871664pgm.51.2022.01.04.21.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 21:15:20 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event
Date:   Wed,  5 Jan 2022 13:15:09 +0800
Message-Id: <20220105051509.69437-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

According to CPUID 0x0A.EBX bit vector, the event [7] should be the
unrealized event "Topdown Slots" instead of the *kernel* generalized
common hardware event "REF_CPU_CYCLES", so we need to skip the cpuid
unavaliblity check in the intel_pmc_perf_hw_id() for the last
REF_CPU_CYCLES event and update the confusing comment.

If the event is marked as unavailable in the Intel guest CPUID
0AH.EBX leaf, we need to avoid any perf_event creation, whether
it's a gp or fixed counter. To distinguish whether it is a rejected
event or an event that needs to be programmed with PERF_TYPE_RAW type,
a new special returned value of "PERF_COUNT_HW_MAX + 1" is introduced.

Fixes: 62079d8a43128 ("KVM: PMU: add proper support for fixed counter 2")
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- Refine comment based on commit c1d6f42f1a42;
- Squash the idea "avoid event creation for rejected hw_config" into this commit;
- Squash the idea "PERF_COUNT_HW_MAX + 1" into this commit;

Previous:
https://lore.kernel.org/kvm/20211112095139.21775-3-likexu@tencent.com/

 arch/x86/kvm/pmu.c           |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c | 18 ++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 8abdadb7e22a..e632693a2266 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -109,6 +109,9 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.config = config,
 	};
 
+	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
+		return;
+
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
 	if (in_tx)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5e0ac57d6d1b..ffccfd9823c0 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -21,7 +21,6 @@
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
-	/* Index must match CPUID 0x0A.EBX bit vector */
 	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
 	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
 	[2] = { 0x3c, 0x01, PERF_COUNT_HW_BUS_CYCLES  },
@@ -29,6 +28,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
 	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+	/* The above index must match CPUID 0x0A.EBX bit vector */
 	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
 };
 
@@ -75,11 +75,17 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
-		if (intel_arch_events[i].eventsel == event_select &&
-		    intel_arch_events[i].unit_mask == unit_mask &&
-		    (pmc_is_fixed(pmc) || pmu->available_event_types & (1 << i)))
-			break;
+	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
+		if (intel_arch_events[i].eventsel != event_select ||
+		    intel_arch_events[i].unit_mask != unit_mask)
+			continue;
+
+		/* disable event that reported as not present by cpuid */
+		if ((i < 7) && !(pmu->available_event_types & (1 << i)))
+			return PERF_COUNT_HW_MAX + 1;
+
+		break;
+	}
 
 	if (i == ARRAY_SIZE(intel_arch_events))
 		return PERF_COUNT_HW_MAX;
-- 
2.33.1

