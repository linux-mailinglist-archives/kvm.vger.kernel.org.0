Return-Path: <kvm+bounces-64805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D27EC8C90C
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:36:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4AFA44E851D
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3AA524C06A;
	Thu, 27 Nov 2025 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kaNhqMns"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79A23D7C0
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207311; cv=none; b=EZjWdet/HHInuXd4JTV5POP/2vVl0FH0SIjmMKaqficJAzQYHPFr+mTqlwMvLqOrU/zLAWZzvu+48Cgx8xlKre07jttrIzG1SNLvdbor6Sio0fLYdCAjjFm9KVwXYCNc6DRf3bbpzkl7n02lke9bYy7lf1dvryWYPnTOEdQj9hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207311; c=relaxed/simple;
	bh=UV0zQexRvvdY6sr4DDe35YyGuYRdEJphSxkjaenYDhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uowHFi7wwLkksXA/63G2aIAsahfNvbtZbbIu5Oux1ICOMEFpFoCHiUuJ7Eo+xlVi9h9HCWb47BYNTWo0VkGGsk7rI5f6arQRlidQ1gmHH5sd/RDeMYjElw3A6pEtzS9ef1xda7gOJ+pLk9gr6VfsH7gZDyvbOyKCWyScRemnF/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kaNhqMns; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+eMCiC+Ad/t5DRqhycrkMjOhIHljfy9tanTohxdWII=;
	b=kaNhqMnsPU0QxtPij8W3K1dQ2nrF61cQxdUMsFw7HS6H/z40sFAkXa9JeNpteXwD8LUB5Q
	EHM2seIuc9A9Lj8KWDOJqpYDP2tprhCfKv5eqy+s/DekBhvvhM7FakxQDmzh2oGVedLavL
	6TXoVr0QXhEGamKAUzLhLUD3DvP0NbU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 05/16] KVM: selftests: Stop setting AD bits on nested EPTs on creation
Date: Thu, 27 Nov 2025 01:34:29 +0000
Message-ID: <20251127013440.3324671-6-yosry.ahmed@linux.dev>
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
index 85043bb1ec4d..a3e2eae981da 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -432,14 +432,6 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
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
 
 void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-- 
2.52.0.158.g65b55ccf14-goog


