Return-Path: <kvm+bounces-3442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7DB804540
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7D471C20B11
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C4AD263;
	Tue,  5 Dec 2023 02:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0mCh4PiV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0523D42
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:43:44 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6d99c3bcf7cso1337557a34.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701744224; x=1702349024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzz5g7ES5nKjgwbjahh46Km+H+w1xHmv8nQyMYp7oKE=;
        b=0mCh4PiVmWf/ZblXlt5Jjpb+P4H16ONZOhWp8rT4jI9wRmrPCZM1iwogbxLRVXfSNq
         3xEpIhLigoTSjt91z6gVdn16kUpOpx97YrCB955BeUNk4PbBwRx6U+kJK1q0eqTyaBk9
         bbW8wp+ubUDsHVoopRXDGkS1DZfUaFu6PfR/5kMOseMogZVXfAQkyRvY1btSy/6/nuax
         +ac2QKVAx7vqRj4sUJ63ydl29/ossHsP8sNv7IqQgPOfY/UfFKlJOgctj/NsaCqpDfBt
         MANH1beJ3Q4GspJexV4YV+YvcEDJc7hY2+RFReVXwgM1AdyI9x9P4wu1K7nreqZee5b/
         gCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701744224; x=1702349024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lzz5g7ES5nKjgwbjahh46Km+H+w1xHmv8nQyMYp7oKE=;
        b=PRaS/fvX3BrTYoVhfGbBxyE1dZbdMaKMlrAsY5VxskzSzagrfhvDp3J3Q235maQbsh
         iadHZXd82Hrnkhv4jaWT90KDbvx4AuuRpSFTaPE7ZPcxpAW0TjSKzFta0Y+ScBw8q9Dc
         QQBIz2T0bV8ETNNRUOxQQPEtdrRaTMyFaS6h/DUYX60VZSbbcWSihxH9U6iaOqSijSKt
         0F1tgHbOBfe6bqh499JpQYXr1sgKVB8VzWGDyW2921fEN2Og7zKsmbKYRWkqrUOUWAih
         ZHQeZ6df57+GnpCVARPnMCMjDExSGRwAO+JPPFAJB+1iT8RSGvMJl7XNwRBxCKaOwpmS
         gv2w==
X-Gm-Message-State: AOJu0YyaUGWnPiTN5Q1IaR1aZkqYZWqDvJql3l3CW88ypL/Grshquh/s
	ved2SB3ZaVUZdfgERzvPO/POIw==
X-Google-Smtp-Source: AGHT+IHAmPQMffRLEjxogkRBgQxGjgGKbV3BI9MZCuyp69gtTWruQBhsw7cE61+U8EFJPv8+v2izAg==
X-Received: by 2002:a05:6830:7185:b0:6d8:1c4b:6c0e with SMTP id el5-20020a056830718500b006d81c4b6c0emr7813977otb.9.1701744223937;
        Mon, 04 Dec 2023 18:43:43 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b006b9848f8aa7sm2157655otk.45.2023.12.04.18.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 18:43:43 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
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
Subject: [RFC 7/9] RISC-V: KVM: Implement SBI PMU Snapshot feature
Date: Mon,  4 Dec 2023 18:43:08 -0800
Message-Id: <20231205024310.1593100-8-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231205024310.1593100-1-atishp@rivosinc.com>
References: <20231205024310.1593100-1-atishp@rivosinc.com>
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
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  10 ++
 arch/riscv/kvm/vcpu_pmu.c             | 129 ++++++++++++++++++++++++--
 arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
 3 files changed, 134 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 395518a1664e..64c75acad6ba 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -36,6 +36,7 @@ struct kvm_pmc {
 	bool started;
 	/* Monitoring event ID */
 	unsigned long event_idx;
+	struct kvm_vcpu *vcpu;
 };
 
 /* PMU data structure per vcpu */
@@ -50,6 +51,12 @@ struct kvm_pmu {
 	bool init_done;
 	/* Bit map of all the virtual counter used */
 	DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
+	/* Bit map of all the virtual counter overflown */
+	DECLARE_BITMAP(pmc_overflown, RISCV_KVM_MAX_COUNTERS);
+	/* The address of the counter snapshot area (guest physical address) */
+	unsigned long snapshot_addr;
+	/* The actual data of the snapshot */
+	struct riscv_pmu_snapshot_data *sdata;
 };
 
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
@@ -85,6 +92,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata);
 void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned long saddr_low,
+				       unsigned long saddr_high, unsigned long flags,
+				       struct kvm_vcpu_sbi_return *retdata);
 void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86391a5061dd..622c4ee89e7b 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -310,6 +310,79 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
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
+#ifdef CONFIG_32BIT
+		saddr |= ((gpa_t)saddr << 32);
+#else
+		sbiret = SBI_ERR_INVALID_ADDRESS;
+		goto out;
+#endif
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
+out:
+	retdata->err_val = sbiret;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_num_ctrs(struct kvm_vcpu *vcpu,
 				struct kvm_vcpu_sbi_return *retdata)
 {
@@ -343,8 +416,10 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	int i, pmc_index, sbiret = 0;
 	struct kvm_pmc *pmc;
 	int fevent_code;
+	bool bSnapshot = flags & SBI_PMU_START_FLAG_INIT_FROM_SNAPSHOT;
 
-	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+	if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) ||
+	    (bSnapshot && kvpmu->snapshot_addr == INVALID_GPA)) {
 		sbiret = SBI_ERR_INVALID_PARAM;
 		goto out;
 	}
@@ -355,8 +430,14 @@ int kvm_riscv_vcpu_pmu_ctr_start(struct kvm_vcpu *vcpu, unsigned long ctr_base,
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
@@ -400,8 +481,10 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 	u64 enabled, running;
 	struct kvm_pmc *pmc;
 	int fevent_code;
+	bool bSnapshot = flags & SBI_PMU_STOP_FLAG_TAKE_SNAPSHOT;
 
-	if (kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) {
+	if ((kvm_pmu_validate_counter_mask(kvpmu, ctr_base, ctr_mask) < 0) ||
+	    (bSnapshot && (kvpmu->snapshot_addr == INVALID_GPA))) {
 		sbiret = SBI_ERR_INVALID_PARAM;
 		goto out;
 	}
@@ -423,27 +506,52 @@ int kvm_riscv_vcpu_pmu_ctr_stop(struct kvm_vcpu *vcpu, unsigned long ctr_base,
 				sbiret = SBI_ERR_ALREADY_STOPPED;
 
 			kvpmu->fw_event[fevent_code].started = false;
+			/* No need to increment the value as it is absolute for firmware events */
+			pmc->counter_val = kvpmu->fw_event[fevent_code].value;
 		} else if (pmc->perf_event) {
 			if (pmc->started) {
 				/* Stop counting the counter */
 				perf_event_disable(pmc->perf_event);
-				pmc->started = false;
 			} else {
 				sbiret = SBI_ERR_ALREADY_STOPPED;
 			}
 
-			if (flags & SBI_PMU_STOP_FLAG_RESET) {
-				/* Relase the counter if this is a reset request */
+			/* Stop counting the counter */
+			perf_event_disable(pmc->perf_event);
+
+			/* We only update if stopped is already called. The caller may stop/reset
+			 * the event in two steps.
+			 */
+			if (pmc->started) {
 				pmc->counter_val += perf_event_read_value(pmc->perf_event,
 									  &enabled, &running);
+				pmc->started = false;
+			}
+
+			if (flags & SBI_PMU_STOP_FLAG_RESET) {
+				/* Relase the counter if this is a reset request */
 				kvm_pmu_release_perf_event(pmc);
 			}
 		} else {
 			sbiret = SBI_ERR_INVALID_PARAM;
 		}
+
+		if (bSnapshot && !sbiret) {
+			//TODO: Add counter overflow support when sscofpmf support is added
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
 
@@ -517,8 +625,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 			kvpmu->fw_event[event_code].started = true;
 	} else {
 		ret = kvm_pmu_create_perf_event(pmc, &attr, flags, eidx, evtdata);
-		if (ret)
-			return ret;
+		if (ret) {
+			sbiret = SBI_ERR_NOT_SUPPORTED;
+			goto out;
+		}
 	}
 
 	set_bit(ctr_idx, kvpmu->pmc_in_use);
@@ -566,6 +676,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 	kvpmu->num_hw_ctrs = num_hw_ctrs + 1;
 	kvpmu->num_fw_ctrs = SBI_PMU_FW_MAX;
 	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
+	kvpmu->snapshot_addr = INVALID_GPA;
 
 	if (kvpmu->num_hw_ctrs > RISCV_KVM_MAX_HW_CTRS) {
 		pr_warn_once("Limiting the hardware counters to 32 as specified by the ISA");
@@ -585,6 +696,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 		pmc = &kvpmu->pmc[i];
 		pmc->idx = i;
 		pmc->event_idx = SBI_PMU_EVENT_IDX_INVALID;
+		pmc->vcpu = vcpu;
 		if (i < kvpmu->num_hw_ctrs) {
 			pmc->cinfo.type = SBI_PMU_CTR_TYPE_HW;
 			if (i < 3)
@@ -625,6 +737,7 @@ void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu)
 	}
 	bitmap_zero(kvpmu->pmc_in_use, RISCV_MAX_COUNTERS);
 	memset(&kvpmu->fw_event, 0, SBI_PMU_FW_MAX * sizeof(struct kvm_fw_event));
+	kvpmu->snapshot_addr = INVALID_GPA;
 }
 
 void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index 7eca72df2cbd..77c20a61fd7d 100644
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


