Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D9C333110
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhCIVjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:10 -0500
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:49607
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231859AbhCIVi5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:38:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbkxRIO29BijacP6UWBTjxTYvlnXQxnpvvZzo+jw1/EnRHROpoPpmI21rU+GEljZ7iZKt5D8Z6HvrQAA4nYTpTESxiCbdeDroxYcMjFp9MiGT0A2nnC76qboLaSCxPu0jsRDKNwWnpBfvopPn1UjsuUQZCzeAHA0tgf5z2eQBJFTaxcIk4zJFfAonxA3m8jvq2UQm0YjqUBpV2sE2aYvqJD65VF56RM9PheNP+FXW+mdbcgLnmisH9O10SwaCb+Rlc6KOA6LMFMNdJ87OpgALmeaPRApY9oH4z3IrQEcTViETamQS3iMUuL3pmPK7lUScO3IehEy4IUhwokWe3MpQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crWEqmM+Da669DP/L5wYzC4CpvMA2sM0GfG0jfA5hE8=;
 b=Sa1gZKjr4PSTiDulKZqcdVt1qNyP1tVrhC/zQdRdivXQwbtaeQSOi76ZcZZh6aA4NwEjbUBK3erdcMDS6OPOBq0FFt1iD0ZsNPef+A5Ip3zgkVGZthU7SYEP3UJ1UDx0aNyJKfNQQZwjaSxOTIoHW00qzTkiPTNxayLuWyFFD/CwCzAykgLcxshhGB/FycAgdwlv8HZW1x2mfkHTSVZIxKB70Cpcw604h6SPlOlsr2SY0tvEILAVBZ/s/pnRohx2QfjOgUUb2coKopCtVadNR4lfCAs+IKW1Jl88KV4JZt3ITdnK/fnlFEhVqCRtE78o0h59I6LoBIbioFPkztl+9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crWEqmM+Da669DP/L5wYzC4CpvMA2sM0GfG0jfA5hE8=;
 b=DvHaHBdq0srMh0jRWchT3NbmGWxl2L77mTjBm1c4CYE8dxMPT17FdUuX6W5LegF1fCmIHl2QXa8YcLiZMHsU+7u7oHxkgc07Su4XtCltivmkMXyM+nE9NyL2VF5Yw05ro4KMQZo75r0m2i1yW/H+hPLeBq0FTWwSlI1FaYHOTpUGUJ2hryDas2u+kTc2MyX4MzOSJQuDyhzbp4DLpK9Gk6dePsMGa14HEIWshrBUkdF5IpMVWyi99CwYYNC5lWgTWYUY/b9TOzSV9Eqk5tNYqmfTB9FkXW5hfYF5H6loIc2aD7pHFf1/VLdGufjV9MH1SAhZavKtyaVYxX5amMCtwQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:55 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 02/10] vfio: Split creation of a vfio_device into init and register ops
Date:   Tue,  9 Mar 2021 17:38:44 -0400
Message-Id: <2-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:208:e8::39) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0026.namprd20.prod.outlook.com (2603:10b6:208:e8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIf-N0; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b613b1dc-d65f-43c9-7759-08d8e343bc81
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2489:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24899AEA184CAFAB05841E51C2929@DM5PR1201MB2489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBlc+jeLTtRWBVX7h66F4bgLtp+lgLdsJ6hSVQjBGKShZU6EDlumgoRU2LNuFkWQcG2FRFbieEM+haXU4i/8nFqILnuAeOSIl0mI765Op+hVO0gVzVdp82TuXFXq7zhlwWZcz05U/DVn8dAYyvWPrSJBbev1IxmZuU5stHLxLb+1Gf3JXB1hmoHLZdRU1QKwQSzGJq5qhrAC803A25uO4/v6NN0sGfJTHdUpdCg0YYr/+Xvp3ZDB+vBHjIQMcivrwY9iMr2+DA5cwF6RPDnNjNMt9+dVlNqzd/q+q6QiScA78VH/jEpe+ZnK62qNqtvjoeSXq5Qh7g15mOgYaT0V8oOSw/tLPq38jJDB/ZIdo96TXpsPd2L3DsqctgUwiLi9sUYpR8lJXCv0Qb74mh8a2FHpzI5+YfLniEqqqoerdUV2Gk4oHyhsbJDgjX6GchU8tYc4fUOJ0MVraCMKAJIb9Qmn34MlfhPPY+dJFaAC7lloU+sjSDMlrIlMkcuet7RsnpZJbVbGtLnxaUmBbeKu8c21ZfJ6PrOCJE/UaKB9NhZiH6X/tTxvwOmCt2pL0D+9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(6666004)(26005)(36756003)(316002)(5660300002)(4326008)(478600001)(54906003)(110136005)(9746002)(426003)(66556008)(66476007)(2616005)(9786002)(8936002)(86362001)(186003)(2906002)(8676002)(107886003)(30864003)(83380400001)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YufTQI+Bj3nU618QbzabMCG+PD3k9M1lqUUTGBbN+K9NBNw1iVDJcWsHyRjG?=
 =?us-ascii?Q?X1uEjn926aZVbnUvd6c6Mu+KYziL1sduuiG8EaIdMhnaRp/L3booY5soc61R?=
 =?us-ascii?Q?6FYsz8zaK32qOQfDMK8Xz+h+fOwWTq5JzWUZyP3MSUZqfUfCZxXj+HR/k//O?=
 =?us-ascii?Q?isqjZHHmszBBg9bFBRTMf5eCKhIivVe59GN9nk2zfXfJFccSTaKylNXyODxQ?=
 =?us-ascii?Q?vBHeJqAT5zKOSAx2Pkx5kCOutcqTWq7vUwu64sAc4/jrUqV2TbE0X335zOcC?=
 =?us-ascii?Q?iUOKE+II0yzvmPhMk130mYY8u34OeAdRWVLCMlzLAkyU2zgVGmRHt/dD8i/C?=
 =?us-ascii?Q?QP8vkn5C8oVveDIwr5VDFoLODr2At+ddbRaGds53fWx/G/sKY15x26kxE2t/?=
 =?us-ascii?Q?fVkGd4whnAjRv3PjZ/Q+567vfrOSy5wUqsxIUQ3t2ADUoz/YBiHt6syo7azV?=
 =?us-ascii?Q?8L1SVi0vIsYp9WH+VZZ4+DMKP0DR4/0MQD5k4LP5kFskwto5k3PvRMTSVPqv?=
 =?us-ascii?Q?OPfFp3z1zEhpS3RA1zjsziPVeD+pe1ybVqotfh9WLmbVcQUZo5ZEPGlpEAN7?=
 =?us-ascii?Q?9OzWBg1wLxN6Q5awVpZIWZo2cHUNC2G3b/MA7Y7ePkP3hQB3f+BGkGd4uu2f?=
 =?us-ascii?Q?WBSs4APAUWmqPA80FogYwkFO1V3i19F6ekvfL3syljdv6T3vM3ljenasltUo?=
 =?us-ascii?Q?9UIGEUxLwGIO5ZRmx7FvC8VSKIcngjOfVvmD30OLkc4bY2EmWKaOLG9yXe3g?=
 =?us-ascii?Q?2CIqOjxvX0HOWhfVZepoIL6QjdrM6ypTqGGa/9LwH9v9YG5Bb81CYGdjexm6?=
 =?us-ascii?Q?sgGITH9bP5s04iPScet/M1UQg0DtOpHz55Aa6RsqYXy4TAJtrzeMTU9GWah0?=
 =?us-ascii?Q?M7oC11MJQwfRa3D28jv5gtiVwvz8zVpZeM9a2SSuAp8z27ynPNk4Ei+y6T3p?=
 =?us-ascii?Q?0p3GcZnyd04Cifcy+QpGUVYeVDFIqtWpF3loXwILbdQ4qejEPteMMo89CGly?=
 =?us-ascii?Q?MZ/0n3jCgMzuQVLwqKarS2iMO5CSv6+3duHeP/IvMRrKF2b5fqT90JkLvAuk?=
 =?us-ascii?Q?MXcvB62nt+4MaNMkj2jkNEf98dCzhQYXxYQJcNSpynFgJAmTHZxpTpzpwg1r?=
 =?us-ascii?Q?2ZjLYvnNTQCnAcsk20zoWAGKXs0raBmFG7ejXV37fnJpS1Zk/DMrGI7Q0zQz?=
 =?us-ascii?Q?NaPcJa37sgsI5y6FDfU7bS30hFb5zWJL4n9PQg1O7KwmZEi1e5z1Prj7VG6h?=
 =?us-ascii?Q?/KtD8BqT3JuuyOvQgGhLRQpcyM8CrZlG3cZYSJ1SBKaF5rKUcV7nSpHb2R/A?=
 =?us-ascii?Q?AP5AN5CGKgaEZDNJmTTIPpbtQqcfayeQFBydyOL8dgTu+A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b613b1dc-d65f-43c9-7759-08d8e343bc81
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:54.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObgjD5J59rxifiqUFSF+PyDKwts5YAWlSAMdoio9Ykt9klOa+3zBcb+Nk+owNKxy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2489
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the struct vfio_pci_device part of the public interface so it
can be used with container_of and so forth, as is typical for a Linux
subystem.

This is the first step to bring some type-safety to the vfio interface by
allowing the replacement of 'void *' and 'struct device *' inputs with a
simple and clear 'struct vfio_pci_device *'

For now the self-allocating vfio_add_group_dev() interface is kept so each
user can be updated as a separate patch.

The expected usage pattern is

  driver core probe() function:
     my_device = kzalloc(sizeof(*mydevice));
     vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
     /* other driver specific prep */
     vfio_register_group_dev(&my_device->vdev);
     dev_set_drvdata(my_device);

  driver core remove() function:
     my_device = dev_get_drvdata(dev);
     vfio_unregister_group_dev(&my_device->vdev);
     /* other driver specific tear down */
     kfree(my_device);

Allowing the driver to be able to use the drvdata and vifo_device to go
to/from its own data.

The pattern also makes it clear that vfio_register_group_dev() must be
last in the sequence, as once it is called the core code can immediately
start calling ops. The init/register gap is provided to allow for the
driver to do setup before ops can be called and thus avoid races.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst |  31 ++++---
 drivers/vfio/vfio.c               | 132 ++++++++++++++----------------
 include/linux/vfio.h              |  16 ++++
 3 files changed, 96 insertions(+), 83 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c3ba0bb1..d3a02300913a7f 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -249,18 +249,23 @@ VFIO bus driver API
 
 VFIO bus drivers, such as vfio-pci make use of only a few interfaces
 into VFIO core.  When devices are bound and unbound to the driver,
-the driver should call vfio_add_group_dev() and vfio_del_group_dev()
-respectively::
-
-	extern int vfio_add_group_dev(struct device *dev,
-				      const struct vfio_device_ops *ops,
-				      void *device_data);
-
-	extern void *vfio_del_group_dev(struct device *dev);
-
-vfio_add_group_dev() indicates to the core to begin tracking the
-iommu_group of the specified dev and register the dev as owned by
-a VFIO bus driver.  The driver provides an ops structure for callbacks
+the driver should call vfio_register_group_dev() and
+vfio_unregister_group_dev() respectively::
+
+	void vfio_init_group_dev(struct vfio_device *device,
+				struct device *dev,
+				const struct vfio_device_ops *ops,
+				void *device_data);
+	int vfio_register_group_dev(struct vfio_device *device);
+	void vfio_unregister_group_dev(struct vfio_device *device);
+
+The driver should embed the vfio_device in its own structure and call
+vfio_init_group_dev() to pre-configure it before going to registration.
+vfio_register_group_dev() indicates to the core to begin tracking the
+iommu_group of the specified dev and register the dev as owned by a VFIO bus
+driver. Once vfio_register_group_dev() returns it is possible for userspace to
+start accessing the driver, thus the driver should ensure it is completely
+ready before calling it. The driver provides an ops structure for callbacks
 similar to a file operations structure::
 
 	struct vfio_device_ops {
@@ -276,7 +281,7 @@ similar to a file operations structure::
 	};
 
 Each function is passed the device_data that was originally registered
-in the vfio_add_group_dev() call above.  This allows the bus driver
+in the vfio_register_group_dev() call above.  This allows the bus driver
 an easy place to store its opaque, private data.  The open/release
 callbacks are issued when a new file descriptor is created for a
 device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 04e24248e77f50..cfa06ae3b9018b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -89,16 +89,6 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 };
 
-struct vfio_device {
-	refcount_t			refcount;
-	struct completion		comp;
-	struct device			*dev;
-	const struct vfio_device_ops	*ops;
-	struct vfio_group		*group;
-	struct list_head		group_next;
-	void				*device_data;
-};
-
 #ifdef CONFIG_VFIO_NOIOMMU
 static bool noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_mode,
@@ -532,40 +522,6 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
 /**
  * Device objects - create, release, get, put, search
  */
-static
-struct vfio_device *vfio_group_create_device(struct vfio_group *group,
-					     struct device *dev,
-					     const struct vfio_device_ops *ops,
-					     void *device_data)
-{
-	struct vfio_device *device;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return ERR_PTR(-ENOMEM);
-
-	refcount_set(&device->refcount, 1);
-	init_completion(&device->comp);
-	device->dev = dev;
-	device->group = group;
-	device->ops = ops;
-	device->device_data = device_data;
-	dev_set_drvdata(dev, device);
-
-	/*
-	 * No need to get group_lock, caller has group reference, matching put
-	 * is in vfio_del_group_dev()
-	 */
-	vfio_group_get(group);
-
-	mutex_lock(&group->device_lock);
-	list_add(&device->group_next, &group->device_list);
-	group->dev_counter++;
-	mutex_unlock(&group->device_lock);
-
-	return device;
-}
-
 /* Device reference always implies a group reference */
 void vfio_device_put(struct vfio_device *device)
 {
@@ -784,14 +740,23 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 /**
  * VFIO driver API
  */
-int vfio_add_group_dev(struct device *dev,
-		       const struct vfio_device_ops *ops, void *device_data)
+void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
+			 const struct vfio_device_ops *ops, void *device_data)
 {
+	init_completion(&device->comp);
+	device->dev = dev;
+	device->ops = ops;
+	device->device_data = device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_init_group_dev);
+
+int vfio_register_group_dev(struct vfio_device *device)
+{
+	struct vfio_device *existing_device;
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
-	struct vfio_device *device;
 
-	iommu_group = iommu_group_get(dev);
+	iommu_group = iommu_group_get(device->dev);
 	if (!iommu_group)
 		return -EINVAL;
 
@@ -810,30 +775,51 @@ int vfio_add_group_dev(struct device *dev,
 		iommu_group_put(iommu_group);
 	}
 
-	device = vfio_group_get_device(group, dev);
-	if (device) {
-		dev_WARN(dev, "Device already exists on group %d\n",
+	existing_device = vfio_group_get_device(group, device->dev);
+	if (existing_device) {
+		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(iommu_group));
-		vfio_device_put(device);
+		vfio_device_put(existing_device);
 		vfio_group_put(group);
 		return -EBUSY;
 	}
 
-	device = vfio_group_create_device(group, dev, ops, device_data);
-	if (IS_ERR(device)) {
-		vfio_group_put(group);
-		return PTR_ERR(device);
-	}
+	/* Our reference on group is moved to the device */
+	device->group = group;
 
-	/*
-	 * Drop all but the vfio_device reference.  The vfio_device holds
-	 * a reference to the vfio_group, which holds a reference to the
-	 * iommu_group.
-	 */
-	vfio_group_put(group);
+	/* Refcounting can't start until the driver calls register */
+	refcount_set(&device->refcount, 1);
+
+	mutex_lock(&group->device_lock);
+	list_add(&device->group_next, &group->device_list);
+	group->dev_counter++;
+	mutex_unlock(&group->device_lock);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_register_group_dev);
+
+int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
+		       void *device_data)
+{
+	struct vfio_device *device;
+	int ret;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	vfio_init_group_dev(device, dev, ops, device_data);
+	ret = vfio_register_group_dev(device);
+	if (ret)
+		goto err_kfree;
+	dev_set_drvdata(dev, device);
+	return 0;
+
+err_kfree:
+	kfree(device);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
 /**
@@ -900,11 +886,9 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
-void *vfio_del_group_dev(struct device *dev)
+void vfio_unregister_group_dev(struct vfio_device *device)
 {
-	struct vfio_device *device = dev_get_drvdata(dev);
 	struct vfio_group *group = device->group;
-	void *device_data = device->device_data;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
 	bool interrupted = false;
@@ -921,7 +905,7 @@ void *vfio_del_group_dev(struct device *dev)
 	 */
 	unbound = kzalloc(sizeof(*unbound), GFP_KERNEL);
 	if (unbound) {
-		unbound->dev = dev;
+		unbound->dev = device->dev;
 		mutex_lock(&group->unbound_lock);
 		list_add(&unbound->unbound_next, &group->unbound_list);
 		mutex_unlock(&group->unbound_lock);
@@ -932,7 +916,7 @@ void *vfio_del_group_dev(struct device *dev)
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
 		if (device->ops->request)
-			device->ops->request(device_data, i++);
+			device->ops->request(device->device_data, i++);
 
 		if (interrupted) {
 			rc = wait_for_completion_timeout(&device->comp,
@@ -942,7 +926,7 @@ void *vfio_del_group_dev(struct device *dev)
 				&device->comp, HZ * 10);
 			if (rc < 0) {
 				interrupted = true;
-				dev_warn(dev,
+				dev_warn(device->dev,
 					 "Device is currently in use, task"
 					 " \"%s\" (%d) "
 					 "blocked until device is released",
@@ -975,9 +959,17 @@ void *vfio_del_group_dev(struct device *dev)
 
 	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
+
+void *vfio_del_group_dev(struct device *dev)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+	void *device_data = device->device_data;
+
+	vfio_unregister_group_dev(device);
 	dev_set_drvdata(dev, NULL);
 	kfree(device);
-
 	return device_data;
 }
 EXPORT_SYMBOL_GPL(vfio_del_group_dev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b7e18bde5aa8b3..ad8b579d67d34a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,18 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct vfio_device {
+	struct device *dev;
+	const struct vfio_device_ops *ops;
+	struct vfio_group *group;
+
+	/* Members below here are private, not for driver use */
+	refcount_t refcount;
+	struct completion comp;
+	struct list_head group_next;
+	void *device_data;
+};
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -48,11 +60,15 @@ struct vfio_device_ops {
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
+void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
+			 const struct vfio_device_ops *ops, void *device_data);
+int vfio_register_group_dev(struct vfio_device *device);
 extern int vfio_add_group_dev(struct device *dev,
 			      const struct vfio_device_ops *ops,
 			      void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
+void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
-- 
2.30.1

