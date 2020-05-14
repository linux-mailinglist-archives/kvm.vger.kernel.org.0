Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49E51D2633
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 07:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgENFCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 01:02:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48482 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbgENFCE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 01:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589432522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LGl3hQ6jGEPFYk2qkojWn52Vuj/W0QDDdOeJbURBeJE=;
        b=Z0gYBJ2ag6QXcdGCeNFKa0r/aW/PYrGB3zvM4Fy3LWwbO0tCfbmV5ZRrL04bR/4Q20bGxQ
        B/PIIGxNp0WalL3yY4qIucs/h5ZnuwRDVKx/lsf600/jkhY/WE0XijJKJz02RzcVblnwhI
        fFG+BCykSy/FhkM+Ua9/hrAYUpXtnPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-tdxmD7RlMoaXV6xooKYw7Q-1; Thu, 14 May 2020 01:02:00 -0400
X-MC-Unique: tdxmD7RlMoaXV6xooKYw7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2200E106B207;
        Thu, 14 May 2020 05:01:58 +0000 (UTC)
Received: from x1.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2EC55D9C5;
        Thu, 14 May 2020 05:01:53 +0000 (UTC)
Date:   Wed, 13 May 2020 23:01:53 -0600
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
Subject: Re: [PATCH Kernel v19 7/8] vfio iommu: Add migration capability to
 report supported features
Message-ID: <20200513230153.0b5f3729@x1.home>
In-Reply-To: <1589400279-28522-8-git-send-email-kwankhede@nvidia.com>
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
        <1589400279-28522-8-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 May 2020 01:34:38 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> Added migration capability in IOMMU info chain.
> User application should check IOMMU info chain for migration capability
> to use dirty page tracking feature provided by kernel module.
> User application must check page sizes supported and maximum dirty
> bitmap size returned by this capability structure for ioctls used to get
> dirty bitmap.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 24 +++++++++++++++++++++++-
>  include/uapi/linux/vfio.h       | 21 +++++++++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 4358be26ff80..77351497a9c2 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2389,6 +2389,22 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
> +					   struct vfio_info_cap *caps)
> +{
> +	struct vfio_iommu_type1_info_cap_migration cap_mig;
> +
> +	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
> +	cap_mig.header.version = 1;
> +	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
> +
> +	/* support minimum pgsize */
> +	cap_mig.pgsize_bitmap = (size_t)1 << __ffs(iommu->pgsize_bitmap);
> +	cap_mig.max_dirty_bitmap_size = DIRTY_BITMAP_SIZE_MAX;
> +
> +	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2433,10 +2449,16 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		mutex_lock(&iommu->lock);
>  		info.flags = VFIO_IOMMU_INFO_PGSIZES;
>  
> +		vfio_pgsize_bitmap(iommu);


Why is it necessary to rebuild the bitmap here?  The user can't get to
this ioctl until they've added a group to the container and set the
IOMMU model.


>  		info.iova_pgsizes = iommu->pgsize_bitmap;
>  
> -		ret = vfio_iommu_iova_build_caps(iommu, &caps);
> +		ret = vfio_iommu_migration_build_caps(iommu, &caps);
> +
> +		if (!ret)
> +			ret = vfio_iommu_iova_build_caps(iommu, &caps);
> +
>  		mutex_unlock(&iommu->lock);
> +
>  		if (ret)
>  			return ret;
>  
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index e3cbf8b78623..c90604322798 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1013,6 +1013,27 @@ struct vfio_iommu_type1_info_cap_iova_range {
>  	struct	vfio_iova_range iova_ranges[];
>  };
>  
> +/*
> + * The migration capability allows to report supported features for migration.
> + *
> + * The structures below define version 1 of this capability.
> + *
> + * pgsize_bitmap: Kernel driver returns supported page sizes bitmap for dirty
> + * page tracking.
> + * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
> + * size in bytes to be used by user application for ioctls to get dirty bitmap.
> + */
> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
> +
> +struct vfio_iommu_type1_info_cap_migration {
> +	struct	vfio_info_cap_header header;
> +	__u32	flags;
> +	/* supports dirty page tracking */
> +#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)

This flag is a bit redundant to the purpose of this capability, isn't
it?  I think exposing the capability itself is indicating support for
dirty page tracking.  We should probably be explicit in the comment
about exactly what interface this capability implies.  Thanks,

Alex

> +	__u64	pgsize_bitmap;
> +	__u64	max_dirty_bitmap_size;		/* in bytes */
> +};
> +
>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>  
>  /**

