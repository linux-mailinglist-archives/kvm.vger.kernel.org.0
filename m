Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D01F9D03
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 23:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKLWaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 17:30:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54749 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbfKLWaV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Nov 2019 17:30:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573597819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0JM7oNYg0EPl18aNTKn2nrAmbofAf8I7P75C71usJU=;
        b=XFOx0mkvkPtzmqmIN5q9mj/4iEb/5Nh5UcMJL/pItTMpySyVagv/OpYKjCfKzCp3VJirnm
        DoxqCMusyNOM4WjCFb82dCGnSR90QY4vHZg1iXAuuSbEnDrONygdsVjQWIWqIsMNwaA4T4
        T5k2cA0J1sP/kQ7pEr1vLAW3i6mF2Gs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-aAvo5fmfMb-9AQx01nxUnQ-1; Tue, 12 Nov 2019 17:30:16 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DFE11005500;
        Tue, 12 Nov 2019 22:30:14 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BC4E4E;
        Tue, 12 Nov 2019 22:30:12 +0000 (UTC)
Date:   Tue, 12 Nov 2019 15:30:12 -0700
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
Subject: Re: [PATCH v9 Kernel 4/5] vfio iommu: Implementation of ioctl to
 get dirty pages bitmap.
Message-ID: <20191112153012.5200516a@x1.home>
In-Reply-To: <1573578220-7530-5-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-5-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: aAvo5fmfMb-9AQx01nxUnQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 22:33:39 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> IOMMU container maintains list of external pinned pages. Bitmap of pinned
> pages for input IO virtual address range is created and returned.
> IO virtual address range should be from a single mapping created by
> map request. Input bitmap_size is validated by calculating the size of
> requested range.
> This ioctl returns bitmap of dirty pages, its user space application
> responsibility to copy content of dirty pages from source to destination
> during migration.
>=20
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 92 +++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 92 insertions(+)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 2ada8e6cdb88..ac176e672857 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -850,6 +850,81 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_=
iommu *iommu)
>  =09return bitmap;
>  }
> =20
> +/*
> + * start_iova is the reference from where bitmaping started. This is cal=
led
> + * from DMA_UNMAP where start_iova can be different than iova

Why not simply call this with a pointer to the bitmap relative to the
start of the iova?

> + */
> +
> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t i=
ova,
> +=09=09=09=09  size_t size, dma_addr_t start_iova,
> +=09=09=09=09  unsigned long *bitmap)
> +{
> +=09struct vfio_dma *dma;
> +=09dma_addr_t temp_iova =3D iova;
> +
> +=09dma =3D vfio_find_dma(iommu, iova, size);
> +=09if (!dma)

The UAPI did not define that the user can only ask for the dirty bitmap
across a mapped range.

> +=09=09return -EINVAL;
> +
> +=09/*
> +=09 * Range should be from a single mapping created by map request.
> +=09 */

The UAPI also did not specify this as a requirement.

> +
> +=09if ((iova < dma->iova) ||
> +=09    ((dma->iova + dma->size) < (iova + size)))
> +=09=09return -EINVAL;

Nor this.

So the actual implemented UAPI is that the user must call this over
some portion of, but not exceeding a single previously mapped DMA
range.  Why so restrictive?

> +
> +=09while (temp_iova < iova + size) {
> +=09=09struct vfio_pfn *vpfn =3D NULL;
> +
> +=09=09vpfn =3D vfio_find_vpfn(dma, temp_iova);
> +=09=09if (vpfn)
> +=09=09=09__bitmap_set(bitmap, vpfn->iova - start_iova, 1);
> +
> +=09=09temp_iova +=3D PAGE_SIZE;

Seems like waking the rb tree would be far more efficient.  Also, if
dma->iommu_mapped, mark all pages dirty until we figure out how to
avoid it.

> +=09}
> +
> +=09return 0;
> +}
> +
> +static int verify_bitmap_size(unsigned long npages, unsigned long bitmap=
_size)
> +{
> +=09unsigned long bsize =3D ALIGN(npages, BITS_PER_LONG) / 8;
> +
> +=09if ((bitmap_size =3D=3D 0) || (bitmap_size < bsize))
> +=09=09return -EINVAL;
> +=09return 0;
> +}
> +
> +static int vfio_iova_get_dirty_bitmap(struct vfio_iommu *iommu,
> +=09=09=09=09struct vfio_iommu_type1_dirty_bitmap *range)
> +{
> +=09unsigned long *bitmap;
> +=09int ret;
> +
> +=09ret =3D verify_bitmap_size(range->size >> PAGE_SHIFT, range->bitmap_s=
ize);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* one bit per page */
> +=09bitmap =3D bitmap_zalloc(range->size >> PAGE_SHIFT, GFP_KERNEL);

This creates a DoS vector, we need to be able to directly use the user
bitmap or chunk words into it using a confined size (ex. a user can
with args 0 to UIN64_MAX). Thanks,

Alex

> +=09if (!bitmap)
> +=09=09return -ENOMEM;
> +
> +=09mutex_lock(&iommu->lock);
> +=09ret =3D vfio_iova_dirty_bitmap(iommu, range->iova, range->size,
> +=09=09=09=09     range->iova, bitmap);
> +=09mutex_unlock(&iommu->lock);
> +
> +=09if (!ret) {
> +=09=09if (copy_to_user(range->bitmap, bitmap, range->bitmap_size))
> +=09=09=09ret =3D -EFAULT;
> +=09}
> +
> +=09bitmap_free(bitmap);
> +=09return ret;
> +}
> +
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  =09=09=09     struct vfio_iommu_type1_dma_unmap *unmap)
>  {
> @@ -2297,6 +2372,23 @@ static long vfio_iommu_type1_ioctl(void *iommu_dat=
a,
> =20
>  =09=09return copy_to_user((void __user *)arg, &unmap, minsz) ?
>  =09=09=09-EFAULT : 0;
> +=09} else if (cmd =3D=3D VFIO_IOMMU_GET_DIRTY_BITMAP) {
> +=09=09struct vfio_iommu_type1_dirty_bitmap range;
> +
> +=09=09/* Supported for v2 version only */
> +=09=09if (!iommu->v2)
> +=09=09=09return -EACCES;
> +
> +=09=09minsz =3D offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> +=09=09=09=09=09bitmap);
> +
> +=09=09if (copy_from_user(&range, (void __user *)arg, minsz))
> +=09=09=09return -EFAULT;
> +
> +=09=09if (range.argsz < minsz)
> +=09=09=09return -EINVAL;
> +
> +=09=09return vfio_iova_get_dirty_bitmap(iommu, &range);
>  =09}
> =20
>  =09return -ENOTTY;

