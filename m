Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E123399E
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 22:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgG3URg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 16:17:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28110 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgG3URg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 16:17:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596140254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LSG66HoNLmBtxPByeCF0UpAy3dBM2fYznxaZ+/uxjK0=;
        b=ZLWh+hZ0q9/fW6mqYnaHR1Ue268MIk5MfHJ58eazTtvxZFxi5PyAOtZ/yRn9g2bsqH4hOG
        7bbwFmQex7Pg/v5Lf4VjRaJwtJkFLPZ/5nYv0mXQi07hqn7Z1jdd8VgI4XQH8Ad/MZwKxv
        JQbDPkxhUQJENClIpmGzYA3n/sRLIhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-dgqAD41JNK6CSATW3me9kw-1; Thu, 30 Jul 2020 16:17:29 -0400
X-MC-Unique: dgqAD41JNK6CSATW3me9kw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE7CA107ACCA;
        Thu, 30 Jul 2020 20:17:27 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68E2E7C0E2;
        Thu, 30 Jul 2020 20:17:26 +0000 (UTC)
Date:   Thu, 30 Jul 2020 14:17:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] iommu: Add iommu_aux_get_domain_for_dev()
Message-ID: <20200730141725.5f63b508@x1.home>
In-Reply-To: <MWHPR11MB1645736D9ED91A95D1D4519A8C700@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-4-baolu.lu@linux.intel.com>
        <20200729142507.182cd18a@x1.home>
        <MWHPR11MB1645736D9ED91A95D1D4519A8C700@MWHPR11MB1645.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jul 2020 23:49:20 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, July 30, 2020 4:25 AM
> > 
> > On Tue, 14 Jul 2020 13:57:02 +0800
> > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> >   
> > > The device driver needs an API to get its aux-domain. A typical usage
> > > scenario is:
> > >
> > >         unsigned long pasid;
> > >         struct iommu_domain *domain;
> > >         struct device *dev = mdev_dev(mdev);
> > >         struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
> > >
> > >         domain = iommu_aux_get_domain_for_dev(dev);
> > >         if (!domain)
> > >                 return -ENODEV;
> > >
> > >         pasid = iommu_aux_get_pasid(domain, iommu_device);
> > >         if (pasid <= 0)
> > >                 return -EINVAL;
> > >
> > >          /* Program the device context */
> > >          ....
> > >
> > > This adds an API for such use case.
> > >
> > > Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > ---
> > >  drivers/iommu/iommu.c | 18 ++++++++++++++++++
> > >  include/linux/iommu.h |  7 +++++++
> > >  2 files changed, 25 insertions(+)
> > >
> > > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > > index cad5a19ebf22..434bf42b6b9b 100644
> > > --- a/drivers/iommu/iommu.c
> > > +++ b/drivers/iommu/iommu.c
> > > @@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct  
> > iommu_domain *domain,  
> > >  }
> > >  EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
> > >
> > > +struct iommu_domain *iommu_aux_get_domain_for_dev(struct device  
> > *dev)  
> > > +{
> > > +	struct iommu_domain *domain = NULL;
> > > +	struct iommu_group *group;
> > > +
> > > +	group = iommu_group_get(dev);
> > > +	if (!group)
> > > +		return NULL;
> > > +
> > > +	if (group->aux_domain_attached)
> > > +		domain = group->domain;  
> > 
> > Why wouldn't the aux domain flag be on the domain itself rather than
> > the group?  Then if we wanted sanity checking in patch 1/ we'd only
> > need to test the flag on the object we're provided.
> > 
> > If we had such a flag, we could create an iommu_domain_is_aux()
> > function and then simply use iommu_get_domain_for_dev() and test that
> > it's an aux domain in the example use case.  It seems like that would  
> 
> IOMMU layer manages domains per parent device. Here given a

Is this the IOMMU layer or the VT-d driver?  I don't see any notion of
managing domains relative to a parent in the IOMMU layer.  Please point
to something more specific if I'm wrong here.

> dev (of mdev), we need a way to find its associated domain under its
> parent device. And we cannot simply use iommu_get_domain_for_dev
> on the parent device of the mdev, as it will give us the primary domain
> of parent device. 

Not the parent device of the mdev, but the mdev_dev(mdev) device.
Isn't that what this series is enabling, being able to return the
domain from the group that contains the mdev_dev?  We shouldn't need to
leave breadcrumbs on the group to know about the domain, the domain
itself should be the source of knowledge, or provide a mechanism/ops to
learn that knowledge.  Thanks,

Alex


> > resolve the jump from a domain to an aux-domain just as well as adding
> > this separate iommu_aux_get_domain_for_dev() interface.  The is_aux
> > test might also be useful in other cases too.  Thanks,
> > 
> > Alex
> >   
> > > +
> > > +	iommu_group_put(group);
> > > +
> > > +	return domain;
> > > +}
> > > +EXPORT_SYMBOL_GPL(iommu_aux_get_domain_for_dev);
> > > +
> > >  /**
> > >   * iommu_sva_bind_device() - Bind a process address space to a device
> > >   * @dev: the device
> > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > > index 9506551139ab..cda6cef7579e 100644
> > > --- a/include/linux/iommu.h
> > > +++ b/include/linux/iommu.h
> > > @@ -639,6 +639,7 @@ int iommu_aux_attach_group(struct  
> > iommu_domain *domain,  
> > >  			   struct iommu_group *group, struct device *dev);
> > >  void iommu_aux_detach_group(struct iommu_domain *domain,
> > >  			   struct iommu_group *group, struct device *dev);
> > > +struct iommu_domain *iommu_aux_get_domain_for_dev(struct device  
> > *dev);  
> > >
> > >  struct iommu_sva *iommu_sva_bind_device(struct device *dev,
> > >  					struct mm_struct *mm,
> > > @@ -1040,6 +1041,12 @@ iommu_aux_detach_group(struct  
> > iommu_domain *domain,  
> > >  {
> > >  }
> > >
> > > +static inline struct iommu_domain *
> > > +iommu_aux_get_domain_for_dev(struct device *dev)
> > > +{
> > > +	return NULL;
> > > +}
> > > +
> > >  static inline struct iommu_sva *
> > >  iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void  
> > *drvdata)  
> > >  {  
> 

