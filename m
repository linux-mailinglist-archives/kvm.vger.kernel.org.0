Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F4D73BC3A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjFWP7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 11:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjFWP7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 11:59:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193F82113;
        Fri, 23 Jun 2023 08:58:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDgm8MMuAQ8PVpqPaWrQKvRSzb0PT+gXcpsPmbGjoJ50Ed9F7wnLQxpP0BQMuG32H61HsaFBvNR40VwUYzqjIf1zYo/gHy2nxAqg3S1CK2sq8TffsBZTF4DIk02za0I817J6O7LmaSxwc+zOPV979l5fx4U7xQSL4za0SehzpAlcTIoPhwddjbl6W/5sS1ICfhlw7S+XBYg2c2KS8bJcIiYWJVS6TLI84NTGKmND56ofBEy5gpD1QhdK7CIJCkXG5J3Ghy9Q6eet7uozeXq9C8Y9Z+3g7m5UHf7zetRAW2udHVfPacqZHZ+aO/zJKieUWEPY7XmYqkUpSmAuI1g8/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fk2lWQC/httf2gLcenBMZrJ4wN76oMvRBg+hR24RCrs=;
 b=K3gITOm+TrxCvcYaNHPZohz8/YSNrQ8vY04Cdz+ajLGq+oNHe9RDXThN/qQVL9vTWU8X2LblLIzTnLhSSA7Se2l8OAnPCtWEvG54Zo0QZJ9mvXMV2QsvWyCE44uatlpK4E4gwmuBwLfs9zMAYlQ/u84wo2shETz3M210Gi56yFAvnxapxZL7YoXSE1ax47vYl0pkdBkF66UkwVt94sb5dra9OavMcUSnwbmSquBqIClVu/4k6odQ1xK6eQu05RjR4cHPBc9U+lUaIvb7LT6n/VHTluVW78LFYA5CGADYtXwY0+cEv/v3TNrbUZMlqluGlvnLR/+jiwA4mGHhkDJo1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fk2lWQC/httf2gLcenBMZrJ4wN76oMvRBg+hR24RCrs=;
 b=MbUQGG8CEmS/sFvUCDX26T1LmeRRg70e4whRmXAwhnoDUK78Qk6hzKNJOtyTC/eXl1sW52+EnX84nncld0imJ2u8tjbeQHhQdA39avFRx+64Ia/4jIAbjZvGEqwt+T0VPSzbsWN0J5XBt2XVFes0ezpCUF3PCMq/mIdjcft7EfdADgJRcdwygLpVrOfJizK1OyWPPOSLqRQNfWIewTgfhZoK70zqzltxsBXJIiBjDnGF4Kj0KLYRa58bdN6ZXjUKrsoBhIShZSpdrt/GgnHncv1naJL7Aq8ETB6amKxALkfX64tHaC7ToFjbhH+wImJwXBeHfw2cGVdZ4CrxJdv5GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4094.namprd12.prod.outlook.com (2603:10b6:208:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 15:58:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 15:58:56 +0000
Date:   Fri, 23 Jun 2023 12:58:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 17/24] vfio: Add cdev for vfio_device
Message-ID: <ZJXBPg2A30hUpigD@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-18-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-18-yi.l.liu@intel.com>
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4094:EE_
X-MS-Office365-Filtering-Correlation-Id: 63ada877-508a-450f-d6d1-08db7402c036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ns2laS9oVFjHJTfbAKjiLyd4qMEBNLxZvTZk+6dcdqtp9ZAS6km6+ucGFm6V0TbizWdYzBst7tfqmusnnNvjbTb73qujtOA1fIAQ8y6YMSjA1SVBcWgCnlto0N7LRJSxJKace6HNHEGBnrwAWWROo1umV5bavurzQboUOwwH436Rt8VyhT04w/9LVssJWuh8/Q8FvxgKtec9FBrxjuqab5Lsn+KWsYoWvZ4+1fC5MXrSrJPNG1pb38Rxf/oJwVZxSoUR6h+W5zn2gIlSssk6Fy5WqM3KwwksxzSuZBycop0o7LwdjGMIjKhy8j9gSVPgmxHZnXFNU2cs6Rb4MlxTg+0nUUAKdhnPRpoKBuaYxvegc44O5Rua9C8zczxtjLLxgmTWgD+KP7mqPht0SZ1j439iO/l4kjJ6oz0fX16YI1sBjrfKZApu3KdUTmrX0ha+gvqHnsNrgVD5LdMCR5SXQdyoI/y+74shT4Oj/s4jFudCPfO39ZwTTweNk9jWFunQ548OnPklvCVhloEtahrRN6eEE1ra9RlQnZQXuvyDYTLsE5XnSk/5YJbTXOfl8bDh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199021)(8676002)(6916009)(8936002)(41300700001)(7416002)(2906002)(66476007)(478600001)(66946007)(66556008)(5660300002)(4326008)(316002)(2616005)(83380400001)(38100700002)(36756003)(6506007)(6512007)(6486002)(186003)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sQhIy7Z0hzvtzH3F0TYPjqRhWaDpyh2sExSMqJ9s6gAvGXf7Ffzo/Xw2eZ7K?=
 =?us-ascii?Q?wMwRJ8WFF6v4P5hXqCCp+CgfQttaADBggEISVbOgOLFilujBuMpULkHNCgKz?=
 =?us-ascii?Q?/y5wfK/RBgH8fh9MVWFhKGoHsYFXlMF7X+/mjz1VSAajK/p1kTPIGNBDRi1C?=
 =?us-ascii?Q?yNAk4FrUFBL8EcuvuH/a3ZVZsLp1OXUUBytvv8gS48eUFeefbzg4A60uJ2+e?=
 =?us-ascii?Q?/wSj0FPH+ica5vURGOe7xy3On028yQUW4yVlukhDmhJfk/0lyoZzf/zpwJIk?=
 =?us-ascii?Q?o1RTTDWY2o/WDoF/jTQC9uf9xeftAb9U8cVAWNEHlHKHR6gJnE7FzFl1iGGB?=
 =?us-ascii?Q?dLjf8FiCtqr73sX/R7LU2EcccefhUnf9ao6+dCniJpsYG6HsYVr8m/OZ4MRJ?=
 =?us-ascii?Q?Roj68jznnbDykLGCer3jjkE+boXR+4kmS0r3QKC6QcWtLcpxkus0iq8shcX+?=
 =?us-ascii?Q?1vdT7qj4YOi+KqI2yqJOjeWhCuZQcn722uuyxKVOdavkt/6TjeZyPArfc+t2?=
 =?us-ascii?Q?f1JzGrjEO6MjRz+YCewCzWuH5OzMs3gto2Pu/Tyc2sJehZy4ITFxlk3EpBS5?=
 =?us-ascii?Q?V91yB2akz0LZTd8zd0DUUzZ0FAc3eAZGOUtLmFha9YfFh4IGZE18K6/pn2Pk?=
 =?us-ascii?Q?X08F0wrEOQxoyj+zslVHaGmEbZRsTvinTFIw46H9Ahv1RAU19eWlWQZuiE7c?=
 =?us-ascii?Q?uwzsV2egqUkEUHKQBzSuH/5ZPP/cfiSw4te67I+hlFNi9ZgWQdS/Lmn//KuF?=
 =?us-ascii?Q?xvAnt49BDjAnTueq03hNfNCmJEXmh9RaU6M4kdVProJGHN7UHX6M1MM0+aOW?=
 =?us-ascii?Q?JLYrNCA98MlWKFKd5TLVxt2gjjumaTW9yrirjQwrwJ7skjXGYTXpXM9dN4Y8?=
 =?us-ascii?Q?xa1Kc49E0uGpsaFY/pWLkNLRCkdFP9htohKN5snYKiZWdOrxM2yncygzVOsq?=
 =?us-ascii?Q?yjvGgPB9nNE38AG2hvLYINlcCjJXup5rB09ubIDRch4Ksc9uk/Oo3jagMIXa?=
 =?us-ascii?Q?zJUmeefHGo8j8Hxq6Vja1UZByHc0P29X1aXRU7YVQPqgOrJ2aIjnI3KLEdnH?=
 =?us-ascii?Q?RZkbiU2L20iBPIU4JiULlX3k5XhvD5Z9TA+9LKCA4rE/a3EMZDPrpTtI18Ys?=
 =?us-ascii?Q?hz2tG07Q+aXZDuEvfNWKAzYKWbBLrUYHt/E/Wck9WZQjVkwsxiuRG4Cwwjyk?=
 =?us-ascii?Q?0vfV2ClPHqbFVco2PKEq3v0p6N+Og8jkeWttQQYEOw2jI03yVvefsAyIGkrU?=
 =?us-ascii?Q?wCz6GgHGr/zKm8Bv2cTSk27W5WleA27pxr4depvyNIgC7peDIZDgKpJLS6rf?=
 =?us-ascii?Q?GgwIdM+NvFTPCUT3LYT7yTM9uVkrYjYmz5jpx1zkKd5ah/iEiBgwRGMWfqEt?=
 =?us-ascii?Q?BNbyitScZqYHFZB9vv1JW0gAOSWksQtJybXQGwyk+z3arsY8Dtlcw+MsQMpv?=
 =?us-ascii?Q?4JZK2XMdDb4XZXcePufZ/c7UUy4CHuopdfNS16ctH4sP1sK2hJvcxddzTnJH?=
 =?us-ascii?Q?gitHYFWPNEbwaA/tRqh7DQRBBa9BprTjcv7WjBAbtufqmU/ZUYC31ApuNCVu?=
 =?us-ascii?Q?udCjr95gTzpsDipbk4/4h4JNDO58WGkIQUt2Pl5Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ada877-508a-450f-d6d1-08db7402c036
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 15:58:56.7851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aSL96CYVTWF2FwDo5HJaslm9odu2B4Z+KkagxWy3+YHIdmgygvLwpvmdWPDXqG5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4094
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:16:46AM -0700, Yi Liu wrote:
> This allows user to directly open a vfio device w/o using the legacy
> container/group interface, as a prerequisite for supporting new iommu
> features like nested translation.
> 
> The device fd opened in this manner doesn't have the capability to access
> the device as the fops open() doesn't open the device until the successful
> BIND_IOMMUFD which be added in next patch.
> 
> With this patch, devices registered to vfio core have both group and device
> interface created.
> 
> - group interface : /dev/vfio/$groupID
> - device interface: /dev/vfio/devices/vfioX - normal device
> 		    ("X" is the minor number and is unique across devices)
> 
> Given a vfio device the user can identify the matching vfioX by checking
> the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
> /sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
> major:minor of the matching vfioX.
> 
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
> 
> The vfio_device cdev logic in this patch:
> *) __vfio_register_dev() path ends up doing cdev_device_add() for each
>    vfio_device if VFIO_DEVICE_CDEV configured.
> *) vfio_unregister_group_dev() path does cdev_device_del();
> 
> device interface does not support noiommu devices, noiommu users should
> use the legacy group interface.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/Kconfig       | 12 ++++++++
>  drivers/vfio/Makefile      |  1 +
>  drivers/vfio/device_cdev.c | 62 ++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        | 54 +++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_main.c   | 23 +++++++++++---
>  include/linux/vfio.h       |  4 +++
>  6 files changed, 151 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/vfio/device_cdev.c

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> +/*
> + * device access via the fd opened by this function is blocked until
> + * .open_device() is called successfully during BIND_IOMMUFD.
> + */
> +int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_device *device = container_of(inode->i_cdev,
> +						  struct vfio_device, cdev);
> +	struct vfio_device_file *df;
> +	int ret;
> +

Add the comment

 /* Paired with the put in vfio_device_fops_release() */
> +	if (!vfio_device_try_get_registration(device))
> +		return -ENODEV;


> @@ -338,6 +338,12 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  	 */
>  	vfio_device_group_unregister(device);
>  
> +	/*
> +	 * Balances vfio_device_add() in register path, also prevents
> +	 * new device opened by userspace in the cdev path.
> +	 */
> +	vfio_device_del(device);
> +
>  	vfio_device_put_registration(device);
>  	rc = try_wait_for_completion(&device->comp);
>  	while (rc <= 0) {
> @@ -361,9 +367,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  		}
>  	}
>  
> -	/* Balances device_add in register path */
> -	device_del(&device->device);
> -

This looks OK from what I can tell, but it might deserve its own patch
like was done for other movement.

Jason
