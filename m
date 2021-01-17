Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0EB2F90C2
	for <lists+kvm@lfdr.de>; Sun, 17 Jan 2021 06:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbhAQFb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 00:31:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAQFbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 00:31:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1E323107;
        Sun, 17 Jan 2021 05:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610861443;
        bh=DpapfS8CloHhWIyfLsKQuj+NWk694+ddY9JT8yb4Z6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXNqSd+dokYfehm1UYjzF5ow+mxEZgK6nonOZmGu3AgNjswSp1q0eAeRyJFfxbmVO
         n/n5xjUpZT1CtG/Z7KQkTqJr6VXJnUW7X5pfyyLtTT9tooiul5djn86uuY0vDSGlQT
         j7Ta3UEIceNucHDMt4alQf5oHlK6kAwYg/966t2LgB5dHSf9aixzKYdtcCGSPpIxNO
         NlXBWLtKnd2IbDinD6b3c/kX7CtXBw/5LxSwj3QGZG4RGRbzXkhJ5vn8J8dzi6D+vl
         JkbPPvcsrtJAse0SrFXbC2afUrfdaLRaHmWMMGZuAsH15Sn1v7ILYeGew9ByfE7iwJ
         cE3KQ/YK8hbAQ==
Date:   Sun, 17 Jan 2021 07:30:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     tglx@linutronix.de, ashok.raj@intel.com, kevin.tian@intel.com,
        dave.jiang@intel.com, megha.dey@intel.com, dwmw2@infradead.org,
        alex.williamson@redhat.com, bhelgaas@google.com,
        dan.j.williams@intel.com, will@kernel.org, joro@8bytes.org,
        dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v3 1/2] iommu: Add capability IOMMU_CAP_VIOMMU
Message-ID: <20210117053039.GO944463@unreal>
References: <20210114013003.297050-1-baolu.lu@linux.intel.com>
 <20210114013003.297050-2-baolu.lu@linux.intel.com>
 <20210114132627.GA944463@unreal>
 <b0c8b260-8e23-a5bd-d2da-ca1d67cdfa8a@linux.intel.com>
 <20210115063108.GI944463@unreal>
 <c58adc13-306a-8df8-19e1-27f834b3a7c9@linux.intel.com>
 <20210116083904.GN944463@unreal>
 <eda6ae9f-76eb-3254-ce58-ea355418a4b1@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eda6ae9f-76eb-3254-ce58-ea355418a4b1@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 16, 2021 at 04:47:40PM +0800, Lu Baolu wrote:
> Hi Leon,
>
> On 2021/1/16 16:39, Leon Romanovsky wrote:
> > On Sat, Jan 16, 2021 at 09:20:16AM +0800, Lu Baolu wrote:
> > > Hi,
> > >
> > > On 2021/1/15 14:31, Leon Romanovsky wrote:
> > > > On Fri, Jan 15, 2021 at 07:49:47AM +0800, Lu Baolu wrote:
> > > > > Hi Leon,
> > > > >
> > > > > On 1/14/21 9:26 PM, Leon Romanovsky wrote:
> > > > > > On Thu, Jan 14, 2021 at 09:30:02AM +0800, Lu Baolu wrote:
> > > > > > > Some vendor IOMMU drivers are able to declare that it is running in a VM
> > > > > > > context. This is very valuable for the features that only want to be
> > > > > > > supported on bare metal. Add a capability bit so that it could be used.
> > > > > >
> > > > > > And how is it used? Who and how will set it?
> > > > >
> > > > > Use the existing iommu_capable(). I should add more descriptions about
> > > > > who and how to use it.
> > > >
> > > > I want to see the code that sets this capability.
> > >
> > > Currently we have Intel VT-d and the virt-iommu setting this capability.
> > >
> > >   static bool intel_iommu_capable(enum iommu_cap cap)
> > >   {
> > >   	if (cap == IOMMU_CAP_CACHE_COHERENCY)
> > >   		return domain_update_iommu_snooping(NULL) == 1;
> > >   	if (cap == IOMMU_CAP_INTR_REMAP)
> > >   		return irq_remapping_enabled == 1;
> > > +	if (cap == IOMMU_CAP_VIOMMU)
> > > +		return caching_mode_enabled();
> > >
> > >   	return false;
> > >   }
> > >
> > > And,
> > >
> > > +static bool viommu_capable(enum iommu_cap cap)
> > > +{
> > > +	if (cap == IOMMU_CAP_VIOMMU)
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> >
> > These two functions are reading this cap and not setting.
> > Where can I see code that does "cap = IOMMU_CAP_VIOMMU" and not "=="?
>
> The iommu_capable() is a generic IOMMU interface to query IOMMU
> capabilities. It takes @bus and @cap as input, and calls the callback
> of vendor iommu. If the vendor iommu driver supports the specific
> capability, it returns true. Otherwise, it returns false.
>
> bool iommu_capable(struct bus_type *bus, enum iommu_cap cap)
> {
>         if (!bus->iommu_ops || !bus->iommu_ops->capable)
>                 return false;
>
>         return bus->iommu_ops->capable(cap);
> }
> EXPORT_SYMBOL_GPL(iommu_capable);
>
> In the vendor iommu's callback, it checks the capability and returns a
> value according to its capability, just as showed above.

Ohh, sorry.
I missed "iommu_capable(dev->bus, IOMMU_CAP_VIOMMU)" from second patch.

Thanks

>
> Best regards,
> baolu
