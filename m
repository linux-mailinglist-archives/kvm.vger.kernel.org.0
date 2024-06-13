Return-Path: <kvm+bounces-19546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 568839063DA
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 08:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68A7A1C21898
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 06:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BF31386B7;
	Thu, 13 Jun 2024 06:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KPVGPkHM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDB3135A4B;
	Thu, 13 Jun 2024 06:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718259128; cv=none; b=M95oN+K1Bz+yPD6coopN4lwOFzopdWhusGFf2DOEaWbV3Qs7AMiNKPIKQ5M3LXs0wGzxOy9zDt5/OCF7O9fl0cdSOTPWUAuDN4/n7OLWoaTllvzFNLbP+Txd5wuwmFULXlf7I7RiTpgAq/5VDBAnErZB6coYqC42D824ycG4aNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718259128; c=relaxed/simple;
	bh=200iro4Vmpjs5iDslEXl3WgKuWoTIPG9CIIZtZp9mVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB0se2jEPa6uI1G7Qnwighl8hyUcKOhVMOkN4wkFQNgSbC59jws3/dXfUv7PH6S47ZD2tyUiGpUSLVpXve80mqYe98ofVEUFGlBzNsM3uDCUeDehamM6k/0pWNNCHCv9Catvv+ewIqbRe/cSk5TBAY9XtX6R2cmVwwknzSV05fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KPVGPkHM; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718259127; x=1749795127;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=200iro4Vmpjs5iDslEXl3WgKuWoTIPG9CIIZtZp9mVc=;
  b=KPVGPkHMPHKJSPU4JslM3u65erR82kLl19jKoiZnUhWgVxytLd5Fq1+D
   WS9x810lH+wjbOj1zDBckHHU408jG8MPe4Z5xtZMaN7jvxwtNoxmaM/En
   ytQ4kqsVcQ5ETSkUtO92qO5kooZqQivyk8mYreQwPyjqPalc0RVmx9qJR
   P+A44FIgA7BFG8VIetjLsVBepxk/zfxg3SYpNC2l0QrwneKNLBevY8MBM
   a9bKs7C6uA0R79bOQ3dMyynNfM2hjNskuJ6tij9WNhyqvf1y0xugR6wBn
   b7KyEiRVo8E8wxgFxNuha2fPvM3j+LnC5xk8IQd/LlyfWdV5CHjKAAKR6
   g==;
X-CSE-ConnectionGUID: friMxZrJRLeaaBYMdFM7Qg==
X-CSE-MsgGUID: DaDIW5QmTE6Q8uoJOXLZgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="25734269"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="25734269"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:12:07 -0700
X-CSE-ConnectionGUID: xvVCxiNORzShhmx7pEI/3g==
X-CSE-MsgGUID: Jh2Q/CkXTNe0fI8K+ti5hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="40669223"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 23:12:03 -0700
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
Subject: [PATCH 5/5] KVM: selftests: Test private access to deleted memslot with quirk disabled
Date: Thu, 13 Jun 2024 14:11:05 +0800
Message-ID: <20240613061105.11880-1-yan.y.zhao@intel.com>
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

Update private_mem_kvm_exits_test to make sure private access to deleted
memslot functional both when quirk KVM_X86_QUIRK_SLOT_ZAP_ALL is enabled
and disabled.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 .../selftests/kvm/x86_64/private_mem_kvm_exits_test.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
index 13e72fcec8dd..a4d304fce294 100644
--- a/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86_64/private_mem_kvm_exits_test.c
@@ -44,7 +44,7 @@ const struct vm_shape protected_vm_shape = {
 	.type = KVM_X86_SW_PROTECTED_VM,
 };
 
-static void test_private_access_memslot_deleted(void)
+static void test_private_access_memslot_deleted(bool disable_slot_zap_quirk)
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -55,6 +55,9 @@ static void test_private_access_memslot_deleted(void)
 	vm = vm_create_shape_with_one_vcpu(protected_vm_shape, &vcpu,
 					   guest_repeatedly_read);
 
+	if (disable_slot_zap_quirk)
+		vm_enable_cap(vm, KVM_CAP_DISABLE_QUIRKS2, KVM_X86_QUIRK_SLOT_ZAP_ALL);
+
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    EXITS_TEST_GPA, EXITS_TEST_SLOT,
 				    EXITS_TEST_NPAGES,
@@ -115,6 +118,10 @@ int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
-	test_private_access_memslot_deleted();
+	test_private_access_memslot_deleted(false);
+
+	if (kvm_check_cap(KVM_CAP_DISABLE_QUIRKS2) & KVM_X86_QUIRK_SLOT_ZAP_ALL)
+		test_private_access_memslot_deleted(true);
+
 	test_private_access_memslot_not_private();
 }
-- 
2.43.2


