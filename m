Return-Path: <kvm+bounces-17626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E348C88B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCCA31C21B99
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D980978C6D;
	Fri, 17 May 2024 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="UdSglax6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB41757F3
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957611; cv=none; b=A+xNT7yrm4sNQ8JTmLCnOoMGHGuyUImrHHTUbixINmI7TR4V90pbVY4viDNDijkl6EyPRnu2GsyoiEiL1ApUjSlaYM+6Ltr9oKaDaJw95aHL1TDJW3zq0VP9iDPGSjZD+++j8HordSkLsHbZrJ9Ljl64jv/mhwjKEXLCzkjJyRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957611; c=relaxed/simple;
	bh=eagQAECzO2hi4eNtQCPhd0tHFgKGQg2VQEsmUNc/frk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a0D0wpkeMpMO9dAfF3qmWt3zFw7cnWdQkqbMzTKaVgbaUgZzerw4vl8k5MGNl8LvB6XTh3ZJrk8c4P/RCdtFmtmLlgyuAfi4Lr7LCqn0+N0DRpwtiEd0AIBu34qmfxm9NOLoTjOqzxqJ14WNLoCcD/oB2FY27TI2ATppv5om1Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=UdSglax6; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2e2a216758bso1260511fa.3
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 07:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1715957607; x=1716562407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZcvU9Yv1rOWLKDlgsJRQ29S24RYbUTnQ4T9H9DZeCs=;
        b=UdSglax6OzNRqIZ9f/fg1l8KSw4m/fQ9w9x7oAy6CSZE1uGLYJSlNEznVW2q2U09UD
         YLVABUg33s0tGJ8cL0nQ/J3X9czyuMK4BpWuxJpMkJRtQO8rywF3B9bzNUxsOTIkq9FM
         r+t3mSe/oC2Vdhu+KUv0BydYVv3iFIPMsc3zHUDkfJwnvxPUm65YNR0wi3I1qkljCYRi
         p02/GRRvMoHJfQyaAxCEp+l11jdcY33kQLGmk9DuNHY89VonkJ5hdB0fJQI+G3ZrDj1o
         COVZtVF8ebOSm+UDm/Ms9NX6i2axZai6ujmZCgCZHURiZ/yKq8oKwK/FFbeSh/lZl+rB
         Kk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957607; x=1716562407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZcvU9Yv1rOWLKDlgsJRQ29S24RYbUTnQ4T9H9DZeCs=;
        b=NvF+atMpoO2bRDS35ENesVrxs0q3y6Og7Fzu/QomsWmWG2sE0TEDUzvMO7OKMqV4zv
         UKUd/jFL0n8Q5bSIlEg97hCkdwnOVyY1IqNGJJMTfKAazmsBtKBFEGt4jgCo/JNZpL2W
         qw00HuVf1VUCO3QjGt2X/lz1Ukyxfosk15UIe1QUxIuaosPIfzIUWhRkFkyvudb7RL/r
         zxy5AlFaUyHSPumr/UPTDjFZ/Mk5lZpWqcnvSGxa5yJO02/tUYauYA9Hy7kWgpmVvhC7
         422PQR1jg8AWaMVb6t1+Q1UFuaerYaiVkskypjXuSzo+Hb1z2MRzyXUucHMA8gaqN7DW
         jt4w==
X-Forwarded-Encrypted: i=1; AJvYcCVAK/ytO6S1sKvxioac0Oohh+tzyW1CW3Z3dSlFbx5wCUNhPTjewAdNIWbXh0Wd1QV7vWfVvH5o5wNA59PpoCIYmZVa
X-Gm-Message-State: AOJu0YzqnjDF98NhTttMH5VygRzpL7r/EQUpw/DUqdO3W9pOnHQTVWEX
	KwTgQXNQz7+Ohpx06IYHkhI0TDpsm2OVNyud/lvJUhZm4zh6ldOVDgipTHBu6/E=
X-Google-Smtp-Source: AGHT+IG0JRKQ4JGhSQKFCaG8K/egrvdoE99BfZAMCAGRo6YHIr6ZDAXQWFJBuUmfJPoMXhQY3Pg2tg==
X-Received: by 2002:a2e:a211:0:b0:2e2:714c:23d2 with SMTP id 38308e7fff4ca-2e51fd3125dmr162327021fa.1.1715957607233;
        Fri, 17 May 2024 07:53:27 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:46f0:3724:aa77:c1f8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41fccce9431sm301723695e9.28.2024.05.17.07.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:53:26 -0700 (PDT)
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
Subject: [PATCH v5 09/16] riscv: hwprobe: export Zca, Zcf, Zcd and Zcb ISA extensions
Date: Fri, 17 May 2024 16:52:49 +0200
Message-ID: <20240517145302.971019-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240517145302.971019-1-cleger@rivosinc.com>
References: <20240517145302.971019-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export Zca, Zcf, Zcd and Zcb ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 20 ++++++++++++++++++++
 arch/riscv/include/uapi/asm/hwprobe.h |  4 ++++
 arch/riscv/kernel/sys_hwprobe.c       |  4 ++++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index 48be38e0b788..cad84f51412d 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -196,6 +196,26 @@ The following keys are defined:
        supported as defined in the RISC-V ISA manual starting from commit
        58220614a5f ("Zimop is ratified/1.0").
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCA`: The Zca extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCB`: The Zcb extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCD`: The Zcd extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCF`: The Zcf extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 3b16a12204b1..652b2373729f 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -61,6 +61,10 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZICOND	(1ULL << 35)
 #define		RISCV_HWPROBE_EXT_ZIHINTPAUSE	(1ULL << 36)
 #define		RISCV_HWPROBE_EXT_ZIMOP		(1ULL << 37)
+#define		RISCV_HWPROBE_EXT_ZCA		(1ULL << 38)
+#define		RISCV_HWPROBE_EXT_ZCB		(1ULL << 39)
+#define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 40)
+#define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 41)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index fc6f4238f0b3..11def345a42d 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -113,6 +113,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTPAUSE);
 		EXT_KEY(ZIMOP);
+		EXT_KEY(ZCA);
+		EXT_KEY(ZCB);
 
 		if (has_vector()) {
 			EXT_KEY(ZVBB);
@@ -133,6 +135,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 			EXT_KEY(ZFH);
 			EXT_KEY(ZFHMIN);
 			EXT_KEY(ZFA);
+			EXT_KEY(ZCD);
+			EXT_KEY(ZCF);
 		}
 #undef EXT_KEY
 	}
-- 
2.43.0


