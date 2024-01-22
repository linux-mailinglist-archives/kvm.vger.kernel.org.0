Return-Path: <kvm+bounces-6512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EC1835B25
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 07:41:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80CA2286C20
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 06:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559B2612B;
	Mon, 22 Jan 2024 06:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4oDc3Pn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148C74A32
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 06:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705905661; cv=none; b=qDszk/5NtDjPzB89F6qXV5Y6C/9trsQvz9BIZCKgTL2qyZLzfAzbHznokYGUNbmkC3vMn/tNDQP9IQWiImFAphEVf/hRpDoeCy6ivv5FVDZM6XBALCZDIehQMbrpwBcZcuPDQVKmICAC0AxoJNVO/hxC38o7DXHCZHmwvndxAUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705905661; c=relaxed/simple;
	bh=JrFoq3NDqP+LcrrV6KoVFxnO7J0vBPKKqKE7Zo3RrCI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oHrDRKXP7wCnfkUA8+dMdKf0EtAcl4MViNsB8o0sfLcU7BKrdL2F2CC2UB0f9NoHZIq+HVKQACmSAxYRSwFwFVKvJH8x/tGGsNcqzZrs0oYSn3xEps9T1RNH/RoFrHt7LcSTg3GJGD4uIpzmY+VnvtfLnEOghJCDDuoAhB2Ljbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4oDc3Pn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705905660; x=1737441660;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JrFoq3NDqP+LcrrV6KoVFxnO7J0vBPKKqKE7Zo3RrCI=;
  b=S4oDc3PnpcubBhkjMoQkFcobW6j9MtBR2qpLWuAV+CujrScVTBVTX6Q3
   99SReLI5Jn/dsWhUyhMkHKtJoarX4aABq1Cz4Wnki0/QwvoB5GRY28QSg
   l3MBltRORv0d4JxQvCaGTLqk7pR+hhtqF7OQnf2fxZtP9S0Khda8L6HoU
   CjJnu5lLpCXWfroEGNkFDTx2WPABqJEVoHsxf+MiM9yTHzMlCLVdxmrYc
   eQYKynAJCRdpNSb2DO5QdjA1D9UUSzybGAoA0git3QrAhSfbViYTWHKzb
   8GIpc/UenQcmLeAoRs4NoSSGmV7ejPNcZrmUUF++s5Z5yifBb5Grmy6NX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1005692"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1005692"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2024 22:40:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="855847224"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="855847224"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jan 2024 22:40:56 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org,
	yi1.lai@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH v2] KVM: selftests: Fix dirty_log_page_splitting_test as page migration
Date: Mon, 22 Jan 2024 14:40:53 +0800
Message-Id: <20240122064053.2825097-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In dirty_log_page_splitting_test, vm_get_stat(vm, "pages_4k") has
probability of gradually reducing before enabling dirty logging. The
reason is the backing sources of some pages (test code and per-vCPU
stacks) are not HugeTLB, leading to the possibility of being migrated.

Requiring NUMA balancing be disabled isn't going to fix the underlying
issue, it's just guarding against one of the more likely culprits.
Therefore, precisely validate only the test data pages, i.e. ensure
no huge pages left and the number of all 4k pages should be at least
equal to the split pages after splitting.

Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
Changelog:

v2:
  - Drop the requirement of NUMA balancing
  - Change the ASSERT conditions

v1:
  https://lore.kernel.org/all/20240117064441.2633784-1-tao1.su@linux.intel.com/
---
 .../kvm/x86_64/dirty_log_page_splitting_test.c     | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..63f9cd2b1e31 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -92,7 +92,7 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	uint64_t host_num_pages;
 	uint64_t pages_per_slot;
 	int i;
-	uint64_t total_4k_pages;
+	uint64_t split_4k_pages;
 	struct kvm_page_stats stats_populated;
 	struct kvm_page_stats stats_dirty_logging_enabled;
 	struct kvm_page_stats stats_dirty_pass[ITERATIONS];
@@ -166,9 +166,8 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	memstress_destroy_vm(vm);
 
 	/* Make assertions about the page counts. */
-	total_4k_pages = stats_populated.pages_4k;
-	total_4k_pages += stats_populated.pages_2m * 512;
-	total_4k_pages += stats_populated.pages_1g * 512 * 512;
+	split_4k_pages = stats_populated.pages_2m * 512;
+	split_4k_pages += stats_populated.pages_1g * 512 * 512;
 
 	/*
 	 * Check that all huge pages were split. Since large pages can only
@@ -180,11 +179,13 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	 */
 	if (dirty_log_manual_caps) {
 		TEST_ASSERT_EQ(stats_clear_pass[0].hugepages, 0);
-		TEST_ASSERT_EQ(stats_clear_pass[0].pages_4k, total_4k_pages);
+		TEST_ASSERT(stats_clear_pass[0].pages_4k >= split_4k_pages,
+			    "The number of 4k pages should be at least equal to the split pages");
 		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, stats_populated.hugepages);
 	} else {
 		TEST_ASSERT_EQ(stats_dirty_logging_enabled.hugepages, 0);
-		TEST_ASSERT_EQ(stats_dirty_logging_enabled.pages_4k, total_4k_pages);
+		TEST_ASSERT(stats_dirty_logging_enabled.pages_4k >= split_4k_pages,
+			    "The number of 4k pages should be at least equal to the split pages");
 	}
 
 	/*
@@ -192,7 +193,6 @@ static void run_test(enum vm_guest_mode mode, void *unused)
 	 * memory again, the page counts should be the same as they were
 	 * right after initial population of memory.
 	 */
-	TEST_ASSERT_EQ(stats_populated.pages_4k, stats_repopulated.pages_4k);
 	TEST_ASSERT_EQ(stats_populated.pages_2m, stats_repopulated.pages_2m);
 	TEST_ASSERT_EQ(stats_populated.pages_1g, stats_repopulated.pages_1g);
 }

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.34.1


