Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724603B691C
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhF1Tcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 15:32:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236574AbhF1Tcv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 15:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624908624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4aDinynGafajdrFAUt+N4CTx5HYHFQkR8BqRweQ4D0Y=;
        b=A7taKArvEQskwoYze0pIH7Xu654/6OlowtfOLOrEKUr2tggXgDP20QfOqNRQBKu2aizOkA
        ifYyJ+KfFP4Af7/FOj54T0D7UEUGVkT2mMPMG0OPMMvb6qjxCOXc7+xBPol0qIT3K1QrbT
        LRzzinjZh+PN6XPfmKOBrn2LqffGVyE=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-98fOtbEgNXCG0j5A-V-yvw-1; Mon, 28 Jun 2021 15:30:21 -0400
X-MC-Unique: 98fOtbEgNXCG0j5A-V-yvw-1
Received: by mail-ot1-f69.google.com with SMTP id h10-20020a9d600a0000b0290467bd8bd570so419606otj.22
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 12:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4aDinynGafajdrFAUt+N4CTx5HYHFQkR8BqRweQ4D0Y=;
        b=KP0galtoZUxtffdaQmyMyFdyFrYic2vHDQ847nvMbpAgDq9blzOMiKGFci/D6fINTm
         FM5osRwNERmK7TlacvBQp2EwY5dsk724tDMhwf4ihvfmrv+yFE1p8PM96xz/PGiZ2A3c
         f9wngvrykmT3H20j2vPulxqQktfJnM3xd2sd5VXRI1KgeatlxXlxdQ/DumPyGiTt6Eqx
         eYHgQdErZQZanzf95mV2lyeP5jCAyzGnomvcpIP5tTc41jYlNW4ECPLEdGg1mCznpbXo
         3gQhUCwFo67FBv5I+QQN9VIyjymsbXWWi3V4+OU3tkdvpW9k3eyXIWr6Kt6cQfvvwliv
         M7pQ==
X-Gm-Message-State: AOAM531uxh8x2TW7uxwDZv8Pti6Fza2ID3rOfht3Fa8qBkrlMOOW2Icr
        E/tT7pE87XJQRDjEL/83ym1/ENBqVNT7KZH191Vf4hRo5lkVtGvShXXwHZon89LUpueA4QqX+2M
        wJbGFGpouw+1P
X-Received: by 2002:a54:4f99:: with SMTP id g25mr22137015oiy.132.1624908620956;
        Mon, 28 Jun 2021 12:30:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHkDsJ/vlm84kWczYHiEPW2vUWVs3lqbZWoF2KSYi5CmBFOLj4QzsAch5CX8CfxouV5F4pOg==
X-Received: by 2002:a54:4f99:: with SMTP id g25mr22137005oiy.132.1624908620753;
        Mon, 28 Jun 2021 12:30:20 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id y11sm1245357oto.28.2021.06.28.12.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 12:30:20 -0700 (PDT)
Date:   Mon, 28 Jun 2021 13:30:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH v2] vfio/pci: Handle concurrent vma faults
Message-ID: <20210628133019.6a246fec.alex.williamson@redhat.com>
In-Reply-To: <20210628185242.GI4459@nvidia.com>
References: <161540257788.10151.6284852774772157400.stgit@gimli.home>
        <20210628104653.4ca65921.alex.williamson@redhat.com>
        <20210628173028.GF4459@nvidia.com>
        <20210628123621.7fd36a1b.alex.williamson@redhat.com>
        <20210628185242.GI4459@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Jun 2021 15:52:42 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jun 28, 2021 at 12:36:21PM -0600, Alex Williamson wrote:
> > On Mon, 28 Jun 2021 14:30:28 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Mon, Jun 28, 2021 at 10:46:53AM -0600, Alex Williamson wrote:  
> > > > On Wed, 10 Mar 2021 11:58:07 -0700
> > > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > >     
> > > > > vfio_pci_mmap_fault() incorrectly makes use of io_remap_pfn_range()
> > > > > from within a vm_ops fault handler.  This function will trigger a
> > > > > BUG_ON if it encounters a populated pte within the remapped range,
> > > > > where any fault is meant to populate the entire vma.  Concurrent
> > > > > inflight faults to the same vma will therefore hit this issue,
> > > > > triggering traces such as:    
> > > 
> > > If it is just about concurrancy can the vma_lock enclose
> > > io_remap_pfn_range() ?  
> > 
> > We could extend vma_lock around io_remap_pfn_range(), but that alone
> > would just block the concurrent faults to the same vma and once we
> > released them they'd still hit the BUG_ON in io_remap_pfn_range()
> > because the page is no longer pte_none().  We'd need to combine that
> > with something like __vfio_pci_add_vma() returning -EEXIST to skip the
> > io_remap_pfn_range(), but I've been advised that we shouldn't be
> > calling io_remap_pfn_range() from within the fault handler anyway, we
> > should be using something like vmf_insert_pfn() instead, which I
> > understand can be called safely in the same situation.  That's rather
> > the testing I was hoping someone who reproduced the issue previously
> > could validate.  
> 
> Yes, using the vmf_ stuff is 'righter' for sure, but there isn't
> really a vmf for IO mappings..
> 
> > > I assume there is a reason why vm_lock can't be used here, so I
> > > wouldn't object, though I don't especially like the loss of tracking
> > > either.  
> > 
> > There's no loss of tracking here, we were only expecting a single fault
> > per vma to add the vma to our list.  This just skips adding duplicates
> > in these cases where we can have multiple faults in-flight.  Thanks,  
> 
> I mean the arch tracking of IO maps that is hidden inside ioremap_pfn

Ok, so I take it you'd feel more comfortable with something like this,
right?  Thanks,

Alex

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 759dfb118712..74fc66cf9cf4 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1584,6 +1584,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_mmap_vma *mmap_vma;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 
 	mutex_lock(&vdev->vma_lock);
@@ -1591,24 +1592,33 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 
 	if (!__vfio_pci_memory_enabled(vdev)) {
 		ret = VM_FAULT_SIGBUS;
-		mutex_unlock(&vdev->vma_lock);
 		goto up_out;
 	}
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
-		mutex_unlock(&vdev->vma_lock);
-		goto up_out;
+	/*
+	 * Skip existing vmas, assume concurrent in-flight faults to avoid
+	 * BUG_ON from io_remap_pfn_range() hitting !pte_none() pages.
+	 */
+	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
+		if (mmap_vma->vma == vma)
+			goto up_out;
 	}
 
-	mutex_unlock(&vdev->vma_lock);
-
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
+			       vma->vm_end - vma->vm_start,
+			       vma->vm_page_prot)) {
 		ret = VM_FAULT_SIGBUS;
+		goto up_out;
+	}
+
+	if (__vfio_pci_add_vma(vdev, vma)) {
+		ret = VM_FAULT_OOM;
+		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	}
 
 up_out:
 	up_read(&vdev->memory_lock);
+	mutex_unlock(&vdev->vma_lock);
 	return ret;
 }
 

