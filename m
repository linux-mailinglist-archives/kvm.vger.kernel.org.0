Return-Path: <kvm+bounces-64802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7CDC8C8F7
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7FBD3B5497
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98D02264AD;
	Thu, 27 Nov 2025 01:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HZqGIS5W"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CD20A5E5
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207305; cv=none; b=qR3xHeZhSxFnP9qTYyt9HKbpOwCDe8jF5zxLc74YpVrnuQSyGd9GHse5i152eVHodQ9DsKHPXiMopoUXLgaGA9Z+fNecZJUaFh7AY4omHKra3qac5cdFrh3IgrDSjB6JjSX3xp7qBRkaedgFcic9iSF/booL7KgP8j2XXestXBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207305; c=relaxed/simple;
	bh=6WtAfRiH26crlvJct2IW2aooUxpguTYbw3yNk1UnbK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puULCWbz16pKVTMtRQNRrX8PPvLPCBM9CPA1VMzy7/asJjH3qsuojoHe16Tp6t6nY4bOol0ib3l27EbmvuamcJElG/AT+GDRjA8LArgD/UUpDXJINTXWdPuAnsBBED8nJxbNahWJ3d3nmQ7JB9WFT3WMlioFw3Fati6OpUV/X6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HZqGIS5W; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ngn58Ujgt1/h2MxgJUJ7H8sJngcgIdx0fAFNYR8+FNQ=;
	b=HZqGIS5WYnwJB1vmmTbNwtGulu+CJE5a0t3b1vzCoLDeYIEzgKWfkxdOumuPiVpki5LE9C
	XPGE9knHa3rzBZ8+cvukqP18J1vHxlMkONcWWzr1hnD9y31cs2HFud51XtjSpqBStjCGXA
	xd84KwjQiq7paq09G69YVIiQltpYrok=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 02/16] KVM: selftests: Stop passing a memslot to nested_map_memslot()
Date: Thu, 27 Nov 2025 01:34:26 +0000
Message-ID: <20251127013440.3324671-3-yosry.ahmed@linux.dev>
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
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
 tools/testing/selftests/kvm/include/x86/vmx.h        |  4 ++--
 tools/testing/selftests/kvm/lib/x86/vmx.c            | 12 ++++++++----
 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 96e2b4c630a9..91916b8aa94b 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -563,8 +563,8 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot);
+void nested_identity_map_default_memslots(struct vmx_pages *vmx,
+					  struct kvm_vm *vm);
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 29b082a58daa..eec33ec63811 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -494,12 +494,16 @@ void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot)
+void nested_identity_map_default_memslots(struct vmx_pages *vmx,
+					  struct kvm_vm *vm)
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
index 98cb6bdab3e6..aab7333aaef0 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,7 +121,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_map_memslot(vmx, vm, 0);
+		nested_identity_map_default_memslots(vmx, vm);
 		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
-- 
2.52.0.158.g65b55ccf14-goog


