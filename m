Return-Path: <kvm+bounces-52456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC59B054F4
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5BBF5611C6
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84482D1913;
	Tue, 15 Jul 2025 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8YMoN3r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933BB1D5ABA;
	Tue, 15 Jul 2025 08:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568316; cv=none; b=J+V6lvLmReSc7OHy8Lr7vr/TNYmh3x9tZd/ckR+zgkBLvcbFA+JoodLtY3+jWiYi72BNI2mMcvOOJoiZks52AkANST+++QLKsjhSrk+lXdEtLpMPiUJAHE3+RHjc7/6991ba3N2Qw3ESarQxPYWk+eVDxNSnmwMBgPDx/WJ1cM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568316; c=relaxed/simple;
	bh=otRui1TH2BOwfKusebCPTj5GNnPhV33tMxV5ZCAavYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6ZvBPBmkc6MuRwWRljLdi+1GX8awUhJ6JSwJyRvOH9TvdpXEjQ1nzGdkSjZpbNsSeF3AJ5mpep8xwN7HthR1fwhpl7Fy37OKm1kuidUy1NedlXIxzxvAMA9OH+Ja04g7LaMs6CRqFIZxXk8z2OX2Udz6XnGgs0afH5RQik20hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8YMoN3r; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752568315; x=1784104315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=otRui1TH2BOwfKusebCPTj5GNnPhV33tMxV5ZCAavYc=;
  b=b8YMoN3rR6jmPDNswRcJBd3gng1UZZDXCAb5Ys4hckO5kH0mPG9lpezB
   Y6d7LwF+uiVXd000CcZ+p9DlSLRZOhhk3yw5545enUqbJ3yatOdO1Ole6
   lmkr+QOz0fWmkX/2oYcBdM/RykGGxCrBwpP68Gcexbp75qtWxFqyfp70m
   +uceIU4B41MI1gmx+AS6cy0hZsC0As8DlRoy/o9AlTNq+G0DyHF9SHbrK
   bHv7GENQSXZTS/lYlnyIXqh2hlZ1FzSLFvjoO+TNbPen7+8QyGdJM5T2b
   sMEqavAPV5sU/axjXceaJOMTjoOhuk9NEBUDoghrxM8mRRPLellKJ9ky3
   w==;
X-CSE-ConnectionGUID: wbENkD8LS32eWNHnlbs/fw==
X-CSE-MsgGUID: xIFlVgp3Qn6+6JDI9qExJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54632096"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54632096"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:31:48 -0700
X-CSE-ConnectionGUID: Rx2ZMBYdTNu59D0IW2jJUQ==
X-CSE-MsgGUID: yVPJKVXBRBa5/IimkzvJgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156572579"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa010.jf.intel.com with ESMTP; 15 Jul 2025 01:31:44 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch 2/5] x86/pmu: Relax precise count validation for Intel overcounted platforms
Date: Sat, 12 Jul 2025 17:49:12 +0000
Message-ID: <20250712174915.196103-3-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
References: <20250712174915.196103-1-dapeng1.mi@linux.intel.com>
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
2.43.0


