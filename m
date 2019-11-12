Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D57F9D04
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 23:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKLWaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 17:30:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726960AbfKLWaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 17:30:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573597824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZX4cLGsoeJ0evGnj3YgZAtBIHFTksN47O88ZYipkno=;
        b=VEcGgpZPUclkMisM0snLkUt/5A2vlaHM5e/6EVl+8TQW87ehPTjp86z7a1ew42bzEHSX9U
        UGiZck34K+WNNSVFJp0M/CAZbqFQXbQxX6gTLAc3Bzk2K2NzKhSnYudN5nYMXqD9tx1yjW
        BTjQbZtG+JB4jZtRfb37KajJofipRWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-K1EeJhRdMome9ky99dcI1Q-1; Tue, 12 Nov 2019 17:30:21 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C5341005509;
        Tue, 12 Nov 2019 22:30:19 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8B4B10027B9;
        Tue, 12 Nov 2019 22:30:17 +0000 (UTC)
Date:   Tue, 12 Nov 2019 15:30:17 -0700
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
Subject: Re: [PATCH v9 Kernel 3/5] vfio iommu: Add ioctl defination to unmap
 IOVA and return dirty bitmap
Message-ID: <20191112153017.3c792673@x1.home>
In-Reply-To: <1573578220-7530-4-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-4-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: K1EeJhRdMome9ky99dcI1Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 22:33:38 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> With vIOMMU, during pre-copy phase of migration, while CPUs are still
> running, IO virtual address unmap can happen while device still keeping
> reference of guest pfns. Those pages should be reported as dirty before
> unmap, so that VFIO user space application can copy content of those page=
s
> from source to destination.
>=20
> IOCTL defination added here add bitmap pointer, size and flag. If flag

definition, adds

> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set and bitmap memory is allocate=
d
> and bitmap_size of set, then ioctl will create bitmap of pinned pages and

s/of/is/

> then unmap those.
>=20
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>=20
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 6fd3822aa610..72fd297baf52 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -925,6 +925,39 @@ struct vfio_iommu_type1_dirty_bitmap {
> =20
>  #define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE=
 + 17)
> =20
> +/**
> + * VFIO_IOMMU_UNMAP_DMA_GET_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
> + *=09=09=09=09      struct vfio_iommu_type1_dma_unmap_bitmap)
> + *
> + * Unmap IO virtual addresses using the provided struct
> + * vfio_iommu_type1_dma_unmap_bitmap.  Caller sets argsz.
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitma=
p
> + * before unmapping IO virtual addresses. If this flag is not set, only =
IO
> + * virtual address are unmapped without creating pinned pages bitmap, th=
at
> + * is, behave same as VFIO_IOMMU_UNMAP_DMA ioctl.
> + * User should allocate memory to get bitmap and should set size of allo=
cated
> + * memory in bitmap_size field. One bit in bitmap is used to represent p=
er page
> + * consecutively starting from iova offset. Bit set indicates page at th=
at
> + * offset from iova is dirty.
> + * The actual unmapped size is returned in the size field and bitmap of =
pages
> + * in the range of unmapped size is returned in bitmap if flag
> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set.
> + *
> + * No guarantee is made to the user that arbitrary unmaps of iova or siz=
e
> + * different from those used in the original mapping call will succeed.
> + */
> +struct vfio_iommu_type1_dma_unmap_bitmap {
> +=09__u32        argsz;
> +=09__u32        flags;
> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> +=09__u64        iova;                        /* IO virtual address */
> +=09__u64        size;                        /* Size of mapping (bytes) =
*/
> +=09__u64        bitmap_size;                 /* in bytes */
> +=09void __user *bitmap;                      /* one bit per page */
> +};
> +
> +#define VFIO_IOMMU_UNMAP_DMA_GET_BITMAP _IO(VFIO_TYPE, VFIO_BASE + 18)
> +

Why not extend VFIO_IOMMU_UNMAP_DMA to support this rather than add an
ioctl that duplicates the functionality and extends it??  Otherwise
same comments as previous, in fact it's too bad we can't use this ioctl
for both, but a DONT_UNMAP flag on the UNMAP_DMA ioctl seems a bit
absurd.

I suspect we also want a flags bit in VFIO_IOMMU_GET_INFO to indicate
these capabilities are supported.

Maybe for both ioctls we also want to define it as the user's
responsibility to zero the bitmap, requiring the kernel to only set
bits as necessary.  Thanks,

Alex

>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU --------=
 */
> =20
>  /*

