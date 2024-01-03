Return-Path: <kvm+bounces-5493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC4582276A
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E97701C22D25
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B23A18644;
	Wed,  3 Jan 2024 03:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lTK7QezD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97FF182DD;
	Wed,  3 Jan 2024 03:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251381; x=1735787381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZTgziGb6S+JjPB/4NsS2emVW8oxagsATmMkk72RlKZU=;
  b=lTK7QezDnVYzUoi2x6HC5fc5GGc7Br8ncihslZTP+uABlNp+2UPF+9D8
   Cu2b5/pHVxuW1j57diNjKvwuxL69rOlYokdVs9dNOz09FZkkjkXN4Vscv
   MJ5bCCTeWn+pk103h3HgeQb7H+JxZL406RxDSR/L3QG1+bWDBEKQUlr7v
   w7FRo3TNRcEXzxDRyzsx5sqTFNEuJx4LUfedjlq7hEDw2dFTi3wTsgdxX
   cRcE6j5lQ+RnkSJTixCLrxySrQygodUkNsAXZUDxbxH0/59pZlMBVl+sY
   GTCEPKY0JwFD+czIZ8RTXwXo9EDli1jMWqQFczIG5yRcOBSPN3y71Etde
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343131"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343131"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:09:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665930"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665930"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:37 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 03/11] x86: pmu: Add asserts to warn inconsistent fixed events and counters
Date: Wed,  3 Jan 2024 11:14:01 +0800
Message-Id: <20240103031409.2504051-4-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current PMU code deosn't check whether PMU fixed counter number is
larger than pre-defined fixed events. If so, it would cause memory
access out of range.

So add assert to warn this invalid case.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a13b8a8398c6..a42fff8d8b36 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -111,8 +111,12 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
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
@@ -245,6 +249,7 @@ static void check_fixed_counters(void)
 	};
 	int i;
 
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
 		measure_one(&cnt);
@@ -266,6 +271,7 @@ static void check_counters_many(void)
 			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
+	assert(pmu.nr_fixed_counters <= ARRAY_SIZE(fixed_events));
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
 		cnt[n].ctr = fixed_events[i].unit_sel;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR;
-- 
2.34.1


