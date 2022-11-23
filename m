Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7663662E
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbiKWQva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbiKWQv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:51:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC251324
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:51:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFQw/QbqzjsGHuS+NYcshhvEwDYY1altGElRX2aH4a5Efu4bsFaVUYrdZXu+zKEf/beMA2judLHIuV2FDgN9utl6QvLHJJhs0zDUxvb0TUlbBOdvbX6gmvphA53UXSZSVXdDrA1ap1hx/stN1N0D7z+5HJVDZl+aEW/7MoQXs+jcx0DghK1Uo/YdAB8kV/meELR8Q8bHL/zRPUJENysd3SBLodZB9Y3hUppEwB0Zrw27Sjp4VwTnRoyZXcIvVgRBcdnfYV5Es6zuwnaHyNR9oE6u9KvH8dM+CwSnBLLHWrcbhqo90mX/1PgucRLotAZXV4T1seaAMgE2ozcHXcShRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W8d5i+kxijJjIsYKqfKG1nE7jpiKpNYdKj3rh/SuH2k=;
 b=PXe36am4I1s3zhiFXEKOVE26NlG5vgIqF92aIREfim0rfj1bBuDyqCjZvgrMfKfM/2JaD3r++BEtH2W/I8gJlTiGmpUmndHpH/ej4OAB25Scz51FTYiaRijKcTAWjmgmvVa3H0F56lnxpEQkH1Wn4EGKy2gNB+tN5O+WQSIWjLT28yOZ36mdaCuTlx2oUT34Q5PEVSQaywzA2NVDKdBWFQ4SQ2SRATvKgMbpusL7MIPFCtpyWEipItGAbLxsWYtawx8x97arnQpDaVGkXF4Qcu9AgtcmMVRN+xg4xaf0ngFzPusJyYVTPsdJIOVahbFCsML0vGwCexLNjZo5hPvTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8d5i+kxijJjIsYKqfKG1nE7jpiKpNYdKj3rh/SuH2k=;
 b=pDRHXby9bYPMt1igrTKm3bdMf3+bfB27DR0C+HTsdtIIdNz3eFT6JrTCS09XqPaMV34r4DYEWz/22SZQCsAZQAZnsuyU/xd89Kh4rF/BELOXcL/EHLL5TMOLEnofv2iI6s/lxfSrmRkhw0N/LpLWgcJHd84dGmcQI16/py8ezmDQZRrVR0qBer3I/B26Uebvw+n3/erTwah0/MmkTfLYD+eRWribfXYAGqqkWWwpg5huV2oFXOWgywBRUwgExX/oC5vBmUJdG+e0gZkWe55BiymydvtJ4vZq0DzNagwaAEFxMZWSffClyq7n8lXTVfizocGnkl8BcML4NyUDZms07w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 16:51:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 16:51:26 +0000
Date:   Wed, 23 Nov 2022 12:51:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC 09/10] vfio: Refactor dma APIs for emulated devices
Message-ID: <Y35PjWQbzRy+oMi7@nvidia.com>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
 <20221123150113.670399-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123150113.670399-10-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR17CA0036.namprd17.prod.outlook.com
 (2603:10b6:208:15e::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bb966d9-03f1-44ea-1daf-08dacd72f5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixB8q6sZQhCesf/l4B+/8sY0D+iNN0Je1oNmG7MQDiJonuRhggTo4Dbix+enuWVB1AGjAirPmjbzgHt0z8gtHwF6OVUeCd4WHqk2uVP1PgM+H0LXdg5EsGulfRZ4WEKmoPRXqKeDn2UU4VPjwcxHXW5r+LJimQxaaU6OEWHkwfI+QNuHpCh6gBre4Ss1AFQ9e0sL8nz/tTntaJLUOpbkVe5FCoLzdNLKLC609z+1FTBOYUuFCwvvx7hTRriINmVl8LlTp43C/S9z8hO40tjrC6e6J5hrUqAMD058vEzyTVeirRWrg3qeqP4WXWAlpgG5RyOthw1ow9pvhKrXiWQ+GZJx95nxqYi3J8pqgiOu0DL0PwR0QbzqbEuqRr4cFe7+ZmpWwiSYnGGz/IWIsZ7CVTHB8hdnFyJ/zUxRQwpkyU1XejdHWiomjEycOyLhn0FuzMEEYhf2wCkWILJHYyfh8VW3t3IZG53uSc7dvCdZvl/hgG6nQPwZxExXzuKiuKekqBWjp+vC23naV4swUdyg9QxRBFens4ZWGl1UqgZhLLuOz2KFthBgB0B6/qY/UExg8zDHvaAKNJt4HA0oT9FybqiJ2FD32c32EGAfDnSn6XdKu2EU5cDDeWYtRie33gG3jg8mynxNLWHFo4M4IvQ6RWH3yRKOC2DqYWebdo70nKGuKAQj796TLkSF6IqHfh5J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6506007)(6512007)(6486002)(26005)(83380400001)(6916009)(86362001)(38100700002)(8936002)(36756003)(316002)(2616005)(186003)(5660300002)(41300700001)(2906002)(66946007)(4326008)(66476007)(66556008)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tUPWt3/mypF0DpoZzWuk4pwGXsCn6VPAo1CDkfS1YkVZ9FROkexImJRwqNfX?=
 =?us-ascii?Q?8kQZFQmkXDFMK+yvW9kgJ/r6lqe93jXENQMHlnjpuR0/tFFUdIT7avLRoUB+?=
 =?us-ascii?Q?ObGrOW4QgqE/tKTDwFUE9oHCK6Zre9cD/ZSe63N7bQJg0Cp7ZRCNagAHP5UM?=
 =?us-ascii?Q?aiTaafGaq1VurMo0Eb9mLUfdCZWi5qGoUgA7xz5MdhFNQSmChzjNPVCeH43K?=
 =?us-ascii?Q?1EI8OQykWBKCUSkkt9FJ/JqmXgTtoSLRYPNSpbrFj9xoGBl9UU2y4sT3lnl/?=
 =?us-ascii?Q?hus56NLCSG4Mcu9tUF6QmthD7sv3sMys8eAmcaykuqK86PQawZgdB/Pb6yOX?=
 =?us-ascii?Q?GtWJyL3DQhhPOdmwg0Irxmt7deXhapZOuOHR1UxXdAQHLgH8msAXJaiTWy2h?=
 =?us-ascii?Q?AuQ/46Hk3eELMAtxsL8NWym3W4X98t7IbyYB3FIdADxHYWsVPGdcBiU+a20d?=
 =?us-ascii?Q?tayg0+CTZLqgpGy4LE2nLWNoxbU6P7TPhgBrnv/gknmOA6i5/DjKpbsJi9Wq?=
 =?us-ascii?Q?xS0kOLC21ecMYfYHIaK9BkLqUyP6Gqo5EWlrbT0Rv6V0K/hkRWOEeZPdUCKc?=
 =?us-ascii?Q?ZEaYzHsAO1rtpOdHO5nVs6/SJl0tnjFQ6tSYvgYOx8pIymD+X6mzQRFz1jUS?=
 =?us-ascii?Q?z0cU7GeQhX1yNyI6ULQrFIZLB33HW8XfbvCbW/j/KdeyLeejMqmk1qKuCwVf?=
 =?us-ascii?Q?5TmwEgOBRnQJCSw0zD5P3y3LgrpwceRqlA7YSI/gfYvYQAztT3Fosqn9SSM/?=
 =?us-ascii?Q?vnRj7lud6Gok9+XBzSM94g1hK1ce6q3bTW58r8aId0H7W3kwsxQtK352FqJ0?=
 =?us-ascii?Q?Dac5S0UpaKgRq6ygyLlajf5AzkoCUA0Jb0GuwEjTkhTP5mBbDWsSY0RP3V6U?=
 =?us-ascii?Q?BeTutziol03v9NMxobEyHD7Qff+I6mtP5O1f1DoqGOyz22sBNUgqL1+mno+U?=
 =?us-ascii?Q?WcV9GP9wl/FJjztcWrpABcesuhgDwilc0TSvJ1aZElnmj3jkeU9lphnWW2eM?=
 =?us-ascii?Q?9SOU+FeVLDtgQgWwdrSbCRvWRfuG/OhOZjh5hFVRcZk9CfNS0MLguZFRHK4t?=
 =?us-ascii?Q?o4+Aj/X9sQh1+DXv2uLXEaXcvaE7d4GNoA/RL2aUxjrkNCrS9OLtw4VJuEhA?=
 =?us-ascii?Q?IvcUeq2xTR5WtcFPJ+be4ZuBnUJKjZcxJnJyahDud3kwmKhf3LPbQZEIBuXQ?=
 =?us-ascii?Q?tNQFRJgqFpG0IcptPV+m/25cSUmLXMPpysXVeEJFQRROzA4QdFqXUUVhE9x+?=
 =?us-ascii?Q?9SBU3/A60br3+NOejbXxZaJyvqV3X1DB8YMKEyTBWGN69iQ+0LoxlVVByGUZ?=
 =?us-ascii?Q?j4N0BtJrqtynhTyes4T2QeBaAw0AZFlmhJEg+zAVLIE9q/8ffco5fGO8SvLb?=
 =?us-ascii?Q?HMA0GtWhCzF9MQkiqUklxztm/PDr9/fcM8GMTru1kBQ/mZUjE6A6E5rBs7sM?=
 =?us-ascii?Q?rGrxEVKtkZGt+0xU4VXThznvDKzpVMkEtiDzdqry8XkBiohj8HDc9+IrPNlX?=
 =?us-ascii?Q?8EgyPN4POdlLHlRxqoe7RHyUJhjGWsMH3z/mEbqoK3XVMPHwlz3lm2Z4QaFR?=
 =?us-ascii?Q?/QBmwTWLx8ZJjRYnV78=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb966d9-03f1-44ea-1daf-08dacd72f5c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 16:51:26.0454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tifa6hS+2o9lh2XNkaV0l7z9dVvyNqGuqugpk/bK5kePeSpwoS1EXSKBa2qfydt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 07:01:12AM -0800, Yi Liu wrote:
> To use group helpers instead of opening group related code in the
> API. This prepares moving group specific code out of vfio_main.c.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/vfio/container.c | 20 +++++++++++++-------
>  drivers/vfio/vfio.h      | 32 ++++++++++++++++----------------
>  drivers/vfio/vfio_main.c | 26 +++++++++++++++-----------
>  3 files changed, 44 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
> index 6b362d97d682..e0d11ab7229a 100644
> --- a/drivers/vfio/container.c
> +++ b/drivers/vfio/container.c
> @@ -540,11 +540,13 @@ void vfio_group_unuse_container(struct vfio_group *group)
>  	fput(group->opened_file);
>  }
>  
> -int vfio_container_pin_pages(struct vfio_container *container,
> -			     struct iommu_group *iommu_group, dma_addr_t iova,
> -			     int npage, int prot, struct page **pages)
> +int vfio_group_container_pin_pages(struct vfio_group *group,
> +				   dma_addr_t iova, int npage,
> +				   int prot, struct page **pages)
>  {
> +	struct vfio_container *container = group->container;
>  	struct vfio_iommu_driver *driver = container->iommu_driver;
> +	struct iommu_group *iommu_group = group->iommu_group;
>  
>  	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
>  		return -E2BIG;
> @@ -555,9 +557,11 @@ int vfio_container_pin_pages(struct vfio_container *container,
>  				      npage, prot, pages);
>  }
>  
> -void vfio_container_unpin_pages(struct vfio_container *container,
> -				dma_addr_t iova, int npage)
> +void vfio_group_container_unpin_pages(struct vfio_group *group,
> +				      dma_addr_t iova, int npage)
>  {
> +	struct vfio_container *container = group->container;
> +
>  	if (WARN_ON(npage <= 0 || npage > VFIO_PIN_PAGES_MAX_ENTRIES))
>  		return;
>  
> @@ -565,9 +569,11 @@ void vfio_container_unpin_pages(struct vfio_container *container,
>  						  npage);
>  }
>  
> -int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
> -			  void *data, size_t len, bool write)
> +int vfio_group_container_dma_rw(struct vfio_group *group,
> +				dma_addr_t iova, void *data,
> +				size_t len, bool write)
>  {
> +	struct vfio_container *container = group->container;
>  	struct vfio_iommu_driver *driver = container->iommu_driver;
>  
>  	if (unlikely(!driver || !driver->ops->dma_rw))
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 3378714a7462..d6b6bc20406b 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -122,13 +122,14 @@ int vfio_container_attach_group(struct vfio_container *container,
>  void vfio_group_detach_container(struct vfio_group *group);
>  void vfio_device_container_register(struct vfio_device *device);
>  void vfio_device_container_unregister(struct vfio_device *device);
> -int vfio_container_pin_pages(struct vfio_container *container,
> -			     struct iommu_group *iommu_group, dma_addr_t iova,
> -			     int npage, int prot, struct page **pages);
> -void vfio_container_unpin_pages(struct vfio_container *container,
> -				dma_addr_t iova, int npage);
> -int vfio_container_dma_rw(struct vfio_container *container, dma_addr_t iova,
> -			  void *data, size_t len, bool write);
> +int vfio_group_container_pin_pages(struct vfio_group *group,
> +				   dma_addr_t iova, int npage,
> +				   int prot, struct page **pages);
> +void vfio_group_container_unpin_pages(struct vfio_group *group,
> +				      dma_addr_t iova, int npage);
> +int vfio_group_container_dma_rw(struct vfio_group *group,
> +				dma_addr_t iova, void *data,
> +				size_t len, bool write);
>  
>  int __init vfio_container_init(void);
>  void vfio_container_cleanup(void);
> @@ -166,22 +167,21 @@ static inline void vfio_device_container_unregister(struct vfio_device *device)
>  {
>  }
>  
> -static inline int vfio_container_pin_pages(struct vfio_container *container,
> -					   struct iommu_group *iommu_group,
> -					   dma_addr_t iova, int npage, int prot,
> -					   struct page **pages)
> +static inline int vfio_group_container_pin_pages(struct vfio_group *group,
> +						 dma_addr_t iova, int npage,
> +						 int prot, struct page **pages)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline void vfio_container_unpin_pages(struct vfio_container *container,
> -					      dma_addr_t iova, int npage)
> +static inline void vfio_group_container_unpin_pages(struct vfio_group *group,
> +						    dma_addr_t iova, int npage)
>  {
>  }
>  
> -static inline int vfio_container_dma_rw(struct vfio_container *container,
> -					dma_addr_t iova, void *data, size_t len,
> -					bool write)
> +static inline int vfio_group_container_dma_rw(struct vfio_group *group,
> +					      dma_addr_t iova, void *data,
> +					      size_t len, bool write)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index cde258f4ea17..b6d3cb35a523 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1925,6 +1925,11 @@ int vfio_set_irqs_validate_and_prepare(struct vfio_irq_set *hdr, int num_irqs,
>  }
>  EXPORT_SYMBOL(vfio_set_irqs_validate_and_prepare);
>  
> +static bool vfio_group_has_container(struct vfio_group *group)
> +{
> +	return group->container;
> +}

This should probably be
 
  vfio_device_has_container(struct vfio_device  *device)

And it just returns false if the group code is compiled out

Jason
