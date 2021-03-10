Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56DB3346E3
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 19:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhCJSen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 13:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232387AbhCJSeS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 13:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615401255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2zg5A9GRmmUbhQTpSccn6Zg6U2kdiSb2CT/WezBnaxU=;
        b=cQEjw2bPS9KrMOT9vaRF9ISfTGonCMXMlbF8GfPIkheuPhIw0L71kdwD7SQucHZX0mvbML
        IPG959ado/SVgHEhKfmtZvwTB8as830TaB6Zxu5j3pPq8ZnVvC+qOMq1Vvs/iVGADI1KZR
        NPT/hR1ugd9exykRq97mRWifoc3UNWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-9tpFA-piNeewkWb8-_F1Gg-1; Wed, 10 Mar 2021 13:34:14 -0500
X-MC-Unique: 9tpFA-piNeewkWb8-_F1Gg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DFEA69738;
        Wed, 10 Mar 2021 18:34:12 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C59D62461;
        Wed, 10 Mar 2021 18:34:07 +0000 (UTC)
Date:   Wed, 10 Mar 2021 11:34:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210310113406.6f029fcf@omen.home.shazbot.org>
In-Reply-To: <20210310181446.GZ2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
        <20210310181446.GZ2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Mar 2021 14:14:46 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 10, 2021 at 10:53:29AM -0700, Alex Williamson wrote:
> 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 65e7e6b44578..ae723808e08b 100644
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1573,6 +1573,11 @@ static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
> >  {
> >  	struct vfio_pci_mmap_vma *mmap_vma;
> >  
> > +	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
> > +		if (mmap_vma->vma == vma)
> > +			return 0; /* Swallow the error, the vma is tracked */
> > +	}
> > +
> >  	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
> >  	if (!mmap_vma)
> >  		return -ENOMEM;
> > @@ -1612,31 +1617,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > -	vm_fault_t ret = VM_FAULT_NOPAGE;
> > +	unsigned long vaddr = vma->vm_start, pfn = vma->vm_pgoff;
> > +	vm_fault_t ret = VM_FAULT_SIGBUS;
> >  
> >  	mutex_lock(&vdev->vma_lock);
> >  	down_read(&vdev->memory_lock);
> >  
> > -	if (!__vfio_pci_memory_enabled(vdev)) {
> > -		ret = VM_FAULT_SIGBUS;
> > -		mutex_unlock(&vdev->vma_lock);
> > +	if (!__vfio_pci_memory_enabled(vdev))
> >  		goto up_out;
> > +
> > +	for (; vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
> > +		ret = vmf_insert_pfn_prot(vma, vaddr, pfn,
> > +					  pgprot_decrypted(vma->vm_page_prot));  
> 
> I investigated this, I think the above pgprot_decrypted() should be
> moved here:
> 
> static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> {
>         vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +       vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
> 
> 
> And since:
> 
> vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> 			unsigned long pfn)
> {
> 	return vmf_insert_pfn_prot(vma, addr, pfn, vma->vm_page_prot);
> 
> The above can just use vfm_insert_pfn()

Cool, easy enough.  Thanks for looking.
 
> The only thing that makes me nervous about this arrangment is loosing
> the track_pfn_remap() which was in remap_pfn_range() - I think it
> means we miss out on certain PAT manipulations.. I *suspect* this is
> not a problem for VFIO because it will rely on the MTRRs generally on
> x86 - but I also don't know this mechanim too well.

Yeah, for VM use cases the MTRRs generally override.

> I think after the address_space changes this should try to stick with
> a normal io_rmap_pfn_range() done outside the fault handler.

I assume you're suggesting calling io_remap_pfn_range() when device
memory is enabled, do you mean using vma_interval_tree_foreach() like
unmap_mapping_range() does to avoid re-adding a vma list?  Thanks,

Alex

