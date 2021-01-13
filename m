Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1106B2F5383
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 20:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbhAMTnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 14:43:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbhAMTnL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 14:43:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610566904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WzW1F9PArFgMnEfYQjifi0/9Ym/6CdqHKhzABLZ3ntY=;
        b=iCsS6P1iJRpyLV+GRsP0qJ3trtqPNhMo/qo+xUi+DoLdyLkIEl7ISwTjrH9eRs8w6wUGn+
        LJk8r3p7tlvXpqz5xixDmrpMeJMcVFAR3wVrHqNA0+QnHnkUyFUKcAPwB7/zjMVn1MpBSK
        HwLWMv309MHCQ0bhPdUnrTud+No2cgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-dvBdJ8edMCKO_OlxMTbt1Q-1; Wed, 13 Jan 2021 14:41:39 -0500
X-MC-Unique: dvBdJ8edMCKO_OlxMTbt1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCD4510766C5;
        Wed, 13 Jan 2021 19:41:21 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E7685D6A8;
        Wed, 13 Jan 2021 19:41:21 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:41:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 2/5] vfio: option to unmap all
Message-ID: <20210113124121.061e90e8@omen.home.shazbot.org>
In-Reply-To: <c5850c5d-52c4-1f21-30cc-34f9b2d7b7f3@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-3-git-send-email-steven.sistare@oracle.com>
        <20210108123548.033377e7@omen.home>
        <c5850c5d-52c4-1f21-30cc-34f9b2d7b7f3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jan 2021 16:09:18 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 1/8/2021 2:35 PM, Alex Williamson wrote:
> > Hi Steve,
> > 
> > On Tue,  5 Jan 2021 07:36:50 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> For VFIO_IOMMU_UNMAP_DMA, delete all mappings if iova=0 and size=0.  
> > 
> > Only the latter is invalid, iova=0 is not special, so does it make
> > sense to use this combination to invoke something special?  It seems
> > like it opens the door that any size less than the minimum mapping
> > granularity means something special.
> > 
> > Why not use a flag to trigger an unmap-all?  
> 
> Hi Alex, that would be fine.
> 
> > Does userspace have any means to know this is supported other than to
> > test it before creating any mappings?  
> 
> Not currently.  We could overload VFIO_SUSPEND, or define a new extension code.

Either an extension or a capability on the IOMMU_INFO return data.
If I interpret our trend on which to use, an extension seems
appropriate here as were only indicating support for a feature with no
additional data to return.

> > What's the intended interaction with retrieving the dirty bitmap during
> > an unmap-all?  
> 
> Undefined and broken if there are gaps between segments :(  Good catch, thanks.  
> I will disallow the combination of unmap-all and get-dirty-bitmap.
> 
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 11 ++++++++---
> >>  include/uapi/linux/vfio.h       |  3 ++-
> >>  2 files changed, 10 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 02228d0..3dc501d 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -1079,6 +1079,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>  	size_t unmapped = 0, pgsize;
> >>  	int ret = 0, retries = 0;
> >>  	unsigned long pgshift;
> >> +	dma_addr_t iova;
> >> +	unsigned long size;
> >>  
> >>  	mutex_lock(&iommu->lock);
> >>  
> >> @@ -1090,7 +1092,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>  		goto unlock;
> >>  	}
> >>  
> >> -	if (!unmap->size || unmap->size & (pgsize - 1)) {
> >> +	if ((!unmap->size && unmap->iova) || unmap->size & (pgsize - 1)) {
> >>  		ret = -EINVAL;
> >>  		goto unlock;
> >>  	}
> >> @@ -1154,8 +1156,11 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,  
> > 
> > It looks like the code just above this would have an issue if there are
> > dma mappings at iova=0.  
> 
> Are you referring to this code?
> 
>         if (iommu->v2) {
>                 dma = vfio_find_dma(iommu, unmap->iova, 1);
>                 if (dma && dma->iova != unmap->iova) {
>                         ret = -EINVAL;
> 
> Both unmap->iova and dma->iova would be 0, so I don't see the problem.

Yeah, I think I was mistaken.  Thanks,

Alex

> >>  		}
> >>  	}
> >>  
> >> -	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
> >> -		if (!iommu->v2 && unmap->iova > dma->iova)
> >> +	iova = unmap->iova;
> >> +	size = unmap->size ? unmap->size : SIZE_MAX;  
> > 
> > AFAICT the only difference of this versus the user calling the unmap
> > with iova=0 size=SIZE_MAX is that SIZE_MAX will throw an -EINVAL due to
> > page size alignment.  If we assume there are no IOMMUs with 1 byte page
> > size, the special combination could instead be {0, SIZE_MAX}.    
> 
> Fine, but we would still need to document it specifically so the user knows that 
> the unaligned SIZE_MAX does not return EINVAL.
> 
> > Or the
> > caller could just track a high water mark for their mappings and use
> > the interface that exists.  Thanks,  
> 
> I am trying to avoid the need to modify existing code, for legacy qemu live update.
> Either a new flag or {0, SIZE_MAX} is suitable.  Which do you prefer?
> 
> - Steve
>  
> >> +
> >> +	while ((dma = vfio_find_dma(iommu, iova, size))) {
> >> +		if (!iommu->v2 && iova > dma->iova)
> >>  			break;
> >>  		/*
> >>  		 * Task with same address space who mapped this iova range is
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 9204705..896e527 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -1073,7 +1073,8 @@ struct vfio_bitmap {
> >>   * Caller sets argsz.  The actual unmapped size is returned in the size
> >>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
> >>   * or size different from those used in the original mapping call will
> >> - * succeed.
> >> + * succeed.  If iova=0 and size=0, all addresses are unmapped.
> >> + *
> >>   * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
> >>   * before unmapping IO virtual addresses. When this flag is set, the user must
> >>   * provide a struct vfio_bitmap in data[]. User must provide zero-allocated  
> >   
> 

