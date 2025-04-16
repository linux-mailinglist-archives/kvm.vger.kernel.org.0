Return-Path: <kvm+bounces-43473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AF89A90692
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DD033A46B5
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 14:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F98F1C860C;
	Wed, 16 Apr 2025 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UzuU9zEV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258443010C
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744814084; cv=none; b=h55RiTLW1oXpWYzyOO7YW8uEx33i46tFnn0W+Cd+HAJxJ69+BHAr8Xy3aFgovKzOnL3ZfPHv9oO4iQB8m3vCfvuh98wYdhcdP/jc4WnolH3ePKLOxNM64KzQxMrbvZ4pXcCUSk10eRT3X8kOTMe5/iVA38tXaj6ZU2yZs0CDq+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744814084; c=relaxed/simple;
	bh=k2CR0YFn0H7n5JGd+iWTlPPq3nkjRM5X0+Mv2/b06i0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=P+XHN3gVpDnyyVZSO3C6D3L+0cfstZyqBOLoFU1ecg63ID+xvbdcnAeZl9zm2BUFqzOQcoXT84wJ/ZIfQFl0fPXrUjYuJ9EA3O5hlr5l/ecttX73718BIz592WYhH8PQrxl9E8G5bOvuVn7tBRoRGi8D8xLG4TPG7SgTfSNk6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UzuU9zEV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2265a09dbfcso98031285ad.0
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 07:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744814082; x=1745418882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gcJVjvc5AD4AZu0r0LS3aEnjjlqRCrPZoyf6cQqINRE=;
        b=UzuU9zEVN2uIwfOpPSFbYIKXXnee8oYPuZtZTGyqnkPI6mTAKz9ZbWk/nFVlviQz7N
         56F7hpfoJVPgcnkoklLgg0gUcUV0w4Gi6t0CddvXwsQcI/3p4xhUOFUnOHc+UHEhcC4J
         +/wB8wkbR3MC13o/tqDQndtyFj4LqWo2kr+wfwjBjNiNL/KWrACMBPah13WAQSZRuZM1
         IIvpO+kTK+E6WJ8KrwVLcFelKoIssmx8LtIgl0tHPsnbRzN7a/ytpwEcryo9SBB1367q
         8We74wKdUj6VDiOmj77RaLcPoD9wP/iKm30AZC4YrdcuJVxIHVzFzljKotmJ/Fn+TyHC
         51Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744814082; x=1745418882;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gcJVjvc5AD4AZu0r0LS3aEnjjlqRCrPZoyf6cQqINRE=;
        b=hAfF0IpYHHYAHSgNvA+zHBrLI7CY7ApqTsX+V31FUEvJmzyM94Mvh5IMCFiMVZZGSG
         H6mIVkSbZPmrqcol3vuJ1vOAgcsxomrLL9rDYujs0SBmPyJ5i8HQUHyc1AkG7CSUrSTP
         INU1GaRSOqn2oZmlEurBweXhYc6QN8VFcZX6HVAJl71F4EQnEQY/RHDqInTUkof/sggs
         ztx1wjI0vf8isIptJJ7LKlk+6h4PACE3dMuxza1TMwSKVffyHL3b2ZDZwOrSAaB921H4
         UUChu1TTbA7oIJXRlIRs95KVB+MUzhiAPEZw3hL1qKRNMEOkT2NMxfA9zFqzsFxSXPrH
         CrPQ==
X-Gm-Message-State: AOJu0YzFBtSmgTmXSm6il5WOzgOi63aqlWmqmiKAEe7VnWNoVCP7taSE
	ed+I+taWow/XiRxjbc5Djc7E1IgtiFjxYQ4SBGNn7jN8d/8kPGnLecD/avJSeYKB9tu8rfJjWjG
	uGQ==
X-Google-Smtp-Source: AGHT+IFgrVEH6XLNnSnDhVRVRVlNo+jyxyvHaipg1vVyh2nUaFljBiKn6CYvZz3wWQ9oSIB0ICfnJ4EJAbI=
X-Received: from plle4.prod.google.com ([2002:a17:903:1664:b0:223:4fa3:bcbd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1109:b0:224:192a:9154
 with SMTP id d9443c01a7336-22c35918edfmr35841905ad.26.1744814082401; Wed, 16
 Apr 2025 07:34:42 -0700 (PDT)
Date: Wed, 16 Apr 2025 14:34:40 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <Z__AAB_EFxGFEjDR@google.com>
Subject: Untested fix for attributes vs. hugepage race
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Mike, can you give this a shot and see if it fixes the race where KVM installs a
hugepage mapping when the memory attributes of a subset of the hugepage are
changing?

Compile tested only.

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 16 Apr 2025 07:18:19 -0700
Subject: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing

When changing memory attributes on a subset of a potential hugepage, add
the hugepage to the invalidation range tracking to prevent installing a
hugepage until the attributes are fully updated.  Like the actual hugepage
tracking updates in kvm_arch_post_set_memory_attributes(), process only
the head and tail pages, as any potential hugepages that are entirely
covered by the range will already be tracked.

Note, only hugepage chunks whose current attributes are NOT mixed need to
be added to the invalidation set, as mixed attributes already prevent
installing a hugepage, and it's perfectly safe to installing a smaller
mapping for a gfn whose attributes aren't changing.

Reported-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 63 +++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a284dce227a0..b324991a0f99 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7670,9 +7670,30 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+				int level)
+{
+	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
+}
+
+static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+				 int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
+}
+
+static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+			       int level)
+{
+	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
+}
+
 bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range)
 {
+	struct kvm_memory_slot *slot = range->slot;
+	int level;
+
 	/*
 	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
 	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
@@ -7687,6 +7708,32 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	/*
+	 * If the head and tail pages of the range currently allow a hugepage,
+	 * i.e. reside fully in the slot and don't have mixed attributes, then
+	 * add each corresponding hugepage range to the ongoing invalidation,
+	 * e.g. to prevent KVM from creating a hugepage in response to a fault
+	 * for a gfn whose attributes aren't changing.  Note, only the range
+	 * of gfns whose attributes are being modified needs to be explicitly
+	 * unmapped, as that will unmap any existing hugepages.
+	 */
+	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
+		gfn_t start = gfn_round_for_level(range->start, level);
+		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
+		gfn_t end = gfn_round_for_level(range->end, level);
+
+		if ((start != range->start || start + nr_pages > range->end) &&
+		    start >= slot->base_gfn &&
+		    start + nr_pages <= slot->base_gfn + slot->npages &&
+		    !hugepage_test_mixed(slot, start, level))
+			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
+
+		if (end < range->end &&
+		    (end + nr_pages) <= (slot->base_gfn + slot->npages) &&
+		    !hugepage_test_mixed(slot, end, level))
+			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
+	}
+
 	/* Unmap the old attribute page. */
 	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		range->attr_filter = KVM_FILTER_SHARED;
@@ -7696,23 +7743,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
-static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				int level)
-{
-	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
-}
 
-static void hugepage_clear_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				 int level)
-{
-	lpage_info_slot(gfn, slot, level)->disallow_lpage &= ~KVM_LPAGE_MIXED_FLAG;
-}
-
-static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-			       int level)
-{
-	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
-}
 
 static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 			       gfn_t gfn, int level, unsigned long attrs)

base-commit: fd02aa45bda6d2f2fedcab70e828867332ef7e1c
-- 


