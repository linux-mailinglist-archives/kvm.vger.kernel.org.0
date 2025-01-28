Return-Path: <kvm+bounces-36728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 583D2A203AB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0B923A2CF0
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7153F1F151A;
	Tue, 28 Jan 2025 05:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yUDVI8qm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE231DFD9B
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040403; cv=none; b=sLHP68Hg89EyFdkPkb+RSggn/Fe3d74eQuEQ4RAMvTxGX3w9cnb5E/9HfyOSj3rPmjVljKmydn/5qppokYBECKcFdEE8F8GyzWPadxwPvBynPKWyLDtwW0vupYQfH+WrSaK0ECPggKSOocVu5CxeXRe68un1if4xifFidDrXSMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040403; c=relaxed/simple;
	bh=tJECrev6NZHKGqf5bDRKo7n5+d6HFqBv/teL58QYUO4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l6inTl3xWFkmL4MZVnRa60LUx3DdTQEfj21SWsikhVu+DPYIlGy1DiCq4HbPTpKvmK+0ZBOB3hXbrBVrBl3BHkqcpaIz1wooBF+48OIbxEtGqruOWnD5T8JjUashfCQFqPkUmRz7GLSx8CWGcm7mM4+FyJ1QlSiyC6Y9qjK8NZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yUDVI8qm; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2efd81c7ca4so6882223a91.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040400; x=1738645200; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5mrMIkTEe6NxNBfmJmR1XKICEvWgZ9tUVZlETsQZaOc=;
        b=yUDVI8qmyc06vcNZ+S2ryoBMaA1Yudx9DuSG4fEE4T1QRwI9X4LpT+RIIjm3ZhO3sA
         uFV85nY+mARFLsHXv6/IAUtLtyIk5b0x6bg5ZrvGuzuRJSQdTOosaH4u/EU1AJeOTsBh
         BKioaYiOOIak4TRZHWK4IpcrVJVrCP7BaMJJpuHqVP/DO7P5dEvI7suGnxNfoIBm1Q8N
         I/0LPoxqE4yHCRWc6FO8LOL8p2Flpb5++eymHeaA/3VCEQGRWUg178tTpmBGEca3rOgx
         z+dDWx3v1uIuj4dnctNqwgoByThjrmabpoAoQUWBzr8gx771XFxQU+6QLxtXZjh77ZCj
         a4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040401; x=1738645201;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5mrMIkTEe6NxNBfmJmR1XKICEvWgZ9tUVZlETsQZaOc=;
        b=KBDcmau51fIftaNwQo42AyyKSyc6pztUa5mH8Fg4PSKIEcXL4t/8C2m90lXpztjljw
         n2TvWL+4rbMEVO3fnIJlvc73bIc0kFgQgwnptLyA2zaXtgY99O5MleG5UiI4fT/WnoYA
         O+HFtv9bC1PcWTgbBpnDqZuSqEuCVzZWddOTy601t/83Kr/UQQ1xLnuARM6XkhjXZ8Ac
         sV8hYSqGbnONzatrLqPyegRN2dtLmr0SWCj1FAkae6M35toiWiU6RTz5oyHMDccjAMPp
         SuOFINgnO3rJDg1qCEH80RWGFU9DDtTPMzZWifL0y6uCLk7LlPiaaXN2PDXz+YQHJau3
         kbLg==
X-Forwarded-Encrypted: i=1; AJvYcCWyPoFPE0lUHReEJNfVSJZxMH15zb6oYq6PLgWABYpX1k3MAJMtWI0DExW4xW1XS+JKaWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXpG57Ibmg1qrpemB0FUghLLJ0+LQNDae9zz2Pp5nOKUB1GFd9
	rXmNGrPOk/jEkgri1FYwtyjyfOqSjv4K1QbMiDYZ93fIfHDcKZTrjtrLcSKAe1E=
X-Gm-Gg: ASbGncuS397UEavEhYjG0lg+y0isQkYKRon9izo/+Z3XoHjT1v6vtOjCEFAZxW9D4R+
	yQ/SMRa0+3tDdf3ioWvamAPPUQ5u4yGrOS00suIQll5ln4Y4ruCt1VonnKnzYF04YjQxjUrwZ6W
	uDRrrKf9m4b9LoMhbjTiX33q+S4x6E01LykQPDLMmjnrbV1lQ3gj9PTU1WWzR1n9//A2BHciwaM
	IcUicydzu6uvZ6/zwM3XEunaqW/aMXJ8gpu/7qInXhG6fhizNXGwoFYBJmiifguun9oDhT26h41
	03kbh+hWt8mxCOFBuTo/Pw6YinSl
X-Google-Smtp-Source: AGHT+IH1CyamZ5GxB/LaeGh1+pUXZNcyZ/3f2i2HBGmcLQlGMYAJa1S5yIJT+e6qxkT5U/Ox2SNkIQ==
X-Received: by 2002:a17:90b:288a:b0:2ee:bc7b:9237 with SMTP id 98e67ed59e1d1-2f782d35fafmr61340887a91.27.1738040400688;
        Mon, 27 Jan 2025 21:00:00 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.20.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:00 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:48 -0800
Subject: [PATCH v3 07/21] RISC-V: Add Ssccfg ISA extension definition and
 parsing
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250127-counter_delegation-v3-7-64894d7e16d5@rivosinc.com>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
In-Reply-To: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
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

Ssccfg (‘Ss’ for Privileged architecture and Supervisor-level
extension, ‘ccfg’ for Counter Configuration) provides access to
delegated counters and new supervisor-level state.

This patch just enables the definitions and enable parsing.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/hwcap.h | 2 ++
 arch/riscv/kernel/cpufeature.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index 3d6e706fc5b2..2f5ef1dee7ac 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -102,6 +102,8 @@
 #define RISCV_ISA_EXT_SVADU		93
 #define RISCV_ISA_EXT_SSCSRIND		94
 #define RISCV_ISA_EXT_SMCSRIND		95
+#define RISCV_ISA_EXT_SSCCFG            96
+#define RISCV_ISA_EXT_SMCDELEG          97
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index d3259b640115..b584aa2d5bc3 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -390,12 +390,14 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_BUNDLE(zvksg, riscv_zvksg_bundled_exts),
 	__RISCV_ISA_EXT_DATA(zvkt, RISCV_ISA_EXT_ZVKT),
 	__RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
+	__RISCV_ISA_EXT_DATA(smcdeleg, RISCV_ISA_EXT_SMCDELEG),
 	__RISCV_ISA_EXT_DATA(smmpm, RISCV_ISA_EXT_SMMPM),
 	__RISCV_ISA_EXT_SUPERSET(smnpm, RISCV_ISA_EXT_SMNPM, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(smstateen, RISCV_ISA_EXT_SMSTATEEN),
 	__RISCV_ISA_EXT_DATA(smcsrind, RISCV_ISA_EXT_SMCSRIND),
 	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
 	__RISCV_ISA_EXT_DATA(sscsrind, RISCV_ISA_EXT_SSCSRIND),
+	__RISCV_ISA_EXT_DATA(ssccfg, RISCV_ISA_EXT_SSCCFG),
 	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
 	__RISCV_ISA_EXT_SUPERSET(ssnpm, RISCV_ISA_EXT_SSNPM, riscv_xlinuxenvcfg_exts),
 	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),

-- 
2.34.1


