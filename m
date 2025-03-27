Return-Path: <kvm+bounces-42156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E03EA73EDD
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E7103BED71
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3EC2356B2;
	Thu, 27 Mar 2025 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="a9idOOEr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736CC233733
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104202; cv=none; b=T5E/hAt9fGVt6EQS72Sl8Ej3cMQlihbXyngwtPrk2VhI8Ol+A5vZOTXT5zFrsuyhJwoOy8N7jlMPiIcfHNn5JPqZl+RevptvZd4atnSU1J2bO1pOgK6hTkNBLfVc0UEypRx8swkPO5FxOF7UR+9uL9ZTot1Xd7SDVP7K+8+QaB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104202; c=relaxed/simple;
	bh=xlYuw0WqXBjwDLdQp7xWvSer8dY7O6gPMvcB2OEu6us=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jRxV4n1Al1Podv+39sSjOZ0utBbQ0yFE0E0eGkKyf8bMG4aGW4QCM57fsSPe5U2tR+WIdJYYpP9Oenlbv9vyUeqjgbL4UYpnKvy3ikkIpSmm/xdFOk9kGawB9raYy2pfoUJ5dJEedllxci39Ldid9FtxpBVDZQtLPdxGTRAxz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=a9idOOEr; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-303a66af07eso1936856a91.2
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104200; x=1743709000; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KssINcBHG6V5nsmKK6p0ubimcU1BXEQtWDJ9ECnykV0=;
        b=a9idOOEr3p8IcGzZW59E+WzhZdg+eU0FPNRbhQvmAVuLjRw4fnMav+K6Y6ysvZZm1T
         mvxRAcqQDky+erslleQ8Rwo03torKasm/mpaH0nfDJnOqU/GTs+injOFy1N8BOHOzn2x
         2AFKF1G/jx6GOCn22PPv9Pqr1ZHf/cP19TDuITsoUS1AwgWY7TDA+xklfhY8MVQSMz4I
         6+CgTH1LH2bFgWJQhiZqXFTmvPp29rrrO540O981em010TQSkM+q9BSwHYl3Ysk6716Q
         tiTugNKgS3MvOq9MY6y/p811kGMzhcqHs60S6U7nh8OM25JC07Ep13kTsrjimSJ3fEYf
         sUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104200; x=1743709000;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KssINcBHG6V5nsmKK6p0ubimcU1BXEQtWDJ9ECnykV0=;
        b=a5i95bj1DwJrZbhB+2IbIXxoRfNKfO0UOr6TDRxOojq7j12ARg68YhzFBffAQNy89B
         HYbtwr4isllJIFfhrwqKGb/nbv140t7ax638ogAvb7lb7gMqbbVQQJkhkbIAA5T7V46i
         nRvzQ23eK0GmQDywrujJN0f4ic+fsp408/2bRThFl3IEw6r5DIZNp+BJHPi8Bhv5q0Bf
         SfPlbM8Fu3+cdL686YV3byRfmLvj01MVpYYUo98GSR0Rm2R3p+quSQU/XW3do/ZS5UdE
         voSqNCBnxV5NfcbrJrW15qOkEy1m4lnkp1eIW1QhGJ0A1kV/Sjm7gtTSTux6MnPaUcOC
         JwTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQgZceT5C+NUnfjCRaSS5g8oB5ViqcsHP/L54qrKWt0VpvSoAD6uYZidfhgVAUwep8QaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEBv8F+8dhGUAF4XPvtoqW4riuNY7RaS4YJJzh87CBatp1+Tnb
	2JMLRraRr6WiFbgN+89sGDtRIWAvGjCX4JI8niG0SjsQ46UcgcwopwqbHo5ZX6I=
X-Gm-Gg: ASbGncspVKQcRYMRK7r6t5q0Me87fNBn0uyacZqvbllCzdSTvpqsYUAI1oMZ/OwZXfO
	MnYEj2Uyi4bnIT7AgssPBkv7HSw6c4ZNCLiyR1oT77SNxdefny3ygphmo8bpcR5S6fdRwwOl+To
	WBxLaVZ8bKnLF2h+WwEg+VDsWSbkBtSeBrfzwPm9RDikHnZyJzIpw8l0OVS+Wmy3uq4kG5FTcdG
	pGibM94usMwgXlIcqoeRfHWC5DOMKTf5yGouu6xFvku9iskPSLnwr87w467S/1NN+BltKpPaYKQ
	KzLl1k7WkmTiZY5ZTByhyjvEugluJXEtyJ21/vGwXWHO/QDWiILxDBhs+g==
X-Google-Smtp-Source: AGHT+IE2krN6Iazwz2/u7kYznnPmcB0AT0QBtnSPpGlLXmbNzMbs0M2bltPDrqZDoRjoQ9cuAJeaHg==
X-Received: by 2002:a17:90b:278c:b0:2fe:b77a:2eab with SMTP id 98e67ed59e1d1-303a8e7653bmr6347831a91.32.1743104199626;
        Thu, 27 Mar 2025 12:36:39 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:39 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:58 -0700
Subject: [PATCH v5 17/21] RISC-V: perf: Add legacy event encodings via
 sysfs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-counter_delegation-v5-17-1ee538468d1b@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Define sysfs details for the legacy events so that any tool can
parse these to understand the minimum set of legacy events
supported by the platform. The sysfs entry will describe both event
encoding and corresponding counter map so that an perf event can be
programmed accordingly.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_dev.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/riscv_pmu_dev.c b/drivers/perf/riscv_pmu_dev.c
index 92ff42aca44b..8a079949e3a4 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -129,7 +129,20 @@ static struct attribute_group riscv_cdeleg_pmu_format_group = {
 	.attrs = riscv_cdeleg_pmu_formats_attr,
 };
 
+#define RVPMU_EVENT_ATTR_RESOLVE(m) #m
+#define RVPMU_EVENT_CMASK_ATTR(_name, _var, config, mask) \
+	PMU_EVENT_ATTR_STRING(_name, rvpmu_event_attr_##_var, \
+			      "event=" RVPMU_EVENT_ATTR_RESOLVE(config) \
+			      ",counterid_mask=" RVPMU_EVENT_ATTR_RESOLVE(mask) "\n")
+
+#define RVPMU_EVENT_ATTR_PTR(name) (&rvpmu_event_attr_##name.attr.attr)
+
+static struct attribute_group riscv_cdeleg_pmu_event_group __ro_after_init = {
+	.name = "events",
+};
+
 static const struct attribute_group *riscv_cdeleg_pmu_attr_groups[] = {
+	&riscv_cdeleg_pmu_event_group,
 	&riscv_cdeleg_pmu_format_group,
 	NULL,
 };
@@ -369,11 +382,14 @@ struct riscv_vendor_pmu_events {
 	const struct riscv_pmu_event *hw_event_map;
 	const struct riscv_pmu_event (*cache_event_map)[PERF_COUNT_HW_CACHE_OP_MAX]
 						       [PERF_COUNT_HW_CACHE_RESULT_MAX];
+	struct attribute **attrs_events;
 };
 
-#define RISCV_VENDOR_PMU_EVENTS(_vendorid, _archid, _implid, _hw_event_map, _cache_event_map) \
+#define RISCV_VENDOR_PMU_EVENTS(_vendorid, _archid, _implid, _hw_event_map, \
+				_cache_event_map, _attrs) \
 	{ .vendorid = _vendorid, .archid = _archid, .implid = _implid, \
-	  .hw_event_map = _hw_event_map, .cache_event_map = _cache_event_map },
+	  .hw_event_map = _hw_event_map, .cache_event_map = _cache_event_map, \
+	  .attrs_events = _attrs },
 
 static struct riscv_vendor_pmu_events pmu_vendor_events_table[] = {
 };
@@ -395,6 +411,8 @@ static void rvpmu_vendor_register_events(void)
 		    pmu_vendor_events_table[i].archid == arch_id) {
 			current_pmu_hw_event_map = pmu_vendor_events_table[i].hw_event_map;
 			current_pmu_cache_event_map = pmu_vendor_events_table[i].cache_event_map;
+			riscv_cdeleg_pmu_event_group.attrs =
+							pmu_vendor_events_table[i].attrs_events;
 			break;
 		}
 	}

-- 
2.43.0


