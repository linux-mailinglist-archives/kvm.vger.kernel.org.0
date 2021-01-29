Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0449A308AF2
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhA2RHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229661AbhA2RHM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 12:07:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611939945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g65XYsKeVTy5aaNxF3sJpXnm3ZqadQnBeDQa+nMvZR4=;
        b=Xvk974yT+BSEhKd9gPZw7dquYyy9APesraARIpVaOgycFrtNYqMTuw+zRF2La+GFVo5fK5
        m7wLDe5ZNhP+nnCsELj40ip/FBsfVPXq/Y2IZRB3/5CuO8AaafTv4SaGRwBZKGzRbDupSD
        iuJ9VKRgbT+4FSv6Jv+HDf7P09gdR1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-kFskcf8HO0SCGFNG47jfTg-1; Fri, 29 Jan 2021 12:05:43 -0500
X-MC-Unique: kFskcf8HO0SCGFNG47jfTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DC7D192CC42;
        Fri, 29 Jan 2021 17:05:42 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 034E019C66;
        Fri, 29 Jan 2021 17:05:41 +0000 (UTC)
Date:   Fri, 29 Jan 2021 10:05:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH V2 0/9] vfio virtual address update
Message-ID: <20210129100541.5b0c3d0f@omen.home.shazbot.org>
In-Reply-To: <55725169-de0d-4019-f96c-ded20dfde0d7@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
        <55725169-de0d-4019-f96c-ded20dfde0d7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 10:48:10 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> Hi Alex, thanks for the feedback on V2.  Any more comments before I submit V3? 

Nope, I'm ok with your proposals.  Thanks,

Alex

> On 1/19/2021 12:48 PM, Steve Sistare wrote:
> > Add interfaces that allow the underlying memory object of an iova range
> > to be mapped to a new virtual address in the host process:
> > 
> >   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
> >   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
> >   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
> >   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
> >   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
> > 
> > Unmap-vaddr invalidates the host virtual address in an iova range and blocks
> > vfio translation of host virtual addresses, but DMA to already-mapped pages
> > continues.  Map-vaddr updates the base VA and resumes translation.  The
> > implementation supports iommu type1 and mediated devices.  Unmap-all allows
> > all ranges to be unmapped or invalidated in a single ioctl, which simplifies
> > userland code.
> > 
> > This functionality is necessary for live update, in which a host process
> > such as qemu exec's an updated version of itself, while preserving its
> > guest and vfio devices.  The process blocks vfio VA translation, exec's
> > its new self, mmap's the memory object(s) underlying vfio object, updates
> > the VA, and unblocks translation.  For a working example that uses these
> > new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
> > https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
> > 
> > Patches 1-4 define and implement the flag to unmap all ranges.
> > Patches 5-6 define and implement the flags to update vaddr.
> > Patches 7-9 add blocking to complete the implementation.
> > 
> > Changes from V1:
> >  - define a flag for unmap all instead of special range values
> >  - define the VFIO_UNMAP_ALL extension
> >  - forbid the combination of unmap-all and get-dirty-bitmap
> >  - unwind in unmap on vaddr error
> >  - add a new function to find first dma in a range instead of modifying
> >    an existing function
> >  - change names of update flags
> >  - fix concurrency bugs due to iommu lock being dropped
> >  - call down from from vfio to a new backend interface instead of up from
> >    driver to detect container close
> >  - use wait/wake instead of sleep and polling
> >  - refine the uapi specification
> >  - split patches into vfio vs type1
> > 
> > Steve Sistare (9):
> >   vfio: option to unmap all
> >   vfio/type1: find first dma
> >   vfio/type1: unmap cleanup
> >   vfio/type1: implement unmap all
> >   vfio: interfaces to update vaddr
> >   vfio/type1: implement interfaces to update vaddr
> >   vfio: iommu driver notify callback
> >   vfio/type1: implement notify callback
> >   vfio/type1: block on invalid vaddr
> > 
> >  drivers/vfio/vfio.c             |   5 +
> >  drivers/vfio/vfio_iommu_type1.c | 229 ++++++++++++++++++++++++++++++++++------
> >  include/linux/vfio.h            |   5 +
> >  include/uapi/linux/vfio.h       |  27 +++++
> >  4 files changed, 231 insertions(+), 35 deletions(-)
> >   
> 

