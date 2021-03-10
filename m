Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D713335CA
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 07:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhCJGXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 01:23:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231712AbhCJGXi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 01:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615357417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bvmcm1Z6AffB+FtbYmn6dnRksu1IuGypmgnhnVhuQas=;
        b=DV2rloGJwyae4y/fVO5ajg4MSAbIpBoFnE4eFo1MtNydGscVynVuUDPZGOxp8t+kpbasPB
        BRNyPO8+wESAiyRplVHg+nlNL2GMoxDDP21yHo2eeOj+OK0Al9SJr7stD6XiLFqp66JPS8
        VCyGTabuytU9hsQ9b93HS4mf2M0EJB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-yCMDQRjHOlirIKiTqYwfLg-1; Wed, 10 Mar 2021 01:23:33 -0500
X-MC-Unique: yCMDQRjHOlirIKiTqYwfLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B5811005E40;
        Wed, 10 Mar 2021 06:23:31 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E32E36E515;
        Wed, 10 Mar 2021 06:23:25 +0000 (UTC)
Date:   Tue, 9 Mar 2021 23:23:25 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Peter Xu <peterx@redhat.com>,
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
Message-ID: <20210309232325.1ddf4c81@x1.home.shazbot.org>
In-Reply-To: <20210309234503.GN2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
        <20210308132106.49da42e2@omen.home.shazbot.org>
        <20210308225626.GN397383@xz-x1>
        <6b98461600f74f2385b9096203fa3611@hisilicon.com>
        <20210309124609.GG2356281@nvidia.com>
        <20210309082951.75f0eb01@x1.home.shazbot.org>
        <20210309164004.GJ2356281@nvidia.com>
        <20210309184739.GD763132@xz-x1>
        <20210309122607.0b68fb9b@omen.home.shazbot.org>
        <20210309125639.70724531@omen.home.shazbot.org>
        <20210309234503.GN2356281@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 19:45:03 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 09, 2021 at 12:56:39PM -0700, Alex Williamson wrote:
> 
> > And I think this is what we end up with for the current code base:  
> 
> Yeah, that looks Ok
>  
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 65e7e6b44578..2f247ab18c66 100644
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1568,19 +1568,24 @@ void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
> >  }
> >  
> >  /* Caller holds vma_lock */
> > -static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
> > -			      struct vm_area_struct *vma)
> > +struct vfio_pci_mmap_vma *__vfio_pci_add_vma(struct vfio_pci_device *vdev,
> > +					     struct vm_area_struct *vma)
> >  {
> >  	struct vfio_pci_mmap_vma *mmap_vma;
> >  
> > +	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
> > +		if (mmap_vma->vma == vma)
> > +			return ERR_PTR(-EEXIST);
> > +	}
> > +
> >  	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
> >  	if (!mmap_vma)
> > -		return -ENOMEM;
> > +		return ERR_PTR(-ENOMEM);
> >  
> >  	mmap_vma->vma = vma;
> >  	list_add(&mmap_vma->vma_next, &vdev->vma_list);
> >  
> > -	return 0;
> > +	return mmap_vma;
> >  }
> >  
> >  /*
> > @@ -1612,30 +1617,39 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > -	vm_fault_t ret = VM_FAULT_NOPAGE;
> > +	struct vfio_pci_mmap_vma *mmap_vma;
> > +	unsigned long vaddr, pfn;
> > +	vm_fault_t ret;
> >  
> >  	mutex_lock(&vdev->vma_lock);
> >  	down_read(&vdev->memory_lock);
> >  
> >  	if (!__vfio_pci_memory_enabled(vdev)) {
> >  		ret = VM_FAULT_SIGBUS;
> > -		mutex_unlock(&vdev->vma_lock);
> >  		goto up_out;
> >  	}
> >  
> > -	if (__vfio_pci_add_vma(vdev, vma)) {
> > -		ret = VM_FAULT_OOM;
> > -		mutex_unlock(&vdev->vma_lock);
> > +	mmap_vma = __vfio_pci_add_vma(vdev, vma);
> > +	if (IS_ERR(mmap_vma)) {
> > +		/* A concurrent fault might have already inserted the page */
> > +		ret = (PTR_ERR(mmap_vma) == -EEXIST) ? VM_FAULT_NOPAGE :
> > +						       VM_FAULT_OOM;  
> 
> I think -EEIXST should not be an error, lets just go down to the
> vmf_insert_pfn() and let the MM resolve the race naturally.
> 
> I suspect returning VM_FAULT_NOPAGE will be averse to the userspace if
> it hits this race??

Given the serialization on vma_lock, if the vma_list entry exists then
the full vma should already be populated, so I don't see the NOPAGE
issue you're worried about.  However, if we wanted to be more similar
to what we expect the new version to do, we could proceed through
re-inserting the pages on -EEXIST.  Zeng Tao's re-ordering to add the
vma_list entry only after successfully inserting all the pfns might work
better for that.
 
> Also the _prot does look needed at least due to the SME, but possibly
> also to ensure NC gets set..

If we need more than pgprot_decrypted(vma->vm_page_prot), please let us
know, but that's all we were getting from io_remap_pfn_range() afaict.
Thanks,

Alex

