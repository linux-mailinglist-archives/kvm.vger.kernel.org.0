Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EF6332F68
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 20:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhCIT5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 14:57:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231313AbhCIT4t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 14:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615319808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zFVpycpZHtVMdvFk5Dnq9yKM0ZpsUG8FNKf17uIyDA=;
        b=WnHHdGz9WN+nTDhMmgGJMPxRb8XFamBgDoDXcBu4ZgBjJAPUDH3ora7ExquJsUqqEGIRYM
        AYvxXb4FzkEqzxoCE5Z4U6He5A/UoN2Ksl7peBKK5u/3yhWsIowHr4iyRIfb+oTvLSDDFj
        uy1KIVnF8fZMGvaFzX4qYo9zfflAEDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-0FK79J_kMa2LRacfDn0vrQ-1; Tue, 09 Mar 2021 14:56:46 -0500
X-MC-Unique: 0FK79J_kMa2LRacfDn0vrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B47EE1009E38;
        Tue,  9 Mar 2021 19:56:44 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 684915C261;
        Tue,  9 Mar 2021 19:56:40 +0000 (UTC)
Date:   Tue, 9 Mar 2021 12:56:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309125639.70724531@omen.home.shazbot.org>
In-Reply-To: <20210309122607.0b68fb9b@omen.home.shazbot.org>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
        <20210308132106.49da42e2@omen.home.shazbot.org>
        <20210308225626.GN397383@xz-x1>
        <6b98461600f74f2385b9096203fa3611@hisilicon.com>
        <20210309124609.GG2356281@nvidia.com>
        <20210309082951.75f0eb01@x1.home.shazbot.org>
        <20210309164004.GJ2356281@nvidia.com>
        <20210309184739.GD763132@xz-x1>
        <20210309122607.0b68fb9b@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 12:26:07 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 9 Mar 2021 13:47:39 -0500
> Peter Xu <peterx@redhat.com> wrote:
> 
> > On Tue, Mar 09, 2021 at 12:40:04PM -0400, Jason Gunthorpe wrote:  
> > > On Tue, Mar 09, 2021 at 08:29:51AM -0700, Alex Williamson wrote:    
> > > > On Tue, 9 Mar 2021 08:46:09 -0400
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >     
> > > > > On Tue, Mar 09, 2021 at 03:49:09AM +0000, Zengtao (B) wrote:    
> > > > > > Hi guys:
> > > > > > 
> > > > > > Thanks for the helpful comments, after rethinking the issue, I have proposed
> > > > > >  the following change: 
> > > > > > 1. follow_pte instead of follow_pfn.      
> > > > > 
> > > > > Still no on follow_pfn, you don't need it once you use vmf_insert_pfn    
> > > > 
> > > > vmf_insert_pfn() only solves the BUG_ON, follow_pte() is being used
> > > > here to determine whether the translation is already present to avoid
> > > > both duplicate work in inserting the translation and allocating a
> > > > duplicate vma tracking structure.    
> > >  
> > > Oh.. Doing something stateful in fault is not nice at all
> > > 
> > > I would rather see __vfio_pci_add_vma() search the vma_list for dups
> > > than call follow_pfn/pte..    
> > 
> > It seems to me that searching vma list is still the simplest way to fix the
> > problem for the current code base.  I see io_remap_pfn_range() is also used in
> > the new series - maybe that'll need to be moved to where PCI_COMMAND_MEMORY got
> > turned on/off in the new series (I just noticed remap_pfn_range modifies vma
> > flags..), as you suggested in the other email.  
> 
> 
> In the new series, I think the fault handler becomes (untested):
> 
> static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> {
>         struct vm_area_struct *vma = vmf->vma;
>         struct vfio_pci_device *vdev = vma->vm_private_data;
>         unsigned long base_pfn, pgoff;
>         vm_fault_t ret = VM_FAULT_SIGBUS;
> 
>         if (vfio_pci_bar_vma_to_pfn(vma, &base_pfn))
>                 return ret;
> 
>         pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> 
>         down_read(&vdev->memory_lock);
> 
>         if (__vfio_pci_memory_enabled(vdev))
>                 ret = vmf_insert_pfn(vma, vmf->address, pgoff + base_pfn);
> 
>         up_read(&vdev->memory_lock);
> 
>         return ret;
> }

And I think this is what we end up with for the current code base:

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 65e7e6b44578..2f247ab18c66 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1568,19 +1568,24 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
 }
 
 /* Caller holds vma_lock */
-static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
-			      struct vm_area_struct *vma)
+struct vfio_pci_mmap_vma *__vfio_pci_add_vma(struct vfio_pci_device *vdev,
+					     struct vm_area_struct *vma)
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
 
+	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
+		if (mmap_vma->vma == vma)
+			return ERR_PTR(-EEXIST);
+	}
+
 	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
 	if (!mmap_vma)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	mmap_vma->vma = vma;
 	list_add(&mmap_vma->vma_next, &vdev->vma_list);
 
-	return 0;
+	return mmap_vma;
 }
 
 /*
@@ -1612,30 +1617,39 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct vfio_pci_device *vdev = vma->vm_private_data;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
+	struct vfio_pci_mmap_vma *mmap_vma;
+	unsigned long vaddr, pfn;
+	vm_fault_t ret;
 
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
 
 	if (!__vfio_pci_memory_enabled(vdev)) {
 		ret = VM_FAULT_SIGBUS;
-		mutex_unlock(&vdev->vma_lock);
 		goto up_out;
 	}
 
-	if (__vfio_pci_add_vma(vdev, vma)) {
-		ret = VM_FAULT_OOM;
-		mutex_unlock(&vdev->vma_lock);
+	mmap_vma = __vfio_pci_add_vma(vdev, vma);
+	if (IS_ERR(mmap_vma)) {
+		/* A concurrent fault might have already inserted the page */
+		ret = (PTR_ERR(mmap_vma) == -EEXIST) ? VM_FAULT_NOPAGE :
+						       VM_FAULT_OOM;
 		goto up_out;
 	}
 
-	mutex_unlock(&vdev->vma_lock);
-
-	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		ret = VM_FAULT_SIGBUS;
-
+	for (vaddr = vma->vm_start, pfn = vma->vm_pgoff;
+	     vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
+		ret = vmf_insert_pfn(vma, vaddr, pfn);
+		if (ret != VM_FAULT_NOPAGE) {
+			zap_vma_ptes(vma, vma->vm_start,
+				     vma->vm_end - vma->vm_start);
+			list_del(&mmap_vma->vma_next);
+			kfree(mmap_vma);
+			break;
+		}
+	}
 up_out:
+	mutex_unlock(&vdev->vma_lock);
 	up_read(&vdev->memory_lock);
 	return ret;
 }

