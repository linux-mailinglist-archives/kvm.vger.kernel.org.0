Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0025F898
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfGDMxw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 4 Jul 2019 08:53:52 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:33052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbfGDMxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 08:53:52 -0400
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 3DA421FEFF57E93EA4C0;
        Thu,  4 Jul 2019 13:53:51 +0100 (IST)
Received: from LHREML524-MBS.china.huawei.com ([169.254.2.154]) by
 lhreml709-cah.china.huawei.com ([10.201.108.32]) with mapi id 14.03.0415.000;
 Thu, 4 Jul 2019 13:53:41 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Linuxarm <linuxarm@huawei.com>,
        "John Garry" <john.garry@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
Subject: RE: [PATCH v7 3/6] vfio/type1: Update iova list on detach
Thread-Topic: [PATCH v7 3/6] vfio/type1: Update iova list on detach
Thread-Index: AQHVLDHlzsp7WZ6o0k2WlwGboVZ1gKa5VF+AgAEhqmA=
Date:   Thu, 4 Jul 2019 12:53:41 +0000
Message-ID: <5FC3163CFD30C246ABAA99954A238FA83F2DDB80@lhreml524-mbs.china.huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
        <20190626151248.11776-4-shameerali.kolothum.thodi@huawei.com>
 <20190703143451.0ae4e9f7@x1.home>
In-Reply-To: <20190703143451.0ae4e9f7@x1.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.34.206.221]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Alex Williamson
> Sent: 03 July 2019 21:35
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: eric.auger@redhat.com; pmorel@linux.vnet.ibm.com;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> iommu@lists.linux-foundation.org; Linuxarm <linuxarm@huawei.com>; John
> Garry <john.garry@huawei.com>; xuwei (O) <xuwei5@huawei.com>;
> kevin.tian@intel.com
> Subject: Re: [PATCH v7 3/6] vfio/type1: Update iova list on detach
> 
> On Wed, 26 Jun 2019 16:12:45 +0100
> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > Get a copy of iova list on _group_detach and try to update the list.
> > On success replace the current one with the copy. Leave the list as
> > it is if update fails.
> >
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 91
> +++++++++++++++++++++++++++++++++
> >  1 file changed, 91 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> > index b6bfdfa16c33..e872fb3a0f39 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -1873,12 +1873,88 @@ static void vfio_sanity_check_pfn_list(struct
> vfio_iommu *iommu)
> >  	WARN_ON(iommu->notifier.head);
> >  }
> >
> > +/*
> > + * Called when a domain is removed in detach. It is possible that
> > + * the removed domain decided the iova aperture window. Modify the
> > + * iova aperture with the smallest window among existing domains.
> > + */
> > +static void vfio_iommu_aper_expand(struct vfio_iommu *iommu,
> > +				   struct list_head *iova_copy)
> > +{
> > +	struct vfio_domain *domain;
> > +	struct iommu_domain_geometry geo;
> > +	struct vfio_iova *node;
> > +	dma_addr_t start = 0;
> > +	dma_addr_t end = (dma_addr_t)~0;
> > +
> > +	list_for_each_entry(domain, &iommu->domain_list, next) {
> > +		iommu_domain_get_attr(domain->domain,
> DOMAIN_ATTR_GEOMETRY,
> > +				      &geo);
> > +		if (geo.aperture_start > start)
> > +			start = geo.aperture_start;
> > +		if (geo.aperture_end < end)
> > +			end = geo.aperture_end;
> > +	}
> > +
> > +	/* Modify aperture limits. The new aper is either same or bigger */
> > +	node = list_first_entry(iova_copy, struct vfio_iova, list);
> > +	node->start = start;
> > +	node = list_last_entry(iova_copy, struct vfio_iova, list);
> > +	node->end = end;
> > +}
> > +
> > +/*
> > + * Called when a group is detached. The reserved regions for that
> > + * group can be part of valid iova now. But since reserved regions
> > + * may be duplicated among groups, populate the iova valid regions
> > + * list again.
> > + */
> > +static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
> > +				   struct list_head *iova_copy)
> > +{
> > +	struct vfio_domain *d;
> > +	struct vfio_group *g;
> > +	struct vfio_iova *node;
> > +	dma_addr_t start, end;
> > +	LIST_HEAD(resv_regions);
> > +	int ret;
> > +
> > +	list_for_each_entry(d, &iommu->domain_list, next) {
> > +		list_for_each_entry(g, &d->group_list, next)
> > +			iommu_get_group_resv_regions(g->iommu_group,
> > +						     &resv_regions);
> 
> Need to account for failure case here too.

Ok.

> > +	}
> > +
> > +	if (list_empty(&resv_regions))
> > +		return 0;
> > +
> > +	node = list_first_entry(iova_copy, struct vfio_iova, list);
> > +	start = node->start;
> > +	node = list_last_entry(iova_copy, struct vfio_iova, list);
> > +	end = node->end;
> > +
> > +	/* purge the iova list and create new one */
> > +	vfio_iommu_iova_free(iova_copy);
> > +
> > +	ret = vfio_iommu_aper_resize(iova_copy, start, end);
> > +	if (ret)
> > +		goto done;
> > +
> > +	/* Exclude current reserved regions from iova ranges */
> > +	ret = vfio_iommu_resv_exclude(iova_copy, &resv_regions);
> > +done:
> > +	vfio_iommu_resv_free(&resv_regions);
> > +	return ret;
> > +}
> > +
> >  static void vfio_iommu_type1_detach_group(void *iommu_data,
> >  					  struct iommu_group *iommu_group)
> >  {
> >  	struct vfio_iommu *iommu = iommu_data;
> >  	struct vfio_domain *domain;
> >  	struct vfio_group *group;
> > +	bool iova_copy_fail;
> > +	LIST_HEAD(iova_copy);
> >
> >  	mutex_lock(&iommu->lock);
> >
> > @@ -1901,6 +1977,12 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
> >  		}
> >  	}
> >
> > +	/*
> > +	 * Get a copy of iova list. If success, use copy to update the
> > +	 * list and to replace the current one.
> > +	 */
> > +	iova_copy_fail = !!vfio_iommu_iova_get_copy(iommu, &iova_copy);
> > +
> >  	list_for_each_entry(domain, &iommu->domain_list, next) {
> >  		group = find_iommu_group(domain, iommu_group);
> >  		if (!group)
> > @@ -1926,10 +2008,19 @@ static void
> vfio_iommu_type1_detach_group(void *iommu_data,
> >  			iommu_domain_free(domain->domain);
> >  			list_del(&domain->next);
> >  			kfree(domain);
> > +			if (!iova_copy_fail && !list_empty(&iommu->domain_list))
> > +				vfio_iommu_aper_expand(iommu, &iova_copy);
> >  		}
> >  		break;
> >  	}
> >
> > +	if (!iova_copy_fail && !list_empty(&iommu->domain_list)) {
> > +		if (!vfio_iommu_resv_refresh(iommu, &iova_copy))
> > +			vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> > +		else
> > +			vfio_iommu_iova_free(&iova_copy);
> > +	}
> 
> The iova_copy_fail and list_empty tests are rather ugly, could we avoid
> them by pushing the tests to the expand and refresh functions?  ie. it
> looks like vfio_iommu_aper_expand() could test list_empty(iova_copy),
> the list_for_each on domain_list doesn't need special handling.  Same
> for vfio_iommu_resv_refresh().  This would also fix the bug above that
> I think we don't free iova_copy if domain_list becomes empty during
> this operation.  Thanks,

Agree. I will change that in next revision.

Thanks,
Shameer
