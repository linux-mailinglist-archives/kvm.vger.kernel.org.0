Return-Path: <kvm+bounces-60625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB2BBF518B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0D9094F3975
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFD62EFDA1;
	Tue, 21 Oct 2025 07:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PT0kTIbx"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB592C1597
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032935; cv=none; b=ogUJ1iMYFPjdiYHqDdHR3v/LcGfOoJSI4i8gGOy2RjT2OV9DNz6OwhJrzqsUT2XizcIMVvRjNFlIs30kdcQu4FTmSI2yXPBFvR14L72A98vs+TToTeW/sAouQcB/VI2YiFfnzpt095BmSGLeob75+yIZI2r2aY6Ce+1y1cI+HVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032935; c=relaxed/simple;
	bh=SwNsXp43um/5RC1PXrP7VWZL9LnkBMIw/GJ0R1/QAeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1Bn8FNHh3Eh+fXQdl446twrZRzsI4NHC2h7mb/bB181ReY2ux8E5ci6L4FayXO7Vpa7R1PEhTY+pfNkVcHL2rWjwGZCnwLiqyAZf0Vit5HepYshUU/e2PaI1borySGgQO+0zBrPR4Kbjs5eCW3K0Y82bROtY45bqSK9rTMQKjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PT0kTIbx; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWmuFaMQlvpdbpcMMh0PPPyyBRYXR+jWxqqcg/LAa98=;
	b=PT0kTIbxDrlqm/jZQ4eGIFs+XlyS2q3Moa1J+k0H2D/KmDjNN/eOpKYCXUpLAA8GpFgbrC
	sLK0pzMzkUr0UeDBa0daD57egd8NZwnCQg7OAEsWzAKU8yQ5U53eIxiohYBmzWsiMoHo5O
	7YghpLPzIFx+4f5McHAq2dJfjRhzyIE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 15/23] KVM: selftests: Stop setting AD bits on nested EPTs on creation
Date: Tue, 21 Oct 2025 07:47:28 +0000
Message-ID: <20251021074736.1324328-16-yosry.ahmed@linux.dev>
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

When new nested EPTs are created, the AD bits are set. This was
introduced by commit 094444204570 ("selftests: kvm: add test for dirty
logging inside nested guests"), which introduced vmx_dirty_log_test.

It's unclear why that was needed at the time, but regardless, the test
seems to pass without them so probably no longer needed.
dirty_log_perf_test (with -n to run in L2) also passes, and these are
the only tests currently using nested EPT mappings.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index f0023a3b0137e..36e60016fa7b2 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -436,14 +436,6 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
 		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
 	}
-
-	/*
-	 * For now mark these as accessed and dirty because the only
-	 * testcase we have needs that.  Can be reconsidered later.
-	 */
-	pte->accessed = true;
-	pte->dirty = true;
-
 }
 
 void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-- 
2.51.0.869.ge66316f041-goog


