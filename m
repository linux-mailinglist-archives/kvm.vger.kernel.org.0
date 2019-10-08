Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438FDCFB5B
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 15:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbfJHNbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 09:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbfJHNbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 09:31:47 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F21A3082E72;
        Tue,  8 Oct 2019 13:31:47 +0000 (UTC)
Received: from gondolin (dhcp-192-202.str.redhat.com [10.33.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6D2719D70;
        Tue,  8 Oct 2019 13:31:41 +0000 (UTC)
Date:   Tue, 8 Oct 2019 15:30:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     sebott@linux.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        pmorel@linux.ibm.com
Subject: Re: [PATCH v4 3/4] vfio: zpci: defining the VFIO headers
Message-ID: <20191008153004.6be0e095.cohuck@redhat.com>
In-Reply-To: <86647083-7f94-44aa-8856-103836906f36@linux.ibm.com>
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
        <1567815231-17940-4-git-send-email-mjrosato@linux.ibm.com>
        <20190919172009.71b1c246.cohuck@redhat.com>
        <0a62aba7-578a-6875-da4d-13e8b145cf9b@linux.ibm.com>
        <20190920160258.70631905.cohuck@redhat.com>
        <86647083-7f94-44aa-8856-103836906f36@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 08 Oct 2019 13:31:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Sep 2019 11:14:28 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 9/20/19 10:02 AM, Cornelia Huck wrote:
> > On Thu, 19 Sep 2019 16:55:57 -0400
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> On 9/19/19 11:20 AM, Cornelia Huck wrote:  
> >>> On Fri,  6 Sep 2019 20:13:50 -0400
> >>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >>>     
> >>>> From: Pierre Morel <pmorel@linux.ibm.com>
> >>>>
> >>>> We define a new device region in vfio.h to be able to
> >>>> get the ZPCI CLP information by reading this region from
> >>>> userland.
> >>>>
> >>>> We create a new file, vfio_zdev.h to define the structure
> >>>> of the new region we defined in vfio.h
> >>>>
> >>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >>>> ---
> >>>>  include/uapi/linux/vfio.h      |  1 +
> >>>>  include/uapi/linux/vfio_zdev.h | 35 +++++++++++++++++++++++++++++++++++
> >>>>  2 files changed, 36 insertions(+)
> >>>>  create mode 100644 include/uapi/linux/vfio_zdev.h  
> >   
> >>>> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> >>>> new file mode 100644
> >>>> index 0000000..55e0d6d
> >>>> --- /dev/null
> >>>> +++ b/include/uapi/linux/vfio_zdev.h
> >>>> @@ -0,0 +1,35 @@
> >>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> >>>> +/*
> >>>> + * Region definition for ZPCI devices
> >>>> + *
> >>>> + * Copyright IBM Corp. 2019
> >>>> + *
> >>>> + * Author(s): Pierre Morel <pmorel@linux.ibm.com>
> >>>> + */
> >>>> +
> >>>> +#ifndef _VFIO_ZDEV_H_
> >>>> +#define _VFIO_ZDEV_H_
> >>>> +
> >>>> +#include <linux/types.h>
> >>>> +
> >>>> +/**
> >>>> + * struct vfio_region_zpci_info - ZPCI information.    
> >>>
> >>> Hm... probably should also get some more explanation. E.g. is that
> >>> derived from a hardware structure?
> >>>     
> >>
> >> The structure itself is not mapped 1:1 to a hardware structure, but it
> >> does serve as a collection of information that was derived from other
> >> hardware structures.
> >>
> >> "Used for passing hardware feature information about a zpci device
> >> between the host and guest" ?  
> > 
> > "zPCI specific hardware feature information for a device"?
> > 
> > Are we reasonably sure that this is complete for now? I'm not sure if
> > expanding this structure would work; adding another should always be
> > possible, though (if a bit annoying).
> >   
> 
> I think trying to make the structure expandable would be best...  If we
> allow arbitrary-sized reads of the info, and only add new fields onto
> the end it should be OK, no? (older qemu doesn't get the info it doesn't
> ask for / understand)....  But I guess that's not compatible with having
> util_str[] size being defined dynamically.  Another caveat would be if
> CLP_UTIL_STR_LEN were to grow in size in the future, and assuming
> util_str[] was no longer at the end of the structure, I guess the
> additional data would have to end up in a
> util_str2[CLP_UTIL_STR_LEN_NEW-CLP_UTIL_STR_LEN_OLD]...  To explain what
> I mean, something like:
> 
> struct vfio_region_zpci_info {
> 	<..>
> 	__u8 util_str[CLP_UTIL_STR_LEN_OLD];
> 	/* END OF V1 */
> 	__u8 foo;
> 	/* END OF V2 */
> 	__u8 util_str2[CLP_UTIL_STR_LEN_NEW-CLP_UTIL_STR_LEN_OLD];
> 	/* END OF V3 */
> } __packed;

[Sorry about the late response -- was on PTO]

That sounds a bit too complicated to me, and I'd prefer the "add
another region if we missed something" approach. If we put anything
looking potentially useful in here now, that "add another region" event
is hopefully far in the future.

> 
> 
> >>  
> >>>> + *
> >>>> + */
> >>>> +struct vfio_region_zpci_info {
> >>>> +	__u64 dasm;
> >>>> +	__u64 start_dma;
> >>>> +	__u64 end_dma;
> >>>> +	__u64 msi_addr;
> >>>> +	__u64 flags;
> >>>> +	__u16 pchid;
> >>>> +	__u16 mui;
> >>>> +	__u16 noi;
> >>>> +	__u16 maxstbl;
> >>>> +	__u8 version;
> >>>> +	__u8 gid;
> >>>> +#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1
> >>>> +	__u8 util_str[];
> >>>> +} __packed;
> >>>> +
> >>>> +#endif    
> >>>
> >>>     
> >>  
> >   
> 

