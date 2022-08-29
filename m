Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9B5A46AF
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiH2KCI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 29 Aug 2022 06:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiH2KCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 06:02:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3EC12A8B
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 03:01:57 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGQrz18ZGznTrT;
        Mon, 29 Aug 2022 17:59:31 +0800 (CST)
Received: from kwepemm000015.china.huawei.com (7.193.23.180) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:01:55 +0800
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm000015.china.huawei.com (7.193.23.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:01:54 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2375.024;
 Mon, 29 Aug 2022 11:01:52 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        zhukeqian <zhukeqian1@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Thread-Topic: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Thread-Index: AQHYW0Rzgpg5/xCdS0KCiFrFVRklVq3GYU0g
Date:   Mon, 29 Aug 2022 10:01:52 +0000
Message-ID: <f692d2e1e45d4cb2ac5ecd05c8d9a32d@huawei.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-3-joao.m.martins@oracle.com>
In-Reply-To: <20220428210933.3583-3-joao.m.martins@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.156.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Joao Martins [mailto:joao.m.martins@oracle.com]
> Sent: 28 April 2022 22:09
> To: iommu@lists.linux-foundation.org
> Cc: Joao Martins <joao.m.martins@oracle.com>; Joerg Roedel
> <joro@8bytes.org>; Suravee Suthikulpanit
> <suravee.suthikulpanit@amd.com>; Will Deacon <will@kernel.org>; Robin
> Murphy <robin.murphy@arm.com>; Jean-Philippe Brucker
> <jean-philippe@linaro.org>; zhukeqian <zhukeqian1@huawei.com>;
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> David Woodhouse <dwmw2@infradead.org>; Lu Baolu
> <baolu.lu@linux.intel.com>; Jason Gunthorpe <jgg@nvidia.com>; Nicolin
> Chen <nicolinc@nvidia.com>; Yishai Hadas <yishaih@nvidia.com>; Kevin Tian
> <kevin.tian@intel.com>; Eric Auger <eric.auger@redhat.com>; Yi Liu
> <yi.l.liu@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org
> Subject: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
> 
> Add an io_pagetable kernel API to toggle dirty tracking:
> 
> * iopt_set_dirty_tracking(iopt, [domain], state)
> 
> It receives either NULL (which means all domains) or an
> iommu_domain. The intended caller of this is via the hw_pagetable
> object that is created on device attach, which passes an
> iommu_domain. For now, the all-domains is left for vfio-compat.
> 
> The hw protection domain dirty control is favored over the IOVA-range
> alternative. For the latter, it iterates over all IOVA areas and calls
> iommu domain op to enable/disable for the range.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/io_pagetable.c    | 71
> +++++++++++++++++++++++++
>  drivers/iommu/iommufd/iommufd_private.h |  3 ++
>  2 files changed, 74 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/io_pagetable.c
> b/drivers/iommu/iommufd/io_pagetable.c
> index f9f3b06946bf..f4609ef369e0 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -276,6 +276,77 @@ int iopt_map_user_pages(struct io_pagetable *iopt,
> unsigned long *iova,
>  	return 0;
>  }
> 
> +static int __set_dirty_tracking_range_locked(struct iommu_domain
> *domain,
> +					     struct io_pagetable *iopt,
> +					     bool enable)
> +{
> +	const struct iommu_domain_ops *ops = domain->ops;
> +	struct iommu_iotlb_gather gather;
> +	struct iopt_area *area;
> +	int ret = -EOPNOTSUPP;
> +	unsigned long iova;
> +	size_t size;
> +
> +	iommu_iotlb_gather_init(&gather);
> +
> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
> +		iova = iopt_area_iova(area);
> +		size = iopt_area_last_iova(area) - iova;

   size = iopt_area_last_iova(area) - iova + 1;  ?

Thanks,
Shameer
> +
> +		if (ops->set_dirty_tracking_range) {
> +			ret = ops->set_dirty_tracking_range(domain, iova,
> +							    size, &gather,
> +							    enable);
> +			if (ret < 0)
> +				break;
> +		}
> +	}
> +
> +	iommu_iotlb_sync(domain, &gather);
> +
> +	return ret;
> +}
> +
> +static int iommu_set_dirty_tracking(struct iommu_domain *domain,
> +				    struct io_pagetable *iopt, bool enable)
> +{
> +	const struct iommu_domain_ops *ops = domain->ops;
> +	int ret = -EOPNOTSUPP;
> +
> +	if (ops->set_dirty_tracking)
> +		ret = ops->set_dirty_tracking(domain, enable);
> +	else if (ops->set_dirty_tracking_range)
> +		ret = __set_dirty_tracking_range_locked(domain, iopt,
> +							enable);
> +
> +	return ret;
> +}
> +
> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> +			    struct iommu_domain *domain, bool enable)
> +{
> +	struct iommu_domain *dom;
> +	unsigned long index;
> +	int ret = -EOPNOTSUPP;
> +
> +	down_write(&iopt->iova_rwsem);
> +	if (!domain) {
> +		down_write(&iopt->domains_rwsem);
> +		xa_for_each(&iopt->domains, index, dom) {
> +			ret = iommu_set_dirty_tracking(dom, iopt, enable);
> +			if (ret < 0)
> +				break;
> +		}
> +		up_write(&iopt->domains_rwsem);
> +	} else {
> +		ret = iommu_set_dirty_tracking(domain, iopt, enable);
> +	}
> +
> +	up_write(&iopt->iova_rwsem);
> +	return ret;
> +}
> +
>  struct iopt_pages *iopt_get_pages(struct io_pagetable *iopt, unsigned long
> iova,
>  				  unsigned long *start_byte,
>  				  unsigned long length)
> diff --git a/drivers/iommu/iommufd/iommufd_private.h
> b/drivers/iommu/iommufd/iommufd_private.h
> index f55654278ac4..d00ef3b785c5 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -49,6 +49,9 @@ int iopt_unmap_iova(struct io_pagetable *iopt,
> unsigned long iova,
>  		    unsigned long length);
>  int iopt_unmap_all(struct io_pagetable *iopt);
> 
> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
> +			    struct iommu_domain *domain, bool enable);
> +
>  int iopt_access_pages(struct io_pagetable *iopt, unsigned long iova,
>  		      unsigned long npages, struct page **out_pages, bool write);
>  void iopt_unaccess_pages(struct io_pagetable *iopt, unsigned long iova,
> --
> 2.17.2

