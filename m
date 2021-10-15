Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D411142EFD8
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhJOLnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:07 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:17792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232456AbhJOLnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzYYdsdM+QpG0TIoWFt0vFrTsWfbLPSkhDfIzUZOIFp222Dm4pjVZiaa2udezcq3n9fMP0bl82NO3mRvRWMpAHtGg59OhBcq/G9PAN+jnGZqZS+eKYGSRIG7L89kf/96KAmQFBQIUAEESs5jTsW/3NjeJubEvexfP3qx3Lw0kI9nOO1wsKVUl5pDc+GlctebLELDf6Wl3NT45U1/SiB2AuheuBLraap/9HqThipOWhbIFoeArZMFSBHEROJDBuVF5QPnLaxzz5MuoE19qI0bpvCyfKA1VOYzFrIp0f60LR/7aKwOZAICEnHTNFt41mUbCdxW2uBFAwMOLIht+oZKYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QL/qQhZgfMau1Z4kgcVNyCcVI31UzM+LI1FKPVig3IM=;
 b=b4/fpZEz1wWzJBKbSXWny+r+l03+z3o1Uyf+zTrlLDFia6d9l5C5GTjstLD1xPguhx+An3pC7m7Cz68RVTNO00GpcEsQJZ04Hc/2oJ7g8YfshkA0RNbig/JUV/QbjzmmlHAoREgJfgW6ZaJmxGuXzeOfJRFkVabj1ELM6bqk21J+6DCwka46tCXK/3OJTWORwNLW5flhp8v4m3FCG/NIbU7UpRNJ3wDCkxWZdMMVcHpiqa1cgLh2kcjBFjC2EFbBYKz7G/9VPeAR97Pam23FIRnuSGBJa8JMyARqp5BeJY4hTEk99Q/hHDEXkZd4uBLkHEIFFHkm8Hg3nIVpmoyNXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QL/qQhZgfMau1Z4kgcVNyCcVI31UzM+LI1FKPVig3IM=;
 b=PRKsFKVE5N7kBSOD791VuIewtF2b22GnsODVX9M+ZNMjPY4g5hwNDZ1H8U7htah4YxHRTrb1sWjIHMqVNNfLW9ygxovyKENMkl7aqPKxi51arV5lDvNVVvuq3v7LJTOwzI4yC4PQnoKDrSetJQXwPrHZKdY/Ec0N5ulr+xTo+QcghbFxOX9Y0pgW2N2n/DoPODgCSs3o9fLWRLDismPXRdTaZnX+tjhJ2JoY9+3r77niMCfRQftTcLeAFFOgwgEJlek6Vs8WXqhaC5txM9p001cENmJ5RBFQv8JOwP+cL/rFukpNRkzX+uV/TE07uWI7i7FaBxMLm11V5hDy2iqLcA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:40:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:40:56 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 5/5] vfio: Use cdev_device_add() instead of device_create()
Date:   Fri, 15 Oct 2021 08:40:54 -0300
Message-Id: <5-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:208:32a::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0118.namprd03.prod.outlook.com (2603:10b6:208:32a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 11:40:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLa2-00FJUR-9Q; Fri, 15 Oct 2021 08:40:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2792eb1-52b1-4ef9-95db-08d98fd0a681
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208433DF5125B0BB2BE7B48C2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:451;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTaM12fU7oO3DNgHZeSa7m6VsRuChbsE5SFFy7WQYOr39F/JqP1xtrQxatw6QUk0VEA5t0fY5HLHM6bedb94GbZZce1CY6CwuWgf1Nb93RXXU8SAUZ6DbZJqBgjyw/uiAeqom7Z6/WDffPgTNSbiUCBjYasPuNL7u6aFm4VgtpZv/drrDbYHfNO947k4pd3qyIOpxA2LLHVub3lrU3WyoZ/DmgnNq9JqPndljmlLEcisgayBcmN8C+CXv4VqBn4W1a4ej8QakBhqefNx8rJm+AdB6CTn2nYus4rY2jyOOgrmrQ6P0r4/OSfeD6FZS4vAZ34G9BQFJKzndLXgfrVoNtKHKOvrjPJnB+f4/shZwFECa78SgXqmJb1H0X5ZKgJ1yNxxEncO71svhXRA16c/dvyl/lY3ZfeEaxo0TKakbcwnpYWAKmuaSIz4C2+M2vAWfpNz81IUIl8+H0N2L1YkhlzHlqm9em/RjzExKVv68XVwHUvxFt1B3g05O/PTuUk77JvVz4gnlyqfHW2p8GL9ElS5HWcDfso23orzYJMsEQ7/xcvixcRJrTo62evgHgwcBrwgsStqPM9ExxyZ+9Vu8Eu/znGt5E8b0ARQV945pCxdCpnrBbpvekANrmcgPNmNbpBdanBW0AFJ/mV9rwJemxhmXmS/X5McGBBdhkWwEM3uJ67iGqzc0hY/CjYy2kO7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(2616005)(83380400001)(4326008)(2906002)(426003)(36756003)(508600001)(30864003)(86362001)(186003)(316002)(110136005)(26005)(9746002)(9786002)(8936002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AFuVZC5m3L6tb5fEj5u2MBV064uJREHi7PfFu0+RhRu1FtzH2yZ0RFYWgvwF?=
 =?us-ascii?Q?t3uIi6LoaLdkmKJ3xjJUgVGmYMcil3ZaQH/Wkcw3LmupdVj8/YZ2EycZMmxI?=
 =?us-ascii?Q?Y57zYcmiSTEJLVdbEi5YGBT8895H1w4jWArFFe6KBxXdCfzaNPVOvnpay+Lo?=
 =?us-ascii?Q?TtZ0QUFaVHmCTpjBErf7DX+bohQVL1idjWuZxUgecT/hBq4IUX0Ca5ddHnFC?=
 =?us-ascii?Q?Dr3mKhUh76jko/vlyJf/gUoKYDxEAlRdeNByeq6Z0R1wqITelE9pffWEwfwO?=
 =?us-ascii?Q?i+Dh/WPNRq1YbU97oaFhCjHUWGc82MmAIozBX5NBZNVcq6M0SfciIlirCgbD?=
 =?us-ascii?Q?nflG7kMJBg5a9PpdqhMWQ813qJM8xDBZe2z3JDe+t5lZkeUrXre1gt0/ifNv?=
 =?us-ascii?Q?8H6JhQTotJUqGurzVXD3m19aUPSizw9MOX9SyRJegf8thH+sVYqOPmA2C11c?=
 =?us-ascii?Q?m+LjZIi4iFv/umwlVq6aVL2N4WCd1kRwYKpjZfby1EOmjiwMqn7yGuqekFS/?=
 =?us-ascii?Q?SP1tThwKIlqb5ZWUtvjDPgdSJfP6AVa+m6xxszmP9YR2EYyIoDsc+QQ6l/1X?=
 =?us-ascii?Q?2S/QrZEU2TwMCuDpK9sG4+yTG+Upc+17o8jo+L6rIW2ONMmR4jsUMTQI0F9g?=
 =?us-ascii?Q?wVkl/COLrTxLW5ejJccXmoWvSwx0DXetGW0Qk1LLX9ng9p8y62E755NYO+IF?=
 =?us-ascii?Q?gGmX28Nke8rS0tlKIEql7x22CLlSlVXazh6MSQVWqdvpTeChlnHOtTQcqWqr?=
 =?us-ascii?Q?hDi6zdSPBPkHYouCuaRebCWL5DUi0TNGvPRWQm6q50ix65Go4t7satJuYZOg?=
 =?us-ascii?Q?UJMvI4EJmfVeKUHQKSbd//sE36peg76VOtxya8wV0sVEW5XNJ5IItyhZgQO+?=
 =?us-ascii?Q?Sh1jN7X/inNXFHAqZY5fOTk2zoPR8E/JAJENp2AN2UYYEHRZDWvNaBP6ibnb?=
 =?us-ascii?Q?bVd7SeiZ6ek9WF4UdD/paFHqKWla5LBW3tcyFxxD2ZZomOMwKDnvJFKCwjkh?=
 =?us-ascii?Q?leqfELtr0z0RFm0kYiUCzrV1GJNRRhNwdiu57tOGqLB9o92OfgUrUJwQIlo8?=
 =?us-ascii?Q?R3NxY7KpuTQhgetJ9vvV+WR0PrDG4QlsCysuLDuVQuoU5ngqbTSmVNrw803u?=
 =?us-ascii?Q?CiMHPTbGMGHo/i6lWoE9cda5w4umtjxN2dS3tPF+yOp6tUEbrZsvKhgCYdYc?=
 =?us-ascii?Q?Puaio7DHt01hku/YGPMwOUM1ulzVWvtyNTikEVsVG966K0OKJKsksaVLTE78?=
 =?us-ascii?Q?ZdxWSmUJYOXJopnDmyfAi6uij/CY1pWruXIL0L4ehFGdmOjrn4XPVRFPyn5n?=
 =?us-ascii?Q?s4Q6XpgRK8rDndANEoSx+aqe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2792eb1-52b1-4ef9-95db-08d98fd0a681
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:40:56.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PgXTo4AT3IcSuUM0Go+c7RtxdqQUbb4ZB5Y4mFgyrxzqfJigHlRfEg2KQnoRjvLI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 193 +++++++++++++++++++++-----------------------
 1 file changed, 92 insertions(+), 101 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e313fa030b9185..82fb75464f923d 100644
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
@@ -459,22 +473,6 @@ static void vfio_group_get(struct vfio_group *group)
 	refcount_inc(&group->users);
 }
 
-static struct vfio_group *vfio_group_get_from_minor(int minor)
-{
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
-}
-
 static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
 {
 	struct iommu_group *iommu_group;
@@ -1479,11 +1477,12 @@ static long vfio_group_fops_unl_ioctl(struct file *filep,
 
 static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 {
-	struct vfio_group *group;
+	struct vfio_group *group =
+		container_of(inode->i_cdev, struct vfio_group, cdev);
 	int opened;
 
-	group = vfio_group_get_from_minor(iminor(inode));
-	if (!group)
+	/* users can be zero if this races with vfio_group_put() */
+	if (!refcount_inc_not_zero(&group->users))
 		return -ENODEV;
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
@@ -2293,7 +2292,7 @@ static int __init vfio_init(void)
 {
 	int ret;
 
-	idr_init(&vfio.group_idr);
+	ida_init(&vfio.group_ida);
 	mutex_init(&vfio.group_lock);
 	mutex_init(&vfio.iommu_drivers_lock);
 	INIT_LIST_HEAD(&vfio.group_list);
@@ -2318,11 +2317,6 @@ static int __init vfio_init(void)
 	if (ret)
 		goto err_alloc_chrdev;
 
-	cdev_init(&vfio.group_cdev, &vfio_group_fops);
-	ret = cdev_add(&vfio.group_cdev, vfio.group_devt, MINORMASK + 1);
-	if (ret)
-		goto err_cdev_add;
-
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -2330,8 +2324,6 @@ static int __init vfio_init(void)
 #endif
 	return 0;
 
-err_cdev_add:
-	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
 err_alloc_chrdev:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
@@ -2347,8 +2339,7 @@ static void __exit vfio_cleanup(void)
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

