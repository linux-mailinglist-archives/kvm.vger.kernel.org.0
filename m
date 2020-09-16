Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4AF26C1B1
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 12:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgIPKcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 06:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbgIPKaf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 06:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600252201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3r5BXKyztzEtBmeGNXveozgvRVkJArVKVoAQJjc9l+Q=;
        b=Wn+7GY8G8MslJcnQO5rz4T94WV+qDghFgQTocROcrMrui/lPNWsyzGyu7MfEHTb2iylLIB
        dL5ni9WRkLvnwwhAvYGrBKyLS+PaGb6+mmjtiov6XaPb/2DFkGOdXvW52Wtq0kyGHgAPRP
        pU8mZlxC3TmmeFpqQfsXLLMi+cSbAw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-7-CPFY-LMKqIfYhtz5ucNA-1; Wed, 16 Sep 2020 06:27:38 -0400
X-MC-Unique: 7-CPFY-LMKqIfYhtz5ucNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41F75186DD25;
        Wed, 16 Sep 2020 10:27:36 +0000 (UTC)
Received: from gondolin (ovpn-112-252.ams2.redhat.com [10.36.112.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 952AB60BFA;
        Wed, 16 Sep 2020 10:27:23 +0000 (UTC)
Date:   Wed, 16 Sep 2020 12:27:20 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        pmorel@linux.ibm.com, david@redhat.com, schnelle@linux.ibm.com,
        qemu-devel@nongnu.org, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        qemu-s390x@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net
Subject: Re: [PATCH v3 4/5] s390x/pci: Add routine to get the vfio dma
 available count
Message-ID: <20200916122720.4c7d8671.cohuck@redhat.com>
In-Reply-To: <0b28ae63-faad-953d-85c2-04bcdefeb7bf@redhat.com>
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
        <1600197283-25274-5-git-send-email-mjrosato@linux.ibm.com>
        <0b28ae63-faad-953d-85c2-04bcdefeb7bf@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Sep 2020 09:21:39 +0200
Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com> wrote:

> On 9/15/20 9:14 PM, Matthew Rosato wrote:
> > Create new files for separating out vfio-specific work for s390
> > pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
> > ioctl to collect the current dma available count.
> >=20
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> >  hw/s390x/meson.build     |  1 +
> >  hw/s390x/s390-pci-vfio.c | 54 ++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  hw/s390x/s390-pci-vfio.h | 17 +++++++++++++++
> >  3 files changed, 72 insertions(+)
> >  create mode 100644 hw/s390x/s390-pci-vfio.c
> >  create mode 100644 hw/s390x/s390-pci-vfio.h
> >=20

(...)

> > diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
> > new file mode 100644
> > index 0000000..75e3ac1
> > --- /dev/null
> > +++ b/hw/s390x/s390-pci-vfio.c
> > @@ -0,0 +1,54 @@
> > +/*
> > + * s390 vfio-pci interfaces
> > + *
> > + * Copyright 2020 IBM Corp.
> > + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2 or =
(at
> > + * your option) any later version. See the COPYING file in the top-lev=
el
> > + * directory.
> > + */
> > +
> > +#include <sys/ioctl.h>
> > +
> > +#include "qemu/osdep.h"
> > +#include "s390-pci-vfio.h"
> > +#include "hw/vfio/vfio-common.h"
> > +
> > +/*
> > + * Get the current DMA available count from vfio.  Returns true if vfi=
o is
> > + * limiting DMA requests, false otherwise.  The current available coun=
t read
> > + * from vfio is returned in avail.
> > + */
> > +bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
> > +{
> > +    g_autofree struct vfio_iommu_type1_info *info;
> > +    uint32_t argsz;
> > +    int ret;
> > +
> > +    assert(avail);
> > +
> > +    argsz =3D sizeof(struct vfio_iommu_type1_info);
> > +    info =3D g_malloc0(argsz);
> > +    info->argsz =3D argsz;
> > +    /*
> > +     * If the specified argsz is not large enough to contain all
> > +     * capabilities it will be updated upon return.  In this case
> > +     * use the updated value to get the entire capability chain.
> > +     */
> > +    ret =3D ioctl(fd, VFIO_IOMMU_GET_INFO, info);
> > +    if (argsz !=3D info->argsz) {
> > +        argsz =3D info->argsz;
> > +        info =3D g_realloc(info, argsz); =20
>=20
> Do we need to bzero [sizeof(struct vfio_iommu_type1_info)..argsz[?

If we do, I think we need to do the equivalent in
vfio_get_region_info() as well?

(Also, shouldn't we check ret before looking at info->argsz?)

>=20
> > +        info->argsz =3D argsz;
> > +        ret =3D ioctl(fd, VFIO_IOMMU_GET_INFO, info);
> > +    }
> > +
> > +    if (ret) {
> > +        return false;
> > +    }
> > +
> > +    /* If the capability exists, update with the current value */
> > +    return vfio_get_info_dma_avail(info, avail);
> > +}
> > +

(...)

