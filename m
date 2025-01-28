Return-Path: <kvm+bounces-36738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79072A203CB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C52C27A1142
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF8BA1F8F0B;
	Tue, 28 Jan 2025 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="sEDD9pkC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284B1F6687
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040419; cv=none; b=gPp9Pe02QE/vK4JiE5zmeXmPVl1FJiSNPn5z4AoMtocT8M0uqtQRPZmrQPNMRvyiv5NBeUZAz02UG4lV/gNpGGtfzFweO6KbvHEvI63uy+bOf5ieoYElUrYOA7qsUQUWlG+VSf+68fHaNY62bBRODuxjKkSiEDs6hsoPofbe5Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040419; c=relaxed/simple;
	bh=35UkcKfzaQAHaYAm8G2pZxEPgxiTRWZpmKzaOMWvgmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lbLCrA73tMkfXR22y1cgqmLsYDoBz39SL125LrCMIGEUNJzSfZ20UeZIWzZSqQxbcim8wt7CSD+ac0YKCjliZVYxZf+DHyyJfU/khJIWrmJoGMCYiXvMvg95hW0m5/GmRMxb2HleedNe/KiT6V2cP8mCkWXb5jJLQgean/EipHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=sEDD9pkC; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso7177314a91.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040417; x=1738645217; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QcgV78ON7bQjbj8rz+m5AxTl8xJOToNes7SYHJXciAs=;
        b=sEDD9pkC4pB7F/g/dmJa6hpT05I/mMrNNw0EuZthofTdMtUpyAg3axEpUgYd1G15E+
         rHtckDJQjODVbvJ5msOw8V0JmQfehJnC5jT0uI1H1DNLFZkD8wg+ssWHCMXN33OM0JSx
         D544BcvoVuj1RxHHwfitmH7LNghZ4DaBfwKh2TiLIjqWfp8M5j2EYx76CGJYDY7o3goC
         uG8wO1eVk8z6RC267mjOK0qliN5mpaVsKFT9r51wakbAOtkipYj2bzvbJ5EfAZiw2j7R
         sgqDyIVKkBYKpcyiTAiCNhLVDfp8ikBcrPrBEVl9EIWMjne5KR20VPoViYpSk0jyXlQZ
         5Ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040417; x=1738645217;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QcgV78ON7bQjbj8rz+m5AxTl8xJOToNes7SYHJXciAs=;
        b=UwxytepKUjhJQipm26NUKdX5PCrcIJKxkzKZJdlBTQWsQKOwJUCqsbsi44c73Kl56z
         n1biFxV29BcSk1Rqrhw6kE0zssDbY9fLwO4zTH+0pjjCvvk4JCJZdL6D8ZJCukqdhrnW
         U9oN6iFeh5LGkvmyoldtXnAmxeTwx1QXbXsr40pcD2aJGtjxfqBQbuxdICK2MrENvCUY
         5t3PwEnqQauHiPkq7Mg/gznZGU+IJUKdQXhspLsvMJ063F2Q8krFsDYTm+t40CFduaUf
         czqDgapodNYG1LuvHIcCYFLXcl+EP2Duy6yEn3EUPkbLHx9nfbrOdS12FPnB8QT1F7j3
         m/iA==
X-Forwarded-Encrypted: i=1; AJvYcCXcOjBrXCENtXtxGObNYmL95H9J3lHKWrj1utZoHHRXNp3AP+P8jzQTPd+G/K6hpLFpDEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTOsISJAWaGvVqPnlGRwu0ANuw3JhNEw9C0eEe5ZQR4qiS6AYG
	jSiGwWvbzyE1cCqr3CIrWSeCWU17DXL2GlDKAIg3LZ3zjKKqCXRSg2+o/3YVX+4=
X-Gm-Gg: ASbGncvgPVTH2Jxu7CwKkD3dIukkJi7upmhgtWnc1O8dqrr8y9BVjY21y4ttDwmu/3p
	IDJmu+/Tp4kUOV/373WWizq3x3XmJl35GIhqOFhMrVcattdecP573KHTnBZHwBqO2ZdBcwIVbNf
	y6UmXL8n95c8uYCnPw/t4knMKaYtgASCkIZK24sXReulBPQR+M+K4p0tVpPdcubL4QPIRG5B3z/
	MrZfCmIrdo8zgREZizo1I8FfMRp4wSaB31iu7KGZbNbRIq25hXV2V7ucTzjlXhAqdzqcQTH+u6C
	Z+je1LlLmdkCB3nqJEm9safIDgzg
X-Google-Smtp-Source: AGHT+IGCm7GMS3VNtxEaZyWfkLMPbe+hI7KXpym5HHPhVJQX2ASsOYeeTikT15JA57Prj6Ttz9V96w==
X-Received: by 2002:a17:90b:524b:b0:2ee:a583:e616 with SMTP id 98e67ed59e1d1-2f782c8fd41mr65998400a91.9.1738040416850;
        Mon, 27 Jan 2025 21:00:16 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.21.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 21:00:16 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:58 -0800
Subject: [PATCH v3 17/21] RISC-V: perf: Add legacy event encodings via
 sysfs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-17-64894d7e16d5@rivosinc.com>
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
index ab84f83df5e1..055011f07759 100644
--- a/drivers/perf/riscv_pmu_dev.c
+++ b/drivers/perf/riscv_pmu_dev.c
@@ -122,7 +122,20 @@ static struct attribute_group riscv_cdeleg_pmu_format_group = {
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
@@ -362,11 +375,14 @@ struct riscv_vendor_pmu_events {
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
@@ -388,6 +404,8 @@ static void rvpmu_vendor_register_events(void)
 		    pmu_vendor_events_table[i].archid == arch_id) {
 			current_pmu_hw_event_map = pmu_vendor_events_table[i].hw_event_map;
 			current_pmu_cache_event_map = pmu_vendor_events_table[i].cache_event_map;
+			riscv_cdeleg_pmu_event_group.attrs =
+							pmu_vendor_events_table[i].attrs_events;
 			break;
 		}
 	}

-- 
2.34.1


