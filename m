Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75DC3466FA
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhCWR4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:23 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:36673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231318AbhCWRzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmJv8veTe2IMV8pTmKr64BR8DkrG/ZpwxSAita+3Sx+UBXGLph2CTj7bE+kA23LsobOmUWba/VEhhY26IyR45tlFcwbhiSoD/fMTnV6t+zIgI3cAiIM2FoDYSdBZjdd6CKfT8CiL0FgVUj2YBMHCd1vA0KPghqfbK4fGc1osAZbJlliudFQ8ey1iUZMQEL1IIJ/gFKuoj6GFUIpsvoC3swssKenwahitpS84kkvFoHCUXiMNXQKeiKbqtcp6shPRTuelZa+Wbxcf57MyKe9ZaiCjNszQGOx0S7fkpPVikw996GZzcU+UUY6vQks9bRcmDBZoO8serUspzm49CABtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdX5m0sjsG9ybbyIjyfC40NWPaxyira/8qCtol2gmZg=;
 b=BisNEjKbmF/J5apZhGDFh4t0tp3jCETIloMseMWxBDJRCXIH3xTzTOi+OYlN/GL6/FS/iWeuIy85bwKhQ5zBfcAznD2JnGlGAqXW52+kq+6S7KKaWb39wkn9gMfFkc4dQeUHJF9aw9qjqM3pZe3G51Zd0Tz3eWDI+kAVkgP7EnF9SJ/WkTBMi28eE3JR94kdiYtZL6IKqIWECRNWuTB4VTfgjLX90qYX34SthQCmJwsilVBiHBUrJVWfJ/0R4/a4+PdK2LHBI5TKjnpFC54Kf0sIfTf6lDh+0fy5QZPwRJDyRhVtTtB/d4cs54bC0rp70F/MUD7cWDwkiBoEK7WVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdX5m0sjsG9ybbyIjyfC40NWPaxyira/8qCtol2gmZg=;
 b=ZlQ+etOQQdAUO9343H7kgxkyM2fPNuRJBsO3H/RIKq3Px18nB5eKSN3Mreh2OWw1X3Oxw6amngAj0Y0TQJ+KZpQJERRQxSTrBYabIURpaeHOLPrVImAmBvUGmwKNMBHAkZ9Nctl1dR9gkf3KuobUgZGus51fVTCXf6vFvfi7Fcd9UrWaRuXbfJF+0esaFyeuWTOUIcNrZO2mdOuQ/DO9sR3dIzt7bppUcbL8Evb5qqoKvJt1FFwJFEZVB/o7Rq/hZqwXjfs4I8ZnBIktslq4Ch4b+HwKNZj7AAOk7WsnTvq/fcH/djDdS4UOc1rYdH6ChoB3yXrvRiryTEr8LmafUA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:43 +0000
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
Subject: [PATCH 04/18] vfio/mdev: Use struct mdev_type in struct mdev_device
Date:   Tue, 23 Mar 2021 14:55:21 -0300
Message-Id: <4-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:208:23c::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR18CA0014.namprd18.prod.outlook.com (2603:10b6:208:23c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 17:55:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgc-Av; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a28af4-dc40-48ff-f1bc-08d8ee24def0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4943AA7140E856B1C7011BEBC2649@DM6PR12MB4943.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PucYBGKYrWxlOp3aVZG2NjcI80k1Cry3TqSa8ZOcP4InNg+4W1e8mrV44CpqM4Dgu9yNveerkQdNzVr6Gmv6gUQpaedBnDPdDDBoJROz+nFhYRnFKZ/YxxwrQ9/6P3pHOmLY9RLblIQp0RNUpX3/0WePJmbm0bQVztE3Ym1V2HhDm2dAO1wah+AErlH9/8T/IA1ilviMf7FExxuHnzsdndWEtyEBMu1dBjmGvlTB+EYRWTB5JfkqyVsej9G6LQU/x6SC+THdpL7BdgBEl/2HyBJbEwrJD+CMGyxbtmcNPTLSBnMNKGAwVMod1UOoOsqN1Uhty+LKjfjlTMSNPqN2iUqH2ZPQAUWBSvK5Qvhmg3yWzP2/5yPMbO35jMataVAL6ZF22XOZD56p6mZxu7Km3CV84c3vnac4T9JMgQlgq42iaut3wuVD00BD4v/jwPiW2SvioyqBZbJH4DnJDeLSJEIMg0qEYju0XgMp6jTrtQ/aCmpzvetjpy5kR9a5CzI+nGZsWjA1clobrVjAYcLIxhjTZDZoiHRhq5SE99ug9llYqQb1vB8gwBuQf7aXpTHHhfF0YlDj45ZSpDPDEKqGpg0jaBLMtjZnLz00pmkuajGyq4sbsobrJV+xpjPe7QkvPyhnGQ+TDozh2uWI9i1TcQwZyhgQmFTGQrgMIhc79nI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(66476007)(186003)(107886003)(6666004)(8936002)(110136005)(36756003)(426003)(86362001)(54906003)(83380400001)(2616005)(38100700001)(66946007)(5660300002)(478600001)(9746002)(66556008)(8676002)(4326008)(2906002)(26005)(316002)(9786002)(6636002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j5pw9UDA/S/YtKRqZaTHMoaYJgppSI2BjxE73JO9F5CLikjpbCB9UT+Jj3E1?=
 =?us-ascii?Q?bzpZEM29QEF9Kf64339c1C3gt1uqYOLhjRwnoVfBXJoTR277zlQJBmIU8oSL?=
 =?us-ascii?Q?kTHyJ32PYb/PdzH8NY9O5qhUd2PeYGrO7V0mRctYfSlq32LwSo78FsMI6B8a?=
 =?us-ascii?Q?+z250k/Hi/MZvlyVmRCRICz1TofCm5eylqjVTjy3lRGn/Wd8td/hFsxptACE?=
 =?us-ascii?Q?YTJ2S6RGCdXXt5FbJ2w+qTYCYu0N/npjlBUDHgVibBVZUjH9qbhDaKpQ1BpH?=
 =?us-ascii?Q?FfmGxXgpPDpURzi7/xl1o73dVl41roK32dorm9XiL0+DETaYZ2gmvQhQlr5S?=
 =?us-ascii?Q?VNiRBbYJkFb/0mCSH/yaQ128adMmo5ZbeyPFBZqkyZMzBWirSC//8dWU49cM?=
 =?us-ascii?Q?XsT1quxT+cnPt1U4hKGuT90fOyaLPDt9TEJQeP3Iw77Wih6c5YRyoI2a+cjm?=
 =?us-ascii?Q?ibq8NrYqvIZqz8zYY3il9Uh+PxdxLySUf13VgkIeS6hRSrHT+jc5Z62u3mCc?=
 =?us-ascii?Q?rsQjPlBsxV7m48rML+C/FMODIMf5x0AtChCg5bqv/b29ROafyM3MajZJUCQu?=
 =?us-ascii?Q?Bh4M/eoeFLCpAfm2+xdS+l9Kx2Jvm4Zi4tgwTsCVeztJ5KnsePqrAglT77G9?=
 =?us-ascii?Q?WX3m00xQDVPYsXpi8VTH2pks6V4Q329r6SaMUZ8G7tpb0cH9M1CiA0MM0enC?=
 =?us-ascii?Q?qWS1RK1+Ep5QHPTCPfG3Q12noIciq+VmlodG0xXmuFAAXKZLZIeLEIPGNL1W?=
 =?us-ascii?Q?+6z7NSEhz9/XBpUyY7Q0PIjSwvzQIZpDErzAZLgwk61j+6bqy5QRbJioODeS?=
 =?us-ascii?Q?UvDKylKLMhTIbi5iOkLwhhOsL/R+gVuDq6lkZNGVOzAFkvrgMGZ4qkDs1ldP?=
 =?us-ascii?Q?tr0N3FksR5XJCXuMmqS6It9VtE2LFFCneGX34X5WDqNUowmaTAiu5+0n3KG8?=
 =?us-ascii?Q?72OBSjKN0kezSTj9jTdnCs32R6xk76HmRGNXQyPqDuehq8VG87tEzyoNLJyj?=
 =?us-ascii?Q?SR/LfJBJXTwLZzX3dGqDGNTSF8SkhhpDgultuw0YZmt7a1h/u+iPZLkKh3El?=
 =?us-ascii?Q?c+lQnI3G0riTfEhgF5vef7QGEJBkh4DxvrK7u50KDRrzl6bGd1ROwgfz8zLj?=
 =?us-ascii?Q?6hmCTrWO0LqpSubfKVDrvtwFJtIPsh9mz3aBGEpe1PI1tnT/Q0UmdiSthtdS?=
 =?us-ascii?Q?98LOhCOWzkZZw/1ySMIvTkz6dJ39gXKecWBVPuYQ3x0pfGXuoW5SuzGN79tz?=
 =?us-ascii?Q?kvGL/qMA88t4SC3nmTXFDedgESiZoaSQmJ4mp+h0on1lY+rHbuRQpYqMIorN?=
 =?us-ascii?Q?iU53BJQBl8lZOtB/EduqVGkZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a28af4-dc40-48ff-f1bc-08d8ee24def0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:40.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UDJXyDB+AOSvS0bkAC2JCbDjEg3sT5lS1g//Da5hKvy/irC/qeaND3H1xZMIbXp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kobj pointer in mdev_device is actually pointing at a struct
mdev_type. Use the proper type so things are understandable.

There are a number of places that are confused and passing both the mdev
and the mtype as function arguments, fix these to derive the mtype
directly from the mdev to remove the redundancy.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    | 16 ++++++----------
 drivers/vfio/mdev/mdev_private.h |  7 +++----
 drivers/vfio/mdev/mdev_sysfs.c   | 15 ++++++++-------
 include/linux/mdev.h             |  4 +++-
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 057922a1707e04..5ca0efa5266bad 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -73,11 +73,9 @@ static void mdev_put_parent(struct mdev_parent *parent)
 static void mdev_device_remove_common(struct mdev_device *mdev)
 {
 	struct mdev_parent *parent;
-	struct mdev_type *type;
 	int ret;
 
-	type = to_mdev_type(mdev->type_kobj);
-	mdev_remove_sysfs_files(mdev, type);
+	mdev_remove_sysfs_files(mdev);
 	device_del(&mdev->dev);
 	parent = mdev->parent;
 	lockdep_assert_held(&parent->unreg_sem);
@@ -241,13 +239,11 @@ static void mdev_device_release(struct device *dev)
 	mdev_device_free(mdev);
 }
 
-int mdev_device_create(struct kobject *kobj,
-		       struct device *dev, const guid_t *uuid)
+int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 {
 	int ret;
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent;
-	struct mdev_type *type = to_mdev_type(kobj);
 
 	parent = mdev_get_parent(type->parent);
 	if (!parent)
@@ -285,14 +281,14 @@ int mdev_device_create(struct kobject *kobj,
 	}
 
 	device_initialize(&mdev->dev);
-	mdev->dev.parent  = dev;
+	mdev->dev.parent = parent->dev;
 	mdev->dev.bus     = &mdev_bus_type;
 	mdev->dev.release = mdev_device_release;
 	dev_set_name(&mdev->dev, "%pUl", uuid);
 	mdev->dev.groups = parent->ops->mdev_attr_groups;
-	mdev->type_kobj = kobj;
+	mdev->type = type;
 
-	ret = parent->ops->create(kobj, mdev);
+	ret = parent->ops->create(&type->kobj, mdev);
 	if (ret)
 		goto ops_create_fail;
 
@@ -300,7 +296,7 @@ int mdev_device_create(struct kobject *kobj,
 	if (ret)
 		goto add_fail;
 
-	ret = mdev_create_sysfs_files(mdev, type);
+	ret = mdev_create_sysfs_files(mdev);
 	if (ret)
 		goto sysfs_fail;
 
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index bb60ec4a8d9d21..debf27f95b4f10 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -40,11 +40,10 @@ struct mdev_type {
 int  parent_create_sysfs_files(struct mdev_parent *parent);
 void parent_remove_sysfs_files(struct mdev_parent *parent);
 
-int  mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type);
-void mdev_remove_sysfs_files(struct mdev_device *mdev, struct mdev_type *type);
+int  mdev_create_sysfs_files(struct mdev_device *mdev);
+void mdev_remove_sysfs_files(struct mdev_device *mdev);
 
-int  mdev_device_create(struct kobject *kobj,
-			struct device *dev, const guid_t *uuid);
+int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
 int  mdev_device_remove(struct mdev_device *dev);
 
 #endif /* MDEV_PRIVATE_H */
diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index 6a5450587b79e9..321b4d13ead7b8 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -67,7 +67,7 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = mdev_device_create(kobj, dev, &uuid);
+	ret = mdev_device_create(to_mdev_type(kobj), &uuid);
 	if (ret)
 		return ret;
 
@@ -249,16 +249,17 @@ static const struct attribute *mdev_device_attrs[] = {
 	NULL,
 };
 
-int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
+int mdev_create_sysfs_files(struct mdev_device *mdev)
 {
 	struct kobject *kobj = &mdev->dev.kobj;
 	int ret;
 
-	ret = sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev->dev));
+	ret = sysfs_create_link(mdev->type->devices_kobj, kobj,
+				dev_name(&mdev->dev));
 	if (ret)
 		return ret;
 
-	ret = sysfs_create_link(kobj, &type->kobj, "mdev_type");
+	ret = sysfs_create_link(kobj, &mdev->type->kobj, "mdev_type");
 	if (ret)
 		goto type_link_failed;
 
@@ -271,15 +272,15 @@ int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
 create_files_failed:
 	sysfs_remove_link(kobj, "mdev_type");
 type_link_failed:
-	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
+	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
 	return ret;
 }
 
-void mdev_remove_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
+void mdev_remove_sysfs_files(struct mdev_device *mdev)
 {
 	struct kobject *kobj = &mdev->dev.kobj;
 
 	sysfs_remove_files(kobj, mdev_device_attrs);
 	sysfs_remove_link(kobj, "mdev_type");
-	sysfs_remove_link(type->devices_kobj, dev_name(&mdev->dev));
+	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
 }
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index cb771c712da0f4..349e8ac1fe3382 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -10,13 +10,15 @@
 #ifndef MDEV_H
 #define MDEV_H
 
+struct mdev_type;
+
 struct mdev_device {
 	struct device dev;
 	struct mdev_parent *parent;
 	guid_t uuid;
 	void *driver_data;
 	struct list_head next;
-	struct kobject *type_kobj;
+	struct mdev_type *type;
 	struct device *iommu_device;
 	bool active;
 };
-- 
2.31.0

