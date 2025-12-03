Return-Path: <kvm+bounces-65246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5472ACA19AF
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 21:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BBD81300D665
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 20:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259DB2C11C2;
	Wed,  3 Dec 2025 20:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUkvEFmO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C5F2C11C5
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 20:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764795555; cv=none; b=T6HeAo5iOG4eZR5WQMFVCeT/VsXr2Av/gDY5eEIW5JEPuAimzKzx7rEMLwOy/TzsmOi62kl1UBbrFoK5AKI1/vea+ppsia+YqVSNat+YNms/x8fgwITcXM16XLUCHnPW7BTP8t/RuGg8MBO/Txv0v3xcoFZGNX/Xt2UZIF1nR+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764795555; c=relaxed/simple;
	bh=+d4pXuGK76xCIPVZb+AXsXC9MaBc0sd/KvqvT1/C9yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TTzs/aXOEcpboKMA2rO1jPkcRm3ogLREpUhXudu/voRJd3KvejrVWqLeHoHKKc3P9SJN8dX6ews+tJj2gDn5hXChfFyLbCuxMXj00YdtHUIV6m+KkJUGvCU8z77nJ9OxEXjeinT51s5mQNdMuUBRufmcHx0CjKB3ciR9jhGkWGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vannapurve.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUkvEFmO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vannapurve.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso295446b3a.0
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 12:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764795552; x=1765400352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CuKlIZ5iIgOGG+KuOjRyhdKbJzg1JAHIwuvpJYHoyE=;
        b=KUkvEFmOhLaVJOyjIOhjcO3Ob7WyxdfTYlqDdBIaRNfAUbsdhJ+Gd8HdJCe2smioR6
         8l0TclCC2yREQX1WVZWRo8J/O6Eu66w7i+A8btaXTPC3POGUNhf32yusTZ1gxAM/PGCz
         3M6S3Hk70XTbKBEE7inpt0vDyCRKs61U+HCbUswB81LRSwNUcY4+oC4rbHTkwYTicz7p
         uh15AckhjoeVa6tMNBBJoKcremP6zjaqAvc0ez1jsdFEDhsU61HmzaQHGZ+pqr0y43rs
         dnK4d0v4xYQjQER+xGqYG9F21h3cthQh5lAR+oy/ZdP4h2drfhXLzt5F/9VKQGJ2zwgy
         i31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764795552; x=1765400352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8CuKlIZ5iIgOGG+KuOjRyhdKbJzg1JAHIwuvpJYHoyE=;
        b=sZ7DfOr0wpPVdolq8rrUQDpQc5+fxDf3b3e5xghvd8iNy8QM1YT4TcRx99SKsVe2LI
         miI9BASd3HXPDMvQQqTQO0asIcIowGvaHlnwfJf9nzlPwoNCPPjZs4B/1cpXTrHaX0gY
         asISLcmXsCjkqqZRdM5rTWrh0l63kMc8m+FozFH+fzVH+ynl0qLc2z5aDjygUgnjZK1O
         hTJTd73iallt/iS50rTAKDccatqABti2MWmxsoCwWElYW8fRzwUvzfLHDYYVEZPZkvu+
         CiyZ3NXJj5/89bGnAxXOaLrEndOPDUZ2128FNZUzjEhPTqy79T3JZ0mEaarCwacQu2oV
         ZK3g==
X-Forwarded-Encrypted: i=1; AJvYcCUbhVcRqgLu5EQZ+RNkv83Ta304kr8aQfGzCnJ+AMoaaA+2egM5KY+Bp8ASgrZt8c/bEuA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww5Twgl62/Dh0y86AO8t9WRIi9CJPRivqY0a91EHw7oEb7bjoc
	o9MTmPyweySnKuj4/p1vlx06Dbcf0ZokVO5vCOTEpvYB7GJJq5y5GkIDxZwMslithZBNYY/8Erb
	4yDffwgcJsLVzbH/XmN6icw==
X-Google-Smtp-Source: AGHT+IH1iQ2PjW83GYpO/CxiZCWCCZIgWQJ2kgkTIgk+amH2HIHZrxGLOOQcwZH2Zp013X1ysYLDrxgEDjNA/62e
X-Received: from pgfw6.prod.google.com ([2002:a63:c106:0:b0:bd9:a349:94bd])
 (user=vannapurve job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:999c:b0:34f:ec81:bc3d with SMTP id adf61e73a8af0-363f5e95a0bmr5155444637.44.1764795552080;
 Wed, 03 Dec 2025 12:59:12 -0800 (PST)
Date: Wed,  3 Dec 2025 20:59:10 +0000
In-Reply-To: <20251203142648.trx6sslxvxr26yzd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251203142648.trx6sslxvxr26yzd@amd.com>
X-Mailer: git-send-email 2.52.0.177.g9f829587af-goog
Message-ID: <20251203205910.1137445-1-vannapurve@google.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: FirstName LastName <vannapurve@google.com>
To: michael.roth@amd.com
Cc: ackerleytng@google.com, aik@amd.com, ashish.kalra@amd.com, 
	david@redhat.com, ira.weiny@intel.com, kvm@vger.kernel.org, 
	liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	seanjc@google.com, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"

> >
> > > but it makes a lot more sense to make those restrictions and changes in
> > > the context of hugepage support, rather than this series which is trying
> > > very hard to not do hugepage enablement, but simply keep what's partially
> > > there intact while reworking other things that have proven to be
> > > continued impediments to both in-place conversion and hugepage
> > > enablement.
> > Not sure how fixing the warning in this series could impede hugepage enabling :)
> >
> > But if you prefer, I don't mind keeping it locally for longer.
>
> It's the whole burden of needing to anticipate hugepage design, while it
> is in a state of potentially massive flux just before LPC, in order to
> make tiny incremental progress toward enabling in-place conversion,
> which is something I think we can get upstream much sooner. Look at your
> changelog for the change above, for instance: it has no relevance in the
> context of this series. What do I put in its place? Bug reports about
> my experimental tree? It's just not the right place to try to justify
> these changes.
>
> And most of this weirdness stems from the fact that we prematurely added
> partial hugepage enablement to begin with. Let's not repeat these mistakes,
> and address changes in the proper context where we know they make sense.
>
> I considered stripping out the existing hugepage support as a pre-patch
> to avoid leaving these uncertainties in place while we are reworking
> things, but it felt like needless churn. But that's where I'm coming

I think simplifying this implementation to handle populate at 4K pages is worth
considering at this stage and we could optimize for huge page granularity
population in future based on the need.

e.g. 4K page based population logic will keep things simple and can be
further simplified if we can add PAGE_ALIGNED(params.uaddr) restriction.
Extending Sean's suggestion earlier, compile tested only.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..224e79ab8f86 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2267,66 +2267,56 @@ struct sev_gmem_populate_args {
 	int fw_error;
 };
 
-static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
-				  void __user *src, int order, void *opaque)
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  struct page *src_page, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
-	int n_private = 0, ret, i;
-	int npages = (1 << order);
-	gfn_t gfn;
+	int ret;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
 		return -EINVAL;
 
-	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
-		struct sev_data_snp_launch_update fw_args = {0};
-		bool assigned = false;
-		int level;
-
-		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
-		if (ret || assigned) {
-			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
-				 __func__, gfn, ret, assigned);
-			ret = ret ? -EINVAL : -EEXIST;
-			goto err;
-		}
+	struct sev_data_snp_launch_update fw_args = {0};
+	bool assigned = false;
+	int level;
 
-		if (src) {
-			void *vaddr = kmap_local_pfn(pfn + i);
+	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
+	if (ret || assigned) {
+		pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+			 __func__, gfn, ret, assigned);
+		ret = ret ? -EINVAL : -EEXIST;
+		goto err;
+	}
 
-			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
-				ret = -EFAULT;
-				goto err;
-			}
-			kunmap_local(vaddr);
-		}
+	if (src_page) {
+		void *vaddr = kmap_local_pfn(pfn);
 
-		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
-				       sev_get_asid(kvm), true);
-		if (ret)
-			goto err;
+		memcpy(vaddr, page_address(src_page), PAGE_SIZE);
+		kunmap_local(vaddr);
+	}
 
-		n_private++;
+	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+			       sev_get_asid(kvm), true);
+	if (ret)
+		goto err;
 
-		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
-		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
-		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
-		fw_args.page_type = sev_populate_args->type;
+	fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+	fw_args.address = __sme_set(pfn_to_hpa(pfn));
+	fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+	fw_args.page_type = sev_populate_args->type;
 
-		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
-				      &fw_args, &sev_populate_args->fw_error);
-		if (ret)
-			goto fw_err;
-	}
+	ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+			      &fw_args, &sev_populate_args->fw_error);
+	if (ret)
+		goto fw_err;
 
 	return 0;
 
 fw_err:
 	/*
 	 * If the firmware command failed handle the reclaim and cleanup of that
-	 * PFN specially vs. prior pages which can be cleaned up below without
-	 * needing to reclaim in advance.
+	 * PFN specially.
 	 *
 	 * Additionally, when invalid CPUID function entries are detected,
 	 * firmware writes the expected values into the page and leaves it
@@ -2336,25 +2326,18 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	 * information to provide information on which CPUID leaves/fields
 	 * failed CPUID validation.
 	 */
-	if (!snp_page_reclaim(kvm, pfn + i) &&
+	if (!snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn + i);
-
-		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
-			pr_debug("Failed to write CPUID page back to userspace\n");
+		void *vaddr = kmap_local_pfn(pfn);
 
+		memcpy(page_address(src_page), vaddr, PAGE_SIZE);
 		kunmap_local(vaddr);
 	}
 
-	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
-	n_private--;
-
 err:
-	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
-		 __func__, ret, sev_populate_args->fw_error, n_private);
-	for (i = 0; i < n_private; i++)
-		kvm_rmp_make_shared(kvm, pfn + i, PG_LEVEL_4K);
+	pr_debug("%s: exiting with error ret %d (fw_error %d)\n",
+		 __func__, ret, sev_populate_args->fw_error);
 
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..acdcb802d9f2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3118,34 +3118,21 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+				  struct page *src_page, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *src_page;
-	int ret, i;
+	int ret;
 
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	/*
-	 * Get the source page if it has been faulted in. Return failure if the
-	 * source page has been swapped out or unmapped in primary memory.
-	 */
-	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
-	if (ret < 0)
-		return ret;
-	if (ret != 1)
-		return -ENOMEM;
-
 	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
-	put_page(src_page);
-
 	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
 		return ret;
 
@@ -3156,11 +3143,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
 	 * zapping flows are mutually exclusive with S-EPT mappings.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
-		if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
-			return -EIO;
-	}
+	err = tdh_mr_extend(&kvm_tdx->td, gpa, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
+		return -EIO;
 
 	return 0;
 }
@@ -3196,38 +3181,26 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 		return -EINVAL;
 
 	ret = 0;
-	while (region.nr_pages) {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		arg = (struct tdx_gmem_post_populate_arg) {
-			.vcpu = vcpu,
-			.flags = cmd->flags,
-		};
-		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
-					     u64_to_user_ptr(region.source_addr),
-					     1, tdx_gmem_post_populate, &arg);
-		if (gmem_ret < 0) {
-			ret = gmem_ret;
-			break;
-		}
+	arg = (struct tdx_gmem_post_populate_arg) {
+		.vcpu = vcpu,
+		.flags = cmd->flags,
+	};
+	gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
+				     u64_to_user_ptr(region.source_addr),
+				     region.nr_pages, tdx_gmem_post_populate, &arg);
+	if (gmem_ret < 0)
+		ret = gmem_ret;
 
-		if (gmem_ret != 1) {
-			ret = -EIO;
-			break;
-		}
+	if (gmem_ret != region.nr_pages)
+		ret = -EIO;
 
-		region.source_addr += PAGE_SIZE;
-		region.gpa += PAGE_SIZE;
-		region.nr_pages--;
+	if (gmem_ret >= 0) {
+		region.source_addr += gmem_ret * PAGE_SIZE;
+		region.gpa += gmem_ret * PAGE_SIZE;
 
-		cond_resched();
+		if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
+			ret = -EFAULT;
 	}
-
-	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
-		ret = -EFAULT;
 	return ret;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..263e75f90e91 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, int order, void *opaque);
+				    struct page *src_page, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2e62bf882aa8..550dc818748b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -85,7 +85,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
 
 	/*
@@ -794,7 +793,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return PTR_ERR(folio);
 
 	if (!folio_test_uptodate(folio)) {
-		clear_huge_page(&folio->page, 0, folio_nr_pages(folio));
+		clear_highpage(folio_page(folio, 0));
 		folio_mark_uptodate(folio);
 	}
 
@@ -812,13 +811,54 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+				struct file *file, gfn_t gfn, struct page *src_page,
+				kvm_gmem_populate_cb post_populate, void *opaque)
+{
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct gmem_inode *gi;
+	struct folio *folio;
+	int ret, max_order;
+	kvm_pfn_t pfn;
+
+	gi = GMEM_I(file_inode(file));
+
+	filemap_invalidate_lock(file->f_mapping);
+
+	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
+		goto out_unlock;
+	}
+
+	folio_unlock(folio);
+
+	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
+				KVM_MEMORY_ATTRIBUTE_PRIVATE,
+				KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		ret = -EINVAL;
+		goto out_put_folio;
+	}
+
+	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
+	if (!ret)
+		folio_mark_uptodate(folio);
+
+out_put_folio:
+	folio_put(folio);
+out_unlock:
+	filemap_invalidate_unlock(file->f_mapping);
+	return ret;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
+	struct page *src_aligned_page = NULL;
 	struct kvm_memory_slot *slot;
+	struct page *src_page = NULL;
 	void __user *p;
-
-	int ret = 0, max_order;
+	int ret = 0;
 	long i;
 
 	lockdep_assert_held(&kvm->slots_lock);
@@ -834,52 +874,50 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock(file->f_mapping);
+	if (src && !PAGE_ALIGNED(src)) {
+		src_page = alloc_page(GFP_KERNEL_ACCOUNT);
+		if (!src_page)
+			return -ENOMEM;
+	}
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
-	for (i = 0; i < npages; i += (1 << max_order)) {
-		struct folio *folio;
-		gfn_t gfn = start_gfn + i;
-		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		kvm_pfn_t pfn;
-
+	for (i = 0; i < npages; i++) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
-		if (IS_ERR(folio)) {
-			ret = PTR_ERR(folio);
-			break;
-		}
-
-		folio_unlock(folio);
-		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-			(npages - i) < (1 << max_order));
+		p = src ? src + i * PAGE_SIZE : NULL;
 
-		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
-			if (!max_order)
-				goto put_folio_and_exit;
-			max_order--;
+		if (p) {
+			if (src_page) {
+				if (copy_from_user(page_address(src_page), p, PAGE_SIZE)) {
+					ret = -EFAULT;
+					break;
+				}
+				src_aligned_page = src_page;
+			} else {
+				ret = get_user_pages((unsigned long)p, 1, 0, &src_aligned_page);
+				if (ret < 0)
+					break;
+				if (ret != 1) {
+					ret = -ENOMEM;
+					break;
+				}
+			}
 		}
 
-		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
-		if (!ret)
-			folio_mark_uptodate(folio);
+		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_aligned_page,
+					  post_populate, opaque);
+		if (p && !src_page)
+			put_page(src_aligned_page);
 
-put_folio_and_exit:
-		folio_put(folio);
 		if (ret)
 			break;
 	}
 
-	filemap_invalidate_unlock(file->f_mapping);
-
+	if (src_page)
+		__free_page(src_page);
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
-- 
2.52.0.177.g9f829587af-goog


