Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D743466F3
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCWR4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:13 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:64608
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231241AbhCWRzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJ2XJvp6SjRp7IiiBLl6DLtsi0yewb7d1/uZPV//2LplQ6jXUNA/ia40n2YddlLsIGqZ+p69ykPvztyndOQ5FTV0j4ZwXk5g25SZuYB10PY3Bvd/usSQD5gyRlIPB3x8JfU9OSF70XFiAh/+6ywgfyPKIyHncwTo7m/L3CgdGCI34ObQg0QzZPw5v8MQEoy0Q1F/MSsRF0eN2jfcODhuJ3P2dBKieGvIzv+78v6WQfgkEdzjHmStcxWl05GMe+jjYbcv4E5lV7drCf91OXEO/HlbcLr2P3VNBK1/R9b4TmZyhbg6MSHwj+jDBSVEcbozLy8GL1xi6ualNtLxJwK2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH0Dx0MLYbD2JA4072HoG+3YqcnhwH6zFLk5giWFPfY=;
 b=jdQJePkx0p8X7HPqu+q0AyYZ0qcSHpDXVqA2zQGkZhK+y5G9r6/d5CL/aZf46gV1Hhct035fy8TY9Oic6NpuTcWlV/iFy8LHxnB5uoGvdsONIY8qZPju/ZTLXaAxYF9Bmhn5R21Sy5HoU+cHM2aKTtzf0Lx99RDAD9sGHxwfKEyajceJNX5m0e8wbBLfDpQcgLj3eF0kAoi7Bb4TiuSwjkBLfJXHhem4qZnnx3AaOSQvuR1e0/a7KcZJ2irQiESYCkTLOPy24EAYwzT27io9/pKtwbuXnZqOlTXZy7EE3G0aD4dHKLyU1NJyNxBOmF16J2xzUIectcXMfWSI3J0GHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JH0Dx0MLYbD2JA4072HoG+3YqcnhwH6zFLk5giWFPfY=;
 b=Yc7CbC2RmMWsVAj6RqPfmwtkWTzlEeDsQoSnaQf9cY7VwMWApua3qeXycLRWd89+pdwh2d4vKuVum7BujPKxm3L4mXHNakt3nx3tQW2YGcPlOeV9X/IQ53Kd7I6WdQvRhVZon2pGpJ2VlwdiNUYo3jEywFNmxJIR03Vjr9cVVJpI8NJ5vecLcuztsGYE+OiDb109378/BvO1bxXJvmc+WMWKVErxiAVfMmMmM15pbK5/Jj/muE/4TPF7ihYjTJHMYbsBX6uUlnz5aiwVkA+ZmHgcIyly5MB3UCR0/4v83HSYQ6Kh+hdsvWmbMtczgTf8LTpiM2Ga2BcQcvPTCfKGDQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 23 Mar
 2021 17:55:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:41 +0000
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
Subject: [PATCH 08/18] vfio/mdev: Reorganize mdev_device_create()
Date:   Tue, 23 Mar 2021 14:55:25 -0300
Message-Id: <8-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL0PR0102CA0035.prod.exchangelabs.com
 (2603:10b6:207:18::48) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL0PR0102CA0035.prod.exchangelabs.com (2603:10b6:207:18::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:55:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgs-GP; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46a45c89-bb0b-43b4-85bc-08d8ee24de11
X-MS-TrafficTypeDiagnostic: DM6PR12MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4483CFE1B9E6F9EB8B461EB4C2649@DM6PR12MB4483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xq8ihY2L1LcF2jNcD2OrmOCBr2aVuQ1jFLDr1Z1XNIFB9G/oqoGeyjRh+ej22sSQ+5vozSCErOlazg11mniofygUbuRrqzwc6aLlX/B29gQI+/gyeo9LTy1SQ/NxCMDUdOlzPobjJzrQeiPEokI7uVace8agRPeBOtQj1GDuSLYPFy8TA9zqrL1dQeFAofHT5vOtd0vv8Db2fM4zwswvQOo3yzWSNOUXmJM8Xh5Wlxff08EvvdNJtQNRZqB+tw6CgCI+QeR0vrZAX4di8GKZp+VXQl1uTwtfHz8hqTQzZRZsbvo2oSmO5hgXE75C/A8p6Ywv1aHThM7xfpJHQEDWv1liA15pw/57oDOksvHc6ju3mDbMmr18117mi6UNi1U1gya1rcwetpeCD88j8Qb4D9r9EJMaLDKsnlOrAgygGoaMRyaoIaFljU8fzSucuSZg33GHz0Qx8yx6v11Go0iXYiZILH+XYRdsFe8WPzqpxjZMTwfRm1LtI3SMyrVz/CAsheqEpw4+3TjLx8TjlLbYljdJaGlDcKfN+Px8EO51oLSSyjYwWpB0zpigo9KETtbeYyIfp5NUYmPPn3lBW3lKfSRG4p39j4nbV4qPyl6AVrsDvZrmyJmCBo8dUUj/dYhQVvJj5nk6uY5cCeoP2VwGwYuRUucGPLxKUaryj+QrSD5goiH9hEaVwgfaVWdX7Peh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(186003)(26005)(36756003)(110136005)(5660300002)(38100700001)(66946007)(4326008)(66476007)(6666004)(2906002)(66556008)(54906003)(6636002)(478600001)(86362001)(316002)(8936002)(426003)(9746002)(9786002)(107886003)(8676002)(2616005)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7j6l6lFwaraownRhtDk8AasjmH85meW0dzZvK535LrtBBEGSc4RPzxLmDOlw?=
 =?us-ascii?Q?/Xx8cH7MU40vgMBne59CG2moWURNF86snb0za0IC1d9v1Xz9wiPQoYrbAhS0?=
 =?us-ascii?Q?jZQkDMXhgrDSIBaWTmtulqAOo/8767l4EKtJM2VkbJm5zES18y+e7vV1iwiY?=
 =?us-ascii?Q?y1ctwq4TjqHnNyGRWmDATjod1yL+am6Lsjs54xLZl7HpSSeHDli5/AL0ByK6?=
 =?us-ascii?Q?E5csBEWxxWZmyamiyLl+WhuiedRddYfY+8KjS4BRLR/DQSbyhj/JKLNLD/Tt?=
 =?us-ascii?Q?+UCIgkWPvnUWgpV/U2p8Q2kIv4ftTxy+2N1H0WArSKYvcxvtZ5i0JejUC6p2?=
 =?us-ascii?Q?guKBiK1rTPNGADAg42kbiomISuAqozUqVKzuf9FypVokNKHGgUwj2jOpx+FX?=
 =?us-ascii?Q?LUW70GBuF1kNo/nJzEEsSvp9KUS8e+JXCW/rHPDevDoarzIgE6ALYLzuFOB9?=
 =?us-ascii?Q?su5eNvA1YOX5i87aE/3QCrwYmHKgfAHGZGbGMP1suIHVKJuBg9xE3jQspThx?=
 =?us-ascii?Q?3SaKpPu2LhziGwn0wv6WbNyclNb41QiGzkSVmCgp4IW1vXgn8vS9z7U+/ke2?=
 =?us-ascii?Q?Ud6huqpNxXnlIwg7OrzgrOT4stvd6THldjIN0ZteGDFlszaRBiI9ca4PYalB?=
 =?us-ascii?Q?FQNjLJgCHLLMAPrkhfRbjwNYX5OIbT/2Fiml97oW9cJ9AOLOsKwz+Yd4N/BL?=
 =?us-ascii?Q?8SLvbtGPobxegj90TZg4JWDTVT5bRjb8OAed9lEI1cRByfaMKe7ZsTPyA8Ce?=
 =?us-ascii?Q?9kYllz9u4R7/HqUtswTbeKc6ZbuFBKIDFP0lAqFRW5XtCPL5MU2PsD3etkYI?=
 =?us-ascii?Q?MlZlXJE9xMUQwee4u1ZAg6YTy9VR81hrq0CL/5ckmonHm006rT7IKG61gw+p?=
 =?us-ascii?Q?7/WEbW02zsvxkSVHfXEExz5RVdL3u8ckGQ+7U/XGuEs6zxCB3MQb/aO5Y0zi?=
 =?us-ascii?Q?dw2lef/mLy55Qdbz7LVBTPqflGSocoaobhwaolxKEb8WrZXuaMk6DDEFyoLF?=
 =?us-ascii?Q?/EJbdXursZCRRv045eKC9StBCiDxq9K5vS0P3jsZf0kXJletQQ1yqNVZMaZU?=
 =?us-ascii?Q?JBq2Soa0+/deTXIHty1oo/FWFnKldDKNKv/A5bVULUFNu4ElOVkNhQn/UKh+?=
 =?us-ascii?Q?zkkGc33+NuZqojBhkn3OPmfAIOduA7gFjKKGdL/TMbC3Ky3RbASZKpSnDsRE?=
 =?us-ascii?Q?lbERTgGYvU7gu9Mi+jlEKVmPuDSlErVFXh6RNRosmBFl6SA5iT6Qyi6//dUg?=
 =?us-ascii?Q?yIEPx2+W5yPZVufONnSqSPDcssdWzBKsRDy47sqG8rSqYUjJJPSCg5DKLmX+?=
 =?us-ascii?Q?9ACLR3FjW+rThYLe0BPklXh8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a45c89-bb0b-43b4-85bc-08d8ee24de11
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:38.7957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUqmKmUO076nw1lGr7eFAM25yyZ0zriHkyAlBeumfHNpM8mrgJx91RcWWnSc+fix
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once the memory for the struct mdev_device is allocated it should
immediately be device_initialize()'d and filled in so that put_device()
can always be used to undo the allocation.

Place the mdev_get/put_parent() so that they are clearly protecting the
mdev->parent pointer. Move the final put to the release function so that
the lifetime rules are trivial to understand.

Remove mdev_device_free() as the release function via device_put() is now
usable in all cases.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 46 +++++++++++++++--------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 7ec21c907397a5..517b6fd351b63a 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -71,7 +71,6 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 
 	/* Balances with device_initialize() */
 	put_device(&mdev->dev);
-	mdev_put_parent(parent);
 }
 
 static int mdev_device_remove_cb(struct device *dev, void *data)
@@ -208,8 +207,13 @@ void mdev_unregister_device(struct device *dev)
 }
 EXPORT_SYMBOL(mdev_unregister_device);
 
-static void mdev_device_free(struct mdev_device *mdev)
+static void mdev_device_release(struct device *dev)
 {
+	struct mdev_device *mdev = to_mdev_device(dev);
+
+	/* Pairs with the get in mdev_device_create() */
+	mdev_put_parent(mdev->parent);
+
 	mutex_lock(&mdev_list_lock);
 	list_del(&mdev->next);
 	mutex_unlock(&mdev_list_lock);
@@ -218,59 +222,50 @@ static void mdev_device_free(struct mdev_device *mdev)
 	kfree(mdev);
 }
 
-static void mdev_device_release(struct device *dev)
-{
-	struct mdev_device *mdev = to_mdev_device(dev);
-
-	mdev_device_free(mdev);
-}
-
 int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 {
 	int ret;
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent = type->parent;
 
-	mdev_get_parent(parent);
 	mutex_lock(&mdev_list_lock);
 
 	/* Check for duplicate */
 	list_for_each_entry(tmp, &mdev_list, next) {
 		if (guid_equal(&tmp->uuid, uuid)) {
 			mutex_unlock(&mdev_list_lock);
-			ret = -EEXIST;
-			goto mdev_fail;
+			return -EEXIST;
 		}
 	}
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev) {
 		mutex_unlock(&mdev_list_lock);
-		ret = -ENOMEM;
-		goto mdev_fail;
+		return -ENOMEM;
 	}
 
+	device_initialize(&mdev->dev);
+	mdev->dev.parent  = parent->dev;
+	mdev->dev.bus = &mdev_bus_type;
+	mdev->dev.release = mdev_device_release;
+	mdev->dev.groups = parent->ops->mdev_attr_groups;
+	mdev->type = type;
+	mdev->parent = parent;
+	/* Pairs with the put in mdev_device_release() */
+	mdev_get_parent(parent);
+
 	guid_copy(&mdev->uuid, uuid);
 	list_add(&mdev->next, &mdev_list);
 	mutex_unlock(&mdev_list_lock);
 
-	mdev->parent = parent;
+	dev_set_name(&mdev->dev, "%pUl", uuid);
 
 	/* Check if parent unregistration has started */
 	if (!down_read_trylock(&parent->unreg_sem)) {
-		mdev_device_free(mdev);
 		ret = -ENODEV;
 		goto mdev_fail;
 	}
 
-	device_initialize(&mdev->dev);
-	mdev->dev.parent = parent->dev;
-	mdev->dev.bus     = &mdev_bus_type;
-	mdev->dev.release = mdev_device_release;
-	dev_set_name(&mdev->dev, "%pUl", uuid);
-	mdev->dev.groups = parent->ops->mdev_attr_groups;
-	mdev->type = type;
-
 	ret = parent->ops->create(&type->kobj, mdev);
 	if (ret)
 		goto ops_create_fail;
@@ -295,9 +290,8 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	parent->ops->remove(mdev);
 ops_create_fail:
 	up_read(&parent->unreg_sem);
-	put_device(&mdev->dev);
 mdev_fail:
-	mdev_put_parent(parent);
+	put_device(&mdev->dev);
 	return ret;
 }
 
-- 
2.31.0

