Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43435484618
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 17:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbiADQlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 11:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiADQlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 11:41:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5E9C061761;
        Tue,  4 Jan 2022 08:41:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEBD661507;
        Tue,  4 Jan 2022 16:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E53C36AE9;
        Tue,  4 Jan 2022 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641314462;
        bh=7LIvck5HPV89YRWtE6kFpffx/kn63b1CJh/KGhZQUKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=LRvO6MenpPinEO+T+hEV/YbUXSjLlkY8NoW3HQ9aE099V5K48u6VhHatEzBsKSBPT
         cmffNDot4PE1jdfo57Arc+b1RjDJF4UindSch9QkjJJQOHEuyDv3Sb/V9CrAZ8qboX
         FqEMlIC2YhID+deJpRGh+rGjD91a069/0BkOvhCvCmsJK1jZi8rBUdT+Y4L6D1LoWJ
         +iF+m+fxZZCM303intD0VWXGgWalDOLkP/rubmrzKenN5dJymlBii0CMk5vgf2rQ4c
         l4GnLXjX0UYge02uSn7jN4nWu8z/+1dWw6issq/EjMI7Z4BLY3xzgU97f0cFdn+/Kk
         7cEOBvSJL88ew==
Date:   Tue, 4 Jan 2022 10:41:00 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
Message-ID: <20220104164100.GA101735@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdQcgFhIMYvUwABV@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 02:08:00AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 04, 2022 at 09:56:31AM +0800, Lu Baolu wrote:
> > Multiple devices may be placed in the same IOMMU group because they
> > cannot be isolated from each other. These devices must either be
> > entirely under kernel control or userspace control, never a mixture.

I guess the reason is that if a group contained a mixture, userspace
could attack the kernel by programming a device to DMA to a device
owned by the kernel?

> > This adds dma ownership management in iommu core and exposes several
> > interfaces for the device drivers and the device userspace assignment
> > framework (i.e. vfio), so that any conflict between user and kernel
> > controlled DMA could be detected at the beginning.

Maybe I'm missing the point because I don't know what "conflict
between user and kernel controlled DMA" is.  Are you talking about
both userspace and the kernel programming the same device to do DMA?

> > The device driver oriented interfaces are,
> > 
> > 	int iommu_device_use_dma_api(struct device *dev);
> > 	void iommu_device_unuse_dma_api(struct device *dev);

Nit, do we care whether it uses the actual DMA API?  Or is it just
that iommu_device_use_dma_api() tells us the driver may program the
device to do DMA?

> > Devices under kernel drivers control must call iommu_device_use_dma_api()
> > before driver probes. The driver binding process must be aborted if it
> > returns failure.

"Devices" don't call functions.  Drivers do, or in this case, it looks
like the bus DMA code (platform, amba, fsl, pci, etc).

These functions are EXPORT_SYMBOL_GPL(), but it looks like all the
callers are built-in, so maybe the export is unnecessary?

You use "iommu"/"IOMMU" and "dma"/"DMA" interchangeably above.  Would
be easier to read if you picked one.

> > The vfio oriented interfaces are,
> > 
> > 	int iommu_group_set_dma_owner(struct iommu_group *group,
> > 				      void *owner);
> > 	void iommu_group_release_dma_owner(struct iommu_group *group);
> > 	bool iommu_group_dma_owner_claimed(struct iommu_group *group);
> > 
> > The device userspace assignment must be disallowed if the set dma owner
> > interface returns failure.

Can you connect this back to the "never a mixture" from the beginning?
If all you cared about was prevent an IOMMU group from containing
devices with a mixture of kernel drivers and userspace drivers, I
assume you could do that without iommu_device_use_dma_api().  So is
this a way to *allow* a mixture under certain restricted conditions?

Another nit below.

> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > ---
> >  include/linux/iommu.h |  31 ++++++++
> >  drivers/iommu/iommu.c | 161 +++++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 189 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index de0c57a567c8..568f285468cf 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -682,6 +682,13 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
> >  void iommu_sva_unbind_device(struct iommu_sva *handle);
> >  u32 iommu_sva_get_pasid(struct iommu_sva *handle);
> >  
> > +int iommu_device_use_dma_api(struct device *dev);
> > +void iommu_device_unuse_dma_api(struct device *dev);
> > +
> > +int iommu_group_set_dma_owner(struct iommu_group *group, void *owner);
> > +void iommu_group_release_dma_owner(struct iommu_group *group);
> > +bool iommu_group_dma_owner_claimed(struct iommu_group *group);
> > +
> >  #else /* CONFIG_IOMMU_API */
> >  
> >  struct iommu_ops {};
> > @@ -1082,6 +1089,30 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
> >  {
> >  	return NULL;
> >  }
> > +
> > +static inline int iommu_device_use_dma_api(struct device *dev)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void iommu_device_unuse_dma_api(struct device *dev)
> > +{
> > +}
> > +
> > +static inline int
> > +iommu_group_set_dma_owner(struct iommu_group *group, void *owner)
> > +{
> > +	return -ENODEV;
> > +}
> > +
> > +static inline void iommu_group_release_dma_owner(struct iommu_group *group)
> > +{
> > +}
> > +
> > +static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
> > +{
> > +	return false;
> > +}
> >  #endif /* CONFIG_IOMMU_API */
> >  
> >  /**
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 8b86406b7162..ff0c8c1ad5af 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -48,6 +48,8 @@ struct iommu_group {
> >  	struct iommu_domain *default_domain;
> >  	struct iommu_domain *domain;
> >  	struct list_head entry;
> > +	unsigned int owner_cnt;
> > +	void *owner;
> >  };
> >  
> >  struct group_device {
> > @@ -289,7 +291,12 @@ int iommu_probe_device(struct device *dev)
> >  	mutex_lock(&group->mutex);
> >  	iommu_alloc_default_domain(group, dev);
> >  
> > -	if (group->default_domain) {
> > +	/*
> > +	 * If device joined an existing group which has been claimed
> > +	 * for none kernel DMA purpose, avoid attaching the default
> > +	 * domain.

AOL: another "none kernel DMA purpose" that doesn't read well.  Is
this supposed to be "non-kernel"?  What does "claimed for non-kernel
DMA purpose" mean?  What interface does that?

> > +	 */
> > +	if (group->default_domain && !group->owner) {
> >  		ret = __iommu_attach_device(group->default_domain, dev);
> >  		if (ret) {
> >  			mutex_unlock(&group->mutex);
> > @@ -2320,7 +2327,7 @@ static int __iommu_attach_group(struct iommu_domain *domain,
> >  {
> >  	int ret;
> >  
> > -	if (group->default_domain && group->domain != group->default_domain)
> > +	if (group->domain && group->domain != group->default_domain)
> >  		return -EBUSY;
> >  
> >  	ret = __iommu_group_for_each_dev(group, domain,
> > @@ -2357,7 +2364,11 @@ static void __iommu_detach_group(struct iommu_domain *domain,
> >  {
> >  	int ret;
> >  
> > -	if (!group->default_domain) {
> > +	/*
> > +	 * If group has been claimed for none kernel DMA purpose, avoid
> > +	 * re-attaching the default domain.
> > +	 */
> 
> none kernel reads odd.  But maybe drop that and just say 'claimed
> already' ala:
> 
> 	/*
> 	 * If the group has been claimed already, do not re-attach the default
> 	 * domain.
> 	 */
