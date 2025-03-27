Return-Path: <kvm+bounces-42145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6600FA73EB5
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E382179C82
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54D2221F17;
	Thu, 27 Mar 2025 19:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="hXTxyTX3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3807721D590
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104183; cv=none; b=bzMk5JIQ+1mpmNGo4qfaONPFUEuV9gAe4Lk5YDfj9htEVex0tQo24orwvSSBXHKuYf8imvItlAzuur4KTYDDi+h9cFce/KDgvLG1h0bIvK6P04qjdpmr6JpoWm8M7Vr02xrV9jndHfFZKWIbQKcBi08yvVbr3IalL4uRD5ptsxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104183; c=relaxed/simple;
	bh=7gzyqd1Bpe/8V7Xh/c5GHAjOiN3oEMtm7RQOKlXxUCk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ACcxB/PoWdXrmggs3YMg9nCqraf97aCCsL8NR2t+xKR+QkZBoHlmDgixiLBWql1t2Tv6lvvJxsgucoQoX+bGoia+grPOVQ6KN9lPj7ozwIiCWFShlYzKndfdObgL/8yA49JLPeklGgPmE4MyWX6fXdwiQjjHegMVeMJP1ArI2wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=hXTxyTX3; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223fb0f619dso31072325ad.1
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104181; x=1743708981; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/JOQ8WwmCbSnRqnzBomZTQ9W38PHSEAGnjY39LhZEAM=;
        b=hXTxyTX3TfdVlk0JnYiJ1dKtlQYQ+RreS4vqfBJOFmq2DqT/2p8/WkUUJkplFWm5Ps
         5HyP0LsMpEm/lHdVywzERrOyj3zNaTyNIwoe2AcAunKM9uEB4wgtQgEaCyf4jjyNAtuR
         jYwvelJwDcyHmewF5yzCamRd4uGVhBwn5HmcR0UTAjGEqXQVhWE67fmUSUtrN5yJImMu
         dDSOmq0pIB2U7bIfN8yLz4sbVIGxv5YutYySbdAvXpGODh6+6dxYzpChGuuhIjsiom4f
         nuLy7M715/CgVFTLD61wtXG3nzzi6tjsYEUvT40cQ/KFBEZt0Y+0UA7m5q0tQRpHleeD
         /0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104181; x=1743708981;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/JOQ8WwmCbSnRqnzBomZTQ9W38PHSEAGnjY39LhZEAM=;
        b=GDgKcAbMQ5YE5dJd9xFwEmfHO8erAP/1hvxoT0vPZCrm+NIVcdGkaaQPVdkFLlCsZ/
         vjRGUgNHS1soycqfmQ3w9EWt72W0xSbc2QVOkvBYm3i1t0kBwnlCT3hXzhCDWH2o8Lf8
         OdZ5hhhw91qT4LvVUlnLYP183lfv8CYaeIBRah4UMVpCrMVegVyj78jWC3S7Qm+cpwQe
         kI03wPLFZjMParLuOAxA16/vdCOVIBNB5O28JG+CqPn99JOTfGHgH+huEj2slPsguUQM
         GuSSBJyGmsIpTUElYdq3JHUjlvAxRpMdPV9Rh0P5+TPpPxuNrSv6bqVsVJ3g6nWYugPx
         195g==
X-Forwarded-Encrypted: i=1; AJvYcCX2QrXsTa1W+fXhNW9c3ptdqFD0DbhavetC5DprTi3pUsMtWdV1ZVAv4+ckyvRPDVDEIdk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWNxqOThb3gzWCYY1ftCGARNYBPsDOMiKw//D7VIvWbpjqN9BL
	+W3tzBuzX7AmmMYC7433smf53wPdITFx3RfN6RHKNf6QUCVzUu8pIbSE5sgO6/I=
X-Gm-Gg: ASbGncub55ehGnhmRxo4UHLYUV6ySm0T7G7+8KnCp9Bb+KwpT8RsPK7wfCxYscjNuIc
	DirgvNtdM+UpNuwfpEU6kqH3ga2lSSGH/mbHPh3/SwCSeAXSzbo+9IAg7IdBntlfE7lsqMSfAmH
	kPjkiiKtXYfCa3cIEGRXC8z0q5zLJHKfIzZwwhBdmG3QLdOgzAw6DtC8rcGjhi+PY2ZPAGw4p/J
	5m6rYq0NJ/BtdHi/j6Z+wXeJeR0FATPXUUrUp+fwOThN3hnN8LFFSyimWSUhD+BvgZEtV8RRAcp
	8z9GLaHxyygRuwhi8/LEugyM0G1v8N+KK6OsRGe6c6Zdkn6w1XrO1nMkG2+HZaLpeono
X-Google-Smtp-Source: AGHT+IFSLJpOO+uUPIXxxR4PWavcDhvMZFlKhYeaacVfbM6bFNGqTFcN8T3TvSAfTzPEFeN7iSGrUA==
X-Received: by 2002:a17:903:11c7:b0:215:4a4e:9262 with SMTP id d9443c01a7336-2280481d0b6mr52437215ad.8.1743104181444;
        Thu, 27 Mar 2025 12:36:21 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:21 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:47 -0700
Subject: [PATCH v5 06/21] RISC-V: Add Smcntrpmf extension parsing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250327-counter_delegation-v5-6-1ee538468d1b@rivosinc.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
In-Reply-To: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
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
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>, 
 =?utf-8?q?Cl=C3=A9ment_L=C3=A9ger?= <cleger@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Smcntrpmf extension allows M-mode to enable privilege mode filtering
for cycle/instret counters. However, the cyclecfg/instretcfg CSRs are
only available only in Ssccfg only Smcntrpmf is present.

That's why, kernel needs to detect presence of Smcntrpmf extension and
enable privilege mode filtering for cycle/instret counters.

Reviewed-by: Clément Léger <cleger@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 3d6e706fc5b2..b4eddcb57842 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -102,6 +102,7 @@
 #define RISCV_ISA_EXT_SVADU		93
 #define RISCV_ISA_EXT_SSCSRIND		94
 #define RISCV_ISA_EXT_SMCSRIND		95
+#define RISCV_ISA_EXT_SMCNTRPMF         96
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index eddbab038301..e3e40cfe7967 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -394,6 +394,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_BUNDLE(zvksg, riscv_zvksg_bundled_exts),
 	__RISCV_ISA_EXT_DATA(zvkt, RISCV_ISA_EXT_ZVKT),
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
+	__RISCV_ISA_EXT_DATA(smcntrpmf, RISCV_ISA_EXT_SMCNTRPMF),
 	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(smmpm, RISCV_ISA_EXT_SMMPM),
 	__RISCV_ISA_EXT_SUPERSET(smnpm, RISCV_ISA_EXT_SMNPM, riscv_xlinuxenvcfg_exts),

-- 
2.43.0


