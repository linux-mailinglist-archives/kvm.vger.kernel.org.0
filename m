Return-Path: <kvm+bounces-55920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D11B38951
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 20:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CAF5687284
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18CC2D0C7B;
	Wed, 27 Aug 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkUNDuYH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2911430CDA0
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 18:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756318269; cv=none; b=oBoDZ32gdCb9WoeOZ+jcKKCFDkiujZjY65YXkmPXnVDEuMDJx+SVtp9VACIn0ZMFiQfi/wXU6BaXZkGCx5t0MB2EZ5PoRG+5hYZBVEcvhCcWgCx1TdiPPni+KXTwAI61CgqSbmr+5OKffYzomsgXJCtQ2dHZ8uM9IDjb94QR+80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756318269; c=relaxed/simple;
	bh=QvHXw5e5o5cbwzJpFsfoHZeFliiUGmQkPA/eepMJwcU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lfoimUJXselTPXlnrtTJOyRh8aJcMCAQXbeKfmYr1+sLcrmFT723ralb2HGDKcGpxSLgmHu8PKGKkIWYDITKniqCTtnl3mLr5vrho7p2NV7dZ2WT8Z7iukexynE1LvuAUbdp7+9F2qlPwHI1xUurwLuiMGGS5ozP/VKtg2YU/RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkUNDuYH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756318264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xd7UFS7CawmPe9GaZmY0KVeI3w3v5+q2sGdZeCqVHOg=;
	b=XkUNDuYHrM5URXb0zAZgF3+o4AvMQbzkxXzaPz9ttfAzJ0YJHhQfXU8ueXUp6WdndaqRIh
	GnrB6UFBxs/pF/GsVUswDWSndpdmGtDvgydy7ejKplaxEdg0+50ToROJW0qvpWvFK9UPHg
	EcluQGwKfqlXxPRLsBOLVgzyxHKzApo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-Ro_wXkTeMGWF_PK67horMA-1; Wed, 27 Aug 2025 14:10:59 -0400
X-MC-Unique: Ro_wXkTeMGWF_PK67horMA-1
X-Mimecast-MFC-AGG-ID: Ro_wXkTeMGWF_PK67horMA_1756318259
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3f08c081ba7so282505ab.0
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 11:10:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756318259; x=1756923059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xd7UFS7CawmPe9GaZmY0KVeI3w3v5+q2sGdZeCqVHOg=;
        b=e8bbLFpmEeA6OYUwMYrrwE5gGDbf+uL98JSrQ8FSlBitc46ZTtX9UWuBcTpe5W/cRG
         02DbIrVfVQwA1OSdCPjvFYeAB5zEL8r6+kudKE9l85SF+MzmCf+A9xT9xsRE9Gcw5ZWs
         Ns3EBKa2GJngNyKgenYeqnJ52vZyDarhy2mxfbakwGbMc5OLfllCqNEO657qyX9KbtXv
         MSJVRYP6nnHO6+l3mAtE4te9hSBgqvHrDZg8iTOfUIEehCpgw9vQh0kbqz01ne0tWUXY
         /aKdr90zh0Mt5H8neLxgxlGJgR4zdzPu0nccM/8EycHKHHUWdD+SXmcpv4P8j1sFcYY0
         +exw==
X-Forwarded-Encrypted: i=1; AJvYcCWCFlAJgHqdV7x7ZtkiBSyTn0cIUlCeYE0E0SqGt4TzJkoM047CSuMtsrxvXzk53ZEXphM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Glb5OIeRmCfg4T8qGjgMYXB7hs6kg4TG6g8akWQU8fyJfp1u
	04wxp77HFlhIvXPAunpeaBn2oUY+K6xjHEt3ZKvjHitHNutWqUGcbFkEFrRxDJLyBlTpjhcKqRc
	pjSOq+crPH43X7/T4n3qqiMB3qvPFao+sQqHxn7iO8dDaumGMHYdDPw==
X-Gm-Gg: ASbGncuOP4e5calL6pUrX4sxqvDRjcEuvd1OL6IFUB5KOhCKa09jvH42YjnWOLsrqWd
	yOiichesD6xeO1+oEZ8tOhJD6C84zuk6pdcvcrB/Q+jnQPuvGne/MYJMtRogSmLeOfLcY4dhTi+
	AyS56GcP3r65yssGifh4v/vTg7JnugSUw4ei0z8PqFYgZXmD5bRGsYC0l2WYPeV9xu+COPtPWQA
	1R9COXdmSR+nyaAcDiPb024h9rV9jA8QUFmcWmNZBp5LTj+lM2H15c2JYBqnF+S2aUx2acau7Hi
	87hGkPfnZwcf58ttGQ04We4vYXYDZUx1k/RsiyHBqOk=
X-Received: by 2002:a05:6602:2c81:b0:881:87de:a336 with SMTP id ca18e2360f4ac-886bd25af01mr900981639f.5.1756318259021;
        Wed, 27 Aug 2025 11:10:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTlE648ZK5gyCMDjdHdH6z4PdCJTq6ON80zAHo/j9xVmBTNqJqZ6LVO/BK3pOeKZu3YTgUBQ==
X-Received: by 2002:a05:6602:2c81:b0:881:87de:a336 with SMTP id ca18e2360f4ac-886bd25af01mr900979439f.5.1756318258537;
        Wed, 27 Aug 2025 11:10:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-886c8fc6d7fsm862725139f.21.2025.08.27.11.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:10:57 -0700 (PDT)
Date: Wed, 27 Aug 2025 12:10:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, jgg@nvidia.com, torvalds@linux-foundation.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, farman@linux.ibm.com, Jason
 Gunthorpe <jgg@ziepe.ca>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Message-ID: <20250827121055.548e1584.alex.williamson@redhat.com>
In-Reply-To: <20250814064714.56485-2-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
	<20250814064714.56485-2-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 14 Aug 2025 14:47:10 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Let's add a simple helper for determining the number of contiguous pages
> that represent contiguous PFNs.
> 
> In an ideal world, this helper would be simpler or not even required.
> Unfortunately, on some configs we still have to maintain (SPARSEMEM
> without VMEMMAP), the memmap is allocated per memory section, and we might
> run into weird corner cases of false positives when blindly testing for
> contiguous pages only.
> 
> One example of such false positives would be a memory section-sized hole
> that does not have a memmap. The surrounding memory sections might get
> "struct pages" that are contiguous, but the PFNs are actually not.
> 
> This helper will, for example, be useful for determining contiguous PFNs
> in a GUP result, to batch further operations across returned "struct
> page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> process.
> 
> Implementation based on Linus' suggestions to avoid new usage of
> nth_page() where avoidable.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h        |  7 ++++++-
>  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+), 1 deletion(-)


Does this need any re-evaluation after Willy's series?[1]  Patch 2/
changes page_to_section() to memdesc_section() which takes a new
memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
mm has many subtleties.

Ideally we could also avoid merge-time fixups for linux-next and
mainline.

Andrew, are you open to topic branch for Willy's series that I could
merge into vfio/next when it's considered stable?  Thanks,

Alex

[1]https://lore.kernel.org/all/20250805172307.1302730-3-willy@infradead.org/T/#u

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..ead6724972cf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
>  {
>  	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long page_to_section(const struct page *page)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>  
>  /**
>   * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..5ea23891fe4c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>  	return true;
>  }
>  
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *			    that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In kernel configs where contiguous pages might not imply contiguous PFNs
> + * over memory section boundaries, this function will stop at the memory
> + * section boundary.
> + *
> + * Returns the number of contiguous pages.
> + */
> +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> +{
> +	struct page *cur_page = pages[0];
> +	unsigned long section = page_to_section(cur_page);
> +	size_t i;
> +
> +	for (i = 1; i < nr_pages; i++) {
> +		if (++cur_page != pages[i])
> +			break;
> +		/*
> +		 * In unproblematic kernel configs, page_to_section() == 0 and
> +		 * the whole check will get optimized out.
> +		 */
> +		if (page_to_section(cur_page) != section)
> +			break;
> +	}
> +
> +	return i;
> +}
> +
>  #endif


