Return-Path: <kvm+bounces-8928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9B5A858C38
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:01:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94DF328260E
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2C020B20;
	Sat, 17 Feb 2024 00:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="GeDy6wkN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FBE200C1
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131521; cv=none; b=iBtbbYf81zk24yxgSvv8ZlEI9jT4hWGc1b9ZnxhbN0a2OUoMbGOI2d+IHgsWOyvambmxA1SkVfFMsv9hiVgs0b2vdX5O0ver6Xo95e4Fqyh1Kx+4xRPTuAPxxbQ0jrWI+Z6SkGpdkJMcwwEQAchE8cgAj2/TP7PUjPQFpA+amJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131521; c=relaxed/simple;
	bh=T3ymMRoaGrDa4O4U2B76Elnx1NUkPmWc8r+7ZulpDm4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P3p6FSlRQUYykv4ys4mRsBUjgTkqhqBXNUTlSYgxqqjQAbr3rl97Lg3vimoIZPvKW6mrgajecESfo5UcUtqt947QpoChoLP8L6aOOAVU6chi+qWUnQ4lMLeJ0JNjgQKUT6WDWeE117xB+kok43cqolvaK/eoNCB+eIcmUiVL904=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=GeDy6wkN; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e09493eb8eso2936477b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131517; x=1708736317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXnbbBG8uU1BPF0JsrRvm9475kp9ExkHduilmVeFprU=;
        b=GeDy6wkNBenBKiOpNFF5895jEv95oyM5MK1UDFFtps4ivlD9JPIzYl2vHoR6EJ7GkB
         uKVTJc5Ks8KJaOOidIaWAezYALU6PnGCFJGcecJggrvQwJo6N424leb6kqnL7M92Fd4z
         kbj3T8nKQwv/lSxmHir5DzTAey7aecfonc56TuU93ihOMNrWzoJzbsnOMu2z8C/LikwJ
         q6r9+Hx6Dj0I8uSLTM4OykLeSC/D7lUhdy5hCJt9BEyDcWIKDn3uVHNw48E3YQShvuv5
         NLwX2aZynq88x8oDSFQnILV4fAdEkN5M1Y7fzhsLpvklcBROwRE1Ib1+hFHZWV31VO/M
         EomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131517; x=1708736317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXnbbBG8uU1BPF0JsrRvm9475kp9ExkHduilmVeFprU=;
        b=Akyf7qSHGWdf8iq5CFmFpBfbeskLbYNyRQORqrM8KUNgt8bij3UAjaUmT+bOxz9jmi
         tblYyScOivi9tbPelu4M5MqS1rz/0QVWwjOOfuAAKUcGtwlr2T9T3OpmtqgxaDrA62OA
         7n5sa3ttFEHv2TiXsZE6K7WI+fQ7cK/MgGgGwbzhj55O1GNzJKZLxLELpYTy+T6fjNTW
         1qvdbkJtrICt3wAZQxceMEGS4McyxGGcKGSjENp8aJUCej2FzrAjBkvN9TKuvUMGiK0b
         duij6g5zC2SUmfPZpus6qiMPQHYomrtnIoyFDgbJmqRDsKlRSk2xOGA7fxBVuNbU3N+b
         HXSA==
X-Forwarded-Encrypted: i=1; AJvYcCUR8du5/bzwrV277gby2QQk9S7/XBbfc7nf16+0byKg8kMVx5Xd9WaZMs9RwSoUhuRym9Nvhvr95Q6BG3BgGdpqAh+H
X-Gm-Message-State: AOJu0YyeMd0E/tGaQkZO9Nt8Jm9A6JjGlpkypN1gS+qmY2G1cXbmkcfy
	qR1/PzWDozPXVB6bROauCELxSbOHnuMwryKzeMXOv1yR8p8u/tj6FsgEjVCGHjw=
X-Google-Smtp-Source: AGHT+IEd55O/kx49zwv2ulB5iw+jovlUvxT19+VDOzMjgyKdkOtaXKU1w9iKYbRt3ClDO/pqc7Grgw==
X-Received: by 2002:a05:6a21:918a:b0:19e:9647:dad3 with SMTP id tp10-20020a056a21918a00b0019e9647dad3mr13656557pzb.12.1708131517282;
        Fri, 16 Feb 2024 16:58:37 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:36 -0800 (PST)
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
Subject: [PATCH RFC 09/20] RISC-V: Add Smcntrpmf extension parsing
Date: Fri, 16 Feb 2024 16:57:27 -0800
Message-Id: <20240217005738.3744121-10-atishp@rivosinc.com>
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

Smcntrpmf extension allows M-mode to enable privilege mode filtering
for cycle/instret counters. However, the cyclecfg/instretcfg CSRs are
only available only in Ssccfg only Smcntrpmf is present.

That's why, kernel needs to detect presence of Smcntrpmf extension and
enable privilege mode filtering for cycle/instret counters.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 5f4401e221ee..b82a8d7a9b3b 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -84,6 +84,7 @@
 #define RISCV_ISA_EXT_SMCSRIND		75
 #define RISCV_ISA_EXT_SSCCFG            76
 #define RISCV_ISA_EXT_SMCDELEG          77
+#define RISCV_ISA_EXT_SMCNTRPMF         78
 
 #define RISCV_ISA_EXT_MAX		128
 #define RISCV_ISA_EXT_INVALID		U32_MAX
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 77cc5dbd73bf..c30be2c924e7 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -302,6 +302,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
 	__RISCV_ISA_EXT_DATA(smcdeleg, RISCV_ISA_EXT_SMCDELEG),
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
+	__RISCV_ISA_EXT_DATA(smcntrpmf, RISCV_ISA_EXT_SMCNTRPMF),
 	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscsrind, RISCV_ISA_EXT_SSCSRIND),
-- 
2.34.1


