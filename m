Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2800413D2F6
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 04:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730427AbgAPD6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 22:58:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39111 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728905AbgAPD6f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 22:58:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579147113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnpkRDpghqTM1NwZ+1iPPc1hcGS89vCuP7+AdZ3c4v4=;
        b=Y2wrTsHlqkiDLOBvQvZLw9I38bxprVJmcit7zZNQkGqQD2MCv8TM+neqiAvi/J/l+gs2+7
        2Wpa/0ZxrfAHwCz/aAVcK7Rpx3Ty87tXaGfBMgN77Gm4f930Gy/ToSN+yhoBrELTkwjl/K
        F5CaM9ORSeGoPp9AEpNj3vL+kN7/diU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-JWNlj9uUPTWbRf_tHKI_-g-1; Wed, 15 Jan 2020 22:58:32 -0500
X-MC-Unique: JWNlj9uUPTWbRf_tHKI_-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18125183B532;
        Thu, 16 Jan 2020 03:58:31 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BEA25C28C;
        Thu, 16 Jan 2020 03:58:27 +0000 (UTC)
Date:   Wed, 15 Jan 2020 20:58:27 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Mika =?UTF-8?B?UGVudHRpbMOk?= <mika.penttila@nextfour.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v2 1/2] vfio: introduce vfio_dma_rw to read/write a
 range of IOVAs
Message-ID: <20200115205827.2249201c@x1.home>
In-Reply-To: <7528cfff-2512-538e-4e44-85f0a0b0130a@nextfour.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
        <20200115035303.12362-1-yan.y.zhao@intel.com>
        <20200115130638.6926dd08@w520.home>
        <80cf3888-2e51-3fd7-a064-213e7ded188e@nextfour.com>
        <20200115195959.28f33078@x1.home>
        <7528cfff-2512-538e-4e44-85f0a0b0130a@nextfour.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 03:15:58 +0000
Mika Penttil=C3=A4 <mika.penttila@nextfour.com> wrote:

> On 16.1.2020 4.59, Alex Williamson wrote:
> > On Thu, 16 Jan 2020 02:30:52 +0000
> > Mika Penttil=C3=A4 <mika.penttila@nextfour.com> wrote:
> > =20
> >> On 15.1.2020 22.06, Alex Williamson wrote: =20
> >>> On Tue, 14 Jan 2020 22:53:03 -0500
> >>> Yan Zhao <yan.y.zhao@intel.com> wrote:
> >>>    =20
> >>>> vfio_dma_rw will read/write a range of user space memory pointed to =
by
> >>>> IOVA into/from a kernel buffer without pinning the user space memory.
> >>>>
> >>>> TODO: mark the IOVAs to user space memory dirty if they are written =
in
> >>>> vfio_dma_rw().
> >>>>
> >>>> Cc: Kevin Tian <kevin.tian@intel.com>
> >>>> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >>>> ---
> >>>>    drivers/vfio/vfio.c             | 45 +++++++++++++++++++
> >>>>    drivers/vfio/vfio_iommu_type1.c | 76 ++++++++++++++++++++++++++++=
+++++
> >>>>    include/linux/vfio.h            |  5 +++
> >>>>    3 files changed, 126 insertions(+)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >>>> index c8482624ca34..8bd52bc841cf 100644
> >>>> --- a/drivers/vfio/vfio.c
> >>>> +++ b/drivers/vfio/vfio.c
> >>>> @@ -1961,6 +1961,51 @@ int vfio_unpin_pages(struct device *dev, unsi=
gned long *user_pfn, int npage)
> >>>>    }
> >>>>    EXPORT_SYMBOL(vfio_unpin_pages);
> >>>>   =20
> >>>> +/*
> >>>> + * Read/Write a range of IOVAs pointing to user space memory into/f=
rom a kernel
> >>>> + * buffer without pinning the user space memory
> >>>> + * @dev [in]  : device
> >>>> + * @iova [in] : base IOVA of a user space buffer
> >>>> + * @data [in] : pointer to kernel buffer
> >>>> + * @len [in]  : kernel buffer length
> >>>> + * @write     : indicate read or write
> >>>> + * Return error code on failure or 0 on success.
> >>>> + */
> >>>> +int vfio_dma_rw(struct device *dev, dma_addr_t iova, void *data,
> >>>> +		   size_t len, bool write)
> >>>> +{
> >>>> +	struct vfio_container *container;
> >>>> +	struct vfio_group *group;
> >>>> +	struct vfio_iommu_driver *driver;
> >>>> +	int ret =3D 0; =20
> >> Do you know the iova given to vfio_dma_rw() is indeed a gpa and not io=
va
> >> from a iommu mapping? So isn't it you actually assume all the guest is
> >> pinned,
> >> like from device assignment?
> >>
> >> Or who and how is the vfio mapping added before the vfio_dma_rw() ? =20
> > vfio only knows about IOVAs, not GPAs.  It's possible that IOVAs are
> > identity mapped to the GPA space, but a VM with a vIOMMU would quickly
> > break any such assumption.  Pinning is also not required.  This access
> > is via the CPU, not the I/O device, so we don't require the memory to
> > be pinning and it potentially won't be for a non-IOMMU backed mediated
> > device.  The intention here is that via the mediation of an mdev
> > device, a vendor driver would already know IOVA ranges for the device
> > to access via the guest driver programming of the device.  Thanks,
> >
> > Alex =20
>=20
> Thanks Alex... you mean IOVA is in the case of iommu already a=20
> iommu-translated address to a user space VA in VM host space?

The user (QEMU in the case of device assignment) performs ioctls to map
user VAs to IOVAs for the device.  With IOMMU backing the VAs are
pinned to get HPA and the IOVA to HPA mappings are programmed into the
IOMMU.  Thus the device accesses the IOVA to get to the HPA, which is
the backing for the VA.  In this case we're simply using the IOVA to
lookup the VA and access it with the CPU directly.  The IOMMU isn't
involved, but we're still performing an access as if we were the device
doing a DMA. Let me know if that doesn't answer your question.

> How does it get to hold on that? What piece of meditation is responsible=
=20
> for this?

It's device specific.  The mdev vendor driver is mediating a specific
hardware device where user accesses to MMIO on the device configures
DMA targets.  The mediation needs to trap those accesses in order to
pin page and program the real hardware with real physical addresses (be
they HPA or host-IOVAs depending on the host IOMMU config) to perform
those DMAs.  For cases where the CPU might choose to perform some sort
of virtual DMA on behalf of the device itself, this interface would be
used.  Thanks,

Alex

