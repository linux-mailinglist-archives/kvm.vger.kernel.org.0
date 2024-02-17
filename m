Return-Path: <kvm+bounces-8922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76050858C1F
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9849F1C212C8
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 00:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364951CD26;
	Sat, 17 Feb 2024 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="R5vvGFEZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839311C293
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131505; cv=none; b=AxD3/gwWeZ/x8NV91yPO5xFjy1INrmLPS/L3lmGpAMenesNeohKGmzixVaq/QXGKArf+bPdEoTeLK2OjUWzdQi20axg39bzXEMutl1sfdzV4K/3ikxiaFvezYeApaw6+aWW1ZFB79RjRiEwVIuonhZYTt9JPV31QeZ823QoGTA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131505; c=relaxed/simple;
	bh=FCKxku0LcQE3xpAfyxEfS6d2yCAYIXFI12M5ylW0v1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FKA1kMofnZAzs7yA8WutcRov9rf7cj95dgQZ8UZvwLAlKvNVIU3SaFHg6CxHiXI3xl+t/i0EnkUhmWm5vHCuCTaHv3548jtX9OxzPRTfKct9GOI+AckifaCJa7WtLhEA+fLcZF+JA08NiwbF/QG5ESIK3Zz06mzKKkErdZsxNhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=R5vvGFEZ; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2046b2cd2d3so2017456fac.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131501; x=1708736301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMgr1ik/uEkkoRNgvQCIWXGmAGeZi75wQYv7ioKJulE=;
        b=R5vvGFEZ2iZxmGgUBjEmX9Bby79SR1/fvxxIQNnda+5w38QKh9DG4o5/Y7quaUWowM
         Hf0InKwSKImTAHsMAh5QehKJCHOZ6L0BRxzhVXyp1DYBoi5aMsZHQJlUB5eKWPL7Ds4j
         WZXPsGNlTkmdBl378/6z6NpLeF4T6tMZ1TOshZHDjMfqBd++j9+8ujL9KdQDez8BY01P
         12MmxgQeuJRxoopPOKRpumr17um5MmddTKjwPDBewS5HsD6OoNKx0VcnnLxqlwl6CUZc
         iOwM09cDvv188DZ0kiYw5AAAP+d7EuDkZaJpjPj+BCszhcG3QXddvqZ9SIJfVgrtoOeM
         ollw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131501; x=1708736301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMgr1ik/uEkkoRNgvQCIWXGmAGeZi75wQYv7ioKJulE=;
        b=dnrE0H+Dp3oHNwbzfhlDhLeFsbR+9ru4OZzNm5nj8OPN1kiCtnp+/FTlS3D622BV/a
         IY6QsfRWF72zK/CRqgAlzdjpFO/Xat4brRm2Rdw+8/+gUkHVuCLzMu4FQnlmCbpvSdjC
         pfzd7drlvw++g4uhemHMtho4iecAaILhypa5iQ9TS+tpbtjQZg8XlsOkY30ktx2BXg5q
         uIZx8jQ0VLTcTU4s1i5VOqiroWRrytWsIcjGWxgm5pMM9ToV+dzEt4XqzcjCXfCkifyg
         A0Pz3tkeE2kw1VUcLFqVmK1E0707wge/DtWSlU6YyMqCGU2TxX3svLyj6OdzQCTxank8
         bosQ==
X-Forwarded-Encrypted: i=1; AJvYcCXz2LJw7e8n/MW/TNpn7uf3G9LErdmMYmzWAvb3KHSjNdsva63G2nlicTEYwPrQGOj4305LgEvcMvPIQxcD/msOAb6J
X-Gm-Message-State: AOJu0YzrRzWE6dpm0yTQfRbVSe03tS+0pbXiPExNsNgy+9Mdim4j/Y2y
	c5LNtuRvFxHxxh4GVlG3o0l4jWH+oqHfk8r40SnGaKl9U/RckJR1Yy31E+bMCXQ=
X-Google-Smtp-Source: AGHT+IE6LQp69xLCLOFFJy6mutWlZnmsAZsBULNSC4jH5aWno9vuisH9O/sW+xQ1B/XKb7HuL+17UQ==
X-Received: by 2002:a05:6870:224d:b0:218:d374:9b7b with SMTP id j13-20020a056870224d00b00218d3749b7bmr7867438oaf.38.1708131501652;
        Fri, 16 Feb 2024 16:58:21 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:21 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 03/20] RISC-V: Add Sxcsrind ISA extension definition and parsing
Date: Fri, 16 Feb 2024 16:57:21 -0800
Message-Id: <20240217005738.3744121-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The S[m|s]csrind extension extends the indirect CSR access mechanism
defined in Smaia/Ssaia extensions.

This patch just enables the definition and parsing.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 2 ++
 arch/riscv/kernel/cpufeature.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 5340f818746b..44df259cc815 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -80,6 +80,8 @@
 #define RISCV_ISA_EXT_ZFA		71
 #define RISCV_ISA_EXT_ZTSO		72
 #define RISCV_ISA_EXT_ZACAS		73
+#define RISCV_ISA_EXT_SSCSRIND		74
+#define RISCV_ISA_EXT_SMCSRIND		75
 
 #define RISCV_ISA_EXT_MAX		128
 #define RISCV_ISA_EXT_INVALID		U32_MAX
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 89920f84d0a3..52ec88dfb004 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -301,7 +301,9 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zvkt, RISCV_ISA_EXT_ZVKT),
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
+	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
+	__RISCV_ISA_EXT_DATA(sscsrind, RISCV_ISA_EXT_SSCSRIND),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
-- 
2.34.1


