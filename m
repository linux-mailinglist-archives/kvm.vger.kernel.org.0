Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DBFF9D06
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 23:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKLWad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 17:30:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32782 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727049AbfKLWac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 17:30:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573597831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXlaFWs2bCpm1GXByz5JVzXYnULCdI2JZXvxgOnAiQg=;
        b=KhYBqsGEXYntIUeGHYOOjvUWHXy8MEKJERCF9ZgW4CYMGVH9EVjVtwWzH2j2t8W4DskljD
        MmCJQH3bGlZwmcyrvbRCZ6WhtU5m8miRFhK+Jp4dCp3zZ8mgGABEp4AdkQze7tvE3rtYvR
        3EsQhfJ5zCoL3apIrio0BcsEoCNk2ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-baZNLM67MKG5P2Abdp9ehw-1; Tue, 12 Nov 2019 17:30:28 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CCAB107ACC4;
        Tue, 12 Nov 2019 22:30:26 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DC542CEFE;
        Tue, 12 Nov 2019 22:30:25 +0000 (UTC)
Date:   Tue, 12 Nov 2019 15:30:07 -0700
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
Subject: Re: [PATCH v9 Kernel 5/5] vfio iommu: Implementation of ioctl to
 get dirty bitmap before unmap
Message-ID: <20191112153007.0b2ba195@x1.home>
In-Reply-To: <1573578220-7530-6-git-send-email-kwankhede@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-6-git-send-email-kwankhede@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: baZNLM67MKG5P2Abdp9ehw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Nov 2019 22:33:40 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> If pages are pinned by external interface for requested IO virtual addres=
s
> range, bitmap of such pages is created and then that range is unmapped.
> To get bitmap during unmap, user should set flag
> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated a=
nd
> bitmap_size should be set. If flag is not set, then it behaves same as
> VFIO_IOMMU_UNMAP_DMA ioctl.
>=20
> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Neo Jia <cjia@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 71 +++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 69 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index ac176e672857..d6b988452ba6 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -926,7 +926,8 @@ static int vfio_iova_get_dirty_bitmap(struct vfio_iom=
mu *iommu,
>  }
> =20
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> -=09=09=09     struct vfio_iommu_type1_dma_unmap *unmap)
> +=09=09=09     struct vfio_iommu_type1_dma_unmap *unmap,
> +=09=09=09     unsigned long *bitmap)
>  {
>  =09uint64_t mask;
>  =09struct vfio_dma *dma, *dma_last =3D NULL;
> @@ -1026,6 +1027,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *io=
mmu,
>  =09=09=09=09=09=09    &nb_unmap);
>  =09=09=09goto again;
>  =09=09}
> +
> +=09=09if (bitmap) {
> +=09=09=09vfio_iova_dirty_bitmap(iommu, dma->iova, dma->size,
> +=09=09=09=09=09       unmap->iova, bitmap);
> +=09=09}
> +
>  =09=09unmapped +=3D dma->size;
>  =09=09vfio_remove_dma(iommu, dma);
>  =09}
> @@ -1039,6 +1046,43 @@ static int vfio_dma_do_unmap(struct vfio_iommu *io=
mmu,
>  =09return ret;
>  }
> =20
> +static int vfio_dma_do_unmap_bitmap(struct vfio_iommu *iommu,
> +=09=09struct vfio_iommu_type1_dma_unmap_bitmap *unmap_bitmap)
> +{
> +=09struct vfio_iommu_type1_dma_unmap unmap;
> +=09unsigned long *bitmap =3D NULL;
> +=09int ret;
> +
> +=09/* check bitmap size */
> +=09if ((unmap_bitmap->flags | VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)) {

It's required to enforce other flag bits are zero or else we can never
guarantee we can use them in the future without breaking existing
userspace, but I'd really rather extend the existing ioctl.

Should we provide any optimization to indicate to the user that dirty
bits were set?  Thanks,

Alex

> +=09=09ret =3D verify_bitmap_size(unmap_bitmap->size >> PAGE_SHIFT,
> +=09=09=09=09=09 unmap_bitmap->bitmap_size);
> +=09=09if (ret)
> +=09=09=09return ret;
> +
> +=09=09/* one bit per page */
> +=09=09bitmap =3D bitmap_zalloc(unmap_bitmap->size >> PAGE_SHIFT,
> +=09=09=09=09=09GFP_KERNEL);
> +=09=09if (!bitmap)
> +=09=09=09return -ENOMEM;
> +=09}
> +
> +=09unmap.iova =3D unmap_bitmap->iova;
> +=09unmap.size =3D unmap_bitmap->size;
> +=09ret =3D vfio_dma_do_unmap(iommu, &unmap, bitmap);
> +=09if (!ret)
> +=09=09unmap_bitmap->size =3D unmap.size;
> +
> +=09if (bitmap) {
> +=09=09if (!ret && copy_to_user(unmap_bitmap->bitmap, bitmap,
> +=09=09=09=09=09 unmap_bitmap->bitmap_size))
> +=09=09=09ret =3D -EFAULT;
> +=09=09bitmap_free(bitmap);
> +=09}
> +
> +=09return ret;
> +}
> +
>  static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
>  =09=09=09  unsigned long pfn, long npage, int prot)
>  {
> @@ -2366,7 +2410,7 @@ static long vfio_iommu_type1_ioctl(void *iommu_data=
,
>  =09=09if (unmap.argsz < minsz || unmap.flags)
>  =09=09=09return -EINVAL;
> =20
> -=09=09ret =3D vfio_dma_do_unmap(iommu, &unmap);
> +=09=09ret =3D vfio_dma_do_unmap(iommu, &unmap, NULL);
>  =09=09if (ret)
>  =09=09=09return ret;
> =20
> @@ -2389,6 +2433,29 @@ static long vfio_iommu_type1_ioctl(void *iommu_dat=
a,
>  =09=09=09return -EINVAL;
> =20
>  =09=09return vfio_iova_get_dirty_bitmap(iommu, &range);
> +=09} else if (cmd =3D=3D VFIO_IOMMU_UNMAP_DMA_GET_BITMAP) {
> +=09=09struct vfio_iommu_type1_dma_unmap_bitmap unmap_bitmap;
> +=09=09long ret;
> +
> +=09=09/* Supported for v2 version only */
> +=09=09if (!iommu->v2)
> +=09=09=09return -EACCES;
> +
> +=09=09minsz =3D offsetofend(struct vfio_iommu_type1_dma_unmap_bitmap,
> +=09=09=09=09    bitmap);
> +
> +=09=09if (copy_from_user(&unmap_bitmap, (void __user *)arg, minsz))
> +=09=09=09return -EFAULT;
> +
> +=09=09if (unmap_bitmap.argsz < minsz)
> +=09=09=09return -EINVAL;
> +
> +=09=09ret =3D vfio_dma_do_unmap_bitmap(iommu, &unmap_bitmap);
> +=09=09if (ret)
> +=09=09=09return ret;
> +
> +=09=09return copy_to_user((void __user *)arg, &unmap_bitmap, minsz) ?
> +=09=09=09-EFAULT : 0;
>  =09}
> =20
>  =09return -ENOTTY;

