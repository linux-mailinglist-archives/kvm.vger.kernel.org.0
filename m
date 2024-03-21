Return-Path: <kvm+bounces-12443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC674886335
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A80128563A
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF47C13667F;
	Thu, 21 Mar 2024 22:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/v+PT0P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D2135A50
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 22:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711059626; cv=none; b=SzLa1n7tZVQ06ydT6SD6Y6bJO1wWY7Or6EgzgYdTkXeAfBl7vwqCE7Rg7/8j5zDPqvjk5sneCFa0o8g4VXeWbLef5/Ek7NEKzQBMbPaJQg5AvMJ4Lqjzzl5tUTZGKMSGp2dCIQ6rlD57I0UUIVn5y+TAITumflE/b39k8cz1u9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711059626; c=relaxed/simple;
	bh=/n2jv8rDgKaqJpNpQ+HnJmah8AfLfxdaeNnParnJZkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ly9qE1yci1rVHRRh4ngrW7S8TTCphRWCtEX/T3zJOLKobY6azxO280DNdIeye5G/NovjW+spuk9C2gAbNP2uU7JpZSq7c6R6PblWeYYIKcmpzvGQnHaiuKlf7F46RAk6MKbvZpdB7GGjjH0xVmdxs0hYG/qcFZSRcJXUmG9ma4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/v+PT0P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711059622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sCyRimbdU2wwu1d7eDel2TgdYhJ1/JYW04ucq+z++Uk=;
	b=a/v+PT0P2io2a8ZOS0olF/WnSMbm4HncinyA672xt/Oi7FOCZAeyNVENCd+SaxKQadrTIP
	IH/B508CyiDcJG4IfMitL3G0rUIsuxALy2VkHb2a64bz0zBAxAqPHeJc4rvpdoBGV4ezuA
	UYlCdpK1qtwhnwlDIViOiW9PhSa5lPM=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-sIpbtukQNbGZhHM1JlIEDg-1; Thu, 21 Mar 2024 18:20:21 -0400
X-MC-Unique: sIpbtukQNbGZhHM1JlIEDg-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-2297e8c9eadso398489fac.1
        for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 15:20:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711059621; x=1711664421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCyRimbdU2wwu1d7eDel2TgdYhJ1/JYW04ucq+z++Uk=;
        b=hBUV+Pvivtph4aLP2Igitz3qwQz6aPLsn10tEr67EIsdVcV4EIzOv/P/n8F2oT163V
         7nXaKBUqnI2+IGxYnYJgB1WazWl1NZ5SV/A1mzPR4G+K4D3doJtx9Cp9OBFavPLuAedr
         UVdNMJsSsKPpeMS/VSnWUFlMiiUEK0XXCFRh+c7WGVUM1+g6UWbsN70U0WD1I85l43li
         XYTX4H4G3m1WSZlhSCSLxw3XaLnIIsjFhC//GGtb54bVIx/DA+zlBo9AGBapp9u/lQHC
         M4dZwBRluzx0V6g+wforp7obPKWqc/1dGW4wIPJv5tdR1WRZ1zwaxurmbI7q5Gem2Wf1
         mnMw==
X-Forwarded-Encrypted: i=1; AJvYcCXikgIbyuYFvWdr+eVC9+OxLybayfbIvafl995srIrrCU3n0MBp2Dq5oBAa7H+4Zqc1oLuNX479YvBat/+m22MRJox6
X-Gm-Message-State: AOJu0YyXQDB9z6HBHPbnAudCTngR0KNe5XZHSplZ3kXIaIcTBKtnHP9K
	YZEtYlFPx60wa+Pa1SISitw7neTw3qvyghUEH++EhxbupJ/r/RHy33SenFi9fXPGNSVNKW6yLFw
	L4fijSieK3uy5SWt5L9drbeveyMzbsrb8p9M+jgZVCeSXs2QEoA==
X-Received: by 2002:a05:6870:f80f:b0:229:e46d:763a with SMTP id fr15-20020a056870f80f00b00229e46d763amr219198oab.0.1711059620833;
        Thu, 21 Mar 2024 15:20:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAsJ1BNGnICQuxlCUIGt0YZ8AO8lhg+b2h4UmNz9/iXMpHRYabaisHPwVf7UL0HBtNAl4TZQ==
X-Received: by 2002:a05:6870:f80f:b0:229:e46d:763a with SMTP id fr15-20020a056870f80f00b00229e46d763amr219170oab.0.1711059620305;
        Thu, 21 Mar 2024 15:20:20 -0700 (PDT)
Received: from x1n ([99.254.121.117])
        by smtp.gmail.com with ESMTPSA id pt19-20020a056214049300b00690f23c8605sm374850qvb.23.2024.03.21.15.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 15:20:20 -0700 (PDT)
Date: Thu, 21 Mar 2024 18:20:17 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/userfaultfd: don't place zeropages when
 zeropages are disallowed
Message-ID: <ZfyyodKYWtGki7MO@x1n>
References: <20240321215954.177730-1-david@redhat.com>
 <20240321215954.177730-2-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240321215954.177730-2-david@redhat.com>

On Thu, Mar 21, 2024 at 10:59:53PM +0100, David Hildenbrand wrote:
> s390x must disable shared zeropages for processes running VMs, because
> the VMs could end up making use of "storage keys" or protected
> virtualization, which are incompatible with shared zeropages.
> 
> Yet, with userfaultfd it is possible to insert shared zeropages into
> such processes. Let's fallback to simply allocating a fresh zeroed
> anonymous folio and insert that instead.
> 
> mm_forbids_zeropage() was introduced in commit 593befa6ab74 ("mm: introduce
> mm_forbids_zeropage function"), briefly before userfaultfd went
> upstream.
> 
> Note that we don't want to fail the UFFDIO_ZEROPAGE request like we do
> for hugetlb, it would be rather unexpected. Further, we also
> cannot really indicated "not supported" to user space ahead of time: it
> could be that the MM disallows zeropages after userfaultfd was already
> registered.
> 
> Fixes: c1a4de99fada ("userfaultfd: mcopy_atomic|mfill_zeropage: UFFDIO_COPY|UFFDIO_ZEROPAGE preparation")
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

Still, a few comments below.

> ---
>  mm/userfaultfd.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 712160cd41eca..1d1061ccd1dea 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -316,6 +316,38 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
>  	goto out;
>  }
>  
> +static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> +		 struct vm_area_struct *dst_vma, unsigned long dst_addr)
> +{
> +	struct folio *folio;
> +	int ret;

nitpick: we can set -ENOMEM here, then

> +
> +	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> +	if (!folio)
> +		return -ENOMEM;

return ret;

> +
> +	ret = -ENOMEM;

drop.

> +	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> +		goto out_put;
> +
> +	/*
> +	 * The memory barrier inside __folio_mark_uptodate makes sure that
> +	 * preceding stores to the page contents become visible before
> +	 * the set_pte_at() write.
> +	 */

This comment doesn't apply.  We can drop it.

Thanks,

> +	__folio_mark_uptodate(folio);
> +
> +	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> +				       &folio->page, true, 0);
> +	if (ret)
> +		goto out_put;
> +
> +	return 0;
> +out_put:
> +	folio_put(folio);
> +	return ret;
> +}
> +
>  static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
>  				     struct vm_area_struct *dst_vma,
>  				     unsigned long dst_addr)
> @@ -324,6 +356,9 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
>  	spinlock_t *ptl;
>  	int ret;
>  
> +	if (mm_forbids_zeropage(dst_vma->mm))
> +		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> +
>  	_dst_pte = pte_mkspecial(pfn_pte(my_zero_pfn(dst_addr),
>  					 dst_vma->vm_page_prot));
>  	ret = -EAGAIN;
> -- 
> 2.43.2
> 

-- 
Peter Xu


