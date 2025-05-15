Return-Path: <kvm+bounces-46657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A50BEAB8073
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 10:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E967E7A590A
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 08:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E435728C00F;
	Thu, 15 May 2025 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="L4DzZy5P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CE328A718
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747297430; cv=none; b=Y1/2GFVR6Q8xKk82iH27R/EmKql2KMD2/QzKJI2EYN5zxJ3yGqUuy501XUpqYaueH3VMdpCDDYyEzx7S8PBIP2jIl+mRjTRwmWJNbKgL18zq7/5tYtaqgf+EgMlOlrlcsFzkBdxU5mmj/Gtm6DG82snIHE2IRt3542qh7wW7Ei0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747297430; c=relaxed/simple;
	bh=oe9YzhrIkRFjcEpmOMMHuXd74hPefU7Jr+/Rq21d1Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YxisUc3p5KG+SBqhwUyodbtRp7n7bch9Iuo++ZFQQEN2Iar5YXjNTGtxXgaE/nILENDCCjHkIVjojy/4t5mO9nzLoa4fI5oFYkxITPKLwnwujdKv6jgN90wzCwyAhI05ZXe5D8yeEg5uzjUZRe6EA+AU9r/EZz3pm1nb4bw4zAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=L4DzZy5P; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-442f4a3a4d6so4148355e9.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 01:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747297426; x=1747902226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVRcVKoxl0DwUNG2KUS/gJuyrRdppt9iuLXI01MGzME=;
        b=L4DzZy5P3aJ/GC7hRBJ1TP4uF6OYa3kLCeBAw/zW9Fud20wIND5tl9CKvsQUPgffMG
         Y3Rihi//bqlyR+VS5poYmvhcOyJkrq0giKQWhoXRHkfPPEmGwQcW+H4Dfk9WdvOKgFeC
         mN2wk9r2oZVJTd+zUk2KESl3DiBimxZX4mFC6esD+p5I1OTtv+hYCn1Nmj3ndamfo8mT
         uAYMjn9oD/YxOcBvf3gsCy2NCpFGrLfbP1T9lznaEjiDGtwysiGJ+KBa5nrKRygLv50m
         3YehJhYnkW4oU/O6yO/FMtLZwMGRHR0+Lvc+IOb9dXBKXybBeEpnwYMHEDWzcspJhCbd
         Mh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747297426; x=1747902226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aVRcVKoxl0DwUNG2KUS/gJuyrRdppt9iuLXI01MGzME=;
        b=lnNFrs8M0U5iTWExK5Evri9HBQ/xHyP19M4cBooFWL9mfWIxDYg/Jf+BLS6g1Fsl+Q
         H8pN7yQjC3EVgJ/Wkuw7Bf2B0ApnfYBwUjQwFVG46NWHVmRXPFt3vFmh9rMXy3K0hKHx
         p8Ikykm4Zc2gFid0JSdlf6ggzDRgbsM3WTrvp5r8Lt9kiBMHvBke1m8hal71oGbgbUiJ
         1dg+2rU3OOJ87r4M7dRRz2JZ/IrarF2pOJoxURz8vqFvvXn1ddeXshKNw6/OccLctixm
         iAxXg08PNqvFVsdE9MW3WqyPxwf2AWwnVYum8RRh/rGa1Ek50FDiiLY88eOqlBS+8Jws
         VwOA==
X-Forwarded-Encrypted: i=1; AJvYcCWJBEHbdDVQ/OS8Ty86SGG55ts7WxDZzzl8hacjPmlk6S+qNOJJF4PpAMYxrJg8fv8PrwU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+xhBe6NuNb/NLqaMSQJ7N7gf5djpjWsIqCL3Bioyete3uhn03
	dB168b7+2DCVaOR16lE6VjV6MfRnYejIfY+RXx5EQHoHq+/1v2MYzLZ9Xu1ouzttskA=
X-Gm-Gg: ASbGncvmmIzyFFxINzlSlPTrm/ILHUJyL0o3ATOqyaVz+P+u6faQfWBxEolBgJkS1JO
	Ne4c5hx36Z92P8tcXZZcu+4/9yde19bL0gvKQTXLivHVw05kSExEEn5vWKRVARRHKPfrg0r0Ijn
	hD8TSHrv2wVUqPLuet65E52HWm+g8G7TeoGNy/TfpROyN3L/s8gaDpG/sHfA8cjpVizXr6U1/cL
	OKJjVfWnuaPXXsnd6nO8tIfSuI3+7tAEMC7Rc7atihxuffAQyY4cqPcbgX02vYW1nLj0e1yo/cj
	uopiZfaEbQkYF3lb7b9NUNTbbLfeiTJ3Q5mZudGySMXQFH5Q36rnTL0zqxVUWQ==
X-Google-Smtp-Source: AGHT+IEf/m3FG8FRM27DD2c+gtkesEWRNvfkiivPTHatSmLHF+9dpAc024hgwxzmnfOdGRF2n1iTFw==
X-Received: by 2002:a05:600c:46c9:b0:442:f8f6:48e5 with SMTP id 5b1f17b1804b1-442f8f6494fmr16827155e9.8.1747297425789;
        Thu, 15 May 2025 01:23:45 -0700 (PDT)
Received: from carbon-x1.. ([91.197.138.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f395166fsm59310785e9.18.2025.05.15.01.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 01:23:45 -0700 (PDT)
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
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v7 02/14] riscv: sbi: remove useless parenthesis
Date: Thu, 15 May 2025 10:22:03 +0200
Message-ID: <20250515082217.433227-3-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515082217.433227-1-cleger@rivosinc.com>
References: <20250515082217.433227-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A few parenthesis in check for SBI version/extension were useless,
remove them.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kernel/sbi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
index 1989b8cade1b..1d44c35305a9 100644
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -609,7 +609,7 @@ void __init sbi_init(void)
 		} else {
 			__sbi_rfence	= __sbi_rfence_v01;
 		}
-		if ((sbi_spec_version >= sbi_mk_version(0, 3)) &&
+		if (sbi_spec_version >= sbi_mk_version(0, 3) &&
 		    sbi_probe_extension(SBI_EXT_SRST)) {
 			pr_info("SBI SRST extension detected\n");
 			pm_power_off = sbi_srst_power_off;
@@ -617,8 +617,8 @@ void __init sbi_init(void)
 			sbi_srst_reboot_nb.priority = 192;
 			register_restart_handler(&sbi_srst_reboot_nb);
 		}
-		if ((sbi_spec_version >= sbi_mk_version(2, 0)) &&
-		    (sbi_probe_extension(SBI_EXT_DBCN) > 0)) {
+		if (sbi_spec_version >= sbi_mk_version(2, 0) &&
+		    sbi_probe_extension(SBI_EXT_DBCN) > 0) {
 			pr_info("SBI DBCN extension detected\n");
 			sbi_debug_console_available = true;
 		}
-- 
2.49.0


