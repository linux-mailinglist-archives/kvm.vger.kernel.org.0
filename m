Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3AE65FE0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 21:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbfGKTIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 15:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728546AbfGKTIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 15:08:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E17130C0DE2;
        Thu, 11 Jul 2019 19:08:13 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B63B25C1B5;
        Thu, 11 Jul 2019 19:08:12 +0000 (UTC)
Date:   Thu, 11 Jul 2019 13:08:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Message-ID: <20190711130811.4e51437d@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F931F8@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
        <20190620150757.7b2fa405@x1.home>
        <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
        <20190621095740.41e6e98e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F05415@SHSMSX104.ccr.corp.intel.com>
        <20190628090741.51e8d18e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1E9EC@SHSMSX104.ccr.corp.intel.com>
        <20190703112212.146ac71c@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1FF4E@SHSMSX104.ccr.corp.intel.com>
        <20190705095520.548331c2@x1.home>
        <A2975661238FB949B60364EF0F2C257439F931F8@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 11 Jul 2019 19:08:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 12:27:26 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
> > Of Alex Williamson
> > Sent: Friday, July 5, 2019 11:55 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > 
> > On Thu, 4 Jul 2019 09:11:02 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > Hi Alex,
> > >  
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Thursday, July 4, 2019 1:22 AM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver  
> [...]
> > >  
> > > > It's really unfortunate that we don't have the mdev inheriting the
> > > > iommu group of the iommu_device so that userspace can really understand
> > > > this relationship.  A separate group makes sense for the aux-domain
> > > > case, and is (I guess) not a significant issue in the case of a
> > > > singleton iommu_device group, but it's pretty awkward here.  Perhaps
> > > > this is something we should correct in design of iommu backed mdevs.  
> > >
> > > Yeah, for aux-domain case, it is not significant issue as aux-domain essentially
> > > means singleton iommu_devie group. And in early time, when designing the  
> > support  
> > > for wrap pci as a mdev, we also considered to let vfio-mdev-pci to reuse
> > > iommu_device group. But this results in an iommu backed group includes mdev and
> > > physical devices, which might also be strange. Do you think it is valuable to  
> > reconsider  
> > > it?  
> > 
> > From a group perspective, the cleanest solution would seem to be that
> > IOMMU backed mdevs w/o aux domain support should inherit the IOMMU
> > group of the iommu_device,  
> 
> A confirm here. Regards to inherit the IOMMU group of iommu_device, do
> you mean mdev device should be added to the IOMMU group of iommu_device
> or maintain a parent and inheritor relationship within vfio? I guess you mean the
> later one? :-)

I was thinking the former, I'm not sure what the latter implies.  There
is no hierarchy within or between IOMMU groups, it's simply a set of
devices.  Maybe what you're getting at is that vfio needs to understand
that the mdev is a child of the endpoint device in its determination of
whether the group is viable.  That's true, but we can also have IOMMU
groups composed of SR-IOV VFs along with their parent PF if the root of
the IOMMU group is (for example) a downstream switch port above the PF.
So we can't simply look at the parent/child relationship within the
group, we somehow need to know that the parent device sharing the IOMMU
group is operating in host kernel space on behalf of the mdev.
 
> > but I think the barrier here is that we have
> > a difficult time determining if the group is "viable" in that case.
> > For example a group where one devices is bound to a native host driver
> > and the other device bound to a vfio driver would typically be
> > considered non-viable as it breaks the isolation guarantees.  However  
> 
> yes, this is how vfio guarantee the isolation before allowing user to further
> add a group to a vfio container and so on.
> 
> > I think in this configuration, the parent device is effectively
> > participating in the isolation and "donating" its iommu group on behalf
> > of the mdev device.  I don't think we can simultaneously use that iommu
> > group for any other purpose.   
> 
> Agree. At least host cannot make use of the iommu group any more in such
> configuration.
> 
> > I'm sure we could come up with a way for
> > vifo-core to understand this relationship and add it to the white list,  
> 
> The configuration is host driver still exists while we want to let mdev device
> to somehow "own" the iommu backed DMA isolation capability. So one possible
> way may be calling vfio_add_group_dev() which will creates a vfio_device instance
> for the iommu_device in vfio.c when creating a iommu backed mdev. Then the
> iommu group is fairly viable.

"fairly viable" ;)  It's a correct use of the term, it's a little funny
though as "fairly" can also mean reasonably/sufficiently/adequately as
well as I think the intended use here equivalent to justly. </tangent>

That's an interesting idea to do an implicit vfio_add_group_dev() on
the iommu_device in this case, if you've worked through how that could
play out, it'd be interesting to see.

> > I wonder though how confusing this might be to users who now understand
> > the group/driver requirement to be "all endpoints bound to vfio
> > drivers".  This might still be the best approach regardless of this.  
> 
> Yes, another thing I'm considering is how to prevent such a host driver from
> issuing DMA. If we finally get a device bound to vfio-pci and another device
> wrapped as mdev and passthru them to VM, the host driver is still capable to
> issue DMA. Though IOMMU can block some DMAs, but not all of them. If a
> DMA issued by host driver happens to have mapping in IOMMU side, then
> host is kind of doing things on behalf on VM. Though we may trust the host
> driver, but it looks to be a little bit awkward to me. :-(

vfio is allocating an iommu domain and placing the iommu_device into
that domain, the user therefore own the iova context for the parent
device, how would that not manage all DMA?   The vendor driver could
theoretically also manipulate mappings within that domain, but that
driver is a host kernel driver and therefore essentially trusted like
any other host kernel driver.  The only unique thing here is that it's
part of a channel providing access for an untrusted user, so it needs
to be particularly concerned with keeping that user access within
bounds.  Thanks,

Alex
