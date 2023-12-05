Return-Path: <kvm+bounces-3444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AC31804542
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05A7B281414
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19444D2E9;
	Tue,  5 Dec 2023 02:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="V4V0HHwF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2B810C7
	for <kvm@vger.kernel.org>; Mon,  4 Dec 2023 18:43:48 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6d81faeefc4so2951524a34.2
        for <kvm@vger.kernel.org>; Mon, 04 Dec 2023 18:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1701744228; x=1702349028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7KPiKrm0gOhakxC/Wb7OeJ/9kc5D1cjNr8HphWNKE8=;
        b=V4V0HHwFqI7vfBLDpScjHw2i44uOEurGwxLEjtWphPdTQSegNJutLhV0J/UZwyJWwo
         SIiv8c24ETDwTRWqFeu3orv0iFUBb15lOdB55bQzV1Daaz0IjKpjlYV7t7dQAsBOGx+V
         WUDDyl7ruXw2D0gzHMAEy096vVwkkzqQCW1rAU7bX9nyEQ89un2MMHOCM4p7sVeL4ew6
         7G+fbcQODMpsvSMJhUDswgOzBff8yTAbbW3OCZ9eFog7b9abK5Kmm3BPAE1poMgtUQ0B
         h5YV5M//hihvVmFJN0F5tqgseWXIhv0PMN5eUiZ1m7zZ/ev4ehRSUHm3fYMPdMNcESEz
         AO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701744228; x=1702349028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7KPiKrm0gOhakxC/Wb7OeJ/9kc5D1cjNr8HphWNKE8=;
        b=VoU7575UkowTnjLMAlCvZGxo7UN3+HuwZEAHR3cUPkjCt9ko6bShRoNKHATVlkZMJf
         kpnvaeb8whYh5A2PRaX+o9SFnbXZ+M0u+rLGhrY8U8DkE392gi/FP4ZcPYG66qNUJCUh
         pvVSoYPIhXs21bzSTJa9fEu6VHE78JTFQhJAGTYd1W5FIAnBVcOdOxODkhFOxSNN9tZn
         Ou2E37CfzGsG/CfOX17WcaO4w9LnWtZpaefjGbI/Bspw5OB92CMeahdxX1pB1uImKDCe
         L1isxpL82TGZ9c4jvYGQ8zGWZeooR8Ze6+KaMExyHWGvIjN3OcwWlD/5qDJKOhve5p7y
         3Y9w==
X-Gm-Message-State: AOJu0Yw+VrVYApd0h0tt/L71ssTziJrv3v37u52iYRHORdpkZbXtOGOX
	zBV3fxWhCrFnDLEN+JB0+fXYrA==
X-Google-Smtp-Source: AGHT+IFjpVDyqkSHbaNqwFBeSjOTvhTrHeLCZiADHAwpcAR48Wdh3tXdrlaF62vWprf7yMCdI/PbwA==
X-Received: by 2002:a05:6830:1c8:b0:6d8:322d:e76d with SMTP id r8-20020a05683001c800b006d8322de76dmr5108332ota.38.1701744227938;
        Mon, 04 Dec 2023 18:43:47 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id z17-20020a9d62d1000000b006b9848f8aa7sm2157655otk.45.2023.12.04.18.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 18:43:47 -0800 (PST)
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
Subject: [RFC 9/9] RISC-V: KVM: Support 64 bit firmware counters on RV32
Date: Mon,  4 Dec 2023 18:43:10 -0800
Message-Id: <20231205024310.1593100-10-atishp@rivosinc.com>
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

The SBI v2.0 introduced a fw_read_hi function to read 64 bit firmware
counters for RV32 based systems.

Add infrastructure to support that.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  6 ++++-
 arch/riscv/kvm/vcpu_pmu.c             | 38 ++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |  7 +++++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 64c75acad6ba..dd655315e706 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -20,7 +20,7 @@ static_assert(RISCV_KVM_MAX_COUNTERS <= 64);
 
 struct kvm_fw_event {
 	/* Current value of the event */
-	unsigned long value;
+	uint64_t value;
 
 	/* Event monitoring status */
 	bool started;
@@ -91,6 +91,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     struct kvm_vcpu_sbi_return *retdata);
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata);
+#if defined(CONFIG_32BIT)
+int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
+				struct kvm_vcpu_sbi_return *retdata);
+#endif
 void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_pmu_setup_snapshot(struct kvm_vcpu *vcpu, unsigned long saddr_low,
 				       unsigned long saddr_high, unsigned long flags,
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 86c8e92f92d3..5b4a93647256 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -195,6 +195,28 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
 
 	return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
 }
+#if defined(CONFIG_32BIT)
+static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
+			      unsigned long *out_val)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	u64 enabled, running;
+	int fevent_code;
+
+	pmc = &kvpmu->pmc[cidx];
+
+	if (pmc->cinfo.type != SBI_PMU_CTR_TYPE_FW)
+		return -EINVAL;
+
+	fevent_code = get_event_code(pmc->event_idx);
+	pmc->counter_val = kvpmu->fw_event[fevent_code].value;
+
+	*out_val = pmc->counter_val >> 32;
+
+	return 0;
+}
+#endif
 
 static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 			unsigned long *out_val)
@@ -696,6 +718,20 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 	return 0;
 }
 
+#if defined(CONFIG_32BIT)
+int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
+				   struct kvm_vcpu_sbi_return *retdata)
+{
+	int ret;
+
+	ret = pmu_fw_ctr_read_hi(vcpu, cidx, &retdata->out_val);
+	if (ret == -EINVAL)
+		retdata->err_val = SBI_ERR_INVALID_PARAM;
+
+	return 0;
+}
+#endif
+
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata)
 {
@@ -769,7 +805,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 			pmc->cinfo.csr = CSR_CYCLE + i;
 		} else {
 			pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
-			pmc->cinfo.width = BITS_PER_LONG - 1;
+			pmc->cinfo.width = 63;
 		}
 	}
 
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index 77c20a61fd7d..0cd051d5a448 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -64,6 +64,13 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case SBI_EXT_PMU_COUNTER_FW_READ:
 		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
 		break;
+	case SBI_EXT_PMU_COUNTER_FW_READ_HI:
+#if defined(CONFIG_32BIT)
+		ret = kvm_riscv_vcpu_pmu_fw_ctr_read_hi(vcpu, cp->a0, retdata);
+#else
+		retdata->out_val = 0;
+#endif
+		break;
 	case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
 		ret = kvm_riscv_vcpu_pmu_setup_snapshot(vcpu, cp->a0, cp->a1, cp->a2, retdata);
 		break;
-- 
2.34.1


