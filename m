Return-Path: <kvm+bounces-19961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B39E990E99B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37CBE1F24484
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37119143749;
	Wed, 19 Jun 2024 11:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="LaTf4Qt3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD2A13F43B
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796942; cv=none; b=XJrZ/uKTrQ9MSEVMixIOW8TgVOUkvbYQLmisASFPvaufBa7ACzERCcYCvL1LXjv19P8ttydsZNo+naI+PC5dgWnGDJmJSY3cPVR/p38AuhUe0GgNk1jGHpwRaJt/3VZN4NFilQ9WDnJ3GgeLZQ1sjeWMcrXDr0D6Iy6smreGYi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796942; c=relaxed/simple;
	bh=ab+8MNUUMoMFxA2G4zusn5OccFaYJU7N593syvWU+0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fkr/QD7B9H75AdyDpaAPw4lXJ23Y+VjovswibKpP1D1ZUVYR6a4tKMGoeMODiyOOlg7F+sbr/Qy2NwF09WAPK2RcTdq3pchg/SfZfZDF8wfAUK1rDiwonFvaXg4czqB4aGEdYIh43a3ptURMce8zUP3JHtRRQXi+lttkHkzhLdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=LaTf4Qt3; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2eaea316481so7892741fa.2
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796939; x=1719401739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NeIVokKZeou2DRmWwx696jQqaRNB0bo5tdjndOt75M=;
        b=LaTf4Qt3GyXF8ceACs0HNk3RPrzr2U624o837qdYrUF5bS3z/MErVEgXHI3t098lXY
         /9aJMRgDXVSNBd7dISJuLNoXPmnhwD/9e22fdW3bbcpQmPZLaJKKYDbgKtG0xE+xVThp
         xVSGIvGvjlUB2dpuIMxUCPtwT7r4Nprd1ZvkElPv9p9A4w+qKDcqq+RMShFHcYS0+Pj/
         qEsYUnkCQNeKwtIN4+PFNdWYNjP2v8TmV+q3QGRwcm+KxCEXnn3b23LZj9d3JGrAW5MF
         FhE1sbqFAwqydX0QZCscpoELAuF4JNwgCsqbwHqEk0ewn1XO8ehPW3HvoDKlKcwjsXwj
         ijbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796939; x=1719401739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3NeIVokKZeou2DRmWwx696jQqaRNB0bo5tdjndOt75M=;
        b=DwmL44oj/Gb5H0omAc5jxXJpS6fYQGnEqS3/yz6H5cqB0tD5LY+8O6v5QCaUh+g827
         PMSApv1q30E1kII3U2nQG9Yon2Mwtg9qCjxcJ59lzhRsjsSycnAG0pGLNeaeGsakHrdV
         /Yd0PHYU1EiPAuMaqXOB68VDRlEGWSV49UyIGXkZs5+dJpWwepjH6PtulZ8m5JY8oU28
         VVepEKVDfIwfDyafeqqzFbRIxc0+jGnrBapyr49g/w9LsaBNJDK4eAu8ODqUdZoef2CV
         82FHiz/S2WKvpeUYb6xuRPzyOYsMSR4WrNEyu1mV+xJ+lWeMjH/5d0z8Zt579ejyJab+
         cVAA==
X-Forwarded-Encrypted: i=1; AJvYcCVl3Y+SjoMYuHkZef2z9MdHfvMhnLc6XCuvIOn2On5CKSQja6AUliStnVztZqA7fQ+CtJCgg3bTLgFBWEn/KcF5JzCy
X-Gm-Message-State: AOJu0YxUTuFMEuVhIY0pXJf8HtZmmYeD1zdZZ5eXIfbLLlvux5JuBYvT
	VMSUQiBj0sRtVKOGGMJZlw8Dk7J+XY/JfJUZ3kOyrveM0IfLRamVjumRqV77Zck=
X-Google-Smtp-Source: AGHT+IHXMR+p5Jiwrk26C4hD41FJdRZ01s6AEWYRELMLJ9ACvKi0hM30z5n9fFC1USLH9An4IqbrFw==
X-Received: by 2002:a2e:9654:0:b0:2eb:e49c:45df with SMTP id 38308e7fff4ca-2ec3d007606mr11998811fa.4.1718796938764;
        Wed, 19 Jun 2024 04:35:38 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:37 -0700 (PDT)
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
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH v7 03/16] riscv: hwprobe: export Zimop ISA extension
Date: Wed, 19 Jun 2024 13:35:13 +0200
Message-ID: <20240619113529.676940-4-cleger@rivosinc.com>
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

Export Zimop ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 4 ++++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_hwprobe.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index fc015b452ebf..2b7f1d05b2e3 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -207,6 +207,10 @@ The following keys are defined:
   * :c:macro:`RISCV_HWPROBE_EXT_ZVE64D`: The Vector sub-extension Zve64d is
     supported, as defined by version 1.0 of the RISC-V Vector extension manual.
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZIMOP`: The Zimop May-Be-Operations extension is
+       supported as defined in the RISC-V ISA manual starting from commit
+       58220614a5f ("Zimop is ratified/1.0").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 7b95fadbea2a..538c404938e6 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -65,6 +65,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZVE64X	(1ULL << 39)
 #define		RISCV_HWPROBE_EXT_ZVE64F	(1ULL << 40)
 #define		RISCV_HWPROBE_EXT_ZVE64D	(1ULL << 41)
+#define		RISCV_HWPROBE_EXT_ZIMOP		(1ULL << 42)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 83fcc939df67..04a2ed4ee415 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -112,6 +112,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZACAS);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTPAUSE);
+		EXT_KEY(ZIMOP);
 
 		/*
 		 * All the following extensions must depend on the kernel
-- 
2.45.2


