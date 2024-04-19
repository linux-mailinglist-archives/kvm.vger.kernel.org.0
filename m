Return-Path: <kvm+bounces-15194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3551D8AA76A
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B8FCAB23718
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1A5C2D6;
	Fri, 19 Apr 2024 03:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJcrAJl/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAAC3E485;
	Fri, 19 Apr 2024 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498361; cv=none; b=pSUvwHLeNooNqihy7B0g+xkpBDh+DATl7hyJkfPd5Xp1aAX0qU77i+fPIx+tN0SwRQkwS3IZK/livNNo4li5TArPdpoNrNtGL8nxfHfgzheTyJjB9jHpSGSkwQAxUlkZWr9iFoCO+PpPdrq1qGtkfO7nyqPdcSvWlU49Iep3LhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498361; c=relaxed/simple;
	bh=5/QEb1aKZvreLoUXtF0uNhYLsiRGyvEfapJ7il+jZgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=INtOocGN7P+Q5gJbGg9tADbXCBXfnUGQaErdIhFYjEMBDT4dEmzDpOx5F+IH3oG788Cvi+VFZtAP2w175Ec7zdYKW0B+xtDs3t3tjj1pXFqWMSx159uNUWxOJrbxdM28zCvbV4IUApsSitTBu/Mn9tNBjlJhEoCj674exVosNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJcrAJl/; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498360; x=1745034360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5/QEb1aKZvreLoUXtF0uNhYLsiRGyvEfapJ7il+jZgM=;
  b=OJcrAJl/n9RN5vX+2KhRr6pe09D6MWR2oJqmgACAEFksvcfZoiBdZtMa
   wfx4X4j3NYZSLXwXr+osbtYNYA8gD03+zIip5qIbqtm9XKYMwlpA8Uk5o
   twJ3Lvfniju74P95bvDK/k3Bbrs9UxODYGYKALny/A9R8v3ijmX2guiZ/
   Otu8+oIj55ZoJy7mFJYjtKO9t+LKv2JqCuHyYujOVjmdH5kO4hTa9V6kr
   3Z7UdQCYajFdUDLODt99AEMzXzNtF1MZppsae3SZAm3qrKTB2AOtixft+
   Jc6V2Mvrfb5xwV2jyEY1vF5ZIn79i9TcnrejJH6QJH31G8U3JtF9yB33y
   Q==;
X-CSE-ConnectionGUID: 7SByHVvVQr2GgV0z14Yhzg==
X-CSE-MsgGUID: fdvePZ+nRHqBS+EA2jsSjQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565463"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565463"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:00 -0700
X-CSE-ConnectionGUID: wtrIdJe7TvmMzrRFSpU+JQ==
X-CSE-MsgGUID: xj6HBejRTIKIRZ4yRuSWcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410183"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:45:57 -0700
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
Subject: [kvm-unit-tests Patch v4 09/17] x86: pmu: Use macro to replace hard-coded ref-cycles event index
Date: Fri, 19 Apr 2024 11:52:25 +0800
Message-Id: <20240419035233.3837621-10-dapeng1.mi@linux.intel.com>
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

Replace hard-coded ref-cycles event index with macro to avoid possible
mismatch issue if new event is added in the future and cause ref-cycles
event index changed, but forget to update the hard-coded ref-cycles
event index.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index fd1b22104fc4..6ae46398d84b 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -54,6 +54,7 @@ struct pmu_event {
  * intel_gp_events[].
  */
 enum {
+	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_BRANCHES_IDX	= 5,
 };
 
@@ -697,7 +698,8 @@ static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR |
+			  intel_gp_events[INTEL_REF_CYCLES_IDX].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
@@ -733,8 +735,10 @@ static void set_ref_cycle_expectations(void)
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
2.34.1


