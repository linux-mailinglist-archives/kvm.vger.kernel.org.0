Return-Path: <kvm+bounces-19966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2221B90E9BA
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:38:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8431CB23972
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B05B714E2E1;
	Wed, 19 Jun 2024 11:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="BMfwsvZS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2C714B967
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796950; cv=none; b=feHH/yNM+fEQHo2HuHfJi7IccT7+HTXXr/fzRaI+LCdM5R0T57UGOBHk9brhthNMttFmgDwvO1Ft+E/aVXNzryANZioeE7u1LqAemuNdYbcKOWGjrIIlmsVeB6ZgRGHnhz/U3uMO/Zl8YoEjVSlNjAw187Mrh8Fb7K5niDHUxa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796950; c=relaxed/simple;
	bh=gK52ggJdJamxyHdrTWYF1YKUSMaTildGwsSqayUiuzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdbINlK//ydg691LmTDyvPnT0I6DTJnc5BQAhA5mfgnbcoEu6Gus19+XMp9cN2iChj0NdNyXSTUn3GEU+hr/QHMDA2yTUYy1G0e1EbDTzKzdL+cW1yw+IHYzMuf8DME4MRUmTk9Sg8q3sV+wnZUvySI4kEZD1Imm1Plh0wMvOVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=BMfwsvZS; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-363db2f9fc5so47549f8f.1
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796946; x=1719401746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=luuWYSLXcV5+8J7r5WvQusu30sDK3pgwQTMW2O5hJ3s=;
        b=BMfwsvZSigOzZBsyFj8TxDWX7VIyOWWy/0vSzcTT0CCc+GM6blLtA68tY5fXWLF2oh
         C338Paj8L4OnQ5JxsculFf5Ha1YvVnZiJI4pfsUBfpgm+sMJyfOLebRfoGV4YLCIUZiE
         fMYqAXRzADyDRVlcGbTafAq4sgRNeVO+7jTexztp6HDxWFoNrlVaN+8oluOod64sc0jD
         lpIY4gfTnsPOdTIMFJ9Bt1njubqSOQ4d/XRnj5M7xH4X+kYnQBYz6VJTkyCZjM1o+8Ia
         sZEcN49BMQpiyCFdkvcEYNj/3YRchuyclE6/fudnbqqS2AfYcZzsGo7YGOqHdYrw5z0C
         +xTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796946; x=1719401746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luuWYSLXcV5+8J7r5WvQusu30sDK3pgwQTMW2O5hJ3s=;
        b=v6EKLjVFcGVHDwz1pKyn/sJq58NgItCaXdsaSPglBxuVta9nSGHMByrc3nTOEJHJlJ
         Z2SiCynprq+BXXvPHwP06uN+XQVWrJboLopvJRR68zS30AsV7dUPSnWTWbYBlu1gIFsf
         4SJOdcGpl1PjKNwbUiLJxmyn4QhEM3tKLYX3JRbX3Tfe9QaxRigSJSIyXS3vCyHyDV8z
         ew8uJ21yomuXvhC87tLkeB3sMHx0IfzHLn+GjwAK9qelth8gmf/ZEcM0knbyq/abQ+B+
         alFQ+qxCye2zGvswIGAQwZuPF0PEaX+wDS+0K4cvHndPeu94zedycWjCI0vp/erZ8X0n
         2YQg==
X-Forwarded-Encrypted: i=1; AJvYcCUjgbKViIE+RbFLU2+I90zxY+KXDJiug2HB6lb5L3m5Wb/0Bx75znRe2YFnxygW3vT5Lc1jzq00iCj0k2yllfoOKHC3
X-Gm-Message-State: AOJu0Yym/5RAlxCG59QZmZ1wpXBBX932fBxHtnfq4/Bur2xCNU2kf8GF
	xR/jDSYQ/8VmWBlkG2Id3pvTIjudEO8uFzYJY8MrBaBzgkKVv41xHI92DShJ/PQ=
X-Google-Smtp-Source: AGHT+IFzGS/p4a4mBQ/inU2s0uZu8vrDHSaWFV9V52yXQFOztuj4Wss5NZDJltC9s5gFdnIi8Cu3yA==
X-Received: by 2002:a05:600c:3ba5:b0:421:f441:e804 with SMTP id 5b1f17b1804b1-42475c2138amr13486685e9.4.1718796946112;
        Wed, 19 Jun 2024 04:35:46 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:44 -0700 (PDT)
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
Subject: [PATCH v7 08/16] riscv: add ISA parsing for Zca, Zcf, Zcd and Zcb
Date: Wed, 19 Jun 2024 13:35:18 +0200
Message-ID: <20240619113529.676940-9-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619113529.676940-1-cleger@rivosinc.com>
References: <20240619113529.676940-1-cleger@rivosinc.com>
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
 arch/riscv/include/asm/hwcap.h |  4 +++
 arch/riscv/kernel/cpufeature.c | 55 +++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 18859277843a..b12ae3f2141c 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -87,6 +87,10 @@
 #define RISCV_ISA_EXT_ZVE64F		78
 #define RISCV_ISA_EXT_ZVE64D		79
 #define RISCV_ISA_EXT_ZIMOP		80
+#define RISCV_ISA_EXT_ZCA		81
+#define RISCV_ISA_EXT_ZCB		82
+#define RISCV_ISA_EXT_ZCD		83
+#define RISCV_ISA_EXT_ZCF		84
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index a3af976f36c9..aa631fe49b7c 100644
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
@@ -236,6 +270,21 @@ static const unsigned int riscv_xlinuxenvcfg_exts[] = {
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
@@ -282,7 +331,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(f, RISCV_ISA_EXT_f),
 	__RISCV_ISA_EXT_DATA(d, RISCV_ISA_EXT_d),
 	__RISCV_ISA_EXT_DATA(q, RISCV_ISA_EXT_q),
-	__RISCV_ISA_EXT_DATA(c, RISCV_ISA_EXT_c),
+	__RISCV_ISA_EXT_SUPERSET(c, RISCV_ISA_EXT_c, riscv_c_exts),
 	__RISCV_ISA_EXT_SUPERSET(v, RISCV_ISA_EXT_v, riscv_v_exts),
 	__RISCV_ISA_EXT_DATA(h, RISCV_ISA_EXT_h),
 	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicbom, RISCV_ISA_EXT_ZICBOM, riscv_xlinuxenvcfg_exts,
@@ -301,6 +350,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
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
2.45.2


