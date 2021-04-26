Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEEB36BA7F
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbhDZUBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:21 -0400
Received: from mail-bn8nam08on2069.outbound.protection.outlook.com ([40.107.100.69]:56800
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241784AbhDZUBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/JzRD0041+Boo3f8smrP8M+Jmf8K4i2hXoRKZD+EVjK/MlOatMhuUo+ycgpWb0Oj2qEIkCBVL+RHnwp7PLk7DbgXPLHHwE1G7n+0a0+jyeX8NJfBDWhMIC/dOFJRsFa06FcFDevDg9Jv/eirJnEO5sMRjlDmHxm/fU3ww+DdoRbfR/oc0qIeIBdWkEQ9GV4t76OuRwH3SN/gQD/xeQ7dpxl925UZ+UUI+LY3GRcdMGnc517CIc7ovSeuZJhnDs6KgUHYQRiGl9tQe89c23ptw48ISnJ1A6suIHy3Hjf2w9y0b6Q80xHrnFAuWJuGNgylwt4VfwUYP35OWnW/PKQ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frizBgNx1wYm+8kzECYvDIwb+hKH4+nzEO3MVHrVWlQ=;
 b=hyivz3hwc8ejZP7mwnQyMnLCFp/dsHLleO5vplxcSMz2LKRPosI1s6x+BzqF3SCEh3AxVNUA5EuDWW4lItfrl0H34/EvINBWXOXbDDAH+cN6z3oE1inmTLdl1UW20HKtE9KBBHyUNOBNM4AjG/6MtQZLm6OZ7I5xgr1wlP4v8iobC0qJDWjpmKfogSiPEHTMvPnqAqHOuXBIGBjQsiHEHAKY5B75g0/Gl7KCcETFRSQfRjGYVQ0BeAdtjP8+l3PBXdAp1gnov/g8aoJ/HL0gkEglzcylfL5jvFoKSqnDoA4t3Y+FmajCTNypmeyYMJCumaUAQOoPEEjHowgDpUCntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frizBgNx1wYm+8kzECYvDIwb+hKH4+nzEO3MVHrVWlQ=;
 b=WTmWTStNhMTbeM9mKHdpQ+Diugsxf/wXrfb5oLYIKhpHfXMEO1dtaot+SQ00kFbfzy0Y4EmwmRZnhaYJ3H3MX8Em2wSWA/EoX9aRv/SPfU0Cka+sRYWHgIW167GWTOfnrRzqh06kD5YDuOhMCcN7ZVK8f9gz+4XwJkUvclz4QbjyBTS0JMr5+iYm87yIk/IwIVUbvy7cw0PsAG3Ov3rmi9SWCDJsW08vYpYXUSCts1y+pmQMQ9LxGw3s3tVFE89X+hNQJH6N9YlKZpvSuqz2SdAmbyYAqZxEMgFwqJjeeOGSKFSUI624XU6z9xuHqszKe2Y6mB21SyfFxYuJ9HoqAw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3740.namprd12.prod.outlook.com (2603:10b6:5:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Mon, 26 Apr
 2021 20:00:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:21 +0000
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
Subject: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify the device driver to bind
Date:   Mon, 26 Apr 2021 17:00:04 -0300
Message-Id: <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:208:235::12) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR20CA0043.namprd20.prod.outlook.com (2603:10b6:208:235::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 20:00:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Ox-00DFZ4-Oq; Mon, 26 Apr 2021 17:00:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a3ebf6f-6d82-478e-5fb1-08d908edea60
X-MS-TrafficTypeDiagnostic: DM6PR12MB3740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37403B19A54592E7F7F09AB2C2429@DM6PR12MB3740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLCkflvJg2rSo5mkeaStXMkq3OqNKxVdy18DjQPmQ5tf+JBrfnATBXsIxhDPZKfvR1nQdbSIsOIdflG0bPtMpfOqX23Dy7QbXEIAcJMKCmkRY4+v5MRvsBRFmpt53kmdrkRcvloxsm22EMvt16seoueAe9tlU13+yKq/0LWy89n3FNAqUKm/hAtvvILm/7L7maEK1uLC/KhaNrIVM7TjyGYFwr5/JrtlvNbJUNyGNF6NxA2+nJQvnfoNK+0VjvDd41Vlgao8KSly1TujR9dlDvbk9maZ32xEhIOSNe8GpsPbzfhbGhcJP67gFper1eJXNnKBA08WVpDVYEqHSKy6Shrob84g7mquuj9Bqzvyo0lEGpy8JOVpIINkSuJdsaBGnezVU5lvg/tLQpeVYSU25KaFaY2uI3v+SETIphVQuPa0crRBQQKi9vzFgAxWG95e5XW7OGiqEmS/Pm/ULDUbaoGIEycIIT1NIpf16/ku9p28dHbth8a7WhQP/s4BWQB+3eDOncZFln5aLG83D1DOHZL1saxVDahFcshvIcrsfdB17r7z2fB6GGTN2JkWC51vSFa3s7vtcL3ldE1jMilt/m6IUD1wPe9piPCJyLGlI4eUbASYbLN+LDNPi9XoOkd+kl8u7Vh1NwGug3k8rPmknw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(66476007)(66556008)(9746002)(54906003)(426003)(110136005)(107886003)(186003)(26005)(6666004)(36756003)(316002)(2906002)(2616005)(478600001)(6636002)(9786002)(8936002)(83380400001)(38100700002)(86362001)(8676002)(5660300002)(4326008)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?t6u/k8qDMbMARIyN8wdb+zXzON6M8+RI+R7KdAdToD2nEFYEgUBOJq+geh0S?=
 =?us-ascii?Q?ASJ5mF3Xd+jXGtaMVeEHIAm0jxsmMQd/cwluEqY+JKwXrdenv790K+d5Uf+O?=
 =?us-ascii?Q?M1PVzl0XKprgjZoejsgBufGxAyci0Vj6novwft+JoJcFdzA9ROBnvvWGmMDH?=
 =?us-ascii?Q?UKpUfaTHDJpizHukEPD/PImWkLfAEKHEIo/NQeU8AdlZ/jQnZkfoieG6wGbT?=
 =?us-ascii?Q?hXbnoX5xndZtMVoQaP2vOvE7RyuLzLKglLjRem5mnvzEgqGTonpkETCEnIZ2?=
 =?us-ascii?Q?rPwZGYwEQfXr+VmE1lZbOXb5MTHvx7qByO0alzJliQ67M8MReNFUEGVsrl/3?=
 =?us-ascii?Q?4NGWksTJsN+ERai9MPao4I+hdCOu+aOgoLHQn9EXMDiFR8iHtjkJt3gZWR8C?=
 =?us-ascii?Q?7jUiCNjEDfMxwYaNr6hPI/oGEgg52N30rHPE2tlCb+sF7HAvKriLlWotNZAJ?=
 =?us-ascii?Q?RV1pz89U8ogRJOb76NaiKIlSdluC+5Ew5Ae4YbrJmJVc7mA3Bsamf3leayzo?=
 =?us-ascii?Q?cUUoaaL5uKfE3dwMBn8yVxqe3A0L8Ww4KoiMl2yM5Oy13ONpsvSbz7fmqVZP?=
 =?us-ascii?Q?Vxc1eGvwi47sGvyR8bS6m3Zz1i4Beyyk0sIK3zWTbktikvmnymrPBDiAZDwG?=
 =?us-ascii?Q?3LNipVGF/QuTITz0I8o5wkGNz91H6tarA0m5YhDYGGoTjuoz0+h1XntoxqUj?=
 =?us-ascii?Q?wqapZ3btm6HzsFo/VZVZR9AzB3JYRg934E1t+4UxaHdI3UowW7i7r0mwUhO/?=
 =?us-ascii?Q?pHD2ilZqPyhWqSUv5Hbz4/YziyT9CVXeg/QI3D2dmy6CEOD8/IWFzqy5KcCt?=
 =?us-ascii?Q?cwPXmcUYYhNOE94yh7PjGs+sWzkJac6r1p+lDuxBH/RgS9S6mn2hxDxAcxAn?=
 =?us-ascii?Q?3RNyI5qKe6UVIqNhnbcJvqpN8QhOliBIXsfDcIYwYrA3RYrWJFJqAmzOzQCl?=
 =?us-ascii?Q?nYQRkZpt3YXETkapxwgo8xJB8mLSCFcUDUuIoANeSJHjAUjO16teipkXZXfx?=
 =?us-ascii?Q?1LloaVIGZ5mVXDOCJyZM1ypQnU73uMLTeQRs0rRy6hQOHgnEcZbI8VAnAjcA?=
 =?us-ascii?Q?Tu4mCoVu066+w6Rt00I/+UuQLKT3P+JjRF6Dx5hZFQRfWiCuE/et7bc8Fa5c?=
 =?us-ascii?Q?aHWBn4USRD1y037eNLiozpwgislCwVzDqL6x7GAz0x82zj92XHVrqN2E7oKR?=
 =?us-ascii?Q?nv6f5OlqROc/XVEKDdByGISYk0uVCdbTEyVlW2Vi7NH8DK5Verk11W9SxpDC?=
 =?us-ascii?Q?9XK12zYIxmMx5IEfdo+677aJj8SpilwzsB6TZRDrIRURXiuymGPU+6poKYA5?=
 =?us-ascii?Q?TQ58yAuCkXa6kkyCnEIVZYAt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a3ebf6f-6d82-478e-5fb1-08d908edea60
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:18.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mib3lEEIjgqlr5APBiiG3dDZT8wMlyuwHIHWivyY4Y2ufGOGQGKW6RO3eD2vhEjU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3740
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

