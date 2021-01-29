Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF3308FB1
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 22:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbhA2V5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 16:57:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231335AbhA2V5U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 16:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611957354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IiHwELk3JC8AN5uej7ay/krqTxRtLqrnidjQlgYRjGI=;
        b=MNqt5Xi8Rp/q3y7v7/Wl8RbmS3K2JJCBTqZWUNPT0cZG9FNffV78gaBh36hxF1Ikw9fEVn
        h3J1s39UCVX9vImoVrQWK5bWf63gV9qlk8guSbddhusXJBaWZGScf1CQkStqMLnXelDdEf
        AIDHn2+VrKmpVajuV1TxoOdPO6QmnXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-QlbMzfKNOxylyZegSNuXZQ-1; Fri, 29 Jan 2021 16:55:51 -0500
X-MC-Unique: QlbMzfKNOxylyZegSNuXZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBF36180A096;
        Fri, 29 Jan 2021 21:55:50 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D300646D6;
        Fri, 29 Jan 2021 21:55:50 +0000 (UTC)
Date:   Fri, 29 Jan 2021 14:55:50 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 0/9] vfio virtual address update
Message-ID: <20210129145550.566d5369@omen.home.shazbot.org>
In-Reply-To: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:03 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Add interfaces that allow the underlying memory object of an iova range
> to be mapped to a new virtual address in the host process:
> 
>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
>   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
>   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
>   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
> 
> Unmap-vaddr invalidates the host virtual address in an iova range and blocks
> vfio translation of host virtual addresses, but DMA to already-mapped pages
> continues.  Map-vaddr updates the base VA and resumes translation.  The
> implementation supports iommu type1 and mediated devices.  Unmap-all allows
> all ranges to be unmapped or invalidated in a single ioctl, which simplifies
> userland code.
> 
> This functionality is necessary for live update, in which a host process
> such as qemu exec's an updated version of itself, while preserving its
> guest and vfio devices.  The process blocks vfio VA translation, exec's
> its new self, mmap's the memory object(s) underlying vfio object, updates
> the VA, and unblocks translation.  For a working example that uses these
> new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
> https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
> 
> Patches 1-3 define and implement the flag to unmap all ranges.
> Patches 4-6 define and implement the flags to update vaddr.
> Patches 7-9 add blocking to complete the implementation.

Hi Steve,

It looks pretty good to me, but I have some nit-picky comments that
I'll follow-up with on the individual patches.  However, I've made the
changes I suggest in a branch that you can find here:

git://github.com/awilliam/linux-vfio.git vaddr-v3

If the changes look ok, just send me an ack, I don't want to attribute
something to you that you don't approve of.  Thanks,

Alex
 
> Changes in V2:
>  - define a flag for unmap all instead of special range values
>  - define the VFIO_UNMAP_ALL extension
>  - forbid the combination of unmap-all and get-dirty-bitmap
>  - unwind in unmap on vaddr error
>  - add a new function to find first dma in a range instead of modifying
>    an existing function
>  - change names of update flags
>  - fix concurrency bugs due to iommu lock being dropped
>  - call down from from vfio to a new backend interface instead of up from
>    driver to detect container close
>  - use wait/wake instead of sleep and polling
>  - refine the uapi specification
>  - split patches into vfio vs type1
> 
> Changes in V3:
>  - add vaddr_invalid_count to fix pin_pages race with unmap
>  - refactor the wait helper functions
>  - traverse dma entries more efficiently in unmap
>  - check unmap flag conflicts more explicitly
>  - rename some local variables and functions
> 
> Steve Sistare (9):
>   vfio: option to unmap all
>   vfio/type1: unmap cleanup
>   vfio/type1: implement unmap all
>   vfio: interfaces to update vaddr
>   vfio/type1: massage unmap iteration
>   vfio/type1: implement interfaces to update vaddr
>   vfio: iommu driver notify callback
>   vfio/type1: implement notify callback
>   vfio/type1: block on invalid vaddr
> 
>  drivers/vfio/vfio.c             |   5 +
>  drivers/vfio/vfio_iommu_type1.c | 251 +++++++++++++++++++++++++++++++++++-----
>  include/linux/vfio.h            |   5 +
>  include/uapi/linux/vfio.h       |  27 +++++
>  4 files changed, 256 insertions(+), 32 deletions(-)
> 

