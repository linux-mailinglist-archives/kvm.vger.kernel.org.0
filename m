Return-Path: <kvm+bounces-59310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DBD4BB0E9E
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B4D6A4E2D59
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1083F30CD99;
	Wed,  1 Oct 2025 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l4eiNaMK"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE2F30C0E3
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330737; cv=none; b=XY3T5ZPq2ktZ6rWyNYowlKSV+LK7KMFfnpMpX/TwLkqYZ5ZSz5bRptLaep3wtcafTk/8CeAIhvaXnTarHSaeLAU9gDNnsBaZUpATl88vXCwwInlJx8HCr4aZFZEo9TUBcE8aNynGprvFw+hheDFBmv5LZZ9EIBmY78SPv23/H14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330737; c=relaxed/simple;
	bh=mbOhnxuG8ulswfPMlF0N9ZTEVLzFWKgBEB2IUkzLVlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpPqcF9WoqPdoW3kpWgu4Z2cFw5/Lht8EQ8GiOpc+yYR1OJ48IcLhZxsZsBWu0714B/a+IwgLgCewgcm9VudFG6zb3LVglVNqClyR0i3not3hXyXQuCXRUBS2po9eRyoSakvgZizl5UNb28ZAtuEMPZhaaFkSseydc69lSdPiIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l4eiNaMK; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNK27Cs7fKo0r1Ea9VAB8EPPFw2zlK9HqEAKfMAfOo0=;
	b=l4eiNaMK6iUmhJHj7eLOZwGAtlj1AC4SL0RZ6zu/t2ZAjdfz03JSgGho/xxOZaOQ1j8ccz
	OcXSNQOIylmqKqmEHOahH/w2QUyUt8gPcckuuyavqaqnRYf7wpp5/nDwGq376Jv+G3Fou4
	ZP1lTqm4uGBMJCfZYeY3b300Z4zM5JI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 08/12] KVM: selftests: Use 'leaf' instead of hugepage to describe EPT entries
Date: Wed,  1 Oct 2025 14:58:12 +0000
Message-ID: <20251001145816.1414855-9-yosry.ahmed@linux.dev>
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

The assertions use 'hugepage' to describe a terminal EPT entry, but
'leaf' is more accruate as a PG_LEVEL_4K EPT entry is a leaf but not a
hugepage. The distincion will be useful in coming changes that will pass
the value around and 'leaf' is clearer than hugepage or page_size.

Leave the EPT bit named page_size to keep it conforming to the manual.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 04c4b97bcd1e7..673756b27e903 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -380,15 +380,15 @@ static void nested_create_pte(struct kvm_vm *vm,
 			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
 	} else {
 		/*
-		 * Entry already present.  Assert that the caller doesn't want
-		 * a hugepage at this level, and that there isn't a hugepage at
-		 * this level.
+		 * Entry already present.  Assert that the caller doesn't want a
+		 * leaf entry at this level, and that there isn't a leaf entry
+		 * at this level.
 		 */
 		TEST_ASSERT(current_level != target_level,
-			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx",
+			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
 			    current_level, nested_paddr);
 		TEST_ASSERT(!pte->page_size,
-			    "Cannot create page table at level: %u, nested_paddr: 0x%lx",
+			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
 			    current_level, nested_paddr);
 	}
 }
-- 
2.51.0.618.g983fd99d29-goog


