Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D499369CF8
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhDWXDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:03:51 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:47680
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229548AbhDWXDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnOMqSSYdM9nJbQhTkKSYD8xX17mMxRLrZclaIHpmg7nlunyY486GH1Uegaus/ggtSXDbGlAUzIdn/daxMQBP5/XkZhlAi/dqtCMC1+WakYz9PY0AqmHdwDuZ/n1tHy4gogFV6Cc/tCa/Xb61SKkVYeCd24T2CJHzIX2mCSrNbX5QaqFOZW9oLGyhImnuN6fwlZfBq3xpQQUT5XkHdKuJSfTMHMDk79q9arRkBRSnOKsoh/Bs+KPeLo9rUrQ5Pi6F7YbwhBQwwEHVznvDoptvp2lpaNSSNAZWNhfo11tG89Dao1V91bDLoNshSNdRH+X3b79r1bH15Ih2srBiVblQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frizBgNx1wYm+8kzECYvDIwb+hKH4+nzEO3MVHrVWlQ=;
 b=GFu81mOS2QF5SQi02jObARwW20ivwpoajU1XTvxYg8G3jDWb0gR8bEkgTLRA0Pwu2wiB98+nZb6PmR0r1qUkEmt6rYqArAtfJgxahjFSoBAf/s/oHs3UIOArJvrPaTE3rmEOtinEI2OW8LB2UcvYebVRiao5eQkxornOKOcMvT7RaDZdD8cV9eGN6WB+DCZjuUoYJIgLt1KDZTiFwgRoKpCWBXwcBeLNo+WdVBNMr9GqPNK0WW+GWS+Ce7XgkO3ulEcaPBsmQT998J3yNAFdNbCqgYkQdiYktWgi+IEfRyqPlVZn3SllugoWR2uWqfW2Vjn8qSUS18BcFvFOdOJyFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frizBgNx1wYm+8kzECYvDIwb+hKH4+nzEO3MVHrVWlQ=;
 b=VpkqbdStzOae3Q/WLHAv+BMkQ5Ie5q34jckC9j1puzHu9i2N4K6cI8MY2a5sIesyg23f1DdBl4UNMjsd9UOG8y9ozv7gFMKriBfvI4auBvC+WNYKPSgxCoKzSR9mG42eNViKgC2i/CtssvX8nTdec1C9pof43TpPPoPbqVDwHQmcrS6qLReBpjPk+JpBRZRa+NkKBjHl+9U+8u6/lcqqe4qYfDKb0BlzmtgE18wY1mYt/2nV3KgIBuPdjybPoDVCP8xsVtKz7l3AeDgzVteFr8sdLAr1o2G30BQnDOX6REUo4IHPTAG60w/tzZ+b0rExlxKQJLFOpL4bqF28mbxYhg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Fri, 23 Apr
 2021 23:03:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:11 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 02/12] vfio/mdev: Allow the mdev_parent_ops to specify the device driver to bind
Date:   Fri, 23 Apr 2021 20:02:59 -0300
Message-Id: <2-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR07CA0019.namprd07.prod.outlook.com (2603:10b6:208:1a0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 23:03:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pJ-00CHzT-Uw; Fri, 23 Apr 2021 20:03:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfd0ed31-cac4-4fe0-9faf-08d906abf76f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3513B9D49A51B06B6EC2E7C4C2459@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PiUf0cXCFD5q5Az0TmHaYKzUjMiArz7QM6NAHJgRTHvifk+tXVFK0cgvKcM9cYXloJpgRriUTPgr6wqcoqQFvbTJzm0oHCkA77Gf4AbYKHkM23w/fVIet4651ry0x3pslIyryuASk1+Cm9+RAGETzFWVrlOQaU4WidbN89+85f57VeOx5gkgwFZeImUpsHmPr8LiEal7ggBiw/uAWP8U+3O0UkTDssU6QdBNSwvAt4ph6EN2a4S9PvGJpNHEIRZqIpSiCqtV9GqySF3gCYA8qFy+RR+Dq82ADA5RlcPoT3G3WHzJ7f9UV3v+VRmlCQu5rpGTV0YWuVcM9UhilFhArV72/qYXKSEvJIa5tHP6ZOcmcXq0rE+0ZecM8Mv8QA/340uPqOUTbMJSH1xPYGV0joEcs6GLbca1pMAVVPztZBhnvRuaQo2KicuvQqtP9BoZB3K+bS2qPgBHvqSTDw55XikoEGQ0yjBXTYKLYPAOupzTabfZ90UDoqPM700QiOruFh6rOCtD8eDlK3EmFwRW1DPWeLgnPWq8AG7rjgNhBQkRZQKO+OpdEFHOACUMyqnOE/GchbLPsO2r2/CK6Cs64F4h5KxWIFqExK3hNMQsgw/aeF8riDT9ENzHJiX1d7PkqEVU1YCq71X155pJkSPonQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(36756003)(66556008)(26005)(66476007)(107886003)(426003)(8936002)(83380400001)(9786002)(5660300002)(186003)(86362001)(9746002)(54906003)(38100700002)(2616005)(316002)(8676002)(6636002)(2906002)(4326008)(110136005)(66946007)(6666004)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yq0KcI2e175SNNFytjFgJacgv7f7R108FEZQb4F7NCfw9mlX6Chp1jUxZXIK?=
 =?us-ascii?Q?kUPLKFDMNyw3dFwmDaDBwE8V6zjmzUszR2tT0sXgqdg5BFqtHMUpE4gEq20o?=
 =?us-ascii?Q?DeQ+xIYh+irrMIIn4qMp+yyvCu4ZU0ZXvLgS8/xA3Spt1cY3p5osprbFpKPN?=
 =?us-ascii?Q?RYTR0ZJu8g4zQam03oUMJ35CKBM9zvLdxNMtFEyAU5LQw4AJ94Io7OUggXXe?=
 =?us-ascii?Q?oX9TjqnJeGOdxzDr/sJlc8YRML8fNmMX5rxkYpo5sSEcav+shzqXGxnnJ05C?=
 =?us-ascii?Q?iZ5gLCP8X7UqEcPrZL7MGH00Y9FLQJiABRNQwtbLr4krF7dp6MDWn7LKA35J?=
 =?us-ascii?Q?wy3TRRNPi3ca2ZEFeSRskGqf8i/BCh1+qkNkHoc/HMwepamanGbHeUtTKAbN?=
 =?us-ascii?Q?hH4W0V+hPRNw5565wlkxJ2klSbzvJFcrWRsAM4VofSs3nCdgv3CTCFXMn4m4?=
 =?us-ascii?Q?/tRhTh7pYDOkoYrVBKbaa9VaElLZMEY+g0WlbmsmAaznZ1ok5rtyvr8FjA/2?=
 =?us-ascii?Q?+acLh3YRN0B3edHIBp2Zwkb4iDvgGJ7kGhIzkrZQTPOhvzPyyZQHvW/AZK1d?=
 =?us-ascii?Q?Mdf2dRLHxifcAupUCFcHUWOqVuzEb4iZDyEM5YqB31fVmivEvnPS2nTVaW2r?=
 =?us-ascii?Q?SJ2KDmeiHYCib7li7WDbcwhZeqj0GrEN4XkNPzEpveWJtfvfz1t99ILhJENd?=
 =?us-ascii?Q?fVivM5X+PanriX3YWt01x7CWTJDbCKR8bfj1/9KbSKIjAVfJMs8QogUdkQ/2?=
 =?us-ascii?Q?9HOyuyZnZg8/o+47Nm53rddD/RXwOLTzpQQ0+9xMRaWR7+7MZVwf01h/kZXi?=
 =?us-ascii?Q?/ckzkcsVZl7O11esS5/pjmJH3EpARlyxU7/y7E3tpQfPl5koug5SWf4EYvUc?=
 =?us-ascii?Q?SWzDhF6+Q3MrlnGw2ohYOOh68AbbqJXjUfkoQBQZfkmneot3jkFAfFhNHaZx?=
 =?us-ascii?Q?1o9/JsHUA7ggtvA6zII/6scj6836zYIvVk+ojK0ZjRFNcTFPpqVIbe5sbE1/?=
 =?us-ascii?Q?u8FfW0LPgfxYbNe7/rSm0RA9WiMskI3dj6fv0uJDEqzrj/whRpb96FrXMjo1?=
 =?us-ascii?Q?o6E3o/zbwqyaTZh2lP3eenw8PfI01PN0+oYYT4aCvPoMcAS35zR9A8b9237d?=
 =?us-ascii?Q?wSK4yq42QLRXdKoQC3YYG3fMDoycO0jKongHAJ0g0VWZEX7vEhuyptzVPKnJ?=
 =?us-ascii?Q?u7GHbwv5bcp7pEM6XKixJaoUvMjRWZseZGKWP6X7XF/A2iNgiF4VVTe8MmzG?=
 =?us-ascii?Q?3umOioC08xcEeDSxkzCAR8WGTIKZDtePfitf/kE1QGbAYu95kanVw530vQH5?=
 =?us-ascii?Q?wVyqCGNwJuDLD5sCsNYgqI12?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd0ed31-cac4-4fe0-9faf-08d906abf76f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:11.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhBGG2LUrvm1wvj/TU7BHmgFwpA0UZlFEuZlrW1JnqsMwsCSSKZbE6zcS3FNMUcz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a mdev driver to opt out of using vfio_mdev.c, instead the
driver will provide a 'struct mdev_driver' and register directly with the
driver core.

Much of mdev_parent_ops becomes unused in this mode:
- create()/remove() are done via the mdev_driver probe()/remove()
- mdev_attr_groups becomes mdev_driver driver.dev_groups
- Wrapper function callbacks are replaced with the same ones from
  struct vfio_device_ops

Following patches convert all the drivers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c   | 64 ++++++++++++++++++++++++++++-----
 drivers/vfio/mdev/mdev_driver.c | 17 ++++++++-
 include/linux/mdev.h            |  3 ++
 3 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index ff8c1a84516698..51b8a9fcf866ad 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -94,9 +94,11 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
 	mdev_remove_sysfs_files(mdev);
 	device_del(&mdev->dev);
 	lockdep_assert_held(&parent->unreg_sem);
-	ret = parent->ops->remove(mdev);
-	if (ret)
-		dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
+	if (parent->ops->remove) {
+		ret = parent->ops->remove(mdev);
+		if (ret)
+			dev_err(&mdev->dev, "Remove failed: err=%d\n", ret);
+	}
 
 	/* Balances with device_initialize() */
 	put_device(&mdev->dev);
@@ -127,7 +129,9 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	char *envp[] = { env_string, NULL };
 
 	/* check for mandatory ops */
-	if (!ops || !ops->create || !ops->remove || !ops->supported_type_groups)
+	if (!ops || !ops->supported_type_groups)
+		return -EINVAL;
+	if (!ops->device_driver && (!ops->create || !ops->remove))
 		return -EINVAL;
 
 	dev = get_device(dev);
@@ -251,6 +255,43 @@ static void mdev_device_release(struct device *dev)
 	kfree(mdev);
 }
 
+/*
+ * mdev drivers can refuse to bind during probe(), in this case we want to fail
+ * the creation of the mdev all the way back to sysfs. This is a weird model
+ * that doesn't fit in the driver core well, nor does it seem to appear any
+ * place else in the kernel, so use a simple hack.
+ */
+static int mdev_bind_driver(struct mdev_device *mdev)
+{
+	struct mdev_driver *drv = mdev->type->parent->ops->device_driver;
+	int ret;
+
+	if (!drv)
+		drv = &vfio_mdev_driver;
+
+	while (1) {
+		device_lock(&mdev->dev);
+		if (mdev->dev.driver == &drv->driver) {
+			ret = 0;
+			goto out_unlock;
+		}
+		if (mdev->probe_err) {
+			ret = mdev->probe_err;
+			goto out_unlock;
+		}
+		device_unlock(&mdev->dev);
+		ret = device_attach(&mdev->dev);
+		if (ret)
+			return ret;
+		mdev->probe_err = -EINVAL;
+	}
+	return 0;
+
+out_unlock:
+	device_unlock(&mdev->dev);
+	return ret;
+}
+
 int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 {
 	int ret;
@@ -296,14 +337,20 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 		goto out_put_device;
 	}
 
-	ret = parent->ops->create(mdev);
-	if (ret)
-		goto out_unlock;
+	if (parent->ops->create) {
+		ret = parent->ops->create(mdev);
+		if (ret)
+			goto out_unlock;
+	}
 
 	ret = device_add(&mdev->dev);
 	if (ret)
 		goto out_remove;
 
+	ret = mdev_bind_driver(mdev);
+	if (ret)
+		goto out_del;
+
 	ret = mdev_create_sysfs_files(mdev);
 	if (ret)
 		goto out_del;
@@ -317,7 +364,8 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 out_del:
 	device_del(&mdev->dev);
 out_remove:
-	parent->ops->remove(mdev);
+	if (parent->ops->remove)
+		parent->ops->remove(mdev);
 out_unlock:
 	up_read(&parent->unreg_sem);
 out_put_device:
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 041699571b7e55..6e96c023d7823d 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -49,7 +49,7 @@ static int mdev_probe(struct device *dev)
 		return ret;
 
 	if (drv->probe) {
-		ret = drv->probe(mdev);
+		ret = mdev->probe_err = drv->probe(mdev);
 		if (ret)
 			mdev_detach_iommu(mdev);
 	}
@@ -71,10 +71,25 @@ static int mdev_remove(struct device *dev)
 	return 0;
 }
 
+static int mdev_match(struct device *dev, struct device_driver *drv)
+{
+	struct mdev_device *mdev = to_mdev_device(dev);
+	struct mdev_driver *target = mdev->type->parent->ops->device_driver;
+
+	/*
+	 * The ops specify the device driver to connect, fall back to the old
+	 * shim driver if the driver hasn't been converted.
+	 */
+	if (!target)
+		target = &vfio_mdev_driver;
+	return drv == &target->driver;
+}
+
 struct bus_type mdev_bus_type = {
 	.name		= "mdev",
 	.probe		= mdev_probe,
 	.remove		= mdev_remove,
+	.match		= mdev_match,
 };
 EXPORT_SYMBOL_GPL(mdev_bus_type);
 
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 1fb34ea394ad46..49cc4f65120d57 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -19,6 +19,7 @@ struct mdev_device {
 	struct list_head next;
 	struct mdev_type *type;
 	struct device *iommu_device;
+	int probe_err;
 	bool active;
 };
 
@@ -55,6 +56,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  * register the device to mdev module.
  *
  * @owner:		The module owner.
+ * @device_driver:	Which device driver to probe() on newly created devices
  * @dev_attr_groups:	Attributes of the parent device.
  * @mdev_attr_groups:	Attributes of the mediated device.
  * @supported_type_groups: Attributes to define supported types. It is mandatory
@@ -103,6 +105,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  **/
 struct mdev_parent_ops {
 	struct module   *owner;
+	struct mdev_driver *device_driver;
 	const struct attribute_group **dev_attr_groups;
 	const struct attribute_group **mdev_attr_groups;
 	struct attribute_group **supported_type_groups;
-- 
2.31.1

