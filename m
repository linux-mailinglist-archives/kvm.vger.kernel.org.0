Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F62355C69
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244959AbhDFTlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:06 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244906AbhDFTlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:41:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZt18h4i1OqkF8J297eelqzB3fqodXfRRw2/wZpjxi4hmg+vJW1u6S/1SqfRnXQKtLoiC9kI0xJS7aP/D0OctZF31CD1J2FuV4AWoX2KD1F/zV5y4O0U3sIc6BaTtzfL3ljOec70VoSvFrplWzZAlWj4o9M18a+2yjadon5HDx1DRNbBWkaM/nXnlWp0QJp2GGmmRsPAAaUfxPo5/anRncs+NvnqZKEHi7iBIe0QoTKCo6QAuzcuK2gUUSJ/f9G11vIwGvUEojiRfmw4ft9BCSganR14iaUSy04LTm+Srw+80KSEUbhPkWn9KPNhiYfQO9bI7vGSqLUSeyUiUolw6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdyikCyh8+bLONJpcS0zgptCbWcNF4yIX+TOYuX6Xsw=;
 b=HATk4zHH8Hd66Y0nmxfe5O1b5Lv98Z8xY67q0MENz/QEkPLUD46d55SiImx+ihujdyOdKMe6UDYA2IyEtDAQH9lf8kq2RbpoknUJPU1OBr2TRZhUuc3iihUnr1U493pItRSY3mzNmzhrZSXXRf+lIbTnuMENjRb4WzdO3mzE5yACifJSI4qBUzk6iCTNtjkGDnzVTz+yUZHTFXqBNrOiHzAu1EYkrn0CP/uTw9I9ZGzDiHHPsJJkrXeEFSZqd92zj1LblXh4QtBj7uB249/mE/+V/lD7KBB5YG8nVeHrcdYOG2fgwphqITR2ymaS/lA4IQ15e/YcEQb4Yqvfw3xuHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdyikCyh8+bLONJpcS0zgptCbWcNF4yIX+TOYuX6Xsw=;
 b=AwJLSSq+urYOf4nKfl7anpLXLGrR6BqNQwDqNXA2WJT+ulghSRkubeQzktuDF5mDqvlQwr4cBU9sZzsZxttUhm7ZwTauRN1FKXxJuGapYGpr5H1PU0YDSga9I7wxbw4ZXpRn55foXLOj069jTIdyA5cgjgZYfK7Ktfy5RBQkklxFDzCNz5U3Zb6znKkuwfih+fvOdveVwwXLT7tHCdW2u6WUu2PkujgdsIVbG+x0iJOQLZfkzKOKKggGrLBtWns+9nl0qcZwA8Ajy0MwtF1pinNxkXaueDW2V87AmkSxwHD+K6tf11+iM5ki0iJXjkTyoo5pNLcY9kw1Q5d7SteQgA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:50 +0000
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
Subject: [PATCH v2 08/18] vfio/mdev: Reorganize mdev_device_create()
Date:   Tue,  6 Apr 2021 16:40:31 -0300
Message-Id: <8-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0148.namprd13.prod.outlook.com (2603:10b6:208:2bb::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Tue, 6 Apr 2021 19:40:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXK-5E; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f765d9b-def9-4180-feb0-08d8f933df21
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4235269319742F6D5B27C9A9C2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j16lpe+/FD3qvsdLVE5MRlMjDZ/36Kw5PXGIsB89Gek+WX1ftkESp6P6Fas5K8gpdjFCziSO7XwSSYWDS4Jfz2Z+IHoPocyUK/fYGQrAXLPnCX2TMi7ImyTbhInfCFbG1UQauY3kq9NN8oW6d/cp1J0BrTFfcAEvVUYjU70aZVLFdHFs/lJDxAQvs2RRM0/7MYLrAbm3X5jNr6rMbMxr4Am5IWnPcH2VYhgZlz2X/+WSOv+FXC3R7rP/di0SwiujpUYWz0Dsw0UWr9PJwGfYAOiLYDTeyKJ7P+y8SMv73QndiIQYtDcvEc0A+xcFLNRCNE1WfPF7+mjcdSK+cvTvcGK6yx5Dp41nftvTiUkQGAbxWT9ra8gx37iioMcyQC/2MpODm39l3SNiHpTO3t6Rtx9ejQ6Ck0aas4A4LVvn3ErhaejHzoUUgwCkH1VpHZeO6G0Gqx8k3d39YVgaNjJCWKzKjkVKtnlPDvnbaSvrlVWwBqAk5HaXECJj6jx5T1QcIL6+5fr2Se9c4hMptzy/5+rFJW9MIpEd6UYKDHdwBwUafoOn+GaebUEREfv8IaOMsxAZK6/mN8StmXtzUxrDtwCPsHUJg7RTeNaxjJb0XsBMYcA6mCXuIISYBCY+dP6hj6cxDA2nOLW3dCC2PY3bsY6AxtJo/9J++CGg1qOtlxXb/ls9nSVkmvWy8B76jQYM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(6636002)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(110136005)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h9mnEjIWxd2/3FJ3DgNj1b4p7ulhVKoxS65WKxRGP0cKWp7hvUAgt+JqEoA9?=
 =?us-ascii?Q?uPKfPHDEivSyOjl0cJNPCzYt5SWWb5Siw4a144DEuKRUp4hp7yJiUKRxCnDF?=
 =?us-ascii?Q?RQwywijXIFi1M5Vr8ihhg0LFo3CubYTZJUX/0gtS5vypoReEMhoRGOdtPnYs?=
 =?us-ascii?Q?F9Rht8wIHpfTEmjWADGUD4jhRpgT0mi2pYBAa9Y10Jn2QIEtUd6/hyv3NHs9?=
 =?us-ascii?Q?fh4QUmeNiVwU+PEuE9nBV6bsgW7y/fb5pAziYHurZMhAUbItTmC4m4P7EDFJ?=
 =?us-ascii?Q?fgf7UQt5KbaeuSF4j0TpvkEHD6/G2F0dJcwO/p97Lvumj2nGZttpXdyfv5Qk?=
 =?us-ascii?Q?uQVxUGf05EO6cRwq1TVK7XOQEij0+nehwVW0pblxmVEaGbY6+8G6H4FNECFU?=
 =?us-ascii?Q?Yy6Jpl1K6lDL9FN/hDltu2gdI2Ae/dNB2B/YPG+W5FesYICp2dhtfPrT3GBF?=
 =?us-ascii?Q?+VEUneMYbrSk967bM/3bVSQJqnxikQOVojIDj8u8XN5KBD4Ah3m71SSkPrJ4?=
 =?us-ascii?Q?ssKrHFsZyxSYIZhPAmiRxaG77QkNyPnKOLXjvcSkAGkWWmTd6yFeYTTGKrMr?=
 =?us-ascii?Q?jkNa5wGNw3Nm6AN/uKbc+a5fMwJB/eE+m/fi9K9CU4aJ4HIOOgNUr5XbQNUw?=
 =?us-ascii?Q?7SctqBhylw4NzXWMGkLsDayiLtT95MY0r6NMCQZXc8xSZb/9nSJtdW3dGSvJ?=
 =?us-ascii?Q?p6M4aQoxngjhKWJjBUPWIuSMSXwvENlzmd64WPvilgxB3os+VN5GI5YS4n22?=
 =?us-ascii?Q?IUO2SmRMBQFrJp4ybmM9EXAYOXGgFplbr4BS6jnXRjs0YGc1GQhdgKVm7WGU?=
 =?us-ascii?Q?z8QqVXrHOyQb35QgyksdByQOqxCWmhH3QDaoiNfHG3aPb3tUKAGmqCI2Q9Gw?=
 =?us-ascii?Q?Oda2J+C1wl1z1ow91z05iUgZZqrbiQ/g9ZsDujl2PiR5HXsnsOwsVxOUawRa?=
 =?us-ascii?Q?OQOYkFIp7eP5jvJPN5gAOPv0SbY4ncjH8sagZCUrjF9BzfUmP2iTVEfxm9zB?=
 =?us-ascii?Q?46LlkxGtEFwB5Xh02xxfelLuq/RTfK6ghP0OnVatBy2wnStkB3ImcU0ALXnF?=
 =?us-ascii?Q?7PscgYhgmkV4yAdQfhY35ZxLSllhw7bhXkGN4+GKPB+jtXVtuZJ8eWOsbXBk?=
 =?us-ascii?Q?18S/Gk9WXVgCKayLe2PH7zRzubzXhW9+j6Mo9gVhA10cxWULpOE+jOWRQNXO?=
 =?us-ascii?Q?Y+MwHAmXiW8Oq/hSYiQdirtNVf3eL6GoheylHeIM8ofvxjn4Yre+sXoTbwCH?=
 =?us-ascii?Q?pLGYvRjlFkhr8glJKLVfwC7145mrABXTCqtCxwjMaccioF6RMkwKbZbQFV6Z?=
 =?us-ascii?Q?iUfWr+CXdRIUW5dT7UphEjF0X1H+YUzE2u/LNKFxo6sIgg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f765d9b-def9-4180-feb0-08d8f933df21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:46.5764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYVhN3IMyEi9OJLdaDfhviLxwcDOoL0z1gnNLU+8tunQEEmee4Jgxy567IQWowVu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Once the memory for the struct mdev_device is allocated it should
immediately be device_initialize()'d and filled in so that put_device()
can always be used to undo the allocation.

Place the mdev_get/put_parent() so that they are clearly protecting the
mdev->parent pointer. Move the final put to the release function so that
the lifetime rules are trivial to understand. Update the goto labels to
follow the normal convention.

Remove mdev_device_free() as the release function via device_put() is now
usable in all cases.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c | 60 ++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 7ec21c907397a5..f7559835b0610f 100644
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
@@ -218,70 +222,61 @@ static void mdev_device_free(struct mdev_device *mdev)
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
-		goto mdev_fail;
+		goto out_put_device;
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
-		goto ops_create_fail;
+		goto out_unlock;
 
 	ret = device_add(&mdev->dev);
 	if (ret)
-		goto add_fail;
+		goto out_remove;
 
 	ret = mdev_create_sysfs_files(mdev);
 	if (ret)
-		goto sysfs_fail;
+		goto out_del;
 
 	mdev->active = true;
 	dev_dbg(&mdev->dev, "MDEV: created\n");
@@ -289,15 +284,14 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 
 	return 0;
 
-sysfs_fail:
+out_del:
 	device_del(&mdev->dev);
-add_fail:
+out_remove:
 	parent->ops->remove(mdev);
-ops_create_fail:
+out_unlock:
 	up_read(&parent->unreg_sem);
+out_put_device:
 	put_device(&mdev->dev);
-mdev_fail:
-	mdev_put_parent(parent);
 	return ret;
 }
 
-- 
2.31.1

