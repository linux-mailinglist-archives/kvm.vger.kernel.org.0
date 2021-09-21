Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F0541384C
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhIURbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:31:14 -0400
Received: from mail-bn8nam08on2050.outbound.protection.outlook.com ([40.107.100.50]:26727
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230351AbhIURbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:31:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2mbow1ybSbv42yRvcfPiSY4QR8avnHoNbvFz9PYcL3sLWeTD9u+LZza5agJjxS76A6ABM+JJDwfEz4ODCjsUDJpL7Mf4J235k4M+JJ1lHBfp/fIUtCTscywpGDHKFYCD2D+J+C9Ypn/nKDgmCEyDgoFDv7MNsvBlqJYYe8JgkuH9gyO34Djx9wODuLUvG9+5tQuTX7awABFGeSRc9HR2GskxDsPtm9FUOnlOc54MZtmke0qmG3b/O0+1oLr5m6tbMKBNxJj8/mTwa8byBykQkLjbIS/lqCAE7jI3BU774V1DJoE/T5DOW46//Fx848LHqRoimB0gNm4+VNeqZvsfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ebk1Vo8/Fhs4WRsQO/NiOYEkR5RuafN9agT1FmWO8HQ=;
 b=bvN8mtqLRNeWgROS17LjAEiU+O+FYrj5QcSY5wVUfOuXuMAFhWPM62YGjHFDY8VODMj45HTh7UUSvXVxWhfxyjV3lMUZEr+6wYfN0yqhV7r0LIr+YK7aDS58wGnDfMdKzdKNSc8LtA+sOYpSf3vEEfL0If2fSI4ibAoXJLhZ0YQdH9h4At5RO0MFLsPYQaMwa+u1SxuIPNPl2+oCIq0dqMKSLAGNQaPOhc0EPJb5gFlSiwNGfBjkB72AtZdn/LfUjX2YWjXRfJ/RaRAjknJs2WMKA+0hBUNEqtM3NgQIsHpQx/YM6TbyitmroPBs4EQMOsAAc7NpMvJ1U2LKjRFylQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebk1Vo8/Fhs4WRsQO/NiOYEkR5RuafN9agT1FmWO8HQ=;
 b=kNllRd2cHFE79E9h/dAR3Dv4CG+8xUdcYNjTcRn4Fe6iY7Car1oh9aLq/9Ty1ZTn6Y6UTxNxv8GxYMJp4iZGnSfa09SBEig39qC3/Bp7UDxaIGoCDxobmUoRug/R369EZzMvWRKEPbBbknMTEcS/xMbar+d0pqTcymOtZopeOrl4lP/E9XfX6DKHVSxYuSOtaJN58fFL8zECUJ54tKTcf9zdpWRUA7+rToPduc2wHDDGZg4VKY27u0ca0H0MhBr1WQE/c6OuMyIKpx8TAZJdi3u4yYyL541GyK8J2388nPrp7aI4QuCeZPVJHYqVpZjj2iZGUL7I/V7bKePdUXZDuQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5380.namprd12.prod.outlook.com (2603:10b6:208:314::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 21 Sep
 2021 17:29:41 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 17:29:40 +0000
Date:   Tue, 21 Sep 2021 14:29:39 -0300
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
Subject: Re: [RFC 08/20] vfio/pci: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20210921172939.GU327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-9-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:208:fc::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0008.namprd02.prod.outlook.com (2603:10b6:208:fc::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 21 Sep 2021 17:29:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSjaN-003Wo1-Fp; Tue, 21 Sep 2021 14:29:39 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c558eab-2d0b-40d6-d345-08d97d2564a4
X-MS-TrafficTypeDiagnostic: BL1PR12MB5380:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5380ECEB0C0478CFB6C8AD0BC2A19@BL1PR12MB5380.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wl5fXXm5Mx17vUh6Kq8AQ2E4LnfINmojQfpoEIrI08NIv5r91O31ejcOd9zk37pcMocraLgKbdulvZP7MsNIVzoldqTBY0komTbQ3giXNsQ2i2SoXItOISh6fuVvI4+1tPzDNX9B7c+6+HOC1kOpfRwVyZZW4G+ZHelnwR6TRznEx22tDweCvBa9xJU/ncYQx5nV9N9cAvJ7wYTqMyRA/gF09kRNP2MhFWsPv6MByM4Iy5hFgzbIOypDNbgGfWm5KxV85EZ1GLjajGlSVeX/gBWCdkf6WDfBQfkQGc6RsimKsiLgLEHniTUddjcPknRp7haWCrXcwX9kYNidizGCtDR+jo7QbV08rWq2M5Km8HgXiU8MyNetOuY+EZX7Ci/jWiP2ivaznNGic130XpbbOB1UeuBx8D0OiArnVSDHcThUySs4e0TcDzyOphuCiMqmkITuoZIp+bq02Ad5wfTadStVUiMiRBnhUTqXfs7Dnk4prU0wDLfx03+1scNm3siR0uHd1YuQaVe1H/Sg8GNlkcPIIQA4C2Jz5Oy3yrrpFToXIelQoqWwQgVLzLp5CY1732yqgHy0rB3TsXKr4rblA6M0+bdEp9NOtw7h31ZRm/aMhw1cyS9aBp/nJu5iKB5lp9SMlGhueY3V/ElMECO6/TB0VDEp86oOMK6BK1sTcxzLXyXkQV8UXCN9jWXs/nwo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(66946007)(33656002)(86362001)(7416002)(2906002)(6916009)(508600001)(186003)(5660300002)(36756003)(8676002)(9746002)(1076003)(426003)(83380400001)(2616005)(9786002)(66476007)(66556008)(316002)(107886003)(26005)(4326008)(8936002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WE8FlwrT6C4b7yOQ/7DtmIw8CRUgAo+Gmuqq0nmnESpqMoVAHzZudArSX3sp?=
 =?us-ascii?Q?d3i1uwAZFHNFP9vndSdh3BoVkJs0qGPB0rnZEAzpTjuXpRvFwJxYEc2zLit2?=
 =?us-ascii?Q?HQ/8w6PfB2MU+SkFeU7ot4fLUusEcf7ZXK5TO0D2FqdgJeMjQ0YtnLG0JYC6?=
 =?us-ascii?Q?pku8vd3jobwRBJl8dBV1tnKXGSH3PnGkwB4uTvvQfh0gHnzeRsFZcHXp+mgE?=
 =?us-ascii?Q?t+PzgyXr0c6crHgnJG9oveS7TCaHo7C8edEuOUPUY56C2ppTboCQjKab3cRZ?=
 =?us-ascii?Q?dUX6qQPrvh+NxcUWxx5aJpeQQTSQrSAv3fELflYpk1/FM99EyLaZXhfDn6V1?=
 =?us-ascii?Q?dH8MrKT32RegeTzK9jDYAaGPL+HB3dIWKXO7nl3/GvAUOJu8/8htxl+Wozog?=
 =?us-ascii?Q?kxTRZxq7MJEpF5f6zfvUvpHGrTPPDrHxs4L7RbGHQ3P7ltdu72C3GY51hsZG?=
 =?us-ascii?Q?UGKwYY0I3wI/DiSMjktVGrzepM5VkLkvJqkCHtxW+tr3HRSJ7cTh+0douRIA?=
 =?us-ascii?Q?h+ONkFvEJqiI71BJzwhsce5ToUUZvL/egQabn/A5ggazuweRhWnJZR932KMv?=
 =?us-ascii?Q?E4M1punwkccl0Y+/bI7iD2n/EKxQSptao8BZTA0cRpt7JV+qXTN7GBe6WbPv?=
 =?us-ascii?Q?5GxzcMPHMPgWScPw/wxdnsLlpTZNQ3yAGfor5KW+YC5QIowyqnYlW++Q8tgV?=
 =?us-ascii?Q?oaNLr8Ixy+sZmP2V5/0ctR6MuKLSW3AzqzNb976QmmFW28o/ixls0kLc6HYs?=
 =?us-ascii?Q?v+Vbmr7V3gYOoIr6wmKmxD/5HiNnAbQu4LbLsUJoByDY3jUVO4+dTK4dEY1E?=
 =?us-ascii?Q?yAudrhhVQbyFh1fjgCtff2XynMSlLNsRKbomhVWY5mJGMtzWanWJjZuDMPLn?=
 =?us-ascii?Q?BBw/K68dMp0u1Q2Lp2MRQm3jAAusCcZGPu+4Ofhuma6azdOo+5m11/qDLpDq?=
 =?us-ascii?Q?n0zC4ENCfArUGy6p6XCfcMtagQoZ0rQn5yxQ//urXk3s761ZzVtn7HDrUsku?=
 =?us-ascii?Q?qeKot9kOveCGraIAeWy2gJRY7PlmV7g0LdgAn8m+y9QJSrPOYPcdL2YxZ4xY?=
 =?us-ascii?Q?b7teHCr8tXQXVaP3wg+F1BzL9oCOu4tctgdQr0r7v1+lgC0KSZa2Hrxd0GAG?=
 =?us-ascii?Q?xRJy2nQsPF3UptBMa50qR5dbcSdUQiLM1+/yVFfURr9fQWsgxZGTTyIDa3PT?=
 =?us-ascii?Q?IH/HYl/+QleK+WBpwUqMmjpHPTMn/1UB/6bYnjK7WiSpH5dFBg71NgJDqZ5m?=
 =?us-ascii?Q?rGMZ+DEhHjtAxriOPSKnk97HE5nrtv3PU14Aggr6t4wpKy6cVFg8lY3RveuZ?=
 =?us-ascii?Q?fDR+FafsfEXUDGxzhsvRzYNv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c558eab-2d0b-40d6-d345-08d97d2564a4
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 17:29:40.8846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /5R27aTak5rqO0W4L6XSspnxtiEDgEWpVXoVazeIGYTTKtmmh4lPIsMwn07+Ks3w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5380
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:36PM +0800, Liu Yi L wrote:
> This patch adds VFIO_DEVICE_BIND_IOMMUFD for userspace to bind the vfio
> device to an iommufd. No VFIO_DEVICE_UNBIND_IOMMUFD interface is provided
> because it's implicitly done when the device fd is closed.
> 
> In concept a vfio device can be bound to multiple iommufds, each hosting
> a subset of I/O address spaces attached by this device. However as a
> starting point (matching current vfio), only one I/O address space is
> supported per vfio device. It implies one device can only be attached
> to one iommufd at this point.
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>  drivers/vfio/pci/Kconfig            |  1 +
>  drivers/vfio/pci/vfio_pci.c         | 72 ++++++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_private.h |  8 ++++
>  include/uapi/linux/vfio.h           | 30 ++++++++++++
>  4 files changed, 110 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 5e2e1b9a9fd3..3abfb098b4dc 100644
> +++ b/drivers/vfio/pci/Kconfig
> @@ -5,6 +5,7 @@ config VFIO_PCI
>  	depends on MMU
>  	select VFIO_VIRQFD
>  	select IRQ_BYPASS_MANAGER
> +	select IOMMUFD
>  	help
>  	  Support for the PCI VFIO bus driver.  This is required to make
>  	  use of PCI drivers using the VFIO framework.
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 145addde983b..20006bb66430 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -552,6 +552,16 @@ static void vfio_pci_release(struct vfio_device *core_vdev)
>  			vdev->req_trigger = NULL;
>  		}
>  		mutex_unlock(&vdev->igate);
> +
> +		mutex_lock(&vdev->videv_lock);
> +		if (vdev->videv) {
> +			struct vfio_iommufd_device *videv = vdev->videv;
> +
> +			vdev->videv = NULL;
> +			iommufd_unbind_device(videv->idev);
> +			kfree(videv);
> +		}
> +		mutex_unlock(&vdev->videv_lock);
>  	}
>  
>  	mutex_unlock(&vdev->reflck->lock);
> @@ -780,7 +790,66 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
>  		container_of(core_vdev, struct vfio_pci_device, vdev);
>  	unsigned long minsz;
>  
> -	if (cmd == VFIO_DEVICE_GET_INFO) {
> +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD) {

Choosing to implement this through the ioctl multiplexor is what is
causing so much ugly gyration in the previous patches

This should be a straightforward new function and ops:

struct iommufd_device *vfio_pci_bind_iommufd(struct vfio_device *)
{
		iommu_dev = iommufd_bind_device(bind_data.iommu_fd,
					   &vdev->pdev->dev,
					   bind_data.dev_cookie);
                if (!iommu_dev) return ERR
                vdev->iommu_dev = iommu_dev;
}
static const struct vfio_device_ops vfio_pci_ops = {
   .bind_iommufd = &*vfio_pci_bind_iommufd

If you do the other stuff I said then you'll notice that the
iommufd_bind_device() will provide automatic exclusivity.

The thread that sees ops->bind_device succeed will know it is the only
thread that can see that (by definition, the iommu enable user stuff
has to be exclusive and race free) thus it can go ahead and store the
iommu pointer.

The other half of the problem '&vdev->block_access' is solved by
manipulating the filp->f_ops. Start with a fops that can ONLY call the
above op. When the above op succeeds switch the fops to the normal
full ops. .

The same flow happens when the group fd spawns the device fd, just
parts of iommfd_bind_device are open coded into the vfio code, but the
whole flow and sequence should be the same.

> +		/*
> +		 * Reject the request if the device is already opened and
> +		 * attached to a container.
> +		 */
> +		if (vfio_device_in_container(core_vdev))
> +			return -ENOTTY;

This is wrongly locked

> +
> +		minsz = offsetofend(struct vfio_device_iommu_bind_data, dev_cookie);
> +
> +		if (copy_from_user(&bind_data, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (bind_data.argsz < minsz ||
> +		    bind_data.flags || bind_data.iommu_fd < 0)
> +			return -EINVAL;
> +
> +		mutex_lock(&vdev->videv_lock);
> +		/*
> +		 * Allow only one iommufd per device until multiple
> +		 * address spaces (e.g. vSVA) support is introduced
> +		 * in the future.
> +		 */
> +		if (vdev->videv) {
> +			mutex_unlock(&vdev->videv_lock);
> +			return -EBUSY;
> +		}
> +
> +		idev = iommufd_bind_device(bind_data.iommu_fd,
> +					   &vdev->pdev->dev,
> +					   bind_data.dev_cookie);
> +		if (IS_ERR(idev)) {
> +			mutex_unlock(&vdev->videv_lock);
> +			return PTR_ERR(idev);
> +		}
> +
> +		videv = kzalloc(sizeof(*videv), GFP_KERNEL);
> +		if (!videv) {
> +			iommufd_unbind_device(idev);
> +			mutex_unlock(&vdev->videv_lock);
> +			return -ENOMEM;
> +		}
> +		videv->idev = idev;
> +		videv->iommu_fd = bind_data.iommu_fd;

No need for more memory, a struct vfio_device can be attached to a
single iommu context. If idev then the context and all the other
information is valid.

> +		if (atomic_read(&vdev->block_access))
> +			atomic_set(&vdev->block_access, 0);

I'm sure I'll tell you this is all wrongly locked too if I look
closely.

> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> + *				struct vfio_device_iommu_bind_data)
> + *
> + * Bind a vfio_device to the specified iommufd
> + *
> + * The user should provide a device cookie when calling this ioctl. The
> + * cookie is later used in iommufd for capability query, iotlb invalidation
> + * and I/O fault handling.
> + *
> + * User is not allowed to access the device before the binding operation
> + * is completed.
> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * Input parameters:
> + *	- iommu_fd;
> + *	- dev_cookie;
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_iommu_bind_data {
> +	__u32	argsz;
> +	__u32	flags;
> +	__s32	iommu_fd;
> +	__u64	dev_cookie;

Missing explicit padding

Always use __aligned_u64 in uapi headers, fix all the patches.

Jason
