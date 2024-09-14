Return-Path: <kvm+bounces-26904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D762978EAA
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 801E91C22BE7
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53161CFEB1;
	Sat, 14 Sep 2024 07:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HbLDASi9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96261CF5D3;
	Sat, 14 Sep 2024 07:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297295; cv=none; b=RmMK/uzXZEG62xb3aqVhz9ZiOrRXLZAXCAxmcDKv+addZesg4zxkrX7Lq5DFe2qAEZQ2lHyeN6Ny4JUc0mk+B5yREGklJMP5fg6xkfIlguPSOn5iOLu8K0kmX0OWegyzWaWA9lUdwhthigrzpwxM5dZ1RRFlxoT7M4iyiy0UKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297295; c=relaxed/simple;
	bh=HHRh5QrD/XIq+0VTyI4BruluVOAwBpdXIhsspddwPeA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QusoTuYNPAZu/rnyn2Nqn2oEcIsUl2cyachBwV5mQC9ndbksc0VzznRzevS7GsUTnRsrREceyT2jqB39m8iIc/UyzFJYt2UWtU8RSmczzKK8Ikn+S1rATd96wBhXxBDa1dNvh/hQUPsYgCHwo+9td1oNpXdx0taBtxKrzmsGORQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HbLDASi9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297294; x=1757833294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HHRh5QrD/XIq+0VTyI4BruluVOAwBpdXIhsspddwPeA=;
  b=HbLDASi9JdZUysSmdOors95nKXJ0TaqZMI9j/QSSDx0ns/EXhnJzZ0Bi
   ljzm+KFpfOl5cYekguWS2RwkRFPdr2iVfIM22/i8uGmqtbfoSdwLQeJ/0
   rvOBik/bcFgGnzSE0BS6nBJ4NajAsImyecC9aolUHtxAcbhia3tDvS1RL
   qtlQraKBBxBXqISJI5OA4Zw4pz62cSjnI2fYSLi4oftyzzw6a3sYALfCc
   k4wAdSHHGtBZwX3wCOFrkT+T6GG8RJjyzM/wCsv3uPaUEQ8qvwvnbML86
   bMQSL2CYRkfGWt2JjKB222OSNL/d8Rqx/+wz35yJuTAPEyv85lALpYevS
   A==;
X-CSE-ConnectionGUID: zniMxSM5RoCltoOcxP+1og==
X-CSE-MsgGUID: IpZSdpbMTlyeyM7ZZ7Q9Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778800"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778800"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:33 -0700
X-CSE-ConnectionGUID: A2kgvwnSRmWhcNhwY0Tl7A==
X-CSE-MsgGUID: 2QCNGOqiTAuktfrbumHDOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950948"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:30 -0700
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
Subject: [kvm-unit-tests patch v6 09/18] x86: pmu: Use macro to replace hard-coded branches event index
Date: Sat, 14 Sep 2024 10:17:19 +0000
Message-Id: <20240914101728.33148-10-dapeng1.mi@linux.intel.com>
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

Currently the branches event index is a hard-coded number. User could
add new events and cause the branches event index changes in the future,
but don't notice the hard-coded event index and forget to update the
event index synchronously, then the issue comes.

Thus, replace the hard-coded index to a macro.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index e864ebc4..496ee877 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -50,6 +50,22 @@ struct pmu_event {
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
+/*
+ * Events index in intel_gp_events[], ensure consistent with
+ * intel_gp_events[].
+ */
+enum {
+	INTEL_BRANCHES_IDX	= 5,
+};
+
+/*
+ * Events index in amd_gp_events[], ensure consistent with
+ * amd_gp_events[].
+ */
+enum {
+	AMD_BRANCHES_IDX	= 2,
+};
+
 char *buf;
 
 static struct pmu_event *gp_events;
@@ -492,7 +508,8 @@ static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
-	unsigned int branch_idx = pmu.is_intel ? 5 : 2;
+	unsigned int branch_idx = pmu.is_intel ?
+				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
-- 
2.40.1


