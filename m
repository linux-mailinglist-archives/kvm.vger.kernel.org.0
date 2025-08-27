Return-Path: <kvm+bounces-55812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB432B375DD
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B30E31B6789D
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 00:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084AF1B7F4;
	Wed, 27 Aug 2025 00:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0WRTvK+H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C1C214A64
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 00:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253142; cv=none; b=IuBqd4a5F80wzvlZPPr6XJR5gJUhBGjGewG8onsTqfsd3hLs+ZVQVjTz0/t39LcwB/p5ZbYiPv7MzE1sNAbkaJzULL5FtORTIrS4JtsJh7xFl+zxbOr/IO2eJzANEIQW6NZ9w5rLH1lrMZdRyjbExw6lI/wXLD5xZF7eRd6h8Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253142; c=relaxed/simple;
	bh=inYnERU1cZUpLoPVwwGG1cPzJ315J3ScXyEuAIhLuzY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e3kU4yv57ocdOj9Ez3x6SfPrSYGrNVuOetqJRQciPF59lXw82EQsVseq3dcaNxaKnbsJxlvImkVTwm4JVTvn0ZWA56EL5H4/fU8E1w/+tuinEKaNrg20U5wzWdPuAceYGHgMZWfSgoAF6iDSdT7Hq982tGi2IUizw0suFzTZaOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0WRTvK+H; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-325ce108e45so352194a91.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 17:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253140; x=1756857940; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EzIV4kw208Crs8PBdWAhCsmfi9lScWdvkVxAX4LkGs0=;
        b=0WRTvK+HDahOWdoNdla4xBbcaCWJOBo/DcTyFmtPvlNjM1k4xgva1ES7Dp6JUaOiaI
         BRC8JllV9tFMez4aSvZTVPVTdPnmjCsoWd92idSX2FOL/ZrNMjZJu3M80k5uCKHz03cA
         zS3mx9jKzXR2FI3UM5F7XHfFiCde5N5YMKtjzfd8w9BWfZZS2L2CqIOvfJ1UXXTHnZ26
         8ZxmEP0aEvvzjmkPbxRvUWCzOv3CPiqIpJztxO9/7O4YLSQFc6qIPKDF3EN8GyunJcwh
         1dx3ikV3iE9yExorLbqN0uPQx0iePs4bZGS8SIaY4ghEqtrPl4otz/J8hdhSGgMokylO
         h0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253140; x=1756857940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EzIV4kw208Crs8PBdWAhCsmfi9lScWdvkVxAX4LkGs0=;
        b=ms452MmV8zXAvjGWPBuhccfcrYfQi/m8mn/61xc+/Xl8Q9tI/u8HUQLee6qJHDCu91
         BRvNr68t+BA44ZjyT5wbFd0vdWfeg/vUjbpy1MiP1Reh7q0FdjbTUG+nU2EpZSVMFIAY
         2/MXk6U5rG9NAUbx5ZcbVWJmmt4I5W6Q6Nz6yPvQl7lf5yCwYMGKK/abcaYM1BQognbN
         bAAQM919kDm0YX7yJdXPbNu2sAapGvW11XsWdqjC5cxli4ukuDdx9U/OZhfegqZyCt9x
         eEC+Deus3ZG7fOkHtRW1Uo//Wb3rfz3oJinIcSZjhL0BU1RoWlLYQrdnuCut9GegQE6s
         uffQ==
X-Gm-Message-State: AOJu0YzPGkFujoTkfRhSNjLrz80PCyPJIgsuNp5zj7pzA3MoJhhV9l+R
	aAjXon8JI0YM4Xa8B7f7lPoT+yi1S/XdlpIKBnF1koMYvsnPL5bj4pWf4ST2HCZCngWpV2XIJJY
	cMfvkzw==
X-Google-Smtp-Source: AGHT+IFsjkLo5saaZ5ATkRw7E1vx5cE/AELT09M9Pwwd8rhFQR3pIhA4BadJFV/SzGBGB3WS8W5BgnMdyvQ=
X-Received: from pjbpl7.prod.google.com ([2002:a17:90b:2687:b0:321:6924:af9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5647:b0:324:e74a:117c
 with SMTP id 98e67ed59e1d1-3275085dceamr4812944a91.13.1756253140034; Tue, 26
 Aug 2025 17:05:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Aug 2025 17:05:19 -0700
In-Reply-To: <20250827000522.4022426-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250827000522.4022426-10-seanjc@google.com>
Subject: [RFC PATCH 09/12] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold tdx_mem_page_record_premap_cnt() into tdx_sept_set_private_spte() as
providing a one-off helper for effectively three lines of code is at best a
wash, and splitting the code makes the comment for smp_rmb()  _extremely_
confusing as the comment talks about reading kvm->arch.pre_fault_allowed
before kvm_tdx->state, but the immediately visible code does the exact
opposite.

Opportunistically rewrite the comments to more explicitly explain who is
checking what, as well as _why_ the ordering matters.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 49 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b7559ea1e353..e4b70c0dbda3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1608,29 +1608,6 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-/*
- * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
- * callback tdx_gmem_post_populate() then maps pages into private memory.
- * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
- * private EPT structures for the page to have been built before, which is
- * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
- * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
- * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
- * are no half-initialized shared EPT pages.
- */
-static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
-					  enum pg_level level, kvm_pfn_t pfn)
-{
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-
-	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-		return -EIO;
-
-	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
-	atomic64_inc(&kvm_tdx->nr_premapped);
-	return 0;
-}
-
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
@@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 
 	/*
-	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
-	 * barrier in tdx_td_finalize().
+	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
+	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
+	 * arbitrary memory until the initial memory image is finalized.  Pairs
+	 * with the smp_wmb() in tdx_td_finalize().
 	 */
 	smp_rmb();
-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+	/*
+	 * If the TD isn't finalized/runnable, then userspace is initializing
+	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
+	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
+	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
+	 * the counter to ensure all mapped pages have been added to the image,
+	 * to prevent running the TD with uninitialized memory.
+	 */
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
+		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
+			return -EIO;
+
+		atomic64_inc(&kvm_tdx->nr_premapped);
+		return 0;
+	}
+
+	return tdx_mem_page_aug(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
-- 
2.51.0.268.g9569e192d0-goog


