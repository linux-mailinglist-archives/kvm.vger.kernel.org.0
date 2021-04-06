Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91741355CB3
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 22:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347163AbhDFUHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 16:07:45 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:34721
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347152AbhDFUHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 16:07:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+3mZx1ik3emvqw7AkGcOEbMnxs/1x0pvVovKVm0N8UeIuO7KEb+iAAKN+zRKW1bjQQlOpWPxeJK3+Sf3xnHX4/Mi/e8EZ9J/WcYdJSP6165UrzutdHame0pL1h1pLWXymXEuhNyilrTjDDwZQdJOj0RC91rp1r9/lZDduIsio7/nJzTTXRqRjCxRCMpLFQk7qNc7yVn/Ucuvv9TsCw8wByRf3+QKFi8e0+fWtWw5l32hddCoNPT/Pk4li4jhwsxjJEI68IX3t4cCBQZD7k/nh3AYoKxTtz/MsUTaMMNSZ/Bc2hf5WDyqlsic8m2ai8NN1ZNHL7EwI9Ry6sV+VgT5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UI/atQnQogvyBJhXJaBBwTUAQKs19OgDMKMYAcuZY8o=;
 b=XVA2IOMCq84dYXgGaT4J3Lgxy1HfKH7PiVpD6Exwr+vv04uIAprlSo70qIkYKNTrSTlVajGz0f9cIf9MvN6jsGdGBSP5G/4LxMi7hKsn9alDBsNzTEw1eFJxBH4oEumbRKm45qeozEPm1hgkdPXbtpFxJN5XGF7Grt4xOQCZX7xYr7/x3xMKPvswtBz1156CX9ccqKq4Qz9IlRqjW+r2hdfW+zLCM10qdvw7FtHkugYwwAzQD8DIRWabtAiHSEQbdae5iZO4oDDehtoCcdaZ8l8hBuwoZFPaOEmtkSYTG3KMpU4LAUlIwNUGjQjGyjuWSw9k1db9DaUR/K0hiBVq0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UI/atQnQogvyBJhXJaBBwTUAQKs19OgDMKMYAcuZY8o=;
 b=YGD6YALCxlOPfGF3KxhNsv9y4/OjpdCFwVLYRnaewL/mj/LVjOK9bhrEOJNzsl9WsfqetCEdHciWGTn5tagr9/XprhMpUmoym6uOnneUx9kVYUyPtyM+JXDXC1wM4gAscynf6iB08pnM6L39cgyNutlv+EDWyp76pd1SkGrJi2WqIrOMx2K57ZKHiGfbTHJxPF6WES++HlqFakFr+MhdmTTCZmeylNc17AP4fC/fv7P2e0oYkUBbTIRYgRXOPc5EMTkSLN7ci71DdEN9APnsc2pGzlIP0b+jcieZQ5QTz43sOmDDLu681RJnrvlJe9mi4FoI94oMAlXWlDryLVqCtQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 20:07:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 20:07:29 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 05/18] vfio/mdev: Use struct mdev_type in struct mdev_device
Date:   Tue,  6 Apr 2021 16:40:28 -0300
Message-Id: <5-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:208:239::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR08CA0001.namprd08.prod.outlook.com (2603:10b6:208:239::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 20:07:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mX8-1e; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71dffbda-dad4-491a-234b-08d8f9379b00
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18835549CBF0B3EBF68A7F05C2769@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWpoB+3c0wGaZxSiRFhsJPU7A7UDFy62LP6Lw1ZXaMm3ju/xeXoWg1olbrksfk/JFjI4AZJc4Lrmxro5+C2YE00CbDpK8LRxVekOGr+VWjFaAUOvfeJaxXRuRU99GEIV5rwtom8P2l6V3NlR08woI/5Y9bzwj3iQwmtCkz8D/Zg1m7cVVBv2vO0zXdDasOjVFxqxg/b97j+CGk5i9rLalnOcF4peZ8yQdFwTkmmA4B8fYz0m1tMubLTGbcCOZ31/CqzKzONeTzVVAs+XpLHe18XiUGxOUj4nJlY6zHbqS9h5+zLabSmxVWKmg5N5U/xmhJ1sSRltw+NMTIY1PUZX9AGpOaqao6Y2A9PAyIRuduaDpP15QkDdA6UHibIY2iq27tKeqCvw03wz/Tzk3J2+7aUPSbKmsLLcUpatKSIvYhOCaZNwwwJF8TyVkz8gxmIk3aYXIDdw1GS6DIAovOCYvZ2zuPc1Y6w27WjzqoZV46CB/kmeGkxafqtk/+wjkR1lGXvG5b9HKr9y6eCT9yWBcQDwg2KBjhZoBUkA3JZCQHhDnqYHPSTAai0DACshWtAKBwX2uEoNvVut183dL4QKSxcAuTVhANqU4JrzySHhaquKQDuLpUpnzZEZc0mptjwu/YgLsj3o82Bbx7r7FLpxMIc8jAKhX/KazjhOEj7gfBD781R/3UMGV7Hh1z6aMwcr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(6666004)(6636002)(38100700001)(186003)(86362001)(8676002)(8936002)(2906002)(2616005)(316002)(54906003)(478600001)(110136005)(9746002)(83380400001)(26005)(66556008)(5660300002)(66946007)(107886003)(9786002)(4326008)(36756003)(426003)(66476007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g4cvrWtDRm326ZEwOkADKEnzDr2bvPh3TNDJVNechh93V9ri2HE4hUT8vrmY?=
 =?us-ascii?Q?zqrnhHblkE9FdryUt3QZIn7P49iM6MMRJQoZhZOBpD4A/U7RTQ53AONp5LkK?=
 =?us-ascii?Q?chOgFE3BF1RCpwa2eu6cEjRpx00aCzDhqLayPDPQZJqFUmxtJW11jTWcf8uT?=
 =?us-ascii?Q?I9cbjW27Qb3na5QOT+Tj2tvCKo/NI4sYreJyoHCHtxUnnZXFEO6ahW+Pqi5R?=
 =?us-ascii?Q?WyVrYkUYJSoGp/ETACRpzty7uYaADLE/ilg2k40uMPMxcujBdx9M7FCcquVC?=
 =?us-ascii?Q?XDlYJtW5bXpPUiZpZQjafg7pPIC+7qvRE7Q0E42YusWGxWfsefS0qrGhjwbD?=
 =?us-ascii?Q?F9q4qup6vcvMPHumwiGXMQQoMxYBaSUPDE5vjUZzvCgTGRDgzcWWuHZQtQMb?=
 =?us-ascii?Q?Fx50IXHA8n2tAdpd5H/Yf5q+m7i8ruCNTSUl9NCpxDzBYBFljqqohuYKBG36?=
 =?us-ascii?Q?ZtAaQgemSIoJVmZno47WBgmX+kTItiddPF2cAmYII28fczJOKVGpQYFcmSin?=
 =?us-ascii?Q?xCs+rqRf2rZMs6d8c21DWnL/25/1g+B2K1dJ1NwmcXvbDVsqCeDBNlGbkVEo?=
 =?us-ascii?Q?QZO3ZW5ISk13jui/u1XBRj2b1t+Mfar+cuedF3YdqmqO/ENHJWOhFmlgL+qV?=
 =?us-ascii?Q?a0ezOVp4j3eUemH2kKHK2X33Rsrx8nt1gzcsKk9Yvf5gjoa//z6+jgm/b584?=
 =?us-ascii?Q?4pG8fv6NKEUsXWTynB/xTRVFAx6oztVGDFbfjLDdVf+P9RPQJIvVs37uSIjl?=
 =?us-ascii?Q?zRjsKsIY5tVo9LhOROP2HFblDz+SreOiMbG/CQrUgDiJKdEDEgqvvUKoLx5Y?=
 =?us-ascii?Q?grgzJfWWdW8PgOCEFW4feFPEhYzav2eVhBeFPgT/BrSlhoV198pzNoL+1o+U?=
 =?us-ascii?Q?heYC7h3QpaB7VPFXJp3CEiQ1K0CxOhiO5IyIZuXEnm9RbdChDp7+D1QueQFl?=
 =?us-ascii?Q?rWV9Bs+4GKT7jJf21JspcVkemXLHZOcXtEalyltJTRfn6qB0BZ03bgnWms5y?=
 =?us-ascii?Q?4TEIGXb1M5tyaqVmghVU71guWqqb/6PGWB1sztOzcrfp3sG+HuxNNyPsTtYn?=
 =?us-ascii?Q?ykX8q0Lk/Za+mdIdqt7x+QnbMrxPSijkHCcXoIpleFjZTB+s83gmUYMTEw58?=
 =?us-ascii?Q?QbjCWMv5ErpZ0+4JttfxpQ6Y9djPO8xZNeWGjTWj4Adqxg5Nw1yGpDiZ7lni?=
 =?us-ascii?Q?+f8bq9FXx3O5avvYI2+qdywmxvLweYomgp1aweFgTH8bRbjugqeUFg7A4DIr?=
 =?us-ascii?Q?KxS2mHHlU+KtaXpu+ICQgw6qwNwDI4fxDlhSh7lcTq12K217dsvBRI6VmbTw?=
 =?us-ascii?Q?/UkzNwsS+qTMzIA0LnRbfJdW491pXD2MmWO+IIYyklFYmg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71dffbda-dad4-491a-234b-08d8f9379b00
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 20:07:29.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmjD6GDJy/UD+TnDyIGDxnZL4r4pGnrdrCTblZHK4gvH/W2rRjHibFWmqcjLSfrJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kobj pointer in mdev_device is actually pointing at a struct
mdev_type. Use the proper type so things are understandable.

There are a number of places that are confused and passing both the mdev
and the mtype as function arguments, fix these to derive the mtype
directly from the mdev to remove the redundancy.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    | 16 ++++++----------
 drivers/vfio/mdev/mdev_private.h |  7 +++----
 drivers/vfio/mdev/mdev_sysfs.c   | 11 ++++++-----
 include/linux/mdev.h             |  4 +++-
 4 files changed, 18 insertions(+), 20 deletions(-)

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
index 18114f3e090a2a..bcfe48d56e8a9e 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -67,7 +67,7 @@ static ssize_t create_store(struct kobject *kobj, struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = mdev_device_create(kobj, dev, &uuid);
+	ret = mdev_device_create(to_mdev_type(kobj), &uuid);
 	if (ret)
 		return ret;
 
@@ -249,8 +249,9 @@ static const struct attribute *mdev_device_attrs[] = {
 	NULL,
 };
 
-int mdev_create_sysfs_files(struct mdev_device *mdev, struct mdev_type *type)
+int mdev_create_sysfs_files(struct mdev_device *mdev)
 {
+	struct mdev_type *type = mdev->type;
 	struct kobject *kobj = &mdev->dev.kobj;
 	int ret;
 
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
2.31.1

