Return-Path: <kvm+bounces-20538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 129A9917DA2
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 12:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2A70B25C2A
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 10:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992C217920E;
	Wed, 26 Jun 2024 10:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GeV+mLqg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6A317F38B;
	Wed, 26 Jun 2024 10:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719397026; cv=none; b=YUNwBk/INwyk76U5JF3BbVdCIs10MMT6rCjTGapehXaTOvE8Zp8XmjewGarg/b/khDgiETe8Skh4n2aE39YfbT1gnIuCYeNSwVSNud2hWJ6KPJ4Qv9Xvh393gbHd0FWvtZzVnxN2+Eeansvh2w3OP+AttGZi3iX+F31ktgKu+rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719397026; c=relaxed/simple;
	bh=btG/8cp2YLAff8XjHMzetlogr5j6nUaqZcP+W3YzqtU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KunEJXlnUgZ31UZjjmIY+GLWZC3vDaZ4l4X8LztKIdnjRZ0QidycbdhkkPCS/6S1w9LnHe9iuYBDRPziH1gcKfJoEtGK75KZmYpDipI9KJjrY+0zH8UYmlWbInlWd/mRsbauT0dc23SB1lsvvKnqcv4pUHQn26y7lnL63zUsTZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GeV+mLqg; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719397025; x=1750933025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=btG/8cp2YLAff8XjHMzetlogr5j6nUaqZcP+W3YzqtU=;
  b=GeV+mLqgYjabB3bGTt8jjjmdgRoV890+3RAYDU08m7xlwjeNM71jYpz3
   Q2f+SwNHrUnlbcbBMNWCpT8g66OknZKQJGJ8YCOsyv3V8zetw98m3msR7
   GLh8Ic1bKeed+h2HLPkTKGUAC34yeArnWe/FOtC+Sgt4Y0AQwJkd/3FwJ
   OJENN1adBu8OkdbvXsg9GIUXiYI96mmD4gLJzKChSAjZSN3/oS8Wct8zL
   7LsndCi/MEqdV5ZmeARs6PfPO9zB+tuPyY2JYduHUCGKGnKe63stcYqeu
   SgvkzBmmx1YNxjcxJpztIwQXsdiZeHOnGrzDZ4JynI667hVEF7Whft2jP
   Q==;
X-CSE-ConnectionGUID: 8tYRzzCLTQi8pkSLmGB5nA==
X-CSE-MsgGUID: nftMGnoGSPeF3t62czON9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16602461"
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="16602461"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2024 03:17:04 -0700
X-CSE-ConnectionGUID: lPfCf4VMT2StZf4BN0XA3g==
X-CSE-MsgGUID: Z8GwrY9ySTS5J7b+HIKk8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,266,1712646000"; 
   d="scan'208";a="43933221"
Received: from unknown (HELO dell-3650.sh.intel.com) ([10.239.159.147])
  by fmviesa008.fm.intel.com with ESMTP; 26 Jun 2024 03:17:03 -0700
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
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v2 2/2] KVM: selftests: Print the seed for the guest pRNG iff it has changed
Date: Thu, 27 Jun 2024 10:17:56 +0800
Message-Id: <20240627021756.144815-2-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240627021756.144815-1-dapeng1.mi@linux.intel.com>
References: <20240627021756.144815-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Print the guest's random seed during VM creation if and only if the seed
has changed since the seed was last printed.  The vast majority of tests,
if not all tests at this point, set the seed during test initialization
and never change the seed, i.e. printing it every time a VM is created is
useless noise.

Snapshot and print the seed during early selftest init to play nice with
tests that use the kselftests harness, at the cost of printing an unused
seed for tests that change the seed during test-specific initialization,
e.g. dirty_log_perf_test.  The kselftests harness runs each testcase in a
separate process that is forked from the original process before creating
each testcase's VM, i.e. waiting until first VM creation will result in
the seed being printed by each testcase despite it never changing.  And
long term, the hope/goal is that setting the seed will be handled by the
core framework, i.e. that the dirty_log_perf_test wart will naturally go
away.

Reported-by: Yi Lai <yi1.lai@intel.com>
Reported-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ad00e4761886..56b170b725b3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -21,6 +21,7 @@
 
 uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
+static uint32_t last_guest_seed;
 
 static int vcpu_mmap_sz(void);
 
@@ -434,7 +435,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
-	pr_info("Random seed: 0x%x\n", guest_random_seed);
+	if (guest_random_seed != last_guest_seed) {
+		pr_info("Random seed: 0x%x\n", guest_random_seed);
+		last_guest_seed = guest_random_seed;
+	}
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
 
@@ -2319,7 +2323,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
-	guest_random_seed = random();
+	guest_random_seed = last_guest_seed = random();
+	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
 	kvm_selftest_arch_init();
 }
-- 
2.34.1


