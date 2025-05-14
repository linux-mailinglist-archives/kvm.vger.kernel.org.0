Return-Path: <kvm+bounces-46593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D01ACAB7A12
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 01:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE4BA3B19C7
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 23:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CFE25EF97;
	Wed, 14 May 2025 23:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ao2pyiSX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AB725CC6F
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266240; cv=none; b=Ui7nPFxL/9YIO2/3IdcBPU98zLmVpk0dblrTABZuUp9AWdxhM7WMs4NVimIg6nlXYD9mWefb61oMZVZSnQItbv8L/gorVmY4wHffaGV3+oucS2y0g04WbrxZPxlIb7aNFsorwPQYWuUB4nkK8Li/EwY3jLAzZUhOtoMsnDPQL+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266240; c=relaxed/simple;
	bh=XwFjWjxtTsC5Fi5aJIX4EK+f5cmTCITRnhMR71nt1xI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SRwwI+v12QYo5ZLR9TqEgRYV2pzRL54SZAL0Tz/3r9EthEj7Xs2nmya33lEtziWSripcCbqRl20Yp5oHLcxKXWxql1DP5zDeQX1oISoq3i2xD3hYyEQC1YrJoYcE+jktnhqO2EZ/XAHVgHKM2FhRKBRCVOOICG3+E6kTbQxzviY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ao2pyiSX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e2bd11716so359652a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 16:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747266237; x=1747871037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l5jpW989/YFyq0v/aJ7/h6dJUf2Wl55zcXhclfQe+Us=;
        b=Ao2pyiSXwjO0hnHRtfhIMr2wPs71tF6H1b7AEoRIxXbGH+G9Z8aUF+DTmPkTIXwwbf
         cljlckWJB/IAXip0IGHGlj/RmLK5+6dhcEuIFOm+DUHnRVaOtPbn0f4C5TNEyCdzMeU6
         +mkSzk+p9P1vfnGbQbuw4puhaFoAwZ50OEzqL26S3nZpgeSO5v64xQPYE1nn+NGlvCdR
         IHqM7E8ybAGgwKngdv+57Q4NoOHqOBn42/OTSbOyk6CUcvb9k7KR2vdFJEnBfOqFTAvE
         mCxzT3psIfHNbgCgyvrBzx51M7pzkFrUQF//aGtGWuOB5dUBH8trA+o6B9mYW3in70KQ
         uTfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747266237; x=1747871037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5jpW989/YFyq0v/aJ7/h6dJUf2Wl55zcXhclfQe+Us=;
        b=stsj0+BCT1Z73+vInucn4W29ek7e7vIZPDKvZI2vgNxYGg7xCfuIh9a9imAC8jqirJ
         eBoX1Z8NFahZDxK0CiFUNhAF2Y5qm7fkYpDNxJoxauJomkXKmhf7h+r30stVUTJEEsVy
         qqUn3ZNRW+xGZslemW/U81psMjPP/U2iIz947yxF6TAMN7GWYPyK4wfafYDR4q8ZkBDc
         vhb9l2DzRks/uh/+2D+fEebDaxfnHV9WkPjfJVZ6LfnxVsb6n25vFKMxzsYdefb0uLwe
         41PA7s2AmdKzT+A/iEezuijeotF+py0YNIWQl7rAHbK4etZqYNpUM3/9eA7IfmFo9hOh
         dUtA==
X-Gm-Message-State: AOJu0YzMkXSOOT5W7OKLoqVSZolHVeljdlTR4GxDkdY8wBJfJUwTsG6Z
	1PeW8qL1kOT+wDFo4wCKh6vO9mG8lu/qDZIRtGHlJLM/6267VPRi4YhkFhrqxBNRZir9NC2WErc
	OfiyJgE2A+H688xLQDKobLY1GvhYUlWfQ50d5+yUo1DceC+Hm3WifUSE4X1Sriyf8TboGeEI2DN
	X29FvaikVyq2sJb8erk4MBxW1YAIorbaJyBgnKNeOM8hY8GDEXhNCaVYw=
X-Google-Smtp-Source: AGHT+IEHmJ3lib+NJLUGZyWmKwas+lc+zkjE9XbH3FlgTmX876qh5dQdz6tJQxjBx6fJXXbdWv8qDStuh5HH5lswOQ==
X-Received: from pjbsx3.prod.google.com ([2002:a17:90b:2cc3:b0:30a:7da4:f075])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a8c:b0:2ff:7331:18bc with SMTP id 98e67ed59e1d1-30e51907799mr665163a91.26.1747266236406;
 Wed, 14 May 2025 16:43:56 -0700 (PDT)
Date: Wed, 14 May 2025 16:42:17 -0700
In-Reply-To: <cover.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <7753dc66229663fecea2498cf442a768cb7191ba.1747264138.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 38/51] KVM: guest_memfd: Split allocator pages for
 guest_memfd use
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org
Cc: ackerleytng@google.com, aik@amd.com, ajones@ventanamicro.com, 
	akpm@linux-foundation.org, amoorthy@google.com, anthony.yznaga@oracle.com, 
	anup@brainfault.org, aou@eecs.berkeley.edu, bfoster@redhat.com, 
	binbin.wu@linux.intel.com, brauner@kernel.org, catalin.marinas@arm.com, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	david@redhat.com, dmatlack@google.com, dwmw@amazon.co.uk, 
	erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, graf@amazon.com, 
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com, 
	kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev, 
	kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"

In this patch, newly allocated pages are split to 4K regular pages
before providing them to the requester (fallocate() or KVM).

During a private to shared conversion, folios are split if not already
split.

During a shared to private conversion, folios are merged if not
already merged.

When the folios are removed from the filemap on truncation, the
allocator is given a chance to do any necessary prep for when the
folio is freed.

When a conversion is requested on a subfolio within a hugepage range,
faulting must be prevented on the whole hugepage range for
correctness.

See related discussion at
https://lore.kernel.org/all/Z__AAB_EFxGFEjDR@google.com/T/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Change-Id: Ib5ee22e3dae034c529773048a626ad98d4b10af3
---
 mm/filemap.c           |   2 +
 virt/kvm/guest_memfd.c | 501 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 483 insertions(+), 20 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a02c3d8e00e8..a052f8e0c41e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -223,6 +223,7 @@ void __filemap_remove_folio(struct folio *folio, void *shadow)
 	filemap_unaccount_folio(mapping, folio);
 	page_cache_delete(mapping, folio, shadow);
 }
+EXPORT_SYMBOL_GPL(__filemap_remove_folio);
 
 void filemap_free_folio(struct address_space *mapping, struct folio *folio)
 {
@@ -258,6 +259,7 @@ void filemap_remove_folio(struct folio *folio)
 
 	filemap_free_folio(mapping, folio);
 }
+EXPORT_SYMBOL_GPL(filemap_remove_folio);
 
 /*
  * page_cache_delete_batch - delete several folios from page cache
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index c578d0ebe314..cb426c1dfef8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -41,6 +41,11 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 				      pgoff_t end);
 static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 				    pgoff_t end);
+static int __kvm_gmem_filemap_add_folio(struct address_space *mapping,
+					struct folio *folio, pgoff_t index);
+static int kvm_gmem_restructure_folios_in_range(struct inode *inode,
+						pgoff_t start, size_t nr_pages,
+						bool is_split_operation);
 
 static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
 {
@@ -126,6 +131,31 @@ static enum shareability kvm_gmem_shareability_get(struct inode *inode,
 	return xa_to_value(entry);
 }
 
+static bool kvm_gmem_shareability_in_range(struct inode *inode, pgoff_t start,
+					    size_t nr_pages, enum shareability m)
+{
+	struct maple_tree *mt;
+	pgoff_t last;
+	void *entry;
+
+	mt = &kvm_gmem_private(inode)->shareability;
+
+	last = start + nr_pages - 1;
+	mt_for_each(mt, entry, start, last) {
+		if (xa_to_value(entry) == m)
+			return true;
+	}
+
+	return false;
+}
+
+static inline bool kvm_gmem_has_some_shared(struct inode *inode, pgoff_t start,
+					    size_t nr_pages)
+{
+	return kvm_gmem_shareability_in_range(inode, start, nr_pages,
+					     SHAREABILITY_ALL);
+}
+
 static struct folio *kvm_gmem_get_shared_folio(struct inode *inode, pgoff_t index)
 {
 	if (kvm_gmem_shareability_get(inode, index) != SHAREABILITY_ALL)
@@ -241,6 +271,105 @@ static bool kvm_gmem_has_safe_refcount(struct address_space *mapping, pgoff_t st
 	return refcount_safe;
 }
 
+static void kvm_gmem_unmap_private(struct kvm_gmem *gmem, pgoff_t start,
+				   pgoff_t end)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = gmem->kvm;
+	unsigned long index;
+	bool locked = false;
+	bool flush = false;
+
+	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+		pgoff_t pgoff = slot->gmem.pgoff;
+
+		struct kvm_gfn_range gfn_range = {
+			.start = slot->base_gfn + max(pgoff, start) - pgoff,
+			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
+			.slot = slot,
+			.may_block = true,
+			/* This function is only concerned with private mappings. */
+			.attr_filter = KVM_FILTER_PRIVATE,
+		};
+
+		if (!locked) {
+			KVM_MMU_LOCK(kvm);
+			locked = true;
+		}
+
+		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
+	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	if (locked)
+		KVM_MMU_UNLOCK(kvm);
+}
+
+static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
+				      pgoff_t end)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm *kvm = gmem->kvm;
+	unsigned long index;
+	bool found_memslot;
+
+	found_memslot = false;
+	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+		gfn_t gfn_start;
+		gfn_t gfn_end;
+		pgoff_t pgoff;
+
+		pgoff = slot->gmem.pgoff;
+
+		gfn_start = slot->base_gfn + max(pgoff, start) - pgoff;
+		gfn_end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff;
+
+		if (!found_memslot) {
+			found_memslot = true;
+
+			KVM_MMU_LOCK(kvm);
+			kvm_mmu_invalidate_begin(kvm);
+		}
+
+		kvm_mmu_invalidate_range_add(kvm, gfn_start, gfn_end);
+	}
+
+	if (found_memslot)
+		KVM_MMU_UNLOCK(kvm);
+}
+
+static pgoff_t kvm_gmem_compute_invalidate_bound(struct inode *inode,
+						 pgoff_t bound, bool start)
+{
+	size_t nr_pages;
+	void *priv;
+
+	if (!kvm_gmem_has_custom_allocator(inode))
+		return bound;
+
+	priv = kvm_gmem_allocator_private(inode);
+	nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
+
+	if (start)
+		return round_down(bound, nr_pages);
+	else
+		return round_up(bound, nr_pages);
+}
+
+static pgoff_t kvm_gmem_compute_invalidate_start(struct inode *inode,
+						 pgoff_t bound)
+{
+	return kvm_gmem_compute_invalidate_bound(inode, bound, true);
+}
+
+static pgoff_t kvm_gmem_compute_invalidate_end(struct inode *inode,
+					       pgoff_t bound)
+{
+	return kvm_gmem_compute_invalidate_bound(inode, bound, false);
+}
+
 static int kvm_gmem_shareability_apply(struct inode *inode,
 				       struct conversion_work *work,
 				       enum shareability m)
@@ -299,35 +428,53 @@ static void kvm_gmem_convert_invalidate_begin(struct inode *inode,
 					      struct conversion_work *work)
 {
 	struct list_head *gmem_list;
+	pgoff_t invalidate_start;
+	pgoff_t invalidate_end;
 	struct kvm_gmem *gmem;
-	pgoff_t end;
+	pgoff_t work_end;
 
-	end = work->start + work->nr_pages;
+	work_end = work->start + work->nr_pages;
+	invalidate_start = kvm_gmem_compute_invalidate_start(inode, work->start);
+	invalidate_end = kvm_gmem_compute_invalidate_end(inode, work_end);
 
 	gmem_list = &inode->i_mapping->i_private_list;
 	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, work->start, end);
+		kvm_gmem_invalidate_begin(gmem, invalidate_start, invalidate_end);
 }
 
 static void kvm_gmem_convert_invalidate_end(struct inode *inode,
 					    struct conversion_work *work)
 {
 	struct list_head *gmem_list;
+	pgoff_t invalidate_start;
+	pgoff_t invalidate_end;
 	struct kvm_gmem *gmem;
-	pgoff_t end;
+	pgoff_t work_end;
 
-	end = work->start + work->nr_pages;
+	work_end = work->start + work->nr_pages;
+	invalidate_start = kvm_gmem_compute_invalidate_start(inode, work->start);
+	invalidate_end = kvm_gmem_compute_invalidate_end(inode, work_end);
 
 	gmem_list = &inode->i_mapping->i_private_list;
 	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_end(gmem, work->start, end);
+		kvm_gmem_invalidate_end(gmem, invalidate_start, invalidate_end);
 }
 
 static int kvm_gmem_convert_should_proceed(struct inode *inode,
 					   struct conversion_work *work,
 					   bool to_shared, pgoff_t *error_index)
 {
-	if (!to_shared) {
+	if (to_shared) {
+		struct list_head *gmem_list;
+		struct kvm_gmem *gmem;
+		pgoff_t work_end;
+
+		work_end = work->start + work->nr_pages;
+
+		gmem_list = &inode->i_mapping->i_private_list;
+		list_for_each_entry(gmem, gmem_list, entry)
+			kvm_gmem_unmap_private(gmem, work->start, work_end);
+	} else {
 		unmap_mapping_pages(inode->i_mapping, work->start,
 				    work->nr_pages, false);
 
@@ -340,6 +487,27 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
 	return 0;
 }
 
+static int kvm_gmem_convert_execute_work(struct inode *inode,
+					 struct conversion_work *work,
+					 bool to_shared)
+{
+	enum shareability m;
+	int ret;
+
+	m = to_shared ? SHAREABILITY_ALL : SHAREABILITY_GUEST;
+	ret = kvm_gmem_shareability_apply(inode, work, m);
+	if (ret)
+		return ret;
+	/*
+	 * Apply shareability first so split/merge can operate on new
+	 * shareability state.
+	 */
+	ret = kvm_gmem_restructure_folios_in_range(
+		inode, work->start, work->nr_pages, to_shared);
+
+	return ret;
+}
+
 static int kvm_gmem_convert_range(struct file *file, pgoff_t start,
 				  size_t nr_pages, bool shared,
 				  pgoff_t *error_index)
@@ -371,18 +539,21 @@ static int kvm_gmem_convert_range(struct file *file, pgoff_t start,
 
 	list_for_each_entry(work, &work_list, list) {
 		rollback_stop_item = work;
-		ret = kvm_gmem_shareability_apply(inode, work, m);
+
+		ret = kvm_gmem_convert_execute_work(inode, work, shared);
 		if (ret)
 			break;
 	}
 
 	if (ret) {
-		m = shared ? SHAREABILITY_GUEST : SHAREABILITY_ALL;
 		list_for_each_entry(work, &work_list, list) {
+			int r;
+
+			r = kvm_gmem_convert_execute_work(inode, work, !shared);
+			WARN_ON(r);
+
 			if (work == rollback_stop_item)
 				break;
-
-			WARN_ON(kvm_gmem_shareability_apply(inode, work, m));
 		}
 	}
 
@@ -434,6 +605,277 @@ static int kvm_gmem_ioctl_convert_range(struct file *file,
 	return ret;
 }
 
+#ifdef CONFIG_KVM_GMEM_HUGETLB
+
+static inline void __filemap_remove_folio_for_restructuring(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+
+	spin_lock(&mapping->host->i_lock);
+	xa_lock_irq(&mapping->i_pages);
+
+	__filemap_remove_folio(folio, NULL);
+
+	xa_unlock_irq(&mapping->i_pages);
+	spin_unlock(&mapping->host->i_lock);
+}
+
+/**
+ * filemap_remove_folio_for_restructuring() - Remove @folio from filemap for
+ * split/merge.
+ *
+ * @folio: the folio to be removed.
+ *
+ * Similar to filemap_remove_folio(), but skips LRU-related calls (meaningless
+ * for guest_memfd), and skips call to ->free_folio() to maintain folio flags.
+ *
+ * Context: Expects only the filemap's refcounts to be left on the folio. Will
+ *          freeze these refcounts away so that no other users will interfere
+ *          with restructuring.
+ */
+static inline void filemap_remove_folio_for_restructuring(struct folio *folio)
+{
+	int filemap_refcount;
+
+	filemap_refcount = folio_nr_pages(folio);
+	while (!folio_ref_freeze(folio, filemap_refcount)) {
+		/*
+		 * At this point only filemap refcounts are expected, hence okay
+		 * to spin until speculative refcounts go away.
+		 */
+		WARN_ONCE(1, "Spinning on folio=%p refcount=%d", folio, folio_ref_count(folio));
+	}
+
+	folio_lock(folio);
+	__filemap_remove_folio_for_restructuring(folio);
+	folio_unlock(folio);
+}
+
+/**
+ * kvm_gmem_split_folio_in_filemap() - Split @folio within filemap in @inode.
+ *
+ * @inode: inode containing the folio.
+ * @folio: folio to be split.
+ *
+ * Split a folio into folios of size PAGE_SIZE. Will clean up folio from filemap
+ * and add back the split folios.
+ *
+ * Context: Expects that before this call, folio's refcount is just the
+ *          filemap's refcounts. After this function returns, the split folios'
+ *          refcounts will also be filemap's refcounts.
+ * Return: 0 on success or negative error otherwise.
+ */
+static int kvm_gmem_split_folio_in_filemap(struct inode *inode, struct folio *folio)
+{
+	size_t orig_nr_pages;
+	pgoff_t orig_index;
+	size_t i, j;
+	int ret;
+
+	orig_nr_pages = folio_nr_pages(folio);
+	if (orig_nr_pages == 1)
+		return 0;
+
+	orig_index = folio->index;
+
+	filemap_remove_folio_for_restructuring(folio);
+
+	ret = kvm_gmem_allocator_ops(inode)->split_folio(folio);
+	if (ret)
+		goto err;
+
+	for (i = 0; i < orig_nr_pages; ++i) {
+		struct folio *f = page_folio(folio_page(folio, i));
+
+		ret = __kvm_gmem_filemap_add_folio(inode->i_mapping, f,
+						   orig_index + i);
+		if (ret)
+			goto rollback;
+	}
+
+	return ret;
+
+rollback:
+	for (j = 0; j < i; ++j) {
+		struct folio *f = page_folio(folio_page(folio, j));
+
+		filemap_remove_folio_for_restructuring(f);
+	}
+
+	kvm_gmem_allocator_ops(inode)->merge_folio(folio);
+err:
+	WARN_ON(__kvm_gmem_filemap_add_folio(inode->i_mapping, folio, orig_index));
+
+	return ret;
+}
+
+static inline int kvm_gmem_try_split_folio_in_filemap(struct inode *inode,
+						      struct folio *folio)
+{
+	size_t to_nr_pages;
+	void *priv;
+
+	if (!kvm_gmem_has_custom_allocator(inode))
+		return 0;
+
+	priv = kvm_gmem_allocator_private(inode);
+	to_nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_page(priv);
+
+	if (kvm_gmem_has_some_shared(inode, folio->index, to_nr_pages))
+		return kvm_gmem_split_folio_in_filemap(inode, folio);
+
+	return 0;
+}
+
+/**
+ * kvm_gmem_merge_folio_in_filemap() - Merge @first_folio within filemap in
+ * @inode.
+ *
+ * @inode: inode containing the folio.
+ * @first_folio: first folio among folios to be merged.
+ *
+ * Will clean up subfolios from filemap and add back the merged folio.
+ *
+ * Context: Expects that before this call, all subfolios only have filemap
+ *          refcounts. After this function returns, the merged folio will only
+ *          have filemap refcounts.
+ * Return: 0 on success or negative error otherwise.
+ */
+static int kvm_gmem_merge_folio_in_filemap(struct inode *inode,
+					   struct folio *first_folio)
+{
+	size_t to_nr_pages;
+	pgoff_t index;
+	void *priv;
+	size_t i;
+	int ret;
+
+	index = first_folio->index;
+
+	priv = kvm_gmem_allocator_private(inode);
+	to_nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
+	if (folio_nr_pages(first_folio) == to_nr_pages)
+		return 0;
+
+	for (i = 0; i < to_nr_pages; ++i) {
+		struct folio *f = page_folio(folio_page(first_folio, i));
+
+		filemap_remove_folio_for_restructuring(f);
+	}
+
+	kvm_gmem_allocator_ops(inode)->merge_folio(first_folio);
+
+	ret = __kvm_gmem_filemap_add_folio(inode->i_mapping, first_folio, index);
+	if (ret)
+		goto err_split;
+
+	return ret;
+
+err_split:
+	WARN_ON(kvm_gmem_allocator_ops(inode)->split_folio(first_folio));
+	for (i = 0; i < to_nr_pages; ++i) {
+		struct folio *f = page_folio(folio_page(first_folio, i));
+
+		WARN_ON(__kvm_gmem_filemap_add_folio(inode->i_mapping, f, index + i));
+	}
+
+	return ret;
+}
+
+static inline int kvm_gmem_try_merge_folio_in_filemap(struct inode *inode,
+						      struct folio *first_folio)
+{
+	size_t to_nr_pages;
+	void *priv;
+
+	priv = kvm_gmem_allocator_private(inode);
+	to_nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
+
+	if (kvm_gmem_has_some_shared(inode, first_folio->index, to_nr_pages))
+		return 0;
+
+	return kvm_gmem_merge_folio_in_filemap(inode, first_folio);
+}
+
+static int kvm_gmem_restructure_folios_in_range(struct inode *inode,
+						pgoff_t start, size_t nr_pages,
+						bool is_split_operation)
+{
+	size_t to_nr_pages;
+	pgoff_t index;
+	pgoff_t end;
+	void *priv;
+	int ret;
+
+	if (!kvm_gmem_has_custom_allocator(inode))
+		return 0;
+
+	end = start + nr_pages;
+
+	/* Round to allocator page size, to check all (huge) pages in range. */
+	priv = kvm_gmem_allocator_private(inode);
+	to_nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
+
+	start = round_down(start, to_nr_pages);
+	end = round_up(end, to_nr_pages);
+
+	for (index = start; index < end; index += to_nr_pages) {
+		struct folio *f;
+
+		f = filemap_get_folio(inode->i_mapping, index);
+		if (IS_ERR(f))
+			continue;
+
+		/* Leave just filemap's refcounts on the folio. */
+		folio_put(f);
+
+		if (is_split_operation)
+			ret = kvm_gmem_split_folio_in_filemap(inode, f);
+		else
+			ret = kvm_gmem_try_merge_folio_in_filemap(inode, f);
+
+		if (ret)
+			goto rollback;
+	}
+	return ret;
+
+rollback:
+	for (index -= to_nr_pages; index >= start; index -= to_nr_pages) {
+		struct folio *f;
+
+		f = filemap_get_folio(inode->i_mapping, index);
+		if (IS_ERR(f))
+			continue;
+
+		/* Leave just filemap's refcounts on the folio. */
+		folio_put(f);
+
+		if (is_split_operation)
+			WARN_ON(kvm_gmem_merge_folio_in_filemap(inode, f));
+		else
+			WARN_ON(kvm_gmem_split_folio_in_filemap(inode, f));
+	}
+
+	return ret;
+}
+
+#else
+
+static inline int kvm_gmem_try_split_folio_in_filemap(struct inode *inode,
+						      struct folio *folio)
+{
+	return 0;
+}
+
+static int kvm_gmem_restructure_folios_in_range(struct inode *inode,
+						pgoff_t start, size_t nr_pages,
+						bool is_split_operation)
+{
+	return 0;
+}
+
+#endif
+
 #else
 
 static int kvm_gmem_shareability_setup(struct maple_tree *mt, loff_t size, u64 flags)
@@ -563,11 +1005,16 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return folio;
 
 	if (kvm_gmem_has_custom_allocator(inode)) {
-		void *p = kvm_gmem_allocator_private(inode);
+		size_t nr_pages;
+		void *p;
 
+		p = kvm_gmem_allocator_private(inode);
 		folio = kvm_gmem_allocator_ops(inode)->alloc_folio(p);
 		if (IS_ERR(folio))
 			return folio;
+
+		nr_pages = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(p);
+		index_floor = round_down(index, nr_pages);
 	} else {
 		gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 
@@ -580,10 +1027,11 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 			folio_put(folio);
 			return ERR_PTR(ret);
 		}
+
+		index_floor = index;
 	}
 	allocated_size = folio_size(folio);
 
-	index_floor = round_down(index, folio_nr_pages(folio));
 	ret = kvm_gmem_filemap_add_folio(inode->i_mapping, folio, index_floor);
 	if (ret) {
 		folio_put(folio);
@@ -600,6 +1048,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return ERR_PTR(ret);
 	}
 
+	/* Leave just filemap's refcounts on folio. */
+	folio_put(folio);
+
+	ret = kvm_gmem_try_split_folio_in_filemap(inode, folio);
+	if (ret)
+		goto err;
+
 	spin_lock(&inode->i_lock);
 	inode->i_blocks += allocated_size / 512;
 	spin_unlock(&inode->i_lock);
@@ -608,14 +1063,17 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	 * folio is the one that is allocated, this gets the folio at the
 	 * requested index.
 	 */
-	folio = page_folio(folio_file_page(folio, index));
-	folio_lock(folio);
+	folio = filemap_lock_folio(inode->i_mapping, index);
 
 	return folio;
+
+err:
+	filemap_remove_folio(folio);
+	return ERR_PTR(ret);
 }
 
-static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
-				      pgoff_t end)
+static void kvm_gmem_invalidate_begin_and_zap(struct kvm_gmem *gmem,
+					      pgoff_t start, pgoff_t end)
 {
 	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
@@ -848,7 +1306,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	filemap_invalidate_lock(inode->i_mapping);
 
 	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
 
 	if (kvm_gmem_has_custom_allocator(inode)) {
 		kvm_gmem_truncate_inode_range(inode, offset, offset + len);
@@ -978,7 +1436,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin_and_zap(gmem, 0, -1ul);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
@@ -1289,7 +1747,7 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	end = start + folio_nr_pages(folio);
 
 	list_for_each_entry(gmem, gmem_list, entry)
-		kvm_gmem_invalidate_begin(gmem, start, end);
+		kvm_gmem_invalidate_begin_and_zap(gmem, start, end);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the
@@ -1330,6 +1788,9 @@ static void kvm_gmem_free_folio(struct address_space *mapping,
 	 */
 	folio_clear_uptodate(folio);
 
+	if (kvm_gmem_has_custom_allocator(mapping->host))
+		kvm_gmem_allocator_ops(mapping->host)->free_folio(folio);
+
 	kvm_gmem_invalidate(folio);
 }
 
-- 
2.49.0.1045.g170613ef41-goog


