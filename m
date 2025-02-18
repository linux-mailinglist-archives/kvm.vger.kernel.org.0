Return-Path: <kvm+bounces-38510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFED3A3AC68
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 00:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA77A3AC424
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30921DDA39;
	Tue, 18 Feb 2025 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NkwfLZ+m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675C31D63E8
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 23:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739920457; cv=none; b=dxKGe1zO9nybu2CVBwDcymUza0InMlYn/gRdg6JlWb3c6ch56ru4cGOIyzgKm2aFRLbOF67NBNx+7zC/OtfxaQedyEMGiIyMVCMCWwNlar/CITky1XT0llkOifvi6x5EHarU2CcKLyKLWP1EkTkoNEA4yYCibjWkxlmEggHqYkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739920457; c=relaxed/simple;
	bh=jjzWBHJVFkuw2OOwhCBhesEY1Q7PqUCIlWTyVfPg5rc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIQyizOyjnoaqXkBLLcz+NLkSRdaANxIdSY/hJM7GwE7m4zWJDyCC84qR9BPnpt8uc58nq9SPk11CTfTShj05Vb64otO5gIKYO/bfgkxm885hvLCzfvafwS92ifb7qR7UoAGQkHjZwKzo5YZgmy4eBeC8AhB+XwZs/VwR999acM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NkwfLZ+m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739920454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DHjLr0rLrhNcbSiUqbGgnbUKfct/I7UxqmG8LtAAQkU=;
	b=NkwfLZ+mT2MpvzofIrRHaXW17XVJ1Q23RhMnkPclEZ35HItApqAbUun01cwXSA1wW1DG1L
	Floj8fIA0fdhpKzd0gQJshOXpBpWXVNhVion6rgm6nc6S2MI4Ony9D8bKX8mbEsu2u1wwI
	8FmFmcqwfK3nefgMgpjT5ZeWc6o3uIs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-bTeN5J_rM-axVaLwVUy0kg-1; Tue, 18 Feb 2025 18:14:13 -0500
X-MC-Unique: bTeN5J_rM-axVaLwVUy0kg-1
X-Mimecast-MFC-AGG-ID: bTeN5J_rM-axVaLwVUy0kg_1739920452
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d2849ae884so4566375ab.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 15:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739920452; x=1740525252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHjLr0rLrhNcbSiUqbGgnbUKfct/I7UxqmG8LtAAQkU=;
        b=qqIwvbLtPbiqa+DVtbDhp3XXoo51Yd0w55kJ2JgKWBAJyCgvnrU6SGJ076cERKJBED
         2cnMlaZt6d0uTaTCcnrtLSflCwLGJpJPTfTtomW/0Kg6ByY2lwRBreTLRE66TTdTTo6R
         eJBWoJVhw8eY6YYrwXsOTlO5XvUJLoIe76Rw5XiPWqc39oXf5W17WHta55VG5BPG7moo
         XBfHlMyCXHrHqqWPFxjiQtdzM6ZsqSYA9b+x3dxcLcZKO3LmaeRLPIQmkXf6GLv1xpZN
         sVq/3Xz+x9VN1pS+3lDCp6al5HyGt2XNtuRBCZk+mFcQd8ue5X2gZwgHW5PW0LEoYHeu
         IrQw==
X-Gm-Message-State: AOJu0Yx6pRLtPQdSM7PJA2coQP5XFTcS8jgKhjWZNFkW2oNe3hh2bZ/e
	iA7s0zRY9NtnZ0fKCR1EEKl1Um9ho9khdabOi9U52JUWcVVhxZpupLwSFV3UcoLgWg4DUjjJuoa
	Wd9UDHW/isWW5ANXNwr1XN0wScjmD8JXAeAA4AWUGMkQIAIaVmQ==
X-Gm-Gg: ASbGnctuBFaIX6sAQXa2ASX1KuxLI+oj8B/22dKjxrwu0bbpu988GHi2vL+b1MkitxI
	ZBluIwMkc8iwpddeUGG4g3hG+NxBwLrj2+pYBDll31hN5kSBCl+GhbWO7ytLo30nZpGLL1PyJvO
	F6/RIOqi2OHFGKDNqOyZCiB2iCnd+wVdR/efNPzT4l05shTL5Ex6my/0mrhqgJHah/Imx18U0xb
	9Zap8I5en3K0/6dO7tIo8uPM4E1bqRLEO5P/gavu9JNUzZePAPSgZoG9DZ8bEzdstQvwIQvwwUC
	RT+Awwre
X-Received: by 2002:a05:6e02:1805:b0:3d1:3d56:d15d with SMTP id e9e14a558f8ab-3d280935057mr39369615ab.5.1739920452243;
        Tue, 18 Feb 2025 15:14:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAH7M7t38v508EoBeSUQTl2IBXKA3WOU5bkl7flcWpH68hMGeBPmER9kP9YUKvYlBW9PFl7A==
X-Received: by 2002:a05:6e02:1805:b0:3d1:3d56:d15d with SMTP id e9e14a558f8ab-3d280935057mr39369555ab.5.1739920451911;
        Tue, 18 Feb 2025 15:14:11 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d282233d9dsm18041285ab.40.2025.02.18.15.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 15:14:09 -0800 (PST)
Date: Tue, 18 Feb 2025 16:14:07 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com,
 willy@infradead.org
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250218161407.6ae2b082.alex.williamson@redhat.com>
In-Reply-To: <Z7UOEpgH5pdTBcJP@x1.local>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
	<20250218222209.1382449-7-alex.williamson@redhat.com>
	<Z7UOEpgH5pdTBcJP@x1.local>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 17:47:46 -0500
Peter Xu <peterx@redhat.com> wrote:

> On Tue, Feb 18, 2025 at 03:22:06PM -0700, Alex Williamson wrote:
> > vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud and
> > pmd mappings for well aligned mappings.  follow_pfnmap_start() walks the
> > page table and therefore knows the page mask of the level where the
> > address is found and returns this through follow_pfnmap_args.pgmask.
> > Subsequent pfns from this address until the end of the mapping page are
> > necessarily consecutive.  Use this information to retrieve a range of
> > pfnmap pfns in a single pass.
> > 
> > With optimal mappings and alignment on systems with 1GB pud and 4KB
> > page size, this reduces iterations for DMA mapping PCI BARs by a
> > factor of 256K.  In real world testing, the overhead of iterating
> > pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> > sub-millisecond overhead.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++-------
> >  1 file changed, 16 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index ce661f03f139..0ac56072af9f 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *batch)
> >  
> >  static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> >  			    unsigned long vaddr, unsigned long *pfn,
> > -			    bool write_fault)
> > +			    unsigned long *addr_mask, bool write_fault)
> >  {
> >  	struct follow_pfnmap_args args = { .vma = vma, .address = vaddr };
> >  	int ret;
> > @@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> >  			return ret;
> >  	}
> >  
> > -	if (write_fault && !args.writable)
> > +	if (write_fault && !args.writable) {
> >  		ret = -EFAULT;
> > -	else
> > +	} else {
> >  		*pfn = args.pfn;
> > +		*addr_mask = args.addr_mask;
> > +	}
> >  
> >  	follow_pfnmap_end(&args);
> >  	return ret;
> > @@ -590,15 +592,22 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >  	vma = vma_lookup(mm, vaddr);
> >  
> >  	if (vma && vma->vm_flags & VM_PFNMAP) {
> > -		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> > +		unsigned long addr_mask;
> > +
> > +		ret = follow_fault_pfn(vma, mm, vaddr, pfn, &addr_mask,
> > +				       prot & IOMMU_WRITE);
> >  		if (ret == -EAGAIN)
> >  			goto retry;
> >  
> >  		if (!ret) {
> > -			if (is_invalid_reserved_pfn(*pfn))
> > -				ret = 1;
> > -			else
> > +			if (is_invalid_reserved_pfn(*pfn)) {
> > +				unsigned long epfn;
> > +
> > +				epfn = (*pfn | (~addr_mask >> PAGE_SHIFT)) + 1;
> > +				ret = min_t(long, npages, epfn - *pfn);  
> 
> s/long/unsigned long/?

ret is signed long since it's the function return and needs to be able
to return -errno, so long was the intention here.  Thanks,

Alex
 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> 
> > +			} else {
> >  				ret = -EFAULT;
> > +			}
> >  		}
> >  	}
> >  done:
> > -- 
> > 2.48.1
> >   
> 


