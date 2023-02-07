Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660F768D356
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 10:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbjBGJ4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 04:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbjBGJ4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 04:56:37 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A922A30EBC
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 01:56:33 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g13so10302472ple.10
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 01:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tz4B42PGLL8rSEQIFNlcBQdaaYEXw29m9v8KoNjY0mM=;
        b=LbZjQhmcW7WxY1PmkUSpeuLU4YUH+8oeud9ddraG+vJr3FVPq5ItykPltdynkGierc
         DowOubmo3vm41Tnt0ibJiIgBSkOv/5ZWbTplmfCAgOoqrbQxIuptqLzbKXxD2MQVNoZ9
         lKl/9+SMz9m6Wd18hx/b7O0IWItJm6myLpOatXWbl/2LzgtLmQ2KBsktzYBDI1jv6RYW
         RmqMvJ6kCTNIWShmOCoqVA2vROlfIUvJ/LVWH495Ue32nWC5EbR1gqGxIOL2qke5CD21
         zgoXguBBDB4lEQR1EmEev/h3yV9V66ANB2F3p4I4fplFhj/Z8AnjUrQ1JEO5a/pnPdlZ
         oLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tz4B42PGLL8rSEQIFNlcBQdaaYEXw29m9v8KoNjY0mM=;
        b=6Zuu/7VB6SqJF6t4d7JXU92U8R5hVdVLm1IN8/Uehgbbx/dWQlZ6t697OPEd/0rXTj
         24OjNI32r86UggyDbKI2c23fMnKpbngMYxYqiUCZ1eSxXHXkbCIdtYRmCF5PwVuB4wEO
         rx+YvstkRIOwMvBL0VtwQSD2DJfy2KyPqFK/qNJv5kB/5LO4Aol81uwMtgwT1jGc6l79
         IjNJXNSRm+VWkQa6QJJKLMAvltcBultdbu5rSn81cOIWukIfRdtD9SO0z3TMH1Sh02fi
         D1ubCef3viQcAS2qHj43vuol+jkWJ+Nnv2sygZYXFuTUZXiIA8vrRvC/pycAd6zLKSCM
         I1zg==
X-Gm-Message-State: AO0yUKUvHdP6N9DcUORfDD2n6a9xikNDUONA4TMec79Ukd2ExlOxJ9c8
        Me2gjPGx8Py+Uent5VE6jOwumQ==
X-Google-Smtp-Source: AK7set+NkYQ1upBmuIofdNvV9k3hCPb48VXDW57yBIEw3HRcDbNPDiz3lksuY4l0KYv/zI1YPtl5Gw==
X-Received: by 2002:a17:902:d08b:b0:196:3056:38f4 with SMTP id v11-20020a170902d08b00b00196305638f4mr1780364plv.50.1675763793145;
        Tue, 07 Feb 2023 01:56:33 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709027b8800b0019602b2c00csm4030598pll.175.2023.02.07.01.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 01:56:32 -0800 (PST)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>
Subject: [PATCH v6 6/8] RISC-V: KVM: Implement perf support without sampling
Date:   Tue,  7 Feb 2023 01:55:27 -0800
Message-Id: <20230207095529.1787260-7-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207095529.1787260-1-atishp@rivosinc.com>
References: <20230207095529.1787260-1-atishp@rivosinc.com>
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 360 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 356 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 51a0237..cb315af 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -13,9 +13,188 @@
 #include <asm/csr.h>
 #include <asm/kvm_vcpu_sbi.h>
 #include <asm/kvm_vcpu_pmu.h>
+#include <linux/bitops.h>
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
+					      unsigned long cbase, unsigned long cmask)
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
 				 unsigned long ctr_mask, unsigned long flags, u64 ival,
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
+		if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE)
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
 
@@ -105,7 +326,46 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				unsigned long ctr_mask, unsigned long flags,
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
+			} else {
+				sbiret = SBI_ERR_ALREADY_STOPPED;
+			}
+
+			if (flags & SBI_PMU_STOP_FLAG_RESET) {
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
 
@@ -114,7 +374,87 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     unsigned long eidx, u64 evtdata,
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
+		.exclude_user = !!(flags & SBI_PMU_CFG_FLAG_SET_UINH),
+		.exclude_kernel = !!(flags & SBI_PMU_CFG_FLAG_SET_SINH),
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
+	if (flags & SBI_PMU_CFG_FLAG_SKIP_MATCH) {
+		if (!test_bit(ctr_base + __ffs(ctr_mask), kvpmu->pmc_in_use)) {
+			sbiret = SBI_ERR_FAILURE;
+			goto out;
+		}
+		ctr_idx = ctr_base + __ffs(ctr_mask);
+	} else  {
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
+	if (flags & SBI_PMU_CFG_FLAG_CLEAR_VALUE) {
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
+	if (flags & SBI_PMU_CFG_FLAG_AUTO_START)
+		perf_event_enable(pmc->perf_event);
+
+	retdata->out_val = ctr_idx;
+out:
+	retdata->err_val = sbiret;
+
 	return 0;
 }
 
@@ -194,7 +534,19 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 
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

