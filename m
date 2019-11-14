Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7661CFD01A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 22:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfKNVGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 16:06:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbfKNVGg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 16:06:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573765594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JZkO9qOZOKio9PSHH2vHArRjWlcp1FYEZqfvTiYAcIU=;
        b=c/k4zrOxAFclqWLhMimumBtSH39v0wvSpkbguhvI8FetsBG0vBZ7zlmozIWxs2HMyYfjx5
        J7SmgptdT7zVg+pP8MA8G4WvPa9VJz2cG1tqLhAiE2G8AttyNjZaVdB5rYaGuiSXCTbC8T
        ZVyRzvWripIEpIXCTy3bmurqqLbY8EE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-xuMjMyTTM-6WwMWHcUmykw-1; Thu, 14 Nov 2019 16:06:31 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D38A5800C73;
        Thu, 14 Nov 2019 21:06:27 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 241885D6AE;
        Thu, 14 Nov 2019 21:06:26 +0000 (UTC)
Date:   Thu, 14 Nov 2019 14:06:25 -0700
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
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
Message-ID: <20191114140625.213e8a99@x1.home>
In-Reply-To: <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
        <20191112153020.71406c44@x1.home>
        <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
        <20191113130705.32c6b663@x1.home>
        <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: xuMjMyTTM-6WwMWHcUmykw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 15 Nov 2019 00:26:07 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 11/14/2019 1:37 AM, Alex Williamson wrote:
> > On Thu, 14 Nov 2019 01:07:21 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >  =20
> >> On 11/13/2019 4:00 AM, Alex Williamson wrote: =20
> >>> On Tue, 12 Nov 2019 22:33:37 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>     =20
> >>>> All pages pinned by vendor driver through vfio_pin_pages API should =
be
> >>>> considered as dirty during migration. IOMMU container maintains a li=
st of
> >>>> all such pinned pages. Added an ioctl defination to get bitmap of su=
ch =20
> >>>
> >>> definition
> >>>     =20
> >>>> pinned pages for requested IO virtual address range. =20
> >>>
> >>> Additionally, all mapped pages are considered dirty when physically
> >>> mapped through to an IOMMU, modulo we discussed devices opting in to
> >>> per page pinning to indicate finer granularity with a TBD mechanism t=
o
> >>> figure out if any non-opt-in devices remain.
> >>>     =20
> >>
> >> You mean, in case of device direct assignment (device pass through)? =
=20
> >=20
> > Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
> > pinned and mapped, then the correct dirty page set is all mapped pages.
> > We discussed using the vpfn list as a mechanism for vendor drivers to
> > reduce their migration footprint, but we also discussed that we would
> > need a way to determine that all participants in the container have
> > explicitly pinned their working pages or else we must consider the
> > entire potential working set as dirty.
> >  =20
>=20
> How can vendor driver tell this capability to iommu module? Any suggestio=
ns?

I think it does so by pinning pages.  Is it acceptable that if the
vendor driver pins any pages, then from that point forward we consider
the IOMMU group dirty page scope to be limited to pinned pages?  There
are complications around non-singleton IOMMU groups, but I think we're
already leaning towards that being a non-worthwhile problem to solve.
So if we require that only singleton IOMMU groups can pin pages and we
pass the IOMMU group as a parameter to
vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
flag on its local vfio_group struct to indicate dirty page scope is
limited to pinned pages.  We might want to keep a flag on the
vfio_iommu struct to indicate if all of the vfio_groups for each
vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
pinned pages as an optimization to avoid walking lists too often.  Then
we could test if vfio_iommu.domain_list is not empty and this new flag
does not limit the dirty page scope, then everything within each
vfio_dma is considered dirty.
=20
> >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>>> ---
> >>>>    include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
> >>>>    1 file changed, 23 insertions(+)
> >>>>
> >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>>> index 35b09427ad9f..6fd3822aa610 100644
> >>>> --- a/include/uapi/linux/vfio.h
> >>>> +++ b/include/uapi/linux/vfio.h
> >>>> @@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
> >>>>    #define VFIO_IOMMU_ENABLE=09_IO(VFIO_TYPE, VFIO_BASE + 15)
> >>>>    #define VFIO_IOMMU_DISABLE=09_IO(VFIO_TYPE, VFIO_BASE + 16)
> >>>>   =20
> >>>> +/**
> >>>> + * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> >>>> + *                                     struct vfio_iommu_type1_dirt=
y_bitmap)
> >>>> + *
> >>>> + * IOCTL to get dirty pages bitmap for IOMMU container during migra=
tion.
> >>>> + * Get dirty pages bitmap of given IO virtual addresses range using
> >>>> + * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which i=
s size of
> >>>> + * struct vfio_iommu_type1_dirty_bitmap. User should allocate memor=
y to get
> >>>> + * bitmap and should set size of allocated memory in bitmap_size fi=
eld.
> >>>> + * One bit is used to represent per page consecutively starting fro=
m iova
> >>>> + * offset. Bit set indicates page at that offset from iova is dirty=
.
> >>>> + */
> >>>> +struct vfio_iommu_type1_dirty_bitmap {
> >>>> +=09__u32        argsz;
> >>>> +=09__u32        flags;
> >>>> +=09__u64        iova;                      /* IO virtual address */
> >>>> +=09__u64        size;                      /* Size of iova range */
> >>>> +=09__u64        bitmap_size;               /* in bytes */ =20
> >>>
> >>> This seems redundant.  We can calculate the size of the bitmap based =
on
> >>> the iova size.
> >>>    =20
> >>
> >> But in kernel space, we need to validate the size of memory allocated =
by
> >> user instead of assuming user is always correct, right? =20
> >=20
> > What does it buy us for the user to tell us the size?  They could be
> > wrong, they could be malicious.  The argsz field on the ioctl is mostly
> > for the handshake that the user is competent, we should get faults from
> > the copy-user operation if it's incorrect.
> > =20
>=20
> It is to mainly fail safe.
>=20
> >>>> +=09void __user *bitmap;                    /* one bit per page */ =
=20
> >>>
> >>> Should we define that as a __u64* to (a) help with the size
> >>> calculation, and (b) assure that we can use 8-byte ops on it?
> >>>
> >>> However, who defines page size?  Is it necessarily the processor page
> >>> size?  A physical IOMMU may support page sizes other than the CPU pag=
e
> >>> size.  It might be more important to indicate the expected page size
> >>> than the bitmap size.  Thanks,
> >>>    =20
> >>
> >> I see in QEMU and in vfio_iommu_type1 module, page sizes considered fo=
r
> >> mapping are CPU page size, 4K. Do we still need to have such argument?=
 =20
> >=20
> > That assumption exists for backwards compatibility prior to supporting
> > the iova_pgsizes field in vfio_iommu_type1_info.  AFAIK the current
> > interface has no page size assumptions and we should not add any. =20
>=20
> So userspace has iova_pgsizes information, which can be input to this=20
> ioctl. Bitmap should be considering smallest page size. Does that makes=
=20
> sense?

I'm not sure.  I thought I had an argument that the iova_pgsize could
indicate support for sizes smaller than the processor page size, which
would make the user responsible for using a different base for their
page size, but vfio_pgsize_bitmap() already masks out sub-page sizes.
Clearly the vendor driver is pinning based on processor sized pages,
but that's independent of an IOMMU and not part of a user ABI.

I'm tempted to say your bitmap_size field has a use here, but it seems
to fail in validating the user page size at the low extremes.  For
example if we have a single page mapping, the user can specify the iova
size as 4K (for example), but the minimum bitmap_size they can indicate
is 1 byte, would we therefore assume the user's bitmap page size is 512
bytes (ie. they provided us with 8 bits to describe a 4K range)?  We'd
need to be careful to specify that the minimum iova_pgsize indicated
page size is our lower bound as well.  But then what do we do if the
user provides us with a smaller buffer than we expect?  For example, a
128MB iova range and only an 8-byte buffer.  Do we go ahead and assume
a 2MB page size and fill the bitmap accordingly or do we generate an
error?  If the latter, might we support that at some point in time and
is it sufficient to let the user perform trial and error to test if that
exists?  Thanks,

Alex

