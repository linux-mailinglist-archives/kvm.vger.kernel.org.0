Return-Path: <kvm+bounces-19544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 468969063D1
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B33AE284566
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71CD1137772;
	Thu, 13 Jun 2024 06:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iEuQatd6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035DC136E16;
	Thu, 13 Jun 2024 06:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718259099; cv=none; b=hJxFw1j91EQwMMESdBXXNplWxfw2gr1moIBBNYYjRKeqA707NHyEHlE72rdykn/1924qi+7xE025GOCcpUUWThL78bsGZNddY8/Xcvf5HHvz1RbK29di9PXgroYcLWqHJb8g6sXF12+5ZCJsjvDPA/gpoOwAfZ1tgCOd87+58Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718259099; c=relaxed/simple;
	bh=w/1rwRGbSd+x48cBrawS9ygwKtHv3Yd42T/+V4bBG5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akC6eGnC3CZaZlz6aLeqnTcMvxpJ4Lm8zNW3yrmWLTC04ornBB3ft/6EskBuIh9IWXLMHYfCKAdDk74VQz3BzOpbGYsZTsUAOnosXEfCiPmZkPhpwylblN3Hom5Itx6CF/1Q0GvBvFWPmQej8E5p5xSm0o86i9VmeTXePSkFdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iEuQatd6; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718259098; x=1749795098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w/1rwRGbSd+x48cBrawS9ygwKtHv3Yd42T/+V4bBG5w=;
  b=iEuQatd6rXdvzfKeRN9mWG9eF+xH5LsDXb07l5bPKszpG/Tx7rywlonT
   GGrWu7aZYRR3XzFBJ5e0rex0qnmB7MxQsTblkJawM1SKbPO9yS4D8qoFU
   c7zkT5RqURjH2HKzr6Lu+EnVU/Ift5dbKD+uI6SxyhPhnWQPTMs6ib6X0
   A6u7w5vaMj4y6hGzW1aeV/npEeCUtWnDT16vwjFDuljLvUTe8CUc6RiBz
   Fkq0S8cev9ZD3Pcl8wMo/KkYGNU9R/uUdbfk0S5lYZTeC1MR/q2COexwa
   UuX4o+Egn7s4wtrN++jB9nSyhwsgDORE10l154jhe8jVUNhjHnsvo2PpX
   Q==;
X-CSE-ConnectionGUID: 4xklyVFRTP2ZgflEnbZ1ow==
X-CSE-MsgGUID: kdYSSuN4Q+CTJrMc2LWtYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14894761"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="14894761"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:11:38 -0700
X-CSE-ConnectionGUID: kWon/JDkRTCTdkJOIhv5dg==
X-CSE-MsgGUID: pGJo4d8WSECnjSFs1jk07w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="44417238"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:11:35 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 3/5] KVM: selftests: Allow slot modification stress test with quirk disabled
Date: Thu, 13 Jun 2024 14:10:37 +0800
Message-ID: <20240613061037.11847-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240613060708.11761-1-yan.y.zhao@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new user option to memslot_modification_stress_test to allow testing
with slot zap quirk KVM_X86_QUIRK_SLOT_ZAP_ALL disabled.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../kvm/memslot_modification_stress_test.c    | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 05fcf902e067..c6f22ded4c96 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -85,6 +85,7 @@ struct test_params {
 	useconds_t delay;
 	uint64_t nr_iterations;
 	bool partition_vcpu_memory_access;
+	bool disable_slot_zap_quirk;
 };
 
 static void run_test(enum vm_guest_mode mode, void *arg)
@@ -95,6 +96,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
+#ifdef __x86_64__
+	if (p->disable_slot_zap_quirk)
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+
+	pr_info("Memslot zap quirk %s\n", p->disable_slot_zap_quirk ?
+		"disabled" : "enabled");
+#endif
 
 	pr_info("Finished creating vCPUs\n");
 
@@ -113,11 +121,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-m mode] [-d delay_usec]\n"
+	printf("usage: %s [-h] [-m mode] [-d delay_usec] [-q]\n"
 	       "          [-b memory] [-v vcpus] [-o] [-i iterations]\n", name);
 	guest_modes_help();
 	printf(" -d: add a delay between each iteration of adding and\n"
 	       "     deleting a memslot in usec.\n");
+	printf(" -q: Disable memslot zap quirk.\n");
 	printf(" -b: specify the size of the memory region which should be\n"
 	       "     accessed by each vCPU. e.g. 10M or 3G.\n"
 	       "     Default: 1G\n");
@@ -143,7 +152,7 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hm:d:b:v:oi:")) != -1) {
+	while ((opt = getopt(argc, argv, "hm:d:qb:v:oi:")) != -1) {
 		switch (opt) {
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -166,6 +175,12 @@ int main(int argc, char *argv[])
 		case 'i':
 			p.nr_iterations = atoi_positive("Number of iterations", optarg);
 			break;
+		case 'q':
+			p.disable_slot_zap_quirk = true;
+
+			TEST_REQUIRE(kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) &
+				     KVM_X86_QUIRK_SLOT_ZAP_ALL);
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
-- 
2.43.2


