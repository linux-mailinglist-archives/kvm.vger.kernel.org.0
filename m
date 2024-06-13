Return-Path: <kvm+bounces-19543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBEFE9063CD
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F26041C21484
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE349136E28;
	Thu, 13 Jun 2024 06:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TLAMOb0d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4624E1369A0;
	Thu, 13 Jun 2024 06:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718259089; cv=none; b=lwTvBECMxGsCGk5pZPo7U46gXtt2CS+YwUfUVnF3W9FMVWcbo5PU8ovnQQJ48NRdQxjQk+T5T1o1ZcK1XVam2E4R+XYnHxHdv/uAwiVxVqDPTHCq5voP6iFG0HR3Yzn9wLkOEYtu3xMB0fZO7f+FR3d0yEUXNlHutOreSXqQ6uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718259089; c=relaxed/simple;
	bh=xELkib58GVsHFnJOyikK4lxSSfPcXfJatrw+PYgf+/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5CFq3vttZcKoEBxIlfGvQms78EbOZmgwwK0s6AZf42g5zU6yf8OKxPySpqEbqsJldDzcfkCVLB+bfyGc2tC4HfZguV0W5WRUpPGEjBKfY9rNt0unkeVEq7vJDIbFKSqjWVMLezhaCa/CguTSB01G2k4MIKz7kidtrT/Ji74Z6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TLAMOb0d; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718259088; x=1749795088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xELkib58GVsHFnJOyikK4lxSSfPcXfJatrw+PYgf+/A=;
  b=TLAMOb0d5LZPcHq/6sCKmMVyx1dh3zxh9bwYT7QsItMfR0MUSO/hy8F+
   yyU8wDfZ5kyzTBbkfXHAsQDQn0HDaJ9VyrMBftjhhYGZC/ccCjAeG/JN3
   aZUIWjGGOk/YchcffqW/wCbzIH7bjTv/9gXhl7nPHPigHj60kumEUIE+l
   Rq1wxUiAvUbPVNpSq0B07bBj5doTEk77E4VIrfXxMErthN5UKdGNdWlst
   JuMhmH7Ygg6nOtCZgdA61YeB+W/uyfytErozOv0vBUvnD56NPJcSry2YD
   mAhoVzOwPLsEf8Qx6kud+nnTRBIqViimMJ1FyiwIoQ1J6sAlVWd/BRDyR
   g==;
X-CSE-ConnectionGUID: P/vIYiOGTiqjQWIrhblyPw==
X-CSE-MsgGUID: gLnke7yRRo26umhDdbWvQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="14894744"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="14894744"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:11:26 -0700
X-CSE-ConnectionGUID: prGISX2bT62Qm9w6RNU/0g==
X-CSE-MsgGUID: vfjsAz2WTkyzrbiPqUcNqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="44417196"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:11:23 -0700
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
Subject: [PATCH 2/5] KVM: selftests: Test slot move/delete with slot zap quirk enabled/disabled
Date: Thu, 13 Jun 2024 14:10:24 +0800
Message-ID: <20240613061024.11831-1-yan.y.zhao@intel.com>
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

Update set_memory_region_test to make sure memslot move and deletion
function correctly both when slot zap quirk KVM_X86_QUIRK_SLOT_ZAP_ALL is
enabled and disabled.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index bb8002084f52..a8267628e9ed 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -175,7 +175,7 @@ static void guest_code_move_memory_region(void)
 	GUEST_DONE();
 }
 
-static void test_move_memory_region(void)
+static void test_move_memory_region(bool disable_slot_zap_quirk)
 {
 	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
@@ -184,6 +184,9 @@ static void test_move_memory_region(void)
 
 	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_move_memory_region);
 
+	if (disable_slot_zap_quirk)
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 
 	/*
@@ -266,7 +269,7 @@ static void guest_code_delete_memory_region(void)
 	GUEST_ASSERT(0);
 }
 
-static void test_delete_memory_region(void)
+static void test_delete_memory_region(bool disable_slot_zap_quirk)
 {
 	pthread_t vcpu_thread;
 	struct kvm_vcpu *vcpu;
@@ -276,6 +279,9 @@ static void test_delete_memory_region(void)
 
 	vm = spawn_vm(&vcpu, &vcpu_thread, guest_code_delete_memory_region);
 
+	if (disable_slot_zap_quirk)
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+
 	/* Delete the memory region, the guest should not die. */
 	vm_mem_region_delete(vm, MEM_REGION_SLOT);
 	wait_for_vcpu();
@@ -553,7 +559,10 @@ int main(int argc, char *argv[])
 {
 #ifdef __x86_64__
 	int i, loops;
+	int j, disable_slot_zap_quirk = 0;
 
+	if (kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_SLOT_ZAP_ALL)
+		disable_slot_zap_quirk = 1;
 	/*
 	 * FIXME: the zero-memslot test fails on aarch64 and s390x because
 	 * KVM_RUN fails with ENOEXEC or EFAULT.
@@ -579,13 +588,17 @@ int main(int argc, char *argv[])
 	else
 		loops = 10;
 
-	pr_info("Testing MOVE of in-use region, %d loops\n", loops);
-	for (i = 0; i < loops; i++)
-		test_move_memory_region();
+	for (j = 0; j <= disable_slot_zap_quirk; j++) {
+		pr_info("Testing MOVE of in-use region, %d loops, slot zap quirk %s\n",
+			loops, j ? "disabled" : "enabled");
+		for (i = 0; i < loops; i++)
+			test_move_memory_region(!!j);
 
-	pr_info("Testing DELETE of in-use region, %d loops\n", loops);
-	for (i = 0; i < loops; i++)
-		test_delete_memory_region();
+		pr_info("Testing DELETE of in-use region, %d loops, slot zap quirk %s\n",
+			loops, j ? "disabled" : "enabled");
+		for (i = 0; i < loops; i++)
+			test_delete_memory_region(!!j);
+	}
 #endif
 
 	return 0;
-- 
2.43.2


