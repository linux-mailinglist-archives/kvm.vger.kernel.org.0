Return-Path: <kvm+bounces-52822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 053EEB0994B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48E961777B9
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5441BD9CE;
	Fri, 18 Jul 2025 01:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c84ymaA+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D5D1A5BBC;
	Fri, 18 Jul 2025 01:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802804; cv=none; b=C07jvr3XM4Wl6256FU3N4o1Ez/kGzcoJ83AGzGRWuWpjmey8twA/bLDTBRvsynobZDBiHzcKI1HdnWA0PZL9kHE+vP+Ib+nhwq26d5PZF7ibtS7PdfMjrQoJY2JA1pz/zzOGGMC0HT6P64xYznu8yHWkJfJ30YxaaNuNU4nHpsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802804; c=relaxed/simple;
	bh=6eRvm9cZzbpKgdE4GQTdQUwYkONs6b4GJehdP1EioZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eAOPS3dIW4v5DR/3ng5yVxHzQZSwQhnZB3mvsxfmlfBUF5eAg6CrYvPJg5knTW43cMokdpEeYj3AY0Y1HVirUsR82freGmGDdeY12SA+/7ISCOUfTxugnrf2WDPBrwR2rt7jnp0DKS6n7gc1e9cgYmThtSs4MRIc0Sti5Zzvj1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c84ymaA+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752802803; x=1784338803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6eRvm9cZzbpKgdE4GQTdQUwYkONs6b4GJehdP1EioZo=;
  b=c84ymaA+3UqNwM5d0nPtmZttD7GKHuvXBm05HG4bZLN6fETHkzGvczWw
   9HGRswLigPkkNK9L4hsVfsT0nq99aB3ak0MCvTUhhQW507TNL2STrHcea
   kgNV9Nq71BvK9t5Ss7afX3SRk6zL/B/LUsmTOOvQ8VljlUN57IHXr4+PN
   7bZb5CKWKLAc1t47uLsLB0i7s/V+Eb7IkphQ+v3b76WBqqevqaawQBT5E
   SHA+CQn87tEXoqiq8YVvqBmFgE6RRai8/MqKleYAdEf0YW+tOxHkVM7pl
   K4MJm7tFdl3txovSOxr0/iEZZRkv8Xqrmn/AjINjrn/mD8re+LEUBt4O5
   A==;
X-CSE-ConnectionGUID: fakO45F6TnWngRsB+1YFxQ==
X-CSE-MsgGUID: rnAGqcEYTFSdBHfHR6JeBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54951447"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54951447"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 18:40:03 -0700
X-CSE-ConnectionGUID: ahKir1S+SNGcYgdo8tJxOg==
X-CSE-MsgGUID: r6CrRDDBTwqLxEM0c7lE+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188918361"
Received: from spr.sh.intel.com ([10.112.229.196])
  by fmviesa001.fm.intel.com with ESMTP; 17 Jul 2025 18:39:59 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Yi Lai <yi1.lai@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v2 2/7] x86/pmu: Relax precise count validation for Intel overcounted platforms
Date: Fri, 18 Jul 2025 09:39:10 +0800
Message-Id: <20250718013915.227452-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
References: <20250718013915.227452-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

As the VM-Exit/VM-Entry overcount issue on Intel Atom platforms,
there is no way to validate the precise count for "instructions" and
"branches" events on these overcounted Atom platforms. Thus relax the
precise count validation on these overcounted platforms.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 87365aff..04946d10 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -237,10 +237,15 @@ static void adjust_events_range(struct pmu_event *gp_events,
 	 * occur while running the measured code, e.g. if the host takes IRQs.
 	 */
 	if (pmu.is_intel && this_cpu_has_perf_global_ctrl()) {
-		gp_events[instruction_idx].min = LOOP_INSNS;
-		gp_events[instruction_idx].max = LOOP_INSNS;
-		gp_events[branch_idx].min = LOOP_BRANCHES;
-		gp_events[branch_idx].max = LOOP_BRANCHES;
+		if (!(intel_inst_overcount_flags & INST_RETIRED_OVERCOUNT)) {
+			gp_events[instruction_idx].min = LOOP_INSNS;
+			gp_events[instruction_idx].max = LOOP_INSNS;
+		}
+
+		if (!(intel_inst_overcount_flags & BR_RETIRED_OVERCOUNT)) {
+			gp_events[branch_idx].min = LOOP_BRANCHES;
+			gp_events[branch_idx].max = LOOP_BRANCHES;
+		}
 	}
 
 	/*
-- 
2.34.1


