Return-Path: <kvm+bounces-36739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B37CA203CE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C82801632AE
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355961F91E9;
	Tue, 28 Jan 2025 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="O+T053w5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCD01F8AC3
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040421; cv=none; b=rfH7Q4rrTgq7PUuZy876HYTc/5a8LFg/x9r9AM5WC51J0wJqc31nA2E0QTjRZ3y4RQFbRMX8S8tlo5NQiQnubc7g5jIMAbOSRUFoiBF8RYPdISXIWFgn954/i2u/h22ij4o+OCNmTofOz5/tevYobr8wsZdoWjURx8b9LlkYTGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040421; c=relaxed/simple;
	bh=7L9cr7KdPT07Iv2ikCIHod/sKcSPb3sA1NMIbfS67so=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uOchcwElWDUJQA9tpgaOK5cuhQeqjLLj0APYeXba3bwFnRkGTS5tIZAN8+o7I4P4r+kujVOM1q2N/L4VG3/fEJ8YhQJoRiX9ppFFYJl8cEiJNjU9VAYLouuNBtLmx/qabC7+D/z/9IFQFQkhGhlVxUpo97madvQUzO0EXwzO/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=O+T053w5; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2f4409fc8fdso7986884a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040418; x=1738645218; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r5NF+IAT/KmspwMK0FGMQwrWJIha2MiTbZ1WzqIdfAY=;
        b=O+T053w5tArKqaxJ08l1uIGgzqExmtXPQGXE0mtAOMWj3lq5eQbcsWbAHmglnRZnT7
         2s5csfRqIQEmN4ej2S83O3Swbas5123zE2nNhuXnLupCbeKwFj7AFej6/lgj170gE28F
         fxfEUR9NkbN7SEoqEztocDReA7qUVU6bvQWuR1KKUff8gaNVqTiJiVMFLEHEdmWKDxOR
         Y4OccWu/V9Z0HI4VAy5sC+qG2M+iGiBdmn0JypJCod5kWqyjKkIFjjBz1cNxFvEXoGZQ
         sFEMJwtSOiszwor/bCQYGLfTCcAxOeb2SDs8PjnXaJI2fwniBl4hNReSi4P00k59zJJZ
         jdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040418; x=1738645218;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5NF+IAT/KmspwMK0FGMQwrWJIha2MiTbZ1WzqIdfAY=;
        b=aGMJVaxG+XL5G6m7z4hmetvw28Z6Wo7qKwc80m98knT6FbTxRzC3r7diHy+g/iumDY
         F+ivMx/gjwcO51xeg06x5STisurnAiPafRMvtUriHyYvQpLjJSM/TpIKJUPDzvusBD0O
         ae0T8Ts4uKrPZ8TE+2/tg0f1JUp9bbXTh+EufKx3D5aArMtk4QR9GObdnHgAYfA3fGkO
         /ncsvTS1D3nybVANRm3H9GFP4rS8kWMX81NvD4tekFPYUlWCEPmPlgLR5s89pjfXtVU7
         TL2BwzqyB3A4vggd9+m5G06oQLZjqYwiogbJw8c5o68Wj47VTng5CmNhD7Oog4tNIdwF
         R9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrY88MiGcxGwgYQaacgacei8OR5Pviya/6vnUNykXoASamgQRdFTi4D9cTon3MGTXCszY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdbu3295ojQMokEeieYrTm5tspNNUOwLGssoY22LpMb+fcnlKC
	oAW3H+l+hVOfuKZbcuXWbjUOxrQvxeIKJ/8R/ijlWX7HKQm65RhPD/3ItD5OliU=
X-Gm-Gg: ASbGnctX7IgWRTVhYCF47JhAVIW3Rfc7Qn5JekXPxFGBTAbHpD2ksbqzKNqWwreFjwE
	CdV7V88JZv0jAn0/2qQZyRygIxLpyDd8BRphayLHCTg3hZzneVwN3e0BNgLFf3DJn4reC4AieFN
	2ogWntUDpjxcQqPS93tGlVCq52wGUvBqrjiphzhUY/Q9m99Rlm6I7KiuJAHbtAmINn1weqjNqpu
	vgl30vi/lEU5JPHr2tc5RWJWKkeD5SZpa6hCk6Nb7BALAsA2jzoQnADkvoaMI/lyynWBpAQHc+R
	wZhS1qcpkYSmWKifDPtDjkT/Wj0VaWg/sMlt/BA=
X-Google-Smtp-Source: AGHT+IH6k4v2G1ElxeZAZKnP2qHihpfZzn6nd2gCpEPf3NHDHrL/Cp1+5uWagHMGSZOAiqHrlZzQ2w==
X-Received: by 2002:a17:90a:f950:b0:2ee:c30f:33c9 with SMTP id 98e67ed59e1d1-2f82c076328mr3187299a91.14.1738040418390;
        Mon, 27 Jan 2025 21:00:18 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:18 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:59 -0800
Subject: [PATCH v3 18/21] RISC-V: perf: Add Qemu virt machine events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-18-64894d7e16d5@rivosinc.com>
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

Qemu virt machine supports a very minimal set of legacy perf events.
Add them to the vendor table so that users can use them when
counter delegation is enabled.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/vendorid_list.h |  4 ++++
 drivers/perf/riscv_pmu_dev.c           | 36 ++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/arch/riscv/include/asm/vendorid_list.h b/arch/riscv/include/asm/vendorid_list.h
index 2f2bb0c84f9a..ef22b03552bc 100644
--- a/arch/riscv/include/asm/vendorid_list.h
+++ b/arch/riscv/include/asm/vendorid_list.h
@@ -9,4 +9,8 @@
 #define SIFIVE_VENDOR_ID	0x489
 #define THEAD_VENDOR_ID		0x5b7
 
+#define QEMU_VIRT_VENDOR_ID		0x000
+#define QEMU_VIRT_IMPL_ID		0x000
+#define QEMU_VIRT_ARCH_ID		0x000
+
 #endif
diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index 055011f07759..db4a61fac838 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -26,6 +26,7 @@
 #include <asm/sbi.h>
 #include <asm/cpufeature.h>
 #include <asm/vendor_extensions.h>
+#include <asm/vendorid_list.h>
 #include <asm/vendor_extensions/andes.h>
 #include <asm/hwcap.h>
 #include <asm/csr_ind.h>
@@ -384,7 +385,42 @@ struct riscv_vendor_pmu_events {
 	  .hw_event_map = _hw_event_map, .cache_event_map = _cache_event_map, \
 	  .attrs_events = _attrs },
 
+/* QEMU virt PMU events */
+static const struct riscv_pmu_event qemu_virt_hw_event_map[PERF_COUNT_HW_MAX] = {
+	PERF_MAP_ALL_UNSUPPORTED,
+	[PERF_COUNT_HW_CPU_CYCLES]		= {0x01, 0xFFFFFFF8},
+	[PERF_COUNT_HW_INSTRUCTIONS]		= {0x02, 0xFFFFFFF8}
+};
+
+static const struct riscv_pmu_event qemu_virt_cache_event_map[PERF_COUNT_HW_CACHE_MAX]
+						[PERF_COUNT_HW_CACHE_OP_MAX]
+						[PERF_COUNT_HW_CACHE_RESULT_MAX] = {
+	PERF_CACHE_MAP_ALL_UNSUPPORTED,
+	[C(DTLB)][C(OP_READ)][C(RESULT_MISS)]	= {0x10019, 0xFFFFFFF8},
+	[C(DTLB)][C(OP_WRITE)][C(RESULT_MISS)]	= {0x1001B, 0xFFFFFFF8},
+
+	[C(ITLB)][C(OP_READ)][C(RESULT_MISS)]	= {0x10021, 0xFFFFFFF8},
+};
+
+RVPMU_EVENT_CMASK_ATTR(cycles, cycles, 0x01, 0xFFFFFFF8);
+RVPMU_EVENT_CMASK_ATTR(instructions, instructions, 0x02, 0xFFFFFFF8);
+RVPMU_EVENT_CMASK_ATTR(dTLB-load-misses, dTLB_load_miss, 0x10019, 0xFFFFFFF8);
+RVPMU_EVENT_CMASK_ATTR(dTLB-store-misses, dTLB_store_miss, 0x1001B, 0xFFFFFFF8);
+RVPMU_EVENT_CMASK_ATTR(iTLB-load-misses, iTLB_load_miss, 0x10021, 0xFFFFFFF8);
+
+static struct attribute *qemu_virt_event_group[] = {
+	RVPMU_EVENT_ATTR_PTR(cycles),
+	RVPMU_EVENT_ATTR_PTR(instructions),
+	RVPMU_EVENT_ATTR_PTR(dTLB_load_miss),
+	RVPMU_EVENT_ATTR_PTR(dTLB_store_miss),
+	RVPMU_EVENT_ATTR_PTR(iTLB_load_miss),
+	NULL,
+};
+
 static struct riscv_vendor_pmu_events pmu_vendor_events_table[] = {
+	RISCV_VENDOR_PMU_EVENTS(QEMU_VIRT_VENDOR_ID, QEMU_VIRT_ARCH_ID, QEMU_VIRT_IMPL_ID,
+				qemu_virt_hw_event_map, qemu_virt_cache_event_map,
+				qemu_virt_event_group)
 };
 
 const struct riscv_pmu_event *current_pmu_hw_event_map;

-- 
2.34.1


