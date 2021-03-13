Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A5F339AA6
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 02:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCMBBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 20:01:17 -0500
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:41185
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229523AbhCMBBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 20:01:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPXyvkF9n1ySi1iKjJkvVh5axzmC2N7kDvCfFIMPZjrCx9ss1Jvtfj//7/A8nHShw4wUY85LKatGLsuoU65QgKsLfK9c4q9YLw657IgzGrYGAabK+ETTR1F7hsXq6vly149RgWHNzznoU4wtXda3zESmhTBcLX5NNgoP4TuWmTe+zj0FNDbg05a1rbhc1NBWdYFYVxhCRAzO/je3rIh2n7WblXlZbbVDrdtpVM3148bp0I2UK14FeG1phvP1xEWA5y48VNmkf1hGzWphTP7Tdh0Ku390Ua4ZI3sHurvt9i2CEYti2ACFhLC+TlwrTyjhgyNoiI/LA1ifX64YqT4yHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IU8zHcIF59YNhZooqAtcNAXQ39MRo5Pfhvw3lFhGAWc=;
 b=FtpRpOhCiovMpAcfhl8WnMhp9xQDFfERMEnJfXLssK577LllkHKa1fjYZmns6bcZjOUCAVR7sabQfW2qdl0JswsZv8UeX5TzsXtgOhklLfzJ1QPrNDfnzwG65kGIOzf0HH8ZkAWl7qjs2r6JokFxucidqEHzF6Jp6xu14WaN+tTXUL8vx0CSZXXDcWoPjSu+lOnC4P7hUEGAmC74W1qns5vWQiJy1/+00S6K3mmnQlrjlIo6JchxpozQYneHypzdg+GrCgA5jpBUaAqucohrr+KzUXGC7xdoFitJAKbh85ywLyrG5xthi9AIs9PxiCYNlEVlNeW4hRPGuA3ds7KnWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IU8zHcIF59YNhZooqAtcNAXQ39MRo5Pfhvw3lFhGAWc=;
 b=bsL4qtJZtGh8mUkjtAammFwU5PQdeb4Gp1vZm+244g2rKl04msPFI2NwQ+f3HZjS/YCW4XG0bkGb1ykV83BREOqBgXTplTSvHaSgAuIn8mOpUzxbvmC4SHGu5iL58TlBYeS459vyKeV0svV8MU0GlaSpFgfQdrjBJQK+79nI5nJMIvGvczN1yloydZgRKDcFerMbrGSRb6vwuUUE79Tknq3lNxWAu0snHnuFZ9IXy9vv3BOKpZYp3rEGmLOXpd5kJb2H1VW8PauZFuIX5klLG/p8kV+NXvdCMPB9F030aJSEN8jMdFGMGXR6fYoeIS7OIplvluSPrrh16nsFxyR+sQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3306.namprd12.prod.outlook.com (2603:10b6:5:186::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Sat, 13 Mar
 2021 01:01:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 01:01:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 12/14] vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of 'void *'
Date:   Fri, 12 Mar 2021 20:56:04 -0400
Message-Id: <12-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:207:3c::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0005.namprd02.prod.outlook.com (2603:10b6:207:3c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 01:01:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBU-7Y; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 419807a8-eb93-44d5-8ebe-08d8e5bb7d65
X-MS-TrafficTypeDiagnostic: DM6PR12MB3306:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3306B90A686EBA4489B951B0C26E9@DM6PR12MB3306.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6nzc0QWUoRqEvlWzLFDlwyX7ULEWYEKmDkKHc87bBA7TLlJTiGhH7+jSdk9fAFru848UQvYf9PrPADOilPRI9ylukWQiLC8jx05L8lTsAzdB2Xrkoo4WN0X49NroQtR3DjXUo9S7gHg4evOxl9Z9DClcBOkcSofCH87c/JY7NytNMPrbxM9MHfNn12JE/E/i3ppWMV99x9KbMdp/lN9ngM+cYtBq7//rBpEBg6AGvOJAQh/sW7jzzhFaJ6xpOznHLD8rSXyjFCT1p+VCB578LJOTknJYtvuhBLIho2Y48em+bzHoXXDmULQFzLRmZONXlI1Z/G9m8caQAvBKaDyNx5/XnHv7bFr5Vkis2LnR7++kSVpGnWshyGWumG+EkHqwjF6OC96LuhbW2I4LiKaypmj1hyqmT4WwU8nNfAe4cDJ2Xni/YNw9+EgkFaQwoYC8CY+2XAl+NNOcOrVw1g6QE/PkJ+gOK4dxC1sYw6spO4yIKysyyLO2CYwFgnoIynm6UrD6XvouX9ggD9pJkU+E5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(30864003)(6666004)(8936002)(110136005)(316002)(54906003)(26005)(426003)(8676002)(9786002)(66556008)(66476007)(86362001)(186003)(83380400001)(478600001)(2616005)(9746002)(4326008)(107886003)(36756003)(66946007)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EBgVb8U/VvxXfXz1iifj9eS3EfrNmBuJSzPpPVAoxUFqZSR/6EcV+v6K4pD2?=
 =?us-ascii?Q?TWP+yT17ZT/5lpJHuE6HlMEcptzOg0+xVTRjow1QVXLVxJaKyV9/TXwz0VyC?=
 =?us-ascii?Q?/4ARXtQpspxfY49XG9VlAGpcgDe1jT5INeN3IFnCWISZwaF4lgqgr8/0jHW+?=
 =?us-ascii?Q?NnTAIhK9EZxEiB1rEx7a6qJm9+rkpVB1M595A8AVHzH8WihUJwcbLII3jZzU?=
 =?us-ascii?Q?8EBmY2oeK0fZzY17dFxNsAxhd5QCjxHWOkSeaQb6gMrHBiZUWyevXhoIIu60?=
 =?us-ascii?Q?ZimjvJvri81mFHrMzDEC8RSv1LwAxWWJb54qVAMojKDpqK7Vp1Vydq/wApDG?=
 =?us-ascii?Q?zrfzGNtWyaUo09o6eD2BqXtlycWkZKqEDoQwtzgFjQpM7XzOulL89jf4zTL6?=
 =?us-ascii?Q?WpLq8qLEEFT9tgq4lth37qvvXHerVfiiDrP90JS/d/gfyI9AOFmkkxuhg4h+?=
 =?us-ascii?Q?uZXyiuUkN/ZdYWvV5aSaEbH+Uepe+FIz1wEQ//MPIQOw5TnLy4v+C7hfXgIe?=
 =?us-ascii?Q?sQ50QBTsH/ezAX4lJzUxrU03WR14n3tjx8V2V8jDPhSOXCYbrOVkydFcHhew?=
 =?us-ascii?Q?klSh7XM8xrbm7PcJXHlxGPhjJba99vFQTFXy+zGpr5WqsHa1/sPM8+Q6W15y?=
 =?us-ascii?Q?irrOmUXHY8q01NJlSb18Lw7vT6aFktjaA/H+AtzB8hc57uXaEl3aVoAsLZEf?=
 =?us-ascii?Q?Tme5lCedN+F4gqSuZuvj5shWzOiGhBnTkyUjnLRFdgwZIaf58yz33Y+kF+sr?=
 =?us-ascii?Q?t8zVTBf2tFb6Y+g5ZhJPkizRaf836L1TL7ZkQu0X28H8snRerzmFEE0447xo?=
 =?us-ascii?Q?xDa8p07QI9GvQkvUy6/sVUT2TTP687pXyFxKbZ1mnZ2d8PN15vkVTd1lzjeJ?=
 =?us-ascii?Q?bKVk5G2/uX5Dv9vfbRUbJEJJZCFEIkVshBNytdIRRZHxMbzcOoHWKKlnEI9A?=
 =?us-ascii?Q?P4J+UHJlRps92dwI6RLA2CYVT2DyYu+HWRMynP3drWa4VfnM8QZtditS04Ae?=
 =?us-ascii?Q?Y5mcn5i/97F4nTM1jX2bbBgUQqqVuzEuh0uk134Db9F9l8gXSRvlwrBwlUGt?=
 =?us-ascii?Q?51yMenk96/+V6Cgu9mjdzPCIU6ldikYahHVPplwX/g8w8joJ0O7CgTgf2vyd?=
 =?us-ascii?Q?cNzy2bINcF+cYNEIy1qm9MYFh0kkg3AHLOE+y8VKtBRhpQXgQ3RZ08GgowMx?=
 =?us-ascii?Q?IAaNovEhvXFZyXBZUlS/ZhPCSR6UglNlnt9DhZSNm4fSDkraiOQ6F1fVvhBH?=
 =?us-ascii?Q?USgAMzBAKv2C1XA7chXtOt7O9XJci5HmWF24ihh5tvXS9PtP12Z0U8qiocTE?=
 =?us-ascii?Q?3RFjNsCSI7nFokejCaZ60LyvZp8vJncdLuAdoImqSzdswA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419807a8-eb93-44d5-8ebe-08d8e5bb7d65
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 01:01:10.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1rkT4+ra3IrDT8s9jx8hsVE/18C5M7OmizUyBxEb+tWXlmdxLm+M9Pl7VgntqpcB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3306
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the standard kernel pattern, the ops associated with a struct get
the struct pointer in for typesafety. The expected design is to use
container_of to cleanly go from the subsystem level type to the driver
level type without having any type erasure in a void *.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst            | 18 ++++----
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 36 +++++++++------
 drivers/vfio/mdev/vfio_mdev.c                | 33 +++++++-------
 drivers/vfio/pci/vfio_pci.c                  | 47 ++++++++++++--------
 drivers/vfio/platform/vfio_platform_common.c | 33 ++++++++------
 drivers/vfio/vfio.c                          | 20 ++++-----
 include/linux/vfio.h                         | 16 +++----
 7 files changed, 117 insertions(+), 86 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index d3a02300913a7f..3337f337293a32 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -269,20 +269,22 @@ ready before calling it. The driver provides an ops structure for callbacks
 similar to a file operations structure::
 
 	struct vfio_device_ops {
-		int	(*open)(void *device_data);
-		void	(*release)(void *device_data);
-		ssize_t	(*read)(void *device_data, char __user *buf,
+		int	(*open)(struct vfio_device *vdev);
+		void	(*release)(struct vfio_device *vdev);
+		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 				size_t count, loff_t *ppos);
-		ssize_t	(*write)(void *device_data, const char __user *buf,
+		ssize_t	(*write)(struct vfio_device *vdev,
+				 const char __user *buf,
 				 size_t size, loff_t *ppos);
-		long	(*ioctl)(void *device_data, unsigned int cmd,
+		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 				 unsigned long arg);
-		int	(*mmap)(void *device_data, struct vm_area_struct *vma);
+		int	(*mmap)(struct vfio_device *vdev,
+				struct vm_area_struct *vma);
 	};
 
-Each function is passed the device_data that was originally registered
+Each function is passed the vdev that was originally registered
 in the vfio_register_group_dev() call above.  This allows the bus driver
-an easy place to store its opaque, private data.  The open/release
+to obtain its private data using container_of().  The open/release
 callbacks are issued when a new file descriptor is created for a
 device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
 a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 87ea8368aa510a..023b2222806424 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -135,9 +135,10 @@ static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
 	kfree(vdev->regions);
 }
 
-static int vfio_fsl_mc_open(void *device_data)
+static int vfio_fsl_mc_open(struct vfio_device *core_vdev)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	int ret;
 
 	if (!try_module_get(THIS_MODULE))
@@ -161,9 +162,10 @@ static int vfio_fsl_mc_open(void *device_data)
 	return ret;
 }
 
-static void vfio_fsl_mc_release(void *device_data)
+static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	int ret;
 
 	mutex_lock(&vdev->reflck->lock);
@@ -197,11 +199,12 @@ static void vfio_fsl_mc_release(void *device_data)
 	module_put(THIS_MODULE);
 }
 
-static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
-			      unsigned long arg)
+static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
+			      unsigned int cmd, unsigned long arg)
 {
 	unsigned long minsz;
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
 
 	switch (cmd) {
@@ -327,10 +330,11 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 }
 
-static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
+static ssize_t vfio_fsl_mc_read(struct vfio_device *core_vdev, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
@@ -404,10 +408,12 @@ static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t *cmd_data)
 	return 0;
 }
 
-static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
-				 size_t count, loff_t *ppos)
+static ssize_t vfio_fsl_mc_write(struct vfio_device *core_vdev,
+				 const char __user *buf, size_t count,
+				 loff_t *ppos)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
@@ -468,9 +474,11 @@ static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
 			       size, vma->vm_page_prot);
 }
 
-static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_fsl_mc_mmap(struct vfio_device *core_vdev,
+			    struct vm_area_struct *vma)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
 	unsigned int index;
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 4469aaf31b56cb..e7309caa99c71b 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -25,10 +25,11 @@ struct mdev_vfio_device {
 	struct vfio_device vdev;
 };
 
-static int vfio_mdev_open(void *device_data)
+static int vfio_mdev_open(struct vfio_device *core_vdev)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
+
 	int ret;
 
 	if (unlikely(!parent->ops->open))
@@ -44,9 +45,9 @@ static int vfio_mdev_open(void *device_data)
 	return ret;
 }
 
-static void vfio_mdev_release(void *device_data)
+static void vfio_mdev_release(struct vfio_device *core_vdev)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (likely(parent->ops->release))
@@ -55,10 +56,10 @@ static void vfio_mdev_release(void *device_data)
 	module_put(THIS_MODULE);
 }
 
-static long vfio_mdev_unlocked_ioctl(void *device_data,
+static long vfio_mdev_unlocked_ioctl(struct vfio_device *core_vdev,
 				     unsigned int cmd, unsigned long arg)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->ioctl))
@@ -67,10 +68,10 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
 	return parent->ops->ioctl(mdev, cmd, arg);
 }
 
-static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
+static ssize_t vfio_mdev_read(struct vfio_device *core_vdev, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->read))
@@ -79,10 +80,11 @@ static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
 	return parent->ops->read(mdev, buf, count, ppos);
 }
 
-static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
-			       size_t count, loff_t *ppos)
+static ssize_t vfio_mdev_write(struct vfio_device *core_vdev,
+			       const char __user *buf, size_t count,
+			       loff_t *ppos)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->write))
@@ -91,9 +93,10 @@ static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
 	return parent->ops->write(mdev, buf, count, ppos);
 }
 
-static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_mdev_mmap(struct vfio_device *core_vdev,
+			  struct vm_area_struct *vma)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->mmap))
@@ -102,9 +105,9 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
-static void vfio_mdev_request(void *device_data, unsigned int count)
+static void vfio_mdev_request(struct vfio_device *core_vdev, unsigned int count)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (parent->ops->request)
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a0ac20a499cf6c..5f1a782d1c65ae 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -553,9 +553,10 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 	vfio_device_put(pf_dev);
 }
 
-static void vfio_pci_release(void *device_data)
+static void vfio_pci_release(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 
 	mutex_lock(&vdev->reflck->lock);
 
@@ -581,9 +582,10 @@ static void vfio_pci_release(void *device_data)
 	module_put(THIS_MODULE);
 }
 
-static int vfio_pci_open(void *device_data)
+static int vfio_pci_open(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	int ret = 0;
 
 	if (!try_module_get(THIS_MODULE))
@@ -797,10 +799,11 @@ struct vfio_devices {
 	int max_index;
 };
 
-static long vfio_pci_ioctl(void *device_data,
+static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	unsigned long minsz;
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
@@ -1402,11 +1405,10 @@ static long vfio_pci_ioctl(void *device_data,
 	return -ENOTTY;
 }
 
-static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
+static ssize_t vfio_pci_rw(struct vfio_pci_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	struct vfio_pci_device *vdev = device_data;
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
@@ -1434,22 +1436,28 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
+
 	if (!count)
 		return 0;
 
-	return vfio_pci_rw(device_data, buf, count, ppos, false);
+	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
+
 	if (!count)
 		return 0;
 
-	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
+	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
@@ -1646,9 +1654,10 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
@@ -1714,9 +1723,10 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return 0;
 }
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 
 	mutex_lock(&vdev->igate);
@@ -1830,9 +1840,10 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(void *device_data, char *buf)
+static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	bool vf_token = false;
 	uuid_t uuid;
 	int ret;
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 6eb749250ee41c..f5f6b537084a67 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -218,9 +218,10 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
 	return -EINVAL;
 }
 
-static void vfio_platform_release(void *device_data)
+static void vfio_platform_release(struct vfio_device *core_vdev)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 
 	mutex_lock(&driver_lock);
 
@@ -244,9 +245,10 @@ static void vfio_platform_release(void *device_data)
 	module_put(vdev->parent_module);
 }
 
-static int vfio_platform_open(void *device_data)
+static int vfio_platform_open(struct vfio_device *core_vdev)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	int ret;
 
 	if (!try_module_get(vdev->parent_module))
@@ -293,10 +295,12 @@ static int vfio_platform_open(void *device_data)
 	return ret;
 }
 
-static long vfio_platform_ioctl(void *device_data,
+static long vfio_platform_ioctl(struct vfio_device *core_vdev,
 				unsigned int cmd, unsigned long arg)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
+
 	unsigned long minsz;
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
@@ -455,10 +459,11 @@ static ssize_t vfio_platform_read_mmio(struct vfio_platform_region *reg,
 	return -EFAULT;
 }
 
-static ssize_t vfio_platform_read(void *device_data, char __user *buf,
-				  size_t count, loff_t *ppos)
+static ssize_t vfio_platform_read(struct vfio_device *core_vdev,
+				  char __user *buf, size_t count, loff_t *ppos)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
 
@@ -531,10 +536,11 @@ static ssize_t vfio_platform_write_mmio(struct vfio_platform_region *reg,
 	return -EFAULT;
 }
 
-static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
+static ssize_t vfio_platform_write(struct vfio_device *core_vdev, const char __user *buf,
 				   size_t count, loff_t *ppos)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
 
@@ -573,9 +579,10 @@ static int vfio_platform_mmap_mmio(struct vfio_platform_region region,
 			       req_len, vma->vm_page_prot);
 }
 
-static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_platform_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	unsigned int index;
 
 	index = vma->vm_pgoff >> (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2d6d7cc1d1ebf9..01de47d1810b6b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -832,7 +832,7 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 		int ret;
 
 		if (it->ops->match) {
-			ret = it->ops->match(it->device_data, buf);
+			ret = it->ops->match(it, buf);
 			if (ret < 0) {
 				device = ERR_PTR(ret);
 				break;
@@ -893,7 +893,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
 		if (device->ops->request)
-			device->ops->request(device->device_data, i++);
+			device->ops->request(device, i++);
 
 		if (interrupted) {
 			rc = wait_for_completion_timeout(&device->comp,
@@ -1379,7 +1379,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
-	ret = device->ops->open(device->device_data);
+	ret = device->ops->open(device);
 	if (ret) {
 		vfio_device_put(device);
 		return ret;
@@ -1391,7 +1391,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 */
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0) {
-		device->ops->release(device->device_data);
+		device->ops->release(device);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1401,7 +1401,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(filep)) {
 		put_unused_fd(ret);
 		ret = PTR_ERR(filep);
-		device->ops->release(device->device_data);
+		device->ops->release(device);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1558,7 +1558,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
 
-	device->ops->release(device->device_data);
+	device->ops->release(device);
 
 	vfio_group_try_dissolve_container(device->group);
 
@@ -1575,7 +1575,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	if (unlikely(!device->ops->ioctl))
 		return -EINVAL;
 
-	return device->ops->ioctl(device->device_data, cmd, arg);
+	return device->ops->ioctl(device, cmd, arg);
 }
 
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
@@ -1586,7 +1586,7 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
 
-	return device->ops->read(device->device_data, buf, count, ppos);
+	return device->ops->read(device, buf, count, ppos);
 }
 
 static ssize_t vfio_device_fops_write(struct file *filep,
@@ -1598,7 +1598,7 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
 
-	return device->ops->write(device->device_data, buf, count, ppos);
+	return device->ops->write(device, buf, count, ppos);
 }
 
 static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
@@ -1608,7 +1608,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
 
-	return device->ops->mmap(device->device_data, vma);
+	return device->ops->mmap(device, vma);
 }
 
 static const struct file_operations vfio_device_fops = {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4995faf51efeae..784c34c0a28763 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -44,17 +44,17 @@ struct vfio_device {
  */
 struct vfio_device_ops {
 	char	*name;
-	int	(*open)(void *device_data);
-	void	(*release)(void *device_data);
-	ssize_t	(*read)(void *device_data, char __user *buf,
+	int	(*open)(struct vfio_device *vdev);
+	void	(*release)(struct vfio_device *vdev);
+	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos);
-	ssize_t	(*write)(void *device_data, const char __user *buf,
+	ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
 			 size_t count, loff_t *size);
-	long	(*ioctl)(void *device_data, unsigned int cmd,
+	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 			 unsigned long arg);
-	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
-	void	(*request)(void *device_data, unsigned int count);
-	int	(*match)(void *device_data, char *buf);
+	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
+	void	(*request)(struct vfio_device *vdev, unsigned int count);
+	int	(*match)(struct vfio_device *vdev, char *buf);
 };
 
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
-- 
2.30.2

