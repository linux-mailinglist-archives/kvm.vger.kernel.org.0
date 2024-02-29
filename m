Return-Path: <kvm+bounces-10346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A3E86BF37
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:00:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFA082855C6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BCF4594A;
	Thu, 29 Feb 2024 02:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mp1HfUoV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD3944C71
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175525; cv=none; b=BJErCNJvHFd3PPkq26pnxy+3pewZKEnfVDwfnvsR4h3dXflRJZUWe32msdgL4mRqzTDdRe6XOipWAZ9dV1OF7U/EMbItTlRIISl5xuWb4z1Uq4khRYwkwsJLxlVE/7kpG6v+Noxbm/VbXMvschrM5vbhmH06uS7kWQpvwd0S/8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175525; c=relaxed/simple;
	bh=CHA75S6snq8UA20Y4BdKK2SwtCegWvLmcyn13Xk/r2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3/3lLEMWxbgFttExIXNrNQ4i1aBBjsUR7Wmb9kptChvCYRAYtVqxOoeNnHTvYefk0/SfDlM8Cq6C9tJ5GLXAhWnx3ybZAmHdZqVpas69hGTyku1qpKEsQB+7wJ6UzxDwEn2ae8gr0QS+oJEQEsm8IHEpjE9eUie5QOpHmHLhCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mp1HfUoV; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dba177c596so3133035ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175523; x=1709780323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpTtMKeJSamVSvzUBrIb8hYRwduZxS9ewHlGqezhwx0=;
        b=mp1HfUoV8R1444WIRrFqUzYsztJIyvqm0ZOmqXBbcmLPwO5W+7I0kcV3s/V+A5voQl
         WGioLd8r/JBgnvkQFknWgPHmvi/NPAIZSdyK/E4gQvp2FjQJW+JlJBwbTBSi0DcuJuC2
         MrwIJJcJHby6lJRxN52BzPSs2EGtqaSBp13X4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175523; x=1709780323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpTtMKeJSamVSvzUBrIb8hYRwduZxS9ewHlGqezhwx0=;
        b=IuaNoU5iodQPPiCCJHg2F73/iTqSxjQD6OrEh6hTRVswZKTRIw0r7ZoGMXiZu0nXuK
         se4W7rd0HFgb1A/pqxhSF/qA7U4S0tKc4PGqQuze7usYFJsYO4TpyvdtvkOit9ZSeVvc
         CnuMUwms9zXogCCJzJzVKuClLV4blG1id9OAdT3GgD6kGG8QEO4FkHXcpLT1WfjrbZMe
         zJj4v9LKz3DpGWNcfN+l46Lw1PjiDSxt8iut5rHD4UWo6BqVYPmumJh0i+qhckzWZSFr
         TqAe1ePELpSuUexNEg5sAcE5N+3rTx7c6rUgYrtzT3oQqfsWv12sb7muBHwrRoAXChvM
         mYaA==
X-Forwarded-Encrypted: i=1; AJvYcCVpFAZxr4y2JpBFrNuGDGYSTAjegq8WTxdSyvo3RrbzrkcB56qOWzoSfPX5NVHlc8BQpdaxCB+JqhPd797FRpo2ETnl
X-Gm-Message-State: AOJu0Ywbji4OrLn8hiEFkp9Agn78NuAHZCgsr+IlpGA226CoFPAXDqoT
	rj8hfaBEo5e1uJ4S5z0uG9NUP74yKVOPc9fNQ8R2C45WA/39pioXxYZ8sZ9V2Q==
X-Google-Smtp-Source: AGHT+IGM1EDN7WbxlDlaAFvUVqxxOhGfcdRwSEFUSUMiVweNLOqnXEi8yEI66S2thaSNOdr2AlN3GA==
X-Received: by 2002:a17:903:1c3:b0:1dc:b887:35bd with SMTP id e3-20020a17090301c300b001dcb88735bdmr1034209plh.5.1709175523466;
        Wed, 28 Feb 2024 18:58:43 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id x10-20020a170902ec8a00b001d5f1005096sm181559plg.55.2024.02.28.18.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:43 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 8/8] KVM: x86/mmu: Handle non-refcounted pages
Date: Thu, 29 Feb 2024 11:57:59 +0900
Message-ID: <20240229025759.1187910-9-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Handle non-refcounted pages in __kvm_faultin_pfn. This allows the
host to map memory into the guest that is backed by non-refcounted
struct pages - for example, the tail pages of higher order non-compound
pages allocated by the amdgpu driver via ttm_pool_alloc_page.

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
index 4936a8c5829b..f9046912bb43 100644
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
+		.allow_non_refcounted_struct_page = shadow_refcounted_mask,
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
index d19a418df04b..ea34eae6cfa4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2426,11 +2426,13 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
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
index 235c92830cdc..1f5d2a1e63a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3284,11 +3284,17 @@ void kvm_set_page_dirty(struct page *page)
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
@@ -3298,7 +3304,7 @@ void kvm_release_page_clean(struct page *page)
 	if (!page)
 		return;
 
-	kvm_set_page_accessed(page);
+	__kvm_set_page_accessed(page);
 	put_page(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);
-- 
2.44.0.rc1.240.g4c46232300-goog


