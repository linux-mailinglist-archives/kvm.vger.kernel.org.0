Return-Path: <kvm+bounces-15396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 586F38AB7CB
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 01:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BCBA1C20AA5
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 23:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE74149C72;
	Fri, 19 Apr 2024 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="n76RWuKa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09ED1494D2
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 23:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713570494; cv=none; b=P+LCpUi8KI3Ddip94l1hToPMJkkajN/ryT5AxX0zXQEwgTYj+Zp3w/ihUVeXKgr8asT2xbII2YirWZyTo119q9vfPrTM8ZFpnZ5XO/rAXp29BPKzjcDI85T8J5yw/UsroviaDVlmQ6714y0Ani597J7gmGYxHZKb8tS4lIJ4gMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713570494; c=relaxed/simple;
	bh=kMQT5NtU/3H2nu/pPUysYDHLMBWHMS5imSpFNSr8k7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SS0Q3ygNQGywY31JIHTAziuNTs7M04WGNCbIL/8UdQqa2qxjzM7aW5e5AqE272A11XB9hulCJJUXS2e7vzuuXteN0xcie5Cjl1yjD3umBAFxp5PI6TAbiWvz4rvwi+DSLYf+bAwrnmhR7kDYdsP8Dv3KWT5PfgC9cXZ6DX3YsiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=n76RWuKa; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ed9fc77bbfso2086206b3a.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713570492; x=1714175292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K/zHwGjJUr6D05KIztpGDsyJZSWroCpzob1LwbCt9c8=;
        b=n76RWuKahJGrkdRXqJIEf3XQhiBLYtxZaiuLHZBD7UF+S4ihg7sySC2K/xkijiuUpG
         DsIMiGhxyekNlr923Y1SblC/gp9ENE9lygp5tANmphgatam8RzeG0rQ06EOOyfQDFAJP
         ro3DX/TrSDi8sOojxXp+L4SPZKupMCMJASZV9/Mzpp50zCnGsF+RlHnunYTFkKDvGsf2
         /cTjGD8nUyLL75Yc1RfAeRDgK/KwuwMO3MgARlDa6KTDvmtI1AgYz0DyeaPhZLQRnFSo
         4MWljLs18tSyU9OECINvgpEpNuD3WUrrtm8iFVW4Vc9zDkBoPtS1eODYuaGZKEPH3Spt
         WrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713570492; x=1714175292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K/zHwGjJUr6D05KIztpGDsyJZSWroCpzob1LwbCt9c8=;
        b=EsmIQXOgWFR2XwlWklpzy39wmOrKW+sf5zvYFmy5jc0aPzbYPYw+Wi7yJXKokMnDle
         fBkptFCWC9gJ3MVTOmo+98atw/v0PyRhHNWIx8dPTe9wt2aadMyPsiFC2eFbp8t1iC74
         YHxAA8r8Drz/6L/nio1+FbKiZQY21Qy+72ONgSbx8Cp3u3ToOW4xKB2seDNFHZY+FXOW
         QigUqvu435mFfcNweX2Ru7OK049jC202LYH67D1kedVP+hgKUvraGuXc0u/eTJeoxUjb
         pdzNV5LJ6O5zZmjx/onxeZn7XVH8vkyElNEu/USQGbQE8/qBbte+efUipw1EIcdrBh93
         D2rA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Ijvy4bbl3v9+T2MY4tlHJhvwemymBEn20tDjYeVW9IVND5HCySa0zmwhitCFC5CS7PRKtGRciwwMW9RSAsQFodtz
X-Gm-Message-State: AOJu0YxfMnz4azjJZMGCuePUuJdXixFxzCOLcyM83IjwMsntUi44hNGl
	hfBTfx9AvZB5M+UqR/jy1/j88p22o/tTB8nSJ865RJAtt20cNhG2LPiOPqx75Ww=
X-Google-Smtp-Source: AGHT+IEs3T3yx2Wfoao895EI90Rubsli+/oRcC36NhMV07FIBKOadqsA0HY8pguaPtpxEhZcF19avQ==
X-Received: by 2002:a05:6a20:da8c:b0:1aa:5b05:7925 with SMTP id iy12-20020a056a20da8c00b001aa5b057925mr4706514pzb.4.1713570492271;
        Fri, 19 Apr 2024 16:48:12 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902d11100b001e42f215f33sm3924017plw.85.2024.04.19.16.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 16:48:11 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	samuel.holland@sifive.com,
	Conor Dooley <conor.dooley@microchip.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v8 15/24] RISC-V: KVM: Support 64 bit firmware counters on RV32
Date: Sat, 20 Apr 2024 08:17:31 -0700
Message-Id: <20240420151741.962500-16-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240420151741.962500-1-atishp@rivosinc.com>
References: <20240420151741.962500-1-atishp@rivosinc.com>
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

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h |  4 ++-
 arch/riscv/kvm/vcpu_pmu.c             | 44 ++++++++++++++++++++++++++-
 arch/riscv/kvm/vcpu_sbi_pmu.c         |  6 ++++
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index 257f17641e00..55861b5d3382 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -20,7 +20,7 @@ static_assert(RISCV_KVM_MAX_COUNTERS <= 64);
 
 struct kvm_fw_event {
 	/* Current value of the event */
-	unsigned long value;
+	u64 value;
 
 	/* Event monitoring status */
 	bool started;
@@ -91,6 +91,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 				     struct kvm_vcpu_sbi_return *retdata);
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata);
+int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
+				      struct kvm_vcpu_sbi_return *retdata);
 void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
 				      unsigned long saddr_high, unsigned long flags,
diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index a801ed52dc9b..e1409ec9afc0 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -197,6 +197,36 @@ static int pmu_get_pmc_index(struct kvm_pmu *pmu, unsigned long eidx,
 	return kvm_pmu_get_programmable_pmc_index(pmu, eidx, cbase, cmask);
 }
 
+static int pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
+			      unsigned long *out_val)
+{
+	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int fevent_code;
+
+	if (!IS_ENABLED(CONFIG_32BIT)) {
+		pr_warn("%s: should be invoked for only RV32\n", __func__);
+		return -EINVAL;
+	}
+
+	if (cidx >= kvm_pmu_num_counters(kvpmu) || cidx == 1) {
+		pr_warn("Invalid counter id [%ld]during read\n", cidx);
+		return -EINVAL;
+	}
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
+
 static int pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 			unsigned long *out_val)
 {
@@ -705,6 +735,18 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
 	return 0;
 }
 
+int kvm_riscv_vcpu_pmu_fw_ctr_read_hi(struct kvm_vcpu *vcpu, unsigned long cidx,
+				      struct kvm_vcpu_sbi_return *retdata)
+{
+	int ret;
+
+	ret = pmu_fw_ctr_read_hi(vcpu, cidx, &retdata->out_val);
+	if (ret == -EINVAL)
+		retdata->err_val = SBI_ERR_INVALID_PARAM;
+
+	return 0;
+}
+
 int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
 				struct kvm_vcpu_sbi_return *retdata)
 {
@@ -778,7 +820,7 @@ void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu)
 			pmc->cinfo.csr = CSR_CYCLE + i;
 		} else {
 			pmc->cinfo.type = SBI_PMU_CTR_TYPE_FW;
-			pmc->cinfo.width = BITS_PER_LONG - 1;
+			pmc->cinfo.width = 63;
 		}
 	}
 
diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
index d3e7625fb2d2..cf111de51bdb 100644
--- a/arch/riscv/kvm/vcpu_sbi_pmu.c
+++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
@@ -64,6 +64,12 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case SBI_EXT_PMU_COUNTER_FW_READ:
 		ret = kvm_riscv_vcpu_pmu_ctr_read(vcpu, cp->a0, retdata);
 		break;
+	case SBI_EXT_PMU_COUNTER_FW_READ_HI:
+		if (IS_ENABLED(CONFIG_32BIT))
+			ret = kvm_riscv_vcpu_pmu_fw_ctr_read_hi(vcpu, cp->a0, retdata);
+		else
+			retdata->out_val = 0;
+		break;
 	case SBI_EXT_PMU_SNAPSHOT_SET_SHMEM:
 		ret = kvm_riscv_vcpu_pmu_snapshot_set_shmem(vcpu, cp->a0, cp->a1, cp->a2, retdata);
 		break;
-- 
2.34.1


