Return-Path: <kvm+bounces-4684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7503C81671D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4FFF1C22344
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1908FD2ED;
	Mon, 18 Dec 2023 07:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6sUmE6B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65DD269
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883470; x=1734419470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HGKj/1fpsSQ7vqgj7Lmbs32WZSTfNzb092RHhg00L04=;
  b=j6sUmE6BnTs7pGp4/lh2r9XvrzDmywBn3S4XdKthX+nUAuocJHbqqCbs
   sRP+pYXx83iIng3e3uV0CIz+RVTVt9PjkddK+hsXIvC0j7FHrbydpmb+P
   yKGR1DzxY2AAikikYadNfveXtbxb/ttriO9qIk9/DatgH6WQPtblTE3Gk
   WQ9TtLiM6tkSLtqnsSG7+wSGD7067tjUrJxFuuuD0V+7jhB8rS8KwPo2C
   ALeMUehBxKaAF5SEAlYL9UOrCLtt62gjRf2gn2uD/mBUvoXT6/g+4LKZl
   ysUuIqdbCECjoUwHB54JT42yUsCwbv/ebfkjQlbYnlpZF2huYBsLHL83Q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2668017"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2668017"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:11:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824848"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824848"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:11:06 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 18/18] x86 TDX: Make run_tests.sh work with TDX
Date: Mon, 18 Dec 2023 15:22:47 +0800
Message-Id: <20231218072247.2573516-19-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Define a special group 'tdx' for those test cases supported by TDX. So
that when group 'tdx' specified, these test cases run in TDX protected
environment if EFI_TDX=y.

For example:
    EFI_TDX=y ./run_tests.sh -g tdx

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-18-zhenzhong.duan@intel.com
Co-developed-by: Qian Wen <qian.wen@intel.com>
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 README.md         |  6 ++++++
 x86/unittests.cfg | 17 ++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 6e82dc22..a84460e9 100644
--- a/README.md
+++ b/README.md
@@ -137,6 +137,12 @@ when the user does not provide an environ, then an environ generated
 from the ./errata.txt file and the host's kernel version is provided to
 all unit tests.
 
+# Unit test in TDX environment
+
+    All the test cases supported by TDX belong to 'tdx' group, by this
+    command: "EFI_TDX=y ./run_tests.sh -g tdx", all these test cases run
+    in a TDX protected environment.
+
 # Contributing
 
 ## Directory structure
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 8a3830d8..ac1f3273 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -69,10 +69,12 @@ arch = i386
 [smptest]
 file = smptest.flat
 smp = 2
+groups = tdx
 
 [smptest3]
 file = smptest.flat
 smp = 3
+groups = tdx
 
 [vmexit_cpuid]
 file = vmexit.flat
@@ -186,6 +188,7 @@ file = hypercall.flat
 [idt_test]
 file = idt_test.flat
 arch = x86_64
+groups = tdx
 
 #[init]
 #file = init.flat
@@ -194,6 +197,7 @@ arch = x86_64
 file = memory.flat
 extra_params = -cpu max
 arch = x86_64
+groups = tdx
 
 [msr]
 # Use GenuineIntel to ensure SYSENTER MSRs are fully preserved, and to test
@@ -202,6 +206,7 @@ arch = x86_64
 # will fail due to shortcomings in KVM.
 file = msr.flat
 extra_params = -cpu max,vendor=GenuineIntel
+groups = tdx
 
 [pmu]
 file = pmu.flat
@@ -241,6 +246,7 @@ file = s3.flat
 
 [setjmp]
 file = setjmp.flat
+groups = tdx
 
 [sieve]
 file = sieve.flat
@@ -250,10 +256,12 @@ timeout = 180
 file = syscall.flat
 arch = x86_64
 extra_params = -cpu Opteron_G1,vendor=AuthenticAMD
+groups = tdx
 
 [tsc]
 file = tsc.flat
 extra_params = -cpu max
+groups = tdx
 
 [tsc_adjust]
 file = tsc_adjust.flat
@@ -263,10 +271,12 @@ extra_params = -cpu max
 file = xsave.flat
 arch = x86_64
 extra_params = -cpu max
+groups = tdx
 
 [rmap_chain]
 file = rmap_chain.flat
 arch = x86_64
+groups = tdx
 
 [svm]
 file = svm.flat
@@ -306,7 +316,7 @@ extra_params = --append "10000000 `date +%s`"
 file = pcid.flat
 extra_params = -cpu qemu64,+pcid,+invpcid
 arch = x86_64
-groups = pcid
+groups = pcid tdx
 
 [pcid-disabled]
 file = pcid.flat
@@ -324,10 +334,12 @@ groups = pcid
 file = rdpru.flat
 extra_params = -cpu max
 arch = x86_64
+groups = tdx
 
 [umip]
 file = umip.flat
 extra_params = -cpu qemu64,+umip
+groups = tdx
 
 [la57]
 file = la57.flat
@@ -447,6 +459,7 @@ check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
 [debug]
 file = debug.flat
 arch = x86_64
+groups = tdx
 
 [hyperv_synic]
 file = hyperv_synic.flat
@@ -485,6 +498,7 @@ extra_params = -M q35,kernel-irqchip=split -device intel-iommu,intremap=on,eim=o
 file = tsx-ctrl.flat
 extra_params = -cpu max
 groups = tsx-ctrl
+groups = tdx
 
 [intel_cet]
 file = cet.flat
@@ -495,3 +509,4 @@ extra_params = -enable-kvm -m 2048 -cpu host
 [intel_tdx]
 file = intel_tdx.flat
 arch = x86_64
+groups = tdx nodefault
-- 
2.25.1


