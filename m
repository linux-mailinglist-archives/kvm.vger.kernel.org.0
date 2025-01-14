Return-Path: <kvm+bounces-35461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEE9A1147F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:59:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75D381693A8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CC722256C;
	Tue, 14 Jan 2025 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="p6vKFe/o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C88216397
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895504; cv=none; b=AoYaY2xtfmxs7s+tlkgNCY1+mwj219JIZNe2VtHXZLM5U2Ehu2v0ZyWobbk6p1WaP7TB6Th6M2NbrfkGkt/G95qifX4tL1mYupU7J+heVMuzfnSbrYmHbKya8kSEX4jT1fc8RrfUTOtX5ntCSxcBbchjIhzRdTMxHbiyNWhASjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895504; c=relaxed/simple;
	bh=m6q4Neyt8+DISvN9Er7fHAb+rxOe7GRGob3X+Htbmbg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HyF9n40B8Nqvvp59O8yti2pe4uOq/ikNGau6fL6BEBkC4u+zCupNAUOdBEZG6onYtdJbDkdh/PmkpxVdd27ymey7EBtnnnUHVuj+fFNT1LcRQqQokzd2Qf/Z7Tr0Uqh6zgUsOm/cw7UuJCQO5gt4qYEl3V/kG91qcLAdqJoRhSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=p6vKFe/o; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2165cb60719so109165145ad.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895502; x=1737500302; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XdmJbLVNE72s4snJvlCZyY59rcdtG68osktCOOFf4IU=;
        b=p6vKFe/oPNeqNyHbGuwxcpiq5b4JccBG83dMentlBdnf+bi+LTk7XkLhltDM6LvEmg
         21eqREkm6IPy1ex6XKv5eNPmHYX+of/gNsa+Vnct9ZryLbX9BziGwfjNnpHnSDYN06sn
         abkUEYLX7M1ye9Pzeu62uT5Qf7z11Dqz4peavp9wamsQt8BteFT4ctDAWmGgLyvHpmtl
         lzKksqxpf1sWjQH16X5lZNHJANU2VFmXUn6y5iXhi5HyOppAsgV+Zdaljdmzp0DqsjL3
         Fn6OLE1/yds1S+vdQ4BgEbdVk3FBbT6hODQH8UqcrIlV2RCgbDuJPwnyDLo8UUN8HEWU
         uhWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895502; x=1737500302;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XdmJbLVNE72s4snJvlCZyY59rcdtG68osktCOOFf4IU=;
        b=iKDlrKPTlRE49FWPNUpv9jK58ZHSQhu8LJdOfY4FIEBz2frlfCgC5uHfvkYi+AZSRE
         N3JW9/KXPUTUrqAntn0afD5WqbTYCQybtDf14N9t1Rm+3Wtp7pyGtCH1bpioa31Ffm9u
         0pa09sSbmfd6gT9FV8I+eKgA5nycU2JE32TJVVo+6cWtHSEdgt56g2SVowSMICP0ekvI
         BuGcDkelRSJapkoFtnRv3kztGb9tdzkHmAhTXHae7R/P89CqvqYNddzVPqpOfsmoMafN
         qPqGUGkC4Q0c5z0d8TnGxSoBuqgdXtFi2fFV3JxP8SEZVP/TCLevFaeb4cAbS5Id0Zjd
         UbAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS2/9Fp/1J0VzI70vYiQmsRicwTpPhgsSYm5QmqJKYP96NiMDU+LzIGlCYBszKDj+F9Yw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcT7f+R/PbEDmTARzR2uq+BVKWDxmsiYT+t5ElzH2AYZaVv+bK
	cyMZ7KjZhYGDL38kGXKX+n+MQZ481WYF5wpJ7srwmMeAZ3Qv9h8rkd5M9P6M2hM=
X-Gm-Gg: ASbGncv88QQGW16+LANJDiCxpwSm4wRU8wH0dcXG284CvA29ERD1JHI+64aZrNKe5nu
	8CifKdzqBrv063dlIn2kOgk+IWuL7pyIEuOXqoA1r0QUU7fbulLzuL19l7PNv4IC1EDOYJuD3aF
	U0kMgJJuFRagr6V6F4TeQfubJg+UpXYEz7Uhdr9Emc1u54Du6PO+yr2i78mUNVLCVW4xZUPAaqQ
	WFBbe8nOiF5eDWFc29iEADNqgitmrJwggECXw2xcluKJuXrj3fG62iyGmn5g9g7wm+hBA==
X-Google-Smtp-Source: AGHT+IH1ltU/mRUuewPYEws/WbJoOFmxt2kzpsU09c76uR3HaGq/wIEXCgpsEq3E5r1Kj+FsLU8f4Q==
X-Received: by 2002:a17:902:dad1:b0:21a:8716:fa97 with SMTP id d9443c01a7336-21a87264051mr357793715ad.13.1736895502516;
        Tue, 14 Jan 2025 14:58:22 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:22 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:28 -0800
Subject: [PATCH v2 03/21] RISC-V: Add Sxcsrind ISA extension definition and
 parsing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-3-8ba74cdb851b@rivosinc.com>
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
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

The S[m|s]csrind extension extends the indirect CSR access mechanism
defined in Smaia/Ssaia extensions.

This patch just enables the definition and parsing.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 5 +++++
 arch/riscv/kernel/cpufeature.c | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 869da082252a..3d6e706fc5b2 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -100,6 +100,8 @@
 #define RISCV_ISA_EXT_ZICCRSE		91
 #define RISCV_ISA_EXT_SVADE		92
 #define RISCV_ISA_EXT_SVADU		93
+#define RISCV_ISA_EXT_SSCSRIND		94
+#define RISCV_ISA_EXT_SMCSRIND		95
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
@@ -109,9 +111,12 @@
 #ifdef CONFIG_RISCV_M_MODE
 #define RISCV_ISA_EXT_SxAIA		RISCV_ISA_EXT_SMAIA
 #define RISCV_ISA_EXT_SUPM		RISCV_ISA_EXT_SMNPM
+#define RISCV_ISA_EXT_SxCSRIND		RISCV_ISA_EXT_SMCSRIND
 #else
 #define RISCV_ISA_EXT_SxAIA		RISCV_ISA_EXT_SSAIA
 #define RISCV_ISA_EXT_SUPM		RISCV_ISA_EXT_SSNPM
+#define RISCV_ISA_EXT_SxAIA		RISCV_ISA_EXT_SSAIA
+#define RISCV_ISA_EXT_SxCSRIND		RISCV_ISA_EXT_SSCSRIND
 #endif
 
 #endif /* _ASM_RISCV_HWCAP_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index c0916ed318c2..d3259b640115 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -393,7 +393,9 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(smmpm, RISCV_ISA_EXT_SMMPM),
 	__RISCV_ISA_EXT_SUPERSET(smnpm, RISCV_ISA_EXT_SMNPM, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
+	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
+	__RISCV_ISA_EXT_DATA(sscsrind, RISCV_ISA_EXT_SSCSRIND),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_SUPERSET(ssnpm, RISCV_ISA_EXT_SSNPM, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),

-- 
2.34.1


