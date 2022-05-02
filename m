Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257B85175E0
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348252AbiEBRfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386673AbiEBRfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9126303
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRnyYOu0ZBciM9S7DefSNVHFeWwRlxRCRjhLRw9PPnwDuH35D2b0SPIEa3uwU2W4ZLhgVOT5r77Ff844ef1fDFanvhoarCGS6aVV21D6kq76rud+Mg0Pmytb8x9e+E9qoQGc+Ml+Xk3/m8sVbb7C2MuGrtkYa6FEwEHmH61voMpTTIkgrYH6dM8O70ZRAjKWg0K+Pewy8gRZdAWEAn+jdJgEMPOLvfTenZxDBSTZLRHjUHq/wquytWU5PQ3BUo1YQe8Dyovv4oruXFyajpJmvEVz0MgvmQ22CbxBVL/MdeMtHBaPws9tCzU8GlJR4ePRBGce7cphUN/oEtqDoJfopw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpAa7bGLl2IxIgrwhnI2gmSgYw9pFpZbZratY2IedFc=;
 b=dERe8ZgJ0gcH5/cYkfvYavOTAMnfmuzSDX1abViDzPTejB4l+SEW/vYTA/boxF2FCouDC5i0zeZa2GSKuuWoQToCv44G52ltApTlwIxTHqbJKUwIPYOgZ128CvYuvzyXb4aw4eDCct3p90QhQBTAbGg6etzM5aaIuzSFU469bl3HsqmTve+sY9Y2V+bA3xWgf/vbnPOCKYgPREAUvIP6t0tHmZeQjeYpItSJcdq+d3vs2nzx2MK6a+HBnN9TGpbTfWdy2VFeOIkWtYMnlf5LAXDmC8kFfu8fz2oo0ixG5MBHLeuEtp0TolOnzPN/r/ZpRD4UGksDBSDNQ48lBoYAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpAa7bGLl2IxIgrwhnI2gmSgYw9pFpZbZratY2IedFc=;
 b=bgrMLlBCkQXqbvRQWxnjJUL2aO65JoHfXQ+8NGjybtt0ai0/YCR8QbAWHAV275JhSv8iiT4IvSDzBDCIdWafm3aUBDjTVnWPTWC+yrl1qastWuQCy2Vjkr7udB6ecqIc0D43xuQn1QGHWGgHkAwwXP+xLSWygEt7UQQxYnnFT2qS6nh5jLYgoNPJPRxCn/ebQGYx8cpSj57o3yRlkzwBM5nYU1zg3bGaGBhPf2AwxqvSNsdCV2rhaYxPYWguPjiw07aLZcEKM0AWxGHfP/epa+Y0MYXQlmv7wzi57q8HSMk/oWefspgAbDOeTo1BeZl3+ASMv4cOQq1tthozQTyOCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CO6PR12MB5458.namprd12.prod.outlook.com (2603:10b6:5:35b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 17:31:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 7/7] vfio: Remove calls to vfio_group_add_container_user()
Date:   Mon,  2 May 2022 14:31:37 -0300
Message-Id: <7-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27245f75-04da-4695-59d3-08da2c619d8b
X-MS-TrafficTypeDiagnostic: CO6PR12MB5458:EE_
X-Microsoft-Antispam-PRVS: <CO6PR12MB5458FF71E749F605D8241E4AC2C19@CO6PR12MB5458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ka+rcU4Bl5Y7GiWCLtTFjqihVG5KaXtsif3SrgHYOy+mUL74+ZYOlUI69+Jj2SMeaKiowzRI3EIsLWe0pQLDy0yIbAi4ysL+ff0kcUI2cMa7VU5+fkejpIQvSLa7TzWXB1/YpNWWbo7INIA2HBuCttNOYxliQ95mImGeZT8G1z+0U5PtR1S78QBQTdTLIcevmORxTai8ld5iCS40cmoseNjhOgjijij8WcNQcEUkgofr+qpoWYgqSbCYQC+8s8n0Hvpwix2HOL3gd7UcZ/mz3giKwq80lqyiVXhiHO8ctMXq7u2hyi48UhMCKFDZTodaTKTsPVs/HFYdPMCf+BUOlnjNUd3o5m7AExcXvKTGdsD5CduB1WMcK863047trWx1NvAd5mgSrxqbVBMRByQd8kh2RMXFDvUvYepZA868ogKyRAisLxmIHNJ7cL4THpjlxa2CyLiHPB3Rnypg++RISYQGMIJPMr31lgscuDBZVB2NXTQOi0GWBNHL0mpkoh8o0Z5iCzqDGUW4bCquvks8OvsK2vnbvD7pcvn6KwnChZmJX1nVvXy/iETRwR3Aic/4w9x0dprf8aLaUr+e9hsKJ5oa9Qtvl6lGnHxR3/gP2mSpxDzXiS/Jev2VgVUF2hzFSU2HzcvwNF9tUljgxANpBLSVyAWQYVnsSsqBNBZELoB6pl0wuFafMvUlhwQn5E+8EpUjwzIHA0ID6Gvwy31RLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(109986005)(6486002)(508600001)(2616005)(86362001)(6512007)(26005)(6506007)(38100700002)(6666004)(316002)(66476007)(2906002)(66946007)(66556008)(186003)(36756003)(5660300002)(8936002)(54906003)(4326008)(83380400001)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OSiVmvsxaWgc5E//AKXcfc057e8GECn0dv4wCpwIuwBoGeRdurm9TJBGBxuy?=
 =?us-ascii?Q?DculdD6D+LaG2XrMzmdN7zIG6+rHoZ5IHgHXn/ZUeJbzRdEd9IutoBf68aIw?=
 =?us-ascii?Q?ck6OrnXj6FBw5nGaLzda96WVlFiYWYdjQA3MqcEsZ36tqXJNjT2tIJpcnxSE?=
 =?us-ascii?Q?hec7SQNH+qDdDFjh5+MFKEsNBf3fP8RsWe79Mb7Qc0CprQhdxmO2CGO/PA2u?=
 =?us-ascii?Q?F4VPwoTpGku2EJsMmNwr9FnKtCm14DAfldQCYCyG4r3G8vE06CsMEXKdaR5b?=
 =?us-ascii?Q?n8YX//8UGGaZ4H8Mu7wzuCj/znZvmyOeDbo/1TyHkxEY+Kn1cA5hB3P2gDaW?=
 =?us-ascii?Q?HC6YMSWIciids0tgxh4ShjGCW6jGeIsbc7VOwzBz+rV2T+/W1bTexxsPgnwI?=
 =?us-ascii?Q?J6flI7mCwFlHlT1z6Qln9m6XdsRIH5pJdYLZpYtY234mhyQDm/Ngpw6oiFsw?=
 =?us-ascii?Q?yEUWoJcEgppfORQVgoE7IVJk/Zs5OjRxWtMksgF2ijZ/Rm8jBnNhGjxW2X4X?=
 =?us-ascii?Q?ISFVRFBCX7P43ZniFctvnKx8jry5cPxH59xGmhxzhEK7M1e+XDRxBsJqN1G3?=
 =?us-ascii?Q?dTKcdAEvyCHZ20DmkYzUDfhn0bvINBpwkmeFO7vmNoGUdXQo7wEXJ7bQ5gHg?=
 =?us-ascii?Q?Yk8IQXL7kMVWrQuQny8jPQVsrwwciJbQP0NhuezqEPprbZ24gVp1WyU5ywXm?=
 =?us-ascii?Q?WzzsKorEdF/hJ+8k3g/EyQzKTQmfEuL7vJ43k0IVFyROsnzVvjDy1HlpEATe?=
 =?us-ascii?Q?CLk207XR0NZAsAPaonQ8Jjh973CISEV8jlxC9Wxg7Q455TNAX4fMydsYkBp7?=
 =?us-ascii?Q?ca53drK5sbDghzr5mGGcbz3WVBtjpRdTUoDgr3JlEzeNeyb+1lNeD4xZFY+i?=
 =?us-ascii?Q?5N+33T0wzjNFS/0Cv9/NBY8WlQl6lvlrmS7PUwGREFnB6z/T8uqeXk4I4Qnx?=
 =?us-ascii?Q?OBi3QQ8hADbBXiRt/Ass4HF4I/5lwqILmbkFgqAxagjw5Vrb6VtQno7dGPB8?=
 =?us-ascii?Q?D3QQJobAH5xKGwfCAEpKn4zY4EZN/DPpZHuW0p45OOg5IQkAbADkcavW6YhS?=
 =?us-ascii?Q?pBs5qFWP55ae7wco43OctM9cmVlVOqhfkS3o3IKojaoh6P2CjAwWSUXf3Czf?=
 =?us-ascii?Q?RZPuwTuanlLoTfiSi/OXnihnyjR14wRydvdwqCGNsn+0IsZPHX9bevgrDGlp?=
 =?us-ascii?Q?Cv6SF4YDSQGQXhbNa3ok2IJF1raiBuoQpuZWxx970S61KD6+vz55sKvtawcJ?=
 =?us-ascii?Q?bplr1d1R/ZDHqkdjCvk1SpJLfgmFUNsm4Wpl/2P3H1oa2Vgn4z+PdG+97ejx?=
 =?us-ascii?Q?D69dW7xIbykr7LD6Zo25rYg5cSk1CEmbx5mcylG0M/f3BospHbA6w/cjS/id?=
 =?us-ascii?Q?CEBCVBw6ar6wdmWvndOPV4hTdUJZi5T6dFCuR2/NY58SH/14+7uJSBMlN8gt?=
 =?us-ascii?Q?+dspFZUwuniJ0Cdf7wboy0CUPNPoRWGGyF3xc3PM0bBiGBNW0qfvrLLsoNIB?=
 =?us-ascii?Q?zCIc7EyuhxeuK2MYdRqAf/121c+ZcRLYrZlOO+CVmHkaQjLVdGx3QC7DMp6S?=
 =?us-ascii?Q?9Kn6iNI+ISvj15w7M5EBwxjgrhfDzNPQK85CvUIAFCzbSeB/ZEYla9GMky1n?=
 =?us-ascii?Q?XSxKzn1JLewtDlejtpdOwgV3uQk4Um1HRmd9FKhedHWg5i+IUoxG1vGseHHH?=
 =?us-ascii?Q?cLKZiGVsz1lMRI89HIXFdVpn+AhJ81Kz9uA/sLPP/fMz1ZYNOYBcJc3OGCXM?=
 =?us-ascii?Q?gvS9FV5jew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27245f75-04da-4695-59d3-08da2c619d8b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:39.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBKeHbLcFJOzd5oN1SZwRFhRv2VbZOaTDdbRQp8SUdSfG1jn0LQVFHlPNBsi37m6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5458
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the open_device() op is called the container_users is incremented and
held incremented until close_device(). Thus, so long as drivers call
functions within their open_device()/close_device() region they do not
need to worry about the container_users.

These functions can all only be called between open_device() and
close_device():

  vfio_pin_pages()
  vfio_unpin_pages()
  vfio_dma_rw()
  vfio_register_notifier()
  vfio_unregister_notifier()

Eliminate the calls to vfio_group_add_container_user() and add
vfio_assert_device_open() to detect driver mis-use. This causes the
close_device() op to check device->open_count so always leave it elevated
while calling the op.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 78 +++++++++------------------------------------
 1 file changed, 15 insertions(+), 63 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 0184d760ec1e44..f7d1898129ad1c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1115,6 +1115,12 @@ static int vfio_group_add_container_user(struct vfio_group *group)
 
 static const struct file_operations vfio_device_fops;
 
+/* true if the vfio_device has open_device() called but not close_device() */
+static bool vfio_assert_device_open(struct vfio_device *device)
+{
+	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
+}
+
 static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 {
 	struct vfio_device *device;
@@ -1329,8 +1335,10 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	struct vfio_device *device = filep->private_data;
 
 	mutex_lock(&device->dev_set->lock);
-	if (!--device->open_count && device->ops->close_device)
+	vfio_assert_device_open(device);
+	if (device->open_count == 1 && device->ops->close_device)
 		device->ops->close_device(device);
+	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 
 	module_put(device->dev->driver->owner);
@@ -1897,7 +1905,7 @@ int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn, int npage,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
-	if (!user_pfn || !phys_pfn || !npage)
+	if (!user_pfn || !phys_pfn || !npage || !vfio_assert_device_open(vdev))
 		return -EINVAL;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
@@ -1906,10 +1914,6 @@ int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn, int npage,
 	if (group->dev_counter > 1)
 		return -EINVAL;
 
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return ret;
-
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->pin_pages))
@@ -1919,8 +1923,6 @@ int vfio_pin_pages(struct vfio_device *vdev, unsigned long *user_pfn, int npage,
 	else
 		ret = -ENOTTY;
 
-	vfio_group_try_dissolve_container(group);
-
 	return ret;
 }
 EXPORT_SYMBOL(vfio_pin_pages);
@@ -1941,16 +1943,12 @@ int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
-	if (!user_pfn || !npage)
+	if (!user_pfn || !npage || !vfio_assert_device_open(vdev))
 		return -EINVAL;
 
 	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
 		return -E2BIG;
 
-	ret = vfio_group_add_container_user(vdev->group);
-	if (ret)
-		return ret;
-
 	container = vdev->group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unpin_pages))
@@ -1959,8 +1957,6 @@ int vfio_unpin_pages(struct vfio_device *vdev, unsigned long *user_pfn,
 	else
 		ret = -ENOTTY;
 
-	vfio_group_try_dissolve_container(vdev->group);
-
 	return ret;
 }
 EXPORT_SYMBOL(vfio_unpin_pages);
@@ -1989,13 +1985,9 @@ int vfio_dma_rw(struct vfio_device *vdev, dma_addr_t user_iova, void *data,
 	struct vfio_iommu_driver *driver;
 	int ret = 0;
 
-	if (!data || len <= 0)
+	if (!data || len <= 0 || !vfio_assert_device_open(vdev))
 		return -EINVAL;
 
-	ret = vfio_group_add_container_user(vdev->group);
-	if (ret)
-		return ret;
-
 	container = vdev->group->container;
 	driver = container->iommu_driver;
 
@@ -2004,9 +1996,6 @@ int vfio_dma_rw(struct vfio_device *vdev, dma_addr_t user_iova, void *data,
 					  user_iova, data, len, write);
 	else
 		ret = -ENOTTY;
-
-	vfio_group_try_dissolve_container(vdev->group);
-
 	return ret;
 }
 EXPORT_SYMBOL(vfio_dma_rw);
@@ -2019,10 +2008,6 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return -EINVAL;
-
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->register_notifier))
@@ -2030,9 +2015,6 @@ static int vfio_register_iommu_notifier(struct vfio_group *group,
 						     events, nb);
 	else
 		ret = -ENOTTY;
-
-	vfio_group_try_dissolve_container(group);
-
 	return ret;
 }
 
@@ -2043,10 +2025,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	struct vfio_iommu_driver *driver;
 	int ret;
 
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return -EINVAL;
-
 	container = group->container;
 	driver = container->iommu_driver;
 	if (likely(driver && driver->ops->unregister_notifier))
@@ -2054,9 +2032,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 						       nb);
 	else
 		ret = -ENOTTY;
-
-	vfio_group_try_dissolve_container(group);
-
 	return ret;
 }
 
@@ -2085,10 +2060,6 @@ static int vfio_register_group_notifier(struct vfio_group *group,
 	if (*events)
 		return -EINVAL;
 
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return -EINVAL;
-
 	ret = blocking_notifier_chain_register(&group->notifier, nb);
 
 	/*
@@ -2098,25 +2069,6 @@ static int vfio_register_group_notifier(struct vfio_group *group,
 	if (!ret && set_kvm && group->kvm)
 		blocking_notifier_call_chain(&group->notifier,
 					VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);
-
-	vfio_group_try_dissolve_container(group);
-
-	return ret;
-}
-
-static int vfio_unregister_group_notifier(struct vfio_group *group,
-					 struct notifier_block *nb)
-{
-	int ret;
-
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return -EINVAL;
-
-	ret = blocking_notifier_chain_unregister(&group->notifier, nb);
-
-	vfio_group_try_dissolve_container(group);
-
 	return ret;
 }
 
@@ -2126,7 +2078,7 @@ int vfio_register_notifier(struct vfio_device *dev, enum vfio_notify_type type,
 	struct vfio_group *group = dev->group;
 	int ret;
 
-	if (!nb || !events || (*events == 0))
+	if (!nb || !events || (*events == 0) || !vfio_assert_device_open(dev))
 		return -EINVAL;
 
 	switch (type) {
@@ -2150,7 +2102,7 @@ int vfio_unregister_notifier(struct vfio_device *dev,
 	struct vfio_group *group = dev->group;
 	int ret;
 
-	if (!nb)
+	if (!nb || !vfio_assert_device_open(dev))
 		return -EINVAL;
 
 	switch (type) {
@@ -2158,7 +2110,7 @@ int vfio_unregister_notifier(struct vfio_device *dev,
 		ret = vfio_unregister_iommu_notifier(group, nb);
 		break;
 	case VFIO_GROUP_NOTIFY:
-		ret = vfio_unregister_group_notifier(group, nb);
+		ret = blocking_notifier_chain_unregister(&group->notifier, nb);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.36.0

