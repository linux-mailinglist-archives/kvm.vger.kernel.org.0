Return-Path: <kvm+bounces-11217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A41874361
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A642283020
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF1B1C6BC;
	Wed,  6 Mar 2024 23:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lF88vDvi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB5E1C2A8
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 23:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766123; cv=none; b=UhsBkirRYH7BVABH6/115UmIq9/ulhbCBHxgAgbg398i1L1ETC/G9uoG93fA8imsmgcGL3Fsoqpmhh6mw3f1pF6c0ddSygl35xg/bkHqSBEvB6hcJbuEa44LevUEtluKRaFg6RyA29H7ItTVdVaurx7o6mKS+HC2tay7i2llJAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766123; c=relaxed/simple;
	bh=H08cXysT/YLBKT0wrak+50B4oDKypWuol4uvigI2BRI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VZzHxg069kiIDaNNdBMS8Sbqeq2be8pzg4diFKsojDLTduwCnJldTdVmivUUNi957RBypk26G8Pj12USt5puml8nSXA1OowkAFXlckQB5z9NdtgluSRkiAkqZqcdgBPyBHqFhQ7WvPGR3GXHXxXwHlQXqOSpYDrm2yOFrC6l+JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lF88vDvi; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dc992f8c8aso184745a12.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 15:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709766121; x=1710370921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=E6LNEvUWmlNs8apq+H+9h8aaLLhsv/v9bYrRjBkl9Yw=;
        b=lF88vDvi6XUmDAiCkw6wfYd/IPOtZcP+u3wBbuR3RW9+bhpBVyxosYPvlAKy/AXtCi
         BL27R0vPrrbE/YioQeYFeBIJxe/qdwX5zxnh54AK7wXgM9tOd60dDUmq1/kOHEQG7fsD
         Ti7wr3l0x23EAW0ITIbdW1VLV+cfejPycLeyOa45ZvTI2hTsfiysh9Nyes/9G0mKWMXI
         ljUjoRa4PkQopbP+j2s/CBN56TqX2Q/aLc65ne1Zpr8Ml1ASTUwuXvePmn4LqoTyz/1h
         FkB6XUQSikBBlKjpcWakXITpfsRQMQNO1GrO7eEjofK5BFKzK7oFKzFucCTllCaxUwM8
         Xp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709766121; x=1710370921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6LNEvUWmlNs8apq+H+9h8aaLLhsv/v9bYrRjBkl9Yw=;
        b=Z8ERGMwF9NhcWAev5FaXprQUgAotrhF1kZGLmNQ2lDhA4zN/u5Cx1WhPIK8Eab5cXV
         8yaFAzcBfcEtLRCwUsTxPWgcwHp8NrhTU7Ka7ZoR/ntGHeyE0RsyVfeIxmcXomeF/t73
         ikujBce1Y97oyPLCJasaHwrP2PLIVWLI0mJj3BBMG/L274EZM/YmjqukilLXQaZPDNxA
         fiwBgGSmwhWlxqZ25gcM+qBiKQ8Lv8nyoID0hXHBPf4GneNPEI3gshuZ7eTw1MRelaK3
         IeK1DPC0X3vPhsLVj/G2Djoq9Hj4y9YtABCm8GoqL68BW88iyCjx5DjkDb8qqtmpjNfC
         Y2yQ==
X-Gm-Message-State: AOJu0YxOGCziPXjUfykrQw8hz8IblEhZqAy0szMi5Mj74Pb32g2EUT1e
	f3NSJhKmQ5QgINe0eerSPqYBm+PRWGLcfOodVWXbZFPxL5t6VkwbNvW5ZuHc7+V251m4OFQjZOZ
	Aow==
X-Google-Smtp-Source: AGHT+IFEp1RWFWMT+0gLvok0lEG94zoMfpDgDbKRqadoBUCM7ZH00U/M+rXNWhi2hmg0xheY4DUZuI4LqvA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7449:0:b0:5ca:3387:5fbb with SMTP id
 e9-20020a637449000000b005ca33875fbbmr43176pgn.5.1709766121437; Wed, 06 Mar
 2024 15:02:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Mar 2024 15:01:52 -0800
In-Reply-To: <20240306230153.786365-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240306230153.786365-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306230153.786365-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/4] x86/pmu: Test adaptive PEBS without any
 adaptive counters
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"

If adaptive PEBS is supported, verify that only basic PEBS records are
generated for counters without their ADAPTIVE flag set.  Per the SDM,
adaptive records are generated if and only if both the per-counter flag
*and* the global enable(s) in MSR_PEBS_DATA_CFG are set.

  IA32_PERFEVTSELx.Adaptive_Record[34]: If this bit is set and
  IA32_PEBS_ENABLE.PEBS_EN_PMCx is set for the corresponding GP counter,
  an overflow of PMCx results in generation of an adaptive PEBS record
  with state information based on the selections made in MSR_PEBS_DATA_CFG.
  If this bit is not set, a basic record is generated.

and

  IA32_FIXED_CTR_CTRL.FCx_Adaptive_Record: If this bit is set and
  IA32_PEBS_ENABLE.PEBS_EN_FIXEDx is set for the corresponding Fixed
  counter, an overflow of FixedCtrx results in generation of an adaptive
  PEBS record with state information based on the selections made in
  MSR_PEBS_DATA_CFG. If this bit is not set, a basic record is generated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu_pebs.c | 74 ++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index dff1ed26..0e8d60c3 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -89,11 +89,11 @@ static u64 counter_start_values[] = {
 	0xffffffffffff,
 };
 
-static unsigned int get_adaptive_pebs_record_size(u64 pebs_data_cfg)
+static unsigned int get_pebs_record_size(u64 pebs_data_cfg, bool use_adaptive)
 {
 	unsigned int sz = sizeof(struct pebs_basic);
 
-	if (!has_baseline)
+	if (!use_adaptive)
 		return sz;
 
 	if (pebs_data_cfg & PEBS_DATACFG_MEMINFO)
@@ -199,10 +199,10 @@ static void free_buffers(void)
 		free_page(pebs_buffer);
 }
 
-static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
+static void pebs_enable(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive)
 {
 	static struct debug_store *ds;
-	u64 baseline_extra_ctrl = 0, fixed_ctr_ctrl = 0;
+	u64 adaptive_ctrl = 0, fixed_ctr_ctrl = 0;
 	unsigned int idx;
 
 	if (has_baseline)
@@ -212,15 +212,15 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
 	ds->pebs_index = ds->pebs_buffer_base = (unsigned long)pebs_buffer;
 	ds->pebs_absolute_maximum = (unsigned long)pebs_buffer + PAGE_SIZE;
 	ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
-		get_adaptive_pebs_record_size(pebs_data_cfg);
+		get_pebs_record_size(pebs_data_cfg, use_adaptive);
 
 	for (idx = 0; idx < pmu.nr_fixed_counters; idx++) {
 		if (!(BIT_ULL(FIXED_CNT_INDEX + idx) & bitmask))
 			continue;
-		if (has_baseline)
-			baseline_extra_ctrl = BIT(FIXED_CNT_INDEX + idx * 4);
+		if (use_adaptive)
+			adaptive_ctrl = BIT(FIXED_CNT_INDEX + idx * 4);
 		wrmsr(MSR_PERF_FIXED_CTRx(idx), ctr_start_val);
-		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | baseline_extra_ctrl);
+		fixed_ctr_ctrl |= (0xbULL << (idx * 4) | adaptive_ctrl);
 	}
 	if (fixed_ctr_ctrl)
 		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, fixed_ctr_ctrl);
@@ -228,10 +228,10 @@ static void pebs_enable(u64 bitmask, u64 pebs_data_cfg)
 	for (idx = 0; idx < max_nr_gp_events; idx++) {
 		if (!(BIT_ULL(idx) & bitmask))
 			continue;
-		if (has_baseline)
-			baseline_extra_ctrl = ICL_EVENTSEL_ADAPTIVE;
+		if (use_adaptive)
+			adaptive_ctrl = ICL_EVENTSEL_ADAPTIVE;
 		wrmsr(MSR_GP_EVENT_SELECTx(idx), EVNTSEL_EN | EVNTSEL_OS | EVNTSEL_USR |
-						 intel_arch_events[idx] | baseline_extra_ctrl);
+						 intel_arch_events[idx] | adaptive_ctrl);
 		wrmsr(MSR_GP_COUNTERx(idx), ctr_start_val);
 	}
 
@@ -268,11 +268,11 @@ static void pebs_disable(unsigned int idx)
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 }
 
-static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
+static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg, bool use_adaptive)
 {
 	struct pebs_basic *pebs_rec = (struct pebs_basic *)pebs_buffer;
 	struct debug_store *ds = (struct debug_store *)ds_bufer;
-	unsigned int pebs_record_size = get_adaptive_pebs_record_size(pebs_data_cfg);
+	unsigned int pebs_record_size;
 	unsigned int count = 0;
 	bool expected, pebs_idx_match, pebs_size_match, data_cfg_match;
 	void *cur_record;
@@ -293,12 +293,9 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
 	do {
 		pebs_rec = (struct pebs_basic *)cur_record;
 		pebs_record_size = pebs_rec->format_size >> RECORD_SIZE_OFFSET;
-		pebs_idx_match =
-			pebs_rec->applicable_counters & bitmask;
-		pebs_size_match =
-			pebs_record_size == get_adaptive_pebs_record_size(pebs_data_cfg);
-		data_cfg_match =
-			(pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
+		pebs_idx_match = pebs_rec->applicable_counters & bitmask;
+		pebs_size_match = pebs_record_size == get_pebs_record_size(pebs_data_cfg, use_adaptive);
+		data_cfg_match = (pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
 		report(expected,
 		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
@@ -311,56 +308,57 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
 			printf("FAIL: The applicable_counters (0x%lx) doesn't match with pmc_bitmask (0x%lx).\n",
 			       pebs_rec->applicable_counters, bitmask);
 		if (!pebs_size_match)
-			printf("FAIL: The pebs_record_size (%d) doesn't match with MSR_PEBS_DATA_CFG (%d).\n",
-			       pebs_record_size, get_adaptive_pebs_record_size(pebs_data_cfg));
+			printf("FAIL: The pebs_record_size (%d) doesn't match with expected record size (%d).\n",
+			       pebs_record_size, get_pebs_record_size(pebs_data_cfg, use_adaptive));
 		if (!data_cfg_match)
-			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with MSR_PEBS_DATA_CFG (0x%lx).\n",
-			       pebs_rec->format_size & 0xffffffffffff, pebs_data_cfg);
+			printf("FAIL: The pebs_data_cfg (0x%lx) doesn't match with the effective MSR_PEBS_DATA_CFG (0x%lx).\n",
+			       pebs_rec->format_size & 0xffffffffffff, use_adaptive ? pebs_data_cfg : 0);
 	}
 }
 
-static void check_one_counter(enum pmc_type type,
-			      unsigned int idx, u64 pebs_data_cfg)
+static void check_one_counter(enum pmc_type type, unsigned int idx,
+			      u64 pebs_data_cfg, bool use_adaptive)
 {
 	int pebs_bit = BIT_ULL(type == FIXED ? FIXED_CNT_INDEX + idx : idx);
 
 	report_prefix_pushf("%s counter %d (0x%lx)",
 			    type == FIXED ? "Extended Fixed" : "GP", idx, ctr_start_val);
 	reset_pebs();
-	pebs_enable(pebs_bit, pebs_data_cfg);
+	pebs_enable(pebs_bit, pebs_data_cfg, use_adaptive);
 	workload();
 	pebs_disable(idx);
-	check_pebs_records(pebs_bit, pebs_data_cfg);
+	check_pebs_records(pebs_bit, pebs_data_cfg, use_adaptive);
 	report_prefix_pop();
 }
 
 /* more than one PEBS records will be generated. */
-static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg)
+static void check_multiple_counters(u64 bitmask, u64 pebs_data_cfg,
+				    bool use_adaptive)
 {
 	reset_pebs();
-	pebs_enable(bitmask, pebs_data_cfg);
+	pebs_enable(bitmask, pebs_data_cfg, use_adaptive);
 	workload2();
 	pebs_disable(0);
-	check_pebs_records(bitmask, pebs_data_cfg);
+	check_pebs_records(bitmask, pebs_data_cfg, use_adaptive);
 }
 
-static void check_pebs_counters(u64 pebs_data_cfg)
+static void check_pebs_counters(u64 pebs_data_cfg, bool use_adaptive)
 {
 	unsigned int idx;
 	u64 bitmask = 0;
 
 	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
-		check_one_counter(FIXED, idx, pebs_data_cfg);
+		check_one_counter(FIXED, idx, pebs_data_cfg, use_adaptive);
 
 	for (idx = 0; idx < max_nr_gp_events; idx++)
-		check_one_counter(GP, idx, pebs_data_cfg);
+		check_one_counter(GP, idx, pebs_data_cfg, use_adaptive);
 
 	for (idx = 0; has_baseline && idx < pmu.nr_fixed_counters; idx++)
 		bitmask |= BIT_ULL(FIXED_CNT_INDEX + idx);
 	for (idx = 0; idx < max_nr_gp_events; idx += 2)
 		bitmask |= BIT_ULL(idx);
 	report_prefix_pushf("Multiple (0x%lx)", bitmask);
-	check_multiple_counters(bitmask, pebs_data_cfg);
+	check_multiple_counters(bitmask, pebs_data_cfg, use_adaptive);
 	report_prefix_pop();
 }
 
@@ -408,7 +406,7 @@ int main(int ac, char **av)
 
 	for (i = 0; i < ARRAY_SIZE(counter_start_values); i++) {
 		ctr_start_val = counter_start_values[i];
-		check_pebs_counters(0);
+		check_pebs_counters(0, false);
 		if (!has_baseline)
 			continue;
 
@@ -419,7 +417,11 @@ int main(int ac, char **av)
 				pebs_data_cfg |= ((MAX_NUM_LBR_ENTRY -1) << PEBS_DATACFG_LBR_SHIFT);
 
 			report_prefix_pushf("Adaptive (0x%lx)", pebs_data_cfg);
-			check_pebs_counters(pebs_data_cfg);
+			check_pebs_counters(pebs_data_cfg, true);
+			report_prefix_pop();
+
+			report_prefix_pushf("Ignored Adaptive (0x%lx)", pebs_data_cfg);
+			check_pebs_counters(pebs_data_cfg, false);
 			report_prefix_pop();
 		}
 	}
-- 
2.44.0.278.ge034bb2e1d-goog


