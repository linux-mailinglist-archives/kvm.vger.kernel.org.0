Return-Path: <kvm+bounces-54852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFC0B29308
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A2D1488298
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 661B628851D;
	Sun, 17 Aug 2025 12:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iUaaxycO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F8B284B5D
	for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755434048; cv=none; b=qACJ5u9WRn80QzyP4C1zDDfn+LH7FSTTtIGY5nwEC1Mn0Fuk6/zxZSoKEujGBKjBxgtrP+/eLjp3v0uQ7d5eNaMJwEibnqEwjYv+aK/3TSkbWdP8IRCfI7KF8ImGNqR6+8Apkkg44nC/4j/MLjx50ANx4YFtiR+5Evp8+PR0I0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755434048; c=relaxed/simple;
	bh=hVMdhYbIXLIIT6+8btqojCllM2RBg3WEv0m0tN5ZgeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu4UCSDkXjrwGv2cLcLzkpkaFXsin7TMISyatTbg9Fm8B7kFl5vxP0N21YOtHB6GSKrPTac/nNHyhd0pnOfLXl7s1isqkn1807oas0gxtULKHsaoASMvEID/JX/PrxPpy93tB2Jx/nGjXizvhdGcJaGfbpGWeYYllT0irw0Rw5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iUaaxycO; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e2ea79219so3736259b3a.2
        for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 05:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755434046; x=1756038846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1X6mHsVn0Xnkju9YueBNfmXGkOzlQDsEJD2zMFOchw0=;
        b=iUaaxycO7XbEhXlz3KXlj5rVDGbAg65hv43HduPZFjS8YsJfZgQyEtKFmTj4fJ7T5V
         ic18GUHVoicFZdm3gNYop4mXJQcrXlVZP/pclaEzvwnZilxhPCURr89eRdt3wv2fvxpz
         TRPadDUdY/74spuWcyWCO02Ywd3fqMi0xrESFi/0aDzlqD3gQh+dHK24RJjcaM06CvDh
         MozDXwoIiwjJ0ALuVUu3PkOK0uODr10hQ7OQPz7xT4bGBl5fVgcQP9WUnYSr/as7VEwF
         jTpyUIx35nP57u81NmLFMpkPpb3FvpT3JMmUYtxHxswg8YNUokdksOZH1sR3trUfPeTf
         X+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755434046; x=1756038846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1X6mHsVn0Xnkju9YueBNfmXGkOzlQDsEJD2zMFOchw0=;
        b=R8XQHbyEAhzQZ+X4jZPsRu1d4DsG2t7fRJ+muEvPGKCOqsGZs/o6mudGXyvHAgQgem
         xH+lZptlWsX6jdk4Rz55YMrzjVFBKXr9tgtz7sDKKKnQd+fsidYQYZGxHDagQa8DAC8j
         3rxIulRxW1U28S5CYKCfgs9Y7YnSJuVwyKg7/rdejcaNINyZdHqVpTYIhQqbqIW//wtc
         QL4JVuUbbka7vewziCIbFrerA9ulvwYsM0RWoGJYwFg0iVjfHZuVqBEhCJzILnQGhxlO
         xfsMlATIhdRwUnc+qQ9lI5eNn1LsbrKPYHhffXZtz5EVmosTktRCXzSLxFH4D6s0gaEy
         X7kA==
X-Forwarded-Encrypted: i=1; AJvYcCXWUQFXVQUy67lon4Awmw3xdyKOa5gSOsOQWDN4DQ/51pZF0MUmeQ2tdxyxKbxnglqJ7ag=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrtcCqdd+x/btvxU+QSWHAPqN01Zt0YKjdMwhzgZggb2AALFE1
	agJYr6ZH8b6LrKRO/Gqiqc/JH70qiIl3ds7USnj8E0lyfvNJ5If9gBcNXYJdUECzBQE=
X-Gm-Gg: ASbGncvBy3/6ibcAPnuUXSy51PEE3w54CPfAxmJzEfeanuDZXzBX9Q7XV30qXKK9IfD
	edRNPOp+VruVol0FUSTeWVHH9B3N+toDYM3IQAJCHY3njQX18C/ZCou19ldAvQ+o+bjZjx8rBDo
	I3+PO5M/PEbEpkAx7jTte7FRByEVa/m4eQsphV1quXGyawUmI0mzWUKFSDH+lBtdc9HmSeUFV6v
	/uwSXLnTfUpMaawr//waLjN4fmw0pUGzeuK5bjybGKNZYXb1vDdsivQQM3iPPlvdTy0kF69LKR9
	AAutRujBuQfTkbmXhMB7QEdFQOYXC9//aq1ZywgCLnjVOUM/HdT+o7XBJATIsjzT/aM4ttz6S4D
	ZrBewGrQ+UK2Vq5kEA+zSuY4iMxyQtsbBDDzkPIfPPXy0r6Noi7E5CyE=
X-Google-Smtp-Source: AGHT+IEtC55e88m1o+TkYXc5HIsqgrGIksroTJA/ryQI57h4rVtpqXgcH5RlB6DdCPCfpIn1BlcsZQ==
X-Received: by 2002:a05:6a20:244b:b0:240:8d5:6271 with SMTP id adf61e73a8af0-240d2f28027mr11452970637.39.1755434046019;
        Sun, 17 Aug 2025 05:34:06 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.202])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232b291449sm4480912a91.0.2025.08.17.05.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 05:34:05 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 5/6] RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
Date: Sun, 17 Aug 2025 18:03:23 +0530
Message-ID: <20250817123324.239423-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250817123324.239423-1-apatel@ventanamicro.com>
References: <20250817123324.239423-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM user-space needs a way to save/restore the state of
SBI FWFT features so implement SBI extension ONE_REG callbacks.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  14 +++
 arch/riscv/kvm/vcpu_sbi_fwft.c    | 168 +++++++++++++++++++++++++++---
 2 files changed, 170 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index a5ca0f4ce2d3..fc5624e89c7b 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -215,6 +215,17 @@ struct kvm_riscv_sbi_sta {
 	unsigned long shmem_hi;
 };
 
+struct kvm_riscv_sbi_fwft_feature {
+	unsigned long flags;
+	unsigned long value;
+};
+
+/* SBI FWFT extension registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_sbi_fwft {
+	struct kvm_riscv_sbi_fwft_feature misaligned_deleg;
+	struct kvm_riscv_sbi_fwft_feature pointer_masking;
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -298,6 +309,9 @@ struct kvm_riscv_sbi_sta {
 #define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_SBI_STA_REG(name)		\
 		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_SBI_FWFT		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_FWFT_REG(name)	\
+		(offsetof(struct kvm_riscv_sbi_fwft, name) / sizeof(unsigned long))
 
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index 5a3bad0f9330..6499a669f9d0 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -22,6 +22,11 @@ struct kvm_sbi_fwft_feature {
 	 */
 	enum sbi_fwft_feature_t id;
 
+	/**
+	 * @flags_reg_num: ONE_REG index of the feature flag
+	 */
+	unsigned long flags_reg_num;
+
 	/**
 	 * @supported: Check if the feature is supported on the vcpu
 	 *
@@ -44,7 +49,8 @@ struct kvm_sbi_fwft_feature {
 	 *
 	 * This callback is mandatory
 	 */
-	long (*set)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long value);
+	long (*set)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
+		    bool one_reg_access, unsigned long value);
 
 	/**
 	 * @get: Get the feature current value
@@ -53,7 +59,8 @@ struct kvm_sbi_fwft_feature {
 	 *
 	 * This callback is mandatory
 	 */
-	long (*get)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long *value);
+	long (*get)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf,
+		    bool one_reg_access, unsigned long *value);
 };
 
 static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
@@ -91,16 +98,18 @@ static void kvm_sbi_fwft_reset_misaligned_delegation(struct kvm_vcpu *vcpu)
 
 static long kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
 					struct kvm_sbi_fwft_config *conf,
-					unsigned long value)
+					bool one_reg_access, unsigned long value)
 {
 	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
 	if (value == 1) {
 		cfg->hedeleg |= MIS_DELEG;
-		csr_set(CSR_HEDELEG, MIS_DELEG);
+		if (!one_reg_access)
+			csr_set(CSR_HEDELEG, MIS_DELEG);
 	} else if (value == 0) {
 		cfg->hedeleg &= ~MIS_DELEG;
-		csr_clear(CSR_HEDELEG, MIS_DELEG);
+		if (!one_reg_access)
+			csr_clear(CSR_HEDELEG, MIS_DELEG);
 	} else {
 		return SBI_ERR_INVALID_PARAM;
 	}
@@ -110,10 +119,11 @@ static long kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
 
 static long kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
 					struct kvm_sbi_fwft_config *conf,
-					unsigned long *value)
+					bool one_reg_access, unsigned long *value)
 {
-	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) == MIS_DELEG;
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
+	*value = (cfg->hedeleg & MIS_DELEG) == MIS_DELEG;
 	return SBI_SUCCESS;
 }
 
@@ -145,7 +155,7 @@ static void kvm_sbi_fwft_reset_pointer_masking_pmlen(struct kvm_vcpu *vcpu)
 
 static long kvm_sbi_fwft_set_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 						   struct kvm_sbi_fwft_config *conf,
-						   unsigned long value)
+						   bool one_reg_access, unsigned long value)
 {
 	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
 	unsigned long pmm;
@@ -167,14 +177,15 @@ static long kvm_sbi_fwft_set_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 	 * update here so that VCPU see's pointer masking mode change
 	 * immediately.
 	 */
-	csr_write(CSR_HENVCFG, vcpu->arch.cfg.henvcfg);
+	if (!one_reg_access)
+		csr_write(CSR_HENVCFG, vcpu->arch.cfg.henvcfg);
 
 	return SBI_SUCCESS;
 }
 
 static long kvm_sbi_fwft_get_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 						   struct kvm_sbi_fwft_config *conf,
-						   unsigned long *value)
+						   bool one_reg_access, unsigned long *value)
 {
 	switch (vcpu->arch.cfg.henvcfg & ENVCFG_PMM) {
 	case ENVCFG_PMM_PMLEN_0:
@@ -198,6 +209,8 @@ static long kvm_sbi_fwft_get_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 static const struct kvm_sbi_fwft_feature features[] = {
 	{
 		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
+		.flags_reg_num = offsetof(struct kvm_riscv_sbi_fwft, misaligned_deleg.flags) /
+				 sizeof(unsigned long),
 		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
 		.reset = kvm_sbi_fwft_reset_misaligned_delegation,
 		.set = kvm_sbi_fwft_set_misaligned_delegation,
@@ -206,6 +219,8 @@ static const struct kvm_sbi_fwft_feature features[] = {
 #ifndef CONFIG_32BIT
 	{
 		.id = SBI_FWFT_POINTER_MASKING_PMLEN,
+		.flags_reg_num = offsetof(struct kvm_riscv_sbi_fwft, pointer_masking.flags) /
+				 sizeof(unsigned long),
 		.supported = kvm_sbi_fwft_pointer_masking_pmlen_supported,
 		.reset = kvm_sbi_fwft_reset_pointer_masking_pmlen,
 		.set = kvm_sbi_fwft_set_pointer_masking_pmlen,
@@ -214,6 +229,21 @@ static const struct kvm_sbi_fwft_feature features[] = {
 #endif
 };
 
+static const struct kvm_sbi_fwft_feature *kvm_sbi_fwft_regnum_to_feature(unsigned long reg_num)
+{
+	const struct kvm_sbi_fwft_feature *feature;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(features); i++) {
+		feature = &features[i];
+		if (feature->flags_reg_num == reg_num ||
+		    (feature->flags_reg_num + 1) == reg_num)
+			return feature;
+	}
+
+	return NULL;
+}
+
 static struct kvm_sbi_fwft_config *
 kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
 {
@@ -267,7 +297,7 @@ static int kvm_sbi_fwft_set(struct kvm_vcpu *vcpu, u32 feature,
 
 	conf->flags = flags;
 
-	return conf->feature->set(vcpu, conf, value);
+	return conf->feature->set(vcpu, conf, false, value);
 }
 
 static int kvm_sbi_fwft_get(struct kvm_vcpu *vcpu, unsigned long feature,
@@ -280,7 +310,7 @@ static int kvm_sbi_fwft_get(struct kvm_vcpu *vcpu, unsigned long feature,
 	if (ret)
 		return ret;
 
-	return conf->feature->get(vcpu, conf, value);
+	return conf->feature->get(vcpu, conf, false, value);
 }
 
 static int kvm_sbi_ext_fwft_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
@@ -354,6 +384,115 @@ static void kvm_sbi_ext_fwft_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+static unsigned long kvm_sbi_ext_fwft_get_reg_count(struct kvm_vcpu *vcpu)
+{
+	unsigned long max_reg_count = sizeof(struct kvm_riscv_sbi_fwft) / sizeof(unsigned long);
+	const struct kvm_sbi_fwft_feature *feature;
+	struct kvm_sbi_fwft_config *conf;
+	unsigned long reg, ret = 0;
+
+	for (reg = 0; reg < max_reg_count; reg++) {
+		feature = kvm_sbi_fwft_regnum_to_feature(reg);
+		if (!feature)
+			continue;
+
+		conf = kvm_sbi_fwft_get_config(vcpu, feature->id);
+		if (!conf || !conf->supported)
+			continue;
+
+		ret++;
+	}
+
+	return ret;
+}
+
+static int kvm_sbi_ext_fwft_get_reg_id(struct kvm_vcpu *vcpu, int index, u64 *reg_id)
+{
+	int reg, max_reg_count = sizeof(struct kvm_riscv_sbi_fwft) / sizeof(unsigned long);
+	const struct kvm_sbi_fwft_feature *feature;
+	struct kvm_sbi_fwft_config *conf;
+	int idx = 0;
+
+	for (reg = 0; reg < max_reg_count; reg++) {
+		feature = kvm_sbi_fwft_regnum_to_feature(reg);
+		if (!feature)
+			continue;
+
+		conf = kvm_sbi_fwft_get_config(vcpu, feature->id);
+		if (!conf || !conf->supported)
+			continue;
+
+		if (index == idx) {
+			*reg_id = KVM_REG_RISCV |
+				  (IS_ENABLED(CONFIG_32BIT) ?
+				   KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64) |
+				  KVM_REG_RISCV_SBI_STATE |
+				  KVM_REG_RISCV_SBI_FWFT | reg;
+			return 0;
+		}
+
+		idx++;
+	}
+
+	return -ENOENT;
+}
+
+static int kvm_sbi_ext_fwft_get_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
+				    unsigned long reg_size, void *reg_val)
+{
+	const struct kvm_sbi_fwft_feature *feature;
+	struct kvm_sbi_fwft_config *conf;
+	unsigned long *value;
+	int ret = 0;
+
+	if (reg_size != sizeof(unsigned long))
+		return -EINVAL;
+	value = reg_val;
+
+	feature = kvm_sbi_fwft_regnum_to_feature(reg_num);
+	if (!feature)
+		return -ENOENT;
+
+	conf = kvm_sbi_fwft_get_config(vcpu, feature->id);
+	if (!conf || !conf->supported)
+		return -ENOENT;
+
+	if (feature->flags_reg_num == reg_num)
+		*value = conf->flags;
+	else
+		ret = conf->feature->get(vcpu, conf, true, value);
+
+	return sbi_err_map_linux_errno(ret);
+}
+
+static int kvm_sbi_ext_fwft_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
+				    unsigned long reg_size, const void *reg_val)
+{
+	const struct kvm_sbi_fwft_feature *feature;
+	struct kvm_sbi_fwft_config *conf;
+	unsigned long value;
+	int ret = 0;
+
+	if (reg_size != sizeof(unsigned long))
+		return -EINVAL;
+	value = *(const unsigned long *)reg_val;
+
+	feature = kvm_sbi_fwft_regnum_to_feature(reg_num);
+	if (!feature)
+		return -ENOENT;
+
+	conf = kvm_sbi_fwft_get_config(vcpu, feature->id);
+	if (!conf || !conf->supported)
+		return -ENOENT;
+
+	if (feature->flags_reg_num == reg_num)
+		conf->flags = value & SBI_FWFT_SET_FLAG_LOCK;
+	else
+		ret = conf->feature->set(vcpu, conf, true, value);
+
+	return sbi_err_map_linux_errno(ret);
+}
+
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
 	.extid_start = SBI_EXT_FWFT,
 	.extid_end = SBI_EXT_FWFT,
@@ -361,4 +500,9 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
 	.init = kvm_sbi_ext_fwft_init,
 	.deinit = kvm_sbi_ext_fwft_deinit,
 	.reset = kvm_sbi_ext_fwft_reset,
+	.state_reg_subtype = KVM_REG_RISCV_SBI_FWFT,
+	.get_state_reg_count = kvm_sbi_ext_fwft_get_reg_count,
+	.get_state_reg_id = kvm_sbi_ext_fwft_get_reg_id,
+	.get_state_reg = kvm_sbi_ext_fwft_get_reg,
+	.set_state_reg = kvm_sbi_ext_fwft_set_reg,
 };
-- 
2.43.0


