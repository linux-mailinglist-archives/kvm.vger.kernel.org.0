Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75703466F6
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhCWR4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:19 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:36673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231313AbhCWRzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzrQOABJ2XpTAt546SbXiLkGrku9Sp0hOircyu5a7jYzpfGkOdAqqzB0WNWfVvi3dq+erY00adfsTohJ44WiKh/dcEbDkPmqjQ5F0ulktjYgP33EKAprJ44tBNcR3ak1dKzkS6F9Jk8dA91EPAUAvHC2g/RhYs6PJDgSz4g3OhkbWf+c/RMaf4ZsbzrdATlpn4j5sTNFGIi3Sbuq4S1kiU7lbq2SKH2T5tC43fGDrQDpWW/cvZQcwwEhuExTiG1Hq0Vh1ar4qmJhQvUZ7o8Rk2X1X7bZVBlXhCWhFnIblZm8bW9b0T38pkrCqYYrg0SDhyK5C3KrbpM7GvQTHH7RUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/nI+FB4N5ClW/A+/83ogRuYqSicWeFW0aES/FV0WQ0=;
 b=G32aWHDCJDHe6mOeFldU29C3CU27TaeYfNiWfhB1nMJ5eDWNwU0teJEkBD0XiLbs3/cYMa6gbXgqmGXGlCL+ucjLpGndwuP0RO2xSx0/EC3oXQmfG52M0izz9T8KcARURSH2iLJNCwidpZQAMOftanqhpI9nd1aMKz2iYUP/h+PPl898a+/8ihHKugKUsTfKiBQNc9K1eiGmOW5PBEU7x2XmI5+Xfe3Vfz1DTg0Fqkg0oEyHYDiBDl080QBhbry5z5R074QiZgbP1GvqJBgeFlDmsMZOI42ZtLNx9MWh1GIzYfmgIIrnG6uTuJ+NZnJFspQ14YTsuzjjghAhAk0KTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/nI+FB4N5ClW/A+/83ogRuYqSicWeFW0aES/FV0WQ0=;
 b=K3BhO7OOdj3eaUGy5+lT/EWgSltRqc3jWcFYR9qjm0X6N+aaZXTIZwvBUlwv2aCBHHsoQJgFDIsV3jfuOZaS9/QOHjNFzLwaJw6z6JSjuTDdVq3ukaV/HAF884976x5XO4iCsK0t7sFu1O+M03rUm5YvuKDCwFQeYvR31wT1WGPbr48lDTcDebmVldelPYuPdkru0P1N6xd1si/tmHgVncYIGuuJZOLmzSPqEfujV/CwMzBZYoMMsVveIbplxqV3+UD3Zy3ABxu3WGcKiUXQ2e70nJMGvdzXE7x1PO3ezieSYhwINsFIrWQMIsxCbfX9BKjw3YqDbOq6q4BA3D1DRQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 10/18] vfio/mdev: Remove duplicate storage of parent in mdev_device
Date:   Tue, 23 Mar 2021 14:55:27 -0300
Message-Id: <10-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:208:23c::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR18CA0018.namprd18.prod.outlook.com (2603:10b6:208:23c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 17:55:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001ch0-JK; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dee73a02-fd27-41cc-7f56-08d8ee24dec3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB49432821DA5292C0C3DBE543C2649@DM6PR12MB4943.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Gkk5SfM6tYMatJ0hzlZ7kEHSaGF5a6WxRKu18EDBtkUoHrIsZQ5bBAw1RzraFSx+KCvqgL0JH4akEOU+9pxUrYhz99afXjbW4RoJRvcAWNrAARrHT1fc7XXFoIQNUZ8+h1dwGoGVuchSbbgQ+4La/JUtPQJzX5oq14a7uasYk6gnCW4W8GCcswvaI80YWaA/dEliSCVDLTN704kgGiNiU7pVpxXpZAtVI6LprsffY7/NYNrWOCgLXYnC6MAkct4550t0KU19F2Evnh/3VkXQRMoKTZrpiFntgk+cjSl0NFYgL7wxOa2mgcfxusIdq8VBg7343a9MB11QU8l2vAE4ndLI0wCkWX6CYbrBSlkHraLELNvCNGvAp/fN6o8synEVUbQn82MCh5n3IaEjfipI9o9l5LogNw6PoR5C+rfV99MoI/z2XwU0Wq3q50/VH63i4CKEnpfVupc6TrH85hOgVnoqYu+daFk4Jwe+cRX2b11HGllhZcy0+MXE75vq3Snds1Mv1j7Y6Fuyd9MPMfpHuOHz+vUu3wBjlJITG37t5Jnrlg6hqIQR30xcAkQJVckywTJz2aKeYrGz98P0rxH7RvEE5OXBBJtr9HKz52BA/eFLmpDY0HpSRSgk+H8dIpzFm0ynVxCfjb33keO+U0MxyBkoY5WOI43OevaMp72yrA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(66476007)(186003)(107886003)(6666004)(8936002)(110136005)(36756003)(426003)(86362001)(54906003)(83380400001)(2616005)(38100700001)(66946007)(5660300002)(478600001)(9746002)(66556008)(8676002)(4326008)(2906002)(26005)(316002)(9786002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?epUy1rTfTlW63rZc7GUAXHNZ9S3O8Iti4dTAek9N/fFW9oFNrQyjGuU+ZlAq?=
 =?us-ascii?Q?Kkx8qWdToUMi+1NVCVl7vcZwR/3q8D+wi/tefLZ/+7y6CMMrXi1jHdGYDhch?=
 =?us-ascii?Q?mm8GhMu55yAn75ONr1vyaOM5cwIU5KR8HnFdCN45p3L9MYk/fUWBCYfRzAx2?=
 =?us-ascii?Q?yWCXOO443JrqHAfxRqVHciLe0A7opurPLJCLcaGMdrdyRALrfHZRQgb7+mRv?=
 =?us-ascii?Q?OL1qjC4nAXyz+Wm70SEn2T4x3+tOYkaSEblJe1VxzlzVsm6v/ubUfxZdO1Q/?=
 =?us-ascii?Q?E4nOJUJWxLkUcqNQ04FblEx+DAunsGZ5xWYmYuBjfHCCV9XX1dY1axhIUGDd?=
 =?us-ascii?Q?zOm80U9QesT5Hj3SLHxvtSbd0WILC+ENjXHJkiN90hciJWGZN/5FI1q1n5EB?=
 =?us-ascii?Q?j9GRJGZ537aor9wVC0BCOYvea9hFlojsqPA0hnGEmF3ydqY8wPeZSGpoob18?=
 =?us-ascii?Q?F6a8ydA6DIhpSkNwpugT9+ORDHDo6P+aX4/Ncn8MY/psOZu6DAqVB0/ExKW1?=
 =?us-ascii?Q?WHCu67/Fa08paSDUiRQLH9r21HmcJcO4UOk0FcpBmPeuqULtnq55Jg4iVxr0?=
 =?us-ascii?Q?Z2LOlO6dWYziLn7VZA9t8q10oyBgOLDKxrXPc4y9XckDzkpIGrvw1V6S12Pf?=
 =?us-ascii?Q?4phUTiwukyiJFi5NWWFXVqgowbu2JQQx9ul50huXO5RpGZpwU3K6yynpDmvJ?=
 =?us-ascii?Q?mkOzfclH6OTzjA7MCyIVbA7grsdH0w/JpgXIJmEpq9YokpHuUGH+rLp7eWqv?=
 =?us-ascii?Q?xnAiNEMSPYMo6uY/zk404iiwUhRF7Dgd2Ff0cDHF+ePi73Hryk53CkGoi/8S?=
 =?us-ascii?Q?MYOfL/2vgG30VFAtSmGj0cEo6zSiUfCKIPoF1gCMYKTYwI2Fll9Q2LITl/Ul?=
 =?us-ascii?Q?YotCwOELc4hZjOEOEHGm10/M1QHzvU+UpsavtZ4culC2lWZ+KVrB1nfBG6b9?=
 =?us-ascii?Q?DfcnShUC4MY5ieC6K7yd7fqaZhXB2pYWc+TAIDgKHysnys1vO0QhcgvhHz7U?=
 =?us-ascii?Q?/RvWJRPpsTF+6x+8g0dvMavxQO5URc9rDHYlrHW5Qf2ogr+peDjF7dWoSSVi?=
 =?us-ascii?Q?G1vssVGxtwn7gesWnjqVHgEv8CpI1C4Ok8CC9vSvIJgCzVxtHyeGGyy3kGqG?=
 =?us-ascii?Q?nHKIOysUmYZm1ZY6Lk4IurUy/tdwAPXdI8yPoJkRGFgd6b9sWn1IIbviAcpz?=
 =?us-ascii?Q?3Zx2QF5aixdOqsfe8UM0ibjIAHnZVB2Wnns3f+feXImHnxA6vif/K2OWIEzS?=
 =?us-ascii?Q?jDNS3iXNhh0B/EZq8u8eaulJ1BTE19AdnbdOKbJNAOcSkjWAYJ9A4ky2jePO?=
 =?us-ascii?Q?e07gVAsYCy8jh+ulZHcBAvqj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee73a02-fd27-41cc-7f56-08d8ee24dec3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:40.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmSv7ruPJ9W3VVBlP2YJRRSCgtfzdLOuGK2zbZnM5Z21DlGAc7eyPUNfferw+YJX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev_device->type->parent is the same thing.

The struct mdev_device was relying on the kref on the mdev_parent to also
indirectly hold a kref on the mdev_type pointer. Now that the type holds a
kref on the parent we can directly kref the mdev_type and remove this
implicit relationship.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 13 +++++--------
 drivers/vfio/mdev/vfio_mdev.c | 14 +++++++-------
 include/linux/mdev.h          |  1 -
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 4b5e372ed58f26..493df3da451339 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -29,7 +29,7 @@ static DEFINE_MUTEX(mdev_list_lock);
 
 struct device *mdev_parent_dev(struct mdev_device *mdev)
 {
-	return mdev->parent->dev;
+	return mdev->type->parent->dev;
 }
 EXPORT_SYMBOL(mdev_parent_dev);
 
@@ -58,12 +58,11 @@ void mdev_release_parent(struct kref *kref)
 /* Caller must hold parent unreg_sem read or write lock */
 static void mdev_device_remove_common(struct mdev_device *mdev)
 {
-	struct mdev_parent *parent;
+	struct mdev_parent *parent = mdev->type->parent;
 	int ret;
 
 	mdev_remove_sysfs_files(mdev);
 	device_del(&mdev->dev);
-	parent = mdev->parent;
 	lockdep_assert_held(&parent->unreg_sem);
 	ret = parent->ops->remove(mdev);
 	if (ret)
@@ -212,7 +211,7 @@ static void mdev_device_release(struct device *dev)
 	struct mdev_device *mdev = to_mdev_device(dev);
 
 	/* Pairs with the get in mdev_device_create() */
-	mdev_put_parent(mdev->parent);
+	kobject_put(&mdev->type->kobj);
 
 	mutex_lock(&mdev_list_lock);
 	list_del(&mdev->next);
@@ -250,9 +249,8 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	mdev->dev.release = mdev_device_release;
 	mdev->dev.groups = parent->ops->mdev_attr_groups;
 	mdev->type = type;
-	mdev->parent = parent;
 	/* Pairs with the put in mdev_device_release() */
-	mdev_get_parent(parent);
+	kobject_get(&type->kobj);
 
 	guid_copy(&mdev->uuid, uuid);
 	list_add(&mdev->next, &mdev_list);
@@ -300,7 +298,7 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 int mdev_device_remove(struct mdev_device *mdev)
 {
 	struct mdev_device *tmp;
-	struct mdev_parent *parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	mutex_lock(&mdev_list_lock);
 	list_for_each_entry(tmp, &mdev_list, next) {
@@ -321,7 +319,6 @@ int mdev_device_remove(struct mdev_device *mdev)
 	mdev->active = false;
 	mutex_unlock(&mdev_list_lock);
 
-	parent = mdev->parent;
 	/* Check if parent unregistration has started */
 	if (!down_read_trylock(&parent->unreg_sem))
 		return -ENODEV;
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index cc9507ed85a181..922729071c5a8e 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -24,7 +24,7 @@
 static int vfio_mdev_open(struct vfio_device *core_vdev)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	int ret;
 
@@ -44,7 +44,7 @@ static int vfio_mdev_open(struct vfio_device *core_vdev)
 static void vfio_mdev_release(struct vfio_device *core_vdev)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	if (likely(parent->ops->release))
 		parent->ops->release(mdev);
@@ -56,7 +56,7 @@ static long vfio_mdev_unlocked_ioctl(struct vfio_device *core_vdev,
 				     unsigned int cmd, unsigned long arg)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	if (unlikely(!parent->ops->ioctl))
 		return -EINVAL;
@@ -68,7 +68,7 @@ static ssize_t vfio_mdev_read(struct vfio_device *core_vdev, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	if (unlikely(!parent->ops->read))
 		return -EINVAL;
@@ -81,7 +81,7 @@ static ssize_t vfio_mdev_write(struct vfio_device *core_vdev,
 			       loff_t *ppos)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	if (unlikely(!parent->ops->write))
 		return -EINVAL;
@@ -93,7 +93,7 @@ static int vfio_mdev_mmap(struct vfio_device *core_vdev,
 			  struct vm_area_struct *vma)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	if (unlikely(!parent->ops->mmap))
 		return -EINVAL;
@@ -104,7 +104,7 @@ static int vfio_mdev_mmap(struct vfio_device *core_vdev,
 static void vfio_mdev_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
-	struct mdev_parent *parent = mdev->parent;
+	struct mdev_parent *parent = mdev->type->parent;
 
 	if (parent->ops->request)
 		parent->ops->request(mdev, count);
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 349e8ac1fe3382..fb582adda28a9b 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -14,7 +14,6 @@ struct mdev_type;
 
 struct mdev_device {
 	struct device dev;
-	struct mdev_parent *parent;
 	guid_t uuid;
 	void *driver_data;
 	struct list_head next;
-- 
2.31.0

