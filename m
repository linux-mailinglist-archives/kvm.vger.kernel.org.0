Return-Path: <kvm+bounces-18774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C68B08FB2BF
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9C0A1C259BD
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931FF14900F;
	Tue,  4 Jun 2024 12:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="U+p23sfp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B01146A6F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717505263; cv=none; b=no0xV3ue4Gr16QGv3SplO5xuKTVQxrogtfnHAmQy63VosNjW3GeMfaeTOMIK0Lyj9L+zGPGIqX2krVk4TYQP/uqi/BPOEYrhlL+KQvnR2ZzqQ7Nm3GSJuwnpJ8An+jkbMnVYFuWB52E0lY3H7Qw77Omox5iSv6ZIVcOix+zG+Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717505263; c=relaxed/simple;
	bh=5lPde1lVaL6QdtLL2hBIKF9CCeYfvrnQ+MEu7+WJ2m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lst09mLx7O8fONS8bREBPBpmXnQQAhjwdSxH1jAVVis403S1D0j0gCZoyl0C5uFnXnZoq5ZErPuC9rhvVi1VBDN7wX34GGldnv9XM3uhWz4Wzz5wRaQ+E0wPa8mFncV/8WIxBYJUQDMzlmdk41dyzUaXWIYV66tAjDWHbonqIlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=U+p23sfp; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f2e3249d5eso4367735ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 05:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1717505261; x=1718110061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjP9cWqi8MF5LcHAVib0g8zUfroe29LCYWJfLV/r52Y=;
        b=U+p23sfpcAORgGucpF2O0xGw6nU9e1xLomxg+sMdYnXWc2uOCnLjSG1lJdVq91nAqq
         obneeaT5KdyeD+vC+KZFQj0+gW3tzdQP3o6H4iIUrPhJcHRQQHyW46CnNoDgZslNDmpY
         IsGXIpJ+jdAqpox5uRl+gCGSgO+W3bIf0WSj/WE08ocyF/OMiab3ZOivvKFiX+bpFcs+
         3wdkwJUSTUr4WKe1BdGrDuDO+xsaJe074UjB3OxgEkoeQ0aZbR4wyeJ0jWbtDiswiuAP
         vQNCeSsHTkCIp9rQCJ2+9RZBII5ZVKQsy38zxbnlkVU0DLTdIgSir/rI+iq2aibvBKYA
         hyHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717505261; x=1718110061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MjP9cWqi8MF5LcHAVib0g8zUfroe29LCYWJfLV/r52Y=;
        b=PR8VX4QN++mSmVhNW4TkbM9Rbwu1KsrsJ4qaczVZK/yo51CflYSisb249chDn0yNKG
         0eYtIl6lFnnVk9MRj06Hqi98jXVx/z4W7//pbayQp0tJIGICTs53jZENkxryJOlk+Fnh
         keeg6AZZV8xdg/+MUg0MzdXX08q78JwOhcC08bj6LadLaln4rdGgvKww2ZBqwDRbonlS
         B8ck8lg0uH5YUPkGgg5nv85Ls7JNffKUVS1NLb/GwIqI/xBlmHXfMw+C8HzjU56IjWPG
         5TA8xiJLkwsRCIaWfprfxX0DGtG3I1AYz30H0xLxZ3MHYeY4X+tj0PNeGH5JY2Q4AfcJ
         bnYg==
X-Forwarded-Encrypted: i=1; AJvYcCWvoQXDUV2k9rWYmYdwePYs9xW64+ASQqZzJfVtJOq1NbEdqN5Oj8MlJmSx0TryJrZp38ndhEEOP6YzVa8y0irteHHx
X-Gm-Message-State: AOJu0YzuhseOmsmaDKJRpjLGTxSELaHCcSKLcbw+z79UdQJd6p1W/v3p
	9xsu+qM36viEw6fg3qa4F4tUcW8KgMoo9rSY2bMwkZyqGca4RbTigwDFqmNb23I=
X-Google-Smtp-Source: AGHT+IE8wijIs7nBE2lAM+asVyiMEjL4UrorzZ1e540mUci5kPZaEXedGsRaMEEhVJegjQvm1F51AQ==
X-Received: by 2002:a17:902:ec8c:b0:1f2:ffbc:7156 with SMTP id d9443c01a7336-1f636fcf230mr129979715ad.1.1717505261548;
        Tue, 04 Jun 2024 05:47:41 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:327b:5ba3:8154:37ed])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323ebc69sm83042885ad.211.2024.06.04.05.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 05:47:41 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v6 08/16] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
Date: Tue,  4 Jun 2024 14:45:40 +0200
Message-ID: <20240604124550.3214710-9-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240604124550.3214710-1-cleger@rivosinc.com>
References: <20240604124550.3214710-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Zc* standard extension for code reduction introduces new extensions.
This patch adds support for Zca, Zcf, Zcd and Zcb. Zce, Zcmt and Zcmp
are left out of this patch since they are targeting microcontrollers/
embedded CPUs instead of application processors.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/hwcap.h |  5 +++-
 arch/riscv/kernel/cpufeature.c | 55 +++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 543e3ea2da0e..3915c9cb088b 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -82,7 +82,10 @@
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
 #define RISCV_ISA_EXT_ZIMOP		75
-
+#define RISCV_ISA_EXT_ZCA		76
+#define RISCV_ISA_EXT_ZCB		77
+#define RISCV_ISA_EXT_ZCD		78
+#define RISCV_ISA_EXT_ZCF		79
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
 #define RISCV_ISA_EXT_MAX		128
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index d20e236cec8b..53c7ca590a22 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -111,6 +111,9 @@ static int riscv_ext_zicboz_validate(const struct riscv_isa_ext_data *data,
 
 #define __RISCV_ISA_EXT_DATA(_name, _id) _RISCV_ISA_EXT_DATA(_name, _id, NULL, 0, NULL)
 
+#define __RISCV_ISA_EXT_DATA_VALIDATE(_name, _id, _validate) \
+			_RISCV_ISA_EXT_DATA(_name, _id, NULL, 0, _validate)
+
 /* Used to declare pure "lasso" extension (Zk for instance) */
 #define __RISCV_ISA_EXT_BUNDLE(_name, _bundled_exts) \
 	_RISCV_ISA_EXT_DATA(_name, RISCV_ISA_EXT_INVALID, _bundled_exts, \
@@ -122,6 +125,37 @@ static int riscv_ext_zicboz_validate(const struct riscv_isa_ext_data *data,
 #define __RISCV_ISA_EXT_SUPERSET_VALIDATE(_name, _id, _sub_exts, _validate) \
 	_RISCV_ISA_EXT_DATA(_name, _id, _sub_exts, ARRAY_SIZE(_sub_exts), _validate)
 
+static int riscv_ext_zca_depends(const struct riscv_isa_ext_data *data,
+				 const unsigned long *isa_bitmap)
+{
+	if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA))
+		return 0;
+
+	return -EPROBE_DEFER;
+}
+static int riscv_ext_zcd_validate(const struct riscv_isa_ext_data *data,
+				  const unsigned long *isa_bitmap)
+{
+	if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
+	    __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_d))
+		return 0;
+
+	return -EPROBE_DEFER;
+}
+
+static int riscv_ext_zcf_validate(const struct riscv_isa_ext_data *data,
+				  const unsigned long *isa_bitmap)
+{
+	if (IS_ENABLED(CONFIG_64BIT))
+		return -EINVAL;
+
+	if (__riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
+	    __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_f))
+		return 0;
+
+	return -EPROBE_DEFER;
+}
+
 static const unsigned int riscv_zk_bundled_exts[] = {
 	RISCV_ISA_EXT_ZBKB,
 	RISCV_ISA_EXT_ZBKC,
@@ -202,6 +236,21 @@ static const unsigned int riscv_xlinuxenvcfg_exts[] = {
 	RISCV_ISA_EXT_XLINUXENVCFG
 };
 
+/*
+ * Zc* spec states that:
+ * - C always implies Zca
+ * - C+F implies Zcf (RV32 only)
+ * - C+D implies Zcd
+ *
+ * These extensions will be enabled and then validated depending on the
+ * availability of F/D RV32.
+ */
+static const unsigned int riscv_c_exts[] = {
+	RISCV_ISA_EXT_ZCA,
+	RISCV_ISA_EXT_ZCF,
+	RISCV_ISA_EXT_ZCD,
+};
+
 /*
  * The canonical order of ISA extension names in the ISA string is defined in
  * chapter 27 of the unprivileged specification.
@@ -248,7 +297,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(f, RISCV_ISA_EXT_f),
 	__RISCV_ISA_EXT_DATA(d, RISCV_ISA_EXT_d),
 	__RISCV_ISA_EXT_DATA(q, RISCV_ISA_EXT_q),
-	__RISCV_ISA_EXT_DATA(c, RISCV_ISA_EXT_c),
+	__RISCV_ISA_EXT_SUPERSET(c, RISCV_ISA_EXT_c, riscv_c_exts),
 	__RISCV_ISA_EXT_DATA(v, RISCV_ISA_EXT_v),
 	__RISCV_ISA_EXT_DATA(h, RISCV_ISA_EXT_h),
 	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicbom, RISCV_ISA_EXT_ZICBOM, riscv_xlinuxenvcfg_exts,
@@ -267,6 +316,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
 	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
 	__RISCV_ISA_EXT_DATA(zfhmin, RISCV_ISA_EXT_ZFHMIN),
+	__RISCV_ISA_EXT_DATA(zca, RISCV_ISA_EXT_ZCA),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zcb, RISCV_ISA_EXT_ZCB, riscv_ext_zca_depends),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zcd, RISCV_ISA_EXT_ZCD, riscv_ext_zcd_validate),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zcf, RISCV_ISA_EXT_ZCF, riscv_ext_zcf_validate),
 	__RISCV_ISA_EXT_DATA(zba, RISCV_ISA_EXT_ZBA),
 	__RISCV_ISA_EXT_DATA(zbb, RISCV_ISA_EXT_ZBB),
 	__RISCV_ISA_EXT_DATA(zbc, RISCV_ISA_EXT_ZBC),
-- 
2.45.1


