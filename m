Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9E0355C6D
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244939AbhDFTlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:13 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244933AbhDFTlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:41:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0qNXX4b7Bi0lFOBCKYyQe1u6UJrJO/KYg0tmY1YuKACoZPeuJt5pdHKrq+O1bqfQS5SdjhB3F5fNVsMkl8JaX00OH2Uqbha/pRSTJsMTil4qKf5C+u4syXcfLEDubTOnDAtfISf6+srUkMzOYVnNZLksBM5ZGfcgYJ1WO7qzUImKdAkYc1g3wWlfu+iHyzqpvMUoIg92XHiJQ09ZaIIUJmumTOy3by/oggrMcyVwV5NrsFiJSKiwTK+sAVqhzjGewmTtZrU+3F2vZXHPVZdp6kjKhM65eGb3RJlIoMqH3Z2rnv63JreWJ8zkZZFMyrTRZAPYIAx2KeJ1ziTWV+yjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frn6N4i+YIjRyVdYhcrr5xAtvOnEgR1psIwGgwgPxCA=;
 b=h63i/e6Qk7k2b8txjI23TMvGnDSCT7SrBgbz7oR60Nx+wT1KSOBtVHgA+yTnDWvWKPg638DXQyjuFqwOJTUXI42U7U6WiEXgy63xMzavGoFBDdXRA+Z2cRXapZURGqs1d3dHmMO6vxJ8GOIBkPAukA3xmKjIJjd7Hjip4n1Vb1SXxmbWGFDS9rFLShqjw1NXS2J6VLgbxF1stvNcyogb32Cl2blhbfB70eV0DnZDq3f174NcfNTok6J223OzFXJ39jLO/HjQ3E1jgFXRmfSXq342zdOaXUjMJTfXta1O6eTM6i2825skZ5pJS9OP/Fcc3LsTwW/PEfVHRId1IpYMsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frn6N4i+YIjRyVdYhcrr5xAtvOnEgR1psIwGgwgPxCA=;
 b=pyRTn0hB64stbWdIK9jFkF+cOdG/K7txVtXTKaVvZB2+KGYsDe4f64RrW62M/OZILhigAafnduFf0h8ygoVEO7H6nAP62ubcLi8+XLYeQNriqWEHeQMhZu+jJkBPci6EwSpx/RNoyFZItR+L+ZVdWbmqCw0H8XqFEnghcYsjCQs5w0Ydq9yZKLxPJKTT0hktlKTqO7djeZORLfcYK5fu5U4yjN91JWf9cCCK4kN8nEaNSriZgi0O8P03ES+eOtdIRN7LD90jdo0Yer5HdXwSJekM4mxqLyCEJHLIcc3k7ZdMHIjgtRofnJcnb8gDy04TMre8JcO+i13vCX33Z7k+bA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:52 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:52 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 04/18] vfio/mdev: Simplify driver registration
Date:   Tue,  6 Apr 2021 16:40:27 -0300
Message-Id: <4-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:208:134::47) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0034.namprd16.prod.outlook.com (2603:10b6:208:134::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 19:40:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ3-001mX4-WC; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 607cc7b5-b3a3-4908-c5ed-08d8f933e123
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4235D9D551282F2A5A7259E8C2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72G2QqYTZo1tK8SJkQvEK7+k+BtNOKtKzLcpLcE1L8JJ7Un2eAt8zLav4kf87yfrypXMVRUetv8kE8aSk2k/2kMgqSGvpcOYuPPSl4I9rCyZ/KUprFiwW4XLzurbBChaLhekrSylJm40NB8z7V+zmI08RC69bZZcV2YFVDB3V8MawynetwrjV8PLMyVx05SVO9S0e6RP4n8v466G2ZERFGtGSk9qephHT/1jnNz2RNfvwXNXAUsBIDd539RV87JHMIolystmfv7Q7+Wl8p7ED7tvqu2xAPW9M5M4bKz/tbh98fee2jKDb8vTyE9dTl3cMyKVjIZ0bYMnCiPFEo/9KyEGXypPrJaPTHualYrjhVenvhihCq9NLiXiSgrY4nVQrF8QVLuo/Gsxj/LOxDlfZA1kaQjROgp7x03xs0czTK01HgD8gV9ImCM5JLrNcbt1H/wALDoXOahJoACI8ahoNsVllSerJOolPoRWwVUtMZQTKLcVFrsSsPd+hd9Q8+lFuReaoUfgcUrU8WWgu39pBMD0njnz1WqsWOO3HTFNf5UoOBeKk2Uk9tQXjlbKm+C40nB/aHrrCl0R+VWN8wnQvgtOR4vLO/ut80SS+FnQW0IdTs8+2CO5qhOw3JxVfnbLGCKIhwsTzVN4AzjceeQCqFDW8RESikEobTBbWVTqaqKeHsta5FtHWPvDq/TNHe26
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(110136005)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zFgZMD+7ZTRVXNQqt2yWTiKv62cPgvriLBb8GtxaRISTDbQM/ef4olYtsoWJ?=
 =?us-ascii?Q?fEe4QX0OK1MgwmZsLQCPiVtqKBvjWWSRwlzUj4Bpea/jqKhLy+kr2ig8Ixzw?=
 =?us-ascii?Q?qD8Ahe9AmagxvTddRakM46Qh2BAGOR2WpQa7pjNOyV8uMR4IzwiYXzphiNEz?=
 =?us-ascii?Q?cdK2g6EMA+xztq7t0RE3oDTUPvwi07l3MRKVBPBjPACwFRWfDGC/XUl3k3+p?=
 =?us-ascii?Q?oBf7Iro6Tf6SrNBp/LqOK9NytAcFE81k9PCXzMv2ym6X/ZoydevVUJQFVdZ8?=
 =?us-ascii?Q?MYwltOqkLiYPjfpDZgzEWafoEoADVHDn1sPI9733EH/PVTJfkJzI/UXDUeiY?=
 =?us-ascii?Q?RbE2vTUJoTXH+Hj94KX9PYhJAmxVsEL/PEQ4kmo1fyIHaUFDFeBm5LaHsvfG?=
 =?us-ascii?Q?0TrAFKrUUaKiH43uxwhfDl4mTd70Y1ww1VkVf8Y3mwQXgb/H9ydrxjDpa0DJ?=
 =?us-ascii?Q?RvSzv4GNTHBn01K3FeaiIMNhLAZQs8Z9dZeMkg9zisvUkFdItzmSo9WWEMVJ?=
 =?us-ascii?Q?TB9uVmlxtJ0v0RrWghrQ9TUh6rrK6PhD0vZeXkDKcUMA4AqfOiTCm7AY4owD?=
 =?us-ascii?Q?QHu4gpqm3kbnVTvdek7ljekliPz0Oy1d/9qjXvAiaMgpKBR0AK/KkVpO3BLQ?=
 =?us-ascii?Q?87uGN/wFa4XliGefCiX7O+ltqyyoV4mIA8Xe68OKj/fj/W7CaDJiqCpsNKdi?=
 =?us-ascii?Q?g+m/FOqoxqu+JoIZicADH4K2EpvM/MJagk3RITM6jgFNUOsLxXYjZiEKS/2E?=
 =?us-ascii?Q?uzPlRvaZwgzAw1Zw0MPScwBpP4ZB/5UrumIL2Qapkvui5fKLZYmFodGIUw4l?=
 =?us-ascii?Q?7ip70A5NvU2WV2mPjgZ/K+SqA2Py8RZdRBHcXFX50r/ZP0gMD+vtWBV38Hz5?=
 =?us-ascii?Q?WF50CHE5gy37znUIbf5HX5UyjcaXesyZyzDAmQh4g1CPsEMRcRphKj90yC9i?=
 =?us-ascii?Q?9cLgx+y873dfv9En6BF7w3Uf9iQWRM99zcW0aPd5EnegmIOP9hI5IobFBEot?=
 =?us-ascii?Q?YHC8pTLKTApGQQ/rhbV4XDlDRH2ABGzJQKsIeevaKea3lTAnU0futtk6GfLn?=
 =?us-ascii?Q?9B0qDhWyQTBtE1vF5VDMoG5+nvxEgMUnAJ93DYJrSC0oCBf/rgWOA7JWVoWh?=
 =?us-ascii?Q?5gSrNdHmGbTj+wyz2sqEAqHCjEyGHmtvqCxSL8q2hOkZEWkW/2OpyeNhVo/S?=
 =?us-ascii?Q?gtBOZlpPNSLluHL4VOxlc5KSlslzgsbHmIcFzodXJPSARX06GxWrNTwYPPuJ?=
 =?us-ascii?Q?zPt1I+XcApfJpdwCgo4SeedDua6WycOJE2V7roUcbTIO4RedTl5FO99gHjFG?=
 =?us-ascii?Q?MlvkFbu0JrTkGiy7lq6EA1C5O1/210J7/2pejTPiQzFVPg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607cc7b5-b3a3-4908-c5ed-08d8f933e123
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:49.4168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWVZmTcGfsYIHpsNnT6NHPmZ6rFymshZ/zKCi0gRYVCvhKmN1SvjyAiKTLlpJ2qr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is only done once, we don't need to generate code to initialize a
structure stored in the ELF .data segment. Fill in the three required
.driver members directly instead of copying data into them during
mdev_register_driver().

Further the to_mdev_driver() function doesn't belong in a public header,
just inline it into the two places that need it. Finally, we can now
clearly see that 'drv' derived from dev->driver cannot be NULL, firstly
because the driver core forbids it, and secondly because NULL won't pass
through the container_of(). Remove the dead code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio-mediated-device.rst |  5 +----
 drivers/vfio/mdev/mdev_driver.c                   | 15 +++++++--------
 drivers/vfio/mdev/vfio_mdev.c                     |  8 ++++++--
 include/linux/mdev.h                              |  6 +-----
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index c43c1dc3333373..1779b85f014e2f 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -98,13 +98,11 @@ structure to represent a mediated device's driver::
 
      /*
       * struct mdev_driver [2] - Mediated device's driver
-      * @name: driver name
       * @probe: called when new device created
       * @remove: called when device removed
       * @driver: device driver structure
       */
      struct mdev_driver {
-	     const char *name;
 	     int  (*probe)  (struct mdev_device *dev);
 	     void (*remove) (struct mdev_device *dev);
 	     struct device_driver    driver;
@@ -115,8 +113,7 @@ to register and unregister itself with the core driver:
 
 * Register::
 
-    extern int  mdev_register_driver(struct mdev_driver *drv,
-				   struct module *owner);
+    extern int  mdev_register_driver(struct mdev_driver *drv);
 
 * Unregister::
 
diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
index 44c3ba7e56d923..041699571b7e55 100644
--- a/drivers/vfio/mdev/mdev_driver.c
+++ b/drivers/vfio/mdev/mdev_driver.c
@@ -39,7 +39,8 @@ static void mdev_detach_iommu(struct mdev_device *mdev)
 
 static int mdev_probe(struct device *dev)
 {
-	struct mdev_driver *drv = to_mdev_driver(dev->driver);
+	struct mdev_driver *drv =
+		container_of(dev->driver, struct mdev_driver, driver);
 	struct mdev_device *mdev = to_mdev_device(dev);
 	int ret;
 
@@ -47,7 +48,7 @@ static int mdev_probe(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (drv && drv->probe) {
+	if (drv->probe) {
 		ret = drv->probe(mdev);
 		if (ret)
 			mdev_detach_iommu(mdev);
@@ -58,10 +59,11 @@ static int mdev_probe(struct device *dev)
 
 static int mdev_remove(struct device *dev)
 {
-	struct mdev_driver *drv = to_mdev_driver(dev->driver);
+	struct mdev_driver *drv =
+		container_of(dev->driver, struct mdev_driver, driver);
 	struct mdev_device *mdev = to_mdev_device(dev);
 
-	if (drv && drv->remove)
+	if (drv->remove)
 		drv->remove(mdev);
 
 	mdev_detach_iommu(mdev);
@@ -79,16 +81,13 @@ EXPORT_SYMBOL_GPL(mdev_bus_type);
 /**
  * mdev_register_driver - register a new MDEV driver
  * @drv: the driver to register
- * @owner: module owner of driver to be registered
  *
  * Returns a negative value on error, otherwise 0.
  **/
-int mdev_register_driver(struct mdev_driver *drv, struct module *owner)
+int mdev_register_driver(struct mdev_driver *drv)
 {
 	/* initialize common driver fields */
-	drv->driver.name = drv->name;
 	drv->driver.bus = &mdev_bus_type;
-	drv->driver.owner = owner;
 
 	/* register with core */
 	return driver_register(&drv->driver);
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 91b7b8b9eb9cb8..cc9507ed85a181 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -152,14 +152,18 @@ static void vfio_mdev_remove(struct mdev_device *mdev)
 }
 
 static struct mdev_driver vfio_mdev_driver = {
-	.name	= "vfio_mdev",
+	.driver = {
+		.name = "vfio_mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
 	.probe	= vfio_mdev_probe,
 	.remove	= vfio_mdev_remove,
 };
 
 static int __init vfio_mdev_init(void)
 {
-	return mdev_register_driver(&vfio_mdev_driver, THIS_MODULE);
+	return mdev_register_driver(&vfio_mdev_driver);
 }
 
 static void __exit vfio_mdev_exit(void)
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 52f7ea19dd0f56..cb771c712da0f4 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -137,21 +137,17 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
 
 /**
  * struct mdev_driver - Mediated device driver
- * @name: driver name
  * @probe: called when new device created
  * @remove: called when device removed
  * @driver: device driver structure
  *
  **/
 struct mdev_driver {
-	const char *name;
 	int (*probe)(struct mdev_device *dev);
 	void (*remove)(struct mdev_device *dev);
 	struct device_driver driver;
 };
 
-#define to_mdev_driver(drv)	container_of(drv, struct mdev_driver, driver)
-
 static inline void *mdev_get_drvdata(struct mdev_device *mdev)
 {
 	return mdev->driver_data;
@@ -170,7 +166,7 @@ extern struct bus_type mdev_bus_type;
 int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops);
 void mdev_unregister_device(struct device *dev);
 
-int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
+int mdev_register_driver(struct mdev_driver *drv);
 void mdev_unregister_driver(struct mdev_driver *drv);
 
 struct device *mdev_parent_dev(struct mdev_device *mdev);
-- 
2.31.1

