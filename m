Return-Path: <kvm+bounces-44383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC3FA9D69B
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 02:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE7543B6736
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E14218DB0D;
	Sat, 26 Apr 2025 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rv/fpouL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A052018787A
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 00:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745626261; cv=none; b=FXE9Vbutr/MuagP4s46G+4pjexBexouWCy8ZHgfsQCJTjw73gc+cyPgy2cFAxv0DDLNVnUL8PRRJ+3MYJA9OaNIfaIEcL+51o7PoPmtXzPoTtdJZgiYx9UI/xV+paIm5k73T/47MUqyilTC6o8Pxx4+/aNt/+JRYszka4/z6moU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745626261; c=relaxed/simple;
	bh=Avelv97rIb7+XDqbtGCU1l8O1wt5sW1oyTruiq/tt3E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=T+waUtQdLTdC9pTKnecViUocYzihEr13G/Of6aOPHYV2IIl5lMpciOCGbQM1v4PlxUz3A8LSl9/piLzNU3QeAavnVWB5cuG8gEKohpRBYmT5gPmzSoC5YWCxk6WlPmMN033wSVY/mcIK4NqZs7QoTlv8j2VrhJi9wIFEWIfJ3sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rv/fpouL; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso2588937a91.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 17:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745626259; x=1746231059; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nl6mE3UI0wvrR40I9/vu5uuYJQkYp5pTF9U7DAxBDpI=;
        b=rv/fpouLK8aPcy35oZvVI/63bKIFzCgFdvxXaqJ0A6T4NuXk37urYigi50JZ2eqEFD
         MTnrMHpzvSG0UZ4slro0ntVD+Zhf1pDP75xm8s2DDIf3VdVkcvSTdkov0kX9Afk255k6
         Ul2Hba9FJH7bi9RzK5XzB7H46nwtmEEJ81aGbOg4CeBtak1jkQ6lGse/ZJ+ts20Oiu6t
         UdpjJHF1dLPFFcE+F/U5Q/olMDuXkOJfhUwPaSPXYXzHKJXQdUOM2Vc9smgbtmjE3zpj
         TAgUFZzYtdnZMwGH4D94bqJ1+EF9vaHwSrxBhmPZUmWyrH+CgaqMyW9z50b+9cYeL9MN
         vQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745626259; x=1746231059;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nl6mE3UI0wvrR40I9/vu5uuYJQkYp5pTF9U7DAxBDpI=;
        b=tYtIt3GIW4NeobYOWuVw9aK2oJy9OE0Y4YD/9L8YtJlYG/Gc+fsk8Q2DsKd3qA7sZR
         pjooMeX2vtGDFQU379sF+RwVd+whTQe1mEzNJrX+RMNm4aGI+Y93T/WQhhjeZkKG5c0O
         6JhE2Ug/C4C0LYJ/7Q28NVdHsfQ3PRSmqqetzjwVxp9+YghvbG9aVcnWzJJxiSSOMC4Z
         Umudose+5fd32430TtI4eHjZSqpwU+kdMKpB1S/Fn+fDo7DMI8MXMhpsGXreg4S4jiuN
         /sesS00Wpg1r9ezuCRmIQenREGVWnUI6KhL50w04HZzk1GuqFd/dZS+KpP1fltdT/Kdp
         pXeA==
X-Gm-Message-State: AOJu0YyKzJo01nIfgGh/kNDuhAc1lnYYuYi/1kyqRa4AUQdT1K64SUG0
	tnK6ZDfFxy1jmrk1zXHJzQYOtcTd0PH2VY+eC/RsNQ+cwgccPUDEOSET+XYl0rNDreJNkSmy/aC
	MOQ==
X-Google-Smtp-Source: AGHT+IHfbQHFbqz93GMMPMKs0cmOBBcFd1R66lZeP3m1CeHDWsS397BMJ08LGsYc/3f1gB8dcpav34eDBso=
X-Received: from pjbsm11.prod.google.com ([2002:a17:90b:2e4b:b0:301:2a0f:b03d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dcd:b0:2fe:99cf:f566
 with SMTP id 98e67ed59e1d1-309f7dde70emr5977861a91.13.1745626258881; Fri, 25
 Apr 2025 17:10:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 25 Apr 2025 17:10:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <20250426001056.1025157-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Prevent installing hugepages when mem
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
 arch/x86/kvm/mmu/mmu.c | 68 ++++++++++++++++++++++++++++++++----------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 63bb77ee1bb1..218ba866a40e 100644
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
@@ -7686,6 +7707,37 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
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
+		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
+		    !hugepage_test_mixed(slot, end, level))
+			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
+	}
+
 	/* Unmap the old attribute page. */
 	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		range->attr_filter = KVM_FILTER_SHARED;
@@ -7695,23 +7747,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
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
2.49.0.850.g28803427d3-goog


