Return-Path: <kvm+bounces-64801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD53C8C8EE
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1291B345D94
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C775B221578;
	Thu, 27 Nov 2025 01:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iobWqrUf"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514211E1E16
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207304; cv=none; b=ANEk5+o1XFHk7/I5+aADkj5QmSjbq9N79RTC89PwpeuTqLFGq8hFa7osA5nZhUBn+EQ0fUqsLG5Scn4pr7S1aZSgbLu63p+8qFEV5Pf4WKlmEe0GG3MjJTj6PZLNfFm5T7Ndhy37n+V6COFlpdjXrI1LQIL7sQE+yYM6pOkJKXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207304; c=relaxed/simple;
	bh=8dSwIsMf5WkZ+GB47q/HjDY4MVtZOBN0iPzHxaa8MB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNWW1yBTQf8nNM0NRO5rhaN4Q1rB3HXz4yKFJ9syKpBt5Dx9uJgVzD4hLhlRlkcl8s3HX2+QlxVyZYQDRfEPrpy0csMyBFfMIUVtLjxgAfm4mJzNWGmmvBT/zRiMuiDb26q2S2tUvxuC2nTd37Pphrg4Tf0pfMiiiId9hkgASwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iobWqrUf; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kgL39qdbTnUxdJP/NSbd0jALF1Kl9kFpUI0uKGh2kK0=;
	b=iobWqrUfhNMTYtVgI+psJKay/AbEG7uSqkZPrQiBLifDsO1wGIu7Ol6R5AB2o90ZNityDU
	GG23b3J9OhUbS5OdEA/rbMVKW2Ic0tE8AjjMKR3jdru1zrBpZ46ilK4y6rOABnve9binZW
	muan9ZZVixPOjDbEvZH4zP2gs441tp0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 01/16] KVM: selftests: Make __vm_get_page_table_entry() static
Date: Thu, 27 Nov 2025 01:34:25 +0000
Message-ID: <20251127013440.3324671-2-yosry.ahmed@linux.dev>
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

The function is only used in processor.c, drop the declaration in
processor.h and make it static.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 2 --
 tools/testing/selftests/kvm/lib/x86/processor.c     | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 57d62a425109..c00c0fbe62cd 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1367,8 +1367,6 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 36104d27f3d9..c14bf2b5f28f 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -306,8 +306,8 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level)
+static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+					   int *level)
 {
 	int va_width = 12 + (vm->pgtable_levels) * 9;
 	uint64_t *pte = &vm->pgd;
-- 
2.52.0.158.g65b55ccf14-goog


