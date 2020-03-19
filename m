Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECFC18AB3D
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 04:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCSDpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 23:45:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:58133 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgCSDpB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 23:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584589500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3IrYsm1nDYmYCrl6yeOdU+LoL6XC7ZlPWuzmgcSbtk=;
        b=hni2Wwby6IeMed1xVcMP97rgJOee1yvTSyGyBmkroB4dJvQetl3VUc+ML02/Nxoxj2DXnv
        oU2786DAGvsP/deHWXsfiX86HlWJBy5k/7FnYU8khs5iy71G7bArIZ9Qc6h6ha/Bs/Zbhj
        rCVudX87R6BpBaTYoA4YL2z/TALG3O8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-qH_aF-JePOmZbJ3uP1bOBg-1; Wed, 18 Mar 2020 23:44:56 -0400
X-MC-Unique: qH_aF-JePOmZbJ3uP1bOBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05FE31857BE0;
        Thu, 19 Mar 2020 03:44:53 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB33F6EF97;
        Thu, 19 Mar 2020 03:44:50 +0000 (UTC)
Date:   Wed, 18 Mar 2020 21:44:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v14 Kernel 3/7] vfio iommu: Add ioctl definition for
 dirty pages tracking.
Message-ID: <20200318214450.358ca543@w520.home>
In-Reply-To: <1584560474-19946-4-git-send-email-kwankhede@nvidia.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
        <1584560474-19946-4-git-send-email-kwankhede@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 01:11:10 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
> All pages pinned by vendor driver through this API should be considered as
> dirty during migration. When container consists of IOMMU capable device and
> all pages are pinned and mapped, then all pages are marked dirty.
> Added support to start/stop pinned and unpinned pages tracking and to get
> bitmap of all dirtied pages for requested IO virtual address range.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d0021467af53..043e9eafb255 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -995,6 +995,12 @@ struct vfio_iommu_type1_dma_map {
>  
>  #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
>  
> +struct vfio_bitmap {
> +	__u64        pgsize;	/* page size for bitmap */
> +	__u64        size;	/* in bytes */
> +	__u64 __user *data;	/* one bit per page */
> +};
> +
>  /**
>   * VFIO_IOMMU_UNMAP_DMA - _IOWR(VFIO_TYPE, VFIO_BASE + 14,
>   *							struct vfio_dma_unmap)
> @@ -1021,6 +1027,55 @@ struct vfio_iommu_type1_dma_unmap {
>  #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>  #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/**
> + * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> + *                                     struct vfio_iommu_type1_dirty_bitmap)
> + * IOCTL is used for dirty pages tracking. Caller sets argsz, which is size of
> + * struct vfio_iommu_type1_dirty_bitmap. Caller set flag depend on which
> + * operation to perform, details as below:
> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
> + * migration is active and IOMMU module should track pages which are pinned and
> + * could be dirtied by device.

"...should track" pages dirtied or potentially dirtied by devices.

As soon as we add support for Yan's DMA r/w the pinning requirement is
gone, besides pinning is an in-kernel implementation detail, the user
of this interface doesn't know or care which pages are pinned.

> + * Dirty pages are tracked until tracking is stopped by user application by
> + * setting VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
> + * IOMMU should stop tracking pinned pages.

s/pinned/dirtied/

> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
> + * given IOVA range. User must provide data[] as the structure
> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range and
> + * pgsize. This interface supports to get bitmap of smallest supported pgsize
> + * only and can be modified in future to get bitmap of specified pgsize.
> + * User must allocate memory for bitmap, zero the bitmap memory and set size
> + * of allocated memory in bitmap_size field. One bit is used to represent one
> + * page consecutively starting from iova offset. User should provide page size
> + * in 'pgsize'. Bit set in bitmap indicates page at that offset from iova is
> + * dirty. Caller must set argsz including size of structure
> + * vfio_iommu_type1_dirty_bitmap_get.
> + *
> + * Only one flag should be set at a time.

"Only one of the flags _START, _STOP, and _GET maybe be specified at a
time."  IOW, let's not presume what yet undefined flags may do.
Hopefully this addresses Dave's concern.

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
> +
> +#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>  
>  /*

