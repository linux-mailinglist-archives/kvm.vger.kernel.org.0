Return-Path: <kvm+bounces-37437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D60A2A220
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:27:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5BB13A6C81
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8AC022CBF0;
	Thu,  6 Feb 2025 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="KJ946uGm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074DC22653D
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826608; cv=none; b=MBl2wRWO615BRuOYeBpiRcqQCzG89pn2w4WOs+0Z8VC/YUnKp33zMOwsEeZRoEmQJcXyqqG/nGpWoeQXT647OuPRjmMYn6TLP6aOvFoWW1NlyoDSi3qOih4Vzqnr5iZRtzgyDg4Z6BrbgABbHwNGKjOmaZo4qvAHQb7gSxcFSX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826608; c=relaxed/simple;
	bh=ClIsG2Lx2D+ejEOZiGO0Kg4tbTxKfRi3WIEvB1U1GKQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W2+o9Hax4di17KqAdtnWPxD0V3VL1NMatTRKdOMMqB5BNxd0hGO2XiojhBxC7Xo7tHHmkkSQDeuMWZY+HRm0wSW2zLi/TSCoXoVbBVXcOTRaWsJu49M6fbjUloZddva6f3VoU9rMgQAsUyzI4kYvddAZbACwdbuVBd1hfQm2150=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=KJ946uGm; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21634338cfdso14076235ad.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826605; x=1739431405; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5jEaYEVzjt3yKFEUjA3mSdxHjzs+ekk92pc880MhBaw=;
        b=KJ946uGmshr0cWcZofe8BsJUoVthUACwxK3OLkvGUYPbo3Wf+xhoKi0l/StgTxqV2t
         3AsfZsUocSm2I5DDj6Zd5WRx28xAGqGcMge0UBvjb4PPCu8AcPZzGEfdyZu7eSjgLAbF
         Q/qso0QRE6Fo12AeQzOua+TVzNyBDu7cay2VndUqIYttg9IMqeT0NNzt7LmtCetnETUI
         QxmKoNhQrrP63WF8JJP7+ZMH1m6Kkqk1lnvUwwUjLGg6peLJJzPzYAcg8C0O1xO9dgv+
         CsdMGTNsXB07s4CRwtjhzJJAWCDc2d4GIe2I+Y/MVlCjxKTdCOIMH9GLBYYuOU/wQDMB
         KSzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826605; x=1739431405;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5jEaYEVzjt3yKFEUjA3mSdxHjzs+ekk92pc880MhBaw=;
        b=k96PPKdaTU9gaReKaL5wNZvtCfxaSpw08Cq1/bJqNvBrhJlKYzywgnD9dXeohty998
         z3Q5C3C14hEve+ieqmyNd2sXOuZmPF+lYgIENM3VXEGu9foRIRMcbdDEUMApJdjwkbL/
         qH9ZbTTxX6X1Aa4tCSzax6kVsumGtMxwIDdF6pnsHCTBKMgZFokA4IVJ3AyMXhcVz64u
         uEzaczInQ/gKE87ELZi8HGbvA8ydisB1+H/kv5+G0hfeF12kOdJwl5iSAoZDxbesMLtC
         lSmMuFpBLvX1vW/fe23BOPAURlS2JWGxdfkOweLDio6bO7nAdWNpGd2iV4K+W0RbY7P0
         b7yg==
X-Forwarded-Encrypted: i=1; AJvYcCUVOZHKXdA7grFmdXoy5bSd2q9+BCnC8h5RzobTuQtWccfnXCDMYuxLpu/R6tqSalcJqTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQweubcu6A7mAd5YkPRMMsdagekpwXZtifnk+iIOS/HkQDUUNw
	qaJEUnnVzhfHj/b5a5lMD0UlskZb4NNhTLTPalKOT27Uqvi8b9nDoo6Xvb1S06E=
X-Gm-Gg: ASbGncslR2joKnvPjQ/62H6PnNaUdIeWTZaw5Y+EsNgQQiiGnai4RHXVYX0tSK89laS
	AiihOmMXmjZtXPRKij/bbwf03VdmNtRIdPHrm3aLaUXLE9ob94jeDKzT1gzK6PVxmtXa0xreka0
	/z+gLehtXCWGPTQFxvNMxpoNjQwgElHxBzQ6VyvkRSMN6sRPWAwdXsw2eRC1spCezBc9w243Et1
	c8xnSOuQQ54tZVjFD3YO7/TXMaBiyGi9IwcaGlxTpHiYvFeosNnkqt9ZxZxnDu4sgCo4d5qNQDZ
	k/evHEAZ2EHF7ni7a8zpNcXes/Wt
X-Google-Smtp-Source: AGHT+IHzp0J+mwXj/o4qdyn5Yi/oH9R23yiqLBnusAGlaJls5faLTlCjx6NHAGuTvmvHDO4dBQO+Rg==
X-Received: by 2002:a17:903:2f92:b0:215:b190:de6 with SMTP id d9443c01a7336-21f17e2c950mr98353905ad.3.1738826605265;
        Wed, 05 Feb 2025 23:23:25 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:25 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:11 -0800
Subject: [PATCH v4 06/21] RISC-V: Add Smcntrpmf extension parsing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-6-835cfa88e3b1@rivosinc.com>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

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
index c6da81aa48aa..8f225c9c3055 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -390,6 +390,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_BUNDLE(zvksg, riscv_zvksg_bundled_exts),
 	__RISCV_ISA_EXT_DATA(zvkt, RISCV_ISA_EXT_ZVKT),
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
+	__RISCV_ISA_EXT_DATA(smcntrpmf, RISCV_ISA_EXT_SMCNTRPMF),
 	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(smmpm, RISCV_ISA_EXT_SMMPM),
 	__RISCV_ISA_EXT_SUPERSET(smnpm, RISCV_ISA_EXT_SMNPM, riscv_xlinuxenvcfg_exts),

-- 
2.43.0


