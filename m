Return-Path: <kvm+bounces-15199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4438AA776
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CF0A1C2451C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513847E59A;
	Fri, 19 Apr 2024 03:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V4Fq1mZ6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499B47E103;
	Fri, 19 Apr 2024 03:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498376; cv=none; b=I8jmLbYBCErlX5KXrTdyR0hkhuvjO4Qw70tu/N10QWi98dPif3k2MGlX5R4OSEKRz91boQWS1QJmSrkqs/k/nQIWwkxCKLl+Igct+A8qzjQlzUhwqITKRTSJXvB8sOUmUD2ZWbapxVu1+LVgqnHDzeeLYLABB0OI506w0O+vGh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498376; c=relaxed/simple;
	bh=cEod3+83Wa+vP4Dtlze3LzHehXl/2U9UGWLeIZ52yNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C+EOjfY/I0GiGlx03NVxgChYaigCkiMNPc3lVnOA8xTAC0PU9ULJyWskjN1/06nactVk9pklEe39gFA5Po9RsQS/HxHFJsj4Ecxn3ULUBRCW/nv+P7ugZoUQcMwvEmq+OaQJKluL7GAUkhmHLsCOu3AtIA2MlOyadowcHuYObHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V4Fq1mZ6; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498375; x=1745034375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cEod3+83Wa+vP4Dtlze3LzHehXl/2U9UGWLeIZ52yNQ=;
  b=V4Fq1mZ6wkcLzs1e9rX2PM70Pf7uS6D9AIgTYvZZ8b3hbnmazM7P6j+T
   dB3vToasmXXgaw34f1lb2k1jZ7h8aQItVMy/Lx7iYWNNvtqc7GrXo2479
   3Bba0cyrFKmnBJ3rksZyyOyxEBGhwj1eW4IX6F6qEmnY5B/HHPQbRDwZn
   4uJ3O/LhB284TIddUrmVkyo4xGsrXB52pkKFVyqNth4bR8TcGszVN1rYc
   KXpIpZi+tZIJoktoWjY6m/7NiXle0pqYJqGHZmHOTbAPvfUIRGeIK39q1
   DABoAmpXaf0At57KgEIRoGFmyuWAINBrZL0+cyHWGlmSa4p4uik08/Yg2
   A==;
X-CSE-ConnectionGUID: tUYQ2KyyTz+jHZ/PU1mf5A==
X-CSE-MsgGUID: v21ZTCm/SXi5gKH4cpdOoA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565501"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565501"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:15 -0700
X-CSE-ConnectionGUID: 5GtYuA+0ROGNMihn9IToDw==
X-CSE-MsgGUID: zO/LMXMtSyWnoNlWDngTpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410299"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:12 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 14/17] x86: pmu: Adjust lower boundary of llc-misses event to 0 for legacy CPUs
Date: Fri, 19 Apr 2024 11:52:30 +0800
Message-Id: <20240419035233.3837621-15-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For these legacy Intel CPUs without clflush/clflushopt support, there is
on way to force to trigger a LLC miss and the measured llc misses is
possible to be 0. Thus adjust the lower boundary of llc-misses event to
0 to avoid possible false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/pmu.c b/x86/pmu.c
index fcae60d33966..adc7e6c640c1 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -81,6 +81,7 @@ struct pmu_event {
 enum {
 	INTEL_INSTRUCTIONS_IDX  = 1,
 	INTEL_REF_CYCLES_IDX	= 2,
+	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -875,6 +876,15 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+
+		/*
+		 * For legacy Intel CPUS without clflush/clflushopt support,
+		 * there is no way to force to trigger a LLC miss, thus set
+		 * the minimum value to 0 to avoid false positives.
+		 */
+		if (!this_cpu_has(X86_FEATURE_CLFLUSH))
+			gp_events[INTEL_LLC_MISSES_IDX].min = 0;
+
 		report_prefix_push("Intel");
 		set_ref_cycle_expectations();
 	} else {
-- 
2.34.1


