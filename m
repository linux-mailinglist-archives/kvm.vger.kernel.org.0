Return-Path: <kvm+bounces-6377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6662283003A
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 07:44:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF35D2876E5
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 06:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602009463;
	Wed, 17 Jan 2024 06:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SJAD+R8z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262168F47
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 06:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705473887; cv=none; b=kD7OY48eYzMlkfcaszng69bI9KYOmtlejVkhtyypB55bpzP/KJoGa4u0qoswtTGVjCGiOlMIb1XZnCncUXHJybDxp+xM5C3pGccK5Hlz01Z8GFB1HnXUARLXPEam2H+dKuVcOTPnz/UPNqvdk5QAiwmtxbnWQ4H6txThvNT6fts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705473887; c=relaxed/simple;
	bh=LJGVG1IZRygTtRQiQlJ4BibpMvhe1rKZ3KxDm6yteMg=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding; b=hXuzrPaLdN7BymrD9LLensoAc35XcoLwou0VoXZBFdjaGxUo+ltEy8bUgMCC/qGhKYhwEBAlVYIORaHoRZixJPLjrDXOs3R1iDPoUc4bb00GfvCZhLeqTyMre4oY0pjIouOaAlLFkhOdW81n6f4JfoYVtf9bJxMbRljHJjgC3l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SJAD+R8z; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705473886; x=1737009886;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LJGVG1IZRygTtRQiQlJ4BibpMvhe1rKZ3KxDm6yteMg=;
  b=SJAD+R8z2CiqCbiuBRBTfn8tHNAt9tDox0Ykz3Y36N0BjvJHoVE10hSS
   cXe2weECaaVxvk5RVii4WV4ChrWlxHHHEVOmT/2egdi02XQlYe7P8APvO
   FepJnG2NV/llyF9BeXEfaBT39g2Aqu03Ik+SXPNB165GvKvbOdzqk7jj1
   rUKsf3ZcTa6PE7lR5nPdqafNJeOkRFIEHE0MkWcrpEAqdWSLPsyKLFp5p
   f9EIiL9kRGnZ+bhEtNPbzZw+h7yZTLMIbPEYuCUSpk3rjFx4hqIMxt/kt
   epTEUExt2LhoosUQ4tIsprQparVpvTu8UoAhfuw2xT58gamb8sCY74JWx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="390539358"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="390539358"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 22:44:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="1031246168"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="1031246168"
Received: from st-server.bj.intel.com ([10.240.193.102])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jan 2024 22:44:43 -0800
From: Tao Su <tao1.su@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	shuah@kernel.org,
	yi1.lai@intel.com,
	tao1.su@linux.intel.com
Subject: [PATCH] KVM: selftests: Add a requirement for disabling numa balancing
Date: Wed, 17 Jan 2024 14:44:41 +0800
Message-Id: <20240117064441.2633784-1-tao1.su@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In dirty_log_page_splitting_test, vm_get_stat(vm, "pages_4k") has
probability of gradually reducing to 0 after vm exit. The reason is that
the host triggers numa balancing and unmaps the related spte. So, the
number of pages currently mapped in EPT (kvm->stat.pages) is not equal
to the pages touched by the guest, which causes stats_populated.pages_4k
and stats_repopulated.pages_4k in this test are not same, resulting in
failure.

The calltrace of unmapping spte triggered by numa balancing:
	handle_changed_spte+0x64b/0x830 [kvm]
	tdp_mmu_zap_leafs+0x159/0x290 [kvm]
	kvm_tdp_mmu_unmap_gfn_range+0x7b/0xa0 [kvm]
	kvm_unmap_gfn_range+0x10f/0x130 [kvm]
	? _raw_spin_unlock+0x1d/0x40
	? hugetlb_follow_page_mask+0x1ba/0x400
	? preempt_count_add+0x86/0xd0
	kvm_mmu_notifier_invalidate_range_start+0x14d/0x380 [kvm]
	__mmu_notifier_invalidate_range_start+0x89/0x1f0
	change_protection+0xce1/0x1490
	? __pfx_tlb_is_not_lazy+0x10/0x10
	change_prot_numa+0x5d/0xb0
	? kmalloc_trace+0x2e/0xa0
	task_numa_work+0x364/0x550
	task_work_run+0x62/0xa0
	xfer_to_guest_mode_handle_work+0xc3/0xd0
	kvm_arch_vcpu_ioctl_run+0xe8e/0x1b90 [kvm]
	kvm_vcpu_ioctl+0x282/0x710 [kvm]

dirty_log_page_splitting_test assumes that kvm->stat.pages and the pages
touched by the guest are the same, but the assumption is no longer true
if numa balancing is enabled. Add a requirement for disabling
numa_balancing to avoid confusing due to test failure.

Actually, all page migration (including numa balancing) will trigger this
issue, e.g. running script:
	./x86_64/dirty_log_page_splitting_test &
	PID=$!
	sleep 1
	migratepages $PID 0 1
It is unusual to create above test environment intentionally, but numa
balancing initiated by the kernel will most likely be triggered, at
least in dirty_log_page_splitting_test.

Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 .../kvm/x86_64/dirty_log_page_splitting_test.c        | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index 634c6bfcd572..f2c796111d83 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -212,10 +212,21 @@ static void help(char *name)
 
 int main(int argc, char *argv[])
 {
+	FILE *f;
 	int opt;
+	int ret, numa_balancing;
 
 	TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
 	TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
+	f = fopen("/proc/sys/kernel/numa_balancing", "r");
+	if (f) {
+		ret = fscanf(f, "%d", &numa_balancing);
+		TEST_ASSERT(ret == 1, "Error reading numa_balancing");
+		TEST_ASSERT(!numa_balancing, "please run "
+			    "'echo 0 > /proc/sys/kernel/numa_balancing'");
+		fclose(f);
+		f = NULL;
+	}
 
 	while ((opt = getopt(argc, argv, "b:hs:")) != -1) {
 		switch (opt) {

base-commit: 052d534373b7ed33712a63d5e17b2b6cdbce84fd
-- 
2.34.1


