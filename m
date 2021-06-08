Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEF039EB20
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFHA5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:55 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:6904
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231312AbhFHA5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJJIyiBJqGw3rHohzPZaAgGLbDkutkMf1Ove7fuHFqt1JDaaEqGqLE0G5hE5qwHgT70Kjnqs1dGaGAOjqDc4nX8ZSw/L7tcvtze/u8maSJ32adH4qZBe8A2TDe/dfFIqdiZn+J/XJuYvNSNAQC5EJPhD9ocF/pgOwngwxJnZkoeI2n/VWlOFIiDDLEu/zp1MupvhlW16MNQAmCpBMmp5sSdcFZeILiOGT6bB/cSgPU5nzE60FzPkzyYvqONeiMhrblnFdX7ox0mbr8obSDiBu663QjI/Zv5C2jeWCldwkeOJW3u0ZI/3lKGgiZVT+wII5xTvMDv2OJCDel1UfFM4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDTfNFaZujEsiIadzqsEi24VY7P/+itStba7KX2NQCQ=;
 b=ciAhMK679UNQzRyr9fNzglR+FNd34SOneO8jZdYHw8dfXUdak76ATXXwnmJ91KCUFM4YI8r91xh7CrIUa0yqrryQrrDbvvUDx82Xw6Ef3mSUXn+TqkkDeuJZy4GS+T4tOnjXu8K8xSz8rsX26fM766n+DxoNKxzczb85ZnJ3hCNol99APYjilTdQMI8qdUyqss5abmF2RiBBcit3xDnUobIoU3HN5LxlGGBDlBot/sypYrQw+HBOGDCPgoWPE07pa/USeEseey5l7HAFkR/ylWl3mduvNBcHfXuEeE1aIPv4Ii1FZMXkxdVvsfpR+ttG2QUQM+Mnh5KgdkjVdqNEiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDTfNFaZujEsiIadzqsEi24VY7P/+itStba7KX2NQCQ=;
 b=uke3z7k/R70t7L6llwlC0f3xE1qVOIUDkim8MRdcij+T2b920QOv1LysPnrDX4mHnm/sZXo+kGjRbNArHOLxsAMEIVFqtN4/x1+Vgrick1Vsnh+oUcoWt5qiKyYiYG8PUEE/ZC53jQPNCBnz+I454qFB0fNMAOPqVUHBRNAa6iMpTzdkDLZbnJc7JWqIZX1IrGVtO6xJuG7s74r6BgefdaVYwQBq+dgwueEEszsCyz85ltUGxHOe1XjBPyIgYn+jMw+gSjc2nRih/iL1bUTb4OP2rGRZYZXgy6B4iNSS91/NhWtHTUqrjh/w7D+bRohhpqyFkXhvRXmVeW4YExYoSg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 00:55:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:57 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: [PATCH 07/10] vfio/mdev: Allow the mdev_parent_ops to specify the device driver to bind
Date:   Mon,  7 Jun 2021 21:55:49 -0300
Message-Id: <7-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0258.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0258.namprd13.prod.outlook.com (2603:10b6:208:2ba::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Tue, 8 Jun 2021 00:55:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKi-L3; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fe5deee-59b6-447f-1aca-08d92a182bcd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB509557C10CDB65345EFA3D32C2379@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9We0iM/Xjr1OTDZ7fw9jY24Mvnye9vmqXALWmQiPOuWI+KyvBLdrTAFPzD4CecIBVv0XAv4tDK5yvZvnpuqobqaJz7kfhJtg+BXI2eDEUcZnLfXZ8eT5I+PO1d9HtR82OZU9LVCAd9Xw0zJlrqJZ44pxYr5Y0HbwdFyOu+oGZor5CXx6zK+Mqok3uEj0aznTn/iNJFlQBPKGCjBq4H3bPuFoiBV14Z1ZMu8xDok+cfCoRyjHPu9Tn8RrIOdrAdCwBQUlyaIWgktVIrX/SKaUYCI4+om0KjRr4hVtTX1xoY1li7lLbjfXrNRJUwQaAqeqIXCW+ES9bSGZc2WZgIczThCmYxJy125PI7cIzh4Cp9XTRb6AOFS9lWtz98y3R+vgQrj36Uw0vYQ3qaqTx+5EgU3JtFbcZIke0NK3HWvbsSaL/y+zN6Smez1Rml35BMvR9n7Km7ItChi8FXAyX+d+RqPIgaxADwM3AGKwmYbXbAK7ioks59nh61ViScXgiJHNVO7Ox9qNeQ2MAFyCn/2qz0furSI9BbyYfrFQfP/2VDSmgoeeiytP4v7g4wPan/wc2GV2Dtr3U0hAW6pCCw4iBoAXqo31lYLYgUpKaBkZhIVSPBZk43nIJW8mPD8uwsICxQNMDS06Pw+uXzhSmiMb9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(110136005)(2616005)(86362001)(9746002)(66556008)(2906002)(36756003)(186003)(9786002)(478600001)(426003)(6636002)(66476007)(83380400001)(8936002)(8676002)(26005)(66946007)(5660300002)(316002)(38100700002)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GnfRjeSj28V+zoYf9xroJNrDbyxLofh/uwdhcfPyGH1Bej/rSLoOgT8eUkMd?=
 =?us-ascii?Q?L45Spcm4k2QD8IO2/3kP/QbqkjhLXEdBHY9SMe/4IohMqaj1o8TATY5Sye5+?=
 =?us-ascii?Q?PTMJJbFUHpzxex+EU4VSVj/LW5DZfxi5fXAEXa7USrtwAvFFuwTA1x6Wh99Y?=
 =?us-ascii?Q?dqTI2h9ov8bAM2aQBisVUZUg4OtFj5TOZIERgZXEY/38Wg7qkXnHTny0KAqi?=
 =?us-ascii?Q?kA5VjThBxBGKBZ7xU4+D9jAEbaOn7lPGXCMMT3b67Ou0XcpaQAfPkt3TKKmG?=
 =?us-ascii?Q?nqS8R8IRVhpBDxUTdThzJUsGNK1N+GMp/ExJtaseRKqHbB6ipjuWN+q4H/6L?=
 =?us-ascii?Q?Y1I+b7u7qLO7VafSwn1i9C8/IgZ8FDLPEmS7NjGfHFO5kd62WPJG/5dITg6b?=
 =?us-ascii?Q?vzrFRI+pfMfmic04Vq2cvPig5WhtHRz8yv52xcmXrC4oHL2xymjBv2r3Ptt0?=
 =?us-ascii?Q?5z2cWcW/VaH5jp8nLKSTC3cALaOt12qCh+5vBqC11qwlKPc5wHJBfSM7SI35?=
 =?us-ascii?Q?/60bnv5fyUw4djCJRL5BRk5GNvlLjeI0mfVs3KKsqXP+VE702mfqAxH9N860?=
 =?us-ascii?Q?lGqa/yi7GretzoUN7U4OshDLc5t1xayRJOFY0jSX3VnuFdx7IiE0tVJfsmk9?=
 =?us-ascii?Q?+I/zgET30DBActReujjNqF0XNJKBEO3O3N4ugIQyfbyivuNHzcFb+HTnEknt?=
 =?us-ascii?Q?fdB4fDOr8vjQh5x00TjMlVQ7+O1p2a6uiGM4QeLf5KNbnt7FhLx8K9dYdc1E?=
 =?us-ascii?Q?qMOuvlUP8ZD1+8nWU7w+GoTbn4p6751MtLYKvCPQ6AkgKx0bNLKYmmT8EliH?=
 =?us-ascii?Q?QaausPkex7iO/NpubicXmoZRaRU3dOHh8U+RKbKiL7dJJAypDZvl3xLIKa9K?=
 =?us-ascii?Q?ZAQSxm6PJM8ZatEEDsQYNLsVARHWepfETJ9n6Nj5EiJHar7f2bl63cbk4eHP?=
 =?us-ascii?Q?EzTSdB4w1sk7N/ak58soFU/X1l4aaMHBnmYwfAKnaydhT1fD0wkCqY8Unxzo?=
 =?us-ascii?Q?Y1LeN6bmgym7HtpW1GM07BACs0NwLsENFhSAV1dXHP8ubvMacVSIsrm4XHfM?=
 =?us-ascii?Q?OKQA0zus+R30lZax9IPPd9QWZ+7k8S9cSlItKUudnRk+3Sd4m9nITrHqi6Hq?=
 =?us-ascii?Q?4jcYNnjNZL8bozMYQXziDcJ9TvPDPCdLajLHeWnvgcGH4fbBi37oj7MFl4Hy?=
 =?us-ascii?Q?GRHjhAdfIcNWmoko+ZMJeP6dAjrLr/Tcx2fi50/STFzMGaoUOJkVDBo3oCAb?=
 =?us-ascii?Q?nPxDQKGXCcEPWCpZVrZcEzL3EW6cmdYn/26+PleLo3+nk3pGNcue9WEUDFD+?=
 =?us-ascii?Q?6g9FVPyN8SN63Baddpz/qvCb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe5deee-59b6-447f-1aca-08d92a182bcd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:55.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JjviFUH2SCFDooMjbaWKzgZPfx/y49j9aqNHejjUiAUD+SmUAOQAAGVSZqctcHV7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c   | 30 ++++++++++++++++++++++--------
 drivers/vfio/mdev/mdev_driver.c | 10 ++++++++++
 include/linux/mdev.h            |  2 ++
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index ff8c1a84516698..e4581ec093a6a6 100644
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
@@ -256,6 +260,7 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 	int ret;
 	struct mdev_device *mdev, *tmp;
 	struct mdev_parent *parent = type->parent;
+	struct mdev_driver *drv = parent->ops->device_driver;
 
 	mutex_lock(&mdev_list_lock);
 
@@ -296,14 +301,22 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
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
 
+	if (!drv)
+		drv = &vfio_mdev_driver;
+	ret = device_driver_attach(&drv->driver, &mdev->dev);
+	if (ret)
+		goto out_del;
+
 	ret = mdev_create_sysfs_files(mdev);
 	if (ret)
 		goto out_del;
@@ -317,7 +330,8 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
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
index 041699571b7e55..c368ec824e2b5c 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -71,10 +71,20 @@ static int mdev_remove(struct device *dev)
 	return 0;
 }
 
+static int mdev_match(struct device *dev, struct device_driver *drv)
+{
+	/*
+	 * No drivers automatically match. Drivers are only bound by explicit
+	 * device_driver_attach()
+	 */
+	return 0;
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
index 1fb34ea394ad46..3a38598c260559 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -55,6 +55,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  * register the device to mdev module.
  *
  * @owner:		The module owner.
+ * @device_driver:	Which device driver to probe() on newly created devices
  * @dev_attr_groups:	Attributes of the parent device.
  * @mdev_attr_groups:	Attributes of the mediated device.
  * @supported_type_groups: Attributes to define supported types. It is mandatory
@@ -103,6 +104,7 @@ struct device *mtype_get_parent_dev(struct mdev_type *mtype);
  **/
 struct mdev_parent_ops {
 	struct module   *owner;
+	struct mdev_driver *device_driver;
 	const struct attribute_group **dev_attr_groups;
 	const struct attribute_group **mdev_attr_groups;
 	struct attribute_group **supported_type_groups;
-- 
2.31.1

