Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0535BF24C
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiIUAmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIUAml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978184AD52
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWNztyff4+gQk5QfLMahZ1xe74gY04w1jdhvneqvNsObSXaN5JMmZ3i7NJXQlMA/GvdGRrCk7D3Lf5OZ+IpIunBz4viP7EhVBaz5HAlqpJMkpgiwdVbRluHxWbxs43JuE+/sQvsxGSM5bCEiB9hbkfrNUtstX3xsm8oAHEpsRz/Xmdo+sj1soSTSYnkjz3LEAtmupiw3voUL8NwU2K4gE7wjfsc5J5uam8E3xBp3pCzR3XHHCy9NxOv/oQe91d1VBpwD00k4MO8V1++CnrTss2G1gcKpedl4atA4OUnGv6UerSpm2+79AfuLM03J5c3aDTlBKaC0zyy7vBAgcmWgDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Yu/1SPKhwWAEuXQtCEOOT0aPNQ/z+QF8ucV/s2Bo40=;
 b=Y6hqEocEZnoKYLvN8r7ZvKn02ESdlrl95l4Z35V0bKcDrGnlAwyVryRW7+xcnWelMA+ANTwbN9fB+eRycEQ8NXRJMR+8R8UX1bneRWOAHLMKfEFP/BJeKXlJ5YovnzW9HzHyy4bYipy9b6GszX7AzBIEtkX9Xsxs4TFKB8SACMXCQ/sR0jAE2OShv/AeSweZ7QOgFjYRt8sSmfUME0lW2Hz4IHjZWYVDayBBeYbBXUPKQQA58CaPYuzw8NT28Ix4FvIJbuvC6eOu+oe+hFKUROc1u/SDT50WaVxLpcTNW0Kx0H1QkTSR+sX+zdzTGOFyHEbqeNMKuSKO/eh5iYK7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Yu/1SPKhwWAEuXQtCEOOT0aPNQ/z+QF8ucV/s2Bo40=;
 b=lw66Q1UVaEMO3eBTg5+GI0OvHWWIj1o3K5YthU0VrX10JMcd5yuOSuwwpi5ZJVKKtU/SINn7SfdVWniYeMqFJVMWsaJqkTvfqEm+HhpXPu2EuhySum0dfFr+tngz5XEYpln+otRm0SSyF/X6Gy9b9Ax+6Qu6urG1dlkp39ingH32i+nuKT5Vk1Lvca6vUDehT6qLC/VCe7nIVyAqWkI64jcgxYDkyK2nwm0Iau1vVw/lyQC0EoglHWFLvwXA0X+A2LbIQQN3dizdRMVPkkjD+lB44i0ryrFZeas8RC1KJZokgmj4dUjCfRVAvrtRwEbyPNjFnwGQDAYdWe8xCyStWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by MW3PR12MB4426.namprd12.prod.outlook.com (2603:10b6:303:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 00:42:38 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:38 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 7/8] vfio: Split the register_device ops call into functions
Date:   Tue, 20 Sep 2022 21:42:35 -0300
Message-Id: <7-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:91::40) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|MW3PR12MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: d0484b33-8d8e-4533-763e-08da9b6a2e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: El3S8P17xQQVgMnOK+BfxVWNDHblBeJkZsRRCSU6F1nwIWiPycPxh1Xoj1YAvO8uC2BqhWU/sL7nrBqUBT+DpdgGjQuapoWbIPcsamYhgAaJFB9ckbX9M3YDC5DaapM1rh2jgz3I2B0pAJdVpUVeWy8B8VkdsilSeX+jwLpqhqpEKospDvt4t9VM4si2kSiwr9yGPSDuBWjhtKn7YeXhN9h1qKnyEWJCxa6oZD+LvCdj0zG2falD+RyihDqOs4MHP2S6BSL8i2YiY3UZCBIccoZkqSSU69sa1qz1kPLHS75c85fltmQ1tC3GMyv1jDkGafRYXjiudKNvFQDJa10itOCxFyL3pnlPwIfGfIeJRaQ6g8emmHvO94o7cNr0wB+QTINlwddHiUkz6uGPicMC1jPhKBc/sq2pEzM+SNnHfGYmHjnUIixjAJYxyk1zzOQsnBOe25dNDz0omYr2PNh3hZLqRUlgSSwW3z4AxOAW/rf2ZNeEwiy1iR8mWxQYdf6tPqidUgynmnav41dfo6bpmF3IZLd9dQOxrKFPVmad6bexCUGt7Dhf6M45LVhOJwUZf16meWAVDWiAtasKdSwnjvoqjRIlU6DfztdKKJl5cetMAI6cC9rzcNYCX/7/gJ9KkJmBR4xK82uu7Momqp6/NE/raPerjNabJ/EjXVwhMuoZ3UqL7ngKLMUIImi2WC0aR5BGoegbwK9bQb5FkyGocw6a1TxAmEEk1uO/PgCaFZY0U9e0wpD4RS4BNjmj/hN/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199015)(38100700002)(8676002)(6512007)(41300700001)(316002)(83380400001)(110136005)(36756003)(86362001)(478600001)(2906002)(2616005)(26005)(6486002)(6506007)(5660300002)(66556008)(8936002)(66476007)(186003)(4326008)(66946007)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z6ydRt8yfDZrUWDwW0PpUAPoHeNgEERpFY5Rfp/fc0+UT+DL3sDdIIfQK/7e?=
 =?us-ascii?Q?ciar3YA+oUPqIbR04IZaIEqUCV6bszR8mBml3LGG0e4xzDKsRJdFsxDNeeYC?=
 =?us-ascii?Q?sP8+XaXl3FZ0l9ErwNDFVvScSjOrJEfG36YGdEurro+tdwz0/7RaHzE8sa7z?=
 =?us-ascii?Q?SD5tV+ZrdvvIdfKfi7I6ZxFuNEWromUaRk8e3L1RmAJsG96mbx3t+3seYgmd?=
 =?us-ascii?Q?4rpNjyVnd+6vY0XGwOFJdd8kfBLLoOo8gpILErAVu8K+ynq+mLTMwIojs0g3?=
 =?us-ascii?Q?pzRvP4ni7vlQmZY7LU8qHs9+FbeEG96XcvvqSTL3MRDUHTKjxm/wIVnDKvO1?=
 =?us-ascii?Q?yMBf8ENdSJ1sM5jv9EE5bcGIpx3dlhEb98sa/HJkKw2XO+lPpVc7IqVgwI74?=
 =?us-ascii?Q?ttbtzNLYxz5XB6BG0xvpUteLKA302YgqV1/B7erYSf6/Ccxm1QetaTgVxyzy?=
 =?us-ascii?Q?42DS3jedvzFavM0KxgQho/x7udkaS4oVb/lLgwDnAV08pldnB3sr9lekwCH3?=
 =?us-ascii?Q?03ldMtzwR2N6TlxM/LanvFvTts1ocQmZVcnFgRzOeK5oQiW+sCw4lYwPXz/4?=
 =?us-ascii?Q?NiHzFDoL44jx6NVfhO6oduWDt0P9hk7jgr4TxZiOjM8oVBqyR41zC/gzdN+o?=
 =?us-ascii?Q?lbCC0jJoRG8fo8F+GiKJEqRU00vb8guROuPOAp8/WtZbK2kabztFndwUJq0v?=
 =?us-ascii?Q?5E8eJkhF7ezHVGPiS0EhTcHoY2ep1H/DgC69Yr564cPIKlTWFPZQx9dTfGH0?=
 =?us-ascii?Q?3L37B3Lj4nIlk4p3xqr0oTHy7QleDmr2e9EzAdHOqXu7jkoCghi7ABy7W8Cc?=
 =?us-ascii?Q?Mu3Xtiv4rmuPNZbIeu0w6KXjiggPtqOZ2pGNNRBmrotOdZ/YeVHCF3uFxc2z?=
 =?us-ascii?Q?1bTfcBZpi+2WCesDATRaFbRUbfMwETn1lDAzZzEU9EsEsF2C3GIMQ7bGwldi?=
 =?us-ascii?Q?0pDgIlCSzyX2GPP8ZQlpbCBF1ohFjneDjwzobIXWN615jNw16R8cbA05HFxO?=
 =?us-ascii?Q?Mo/GjsnippRurC8BTDF+v3d5uO96BTALh6QboWlpUYe34WnttZBqXa0D4F74?=
 =?us-ascii?Q?cWKYcBzbTF+10gOLHb0Msz15xLD/g7asqhPXNTXNtu60e7yawtPnIOcdfpJi?=
 =?us-ascii?Q?ZY6KjLX/tNyCMxsgJ7fLXIJ37SHRAJ3MP9RdnVPcAtLWUMJio/lUJd2FKOuG?=
 =?us-ascii?Q?5anteHPYCSTjRKBmQo1S7yXuOWXJ0STs60CiBr8ayeWUM5I5dYiZJUrvhh+R?=
 =?us-ascii?Q?zlvZDo3dnGazETjo1QMI9AQ4thZRgaIWEgxY5re0F0LcdOcpyZMP/pYrgeJF?=
 =?us-ascii?Q?ChLsjOh4AQvthrwPdw1ahxY3AWgC+Z8nacoiIyLFzf9YwlAr48dLHlXRpsza?=
 =?us-ascii?Q?8jACNF+lHL+KuvXCArlISJNMav0rDFlMOLagtU9qhuRBkh1WF1PcfQewoV3L?=
 =?us-ascii?Q?QKgzgZptXrHI/1uBAW/T4mevMyOnlkPVmlDgJCBrlnYSpKtY5xkoNSOaM2OK?=
 =?us-ascii?Q?EFVr/uVtQMkWRcPM3o0wQj6A86moqbNdqde8usq4K0D2q1e01SoCJ3TuZSic?=
 =?us-ascii?Q?fl/PMNIY27z2F6u6TBB9CBXuXaosTYUKjqVnoFJn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0484b33-8d8e-4533-763e-08da9b6a2e66
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:37.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPP8lhIUT5nPKsgz2CJdpUdh6PQLUClK44UXrPJxK4uIYRqBu6Y2aoMnNbSLZjWs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4426
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a container item.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 3a412a2562bbee..21167c74a290db 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1116,9 +1116,28 @@ static void vfio_device_unassign_container(struct vfio_device *device)
 	up_write(&device->group->group_rwsem);
 }
 
+static void vfio_device_container_register(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->register_device)
+		iommu_driver->ops->register_device(
+			device->group->container->iommu_data, device);
+}
+
+static void vfio_device_container_unregister(struct vfio_device *device)
+{
+	struct vfio_iommu_driver *iommu_driver =
+		device->group->container->iommu_driver;
+
+	if (iommu_driver && iommu_driver->ops->unregister_device)
+		iommu_driver->ops->unregister_device(
+			device->group->container->iommu_data, device);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
-	struct vfio_iommu_driver *iommu_driver;
 	struct file *filep;
 	int ret;
 
@@ -1149,12 +1168,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 			if (ret)
 				goto err_undo_count;
 		}
-
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->register_device)
-			iommu_driver->ops->register_device(
-				device->group->container->iommu_data, device);
-
+		vfio_device_container_register(device);
 		up_read(&device->group->group_rwsem);
 	}
 	mutex_unlock(&device->dev_set->lock);
@@ -1192,10 +1206,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (device->open_count == 1 && device->ops->close_device) {
 		device->ops->close_device(device);
 
-		iommu_driver = device->group->container->iommu_driver;
-		if (iommu_driver && iommu_driver->ops->unregister_device)
-			iommu_driver->ops->unregister_device(
-				device->group->container->iommu_data, device);
+		vfio_device_container_unregister(device);
 	}
 err_undo_count:
 	up_read(&device->group->group_rwsem);
@@ -1403,7 +1414,6 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
-	struct vfio_iommu_driver *iommu_driver;
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
@@ -1411,10 +1421,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
 
-	iommu_driver = device->group->container->iommu_driver;
-	if (iommu_driver && iommu_driver->ops->unregister_device)
-		iommu_driver->ops->unregister_device(
-			device->group->container->iommu_data, device);
+	vfio_device_container_unregister(device);
 	up_read(&device->group->group_rwsem);
 	device->open_count--;
 	if (device->open_count == 0)
-- 
2.37.3

