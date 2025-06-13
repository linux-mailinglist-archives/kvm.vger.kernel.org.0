Return-Path: <kvm+bounces-49511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C809AAD957C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 690FD1890C26
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E4662BF050;
	Fri, 13 Jun 2025 19:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+xCHb1m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAC23E356
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842508; cv=none; b=biU3KOAMp1t6KUmGB9sPNToHXCO4R1+Y5N9HaaJwzFRdZdGrsPEW+WPG81kbbIUgcNsMI7bbaLC7xVh1Kk2GArD7QXj+bXy6j/xplk8up3cRTfmS+P4CTy/cpratOwlROJdznu7JEcp8em1Jywr/lGhX1upOiC2Vp6iLtjI020o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842508; c=relaxed/simple;
	bh=DI9goXjsgHd0CIIpoV89sIa4Moo1ngQqqygfMWTuukY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h2zKKGETgmEiC83z/wfi0v7Euru+7r42cEh3T8qFZT+1x9JstnOdFB06isLjRE5HzciVF5QAE+7sCE90AD/8DBV/3rH9Sxj7UY7QGNPE+9RALIPowUI2B1cE+MpgjpWGz9eJ6JRnm3S6k07PHMM1n/O8qfx9wx5Tq2URkwWvu2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+xCHb1m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749842505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=47EwzNRArjARKfaIAn0KmpmAVReUeeJkM/EwClBQZtg=;
	b=B+xCHb1m8QA6i4FwnZKQLXd+mYZ9LBwCA6IRoYLbN1UGNz6BE7P7ZgFvF+6n9rk3Ezv+2J
	eJvKpDqnYt5tJ/lsFxWxa1VW0k+q9tTLlMRD92kTVvFnqFVTaLUStQdAB4B47IVhTT/PfR
	8olFfFVNDBfM1GFWMMZVjme+xsslQ4c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-5mzcRdByNxqpPCHhzL60wA-1; Fri, 13 Jun 2025 15:21:44 -0400
X-MC-Unique: 5mzcRdByNxqpPCHhzL60wA-1
X-Mimecast-MFC-AGG-ID: 5mzcRdByNxqpPCHhzL60wA_1749842503
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7cd06c31ad6so507998885a.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 12:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749842503; x=1750447303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47EwzNRArjARKfaIAn0KmpmAVReUeeJkM/EwClBQZtg=;
        b=rmfI50ZBysxpI4czJf0pTxRiK2HUwozErDNFyoWxjJWlEOFsuAT9YYs4TpYJtljdXv
         UzBnV6rwmMoCdABVteIxwrLBdUL8V3YXqgqodCMRXdBFVQ8636Fqm6iSW3sgf2n9ocLk
         FubxONK/Crb0Cep6iBpL7v46ymylnzyMEG2k2sB1BB3E2BUEWOEyderaLYxsfSX1tqCQ
         Bzg/CxZ8UdN9QLyzsSM6fYyx9MGdL6F/A84/oWcf+07dU0g11RN4c7DMefAAZHd13Bke
         uNpmma2fUsqx2mfAYyYXb0FWYCuwv6jhp296WMPLC2XZgg4GFef/kwUSMus52vsj4+Kx
         hsHA==
X-Forwarded-Encrypted: i=1; AJvYcCV0qT/YWNaKhkC6Oh0c5HSWZ2hTrzdJQpjqxCyfeWzNh6kY5Ex2NtUxtmgp92tVnSKAE88=@vger.kernel.org
X-Gm-Message-State: AOJu0YycXpyT8/iOMJMhqac2S7xYb3sh9p9gl4h4YrC9YHyeVsJX4m5V
	gbuGL3wLiVehnQwcRgKkSbNpTyMvepnep3Ew/BjTtw1i6ASTVWhZDAuJ2aM0y/6KqZY/j4nH1pd
	MmFI4xlHuIXzLL6RdoHc4n1fOeIO72TlUCGHqK2Wz8UEdghaAC7bYBw==
X-Gm-Gg: ASbGnctAtpcMA4xZVAkrsXd1uEbZESSEGc6ye+PtECHUA2aanoA5ch5egtaslKxQrTa
	KqtGtkeEfQ9LcG9IDGMiu3oUONtFzvQ78tlmWgA4wYKxq1P/kzpSRaOjylJlL6xPZKgbAkujFWT
	wQDzBY9FMupkoQYj8kdRhYLJJiPoNLCpY706K+indMxzDmJFo8KFM/FKc0PabDCnDYkKubXIxyu
	QyKK2EVQt5iP8GZDCPwxp8fX02sKfMMJxUrFMJUwA1AMV3Rl5C4rfRz3xgqTCmLmEexX2pXh0n1
	53R4dRFqUsL3JQ==
X-Received: by 2002:a05:620a:410c:b0:7cd:3ef0:d1ac with SMTP id af79cd13be357-7d3c6841c5fmr163743185a.15.1749842503544;
        Fri, 13 Jun 2025 12:21:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYPw1DvF4R6o67TB67rLDMELDw3huktfBOSn9E7o8cN6pBp5XOkigzzTV9lHJHGKVi6V/qow==
X-Received: by 2002:a05:620a:410c:b0:7cd:3ef0:d1ac with SMTP id af79cd13be357-7d3c6841c5fmr163739085a.15.1749842503116;
        Fri, 13 Jun 2025 12:21:43 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8df8ee8sm209361985a.28.2025.06.13.12.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 12:21:42 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:21:39 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aEx6Qyl3cgiarXZD@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <d6fbee39-a38f-4f94-bffb-938f7be73681@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6fbee39-a38f-4f94-bffb-938f7be73681@redhat.com>

On Fri, Jun 13, 2025 at 08:09:41PM +0200, David Hildenbrand wrote:
> On 13.06.25 15:41, Peter Xu wrote:
> > This patch enables best-effort mmap() for vfio-pci bars even without
> > MAP_FIXED, so as to utilize huge pfnmaps as much as possible.  It should
> > also avoid userspace changes (switching to MAP_FIXED with pre-aligned VA
> > addresses) to start enabling huge pfnmaps on VFIO bars.
> > 
> > Here the trick is making sure the MMIO PFNs will be aligned with the VAs
> > allocated from mmap() when !MAP_FIXED, so that whatever returned from
> > mmap(!MAP_FIXED) of vfio-pci MMIO regions will be automatically suitable
> > for huge pfnmaps as much as possible.
> > 
> > To achieve that, a custom vfio_device's get_unmapped_area() for vfio-pci
> > devices is needed.
> > 
> > Note that MMIO physical addresses should normally be guaranteed to be
> > always bar-size aligned, hence the bar offset can logically be directly
> > used to do the calculation.  However to make it strict and clear (rather
> > than relying on spec details), we still try to fetch the bar's physical
> > addresses from pci_dev.resource[].
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> There is likely a
> 
> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> 
> missing?

Would it mean the same if we use the two SoBs like what this patch uses?
I sincerely don't know the difference..  I hope it's fine to show that this
patch was developed together.  Please let me know otherwise.

> 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >   drivers/vfio/pci/vfio_pci.c      |  3 ++
> >   drivers/vfio/pci/vfio_pci_core.c | 65 ++++++++++++++++++++++++++++++++
> >   include/linux/vfio_pci_core.h    |  6 +++
> >   3 files changed, 74 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 5ba39f7623bb..d9ae6cdbea28 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -144,6 +144,9 @@ static const struct vfio_device_ops vfio_pci_ops = {
> >   	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
> >   	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
> >   	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
> > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> > +	.get_unmapped_area	= vfio_pci_core_get_unmapped_area,
> > +#endif
> >   };
> >   static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 6328c3a05bcd..835bc168f8b7 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1641,6 +1641,71 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
> >   	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
> >   }
> > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> > +/*
> > + * Hint function to provide mmap() virtual address candidate so as to be
> > + * able to map huge pfnmaps as much as possible.  It is done by aligning
> > + * the VA to the PFN to be mapped in the specific bar.
> > + *
> > + * Note that this function does the minimum check on mmap() parameters to
> > + * make the PFN calculation valid only. The majority of mmap() sanity check
> > + * will be done later in mmap().
> > + */
> > +unsigned long vfio_pci_core_get_unmapped_area(struct vfio_device *device,
> > +					      struct file *file,
> > +					      unsigned long addr,
> > +					      unsigned long len,
> > +					      unsigned long pgoff,
> > +					      unsigned long flags)
> 
> A very suboptimal way to indent this many parameters; just use two tabs at
> the beginning.

This is the default indentation from Emacs c-mode.

Since this is a VFIO file, I checked the file and looks like there's not
yet a strict rule of indentation across the whole file.  I can switch to
two-tabs for sure if nobody else disagrees.

> 
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(device, struct vfio_pci_core_device, vdev);
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	unsigned long ret, phys_len, req_start, phys_addr;
> > +	unsigned int index;
> > +
> > +	index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> 
> Could do
> 
> unsigned int index =  pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> 
> at the very top.

Sure.

> 
> > +
> > +	/* Currently, only bars 0-5 supports huge pfnmap */
> > +	if (index >= VFIO_PCI_ROM_REGION_INDEX)
> > +		goto fallback;
> > +
> > +	/* Bar offset */
> > +	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
> > +	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
> > +
> > +	/*
> > +	 * Make sure we at least can get a valid physical address to do the
> > +	 * math.  If this happens, it will probably fail mmap() later..
> > +	 */
> > +	if (req_start >= phys_len)
> > +		goto fallback;
> > +
> > +	phys_len = MIN(phys_len, len);
> > +	/* Calculate the start of physical address to be mapped */
> > +	phys_addr = pci_resource_start(pdev, index) + req_start;
> > +
> > +	/* Choose the alignment */
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE) {
> > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > +						   flags, PUD_SIZE, 0);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	if (phys_len >= PMD_SIZE) {
> > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > +						   flags, PMD_SIZE, 0);
> > +		if (ret)
> > +			return ret;
> 
> Similar to Jason, I wonder if that logic should reside in the core, and we
> only indicate the maximum page table level we support.

I replied.  We can continue the discussion there.

Thanks,

-- 
Peter Xu


