Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D2C1C3E00
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgEDPCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729175AbgEDPCx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 11:02:53 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D41C061A0F
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 08:02:53 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 71so14181713qtc.12
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 08:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pEkcpc7p0hbqyGBvGeqY9qBw2K4+umYg84O9K1LJmhc=;
        b=O0/SsYEiyh30CWZLFLhKk3Af1Wm0y9ombP0AB9Yw4eoIhhAd6zxECAB3Jr8X7FHerb
         hXa4OaYfd7mx+fHn8xkDxEqqs3tInN81Mnyo9I5BjL0eOqfqu0udT2cWW08TWh3A+OhV
         LO+0v1LdAK5UwgnZms3jdNhK6of9dg0/+xWFC9LIa7w3Mwv94iOcmjJ5IZyeiFfb4Mpf
         h02KPAjWm4U0AYrICAUPZ+3LdwuQQsDrrghLsnGh/z1P6gpdFucK+ZNEw157Q7oVibWj
         f6WMcN8en2o3CqrhPKmfVIHR8+WpSxgEf9qY0w0eaw4X70ro1gH2aXf8LbNthC+nxNAm
         HH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pEkcpc7p0hbqyGBvGeqY9qBw2K4+umYg84O9K1LJmhc=;
        b=KEUVy2+mhqSb/6Z0vq62OULu9phObUM5rkL/zWaOML7USW5ksZYK/aWBUz649lZk/t
         v40l8//esitu09SWEfpAVXLJrvdzGOurQPtOwHfGp5/1lfCfHy/xbzUvCsWlloFOzGon
         /+NT1BkhgfjUmW7GXD68EG9ZX4EgS6GFZhMag/uq6wJVEHta7BrwLGPufm9QCcdBxI2S
         W2hgBoL6CcEyNX7SbdH8o2p5nAot2ZYOHrCpfhnpb9pJkKN1QPMd/enJXA75RMqWjGT/
         +khzUTWJT/TwQl/Qbvi1PP5eAetF0ten7fQt8ELrNHY/97R16M4rsPCS1rcx4cjQK1WC
         T23w==
X-Gm-Message-State: AGi0PubQCdbnyJpab1Jln4meK47kCk6zeJkIuSKJwMe2ckHn7OPC2jRU
        VWIQtiRIJGaUT5f4QV+6IcblFA==
X-Google-Smtp-Source: APiQypJy7lN7noG6hTnCNDGaF3L0TkUKhOXDytH7FtT7xvOcceX25Rfo7r4RyXyJv2kdUAEoUX+vxg==
X-Received: by 2002:ac8:4cce:: with SMTP id l14mr17188342qtv.31.1588604572499;
        Mon, 04 May 2020 08:02:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id j25sm10646608qtn.21.2020.05.04.08.02.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 08:02:50 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVccK-0000Gm-Od; Mon, 04 May 2020 12:02:48 -0300
Date:   Mon, 4 May 2020 12:02:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 1/3] vfio/type1: Support faulting PFNMAP vmas
Message-ID: <20200504150248.GW26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836914801.8433.9711545991918184183.stgit@gimli.home>
 <20200501235033.GA19929@ziepe.ca>
 <20200504080630.293f33e8@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504080630.293f33e8@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 08:06:30AM -0600, Alex Williamson wrote:
> On Fri, 1 May 2020 20:50:33 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Fri, May 01, 2020 at 03:39:08PM -0600, Alex Williamson wrote:
> > > With conversion to follow_pfn(), DMA mapping a PFNMAP range depends on
> > > the range being faulted into the vma.  Add support to manually provide
> > > that, in the same way as done on KVM with hva_to_pfn_remapped().
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >  drivers/vfio/vfio_iommu_type1.c |   36 +++++++++++++++++++++++++++++++++---
> > >  1 file changed, 33 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > index cc1d64765ce7..4a4cb7cd86b2 100644
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -317,6 +317,32 @@ static int put_pfn(unsigned long pfn, int prot)
> > >  	return 0;
> > >  }
> > >  
> > > +static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> > > +			    unsigned long vaddr, unsigned long *pfn,
> > > +			    bool write_fault)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = follow_pfn(vma, vaddr, pfn);
> > > +	if (ret) {
> > > +		bool unlocked = false;
> > > +
> > > +		ret = fixup_user_fault(NULL, mm, vaddr,
> > > +				       FAULT_FLAG_REMOTE |
> > > +				       (write_fault ?  FAULT_FLAG_WRITE : 0),
> > > +				       &unlocked);
> > > +		if (unlocked)
> > > +			return -EAGAIN;
> > > +
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		ret = follow_pfn(vma, vaddr, pfn);
> > > +	}
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >  static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> > >  			 int prot, unsigned long *pfn)
> > >  {
> > > @@ -339,12 +365,16 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> > >  
> > >  	vaddr = untagged_addr(vaddr);
> > >  
> > > +retry:
> > >  	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
> > >  
> > >  	if (vma && vma->vm_flags & VM_PFNMAP) {
> > > -		if (!follow_pfn(vma, vaddr, pfn) &&
> > > -		    is_invalid_reserved_pfn(*pfn))
> > > -			ret = 0;
> > > +		ret = follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMMU_WRITE);
> > > +		if (ret == -EAGAIN)
> > > +			goto retry;
> > > +
> > > +		if (!ret && !is_invalid_reserved_pfn(*pfn))
> > > +			ret = -EFAULT;  
> > 
> > I suggest checking vma->vm_ops == &vfio_pci_mmap_ops and adding a
> > comment that this is racy and needs to be fixed up. The ops check
> > makes this only used by other vfio bars and should prevent some
> > abuses of this hacky thing
> 
> We can't do that, vfio-pci is only one bus driver within the vfio
> ecosystem.

Given this flow is already hacky, maybe it is OK?

> > However, I wonder if this chould just link itself into the
> > vma->private data so that when the vfio that owns the bar goes away,
> > so does the iommu mapping?
> 
> I don't really see why we wouldn't use mmu notifiers so that the vfio
> iommu backend and vfio bus driver remain independent.

mmu notifiers have tended to be complicated enough that if they can be
avoided it is usually better.

eg you can't just use mmu notifiers here, you have to use an entire
whole pinless page faulting scheme with the locking like
hmm_range_fault uses.

You also have to be very very careful with locking around invalidation
of the iommu to avoid deadlock. For instance the notifier invalidate
cannot do GFP_KERNEL memory allocations.

Jason
