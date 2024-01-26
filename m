Return-Path: <kvm+bounces-7088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2C1783D64F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E67841C26FA1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0122374C;
	Fri, 26 Jan 2024 08:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJU5vNT/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8324B22EE3;
	Fri, 26 Jan 2024 08:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259341; cv=none; b=t6eLtmOhEGCZq8jJ50tSF9Xsnp5pVPDwoO/n91QYXARy0NGbm77AU307jjIJ9BU4uSbdVQQEE1IeVlJ17fTHGhl5p8RzrYAWs0wUs+qeAUpT6A/w4JF+Q5VzpUL1tnMvD01acwuXEezas+FklPrlrdN5pBSUwHusF7jd6W4lNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259341; c=relaxed/simple;
	bh=1r9bMkN+DuC7eFrI9IMK6ih6tNqjKLC/zGVRio9Us8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nW2V9evEm99t9YYdoiLbJnmUmVnaTP0Bpqyg98BKsY/6/b3YeJDOJSyvpGjZsw8Dd7uvuk4GbJRMTDT0Dyv7f7wXGjwAvp20dAnySXN+m0ZPPJ/tI+HXfhVShaSs/d4UucuRBo0/yiXPVN/Q0DCKpdjlBFXIxRjSAG2297oK9s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJU5vNT/; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259340; x=1737795340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1r9bMkN+DuC7eFrI9IMK6ih6tNqjKLC/zGVRio9Us8k=;
  b=SJU5vNT/x77p5DRNOlDKjAC3KeBXzPzWnNIfUlA0LvFY9bdqCs7t+oNS
   v5o6ixc8vZ1hI2V8xXYojfKu5wyv1KK/QYOugUV4x90mjOIgVn/E8sv9Z
   iAJLYipnD64TtHjJCNCkR7uUW/dfm7szllrdrOtMLtlqFk9WI7hZbQ/gL
   KyijfmySl1RSFs5GZlZ1CmyXvJ97yExfwP8wwZ/c3J2rRQxHjOD/DcHUh
   B2z10NlWN67qF1QB1nh21EzzZMgQZIhEy1hAzgBK3F8s7p+0INMnsLNiM
   ywijPjJuYCi5sAMdRWrz68j2KMzJOjhX+1w3YaSq0N/jG+fIUpQKHEu8W
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792030"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792030"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309778"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309778"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:55:34 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [RFC PATCH 01/41] perf: x86/intel: Support PERF_PMU_CAP_VPMU_PASSTHROUGH
Date: Fri, 26 Jan 2024 16:54:04 +0800
Message-Id: <20240126085444.324918-2-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kan Liang <kan.liang@linux.intel.com>

Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the version 4
and later PMUs, which includes the improvements for virtualization.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/intel/core.c | 6 ++++++
 include/linux/perf_event.h   | 1 +
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a08f794a0e79..cf790c37757a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4662,6 +4662,9 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 	else
 		pmu->pmu.capabilities |= ~PERF_PMU_CAP_AUX_OUTPUT;
 
+	if (x86_pmu.version >= 4)
+		pmu->pmu.capabilities |= PERF_PMU_CAP_VPMU_PASSTHROUGH;
+
 	intel_pmu_check_event_constraints(pmu->event_constraints,
 					  pmu->num_counters,
 					  pmu->num_counters_fixed,
@@ -6137,6 +6140,9 @@ __init int intel_pmu_init(void)
 			pr_cont(" AnyThread deprecated, ");
 	}
 
+	if (version >= 4)
+		x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_VPMU_PASSTHROUGH;
+
 	/*
 	 * Install the hw-cache-events table:
 	 */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index afb028c54f33..60eff413dbba 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -291,6 +291,7 @@ struct perf_event_pmu_context;
 #define PERF_PMU_CAP_NO_EXCLUDE			0x0040
 #define PERF_PMU_CAP_AUX_OUTPUT			0x0080
 #define PERF_PMU_CAP_EXTENDED_HW_TYPE		0x0100
+#define PERF_PMU_CAP_VPMU_PASSTHROUGH		0x0200
 
 struct perf_output_handle;
 
-- 
2.34.1


