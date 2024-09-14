Return-Path: <kvm+bounces-26902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB84A978EA6
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 794E6B261B3
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D371CF5FE;
	Sat, 14 Sep 2024 07:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IT5uE6qc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC941CF5D3;
	Sat, 14 Sep 2024 07:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297288; cv=none; b=RKuX1/CcHNNdtKgmUpVwMp+Im/G+1lK8HxxRHlZqlppsswylW0ya1u1AI9ukOrSkQNBRX/CWgDQlY6yTXx07WmgM5GUEh+X+51l0UwraKUTWQCxoq6F8Dt4s53dUTugxE0XiHea5XxOHKxHdK+qd2t+DlqdXjr8xpqBlykfrF7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297288; c=relaxed/simple;
	bh=BJe0sP/7dT483VAOgVBmKK7UewNMZdCxjtWZqHTYsi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gk+KNqx88jy6F3Rv+vHlGTcn3Stf3rDYTV5g8vW27c1TsRGwJXLLErdgjweqBw2JlBUZ+IoK5s56gev4krHt4DXGVm6i1hhMeLmjIs3qRwiYLMyMufF/e29E38o7PkvZ0KCbkZnLyDd9/NLv3uBt1lowARyZWpePTM97xu6nIDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IT5uE6qc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297287; x=1757833287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BJe0sP/7dT483VAOgVBmKK7UewNMZdCxjtWZqHTYsi4=;
  b=IT5uE6qcBD9M/c5ec9XgqAgPcVBW1AX4Dl+8n5yF4gVNA2qn+JDDxTaP
   wYugY5d338w1UeNhbSn2K2WeAVF7+cQZpXOZ9exiKU1cKpfCejb+H0UyM
   NDZQGxSX1GPJHf9dtj3VU4ML7z6G8l+I23ZxrvV0J7bt2mJ7ZGqRaRHpw
   dHg4c51LuHKZ9cLVGvDkbaxDF5hqk28j1CoKr/Cln4sX4piTHhH5mSoZN
   OY5ySC/iVVC0ZjluydQ/04QadmNELB9aJ4eZ0SwCltm5bXLFFabYa9rb6
   oif77RoMNzQobJCWM2y/cyzQxq5UmKPgunqsh3goXqEEpATYhYL3mIJNZ
   w==;
X-CSE-ConnectionGUID: sMbULrjoQo2lsvsqZbCrlw==
X-CSE-MsgGUID: 1DRj9rDJQMmqqjZ9CTQJKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778783"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778783"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:27 -0700
X-CSE-ConnectionGUID: GyduzjHJRaWo+z49O9c8jg==
X-CSE-MsgGUID: uGqwn+L7TWifZ2bNUWdgUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950921"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:24 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 07/18] x86: pmu: Fix potential out of bound access for fixed events
Date: Sat, 14 Sep 2024 10:17:17 +0000
Message-Id: <20240914101728.33148-8-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current PMU code doesn't check whether PMU fixed counter number is
larger than pre-defined fixed events. If so, it would cause memory
access out of range.

So limit validated fixed counters number to
MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events)) and print message
to warn that KUT/pmu tests need to be updated if fixed counters number
exceeds defined fixed events number.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 53bb7ec0..cc940a61 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -54,6 +54,7 @@ char *buf;
 
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
+static unsigned int fixed_counters_num;
 
 static inline void loop(void)
 {
@@ -113,8 +114,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 		for (i = 0; i < gp_events_size; i++)
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
-	} else
-		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
+	} else {
+		unsigned int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
+
+		if (idx < ARRAY_SIZE(fixed_events))
+			return &fixed_events[idx];
+	}
 
 	return (void*)0;
 }
@@ -204,8 +209,12 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
-	bool pass = count >= e->min && count <= e->max;
+	bool pass;
 
+	if (!e)
+		return false;
+
+	pass = count >= e->min && count <= e->max;
 	if (!pass)
 		printf("FAIL: %d <= %"PRId64" <= %d\n", e->min, count, e->max);
 
@@ -250,7 +259,7 @@ static void check_fixed_counters(void)
 	};
 	int i;
 
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < fixed_counters_num; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
@@ -271,7 +280,7 @@ static void check_counters_many(void)
 			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < fixed_counters_num; i++) {
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
 		n++;
@@ -419,7 +428,7 @@ static void check_rdpmc(void)
 		else
 			report(cnt.count == (u32)val, "fast-%d", i);
 	}
-	for (i = 0; i < pmu.nr_fixed_counters; i++) {
+	for (i = 0; i < fixed_counters_num; i++) {
 		uint64_t x = val & ((1ull << pmu.fixed_counter_width) - 1);
 		pmu_counter_t cnt = {
 			.ctr = MSR_CORE_PERF_FIXED_CTR0 + i,
@@ -744,6 +753,12 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
+	fixed_counters_num = MIN(pmu.nr_fixed_counters, ARRAY_SIZE(fixed_events));
+	if (pmu.nr_fixed_counters > ARRAY_SIZE(fixed_events))
+		report_info("Fixed counters number %d > defined fixed events %ld. "
+			    "Please update test case.", pmu.nr_fixed_counters,
+			    ARRAY_SIZE(fixed_events));
+
 	apic_write(APIC_LVTPC, PMI_VECTOR);
 
 	check_counters();
-- 
2.40.1


