Return-Path: <kvm+bounces-15102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A67F8A9D09
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 634B9B21E36
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B671316ABF8;
	Thu, 18 Apr 2024 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="citmvoJC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0023F168AF3
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450434; cv=none; b=FcLfEFcUjDvBIHmw9dHos+mrz0uxhIQJFk8j6Xr5Ci1lCFKbjWOgB7LOSXjaJ2F6AquTJfHVNNdGOTWR5xrhb3wuKZSkWGbm064/t9v7f2jv1M3OEBhRT7Fp+L2gHLtDxnTQjJjH2XGzr6DOkfabNI3rbYfJdGCySfJl2QrWqLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450434; c=relaxed/simple;
	bh=Qq3qZUDiX+qVcrmtRiXkpIAVW4TFc7HS4hoqHhPDUsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBWfeNxf0BTRxPn15H9yak7+9QMKdEHNmQUTdRf08jXvvUnJ1NyCl5bdTyvBJKBplU3QXNpUEr12Y+LnsPElof4+UZ2/6UaFMP7kRbOLmr/gcntgymSUHCP35EU0VEJLAfbne99oM3w2AukSt4fl/yA0G9k2TnMrrNTW+P11DTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=citmvoJC; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-349a35aba9dso167597f8f.3
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450431; x=1714055231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjYeEsui4m5xv1lGH5o6mH+W8BXsONKsbiY648bn26Q=;
        b=citmvoJCHwNuL4C+DMYdoAfA7QLh9agRZiWdOsKZgN92U3eOrdWPu/uyj7zCQ5osxu
         yIO1tsRAd1OIUntIy+c6wIl1MhLG2LLIEnnW91331Daxl+8V7KEe548cmtEvIukFdEax
         to3LwDr+wx4toPxxoIhKrIyWxfDOs705z4Dsb8zJu9Y4rxPuqjwd8PDYSzfVHNws1hDU
         1boA7MY9hhKbyTNK+p4+PBbhXxsdr5o1dhpkXyb4j491buMrVVIHTHH6Nj0v7kQF1l+g
         2t3mbDF+fQX+vMSabHqXfmQszaVXWSkRnXCDdohkhk9OZZ+wHJArqTKjrFA0kKhcEh91
         Y+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450431; x=1714055231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pjYeEsui4m5xv1lGH5o6mH+W8BXsONKsbiY648bn26Q=;
        b=hX/vobHEAOp0H19rY9Sj/+V9STNeDlB8p0H5EAohp2takfIs8t1/jMAenE4tBZjWWk
         iuV2q0z2CEQYhQyz3IDuLEv/gOdHtnAMnuyX8fvlvC0oH9IPXysIp5DKZnYIrABaUeAt
         KtTRzF+qWJM/q2FkHZCfel8uVUJOX5CT7xbw3pkU8CnYvMzwRonc0U2ID1iizzsZ6zWI
         cDhHemO15CFjcpJKTFNo3KE0qTEHj6Yu//jnJRSEtFqpf9Sf83LatKfH7FmmLBWXurEn
         Zj2YnESmGK4pzOwoOCBkvRHwVdLXjGJDf6CE6r9eN8qtcIPpXzild501gza5o5keIecy
         clkw==
X-Forwarded-Encrypted: i=1; AJvYcCWWuMOZnTT4oMR61TyUFyKC1HcbB+Q3x/dyglo6PILOypj3O59uaPGtSoFWLZqCQ787p7SELstus73J2znQIpg45ztF
X-Gm-Message-State: AOJu0YwV3nch2ijYAB2gpv3w2UGpbL6Ijn7cA0YzCeX7YVxR70nmVN8t
	eF8B2Vmxod7ZVPeE0rHATEgn1E1rEZfqKGN+jYGZsvx0LD8VE5q8STz/nX2M4bQ=
X-Google-Smtp-Source: AGHT+IFFwaascQCVwSoWuecZs0QNk4WI1qD1KbtUyisTXBvH15F7tw1GRlm2dKuVmVzvSHfB6Uh8Ag==
X-Received: by 2002:a05:600c:3554:b0:416:7b2c:df05 with SMTP id i20-20020a05600c355400b004167b2cdf05mr2100856wmq.1.1713450431422;
        Thu, 18 Apr 2024 07:27:11 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:10 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [RFC PATCH 1/7] riscv: kvm: add support for FWFT SBI extension
Date: Thu, 18 Apr 2024 16:26:40 +0200
Message-ID: <20240418142701.1493091-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for FWFT extension in KVM

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h          |   5 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h      |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  37 ++++++
 arch/riscv/include/uapi/asm/kvm.h          |   1 +
 arch/riscv/kvm/Makefile                    |   1 +
 arch/riscv/kvm/vcpu.c                      |   5 +
 arch/riscv/kvm/vcpu_sbi.c                  |   4 +
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 136 +++++++++++++++++++++
 8 files changed, 190 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 484d04a92fa6..be60aaa07f57 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_vcpu_sbi_fwft.h>
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_pmu.h>
 
@@ -169,6 +170,7 @@ struct kvm_vcpu_csr {
 struct kvm_vcpu_config {
 	u64 henvcfg;
 	u64 hstateen0;
+	u64 hedeleg;
 };
 
 struct kvm_vcpu_smstateen_csr {
@@ -261,6 +263,9 @@ struct kvm_vcpu_arch {
 	/* Performance monitoring context */
 	struct kvm_pmu pmu_context;
 
+	/* Firmware feature SBI extension context */
+	struct kvm_sbi_fwft fwft_context;
+
 	/* 'static' configurations which are set only once */
 	struct kvm_vcpu_config cfg;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index b96705258cf9..3a33bbacc233 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -86,6 +86,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
new file mode 100644
index 000000000000..7dc1b80c7e6c
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2023 Rivos Inc
+ *
+ * Authors:
+ *     Atish Patra <atishp@rivosinc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_FWFT_H
+#define __KVM_VCPU_RISCV_FWFT_H
+
+#include <asm/sbi.h>
+
+#define KVM_SBI_FWFT_FEATURE_COUNT	1
+
+struct kvm_sbi_fwft_config;
+struct kvm_vcpu;
+
+struct kvm_sbi_fwft_feature {
+	enum sbi_fwft_feature_t id;
+	int (*set)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long value);
+	int (*get)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long *value);
+};
+
+struct kvm_sbi_fwft_config {
+	const struct kvm_sbi_fwft_feature *feature;
+	unsigned long flags;
+};
+
+/* FWFT data structure per vcpu */
+struct kvm_sbi_fwft {
+	struct kvm_sbi_fwft_config configs[KVM_SBI_FWFT_FEATURE_COUNT];
+};
+
+#define vcpu_to_fwft(vcpu) (&(vcpu)->arch.fwft_context)
+
+#endif /* !__KVM_VCPU_RISCV_FWFT_H */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 7499e88a947c..fa3097da91c0 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -185,6 +185,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
+	KVM_RISCV_SBI_EXT_FWFT,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index c9646521f113..19175bd5b40a 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -27,6 +27,7 @@ kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_sbi_hsm.o
 kvm-y += vcpu_sbi_sta.o
+kvm-y += vcpu_sbi_fwft.o
 kvm-y += vcpu_timer.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
 kvm-y += aia.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..461ef60d4eda 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -505,6 +505,8 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 		if (riscv_isa_extension_available(isa, SMSTATEEN))
 			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
 	}
+
+	cfg->hedeleg = csr_read(CSR_HEDELEG);
 }
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -521,6 +523,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	csr_write(CSR_VSTVAL, csr->vstval);
 	csr_write(CSR_HVIP, csr->hvip);
 	csr_write(CSR_VSATP, csr->vsatp);
+	csr_write(CSR_HEDELEG, cfg->hedeleg);
 	csr_write(CSR_HENVCFG, cfg->henvcfg);
 	if (IS_ENABLED(CONFIG_32BIT))
 		csr_write(CSR_HENVCFGH, cfg->henvcfg >> 32);
@@ -551,6 +554,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
 
 	vcpu->cpu = -1;
 
@@ -574,6 +578,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	csr->vstval = csr_read(CSR_VSTVAL);
 	csr->hvip = csr_read(CSR_HVIP);
 	csr->vsatp = csr_read(CSR_VSATP);
+	cfg->hedeleg = csr_read(CSR_HEDELEG);
 }
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 72a2ffb8dcd1..76901f0f34b7 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -74,6 +74,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
 		.ext_idx = KVM_RISCV_SBI_EXT_STA,
 		.ext_ptr = &vcpu_sbi_ext_sta,
 	},
+	{
+		.ext_idx = KVM_RISCV_SBI_EXT_FWFT,
+		.ext_ptr = &vcpu_sbi_ext_fwft,
+	},
 	{
 		.ext_idx = KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 		.ext_ptr = &vcpu_sbi_ext_experimental,
diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
new file mode 100644
index 000000000000..b9b7f8fa6d22
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_vcpu_sbi_fwft.h>
+
+#define MIS_DELEG (1UL << EXC_LOAD_MISALIGNED | 1UL << EXC_STORE_MISALIGNED)
+
+static int kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long value)
+{
+	if (value)
+		csr_set(CSR_HEDELEG, MIS_DELEG);
+	else
+		csr_clear(CSR_HEDELEG, MIS_DELEG);
+
+	return SBI_SUCCESS;
+}
+
+static int kvm_sbi_fwft_get_misaligned_delegation(struct kvm_vcpu *vcpu,
+					struct kvm_sbi_fwft_config *conf,
+					unsigned long *value)
+{
+	*value = (csr_read(CSR_HEDELEG) & MIS_DELEG) != 0;
+
+	return SBI_SUCCESS;
+}
+
+static struct kvm_sbi_fwft_config *
+kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
+{
+	int i = 0;
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+
+	for (i = 0; i < KVM_SBI_FWFT_FEATURE_COUNT; i++) {
+		if (fwft->configs[i].feature->id == feature)
+			return &fwft->configs[i];
+	}
+
+	return NULL;
+}
+
+static int kvm_sbi_fwft_set(struct kvm_vcpu *vcpu,
+			    enum sbi_fwft_feature_t feature,
+			    unsigned long value, unsigned long flags)
+{
+	struct kvm_sbi_fwft_config *conf = kvm_sbi_fwft_get_config(vcpu,
+								   feature);
+	if (!conf)
+		return SBI_ERR_DENIED;
+
+	if ((flags & ~SBI_FWFT_SET_FLAG_LOCK) != 0)
+		return SBI_ERR_INVALID_PARAM;
+
+	if (conf->flags & SBI_FWFT_SET_FLAG_LOCK)
+		return SBI_ERR_DENIED;
+
+	conf->flags = flags;
+
+	return conf->feature->set(vcpu, conf, value);
+}
+
+static int kvm_sbi_fwft_get(struct kvm_vcpu *vcpu,
+			    enum sbi_fwft_feature_t feature,
+			    unsigned long *value)
+{
+	struct kvm_sbi_fwft_config *conf = kvm_sbi_fwft_get_config(vcpu,
+								   feature);
+	if (!conf)
+		return SBI_ERR_DENIED;
+
+	return conf->feature->get(vcpu, conf, value);
+}
+
+static int kvm_sbi_ext_fwft_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    struct kvm_vcpu_sbi_return *retdata)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long funcid = cp->a6;
+
+	switch (funcid) {
+	case SBI_EXT_FWFT_SET:
+		ret = kvm_sbi_fwft_set(vcpu, cp->a0, cp->a1, cp->a2);
+		break;
+	case SBI_EXT_FWFT_GET:
+		ret = kvm_sbi_fwft_get(vcpu, cp->a0, &retdata->out_val);
+		break;
+	default:
+		ret = SBI_ERR_NOT_SUPPORTED;
+		break;
+	}
+
+	retdata->err_val = ret;
+
+	return 0;
+}
+
+static const struct kvm_sbi_fwft_feature features[] = {
+	{
+		.id = SBI_FWFT_MISALIGNED_DELEG,
+		.set = kvm_sbi_fwft_set_misaligned_delegation,
+		.get = kvm_sbi_fwft_get_misaligned_delegation,
+	}
+};
+
+static_assert(ARRAY_SIZE(features) == KVM_SBI_FWFT_FEATURE_COUNT);
+
+
+static unsigned long kvm_sbi_ext_fwft_probe(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(features); i++)
+		fwft->configs[i].feature = &features[i];
+
+	return 1;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
+	.extid_start = SBI_EXT_FWFT,
+	.extid_end = SBI_EXT_FWFT,
+	.handler = kvm_sbi_ext_fwft_handler,
+	.probe = kvm_sbi_ext_fwft_probe,
+};
-- 
2.43.0


