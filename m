Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1FB1DB028
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 12:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgETK3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 06:29:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50020 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726224AbgETK3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 06:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589970556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j7Qa636nr77ozit91n4CLVmdB0iFZ+gh72rScJACoHw=;
        b=etXrbDj9JKS4k3dVEj0qJcwOso63JFiLOx88bSoVyX/A9PoAut1ZUXdsiipVIFG5wK9t3i
        4ckoTOKjnbCAXudL3uEMbTQvL8lm2ph+/FxA0IpFaU1L4Nv8u7KAXdYAGCj8fOhRN3cKPv
        d41tVjE+4em1vPsNZJzBG/jvVFJh7l0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-sewPRTkzPD2PrbfB3t4NVg-1; Wed, 20 May 2020 06:29:12 -0400
X-MC-Unique: sewPRTkzPD2PrbfB3t4NVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 246C81005510;
        Wed, 20 May 2020 10:29:10 +0000 (UTC)
Received: from gondolin (ovpn-113-5.ams2.redhat.com [10.36.113.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9049F1943D;
        Wed, 20 May 2020 10:29:02 +0000 (UTC)
Date:   Wed, 20 May 2020 12:27:38 +0200
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
Subject: Re: [PATCH Kernel v22 6/8] vfio iommu: Update UNMAP_DMA ioctl to
 get dirty bitmap before unmap
Message-ID: <20200520122738.351985a3.cohuck@redhat.com>
In-Reply-To: <1589871253-10650-1-git-send-email-kwankhede@nvidia.com>
References: <1589781397-28368-7-git-send-email-kwankhede@nvidia.com>
        <1589871253-10650-1-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 May 2020 12:24:13 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> DMA mapped pages, including those pinned by mdev vendor drivers, might
> get unpinned and unmapped while migration is active and device is still
> running. For example, in pre-copy phase while guest driver could access
> those pages, host device or vendor driver can dirty these mapped pages.
> Such pages should be marked dirty so as to maintain memory consistency
> for a user making use of dirty page tracking.
> 
> To get bitmap during unmap, user should allocate memory for bitmap, set
> it all zeros, set size of allocated memory, set page size to be
> considered for bitmap and set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
> 
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 62 +++++++++++++++++++++++++++++++++--------
>  include/uapi/linux/vfio.h       | 10 +++++++
>  2 files changed, 61 insertions(+), 11 deletions(-)

(...)

> @@ -1085,6 +1093,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			ret = -EINVAL;
>  			goto unlock;
>  		}
> +

Nit: unrelated whitespace change.

>  		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
>  		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
>  			ret = -EINVAL;

(...)

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 4850c1fef1f8..a1dd2150971e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1048,12 +1048,22 @@ struct vfio_bitmap {
>   * field.  No guarantee is made to the user that arbitrary unmaps of iova
>   * or size different from those used in the original mapping call will
>   * succeed.
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap

s/dirty bitmap/the dirty bitmap/

> + * before unmapping IO virtual addresses. When this flag is set, user must

s/user/the user/

> + * provide data[] as structure vfio_bitmap. User must allocate memory to get

"provide a struct vfio_bitmap in data[]" ?


> + * bitmap, zero the bitmap memory and must set size of allocated memory in
> + * vfio_bitmap.size field.

"The user must provide zero-allocated memory via vfio_bitmap.data and
its size in the vfio_bitmap.size field." ?


> A bit in bitmap represents one page of user provided

s/bitmap/the bitmap/

> + * page size in 'pgsize', consecutively starting from iova offset. Bit set

s/Bit set/A set bit/

> + * indicates page at that offset from iova is dirty. Bitmap of pages in the

s/indicates page/indicates that the page/

> + * range of unmapped size is returned in vfio_bitmap.data

"A bitmap of the pages in the range of the unmapped size is returned in
the user-provided vfio_bitmap.data." ?

>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>  	__u64	iova;				/* IO virtual address */
>  	__u64	size;				/* Size of mapping (bytes) */
> +	__u8    data[];
>  };
>  
>  #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)

With the nits addressed,
Reviewed-by: Cornelia Huck <cohuck@redhat.com>

