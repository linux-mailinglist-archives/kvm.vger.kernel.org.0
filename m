Return-Path: <kvm+bounces-49797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC20ADE26F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 06:26:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 173F37ACAE5
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 04:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF93218851;
	Wed, 18 Jun 2025 04:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3HiNoPEr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65068212B28
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220678; cv=none; b=dZUHIenjDjCCaUlfeZk/5W295xqEpWj2NQAcqsMq8SdynHsDd2fBWs7LQiP8jJWzap2t2TneSzbA+TotZYxl3yWnzpR8ApXQOBvLJ+SVF4QgTY0AygjeYi+DpBqO3K6qun02rSvxZk0AmtUgwu8QcSFlfdgcPaZOI/To/VQFkd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220678; c=relaxed/simple;
	bh=NPz0+9NZChr+FABsJMTAuN25yJ2sI7tDtR2Lkd4QSco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oqWfKQN4xRYjunRyntZZdYZMzC+qflJhvxBdtkLzSxX1ti/e/kOZmVKyxlkw6IDRhcJdm1+uurD+oxcZnTCGIIjfDOJXP/k+PcdU8p4VtwOeL8YcjZpD8mOajTuTy0x9BCa6Hyc17IUhoCY9J4DKgFj/0JKbVPW5dgfh9NfZd2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3HiNoPEr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313f702d37fso3176802a91.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220676; x=1750825476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Crtc37yj3I5HY0sOOY/Hc9qKBpXKt+15nfqytsnjM48=;
        b=3HiNoPErfo7kydQaNjYH+735LMmei2TZUHSQcMwl8H8YOCupVnC5Y3QGo66IOXwSra
         xO67bvOk7Nz/6AWdeORFdzlVKwYQtLQqFOuAh5fhFA4tZAjblAyhLD0CqDBqruCha7ia
         sqZDCCf/sqMF443ANY8anWsVnEU3S6FOcS2WU5U2VAbnKAPYpYI2YEGGttbkYO7oMHvw
         KQswzSS5LhJhrzjGl3cBXlBgNcce/6u1+FDdOH+9bs9KmCiA6rNZQYGQK41+ITk03o4m
         /C5v+NFcGQwhPApvZ892WmB4qqI7Gg4F6stzBEi5HSz3wF5+tYl5dasALWW/IDGU68UF
         LG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220676; x=1750825476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Crtc37yj3I5HY0sOOY/Hc9qKBpXKt+15nfqytsnjM48=;
        b=IRVQ1Lqe9M+VVxdrisT0i+iDzpFViMqRMVZyL2NZky+rrWHGlQtrLcdwAKBJSSXVU4
         M48zI6WgdsRX3S5wOb3IjS0JqZz8oR28RJZgxD2f4voWPeixSvAWwRMcr6Q09k1h+viv
         If63FWViFAGrKWKJKY8c5flQF49RSmzvJN6I4uSt+yblfsYAH1G/o/tpJllogUGZdsAL
         RBRBR2Vg6Pf11kEfgcjMrH9xgRcxjdTiMkj8t4cqrtWh+9ubLLqVxjvvzs5jE6mzHA0K
         9pJyI8V4vlELcwZMLa+GmUzq6DAOgbYASlGVjMaLqTyYtwplnx58ju/vgwvzKqYLwQw+
         TFdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtzyWc4Pk3Tz2jqakiGuc7cZ6OcA6aYyFcumhnxcRl0rlwVdMPRSqnEIMjE877PgfPbYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrAT9CjUnagzgYn2wdATXyCuJtKgIN4v3KU+yjHThTNWCTxcvt
	URZzTmo8zxnTTkwVEacEl4CF0BTXmBAOEXb5Qnr39S1MKcUPsAPyh5LnSgEk5fXS+48ng2Yfd8H
	mDB1IkqaLA6as8lXo0/fvJg==
X-Google-Smtp-Source: AGHT+IECQVYtJtqccD2ckXzkUCRtEGI61f7empdw5CPtw8UB73TqbA6HTmrTRxT/T52yNYKeR/onnUx3D5hsOmVD
X-Received: from pjbsl11.prod.google.com ([2002:a17:90b:2e0b:b0:312:1dae:6bf0])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5245:b0:311:ff02:3fcc with SMTP id 98e67ed59e1d1-313f1c03409mr27710648a91.14.1750220676391;
 Tue, 17 Jun 2025 21:24:36 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:15 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-7-jthoughton@google.com>
Subject: [PATCH v3 06/15] KVM: arm64: Add support for KVM userfault exits
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

To support KVM userfault exits with arm64:

1. Force mappings to be 4K while KVM_MEM_USERFAULT is enabled.
2. Return -EFAULT when kvm_do_userfault() reports that the page is
   userfault (or that reading the bitmap failed).

kvm_arch_commit_memory_region() was written assuming that, for
KVM_MR_FLAGS_ONLY changes, KVM_MEM_LOG_DIRTY_PAGES must be being
toggled. This is no longer the case, so adjust the logic appropriately.

Signed-off-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0c209f2e1c7b2..d75a6685d6842 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1548,7 +1548,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * logging_active is guaranteed to never be true for VM_PFNMAP
 	 * memslots.
 	 */
-	if (logging_active) {
+	if (logging_active || is_protected_kvm_enabled() ||
+	    kvm_is_userfault_memslot(memslot)) {
 		force_pte = true;
 		vma_shift = PAGE_SHIFT;
 	} else {
@@ -1637,6 +1638,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
 
+	if (kvm_do_userfault(vcpu, &fault))
+		return -EFAULT;
+
 	pfn = __kvm_faultin_pfn(memslot, fault.gfn, fault.write ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
@@ -2134,15 +2138,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags = old ? old->flags : 0;
+	u32 new_flags = new ? new->flags : 0;
+
+	/* Nothing to do if not toggling dirty logging. */
+	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
 
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (log_dirty_pages) {
-
+	if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		if (change == KVM_MR_DELETE)
 			return;
 
-- 
2.50.0.rc2.692.g299adb8693-goog


