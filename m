Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C426D89B
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 12:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgIQKPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 06:15:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53347 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726241AbgIQKPS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 06:15:18 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 06:15:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600337713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWSgbcBzg4cWtL5b5RCSUatW7JEAI/GyQ80ADBOGhu8=;
        b=fkmG5brenjIV3CCsKho778Eunykk+DU+MWwuIftbiiGbcS9A8EVQQQxA84IPnDJwnjsNhT
        1RZga4uXKqYbM1GVRZ+VDIopB3UatfKhp036aClrDJzJTABLfG3ECd6YhZYDTO0Db+VFuU
        dJUuwCZoQbaYzvb6jc/kzOAxWIm3jYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-OSzsdZQOOEmwcQHsch3YYQ-1; Thu, 17 Sep 2020 05:59:49 -0400
X-MC-Unique: OSzsdZQOOEmwcQHsch3YYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4436D1019629;
        Thu, 17 Sep 2020 09:59:48 +0000 (UTC)
Received: from gondolin (ovpn-113-19.ams2.redhat.com [10.36.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB3C419D6C;
        Thu, 17 Sep 2020 09:59:36 +0000 (UTC)
Date:   Thu, 17 Sep 2020 11:59:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>,
        thuth@redhat.com, pmorel@linux.ibm.com, david@redhat.com,
        qemu-s390x@nongnu.org, schnelle@linux.ibm.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        alex.williamson@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        pbonzini@redhat.com, rth@twiddle.net
Subject: Re: [PATCH v3 4/5] s390x/pci: Add routine to get the vfio dma
 available count
Message-ID: <20200917115934.4659537a.cohuck@redhat.com>
In-Reply-To: <a2599938-d0b8-4436-2cf6-ceed9bba28f3@linux.ibm.com>
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
        <1600197283-25274-5-git-send-email-mjrosato@linux.ibm.com>
        <0b28ae63-faad-953d-85c2-04bcdefeb7bf@redhat.com>
        <20200916122720.4c7d8671.cohuck@redhat.com>
        <a2599938-d0b8-4436-2cf6-ceed9bba28f3@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Sep 2020 08:55:00 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 9/16/20 6:27 AM, Cornelia Huck wrote:
> > On Wed, 16 Sep 2020 09:21:39 +0200
> > Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:
> >  =20
> >> On 9/15/20 9:14 PM, Matthew Rosato wrote: =20
> >>> Create new files for separating out vfio-specific work for s390
> >>> pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
> >>> ioctl to collect the current dma available count.
> >>>
> >>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >>> ---
> >>>   hw/s390x/meson.build     |  1 +
> >>>   hw/s390x/s390-pci-vfio.c | 54 +++++++++++++++++++++++++++++++++++++=
+++++++++++
> >>>   hw/s390x/s390-pci-vfio.h | 17 +++++++++++++++
> >>>   3 files changed, 72 insertions(+)
> >>>   create mode 100644 hw/s390x/s390-pci-vfio.c
> >>>   create mode 100644 hw/s390x/s390-pci-vfio.h
> >>> =20
> >=20
> > (...)
> >  =20
> >>> diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> >>> new file mode 100644
> >>> index 0000000..75e3ac1
> >>> --- /dev/null
> >>> +++ b/hw/s390x/s390-pci-vfio.c
> >>> @@ -0,0 +1,54 @@
> >>> +/*
> >>> + * s390 vfio-pci interfaces
> >>> + *
> >>> + * Copyright 2020 IBM Corp.
> >>> + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> >>> + *
> >>> + * This work is licensed under the terms of the GNU GPL, version 2 o=
r (at
> >>> + * your option) any later version. See the COPYING file in the top-l=
evel
> >>> + * directory.
> >>> + */
> >>> +
> >>> +#include <sys/ioctl.h>
> >>> +
> >>> +#include "qemu/osdep.h"
> >>> +#include "s390-pci-vfio.h"
> >>> +#include "hw/vfio/vfio-common.h"
> >>> +
> >>> +/*
> >>> + * Get the current DMA available count from vfio.  Returns true if v=
fio is
> >>> + * limiting DMA requests, false otherwise.  The current available co=
unt read
> >>> + * from vfio is returned in avail.
> >>> + */
> >>> +bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
> >>> +{
> >>> +    g_autofree struct vfio_iommu_type1_info *info;
> >>> +    uint32_t argsz;
> >>> +    int ret;
> >>> +
> >>> +    assert(avail);
> >>> +
> >>> +    argsz =3D sizeof(struct vfio_iommu_type1_info);
> >>> +    info =3D g_malloc0(argsz);
> >>> +    info->argsz =3D argsz;
> >>> +    /*
> >>> +     * If the specified argsz is not large enough to contain all
> >>> +     * capabilities it will be updated upon return.  In this case
> >>> +     * use the updated value to get the entire capability chain.
> >>> +     */
> >>> +    ret =3D ioctl(fd, VFIO_IOMMU_GET_INFO, info);
> >>> +    if (argsz !=3D info->argsz) {
> >>> +        argsz =3D info->argsz;
> >>> +        info =3D g_realloc(info, argsz); =20
> >>
> >> Do we need to bzero [sizeof(struct vfio_iommu_type1_info)..argsz[? =20
> >=20
> > If we do, I think we need to do the equivalent in
> > vfio_get_region_info() as well?
> >  =20
>=20
> I agree that it would need to be in both places or neither -- I would=20
> expect the re-driven ioctl to overwrite the prior contents of info=20
> (unless we get a bad ret, but in this case we don't care what is in info)?
>=20
> Perhaps the fundamental difference between this code and=20
> vfio_get_region_info is that the latter checks for only a growing argsz=20
> and retries, whereas this code checks for !=3D so it's technically=20
> possible for a smaller argsz to trigger the retry here, and we wouldn't=20
> know for sure that all bytes from the first ioctl call were overwritten.

Nod. Relying on overwriting should be fine.

>=20
> What if I adjust this code to look like vfio_get_region_info:
>=20
> retry:
> 	info->argsz =3D argsz;
>=20
> 	if (ioctl(fd, VFIO_IOMMU_GET_INFO, info)) {
> 		// no need to g_free() bc of g_autofree
> 		return false;=09
> 	}
>=20
> 	if (info->argsz > argsz) {
> 		argsz =3D info->argsz;
> 		info =3D g_realloc(info, argsz);
> 		goto retry;
> 	}
>=20
> 	/* If the capability exists, update with the current value */
> 	return vfio_get_info_dma_avail(info, avail);
>=20
> Now we would only trigger when we are told by the host that the buffer=20
> must be larger.

I think that makes sense.

>=20
> > (Also, shouldn't we check ret before looking at info->argsz?)
> >  =20
>=20
> Yes, you are correct.  The above proposal would fix that issue too.
>=20
> >> =20
> >>> +        info->argsz =3D argsz;
> >>> +        ret =3D ioctl(fd, VFIO_IOMMU_GET_INFO, info);
> >>> +    }
> >>> +
> >>> +    if (ret) {
> >>> +        return false;
> >>> +    }
> >>> +
> >>> +    /* If the capability exists, update with the current value */
> >>> +    return vfio_get_info_dma_avail(info, avail);
> >>> +}
> >>> + =20
> >=20
> > (...)
> >=20
> >  =20
>=20

