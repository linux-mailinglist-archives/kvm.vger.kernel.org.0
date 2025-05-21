Return-Path: <kvm+bounces-47288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 404B9ABFA0B
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FCC81BC779A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A31421CC49;
	Wed, 21 May 2025 15:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aNt7Qqq4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF287187876
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 15:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842060; cv=none; b=cUXJZzqfS0n/AGJs9JRVGcyVwoBtQTQ/EUtk+LhbaNoaYmEpcGwZDwZeNfnEes8G0PXaOmdPjhpMUDK8gK8KqjV1MG0QgFy0pahDCxvw2uI8nbW63Nl+xeFKGE4BNXp6grhSt5N7tnP8VUdJaePD+n73BtAOQs22qDTqNdyTWPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842060; c=relaxed/simple;
	bh=x2UpAPG5W0IaNg6NUiNTzQrRTClAfJi/ienNx+wMne8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKKZcgnY4zY9VL2jmO08OnBml+B66NruQlhwY7LGJCxNbmZ0SntJtADpZKEVlEH0W60UosfuxOok5QLF2M9A5FsgdWfix/KQJMMFaun5DtpquBDUxLIG929rcC0FwL1IcPA1PDoMgM9QzKK/8TGi76D7eepxPVVy3VuglP9VSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aNt7Qqq4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747842057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tqHSpRIfPfnEvmoItAnA0UzMEcUJBUk+JNOniEKUyA=;
	b=aNt7Qqq4XyHvOTXBlMK+JLAuWuwAJkKNdLLoSPbYXMlFb6xr7frxd+n6Gfkseb+wqitf+s
	EAA2q+j1YNsC6qDuWzpc7kJwyx4V0a9RvKsZ/YjInNv1qStrD76f87Na3tR430FP1F5Rjv
	4ce5nj/QWYu5cDdCXn3ExmscNG9qHZU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-53usTMhONBKeF9m5-JirZA-1; Wed, 21 May 2025 11:40:56 -0400
X-MC-Unique: 53usTMhONBKeF9m5-JirZA-1
X-Mimecast-MFC-AGG-ID: 53usTMhONBKeF9m5-JirZA_1747842056
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7cabd21579eso1227998185a.3
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 08:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747842056; x=1748446856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tqHSpRIfPfnEvmoItAnA0UzMEcUJBUk+JNOniEKUyA=;
        b=qcO8V8ErLURYi8CA7jq3V0NrWk7XU57kY9n08+FfhqH6hlUaUxVAtG5IgkXbYWHScH
         fUHv1p0Igdhw2Xufk/VtHZB3Kq3yiyzf7vkw3NIIIQ/zR/IQ7HXL/dZWd8GdZoLiVGHf
         bQQx2K7yeYQk/TxcY+tuOd04cGlMU+nJJQZRRK41HyOSbk2iZ82mqC+GwtrK3IpIZ4Gh
         KpPwOC8UGE8ESGN7q6w5zzWiyAFbIR/mkOCDv+eAu/+0sB8mizgFZDy6P91FMTltHhVS
         kZGtVyx2p7bbHQCb93eCOI5o+9O7udeg+S2NMYgT9Wki9GXEpoIWjjRYZqiqW4OC2iV8
         5+5A==
X-Forwarded-Encrypted: i=1; AJvYcCVmlQ+oGE7x5IPEIr/tHBDWVccVw3ucXTjtiuXwCTcvEMq+UTOURQ9Tdzah5tlRfaf3N1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnVPPDAwEL/g2XmqG6fQqDyQLL2k7+Rj+43yArXKS3YVla85yQ
	cbtgGvfL0tlKNpf6kVHGvumNroIYWA/xL+kMJIttwGOMy93vRM/M2dhEdsHiHAktpu0oVfkf6ni
	EsKSVmGQucEXR61/hFv5xvfE/kOltsrPaHSqD8ajWSDS+XvLh/ZxcmA==
X-Gm-Gg: ASbGncsQ0xMvKqcwvgyhl8z0+OPLJwbNLzqiZbHl50ioK038mXi6a7d4SSqu3mSuLWT
	BezsSDktu92+jCcFrlcSBr+Zhcdt3BfUqnsqLsqu0mA3DZ6NCU+o+7lfjBMLnDCT7zPdrewELF4
	lXvMdO5N5MESyl9sGeRpXyZjqSaE9K7VN1YmBtx1+9RA8vSWXHDjJZQVa1KpKNiDHaYc2wyrDRJ
	EyQJsM5FwKZESX6sXxHZ09pjgaT8BF3Og2IrlO+aMv8TpvhIP0ZH+nKpEJeWIoxSIzTYOv38jnV
	E2o=
X-Received: by 2002:a05:620a:4555:b0:7c5:9788:1762 with SMTP id af79cd13be357-7cd4678051amr3110618585a.45.1747842055646;
        Wed, 21 May 2025 08:40:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3a2uIuhszzX6u/m8PaNUSfSQHEqGfmhnxFRkzcN2fPM+8UtLLD8Ja0vDy+EkZ1oN2jOSBLw==
X-Received: by 2002:a05:620a:4555:b0:7c5:9788:1762 with SMTP id af79cd13be357-7cd4678051amr3110615285a.45.1747842055227;
        Wed, 21 May 2025 08:40:55 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467ef019sm891786485a.63.2025.05.21.08.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 08:40:54 -0700 (PDT)
Date: Wed, 21 May 2025 11:40:46 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, lizhe.67@bytedance.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
Message-ID: <aC3z_gUxJbY1_JP7@x1.local>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
 <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
 <20250520162125.772d003f.alex.williamson@redhat.com>
 <ff914260-6482-41a5-81f4-9f3069e335da@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff914260-6482-41a5-81f4-9f3069e335da@redhat.com>

On Wed, May 21, 2025 at 08:35:47AM +0200, David Hildenbrand wrote:
> On 21.05.25 00:21, Alex Williamson wrote:
> > On Tue, 20 May 2025 19:38:45 +0200
> > David Hildenbrand <david@redhat.com> wrote:
> > 
> > > On 20.05.25 09:00, lizhe.67@bytedance.com wrote:
> > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > 
> > > Subject: "huge folio" -> "large folios"
> > > 
> > > > 
> > > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > > includes huge folios, the function currently performs individual
> > > 
> > > Similar, we call it a "large" f
> > > 
> > > > statistics counting operations for each page. This can lead to significant
> > > > performance overheads, especially when dealing with large ranges of pages.
> > > > 
> > > > This patch optimize this process by batching the statistics counting
> > > > operations.
> > > > 
> > > > The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> > > > obtained through trace-cmd, are as follows. In this case, the 8G virtual
> > > > address space has been mapped to physical memory using hugetlbfs with
> > > > pagesize=2M.
> > > > 
> > > > Before this patch:
> > > > funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> > > > 
> > > > After this patch:
> > > > funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
> > > > 
> > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > ---
> > > > Changelogs:
> > > > 
> > > > v2->v3:
> > > > - Code simplification.
> > > > - Fix some issues in comments.
> > > > 
> > > > v1->v2:
> > > > - Fix some issues in comments and formatting.
> > > > - Consolidate vfio_find_vpfn_range() and vfio_find_vpfn().
> > > > - Move the processing logic for huge folio into the while(true) loop
> > > >     and use a variable with a default value of 1 to indicate the number
> > > >     of consecutive pages.
> > > > 
> > > > v2 patch: https://lore.kernel.org/all/20250519070419.25827-1-lizhe.67@bytedance.com/
> > > > v1 patch: https://lore.kernel.org/all/20250513035730.96387-1-lizhe.67@bytedance.com/
> > > > 
> > > >    drivers/vfio/vfio_iommu_type1.c | 48 +++++++++++++++++++++++++--------
> > > >    1 file changed, 37 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > index 0ac56072af9f..48f06ce0e290 100644
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -319,15 +319,22 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> > > >    /*
> > > >     * Helper Functions for host iova-pfn list
> > > >     */
> > > > -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > > > +
> > > > +/*
> > > > + * Find the first vfio_pfn that overlapping the range
> > > > + * [iova, iova + PAGE_SIZE * npage) in rb tree.
> > > > + */
> > > > +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > > > +		dma_addr_t iova, unsigned long npage)
> > > >    {
> > > >    	struct vfio_pfn *vpfn;
> > > >    	struct rb_node *node = dma->pfn_list.rb_node;
> > > > +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
> > > >    	while (node) {
> > > >    		vpfn = rb_entry(node, struct vfio_pfn, node);
> > > > -		if (iova < vpfn->iova)
> > > > +		if (end_iova <= vpfn->iova)
> > > >    			node = node->rb_left;
> > > >    		else if (iova > vpfn->iova)
> > > >    			node = node->rb_right;
> > > > @@ -337,6 +344,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > > >    	return NULL;
> > > >    }
> > > > +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > > > +{
> > > > +	return vfio_find_vpfn_range(dma, iova, 1);
> > > > +}
> > > > +
> > > >    static void vfio_link_pfn(struct vfio_dma *dma,
> > > >    			  struct vfio_pfn *new)
> > > >    {
> > > > @@ -681,32 +693,46 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> > > >    		 * and rsvd here, and therefore continues to use the batch.
> > > >    		 */
> > > >    		while (true) {
> > > > +			struct folio *folio = page_folio(batch->pages[batch->offset]);
> > > > +			long nr_pages;
> > > > +
> > > >    			if (pfn != *pfn_base + pinned ||
> > > >    			    rsvd != is_invalid_reserved_pfn(pfn))
> > > >    				goto out;
> > > > +			/*
> > > > +			 * Note: The current nr_pages does not achieve the optimal
> > > > +			 * performance in scenarios where folio_nr_pages() exceeds
> > > > +			 * batch->capacity. It is anticipated that future enhancements
> > > > +			 * will address this limitation.
> > > > +			 */
> > > > +			nr_pages = min((long)batch->size, folio_nr_pages(folio) -
> > > > +						folio_page_idx(folio, batch->pages[batch->offset]));
> > > > +			if (nr_pages > 1 && vfio_find_vpfn_range(dma, iova, nr_pages))
> > > > +				nr_pages = 1;
> > > 
> > > 
> > > You seem to assume that the batch really contains the consecutive pages
> > > of that folio.
> > 
> > I don't think we are.  We're iterating through our batch of pages from
> > GUP to find consecutive pfns.  We use the page to get the pfn, the
> > folio, and immediately above, the offset into the folio.  batch->size is
> > the remaining length of the page array from GUP and batch->offset is our
> > current index into that array.
> 
> Let me try again using an example below ....
> 
> > > This is not the case if we obtained the pages through GUP and we have
> > > 
> > > (a) A MAP_PRIVATE mapping
> > > 
> > > (b) We span multiple different VMAs
> > > 
> > > 
> > > Are we sure we can rule out (a) and (b)?
> > > 
> > > A more future-proof approach would be at least looking whether the
> > > pages/pfns are actually consecutive.
> > 
> > The unmodified (pfn != *pfn_base + pinned) test is where we verify we
> > have the next consecutive pfn.  Maybe I'm not catching the dependency
> > you're seeing on consecutive pages, I think there isn't one unless
> > we're somehow misusing folio_page_idx() to get the offset into the
> > folio.
> 
> Assume our page tables look like this (case (a), a partially mapped large
> pagecache folio mixed with COW'ed anonymous folios):
> 
>   + page[0] of folio 0
>   |              + COWed anonymous folio (folio 1)
>   |              |    + page[4] of folio 0
>   |              |    |
>   v              v    v
> F0P0 F0P1 F0P2 F1P0 F0P4 P0P5 F0P6 F0P7
> 
> If we GUP that range, we get exactly these pages, except that the PFNs are
> not consecutive, because F0P3 was replaced by another page. The large folio
> is partially mapped.
> 
> 
> Maybe I misunderstand that code, but wouldn't we just "jump" over F1P0
> because we assume the batch would contain F1P0, where it really contains
> F0P4?

Looks like a real issue (even if unlikely setup)..

Before a next-gen GUP.. Maybe we should stick with memfd_pin_folios(),
that'll require mmap read lock taken though when seeing a hugetlb folio, so
it'll be a fast path to try to ping hugetlb-only vmas.

VFIO will also need to check in the fast path on: (1) double check it's a
hugetlb VMA (in case vma layout changed after GUP and before mmap read
lock), (2) VMA boundary check, making sure it's not out-of-bound (3) stick
with VM_SHARED only for now (I don't think anyone uses MAP_PRIVATE anyway
that will also care about how fast it pins..). Then 1G will also work
there..

Thanks,

-- 
Peter Xu


