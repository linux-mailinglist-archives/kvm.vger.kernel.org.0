Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEC845320C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhKPMYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbhKPMYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:24:35 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9876C061570;
        Tue, 16 Nov 2021 04:21:38 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z6so18024300pfe.7;
        Tue, 16 Nov 2021 04:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuC7ZB2yxcgOU60z+OpXfks9WN9+4gTePeFFLFNtjWA=;
        b=iZrd7FzvW9ZHF1ZjHuKYCYUM5ZrrbIRtIljZA1hlsNOuxidO6KZzgo3GSMXcuMN6BY
         Mzj6M6VSCjlsrIfj77FAGSHrW1vYhrPDrnpNd8H74KV1IWPuFmwoyZNRluQKuwA/JH0z
         er7GOEL/iY3A8zx83pTFdU/KzjGY0pi0sadagy+MxW1v0OE+oVgKPRWA+lutedq08PN/
         ZuQAvnhU1p2yDntc58MOk5IGfrHflliB6r6PhdXpkIMmYvNpxfUP1CBPQRHGAbuuOh0e
         L0Stc5qOFc+pujvHaanAiOogzgALH0cOrlO4GjLg4RLO65+fadRuE5hfbqi4+u3NoHIY
         JADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuC7ZB2yxcgOU60z+OpXfks9WN9+4gTePeFFLFNtjWA=;
        b=eFzISv/+8GUZIu250AZ6SEURcZzxjfJGm7Ah92rDxguDWMLQGdgydL8HX70vMlrhOY
         M4sEEUB7JPhZvcatr8BApGPoHkspcTXnP+EJ4GGXyAOoLy36AvBYNtGrxkcx3TP5aIrS
         nN5vvHXpILn0VF/joPUdn3t1kgMdKC5br6ygGDEIWB4ek7SIimfCtlhJCdHWxa/s8QD+
         afk7mxFjff5deTeqo14m0OLGSs55303v6Ik6MHxSiP5UOX53tgAfW8rgMTv5W137IZt8
         DeD8jq0pIqpZv0yDYsKW+UEIEk++cuTMWuY1muFuHNjQ/cB6k1Hy3yXA7GX7gUVYJbVr
         tpFA==
X-Gm-Message-State: AOAM533YskmButq2VjAzpynIx/s6o98pU7yHT49hxqHS4VT2DKEV5EP8
        9jffkauLj/4BNesDsIz5GwU=
X-Google-Smtp-Source: ABdhPJwC6zx9TaYnwjCFjqm9fnR+Tw0Q+JHb7RPX7Lxnn8zrmlQ6M6npXwsQy6218+GXg8vaGkPGQQ==
X-Received: by 2002:a62:760a:0:b0:494:6fa0:60a2 with SMTP id r10-20020a62760a000000b004946fa060a2mr40001157pfc.39.1637065298339;
        Tue, 16 Nov 2021 04:21:38 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i67sm18557613pfg.189.2021.11.16.04.21.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 04:21:37 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: x86/pmu: Reuse find_perf_hw_id() and drop find_fixed_event()
Date:   Tue, 16 Nov 2021 20:20:29 +0800
Message-Id: <20211116122030.4698-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116122030.4698-1-likexu@tencent.com>
References: <20211116122030.4698-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Since we set the same semantic event value for the fixed counter in
pmc->eventsel, returning the perf_hw_id for the fixed counter via
find_fixed_event() can be painlessly replaced by find_perf_hw_id()
with the help of pmc_is_fixed() check.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  2 +-
 arch/x86/kvm/pmu.h           |  1 -
 arch/x86/kvm/svm/pmu.c       | 11 ++++-------
 arch/x86/kvm/vmx/pmu_intel.c | 29 ++++++++++++++++-------------
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 903dc6a532cc..3c45467b4275 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -262,7 +262,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
+			      kvm_x86_ops.pmu_ops->find_perf_hw_id(pmc),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index e7a5d4b6fa94..354339710d0d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -25,7 +25,6 @@ struct kvm_event_hw_type_mapping {
 
 struct kvm_pmu_ops {
 	unsigned int (*find_perf_hw_id)(struct kvm_pmc *pmc);
-	unsigned (*find_fixed_event)(int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 1d31bd5c6803..eeaeb58d501b 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -140,6 +140,10 @@ static unsigned int amd_find_perf_hw_id(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
+	if (pmc_is_fixed(pmc))
+		return PERF_COUNT_HW_MAX;
+
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
 		if (amd_event_mapping[i].eventsel == event_select
 		    && amd_event_mapping[i].unit_mask == unit_mask)
@@ -151,12 +155,6 @@ static unsigned int amd_find_perf_hw_id(struct kvm_pmc *pmc)
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
@@ -321,7 +319,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops amd_pmu_ops = {
 	.find_perf_hw_id = amd_find_perf_hw_id,
-	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f1cc6192ead7..8ba8b4ab1fb7 100644
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
 static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -75,6 +88,9 @@ static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	if (pmc_is_fixed(pmc))
+		return intel_find_fixed_event(pmc->idx - INTEL_PMC_IDX_FIXED);
+
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
 		if (intel_arch_events[i].eventsel == event_select
 		    && intel_arch_events[i].unit_mask == unit_mask
@@ -87,18 +103,6 @@ static unsigned int intel_find_perf_hw_id(struct kvm_pmc *pmc)
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
@@ -722,7 +726,6 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops intel_pmu_ops = {
 	.find_perf_hw_id = intel_find_perf_hw_id,
-	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.33.1

