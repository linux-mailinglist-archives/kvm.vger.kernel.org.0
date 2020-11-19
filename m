Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4762B98E4
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 18:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgKSRFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 12:05:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728614AbgKSRFN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 12:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605805512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rphq9zvAUmd4d4wT5fgUborloPcVcl2GbeePfTvH6N0=;
        b=SKT/jHAG5yq0bNW7KUNwhSeNyossTwlr2tgpUWXe4tsGw6ugomf7VvsTe1TcUa2mbgtLOH
        5qSZMoVIpVl58WtwaW55xVHvx33rAipqO4y8i4n+3Kh8IPm0zFxAt4HVJT0zY7V1PxYEb2
        bUYgU7ZjW6GQEruO6N2eF/JeGdV1LH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-RZjdcy3WN0i0kC_9VafJCg-1; Thu, 19 Nov 2020 12:05:10 -0500
X-MC-Unique: RZjdcy3WN0i0kC_9VafJCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 633BE8144E1;
        Thu, 19 Nov 2020 17:05:09 +0000 (UTC)
Received: from w520.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AB1F13470;
        Thu, 19 Nov 2020 17:05:09 +0000 (UTC)
Date:   Thu, 19 Nov 2020 10:05:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jia He <justin.he@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201119100508.483c6503@w520.home>
In-Reply-To: <20201119142737.17574-1-justin.he@arm.com>
References: <20201119142737.17574-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Nov 2020 22:27:37 +0800
Jia He <justin.he@arm.com> wrote:

> The permission of vfio iommu is different and incompatible with vma
> permission. If the iotlb->perm is IOMMU_NONE (e.g. qemu side), qemu will
> simply call unmap ioctl() instead of mapping. Hence vfio_dma_map() can't
> map a dma region with NONE permission.
> 
> This corner case will be exposed in coming virtio_fs cache_size
> commit [1]
>  - mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>    memory_region_init_ram_ptr()
>  - re-mmap the above area with read/write authority.
>  - vfio_dma_map() will be invoked when vfio device is hotplug added.
> 
> qemu:
> vfio_listener_region_add()
> 	vfio_dma_map(..., readonly=false)
> 		map.flags is set to VFIO_DMA_MAP_FLAG_READ|VFIO_..._WRITE
> 		ioctl(VFIO_IOMMU_MAP_DMA)
> 
> kernel:
> vfio_dma_do_map()
> 	vfio_pin_map_dma()
> 		vfio_pin_pages_remote()
> 			vaddr_get_pfn()
> 			...
> 				check_vma_flags() failed! because
> 				vm_flags hasn't VM_WRITE && gup_flags
> 				has FOLL_WRITE
> 
> It will report error in qemu log when hotplug adding(vfio) a nvme disk
> to qemu guest on an Ampere EMAG server:
> "VFIO_MAP_DMA failed: Bad address"

I don't fully understand the argument here, I think this is suggesting
that because QEMU won't call VFIO_IOMMU_MAP_DMA on a region that has
NONE permission, the kernel can ignore read/write permission by using
FOLL_FORCE.  Not only is QEMU not the only userspace driver for vfio,
but regardless of that, we can't trust the behavior of any given
userspace driver.  Bypassing the permission check with FOLL_FORCE seems
like it's placing the trust in the user, which seems like a security
issue.  Thanks,

Alex


> [1] https://gitlab.com/virtio-fs/qemu/-/blob/virtio-fs-dev/hw/virtio/vhost-user-fs.c#L502
> 
> Signed-off-by: Jia He <justin.he@arm.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 67e827638995..33faa6b7dbd4 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -453,7 +453,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
>  		flags |= FOLL_WRITE;
>  
>  	mmap_read_lock(mm);
> -	ret = pin_user_pages_remote(mm, vaddr, 1, flags | FOLL_LONGTERM,
> +	ret = pin_user_pages_remote(mm, vaddr, 1,
> +				    flags | FOLL_LONGTERM | FOLL_FORCE,
>  				    page, NULL, NULL);
>  	if (ret == 1) {
>  		*pfn = page_to_pfn(page[0]);

