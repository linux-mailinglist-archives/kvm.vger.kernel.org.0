Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7605241F82B
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 01:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhJAXYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 19:24:16 -0400
Received: from mail-dm3nam07on2074.outbound.protection.outlook.com ([40.107.95.74]:12768
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231178AbhJAXYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 19:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1D8/3HcoGV3W0hiV5Hy6vDtsBqr4kLLYTzU8QDDEJqFfUCC5QJUZZQcA1AMDzD/R/AZoRcmPyycQjrTu14s3TsDu1OPsaWu+LEgVAVb8hgUZkjXJZjuN6OFnh40JpYOp2VsMR8aQVDnaco++IWKnwj0lf5uJbQoMOmyHuzFyLAMzwwXN2PtvX41hxPIPKLpDRLjKldGK4Sg/of34bxvIBRKEN2huGjc0/C2N+sulZyI+dkC+qxq10JEugnk9uveKD4FONCm4I7wK5yEFAwHopH8bLG4WsqeYAJiQ0OOcZpeNMNlfFU3ekk6hNIgisOgzuTZ7qDahgc0g710vvEwKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1uUKsP/iGY7G6uhdPJp9ntcJ0xN/EQsu7R5rFAkhnY=;
 b=Q2SAOlbL+7skDxyVJXhtEHKb/J1RAxV8LU4tpGRKxELc5xN35u2YVL5jkGgM8Tbu06IzVmsWa1Kxbct2AaDMeXoWNNeHq9CBETY9OOPtCIsD5crGHu22fpgWrxRten4iPxgMEhAAC6hW8zfmGC9UL+XpdRJHum+l+UnF+JE27yi/Sh8EituDDtc/44rkETWAGuPxSf/E80egQ4XP5FKS83Vp/1T5tzs3CPBFQUCvA354Jzc9N2MdhStGrRh1gf+40o3RlcDPC91f7A2DY7qscsmZvNLpbujwtsr1No0uv/yDKe3VbKjtTjVpYM6tdgnsJovpiQfHNSe8lTRw5gujSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1uUKsP/iGY7G6uhdPJp9ntcJ0xN/EQsu7R5rFAkhnY=;
 b=AWP0rGdk3rOjYfGOzcQofxWyHMJEFHxNEw//XpiOUUxw5P2pYHOAQxlEusMzUrgzgkzcDG8IFcEdITbvHThaUQrmIwGugHexy8vWCYy0liCZGx3G5kcSd9ira2lbQiVMNWZm3LmoZyFyi57AmiRVjkGNdGqDROLUhXXUTOqdhmwjJCTGxmg6Ao9fKdKpLiNSSbrkS4g6gguL0rVyoZP1PyjGZ2u/rMJezYuW+yhkaY1JkiWaoDjQ2O5M4M50+YCCrIZ5tqR5/13uYGLkPg4KV86+le8gcJ0pVBLDQNcnTT94YSqP7ueQMhSqxOfttYbXTCe2l8YRKJoI9BJBs0mmQA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 23:22:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 23:22:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH 5/5] vfio: Use cdev_device_add() instead of device_create()
Date:   Fri,  1 Oct 2021 20:22:24 -0300
Message-Id: <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0450.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0450.namprd13.prod.outlook.com (2603:10b6:208:2c3::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Fri, 1 Oct 2021 23:22:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWRrE-009Z5k-Aq; Fri, 01 Oct 2021 20:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0ca5ed0-2003-43d8-3558-08d98532547e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362D16EBDF4A0EE58731023C2AB9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:381;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4vAHcVuKuFk/POJhFU/s53LVGDgjslunWzu3c7vPhThAn3boThDZ9/7ACEidShvJZnSZ5r+EMH8yLY3nN/4wzvGKFtP8k+5ojsxdJ/L5xbctVIDZTYkKK32IrSn2Q9jZhgfFK4rFG1LopQBv5vcFgJv52RKLQMWIg6xxe+ZNDoz51UryY6s7uv/F2u0rhoFBUtnEkep6CHWEceq4VRjb6FKAemmkbAgl35/VzFMuHp413WutO0okOPy4MTC161lrdzgZJN3NFCjLnl7OpgJbZ7fRU/vU3ic+G1iKCALUYIQYrn0hUk5rdkUEi7yS+7iJiboNaSZwQbGmbGd6SVuxK5HhvlQI7F9OceoDCs28QUw5aLvmHSHl/Hwni7PrK+p5GbcbYfEapUp1jX+J6b+zN75mEBPK2KSHbDUwXG+cDivdJmn3WycIedAig0RTjE3O0QoPCMCeoDcODG/Ua5Rd5J0JIw4Xoh+8GeGZUoa6mKSZiDxZ+mQJmu69kHEMeNcA/nPFHGAhGWM8AkjIb02kUXXzqDCgc2upPUY5Q5WiBzdoZ6rOw54YIaf0T4/ABKh2gHakyJfx54QoP5a7lpYkJs00fiSuH3AZ85w9BhlkI/nf8vfhzA96mRoI+tTm/HwNs4dpHh/Vz2eAZ3iyvZ27doXIkFAiEWZhVAPklWXnp4IMyS8yf6PRZSlp+Lgx1xyYHQWmKfcu/g7wFXy+QrkrGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(9786002)(2616005)(5660300002)(426003)(38100700002)(4326008)(186003)(54906003)(26005)(9746002)(86362001)(66556008)(508600001)(66476007)(83380400001)(8676002)(36756003)(2906002)(30864003)(8936002)(316002)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mkrt1V5Amzo9CZrkySxL7YMqQbQvdbx3UPF1CbzeBi7RcL3XsPVKHwiowTe5?=
 =?us-ascii?Q?BoWlE8ETRMiFKVbfmkXwyLGzJfhBGg3Rkgda23b7O10zvh776E5OJKhG2oYD?=
 =?us-ascii?Q?OFmSj2fYdHVq2B75VDAvdV67U6fonBQtjON9msMXfuLjDZtioYDbb9RnYFRr?=
 =?us-ascii?Q?b0MM1MDDx5n/eyzVHY9pMtqp6a7n5KmbDCEOvSJKZ7Vy5n/Wz+oCn7ZmQ5uk?=
 =?us-ascii?Q?U3Suwq7cqqZ7i45rKMfUA9B0gYDcuB1J4E8jwDxkwbAT/7uSqJV4FlEdpVpp?=
 =?us-ascii?Q?Fh/mj7BXSzaEtAKlTarqvkmIi9s9jLjEkMqGlqpdkaLj/JB43NobCvfklus6?=
 =?us-ascii?Q?ZftVFL9uulM0GpeaezQpUbFoI8NLX3x7KYegikcnchbS9DQh/uxRT5XXUVGt?=
 =?us-ascii?Q?t6G900CR1PLWcqeDokjVRhJ/HqWe2jIq2BGrrDhSSvw/3H3egHJ92ZBdBw/A?=
 =?us-ascii?Q?Cst6ySpxD5Nk2J3s5ooNjdbH1Rw9n96eXBr2EZjhJY/mQKymx93PjPtvXt3+?=
 =?us-ascii?Q?00ww5YHg/Bgtst1rzLun/dOQ1I8DgbciLEJV0myARL2YAvxvEVpMEQ2ZF2Wa?=
 =?us-ascii?Q?+0C/p0LnOE+x/66Zz5b4xga3jpjqW9OzNzDvObTODQVQh5OMNvyQR1GBvh2G?=
 =?us-ascii?Q?cKzZy2RhTnuQEbRjgqxiSrv/2YRBfjnYclFFZGwtZVYSmCsmQDM5fEoj6I5z?=
 =?us-ascii?Q?jA124LO0liS5ixZDLrs9O26tltYJaYxDjsBWVyYkDN8L4aY0zQTS48ojXYJN?=
 =?us-ascii?Q?kXHoAjKLpOwJOFBtdSO7EpdHmYgjVBtNr9+ao8cUTy6lKfS66TexVqjJAq2l?=
 =?us-ascii?Q?zs3j3o5b71eUw9aD/H96M/NeQ6K30ZxJ79X+YMRLCU8Yv4NOXdXl3TXZYxum?=
 =?us-ascii?Q?wpzio9XE88qz3Q6uldyd6cqRyxWe2xAavJVOqfeqnMCwD/PouwZqsZYjZnSs?=
 =?us-ascii?Q?6LbbXL8gir1SmWXIxHX0DiaLpx29HC2673zVVbP2nTqX85vFUYqVeseuqTTn?=
 =?us-ascii?Q?ww6YNQfNiNhAefZKFXEAxyGP5j1kPkoP309k20xPtEauBzOxwrHBXQ8gaaBo?=
 =?us-ascii?Q?saGgDW18QQOjTV5Unix4Cc+FlZPBg0oEX+JekEDuGkr3rIf6H0E2T6tFFjb4?=
 =?us-ascii?Q?o+EglZDgZltMhh0LLoZVLgkhGAzExef8F25C+SuiMMLxlgfZjXWvIS8OJQ4U?=
 =?us-ascii?Q?ihR6bBjBzC7WKK5p5r7uZkXfORaaD3u5G9RwdPiYrCWq+BvKij3d+/+/uznO?=
 =?us-ascii?Q?TgOTwhjdCkT4xkL0772vjdkqwoyH6w3k3/S8+90R0TQijHOyDpb/TtWVk6cH?=
 =?us-ascii?Q?rgUSPI7FHIsUntNJmSgIPdtx4e37ln4BVPX8JvZ+AXMYzA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ca5ed0-2003-43d8-3558-08d98532547e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 23:22:26.4969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wE+NJv9L+yOAUzbvShQpWTRwQCPn5MGzu8IvjoXAgCtnbQyartSfd3f/jO/bMqal
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
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
 drivers/vfio/vfio.c | 200 +++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 106 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index dbe7edd88ce35c..01e04947250f40 100644
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
+	struct device dev;
+	struct cdev cdev;
 	refcount_t users;
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
@@ -322,26 +309,6 @@ static void vfio_container_put(struct vfio_container *container)
 	kref_put(&container->kref, vfio_container_release);
 }
 
-static void vfio_group_unlock_and_free(struct vfio_group *group)
-{
-	struct vfio_unbound_dev *unbound, *tmp;
-
-	mutex_unlock(&vfio.group_lock);
-	/*
-	 * Unregister outside of lock.  A spurious callback is harmless now
-	 * that the group is no longer in vfio.group_list.
-	 */
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
@@ -370,75 +337,112 @@ vfio_group_get_from_iommu(struct iommu_group *iommu_group)
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
 
-	group->nb.notifier_call = vfio_iommu_group_notifier;
+	return group;
+}
 
-	ret = iommu_group_register_notifier(iommu_group, &group->nb);
-	if (ret) {
-		group = ERR_PTR(ret);
-		goto err_put_group;
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
+	group->nb.notifier_call = vfio_iommu_group_notifier;
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
-
-err_put_group:
-	iommu_group_put(iommu_group);
-	kfree(group);
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
@@ -450,10 +454,12 @@ static void vfio_group_put(struct vfio_group *group)
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
@@ -461,20 +467,10 @@ static void vfio_group_get(struct vfio_group *group)
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
@@ -1484,11 +1480,11 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
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
@@ -2296,7 +2292,7 @@ static int __init vfio_init(void)
 {
 	int ret;
 
-	idr_init(&vfio.group_idr);
+	ida_init(&vfio.group_ida);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
@@ -2321,11 +2317,6 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-	cdev_init(&vfio.group_cdev, &vfio_group_fops);
-	ret = cdev_add(&vfio.group_cdev, vfio.group_devt, MINORMASK + 1);
-	if (ret)
-		goto err_cdev_add;
-
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -2333,8 +2324,6 @@ static int __init vfio_init(void)
 #endif
 	return 0;
 
-err_cdev_add:
-	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
@@ -2350,8 +2339,7 @@ static void __exit vfio_cleanup(void)
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

