Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C797C19000A
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 22:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgCWVLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 17:11:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57193 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgCWVLs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 17:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584997906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4jxkOGkxX4sSb0SR5BuCRAmRA16c3eLjFmjSDZcPB4=;
        b=arE5ogQNzq3QyuzVLwV//5Rd7ufvzk6+EARR4LQ4FKKv/BbQ+vD1Zsmm2AGY3bao9sXhXI
        5DlC6lG8rPjR4ayJk2hlsezi11Ux9kg0okhg8K67XtsSe5npTnS+ugFxpcJni0MDHCIUnA
        jRLMAOfvkbtof2IYMDeJCSONcQdOloc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-z4OB08HLNgmyuHKWU1fQsg-1; Mon, 23 Mar 2020 17:11:41 -0400
X-MC-Unique: z4OB08HLNgmyuHKWU1fQsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09FA8DBE5;
        Mon, 23 Mar 2020 21:11:39 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A473D5C1B5;
        Mon, 23 Mar 2020 21:11:30 +0000 (UTC)
Subject: Re: [PATCH v15 Kernel 3/7] vfio iommu: Add ioctl definition for dirty
 pages tracking.
To:     Kirti Wankhede <kwankhede@nvidia.com>, alex.williamson@redhat.com,
        cjia@nvidia.com
Cc:     kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dgilbert@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@Alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, yan.y.zhao@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
 <1584649004-8285-4-git-send-email-kwankhede@nvidia.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <6c58c249-9dc8-77bd-454e-9418216cdf92@redhat.com>
Date:   Mon, 23 Mar 2020 22:11:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1584649004-8285-4-git-send-email-kwankhede@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kirti,

On 3/19/20 9:16 PM, Kirti Wankhede wrote:
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
> index d0021467af53..8138f94cac15 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -995,6 +995,12 @@ struct vfio_iommu_type1_dma_map {
>  
>  #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
>  
> +struct vfio_bitmap {
> +	__u64        pgsize;	/* page size for bitmap */
in bytes as well
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
> + * IOCTL is used for dirty pages tracking. Caller sets argsz, which is size of> + * struct vfio_iommu_type1_dirty_bitmap.
nit: This may become outdated when adding new fields. argz use mode is
documented at the beginning of the file.

 Caller set flag depend on which
> + * operation to perform, details as below:
> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
> + * migration is active and IOMMU module should track pages which are dirtied or
> + * potentially dirtied by device.
> + * Dirty pages are tracked until tracking is stopped by user application by
> + * setting VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
> + * IOMMU should stop tracking dirtied pages.
> + *
> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
> + * given IOVA range. User must provide data[] as the structure
> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range
I think the fact the IOVA range must match the vfio dma_size must be
documented.
 and
> + * pgsize. This interface supports to get bitmap of smallest supported pgsize
> + * only and can be modified in future to get bitmap of specified pgsize.
> + * User must allocate memory for bitmap, zero the bitmap memory and set size
> + * of allocated memory in bitmap_size field. One bit is used to represent one
> + * page consecutively starting from iova offset. User should provide page size
> + * in 'pgsize'. Bit set in bitmap indicates page at that offset from iova is
> + * dirty. Caller must set argsz including size of structure
> + * vfio_iommu_type1_dirty_bitmap_get.
nit: ditto
> + *
> + * Only one of the flags _START, STOP and _GET may be specified at a time.
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
> 
Thanks

Eric

