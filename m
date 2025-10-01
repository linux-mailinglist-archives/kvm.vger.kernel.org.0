Return-Path: <kvm+bounces-59311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F120BBB0F1C
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD8D14C5D7E
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0591230DD32;
	Wed,  1 Oct 2025 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jiLgnmFd"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1CA30CB26
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330739; cv=none; b=a/VfSmiKQeQUgysJKfdEoawRjU5EPdvUWVoXGhMqSOJrIyQhkaIcZC2v1IEHj0dh2jL8ASP5F6zqrFiBDrLyFebkFcFynvSzA7JQ7bd+BX20wOpHYNIO6+3++pKsNGub/GPmhRP6i0IDi0WmhhgDM4/ufV8czrG345mLpyQxH3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330739; c=relaxed/simple;
	bh=ZTJmiiqWLF+y1Q/GfcH8oyakTOF9fQGNWmPwrUbydkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNVX7AT9Ee91gERjgTgDSqNSfKxN/aBnuEOkW8mIL6AV+hLpQ6K8abwzuwkEO4pD/deK7+hj4QsEiTg8CqFKoCmpdQBMBDQRN1JrhGoiC6wZsFwQn9jbAwP/jH12UiIHY92nrAMQDFRos4aDvpDELSyq3yRlFqSigKIj6JbhhzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jiLgnmFd; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=snKvlr6OPxDH7X56qF+PKa57E0gslaeWbzsu8swX4+Q=;
	b=jiLgnmFdkLDz60zGIOOG64drX8YhhbA/c56BH4vZJD21NIou0HIapJjv/42xDbby7yQO+j
	qyxHj8jaZcz3pNzpTCcOSRmRwPCDKCjUs4Zcd9J0pzaAHQnRPcZv07nLcv3wsCrzZkvVM4
	U4O+hCdoSr5zg26+wtoAImaEEfCaxzQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 09/12] KVM: selftests: Move all PTE accesses into nested_create_pte()
Date: Wed,  1 Oct 2025 14:58:13 +0000
Message-ID: <20251001145816.1414855-10-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

In preparation for making the nested mapping functions work for NPT,
move all logic that directly accesses the PTE into nested_create_pte(),
as these accesses will be different for SVM.

Stop using struct eptPageTableEntry in the caller, instead pass a
uint64_t pointer (and add an assertion on the size to make sure it stays
correct).

Calculate whether or not an EPT entry is a leaf in __nested_pg_map(),
and return the address from nested_create_pte() to __nested_pg_map().
Also, set the access and dirty bits in nested_create_pte() for leaf
entries. This matches the current behavior and removes all direct
accesses to the EPT entry from __nested_pg_map().

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 69 +++++++++++++----------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 673756b27e903..b0e6267eac806 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -33,6 +33,7 @@ struct eptPageTableEntry {
 	uint64_t ignored_62_52:11;
 	uint64_t suppress_ve:1;
 };
+kvm_static_assert(sizeof(struct eptPageTableEntry) == sizeof(uint64_t));
 
 struct eptPageTablePointer {
 	uint64_t memory_type:3;
@@ -42,6 +43,8 @@ struct eptPageTablePointer {
 	uint64_t address:40;
 	uint64_t reserved_63_52:12;
 };
+kvm_static_assert(sizeof(struct eptPageTablePointer) == sizeof(uint64_t));
+
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
 	uint16_t evmcs_ver;
@@ -362,35 +365,46 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-static void nested_create_pte(struct kvm_vm *vm,
-			      struct eptPageTableEntry *pte,
-			      uint64_t nested_paddr,
-			      uint64_t paddr,
-			      int current_level,
-			      int target_level)
+static uint64_t nested_create_pte(struct kvm_vm *vm,
+				  uint64_t *pte,
+				  uint64_t nested_paddr,
+				  uint64_t paddr,
+				  int level,
+				  bool leaf)
 {
-	if (!pte->readable) {
-		pte->writable = true;
-		pte->readable = true;
-		pte->executable = true;
-		pte->page_size = (current_level == target_level);
-		if (pte->page_size)
-			pte->address = paddr >> vm->page_shift;
+	struct eptPageTableEntry *epte = (struct eptPageTableEntry *)pte;
+
+	if (!epte->readable) {
+		epte->writable = true;
+		epte->readable = true;
+		epte->executable = true;
+		epte->page_size = leaf;
+
+		if (leaf)
+			epte->address = paddr >> vm->page_shift;
 		else
-			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
+			epte->address = vm_alloc_page_table(vm) >> vm->page_shift;
+
+		/*
+		 * For now mark these as accessed and dirty because the only
+		 * testcase we have needs that.  Can be reconsidered later.
+		 */
+		epte->accessed = leaf;
+		epte->dirty = leaf;
 	} else {
 		/*
 		 * Entry already present.  Assert that the caller doesn't want a
 		 * leaf entry at this level, and that there isn't a leaf entry
 		 * at this level.
 		 */
-		TEST_ASSERT(current_level != target_level,
+		TEST_ASSERT(!leaf,
 			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
-			    current_level, nested_paddr);
-		TEST_ASSERT(!pte->page_size,
+			    level, nested_paddr);
+		TEST_ASSERT(!epte->page_size,
 			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
-			    current_level, nested_paddr);
+			    level, nested_paddr);
 	}
+	return epte->address;
 }
 
 
@@ -398,8 +412,9 @@ void __nested_pg_map(void *root_hva, struct kvm_vm *vm,
 		     uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	struct eptPageTableEntry *pt = root_hva, *pte;
-	uint16_t index;
+	uint64_t *pt = root_hva, *pte;
+	uint16_t index, address;
+	bool leaf;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -427,22 +442,16 @@ void __nested_pg_map(void *root_hva, struct kvm_vm *vm,
 	for (int level = PG_LEVEL_512G; level >= PG_LEVEL_4K; level--) {
 		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 		pte = &pt[index];
+		leaf = (level == target_level);
 
-		nested_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
+		address = nested_create_pte(vm, pte, nested_paddr, paddr, level, leaf);
 
-		if (pte->page_size)
+		if (leaf)
 			break;
 
-		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
+		pt = addr_gpa2hva(vm, address * vm->page_size);
 	}
 
-	/*
-	 * For now mark these as accessed and dirty because the only
-	 * testcase we have needs that.  Can be reconsidered later.
-	 */
-	pte->accessed = true;
-	pte->dirty = true;
-
 }
 
 void nested_pg_map(void *root_hva, struct kvm_vm *vm,
-- 
2.51.0.618.g983fd99d29-goog


