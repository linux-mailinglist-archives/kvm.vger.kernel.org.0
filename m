Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F64C462DB3
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbhK3HqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239128AbhK3Hp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 02:45:58 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3226C061574;
        Mon, 29 Nov 2021 23:42:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so17612642pju.3;
        Mon, 29 Nov 2021 23:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wAZN5OcC8YDcmNyDQE/y9NeagKXbDq4eHYJ8bgvlYGw=;
        b=X54Bw7DmxTLuB30ZZJ2eKQR6YtM/Ek2vIv8ZoGwroly0nONl0HdzSYXGEnrlAu0ty0
         xsiha453Ev9GMsLrezNmXYyA6ccPSg3k2KIxa1rHf011y4dvqGFdFWYY5Hoy6Fkt91or
         H14Od9Ya88nqeaVu8A3TAXHo85MDTX5+PP8K4qNC6bMtKpBjNo9vGOs8GWH5dNRzgMAA
         DogrzanVhJ1hknehBCiGzOvjXSQhkmeiKDajq12/s8WfQqk4kVNuXNyiKcL/rhmMrrTc
         M9SqKv80h7W82ChQY9bSGCet+3x3wkFuQDv+qGanXclzs+dQJzyfgzK9efVAUuQu67RR
         /iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wAZN5OcC8YDcmNyDQE/y9NeagKXbDq4eHYJ8bgvlYGw=;
        b=mJ45JhcEDBLXEFwSR9+dMNWxcoz2NIldRSEQHUTd1fSBym3eJTSnuiFJ1UI1Zky/By
         Qi8NTChAVgeDV0j8s4XfsMYf/bsSoOMhv0fEn5peAa6Bl3DfSlhBozl2mdoE2lK1a9qd
         4g4LHjTwK7uTPqBCGNpzmmxyFc88DOyIVXkD35AkISeMwnU893NjNqMNWornfdzNJFgu
         xuZ1gvdFrzrQkYIicDdyLXTVqHThDk2fEcxQjCQ11xmlGPUEZyjemBGqKNAJasxPbSAr
         Jw6OVXNXLdOwlvNnGkx7pbLPM40oloLMzGV+1nYrYBJNgDYhoSX/MQiSoN9s+jRGBWFs
         8KGQ==
X-Gm-Message-State: AOAM530cNt4asEKt0l15e7lz7ntpQnrd+rTK/IVp5kNydnm5arBS2/fA
        HJhKL4q1U6s5G5ajTW/2C9w=
X-Google-Smtp-Source: ABdhPJyzyLVxjdNduOxRL8LaEPEH5ZRN2ATv1ChT4Y4wS8OIR8rcE0tAEIqNH9N5H/7jB9htU66Agw==
X-Received: by 2002:a17:90b:1c0f:: with SMTP id oc15mr4167156pjb.50.1638258159508;
        Mon, 29 Nov 2021 23:42:39 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h13sm19066010pfv.84.2021.11.29.23.42.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Nov 2021 23:42:39 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v2 3/6] KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
Date:   Tue, 30 Nov 2021 15:42:18 +0800
Message-Id: <20211130074221.93635-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211130074221.93635-1-likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
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
 arch/x86/kvm/vmx/pmu_intel.c | 19 +++----------------
 4 files changed, 8 insertions(+), 25 deletions(-)

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
index fb0ce8cda8a7..12d8b301065a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -144,6 +144,10 @@ static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	/* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
+	if (WARN_ON(pmc_is_fixed(pmc)))
+		return PERF_COUNT_HW_MAX;
+
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
 		if (amd_event_mapping[i].eventsel == event_select
 		    && amd_event_mapping[i].unit_mask == unit_mask)
@@ -155,12 +159,6 @@ static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
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
@@ -324,7 +322,6 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops amd_pmu_ops = {
 	.pmc_perf_hw_id = amd_pmc_perf_hw_id,
-	.find_fixed_event = amd_find_fixed_event,
 	.pmc_is_enabled = amd_pmc_is_enabled,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 67a0188ecdc5..ad0e53b0d7bf 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -76,9 +76,9 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++)
-		if (intel_arch_events[i].eventsel == event_select
-		    && intel_arch_events[i].unit_mask == unit_mask
-		    && (pmu->available_event_types & (1 << i)))
+		if (intel_arch_events[i].eventsel == event_select &&
+		    intel_arch_events[i].unit_mask == unit_mask &&
+		    (pmc_is_fixed(pmc) || pmu->available_event_types & (1 << i)))
 			break;
 
 	if (i == ARRAY_SIZE(intel_arch_events))
@@ -87,18 +87,6 @@ static unsigned int intel_pmc_perf_hw_id(struct kvm_pmc *pmc)
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
@@ -721,7 +709,6 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 
 struct kvm_pmu_ops intel_pmu_ops = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
-	.find_fixed_event = intel_find_fixed_event,
 	.pmc_is_enabled = intel_pmc_is_enabled,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
-- 
2.33.1

