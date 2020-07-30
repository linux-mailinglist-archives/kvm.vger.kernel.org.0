Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85150233A69
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 23:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbgG3VRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 17:17:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25934 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730493AbgG3VRO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 17:17:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596143830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZGuV4rD0Ceq1ep6s52mf/yK6aOPC8Nt7kiDKbGKZCM=;
        b=fSD5EdSO4Nry2NbMtGCBXHpYrFugAVbC9tkpespU/M+T6/H60af3AvbeEfXb5bwupHm6Wo
        JpDKJEyb5PqHjcrbr89Ft3/exIDM4FvC+IcUKDDNtkC4v5YQ7vNaRAbJP7mVrjDsCEqhY8
        mg87dFG8lwmzXvMNYApNlZMzdPiF818=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-x-mLPphPMe-v_LHwNhgtoA-1; Thu, 30 Jul 2020 17:17:06 -0400
X-MC-Unique: x-mLPphPMe-v_LHwNhgtoA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B53B1100A8F2;
        Thu, 30 Jul 2020 21:17:04 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C301519D7B;
        Thu, 30 Jul 2020 21:17:03 +0000 (UTC)
Date:   Thu, 30 Jul 2020 15:17:03 -0600
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
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group()
 APIs
Message-ID: <20200730151703.5daf8ad4@x1.home>
In-Reply-To: <af6c95a7-3238-1cbd-8656-014c12498587@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-5-baolu.lu@linux.intel.com>
        <20200729143258.22533170@x1.home>
        <af6c95a7-3238-1cbd-8656-014c12498587@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jul 2020 10:41:32 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> Hi Alex,
> 
> On 7/30/20 4:32 AM, Alex Williamson wrote:
> > On Tue, 14 Jul 2020 13:57:03 +0800
> > Lu Baolu <baolu.lu@linux.intel.com> wrote:
> >   
> >> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
> >> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the
> >> vfio_group data structure so that it could be reused in other places.
> >>
> >> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
> >>   1 file changed, 7 insertions(+), 37 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 5e556ac9102a..f8812e68de77 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -100,6 +100,7 @@ struct vfio_dma {
> >>   struct vfio_group {
> >>   	struct iommu_group	*iommu_group;
> >>   	struct list_head	next;
> >> +	struct device		*iommu_device;
> >>   	bool			mdev_group;	/* An mdev group */
> >>   	bool			pinned_page_dirty_scope;
> >>   };
> >> @@ -1627,45 +1628,13 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
> >>   	return NULL;
> >>   }
> >>   
> >> -static int vfio_mdev_attach_domain(struct device *dev, void *data)
> >> -{
> >> -	struct iommu_domain *domain = data;
> >> -	struct device *iommu_device;
> >> -
> >> -	iommu_device = vfio_mdev_get_iommu_device(dev);
> >> -	if (iommu_device) {
> >> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> >> -			return iommu_aux_attach_device(domain, iommu_device);
> >> -		else
> >> -			return iommu_attach_device(domain, iommu_device);
> >> -	}
> >> -
> >> -	return -EINVAL;
> >> -}
> >> -
> >> -static int vfio_mdev_detach_domain(struct device *dev, void *data)
> >> -{
> >> -	struct iommu_domain *domain = data;
> >> -	struct device *iommu_device;
> >> -
> >> -	iommu_device = vfio_mdev_get_iommu_device(dev);
> >> -	if (iommu_device) {
> >> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> >> -			iommu_aux_detach_device(domain, iommu_device);
> >> -		else
> >> -			iommu_detach_device(domain, iommu_device);
> >> -	}
> >> -
> >> -	return 0;
> >> -}
> >> -
> >>   static int vfio_iommu_attach_group(struct vfio_domain *domain,
> >>   				   struct vfio_group *group)
> >>   {
> >>   	if (group->mdev_group)
> >> -		return iommu_group_for_each_dev(group->iommu_group,
> >> -						domain->domain,
> >> -						vfio_mdev_attach_domain);
> >> +		return iommu_aux_attach_group(domain->domain,
> >> +					      group->iommu_group,
> >> +					      group->iommu_device);  
> > 
> > No, we previously iterated all devices in the group and used the aux
> > interface only when we have an iommu_device supporting aux.  If we
> > simply assume an mdev group only uses an aux domain we break existing
> > users, ex. SR-IOV VF backed mdevs.  Thanks,  
> 
> Oh, yes. Sorry! I didn't consider the physical device backed mdevs
> cases.
> 
> Looked into this part of code, it seems that there's a lock issue here.
> The group->mutex is held in iommu_group_for_each_dev() and will be
> acquired again in iommu_attach_device().

These are two different groups.  We walk the devices in the mdev's
group with iommu_group_for_each_dev(), holding the mdev's group lock,
but we call iommu_attach_device() with iommu_device, which results in
acquiring the lock for the iommu_device's group.

> How about making it like:
> 
> static int vfio_iommu_attach_group(struct vfio_domain *domain,
>                                     struct vfio_group *group)
> {
>          if (group->mdev_group) {
>                  struct device *iommu_device = group->iommu_device;
> 
>                  if (WARN_ON(!iommu_device))
>                          return -EINVAL;
> 
>                  if (iommu_dev_feature_enabled(iommu_device, 
> IOMMU_DEV_FEAT_AUX))
>                          return iommu_aux_attach_device(domain->domain, 
> iommu_device);
>                  else
>                          return iommu_attach_device(domain->domain, 
> iommu_device);
>          } else {
>                  return iommu_attach_group(domain->domain, 
> group->iommu_group);
>          }
> }
> 
> The caller (vfio_iommu_type1_attach_group) has guaranteed that all mdevs
> in an iommu group should be derived from a same physical device.

Have we?  iommu_attach_device() will fail if the group is not
singleton, but that's just encouraging us to use the _attach_group()
interface where the _attach_device() interface is relegated to special
cases.  Ideally we'd get out of those special cases and create an
_attach_group() for aux that doesn't further promote these notions.

> Any thoughts?

See my reply to Kevin, I'm thinking we need to provide a callback that
can enlighten the IOMMU layer to be able to do _attach_group() with
aux or separate IOMMU backed devices.  Thanks,

Alex

