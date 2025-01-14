Return-Path: <kvm+bounces-35475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FD53A114D2
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40FF0162DA7
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1CF2288CE;
	Tue, 14 Jan 2025 22:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="gXctSMhm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17C0227B8B
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895530; cv=none; b=C9aTHtTGxKV9Pq40HG9lQ84evmVBxBq9QHfVPronKBaSLS0W/oNLfF94CO9zF7bugiq+BtoKLNAy7ykWWCwCZkakjJt8TBOXh8QYbSG/c9AQOMk2sX3kw/X/2zUecYxrP5ruEQy2E63GJC7Okb1kdwofq4gtuLUPdEGVr5ynRHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895530; c=relaxed/simple;
	bh=IonkNrSqnxTgqTe44xyZhAJLdqqmTStDra6vOLyGrKw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=vGdLQN9X5YlkJVIPP2H3mFlCxJx70+Sg5nFLW2iGzIgqpV54/nnjYfXuDG4S6ErvtfieqblcIlw/JdKY4K3xRIQme7lzjVwWW6cTAzuFRFnyLcMEx56QyJKL1Yz+DvINVcIPRR7t2Sd5cTgOh8yEdJ0Im7W1I0n5yROvyJRfQW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=gXctSMhm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2161eb95317so108568635ad.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895528; x=1737500328; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lFaqQYFa0i4Hi1540ZaNWub9sunz3Nl340tvz0aVjzo=;
        b=gXctSMhmMtCU5kClJE/0l886usgr53w8XT2HZQK7xjFbqeKLOnzKh2mvPnPSHrv/Cv
         PaLL4igwlcdoOg4eHNR5ZHt8avDNUBKOgBZuzuaHgCTfyz1+JBoJrYgM36YFtDHBbsXB
         0dNtJ0y/Jx08ecinbQiNAmwLZuKZEw2QHQ1ER++eQR50A4ZwNnSDLULslFmRlZW0i82b
         cwEWtGhFpMdUcpVz3xRbqUuRJ6XN+bvxxdT62QJzoBtHkgPUqM0xlIK+bIu84CziSBab
         6su7mCnfFhYa13JzfUdygvlT0lrKfVvAeiw0gA1WBMVVXCPJ/Fak4NNk+8AB4JFmqMgm
         1LiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895528; x=1737500328;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFaqQYFa0i4Hi1540ZaNWub9sunz3Nl340tvz0aVjzo=;
        b=XduCJDqTlSfGcekXuyuewczINGa4uZEnBi6VJTFNufbb9w0klx++jmyXoaoETy6mtG
         5dXO5B8bxJ92iYRJtvx0q+cr/ay2epflSEcUcmDmxg9aB06+rJnLiJwYZOFkCYRZJ/33
         R2vtS8WVQ/crS7qOOJbHsB/VPimqySU7ZGpkEdMIrIUr3OUa/lGLFoIEAOrBtLvc3IQL
         l2qneFg5Hn9UEFUcj9Fk34SRtdLGC3NlX17UUOyoKQSdtDrXApDrWIy2wi5ynyxceumM
         2GdNG4WuPPr+C8br1n03pr6SEkPPd8+yGAIrhYRpxs451CS0js9cUNstG7+9vZsmf2W2
         fiZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs8gW91a3QGyvlGXfEf+YYt/HprjIGtOzxIHgFiV3C7Lfvz0ZVQfP3QBppjD6FmNo7lKg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0GIBxkjrf28qS01pzy5w4g18Dlu2mrhf9iDznx4IUVDygMgYh
	5yY9and0RtwtcKjMen3HD4NhjdgCrasa5bfzRF7EhxOv6wn3U+0xIZifOkK4m9M=
X-Gm-Gg: ASbGncv9HW2g1JCgdwwd7NiGq5gEZHqw86tkTRAAqObTWDlBlei+NLbrpdC506q+rWZ
	ccfjF4F9TFuMZW0a0VJ0YZ6k+N1096MzSufE6Z0Mox+Zt5xGPBU5BWdTU5uP/AhpyyIDPclp+Zu
	Nk/vzkmYn/+6T7fM/keHZd/9MVMCjkrCPeSLdmGJ4vz8o9pYpUQsqSBFBJsoXxudTkKQS1OR6XE
	xOXqNgrZrcDpeY2/DVstTOu2Q1lwxsMzAMG7qJvEVsyKtgO9EUsnKGNCHuZBkAoFxfxJg==
X-Google-Smtp-Source: AGHT+IHCQ6qV+IZREHZOksM8g070R45gqC24v2Ey2b78fnINPv3h7b/5YKzuEF3OHMLV4KVWpbWi3w==
X-Received: by 2002:a17:902:c941:b0:216:7cbf:951f with SMTP id d9443c01a7336-21a83f4f096mr419065225ad.21.1736895528131;
        Tue, 14 Jan 2025 14:58:48 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:47 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:42 -0800
Subject: [PATCH v2 17/21] RISC-V: perf: Add legacy event encodings via
 sysfs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-17-8ba74cdb851b@rivosinc.com>
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
index 8c5e2474fb7d..8c5598253af0 100644
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


