Return-Path: <kvm+bounces-174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4157DC959
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:22:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19AF91C20B64
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A600D199DB;
	Tue, 31 Oct 2023 09:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KNM+3pQn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04438199A9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:22:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16ACB7;
	Tue, 31 Oct 2023 02:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698744121; x=1730280121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PuCRcyvXo/0paorC4geEOaVKWI0b7CqKhedXiIXoy0A=;
  b=KNM+3pQnGpmUUNQuHOdJcxhEJDaYVJgfWRz9AWWnmosWzV4A0ehXWcI/
   lTcQ7n0+M5pnMKJBkf7mAKGCvzPElMZkNpf5A9oZyhQsxywtri3MP8CXR
   k+90mWDkWu3TC4irj/W8bzCV+I2k/DHt5GPwcdHwI79hTSZAfusPp/HyN
   PW/VWy8IGJjj6uj0A3mLEhTsllOP8qkA/F5oCa4zIVLB4aeMhtaNtTJMv
   ER38hCNC5tuW4J9Vl35gLh/DUYqMexeTcluHlsSHkjBrOuOgz7f7D9ZQX
   u5wKjKuiKo+1MBhBytx85ub/awqH/MP194ZIgD+flMns1Ibf4ouBRS9Rl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="385435997"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="385435997"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 02:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="877445536"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="877445536"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga002.fm.intel.com with ESMTP; 31 Oct 2023 02:21:58 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v2 5/5] x86: pmu: Add asserts to warn inconsistent fixed events and counters
Date: Tue, 31 Oct 2023 17:29:21 +0800
Message-Id: <20231031092921.2885109-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current PMU code doesn't check whether the number of fixed counters is
larger than pre-defined fixed events. If so, it would cause out of range
memory access.

So add asserts to warn this invalid case.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 404dc7b62ac2..3ce05f0a1d38 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -117,8 +117,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 		for (i = 0; i < gp_events_size; i++)
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
-	} else
-		return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CTR0];
+	} else {
+		int idx = cnt->ctr - MSR_CORE_PERF_FIXED_CTR0;
+
+		assert(idx < ARRAY_SIZE(fixed_events));
+		return &fixed_events[idx];
+	}
 
 	return (void*)0;
 }
@@ -251,6 +255,7 @@ static void check_fixed_counters(void)
 	};
 	int i;
 
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
@@ -272,6 +277,7 @@ static void check_counters_many(void)
 			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
-- 
2.34.1


