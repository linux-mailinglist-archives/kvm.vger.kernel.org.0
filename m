Return-Path: <kvm+bounces-46731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC41AB9180
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 23:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99C85A03AC5
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 21:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2FD25A2C4;
	Thu, 15 May 2025 21:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCcPBnLM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD346171C9
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 21:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747343995; cv=none; b=Ea+Ug+iFZ40j7wGFOPpiSS8VbgKB3QkxFjnb0cIiDYSyw2GJL1qhz100L5ReQDoe07/J4FgtG+gzOKYIET+ZkyA5oyTM6v24vi2TvSDnb2X3oKAInnebj/VmUMyRdm8xbxOmJuB148d6214Ph4KJWN+20CGsAHPvIR4UBI/4dqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747343995; c=relaxed/simple;
	bh=4wiXHmOwaB+bTuV+f27+EuZejf7nDXNIK1ZW+q2L39s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/w1XgerRSMFkD5CXe2gH0+h54yCEMdB++lwkiERvPDIAitGXUinHyonH+2Qpbf9XpA1ItPRie1LqWrgmD3VA86xOIGYDzdx70HCGtSnyUrwrjt00VupXgokeWDtObbfCpDaax0YAOTubVzG5ow3sgFTn8Bo5dXyhIXFWrK+JBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TCcPBnLM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747343991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uzk3u35YnfRWAKjqSnGb3sIv5A3Wjv1GX0rG/67Xq/0=;
	b=TCcPBnLMGDLQPSDyVK8ufoq59h7BwJK1kl6KsDapr/k//KlKQEZm0qvtYECii8IqOZUYyK
	Vaa30zhQndjfLNSMkNVeEgZWs71WIw7Seu4aCqYe2UrhbYL3c3civD+8nQFXVdOvPMpsq9
	Vj5poO53N8XWOp67WuALd8g2pmM+RSE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-4bdvsh1BMnmDpcUk8pmS_Q-1; Thu, 15 May 2025 17:19:50 -0400
X-MC-Unique: 4bdvsh1BMnmDpcUk8pmS_Q-1
X-Mimecast-MFC-AGG-ID: 4bdvsh1BMnmDpcUk8pmS_Q_1747343989
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-85b46c0e605so23418139f.0
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 14:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747343989; x=1747948789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uzk3u35YnfRWAKjqSnGb3sIv5A3Wjv1GX0rG/67Xq/0=;
        b=kxkiSj9Y5IioVfmOWW/tyA/VqtVNtHPtdm4BYQfkaJ7vaUgvfCMaDk0+x8pdMvuhpw
         sotygiznFBcN+uuF4cpCnmA68vhRWp1Z9kImhE3aDHLvAYGiUf89gVN/7e1wmVpTMo7y
         0R/52bChgt7VOlKrsApK9jR23jx358PwcdLohyGz7pJHmvRoaJIJFROm0XabhW0EOwgB
         LQ16C6SDZFo0WllAayMqEC031o5aJJyxXMcsaYEnJRPNU1Oaiugc/CDk7vJMwRrYNKRj
         8KzR/JZvcKawC8EmGTXSyeZdfgA01oSTBu2fek6YE/xROBIxEc4u2rEoVg6CIbMY/czA
         RY/A==
X-Gm-Message-State: AOJu0Yx2iTSK6xDWs1DQyRApjqaWnXR28j95o8t0iwvWwuQ8O3DYr7lT
	UyRyZiPyrStlPs26SajRqsEsWFDHohK7WV1J6CBn0SVOUBojJ4lL6V6BhSxWBgCgSa0SpgU3wjx
	IVnKQf+n/s1bIdsDnwsPsKQsoHD5mCixPYbKrRCF/aBPdTasTMLrK5Q==
X-Gm-Gg: ASbGncvUYHfPVaz4igiZYovE7dn4SnlbCW7wpAHwyzckAQ0QEyngEvheP4tqwCaj/y7
	rMUm6ISsizIjS5pBVskq6II4TiCPUppQXxwX/QbdYRBeap4I0DDOVsxpjWwohk7bGsasCpxTMkL
	3vOvDH59cwUfF/pEdTbNaQKqQzoYQPNCkc4W7EGgUtmEzf0x4KjSlJc3SY5ImDTXkGdwzxwt0zg
	A/EdVM20tVgp/ad2KayzCI4pfM8dqYHMBBPtVVpgGDF0lDHedUF+ExjSuIGzJYD5Mc37skkmygM
	pgo0k25SIUigs80=
X-Received: by 2002:a05:6602:2d8d:b0:85e:26b0:e7ae with SMTP id ca18e2360f4ac-86a2338cda3mr53438939f.4.1747343989377;
        Thu, 15 May 2025 14:19:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb57pfEPGWSK8bE8t4YVzQQabHKI9Wn1YGu0NSYKmiOZjuXZ2cBHqiHCDm6Aqx/nYgsxPIfw==
X-Received: by 2002:a05:6602:2d8d:b0:85e:26b0:e7ae with SMTP id ca18e2360f4ac-86a2338cda3mr53437939f.4.1747343988970;
        Thu, 15 May 2025 14:19:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c7a7sm91415173.75.2025.05.15.14.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 14:19:48 -0700 (PDT)
Date: Thu, 15 May 2025 15:19:46 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] vfio/type1: optimize vfio_pin_pages_remote() for
 hugetlbfs folio
Message-ID: <20250515151946.1e6edf8b.alex.williamson@redhat.com>
In-Reply-To: <20250513035730.96387-1-lizhe.67@bytedance.com>
References: <20250513035730.96387-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 May 2025 11:57:30 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes hugetlbfs folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> This patch optimize this process by batching the statistics counting
> operations.
> 
> The performance test results for completing the 8G VFIO IOMMU DMA mapping,
> obtained through trace-cmd, are as follows. In this case, the 8G virtual
> address space has been mapped to physical memory using hugetlbfs with
> pagesize=2M.
> 
> Before this patch:
> funcgraph_entry:      # 33813.703 us |  vfio_pin_map_dma();
> 
> After this patch:
> funcgraph_entry:      # 15635.055 us |  vfio_pin_map_dma();
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)

Hi,

Thanks for looking at improvements in this area...

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac56072af9f..bafa7f8c4cc6 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -337,6 +337,30 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
>  	return NULL;
>  }
>  
> +/*
> + * Find a random vfio_pfn that belongs to the range
> + * [iova, iova + PAGE_SIZE * npage)
> + */
> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> +		dma_addr_t iova, unsigned long npage)
> +{
> +	struct vfio_pfn *vpfn;
> +	struct rb_node *node = dma->pfn_list.rb_node;
> +	dma_addr_t end_iova = iova + PAGE_SIZE * npage;
> +
> +	while (node) {
> +		vpfn = rb_entry(node, struct vfio_pfn, node);
> +
> +		if (end_iova <= vpfn->iova)
> +			node = node->rb_left;
> +		else if (iova > vpfn->iova)
> +			node = node->rb_right;
> +		else
> +			return vpfn;
> +	}
> +	return NULL;
> +}

This essentially duplicates vfio_find_vpfn(), where the existing
function only finds a single page.  The existing function should be
extended for this new use case and callers updated.  Also the vfio_pfn
is not "random", it's the first vfio_pfn overlapping the range.

> +
>  static void vfio_link_pfn(struct vfio_dma *dma,
>  			  struct vfio_pfn *new)
>  {
> @@ -670,6 +694,31 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  				iova += (PAGE_SIZE * ret);
>  				continue;
>  			}
> +

Spurious new blank line.

> +		}

A new blank line here would be appreciated.

> +		/* Handle hugetlbfs page */
> +		if (likely(!disable_hugepages) &&

Isn't this already accounted for with npage = 1?

> +				folio_test_hugetlb(page_folio(batch->pages[batch->offset]))) {

I don't follow how this guarantees the entire batch->size is
contiguous.  Isn't it possible that a batch could contain multiple
hugetlb folios?  Is the assumption here only true if folio_nr_pages()
(or specifically the pages remaining) is >= batch->capacity?  What
happens if we try to map the last half of one 2MB hugetlb page and
first half of the non-physically-contiguous next page?  Or what if the
hugetlb size is 64KB and the batch contains multiple folios that are
not physically contiguous?

> +			if (pfn != *pfn_base + pinned)
> +				goto out;
> +
> +			if (!rsvd && !vfio_find_vpfn_range(dma, iova, batch->size)) {
> +				if (!dma->lock_cap &&
> +				    mm->locked_vm + lock_acct + batch->size > limit) {
> +					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> +						__func__, limit << PAGE_SHIFT);
> +					ret = -ENOMEM;
> +					goto unpin_out;
> +				}
> +				pinned += batch->size;
> +				npage -= batch->size;
> +				vaddr += PAGE_SIZE * batch->size;
> +				iova += PAGE_SIZE * batch->size;
> +				lock_acct += batch->size;
> +				batch->offset += batch->size;
> +				batch->size = 0;
> +				continue;
> +			}

There's a lot of duplication with the existing page-iterative loop.  I
think they could be consolidated if we extract the number of known
contiguous pages based on the folio into a variable, default 1.

Also, while this approach is an improvement, it leaves a lot on the
table in scenarios where folio_nr_pages() exceeds batch->capacity.  For
example we're at best incrementing 1GB hugetlb pages in 2MB increments.
We're also wasting a lot of cycles to fill pages points we mostly don't
use.  Thanks,

Alex


