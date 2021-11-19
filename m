Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9252D456A6A
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 07:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhKSGwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 01:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhKSGwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 01:52:16 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B6CC06173E;
        Thu, 18 Nov 2021 22:49:15 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id i12so8582002pfd.6;
        Thu, 18 Nov 2021 22:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/oODsisYT43emkbjYLaNkqzmjXiRrzkOY4r35KmWnY=;
        b=oCrrten28Nqle+kQf73ws2IIE1pd7x18jE3qHRotzYc3UBHD3QI7YnxyHgS5OWvN3Q
         dKEJxV6d8d9Fjl0vIpyOjo7t/oBimFHQqmnWDx1vfYwsNSWK34/ibhHt2WMkxwfGPyLy
         hE+zlKSyUIDzpE6Fa3+pZZz+3nyA0OcmwlwyhzUS1hUgG9zHs/+bPIH8lW0HB7pmIaAK
         XgZJTE5qYiw+Z4ifLUvXbWCjNuD+L3Whh6DoIw1i7Y0CxyHppVjmIoJuJ8slPF3Iy4U/
         4esM3Cx3J3xL7x27dO7587MKwwWb9q+BMHy5+7cNkOAW987xisdub1MKadPy8Arqf2sY
         RyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/oODsisYT43emkbjYLaNkqzmjXiRrzkOY4r35KmWnY=;
        b=SFgV5p8ZSXw84Nb5D/ymBOVlpX+cGVdW92KjvkfAah60GQjX1WE31jQxcVUEJ7rhSV
         HFDAZs6w9MbrLJdvxz9xVF5Ah/duZuRCSJspK8CEzmCtQ8Zt0z72Fl2hhzSe1YBaSVuZ
         4U/TTGMN3So3nrelihNCmKYu68goSgb2vzS/hFWtEHYRMysasAsuoAbLs+aGeoF+Ytf4
         RzHG8FoyjZWXWV2GuT6jT/rzxXcz37uAKstF1A/Yhesi7LELm8RIkFs/NRQo/NjaSAtR
         e0kKN/Co6Les+HOagdmpc8GUxCpGBQR+NiGrMOsH0Z7gcBe+hxTeDcqJnWYn9YDUhn29
         732Q==
X-Gm-Message-State: AOAM532AHFfmo7v6LCP0n2reH/P9ZhuTMfwdzbyyvST34Ixu49UeeOJD
        aOkXg4M9t12oyA7hr6DI3hI=
X-Google-Smtp-Source: ABdhPJxmH1IsniPfClUOYO3brG7htx6Dnq12JYMqwsbVmKpVvG1WBfyqBeB5TpimgaMz3J3r0F7Ieg==
X-Received: by 2002:a62:dd54:0:b0:4a2:93f7:c20a with SMTP id w81-20020a62dd54000000b004a293f7c20amr43706559pff.46.1637304554799;
        Thu, 18 Nov 2021 22:49:14 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mr2sm1286928pjb.25.2021.11.18.22.49.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 22:49:14 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
Date:   Fri, 19 Nov 2021 14:48:55 +0800
Message-Id: <20211119064856.77948-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119064856.77948-1-likexu@tencent.com>
References: <20211119064856.77948-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Since we set the same semantic event value for the fixed counter in
pmc->eventsel, returning the perf_hw_id for the fixed counter via
find_fixed_event() can be painlessly replaced by pmc_perf_hw_id()
with the help of pmc_is_fixed() check.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  2 +-
 arch/x86/kvm/pmu.h           |  1 -
 arch/x86/kvm/svm/pmu.c       | 11 ++++-------
 arch/x86/kvm/vmx/pmu_intel.c | 29 ++++++++++++++++-------------
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3b3ccf5b1106..b7a1ae28ab87 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -262,7 +262,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
+			      kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index dd7dbb1c5048..c91d9725aafd 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -25,7 +25,6 @@ struct kvm_event_hw_type_mapping {
 
 struct kvm_pmu_ops {
 	unsigned int (*pmc_perf_hw_id)(struct kvm_pmc *pmc);
-	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 3c00a34457d7..da8aa1e5bff0 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -140,6 +140,10 @@ static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
+	if (WARN_ON(pmc_is_fixed(pmc)))
+		return PERF_COUNT_HW_MAX;
+
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
 		if (amd_event_mapping[i].eventsel == event_select
 		    && amd_event_mapping[i].unit_mask == unit_mask)
@@ -151,12 +155,6 @@ static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	return amd_event_mapping[i].event_type;
 }
 
-/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-static unsigned amd_find_fixed_event(int idx)
-{
-	return PERF_COUNT_HW_MAX;
-}
-
 /* check if a PMC is enabled by comparing it against global_ctrl bits. Because
  * AMD CPU doesn't have global_ctrl MSR, all PMCs are enabled (return TRUE).
  */
@@ -320,7 +318,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops amd_pmu_ops = {
 	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
-	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 67a0188ecdc5..72db4ffb7eb2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,6 +68,19 @@ static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
 		reprogram_counter(pmu, bit);
 }
 
+static inline unsigned int intel_find_fixed_event(int idx)
+{
+	u32 event;
+	size_t size = ARRAY_SIZE(fixed_pmc_events);
+
+	if (idx >= size)
+		return PERF_COUNT_HW_MAX;
+
+	event = fixed_pmc_events[array_index_nospec(idx, size)];
+	return intel_arch_events[event].event_type;
+}
+
+
 static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -75,6 +88,9 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	if (pmc_is_fixed(pmc))
+		return intel_find_fixed_event(pmc->idx - INTEL_PMC_IDX_FIXED);
+
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
 		if (intel_arch_events[i].eventsel == event_select
 		    && intel_arch_events[i].unit_mask == unit_mask
@@ -87,18 +103,6 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	return intel_arch_events[i].event_type;
 }
 
-static unsigned intel_find_fixed_event(int idx)
-{
-	u32 event;
-	size_t size = ARRAY_SIZE(fixed_pmc_events);
-
-	if (idx >= size)
-		return PERF_COUNT_HW_MAX;
-
-	event = fixed_pmc_events[array_index_nospec(idx, size)];
-	return intel_arch_events[event].event_type;
-}
-
 /* check if a PMC is enabled by comparing it with globl_ctrl bits. */
 static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
@@ -721,7 +725,6 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops intel_pmu_ops = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
-	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.33.1

