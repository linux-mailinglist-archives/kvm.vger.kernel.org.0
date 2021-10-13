Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD42542C327
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbhJMOaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:30:06 -0400
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:8800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235412AbhJMOaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:30:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioa1aA+j828jLlwrFE4Rv3OPVlk3d9bH/S5I0DRe86p76k6+Xj0Xmp1/BiS1sMAk/ViO6qlZiGZ1Nb82qTjTpLZgbTdlAYpJE1WAmiTfMJqGHIhabAAJRyht9plzIz9kRRXWEyIEqZ6/ubo4+wcQviBHAp8/KRScp0YpV5ogUc8Xkx2EwU/CWNszotSyjcKprlKQSelP7RH7SR3J2qs4NXTmz+DWkbJ6JoCjxRmJDj2S/YHe3mOJ1wrkn55D/0YTzLxuHfuFMBYfrNotABlNYcfrAW1zIRvsAyQ2bfNkYyVuS/UfAYFGyQ3prMWSNHKVn+TLys5sUF5XOT0lSxw0qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nNNW95jAdtnqzOha4dojOxnE9MTjgYwJBIcYRZfUNPU=;
 b=W9BctGQqe+ST8KvY7m6WHkO5K6ek9ryKPv1bzmxISGGb7F2ZTHbNV2CNUwM9IM0D3P3f6zUplr+l6Gn9nOjxNAOQPkSW3Y9mOHgB6c9sxO2o+uDm2VzRq1GzCWlHFe/KfYhQNx701uZANWg0FkvDBBo8EG37MO1AKFL8g44aJh/nh4bb680kecQqUbbYW5ATkxY1RM9yiALE71QNtJ9bOTUKYBTOjGRpmCBDtPVbRrDSvWIrCWm6Gyza/eXl/t8ZmxcFMe58rz9cT9PU+QrOKEXPpIIAhIR3SI5gtkGvLXGgrowQJfEqpHSyfUP+6vA2NVac76YDflPxOUyIhiuJeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNNW95jAdtnqzOha4dojOxnE9MTjgYwJBIcYRZfUNPU=;
 b=Qag70eSYx3ET8Ik2MydavVzBfaGPTu0Iqy994NkeqgJrcVbcsRyRY/h8UjlxuBgH014HMEUg8C11VaugSz3DzMgp2aOWsxobfohEpjQCnfC8lwlE8c5hPXHyLR6NliYalR5gZ+w43ZzXjNEgUBKtmBNbpoJ1Nwt2fGeiE926/hzTyyqYP6gaaZe9LBEp5N8EjqpkH1jyL7CSWBW3t4viTj/laI89prYSYYEI9WL5KGh9ErM0RthrPvXMDmmyFfPfDBAnrL+M5rmuBLP8qBKWzMuWn0+hW9VnUTDpsIbZ+k6OFMmBsqDJmFHo4FLzYeZdBbiLSi1b4JD0A77jhcEKZg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 13 Oct
 2021 14:27:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 14:27:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 5/5] vfio: Use cdev_device_add() instead of device_create()
Date:   Wed, 13 Oct 2021 11:27:50 -0300
Message-Id: <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT2PR01CA0023.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 14:27:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mafEU-00EVFO-A6; Wed, 13 Oct 2021 11:27:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeb3f88f-ebca-46a9-048d-08d98e55a4a0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5287EDF297ECC89D0F68B703C2B79@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:381;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVPVaEkiIteo45tnucc2j39q5pnpLR74muNmJmLPXn4wO2etvnkVZ/hXAQhXKBthqQPkdUfnuKBVZisr5eElSop4AsMMz5H7CtKngOejCjZC8w4WhiOYqGNm/3eIKO34s3mxXO6kzeq9SFzf97ol8kWMUXHg7ADEnVq9hIXn6Z2mSoEVyoRez6bTQi2f/KvwzvFPFtJcWKtGUHeKTQaLGCLmauxCepEu98c3rGis2R1q0p6D5ZB9+XrqWkqs6IE8eapqW/WVgMN4d2Sn537iVjhahKf/IxjsLFzYBq7mXqbubcdHl1YrOgqsO7CqHFJ9X8zBzqzGVEtRTDegfsEFS2y+5yZ1W6lrLVpBa/bmjqP9kLF7RAMvsaWydn+wlFNb7hVyVfkP5modvmlkIm07GC7HM5RtmeX6El78yF+uz2O1+Bk+zUgGO6rYKWWHMXUBT2mIFt+Ceo672MJwObKK2VXAGkO5hN9aK13MQXkb3v8uiz3vjFifxYeixlsIfBJsdmcTKPntz6t6Hq8XGOCK1NaAMigU5fLUzp86jRTLbElw9fwnyqjm13vMBxo3F1pDQNUgkCD5eBOfVWTRw6CVMsOexf8tDHsejkG2oxXtfIbkPstEgE1/fz7yYNV4t6VHzKW2meEukY3VCRuEIecNQCIByhtDtbAuzuT483r2Kv9z65v5rLfl49F+V181DD33+F449it8riCMLahVv60Zbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(83380400001)(86362001)(30864003)(186003)(9746002)(316002)(2906002)(9786002)(508600001)(66556008)(36756003)(8936002)(426003)(66476007)(110136005)(4326008)(2616005)(54906003)(66946007)(38100700002)(8676002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?01Sfl3V7fiYWwbXWafJHOktOtiqtL4KLcATG0BLj2/0IpWHJQV48k5iZw+zw?=
 =?us-ascii?Q?2acOfZE22n+1RZZY0PWQfVVdFljjda13XYFwsxB38rXMEkU5hdIcQBQW8WLc?=
 =?us-ascii?Q?U5Q3tpaDfoQqGwGFZmXV8Sd5CeYJoMTuZy5w39bE4XYugFKLIZo3lMVf0Yph?=
 =?us-ascii?Q?bV0ArhbvGC3jx9Hz7iAcYvwgCZA6qENnw0jmPIt4mma6hSYCkNGuLoZ+ZwQb?=
 =?us-ascii?Q?zxrWpX8plcQrraGZxwOJ0z2t4B3Wney95mqv8ecPD0pGTE3x11JrEqxx9CY0?=
 =?us-ascii?Q?qXMQYTFcuY7O0g0niP2ws2M8KpWQT4/awQWyvyknKS0JNTF8GhUt9oY1D4Ph?=
 =?us-ascii?Q?/KCGgmaDruwLr2+lIOEcM6Y0IeMkLBh3RNLDGlBuFIW0MBg2oXbtPNjMKVdf?=
 =?us-ascii?Q?1+wKhxJeoxV7c5H3jsouE7J8z7hCevg/1BgjdIQxXDG/CIerYkt0nwaLSRzV?=
 =?us-ascii?Q?bhCLlqZl4wt1oAGWnBqlulPKXTMq4tnm4t32Bwc3ojW0riD4p9/6mXOse5+2?=
 =?us-ascii?Q?qLxRNbtU3GrCzhyDuTMYfSizpPY4dYs/+NP2zD8vgTRq9rtkVjG+HFBcpwUW?=
 =?us-ascii?Q?61Cz2M7hTJz+4aPfsJoqgrFEv4UYQZ7P15ZRlO13bbsmRmZe3Zfa6te9wgdj?=
 =?us-ascii?Q?TnnI0a5NzuxHGc0fnVORi70e7GjD9o7LQ0VEv2S4Z33uyihOWLmdbK7T6DGG?=
 =?us-ascii?Q?fmVCCfJWerh1Y/XhCu2QEl2axMnB4bMicKwHDo0eo7I9BKwrXP/x5ml6VXjO?=
 =?us-ascii?Q?T0/fDejHGtr4mJRxoNavHJrd+vTmqQcVBE23dJcCSWx5yi/bvcIZ2KCUPqnM?=
 =?us-ascii?Q?UaAYn+n0HqUelmnWKvLn79drLZ/IsG98nAFL3FNf6X0y0x0DM/qbgXvxDCYR?=
 =?us-ascii?Q?j8aHKL3W1TiiZ4m1ZYYxkmX/TUd0lsHuBpL0cjyRoWcDFUrVl+Av96gN8Fkc?=
 =?us-ascii?Q?08j0v0uV5ISlW2SzeDDGkCDKhuDNwaRFZRuSjrUxqowlYCdRHyox7Lhu+x2J?=
 =?us-ascii?Q?QSNBQQwSd/6dTyu8d/LBUSNCaVHJrLCEkMjdzecBmXgyn87ULCzCdOqt0Ujy?=
 =?us-ascii?Q?cPkqOeRIyjhcaS2J5BDlVZkQ9JyWV2Z15knzPeyxKbeJmzFv76XK3TRPzgTg?=
 =?us-ascii?Q?/BRRBGpDgHAdYsMyt+Yi36FEiBYeIWChhmg/Jk7NZ6cxCOQC+Kb3Yg/pS7uz?=
 =?us-ascii?Q?1FixeW2TTJUUBjW0i302u4JYpLuU2EDAsi2el34t4HdVORGgAjlTaw+5Zz3A?=
 =?us-ascii?Q?Mn+CDFiPS0O+FbdKk7YgMVY5KBMchodCNLNNdQt8Mig6DfLLVozS6udc2lFd?=
 =?us-ascii?Q?FgfHBA/ws1xlQrvnNARCY6m3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb3f88f-ebca-46a9-048d-08d98e55a4a0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:27:53.7340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YW6bgZ9opXL/LdSntdQo0xQ7FPyQS0vu2A1Ld/jrfLyJnZ4nKsUHnP/DanoL9Kb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modernize how vfio is creating the group char dev and sysfs presence.

These days drivers with state should use cdev_device_add() and
cdev_device_del() to manage the cdev and sysfs lifetime.

This API requires the driver to put the struct device and struct cdev
inside its state struct (vfio_group), and then use the usual
device_initialize()/cdev_device_add()/cdev_device_del() sequence.

Split the code to make this possible:

 - vfio_group_alloc()/vfio_group_release() are pair'd functions to
   alloc/free the vfio_group. release is done under the struct device
   kref.

 - vfio_create_group()/vfio_group_put() are pairs that manage the
   sysfs/cdev lifetime. Once the uses count is zero the vfio group's
   userspace presence is destroyed.

 - The IDR is replaced with an IDA. container_of(inode->i_cdev)
   is used to get back to the vfio_group during fops open. The IDA
   assigns unique minor numbers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 192 ++++++++++++++++++++++----------------------
 1 file changed, 94 insertions(+), 98 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 60fabd4252ac66..528a98fa267120 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -43,9 +43,8 @@ static struct vfio {
 	struct list_head		iommu_drivers_list;
 	struct mutex			iommu_drivers_lock;
 	struct list_head		group_list;
-	struct idr			group_idr;
-	struct mutex			group_lock;
-	struct cdev			group_cdev;
+	struct mutex			group_lock; /* locks group_list */
+	struct ida			group_ida;
 	dev_t				group_devt;
 } vfio;
 
@@ -69,14 +68,14 @@ struct vfio_unbound_dev {
 };
 
 struct vfio_group {
+	struct device 			dev;
+	struct cdev			cdev;
 	refcount_t			users;
-	int				minor;
 	atomic_t			container_users;
 	struct iommu_group		*iommu_group;
 	struct vfio_container		*container;
 	struct list_head		device_list;
 	struct mutex			device_lock;
-	struct device			*dev;
 	struct notifier_block		nb;
 	struct list_head		vfio_next;
 	struct list_head		container_next;
@@ -98,6 +97,7 @@ MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  Thi
 #endif
 
 static DEFINE_XARRAY(vfio_device_set_xa);
+static const struct file_operations vfio_group_fops;
 
 int vfio_assign_device_set(struct vfio_device *device, void *set_id)
 {
@@ -281,19 +281,6 @@ void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_iommu_driver);
 
-/**
- * Group minor allocation/free - both called with vfio.group_lock held
- */
-static int vfio_alloc_group_minor(struct vfio_group *group)
-{
-	return idr_alloc(&vfio.group_idr, group, 0, MINORMASK + 1, GFP_KERNEL);
-}
-
-static void vfio_free_group_minor(int minor)
-{
-	idr_remove(&vfio.group_idr, minor);
-}
-
 static int vfio_iommu_group_notifier(struct notifier_block *nb,
 				     unsigned long action, void *data);
 static void vfio_group_get(struct vfio_group *group);
@@ -322,22 +309,6 @@ static void vfio_container_put(struct vfio_container *container)
 	kref_put(&container->kref, vfio_container_release);
 }
 
-static void vfio_group_unlock_and_free(struct vfio_group *group)
-{
-	struct vfio_unbound_dev *unbound, *tmp;
-
-	mutex_unlock(&vfio.group_lock);
-	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
-
-	list_for_each_entry_safe(unbound, tmp,
-				 &group->unbound_list, unbound_next) {
-		list_del(&unbound->unbound_next);
-		kfree(unbound);
-	}
-	iommu_group_put(group->iommu_group);
-	kfree(group);
-}
-
 /**
  * Group objects - create, release, get, put, search
  */
@@ -366,71 +337,112 @@ vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 	return group;
 }
 
-static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
-		enum vfio_group_type type)
+static void vfio_group_release(struct device *dev)
 {
-	struct vfio_group *group, *existing_group;
-	struct device *dev;
-	int ret, minor;
+	struct vfio_group *group = container_of(dev, struct vfio_group, dev);
+	struct vfio_unbound_dev *unbound, *tmp;
+
+	list_for_each_entry_safe(unbound, tmp,
+				 &group->unbound_list, unbound_next) {
+		list_del(&unbound->unbound_next);
+		kfree(unbound);
+	}
+
+	mutex_destroy(&group->device_lock);
+	mutex_destroy(&group->unbound_lock);
+	iommu_group_put(group->iommu_group);
+	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
+	kfree(group);
+}
+
+static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
+					   enum vfio_group_type type)
+{
+	struct vfio_group *group;
+	int minor;
 
 	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
+	minor = ida_alloc_max(&vfio.group_ida, MINORMASK, GFP_KERNEL);
+	if (minor < 0) {
+		kfree(group);
+		return ERR_PTR(minor);
+	}
+
+	device_initialize(&group->dev);
+	group->dev.devt = MKDEV(MAJOR(vfio.group_devt), minor);
+	group->dev.class = vfio.class;
+	group->dev.release = vfio_group_release;
+	cdev_init(&group->cdev, &vfio_group_fops);
+	group->cdev.owner = THIS_MODULE;
+
 	refcount_set(&group->users, 1);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	INIT_LIST_HEAD(&group->unbound_list);
 	mutex_init(&group->unbound_lock);
-	atomic_set(&group->container_users, 0);
-	atomic_set(&group->opened, 0);
 	init_waitqueue_head(&group->container_q);
 	group->iommu_group = iommu_group;
-	/* put in vfio_group_unlock_and_free() */
+	/* put in vfio_group_release() */
 	iommu_group_ref_get(iommu_group);
 	group->type = type;
 	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
+	return group;
+}
+
+static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
+		enum vfio_group_type type)
+{
+	struct vfio_group *group;
+	struct vfio_group *ret;
+	int err;
+
+	group = vfio_group_alloc(iommu_group, type);
+	if (IS_ERR(group))
+		return group;
+
+	err = dev_set_name(&group->dev, "%s%d",
+			   group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
+			   iommu_group_id(iommu_group));
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_put;
+	}
+
 	group->nb.notifier_call = vfio_iommu_group_notifier;
-	ret = iommu_group_register_notifier(iommu_group, &group->nb);
-	if (ret) {
-		iommu_group_put(iommu_group);
-		kfree(group);
-		return ERR_PTR(ret);
+	err = iommu_group_register_notifier(iommu_group, &group->nb);
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_put;
 	}
 
 	mutex_lock(&vfio.group_lock);
 
 	/* Did we race creating this group? */
-	existing_group = __vfio_group_get_from_iommu(iommu_group);
-	if (existing_group) {
-		vfio_group_unlock_and_free(group);
-		return existing_group;
-	}
+	ret = __vfio_group_get_from_iommu(iommu_group);
+	if (ret)
+		goto err_unlock;
 
-	minor = vfio_alloc_group_minor(group);
-	if (minor < 0) {
-		vfio_group_unlock_and_free(group);
-		return ERR_PTR(minor);
+	err = cdev_device_add(&group->cdev, &group->dev);
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_unlock;
 	}
 
-	dev = device_create(vfio.class, NULL,
-			    MKDEV(MAJOR(vfio.group_devt), minor), group, "%s%d",
-			    group->type == VFIO_NO_IOMMU ? "noiommu-" : "",
-			    iommu_group_id(iommu_group));
-	if (IS_ERR(dev)) {
-		vfio_free_group_minor(minor);
-		vfio_group_unlock_and_free(group);
-		return ERR_CAST(dev);
-	}
-
-	group->minor = minor;
-	group->dev = dev;
-
 	list_add(&group->vfio_next, &vfio.group_list);
 
 	mutex_unlock(&vfio.group_lock);
 	return group;
+
+err_unlock:
+	mutex_unlock(&vfio.group_lock);
+	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
+err_put:
+	put_device(&group->dev);
+	return ret;
 }
 
 static void vfio_group_put(struct vfio_group *group)
@@ -448,10 +460,12 @@ static void vfio_group_put(struct vfio_group *group)
 	WARN_ON(atomic_read(&group->container_users));
 	WARN_ON(group->notifier.head);
 
-	device_destroy(vfio.class, MKDEV(MAJOR(vfio.group_devt), group->minor));
 	list_del(&group->vfio_next);
-	vfio_free_group_minor(group->minor);
-	vfio_group_unlock_and_free(group);
+	cdev_device_del(&group->cdev, &group->dev);
+	mutex_unlock(&vfio.group_lock);
+
+	iommu_group_unregister_notifier(group->iommu_group, &group->nb);
+	put_device(&group->dev);
 }
 
 static void vfio_group_get(struct vfio_group *group)
@@ -459,20 +473,10 @@ static void vfio_group_get(struct vfio_group *group)
 	refcount_inc(&group->users);
 }
 
-static struct vfio_group *vfio_group_get_from_minor(int minor)
+/* returns true if the get was obtained */
+static bool vfio_group_try_get(struct vfio_group *group)
 {
-	struct vfio_group *group;
-
-	mutex_lock(&vfio.group_lock);
-	group = idr_find(&vfio.group_idr, minor);
-	if (!group) {
-		mutex_unlock(&vfio.group_lock);
-		return NULL;
-	}
-	vfio_group_get(group);
-	mutex_unlock(&vfio.group_lock);
-
-	return group;
+	return refcount_inc_not_zero(&group->users);
 }
 
 static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
@@ -1481,11 +1485,11 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
 static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
-	struct vfio_group *group;
+	struct vfio_group *group =
+		container_of(inode->i_cdev, struct vfio_group, cdev);
 	int opened;
 
-	group = vfio_group_get_from_minor(iminor(inode));
-	if (!group)
+	if (!vfio_group_try_get(group))
 		return -ENODEV;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
@@ -2295,7 +2299,7 @@ static int __init vfio_init(void)
 {
 	int ret;
 
-	idr_init(&vfio.group_idr);
+	ida_init(&vfio.group_ida);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
@@ -2320,11 +2324,6 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-	cdev_init(&vfio.group_cdev, &vfio_group_fops);
-	ret = cdev_add(&vfio.group_cdev, vfio.group_devt, MINORMASK + 1);
-	if (ret)
-		goto err_cdev_add;
-
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -2332,8 +2331,6 @@ static int __init vfio_init(void)
 #endif
 	return 0;
 
-err_cdev_add:
-	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
@@ -2349,8 +2346,7 @@ static void __exit vfio_cleanup(void)
 #ifdef CONFIG_VFIO_NOIOMMU
 	vfio_unregister_iommu_driver(&vfio_noiommu_ops);
 #endif
-	idr_destroy(&vfio.group_idr);
-	cdev_del(&vfio.group_cdev);
+	ida_destroy(&vfio.group_ida);
 	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 	class_destroy(vfio.class);
 	vfio.class = NULL;
-- 
2.33.0

