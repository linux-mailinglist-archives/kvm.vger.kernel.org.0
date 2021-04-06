Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD4355CB2
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 22:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347149AbhDFUHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 16:07:43 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:34721
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347153AbhDFUHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 16:07:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOURRhmtqRLDHKm8AimTmp1Ubgr20/UvclC+iKp8CNEWTOlb7l9uhYzbQ0jCNDP864NXJUfGZrmVuP/TlIeZ57gjnah2PxP2Hr9rtMw+zASoLNnMwGtLpViQtxNjz7ZDkLhUYc67yT8GM/hmLo9AZwjeFHPS6yxzaIhRor/3fO62vaRNrNwx/mzKQllQWbSuI8zU4tjDLbAJZJ1eTWX30bVgl+XV/YI3iknzUwM1IuBh8Kf3/Hw2KLz0H7szus2C+KN67xksiRaJpsxVqxvRYMr9r52O7BJ0TP3EBikeoZ6BWRJWRi8+Khls4DeK75Pag3dRzz5tOuFi/01EbtBWNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNeIevVOOYi+k3r5FquCyHpMmhxjxVAf4smmFRs/swk=;
 b=XpjhfoocrGVf+U2Ak6ahzNB7gViSOdjnh7ksFInzBtwj4YN3RqfAsngUPDZCaTzm5+btJcQPYI7JlRR3ZD/wNt8CbiJMYYvoSOkUQU0mMcCTWl8WSYcFCG4jXf6sJpkcLJXREAR2rc2hySA/gm3WKnIhkQAx6b60dogR3zTsLt5EClToSgYRhBVxOSIeRtuPDJ5a/4Pw6tpISf6mQJZrEgAb/KrT0831zyDdwb4x6ATvUddItP0NUJEXcSu1BQMuc/0Zx7X4f6iaUhBxemh+Wkh6Nwka+W8b8VFqQ+v5Prcmv7FILl5sK2W5gk0GCdP29Qdd8FbjRTClZicYPemdDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JNeIevVOOYi+k3r5FquCyHpMmhxjxVAf4smmFRs/swk=;
 b=N42RDP+hOqTWuha7rSy2uVdOvB5Z4efWKrzVi7mlylZcVnA8mL6ZwHsensrrKmaMUyY6lDyQ0DIaXfJl3U0QOkspCNGudkMw48mPdV7npuFbDH4ev1LdE1M7ZdXrgtUQ0J9dudlhsOJp5dP4RpKRNBUUrlN+hLeaXZWFC2HOnaLP5N5loV4DelnkJ3LRE3DCVXUQON5LktaPlHum+x8kRo9FtQYoLeXJ0Yk1f395nos4r+CoRGejEIwJ1rlE1BluUYtjaTDGADiMZtZ/tb0nrHOnumvBXkDb6DQ/H9QUdVZLxH6Cr/vhQxKyIcCFKFbOgs9Sbefqk+54tCcbBrRt/g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 20:07:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 20:07:27 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 10/18] vfio/mdev: Remove duplicate storage of parent in mdev_device
Date:   Tue,  6 Apr 2021 16:40:33 -0300
Message-Id: <10-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR1501CA0001.namprd15.prod.outlook.com
 (2603:10b6:207:17::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR1501CA0001.namprd15.prod.outlook.com (2603:10b6:207:17::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 20:07:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXS-7c; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5bbe004-b898-478c-18dd-08d8f93799dc
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1883140BD4FC59DE72AD59EFC2769@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u1UQClBS9yEH64fzjIB6MeXJejBCUqpfRsN4/1leSF9sVfoRuJYY1z6BR72tjSA352kq3pG9oE54xy/MsxmT1l14kzdz9hR73J2GS+/ZWb93MyBn8OPSAaV7eFcMQ0EgleXdPj0Nmop39mMRf/A+5BKI61nc383BwgPXzXJYx6/kxQcutqKJNaS0Z6EpQFta02y3gQJNAcJtBG8Q+5Q3fNb/Gd47FddphIYp1EGm7Z+zDQ3xtBBuh5FrmuSwHhHgXBsdskqza7cxu0nzJscwb8cgPckeyBckN2jMCBEB9ptUiTOYZYx7qzSlFPO9OwbpOOCQUQrp43Ef36xIc148lfkVMDA/DWSztryjg7GXxZaKvtyxAxzxyCESFuZKkKB0RBzz4LaMReJJBpGd+6jAt57DLq3/5tQr4begO45bsr7Z4AqMuXIdIyq8lIu+fDpjjVmISUdd5VXxED0o82OillWfreFKQSTyIp72m/wFumr3D56+2C01gxzAiAoqbQ+BWbHraMeLup0Un6bw5oLi+PO+roLznmkU/UG9CNB2FAbZ0rhnouwHKgg1LqdLFH5VHke1qXpLHcdW81MgaELryeCgbIFs6SUgAC2DVJN+ZwMr7XQMho3o0veEa454SZIKVYvCURXdPDS6KOXorHt+g3KSuKB9gh10vJy9z+spV/A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(6666004)(6636002)(38100700001)(186003)(86362001)(8676002)(8936002)(2906002)(2616005)(316002)(54906003)(478600001)(110136005)(9746002)(83380400001)(26005)(66556008)(5660300002)(66946007)(107886003)(9786002)(4326008)(36756003)(426003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Xx5qOVWs4k6NyyoKeSgiewrKWBJKXEWTkQ4OohTI4IrrV8Jb5ewzqm3sSiW+?=
 =?us-ascii?Q?CPiIAbG8tjfCPmyAM3OS9nICu7rL47lMJTxJCDIlk3PPiscPRlnZLKYuCRBI?=
 =?us-ascii?Q?hpNM6oqRTgx3z3l/GRCMrdx8TblehRfqMcgVWnCB4xupxiAJvJLD466M5m+h?=
 =?us-ascii?Q?18tN8sGWTwG9XKD79xDukB4iRXyupX69ngnXYp7YvfIOsNUTdyjIo/w1hmR5?=
 =?us-ascii?Q?NMA+e3mlG4aPCwhxSiiFIrI9iq/edqIdLqkp+uBUz1M4/f2Uu3eWu3zRpqQi?=
 =?us-ascii?Q?295wc2sRemMPdyju+ryQHRHKDAtNjq/OwpOfxmNJGMdSw4+ciKjC2HTp7MJC?=
 =?us-ascii?Q?DhL2hECT+capI59f36WP8HnD/WyPi6FCm457Zn8lMDVTBaYX5NzcDD1iJgqm?=
 =?us-ascii?Q?F0kwDx4nG8TxQETDcnUqu1lZNClXpmq5qE/9L2SAkzmiGLAYNCD1aaWHiMh+?=
 =?us-ascii?Q?2tYQ4Xx4Lp2FYNaE+e9uhPWBouP2i3SF74j/S07DRxW/kKfxizlv286z+4rM?=
 =?us-ascii?Q?jpN3CaRNlysrnc3/I5Ij5rvcKvgjjSmVP0KnvStpbxG+zJU5Yruelwoyp8Wk?=
 =?us-ascii?Q?zzA714UqZahI6RLOWdqMKZeQVFzCX9/gtJ6wwfydZVnXZ9yHkJWRVIl0rYIA?=
 =?us-ascii?Q?P38qNG7YjW9y8OpaCqZ3c+IuwCbzl0Am2cOF7YJz4Kqxa5slUPnFd0DgfCQ6?=
 =?us-ascii?Q?nYYvtT7NZTx5aXxt8CXIElYRA2H7isMIg6rfEAF3fgAUm920m8Z6U88zybbJ?=
 =?us-ascii?Q?fSjUPm5JpUy7IdFchyn/jZTpgKg/Jsk74dZ6nQqgdPtsJyusEup6fL2NhFwB?=
 =?us-ascii?Q?1B2qzb1oOwGqfK1UIYjfXDS6Gp27kvSr33tSL3dFq8v/jIoUAi4fYdqCXr44?=
 =?us-ascii?Q?FkXvZ+ghZm1shao/vNdiLlyhHEqFWlAbb55G84ZTDNXBs+RL2razHOBzl+2+?=
 =?us-ascii?Q?+K2aYWFCPNWZH1y+ehfKycZTQ7b1X8zl0Mi9pXQErZhdy1jBYj89h9hz7Hus?=
 =?us-ascii?Q?kTEN1Fmf40fakc5P6XAK71rGth/9mOnEY9V3gNw2eMp1864CYTjyeZbt0Pb/?=
 =?us-ascii?Q?AvMQYJOWZJIzdm443BtAXrFMaY+2rvKZ1By/L15r9qlQ8Zolf/SpvP5eJTtH?=
 =?us-ascii?Q?fLMudqRaZl/Srz7SG6jXdXtVorqdfs5pRGWQdgdJH4Git2IqwBP8hcJOh6+5?=
 =?us-ascii?Q?MX+zZ7Sd9sjEEnwoMRczV/bMwaQK7F/jphmqrOwOGeOHQoMO4F6gTMwvY1oc?=
 =?us-ascii?Q?UgZ1Rgg9q27OBLy18v5erOQG5ToZ+d+v2y2LXwbAFjj7TgMQdFPG2JZiNqMN?=
 =?us-ascii?Q?sFgW7xSj1RU4NLVXT7sAgq7V1iH334cwBtKkiKMGetrHMg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bbe004-b898-478c-18dd-08d8f93799dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:07:27.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QGZApkSrJEnu4l878/4iijEqzHuYX+5Cgw9lsb/ml6qxHOHW0AUpxpz8rl2QOXx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev_device->type->parent is the same thing.

The struct mdev_device was relying on the kref on the mdev_parent to also
indirectly hold a kref on the mdev_type pointer. Now that the type holds a
kref on the parent we can directly kref the mdev_type and remove this
implicit relationship.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 13 +++++--------
 drivers/vfio/mdev/vfio_mdev.c | 14 +++++++-------
 include/linux/mdev.h          |  1 -
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 4caedb3d4fbf32..2a20bdaf614214 100644
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
2.31.1

