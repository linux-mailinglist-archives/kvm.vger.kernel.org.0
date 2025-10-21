Return-Path: <kvm+bounces-60621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B8C5FBF5168
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E23A54FFA96
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5442D781B;
	Tue, 21 Oct 2025 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aHJJEj4Z"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F56B28D83F
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032929; cv=none; b=E+fxBOzH6CwompQGfY5bZAiHr37/IVLVYZlTHH2f2QHnqCbdsiWk+GFozBgCHiggh0+yZCT7d49Wm6Dc9Td1/To0iF/WYGj0l9yfsC/XKmYY9bmWQ/QgLIgQSOJmElX+JHc7eA7jN4Ov1phfFOtXcvGw/o6idAxXVGrtacAnCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032929; c=relaxed/simple;
	bh=FLiWL509+4paNkCe21c7zaoLHTKMIsFRWgJVt7RlyDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6VNfQiVSiWHrsiSrNjTvDeGDZAyGXX7VOCVoSStJFI3ib8WKgN+8JY/t85/2AutOiYJmIJNaOrVh2oHO9h+7wbzn2QgVfERWJHhqWc6Lm4lVB83HgYkNDn62PKXKzzygCtbcQfIM6KkKHqvKsmBuedfTlnI+s60U4q7EOS+FpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aHJJEj4Z; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qbz6uq0EIDXItWBuGg+PhUHYj6uMZIfd2BYBGlaVWhA=;
	b=aHJJEj4Z9951a21mv9O0n4egRuBSYHDMcM0eAvZgbExbn3RNY6Rrqk6YU6TPL8rmPvUGMC
	nCkn7+5/dNX4DOzRLXU+b8ZQ91E3gVUNHMJEiN/yZW6bPNPeUP4wFQRMFcPklgCaTncqkh
	aeRGCLt74ewg6fqzMnkrau7w0vOIaBE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 11/23] KVM: selftests: Make sure vm->vpages_mapped is always up-to-date
Date: Tue, 21 Oct 2025 07:47:24 +0000
Message-ID: <20251021074736.1324328-12-yosry.ahmed@linux.dev>
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

Call paths leading to __virt_pg_map() are currently:
(a) virt_pg_map() -> virt_arch_pg_map() -> __virt_pg_map()
(b) virt_map_level() -> __virt_pg_map()

For (a), calls to virt_pg_map() from kvm_util.c make sure they update
vm->vpages_mapped, but other callers do not. Move the sparsebit_set()
call into virt_pg_map() to make sure all callers are captured.

For (b), call sparsebit_set_num() from virt_map_level().

It's tempting to have a single the call inside __virt_pg_map(), however:
- The call path in (a) is not x86-specific, while (b) is. Moving the
  call into __virt_pg_map() would require doing something similar for
  other archs implementing virt_pg_map().

- Incoming changes will reusue __virt_pg_map() for nested PTEs, which
  should not update vm->vpages_mapped. This means we'd need to break out
  a triple underscore version that does not update vm->vpages_mapped.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/kvm_util.h  | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c      | 3 ---
 tools/testing/selftests/kvm/lib/x86/processor.c | 2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bcbcfb4deb9a2..15c69af11a684 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1206,6 +1206,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
 static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	virt_arch_pg_map(vm, vaddr, paddr);
+	sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
 }
 
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 5e6b51768f67f..473c533774898 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1490,8 +1490,6 @@ static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
 		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
 
 		virt_pg_map(vm, vaddr, paddr);
-
-		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
 	}
 
 	return vaddr_start;
@@ -1605,7 +1603,6 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	while (npages--) {
 		virt_pg_map(vm, vaddr, paddr);
-		sparsebit_set(vm->vpages_mapped, vaddr >> vm->page_shift);
 
 		vaddr += page_size;
 		paddr += page_size;
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index c484e83255c70..4ee9fc844ee66 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -285,6 +285,8 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 	for (i = 0; i < nr_pages; i++) {
 		__virt_pg_map(vm, vaddr, paddr, level);
+		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
+				  nr_bytes / PAGE_SIZE);
 
 		vaddr += pg_size;
 		paddr += pg_size;
-- 
2.51.0.869.ge66316f041-goog


