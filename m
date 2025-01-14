Return-Path: <kvm+bounces-35476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A87BA114D6
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A92D77A00F0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB6B228360;
	Tue, 14 Jan 2025 22:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="mRpHszRX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78515227BBB
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895532; cv=none; b=aSLLdejscmBjxyODBTg03DL85dVVvEQfqs44aewTkvCvdyY+nJSOavNRemJgjsauxksSHjQqJVgQ4RumHkX8jvY1+auyA+7Sx0KDMs/wHhF70ee3tFU8oB1jo+lPhAURoevvWDukLKsFXVZ1EPY6401qM4hDm6WdKrjp8zBVnog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895532; c=relaxed/simple;
	bh=KX+c6OZLcoeS98RkAUKLotKTlJrHqY7en1pLAwLRhK8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mDYmodA8qpVIiagGazWkLk3h/cuzSgZ7rOv946a4Mmz5p+ahmNcBNP6zOVtoLGOk8cxdMB7oh3slo1b2Yz6Z/SP9uyXfvyGs/SwSK5hgSI8hNn2MkfyiWdoZzmcbYA75IFdVAnCywY1IfFyFMQkMT7jKcVszMZ6SQ5jsPxq+HeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=mRpHszRX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2164b1f05caso108020535ad.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895530; x=1737500330; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qntZYbhhaPOyc0opQ/xzbCXT2UPDrjgDrjtXnzGv1Lc=;
        b=mRpHszRX6ik/dBvFnqOgfexdZuIsP3u9Y4NIjN1p5e8ujRPU59C/lNHIgHqxrP+eA+
         jIU9a7ITmY46zrhBLYlYqhYKWYD/pjktFnLHFjpx3GGDK+vuLsAvOIUdyUIQNQtmKDqb
         IiAZDKi6gZiemqdf+cOk8DB8Fyl53wov3wkzwECVnIJPsrSfllEdV0XIKeLNcO52B/hn
         T/gV1o6ElybcHx9U1KWDpbPkUoxLora92bCoC3mfalgFqGCx0UFLbIETkmtjF7KO7+UF
         bG9084XOX1dAJwElF/ZBhg5guNP5em/sgu5tnnhGRaAS41ldsh6zD3v3DdkLX9d4C8KG
         SWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895530; x=1737500330;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qntZYbhhaPOyc0opQ/xzbCXT2UPDrjgDrjtXnzGv1Lc=;
        b=SnGssNWeSLHmAWImFdS2YOU6uPAvSnCODll3RRJQ0AAfUXJqCdJMXqJzEmUUJpWVCo
         jg0RWQFOo3AYbF2nsVE/4V0J0DLULfniOmV1YgRJ03MZUFv7RzS13bkZnTqYuMxAxH/H
         w5+iiq72K/WMM8UM05FWRefkUnUF1kxVq1QUqZmzHF0ekdpuQjI4nYxSHFy+gLQQ8x5U
         2mFUXxlrM56LHl9bhqN+eQxuAu3AKWpjaxbwO0QuRIA22oexh4ImdGW1XnwM7krzkZRX
         f9xYcAkc5GSBaqXQd6inKnjYgssyF/Zszd/4xyOxlZwCGveavPcSw5qt1kuBOHCeDtK+
         bQOw==
X-Forwarded-Encrypted: i=1; AJvYcCVkn7LyQHYb9ri2p4iwNm9sD8iOktylZl8JFIgEp9SxuCrDeEfJVi/sIQBBBYO7OfoZmgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUadYxp5/YXIc2Eys2x6gSX+BKw/VeU68V5CeMdT1hbfvHORtE
	g6hGIXvmTbeXJYLzSughMzN0ryH9M1deRa5qR1B9bweV56354VcxONanS1rJGME=
X-Gm-Gg: ASbGnctzre3SqLXf6LvEXNcxgjDUKYJYOlz74Vy8r7Rhg6Jh9/xIqL0+XiKeX9512Yd
	YV2b6otK6Vqh2wKu23PGd6rQnC2RB8BjbtUBjDiCi0jpNuPhRxR6eZyaaSvH6V5FP8a3cpe2Vzd
	Onku80RIscPhPUznIeVpknlnuRGamVdpgcRvFjOK7ubA/NI+Gy7c1DZ2R+qxWceN4wLwtfcqimZ
	3sQScKgUzsfhb5Xqlsz1W4c70uNeAtvWgmetKDxjA7CpI7kwLeqCCndz1QzjWjWQT8KHw==
X-Google-Smtp-Source: AGHT+IGvBxZa4fPYf8i5v/l3b33jLbUOvTwVMUDT5oDU8+c/I1Eb7QvrJXcdFBnuK94wX8xRhTTgmw==
X-Received: by 2002:a17:902:ecc5:b0:216:45eb:5e4d with SMTP id d9443c01a7336-21a83f4b29dmr369677175ad.6.1736895529901;
        Tue, 14 Jan 2025 14:58:49 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:49 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:43 -0800
Subject: [PATCH v2 18/21] RISC-V: perf: Add Qemu virt machine events
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-18-8ba74cdb851b@rivosinc.com>
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
index 8c5598253af0..d28d60abaaf2 100644
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


