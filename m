Return-Path: <kvm+bounces-19996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E3790F28E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B648B1F26063
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 15:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A3FC15A850;
	Wed, 19 Jun 2024 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="OljYsPa/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D817158A33
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718811678; cv=none; b=hvbxnA5hkjjyrCLpOzRIpG2Mkaxrj5/6k0J9gqtpZfL2/NxHxxjwkzy1X1/clXbZmBsP5FYH2G6xhilmajezuzr7VVHm/ERzVBQ4iNRyIEQ/CmkdY07nlwkZzd6JwZdguMgwTvMUNP+CW9dubL3UxDhqPke25u9prE2G8PHm4sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718811678; c=relaxed/simple;
	bh=7H3ZZ/U/d5MGGck8wALvbGs4PxOtO2VkSs85+KZ1HfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=klwvznQVaTEJCQZ+n9AVAjORQy2sqfS9w5rwcHZylW25TrNT2ZeGZGQy6Wfoy7r8wuLwuFj2YBk76dPmStGf7rQO7EWadMqdIcsAQGtTOg+gSa8iU/wBgHVTJjpT/mT9EXX8csEs8Y0i1kxhjUB4GXMffJ9hQArf3uTs8IP5NQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=OljYsPa/; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42479dece93so336165e9.0
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 08:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718811674; x=1719416474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GPY+3E4dBoFlMa6qj3x8QVsLE7eX+roIHLt6ynEnu2U=;
        b=OljYsPa/SDvi/ATMKcTp2LDXb7/rH4BLAZhBzlGl75Lnz0PJmgSpgdytGQb8wHdbNA
         64qhKqWfr6iHWEFD/iLu2PU5ZaYfqtsYgSl1HbtcIPtV2e5WzwpWx1hjH+wrGtgADRFh
         Y3i2dyLGnmbSwqUFysXUIsLZ2jgLIiIez2LShYrfGLA44ctvwfgjx+e4qtzi71scO4cy
         DYAyoBTEkBVYAvT65PMf3HQkwkZ//2UbRQszXdHLMm0LnkhZPNScRyCe6nEnTqGhwaON
         nH4rw/COVLXFJKoffe6SYV2i7gNzkZy/yCFk38dKDIDjGyBBJRvdxSuflBWSuFN5U+qy
         vQiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718811674; x=1719416474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GPY+3E4dBoFlMa6qj3x8QVsLE7eX+roIHLt6ynEnu2U=;
        b=cVFRChqdwzxzVYO6kNwD0boVRoGBGibdndd/I/oAwjI5xA7JLHTmSoNc+fWHa3kYG2
         tHUHa6M2Fq9wLDGet8vqN0BJxgb3EO5Ah6ZDvZdW//Rz1EZwMgffdehlSI3tdi/NscaP
         HcinpiAO2ZB57qK6Zm7Q42Hmyrpy62Qd9RB2Oagre6236uWxGezNbVta0IuL3jo4qK4X
         U0+NG1f5MOdnavxOFlc6+X78EsAur2bUhLlqxzXA54cDw4Z3BQ381ZKwNBpBc1zSIiuK
         U8W0wQZeZjD+cy6y0wyS5TzpgiOgDZAE4kSLYy1IAp1xYVU20XXKnJR7+FHSS58kDau2
         3yxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpvv2NEhwxBC12kGYvSvMq2Mu5BsYoiNLb7osSi/zE+64bq2OrfovrLorIEOn7NdFSMWpZMLFGha18j7sKzgZ0D/FH
X-Gm-Message-State: AOJu0YxtFXPxdqokeRUrArDwEbP9k2UwHsicIBV2euRwqF2c9YKiQ7Kf
	pciM7V91WgAqG4j+cwbtc1K7v18MaXiFiyXuYjalb704E3ShuPeJXOOjBUUpvyM=
X-Google-Smtp-Source: AGHT+IHEyMK/ITgXlMXOhDLGJETYUb24IsTevTAqgLrmuWFBKFkU3n8nX5A972+nIAwKJBmfBumqAA==
X-Received: by 2002:a5d:5f93:0:b0:35f:2929:846e with SMTP id ffacd0b85a97d-363171e28demr2732165f8f.1.1718811673916;
        Wed, 19 Jun 2024 08:41:13 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:819d:b9d2:9c2:3b7a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c785sm17392292f8f.34.2024.06.19.08.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 08:41:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 3/5] riscv: hwprobe: export Zaamo and Zalrsc extensions
Date: Wed, 19 Jun 2024 17:39:10 +0200
Message-ID: <20240619153913.867263-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619153913.867263-1-cleger@rivosinc.com>
References: <20240619153913.867263-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export the Zaamo and Zalrsc extensions to userspace using hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 8 ++++++++
 arch/riscv/include/uapi/asm/hwprobe.h | 2 ++
 arch/riscv/kernel/sys_hwprobe.c       | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index 25d783be2878..6836a789a9b1 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -235,6 +235,14 @@ The following keys are defined:
        supported as defined in the RISC-V ISA manual starting from commit
        c732a4f39a4 ("Zcmop is ratified/1.0").
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZAAMO`: The Zaamo extension is supported as
+       defined in the in the RISC-V ISA manual starting from commit e87412e621f1
+       ("integrate Zaamo and Zalrsc text (#1304)").
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZALRSC`: The Zalrsc extension is supported as
+       defined in the in the RISC-V ISA manual starting from commit e87412e621f1
+       ("integrate Zaamo and Zalrsc text (#1304)").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 920fc6a586c9..52cd161e9a94 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -71,6 +71,8 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 45)
 #define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 46)
 #define		RISCV_HWPROBE_EXT_ZCMOP		(1ULL << 47)
+#define		RISCV_HWPROBE_EXT_ZAAMO		(1ULL << 48)
+#define		RISCV_HWPROBE_EXT_ZALRSC	(1ULL << 49)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 3d1aa13a0bb2..e09f1bc3af17 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -116,6 +116,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZCA);
 		EXT_KEY(ZCB);
 		EXT_KEY(ZCMOP);
+		EXT_KEY(ZAAMO);
+		EXT_KEY(ZALRSC);
 
 		/*
 		 * All the following extensions must depend on the kernel
-- 
2.45.2


