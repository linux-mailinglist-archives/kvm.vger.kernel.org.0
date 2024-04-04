Return-Path: <kvm+bounces-13524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BBF898517
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77FCA1F22AAE
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 10:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5817EEFE;
	Thu,  4 Apr 2024 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="aY3toT7s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6697F48E
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 10:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712226868; cv=none; b=gxZg1nnmFpk1DfBkFO2jbZ0fE1/CHQX/sR/CvGlzeaFNs6r1pSeuBarWNfLdNk//tKmzWFDp61UDgSOYOCDhSoRaMl9dLKNvQRrrgw8UJdE1YBjdI2nghQ1n3e9o51Vj9fIua7v6qiqJUATS+czkZ4H74A5y7BzBpHvKRvzSx7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712226868; c=relaxed/simple;
	bh=KEz0KdTIXXXEwmuecoQuGlTwELOY5TUh2XKrhjj0EJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVpwWnzCPQ2I/R1sdi+DcqP43myCEz5L9roRqKe7fHwWBphN4LMWhIqoFXQTvCUeiLSLcyUjhAT3avvo6sxJ+/b9k25zoKMCFMIs/5I3jFJYJspTHnIHV3pRUZtmdTkyVIGF92190EW0JSAlA9WM3Tqpl4qBisyDLf94EPmE+4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=aY3toT7s; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-516ced2f94cso84522e87.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 03:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712226865; x=1712831665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iku5aBhZQx5P/6uMfa9dqXU93ym6YmGWtDxr/u9bzFk=;
        b=aY3toT7sUqL2JeNUucYGJJAxZhBxw8OTzLZk4AI/5bkY7hzDu5MMu0u50ojuu9S2tZ
         V+4yWfFlOfs7A0eSr2ndsilreAf0K+/CatPPUhMz+XW0D+4gaFZs94Fpwj5EB+ix5v0l
         3yy0Mgpt+/1R6ltkQcn5KuB8sYmiUXYdNh0bPaW3Tt7Ms5QJ9t5e5RFqhoamQpFZSDaG
         FBTTK8XBrHLIE85RXfKSMy6RRWfj3cVw09yPphsB9Vpq7lUp1wzdC/a91ZVnYeM9IRdG
         uxHNJDEj37UL25vftb+EGfrk8RHEunSzwOBnlph1Ja4EzLT5YQIFO647hBDf9seNjazD
         Kbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712226865; x=1712831665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iku5aBhZQx5P/6uMfa9dqXU93ym6YmGWtDxr/u9bzFk=;
        b=PokUHyvXFLyBjdYwAC67W5leV9oyn1zotW51DfWfjS+GQvdAUULggKMCCJT1n6+on6
         Rjn+gqR1MyD/poIiuYw+sa0s/VWupNbnXgOOQ7fEgZA1AZBmMIdX00n8WYLa087gVmg6
         Ov1/0N92euhRJnKXUEBzQgox/vES53UZLa5lWR7ATwDxAVGde68QsI3GC/Elvx7lnZ91
         wDfNMbBZTY9vJqyWirqQEErGYI8Xom2lvZEII5QaPu0rDxq8kvrIiwZGwi64xasNnVwj
         3QCdZ878YKJUPHKdLzUg/h9HwMcXgQhW42ANLQ4oh/LacL/66oZsgygbTNgYcR6qS86Z
         XjYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNK7RQuiRm8S6SImY852HfexnGih/182omgnX4ayr9Ky6+RQVIIoXnrgwvPV3UN4jy6USacqXGozC4unApUAbXzeDH
X-Gm-Message-State: AOJu0YyzEgTJ8LlAfdSkIFT8tnvyx92QlDr2zkX4Svc1AJtgiICrBM1s
	rZKCxk532TUj898j+rWQpPcmKH0fy/3/ZlYcsGr+QR+WJi28QXijKD0l/iso+Ik=
X-Google-Smtp-Source: AGHT+IGQHApayxznh8OMT1KuiXEDgxLxBt0Y/yh7QCrxC+TBhRlVv057wTPfke1UlSRTEFSNP9rucg==
X-Received: by 2002:a05:6512:55b:b0:513:cfb8:8cb3 with SMTP id h27-20020a056512055b00b00513cfb88cb3mr1321593lfl.1.1712226864728;
        Thu, 04 Apr 2024 03:34:24 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:555b:1d2e:132d:dd32])
        by smtp.gmail.com with ESMTPSA id ju8-20020a05600c56c800b00416253a0dbdsm2171340wmb.36.2024.04.04.03.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 03:34:24 -0700 (PDT)
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
Subject: [PATCH 2/5] riscv: add ISA extension parsing for Zimop
Date: Thu,  4 Apr 2024 12:32:48 +0200
Message-ID: <20240404103254.1752834-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240404103254.1752834-1-cleger@rivosinc.com>
References: <20240404103254.1752834-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add parsing for Zimop ISA extension which was ratified in commit
58220614a5f of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index e17d0078a651..543e3ea2da0e 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -81,6 +81,7 @@
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
 #define RISCV_ISA_EXT_XANDESPMU		74
+#define RISCV_ISA_EXT_ZIMOP		75
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 3ed2359eae35..115ba001f1bc 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -256,6 +256,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zihintntl, RISCV_ISA_EXT_ZIHINTNTL),
 	__RISCV_ISA_EXT_DATA(zihintpause, RISCV_ISA_EXT_ZIHINTPAUSE),
 	__RISCV_ISA_EXT_DATA(zihpm, RISCV_ISA_EXT_ZIHPM),
+	__RISCV_ISA_EXT_DATA(zimop, RISCV_ISA_EXT_ZIMOP),
 	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
 	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
 	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
-- 
2.43.0


