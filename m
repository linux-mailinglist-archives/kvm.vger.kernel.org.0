Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3FE13D265
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 04:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAPDAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 22:00:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44127 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729110AbgAPDAH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 22:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579143606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QYDIddpraf1y7iH1YrZ3bXVk4InOC/gXpwyEqB+s6Kg=;
        b=IO231mF6hW35fStU+BMazWebu3yMedee2DQz/xpNv3+NRLQ6G4jVA9+l0nlHKAxWnQGHA5
        hM/KzC7QLcKBZUhy+dkbHDLEzQPh76h/G8OTj6wjJ/50O4fQk7AKljNbDr/a5n+yWWS7op
        Z0CyAv6qRXGwe/ms4ejhjb2gHDD4YCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-VmuSj52CP52FZ32jsTdlSA-1; Wed, 15 Jan 2020 22:00:05 -0500
X-MC-Unique: VmuSj52CP52FZ32jsTdlSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66E9F107ACC7;
        Thu, 16 Jan 2020 03:00:03 +0000 (UTC)
Received: from x1.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 452F088898;
        Thu, 16 Jan 2020 03:00:00 +0000 (UTC)
Date:   Wed, 15 Jan 2020 19:59:59 -0700
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
Message-ID: <20200115195959.28f33078@x1.home>
In-Reply-To: <80cf3888-2e51-3fd7-a064-213e7ded188e@nextfour.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
        <20200115035303.12362-1-yan.y.zhao@intel.com>
        <20200115130638.6926dd08@w520.home>
        <80cf3888-2e51-3fd7-a064-213e7ded188e@nextfour.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 02:30:52 +0000
Mika Penttil=C3=A4 <mika.penttila@nextfour.com> wrote:

> On 15.1.2020 22.06, Alex Williamson wrote:
> > On Tue, 14 Jan 2020 22:53:03 -0500
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > =20
> >> vfio_dma_rw will read/write a range of user space memory pointed to by
> >> IOVA into/from a kernel buffer without pinning the user space memory.
> >>
> >> TODO: mark the IOVAs to user space memory dirty if they are written in
> >> vfio_dma_rw().
> >>
> >> Cc: Kevin Tian <kevin.tian@intel.com>
> >> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> >> ---
> >>   drivers/vfio/vfio.c             | 45 +++++++++++++++++++
> >>   drivers/vfio/vfio_iommu_type1.c | 76 +++++++++++++++++++++++++++++++=
++
> >>   include/linux/vfio.h            |  5 +++
> >>   3 files changed, 126 insertions(+)
> >>
> >> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >> index c8482624ca34..8bd52bc841cf 100644
> >> --- a/drivers/vfio/vfio.c
> >> +++ b/drivers/vfio/vfio.c
> >> @@ -1961,6 +1961,51 @@ int vfio_unpin_pages(struct device *dev, unsign=
ed long *user_pfn, int npage)
> >>   }
> >>   EXPORT_SYMBOL(vfio_unpin_pages);
> >>  =20
> >> +/*
> >> + * Read/Write a range of IOVAs pointing to user space memory into/fro=
m a kernel
> >> + * buffer without pinning the user space memory
> >> + * @dev [in]  : device
> >> + * @iova [in] : base IOVA of a user space buffer
> >> + * @data [in] : pointer to kernel buffer
> >> + * @len [in]  : kernel buffer length
> >> + * @write     : indicate read or write
> >> + * Return error code on failure or 0 on success.
> >> + */
> >> +int vfio_dma_rw(struct device *dev, dma_addr_t iova, void *data,
> >> +		   size_t len, bool write)
> >> +{
> >> +	struct vfio_container *container;
> >> +	struct vfio_group *group;
> >> +	struct vfio_iommu_driver *driver;
> >> +	int ret =3D 0; =20
>=20
> Do you know the iova given to vfio_dma_rw() is indeed a gpa and not iova=
=20
> from a iommu mapping? So isn't it you actually assume all the guest is=20
> pinned,
> like from device assignment?
>=20
> Or who and how is the vfio mapping added before the vfio_dma_rw() ?

vfio only knows about IOVAs, not GPAs.  It's possible that IOVAs are
identity mapped to the GPA space, but a VM with a vIOMMU would quickly
break any such assumption.  Pinning is also not required.  This access
is via the CPU, not the I/O device, so we don't require the memory to
be pinning and it potentially won't be for a non-IOMMU backed mediated
device.  The intention here is that via the mediation of an mdev
device, a vendor driver would already know IOVA ranges for the device
to access via the guest driver programming of the device.  Thanks,

Alex

