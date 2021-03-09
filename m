Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FAC33310B
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhCIVjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:09 -0500
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:49607
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232016AbhCIVi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:38:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5j1qiZKHTQaiCznXq/K6PdXcBXThwPx8L1OtrLOEQQT7FVa1ZHta3J4i2z820LIu7xe6V/evBPNyf27Y2BgcnJE/Y2O4CnRoIzCku/Q6nvRPEXoQKBkNjgezfwOqvOVIlwiJtMeV9olvYqiAsvzWUNP8uFiqSs/bRsSmWQQcTtCV+fb2fv4PoPqtFuztn8Ujem3Gyv9sBWs8Ki1Xur51BHIaZEsB36raCd869jBvOWqXxWpgtAf60NPCHjeSZPt8ErpRPmJUU/M9ehLzem+9QyLeUDcnuG2OfgHtI1ORz8rqaqdLMG75pkM46w1FzppMTMsP34zvO4T9zd2mWMzRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMQA4dWEDJuNUMCZeVI8jPtMdUXGyYBpT4peb2t74qo=;
 b=dgRG6CzFAqIN5WKBYWcLiKjWFSZREI5+LTko8xsFqdjFeZrgtUE2Fh4hp0CuFI66uUA8ucFksJjwxdn+CfWjiTSw0d47ctt3BUhcJmpPTmvT/zQvuxZ7KJKIHUOkYpvLosNye3kFZRBbkxFL/4quqkOXzqnVmhTSe3YqQwZuETFySYPqw4f47bSGLTIdLJwqhmCT0wR0MV9FOpqB03oPUVsug0SZk+vVpkXiuWvm1a/fGdSMNFzi/Y/8dTR/CYzo07MlNDs3XUndgaRPntfbFxvwNl9yi6yPbbc2WhJYFVSfsdelb+MKERNKoksZp0HJTHf9CZzxSFAArywWzjJfkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMQA4dWEDJuNUMCZeVI8jPtMdUXGyYBpT4peb2t74qo=;
 b=sYDJz1MCriFgJ3ciUoyF/DILIZ3Dz7eKHJaAaCSOMq5PBO5Gsw+c7s8478WDgUP53g3gwHuluDYQ3qrMrjJkalqSdnWj+bbC9B0qM4jrb95otg+axrKCB53BijoaPSlVnxUq2avIh3iQjJ/C0OGzLWFi8Nw+6/ys9yUT3b61WObsvihqQFiYNlok2chZgXXWISJjqUXUmorMi62YZzpZuDXi6r2hpYJ+81XwNhTxJCyXj+9o9QGpELkzPtSwVSa4UcEDttQszBqCR44UWXrkrnH/AB5mkGuWJRTsR7OuoV8hW1OZryuTZzxUOnlnMarr9+cRfLl1xqHw+WJBwcQ2NQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:56 +0000
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
Subject: [PATCH 06/10] vfio/mdev: Use vfio_init/register/unregister_group_dev
Date:   Tue,  9 Mar 2021 17:38:48 -0400
Message-Id: <6-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0029.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0029.namprd15.prod.outlook.com (2603:10b6:208:1b4::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVIv-SW; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4905d41d-b13b-4559-7696-08d8e343bd4a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2489:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB24895EE981D43D1A71D4F693C2929@DM5PR1201MB2489.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQYJ2ha2CLIrDAn12eN8WG//yCpo5qQUZOE25I2YtDtnRqGQgV+sCw7M3ycERyCAyA6+ajBwD+7NDMUWYSt0dPaVv8Umy2dcgjOGmyEzEq/NteiOA89laz4WIbVcUb6WeaVz+j4AZNc97s4SmD6qDm6e3I03M6T+32YNAuBIjCXgAGqlAbwwFtSm2SKf6WBLq1XeooADXvJr8U0Vn6J1K/fC35Sk4FdJkWDq+xNzXaQ+SvA1wxRkWDN1xpNuvtSRJprAaM999J5MlZJPLWjgvMSnJR3wVhH6ltfrTVjqyCAgHDK0jUxcr+Wa61iUQ4RY6YiW0J/NVydTmaD9C1SXOfsTioso1UPe9MFZhXXx1+LWLHD5e7YhWqz79vDYynQQ85y1NNGJ91OPPYa0Jg4WW7h/DA8v/TlSRC7Q2i9XDI1QB9aqk1M8fqkjNN5rpM3bBqJkmqpPote2AdXLb8uatSAM8CaWj9vPH3i4tkq52XeK8ANUlWP69YhbZjrXFvh4P84/N7wXHKklRq0q659YvdXa1PIoCXBCvUVC3sgL68u+/yvIwGkIfkrQMnd8bdu5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(6666004)(26005)(36756003)(316002)(5660300002)(4326008)(478600001)(54906003)(110136005)(9746002)(426003)(66556008)(66476007)(2616005)(9786002)(6636002)(8936002)(86362001)(186003)(2906002)(8676002)(107886003)(83380400001)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BwoyZZnmeaDlF9ceLZg9vyZbGDCBCoibtCTU9k15NPUTBuhEVz6sP5bgts2b?=
 =?us-ascii?Q?IQMdKq1+6KQMt7Z3wdL6A2JnjqgGEGlTd5TEswtXiDJI+6mYk1taF43MJsYu?=
 =?us-ascii?Q?bdK0zf/ZVV+k0QQXxhd7BKvLYXCcSpEYg586pthDlJ7dchT+u157UgJfCcUl?=
 =?us-ascii?Q?Adn3qpdLsZ8HvPwt0ZBAE2gI90b88lNl3IXS9UqGkqbGceGKme6D54E0uIW8?=
 =?us-ascii?Q?i4vO9jpFoExWUqMuD7N7nt55O1KZJFVIKvfd2JfE0/1YLjVXG506o5V2sVLd?=
 =?us-ascii?Q?H13NI8V/wsa0Pli0UM8xnypFY5d9gPoJTy20Z9FmEiSQ1jolrhSwYzFQ3P2X?=
 =?us-ascii?Q?Py/iEZWYB+BZTrTeHozfB2410fiMpF05zwwvREEPS3LoE4UFGFn4DtLOtQ3m?=
 =?us-ascii?Q?qJ0tFjpJoI1V6NsVwpwBZfoiZc7nOxzKrCub+8/ZFxPxR8/AAd5N4Mx2yGDN?=
 =?us-ascii?Q?IhyFYNegoyzkHElE+nfib+9Lbb3xKrofXHXH3gHK2oaI5VujhwcbxT4+pTGf?=
 =?us-ascii?Q?ZpYZYQNW9YupHU3P3UVBcIFERqpihxAHD7dWQg/TCQvCab9JVlR/bFMlh72r?=
 =?us-ascii?Q?e/PWZgtIkL9XXkS6wxoBiWKyK3KSjhOACNUflqL9RnyYOYlzMAoa7EXivKxq?=
 =?us-ascii?Q?avrCMm/im3TgdxiV18mCh5dKZ6UFxc3rgryHvMGKrE/iKauzF2ENYpzDhVLa?=
 =?us-ascii?Q?cZs77MlSLEnYnXKLB4R6Fz2lII8DN91o1MD034glr7QVLMqYAMmMM5OdSzge?=
 =?us-ascii?Q?RMOX/+hTGSlYSXi1UK7s7Uv/CQ3oDGbh+5SKuPwcDKsiNT8SR7xesd7WxLbM?=
 =?us-ascii?Q?PQlcH0I6udjBR7/j5pwiYoEqaKsmWPvnw1YzdguMkTg9gPoFosKTY1Wiq6Km?=
 =?us-ascii?Q?QT2ym8jXvVqBmvngUJRzpnJahLfmAxAOQt7/6v9YjEpRHiVN7gO53AsoW27F?=
 =?us-ascii?Q?ti4qNabqZh4XeYX/LFW2Q9ylHSe+0aaLXwmWJciludZm+9vxCVlr3mHFdd9o?=
 =?us-ascii?Q?f6RTugNvekAqnMsUNj6C6AyOqmOfDXnLsFPAmL9larWOjvjorTPjQSy9FVhU?=
 =?us-ascii?Q?N1m6CwdEJ6mPK6XbaLA0Xqhsvs8lIpjO/f1krVXZ6A4FEL8/pEKddMyKuNmH?=
 =?us-ascii?Q?v/nwGaBG0xzrwUp7F4Ww3kxL/ubfwWb48zgJwQoQfLRgEeN6FKm9ej96dcvD?=
 =?us-ascii?Q?VQdzdlMJrMrsZzFDoBAIPFaPDUJKie4lWZglm+oL6tBzrGduspi4ipnn3/HB?=
 =?us-ascii?Q?GpzXbR3LWo0J9Dz1zrhs7Tq5HwVvD0N+WUzmsUBI0nQfPWNnPZb/Km32UKor?=
 =?us-ascii?Q?YEZUwxqfqHBOGUSxfLBDRjvD6jtB6iOwJZjBOLmZ34ULzw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4905d41d-b13b-4559-7696-08d8e343bd4a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:55.6080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vd57UgnjEEpvPUOzt/Rx0zrJ0G/2ga109jD2LK9CMcg44HkUsGHPh7MKPkCRTorh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2489
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev gets little benefit because it doesn't actually do anything, however
it is the last user, so move the code here for now.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/vfio_mdev.c | 24 +++++++++++++++++++--
 drivers/vfio/vfio.c           | 39 ++---------------------------------
 include/linux/vfio.h          |  5 -----
 3 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index b52eea128549ee..4469aaf31b56cb 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -21,6 +21,10 @@
 #define DRIVER_AUTHOR   "NVIDIA Corporation"
 #define DRIVER_DESC     "VFIO based driver for Mediated device"
 
+struct mdev_vfio_device {
+	struct vfio_device vdev;
+};
+
 static int vfio_mdev_open(void *device_data)
 {
 	struct mdev_device *mdev = device_data;
@@ -124,13 +128,29 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 static int vfio_mdev_probe(struct device *dev)
 {
 	struct mdev_device *mdev = to_mdev_device(dev);
+	struct mdev_vfio_device *mvdev;
+	int ret;
 
-	return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
+	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
+	if (!mvdev)
+		return -ENOMEM;
+
+	vfio_init_group_dev(&mvdev->vdev, &mdev->dev, &vfio_mdev_dev_ops, mdev);
+	ret = vfio_register_group_dev(&mvdev->vdev);
+	if (ret) {
+		kfree(mvdev);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mvdev);
+	return 0;
 }
 
 static void vfio_mdev_remove(struct device *dev)
 {
-	vfio_del_group_dev(dev);
+	struct mdev_vfio_device *mvdev = dev_get_drvdata(dev);
+
+	vfio_unregister_group_dev(&mvdev->vdev);
+	kfree(mvdev);
 }
 
 static struct mdev_driver vfio_mdev_driver = {
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index cfa06ae3b9018b..2d6d7cc1d1ebf9 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -99,8 +99,8 @@ MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  Thi
 /*
  * vfio_iommu_group_{get,put} are only intended for VFIO bus driver probe
  * and remove functions, any use cases other than acquiring the first
- * reference for the purpose of calling vfio_add_group_dev() or removing
- * that symmetric reference after vfio_del_group_dev() should use the raw
+ * reference for the purpose of calling vfio_register_group_dev() or removing
+ * that symmetric reference after vfio_unregister_group_dev() should use the raw
  * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put()
  * removes the device from the dummy group and cannot be nested.
  */
@@ -799,29 +799,6 @@ int vfio_register_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
-int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
-		       void *device_data)
-{
-	struct vfio_device *device;
-	int ret;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return -ENOMEM;
-
-	vfio_init_group_dev(device, dev, ops, device_data);
-	ret = vfio_register_group_dev(device);
-	if (ret)
-		goto err_kfree;
-	dev_set_drvdata(dev, device);
-	return 0;
-
-err_kfree:
-	kfree(device);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vfio_add_group_dev);
-
 /**
  * Get a reference to the vfio_device for a device.  Even if the
  * caller thinks they own the device, they could be racing with a
@@ -962,18 +939,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
-void *vfio_del_group_dev(struct device *dev)
-{
-	struct vfio_device *device = dev_get_drvdata(dev);
-	void *device_data = device->device_data;
-
-	vfio_unregister_group_dev(device);
-	dev_set_drvdata(dev, NULL);
-	kfree(device);
-	return device_data;
-}
-EXPORT_SYMBOL_GPL(vfio_del_group_dev);
-
 /**
  * VFIO base fd, /dev/vfio/vfio
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ad8b579d67d34a..4995faf51efeae 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -63,11 +63,6 @@ extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
 			 const struct vfio_device_ops *ops, void *device_data);
 int vfio_register_group_dev(struct vfio_device *device);
-extern int vfio_add_group_dev(struct device *dev,
-			      const struct vfio_device_ops *ops,
-			      void *device_data);
-
-extern void *vfio_del_group_dev(struct device *dev);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
-- 
2.30.1

