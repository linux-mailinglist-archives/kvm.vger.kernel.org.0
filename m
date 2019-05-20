Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E86A2403C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfETSYG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 20 May 2019 14:24:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfETSYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 14:24:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F8473082140;
        Mon, 20 May 2019 18:23:57 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D50D600C6;
        Mon, 20 May 2019 18:23:53 +0000 (UTC)
Date:   Mon, 20 May 2019 12:23:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: Re: [PATCH v2 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
Message-ID: <20190520122352.73082e52@x1.home>
In-Reply-To: <23f6a739-be4f-7eda-2227-2994fdc2325a@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
        <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
        <20190517104143.240082b5@x1.home>
        <92b6ad4e-9a49-636b-9225-acca0bec4bb7@linux.ibm.com>
        <ed193353-56f0-14b5-f1fb-1835d0a6c603@linux.ibm.com>
        <20190520162737.7560ad7c.cohuck@redhat.com>
        <23f6a739-be4f-7eda-2227-2994fdc2325a@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 20 May 2019 18:24:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 18:31:08 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 20/05/2019 16:27, Cornelia Huck wrote:
> > On Mon, 20 May 2019 13:19:23 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> On 17/05/2019 20:04, Pierre Morel wrote:  
> >>> On 17/05/2019 18:41, Alex Williamson wrote:  
> >>>> On Fri, 17 May 2019 18:16:50 +0200
> >>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>>>     
> >>>>> We implement the capability interface for VFIO_IOMMU_GET_INFO.
> >>>>>
> >>>>> When calling the ioctl, the user must specify
> >>>>> VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and
> >>>>> must check in the answer if capabilities are supported.
> >>>>>
> >>>>> The iommu get_attr callback will be used to retrieve the specific
> >>>>> attributes and fill the capabilities.
> >>>>>
> >>>>> Currently two Z-PCI specific capabilities will be queried and
> >>>>> filled by the underlying Z specific s390_iommu:
> >>>>> VFIO_IOMMU_INFO_CAP_QFN for the PCI query function attributes
> >>>>> and
> >>>>> VFIO_IOMMU_INFO_CAP_QGRP for the PCI query function group.
> >>>>>
> >>>>> Other architectures may add new capabilities in the same way
> >>>>> after enhancing the architecture specific IOMMU driver.
> >>>>>
> >>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>>>> ---
> >>>>>    drivers/vfio/vfio_iommu_type1.c | 122
> >>>>> +++++++++++++++++++++++++++++++++++++++-
> >>>>>    1 file changed, 121 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c
> >>>>> b/drivers/vfio/vfio_iommu_type1.c
> >>>>> index d0f731c..9435647 100644
> >>>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>>> @@ -1658,6 +1658,97 @@ static int
> >>>>> vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
> >>>>>        return ret;
> >>>>>    }
> >>>>> +static int vfio_iommu_type1_zpci_fn(struct iommu_domain *domain,
> >>>>> +                    struct vfio_info_cap *caps, size_t size)
> >>>>> +{
> >>>>> +    struct vfio_iommu_type1_info_pcifn *info_fn;
> >>>>> +    int ret;
> >>>>> +
> >>>>> +    info_fn = kzalloc(size, GFP_KERNEL);
> >>>>> +    if (!info_fn)
> >>>>> +        return -ENOMEM;
> >>>>> +
> >>>>> +    ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_ZPCI_FN,
> >>>>> +                    &info_fn->response);  
> >>>>
> >>>> What ensures that the 'struct clp_rsp_query_pci' returned from this
> >>>> get_attr remains consistent with a 'struct vfio_iommu_pci_function'?
> >>>> Why does the latter contains so many reserved fields (beyond simply
> >>>> alignment) for a user API?  What fields of these structures are
> >>>> actually useful to userspace?  Should any fields not be exposed to the
> >>>> user?  Aren't BAR sizes redundant to what's available through the vfio
> >>>> PCI API?  I'm afraid that simply redefining an internal structure as
> >>>> the API leaves a lot to be desired too.  Thanks,
> >>>>
> >>>> Alex
> >>>>     
> >>> Hi Alex,
> >>>
> >>> I simply used the structure returned by the firmware to be sure to be
> >>> consistent with future evolutions and facilitate the copy from CLP and
> >>> to userland.
> >>>
> >>> If you prefer, and I understand that this is the case, I can define a
> >>> specific VFIO_IOMMU structure with only the fields relevant to the user,
> >>> leaving future enhancement of the user's interface being implemented in
> >>> another kernel patch when the time has come.

TBH, I had no idea that CLP is an s390 firmware interface and this is
just dumping that to userspace.  The cover letter says:

  Using the PCI VFIO interface allows userland, a.k.a. QEMU, to
  retrieve ZPCI specific information without knowing Z specific
  identifiers like the function ID or the function handle of the zPCI
  function hidden behind the PCI interface.

But what does this allow userland to do and what specific pieces of
information do they need?  We do have a case already where Intel
graphics devices have a table (OpRegion) living in host system memory
that we expose via a vfio region, so it wouldn't be unprecedented to do
something like this, but as Connie suggests, if we knew what was being
consumed here and why, maybe we could generalize it into something
useful for others.

> >>> In fact, the struct will have all defined fields I used but not the BAR
> >>> size and address (at least for now because there are special cases we do
> >>> not support yet with bars).
> >>> All the reserved fields can go away.
> >>>
> >>> Is it more conform to your idea?
> >>>
> >>> Also I have 2 interfaces:
> >>>
> >>> s390_iommu.get_attr <-I1-> VFIO_IOMMU <-I2-> userland
> >>>
> >>> Do you prefer:
> >>> - 2 different structures, no CLP raw structure
> >>> - the CLP raw structure for I1 and a VFIO specific structure for I2  
> > 
> > <entering from the sideline>
> > 
> > IIUC, get_attr extracts various data points via clp, and we then make
> > it available to userspace. The clp interface needs to be abstracted
> > away at some point... one question from me: Is there a chance that
> > someone else may want to make use of the userspace interface (extra
> > information about a function)? If yes, I'd expect the get_attr to
> > obtain some kind of portable information already (basically your third
> > option, below).

I agree, but I also suspect we're pretty deep into s390
eccentricities.  An ioctl on the IOMMU container to get information
about a PCI function (singular) really seems like it can only exist on
a system where the actual PCI hardware is already being virtualized to
the host system.  I don't think this excludes us from the conversation
about what we're actually trying to expose and what it enables in
userspace though.
 
> Yes, seems the most reasonable.
> In this case I need to share the structure definition between:
> userspace through vfio.h
> vfio_iommu (this is obvious)
> s390_iommu
> 
> It is this third include which made me doubt.
> But when you re formulate it it looks the more reasonable because there 
> are much less changes.

It depends on what we settle on for get_attr.  If there are discrete
features that vfio_iommu_type1 can query and assemble into the
userspace response, the s390_iommu doesn't need to know the resulting
structure.  Even if it's just a CLP structure from the get_attr, why
would s390_iommu be responsible for formatting that into a user
structure vs vfio_iommu?  I don't think we want get_attr passing vfio
specific structures.  Thanks,

Alex
