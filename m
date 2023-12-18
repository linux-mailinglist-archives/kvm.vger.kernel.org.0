Return-Path: <kvm+bounces-4713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7291D816B60
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 11:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 979CF1C22723
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 10:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A51B2031E;
	Mon, 18 Dec 2023 10:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="cgCmj+91"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3461C6AF
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 10:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-59067f03282so2197381eaf.0
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 02:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702896090; x=1703500890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgb/+xwwLSFVgGdjAawvSKpDGzd75L7sXtCvA5wETh8=;
        b=cgCmj+91r6J4T4DJ455I8eb4DIKLuVGssVPfErNsu054cZG9TfTvG4Ud2LX8W6X9HS
         saMbmY2nJU/JFr6Q7ysEEFpWrcSZfMXag0Pfq4I1XB7eNNphjFCBdUYSPOznbGno2qs/
         AQUN58oJfqeLSIvl4vOtU0I7esSUfdopbcbXuipzcxUceNUlvBJ5XnJSh7ruV9qYXftA
         3QrqsQCXq90/6VUuO0uiBBBwX577/brzGQYJwIrIp/AZLsPmd3TeR3QAbVV6tyzjsUsF
         4hZ4gfVOQb5AD03OB5DAvZRoe1RP+jPKaZQ3OjjOLY2Xa41wImiVry4qdZKOyUl8UUgi
         noyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702896090; x=1703500890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgb/+xwwLSFVgGdjAawvSKpDGzd75L7sXtCvA5wETh8=;
        b=HI0DeX/THqG1tVOxnI1gG2uivrA1po+hYOpzIYuu4eofcAATVJAYGNNuHarulmk8V8
         CAKWGjL5B9RuEept/+P+wdFMc4gPdjK5UtkATBHwOtAezz3Pw0fmw4Pp9DTiIUQdriGr
         r0ks+X3Prkv6tneHFarLrs47P1bCzjdYvR7kvFwSyeFuJisa2Y5Z5uXAFwTFi9K1QfBy
         tGA61bdzn6fmH6G18540XlXSx8QpA2YJGcjr2StX9jLFXLSnSN/Wo40BV1TGIEY0raJs
         /VgiG1UetO81tuMV4y8qoMjaHMZk8zS2fwqKkhSoNch6aeq7WvqzrqAT+OXzBFgrbNTE
         QwLg==
X-Gm-Message-State: AOJu0Yy3wDkrrq9kkGj6uKUgGUTX8Pik9xY+QnuUMxyKS0jLW5jbRd5v
	HZOLk5XNisUwMrdOiw7tsYG7Zw==
X-Google-Smtp-Source: AGHT+IGMDctPe079Dztmo0kNt2pasE8nxtHFuYPolKJ1kYuuGQ5wsJA8uYjaglZAco3oBvKpiElwNQ==
X-Received: by 2002:a4a:9883:0:b0:591:5457:ff42 with SMTP id a3-20020a4a9883000000b005915457ff42mr4153622ooj.7.1702896090234;
        Mon, 18 Dec 2023 02:41:30 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 185-20020a4a1ac2000000b005907ad9f302sm574970oof.37.2023.12.18.02.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 02:41:29 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Guo Ren <guoren@kernel.org>,
	Icenowy Zheng <uwu@icenowy.me>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Will Deacon <will@kernel.org>
Subject: [v1 08/10] RISC-V: KVM: Implement SBI PMU Snapshot feature
Date: Mon, 18 Dec 2023 02:41:05 -0800
Message-Id: <20231218104107.2976925-9-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218104107.2976925-1-atishp@rivosinc.com>
References: <20231218104107.2976925-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PMU Snapshot function allows to minimize the number of traps when the
guest access configures/access the hpmcounters. If the snapshot feature
is enabled, the hypervisor updates the shared memory with counter
data and state of overflown counters. The guest can just read the
shared memory instead of trap & emulate done by the hypervisor.

This patch doesn't implement the counter overflow yet.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h |   9 ++
 arch/riscv/kvm/aia.c                  |   5 ++
 arch/riscv/kvm/vcpu_onereg.c          |   7 +-
 arch/riscv/kvm/vcpu_pmu.c             | 120 +++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 5 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 395518a1664e..5e6fc9ac2b90 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -50,6 +50,12 @@ struct kvm_pmu {
 	bool init_done;
 	/* Bit map of all the virtual counter used */
 	DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
+	/* Bit map of all the virtual counter overflown */
+	DECLARE_BITMAP(pmc_overflown, RISCV_KVM_MAX_COUNTERS);
+	/* The address of the counter snapshot area (guest physical address) */
+	gpa_t snapshot_addr;
+	/* The actual data of the snapshot */
+	struct riscv_pmu_snapshot_data *sdata;
 };
 
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
@@ -85,6 +91,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata);
 void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				       unsigned long saddr_high, unsigned long flags,
+				       struct kvm_vcpu_sbi_return *retdata);
 void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index a944294f6f23..71d161d7430d 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -545,6 +545,9 @@ void kvm_riscv_aia_enable(void)
 	enable_percpu_irq(hgei_parent_irq,
 			  irq_get_trigger_type(hgei_parent_irq));
 	csr_set(CSR_HIE, BIT(IRQ_S_GEXT));
+	/* Enable IRQ filtering for overflow interrupt only if sscofpmf is present */
+	if (__riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSCOFPMF))
+		csr_write(CSR_HVIEN, BIT(IRQ_PMU_OVF));
 }
 
 void kvm_riscv_aia_disable(void)
@@ -560,6 +563,8 @@ void kvm_riscv_aia_disable(void)
 
 	/* Disable per-CPU SGEI interrupt */
 	csr_clear(CSR_HIE, BIT(IRQ_S_GEXT));
+	if (__riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSCOFPMF))
+		csr_clear(CSR_HVIEN, BIT(IRQ_PMU_OVF));
 	disable_percpu_irq(hgei_parent_irq);
 
 	aia_set_hvictl(false);
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f8c9fa0c03c5..855d12b6a4a5 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -117,8 +117,13 @@ void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu)
 	for (i = 0; i < ARRAY_SIZE(kvm_isa_ext_arr); i++) {
 		host_isa = kvm_isa_ext_arr[i];
 		if (__riscv_isa_extension_available(NULL, host_isa) &&
-		    kvm_riscv_vcpu_isa_enable_allowed(i))
+		    kvm_riscv_vcpu_isa_enable_allowed(i)) {
+			/* Sscofpmf depends on interrupt filtering defined in ssaia */
+			if (host_isa == RISCV_ISA_EXT_SSCOFPMF &&
+			    !__riscv_isa_extension_available(NULL, RISCV_ISA_EXT_SSAIA))
+				continue;
 			set_bit(host_isa, vcpu->arch.isa);
+		}
 	}
 }
 
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 08f561998611..a6e9c2132e24 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -311,6 +311,81 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
 	return ret;
 }
 
+static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
+
+	if (kvpmu->sdata) {
+		memset(kvpmu->sdata, 0, snapshot_area_size);
+		if (kvpmu->snapshot_addr != INVALID_GPA)
+			kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
+					     kvpmu->sdata, snapshot_area_size);
+		kfree(kvpmu->sdata);
+		kvpmu->sdata = NULL;
+	}
+	kvpmu->snapshot_addr = INVALID_GPA;
+}
+
+int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				      unsigned long saddr_high, unsigned long flags,
+				      struct kvm_vcpu_sbi_return *retdata)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
+	int sbiret = 0;
+	gpa_t saddr;
+	unsigned long hva;
+	bool writable;
+
+	if (!kvpmu) {
+		sbiret = SBI_ERR_INVALID_PARAM;
+		goto out;
+	}
+
+	if (saddr_low == -1 && saddr_high == -1) {
+		kvm_pmu_clear_snapshot_area(vcpu);
+		return 0;
+	}
+
+	saddr = saddr_low;
+
+	if (saddr_high != 0) {
+		if (IS_ENABLED(CONFIG_32BIT))
+			saddr |= ((gpa_t)saddr << 32);
+		else
+			sbiret = SBI_ERR_INVALID_ADDRESS;
+		goto out;
+	}
+
+	if (kvm_is_error_gpa(vcpu->kvm, saddr)) {
+		sbiret = SBI_ERR_INVALID_PARAM;
+		goto out;
+	}
+
+	hva = kvm_vcpu_gfn_to_hva_prot(vcpu, saddr >> PAGE_SHIFT, &writable);
+	if (kvm_is_error_hva(hva) || !writable) {
+		sbiret = SBI_ERR_INVALID_ADDRESS;
+		goto out;
+	}
+
+	kvpmu->snapshot_addr = saddr;
+	kvpmu->sdata = kzalloc(snapshot_area_size, GFP_ATOMIC);
+	if (!kvpmu->sdata)
+		return -ENOMEM;
+
+	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {
+		kfree(kvpmu->sdata);
+		kvpmu->snapshot_addr = INVALID_GPA;
+		sbiret = SBI_ERR_FAILURE;
+	}
+
+out:
+	retdata->err_val = sbiret;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
 				struct kvm_vcpu_sbi_return *retdata)
 {
@@ -344,20 +419,32 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	int i, pmc_index, sbiret = 0;
 	struct kvm_pmc *pmc;
 	int fevent_code;
+	bool bSnapshot = flags & SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
 
-	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+	if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0)) {
 		sbiret = SBI_ERR_INVALID_PARAM;
 		goto out;
 	}
 
+	if (bSnapshot && kvpmu->snapshot_addr == INVALID_GPA) {
+		sbiret = SBI_ERR_NO_SHMEM;
+		goto out;
+	}
+
 	/* Start the counters that have been configured and requested by the guest */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
 		pmc_index = i + ctr_base;
 		if (!test_bit(pmc_index, kvpmu->pmc_in_use))
 			continue;
 		pmc = &kvpmu->pmc[pmc_index];
-		if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE)
+		if (flags & SBI_PMU_START_FLAG_SET_INIT_VALUE) {
 			pmc->counter_val = ival;
+		} else if (bSnapshot) {
+			kvm_vcpu_read_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
+					    sizeof(struct riscv_pmu_snapshot_data));
+			pmc->counter_val = kvpmu->sdata->ctr_values[pmc_index];
+		}
+
 		if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW) {
 			fevent_code = get_event_code(pmc->event_idx);
 			if (fevent_code >= SBI_PMU_FW_MAX) {
@@ -401,12 +488,18 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
+	bool bSnapshot = flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
 
-	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+	if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0)) {
 		sbiret = SBI_ERR_INVALID_PARAM;
 		goto out;
 	}
 
+	if (bSnapshot && kvpmu->snapshot_addr == INVALID_GPA) {
+		sbiret = SBI_ERR_NO_SHMEM;
+		goto out;
+	}
+
 	/* Stop the counters that have been configured and requested by the guest */
 	for_each_set_bit(i, &ctr_mask, RISCV_MAX_COUNTERS) {
 		pmc_index = i + ctr_base;
@@ -439,9 +532,28 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 		} else {
 			sbiret = SBI_ERR_INVALID_PARAM;
 		}
+
+		if (bSnapshot && !sbiret) {
+			if (pmc->cinfo.type == SBI_PMU_CTR_TYPE_FW)
+				pmc->counter_val = kvpmu->fw_event[fevent_code].value;
+			else if (pmc->perf_event)
+				pmc->counter_val += perf_event_read_value(pmc->perf_event,
+									  &enabled, &running);
+			/* TODO: Add counter overflow support when sscofpmf support is added */
+			kvpmu->sdata->ctr_values[i] = pmc->counter_val;
+			kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
+					     sizeof(struct riscv_pmu_snapshot_data));
+		}
+
 		if (flags & SBI_PMU_STOP_FLAG_RESET) {
 			pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
 			clear_bit(pmc_index, kvpmu->pmc_in_use);
+			if (bSnapshot) {
+				/* Clear the snapshot area for the upcoming deletion event */
+				kvpmu->sdata->ctr_values[i] = 0;
+				kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr, kvpmu->sdata,
+						     sizeof(struct riscv_pmu_snapshot_data));
+			}
 		}
 	}
 
@@ -567,6 +679,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 	kvpmu->num_hw_ctrs = num_hw_ctrs + 1;
 	kvpmu->num_fw_ctrs = SBI_PMU_FW_MAX;
 	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
+	kvpmu->snapshot_addr = INVALID_GPA;
 
 	if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
 		pr_warn_once("Limiting the hardware counters to 32 as specified by the ISA");
@@ -626,6 +739,7 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
 	}
 	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
 	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
+	kvm_pmu_clear_snapshot_area(vcpu);
 }
 
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index b70179e9e875..9f61136e4bb1 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -64,6 +64,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case SBI_EXT_PMU_COUNTER_FW_READ:
 		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
 		break;
+	case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
+		ret = kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0, cp->a1, cp->a2, retdata);
+		break;
 	default:
 		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
 	}
-- 
2.34.1


