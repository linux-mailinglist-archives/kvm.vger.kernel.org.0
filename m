Return-Path: <kvm+bounces-42060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CFBA71F63
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 659D83BED02
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB278266B7C;
	Wed, 26 Mar 2025 19:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MIw/qhfM"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C319266B4B
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017843; cv=none; b=olTheUYoV2tbn+zQZBn4xcWU5+pWU1hzEDRbWM7q07L7OJ2EuzAfmgnuPPTcy04PdGIo9iKfeQp1o6RZATHCXn+FSepcUCE6sJvFkJGYO//YS+Hv3iCPjZ5yMsj4nGcxhq+mEbiUFaCke8dA+xr932Oe8+E7mG9loseAfBcMjLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017843; c=relaxed/simple;
	bh=d7XKnzf7k+8xqNZ9Bff2cPjyaNDlmTtBgLKVxfUqY8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSpYP8LAAIgVxSWUgaWt5QmuerqJfAMB99+sWxP3obu2kgU0dJvw4cM0RwAFtG8/q9JKjEDv90CwJbzvgeMFzNWHYycybAtcSJqIM6wms1wCyGw7TYOEXHhTBn1HJG0fIMHeBS4E4fDRL0zl2c14fJZ7xSfue7amoisGzsJuXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MIw/qhfM; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N/bYfP9s28hzwaYbP0WnCcH/qj/69pzWGJhEEE0MPjU=;
	b=MIw/qhfMA+UrfL6ngMc3lzJmRv1NfzQffcrnUm/TpR0QsDbCMNYa8Le623K1l4trJ7xpmc
	9JluCEFA6Ei23BIdhOLQ2TPBqKtv+YiM6sFV0xeO6vzY0PMUaz6mLrA804m3Wt/tvTK3m4
	d2qSRthUOiCTJfqMFT1hU48ITzGJKF4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 15/24] KVM: x86/mmu: rename __kvm_mmu_invalidate_addr()
Date: Wed, 26 Mar 2025 19:36:10 +0000
Message-ID: <20250326193619.3714986-16-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In preparation for creating another helper for
kvm_mmu_invalidate_addr(), rename __kvm_mmu_invalidate_addr() to
kvm_mmu_invalidate_addr_in_root().

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/mmu/mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb16..4a72ada0a7585 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6317,8 +6317,9 @@ void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_print_sptes);
 
-static void __kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-				      u64 addr, hpa_t root_hpa)
+static void kvm_mmu_invalidate_addr_in_root(struct kvm_vcpu *vcpu,
+					    struct kvm_mmu *mmu,
+					    u64 addr, hpa_t root_hpa)
 {
 	struct kvm_shadow_walk_iterator iterator;
 
@@ -6374,11 +6375,11 @@ void kvm_mmu_invalidate_addr(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		return;
 
 	if (roots & KVM_MMU_ROOT_CURRENT)
-		__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->root.hpa);
+		kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->root.hpa);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
-			__kvm_mmu_invalidate_addr(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
+			kvm_mmu_invalidate_addr_in_root(vcpu, mmu, addr, mmu->prev_roots[i].hpa);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_addr);
-- 
2.49.0.395.g12beb8f557-goog


