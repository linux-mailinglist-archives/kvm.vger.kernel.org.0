Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1211413968
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhIUSDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 14:03:36 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:39040
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231719AbhIUSDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 14:03:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKcbPve3xzCe57KFpPLrxdGI41YKOMPCwVBDCQb+RqeURMWbep9blPXtjzWkbkq6TS8qGH9hjTpnl9zCMdn1ukfhds9rQtXg5P0ErIDJEHI0o7zEnjWgUZpeDJ3jsrlykYqkrDB+r4Yw3yw+nDZzm+hU8xL9YnnJXJd50Qbw9pRf7FPCoKQV5LZqLGqbyyVxKx+9vn3yJJiByiKMBWuAXYU+zuLhwLaje3au1m8dWWF5yoTdGTPo/tP6gHyPhhmtwMaAXCGELfH9eD5YNyZFG5XDfqCH8X7caDISN8ZYMW9FE1QJxlEtlv1MgISBxjRyp08im+12gXswiF4w3tu98A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GbIfm1PL887bjk13mp+rA/xZgAFBS1N9vxVF4Aw8s4g=;
 b=g0EYz5pgecZzf+xNEbCjWM8wWOJfWFyJiTkZYlWddMUE7XBWUJCEm7Lomt1nrL/EZnD1M3mNG5xrOUXoyuGuuLFwOhHHRoYm2kefyhVoEwiUFNSVkSwSJhE3aD04nGpQEUERPFRf3KjujEFh3aOP3eimCpID9UsZaMzojQ+jxnDxsC/oDXj4kU+rOw6qTMmccmnx0nRF8nE+NICkYdLz2ZZTT5cYePr0y/BYk848gJkk/JSb04lwabjEoOwTUaNF1zsDLabsDZV4ChvOBwdoli1BpU+WTmmM346ZaRQXrdmtsWuPkp7C01cpqWQP7mdewB6cQYD7hohQ7KEI+zGirg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbIfm1PL887bjk13mp+rA/xZgAFBS1N9vxVF4Aw8s4g=;
 b=NfYjjRtckI4//ve7tELRAMnT1UXeFBnCDFkBa2eM91InqZ7XdxxOz/RLEe03XW+bsnaciytcuCZWacAjU+98ucxKLRcousJcRkTA+I4y0Gi2HxjlDvO1g9oLM8J3nxwX9VvZB1ZnHXVxaEyyLc8JWiqu/LRhWhRtcSITPEjWgbOi9TE2qP2R4Lr0Cst/ET9M2Wz9+2XB09SVkRXQJxTE9CEoluq+3G3/iQh5Jk2SelIrpbf/H549vKVAu6ifEtKMsOq9TjBO0CHI5XD3WpDJSaKHzBkbalNgRK+6J6P/dQIt16Cx7XS4dvnw9xUEYim31uar1Zmsy33js8lN4IpT8Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 21 Sep
 2021 18:02:05 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 18:02:05 +0000
Date:   Tue, 21 Sep 2021 15:02:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 14/20] iommu/iommufd: Add iommufd_device_[de]attach_ioasid()
Message-ID: <20210921180203.GY327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-15-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-15-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0319.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0319.namprd13.prod.outlook.com (2603:10b6:208:2c1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Tue, 21 Sep 2021 18:02:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSk5j-003XIN-UM; Tue, 21 Sep 2021 15:02:03 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e83f8d5-f796-4344-78cc-08d97d29eb84
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143CF5A0C8C54963810CE0BC2A19@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DImCog2q/sLcc2hw+JSeu6DlMV5g3WxXr2YnG3BLGcM1O0WPZfmSn4edW4yBbwkY9ICQAu1gXKfb52MGNamglSpu662LIzH5DMOurdMSETfouQsfEES159WFpIieHbQ+qBEaoSpcYIXe+qHpMDnm5GRHd9YP1pZ3IFqU3LtmSv2WrN1TJGvdfr+MYhONs9stCxQJqXH5gDuwboYUSjpuAOz+EdKlW+kpfq+Twi8oZ7VivWdkL+uRFOHvPqAveXi+xtKYCXOyeYZpxQOpylq+p6fo6WjmA5Y68mVVvQ9I9NBq6E5/oXzQ28JzF1SVg8BamxQ5ZAwD/RKYZsTr81RITah+N7BUoYkEUpuLwFuyCwKHTh9ZsGeE6X9oereRmfkgKk2/wNBdK2mMNehSUNHLssPqtxC+YfIjCJEI1tgx5i959gUqS/IdSexkcXyFaRtIhvCjkvVF7TA/PaCrARafLAcOmrv+1xuOud1OTBV8SMUayUXCkJcFPtXFI6wJ7syXTQHZmOse++5BdxZnGXOYGZIinLSXi+FHEo7TWVom35NPJE8zemv+FrV6Nk5KagfQEUDrdttUAJWr4egfxk+0K0T2DNNESLivacac1fxWJithw9kjZIHRkAHrjsyKfGhcFTdcm7KFJahjVRYkn/6mRayqfcb7psDdAP1Gt5VRYgBIE7qqY/3NjW2PNAYPO1VYGARbF+UFZ6ZqfNdjp42m7nepr529sGTjC7K0PrrCVIxxAND+ccaxZRT9D6Aezwtz+JODGZWGfy13WOAyBK4Nxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(5660300002)(66476007)(7416002)(26005)(9786002)(186003)(316002)(9746002)(33656002)(38100700002)(66946007)(107886003)(8936002)(508600001)(86362001)(4326008)(6916009)(36756003)(2616005)(426003)(966005)(2906002)(83380400001)(8676002)(1076003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?844LSYP7gXCwoxt+vNzJL8r2YNWEYztotBrwcXX6iGz9ytMH3oprssyfjssW?=
 =?us-ascii?Q?4Ts7KXGWd71qOajFAG17TL5OgkDsIkCdOU4bot/5/1BVVWegbHeEAw/97zKf?=
 =?us-ascii?Q?EebzUnzPTbnyYv2w911y8Fp0YIwvRrFjYO2Dm4W3fj7XOZI+DTThhGrarp5P?=
 =?us-ascii?Q?KCaktrPkhqJryY1+ClYPrf2Vq48U9X7mDtxoVeRWqFmm0EV3a8FiIpNCY9qc?=
 =?us-ascii?Q?TlvVA7s9WKSEY75M5875iGffVSgKCFH8/T5dPV4ftP/21LPk7Us+aq//Af1x?=
 =?us-ascii?Q?6xLFOVJXHcLHGh1D4/kTHWZG5jXw2gWT3xkoj1tM1bz0CwRu1EZgCqwEx/lD?=
 =?us-ascii?Q?io16LGSnVcFcsKCE4MwUQJYlgGvcCGWGnIESxvtIl4iw18Q5REgJYpw+09hf?=
 =?us-ascii?Q?xsQ31j47/15DS27fEmoiYAcg/qa0aChvh165yg04ljBy9ANk3SWvzMcGDrFt?=
 =?us-ascii?Q?FzjrR9YeLJMBcZbw2WcvBh/gm/gWE0CoPCpaZ0ENfKv90mLL4XmBZ7pJloYn?=
 =?us-ascii?Q?trSR7aZBNO76mXEVBU0ZPvX6x6OC/k1a6vaAGayeFw+cMKagDLvlWtBjuO+T?=
 =?us-ascii?Q?9ZX2Rvv7/rNjqFR5Zh1FGFltw6snKSR8AsgfswGLHvgg8plZwyLrMSH0BWmO?=
 =?us-ascii?Q?FzwqxvQapCXZy9z/P1kAKOEfWbQgfb4jzbdV3zIA3MVcpJeBMYNjSGgtp37Z?=
 =?us-ascii?Q?v84bxNBiiIOb0SYCtE1bAns1OjSVjS/zr60FWZfUBQX9x/3fhm/zkGiNA361?=
 =?us-ascii?Q?CcQXqT3w8t8tfLl2CXIYohpSoSeV6Od2gmK1wBdw0q95UHyjshxjgJQ525sT?=
 =?us-ascii?Q?ZwAzKOUc970wqP/P0IicOy8tqXSSTUwKoZMsyKW5ncjq9J+8h77z28b6h/FF?=
 =?us-ascii?Q?/T+Awhze7cHQUv666z20cFMbo/1kryhbV8uUhLYJ4RiSJ6UvTYjB4+3a9zSu?=
 =?us-ascii?Q?G5OL5DaXzejM1Uri6Hi1ckDjFwHWxGoq4XYcDLwVoc6ix8OeqLBZMYxGd0rt?=
 =?us-ascii?Q?772lMCeAh1AoTnICrXRi+l/9ls8uZqD5+yGGQ25pfbU0+ji4xTpvBGBtHuRR?=
 =?us-ascii?Q?LsbDiuMDv+mX/fG+NRgnRj3JKNtDtpPxoj1BT4nIrCQPeqmAaCmDw/IvC312?=
 =?us-ascii?Q?In9/ZLOQ6F9ppNFDApBCy3SrSHCvjbkIxy6O0kphNKpbjOK/GVWi9CGgdUv8?=
 =?us-ascii?Q?L2bcNbUUdL3vapWoZgqC51sV0httL+IRbt3gIsBze9X4Q1E5K3KDLlTVs4xR?=
 =?us-ascii?Q?WlWivuTW4e/pal8F9wUMqsr6hHSd4scy0kvl7dMN4BWCyyfDTmvAv+ky83iz?=
 =?us-ascii?Q?U9+ZUegsGFj2+qsdhIxi6BSg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e83f8d5-f796-4344-78cc-08d97d29eb84
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 18:02:05.0563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+ItimGqjx/umJ3H+/JNAOdgj+F91aEduDto2kqDRb62GW3amjoGg10h2bqudHaZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:42PM +0800, Liu Yi L wrote:
> An I/O address space takes effect in the iommu only after it's attached
> by a device. This patch provides iommufd_device_[de/at]tach_ioasid()
> helpers for this purpose. One device can be only attached to one ioasid
> at this point, but one ioasid can be attached by multiple devices.
> 
> The caller specifies the iommufd_device (returned at binding time) and
> the target ioasid when calling the helper function. Upon request, iommufd
> installs the specified I/O page table to the correct place in the IOMMU,
> according to the routing information (struct device* which represents
> RID) recorded in iommufd_device. Future variants could allow the caller
> to specify additional routing information (e.g. pasid/ssid) when multiple
> I/O address spaces are supported per device.
> 
> Open:
> Per Jason's comment in below link, bus-specific wrappers are recommended.
> This RFC implements one wrapper for pci device. But it looks that struct
> pci_device is not used at all since iommufd_ device already carries all
> necessary info. So want to have another discussion on its necessity, e.g.
> whether making more sense to have bus-specific wrappers for binding, while
> leaving a common attaching helper per iommufd_device.
> https://lore.kernel.org/linux-iommu/20210528233649.GB3816344@nvidia.com/
> 
> TODO:
> When multiple devices are attached to a same ioasid, the permitted iova
> ranges and supported pgsize bitmap on this ioasid should be a common
> subset of all attached devices. iommufd needs to track such info per
> ioasid and update it every time when a new device is attached to the
> ioasid. This has not been done in this version yet, due to the temporary
> hack adopted in patch 16-18. The hack reuses vfio type1 driver which
> already includes the necessary logic for iova ranges and pgsize bitmap.
> Once we get a clear direction for those patches, that logic will be moved
> to this patch.
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>  drivers/iommu/iommufd/iommufd.c | 226 ++++++++++++++++++++++++++++++++
>  include/linux/iommufd.h         |  29 ++++
>  2 files changed, 255 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
> index e45d76359e34..25373a0e037a 100644
> +++ b/drivers/iommu/iommufd/iommufd.c
> @@ -51,6 +51,19 @@ struct iommufd_ioas {
>  	bool enforce_snoop;
>  	struct iommufd_ctx *ictx;
>  	refcount_t refs;
> +	struct mutex lock;
> +	struct list_head device_list;
> +	struct iommu_domain *domain;

This should just be another xarray indexed by the device id

> +/* Caller should hold ioas->lock */
> +static struct ioas_device_info *ioas_find_device(struct iommufd_ioas *ioas,
> +						 struct iommufd_device *idev)
> +{
> +	struct ioas_device_info *ioas_dev;
> +
> +	list_for_each_entry(ioas_dev, &ioas->device_list, next) {
> +		if (ioas_dev->idev == idev)
> +			return ioas_dev;
> +	}

Which eliminates this search. xarray with tightly packed indexes is
generally more efficient than linked lists..

> +static int ioas_check_device_compatibility(struct iommufd_ioas *ioas,
> +					   struct device *dev)
> +{
> +	bool snoop = false;
> +	u32 addr_width;
> +	int ret;
> +
> +	/*
> +	 * currently we only support I/O page table with iommu enforce-snoop
> +	 * format. Attaching a device which doesn't support this format in its
> +	 * upstreaming iommu is rejected.
> +	 */
> +	ret = iommu_device_get_info(dev, IOMMU_DEV_INFO_FORCE_SNOOP, &snoop);
> +	if (ret || !snoop)
> +		return -EINVAL;
> +
> +	ret = iommu_device_get_info(dev, IOMMU_DEV_INFO_ADDR_WIDTH, &addr_width);
> +	if (ret || addr_width < ioas->addr_width)
> +		return -EINVAL;
> +
> +	/* TODO: also need to check permitted iova ranges and pgsize bitmap */
> +
> +	return 0;
> +}

This seems kind of weird..

I expect the iommufd to hold a SW copy of the IO page table and each
time a new domain is to be created it should push the SW copy into the
domain. If the domain cannot support it then the domain driver should
naturally fail a request.

When the user changes the IO page table the SW copy is updated then
all of the domains are updated too - again if any domain cannot
support the change then it fails and the change is rolled back.

It seems like this is a side effect of roughly hacking in the vfio
code?

> +
> +/**
> + * iommufd_device_attach_ioasid - attach device to an ioasid
> + * @idev: [in] Pointer to struct iommufd_device.
> + * @ioasid: [in] ioasid points to an I/O address space.
> + *
> + * Returns 0 for successful attach, otherwise returns error.
> + *
> + */
> +int iommufd_device_attach_ioasid(struct iommufd_device *idev, int ioasid)

Types for the ioas_id again..

> +{
> +	struct iommufd_ioas *ioas;
> +	struct ioas_device_info *ioas_dev;
> +	struct iommu_domain *domain;
> +	int ret;
> +
> +	ioas = ioasid_get_ioas(idev->ictx, ioasid);
> +	if (!ioas) {
> +		pr_err_ratelimited("Trying to attach illegal or unkonwn IOASID %u\n", ioasid);
> +		return -EINVAL;

No prints triggered by bad userspace

> +	}
> +
> +	mutex_lock(&ioas->lock);
> +
> +	/* Check for duplicates */
> +	if (ioas_find_device(ioas, idev)) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}

just xa_cmpxchg NULL, XA_ZERO_ENTRY

> +	/*
> +	 * Each ioas is backed by an iommu domain, which is allocated
> +	 * when the ioas is attached for the first time and then shared
> +	 * by following devices.
> +	 */
> +	if (list_empty(&ioas->device_list)) {

Seems strange, what if the devices are forced to have different
domains? We don't want to model that in the SW layer..

> +	/* Install the I/O page table to the iommu for this device */
> +	ret = iommu_attach_device(domain, idev->dev);
> +	if (ret)
> +		goto out_domain;

This is where things start to get confusing when you talk about PASID
as the above call needs to be some PASID centric API.

> @@ -27,6 +28,16 @@ struct iommufd_device *
>  iommufd_bind_device(int fd, struct device *dev, u64 dev_cookie);
>  void iommufd_unbind_device(struct iommufd_device *idev);
>  
> +int iommufd_device_attach_ioasid(struct iommufd_device *idev, int ioasid);
> +void iommufd_device_detach_ioasid(struct iommufd_device *idev, int ioasid);
> +
> +static inline int
> +__pci_iommufd_device_attach_ioasid(struct pci_dev *pdev,
> +				   struct iommufd_device *idev, int ioasid)
> +{
> +	return iommufd_device_attach_ioasid(idev, ioasid);
> +}

If think sis taking in the iommfd_device then there isn't a logical
place to signal the PCIness

But, I think the API should at least have a kdoc that this is
capturing the entire device and specify that for PCI this means all
TLPs with the RID.

Jason
