Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C810578810
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiGRRGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbiGRRF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8152A2C13F
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q16so8039847pgq.6
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oOsWXe1XlE7Dvyt6YnaIl4l/lBbF3+FHoY2EVuHBogc=;
        b=yDEh3i7cvGOG1Tg6a3LH5g6p9IZ71ROXWiKkAcCBDzpRGIkynsCnDocSHaB+p5lMtJ
         un3KvvMO1rR4R6lnmasBC5U/GtKZCLfazzQczKJ460Swi58kGxQQGVKHHLwGSZmXg52d
         jAtF35upbVQffkVvkequyyH558IkEUcoc8q2Ta0kG9/goGLIh6PxPSMEhL/edqqRa/RU
         3SY6aBwkzzhR/2uFSpIH2LMHaADdwA9v2eYNcHXpv5YnJIYXvNJVnj53+Dslhe2tZold
         mCQD+57SYP0fEBMAGQSZHaskYwdskEPm0nGJwtL0AYAaeMlsu4wrXigjxkFByncTorSX
         Lt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oOsWXe1XlE7Dvyt6YnaIl4l/lBbF3+FHoY2EVuHBogc=;
        b=LAkhhN1NKjYsANfzXIu2hSedPpPg6s+wxuvH5BuK9wcgbf3lwNp/SSR9wcDSPhY3/o
         VbBPZCV6LC34HbJrodYawkmRNScl0fz6NNJssF2WrA4n2MU2n70MnQOQMdEbPXGa4Aez
         jc1vsdHDF7ppA8OJHI52OZOx3tG/nV62nwt28/STEQIuP6sqnq6gG+H8baWeXNJtGw91
         rk0eHmoahAAn3iIzZkCQSE+qLS05urjmr1AxaOmwxw/dgcVY/uIDz501Ha5gaI8dK6Mf
         IeOkPsdRX0JReS83InH9skKPne0PQPa0DKYI3vSsS7qNYULoEzUcIVMYLjcyeMCYC59O
         WkAQ==
X-Gm-Message-State: AJIora+h8nftEbezkds++xH/x0m0wZbrkUmhzIh2Ar7QzAlg26tm33GQ
        OPBi46i7dIncNXcHgomIOAJutg==
X-Google-Smtp-Source: AGRyM1u3Q+C0LQCywanESfw4GyKuwBIrIwjITjzR6A1JvgUVZ5Tnlck04W/lkZFWguLgJ06YyWcaMA==
X-Received: by 2002:a63:3101:0:b0:419:a4c7:649a with SMTP id x1-20020a633101000000b00419a4c7649amr23650792pgx.199.1658163954901;
        Mon, 18 Jul 2022 10:05:54 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:54 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC  9/9] RISC-V: KVM: Implement firmware events
Date:   Mon, 18 Jul 2022 10:02:05 -0700
Message-Id: <20220718170205.2972215-10-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718170205.2972215-1-atishp@rivosinc.com>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI PMU extension defines a set of firmware events which can provide
useful information to guests about number of SBI calls. As hypervisor
implements the SBI PMU extension, these firmware events corresponds
to ecall invocations between VS->HS mode. All other firmware events
will always report zero if monitored as KVM doesn't implement them.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 16 +++++
 arch/riscv/include/asm/sbi.h          |  2 +-
 arch/riscv/kvm/tlb.c                  |  6 +-
 arch/riscv/kvm/vcpu_pmu.c             | 90 +++++++++++++++++++++++----
 arch/riscv/kvm/vcpu_sbi_replace.c     |  7 +++
 5 files changed, 106 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 5410236b62a8..d68b17ea796b 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -15,6 +15,14 @@
 #ifdef CONFIG_RISCV_PMU_SBI
 #define RISCV_KVM_MAX_FW_CTRS 32
 
+struct kvm_fw_event {
+	/* Current value of the event */
+	unsigned long value;
+
+	/* Event monitoring status */
+	bool started;
+};
+
 /* Per virtual pmu counter data */
 struct kvm_pmc {
 	u8 idx;
@@ -22,11 +30,14 @@ struct kvm_pmc {
 	struct perf_event *perf_event;
 	uint64_t counter_val;
 	union sbi_pmu_ctr_info cinfo;
+	/* Monitoring event ID */
+	unsigned long event_idx;
 };
 
 /* PMU data structure per vcpu */
 struct kvm_pmu {
 	struct kvm_pmc pmc[RISCV_MAX_COUNTERS];
+	struct kvm_fw_event fw_event[RISCV_KVM_MAX_FW_CTRS];
 	/* Number of the virtual firmware counters available */
 	int num_fw_ctrs;
 	/* Number of the virtual hardware counters available */
@@ -48,6 +59,7 @@ struct kvm_pmu {
 { .base = CSR_CYCLE,      .count = 31, .func = kvm_riscv_vcpu_pmu_read_hpm },
 #endif
 
+int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid);
 int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 				unsigned long *val, unsigned long new_val,
 				unsigned long wr_mask);
@@ -75,6 +87,10 @@ struct kvm_pmu {
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
 { .base = 0,      .count = 0, .func = NULL },
 
+static inline int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
+{
+	return 0;
+}
 
 static inline int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 2a0ef738695e..a192a95a34eb 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -171,7 +171,7 @@ enum sbi_pmu_fw_generic_events_t {
 	SBI_PMU_FW_IPI_SENT		= 6,
 	SBI_PMU_FW_IPI_RECVD		= 7,
 	SBI_PMU_FW_FENCE_I_SENT		= 8,
-	SBI_PMU_FW_FENCE_I_RECVD	= 9,
+	SBI_PMU_FW_FENCE_I_RCVD		= 9,
 	SBI_PMU_FW_SFENCE_VMA_SENT	= 10,
 	SBI_PMU_FW_SFENCE_VMA_RCVD	= 11,
 	SBI_PMU_FW_SFENCE_VMA_ASID_SENT	= 12,
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index 1a76d0b1907d..0793d39e8ff7 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -240,6 +240,7 @@ void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
 
 void kvm_riscv_fence_i_process(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_RCVD);
 	local_flush_icache_all();
 }
 
@@ -323,15 +324,18 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vcpu)
 						d.addr, d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			kvm_riscv_local_hfence_vvma_asid_gva(
 						READ_ONCE(v->vmid), d.asid,
 						d.addr, d.size, d.order);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_ASID_ALL:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
 			kvm_riscv_local_hfence_vvma_asid_all(
 						READ_ONCE(v->vmid), d.asid);
 			break;
 		case KVM_RISCV_HFENCE_VVMA_GVA:
+			kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_RCVD);
 			kvm_riscv_local_hfence_vvma_gva(
 						READ_ONCE(v->vmid),
 						d.addr, d.size, d.order);
@@ -382,7 +386,7 @@ void kvm_riscv_fence_i(struct kvm *kvm,
 		       unsigned long hbase, unsigned long hmask)
 {
 	make_xfence_request(kvm, hbase, hmask, KVM_REQ_FENCE_I,
-			    KVM_REQ_FENCE_I, NULL);
+		    KVM_REQ_FENCE_I, NULL);
 }
 
 void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 278c261efad3..f451d7ac2608 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -168,21 +168,39 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
 	return pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
 }
 
+int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_fw_event *fevent;
+
+	if (!kvpmu || fid >= SBI_PMU_FW_MAX)
+		return -EINVAL;
+
+	fevent = &kvpmu->fw_event[fid];
+	if (fevent->started)
+		fevent->value++;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				unsigned long *out_val)
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	u64 enabled, running;
+	int fevent_code;
 
 	if (!kvpmu)
 		return -EINVAL;
 
 	pmc = &kvpmu->pmc[cidx];
-	if (!pmc->perf_event)
-		return -EINVAL;
 
-	pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
+	if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+		fevent_code = get_event_code(pmc->event_idx);
+		pmc->counter_val = kvpmu->fw_event[fevent_code].value;
+	} else if (pmc->perf_event)
+		pmc->counter_val += perf_event_read_value(pmc->perf_event, &enabled, &running);
 	*out_val = pmc->counter_val;
 
 	return 0;
@@ -237,6 +255,7 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	int i, num_ctrs, pmc_index;
 	struct kvm_pmc *pmc;
+	int fevent_code;
 
 	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
 	if (ctr_base + __fls(ctr_mask) >= num_ctrs)
@@ -250,7 +269,14 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		pmc = &kvpmu->pmc[pmc_index];
 		if (flag & SBI_PMU_START_FLAG_SET_INIT_VALUE)
 			pmc->counter_val = ival;
-		if (pmc->perf_event) {
+		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+			fevent_code = get_event_code(pmc->event_idx);
+			if (fevent_code >= SBI_PMU_FW_MAX)
+				return -EINVAL;
+
+			kvpmu->fw_event[fevent_code].started = true;
+			kvpmu->fw_event[fevent_code].value = pmc->counter_val;
+		} else if (pmc->perf_event) {
 			perf_event_period(pmc->perf_event, pmu_get_sample_period(pmc));
 			perf_event_enable(pmc->perf_event);
 		}
@@ -266,6 +292,7 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	int i, num_ctrs, pmc_index;
 	u64 enabled, running;
 	struct kvm_pmc *pmc;
+	int fevent_code;
 
 	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
 	if ((ctr_base + __fls(ctr_mask)) >= num_ctrs)
@@ -277,7 +304,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		if (!test_bit(pmc_index, kvpmu->used_pmc))
 			continue;
 		pmc = &kvpmu->pmc[pmc_index];
-		if (pmc->perf_event) {
+		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
+			fevent_code = get_event_code(pmc->event_idx);
+			if (fevent_code >= SBI_PMU_FW_MAX)
+				return -EINVAL;
+			kvpmu->fw_event[fevent_code].started = false;
+		} else if (pmc->perf_event) {
 			/* Stop counting the counter */
 			perf_event_disable(pmc->perf_event);
 			if (flag & SBI_PMU_STOP_FLAG_RESET) {
@@ -285,9 +317,12 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				pmc->counter_val += perf_event_read_value(pmc->perf_event,
 									  &enabled, &running);
 				pmu_release_perf_event(pmc);
-				clear_bit(pmc_index, kvpmu->used_pmc);
 			}
 		}
+		if (flag & SBI_PMU_STOP_FLAG_RESET) {
+			pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
+			clear_bit(pmc_index, kvpmu->used_pmc);
+		}
 	}
 
 	return 0;
@@ -303,14 +338,19 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 	int num_ctrs, ctr_idx;
 	u32 etype = pmu_get_perf_event_type(eidx);
 	u64 config;
-	struct kvm_pmc *pmc;
+	struct kvm_pmc *pmc = NULL;
+	bool is_fevent;
+	unsigned long event_code;
 
 	num_ctrs = kvpmu->num_fw_ctrs + kvpmu->num_hw_ctrs;
 	if ((etype == PERF_TYPE_MAX) || ((ctr_base + __fls(ctr_mask)) >= num_ctrs))
 		return -EINVAL;
 
-	if (pmu_is_fw_event(eidx))
+	event_code = get_event_code(eidx);
+	is_fevent = pmu_is_fw_event(eidx);
+	if (is_fevent && event_code >= SBI_PMU_FW_MAX)
 		return -EOPNOTSUPP;
+
 	/*
 	 * SKIP_MATCH flag indicates the caller is aware of the assigned counter
 	 * for this event. Just do a sanity check if it already marked used.
@@ -319,13 +359,23 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		if (!test_bit(ctr_base, kvpmu->used_pmc))
 			return -EINVAL;
 		ctr_idx = ctr_base;
-		goto match_done;
+		if (is_fevent)
+			goto perf_event_done;
+		else
+			goto match_done;
 	}
 
 	ctr_idx = pmu_get_pmc_index(kvpmu, eidx, ctr_base, ctr_mask);
 	if (ctr_idx < 0)
 		return -EOPNOTSUPP;
 
+	/*
+	 * No need to create perf events for firmware events as the firmware counter
+	 * is supposed to return the measurement of VS->HS mode invocations.
+	 */
+	if (is_fevent)
+		goto perf_event_done;
+
 match_done:
 	pmc = &kvpmu->pmc[ctr_idx];
 	pmu_release_perf_event(pmc);
@@ -363,17 +413,26 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(ctr_idx, kvpmu->used_pmc);
 	pmc->perf_event = event;
-	if (flag & SBI_PMU_CFG_FLAG_AUTO_START)
-		perf_event_enable(pmc->perf_event);
+perf_event_done:
+	if (flag & SBI_PMU_CFG_FLAG_AUTO_START) {
+		if (is_fevent)
+			kvpmu->fw_event[event_code].started = true;
+		else
+			perf_event_enable(pmc->perf_event);
+	}
+	/* This should be only true for firmware events */
+	if (!pmc)
+		pmc = &kvpmu->pmc[ctr_idx];
+	pmc->event_idx = eidx;
+	set_bit(ctr_idx, kvpmu->used_pmc);
 
 	return ctr_idx;
 }
 
 int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 {
-	int i = 0, num_hw_ctrs, num_fw_ctrs, hpm_width;
+	int i, num_hw_ctrs, num_fw_ctrs, hpm_width;
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 
@@ -395,6 +454,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 	bitmap_zero(kvpmu->used_pmc, RISCV_MAX_COUNTERS);
 	kvpmu->num_hw_ctrs = num_hw_ctrs;
 	kvpmu->num_fw_ctrs = num_fw_ctrs;
+	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
 	/*
 	 * There is no corelation betwen the logical hardware counter and virtual counters.
 	 * However, we need to encode a hpmcounter CSR in the counter info field so that
@@ -409,6 +469,7 @@ int kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 		pmc->idx = i;
 		pmc->counter_val = 0;
 		pmc->vcpu = vcpu;
+		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
 		if (i < kvpmu->num_hw_ctrs) {
 			kvpmu->pmc[i].cinfo.type = SBI_PMU_CTR_TYPE_HW;
 			if (i < 3)
@@ -444,7 +505,10 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
 	for_each_set_bit(i, kvpmu->used_pmc, RISCV_MAX_COUNTERS) {
 		pmc = &kvpmu->pmc[i];
 		pmu_release_perf_event(pmc);
+		pmc->counter_val = 0;
+		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
 	}
+	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
 }
 
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 4c034d8a606a..614ae127e102 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -12,6 +12,7 @@
 #include <asm/csr.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_pmu.h>
 #include <asm/kvm_vcpu_sbi.h>
 
 static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
@@ -25,6 +26,7 @@ static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (cp->a6 != SBI_EXT_TIME_SET_TIMER)
 		return -EINVAL;
 
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_SET_TIMER);
 #if __riscv_xlen == 32
 	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
 #else
@@ -55,6 +57,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (cp->a6 != SBI_EXT_IPI_SEND_IPI)
 		return -EINVAL;
 
+	kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_IPI_SENT);
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
 		if (hbase != -1UL) {
 			if (tmp->vcpu_id < hbase)
@@ -65,6 +68,7 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
 		if (ret < 0)
 			break;
+		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RECVD);
 	}
 
 	return ret;
@@ -89,6 +93,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 	switch (funcid) {
 	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
 		kvm_riscv_fence_i(vcpu->kvm, hbase, hmask);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
 		if (cp->a2 == 0 && cp->a3 == 0)
@@ -96,6 +101,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 		else
 			kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hmask,
 						  cp->a2, cp->a3, PAGE_SHIFT);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
 		if (cp->a2 == 0 && cp->a3 == 0)
@@ -106,6 +112,7 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
 						       hbase, hmask,
 						       cp->a2, cp->a3,
 						       PAGE_SHIFT, cp->a4);
+		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_HFENCE_VVMA_ASID_SENT);
 		break;
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
 	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
-- 
2.25.1

