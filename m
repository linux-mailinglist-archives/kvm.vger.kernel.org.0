Return-Path: <kvm+bounces-47570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B819DAC210A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39ED87BA127
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024E323F417;
	Fri, 23 May 2025 10:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JiHaerwL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A65522A7E1
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995777; cv=none; b=JwtsFBOffHoveGaYh1wJyIWB1qslDWXPpX67rTUh60ud6pGqgu680/HwtPk3ofdWLP416AlwqvSIPB/SPYlP9cTCd/JOxcUgrZQTYs7pQzYa8DTKFCPos0LcvWiTWrK0Y2P1SW994J3hH5r4DKyb7giF5Jbwdd3WeA5+ABUAjBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995777; c=relaxed/simple;
	bh=nU4YnlL5l08V6lrXuV+qv8a1fV7dLDUs2W/B8vYQYkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etQACJcLGzr3cT6IK9MXz0MzHbBgTkzIJ2+euzY+FNqaFTYAX5nTLK/R3trIcL4X4WYQ+jLK5BN6JoowLczuAx1bCjz48K+baLngywKrAL9Xsel/mCswhypxsb57iNwBCvphqc1BUv6ThSw62nm/BpN3vYxRFfr+6w7kqqIAZh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JiHaerwL; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-742c7a52e97so5093861b3a.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747995775; x=1748600575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U481WP3Qw1aBWtl4ep23kHLSc1kpXWgI6ny8IPxt0A0=;
        b=JiHaerwLQnoEm5L5+EbczVYrqxPFYSESASJKeUoEqJPhOKyEpbk/HbwJFndeSOGOLB
         DDrVjrlgcv6kIz9RlepAmqV3DTSuVgDdpN5RegfhjK7Kh6uNUIxzVHjkl1ub0+kIh3wI
         QuspjUBvFMWIZ5FhGOTPaDsuiKY7SEIH1CL5KWvvMr10VbRNxZ0+WAg8gkgc9qbI89su
         YA/tjqzRTeOlI5qO8+gnySkipLdAoeMle2pmZfvnqcNvfLf3LCmUwXHGgdfjr+TUPp7Y
         HUnyuwZpAI0Xyr/n/4R3N73how7xRaOGeYW5A8J8xoz4W5MCaF0z/TX/hLLUbsnD3kOf
         ZJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747995775; x=1748600575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U481WP3Qw1aBWtl4ep23kHLSc1kpXWgI6ny8IPxt0A0=;
        b=aJFPzvY5qQtc1omZpQoHpy/qoAcjkDUdq9M30H4c6smCyvEeImkxjb6JdD0ZDkQhY+
         H/3yYPv9z7YIhjM2T11SKHgpMheeivwbt1qizqVDB1Wl7oz2g1YZxN6yeRVI1wgQe9tQ
         zMduj77sD7BgnO6GQzt61Nu7wQ0t4CRZxNqRBcjDNd1tkzaZUEwvsUIBDWFcYE/XzJuD
         A5YlMKe0epvF458QHH3fV6jsdl0bVa7tngV64i4kQ7D07wz/4nXb2STrOysjCiS0ieHo
         xKjTieH7bGA3Afm9C3/TnfJEwc1LEpLfS5pvY2CeWEk5jQ51Aq0xF6xP1OKVH+6tuCbX
         TVfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwjngwAQ0AJOCyZRhbiODNlZjQRLiweAv33HihPnc8zkTY7ZOSSZA9I/+RscQ1koBF8xU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrweovKWuruVF+eMhaTkhd0jD2eLA202qj34FrOqHBQJgnAqnm
	YGx2cPJNnSiBK4ickVutAIkRcGdmjbEysHhPePSQVDMnelISN80iNPyqTi2cviB/XUg=
X-Gm-Gg: ASbGncsdNhnTfqkTQz8bIvrlWdIYzAY7eadQ6TDdsYkywwZyWlqv2YIugA/Dowp6Mfn
	Xx14YUK8lg6V9Bak2SOzz0bqwQgwb7cqAUaeDPpE18N2NMy8oV6sPIsZiwNw2LXdnqffRsxxKeR
	w9q5s3pHgchHjkIbnuakzuZS+Axspb3G3lbsDgR7RUUyg2/U9ICBYAaRtpAIigTCULqusfoQDRf
	STvBhsdzXu9Kkg8jscOiOY/GUDny7XZSuXZvNQQYjt4B5pGTj/1BSzOJhNCn4iUCTNOQ+nPKo/N
	G8/jrb7Fi8W+J3rmIfJ31OPt1/BdQGAEwLx7tViaD/MH/nuCJ0CV
X-Google-Smtp-Source: AGHT+IFiDLwVckgqZj0RAK1ABLaotxxMCr44BH2LIYXfl59fXeEy2SIZjm6vqpbLqXxALhJS2PsjoA==
X-Received: by 2002:a05:6a00:2d0a:b0:740:6f69:8d94 with SMTP id d2e1a72fcca58-742acba67c1mr36846715b3a.0.1747995774634;
        Fri, 23 May 2025 03:22:54 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829ce8sm12466688b3a.118.2025.05.23.03.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:22:53 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v8 13/14] RISC-V: KVM: add support for FWFT SBI extension
Date: Fri, 23 May 2025 12:19:30 +0200
Message-ID: <20250523101932.1594077-14-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523101932.1594077-1-cleger@rivosinc.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add basic infrastructure to support the FWFT extension in KVM.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h          |   4 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h      |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  29 +++
 arch/riscv/include/uapi/asm/kvm.h          |   1 +
 arch/riscv/kvm/Makefile                    |   1 +
 arch/riscv/kvm/vcpu_sbi.c                  |   4 +
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 216 +++++++++++++++++++++
 7 files changed, 256 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 4fa02e082142..c3f880763b9a 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_vcpu_sbi_fwft.h>
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_pmu.h>
 
@@ -281,6 +282,9 @@ struct kvm_vcpu_arch {
 	/* Performance monitoring context */
 	struct kvm_pmu pmu_context;
 
+	/* Firmware feature SBI extension context */
+	struct kvm_sbi_fwft fwft_context;
+
 	/* 'static' configurations which are set only once */
 	struct kvm_vcpu_config cfg;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index cb68b3a57c8f..ffd03fed0c06 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -98,6 +98,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_susp;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
new file mode 100644
index 000000000000..9ba841355758
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2025 Rivos Inc.
+ *
+ * Authors:
+ *     Clément Léger <cleger@rivosinc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_FWFT_H
+#define __KVM_VCPU_RISCV_FWFT_H
+
+#include <asm/sbi.h>
+
+struct kvm_sbi_fwft_feature;
+
+struct kvm_sbi_fwft_config {
+	const struct kvm_sbi_fwft_feature *feature;
+	bool supported;
+	unsigned long flags;
+};
+
+/* FWFT data structure per vcpu */
+struct kvm_sbi_fwft {
+	struct kvm_sbi_fwft_config *configs;
+};
+
+#define vcpu_to_fwft(vcpu) (&(vcpu)->arch.fwft_context)
+
+#endif /* !__KVM_VCPU_RISCV_FWFT_H */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 5f59fd226cc5..5ba77a3d9f6e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -204,6 +204,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_SUSP,
+	KVM_RISCV_SBI_EXT_FWFT,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4e0bba91d284..06e2d52a9b88 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -26,6 +26,7 @@ kvm-y += vcpu_onereg.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
 kvm-y += vcpu_sbi.o
 kvm-y += vcpu_sbi_base.o
+kvm-y += vcpu_sbi_fwft.o
 kvm-y += vcpu_sbi_hsm.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_sbi_pmu.o
 kvm-y += vcpu_sbi_replace.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 50be079b5528..0748810c0252 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -78,6 +78,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
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
index 000000000000..b0f66c7bf010
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -0,0 +1,216 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025 Rivos Inc.
+ *
+ * Authors:
+ *     Clément Léger <cleger@rivosinc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/cpufeature.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_vcpu_sbi_fwft.h>
+
+struct kvm_sbi_fwft_feature {
+	/**
+	 * @id: Feature ID
+	 */
+	enum sbi_fwft_feature_t id;
+
+	/**
+	 * @supported: Check if the feature is supported on the vcpu
+	 *
+	 * This callback is optional, if not provided the feature is assumed to
+	 * be supported
+	 */
+	bool (*supported)(struct kvm_vcpu *vcpu);
+
+	/**
+	 * @set: Set the feature value
+	 *
+	 * Return SBI_SUCCESS on success or an SBI error (SBI_ERR_*)
+	 *
+	 * This callback is mandatory
+	 */
+	long (*set)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long value);
+
+	/**
+	 * @get: Get the feature current value
+	 *
+	 * Return SBI_SUCCESS on success or an SBI error (SBI_ERR_*)
+	 *
+	 * This callback is mandatory
+	 */
+	long (*get)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long *value);
+};
+
+static const enum sbi_fwft_feature_t kvm_fwft_defined_features[] = {
+	SBI_FWFT_MISALIGNED_EXC_DELEG,
+	SBI_FWFT_LANDING_PAD,
+	SBI_FWFT_SHADOW_STACK,
+	SBI_FWFT_DOUBLE_TRAP,
+	SBI_FWFT_PTE_AD_HW_UPDATING,
+	SBI_FWFT_POINTER_MASKING_PMLEN,
+};
+
+static bool kvm_fwft_is_defined_feature(enum sbi_fwft_feature_t feature)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_fwft_defined_features); i++) {
+		if (kvm_fwft_defined_features[i] == feature)
+			return true;
+	}
+
+	return false;
+}
+
+static const struct kvm_sbi_fwft_feature features[] = {
+};
+
+static struct kvm_sbi_fwft_config *
+kvm_sbi_fwft_get_config(struct kvm_vcpu *vcpu, enum sbi_fwft_feature_t feature)
+{
+	int i;
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+
+	for (i = 0; i < ARRAY_SIZE(features); i++) {
+		if (fwft->configs[i].feature->id == feature)
+			return &fwft->configs[i];
+	}
+
+	return NULL;
+}
+
+static int kvm_fwft_get_feature(struct kvm_vcpu *vcpu, u32 feature,
+				struct kvm_sbi_fwft_config **conf)
+{
+	struct kvm_sbi_fwft_config *tconf;
+
+	tconf = kvm_sbi_fwft_get_config(vcpu, feature);
+	if (!tconf) {
+		if (kvm_fwft_is_defined_feature(feature))
+			return SBI_ERR_NOT_SUPPORTED;
+
+		return SBI_ERR_DENIED;
+	}
+
+	if (!tconf->supported)
+		return SBI_ERR_NOT_SUPPORTED;
+
+	*conf = tconf;
+
+	return SBI_SUCCESS;
+}
+
+static int kvm_sbi_fwft_set(struct kvm_vcpu *vcpu, u32 feature,
+			    unsigned long value, unsigned long flags)
+{
+	int ret;
+	struct kvm_sbi_fwft_config *conf;
+
+	ret = kvm_fwft_get_feature(vcpu, feature, &conf);
+	if (ret)
+		return ret;
+
+	if ((flags & ~SBI_FWFT_SET_FLAG_LOCK) != 0)
+		return SBI_ERR_INVALID_PARAM;
+
+	if (conf->flags & SBI_FWFT_SET_FLAG_LOCK)
+		return SBI_ERR_DENIED_LOCKED;
+
+	conf->flags = flags;
+
+	return conf->feature->set(vcpu, conf, value);
+}
+
+static int kvm_sbi_fwft_get(struct kvm_vcpu *vcpu, unsigned long feature,
+			    unsigned long *value)
+{
+	int ret;
+	struct kvm_sbi_fwft_config *conf;
+
+	ret = kvm_fwft_get_feature(vcpu, feature, &conf);
+	if (ret)
+		return ret;
+
+	return conf->feature->get(vcpu, conf, value);
+}
+
+static int kvm_sbi_ext_fwft_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    struct kvm_vcpu_sbi_return *retdata)
+{
+	int ret;
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
+static int kvm_sbi_ext_fwft_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+	const struct kvm_sbi_fwft_feature *feature;
+	struct kvm_sbi_fwft_config *conf;
+	int i;
+
+	fwft->configs = kcalloc(ARRAY_SIZE(features), sizeof(struct kvm_sbi_fwft_config),
+				GFP_KERNEL);
+	if (!fwft->configs)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(features); i++) {
+		feature = &features[i];
+		conf = &fwft->configs[i];
+		if (feature->supported)
+			conf->supported = feature->supported(vcpu);
+		else
+			conf->supported = true;
+
+		conf->feature = feature;
+	}
+
+	return 0;
+}
+
+static void kvm_sbi_ext_fwft_deinit(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+
+	kfree(fwft->configs);
+}
+
+static void kvm_sbi_ext_fwft_reset(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+
+	for (i = 0; i < ARRAY_SIZE(features); i++)
+		fwft->configs[i].flags = 0;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
+	.extid_start = SBI_EXT_FWFT,
+	.extid_end = SBI_EXT_FWFT,
+	.handler = kvm_sbi_ext_fwft_handler,
+	.init = kvm_sbi_ext_fwft_init,
+	.deinit = kvm_sbi_ext_fwft_deinit,
+	.reset = kvm_sbi_ext_fwft_reset,
+};
-- 
2.49.0


