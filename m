Return-Path: <kvm+bounces-35459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41898A1147B
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE3543A328A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5FD921B1BF;
	Tue, 14 Jan 2025 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="s25Hr8LP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF66215049
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895503; cv=none; b=P5YKUJDs9nymh76da1FYOYk35H58TKvT35tUuXCJelsB10cbfUvf8o+NfUmszexPqH8PV6K4Yl6zJMpj9ABOsW2+w7bwhFt0w9Cphwl0VxuVhe787IbrqZerySiucYqEB+ULj2CQAfvnNkypxApApvWZAliWtm4N/2Crrg5/g6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895503; c=relaxed/simple;
	bh=dEycrqPujNQoyCH4UD+bkihtlTfJcGr4YH26Pdpa3s4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IznfFE1Fib2vhAYkagUgR27ljL8qP6TdCLTOCl9u9fArUPNukadm2jtI1NfsrCkiX3sNyBMzrKYeTMIGYg4tZy76Vx+hYoxu0nY3cC6DXVfO/6uolD+cHJ0aJSPGvT//QZqThyLJKnFHIjBZ6GYl1gSlN46Au41A/K+z8x466uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=s25Hr8LP; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21634338cfdso100824035ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895501; x=1737500301; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NxfKG65dTTWELGQSY1XBUvmc4ww6DrMBB5fk3tB2Lpw=;
        b=s25Hr8LPoEZqpKnKH5jvsTYHYWxousDOJ4TLeBvZ60aSy/Y5opoFHfb1B3PmfFRk/3
         qPNW8LySVkZQCB3sxtm86np/ZkAFNV4EbcKwYvwr8uc9HPUUptvx2MWgBQOjK2RhrWwv
         8pkWh9WGYm6YBWpzoGcV2YhnC20oimenQWzeySNT47OYG0/PtzTxqnF7M6Mym2fhfO2e
         fqdOeYFnToGeaGBl34wx2NTkBu6ivisx5ddl6Erd5dL1mcY/N6FwqPIfjCcSmg8Mpfoe
         UD9c/r1UES/GnOssOys2LgnUUxs5Iw4yCItu+rOFXFPVNe12kBzh+pCAlt2gnCJ+TzOw
         0mLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895501; x=1737500301;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NxfKG65dTTWELGQSY1XBUvmc4ww6DrMBB5fk3tB2Lpw=;
        b=CO2oAcVA9iuAY8d8gH1J+7a4SNQoJk7wT2s//VCpJBcyt3KAQ+DrLFCIVF+wtqTrJo
         nDSQ5uxitO+fjNm513Wkw9/eF6yQlLdA66Tybm8hbKtovuDtPa3voQ15om9vk/E19amX
         b+iNqhmsfFKLKBF2NSUEPtTSNe/2HUWkG+vq7lXO8DIQ8q0Gtl+lHkq894B9Bb/cDa5R
         OF2eg7GKQpuDv9+FsCZgQk6xfvuw3iI9u3yVj1aAhhjWSFDs753SwBQPmWP/N8eiY+DB
         MHJpUI3qWUx0nHFUIxdx6bTLL/9EDsPKiIEcndF462HE+ZJV0JTGHNq+k9ItLJoQVi3S
         4OKA==
X-Forwarded-Encrypted: i=1; AJvYcCUGsar+7hnye7km6qoSK0Q35leujT4ZD7Unc1Wk6eV8pMs+7EoB1CbcBaT9ztQtU5+xsjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoiATlI/nq2SO+fD2pK5KAc12c6T5jnuTId76B+eFxStPPCw+s
	qOBzIjy7csaNfp3JIUm3yOgRGOcNcB9tuO7DhL7XTC+gFcV6gviyFkrNOR7cn8k=
X-Gm-Gg: ASbGnctO3JDRBRAUQNaivpaG/vakfOXQGPjClN+eP7biecDl+Zv1SPXjbmalXMm2u1R
	U556ugwSaQrv8mLE7wmg7DMqvozFEf0DOcBMg0S5juYUIqNyaJFUz3sKKWRZvojmDkM/5YTLKV7
	rlfIg7YyuBH1SMDejohcxcTkmYyyR9iKXeGyF82QXr2+4Gm+ydg3cijtmvOnDr49GuDyY9TCI/v
	U335eb5D9XHAYsIOXEXOPxksqQOlwPrKQee5Mpk8sffsjKbPNCwkpEwb8vY49p5egehmQ==
X-Google-Smtp-Source: AGHT+IEFzn+BQGP9HoY9wlfnVhVEePoikrfOCZH8FHyJCqYtdMpQEJ0WBuydKODT01yP3q133TXafQ==
X-Received: by 2002:a17:903:191:b0:215:a964:e680 with SMTP id d9443c01a7336-21a83f65330mr394967985ad.25.1736895500674;
        Tue, 14 Jan 2025 14:58:20 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:20 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:27 -0800
Subject: [PATCH v2 02/21] RISC-V: Add Sxcsrind ISA extension CSR
 definitions
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-2-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>, 
 Kaiwen Xue <kaiwenx@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

From: Kaiwen Xue <kaiwenx@rivosinc.com>

This adds definitions of new CSRs and bits defined in Sxcsrind ISA
extension. These CSR enables indirect accesses mechanism to access
any CSRs in M-, S-, and VS-mode. The range of the select values
and ireg will be define by the ISA extension using Sxcsrind extension.

Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 37bdea65bbd8..2ad2d492e6b4 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -318,6 +318,12 @@
 /* Supervisor-Level Window to Indirectly Accessed Registers (AIA) */
 #define CSR_SISELECT		0x150
 #define CSR_SIREG		0x151
+/* Supervisor-Level Window to Indirectly Accessed Registers (Sxcsrind) */
+#define CSR_SIREG2		0x152
+#define CSR_SIREG3		0x153
+#define CSR_SIREG4		0x155
+#define CSR_SIREG5		0x156
+#define CSR_SIREG6		0x157
 
 /* Supervisor-Level Interrupts (AIA) */
 #define CSR_STOPEI		0x15c
@@ -365,6 +371,14 @@
 /* VS-Level Window to Indirectly Accessed Registers (H-extension with AIA) */
 #define CSR_VSISELECT		0x250
 #define CSR_VSIREG		0x251
+/*
+ * VS-Level Window to Indirectly Accessed Registers (H-extension with Sxcsrind)
+ */
+#define CSR_VSIREG2		0x252
+#define CSR_VSIREG3		0x253
+#define CSR_VSIREG4		0x255
+#define CSR_VSIREG5		0x256
+#define CSR_VISREG6		0x257
 
 /* VS-Level Interrupts (H-extension with AIA) */
 #define CSR_VSTOPEI		0x25c
@@ -407,6 +421,12 @@
 /* Machine-Level Window to Indirectly Accessed Registers (AIA) */
 #define CSR_MISELECT		0x350
 #define CSR_MIREG		0x351
+/* Machine-Level Window to Indrecitly Accessed Registers (Sxcsrind) */
+#define CSR_MIREG2		0x352
+#define CSR_MIREG3		0x353
+#define CSR_MIREG4		0x355
+#define CSR_MIREG5		0x356
+#define CSR_MIREG6		0x357
 
 /* Machine-Level Interrupts (AIA) */
 #define CSR_MTOPEI		0x35c
@@ -452,6 +472,11 @@
 # define CSR_IEH		CSR_MIEH
 # define CSR_ISELECT	CSR_MISELECT
 # define CSR_IREG	CSR_MIREG
+# define CSR_IREG2	CSR_MIREG2
+# define CSR_IREG3	CSR_MIREG3
+# define CSR_IREG4	CSR_MIREG4
+# define CSR_IREG5	CSR_MIREG5
+# define CSR_IREG6	CSR_MIREG6
 # define CSR_IPH		CSR_MIPH
 # define CSR_TOPEI	CSR_MTOPEI
 # define CSR_TOPI	CSR_MTOPI
@@ -477,6 +502,11 @@
 # define CSR_IEH		CSR_SIEH
 # define CSR_ISELECT	CSR_SISELECT
 # define CSR_IREG	CSR_SIREG
+# define CSR_IREG2	CSR_SIREG2
+# define CSR_IREG3	CSR_SIREG3
+# define CSR_IREG4	CSR_SIREG4
+# define CSR_IREG5	CSR_SIREG5
+# define CSR_IREG6	CSR_SIREG6
 # define CSR_IPH		CSR_SIPH
 # define CSR_TOPEI	CSR_STOPEI
 # define CSR_TOPI	CSR_STOPI

-- 
2.34.1


