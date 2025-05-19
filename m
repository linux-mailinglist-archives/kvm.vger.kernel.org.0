Return-Path: <kvm+bounces-46999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF7FABC474
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44B057A1A98
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE6C2874F9;
	Mon, 19 May 2025 16:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="acB01GWB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974071DE2A8
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 16:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747671789; cv=none; b=i2oKDrQiq/PLCc9MTIgwfF00Dp+36QIiNov89grTCLMU+OzrXIHD8M9nGOMmrmt7NJCt5Kp/bTn0OAtLwDN997RmRGMDwWuqjLBxeGS2B2laRu5iTYJ6RpsNr1PANjUHcn8GMSwqgEMpPVfgjNy/8ynhQJ0R9Fe3aLw5ewxk3Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747671789; c=relaxed/simple;
	bh=lHfbpQwX7iCeO1J0hvTTg6qpLwhZNGSSzZU99gzGtaM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pWdVvrnlErkpEo7UBYC9aZIl9ZV94SmqJFP0SO4+a3a7toHNOr5VFM0QKX9g44F/fmq+Y/zlYPz2FeB2SjQmRuJgTSo3ullwJ56ufFHDn+pHMIq75mS987iu6Taf9QyINLk0FoS0tuS4dCfSLNiwFyzsGo7y/bvnOBJ1l9hXIE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=acB01GWB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747671786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sDgr0prN9gLGQMYAikyRd79eyYuE0j6jqsT8PtAlUyA=;
	b=acB01GWBjeQWC+FXOI0bYCdMNXSlvMBz5ONIILm4AESzyJDXBQwczZcU2MtsXSeahWqI5h
	Nik3s95ipo+/9SUDJBTPJ67JsB0VLMfBXSoHZ2mS2vJYmXQVOyy3cqwP6fu8DBfXUZ7/o4
	KZDLOl27Zigaz3BMemHXPi68rXQq1f4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-HGEz8Z72M4WoKSEqU8pS8g-1; Mon, 19 May 2025 12:23:04 -0400
X-MC-Unique: HGEz8Z72M4WoKSEqU8pS8g-1
X-Mimecast-MFC-AGG-ID: HGEz8Z72M4WoKSEqU8pS8g_1747671784
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8649babc826so79218239f.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 09:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747671784; x=1748276584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sDgr0prN9gLGQMYAikyRd79eyYuE0j6jqsT8PtAlUyA=;
        b=nxBf4UmDTKx8EGhqJ+HDZXSL1TB+s81BGCZdmHS2mP4uctGQJTOhYCbX3o16c5K5ow
         v3Wh+ebgz0o8pC/JlSt3tfYg/4NJ6WDFatOVFzOZAwlHF9fsyFfdPLRe5UjNkGqohMMV
         FEOPThTKnhRs4UtJb6HrMIXoFewQQlebd/LbRzYKZZnz1NF4sBS09H08sU2obOw6G0Ib
         /vAef40m8CRR0DsTUbvOVbz1PHpw5qwrOuKJcDko1OlpBnGBAg8yXUGUPOPRljUeezfp
         MFOxOvv3kExauCRc7BKf1neHi7ohjwLKDrSF0kUZmD9dGRHYv+39unsUcff4/nHyhcGV
         eHyg==
X-Gm-Message-State: AOJu0Yx0/q6cJH+9fjdpP5kQbJn+aFve0Q35KnY0c7R7RgRZ+A12THOO
	jgOLYO1Ss3LzoGe5Du7auLaYke1YfrvOUFalmpauJZ/TEpFN0WgkHe0asJYqM9kHnDjqhNN15K+
	FOTLGw4qlAh+J+FKEfEyTaQsgvEUdv3P2NbnByJ/HUSyl2VO5gMHuDw==
X-Gm-Gg: ASbGnct1jY+tXHeCOsviSZGAqY0MGiW+PPzwep0l9mrUZEccChy47TyCcG7k/G0Fhji
	9dnacsvUnHQ80bePSaqahJqmsZJrwWwPKu7lkAxh2JM4jq7WqiIluVdsxbcYSgjerp/CgfQYQlY
	K7mgS6avmwCnDR62QHQ+n4uoCmAUeL5CCM04na9huihv21/cyAYdfWQNRKxhfnKIFv8R70VcRAF
	bGfuOMuZ55a9swXLlNbdCi3wWDeDFF5t8j0aPxvEN3aG6rs0n2queMg+zkj/ktOCm3ZEyqJMxWp
	PsVVLprC4PIPxIM=
X-Received: by 2002:a92:ca0d:0:b0:3d9:3ac1:b7c7 with SMTP id e9e14a558f8ab-3db84296d8dmr35803185ab.1.1747671783809;
        Mon, 19 May 2025 09:23:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHILcODf7Q0MUKmVzGsshD6QnwMYrn47COfOudZQSICUoGsPux+RvDqinmx5Ezvwr9bufsGMQ==
X-Received: by 2002:a92:ca0d:0:b0:3d9:3ac1:b7c7 with SMTP id e9e14a558f8ab-3db84296d8dmr35803075ab.1.1747671783305;
        Mon, 19 May 2025 09:23:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ec3b7sm1759765173.145.2025.05.19.09.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 09:23:02 -0700 (PDT)
Date: Mon, 19 May 2025 10:23:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2] vfio/type1: optimize vfio_pin_pages_remote() for
 hugetlbfs folio
Message-ID: <20250519102301.03686383.alex.williamson@redhat.com>
In-Reply-To: <20250519100724.7fd6cc1e.alex.williamson@redhat.com>
References: <20250519070419.25827-1-lizhe.67@bytedance.com>
	<20250519100724.7fd6cc1e.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 19 May 2025 10:07:24 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 19 May 2025 15:04:19 +0800
> lizhe.67@bytedance.com wrote:
> 
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > When vfio_pin_pages_remote() is called with a range of addresses that
> > includes hugetlbfs folios, the function currently performs individual
> > statistics counting operations for each page. This can lead to significant
> > performance overheads, especially when dealing with large ranges of pages.
> > 
> > This patch optimize this process by batching the statistics counting
> > operations.
> > 
> > The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> > obtained through trace-cmd, are as follows. In this case, the 8G virtual
> > address space has been mapped to physical memory using hugetlbfs with
> > pagesize=2M.
> > 
> > Before this patch:
> > funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> > 
> > After this patch:
> > funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> > Changelogs:
> > 
> > v1->v2:
> > - Fix some issues in comments and formatting.
> > - Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
> > - Move the processing logic for hugetlbfs folio into the while(true) loop
> >   and use a variable with a default value of 1 to indicate the number of
> >   consecutive pages.
> > 
> > v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
> > 
> >  drivers/vfio/vfio_iommu_type1.c | 70 +++++++++++++++++++++++++++------
> >  1 file changed, 58 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 0ac56072af9f..2218ca415366 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -317,17 +317,20 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> >  }
> >  
> >  /*
> > - * Helper Functions for host iova-pfn list
> > + * Find the first vfio_pfn that overlapping the range
> > + * [iova, iova + PAGE_SIZE * npage) in rb tree
> >   */
> > -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > +		dma_addr_t iova, unsigned long npage)
> >  {
> >  	struct vfio_pfn *vpfn;
> >  	struct rb_node *node = dma->pfn_list.rb_node;
> > +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
> >  
> >  	while (node) {
> >  		vpfn = rb_entry(node, struct vfio_pfn, node);
> >  
> > -		if (iova < vpfn->iova)
> > +		if (end_iova <= vpfn->iova)
> >  			node = node->rb_left;
> >  		else if (iova > vpfn->iova)
> >  			node = node->rb_right;
> > @@ -337,6 +340,14 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * Helper Functions for host iova-pfn list
> > + */  
> 
> This comment should still precede the renamed function above, it's in
> reference to this section of code related to searching, inserting, and
> removing entries from the pfn list.
> 
> > +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +{
> > +	return vfio_find_vpfn_range(dma, iova, 1);
> > +}
> > +
> >  static void vfio_link_pfn(struct vfio_dma *dma,
> >  			  struct vfio_pfn *new)
> >  {
> > @@ -681,32 +692,67 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >  		 * and rsvd here, and therefore continues to use the batch.
> >  		 */
> >  		while (true) {
> > +			int page_step = 1;
> > +			long lock_acct_step = 1;
> > +			struct folio *folio = page_folio(batch->pages[batch->offset]);
> > +			bool found_vpfn;
> > +
> >  			if (pfn != *pfn_base + pinned ||
> >  			    rsvd != is_invalid_reserved_pfn(pfn))
> >  				goto out;
> >  
> > +			/* Handle hugetlbfs page */
> > +			if (folio_test_hugetlb(folio)) {  
> 
> Why do we care to specifically test for hugetlb vs
> folio_large_nr_pages(), at which point we can just use folio_nr_pages()
> directly here.
> 
> > +				unsigned long start_pfn = PHYS_PFN(vaddr);  
> 
> Using this macro on a vaddr looks wrong.
> 
> > +
> > +				/*
> > +				 * Note: The current page_step does not achieve the optimal
> > +				 * performance in scenarios where folio_nr_pages() exceeds
> > +				 * batch->capacity. It is anticipated that future enhancements
> > +				 * will address this limitation.
> > +				 */
> > +				page_step = min(batch->size,
> > +					ALIGN(start_pfn + 1, folio_nr_pages(folio)) - start_pfn);  
> 
> Why do we assume start_pfn is the beginning of the folio?
> 
> > +				found_vpfn = !!vfio_find_vpfn_range(dma, iova, page_step);
> > +				if (rsvd || !found_vpfn) {
> > +					lock_acct_step = page_step;
> > +				} else {
> > +					dma_addr_t tmp_iova = iova;
> > +					int i;
> > +
> > +					lock_acct_step = 0;
> > +					for (i = 0; i < page_step; ++i, tmp_iova += PAGE_SIZE)
> > +						if (!vfio_find_vpfn(dma, tmp_iova))
> > +							lock_acct_step++;
> > +					if (lock_acct_step)
> > +						found_vpfn = false;  
> 
> Why are we making this so complicated versus falling back to iterating
> at page per page?
> 
> > +				}
> > +			} else {
> > +				found_vpfn = vfio_find_vpfn(dma, iova);
> > +			}
> > +
> >  			/*
> >  			 * Reserved pages aren't counted against the user,
> >  			 * externally pinned pages are already counted against
> >  			 * the user.
> >  			 */
> > -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> > +			if (!rsvd && !found_vpfn) {
> >  				if (!dma->lock_cap &&
> > -				    mm->locked_vm + lock_acct + 1 > limit) {
> > +				    mm->locked_vm + lock_acct + lock_acct_step > limit) {
> >  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> >  						__func__, limit << PAGE_SHIFT);
> >  					ret = -ENOMEM;
> >  					goto unpin_out;
> >  				}
> > -				lock_acct++;
> > +				lock_acct += lock_acct_step;
> >  			}
> >  
> > -			pinned++;
> > -			npage--;
> > -			vaddr += PAGE_SIZE;
> > -			iova += PAGE_SIZE;
> > -			batch->offset++;
> > -			batch->size--;
> > +			pinned += page_step;
> > +			npage -= page_step;
> > +			vaddr += PAGE_SIZE * page_step;
> > +			iova += PAGE_SIZE * page_step;
> > +			batch->offset += page_step;
> > +			batch->size -= page_step;
> >  
> >  			if (!batch->size)
> >  				break;  
> 
> Why is something like below (untested) not sufficient?
> 
> NB. (vaddr - folio_address()) still needs some scrutiny to determine if
> it's valid.
> 
> @@ -681,32 +692,40 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  		 * and rsvd here, and therefore continues to use the batch.
>  		 */
>  		while (true) {
> +			struct folio *folio = page_folio(batch->pages[batch->offset]);
> +			long nr_pages;
> +
>  			if (pfn != *pfn_base + pinned ||
>  			    rsvd != is_invalid_reserved_pfn(pfn))
>  				goto out;
>  
> +			nr_pages = min(batch->size, folio_nr_pages(folio) -
> +						    (vaddr - folio_address(folio)) >> PAGE_SHIFT);
 
folio_nr_pages(folio) - folio_page_idx(folio, batch->pages[batch->offset])

might be a better option here.  Thanks,

Alex

> +			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
> +				nr_pages = 1;
> +
>  			/*
>  			 * Reserved pages aren't counted against the user,
>  			 * externally pinned pages are already counted against
>  			 * the user.
>  			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (!rsvd && (nr_pages > 1 || !vfio_find_vpfn(dma, iova))) {
>  				if (!dma->lock_cap &&
> -				    mm->locked_vm + lock_acct + 1 > limit) {
> +				    mm->locked_vm + lock_acct + nr_pages > limit) {
>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>  						__func__, limit << PAGE_SHIFT);
>  					ret = -ENOMEM;
>  					goto unpin_out;
>  				}
> -				lock_acct++;
> +				lock_acct += nr_pages;
>  			}
>  
> -			pinned++;
> -			npage--;
> -			vaddr += PAGE_SIZE;
> -			iova += PAGE_SIZE;
> -			batch->offset++;
> -			batch->size--;
> +			pinned += nr_pages;
> +			npage -= nr_pages;
> +			vaddr += PAGE_SIZE * nr_pages;
> +			iova += PAGE_SIZE * nr_pages;
> +			batch->offset += nr_pages;
> +			batch->size -= nr_pages;
>  
>  			if (!batch->size)
>  				break;


