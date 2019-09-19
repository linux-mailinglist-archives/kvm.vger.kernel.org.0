Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B0CB8799
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 00:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405260AbfISWtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 18:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389023AbfISWtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 18:49:08 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 757881DD1;
        Thu, 19 Sep 2019 22:49:07 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D37319C5B;
        Thu, 19 Sep 2019 22:49:05 +0000 (UTC)
Date:   Thu, 19 Sep 2019 16:49:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, sebott@linux.ibm.com,
        gerald.schaefer@de.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        pmorel@linux.ibm.com
Subject: Re: [PATCH v4 3/4] vfio: zpci: defining the VFIO headers
Message-ID: <20190919164904.579f9e9e@x1.home>
In-Reply-To: <20190919162708.07d4eec4@x1.home>
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
        <1567815231-17940-4-git-send-email-mjrosato@linux.ibm.com>
        <20190919172009.71b1c246.cohuck@redhat.com>
        <0a62aba7-578a-6875-da4d-13e8b145cf9b@linux.ibm.com>
        <20190919162708.07d4eec4@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 19 Sep 2019 22:49:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Sep 2019 16:27:08 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 19 Sep 2019 16:55:57 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > On 9/19/19 11:20 AM, Cornelia Huck wrote:  
> > > On Fri,  6 Sep 2019 20:13:50 -0400
> > > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> > >     
> > >> From: Pierre Morel <pmorel@linux.ibm.com>
> > >>
> > >> We define a new device region in vfio.h to be able to
> > >> get the ZPCI CLP information by reading this region from
> > >> userland.
> > >>
> > >> We create a new file, vfio_zdev.h to define the structure
> > >> of the new region we defined in vfio.h
> > >>
> > >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > >> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > >> ---
> > >>  include/uapi/linux/vfio.h      |  1 +
> > >>  include/uapi/linux/vfio_zdev.h | 35 +++++++++++++++++++++++++++++++++++
> > >>  2 files changed, 36 insertions(+)
> > >>  create mode 100644 include/uapi/linux/vfio_zdev.h
> > >>
> > >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > >> index 8f10748..8328c87 100644
> > >> --- a/include/uapi/linux/vfio.h
> > >> +++ b/include/uapi/linux/vfio.h
> > >> @@ -371,6 +371,7 @@ struct vfio_region_gfx_edid {
> > >>   * to do TLB invalidation on a GPU.
> > >>   */
> > >>  #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
> > >> +#define VFIO_REGION_SUBTYPE_ZDEV_CLP		(2)    
> > > 
> > > Using a subtype is fine, but maybe add a comment what this is for?
> > >     
> > 
> > Fair point.  Maybe something like "IBM ZDEV CLP is used to pass zPCI
> > device features to guest"  
> 
> And if you're going to use a PCI vendor ID subtype, maintain consistent
> naming, VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP or something.  Ideally there'd
> also be a reference to the struct provided through this region
> otherwise it's rather obscure to find by looking for the call to
> vfio_pci_register_dev_region() and ops defined for the region.  I
> wouldn't be opposed to defining the region structure here too rather
> than a separate file, but I guess you're following the example set by
> ccw.
> 
> > >>  
> > >>  /*
> > >>   * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
> > >> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> > >> new file mode 100644
> > >> index 0000000..55e0d6d
> > >> --- /dev/null
> > >> +++ b/include/uapi/linux/vfio_zdev.h
> > >> @@ -0,0 +1,35 @@
> > >> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > >> +/*
> > >> + * Region definition for ZPCI devices
> > >> + *
> > >> + * Copyright IBM Corp. 2019
> > >> + *
> > >> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> > >> + */
> > >> +
> > >> +#ifndef _VFIO_ZDEV_H_
> > >> +#define _VFIO_ZDEV_H_
> > >> +
> > >> +#include <linux/types.h>
> > >> +
> > >> +/**
> > >> + * struct vfio_region_zpci_info - ZPCI information.    
> > > 
> > > Hm... probably should also get some more explanation. E.g. is that
> > > derived from a hardware structure?
> > >     
> > 
> > The structure itself is not mapped 1:1 to a hardware structure, but it
> > does serve as a collection of information that was derived from other
> > hardware structures.
> > 
> > "Used for passing hardware feature information about a zpci device
> > between the host and guest" ?
> >   
> > >> + *
> > >> + */
> > >> +struct vfio_region_zpci_info {
> > >> +	__u64 dasm;
> > >> +	__u64 start_dma;
> > >> +	__u64 end_dma;
> > >> +	__u64 msi_addr;
> > >> +	__u64 flags;
> > >> +	__u16 pchid;
> > >> +	__u16 mui;
> > >> +	__u16 noi;
> > >> +	__u16 maxstbl;
> > >> +	__u8 version;
> > >> +	__u8 gid;
> > >> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1

Why is this defined so far away from the flags field?  I thought it was
lost at first.  I also wonder what it means... brief descriptions?
Thanks,

Alex

> > >> +	__u8 util_str[];
> > >> +} __packed;
> > >> +
> > >> +#endif    
> 
> I'm half tempted to suggest that this struct could be exposed directly
> through an info capability, the trouble is where.  It would be somewhat
> awkward to pick an arbitrary BAR or config space region to expose this
> info.  The VFIO_DEVICE_GET_INFO ioctl could include it, but we don't
> support capabilities on that return structure and I'm not sure it's
> worth implementing versus the solution here.  Just a thought.  Thanks,
> 
> Alex

