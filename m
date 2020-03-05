Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90517AF68
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 21:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCEUKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 15:10:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24496 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726143AbgCEUKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 15:10:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583439012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYZ2n1xMZLivviLHsnglpanRdiwk22YuyxCTtEByNBg=;
        b=iNekt469ER0jokNxGVA1RpXMGru0pDgjExa1ptBG+Ge5gOvYesXslh5pmmD0EVUOjTm3ol
        jg2eDui4xaKdKzGBvvLOBdZkHoaK66cFRiefbR34X2xhRR0CvQCQxX10PZo27Zqh6rkGsJ
        BGi9deKwtfGZfy/wxomKkvr9nQUh+8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-OqEN0Qt6O_aNHNjTzZwc8g-1; Thu, 05 Mar 2020 15:10:10 -0500
X-MC-Unique: OqEN0Qt6O_aNHNjTzZwc8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2915800053;
        Thu,  5 Mar 2020 20:10:08 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FDCC5DA81;
        Thu,  5 Mar 2020 20:10:04 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:10:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thanos Makatos <thanos.makatos@nutanix.com>
Cc:     "vfio-users@redhat.com" <vfio-users@redhat.com>,
        Swapnil Ingle <swapnil.ingle@nutanix.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        "Raphael@mx0b-002c1b01.pphosted.com" 
        <Raphael@mx0b-002c1b01.pphosted.com>,
        Felipe Franciosi <felipe@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [vfio-users] missing VFIO_IOMMU_NOTIFY_DMA_UNMAP event when
 driver hasn't called vfio_pin_pages
Message-ID: <20200305131003.2a08ea7a@w520.home>
In-Reply-To: <MN2PR02MB620535DA7C5C1DDB36B74B6B8BE80@MN2PR02MB6205.namprd02.prod.outlook.com>
References: <MN2PR02MB6205025CD5FBD8E9E9FAF5EA8BED0@MN2PR02MB6205.namprd02.prod.outlook.com>
        <MN2PR02MB620535DA7C5C1DDB36B74B6B8BE80@MN2PR02MB6205.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Probably better to ask on the vfio devel list (kvm) rather than the
vfio user's list...

On Fri, 28 Feb 2020 17:20:20 +0000
Thanos Makatos <thanos.makatos@nutanix.com> wrote:

> > Drivers that handle DMA region registration events without having to call
> > vfio_pin_pages (e.g. in muser we inject the fd backing that VMA to a
> > userspace
> > process and then ask it to memory map that fd) aren't notified at all when
> > that
> > region is unmapped.  Because of this, we get duplicate/overlapping DMA
> > regions
> > that can be problematic to properly handle (e.g. we can implicitly unmap the
> > existing region etc.). Would it make sense for VFIO to always send the DMA
> > unregistration event to a driver (or at least conditionally, if the driver
> > requests it with some flag during driver registration time), even if it doesn't
> > currently have any pages pinned? I think this could be beneficial for drivers
> > other than muser, e.g. some driver set up some bookkeeping data structure
> > in
> > response to the DMA_MAP event but it didn't happen to have to pin any
> > page. By
> > receiving the DMA_UNMAP event it could release that data
> > structure/memory.
> > 
> > I've experimented with a proof of concept which seems to work:
> > 
> > # git diff --cached
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c
> > index d864277ea16f..2aaa88f64c67 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -875,6 +875,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu
> > *iommu,
> >         struct vfio_dma *dma, *dma_last = NULL;
> >         size_t unmapped = 0;
> >         int ret = 0, retries = 0;
> > +       bool advised = false;
> > 
> >         mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> > 
> > @@ -944,9 +945,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu
> > *iommu,
> >                 if (dma->task->mm != current->mm)
> >                         break;
> > 
> > -               if (!RB_EMPTY_ROOT(&dma->pfn_list)) {
> > +               if (!RB_EMPTY_ROOT(&dma->pfn_list) || !advised) {
> >                         struct vfio_iommu_type1_dma_unmap nb_unmap;
> > 
> > +                       advised = true;
> > +

The while() loop iterates over every overlapping mapping, but this
would only advise on the first overlap.  I think instead of this
advised bool logic you'd only unlock the iommu->lock and take the
again: goto if there were pinned pages.

> >                         if (dma_last == dma) {
> >                                 BUG_ON(++retries > 10);
> >                         } else {  
> 
> I have also experimented with sending two overlapping DMA regions to VFIO and
> vfio_dma_do_map explicitly fails this operation with -EEXIST. Therefore I could
> assume that if my driver receives two overlapping DMA regions then the existing
> one can be safely unmapped. However, there is still a possibility of resource
> leak since there is no guarantee that at least part of an unmapped DMA region
> will be clobbered by another one. This could be partially mitigated by
> introducing some timeout to unmap the fd of a DMA region that hasn't been
> accessed for some time (and then mmap it on demand if necessary), but it's still
> not ideal.

Seems like the approach you'd take only after exhausting all options to
get an unmap notification, which we certainly haven't yet.
 
> I still think giving the option to mdev drivers to request to be notified
> for DMA unmap events is the best way to solve this problem. Are there other
> alternatives?

I don't have an immediate problem with using the existing notifier
regardless of whether pages are pinned.  If we had to we could use
another event bit to select all unmaps versus only unmaps overlapping
pinned pages.  Thanks,

Alex

