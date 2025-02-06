Return-Path: <kvm+bounces-37448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4B0A2A23F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA8471881FE3
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9E6231A27;
	Thu,  6 Feb 2025 07:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="FRoNQCLD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119323099A
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826625; cv=none; b=eZ7N6g44dMHk3UxF3/PgqXH2cZUWo7fkh7s3YhQi/rP2tQpMQZgFHcPZBvInP1G+NrzLVtNHgyz362nqs8YQerlp663ZtsForoWexTwFNJN7LT1pnN44y87MB3YLC92MSvcPXg2EHzzvFGIDBmuQIAT9Fh5eMQ5cFd6AE57G7PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826625; c=relaxed/simple;
	bh=bauPhqyei9pIckq60+acDhLOvCgCVkJ2prJTWUYShkw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C8YKiEa2nQSjfcnWC/nJejpJ2KxqxxhtTawhhic4neawMKa+6xMSnFJ7L+WkwHkQwZQUeTihO6VFFPmyP+afBwroD4JIzuphTO2RbampGb8gfB6XrU019dZsRHQwWYO9JRoZzbhEdpFbbuS0L32lH5Cvd33ZlPlnVRdaZCi6H1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=FRoNQCLD; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2f9f5caa37cso1712813a91.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826623; x=1739431423; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLt3uQ+5mVFCD4CpzivJzFeQzs8sYQp9bQK+aL0eLxQ=;
        b=FRoNQCLDl7hQKV0PAYQPopxyu93tgJQ+aiq8Yj4QGOJy6OfR5/eittKuAFDHIoYl2l
         cWH211hz59ZbZWJ/c5heePDXhd4koF2fuUG5lNehUyAMIZG0IOsMOxGo2vYj2V0brQVG
         DaEw1C+GUViUzz7NT0zrMLeItR44sCQ0g9+vBC+xW+z+qzeUKfELQaP/e9qU12nCtKAN
         cV3/hkQCFmYTjKNaW3JJxwKcClXdiKZzGKbVRehbI6+iAAFqZ3fq504o726ra3ri9RLn
         fFR4eWQtS9tUqGDCeAIYdVTPWSdYNhBY/OiMJIliobxrcNMSvj9knLhKgq9WMaVT5W+C
         v2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826623; x=1739431423;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mLt3uQ+5mVFCD4CpzivJzFeQzs8sYQp9bQK+aL0eLxQ=;
        b=BWK4PqFWnQ0c6FWsP+BRRbn5Qxh4CGow1vOlNbP4gZBlfzbcZ1VQksNtgtz4uDv1M+
         sLi/UMVWvezH093M5DsgRVsj1JmghLYcU4mAW89BRmnoz0NuUY/ePiSu180MdTlEvorZ
         fCM7f4E//8eDySSjVReEAM3uIftKpyb3gaZqSdm8xkm7MBPp6EuGggrU4qOG7JxszFBc
         fQf3nYVEmeESZN2fD9aNLFJy1sOPAWHM1SOJdwt191xWMj6O5MhHiB95lcKsjkW+GrCl
         FzJlqG7thmdwhAmYbdDy9G3XUdgCkU1haE5AaWE8w8w6g1xDF+HGthxPaWQtDdOPMOUY
         TwiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOazBsLFgV0MgKm/pvqFQfF/nabLsPdBC5+wO1VwL5fMC6mF5nPlryXmvXbklOBPPofM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXZix+NrxJXHHe/GFS8qfbBL1cNERe/qiwoE9TM+XcHBcu4eKJ
	2PJA994XDqJT6zbvaZNDb1glurbrdCAa5r3pjyh3yalAnbDEknj1bJgHPks+05Y=
X-Gm-Gg: ASbGncvf8GkZsmx65RqLyji38mpWSQWods/XsjsSp4Ap2xe9iZ911HOZeXi1S0eJqWk
	6nof91m6PQ1ZoOKAi0X2Z6y2VfM2KX184khAzL3M9NVUDbO4KYwVT7xK7MHB8UWhSZvCLG9fvsH
	vvQbMi4HBMpXyUuOa5ZCj8dODd1YfGf+B6UN7zx685t05UAJCEQ5SsohwQr5bckZGj26CF5CjOF
	xC81LuVQoEpKTxvheHOl8eqeXFC8TPstd1z/Rq1/t0GPa8iqSjWfuj4fzPaHlSUoapgMjtWlvJO
	13XLdXk3jt2JHtInR05cQwYuT84/
X-Google-Smtp-Source: AGHT+IE+zm5bTYTXugTwpHU711moyOZkgKemcMPApk5i6Nyzgk504/702jQ6OsU4eVbUvVfR2YHglw==
X-Received: by 2002:a17:90b:4fd1:b0:2f9:e730:1601 with SMTP id 98e67ed59e1d1-2f9ff8a1befmr4045975a91.7.1738826623101;
        Wed, 05 Feb 2025 23:23:43 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:42 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:22 -0800
Subject: [PATCH v4 17/21] RISC-V: perf: Add legacy event encodings via
 sysfs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-17-835cfa88e3b1@rivosinc.com>
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
index bbf5bcff51fc..dd4627055e7a 100644
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
2.43.0


