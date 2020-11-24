Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844F32C2E08
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 18:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403912AbgKXRJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 12:09:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403885AbgKXRJE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 12:09:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606237742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5atMwpKAatS9hTVo/mzcGTzZMJlv8pILYgqT1sV3tI=;
        b=SGW/ZOUQ4l6Y4FnWJ7e1MZ+4Jk1UEhqpIR+5cNnEeJDoi4j+pwx0j3kk/dSE2LdYAWUGNK
        1v+4BLyMnAc/Jf0nv1RGXh6hlz1sWm3359RCeMYRRhaV7puWV254A9E66jF7RNEWoUiwGq
        ZnRZlqi1O4FiVuFiqAjoMmPJXBVwXMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-rf_htEO7MVGLXq5-13Ms2Q-1; Tue, 24 Nov 2020 12:08:48 -0500
X-MC-Unique: rf_htEO7MVGLXq5-13Ms2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9824D1016E60;
        Tue, 24 Nov 2020 17:07:55 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 761B15C1A3;
        Tue, 24 Nov 2020 17:07:51 +0000 (UTC)
Date:   Tue, 24 Nov 2020 10:07:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Justin He <Justin.He@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201124100751.793c671f@w520.home>
In-Reply-To: <AM6PR08MB32248D873EDD8923675F2D3BF7FC0@AM6PR08MB3224.eurprd08.prod.outlook.com>
References: <20201119142737.17574-1-justin.he@arm.com>
        <20201119100508.483c6503@w520.home>
        <AM6PR08MB32248D873EDD8923675F2D3BF7FC0@AM6PR08MB3224.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Nov 2020 02:37:32 +0000
Justin He <Justin.He@arm.com> wrote:

> Hi Alex, thanks for the comments.
> See mine below:
> 
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, November 20, 2020 1:05 AM
> > To: Justin He <Justin.He@arm.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
> > vfio_pin_pages_remote()
> >
> > On Thu, 19 Nov 2020 22:27:37 +0800
> > Jia He <justin.he@arm.com> wrote:
> >  
> > > The permission of vfio iommu is different and incompatible with vma
> > > permission. If the iotlb->perm is IOMMU_NONE (e.g. qemu side), qemu will
> > > simply call unmap ioctl() instead of mapping. Hence vfio_dma_map() can't
> > > map a dma region with NONE permission.
> > >
> > > This corner case will be exposed in coming virtio_fs cache_size
> > > commit [1]
> > >  - mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> > >    memory_region_init_ram_ptr()
> > >  - re-mmap the above area with read/write authority.
> > >  - vfio_dma_map() will be invoked when vfio device is hotplug added.
> > >
> > > qemu:
> > > vfio_listener_region_add()
> > > vfio_dma_map(..., readonly=false)
> > > map.flags is set to VFIO_DMA_MAP_FLAG_READ|VFIO_..._WRITE
> > > ioctl(VFIO_IOMMU_MAP_DMA)
> > >
> > > kernel:
> > > vfio_dma_do_map()
> > > vfio_pin_map_dma()
> > > vfio_pin_pages_remote()
> > > vaddr_get_pfn()
> > > ...
> > > check_vma_flags() failed! because
> > > vm_flags hasn't VM_WRITE && gup_flags
> > > has FOLL_WRITE
> > >
> > > It will report error in qemu log when hotplug adding(vfio) a nvme disk
> > > to qemu guest on an Ampere EMAG server:
> > > "VFIO_MAP_DMA failed: Bad address"  
> >
> > I don't fully understand the argument here, I think this is suggesting
> > that because QEMU won't call VFIO_IOMMU_MAP_DMA on a region that has
> > NONE permission, the kernel can ignore read/write permission by using
> > FOLL_FORCE.  Not only is QEMU not the only userspace driver for vfio,
> > but regardless of that, we can't trust the behavior of any given
> > userspace driver.  Bypassing the permission check with FOLL_FORCE seems
> > like it's placing the trust in the user, which seems like a security
> > issue.  Thanks,  
> Yes, this might have side impact on security.
> But besides this simple fix(adding FOLL_FORCE), do you think it is a good
> idea that:
> Qemu provides a special vfio_dma_map_none_perm() to allow mapping a
> region with NONE permission?

If NONE permission implies that we use FOLL_FORCE as described here to
ignore the r+w permissions and trust that the user knows what they're
doing, that seems like a non-starter.  Ultimately I think what you're
describing is a scenario where our current permission check fails and
the solution is probably to extend the check to account for other ways
that a user may have access to a vma rather than bypass the check.
Thanks,

Alex

