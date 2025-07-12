Return-Path: <kvm+bounces-52449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D3300B05426
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39A527ADF09
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FE1275AE8;
	Tue, 15 Jul 2025 08:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TxFCpZwL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E9275863;
	Tue, 15 Jul 2025 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566881; cv=none; b=nJKd4sx5ffqcXJdFrZDnYlDNAi1vj3LMNa5vwiMpzzbNcAQOHxcwFnEhdj3/QXYzfkInfvq3I0z8BmrLL4ArkCZ4gYPhkMrN7Bes8YKgVHUSwi7eQppwyvGZ9b7xaJLx1ASZCJ7EkQcWpYtr7DdZv6Dn7crlRSpIJRf9H/A1pbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566881; c=relaxed/simple;
	bh=NXaK9A6F5geqHuLjSmTOtivGrEFJHLoLN+Ro7D+Sc8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Siz5Ey3bUYEqvlJiBhlzcjMo19ZxLponKjSYNEq5eTd/CvkS5S3TfP4/o1nETfMIgy/OjxiTGQ+VdXn7vG/x2Nee6EcPBdpKDjNISSjTijWDNATCvF2Ee3aD3Sm+Gxw24W1XFn1I7oIPGM9ue9KrWP8pKdJs49WEMaf21PxrqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TxFCpZwL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752566880; x=1784102880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NXaK9A6F5geqHuLjSmTOtivGrEFJHLoLN+Ro7D+Sc8s=;
  b=TxFCpZwLhjcXoHXUMvLzhL0SzDf5wVnlXErMPkbGKl/VnhYroegtiMVk
   fsTtqGShkz8jDUI3FmcJPEshYT0H7y2MUlpy1r8oqoIanVi04WdzxELHd
   BgG051WXZSVfCzMyZ9EyLkhUh29m65PDywK7nPIPWMFHo7JrcDhDCRvPN
   OYFLLb3sqDFuUkyACov7PiKLwGVxvH+YmMUA9d6Ysh7Qh/mJZiqoFiRqc
   ps/hvETt8g/2qYooLoYlp26K0JSOQDvFgtpakhFDpSq306+zIA2DhPLVw
   k7p9Xa6qZ0AOt+eBlEK54zQHofHuP+NN+2elCMX4lxPaZNqj8QixPWebR
   Q==;
X-CSE-ConnectionGUID: ncUmbUA2QmaobfI8TI7Fdw==
X-CSE-MsgGUID: J27uAH9PQNihKExa+YtbAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66135097"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="66135097"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 01:07:59 -0700
X-CSE-ConnectionGUID: Rp6jLuBHT+CRzAJ3VpvueQ==
X-CSE-MsgGUID: kDddVAQdQOSeDtDtwM8UwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="161471353"
Received: from emr.sh.intel.com ([10.112.229.56])
  by orviesa003.jf.intel.com with ESMTP; 15 Jul 2025 01:07:57 -0700
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
Subject: [PATCH 3/3] KVM: selftests: Relax branches event count check for event_filter test
Date: Sat, 12 Jul 2025 17:25:21 +0000
Message-ID: <20250712172522.187414-4-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250712172522.187414-1-dapeng1.mi@linux.intel.com>
References: <20250712172522.187414-1-dapeng1.mi@linux.intel.com>
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
2.43.0


