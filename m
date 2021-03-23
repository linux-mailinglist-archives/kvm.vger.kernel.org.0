Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8113464BB
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhCWQPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:41 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:19553
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233152AbhCWQPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfLf9IUqHSx3RkShku651zfQiUSTGjC9aSBCXoA3Vq0Y5q2pST1UyhxLbgJiXNIli+orkyNkl4lAI9RHqrjHZGOmhCulhezHDcULiKqARonuFWdkLTQANWt6jVwSx05XBtNNzNxXYlKxV7RuHY60/OObPhJmbky8v/Axf8bta7wiLe73noPt2dvOSp+0ONTtQYq6t7A/IskfXZxTZIaDExyQmx/YIHT9MoxiEYk6om+uJ9slnjH+LeiAB04U66csYKco0ft6VrsA5rKiFerOim4OVsmClCtmgThsPpNfPSZMM7F8hYQKlUCWMT5T8vTjyJiu1HNRrW8o0qRob2NKcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEak6oZ5oGrh/36XE8vfMtDr01GFf3MViduAKRXlsog=;
 b=NOMdI/xG6x0uoauOizQDtXBQ8KFkoTOcy78SOuObN8Cf4zl51v0jak6lwrcUWClZPUHzrn3NpiApkLdKHzumgqGsAb29TH81ilANqZbgge8ueS7rBU6pOdlKJMxwDnVP7aRXS4flMlcepl0nO7F0p9eiQ2t6f2I9HEKxXztEF+f9A2pVuA7+mXJWnlaz/M45gfNYv4MVsj9J820kjLvXiK+1zl9IHEFuk3oXBSbOWyQq+f94hSBB8FzIcLytqLyPf58JrjG6uY7BHLjLXzUeS8EgKinl7wUzZr4t1Q6OfK/CaZ4iJHeUlRPW0LRHMD9Ia/PvbQnH7IaVfxtG0ZFStw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEak6oZ5oGrh/36XE8vfMtDr01GFf3MViduAKRXlsog=;
 b=sRypVxesv7lrsM6ThVuhES0Z4o9JRARqU1vP1O+4LTjhm/18650cmhamZ5aDQgh5SIgr8IFfxiM8G3OiJOovKdtBDHNwXW7hPzOBmz6yIclFyvSG8lAeO9EPBnGfAZl2oWnjd7Y26oJ6NRnXP09ddB1nRhSLLySZoDCx1+74Zaz7kcQgomCcyyKQoiz6B6macIq0T3yjILAim7akWhS07dSTKx4Y5aEAD/sHQLYKN0yVX+2oFS7/RSGXlF/B4M7YorWuqWqBEwtcIVCoHh/MhIRYYdYIgwgkU6RcmAQAu1AIpPEZkG56lxeaI3n714MT466dw0kZR3E5r7xoaiqFVA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 14/14] vfio: Remove device_data from the vfio bus driver API
Date:   Tue, 23 Mar 2021 13:15:06 -0300
Message-Id: <14-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0253.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0253.namprd13.prod.outlook.com (2603:10b6:208:2ba::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Tue, 23 Mar 2021 16:15:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgR-001aDG-1e; Tue, 23 Mar 2021 13:15:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8455ccc3-5a4d-42c8-a45d-08d8ee16d495
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267B0D164197459FCA88AF4C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NQmoEkx6tvWkYkATEzgPChb4f7J0S5uTcW3z7PTw3ziweJHmFZW2m0pk2IpXmL8redXfwQcd5fkfWXe5tFuvAogh2gDdlwaK2CrDPOs7E0Ym7Mjr/0HGhf4+7YtHeAbHlZcCVmC5ZxH5e01Aea6mfPw0xQ1NqLiY2ojVgZFL1nktja/pBd9N45JeqHiWiDWnnvZR9GdoNN12WUbTCa/yUnC2ym0j/nWNSOfNtmKRMQTHYWFjAwr96fKfLBnSZQneW3IuWtXh8g5Jg0vQAlrVEeCsVurx6RLOqKQydcdJ2qOPuN/LXRV4VqgpsjNXY2f6m71OUUd7c9YeXiuVjQK0eDbATlkA0bKYWtELd/f2mP67iVjMFHdnCUGdt9pK5FKeDo9RYspfxFTvFI3yXElY4ZKzA/2E+vZLO8YXlGWPFEkX/kw6VqmB2d8iwd4AxtVyk7Rlbp0kBIorcVXFyF/xpPykpYIptX5z0vArYLpFsWMkId/ClZq0Zl66voxcCR71haveq8ozk4v/CtriOHyY4jmMWQG5133cfclLK+9OEMqGvXUODbAiNPdCHet9ECIxsEJ9BKxDH76G5HvFQHydXjqMcI8Fvr4ltOzu/WVRqB8VFQHXFjh4lm36TIy5KXW09BmQWL91j9D5oju/T3BxOVQVXcTXrR2HRWSQV2boyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(7416002)(83380400001)(426003)(54906003)(110136005)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ux4RG0L/ltl6Wyr3a/FWa15GTYgdwJINtxkz+cFzfkOcEUxv2TY5wn24WVrF?=
 =?us-ascii?Q?kEcITFEPpYz+JSQVroCAJVoyiVqgmPrB69JDonPh1c/WBpxZl3HQgyQNp1WG?=
 =?us-ascii?Q?Ix35IeMtLL6a9q/1jl8HLrAFi9eS6twRCZ8DB9i42CgkkDt7WZ/rwR7/Vpo6?=
 =?us-ascii?Q?as5bUBgvRLpWJRe1ZEHmOYOITsVopsCcj3WzJCE+3Y7fmLPLVc3UuEqNkSW2?=
 =?us-ascii?Q?8OjxA5LS7xn7bbg94hhA5pjuVZ5JAU0bJC7BPQX2Yvp74ZNG9Xndfg5L8PU1?=
 =?us-ascii?Q?ntl2jlAaxzRPXY40COiogPh5oE3mnZOTxwhjE+m35WODzdpjF0Yqn8HrLBLj?=
 =?us-ascii?Q?Xe0Lt3GfjstUzeBQmdGnYlbetriw7rlSP/3c9ycYHVpOWGksMwna2I/rgedN?=
 =?us-ascii?Q?iVjSF+tmTVi0Z6e9kgExvu7bSW2kinq/MW5AG8k4z4oGYAZ2oE/uEIn0DHBh?=
 =?us-ascii?Q?rzbz/Zf5EE5rjesCUUgzN41DM4FBHhO/1gp1e7oZmZ6bcwlzzzdTajZ1AMKN?=
 =?us-ascii?Q?5XbKUufJ78gxDpCT7SZWWsFj/tLe7/TA6h8J4NSvbGM/a4KgrLTZwgIkKsiZ?=
 =?us-ascii?Q?Efac1d1vbNKqZUaI/Wnsk0ACNMOFitQFg4q180lwydNOza/jC7NwcUQ3tnDl?=
 =?us-ascii?Q?C/KhXWTqZm4ZnVG8imQKbxF/RUcNNVqxLOSsQmqV3AiszGVEawbbiC66/hRf?=
 =?us-ascii?Q?W4FrRQfmPEDNUXdmHGCU3cANQ8nKrv58NFmmAKDu+bnj8kt2KlehzN7FlVZx?=
 =?us-ascii?Q?dTJDyeAX2i9dcSmNUFfM1n5l3ITuMcxEUWDWlZ5SuMaEuxhT/5YI2cBkBmzv?=
 =?us-ascii?Q?8ICSLbtnklNX8sgbrz7d9maNcRhQgwnLVaw5c/9zjcWPIvrdalps/aGQp5/N?=
 =?us-ascii?Q?KmJ8DSoIh12TcszVoOThFh8P23UIzLgBnOYpcXq4Pb56ZUg5vHqbHR/JXj2K?=
 =?us-ascii?Q?5MuUwktZjDjKMOhTTxCa6FKN0YPPjRDRZj7yXlFdu7mUpLpODMu3wQcpAPsY?=
 =?us-ascii?Q?AR5HF37QAiex5uWCElT+W/gS8WN0JclzZcz4mUXd3Lrhr8V91sBp2YMEn/ID?=
 =?us-ascii?Q?leg+4iKvIY35LZuehZtnwKoJnH4OWj/XvzQkA1PgfrhHdJobfs0/hz+X3UDI?=
 =?us-ascii?Q?9HAIRW2JXjpCi8IIJ5kbz+8NpLQUqLBU6b3MxOkqtiaTFjjAtIGeSigpNaTn?=
 =?us-ascii?Q?p0uDrnfwKufGfvcdSNdvc1gnbNokx5GPrEondeXrdbIkV7hBCE4sSFgylUev?=
 =?us-ascii?Q?JK2vMHjFWcuiKS7hSIgAiZWzwCaEJ+iCuuV1l/ueGSfUnCcmpR8G1YsNrBIV?=
 =?us-ascii?Q?yYbN/gI8lWbc0Uab0GqNLyVb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8455ccc3-5a4d-42c8-a45d-08d8ee16d495
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:09.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6TOZ3PTYOhuplm9EpH66nA1eK9BSJm7zyoyxV5hY9JqGLvq77fya5AigdRYSBa5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are no longer any users, so it can go away. Everything is using
container_of now.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst            |  3 +--
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  5 +++--
 drivers/vfio/mdev/vfio_mdev.c                |  2 +-
 drivers/vfio/pci/vfio_pci.c                  |  2 +-
 drivers/vfio/platform/vfio_platform_common.c |  2 +-
 drivers/vfio/vfio.c                          | 12 +-----------
 include/linux/vfio.h                         |  4 +---
 7 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 3337f337293a32..decc68cb8114ac 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -254,8 +254,7 @@ vfio_unregister_group_dev() respectively::
 
 	void vfio_init_group_dev(struct vfio_device *device,
 				struct device *dev,
-				const struct vfio_device_ops *ops,
-				void *device_data);
+				const struct vfio_device_ops *ops);
 	int vfio_register_group_dev(struct vfio_device *device);
 	void vfio_unregister_group_dev(struct vfio_device *device);
 
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 45f397c04a8959..980e5955130197 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -75,7 +75,8 @@ static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
 			goto unlock;
 		}
 
-		cont_vdev = vfio_device_data(device);
+		cont_vdev =
+			container_of(device, struct vfio_fsl_mc_device, vdev);
 		if (!cont_vdev || !cont_vdev->reflck) {
 			vfio_device_put(device);
 			ret = -ENODEV;
@@ -630,7 +631,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		goto out_group_put;
 	}
 
-	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops);
 	vdev->mc_dev = mc_dev;
 	mutex_init(&vdev->igate);
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 11b3e15403ba4f..ae7e322fbe3c26 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -134,7 +134,7 @@ static int vfio_mdev_probe(struct device *dev)
 	if (!vdev)
 		return -ENOMEM;
 
-	vfio_init_group_dev(vdev, &mdev->dev, &vfio_mdev_dev_ops, mdev);
+	vfio_init_group_dev(vdev, &mdev->dev, &vfio_mdev_dev_ops);
 	ret = vfio_register_group_dev(vdev);
 	if (ret) {
 		kfree(vdev);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1f70387c8afe37..55ef27a15d4d3f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2022,7 +2022,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_group_put;
 	}
 
-	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index f5f6b537084a67..361e5b57e36932 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -666,7 +666,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	struct iommu_group *group;
 	int ret;
 
-	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops);
 
 	ret = vfio_platform_acpi_probe(vdev, dev);
 	if (ret)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e6f5109fba4858..5e631c359ef23c 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -741,12 +741,11 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
  * VFIO driver API
  */
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops, void *device_data)
+			 const struct vfio_device_ops *ops)
 {
 	init_completion(&device->comp);
 	device->dev = dev;
 	device->ops = ops;
-	device->device_data = device_data;
 }
 EXPORT_SYMBOL_GPL(vfio_init_group_dev);
 
@@ -851,15 +850,6 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 	return device;
 }
 
-/*
- * Caller must hold a reference to the vfio_device
- */
-void *vfio_device_data(struct vfio_device *device)
-{
-	return device->device_data;
-}
-EXPORT_SYMBOL_GPL(vfio_device_data);
-
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 784c34c0a28763..a2c5b30e1763ba 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -24,7 +24,6 @@ struct vfio_device {
 	refcount_t refcount;
 	struct completion comp;
 	struct list_head group_next;
-	void *device_data;
 };
 
 /**
@@ -61,12 +60,11 @@ extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops, void *device_data);
+			 const struct vfio_device_ops *ops);
 int vfio_register_group_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
-extern void *vfio_device_data(struct vfio_device *device);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
-- 
2.31.0

