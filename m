Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D2A40EB32
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 21:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235817AbhIPT5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 15:57:31 -0400
Received: from mail-mw2nam12on2041.outbound.protection.outlook.com ([40.107.244.41]:11776
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232637AbhIPT5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 15:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SU9F8tjE8p9kyuAqTmVsZzoAs6m8361auugzrQ6/RjgApb9stWWDH5fNCETvSNd00tP0onYgvXGIhNFzBd1hqjiaZCTR4wQ8Z3CXB+/zRSCtrRiBI2bPgzsPim548Zis2iYG2CzEnOrVDpP4PDocGpAlatq+grj3zlUmWzVpfExY43C5YzgzErStcUe3iyC7EA/82D7LlqTnrk7Zg5sZUwD8fprX7bCvEtaQjm3oJZk3Nj2ZPUGNDUYJ/CE+3EVM3xYz4d6/ZCiESCplbLdwFXpMiDuc6YooqXQUPrXt152g6WTfT67kBcxH7sVXzNqZ9E8MARcJRSfJ+sPkglc8vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ERF0eL7qv1i/8wWu5ibVdnpFJc1O1lSrwtYF/9of0OM=;
 b=e9cGxjK0pi3dDzgFhEeA5LC32U5PYA8sFfvUn488GZIsu0uN3i61m21+rKYC+pArO/Hgezwhr0u/bmDx/sLwn5U0Z3DO/iOkDKpeyUwbvsC/xl4EuDARy9dWiegYmZ6F3YhubpGyYbjr3E2GInCnAt41zZnDIZ0Q7drCK8mbZnmvE9GP7+lKOfAEIh9dARMKrRX8R8WOAxtqMh/piTt7TLKU/PYr0XzLGTRQiRX2KeShL/UXERwIsHCrLd5MpRyvs1RzEw6FoLAnnYnXu5r8dK8bq6crbqzjAKsCUgeI1ssmaY0kMfSWwjGurAO4Y2czdmCz9qTUIQouD6x9cXHhRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERF0eL7qv1i/8wWu5ibVdnpFJc1O1lSrwtYF/9of0OM=;
 b=MqBeNpQ9Nb/VkfMRCQWs9/ruMUipXHvB1iW2b3RhXdkcKxeZivJOKDLtev6jsP7MtrPVfC+Pt/qmD4QTVxJ23Fpvqh9JCDDoi1iq8sL14tZa2fX1RYeZ8Mo4sc2d+4veZq7hoONcnOZUHh02E2BfUPpbhENfwjEnTiYj9HE2AXAEfksgdLHxUeWUzJlzP3yFdSUT3r94a31509N8sGo1j9PC383aIRz7umd++4tOSFF2sXzHzRPXlSKluIy3wh3Oc5dfH7dtvjI+CL1UK+ClZHn8xhn5aMVqSGsFVCjZzW75Q1qCZp1GFZo13Nf8aNhsopFbv6Fv9+67OnCs3pgN+w==
Received: from BN6PR13CA0020.namprd13.prod.outlook.com (2603:10b6:404:10a::30)
 by DM5PR12MB2488.namprd12.prod.outlook.com (2603:10b6:4:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Thu, 16 Sep
 2021 19:56:08 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::4d) by BN6PR13CA0020.outlook.office365.com
 (2603:10b6:404:10a::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend
 Transport; Thu, 16 Sep 2021 19:56:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 19:56:07 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Sep
 2021 12:56:06 -0700
Received: from [10.40.102.56] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Sep
 2021 19:56:03 +0000
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-12-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
Date:   Fri, 17 Sep 2021 01:25:59 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210913071606.2966-12-hch@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb40b03-f42a-482a-a4e8-08d9794c063d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2488:
X-Microsoft-Antispam-PRVS: <DM5PR12MB24881AF3936E580BCF6B14D5DCDC9@DM5PR12MB2488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7t66hySAcC8Ba3N/GY9dpt/7/19UCBnIR7NCgotOAHsHhaJMM056+nErG5czUXZVKMaX+C5Uq1jFIQ3LR3kuN+SHObw1d1szfj7xyKOdc2KuKz95H9vdAowy9eqNHuT/1QEWmFNLg1/Lvkzxqc8h8+bqbovRjE+zaoCwMOllaqDOlmQKzdmyLH8RhpCn2w1khvgvU/KacoBoM2bV8IymWBqweMq7/z7Yz8ZnTbLWCj2Vj517GbCZ69EZhkqzMA7sJ6ES6nyRhO1NpzHh3SACT4xxvaewDrhET0ML8M0okH8sTBFQOf8JEft0h3SdcKjGV93OMu0UKHU+LXHE0PerQ+8/wKz7M9lFYN8N+ZOYDVbKhQRln+k0H9PD0SilXJ7MTNU1xz8/xHxX6+bLDDxQCNniZEI9gV/7NnEkmQa+27NGu3ldKCL8lY+85rf0+q6LhKfMVvTRJqoK2jYg6olxfIi2eyZorbuPOl2sJWUVtwdPx057x7dk0GixXTtZwJLqf3zvUzbHC/eOSF06dNFrx9lchtjdw98Bx+FmAdM3KG25D4Ka+C9fPqP6vAk2Rws2+4pNy6F8YMT2y/GNB8cVn0f+0dCwnny/FyLpfcKnoYhwhFw8WDpTnXdHr1DQeLlEvC8Ow4Cmu3akVdWGko0FxI1HgZx9f/CUB/BXDFNiPN/ji+Ch7ZVCaC9K4JEkUsvRRJJ5BsgDDdJtBGmbqGsABv97y0NMMrGd5/Y243q7yek=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(36840700001)(46966006)(2906002)(31696002)(426003)(356005)(110136005)(186003)(31686004)(6666004)(7636003)(54906003)(36860700001)(86362001)(47076005)(82310400003)(4326008)(336012)(2616005)(36756003)(53546011)(70586007)(70206006)(26005)(8676002)(5660300002)(16526019)(478600001)(316002)(8936002)(83380400001)(82740400003)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 19:56:07.6665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb40b03-f42a-482a-a4e8-08d9794c063d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2488
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/13/2021 12:46 PM, Christoph Hellwig wrote:
> Pass the group flags to ->attach_group and remove the messy check for
> the bus type.
> 

I like the way vfio_group_type is used in this patch, that removes messy 
way to call symbol_get(mdev_bus_type).

Any thoughts on how VFIO_IOMMU, i.e. IOMMU backed mdev, can be implemented?

For IOMMU backed mdev, mdev->dev->iommu_group should be same as 
mdev->type->parent->dev->iommu_group or in other words, parent device 
would be DMA alias for the mdev device with the restriction - single 
mdev device can be created for the physical device. Is it possible to 
link iommu_group of these two devices some way?

Thanks,
Kirti

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/vfio/vfio.c                 | 32 +++++------------------------
>   drivers/vfio/vfio.h                 | 27 +++++++++++++++++++++++-
>   drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
>   drivers/vfio/vfio_iommu_type1.c     | 19 ++---------------
>   4 files changed, 34 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 6589e296ef348c..08b27b64f0f935 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -68,30 +68,6 @@ struct vfio_unbound_dev {
>   	struct list_head		unbound_next;
>   };
>   
> -enum vfio_group_type {
> -	/*
> -	 * Physical device with IOMMU backing.
> -	 */
> -	VFIO_IOMMU,
> -
> -	/*
> -	 * Virtual device without IOMMU backing. The VFIO core fakes up an
> -	 * iommu_group as the iommu_group sysfs interface is part of the
> -	 * userspace ABI.  The user of these devices must not be able to
> -	 * directly trigger unmediated DMA.
> -	 */
> -	VFIO_EMULATED_IOMMU,
> -
> -	/*
> -	 * Physical device without IOMMU backing. The VFIO core fakes up an
> -	 * iommu_group as the iommu_group sysfs interface is part of the
> -	 * userspace ABI.  Users can trigger unmediated DMA by the device,
> -	 * usage is highly dangerous, requires an explicit opt-in and will
> -	 * taint the kernel.
> -	 */
> -	VFIO_NO_IOMMU,
> -};
> -
>   struct vfio_group {
>   	struct kref			kref;
>   	int				minor;
> @@ -219,7 +195,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
>   }
>   
>   static int vfio_noiommu_attach_group(void *iommu_data,
> -				     struct iommu_group *iommu_group)
> +		struct iommu_group *iommu_group, enum vfio_group_type type)
>   {
>   	return 0;
>   }
> @@ -1129,7 +1105,8 @@ static int __vfio_container_attach_groups(struct vfio_container *container,
>   	int ret = -ENODEV;
>   
>   	list_for_each_entry(group, &container->group_list, container_next) {
> -		ret = driver->ops->attach_group(data, group->iommu_group);
> +		ret = driver->ops->attach_group(data, group->iommu_group,
> +						group->type);
>   		if (ret)
>   			goto unwind;
>   	}
> @@ -1387,7 +1364,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>   	driver = container->iommu_driver;
>   	if (driver) {
>   		ret = driver->ops->attach_group(container->iommu_data,
> -						group->iommu_group);
> +						group->iommu_group,
> +						group->type);
>   		if (ret)
>   			goto unlock_out;
>   	}
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index a78de649eb2f16..a6713022115155 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -4,6 +4,30 @@
>    *     Author: Alex Williamson <alex.williamson@redhat.com>
>    */
>   
> +enum vfio_group_type {
> +	/*
> +	 * Physical device with IOMMU backing.
> +	 */
> +	VFIO_IOMMU,
> +
> +	/*
> +	 * Virtual device without IOMMU backing. The VFIO core fakes up an
> +	 * iommu_group as the iommu_group sysfs interface is part of the
> +	 * userspace ABI.  The user of these devices must not be able to
> +	 * directly trigger unmediated DMA.
> +	 */
> +	VFIO_EMULATED_IOMMU,
> +
> +	/*
> +	 * Physical device without IOMMU backing. The VFIO core fakes up an
> +	 * iommu_group as the iommu_group sysfs interface is part of the
> +	 * userspace ABI.  Users can trigger unmediated DMA by the device,
> +	 * usage is highly dangerous, requires an explicit opt-in and will
> +	 * taint the kernel.
> +	 */
> +	VFIO_NO_IOMMU,
> +};
> +
>   /* events for the backend driver notify callback */
>   enum vfio_iommu_notify_type {
>   	VFIO_IOMMU_CONTAINER_CLOSE = 0,
> @@ -20,7 +44,8 @@ struct vfio_iommu_driver_ops {
>   	long		(*ioctl)(void *iommu_data, unsigned int cmd,
>   				 unsigned long arg);
>   	int		(*attach_group)(void *iommu_data,
> -					struct iommu_group *group);
> +					struct iommu_group *group,
> +					enum vfio_group_type);
>   	void		(*detach_group)(void *iommu_data,
>   					struct iommu_group *group);
>   	int		(*pin_pages)(void *iommu_data,
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> index 3efd09faeca4a8..936a26b13c0b01 100644
> --- a/drivers/vfio/vfio_iommu_spapr_tce.c
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -1239,7 +1239,7 @@ static long tce_iommu_take_ownership_ddw(struct tce_container *container,
>   }
>   
>   static int tce_iommu_attach_group(void *iommu_data,
> -		struct iommu_group *iommu_group)
> +		struct iommu_group *iommu_group, enum vfio_group_type type)
>   {
>   	int ret = 0;
>   	struct tce_container *container = iommu_data;
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 42a6be1fb7265e..a48e9f597cb213 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -36,7 +36,6 @@
>   #include <linux/uaccess.h>
>   #include <linux/vfio.h>
>   #include <linux/workqueue.h>
> -#include <linux/mdev.h>
>   #include <linux/notifier.h>
>   #include <linux/dma-iommu.h>
>   #include <linux/irqdomain.h>
> @@ -1934,20 +1933,6 @@ static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
>   	return ret;
>   }
>   
> -static bool vfio_bus_is_mdev(struct bus_type *bus)
> -{
> -	struct bus_type *mdev_bus;
> -	bool ret = false;
> -
> -	mdev_bus = symbol_get(mdev_bus_type);
> -	if (mdev_bus) {
> -		ret = (bus == mdev_bus);
> -		symbol_put(mdev_bus_type);
> -	}
> -
> -	return ret;
> -}
> -
>   /*
>    * This is a helper function to insert an address range to iova list.
>    * The list is initially created with a single entry corresponding to
> @@ -2172,7 +2157,7 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>   }
>   
>   static int vfio_iommu_type1_attach_group(void *iommu_data,
> -					 struct iommu_group *iommu_group)
> +		struct iommu_group *iommu_group, enum vfio_group_type type)
>   {
>   	struct vfio_iommu *iommu = iommu_data;
>   	struct vfio_iommu_group *group;
> @@ -2207,7 +2192,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	if (ret)
>   		goto out_free;
>   
> -	if (vfio_bus_is_mdev(bus)) {
> +	if (type == VFIO_EMULATED_IOMMU) {
>   		if (!iommu->external_domain) {
>   			INIT_LIST_HEAD(&domain->group_list);
>   			iommu->external_domain = domain;
> 
