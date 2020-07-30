Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE123393F
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbgG3TrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 15:47:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20824 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730551AbgG3TrG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 15:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596138423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBQQmJPaywtGjRPnPxfMrCP97/jk9vz+YTn2z/bOwXE=;
        b=GF8K7XBSjdo7u+lY2XSCSwcNbgur0vx6+lzwTwynbswpltTeVraAOd9k3wOGpEV+08pBch
        UepM4Sonrt68q9iigxLclvvGJyfF9OUp19irCp3AJeTyDPar172D/zzjUQ0eKdePjBd1kS
        gbg6GKwnEHyy6FWP4NhmBxahPUiHbU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-FVNopLLKNFaqli-_SWKSjA-1; Thu, 30 Jul 2020 15:47:01 -0400
X-MC-Unique: FVNopLLKNFaqli-_SWKSjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C13101932480;
        Thu, 30 Jul 2020 19:46:59 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC8A75BAC3;
        Thu, 30 Jul 2020 19:46:58 +0000 (UTC)
Date:   Thu, 30 Jul 2020 13:46:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 2/4] iommu: Add iommu_aux_at(de)tach_group()
Message-ID: <20200730134658.44c57a67@x1.home>
In-Reply-To: <MWHPR11MB16454283959A365ED7964C488C700@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-3-baolu.lu@linux.intel.com>
        <20200714093909.1ab93c9e@jacob-builder>
        <b5b22e01-4a51-8dfe-9ba4-aeca783740f1@linux.intel.com>
        <20200715090114.50a459d4@jacob-builder>
        <435a2014-c2e8-06b9-3c9a-4afbf6607ffe@linux.intel.com>
        <20200729140336.09d2bfe7@x1.home>
        <MWHPR11MB16454283959A365ED7964C488C700@MWHPR11MB1645.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jul 2020 23:34:40 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, July 30, 2020 4:04 AM
> > 
> > On Thu, 16 Jul 2020 09:07:46 +0800
> > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> >   
> > > Hi Jacob,
> > >
> > > On 7/16/20 12:01 AM, Jacob Pan wrote:  
> > > > On Wed, 15 Jul 2020 08:47:36 +0800
> > > > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> > > >  
> > > >> Hi Jacob,
> > > >>
> > > >> On 7/15/20 12:39 AM, Jacob Pan wrote:  
> > > >>> On Tue, 14 Jul 2020 13:57:01 +0800
> > > >>> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> > > >>>  
> > > >>>> This adds two new aux-domain APIs for a use case like vfio/mdev
> > > >>>> where sub-devices derived from an aux-domain capable device are
> > > >>>> created and put in an iommu_group.
> > > >>>>
> > > >>>> /**
> > > >>>>    * iommu_aux_attach_group - attach an aux-domain to an  
> > iommu_group  
> > > >>>> which
> > > >>>>    *                          contains sub-devices (for example
> > > >>>> mdevs) derived
> > > >>>>    *                          from @dev.
> > > >>>>    * @domain: an aux-domain;
> > > >>>>    * @group:  an iommu_group which contains sub-devices derived  
> > from  
> > > >>>> @dev;
> > > >>>>    * @dev:    the physical device which supports  
> > IOMMU_DEV_FEAT_AUX.  
> > > >>>>    *
> > > >>>>    * Returns 0 on success, or an error value.
> > > >>>>    */
> > > >>>> int iommu_aux_attach_group(struct iommu_domain *domain,
> > > >>>>                              struct iommu_group *group,
> > > >>>>                              struct device *dev)
> > > >>>>
> > > >>>> /**
> > > >>>>    * iommu_aux_detach_group - detach an aux-domain from an
> > > >>>> iommu_group *
> > > >>>>    * @domain: an aux-domain;
> > > >>>>    * @group:  an iommu_group which contains sub-devices derived  
> > from  
> > > >>>> @dev;
> > > >>>>    * @dev:    the physical device which supports  
> > IOMMU_DEV_FEAT_AUX.  
> > > >>>>    *
> > > >>>>    * @domain must have been attached to @group via
> > > >>>> iommu_aux_attach_group(). */
> > > >>>> void iommu_aux_detach_group(struct iommu_domain *domain,
> > > >>>>                               struct iommu_group *group,
> > > >>>>                               struct device *dev)
> > > >>>>
> > > >>>> It also adds a flag in the iommu_group data structure to identify
> > > >>>> an iommu_group with aux-domain attached from those normal ones.
> > > >>>>
> > > >>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
> > > >>>> ---
> > > >>>>    drivers/iommu/iommu.c | 58
> > > >>>> +++++++++++++++++++++++++++++++++++++++++++  
> > include/linux/iommu.h |  
> > > >>>> 17 +++++++++++++ 2 files changed, 75 insertions(+)
> > > >>>>
> > > >>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > > >>>> index e1fdd3531d65..cad5a19ebf22 100644
> > > >>>> --- a/drivers/iommu/iommu.c
> > > >>>> +++ b/drivers/iommu/iommu.c
> > > >>>> @@ -45,6 +45,7 @@ struct iommu_group {
> > > >>>>    	struct iommu_domain *default_domain;
> > > >>>>    	struct iommu_domain *domain;
> > > >>>>    	struct list_head entry;
> > > >>>> +	unsigned int aux_domain_attached:1;
> > > >>>>    };
> > > >>>>
> > > >>>>    struct group_device {
> > > >>>> @@ -2759,6 +2760,63 @@ int iommu_aux_get_pasid(struct  
> > iommu_domain  
> > > >>>> *domain, struct device *dev) }
> > > >>>>    EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
> > > >>>>
> > > >>>> +/**
> > > >>>> + * iommu_aux_attach_group - attach an aux-domain to an  
> > iommu_group  
> > > >>>> which
> > > >>>> + *                          contains sub-devices (for example
> > > >>>> mdevs) derived
> > > >>>> + *                          from @dev.
> > > >>>> + * @domain: an aux-domain;
> > > >>>> + * @group:  an iommu_group which contains sub-devices derived  
> > from  
> > > >>>> @dev;
> > > >>>> + * @dev:    the physical device which supports  
> > IOMMU_DEV_FEAT_AUX.  
> > > >>>> + *
> > > >>>> + * Returns 0 on success, or an error value.
> > > >>>> + */
> > > >>>> +int iommu_aux_attach_group(struct iommu_domain *domain,
> > > >>>> +			   struct iommu_group *group, struct
> > > >>>> device *dev) +{
> > > >>>> +	int ret = -EBUSY;
> > > >>>> +
> > > >>>> +	mutex_lock(&group->mutex);
> > > >>>> +	if (group->domain)
> > > >>>> +		goto out_unlock;
> > > >>>> +  
> > > >>> Perhaps I missed something but are we assuming only one mdev per
> > > >>> mdev group? That seems to change the logic where vfio does:
> > > >>> iommu_group_for_each_dev()
> > > >>> 	iommu_aux_attach_device()
> > > >>>  
> > > >>
> > > >> It has been changed in PATCH 4/4:
> > > >>
> > > >> static int vfio_iommu_attach_group(struct vfio_domain *domain,
> > > >>                                      struct vfio_group *group)
> > > >> {
> > > >>           if (group->mdev_group)
> > > >>                   return iommu_aux_attach_group(domain->domain,
> > > >>                                                 group->iommu_group,
> > > >>                                                 group->iommu_device);
> > > >>           else
> > > >>                   return iommu_attach_group(domain->domain,
> > > >> group->iommu_group);
> > > >> }
> > > >>
> > > >> So, for both normal domain and aux-domain, we use the same concept:
> > > >> attach a domain to a group.
> > > >>  
> > > > I get that, but don't you have to attach all the devices within the  
> > >
> > > This iommu_group includes only mediated devices derived from an
> > > IOMMU_DEV_FEAT_AUX-capable device. Different from  
> > iommu_attach_group(),  
> > > iommu_aux_attach_group() doesn't need to attach the domain to each
> > > device in group, instead it only needs to attach the domain to the
> > > physical device where the mdev's were created from.
> > >  
> > > > group? Here you see the group already has a domain and exit.  
> > >
> > > If the (group->domain) has been set, that means a domain has already
> > > attached to the group, so it returns -EBUSY.  
> > 
> > I agree with Jacob, singleton groups should not be built into the IOMMU
> > API, we're not building an interface just for mdevs or current
> > limitations of mdevs.  This also means that setting a flag on the group
> > and passing a device that's assumed to be common for all devices within
> > the group, don't really make sense here.  Thanks,
> > 
> > Alex  
> 
> Baolu and I discussed about this assumption before. The assumption is
> not based on singleton groups. We do consider multiple mdevs in one
> group. But our feeling at the moment is that all mdevs (or other AUX
> derivatives) in the same group should come from the same parent 
> device, thus comes with above design. Does it sound a reasonable
> assumption to you?

No, the approach in this series doesn't really make sense to me.  We
currently have the following workflow as Baolu notes in the cover
letter:

	domain = iommu_domain_alloc(bus);

	iommu_group_for_each_dev(group... 

		iommu_device = mdev-magic()

		if (iommu_dev_feature_enabled(iommu_device,
						IOMMU_DEV_FEAT_AUX))
			iommu_aux_attach_device(domain, iommu_device);

And we want to convert this to a group function, like we have for
non-aux domains:

	domain = iommu_domain_alloc(bus);

	iommu_device = mdev-magic()

	iommu_aux_attach_group(domain, group, iommu_device);

And I think we want to do that largely because iommu_group.domain is
private to iommu.c (therefore vfio code cannot set it), but we need it
set in order for iommu_get_domain_for_dev() to work with a group
attached to an aux domain.  Passing an iommu_device avoids the problem
that IOMMU API code doesn't know how to derive an iommu_device for each
device in the group, but while doing so it ignores the fundamental
nature of a group as being a set of one or more devices.  Even if we
can make the leap that all devices within the group would use the same
iommu_device, an API that sets and aux domain for a group while
entirely ignoring the devices within the group seems very broken.

So, barring adding an abstraction at struct device where an IOMMU API
could retrieve the iommu_device backing anther device (which seems a
very abstract concept for the base class), why not have the caller
provide a lookup function?  Ex:

int iommu_aux_attach_group(struct iommu_domain *domain,
			   struct iommu_group *group,
			   struct device *(*iommu_device_lookup)(
				struct device *dev));

Thus vfio could could simply provide &vfio_mdev_get_iommu_device and
we'd have equivalent functionality to what we have currently, but with
the domain pointer set in the iommu_group.

This also however highlights that our VF backed mdevs will have the
same issue, so maybe this new IOMMU API interface should mimic
vfio_mdev_attach_domain() more directly, testing whether the resulting
device supports IOMMU_DEV_FEAT_AUX and using an aux vs non-aux attach.
I'm not sure what the name of this combined function should be,
iommu_attach_group_with_lookup()?  This could be the core
implementation of iommu_attach_group() where the existing function
simply wraps the call with a NULL function pointer.

Anyway, I think there are ways to implement this that are more in line
with the spirit of groups.  Thanks,

Alex

