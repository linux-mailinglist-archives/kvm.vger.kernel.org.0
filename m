Return-Path: <kvm+bounces-49796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5F03ADE26B
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4A8917C1B2
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1207F1D9A5D;
	Wed, 18 Jun 2025 04:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KH1B+lap"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6E920C480
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220677; cv=none; b=idSldWkFnB+R21GkELoT/QOUH7GCL92+2o6c/u+NPnO+jiFCtupmuiQXxOuw02w4D3TRS4b3hupey2SXldbtJceWqpIjoQMyi9ErAUnOTAMKNm7Y0YRy/vDVleqMkdfPNfecd4ZO4obdizq5cqkMcuRU5ca4RyY4Ogs+3+LeS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220677; c=relaxed/simple;
	bh=Fd4SdpBpGMWqTpDQtVvgHQNQARLYxNkES4VtDZAj2OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d0WpxL0+yWif5nrDflsQjIjlEEnrPFQngnnPcLjdI4vIrpLiCrQE9gPHS2LmrSlfu6M111VE0EN4iRFuzGLDGuTeHKx/LCMFfXmMqr/PG9fDAKA9CHnhZb9Wh2vUWtQEwl1eZ2H4K4aRTzh+dWcs5HD8gXZvw/ayNUSIRABu/wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KH1B+lap; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-234fedd3e51so59172715ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220675; x=1750825475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=He9GMZwZGhbuABKsoN3wz9xUeb4JLf+qOIjtO6Uhl9c=;
        b=KH1B+laphzq9ggMTEQZDW66kmcpSWnAYBsc+aRZHqDzrFFdd5a2kfuMyA8Do5iKMKK
         TNM2qWwAsbo54UwgRLqPmu9xIm6uchA7dv8+Lifren1AYDWH26/xsEBFRfxGw1Rxrv0E
         RtugHExSRwAyTo5Rw3URXCtupYMjsnTcre+cWu3ud2Axr7N0TOxsA7URRl7vt4QM3ldj
         +5NTxYki7ofVN0hAqzgKWbzYtezZJHziPrYJ+1TiySFeURxabaBEE7o+XX5NW2vS9Yjw
         8XjGR4lcCmA9ZcuRj+7D4fRxXBEnoPaaqVSGa4pn0EwgXRVDp66lbSu9X4sMFXNJpbas
         lx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220675; x=1750825475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=He9GMZwZGhbuABKsoN3wz9xUeb4JLf+qOIjtO6Uhl9c=;
        b=PU5mW8k+AqtcO1ubq9kwYSiQIoNeeeyyyLaWVun63vzVI6FQnbWETVLWXtLkZXeGc8
         au7M6YyZJteQJNmP8YzsnnEZxUOWjwxjBSslFtvX0acBdNoAdoHqU2524FsOetzPrAxs
         Sa/ozzky2+EWERpcnJObMNmz0JnclIEs/UhPxK0vnuRm4CWKKBE3e2mqCkSTSt7IZs5J
         YnWXYLWZ/ev8otmKWjYY+lneivnUHFtZDyOH8l0tQw/NCLaErTrbLBFxtdUpDHBP9hD9
         Nv267wp+Gkn+JfZl+27TlNnUR/YgxhagJXyaoKIgNpNoYv2Y3H9IjPj/EznXOH+DseC7
         xsGg==
X-Forwarded-Encrypted: i=1; AJvYcCU6uBLRG+VtiR49UzSAkorP6g3s3OVcPaO7eTaTSiFehJMg7vYi7T3e6JoqN+NMeGLuAWU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3vhUEHSmroRQFkv62J0vzoi3bi03/+JFE9d7ny978tv3KeBlV
	CuJQG+eK/A0dnm9/dRJ2HQXY6u++IaP+VzfV/e6Jt6h3lNupLyX799hFcy4LnYnh6UV6WC8P7r1
	RBORnQNSQPuE74hi3V1zasA==
X-Google-Smtp-Source: AGHT+IEz+sYmwmOj4IeHxcE6XX3uQvv4AyNEb1cpKl7A16mtz5cSX2RNnd2uZJbF+w+tZiQScGXmjNJtGrMaKECU
X-Received: from pjtd15.prod.google.com ([2002:a17:90b:4f:b0:30a:31eb:ec8e])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:dacc:b0:234:c8f6:1b05 with SMTP id d9443c01a7336-2366b3fe725mr232646505ad.52.1750220674878;
 Tue, 17 Jun 2025 21:24:34 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:14 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-6-jthoughton@google.com>
Subject: [PATCH v3 05/15] KVM: x86: Add support for KVM userfault exits
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Only a few changes are needed to support KVM userfault exits on x86:

1. Adjust kvm_mmu_hugepage_adjust() to force pages to be mapped at 4K
   while KVM_MEM_USERFAULT is enabled.
2. Return -EFAULT when kvm_do_userfault() when it reports that the page
   is userfault. (Upon failure to read from the bitmap,
   kvm_do_userfault() will return true without setting up a memory fault
   exit, so we'll return a bare -EFAULT).

For hugepage recovery, the behavior when disabling KVM_MEM_USERFAULT
should match the behavior when disabling KVM_MEM_LOG_DIRTY_PAGES; make
changes to kvm_mmu_slot_apply_flags() to recover hugepages when
KVM_MEM_USERFAULT is disabled.

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c |  5 ++++-
 arch/x86/kvm/x86.c     | 27 +++++++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a4439e9e07268..49eb6b9b268cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3304,7 +3304,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (is_error_noslot_pfn(fault->pfn))
 		return;
 
-	if (kvm_slot_dirty_track_enabled(slot))
+	if (kvm_slot_dirty_track_enabled(slot) || kvm_is_userfault_memslot(slot))
 		return;
 
 	/*
@@ -4522,6 +4522,9 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 {
 	unsigned int foll = fault->write ? FOLL_WRITE : 0;
 
+	if (kvm_do_userfault(vcpu, fault))
+		return -EFAULT;
+
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722de..fa279ba38115c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13152,12 +13152,27 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	u32 new_flags = new ? new->flags : 0;
 	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
+	/*
+	 * Recover hugepages when userfault is toggled off, as KVM forces 4KiB
+	 * mappings when userfault is enabled.  See below for why CREATE, MOVE,
+	 * and DELETE don't need special handling.  Note, common KVM handles
+	 * zapping SPTEs when userfault is toggled on.
+	 */
+	if (change == KVM_MR_FLAGS_ONLY && (old_flags & KVM_MEM_USERFAULT) &&
+	    !(new_flags & KVM_MEM_USERFAULT))
+		kvm_mmu_recover_huge_pages(kvm, new);
+
+	/*
+	 * Nothing more to do if dirty logging isn't being toggled.
+	 */
+	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
+
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
 	 */
-	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)
-		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
+	kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
 
 	/*
 	 * Nothing more to do for RO slots (which can't be dirtied and can't be
@@ -13177,14 +13192,6 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	if ((change != KVM_MR_FLAGS_ONLY) || (new_flags & KVM_MEM_READONLY))
 		return;
 
-	/*
-	 * READONLY and non-flags changes were filtered out above, and the only
-	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
-	 * logging isn't being toggled on or off.
-	 */
-	if (WARN_ON_ONCE(!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)))
-		return;
-
 	if (!log_dirty_pages) {
 		/*
 		 * Recover huge page mappings in the slot now that dirty logging
-- 
2.50.0.rc2.692.g299adb8693-goog


