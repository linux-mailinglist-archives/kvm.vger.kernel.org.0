Return-Path: <kvm+bounces-20879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC3C924DB2
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76B3BB23886
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7D7130486;
	Wed,  3 Jul 2024 02:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mb41AVne"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E2612F5A0;
	Wed,  3 Jul 2024 02:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972801; cv=none; b=jMJIPZUJt+YQ/wxmP/WTWqO4oLP7vqCs/W3zU+DLvCZjlrkDdil8CvrXNo+6jYjw9M/dpX6ZrjEzmF1R/uCzPo+RmEhObz1/lcCX/5ZqjDHHivNvzGa14kp6neGMhQankra1J2hUpwpRJZuwxA79+IDVq3iF71QkUKZq9+zvXgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972801; c=relaxed/simple;
	bh=w/1rwRGbSd+x48cBrawS9ygwKtHv3Yd42T/+V4bBG5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggJ7putWZ3hVtzozLolDHePO7/VdOGlwt279yLSSD2jWtZZgU44NWPv4JqStYtjV8c/bgfnA+7q4IMD1uNUk4ZQeYqBGcQ3J3ASFwqQV/HpsDtUZEIzCdp8Ta8HYdHOTu+PAFQRJFHlKrKNJPAdoa93haexuM7DMP2WWv4/CXiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mb41AVne; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972800; x=1751508800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w/1rwRGbSd+x48cBrawS9ygwKtHv3Yd42T/+V4bBG5w=;
  b=mb41AVneLdEQkJuXtsKobl4/9depaEM24z4HPdUQDaZ+Gs721+ng5GEK
   3aYq/r4OYICNW/iDTLMKE1VskjKH/VwKw3bMOEuI6mBivWDzZVu/bJg3H
   t4BIcbWutgL8HejT96NN8E6fbW3yr5pSACp+n+C13M12hJdc5nMyUTwLA
   5QMGfK0Bs73XpTe4OwhHaCuvEZHEAKV78pl7DhBPEf4IOcPRzWUMLTxrX
   F4CQBJ/0mZZR8qQOTUtnM6MBtRD1Y6asbdAUxsSZ79hrC1bAQOjBnElp4
   nZyGykFsCwoGUoAwrNRVbkGh6Wa37Si6ESDyXMq7+o/Bgd0SHePEuWDww
   A==;
X-CSE-ConnectionGUID: eV/OL/DqQmqSiHlhDGf8iA==
X-CSE-MsgGUID: nDk8+QzuSVWC5sNcQMbXsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="20082372"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="20082372"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:19 -0700
X-CSE-ConnectionGUID: 93II0wvEQSSN6l+4srTpuQ==
X-CSE-MsgGUID: Waa3/Xu1TaGd8y8/bBAt7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="76832476"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:16 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	dmatlack@google.com,
	sagis@google.com,
	erdemaktas@google.com,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 3/4] KVM: selftests: Allow slot modification stress test with quirk disabled
Date: Wed,  3 Jul 2024 10:12:06 +0800
Message-ID: <20240703021206.13923-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240703020921.13855-1-yan.y.zhao@intel.com>
References: <20240703020921.13855-1-yan.y.zhao@intel.com>
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


