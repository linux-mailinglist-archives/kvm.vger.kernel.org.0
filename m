Return-Path: <kvm+bounces-31301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC539C21F3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:21:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E052282229
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E0B1E3DF5;
	Fri,  8 Nov 2024 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VIBppyD2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B38B199FAD
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082864; cv=none; b=WwiWvZt+g6OF7Bh0y9C4ztOn+cJ+5CwhyU7gA5Y33k4S528vjmdsC3AL7XCb4sEhFuAi8fjIEjr3Dr+32JdSTzMLaUNSV52uUw28egS7g8EZPTBWkxk/V6iZyPXHf9XaYJ0w5/e9VIHy3rOoLM3O1DGakc7n8LwPGL15+N5d/KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082864; c=relaxed/simple;
	bh=K1b6tyL4L39G1de+nnSTbXKIMTHDWGrE84WevKk4PlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J5OwWIWimaATdm7y2TRp8RgNuM09XC/9vApIyunSSwK9ydKE7bkrv3cMUW0s0/ceG9GpGK9C6DksoWjsmnU7FXg3lfzzk1+xuhNd1Zl+G+niXgHYBbOJEDgyz2AJcLdtoDZTg2i1t6ztL4HogGT9BKiQLo60AO/c9QSL3Ms2IBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VIBppyD2; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43151a9ea95so18037475e9.1
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 08:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731082861; x=1731687661; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zc2jp+pMldWQELuiNGfEMyRAPqgAV/dSRAey9KCp9+8=;
        b=VIBppyD2FgCT+4sPPfp61utzdKkL778hOeWl4EurHITmZU/fko7FdnjrqtbWGmoHYL
         ihg5OWP352bS8dKf6+uHhinY5BAAGfyooAAnaxUajqFmhVlBmD2kkcNiVWM8CdUvxGdz
         FpOUzRMXvfbocWWqR/7B3MtORRtYLW0s7uliHUaEG0j37Eg7aWCTLWDV10LO4Fi/PXIH
         /h1bwpyTASbt00l3EpKlAtuehbUbNYaKxY4oLoJEUgrJUUmxbCH4j8pIwnMxCyyTuWbR
         HhEpZzzXe4kUMvcUGKItXHd3r+VwvHkTzWe6c9PsqiKzDHMvfBK66LoKlxtUZ6rSIU3M
         ipyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731082861; x=1731687661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zc2jp+pMldWQELuiNGfEMyRAPqgAV/dSRAey9KCp9+8=;
        b=HzxmmykjWVaWAYXg3gUc5z2bWcam+viZ5iWYRw1/AxBEYkf2AJAeEndIBHnUnZyjys
         uTjLecQfl6r3X9wk0MWwA8IO9beKgOAFWSx0Lx3ukGC0JJ72ts542I040g89F4XfyCnW
         DpT1Wg5495LqC/7QvgRuaWssHnicDWpy/mwSN5/KQqYvGsBVbl68L0xD5jM8eb82TGYn
         EJItraTYxaFnC9P0QuQNOi5hwJ0QJDsJidbUQJL8lEjia7H4LpcYmwnYaFf7sKx3hMv7
         9FdkbRsFtkF857hCzDTED+Yf5rKdjPPXFmtT7RsAkuZY8t7qk0K2knszgEkRAtyLQVwg
         h0tQ==
X-Gm-Message-State: AOJu0Yx2XmznDMF1JeGbW+loZQvMwLcbIGUIVGoqYswWF1ed32IUyyWG
	VfTkVNP2xX0/4iGFhj/YPqro74NrW//Czc4pNWKeXdRHRnTjipNOAbUk/cKWVkrnkzFSfA8kJA=
	=
X-Google-Smtp-Source: AGHT+IEFnogtOzb1Xio0nKmbj4KqgDBTNvMMzqTZB5Q0tAq5Rm4eo6VUxTjFp/Ump5nYGzIZAg3lfcnSTA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:cbc9:0:b0:42e:6ad4:e411 with SMTP id
 5b1f17b1804b1-432b741c9b5mr131765e9.1.1731082860803; Fri, 08 Nov 2024
 08:21:00 -0800 (PST)
Date: Fri,  8 Nov 2024 16:20:38 +0000
In-Reply-To: <20241108162040.159038-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108162040.159038-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241108162040.159038-9-tabba@google.com>
Subject: [RFC PATCH v1 08/10] mm: Use getters and setters to access page pgmap
From: Fuad Tabba <tabba@google.com>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, david@redhat.com, rppt@kernel.org, 
	jglisse@redhat.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	simona@ffwll.ch, airlied@gmail.com, pbonzini@redhat.com, seanjc@google.com, 
	willy@infradead.org, jgg@nvidia.com, jhubbard@nvidia.com, 
	ackerleytng@google.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	kirill.shutemov@linux.intel.com, quic_eberman@quicinc.com, maz@kernel.org, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The pointer to pgmap in struct page is overlaid with folio
owner_ops. To indicate that a page/folio has owner ops, bit 1 is
set. Therefore, before we can start to using owner_ops, we need
to ensure that all accesses to page pgmap sanitize the pointer
value.

This patch introduces the accessors, which will be modified in
the following patch to sanitize the pointer values.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |  4 +++-
 drivers/pci/p2pdma.c                   |  8 +++++---
 include/linux/memremap.h               |  6 +++---
 include/linux/mm_types.h               | 13 +++++++++++++
 lib/test_hmm.c                         |  2 +-
 mm/hmm.c                               |  2 +-
 mm/memory.c                            |  2 +-
 mm/memremap.c                          | 19 +++++++++++--------
 mm/migrate_device.c                    |  4 ++--
 mm/mm_init.c                           |  2 +-
 10 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 1a072568cef6..d7d9d9476bb0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -88,7 +88,9 @@ struct nouveau_dmem {
 
 static struct nouveau_dmem_chunk *nouveau_page_to_chunk(struct page *page)
 {
-	return container_of(page->pgmap, struct nouveau_dmem_chunk, pagemap);
+	struct dev_pagemap *pgmap = page_get_pgmap(page);
+
+	return container_of(pgmap, struct nouveau_dmem_chunk, pagemap);
 }
 
 static struct nouveau_drm *page_to_drm(struct page *page)
diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 4f47a13cb500..19519bb4ba56 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -193,7 +193,7 @@ static const struct attribute_group p2pmem_group = {
 
 static void p2pdma_page_free(struct page *page)
 {
-	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page->pgmap);
+	struct pci_p2pdma_pagemap *pgmap = to_p2p_pgmap(page_get_pgmap(page));
 	/* safe to dereference while a reference is held to the percpu ref */
 	struct pci_p2pdma *p2pdma =
 		rcu_dereference_protected(pgmap->provider->p2pdma, 1);
@@ -1016,8 +1016,10 @@ enum pci_p2pdma_map_type
 pci_p2pdma_map_segment(struct pci_p2pdma_map_state *state, struct device *dev,
 		       struct scatterlist *sg)
 {
-	if (state->pgmap != sg_page(sg)->pgmap) {
-		state->pgmap = sg_page(sg)->pgmap;
+	struct dev_pagemap *pgmap = page_get_pgmap(sg_page(sg));
+
+	if (state->pgmap != pgmap) {
+		state->pgmap = pgmap;
 		state->map = pci_p2pdma_map_type(state->pgmap, dev);
 		state->bus_off = to_p2p_pgmap(state->pgmap)->bus_offset;
 	}
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 3f7143ade32c..060e27b6aee0 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -161,7 +161,7 @@ static inline bool is_device_private_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
 		is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
+		page_get_pgmap(page)->type == MEMORY_DEVICE_PRIVATE;
 }
 
 static inline bool folio_is_device_private(const struct folio *folio)
@@ -173,13 +173,13 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
 		is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
+		page_get_pgmap(page)->type == MEMORY_DEVICE_PCI_P2PDMA;
 }
 
 static inline bool is_device_coherent_page(const struct page *page)
 {
 	return is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_COHERENT;
+		page_get_pgmap(page)->type == MEMORY_DEVICE_COHERENT;
 }
 
 static inline bool folio_is_device_coherent(const struct folio *folio)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6e06286f44f1..27075ea24e67 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -616,6 +616,19 @@ static inline const struct folio_owner_ops *folio_get_owner_ops(struct folio *fo
 	return owner_ops;
 }
 
+/*
+ * Get the page dev_pagemap pgmap pointer.
+ */
+#define page_get_pgmap(page)	((page)->pgmap)
+
+/*
+ * Set the page dev_pagemap pgmap pointer.
+ */
+static inline void page_set_pgmap(struct page *page, struct dev_pagemap *pgmap)
+{
+	page->pgmap = pgmap;
+}
+
 struct page_frag_cache {
 	void * va;
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 056f2e411d7b..d3e3843f57dd 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -195,7 +195,7 @@ static int dmirror_fops_release(struct inode *inode, struct file *filp)
 
 static struct dmirror_chunk *dmirror_page_to_chunk(struct page *page)
 {
-	return container_of(page->pgmap, struct dmirror_chunk, pagemap);
+	return container_of(page_get_pgmap(page), struct dmirror_chunk, pagemap);
 }
 
 static struct dmirror_device *dmirror_page_to_device(struct page *page)
diff --git a/mm/hmm.c b/mm/hmm.c
index 7e0229ae4a5a..b5f5ac218fda 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -248,7 +248,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		 * just report the PFN.
 		 */
 		if (is_device_private_entry(entry) &&
-		    pfn_swap_entry_to_page(entry)->pgmap->owner ==
+		    page_get_pgmap(pfn_swap_entry_to_page(entry))->owner ==
 		    range->dev_private_owner) {
 			cpu_flags = HMM_PFN_VALID;
 			if (is_writable_device_private_entry(entry))
diff --git a/mm/memory.c b/mm/memory.c
index 80850cad0e6f..5853fa5767c7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4276,7 +4276,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			 */
 			get_page(vmf->page);
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
+			ret = page_get_pgmap(vmf->page)->ops->migrate_to_ram(vmf);
 			put_page(vmf->page);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
diff --git a/mm/memremap.c b/mm/memremap.c
index 40d4547ce514..931bc85da1df 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -458,8 +458,9 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
 void free_zone_device_folio(struct folio *folio)
 {
-	if (WARN_ON_ONCE(!folio->page.pgmap->ops ||
-			!folio->page.pgmap->ops->page_free))
+	struct dev_pagemap *pgmap = page_get_pgmap(&folio->page);
+
+	if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
 		return;
 
 	mem_cgroup_uncharge(folio);
@@ -486,17 +487,17 @@ void free_zone_device_folio(struct folio *folio)
 	 * to clear folio->mapping.
 	 */
 	folio->mapping = NULL;
-	folio->page.pgmap->ops->page_free(folio_page(folio, 0));
+	pgmap->ops->page_free(folio_page(folio, 0));
 
-	if (folio->page.pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    folio->page.pgmap->type != MEMORY_DEVICE_COHERENT)
+	if (pgmap->type != MEMORY_DEVICE_PRIVATE &&
+	    pgmap->type != MEMORY_DEVICE_COHERENT)
 		/*
 		 * Reset the refcount to 1 to prepare for handing out the page
 		 * again.
 		 */
 		folio_set_count(folio, 1);
 	else
-		put_dev_pagemap(folio->page.pgmap);
+		put_dev_pagemap(pgmap);
 }
 
 void zone_device_page_init(struct page *page)
@@ -505,7 +506,7 @@ void zone_device_page_init(struct page *page)
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
 	 */
-	WARN_ON_ONCE(!percpu_ref_tryget_live(&page->pgmap->ref));
+	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_get_pgmap(page)->ref));
 	set_page_count(page, 1);
 	lock_page(page);
 }
@@ -514,7 +515,9 @@ EXPORT_SYMBOL_GPL(zone_device_page_init);
 #ifdef CONFIG_FS_DAX
 bool __put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
-	if (folio->page.pgmap->type != MEMORY_DEVICE_FS_DAX)
+	struct dev_pagemap *pgmap = page_get_pgmap(&folio->page);
+
+	if (pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
 
 	/*
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9cf26592ac93..368def358d02 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -135,7 +135,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			page = pfn_swap_entry_to_page(entry);
 			if (!(migrate->flags &
 				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			    page->pgmap->owner != migrate->pgmap_owner)
+			    page_get_pgmap(page)->owner != migrate->pgmap_owner)
 				goto next;
 
 			mpfn = migrate_pfn(page_to_pfn(page)) |
@@ -156,7 +156,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				goto next;
 			else if (page && is_device_coherent_page(page) &&
 			    (!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
-			     page->pgmap->owner != migrate->pgmap_owner))
+			     page_get_pgmap(page)->owner != migrate->pgmap_owner))
 				goto next;
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1c205b0a86ed..279cdaebfd2b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -995,7 +995,7 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
 	 * ever freed or placed on a driver-private list.
 	 */
-	page->pgmap = pgmap;
+	page_set_pgmap(page, pgmap);
 	page->zone_device_data = NULL;
 
 	/*
-- 
2.47.0.277.g8800431eea-goog


