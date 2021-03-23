Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C5E34671F
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 19:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCWSDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 14:03:39 -0400
Received: from mail-mw2nam10on2052.outbound.protection.outlook.com ([40.107.94.52]:63748
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230370AbhCWSDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 14:03:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhFHLF8aqHmWRFIIyAYgWA1zTQh3syOHZJ1t6lRdqMFf3csgtlI8BgcRmYAv1QOEPqabSZGgEdkdlxoydiTAaiPrnmSWRGOEMcX/lHnEc3QrdytEEufo48ZM2mnBOwQx6LSMyaItH19r9QlmHjBz+kiQEs6U6XcBAUBLU2XDvpTDEHf2ypGPtppbvZghVgupqrecARVSLm64G3ChqfeZDlHhe2hwvt+mReQ2b2ywTamo87qsVP+4e/rwj8I7v6jtn8zO/Do727y9/GPYTabN3AdSqmoNvpq0UVbYzsnQHNZq55hraIYfQ72kmAYvf1RaylE1cBQsh3BeBrero+is0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybq9AmUWfapy1CJMdY7w8M+5olrUXBj9cUudQd/NxN4=;
 b=jbSZ9EoaYra2UYxIWPk20MWvysfF81lpwB7FUbWPL1MI50dB/ytD325M7OpjiZB5v/1q4rl2AwiAWGeCpEy8jCoqfFu1I5HLrT8qIdAXfZ/WJPr2vTn5rM3ypXMXe4o7IKwt/3Epgjgylwqjc3DVn92fn6zwtd4Tampxlkk6alx4cFqvWdH0FKSZjMtu8LfvoY6R2XAWV3Fv18YjCNFTmXOo+lyyKoCwFI7Re6PIbc0uJ3WHrVTZOHB6s6TsC9uJkktLOFb9DTJQeWcH76A3ui752zXNPR+27w61Hlv+BhWF/5+8LbZoEzmpeaxN8c42ntgD7XenezInEsncZvnK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybq9AmUWfapy1CJMdY7w8M+5olrUXBj9cUudQd/NxN4=;
 b=lgzTFMR+kMoXxkC+W148oSc7irP+EGs3Mg3nnmwNVgDDBLPx6zSP/iSDHRiH4bozJI2s/cHZxr2YSD+OXsssMqKML4KCwc6CbskxIjuoBs6aeUqxcJKjrDFIsmWaH82Qyjh7ZeoEDj6PB5Ud853OrTstb1nzRv9Kbd+U90feXLfg+XKeu6vgNwk2Dt+FpFDexCqU+WyOC2pjBkWjuPYruXjqKEy0CXdmuxcSJSKysTfrXLWgKZopE4Ql3GV02pTG6AIc3VhNQe/FucuVbBPyfjKaZ5Sv/3riT7ysjLthYcozJhPcy4fYRbyrPotljyABVfWbofEXhWfeZMiF5R4tCA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4266.namprd12.prod.outlook.com (2603:10b6:5:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 18:03:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 18:03:07 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 03/18] vfio/mdev: Simplify driver registration
Date:   Tue, 23 Mar 2021 14:55:20 -0300
Message-Id: <3-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR15CA0065.namprd15.prod.outlook.com
 (2603:10b6:208:237::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR15CA0065.namprd15.prod.outlook.com (2603:10b6:208:237::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 18:03:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgY-9F; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ec7ee6-db53-4207-c2fb-08d8ee25e9ad
X-MS-TrafficTypeDiagnostic: DM6PR12MB4266:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42665D6A4BA3697492D59496C2649@DM6PR12MB4266.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j2/n7nIMx3Kh2E40tf7Nj1Fq3svEvGC/KZJsw9kiNOp7d9hfvzPoux0jg05nN69cd/VP+u8DhgJ9DKRxbDkmgSQ2Pwno6HtHSEcBF1xjlYoyfb9197rO6x8j6pcXlLEq8L0vvurbGGp/ZJs/CWTADyk9TsOu+NHD1g7Gt2iKfbE1RLZIIrBZgB/2d4md34Ml4Qz6DtTkl1iJUmzyDUGaXPUMYD/Gm1XbuJbKmfpNX1HZSajbTi/svhlLAfW/lMlRgLMbgvOKMAbuZKFEGCFWY6BDiO4MhWH1Jzkisa1vLzFBYAEy0jbAiAjIDJwvmk5UaB8fTb96x9i71Vfncd7xXQn+GNoJxdIvPnQ9exADtXi/Sl+DcFAO6U2cHYnDI+DhGAK+kaL0FXJ/RYglKTlnWz2UfJ5hLYPAe8cd/bCp56K6eyl5R3Y4zQFDfgI0VlZB8WtJ0V0LVxm6rAeIpUJf/mTT77DuTGYp9EUNKNz4g8ePiAT390de27qcmaDctzeGI68/3YoPS8aSUZ5p6HRXaDvDKPPG/+yxzbjbdaySUKAxPIJv/oHmQhLCyzl3a/oGbU2AeYHRjHXjKBq1hBwqOqY7fKxHXPCQxQpUZFluw1hc1Kj5wRkuMwu7KlMjRoq8Yw+gwzI7nA25sCqbwkQ70gprjpAuR6PWfgnMb71zyzM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(366004)(346002)(66556008)(66946007)(2906002)(66476007)(110136005)(83380400001)(86362001)(54906003)(38100700001)(316002)(9746002)(9786002)(8676002)(186003)(478600001)(26005)(36756003)(426003)(4326008)(2616005)(6666004)(107886003)(5660300002)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KMKzB0t63+ab8tdubSJwyWY44Zi2dzW0SldgyGtQFQxy/ZNEJb2FBlXEXl84?=
 =?us-ascii?Q?NTP+vOELhqx+DVs8Qz0i7ffX3SCGEE0F+VHJa3BFu2u1g+lhuEu2yA9vAASt?=
 =?us-ascii?Q?W48+YXc8UDJLS6gK1jKuRwfwb0Oko+6xtmkNEvb1wxu0uwBsDfP8LbuwqHTU?=
 =?us-ascii?Q?vFkO2mhWQsSSYPR3MZfIjPrnOxoR6aRXT3GzcWU0rRB5cpgM+QyNro20eRb5?=
 =?us-ascii?Q?dd9GV3noBgDeLup2jTOXIG74pW1742FDDEHxcPqI2mYVzG24/66oDB+K3FeM?=
 =?us-ascii?Q?n4s+fD3n2bNCf7ntrBqTU/fQL37rVOLs4rqi9CeK2JFiPwaxwdbB5+/+CkZH?=
 =?us-ascii?Q?LT6mzgwnbrGFN75ooFWmOJM4YlugRrp3U7f43ZxdXDmm4K+i68RFhj7Iu51M?=
 =?us-ascii?Q?OCJasSuPqhTOgYtaG0L6h/7GqQarTxg/T2CDse5+8lUBGsZRAywF1Bshf+Lv?=
 =?us-ascii?Q?q9qXZ5wE443aKWOyKOXsLWF+vdUVMotl6ex8sDGBBnP6BpVHHlNAT2rak1yX?=
 =?us-ascii?Q?LMl1XH0jtbRc4DSgH/hYWkdOHhVbKJoqUyB0eDWFsHhUETJcAIhvg5E/o7+6?=
 =?us-ascii?Q?9qdwj6x0TuJMXqtUo6+PeRMgfbC1tNjY/QQB6mEzzq93dp/CeIGLfZvXDmiM?=
 =?us-ascii?Q?mCheZxq3TqBqNh5SCMakUw8w2y1ZsPtF5Hot1IC5/KLt0wigDGGc1sqsKBsm?=
 =?us-ascii?Q?MDWZi+4xhkor7lJ1B4XsOJ2GbldAA9MWSO00fGunKruXteBzDwEyh4sfjoS1?=
 =?us-ascii?Q?aXL0Xj4Sq/qS2fYzAUngkIG0OoOgoOynJe94YDEXtJyn4byE5q3Y30/ObTDH?=
 =?us-ascii?Q?ExUQ9eA3v7Jah8zmWlQ1RFpRkeREzFgy4wgbmG6KdrTJRbnHHV/Xikjg7PUu?=
 =?us-ascii?Q?f3oLz+2w3sQkVqoM76WCVSewAIJU31p47a5XI84xY/D7rABZpP1XmP1MDedR?=
 =?us-ascii?Q?MD5ZaXXra8K0mt5UpbamA4mF2KT7wN78iQTAuRdamFHRmeovsWidUahK1sbW?=
 =?us-ascii?Q?+XYdf/16oM7+ZuXjGFFueNJKaUDMIBWEmEDcp/hBiO+GQlsMSVolukxbQ08t?=
 =?us-ascii?Q?WcfbOSnIrs4JI1wV7KD8QXmlAi3RmKijFA1HIXYp0Uu6iIrdS6SHbutGAsDY?=
 =?us-ascii?Q?v9GGLFQX3It4lSEzWkWKz2W98EvnVfx4kDXrDxtWRvXa0Fq6Q0del+4YD/i4?=
 =?us-ascii?Q?QRZgM8kwP6F8CzDSBN0suZm1JIwupMTHVjBDcibMrg0XmWa1ldrhTSHlG78w?=
 =?us-ascii?Q?289RY7+XgoJ0kIt78fBhCEBjV2FaCQJPtWiPwWiNc0JqbZVZQDoslaqC5+pa?=
 =?us-ascii?Q?9MNJkIBLvEkp4qt7JgA4hztb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ec7ee6-db53-4207-c2fb-08d8ee25e9ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 18:03:07.6823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unMfUKmiIFeblyQ1r3MYoKVNsr6E87sAlnNCPb8U0+5M88PToDDqmIqHYTgrYo/8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4266
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
2.31.0

