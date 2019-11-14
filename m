Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3283FD01D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 22:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfKNVIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 16:08:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39235 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbfKNVIc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 16:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573765711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5pDDzLjSI9qqUSPbYB+psol3zH7V2uqbHtghDpsPPfw=;
        b=Ma7N64UAjPXSZb0I1kK/hH14vp419Y/4hVl6LL6fMutlXZrxE6rJ3QRrUZzQwPOapcAWbO
        St/AasopnWSDxZwQDrgXd8yAJpwiP+u0zvZLx1UcPrZwdY8ac8ojFk+iPV7nHj6i4AM0sz
        T5EjbH7NTqmbG9qaIYz0bCnfHzuYlfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-vveDkcKHPMmtyIMiyhPKmg-1; Thu, 14 Nov 2019 16:08:29 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D071800C77;
        Thu, 14 Nov 2019 21:08:27 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E88355C1D4;
        Thu, 14 Nov 2019 21:08:25 +0000 (UTC)
Date:   Thu, 14 Nov 2019 14:08:25 -0700
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
Message-ID: <20191114140825.7472970d@x1.home>
In-Reply-To: <1f8fc51f-8bdc-7c0c-43ce-1b252f429260@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-4-git-send-email-kwankhede@nvidia.com>
        <20191112153017.3c792673@x1.home>
        <a148c5e2-ad34-6973-de50-eab472ed38fb@nvidia.com>
        <20191113132219.5075b32e@x1.home>
        <1f8fc51f-8bdc-7c0c-43ce-1b252f429260@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: vveDkcKHPMmtyIMiyhPKmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 00:26:26 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 11/14/2019 1:52 AM, Alex Williamson wrote:
> > On Thu, 14 Nov 2019 01:22:39 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >  =20
> >> On 11/13/2019 4:00 AM, Alex Williamson wrote: =20
> >>> On Tue, 12 Nov 2019 22:33:38 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>     =20
> >>>> With vIOMMU, during pre-copy phase of migration, while CPUs are stil=
l
> >>>> running, IO virtual address unmap can happen while device still keep=
ing
> >>>> reference of guest pfns. Those pages should be reported as dirty bef=
ore
> >>>> unmap, so that VFIO user space application can copy content of those=
 pages
> >>>> from source to destination.
> >>>>
> >>>> IOCTL defination added here add bitmap pointer, size and flag. If fl=
ag =20
> >>>
> >>> definition, adds
> >>>     =20
> >>>> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set and bitmap memory is all=
ocated
> >>>> and bitmap_size of set, then ioctl will create bitmap of pinned page=
s and =20
> >>>
> >>> s/of/is/
> >>>     =20
> >>>> then unmap those.
> >>>>
> >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>>> ---
> >>>>    include/uapi/linux/vfio.h | 33 +++++++++++++++++++++++++++++++++
> >>>>    1 file changed, 33 insertions(+)
> >>>>
> >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>>> index 6fd3822aa610..72fd297baf52 100644
> >>>> --- a/include/uapi/linux/vfio.h
> >>>> +++ b/include/uapi/linux/vfio.h
> >>>> @@ -925,6 +925,39 @@ struct vfio_iommu_type1_dirty_bitmap {
> >>>>   =20
> >>>>    #define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VF=
IO_BASE + 17)
> >>>>   =20
> >>>> +/**
> >>>> + * VFIO_IOMMU_UNMAP_DMA_GET_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 1=
8,
> >>>> + *=09=09=09=09      struct vfio_iommu_type1_dma_unmap_bitmap)
> >>>> + *
> >>>> + * Unmap IO virtual addresses using the provided struct
> >>>> + * vfio_iommu_type1_dma_unmap_bitmap.  Caller sets argsz.
> >>>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty =
bitmap
> >>>> + * before unmapping IO virtual addresses. If this flag is not set, =
only IO
> >>>> + * virtual address are unmapped without creating pinned pages bitma=
p, that
> >>>> + * is, behave same as VFIO_IOMMU_UNMAP_DMA ioctl.
> >>>> + * User should allocate memory to get bitmap and should set size of=
 allocated
> >>>> + * memory in bitmap_size field. One bit in bitmap is used to repres=
ent per page
> >>>> + * consecutively starting from iova offset. Bit set indicates page =
at that
> >>>> + * offset from iova is dirty.
> >>>> + * The actual unmapped size is returned in the size field and bitma=
p of pages
> >>>> + * in the range of unmapped size is returned in bitmap if flag
> >>>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set.
> >>>> + *
> >>>> + * No guarantee is made to the user that arbitrary unmaps of iova o=
r size
> >>>> + * different from those used in the original mapping call will succ=
eed.
> >>>> + */
> >>>> +struct vfio_iommu_type1_dma_unmap_bitmap {
> >>>> +=09__u32        argsz;
> >>>> +=09__u32        flags;
> >>>> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> >>>> +=09__u64        iova;                        /* IO virtual address =
*/
> >>>> +=09__u64        size;                        /* Size of mapping (by=
tes) */
> >>>> +=09__u64        bitmap_size;                 /* in bytes */
> >>>> +=09void __user *bitmap;                      /* one bit per page */
> >>>> +};
> >>>> +
> >>>> +#define VFIO_IOMMU_UNMAP_DMA_GET_BITMAP _IO(VFIO_TYPE, VFIO_BASE + =
18)
> >>>> + =20
> >>>
> >>> Why not extend VFIO_IOMMU_UNMAP_DMA to support this rather than add a=
n
> >>> ioctl that duplicates the functionality and extends it?? =20
> >>
> >> We do want old userspace applications to work with new kernel and
> >> vice-versa, right?
> >>
> >> If I try to change existing VFIO_IOMMU_UNMAP_DMA ioctl structure, say =
if
> >> add 'bitmap_size' and 'bitmap' after 'size', with below code in old
> >> kernel, old kernel & new userspace will work.
> >>
> >>           minsz =3D offsetofend(struct vfio_iommu_type1_dma_unmap, siz=
e);
> >>
> >>           if (copy_from_user(&unmap, (void __user *)arg, minsz))
> >>                   return -EFAULT;
> >>
> >>           if (unmap.argsz < minsz || unmap.flags)
> >>                   return -EINVAL;
> >>
> >>
> >> With new kernel it would change to:
> >>           minsz =3D offsetofend(struct vfio_iommu_type1_dma_unmap, bit=
map); =20
> >=20
> > No, the minimum structure size still ends at size, we interpret flags
> > and argsz to learn if the user understands those fields and optionally
> > include them.  Therefore old userspace on new kernel continues to work.
> >  =20
> >>           if (copy_from_user(&unmap, (void __user *)arg, minsz))
> >>                   return -EFAULT;
> >>
> >>           if (unmap.argsz < minsz || unmap.flags)
> >>                   return -EINVAL;
> >>
> >> Then old userspace app will fail because unmap.argsz < minsz and might
> >> be copy_from_user would cause seg fault because userspace sdk doesn't
> >> contain new member variables.
> >> We can't change the sequence to keep 'size' as last member, because th=
en
> >> new userspace app on old kernel will interpret it wrong. =20
> >=20
> > If we have new userspace on old kernel, that userspace needs to be able
> > to learn that this feature exists (new flag in the
> > vfio_iommu_type1_info struct as suggested below) and only make use of i=
t
> > when available.  This is why the old kernel checks argsz against minsz.
> > So long as the user passes something at least minsz in size, we have
> > compatibility.  The old kernel doesn't understand the GET_DIRTY_BITMAP
> > flag and will return an error if the user attempts to use it.  Thanks,
> >  =20
>=20
> Ok. So then VFIO_IOMMU_UNMAP_DMA_GET_BITMAP ioctl is not needed. I'll do=
=20
> the change. Again bitmap will be created considering smallest page size=
=20
> of iova_pgsizes
>=20
> But VFIO_IOMMU_GET_DIRTY_BITMAP ioctl will still required, right?

Yes, I'm not willing to suggest a flag on an unmap ioctl that
eliminates the unmap just so we can re-use it for retrieving a dirty
page bitmap.  That'd be ugly.  Thanks,

Alex

