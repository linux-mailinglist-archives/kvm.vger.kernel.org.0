Return-Path: <kvm+bounces-45001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E377EAA57E0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 00:10:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D9999E286B
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD84F22371C;
	Wed, 30 Apr 2025 22:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3hzIGGtx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C65D2236ED
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746050999; cv=none; b=NHSbT5dctDnUp5O4V8C/vMlmpCO+SsPGYph13YotFUeuiNvsI0oG5CtcgNnn/8uzDjvcVIHaQSFSxo51pT/ESBSuWJzjoEqDpy85He+r2RYE5zggxUZjevZlIgmfMqGYqjvXWa6ZJ37NeasE8ipbYyRuF0vTB/Ps/BCEuQ2Ak98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746050999; c=relaxed/simple;
	bh=nt9O3bY8xYpbbY8hLFsXM3ylEbVtCa/AX1l7at7vIZE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BbVED7I9elMKkIESqxL1grwpQiZ+rTq+N4dG1RQPJovHpJo8my1WggUQjH4/6YoFlWR8nBToE37f7PJMsAjBZ32BpAWCLDMVboS4nac3RV5wc5ZX8XTq4uxpHJqlX0Yo43n9KLF9YoJyQeeYLHkwHIqZ0EsgSMkMZzfzMEjG0jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3hzIGGtx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff68033070so298556a91.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 15:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746050997; x=1746655797; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZ/MaCiqXtq7XnMNvwgF7ZXXhu0iWgk2GK4UvEq7z4I=;
        b=3hzIGGtxfnMPznGrqcwm39URy/M2kUhl/DL4S3w3hMMfOmrXxpLy2/nOb8yAST52XC
         bXHyEUUuKx3eUcqRZA6DEyJL1PPHsdtIkL3NIst6cm0C7NI+TM8B71GOEQPiNtHe29u/
         umgeFS8BMXU1tqwN7dyaV+gnmTpXBofN9gDNz0fzQLh8ZUFbAdDZVaRyvnY8jmOKTGIl
         OqlRzXBJoatyFdbDBmMcKZZhPLbtPXuUbakmvLRfHwJ+6H7vKY4qngpMDUzLVDneeMHO
         fHtF40b3eN7shsUGtnpcUW70m7VRV0XL3mSXKhwRRUzWVzp4MA89FP+5VMkvm/klJIvt
         eNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746050997; x=1746655797;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZ/MaCiqXtq7XnMNvwgF7ZXXhu0iWgk2GK4UvEq7z4I=;
        b=ciYfFZC7KqemSvoQvFJlHLipv1A0YTMlQUGDjDRjVFLCMq5QON7tFV8hqjA1T5OnKd
         VPmwZXE0oSWu1gv55ICfHdrJlRkSdKsh09PGJR9R2anLW+5h/GUqPMHMgqqX678/j4Eg
         r0E5cwYSiYqrcc6J+qD4y75G91T7m2JxWT6pscBQkfic4DlnT2ikOT1mEl5xe2gbPwLg
         SdQ48MOnyVZACvNeGneiVkagoPk4CxE7/Oe5fUP3SsZ+VC7t/fdf57jUz7heKMlZ9k9Z
         9Ovgc3J7gyJUZ7sPTptBB71KFL5KdJKSvfauOCY/ibPB+pG5coy7ruaa1u4F8OzaljTO
         OOHQ==
X-Gm-Message-State: AOJu0Yw9eH21dQ+Gh7nMucUtRtfw3eBKu0DTGntIebeyM4NTn3WpVN6a
	Z1qLmv8WjLHXAb0IsfDj8P96oHvA63oe6d1jiE3GyR8Xw32JqeFtHndTfVaYypClLa3cjU5H2uf
	8eQ==
X-Google-Smtp-Source: AGHT+IFDCE4ixEWkqW6JuW3nZKoDOeyTblrj/HS+JgqpSphQzY3xCCE/XlAvFn9djfhRe2sBMtC9+CGBoY4=
X-Received: from pjoo6.prod.google.com ([2002:a17:90b:5826:b0:308:65f7:9f24])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e10:b0:2f8:34df:5652
 with SMTP id 98e67ed59e1d1-30a431b6d57mr94171a91.21.1746050996743; Wed, 30
 Apr 2025 15:09:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Apr 2025 15:09:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <20250430220954.522672-1-seanjc@google.com>
Subject: [PATCH v2] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

When changing memory attributes on a subset of a potential hugepage, add
the hugepage to the invalidation range tracking to prevent installing a
hugepage until the attributes are fully updated.  Like the actual hugepage
tracking updates in kvm_arch_post_set_memory_attributes(), process only
the head and tail pages, as any potential hugepages that are entirely
covered by the range will already be tracked.

Note, only hugepage chunks whose current attributes are NOT mixed need to
be added to the invalidation set, as mixed attributes already prevent
installing a hugepage, and it's perfectly safe to install a smaller
mapping for a gfn whose attributes aren't changing.

Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
Cc: stable@vger.kernel.org
Reported-by: Michael Roth <michael.roth@amd.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Mike, if you haven't arleady, can you rerun your testcase to double check
that adding the "(end + nr_pages) > range->end" check didn't break anything?

v2: Don't add the tail page if its wholly contained by the range whose
    attributes are being modified. [Yan]
v1: https://lore.kernel.org/all/20250426001056.1025157-1-seanjc@google.com

 arch/x86/kvm/mmu/mmu.c | 69 ++++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb1..de7fd6d4b9d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7669,9 +7669,30 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
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
@@ -7686,6 +7707,38 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
+	if (WARN_ON_ONCE(range->end <= range->start))
+		return false;
+
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
+		gfn_t end = gfn_round_for_level(range->end - 1, level);
+		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
+
+		if ((start != range->start || start + nr_pages > range->end) &&
+		    start >= slot->base_gfn &&
+		    start + nr_pages <= slot->base_gfn + slot->npages &&
+		    !hugepage_test_mixed(slot, start, level))
+			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
+
+		if (end == start)
+			continue;
+
+		if ((end + nr_pages) > range->end &&
+		    (end + nr_pages) <= (slot->base_gfn + slot->npages) &&
+		    !hugepage_test_mixed(slot, end, level))
+			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
+	}
+
 	/* Unmap the old attribute page. */
 	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		range->attr_filter = KVM_FILTER_SHARED;
@@ -7695,23 +7748,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
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

base-commit: 2d7124941a273c7233849a7a2bbfbeb7e28f1caa
-- 
2.49.0.906.g1f30a19c02-goog


