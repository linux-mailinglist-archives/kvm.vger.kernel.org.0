Return-Path: <kvm+bounces-9284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B2785D15D
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:29:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A49701C23999
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0EF23EA90;
	Wed, 21 Feb 2024 07:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gQWJxiGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF9A3EA6C
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500399; cv=none; b=jYecdNyGVdkRm2fL5bk6ssub9I7Jsc9/CE5YHf1p8/ioGjFEWXdtOfbsw4DdyM7tub0c2e6ivSh7fiVDEsRG73bzMusVW9vaY4ELd0IkwqfS12MXiWSLUmLU0WMnJDxs6fMGK3V8WLz0syfhdABcHO9537Y1lpxpCpFO3azo9SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500399; c=relaxed/simple;
	bh=GoRB5muUW/vlnvbdqSuzJBKiC4jRGCNWuO4c6CRCuLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQrfR7MIBgOLmcrkEYYzmHhFYZQmvmtHUCN/dm9DooHQwz1PkH9BrDY7w6O+1Asv+CcTl8SkOt98xVVDBz9yET8gb95il/kON6nMOkyyV3p7IJ5jxezLnvENsI+kgVMGxHI3EqpXEGZUxqQg8qNHK8Vc3Hxbp+ozOCjUdCLYZdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=gQWJxiGZ; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c17098ee8eso92039b6e.2
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 23:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500397; x=1709105197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9bx11pSLT/dMnEbM2cRs3+BobJT8jfteDPW/FW2wkZ8=;
        b=gQWJxiGZ2wAaeQ4rprfaIPlH4MuEO1gbLhQvPl2xv10QIwTr4Z2dombPI8TwVYxJph
         XjSt0itAwDy6EkT9iEOWsHzDX8Yaf3xvXT+isQdjIFmhGyAcOh54Li9tWjnapIRGmnKn
         bfc3J+3/alMTwz2OTnZlZxZdCUXlqvOCSQkE8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500397; x=1709105197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9bx11pSLT/dMnEbM2cRs3+BobJT8jfteDPW/FW2wkZ8=;
        b=loBEDDtaKC/ie2AjG97qJNW3PiwiH36oGvlt1YhplcXWylLCYOXUxcI7lqSvLZ4ijJ
         7LmmeDpMR4pHk+rJkZQMHaYpfB38zVUQUT7VtXgnDhHdg/YeGz6lpNA6X6nji46a9m5N
         Cqd1UuNkWLTPB+QsxieAhWEwtowN/jX0pkMy3fh4AQGTCoxgbM1TvlF/7hIkoocFAb3l
         PXWeKZVL2roZR6Cf83HlCUJWGvx6DdNRFMfYmVT8U1Vb46bBD6mf+5eBJlrMnmjIcbfF
         4RRRZl67NdGSKGWRbPr+UL7f+V5/GH4hGR/RPfiVw91hQkEBTWiTrM3U9ZUgy5vLY2hQ
         46DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJc2rNExeFK41LEvsYPhD65AqhIj6v9Zs1vnDeEVOV0Jj8dXlof6/CZCCWkhQ9XIpSOYOHNSecPkkLHOc+0TjQ7GPy
X-Gm-Message-State: AOJu0Yygi18wgRsHPFK+bM0iHh3z0j+p7JxBMjI/8et1nT9D+vlbjmvU
	W55/Mf5nRL8ktCZcGtd5LeQlWi8GDRZvwIb84Aq9ITG1OkuaK80r6k+eo2L0Fg==
X-Google-Smtp-Source: AGHT+IGNh9WqoGwOHL9szx/wp2kJnQlTMKTYun1TNgpWSovSInZnd2lgzADd8sI8PrrbYbICOO5+xg==
X-Received: by 2002:a05:6808:1703:b0:3c0:b3f3:c2dc with SMTP id bc3-20020a056808170300b003c0b3f3c2dcmr20423256oib.35.1708500397214;
        Tue, 20 Feb 2024 23:26:37 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id o74-20020a62cd4d000000b006e3f09fd6a7sm6765220pfg.85.2024.02.20.23.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:36 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH v10 8/8] KVM: x86/mmu: Handle non-refcounted pages
Date: Wed, 21 Feb 2024 16:25:28 +0900
Message-ID: <20240221072528.2702048-11-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Handle non-refcounted pages in kvm_faultin_pfn(). This allows the host
to map memory into the guest that is backed by non-refcounted struct
pages - for example, the tail pages of higher order non-compound pages
allocated by the amdgpu driver via ttm_pool_alloc_page.

Tested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com> # virgl+venus+virtio-intel+i915
Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c          | 24 +++++++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++-
 include/linux/kvm_host.h        |  6 ++++--
 virt/kvm/guest_memfd.c          |  8 ++++----
 virt/kvm/kvm_main.c             | 10 ++++++++--
 7 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7c059b23ae16..73a9f6ee683f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2924,6 +2924,11 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool host_writable = !fault || fault->map_writable;
 	bool prefetch = !fault || fault->prefetch;
 	bool write_fault = fault && fault->write;
+	/*
+	 * Prefetching uses gfn_to_page_many_atomic, which never gets
+	 * non-refcounted pages.
+	 */
+	bool is_refcounted = !fault || !!fault->accessed_page;
 
 	if (unlikely(is_noslot_pfn(pfn))) {
 		vcpu->stat.pf_mmio_spte_created++;
@@ -2951,7 +2956,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	}
 
 	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
-			   true, host_writable, true, &spte);
+			   true, host_writable, is_refcounted, &spte);
 
 	if (*sptep == spte) {
 		ret = RET_PF_SPURIOUS;
@@ -4319,8 +4324,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
-	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &max_order);
+	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn,
+			     &fault->pfn, &fault->accessed_page, &max_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
@@ -4330,6 +4335,9 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 			       fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
+	/* kvm_gmem_get_pfn takes a refcount, but accessed_page doesn't need it. */
+	put_page(fault->accessed_page);
+
 	return RET_PF_CONTINUE;
 }
 
@@ -4339,10 +4347,10 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	struct kvm_follow_pfn kfp = {
 		.slot = slot,
 		.gfn = fault->gfn,
-		.flags = FOLL_GET | (fault->write ? FOLL_WRITE : 0),
+		.flags = fault->write ? FOLL_WRITE : 0,
 		.try_map_writable = true,
 		.guarded_by_mmu_notifier = true,
-		.allow_non_refcounted_struct_page = false,
+		.allow_non_refcounted_struct_page = spte_has_refcount_bit(),
 	};
 
 	/*
@@ -4359,6 +4367,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			fault->slot = NULL;
 			fault->pfn = KVM_PFN_NOSLOT;
 			fault->map_writable = false;
+			fault->accessed_page = NULL;
 			return RET_PF_CONTINUE;
 		}
 		/*
@@ -4422,6 +4431,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 success:
 	fault->hva = kfp.hva;
 	fault->map_writable = kfp.writable;
+	fault->accessed_page = kfp.refcounted_page;
 	return RET_PF_CONTINUE;
 }
 
@@ -4510,8 +4520,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = direct_map(vcpu, fault);
 
 out_unlock:
+	kvm_set_page_accessed(fault->accessed_page);
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
@@ -4586,8 +4596,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
+	kvm_set_page_accessed(fault->accessed_page);
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 #endif
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..0b05183600af 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -240,6 +240,8 @@ struct kvm_page_fault {
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
+	/* Does NOT have an elevated refcount */
+	struct page *accessed_page;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c965f77ac4d5..b39dce802394 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -847,8 +847,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = FNAME(fetch)(vcpu, fault, &walker);
 
 out_unlock:
+	kvm_set_page_accessed(fault->accessed_page);
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ee497fb78d90..0524be7c0796 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -958,7 +958,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	else
 		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
 				   fault->pfn, iter->old_spte, fault->prefetch, true,
-				   fault->map_writable, true, &new_spte);
+				   fault->map_writable, !!fault->accessed_page,
+				   &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cff5df6b0c52..0aae27771fea 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2421,11 +2421,13 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+		     int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, int *max_order)
+				   kvm_pfn_t *pfn, struct page **page,
+				   int *max_order)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0f4e0cf4f158..dabcca2ecc37 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -483,12 +483,12 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+		     int *max_order)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem;
 	struct folio *folio;
-	struct page *page;
 	struct file *file;
 	int r;
 
@@ -514,9 +514,9 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out_unlock;
 	}
 
-	page = folio_file_page(folio, index);
+	*page = folio_file_page(folio, index);
 
-	*pfn = page_to_pfn(page);
+	*pfn = page_to_pfn(*page);
 	if (max_order)
 		*max_order = 0;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e53a14adf149..4db7248fb678 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3288,11 +3288,17 @@ void kvm_set_page_dirty(struct page *page)
 }
 EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
 
-void kvm_set_page_accessed(struct page *page)
+static void __kvm_set_page_accessed(struct page *page)
 {
 	if (kvm_is_ad_tracked_page(page))
 		mark_page_accessed(page);
 }
+
+void kvm_set_page_accessed(struct page *page)
+{
+	if (page)
+		__kvm_set_page_accessed(page);
+}
 EXPORT_SYMBOL_GPL(kvm_set_page_accessed);
 
 void kvm_release_page_clean(struct page *page)
@@ -3302,7 +3308,7 @@ void kvm_release_page_clean(struct page *page)
 	if (!page)
 		return;
 
-	kvm_set_page_accessed(page);
+	__kvm_set_page_accessed(page);
 	put_page(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);
-- 
2.44.0.rc0.258.g7320e95886-goog


