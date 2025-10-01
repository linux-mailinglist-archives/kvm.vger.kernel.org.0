Return-Path: <kvm+bounces-59312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 688B3BB0EE6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE195189324E
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C4F30DD3B;
	Wed,  1 Oct 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BveAUWQG"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8752130DD1B
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330741; cv=none; b=g/ORupK1XvCUyHN0yEeZJ8oqmsKpk3QTQSKTNz/j+YXxx/K/VM6Q36lxxonH8eCJgUwzkxJ9Cf0OvD24ioRnhy7d3iCq03dNZ6zHP6ETsLlvzhnIRYz60vLAO3Y5YcuDod6tjxSbjReUx1m1QDCvoJDq5AJTvljfLBOfCCgHpnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330741; c=relaxed/simple;
	bh=ThlnxXJnBzPguOtYLCHF06DSVYgTHIi41nnNBzqrW0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9P1tzCt6U3hjukFcF87UB/XzG8ps9OEW/HKN/6y9dcGoCPEb6KZfc2NrLP3bM0AT+apjG1Qx1dchjVsA2Xw96HVJ0427YFGbCsQAaV+B8e/4UftNKo+VH+SSBYjPM2yYRv3ynFUrOz9trWCUi52KT07nXdOqYjlEsp5Xh22iig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BveAUWQG; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TQv4BWEKXzFdMwpyunqs9lX/Regx9S1cRjNZtX+om4M=;
	b=BveAUWQG1NY93jMjPhQYH2Qlm28DnNa78EPzh2GnhhBD3yfioVR4wuXpb4fH8X0NQBkg1i
	t9wEHvYsubJWeVgZU+5TojhiB6QjpgjlovyCaMJxTgHVcEOss0zGEbRh/Q7DqFM7Opdbo8
	D2UFRL/4l+3ub/tWY0I9uIUxHy/ACrc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 10/12] KVM: selftests: Move EPT-specific init outside nested_create_pte()
Date: Wed,  1 Oct 2025 14:58:14 +0000
Message-ID: <20251001145816.1414855-11-yosry.ahmed@linux.dev>
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

Refactor the EPT specific initialization into nested_ept_create_pte(),
in preparation for making nested_create_pte() NPT-friendly.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/vmx.c | 71 ++++++++++++++---------
 1 file changed, 43 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index b0e6267eac806..eeacf42bf30b1 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -365,46 +365,61 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
+static bool nested_ept_create_pte(struct kvm_vm *vm,
+				  uint64_t *pte,
+				  uint64_t paddr,
+				  uint64_t *address,
+				  bool *leaf)
+{
+	struct eptPageTableEntry *epte = (struct eptPageTableEntry *)pte;
+
+	/* PTE already exists? */
+	if (epte->readable) {
+		*leaf = epte->page_size;
+		*address = epte->address;
+		return false;
+	}
+
+	epte->writable = true;
+	epte->readable = true;
+	epte->executable = true;
+	epte->page_size = *leaf;
+
+	if (*leaf)
+		epte->address = paddr >> vm->page_shift;
+	else
+		epte->address = vm_alloc_page_table(vm) >> vm->page_shift;
+
+	*address = epte->address;
+
+	/*
+	 * For now mark these as accessed and dirty because the only
+	 * testcase we have needs that.  Can be reconsidered later.
+	 */
+	epte->accessed = *leaf;
+	epte->dirty = *leaf;
+	return true;
+}
+
 static uint64_t nested_create_pte(struct kvm_vm *vm,
 				  uint64_t *pte,
 				  uint64_t nested_paddr,
 				  uint64_t paddr,
 				  int level,
-				  bool leaf)
+				  bool want_leaf)
 {
-	struct eptPageTableEntry *epte = (struct eptPageTableEntry *)pte;
-
-	if (!epte->readable) {
-		epte->writable = true;
-		epte->readable = true;
-		epte->executable = true;
-		epte->page_size = leaf;
+	bool leaf = want_leaf;
+	uint64_t address;
 
-		if (leaf)
-			epte->address = paddr >> vm->page_shift;
-		else
-			epte->address = vm_alloc_page_table(vm) >> vm->page_shift;
-
-		/*
-		 * For now mark these as accessed and dirty because the only
-		 * testcase we have needs that.  Can be reconsidered later.
-		 */
-		epte->accessed = leaf;
-		epte->dirty = leaf;
-	} else {
-		/*
-		 * Entry already present.  Assert that the caller doesn't want a
-		 * leaf entry at this level, and that there isn't a leaf entry
-		 * at this level.
-		 */
-		TEST_ASSERT(!leaf,
+	if (!nested_ept_create_pte(vm, pte, paddr, &address, &leaf)) {
+		TEST_ASSERT(!want_leaf,
 			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
 			    level, nested_paddr);
-		TEST_ASSERT(!epte->page_size,
+		TEST_ASSERT(!leaf,
 			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
 			    level, nested_paddr);
 	}
-	return epte->address;
+	return address;
 }
 
 
-- 
2.51.0.618.g983fd99d29-goog


