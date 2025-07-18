Return-Path: <kvm+bounces-52819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F66B098E8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 02:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 276D41C483C8
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 00:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE8672613;
	Fri, 18 Jul 2025 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gn6N8jkT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6C3433AD;
	Fri, 18 Jul 2025 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752798012; cv=none; b=UKHjsBofQHJNEGrWNSf9j/STcSNP8AP0kXK624dtnxfWOXpZ3jAzr6Zph7/8j78fbgsMUaH9Zrn7niAd8vCtyEDAQ3izbstuv3a1+6TmESXTomQ46zbGSkKXH9WKc4t2fT3efac04qlP4JuLhk9kx8GEFNuwmMuVk0gSB20vLIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752798012; c=relaxed/simple;
	bh=n9KSM5nD7tPQVXKTSrlwb1RAUzG93qtZMdGhDgq1KeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CQ1KE4UE3Jdb7ROVy/tfU8mZaY/mbn9bn1p8+WUHAuf3ALKnsrpPi1S3hgAGoMZ9uuq4I61+2zlAMZCijjpEllyhd5XU/SyNJCRoJH3DyybpRWeCo76O5eysvb5wxkgi9Rk0tB0FMRuapY2gb0qxVVmg3LjiLmGSy2TT6ngBbbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gn6N8jkT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752798011; x=1784334011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n9KSM5nD7tPQVXKTSrlwb1RAUzG93qtZMdGhDgq1KeQ=;
  b=Gn6N8jkTeo53hCxrhgPT7t74zepYTCvUm1FJs85j//W2asuWRyupII+X
   YMYJiDsrR1eKEmUkFosKhvocC/nTAPx/kqgepW6ZxkwGGEJN4UhkEpRta
   TvFbZ0GOz9O0aCoDBSAYtwb5vLGdPVtz7QbChruxI6GReRwvJIO/GpVl+
   f2FixYtTK9GBURQ2gL2UFq3BGZAZeeVs2r8HA16QD24F17yPux6P+9/CM
   cYkwSinHn3dhMxhG7JrqUwfmzz54v3X5yFxD/x77sLdG0tG5nasFQJszY
   uLm3WphjdrQhBX8hzMAmywOOCHtmS3zq0MkQImwHXGX0j3fH1y3xLrmgV
   Q==;
X-CSE-ConnectionGUID: lZfDu0kTSp2LB8aq292Dfw==
X-CSE-MsgGUID: u8xfkDDWRfuFoe27aYuJ+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="65780139"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="65780139"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 17:20:11 -0700
X-CSE-ConnectionGUID: KUZQIL5PQBCANVUJzO9Y8g==
X-CSE-MsgGUID: 2cNKqIsPR3u5o6QWOEsFhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="157322908"
Received: from spr.sh.intel.com ([10.112.229.196])
  by orviesa010.jf.intel.com with ESMTP; 17 Jul 2025 17:20:07 -0700
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
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2 5/5] KVM: selftests: Relax branches event count check for event_filter test
Date: Fri, 18 Jul 2025 08:19:05 +0800
Message-Id: <20250718001905.196989-6-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
References: <20250718001905.196989-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the branches event overcount issue on Atom platforms, once there are
VM-Exits triggered (external interrupts) in the guest loop, the measured
branch event count could be larger than NUM_BRANCHES, this would lead to
the pmu_event_filter_test print warning to info the measured branches
event count is mismatched with expected number (NUM_BRANCHES).

To eliminate this warning, relax the branches event count check on the
Atom platform which have the branches event overcount issue.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 tools/testing/selftests/kvm/x86/pmu_event_filter_test.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
index c15513cd74d1..9c1a92f05786 100644
--- a/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_event_filter_test.c
@@ -60,6 +60,8 @@ struct {
 	uint64_t instructions_retired;
 } pmc_results;
 
+static uint8_t inst_overcount_flags;
+
 /*
  * If we encounter a #GP during the guest PMU sanity check, then the guest
  * PMU is not functional. Inform the hypervisor via GUEST_SYNC(0).
@@ -214,8 +216,10 @@ static void remove_event(struct __kvm_pmu_event_filter *f, uint64_t event)
 do {											\
 	uint64_t br = pmc_results.branches_retired;					\
 	uint64_t ir = pmc_results.instructions_retired;					\
+	bool br_matched = inst_overcount_flags & BR_RETIRED_OVERCOUNT ?			\
+			  br >= NUM_BRANCHES : br == NUM_BRANCHES;			\
 											\
-	if (br && br != NUM_BRANCHES)							\
+	if (br && !br_matched)								\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
 			__func__, br, NUM_BRANCHES);					\
 	TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",		\
@@ -850,6 +854,9 @@ int main(int argc, char *argv[])
 	if (use_amd_pmu())
 		test_amd_deny_list(vcpu);
 
+	if (use_intel_pmu())
+		inst_overcount_flags = detect_inst_overcount_flags();
+
 	test_without_filter(vcpu);
 	test_member_deny_list(vcpu);
 	test_member_allow_list(vcpu);
-- 
2.34.1


