Return-Path: <kvm+bounces-44215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D69DA9B574
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:37:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E8671BA528D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539F7292928;
	Thu, 24 Apr 2025 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="0OuXm3eq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D66128F921
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516137; cv=none; b=B09vxrXnEHFH4GdI2DsTat7JDfWGe3Z57cpJ1OBvgt2gYPWQblKppdiVqQ6VS0kQ4jV6e7JNYuY+5oDM7YUxdFt3X1iV6IhUjW/kpF+A6m5unQZvOblE4yXt7DgB46yI9BvUGaWUwpDR1xlHMBn9QW1Ph8gsWWaoRQZZjEi0uSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516137; c=relaxed/simple;
	bh=1C7Djni+0IZk+aDQP5LiExVKCiwH2agzUNaeaAf13I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mh4jg0YrHPBHjmqyjhOH39yqnTK9gb4byTYOTInX8fIepbF8brxf5NzYbellIjqiE9fH1ASjnLRlnHWPqwvqJTT9HLAJAWO5031KpHljA5qt7OGq06Qekkn6gBIxsZ8oZbCemNEigjgF7J5ipKKPo/s7phBTTrLkJxukN8Ne4Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=0OuXm3eq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2260c91576aso11745045ad.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516133; x=1746120933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pIsv+titG4x0ovEMDknM6ko4IiiOufEK1Ymj080VPx4=;
        b=0OuXm3eq5dRrmJC9snSoI50FFQZhAzXlr2ejaAT5uESgat/91ksVjmo48TFG4pcvKM
         5Co3m+5Mz3234mcVxUOf/NNVzDe/SbmAuGyi0dCiB3oJ9SiP5qZhSDvWf9gz6mQfbR57
         G1wMoCqzmDuNtVYRhLw7pQhSFWubBPy38f5+PkFyVO7RXzC+Fbx1mcEmSD3LqnzzV/kt
         AnWoomz7sDsHAMcZra056SNJjtjPoBQEN1FEErY4ANifK464pMTv8byOtSPiyE4DXSXg
         guyR1i/U6T118wdUHWx1ZvQoEncfrHMxqX5EduowiA9F6yoAJrcWZ2wp/zzSzIg09diH
         psEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516133; x=1746120933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIsv+titG4x0ovEMDknM6ko4IiiOufEK1Ymj080VPx4=;
        b=gEI9fiTOX0h69OMhq0ej3PiQ2NQngwi3g/Ii7k9Z2veuwrIIZ82+zByxmXx8uH8niT
         5Nbqt65UzFd15Cij0BMsqSokMelzyp1rvQUzCY7GN/0lyD86bhT9q81S1v538TQOPJCI
         rf81UQq/PjDc5z19/TtH5fK0Bsee6NT/0zqJ3kTuvcPWcuid225KlmITVRjtL0Wm//L8
         veRi8buhzfM4qglDdp/1/EXFRfacl3iJoO7VKTD39TNxOmgZFfEy19PCe5ERlQCSNMr6
         H5YDXqe7RbqPR/DNeppMhgvqcvcx/ciqnd53ZcCG5vj6a0wSJryIoZESM8vwGoPQJdc5
         DaHA==
X-Forwarded-Encrypted: i=1; AJvYcCWLv/PPBbtyP4o0tj2hH5vjYon4NfaMSvpbSG6NjhIUD7YuF7GxuPoW43HTokYqewttUUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBh2ZinEVf3mp6PRKbba4XkpNVcus13brhzSOEced+Tdjzdp3/
	IVfHoFRSCJbYIW3BSWybZftkAeT6QfRtlqEE7ZJ4qlUOId4X9Rr+5gQYQLwUw8M=
X-Gm-Gg: ASbGnctEElC89aS6YMt9Gvb9nLf2uiA/MdtaEMxri47cetEesohziLSZwtYFosvmEHO
	7ECPEONP8vpxadWP3UZVwEy8yWVX5qP0f8UHiOr90g7hfaAWNh6MApHyo3sZ/aFvOGSkn01Dgq/
	rUlahRRGpxZenCumeQswW4EUP0+/QRmPmNh+l8iLO/zV3TWkNB7uvlThPpU6+ctY2IOZQF8T+ro
	PXNsTgxKeUHS5SK/EGs1w801ZJbG0mb3rf6RH2U+9sjI9r7pYAT1l537epEiqdVsN+tJoyaVQv7
	QbYLTVBr43nmb93hn8rVNrxNiEyXm32A/bhL+lwf0Q==
X-Google-Smtp-Source: AGHT+IG9MFmvlCC44cS0jYEh46W0kXDkUBACm39Pu4nHZgkwqd3/vf/EeN8PbrVqTWMOQVYaPZCP6g==
X-Received: by 2002:a17:903:234e:b0:223:67ac:8929 with SMTP id d9443c01a7336-22dbd35407bmr5607675ad.0.1745516133553;
        Thu, 24 Apr 2025 10:35:33 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:35:32 -0700 (PDT)
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
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v6 13/14] RISC-V: KVM: add support for FWFT SBI extension
Date: Thu, 24 Apr 2025 19:32:00 +0200
Message-ID: <20250424173204.1948385-14-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424173204.1948385-1-cleger@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
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


