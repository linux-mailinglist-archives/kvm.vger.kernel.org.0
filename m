Return-Path: <kvm+bounces-26905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28595978EAC
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B1261C2568E
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3B31CFEDD;
	Sat, 14 Sep 2024 07:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A8O3ZyLj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2421C1CDFCC;
	Sat, 14 Sep 2024 07:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297298; cv=none; b=Z2WdXJYycJ0W2J9mJbv78dJouSHFe1SpCV32lFU4/JpFmZio3tQr0fxTDBnOqlDncnR5Dhwun7USbL8iBDcH6UeHoogy7Pdn6+eIA8R2991jIfvwZ6aaqLTMaZXdK1Bxs53RAPmF6/z3Ug8OVDFNqSXgPAM+b/tprSzzkVLSlAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297298; c=relaxed/simple;
	bh=CLw+sFB+mUF6gzDPRFjmd//aq+LgNnbUGCAlWCZahBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SifRI84gyhvsVHATNfEz1GSNVX8qtuvmnV6UEOI8XNaeKO4dHM1XbOJLiarsvli4MTD0dnw6pfQplLt95zcwIOQNmmXrqV2pUPtIT/MVJzShiQHUibLrj/2JolofUg8QjIcReHhoTO6iGVflrsIZagrEUAXVbelah6t+bS8FoUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A8O3ZyLj; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297297; x=1757833297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLw+sFB+mUF6gzDPRFjmd//aq+LgNnbUGCAlWCZahBA=;
  b=A8O3ZyLjEEaSUaUrJtUcAezf5IBDyVhJxfZvQRE96ZOkRTx25Jf2XWU0
   395gVLwu+xU1kHqd0OJ1Ojxp/7cGdGtheU2V/UzXBFPA3YzVeTUtGRhJx
   IKggtuXfd8+GL98Pb8xJhM2U7qXUl6fmqe4z9oHY5cbGvdd5Iw7teB6Bs
   ahzhaO00/YqWb5gwhtIIRvO2iolaDZsmZGneUq7qb2PVrP5FTxKEkuthS
   +9sIVTisWEYRZV7OFnLQx1hg1cvoNlN/FPeZwpVz4HtGKm6cSeohYaOKr
   Xy/CItYyR/8YPPaA4YYmnkyA9eVc+AaIDkgZAk97UPDRjlMIHrxd/gt81
   w==;
X-CSE-ConnectionGUID: QH27+pHNTMu84KhbELDVPg==
X-CSE-MsgGUID: GTiORYDYQZqtdcKP6wiTaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778809"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778809"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:37 -0700
X-CSE-ConnectionGUID: P+hXxCiZRwaNuP8x5jfJjg==
X-CSE-MsgGUID: yj00ZIYKT8KJdLSijc0e8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67950959"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:33 -0700
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
Subject: [kvm-unit-tests patch v6 10/18] x86: pmu: Use macro to replace hard-coded ref-cycles event index
Date: Sat, 14 Sep 2024 10:17:20 +0000
Message-Id: <20240914101728.33148-11-dapeng1.mi@linux.intel.com>
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

Replace hard-coded ref-cycles event index with macro to avoid possible
mismatch issue if new event is added in the future and cause ref-cycles
event index changed, but forget to update the hard-coded ref-cycles
event index.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 496ee877..523369b2 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -55,6 +55,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -708,7 +709,8 @@ static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  intel_gp_events[INTEL_REF_CYCLES_IDX].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
@@ -744,8 +746,10 @@ static void set_ref_cycle_expectations(void)
 	if (!tsc_delta)
 		return;
 
-	intel_gp_events[2].min = (intel_gp_events[2].min * cnt.count) / tsc_delta;
-	intel_gp_events[2].max = (intel_gp_events[2].max * cnt.count) / tsc_delta;
+	intel_gp_events[INTEL_REF_CYCLES_IDX].min =
+		(intel_gp_events[INTEL_REF_CYCLES_IDX].min * cnt.count) / tsc_delta;
+	intel_gp_events[INTEL_REF_CYCLES_IDX].max =
+		(intel_gp_events[INTEL_REF_CYCLES_IDX].max * cnt.count) / tsc_delta;
 }
 
 static void check_invalid_rdpmc_gp(void)
-- 
2.40.1


