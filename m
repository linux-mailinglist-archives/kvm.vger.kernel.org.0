Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A234392470
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 03:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhE0Bms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 21:42:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:13620 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232103AbhE0Bmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 21:42:47 -0400
IronPort-SDR: NRww83wa0KZQ9ZXsbdrD9Wyx4AQnGmsO3Ig5qVcCm2sAx/jqCWR1OYRRiIRuCcnLBYqCBIhHCx
 N5WkgJ0oZP/w==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="202388999"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="202388999"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 18:41:11 -0700
IronPort-SDR: tGoOcBKR4ifdc4kePKXvkEd+sM4iN87B870Dq7uN7vi/eClmAGwFbe8CiCm1IPU8PixXayfUFC
 BsgfsRJntA8A==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="436354249"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.36])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 18:41:10 -0700
Date:   Wed, 26 May 2021 18:41:07 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, tglx@linutronix.de, vkoul@kernel.org,
        megha.dey@intel.com, jacob.jun.pan@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v6 15/20] vfio/mdev: idxd: ims domain setup for the vdcm
Message-ID: <20210527014107.GA18829@otc-nc-03>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164283796.261970.11020270418798826121.stgit@djiang5-desk3.ch.intel.com>
 <20210523235023.GL1002214@nvidia.com>
 <29cec5cd-3f23-f947-4545-f507b3f70988@intel.com>
 <20210527005444.GV1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527005444.GV1002214@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 09:54:44PM -0300, Jason Gunthorpe wrote:
> On Wed, May 26, 2021 at 05:22:22PM -0700, Dave Jiang wrote:
> > 
> > On 5/23/2021 4:50 PM, Jason Gunthorpe wrote:
> > > On Fri, May 21, 2021 at 05:20:37PM -0700, Dave Jiang wrote:
> > > > @@ -77,8 +80,18 @@ int idxd_mdev_host_init(struct idxd_device *idxd, struct mdev_driver *drv)
> > > >   		return rc;
> > > >   	}
> > > > +	ims_info.max_slots = idxd->ims_size;
> > > > +	ims_info.slots = idxd->reg_base + idxd->ims_offset;
> > > > +	idxd->ims_domain = pci_ims_array_create_msi_irq_domain(idxd->pdev, &ims_info);
> > > > +	if (!idxd->ims_domain) {
> > > > +		dev_warn(dev, "Fail to acquire IMS domain\n");
> > > > +		iommu_dev_disable_feature(dev, IOMMU_DEV_FEAT_AUX);
> > > > +		return -ENODEV;
> > > > +	}
> > > I'm quite surprised that every mdev doesn't create its own ims_domain
> > > in its probe function.
> > > 
> > > This places a global total limit on the # of vectors which makes me
> > > ask what was the point of using IMS in the first place ?
> > > 
> > > The entire idea for IMS was to make the whole allocation system fully
> > > dynamic based on demand.
> > 
> > Hi Jason, thank you for the review of the series.
> > 
> > My understanding is that the driver creates a single IMS domain for the
> > device and provides the address base and IMS numbers for the domain based on
> > device IMS resources. So the IMS region needs to be contiguous. Each mdev
> > can call msi_domain_alloc_irqs() and acquire the number of IMS vectors it
> > desires and the DEV MSI core code will keep track of which vectors are being
> > used. This allows the mdev devices to dynamically allocate based on demand.
> > If the driver allocates a domain per mdev, it'll needs to do internal
> > accounting of the base and vector numbers for each of those domains that the
> > MSI core already provides. Isn't that what we are trying to avoid? As mdevs
> > come and go, that partitioning will become fragmented.
> 
> I suppose it depends entirely on how the HW works.
> 
> If the HW has a fixed number of interrupt vectors organized in a
> single table then by all means allocate a single domain that spans the
> entire fixed HW vector space. But then why do we have a ims_size
> variable here??
> 
> However, that really begs the question of why the HW is using IMS at
> all? I'd expect needing 2x-10x the max MSI-X vector size before
> reaching for IMS.

Its more than the number of vectors. Yes, thats one of the attributes.
IMS also has have additional flexibility. I think we covered this a while
back but maybe lost since its been a while.

- Format isn't just the standard MSIx, for e.g. DSA has the pending bits
  all merged and co-located together with the interrupt store.
- You might want the vector space to be mabe on device. (I think you
  alluded one of your devices can actually do that?)
- Remember we do handle validation when interrupts are requested from user
  space. Interrupts are validated with PASID of requester. (I think we also
  talked about if we should turn the interrupt message to also take a PASID
  as opposed to request without PASID as its specified in PCIe)
- For certain devices the interupt might be simply in the user context
  maintained by the kernel. Graphics for e.g.
> 
> So does IDXD really have like a 4k - 40k entry linear IMS vector table
> to wrap a shared domain around?
> 
> Basically, that isn't really "scalable" it is just "bigger".
> 
> Fully scalable would be for every mdev to point to its own 2k entry
> IMS table that is allocated on the fly. Every mdev gets a domain and
> every domain is fully utilized by the mdev in emulating
> MSI-X. Basically for a device like idxd every PASID would have to map
> to a IMS vector table array.
> 
> I suppose that was not what was done?
> 
> Jason

-- 
Cheers,
Ashok

