Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AF6871B4
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 00:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjBAXNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 18:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjBAXNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 18:13:21 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47705C0E1
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 15:13:04 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id m13so57434plx.13
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 15:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VfO15ZHuuwZQlxpdy+WPV8DLLxXj3bF/DM6xSoz1I38=;
        b=Ss2HMkNsLHFGtCKZnh5yJetrKXLZ9fiN9fokOqwXcFtY1pnjcwL+tHsuAmfmFMxnKB
         IZR4xx1GU8agHdnKw4V3/k+RRmpUk15M/wENN0wEo7bUCe82YUmDME6/0skn3vICQP+4
         VzqheYrNe/Z/kOp36WCkofUK84CAS4KHbzheBZE2+hgoEO5utZfsFzf+WPEndOeZE0n7
         kvKu/XM+bBYF53mzYTRkZQxRXjBCaYzwriD6la6COKY7/ccD4mVFDX2oI4xlXCD6/Qxd
         Y8c3xWl3azTCJPMZrT0C7Y06S9VPsqBRbtmLwmg7UBNitnTM6o4St7pMDvW8Mbj13W4J
         iS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VfO15ZHuuwZQlxpdy+WPV8DLLxXj3bF/DM6xSoz1I38=;
        b=5W0btg19PFdcQSn62HsXnRSZS/LrzYfRJP61s8wSWuS0+Wu3YbxYN0zzQ9kSWy9xDW
         Sk6yCJwpN3JLnQ8jO29Qp5ou/f9Hb7JkgSDsIRWZ+hqf5URp7K2o7jbtTjD4GfqLg9c+
         aMsaHCOWYNMYuiOj9XQBHBPRvQUva/ajtQVaieFdx+jb/oz8usSXk7dgGy4AGtkfQqoN
         D0T5X9r97eZHkQ+iqcA0/56FNtVM51I3fhb3WmN1OLlEobkAN9JBAwshwCnJytBx7J2B
         ryt0YBHfyT7LXjUZ26WSyqt0xErOwpfn5Gng0/3qKLT7tfFt/DaE+Ez6feIy0boX8fRj
         Mdug==
X-Gm-Message-State: AO0yUKUD9iZvKHcovikwPLtpYy0wsBnP1bA0nBUUjqEj20vfxTetdaPT
        WjdzhJ/Zv6Rv4FCDAY2dkbx2+A==
X-Google-Smtp-Source: AK7set9dhF7OEHarz+bUdpymxmWfyXPW7DFWE1j3J9ZVi6IKvy9+cPBJPPq8yrr7cpqqC0BshLUfRQ==
X-Received: by 2002:a05:6a21:789b:b0:bc:f189:505d with SMTP id bf27-20020a056a21789b00b000bcf189505dmr5696598pzc.48.1675293184005;
        Wed, 01 Feb 2023 15:13:04 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a510300b0022bf0b0e1b7sm1861774pjh.10.2023.02.01.15.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 15:13:03 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        Eric Lin <eric.lin@sifive.com>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v4 12/14] RISC-V: KVM: Implement perf support without sampling
Date:   Wed,  1 Feb 2023 15:12:48 -0800
Message-Id: <20230201231250.3806412-13-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201231250.3806412-1-atishp@rivosinc.com>
References: <20230201231250.3806412-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RISC-V SBI PMU & Sscofpmf ISA extension allows supporting perf in
the virtualization enviornment as well. KVM implementation
relies on SBI PMU extension for the most part while trapping
& emulating the CSRs read for counter access.

This patch doesn't have the event sampling support yet.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 360 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 356 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 6fa0065..473ad80 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -12,10 +12,189 @@
 #include <linux/perf/riscv_pmu.h>
 #include <asm/csr.h>
 #include <asm/kvm_vcpu_sbi.h>
+#include <asm/bitops.h>
 #include <asm/kvm_vcpu_pmu.h>
 #include <linux/kvm_host.h>
 
 #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
+#define get_event_type(x) (((x) & SBI_PMU_EVENT_IDX_TYPE_MASK) >> 16)
+#define get_event_code(x) ((x) & SBI_PMU_EVENT_IDX_CODE_MASK)
+
+static enum perf_hw_id hw_event_perf_map[SBI_PMU_HW_GENERAL_MAX] = {
+	[SBI_PMU_HW_CPU_CYCLES] = PERF_COUNT_HW_CPU_CYCLES,
+	[SBI_PMU_HW_INSTRUCTIONS] = PERF_COUNT_HW_INSTRUCTIONS,
+	[SBI_PMU_HW_CACHE_REFERENCES] = PERF_COUNT_HW_CACHE_REFERENCES,
+	[SBI_PMU_HW_CACHE_MISSES] = PERF_COUNT_HW_CACHE_MISSES,
+	[SBI_PMU_HW_BRANCH_INSTRUCTIONS] = PERF_COUNT_HW_BRANCH_INSTRUCTIONS,
+	[SBI_PMU_HW_BRANCH_MISSES] = PERF_COUNT_HW_BRANCH_MISSES,
+	[SBI_PMU_HW_BUS_CYCLES] = PERF_COUNT_HW_BUS_CYCLES,
+	[SBI_PMU_HW_STALLED_CYCLES_FRONTEND] = PERF_COUNT_HW_STALLED_CYCLES_FRONTEND,
+	[SBI_PMU_HW_STALLED_CYCLES_BACKEND] = PERF_COUNT_HW_STALLED_CYCLES_BACKEND,
+	[SBI_PMU_HW_REF_CPU_CYCLES] = PERF_COUNT_HW_REF_CPU_CYCLES,
+};
+
+static u64 kvm_pmu_get_sample_period(struct kvm_pmc *pmc)
+{
+	u64 counter_val_mask = GENMASK(pmc->cinfo.width, 0);
+	u64 sample_period;
+
+	if (!pmc->counter_val)
+		sample_period = counter_val_mask + 1;
+	else
+		sample_period = (-pmc->counter_val) & counter_val_mask;
+
+	return sample_period;
+}
+
+static u32 kvm_pmu_get_perf_event_type(unsigned long eidx)
+{
+	enum sbi_pmu_event_type etype = get_event_type(eidx);
+	u32 type = PERF_TYPE_MAX;
+
+	switch (etype) {
+	case SBI_PMU_EVENT_TYPE_HW:
+		type = PERF_TYPE_HARDWARE;
+		break;
+	case SBI_PMU_EVENT_TYPE_CACHE:
+		type = PERF_TYPE_HW_CACHE;
+		break;
+	case SBI_PMU_EVENT_TYPE_RAW:
+	case SBI_PMU_EVENT_TYPE_FW:
+		type = PERF_TYPE_RAW;
+		break;
+	default:
+		break;
+	}
+
+	return type;
+}
+
+static bool kvm_pmu_is_fw_event(unsigned long eidx)
+{
+	return get_event_type(eidx) == SBI_PMU_EVENT_TYPE_FW;
+}
+
+static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		perf_event_disable(pmc->perf_event);
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+	}
+}
+
+static u64 kvm_pmu_get_perf_event_hw_config(u32 sbi_event_code)
+{
+	return hw_event_perf_map[sbi_event_code];
+}
+
+static u64 kvm_pmu_get_perf_event_cache_config(u32 sbi_event_code)
+{
+	u64 config = U64_MAX;
+	unsigned int cache_type, cache_op, cache_result;
+
+	/* All the cache event masks lie within 0xFF. No separate masking is necessary */
+	cache_type = (sbi_event_code & SBI_PMU_EVENT_CACHE_ID_CODE_MASK) >>
+		      SBI_PMU_EVENT_CACHE_ID_SHIFT;
+	cache_op = (sbi_event_code & SBI_PMU_EVENT_CACHE_OP_ID_CODE_MASK) >>
+		    SBI_PMU_EVENT_CACHE_OP_SHIFT;
+	cache_result = sbi_event_code & SBI_PMU_EVENT_CACHE_RESULT_ID_CODE_MASK;
+
+	if (cache_type >= PERF_COUNT_HW_CACHE_MAX ||
+	    cache_op >= PERF_COUNT_HW_CACHE_OP_MAX ||
+	    cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
+		return config;
+
+	config = cache_type | (cache_op << 8) | (cache_result << 16);
+
+	return config;
+}
+
+static u64 kvm_pmu_get_perf_event_config(unsigned long eidx, uint64_t evt_data)
+{
+	enum sbi_pmu_event_type etype = get_event_type(eidx);
+	u32 ecode = get_event_code(eidx);
+	u64 config = U64_MAX;
+
+	switch (etype) {
+	case SBI_PMU_EVENT_TYPE_HW:
+		if (ecode < SBI_PMU_HW_GENERAL_MAX)
+			config = kvm_pmu_get_perf_event_hw_config(ecode);
+		break;
+	case SBI_PMU_EVENT_TYPE_CACHE:
+		config = kvm_pmu_get_perf_event_cache_config(ecode);
+		break;
+	case SBI_PMU_EVENT_TYPE_RAW:
+		config = evt_data & RISCV_PMU_RAW_EVENT_MASK;
+		break;
+	case SBI_PMU_EVENT_TYPE_FW:
+		if (ecode < SBI_PMU_FW_MAX)
+			config = (1ULL << 63) | ecode;
+		break;
+	default:
+		break;
+	}
+
+	return config;
+}
+
+static int kvm_pmu_get_fixed_pmc_index(unsigned long eidx)
+{
+	u32 etype = kvm_pmu_get_perf_event_type(eidx);
+	u32 ecode = get_event_code(eidx);
+
+	if (etype != SBI_PMU_EVENT_TYPE_HW)
+		return -EINVAL;
+
+	if (ecode == SBI_PMU_HW_CPU_CYCLES)
+		return 0;
+	else if (ecode == SBI_PMU_HW_INSTRUCTIONS)
+		return 2;
+	else
+		return -EINVAL;
+}
+
+static int kvm_pmu_get_programmable_pmc_index(struct kvm_pmu *kvpmu, unsigned long eidx,
+					  unsigned long cbase, unsigned long cmask)
+{
+	int ctr_idx = -1;
+	int i, pmc_idx;
+	int min, max;
+
+	if (kvm_pmu_is_fw_event(eidx)) {
+		/* Firmware counters are mapped 1:1 starting from num_hw_ctrs for simplicity */
+		min = kvpmu->num_hw_ctrs;
+		max = min + kvpmu->num_fw_ctrs;
+	} else {
+		/* First 3 counters are reserved for fixed counters */
+		min = 3;
+		max = kvpmu->num_hw_ctrs;
+	}
+
+	for_each_set_bit(i, &cmask, BITS_PER_LONG) {
+		pmc_idx = i + cbase;
+		if ((pmc_idx >= min && pmc_idx < max) &&
+		    !test_bit(pmc_idx, kvpmu->pmc_in_use)) {
+			ctr_idx = pmc_idx;
+			break;
+		}
+	}
+
+	return ctr_idx;
+}
+
+static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
+			     unsigned long cbase, unsigned long cmask)
+{
+	int ret;
+
+	/* Fixed counters need to be have fixed mapping as they have different width */
+	ret = kvm_pmu_get_fixed_pmc_index(eidx);
+	if (ret >= 0)
+		return ret;
+
+	return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
+}
 
 static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 			unsigned long *out_val)
@@ -34,6 +213,16 @@ static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 	return 0;
 }
 
+static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ctr_base,
+					 unsigned long ctr_mask)
+{
+	/* Make sure the we have a valid counter mask requested from the caller */
+	if (!ctr_mask || (ctr_base + __fls(ctr_mask) >= kvm_pmu_num_counters(kvpmu)))
+		return -EINVAL;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long *val, unsigned long new_val,
 				unsigned long wr_mask)
@@ -97,7 +286,39 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				 unsigned long ctr_mask, unsigned long flag, uint64_t ival,
 				 struct kvm_vcpu_sbi_return *retdata)
 {
-	/* TODO */
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	int i, pmc_index, sbiret = 0;
+	struct kvm_pmc *pmc;
+
+	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+		sbiret = SBI_ERR_INVALID_PARAM;
+		goto out;
+	}
+
+	/* Start the counters that have been configured and requested by the guest */
+	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
+		pmc_index = i + ctr_base;
+		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
+			continue;
+		pmc = &kvpmu->pmc[pmc_index];
+		if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
+			pmc->counter_val = ival;
+		if (pmc->perf_event) {
+			if (unlikely(pmc->started)) {
+				sbiret = SBI_ERR_ALREADY_STARTED;
+				continue;
+			}
+			perf_event_period(pmc->perf_event, kvm_pmu_get_sample_period(pmc));
+			perf_event_enable(pmc->perf_event);
+			pmc->started = true;
+		} else {
+			sbiret = SBI_ERR_INVALID_PARAM;
+		}
+	}
+
+out:
+	retdata->err_val = sbiret;
+
 	return 0;
 }
 
@@ -105,7 +326,45 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				unsigned long ctr_mask, unsigned long flag,
 				struct kvm_vcpu_sbi_return *retdata)
 {
-	/* TODO */
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	int i, pmc_index, sbiret = 0;
+	u64 enabled, running;
+	struct kvm_pmc *pmc;
+
+	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+		sbiret = SBI_ERR_INVALID_PARAM;
+		goto out;
+	}
+
+	/* Stop the counters that have been configured and requested by the guest */
+	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
+		pmc_index = i + ctr_base;
+		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
+			continue;
+		pmc = &kvpmu->pmc[pmc_index];
+		if (pmc->perf_event) {
+			if (pmc->started) {
+				/* Stop counting the counter */
+				perf_event_disable(pmc->perf_event);
+				pmc->started = false;
+			} else
+				sbiret = SBI_ERR_ALREADY_STOPPED;
+
+			if (flag & SBI_PMU_STOP_FLAG_RESET) {
+				/* Relase the counter if this is a reset request */
+				pmc->counter_val += perf_event_read_value(pmc->perf_event,
+									  &enabled, &running);
+				kvm_pmu_release_perf_event(pmc);
+				clear_bit(pmc_index, kvpmu->pmc_in_use);
+			}
+		} else {
+			sbiret = SBI_ERR_INVALID_PARAM;
+		}
+	}
+
+out:
+	retdata->err_val = sbiret;
+
 	return 0;
 }
 
@@ -114,7 +373,88 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     unsigned long eidx, uint64_t evtdata,
 				     struct kvm_vcpu_sbi_return *retdata)
 {
-	/* TODO */
+	int ctr_idx, sbiret = 0;
+	u64 config;
+	u32 etype = kvm_pmu_get_perf_event_type(eidx);
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct perf_event *event;
+	struct kvm_pmc *pmc;
+	struct perf_event_attr attr = {
+		.type = etype,
+		.size = sizeof(struct perf_event_attr),
+		.pinned = true,
+		/*
+		 * It should never reach here if the platform doesn't support the sscofpmf
+		 * extension as mode filtering won't work without it.
+		 */
+		.exclude_host = true,
+		.exclude_hv = true,
+		.exclude_user = !!(flag & SBI_PMU_CFG_FLAG_SET_UINH),
+		.exclude_kernel = !!(flag & SBI_PMU_CFG_FLAG_SET_SINH),
+		.config1 = RISCV_PMU_CONFIG1_GUEST_EVENTS,
+	};
+
+	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+		sbiret = SBI_ERR_INVALID_PARAM;
+		goto out;
+	}
+
+	if (kvm_pmu_is_fw_event(eidx)) {
+		sbiret = SBI_ERR_NOT_SUPPORTED;
+		goto out;
+	}
+
+	/*
+	 * SKIP_MATCH flag indicates the caller is aware of the assigned counter
+	 * for this event. Just do a sanity check if it already marked used.
+	 */
+	if (flag & SBI_PMU_CFG_FLAG_SKIP_MATCH) {
+		if (!test_bit(ctr_base + __ffs(ctr_mask), kvpmu->pmc_in_use)) {
+			sbiret = SBI_ERR_FAILURE;
+			goto out;
+		}
+		ctr_idx = ctr_base + __ffs(ctr_mask);
+	} else  {
+
+		ctr_idx = pmu_get_pmc_index(kvpmu, eidx, ctr_base, ctr_mask);
+		if (ctr_idx < 0) {
+			sbiret = SBI_ERR_NOT_SUPPORTED;
+			goto out;
+		}
+	}
+
+	pmc = &kvpmu->pmc[ctr_idx];
+	kvm_pmu_release_perf_event(pmc);
+	pmc->idx = ctr_idx;
+
+	config = kvm_pmu_get_perf_event_config(eidx, evtdata);
+	attr.config = config;
+	if (flag & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
+		//TODO: Do we really want to clear the value in hardware counter
+		pmc->counter_val = 0;
+	}
+
+	/*
+	 * Set the default sample_period for now. The guest specified value
+	 * will be updated in the start call.
+	 */
+	attr.sample_period = kvm_pmu_get_sample_period(pmc);
+
+	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
+	if (IS_ERR(event)) {
+		pr_err("kvm pmu event creation failed for eidx %lx: %ld\n", eidx, PTR_ERR(event));
+		return PTR_ERR(event);
+	}
+
+	set_bit(ctr_idx, kvpmu->pmc_in_use);
+	pmc->perf_event = event;
+	if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
+		perf_event_enable(pmc->perf_event);
+
+	retdata->out_val = ctr_idx;
+out:
+	retdata->err_val = sbiret;
+
 	return 0;
 }
 
@@ -192,7 +532,19 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 
 void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
 {
-	/* TODO */
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	if (!kvpmu)
+		return;
+
+	for_each_set_bit(i, kvpmu->pmc_in_use, RISCV_MAX_COUNTERS) {
+		pmc = &kvpmu->pmc[i];
+		pmc->counter_val = 0;
+		kvm_pmu_release_perf_event(pmc);
+	}
+	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
 }
 
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
-- 
2.25.1

