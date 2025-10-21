Return-Path: <kvm+bounces-60630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71128BF5176
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C17AE1890E65
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B73B82E8B76;
	Tue, 21 Oct 2025 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pKVYg/tj"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2EA2F9DA0
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032942; cv=none; b=n78k9Qpwgq0qYaSCA/0ihYOkOqgnocbrRW2pjpAHZXO/Usz2J+ehc4nT9C8248pxQr29IfoW90w8psFId6yJC7HnTnIa+Hq4jXFTEkw8tt2651tbUEGRcgGP6lH151DB+4+wOSh8J07xN04n7Xgrmq63mi9fAmUIX59olzcguEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032942; c=relaxed/simple;
	bh=EmznAr8tmGfsTdBHmekvfG9pkapYRSGehWhfgV4sp90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3Rqz5yIw0M/UNbuGEUA1Q4r0oBJKiNDk6U1gSMXYH0k6wdipumQM+jeRy3i8gBnqefGT2OvL/ihNKx1lMqX4mPPMHiJGl5HAcCFpyqvW5+jdF4JW5k+MqPVN280RtgpJDQ4ZYe7CtBY/BCneJTukzakea65oPmsUQKfI2J4G8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pKVYg/tj; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nN4L1HU/8fM9rmYn5HhmuTZwVxQlkWZRotXsVNYVoAk=;
	b=pKVYg/tjR1tdfXX+FDnTt89yFzICj/HM64BFPiG6eQ+dQLU1AmXdyQUqQ356KVHr8UQdAp
	9uHmlte6E/j1ZFc7aYVQSm3Lf0lm6iBMlgGTaqJdidJYaDEZPQy+b1DksFuXLJXmm3YUO5
	JxRr1JlhlzDx3VCTXavbDIbWKKAyNjo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 20/23] KVM: selftests: Stop passing a memslot to nested_map_memslot()
Date: Tue, 21 Oct 2025 07:47:33 +0000
Message-ID: <20251021074736.1324328-21-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On x86, KVM selftests use memslot 0 for all the default regions used by
the test infrastructure. This is an implementation detail.
nested_map_memslot() is currently used to map the default regions by
explicitly passing slot 0, which leaks the library implementation into
the caller.

Rename the function to a very verbose
nested_identity_map_default_memslots() to reflect what it actually does.
Add an assertion that only memslot 0 is being used so that the
implementation does not change from under us.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/processor.h  |  3 +--
 tools/testing/selftests/kvm/lib/x86/processor.c      | 11 +++++++----
 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c |  2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 13e8f4a1f589d..2608152b2fa27 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1459,8 +1459,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t root_gpa,
-			uint32_t memslot);
+void nested_identity_map_default_memslots(struct kvm_vm *vm, vm_paddr_t root_gpa);
 void nested_identity_map_1g(struct kvm_vm *vm, vm_paddr_t root_gpa,
 			    uint64_t addr, uint64_t size);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 1725f8fde2aa5..958389ec1722d 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -496,12 +496,15 @@ void nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t root_gpa,
-			uint32_t memslot)
+void nested_identity_map_default_memslots(struct kvm_vm *vm, vm_paddr_t root_gpa)
 {
+	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
-	struct userspace_mem_region *region =
-		memslot2region(vm, memslot);
+	struct userspace_mem_region *region = memslot2region(vm, memslot);
+
+	/* Only memslot 0 is mapped here, ensure it's the only one being used */
+	for (s = 0; s < NR_MEM_REGIONS; s++)
+		TEST_ASSERT_EQ(vm->memslots[s], 0);
 
 	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
 	last = i + (region->region.memory_size >> vm->page_shift);
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index e54e6111164e7..b8ebb246aaf15 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,7 +121,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_map_memslot(vm, vmx->eptp_gpa, 0);
+		nested_identity_map_default_memslots(vm, vmx->eptp_gpa);
 		nested_map(vm, vmx->eptp_gpa, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		nested_map(vm, vmx->eptp_gpa, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
-- 
2.51.0.869.ge66316f041-goog


