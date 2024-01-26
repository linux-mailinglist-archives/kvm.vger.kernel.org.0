Return-Path: <kvm+bounces-7097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B0683D665
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16F7028D219
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B66D13BEA1;
	Fri, 26 Jan 2024 08:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A74LVPeU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB7213BE91;
	Fri, 26 Jan 2024 08:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259388; cv=none; b=DlMG9+2+Uz4mknqNrsAl+h/Z6f00PE7gXOFm7M3d+D6+WCaaxveZTKKVJ18NuZH4zRiLaa2ZoqjBiFLNSYeQxkCnRHBqBJBa9gB0uotBRzqWTDumwGbRJdIsqqO2zAOzTK+VnXFnL/TKMA4Hnmkb1wequ4agfSvG0ypdwZLPPF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259388; c=relaxed/simple;
	bh=6JnkGZdy3nkI3NJ2k4azjD0eBKOe9vEjIxkF53tkjTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=azczpXp+3lhrY3IqEVFK4nzGSGjgFvusjnu6mfnvPhQFlfTrgwDMN6MFFc3hk16ToMZdPpRA3uzFmfi3Bsa4gV4YtPZENY43cBUMBoQhqxc70l+7BoIEbwL4P1ydVl6KaHbQZgv2qf5kIvlcql2jmPaHifF//m4Azoqn6qHbuKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A74LVPeU; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259387; x=1737795387;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6JnkGZdy3nkI3NJ2k4azjD0eBKOe9vEjIxkF53tkjTo=;
  b=A74LVPeU2hf5WOYXVFnafad6FX3MeE6iAIXsmzA3FBzeMXQCdMjgeYVu
   nFNqVzVQI9nBLH5DYKRJ3v9UhSWt9X77PGbMmQZ3Qaby9NAY+4upcIrF4
   cdvrHOwC2TzFQ+R60A3US+cCbyA9yrSETzuFj0sBxsT9kaa985FPMrwVB
   g5cy6UT1y3+jVAeLhVn4YZnsW3msmo3jwFuLGPQy+GOvYVLqoHN1cpOyH
   JpjX/7PpbpCvR7VcHjT4RGgfi7BlHG7Vh3BYeehjYE58WHG65KCvNEfLB
   eMGNA9m4hr5UBXyE29CQn0d350DyxS5zqMoBVSA7Qz4MAzDpYef6qSCVM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792172"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792172"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930309979"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930309979"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:21 -0800
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
	xiong.y.zhang@linux.intel.com
Subject: [RFC PATCH 10/41] perf: core/x86: Plumb passthrough PMU capability from x86_pmu to x86_pmu_cap
Date: Fri, 26 Jan 2024 16:54:13 +0800
Message-Id: <20240126085444.324918-11-xiong.y.zhang@linux.intel.com>
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

From: Mingwei Zhang <mizhang@google.com>

Plumb passthrough PMU capability to x86_pmu_cap in order to let any kernel
entity such as KVM know that host PMU support passthrough PMU mode and has
the implementation.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/events/core.c            | 1 +
 arch/x86/events/intel/core.c      | 4 +++-
 arch/x86/events/perf_event.h      | 1 +
 arch/x86/include/asm/perf_event.h | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 20a5ccc641b9..d2b7aa5b7876 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -3026,6 +3026,7 @@ void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 	cap->events_mask	= (unsigned int)x86_pmu.events_maskl;
 	cap->events_mask_len	= x86_pmu.events_mask_len;
 	cap->pebs_ept		= x86_pmu.pebs_ept;
+	cap->passthrough	= !!(x86_pmu.flags & PMU_FL_PASSTHROUGH);
 }
 EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index cf790c37757a..727ee64bb566 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6140,8 +6140,10 @@ __init int intel_pmu_init(void)
 			pr_cont(" AnyThread deprecated, ");
 	}
 
-	if (version >= 4)
+	if (version >= 4) {
+		x86_pmu.flags |= PMU_FL_PASSTHROUGH;
 		x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_VPMU_PASSTHROUGH;
+	}
 
 	/*
 	 * Install the hw-cache-events table:
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 53dd5d495ba6..39c58a3f5a6b 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1012,6 +1012,7 @@ do {									\
 #define PMU_FL_INSTR_LATENCY	0x80 /* Support Instruction Latency in PEBS Memory Info Record */
 #define PMU_FL_MEM_LOADS_AUX	0x100 /* Require an auxiliary event for the complete memory info */
 #define PMU_FL_RETIRE_LATENCY	0x200 /* Support Retire Latency in PEBS */
+#define PMU_FL_PASSTHROUGH	0x400 /* Support passthrough mode */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 180d63ba2f46..400727b27634 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -254,6 +254,7 @@ struct x86_pmu_capability {
 	unsigned int	events_mask;
 	int		events_mask_len;
 	unsigned int	pebs_ept	:1;
+	unsigned int	passthrough	:1;
 };
 
 /*
-- 
2.34.1


