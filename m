Return-Path: <kvm+bounces-15651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C2B8AE696
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:44:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E95B81C2201C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA484134CC0;
	Tue, 23 Apr 2024 12:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="S22OoSS9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FCD12F380
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713876227; cv=none; b=rvDMxEvwOA2Rf1Sln3JSYotBB9sgOILt4SPbhuovSaQPLNPTcHb4VyZSEa6YKtpKE0DcLonfsk12+EKChJTtWHhtpuefN+oodAzODaNtHH4mIeWmEFRL+VTOK8ebQm1D9b8egWguOD896iGCdbLLn+AWKJ8MZLThyp1t+PkjbCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713876227; c=relaxed/simple;
	bh=lXHesYNn+SPY+KKQCxDfO/pMRkhpzCoAd9fRQpJMBos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kaSIITO7n1b8/aMk3uIfcmkl92Bs+d0ijSAKqjLJBMXg4tl1URTabcg8S89oLUozxy/GiBn81KIq9LolhS2qQ/9mIuLR3U8xN2OCB8ED92JwH4T10xibKT1dHEkidr4/SrYKre72RxvG4FteaC7NB0+5/kmemlUriuLLfOg6np8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=S22OoSS9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-34b3f376515so69913f8f.2
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 05:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713876224; x=1714481024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUZbX4he9n4q1vZFYMxp+s3nYLKyrFtBWJZsTu2EIzo=;
        b=S22OoSS9Cp5/Nl8lEMlIYYfGwv0Ozvy7wPj48m2AI1rT/LVZgOH3oz4ehDrW8Bu/3R
         uOlAROK6c1vOd2giv0lPYU9pXQ/fxU6CmaqM+Lb2i+NWF0MLu0pr7i3scEcvrTfULAcH
         CXBWFMZvpnZttqtYzsjIT3XXHVJj7PPUl7Ua9UUxaKIfYsFFwFQEDlXSFUlkcHJIXa4g
         NdaegNS2jKe48Wr9sX7TdIFb0NZTtZoC8DVZZS1U3rsx35SE8A29tfhJfW2+rXTUenUv
         kf7cYE8h5w2grSdbWmncxGmwfAa+jiiRRvflOseLkW7WZJ7r5IztmRvncW3u6edMZQcf
         WRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713876224; x=1714481024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TUZbX4he9n4q1vZFYMxp+s3nYLKyrFtBWJZsTu2EIzo=;
        b=e/FHbzOI1R50yhdWUTqMGv0CPXtzE/UHdgs3Iy76R+x7w6+xIhsDQgq3DJ1Wi9NiGx
         8FRFpxARlMACKiPJLFtVHjs6VpZ+cs7GzncmHtgV7zzW3IM7BE35HolqLaB/MTlRxywl
         amUWHPWIjfDcD4WhnKiVd6E7EoJH+YfrDsXnWjRsGnxQUa8SeUu1uHoSwiu12eNkqU+g
         vFiI/ik0kXqP64SCqBhUwDO049nfv07OjM84Eek2h5DtH/XyCXW13XAZhwK+VYWNQanA
         4OK0gWkt4rFEociysjTGfC9867rrkZOMy2e/ISDPbSA6EYo6YNiBsQTjw4oW6rkUQCFG
         BArA==
X-Forwarded-Encrypted: i=1; AJvYcCUnBxjj79h2ECNOIKFVtVG3rBNOSTvOGULqVhUOUmCEtTAPILxq1a9570ftP7uv31dSk9M3OnbhmkOatVhGEJ742iwg
X-Gm-Message-State: AOJu0Ywc7VQ6SB5Nfac3U60+pujKQGI4VD/+kZTIeXNXBoRRR/mbkhYa
	Ujo5TA28ulh4UaI5zpmomVfaoyW0uSBM+eEOFREd9NsoFCk4UE6VF34tK5Yk4Qs=
X-Google-Smtp-Source: AGHT+IGbIVzcAn3QLqtxJnElWT6wqDhKCqDt4jI+gjpB2p8+cPOxRO/7EwBoQJ6Mrahyga7IgRhsSA==
X-Received: by 2002:a05:600c:3b8a:b0:419:f241:6336 with SMTP id n10-20020a05600c3b8a00b00419f2416336mr6604286wms.1.1713876224214;
        Tue, 23 Apr 2024 05:43:44 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:71cb:1f75:7053:849c])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm19975709wmo.42.2024.04.23.05.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 05:43:43 -0700 (PDT)
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
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 03/11] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
Date: Tue, 23 Apr 2024 14:43:17 +0200
Message-ID: <20240423124326.2532796-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240423124326.2532796-1-cleger@rivosinc.com>
References: <20240423124326.2532796-1-cleger@rivosinc.com>
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
---
 arch/riscv/include/asm/hwcap.h |  4 +++
 arch/riscv/kernel/cpufeature.c | 47 +++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 543e3ea2da0e..b7551bad341b 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -82,6 +82,10 @@
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
 #define RISCV_ISA_EXT_ZIMOP		75
+#define RISCV_ISA_EXT_ZCA		76
+#define RISCV_ISA_EXT_ZCB		77
+#define RISCV_ISA_EXT_ZCD		78
+#define RISCV_ISA_EXT_ZCF		79
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 6d238c8dbccf..24bf3fbc0578 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -107,6 +107,29 @@ static bool riscv_ext_zicboz_validate(const struct riscv_isa_ext_data *data,
 	return true;
 }
 
+static bool riscv_ext_zca_depends(const struct riscv_isa_ext_data *data,
+				   const unsigned long *isa_bitmap)
+{
+	return __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA);
+}
+static bool riscv_ext_zcd_validate(const struct riscv_isa_ext_data *data,
+				   const unsigned long *isa_bitmap)
+{
+	return __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
+	       __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_d);
+}
+
+static bool riscv_ext_zcf_validate(const struct riscv_isa_ext_data *data,
+				   const unsigned long *isa_bitmap)
+{
+#ifdef CONFIG_64BIT
+	return false;
+#else
+	return __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_ZCA) &&
+	       __riscv_isa_extension_available(isa_bitmap, RISCV_ISA_EXT_f);
+#endif
+}
+
 #define _RISCV_ISA_EXT_DATA(_name, _id, _subset_exts, _subset_exts_size, _validate) {	\
 	.name = #_name,									\
 	.property = #_name,								\
@@ -118,6 +141,9 @@ static bool riscv_ext_zicboz_validate(const struct riscv_isa_ext_data *data,
 
 #define __RISCV_ISA_EXT_DATA(_name, _id) _RISCV_ISA_EXT_DATA(_name, _id, NULL, 0, NULL)
 
+#define __RISCV_ISA_EXT_DATA_VALIDATE(_name, _id, _validate) \
+			_RISCV_ISA_EXT_DATA(_name, _id, NULL, 0, _validate)
+
 /* Used to declare pure "lasso" extension (Zk for instance) */
 #define __RISCV_ISA_EXT_BUNDLE(_name, _bundled_exts) \
 	_RISCV_ISA_EXT_DATA(_name, RISCV_ISA_EXT_INVALID, _bundled_exts, \
@@ -209,6 +235,21 @@ static const unsigned int riscv_xlinuxenvcfg_exts[] = {
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
@@ -255,7 +296,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(f, RISCV_ISA_EXT_f),
 	__RISCV_ISA_EXT_DATA(d, RISCV_ISA_EXT_d),
 	__RISCV_ISA_EXT_DATA(q, RISCV_ISA_EXT_q),
-	__RISCV_ISA_EXT_DATA(c, RISCV_ISA_EXT_c),
+	__RISCV_ISA_EXT_SUPERSET(c, RISCV_ISA_EXT_c, riscv_c_exts),
 	__RISCV_ISA_EXT_DATA(v, RISCV_ISA_EXT_v),
 	__RISCV_ISA_EXT_DATA(h, RISCV_ISA_EXT_h),
 	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicbom, RISCV_ISA_EXT_ZICBOM, riscv_xlinuxenvcfg_exts,
@@ -274,6 +315,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
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
2.43.0


