Return-Path: <kvm+bounces-20863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4233E924D8C
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D49AB23394
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84F211187;
	Wed,  3 Jul 2024 02:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrcPyI1e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B7BBA38;
	Wed,  3 Jul 2024 02:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972755; cv=none; b=i3IW47s0WgdN+0muk86C8d3bBF+LHE9hc5wGUhVQHczSl/5wacPZF5ubnFFi3/KxAhp4qkV194b6aL0rjkbVDtItFRHJXep0y1qTIkiAoF1UY/qkDv1TIqkHXYPFVmni2crhu4evCH9z3ogMgGLnua15pERZYkVNNKPmwximzLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972755; c=relaxed/simple;
	bh=xELkib58GVsHFnJOyikK4lxSSfPcXfJatrw+PYgf+/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKhHiXSxujeS+TYAR/Dzc3sx+e7GgrVQYRCQ4xrErtUfxdTmYsiy0/aF/deZ3vwWlCkIeZEo6yQHXAVYgOsAn/nKayTIz+aRey6Mp6awLVLg+dAUx8RpwFSiapLp0a+3NpqGbH7pMnO96fo3qm8bsOVKLsEZM31XFbiiwhVSXgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrcPyI1e; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972754; x=1751508754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xELkib58GVsHFnJOyikK4lxSSfPcXfJatrw+PYgf+/A=;
  b=TrcPyI1edF4SW4eulaBGFluo1HQ2cp/2jluWady4Lha9Sl5lfnmD7D6U
   j2diJ8xCtlSPDmmyYYNUjZBrEdU0BfW8ajS0/iXCVh+gBIArIWe46PaaJ
   0CbR14D9aeqf2cOqeg+1w1vY5IAP53cP2g9MRdFj8bZYLydA5NkQeRJlP
   kZjjqIFGCtR6GIsycZrtPJtMFGamzQ+58hY5qo+OHcDe14IMArDQqGJhJ
   t9533g5T3urCAXRAH88o2Jmz/1rI/FARkPrsk/fON99jXeHD7KNBdpayf
   wjU5+azsSf7FlGBaf8La+JRHYF4mCkyniuM5otGW01DfMW7GXmxI9MuuD
   Q==;
X-CSE-ConnectionGUID: NhscTyeTTBKYZarblZHoxQ==
X-CSE-MsgGUID: S4QjrT4GQnW0MG1LpXgvBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="21052136"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="21052136"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:33 -0700
X-CSE-ConnectionGUID: kGJWyL5JQgKKAelzLxEcFQ==
X-CSE-MsgGUID: PUctjiZqTS6rWw0lyvYK9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46507093"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:12:30 -0700
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
Subject: [PATCH v2 2/4] KVM: selftests: Test slot move/delete with slot zap quirk enabled/disabled
Date: Wed,  3 Jul 2024 10:11:19 +0800
Message-ID: <20240703021119.13904-1-yan.y.zhao@intel.com>
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


