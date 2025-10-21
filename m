Return-Path: <kvm+bounces-60632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01972BF51A6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACD9B465A2A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9158C3002B4;
	Tue, 21 Oct 2025 07:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xw8zX8XW"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFEC2FC899
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032946; cv=none; b=ezbt1bOhkXxjemzeKe1tiCpeavYDtfq8toltpk6zIUC9RxFoYKpWRSQQA53vFkeWLK6yGkzFC++UlzzDqYfZGLZTi+m4RWGiOJWJ7zPaEN42dWDpnsY8lh5lUNrfshiPWYI8tv9mnZs6QYFNtc7yGBQ9joVduteOVzcUXU6Dqvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032946; c=relaxed/simple;
	bh=mimdIqws80HVOxm1yhhjm6Tqchksppfs/5CQtKjZHfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7xZEO20TOR+MAW2pp9DXaoFQXwJiRe9uG9fBTZZ3mbe78fXjiH3uJQXIrIlzvzNOJA0szSblY9Xo41Mp3SlEG/s740ysp7s1DoSVCVd8TRdhqwe1yDT3YHrUY+svaNwzjlI1SI57cKxIRsGkxAB29b3o3Nww4wOdcg2wncQwKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xw8zX8XW; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWFxHvuiWBriikDXhyh4DbqYsyF3B7/uazdqjEeTciM=;
	b=xw8zX8XWnCvg/+H+ajgh04dOBKzFTNGN2r2FVXLaYgqrAuF7PkWi1T0UimFIhGlBxnaYJl
	C62c7t48pgCtJDtnpo9QPOyeXnWu/zgEvGH++X0g8eBnK/UueXZIuhcs7380lrVF9hvgsg
	FV8Oisoa6bEhWcIKSWrNofNBkVjjIlc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 22/23] KVM: selftests: Set the user bit on nested MMU PTEs
Date: Tue, 21 Oct 2025 07:47:35 +0000
Message-ID: <20251021074736.1324328-23-yosry.ahmed@linux.dev>
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

Similar to KVM's shadow MMU (in most cases), set the user bit on nested
PTEs. This is in preparation for supporting NPT mappings, which require
the user bit to be set. This should be nop for VMX.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 958389ec1722d..c2912b0a49e90 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -211,7 +211,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	paddr = vm_untag_gpa(vm, paddr);
 
 	if (!(*pte & masks->present)) {
-		*pte = masks->present | masks->writeable | masks->x;
+		*pte = masks->present | masks->writeable | masks->x | masks->user;
 		if (current_level == target_level)
 			*pte |= masks->large | (paddr & PHYSICAL_PAGE_MASK);
 		else
@@ -276,7 +276,7 @@ void __virt_pg_map(struct kvm_vm *vm, vm_paddr_t root_gpa, uint64_t vaddr,
 	pte = virt_get_pte(vm, root_gpa, pte, vaddr, PG_LEVEL_4K, masks);
 	TEST_ASSERT(!(*pte & masks->present),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = masks->present | masks->writeable | masks->x
+	*pte = masks->present | masks->writeable | masks->x | masks->user
 		| (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
-- 
2.51.0.869.ge66316f041-goog


