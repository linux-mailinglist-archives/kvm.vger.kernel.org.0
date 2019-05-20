Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9226239F9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbfETO1z convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 20 May 2019 10:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730687AbfETO1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:27:55 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D034308793B;
        Mon, 20 May 2019 14:27:49 +0000 (UTC)
Received: from gondolin (ovpn-204-110.brq.redhat.com [10.40.204.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DF5817A88;
        Mon, 20 May 2019 14:27:40 +0000 (UTC)
Date:   Mon, 20 May 2019 16:27:37 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: Re: [PATCH v2 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
Message-ID: <20190520162737.7560ad7c.cohuck@redhat.com>
In-Reply-To: <ed193353-56f0-14b5-f1fb-1835d0a6c603@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
        <1558109810-18683-5-git-send-email-pmorel@linux.ibm.com>
        <20190517104143.240082b5@x1.home>
        <92b6ad4e-9a49-636b-9225-acca0bec4bb7@linux.ibm.com>
        <ed193353-56f0-14b5-f1fb-1835d0a6c603@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 20 May 2019 14:27:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 13:19:23 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 17/05/2019 20:04, Pierre Morel wrote:
> > On 17/05/2019 18:41, Alex Williamson wrote:  
> >> On Fri, 17 May 2019 18:16:50 +0200
> >> Pierre Morel <pmorel@linux.ibm.com> wrote:
> >>  
> >>> We implement the capability interface for VFIO_IOMMU_GET_INFO.
> >>>
> >>> When calling the ioctl, the user must specify
> >>> VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and
> >>> must check in the answer if capabilities are supported.
> >>>
> >>> The iommu get_attr callback will be used to retrieve the specific
> >>> attributes and fill the capabilities.
> >>>
> >>> Currently two Z-PCI specific capabilities will be queried and
> >>> filled by the underlying Z specific s390_iommu:
> >>> VFIO_IOMMU_INFO_CAP_QFN for the PCI query function attributes
> >>> and
> >>> VFIO_IOMMU_INFO_CAP_QGRP for the PCI query function group.
> >>>
> >>> Other architectures may add new capabilities in the same way
> >>> after enhancing the architecture specific IOMMU driver.
> >>>
> >>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >>> ---
> >>>   drivers/vfio/vfio_iommu_type1.c | 122 
> >>> +++++++++++++++++++++++++++++++++++++++-
> >>>   1 file changed, 121 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/vfio/vfio_iommu_type1.c 
> >>> b/drivers/vfio/vfio_iommu_type1.c
> >>> index d0f731c..9435647 100644
> >>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>> @@ -1658,6 +1658,97 @@ static int 
> >>> vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
> >>>       return ret;
> >>>   }
> >>> +static int vfio_iommu_type1_zpci_fn(struct iommu_domain *domain,
> >>> +                    struct vfio_info_cap *caps, size_t size)
> >>> +{
> >>> +    struct vfio_iommu_type1_info_pcifn *info_fn;
> >>> +    int ret;
> >>> +
> >>> +    info_fn = kzalloc(size, GFP_KERNEL);
> >>> +    if (!info_fn)
> >>> +        return -ENOMEM;
> >>> +
> >>> +    ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_ZPCI_FN,
> >>> +                    &info_fn->response);  
> >>
> >> What ensures that the 'struct clp_rsp_query_pci' returned from this
> >> get_attr remains consistent with a 'struct vfio_iommu_pci_function'?
> >> Why does the latter contains so many reserved fields (beyond simply
> >> alignment) for a user API?  What fields of these structures are
> >> actually useful to userspace?  Should any fields not be exposed to the
> >> user?  Aren't BAR sizes redundant to what's available through the vfio
> >> PCI API?  I'm afraid that simply redefining an internal structure as
> >> the API leaves a lot to be desired too.  Thanks,
> >>
> >> Alex
> >>  
> > Hi Alex,
> > 
> > I simply used the structure returned by the firmware to be sure to be 
> > consistent with future evolutions and facilitate the copy from CLP and 
> > to userland.
> > 
> > If you prefer, and I understand that this is the case, I can define a 
> > specific VFIO_IOMMU structure with only the fields relevant to the user, 
> > leaving future enhancement of the user's interface being implemented in 
> > another kernel patch when the time has come.
> > 
> > In fact, the struct will have all defined fields I used but not the BAR 
> > size and address (at least for now because there are special cases we do 
> > not support yet with bars).
> > All the reserved fields can go away.
> > 
> > Is it more conform to your idea?
> > 
> > Also I have 2 interfaces:
> > 
> > s390_iommu.get_attr <-I1-> VFIO_IOMMU <-I2-> userland
> > 
> > Do you prefer:
> > - 2 different structures, no CLP raw structure
> > - the CLP raw structure for I1 and a VFIO specific structure for I2  

<entering from the sideline>

IIUC, get_attr extracts various data points via clp, and we then make
it available to userspace. The clp interface needs to be abstracted
away at some point... one question from me: Is there a chance that
someone else may want to make use of the userspace interface (extra
information about a function)? If yes, I'd expect the get_attr to
obtain some kind of portable information already (basically your third
option, below).

> 
> Hi Alex,
> 
> I am back again on this.
> This solution here above seems to me the best one but in this way I must 
> include S390 specific include inside the iommu_type1, which is AFAIU not 
> a good thing.
> It seems that the powerpc architecture use a solution with a dedicated 
> VFIO_IOMMU, the vfio_iommu_spar_tce.
> 
> Wouldn't it be a solution for s390 too, to use the vfio_iommu_type1 as a 
> basis to have a s390 dedicated solution.
> Then it becomes easier to have on one side the s390_iommu interface, 
> S390 specific, and on the other side a VFIO interface without a blind 
> copy of the firmware values.

If nobody else would want this exact interface, it might be a solution.
It would still be better not to encode clp data explicitly in the
userspace interface.

> 
> Do you think it is a viable solution?
> 
> Thanks,
> Pierre
> 
> 
> 
> > - the same VFIO structure for both I1 and I2
