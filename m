Return-Path: <kvm+bounces-34608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC08EA02C23
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4D553A2D0F
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA891DED60;
	Mon,  6 Jan 2025 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="MYwukq9M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4315B1DED49
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178574; cv=none; b=Sh2kv5my7zw0JbGeLnNkJOa6tWwstChNIim6rsjB9kucflwLSmAm1ZdVV2eb5e4EeZkO5e7ECpL8BnCkahVtlNJASy7LPDg9CErEQT9ewa0yv+t239O/XM8OHyCqTeN7H0KAb108A3L2YTbfIIBOO/FOMHG4jmetJJrz4aSsFmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178574; c=relaxed/simple;
	bh=Sf4mkChjGPawhlMdNs6sYUSQY7rxaMa0aiV0h0QaDa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j4mbuzf05RsFWXRfj41TXfhe7nW+euGaPgSiK0/4x0CgIML8GMunzgF75HeCi0GtRRPgvtjoSkr4wJ1Sqscihz4Of/zFiZtezaLEMLFeETuKqAjOcs8XJ3dVIm53JhgXSJOUj3g92CN6V8j2ezlEnFnV7ZPpMFejfOMEZqGYOoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=MYwukq9M; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ee46851b5eso17079499a91.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178571; x=1736783371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmv3FPl4GV//dUdGFHsJuNQdfa6373N/9drpleSw3Cw=;
        b=MYwukq9MQH5upUsoLwco47QFT5a1gR1m1slm41nhclncH1ftzUPSsdl1KZVp1KZCF/
         a2aOfYxKiTAUOZfwmfmW8OB/sNfPN5CcZxngwpbyI+FupsR64fcN0FJjyco3xCWFHCg2
         zwtU6gK7D5JjeAnFVYOyiyHxc2ssNLvkjCIZvnWdIDKPf0lN8mrvNbvOAVJqFQGmwU/B
         tE31Anuo3PdZY4YGUrjfV6DCa3RtjHvQKDluZVQtos+Vw3vOcWKGm/JbIfdulBAJNWg/
         7mfO2sFjkqqe7RsjAedQ6jLAlvQ54DhqBsi1ZIW2tjpwm4LxL47eHdSJmW0mGZ5VlD3u
         OF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178571; x=1736783371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmv3FPl4GV//dUdGFHsJuNQdfa6373N/9drpleSw3Cw=;
        b=ThjnJTX1TMKVa/5kIj+3rsF3l2zzUEtzXbHBYzQPo125Zl0gpmcWCQn2mwiKne0W8t
         KPhP+vJhEakepaT3j3/+ebbY2qem4O4FXqx4Sui9aIDayjSwO0IxEtJivFcg9aH6dJqy
         4qoA8sHrq6IWxK2JKs5s4VoP/GE3PPk+WVL+5YEA64ux6bljvg65ADzyAEe6VWvbmnZr
         H3vPlMJtpsRRNBl3ODnvA1o1jRY2EZ62qunw+2gvMZWNq91b09BNQtRZX50nosy3O1wA
         2mhKNSwdVJ4TGArpE6nW3dqhA72rb+4yeRA00B+xi36AmzH3dYkSBcTMD4iE4IGc/MTi
         /hyA==
X-Forwarded-Encrypted: i=1; AJvYcCX6ahaup8x+pJ+zgh57e6/P09Pd/zvMetMtTyf62F3umW4tn8WnXSjDfF3zjLJaG2Y4/M4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi2ZIqGpD0WnFcJygYZRA/VfghhMLNgNYlicvEoey5zgrPqiEF
	3QhPYAeHlkdn5Cd9LsvSoErSGVYwAMOK4Xn8UYHu84dUFSWPkQy2zVCOuwnli9w=
X-Gm-Gg: ASbGncvqejwD+yBsI6/i2/NFntco0dd82g4LhSeTEqWZxHkQ8CijOAxos3nnBcO0hok
	nFwmnlHmFzq2+qBETRz+NY7llg0aYWalAKvtBb3aMnVBkAsiGs4x9TFnofgA+DH4jJhuop+oPl8
	BQy2GqYQ5iuHDUB2xzFWV1KbzZLGEpclzhRBIWTtL+y0zye6KrcAsHC/386PVRbSq/iiskYdmEC
	nwEqUAvtZ1kwZcmmXFMHW3vb60BPdJkaAu+lk+AenOV2rsDCnxlBBfq0A==
X-Google-Smtp-Source: AGHT+IHmlaHSPqFlwypLhD4uQLLN0+z7Y6gy5e30raQNWiHTPxZ57UoHgVMO9gETG3Wu9LX0cFWz9w==
X-Received: by 2002:a17:90a:da8e:b0:2ee:9d65:65a7 with SMTP id 98e67ed59e1d1-2f452ec6ff3mr89290918a91.29.1736178571339;
        Mon, 06 Jan 2025 07:49:31 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:30 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 4/6] RISC-V: KVM: add support for FWFT SBI extension
Date: Mon,  6 Jan 2025 16:48:41 +0100
Message-ID: <20250106154847.1100344-5-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106154847.1100344-1-cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
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
---
 arch/riscv/include/asm/kvm_host.h          |   4 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h      |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h |  37 +++++
 arch/riscv/include/uapi/asm/kvm.h          |   1 +
 arch/riscv/kvm/Makefile                    |   1 +
 arch/riscv/kvm/vcpu_sbi.c                  |   4 +
 arch/riscv/kvm/vcpu_sbi_fwft.c             | 176 +++++++++++++++++++++
 7 files changed, 224 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
 create mode 100644 arch/riscv/kvm/vcpu_sbi_fwft.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 35eab6e0f4ae..9bd046ed7907 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -19,6 +19,7 @@
 #include <asm/kvm_vcpu_fp.h>
 #include <asm/kvm_vcpu_insn.h>
 #include <asm/kvm_vcpu_sbi.h>
+#include <asm/kvm_vcpu_sbi_fwft.h>
 #include <asm/kvm_vcpu_timer.h>
 #include <asm/kvm_vcpu_pmu.h>
 
@@ -276,6 +277,9 @@ struct kvm_vcpu_arch {
 	/* Performance monitoring context */
 	struct kvm_pmu pmu_context;
 
+	/* Firmware feature SBI extension context */
+	struct kvm_sbi_fwft fwft_context;
+
 	/* 'static' configurations which are set only once */
 	struct kvm_vcpu_config cfg;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 8c465ce90e73..7ff200a1ad3b 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -95,6 +95,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
new file mode 100644
index 000000000000..5782517f6e08
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h
@@ -0,0 +1,37 @@
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
+struct kvm_sbi_fwft_config;
+struct kvm_vcpu;
+
+struct kvm_sbi_fwft_feature {
+	enum sbi_fwft_feature_t id;
+	bool (*supported)(struct kvm_vcpu *vcpu);
+	int (*set)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long value);
+	int (*get)(struct kvm_vcpu *vcpu, struct kvm_sbi_fwft_config *conf, unsigned long *value);
+};
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
index 3482c9a73d1b..0813145a6272 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -198,6 +198,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
+	KVM_RISCV_SBI_EXT_FWFT,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 0fb1840c3e0a..ece6b119913a 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -32,6 +32,7 @@ kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_sbi_sta.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
 kvm-y += vcpu_switch.o
+kvm-y += vcpu_sbi_fwft.o
 kvm-y += vcpu_timer.o
 kvm-y += vcpu_vector.o
 kvm-y += vm.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d2dbb0762072..5bf6c92cca5b 100644
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
index 000000000000..55433e805baa
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -0,0 +1,176 @@
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
+	int i = 0;
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
+static int kvm_fwft_get_feature(struct kvm_vcpu *vcpu,
+				enum sbi_fwft_feature_t feature,
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
+static int kvm_sbi_fwft_set(struct kvm_vcpu *vcpu,
+			    enum sbi_fwft_feature_t feature,
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
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
+	.extid_start = SBI_EXT_FWFT,
+	.extid_end = SBI_EXT_FWFT,
+	.handler = kvm_sbi_ext_fwft_handler,
+	.init = kvm_sbi_ext_fwft_init,
+	.deinit = kvm_sbi_ext_fwft_deinit,
+};
-- 
2.47.1


