Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8D31D4BE7
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 12:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgEOK7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 06:59:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726198AbgEOK7f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 06:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589540373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZGe4aex54z7fpeMiMbDba5RJDjvo5sLYKa4o6ESDlc=;
        b=SEcUGYtbG2nrAPxnpO5oGVbwOakGS2EOczuc7XPtFpdPNEPdARXuOo2q27dpiu/Z2HzT/d
        OzJEAvWFUES4eM765a+s4gGO+TXbZ/CtJjVvcGZUz6u2xNhTrshowvbNKJ3KLjUfuSUwhg
        /Muy1DCCGTihxS8RM4rKpaQ3routVpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-BrA0sVyWOxu-r7zqYtJWYQ-1; Fri, 15 May 2020 06:59:29 -0400
X-MC-Unique: BrA0sVyWOxu-r7zqYtJWYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03DE08018A5;
        Fri, 15 May 2020 10:59:27 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 702551C8;
        Fri, 15 May 2020 10:59:19 +0000 (UTC)
Date:   Fri, 15 May 2020 12:59:16 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH Kernel v20 4/8] vfio iommu: Add ioctl definition for
 dirty pages tracking
Message-ID: <20200515125916.78723321.cohuck@redhat.com>
In-Reply-To: <1589488667-9683-5-git-send-email-kwankhede@nvidia.com>
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
        <1589488667-9683-5-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 May 2020 02:07:43 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
> All pages pinned by vendor driver through this API should be considered as
> dirty during migration. When container consists of IOMMU capable device and
> all pages are pinned and mapped, then all pages are marked dirty.
> Added support to start/stop dirtied pages tracking and to get bitmap of all
> dirtied pages for requested IO virtual address range.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ad9bb5af3463..123de3bc2dce 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1033,6 +1033,12 @@ struct vfio_iommu_type1_dma_map {
>  
>  #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
>  
> +struct vfio_bitmap {
> +	__u64        pgsize;	/* page size for bitmap in bytes */
> +	__u64        size;	/* in bytes */
> +	__u64 __user *data;	/* one bit per page */
> +};
> +
>  /**
>   * VFIO_IOMMU_UNMAP_DMA - _IOWR(VFIO_TYPE, VFIO_BASE + 14,
>   *							struct vfio_dma_unmap)
> @@ -1059,6 +1065,55 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/**
> + * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> + *                                     struct vfio_iommu_type1_dirty_bitmap)
> + * IOCTL is used for dirty pages tracking.
> + * Caller should set flag depending on which operation to perform, details as
> + * below:
> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
> + * migration is active and IOMMU module should track pages which are dirtied or
> + * potentially dirtied by device.

"Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_START instructs the
IOMMU driver to track pages that are dirtied or potentially dirtied by
the device; designed to be used when a migration is in progress."

?

> + * Dirty pages are tracked until tracking is stopped by user application by
> + * setting VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.

"...by calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP." ?

> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
> + * IOMMU should stop tracking dirtied pages.

"Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP instructs the
IOMMU driver to stop tracking dirtied pages."

?

> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
> + * given IOVA range. 

"Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_GET_BITMAP returns the
dirty pages bitmap for the IOMMU container for a given IOVA range." ?

Q: How does this interact with the two other operations? I imagine
getting an empty bitmap before _START and a bitmap-in-progress between
_START and _STOP. After _STOP, will subsequent calls always give the
same bitmap?

> User must provide data[] as the structure
> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range and
> + * pgsize.

"The user must specify the IOVA range and the pgsize through the
vfio_iommu_type1_dirty_bitmap_get structure in the data[] portion."

?

> This interface supports to get bitmap of smallest supported pgsize
> + * only and can be modified in future to get bitmap of specified pgsize.

That's a current restriction? How can the user find out whether it has
been lifted (or, more generally, find out which pgsize values are
supported)?

> + * User must allocate memory for bitmap, zero the bitmap memory  and set size
> + * of allocated memory in bitmap.size field.

"The user must provide a zeroed memory area for the bitmap memory and
specify its size in bitmap.size."

?

> One bit is used to represent one
> + * page consecutively starting from iova offset. User should provide page size
> + * in bitmap.pgsize field. 

s/User/The user/

Is that the 'pgsize' the comment above talks about?

> Bit set in bitmap indicates page at that offset from
> + * iova is dirty. 

"A bit set in the bitmap indicates that the page at that offset from
iova is dirty." ?

> Caller must set argsz including size of structure
> + * vfio_iommu_type1_dirty_bitmap_get.

s/Caller/The caller/

Does argz also include the size of the bitmap?

> + *
> + * Only one of the flags _START, STOP and _GET may be specified at a time.

s/STOP/_STOP/

(just to be consistent)

> + *
> + */
> +struct vfio_iommu_type1_dirty_bitmap {
> +	__u32        argsz;
> +	__u32        flags;
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
> +	__u8         data[];
> +};
> +
> +struct vfio_iommu_type1_dirty_bitmap_get {
> +	__u64              iova;	/* IO virtual address */
> +	__u64              size;	/* Size of iova range */
> +	struct vfio_bitmap bitmap;
> +};

That's for type1 only, right?

> +
> +#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

