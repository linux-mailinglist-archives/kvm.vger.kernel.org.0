Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA0CFB961
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 21:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfKMUHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 15:07:15 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44718 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726597AbfKMUHP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 15:07:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573675633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVRhzheI0rP3RyDzAurxr2LYBtKchl5qyDJNFB5QRko=;
        b=cv35YyPHbMv10qLX+GpnABAHvbwCjBXNDdSwqmID1t3RcmmKtgls2X/Ni2hRw3nTRg3zzZ
        BdCpo9Tx53CFzFBobWf+uUKnyQywZRdFYk0QedUWHbIQCynkvZeDebNY5p+7lvucP7r8m8
        7vx+duKu3YKE9NejjNAIVnvkYTgCjTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-Ocm2z_MePxaayrfBtxw4Zw-1; Wed, 13 Nov 2019 15:07:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43A2B801E6A;
        Wed, 13 Nov 2019 20:07:08 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50BD219481;
        Wed, 13 Nov 2019 20:07:06 +0000 (UTC)
Date:   Wed, 13 Nov 2019 13:07:05 -0700
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
Message-ID: <20191113130705.32c6b663@x1.home>
In-Reply-To: <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
        <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
        <20191112153020.71406c44@x1.home>
        <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Ocm2z_MePxaayrfBtxw4Zw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 01:07:21 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 11/13/2019 4:00 AM, Alex Williamson wrote:
> > On Tue, 12 Nov 2019 22:33:37 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >  =20
> >> All pages pinned by vendor driver through vfio_pin_pages API should be
> >> considered as dirty during migration. IOMMU container maintains a list=
 of
> >> all such pinned pages. Added an ioctl defination to get bitmap of such=
 =20
> >=20
> > definition
> >  =20
> >> pinned pages for requested IO virtual address range. =20
> >=20
> > Additionally, all mapped pages are considered dirty when physically
> > mapped through to an IOMMU, modulo we discussed devices opting in to
> > per page pinning to indicate finer granularity with a TBD mechanism to
> > figure out if any non-opt-in devices remain.
> >  =20
>=20
> You mean, in case of device direct assignment (device pass through)?

Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
pinned and mapped, then the correct dirty page set is all mapped pages.
We discussed using the vpfn list as a mechanism for vendor drivers to
reduce their migration footprint, but we also discussed that we would
need a way to determine that all participants in the container have
explicitly pinned their working pages or else we must consider the
entire potential working set as dirty.

> >> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >> ---
> >>   include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
> >>   1 file changed, 23 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 35b09427ad9f..6fd3822aa610 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
> >>   #define VFIO_IOMMU_ENABLE=09_IO(VFIO_TYPE, VFIO_BASE + 15)
> >>   #define VFIO_IOMMU_DISABLE=09_IO(VFIO_TYPE, VFIO_BASE + 16)
> >>  =20
> >> +/**
> >> + * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> >> + *                                     struct vfio_iommu_type1_dirty_=
bitmap)
> >> + *
> >> + * IOCTL to get dirty pages bitmap for IOMMU container during migrati=
on.
> >> + * Get dirty pages bitmap of given IO virtual addresses range using
> >> + * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which is =
size of
> >> + * struct vfio_iommu_type1_dirty_bitmap. User should allocate memory =
to get
> >> + * bitmap and should set size of allocated memory in bitmap_size fiel=
d.
> >> + * One bit is used to represent per page consecutively starting from =
iova
> >> + * offset. Bit set indicates page at that offset from iova is dirty.
> >> + */
> >> +struct vfio_iommu_type1_dirty_bitmap {
> >> +=09__u32        argsz;
> >> +=09__u32        flags;
> >> +=09__u64        iova;                      /* IO virtual address */
> >> +=09__u64        size;                      /* Size of iova range */
> >> +=09__u64        bitmap_size;               /* in bytes */ =20
> >=20
> > This seems redundant.  We can calculate the size of the bitmap based on
> > the iova size.
> > =20
>=20
> But in kernel space, we need to validate the size of memory allocated by=
=20
> user instead of assuming user is always correct, right?

What does it buy us for the user to tell us the size?  They could be
wrong, they could be malicious.  The argsz field on the ioctl is mostly
for the handshake that the user is competent, we should get faults from
the copy-user operation if it's incorrect.
=20
> >> +=09void __user *bitmap;                    /* one bit per page */ =20
> >=20
> > Should we define that as a __u64* to (a) help with the size
> > calculation, and (b) assure that we can use 8-byte ops on it?
> >=20
> > However, who defines page size?  Is it necessarily the processor page
> > size?  A physical IOMMU may support page sizes other than the CPU page
> > size.  It might be more important to indicate the expected page size
> > than the bitmap size.  Thanks,
> > =20
>=20
> I see in QEMU and in vfio_iommu_type1 module, page sizes considered for=
=20
> mapping are CPU page size, 4K. Do we still need to have such argument?

That assumption exists for backwards compatibility prior to supporting
the iova_pgsizes field in vfio_iommu_type1_info.  AFAIK the current
interface has no page size assumptions and we should not add any.
Thanks,

Alex

