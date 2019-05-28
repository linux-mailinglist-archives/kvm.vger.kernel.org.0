Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02ACE2D143
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 23:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfE1Vya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 17:54:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40725 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfE1Vya (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 17:54:30 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A34A2883D7;
        Tue, 28 May 2019 21:54:29 +0000 (UTC)
Received: from x1.home (ovpn-116-22.phx2.redhat.com [10.3.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BCAF60BF1;
        Tue, 28 May 2019 21:54:28 +0000 (UTC)
Date:   Tue, 28 May 2019 15:54:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: Re: [PATCH v3 2/3] vfio: zpci: defining the VFIO headers
Message-ID: <20190528155428.0f149994@x1.home>
In-Reply-To: <20190523182433.567b8408.cohuck@redhat.com>
References: <1558614326-24711-1-git-send-email-pmorel@linux.ibm.com>
        <1558614326-24711-3-git-send-email-pmorel@linux.ibm.com>
        <20190523182433.567b8408.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 28 May 2019 21:54:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 May 2019 18:24:33 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 23 May 2019 14:25:25 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
> > We define a new device region in vfio.h to be able to
> > get the ZPCI CLP information by reading this region from
> > userland.
> > 
> > We create a new file, vfio_zdev.h to define the structure
> > of the new region we defined in vfio.h
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  include/uapi/linux/vfio.h      |  4 ++++
> >  include/uapi/linux/vfio_zdev.h | 34 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 38 insertions(+)
> >  create mode 100644 include/uapi/linux/vfio_zdev.h
> > 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 8f10748..56595b8 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -306,6 +306,10 @@ struct vfio_region_info_cap_type {
> >  #define VFIO_REGION_TYPE_GFX                    (1)
> >  #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
> >  
> > +/* IBM Subtypes */
> > +#define VFIO_REGION_TYPE_IBM_ZDEV		(1)
> > +#define VFIO_REGION_SUBTYPE_ZDEV_CLP		(1)  
> 
> I'm afraid that confuses me a bit. You want to add the region to every
> vfio-pci device when we're running under s390, right? So this does not
> depend on the device type of the actual device (which may or may not be
> from IBM), but only on the architecture?

FWIW, I don't really have a strong opinion here but I welcome the
discussion.  It seems fair to me that a PCI vendor type could be used
for either a device with that vendor ID or by the vendor of the
platform.  We've got a lot of address space if want to use
VFIO_REGION_TYPE_IBM_ZDEV rather than a PCI vendor type (so long as
it's updated not to conflict with the GFX type).  Thanks,

Alex
 
> (Generally speaking, I think using regions for this makes sense,
> though.)
> 
> > +
> >  /**
> >   * struct vfio_region_gfx_edid - EDID region layout.
> >   *
> > diff --git a/include/uapi/linux/vfio_zdev.h
> > b/include/uapi/linux/vfio_zdev.h new file mode 100644
> > index 0000000..84b1a82
> > --- /dev/null
> > +++ b/include/uapi/linux/vfio_zdev.h
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + * Region definition for ZPCI devices
> > + *
> > + * Copyright IBM Corp. 2019
> > + *
> > + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> > + */
> > +
> > +#ifndef _VFIO_ZDEV_H_
> > +#define _VFIO_ZDEV_H_
> > +
> > +#include <linux/types.h>
> > +
> > +/**
> > + * struct vfio_region_zpci_info - ZPCI information.
> > + *
> > + */
> > +struct vfio_region_zpci_info {
> > +	__u64 dasm;
> > +	__u64 start_dma;
> > +	__u64 end_dma;
> > +	__u64 msi_addr;
> > +	__u64 flags;
> > +	__u16 pchid;
> > +	__u16 mui;
> > +	__u16 noi;
> > +	__u8 gid;
> > +	__u8 version;
> > +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1
> > +	__u8 util_str[CLP_UTIL_STR_LEN];
> > +} __packed;
> > +
> > +#endif  
> 

