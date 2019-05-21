Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3FA2532B
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 16:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfEUO7i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 May 2019 10:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbfEUO7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 10:59:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96625C057F3E;
        Tue, 21 May 2019 14:59:34 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63B7C19C71;
        Tue, 21 May 2019 14:59:31 +0000 (UTC)
Date:   Tue, 21 May 2019 08:59:30 -0600
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
Message-ID: <20190521085930.4d91842c@x1.home>
In-Reply-To: <9dc0a8de-b850-df21-e3b7-21b7c2a373a3@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
        <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
        <20190517104143.240082b5@x1.home>
        <92b6ad4e-9a49-636b-9225-acca0bec4bb7@linux.ibm.com>
        <ed193353-56f0-14b5-f1fb-1835d0a6c603@linux.ibm.com>
        <20190520162737.7560ad7c.cohuck@redhat.com>
        <23f6a739-be4f-7eda-2227-2994fdc2325a@linux.ibm.com>
        <20190520122352.73082e52@x1.home>
        <9dc0a8de-b850-df21-e3b7-21b7c2a373a3@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 21 May 2019 14:59:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 May 2019 11:14:38 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 20/05/2019 20:23, Alex Williamson wrote:
> > On Mon, 20 May 2019 18:31:08 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> On 20/05/2019 16:27, Cornelia Huck wrote:  
> >>> On Mon, 20 May 2019 13:19:23 +0200
> >>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>>      
> >>>> On 17/05/2019 20:04, Pierre Morel wrote:  
> >>>>> On 17/05/2019 18:41, Alex Williamson wrote:  
> >>>>>> On Fri, 17 May 2019 18:16:50 +0200
> >>>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>>>>>        
> >>>>>>> We implement the capability interface for VFIO_IOMMU_GET_INFO.
> >>>>>>>
> >>>>>>> When calling the ioctl, the user must specify
> >>>>>>> VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and
> >>>>>>> must check in the answer if capabilities are supported.
> >>>>>>>
> >>>>>>> The iommu get_attr callback will be used to retrieve the specific
> >>>>>>> attributes and fill the capabilities.
> >>>>>>>
> >>>>>>> Currently two Z-PCI specific capabilities will be queried and
> >>>>>>> filled by the underlying Z specific s390_iommu:
> >>>>>>> VFIO_IOMMU_INFO_CAP_QFN for the PCI query function attributes
> >>>>>>> and
> >>>>>>> VFIO_IOMMU_INFO_CAP_QGRP for the PCI query function group.
> >>>>>>>
> >>>>>>> Other architectures may add new capabilities in the same way
> >>>>>>> after enhancing the architecture specific IOMMU driver.
> >>>>>>>
> >>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>>>>>> ---
> >>>>>>>     drivers/vfio/vfio_iommu_type1.c | 122
> >>>>>>> +++++++++++++++++++++++++++++++++++++++-
> >>>>>>>     1 file changed, 121 insertions(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c
> >>>>>>> b/drivers/vfio/vfio_iommu_type1.c
> >>>>>>> index d0f731c..9435647 100644
> >>>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>>>>> @@ -1658,6 +1658,97 @@ static int
> >>>>>>> vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
> >>>>>>>         return ret;
> >>>>>>>     }
> >>>>>>> +static int vfio_iommu_type1_zpci_fn(struct iommu_domain *domain,
> >>>>>>> +                    struct vfio_info_cap *caps, size_t size)
> >>>>>>> +{
> >>>>>>> +    struct vfio_iommu_type1_info_pcifn *info_fn;
> >>>>>>> +    int ret;
> >>>>>>> +
> >>>>>>> +    info_fn = kzalloc(size, GFP_KERNEL);
> >>>>>>> +    if (!info_fn)
> >>>>>>> +        return -ENOMEM;
> >>>>>>> +
> >>>>>>> +    ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_ZPCI_FN,
> >>>>>>> +                    &info_fn->response);  
> >>>>>>
> >>>>>> What ensures that the 'struct clp_rsp_query_pci' returned from this
> >>>>>> get_attr remains consistent with a 'struct vfio_iommu_pci_function'?
> >>>>>> Why does the latter contains so many reserved fields (beyond simply
> >>>>>> alignment) for a user API?  What fields of these structures are
> >>>>>> actually useful to userspace?  Should any fields not be exposed to the
> >>>>>> user?  Aren't BAR sizes redundant to what's available through the vfio
> >>>>>> PCI API?  I'm afraid that simply redefining an internal structure as
> >>>>>> the API leaves a lot to be desired too.  Thanks,
> >>>>>>
> >>>>>> Alex
> >>>>>>        
> >>>>> Hi Alex,
> >>>>>
> >>>>> I simply used the structure returned by the firmware to be sure to be
> >>>>> consistent with future evolutions and facilitate the copy from CLP and
> >>>>> to userland.
> >>>>>
> >>>>> If you prefer, and I understand that this is the case, I can define a
> >>>>> specific VFIO_IOMMU structure with only the fields relevant to the user,
> >>>>> leaving future enhancement of the user's interface being implemented in
> >>>>> another kernel patch when the time has come.  
> > 
> > TBH, I had no idea that CLP is an s390 firmware interface and this is
> > just dumping that to userspace.  The cover letter says:
> > 
> >    Using the PCI VFIO interface allows userland, a.k.a. QEMU, to
> >    retrieve ZPCI specific information without knowing Z specific
> >    identifiers like the function ID or the function handle of the zPCI
> >    function hidden behind the PCI interface.
> > 
> > But what does this allow userland to do and what specific pieces of
> > information do they need?  We do have a case already where Intel
> > graphics devices have a table (OpRegion) living in host system memory
> > that we expose via a vfio region, so it wouldn't be unprecedented to do
> > something like this, but as Connie suggests, if we knew what was being
> > consumed here and why, maybe we could generalize it into something
> > useful for others.  
> 
> OK, sorry I try to explain better.
> 
> 1) A short description, of zPCI functions and groups
> 
> IN Z, PCI cards, leave behind an adapter between subchannels and PCI.
> We access PCI cards through 2 ways:
> - dedicated PCI instructions (pci_load/pci_store/pci/store_block)
> - DMA
> We receive events through
> - Adapter interrupts
> - CHSC events
> 
> The adapter propose an IOMMU to protect the DMA
> and the interrupt handling goes through a MSIX like interface handled by 
> the adapter.
> 
> The architecture specific PCI do the interface between the standard PCI 
> level and the zPCI function (PCI + DMA/IOMMU/Interrupt)
> 
> To handle the communication through the "zPCI way" the CLP interface 
> provides instructions to retrieve informations from the adapters.
> 
> There are different group of functions having same functionalities.
> 
> clp_list give us a list from zPCI functions
> clp_query_pci_function returns informations specific to a function
> clp_query_group returns information on a function group
> 
> 
> 2) Why do we need it in the guest
> 
> We need to provide the guest with information on the adapters and zPCI 
> functions returned by the clp_query instruction so that the guest's 
> driver gets the right information on how the way to the zPCI function 
> has been built in the host.
> 
> 
> When a guest issues the CLP instructions we intercept the clp command in 
> QEMU and we need to feed the response with the right values for the guest.
> The "right" values are not the raw CLP response values:
> 
> - some identifier must be virtualized, like UID and FID,
> 
> - some values must match what the host received from the CLP response, 
> like the size of the transmited blocks, the DMA Address Space Mask, 
> number of interrupt, MSIA
> 
> - some other must match what the host handled with the adapter and 
> function, the start and end of DMA,
> 
> - some what the host IOMMU driver supports (frame size),

This seems very reminiscent of virtualizing PCI config space... so why
is this being proposed as a VFIO IOMMU ioctl extension?  These are all
function level characteristics, right?  Should this be a capability on
the VFIO device, or perhaps a region like we used for the Intel
OpRegion (though the structure size seems more akin to a capability
here)?  As I mentioned in my previous reply, tying this into the IOMMU
interface seemed to rely on (I assume) an one-to-one-to-one mapping of
PCI function to IOMMU group to IOMMU domain, but that doesn't still
doesn't necessarily lend itself to using the IOMMU for device level
information.  If there is IOMMU info, perhaps it needs to be split, ie.
expose a frame size via domain_get_attr, expose device level features
via a device capability, let QEMU assemble these into something
coherent to emulate the clp interface.

> 3) We have three different way to get This information:
> 
> The PCI Linux interface is a standard PCI interface and some Z specific 
> information is available in sysfs.
> Not all the information needed to be returned inside the CLP response is 
> available.
> So we can not use the sysfs interface to get all the information.
> 
> There is a CLP ioctl interface but this interface is not secure in that 
> it returns the information for all adapters in the system.
> 
> The VFIO interface offers the advantage to point to a single PCI 
> function, so more secure than the clp ioctl interface.
> Coupled with the s390_iommu we get access to the zPCI CLP instruction 
> and to the values handled by the zPCI driver.
> 
> 
> 4) Until now we used to fill the CLP response to the guest inside QEMU 
> with fixed values corresponding to the only PCI card we supported.
> To support new cards we need to get the right values from the kernel out.

If it's already emulated, I much prefer figuring out how to expose the
right pieces of information via an appropriate interface to virtualize
fields that are actually necessary rather than simply providing an
interface to dump the clp info straight to userspace and pipe it to the
VM.  Thanks,

Alex
