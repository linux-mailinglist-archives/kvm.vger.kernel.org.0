Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D47234AB2
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 20:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgGaSO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 14:14:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730040AbgGaSO0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 14:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596219264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5RCnyOaFSBCI3Qz6zkjCZ63e5lETgkYf1JyHMYznJQ=;
        b=T75L1VmuKn87aEA1Ac94iyH6oSjK3TP2MBmqr+En+JSWWG6gfAl3LybtuKvoVZ/q+ME/dp
        0jMufEOvwkvNKx0k7Tvql4HLDpDUyVufgt9s1NgYyqWwJ35Qhn1sCA+8/KkHEUGEf0UxWZ
        LjreQFuKIz4Qc+EkY9dSoKc1LI0XJi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-wSMzoo6iOy6LHz813pxjOA-1; Fri, 31 Jul 2020 14:14:22 -0400
X-MC-Unique: wSMzoo6iOy6LHz813pxjOA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CA0318839CD;
        Fri, 31 Jul 2020 18:14:20 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 732831002388;
        Fri, 31 Jul 2020 18:14:19 +0000 (UTC)
Date:   Fri, 31 Jul 2020 12:14:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/4] iommu: Add iommu_aux_get_domain_for_dev()
Message-ID: <20200731121418.0274afb8@x1.home>
In-Reply-To: <06fd91c1-a978-d526-7e2b-fec619a458e4@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-4-baolu.lu@linux.intel.com>
        <20200729142507.182cd18a@x1.home>
        <06fd91c1-a978-d526-7e2b-fec619a458e4@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 31 Jul 2020 14:30:03 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> Hi Alex,
> 
> On 2020/7/30 4:25, Alex Williamson wrote:
> > On Tue, 14 Jul 2020 13:57:02 +0800
> > Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> >   
> >> The device driver needs an API to get its aux-domain. A typical usage
> >> scenario is:
> >>
> >>          unsigned long pasid;
> >>          struct iommu_domain *domain;
> >>          struct device *dev = mdev_dev(mdev);
> >>          struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
> >>
> >>          domain = iommu_aux_get_domain_for_dev(dev);
> >>          if (!domain)
> >>                  return -ENODEV;
> >>
> >>          pasid = iommu_aux_get_pasid(domain, iommu_device);
> >>          if (pasid <= 0)
> >>                  return -EINVAL;
> >>
> >>           /* Program the device context */
> >>           ....
> >>
> >> This adds an API for such use case.
> >>
> >> Suggested-by: Alex Williamson<alex.williamson@redhat.com>
> >> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
> >> ---
> >>   drivers/iommu/iommu.c | 18 ++++++++++++++++++
> >>   include/linux/iommu.h |  7 +++++++
> >>   2 files changed, 25 insertions(+)
> >>
> >> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> >> index cad5a19ebf22..434bf42b6b9b 100644
> >> --- a/drivers/iommu/iommu.c
> >> +++ b/drivers/iommu/iommu.c
> >> @@ -2817,6 +2817,24 @@ void iommu_aux_detach_group(struct iommu_domain *domain,
> >>   }
> >>   EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
> >>   
> >> +struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *dev)
> >> +{
> >> +	struct iommu_domain *domain = NULL;
> >> +	struct iommu_group *group;
> >> +
> >> +	group = iommu_group_get(dev);
> >> +	if (!group)
> >> +		return NULL;
> >> +
> >> +	if (group->aux_domain_attached)
> >> +		domain = group->domain;  
> > Why wouldn't the aux domain flag be on the domain itself rather than
> > the group?  Then if we wanted sanity checking in patch 1/ we'd only
> > need to test the flag on the object we're provided.  
> 
> Agreed. Given that a group may contain both non-aux and aux devices,
> adding such flag in iommu_group doesn't make sense.
> 
> > 
> > If we had such a flag, we could create an iommu_domain_is_aux()
> > function and then simply use iommu_get_domain_for_dev() and test that
> > it's an aux domain in the example use case.  It seems like that would
> > resolve the jump from a domain to an aux-domain just as well as adding
> > this separate iommu_aux_get_domain_for_dev() interface.  The is_aux
> > test might also be useful in other cases too.  
> 
> Let's rehearsal our use case.
> 
>          unsigned long pasid;
>          struct iommu_domain *domain;
>          struct device *dev = mdev_dev(mdev);
>          struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
> 
> [1]     domain = iommu_get_domain_for_dev(dev);
>          if (!domain)
>                  return -ENODEV;
> 
> [2]     pasid = iommu_aux_get_pasid(domain, iommu_device);
>          if (pasid <= 0)
>                  return -EINVAL;
> 
>           /* Program the device context */
>           ....
> 
> The reason why I add this iommu_aux_get_domain_for_dev() is that we need
> to make sure the domain got at [1] is valid to be used at [2].
> 
> https://lore.kernel.org/linux-iommu/20200707150408.474d81f1@x1.home/

Yep, I thought that was a bit of a leap in logic.

> When calling into iommu_aux_get_pasid(), the iommu driver should make
> sure that @domain is a valid aux-domain for @iommu_device. Hence, for
> our use case, it seems that there's no need for a is_aux_domain() api.
> 
> Anyway, I'm not against adding a new is_aux_domain() api if there's a
> need elsewhere.

I think it could work either way, we could have an
iommu_get_aux_domain_for_dev() which returns NULL if the domain is not
an aux domain, or we could use iommu_get_domain_for_dev() and the
caller could test the domain with iommu_is_aux_domain() if they need to
confirm if it's an aux domain.  The former could even be written using
the latter, a wrapper of iommu_get_domain_for_dev() that checks aux
property before returning.  Thanks,

Alex

