Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440A7339A96
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhCMA4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:31 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231907AbhCMA4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gv7MWvgjdKQIgU8qCZJmKISCs6crTHLgttWDSPrv3ScrbKSL/QWaGFV63kBUTLYco+m2Dxj3f4WQ4rXmj5NXNQphNhybEtgvlwTr8mRePAmKvDc5n42J4G4u/FC53IiZJF2FpWsrUJx3mAbbb1mXNQ4Lh2BIs8wuPiGeIruHsMYv/urWke92IMa0AsH8qdh7BH5ef3pIh/tqFqDV97aR6x/LiIUd9l3rCrezOCzYKd8pHncryQOdJbAvq+2dKfjt7b48l+k4yNux16T9Nzq4TgZf6abCnvSwIBY5JA1CHwRoJulZCoBUmVfktn1l20PerCAlhZ+BNosE2TwfcBqIfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jf6XvtxllmGXRppYusByYnlwfyOqo2GO2puGv/Dx5xk=;
 b=TZp1H7FS4C0myfUr/084z9kLp86ph97UwgXlRTGMYIwGXqJJD9eE7VNh9g3mz2o19EcpdMBH3ZWpzR0JmMRATpmKNK4/zDEgnSbpp+OhVJTzPKkVVdSh5W63n+Ba3cUV2/KG5Krv8+VKUGw1aaljn8u5QDE2B19h6jkYE6XHlxwKowgGrGiJYGWEoQ1dcSYbWhNYuOc/20AYua+pPjaPQ/WaRWYJC6fxYEDnmxHWjq2pWDETNBO8ymAv/Sl81PYVrJ557M/y+goGYdS2RUCH6tu+ZZhjuQIvo2KIZVt92nKkb1cMFAnrqxMk+7iU+VPGP8iPGzwekTfFMXbE8XVF2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jf6XvtxllmGXRppYusByYnlwfyOqo2GO2puGv/Dx5xk=;
 b=a2p2wR+kKYcydzYmW5dlbjsanTNsRMXQ0b0xCpVfcZzlnoW1Su05T1c4HdT+lLAgyZwJXNCQEuLrEhvqJS1s0GBTf5bgDvFxM2iEAiqjaHwiIeM6xDtYJfCJj3kCiKN0aLNGcj8KiKFcmfYWVDGywekBf++UQhxnnWFkSyBo5fhZAvokI5ea+XCrDY7yb7yh1V85+HovfkUe/zhuIpUc4u21V0DtMCSuCZjY9C+mq6Q6uGf2Frtq7pjnafSZ2gYmv5Am0TsaSbAauUNCbb0a9Povlbt+kZ67kpXkp7z0bKmE777WCwGrqKHpH8y2raEC7KdosbY+RYl6MEmvgun9EQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init and register ops
Date:   Fri, 12 Mar 2021 20:55:55 -0400
Message-Id: <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0228.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0228.namprd13.prod.outlook.com (2603:10b6:208:2bf::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Sat, 13 Mar 2021 00:56:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZa-00EMAt-RU; Fri, 12 Mar 2021 20:56:06 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d47b6ee4-3c19-47ac-0c56-08d8e5bacb1d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940B6F5B1C7BB62B236D172C26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jmrbUBBmqdKhrl01G4NHjxqtNajhq0dGDtYTDAQlmlrel6tvaHFK9NLD/ITHAF+MNrIVbE+dWNObM9aBMQ7DxbeyXMOOZKmLv8MNABrqof3lS39t1Tg28dhJwdkiMHhg6v1KEjYtAzhCe/8gobVjCZMqriIiG2wbcxABPkwHye+LdNfGUzMzLcmcJHQ0Wffku7l/wWt7BShkBLi3y4NeQjbAvYXsNETdX5cZir70ZteBTaHUPlEK8zBkWs+cLj3e6i4qJwhrLC7raUQGounBym7ilPyMO69khb+MR6l1cuUzbWPNrGlr4RL829yVARvyS7xWUfTP55YxwHohnllpbcf206UNJEs2psob+7j+k2Ll0//b2MECrQ7uk8KgSJqbRUkGuS+Y2QtIYy+PghOg89bRMR1A5WU2Sk0sPaN42AvxiwesvwHaHjJMYqCp0/cqg186RpqqFer/sLNYtpIc10ItoPpW0UcBQOPI4uqprpyeuJ9aSqMFkJyY0RSeBIw1+bnQa+Y5JSMtGYQnReZssjqu9KXAEENRnLRP7KCycX0GVlR7Ol2MvPKpam2OZv69aKkSakYLg7rppUdiUIB2XsxOhT3Jnzi8EGAihSZJY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(30864003)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(7416002)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YE4eT/GMc1OmEPUryUDkfGcbbV6uKHKhSeuxjjula56PyJQi6yJzLWfQQPc1?=
 =?us-ascii?Q?F+X2VvSpQoQ3OfFw7ALbLc9UP2HvLcuhl0P+A0WtD6Qik+eE84hXDhOkKmck?=
 =?us-ascii?Q?lQVGmvdIBscUuRoaIwOzFzo4+Su29xO/SF9dKtdVVEhsQHNzKITV/bLkBngs?=
 =?us-ascii?Q?H74dyiU2D+C92LQFfKrDmvoTHcOSOp9ucebsH+9EVXQMW0oa2zyNbILZflYY?=
 =?us-ascii?Q?uR1i8gcwaOmySsMBk+LcRiPWeGy9dg4iEbPtqBujAv/hdkuv7ih9IoBLuDng?=
 =?us-ascii?Q?hG4OmONuCM/ys70wRSEdbxgsYv/cLSxryWXR0mvfLXH+qMow5ep2a5S/HgQN?=
 =?us-ascii?Q?K/pyLht71n/nJEpd45U5GXlKkkqVMR+9/p0urPC+2E9S08J+1NDJuDDNSuUf?=
 =?us-ascii?Q?yqHdEXwhfyzy3ebhDRJ6lOpeVVgEYBN40pmOHokFwKKOjjh+VJwJ35Zammab?=
 =?us-ascii?Q?Tax2r52WeiqBBhctK/pns+eN3lvjfiOKstoRNDHer8ce35rwqZNCJGp72atq?=
 =?us-ascii?Q?kC8xvbP0VOtY7KIkxh68yf+2ZAkxct8ymiomRCQk1WadOGbhb9Q6cHE3SHz3?=
 =?us-ascii?Q?bKDcUa7w3r1qHtJq/aXaTH7bUg7SdLWMW4twWWGUq4J7IHtAeNS0j+NxTTHO?=
 =?us-ascii?Q?NC40On/zg+PLi1bvMY5aQDB2K86kPMjkSoKmd5owWmDY2OXjpzKM3ycV1itY?=
 =?us-ascii?Q?avq38gB5nncS+0oA8lXpUDw4lurbSBwig5Me1752czSf185IQJx6Z/iNu7tQ?=
 =?us-ascii?Q?EyhB7lN/MpDtWilE28jMfPI7i7zuq/TqkdgOwtvni8M8YCXvpQIEM1gbGV7Y?=
 =?us-ascii?Q?DFCya34Z/5yrAYUlbR/li66IYg0HT0v8Kt9d8y8va5CQ3cGT/lDDX66HDbv7?=
 =?us-ascii?Q?ECLT9YV8/uRU86HBUE47Ksv8l7+fJSOfwLOdzU7UBzFdgFP/KhF2G/u0ERNm?=
 =?us-ascii?Q?vc4o98ivRL6CVp+d55FQAf8Dy9KfCBUWo/8IPXlWLbQ+Ay07iX7K4jFsHCYa?=
 =?us-ascii?Q?ZiI0PY9D7PqXIPseFqifmsxp7RoaGxKn1Ai+ccxGUdS6ucsAl7ZH/HL1VaKu?=
 =?us-ascii?Q?JtkU9r62vOwQCL4YfruhA3igei9OrjQDnSj7GqANkS3O6MUoyo1Tm8yDMYv8?=
 =?us-ascii?Q?AalRo/zEdQJ9UQMw1E61CcLAopukQmFrrqPU+xGmfDeXAmrQe6g0UzBSV2XN?=
 =?us-ascii?Q?puFsg/tnONFUmrfbYHTffgQjAOcU+/0Cxx/Vn+EhafzcouxUmXDzRrKG0XY3?=
 =?us-ascii?Q?miXtOv1zJOODbqTc7YKLG+J7x9SlCPPHMbYna6C0luEP4EPcmViBEfZd6wsA?=
 =?us-ascii?Q?1tCdLi5z4ov6+eLe1iUhn4IzJQFdZqpbfWRDPsruE++CFA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d47b6ee4-3c19-47ac-0c56-08d8e5bacb1d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:10.9300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tjShEJ5vZ6qs2LvT/WPSHQ9Mvwn0hgGXaWHCs83Pj/YaCdS473qhX8ZJZfpj1rHc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the struct vfio_pci_device part of the public interface so it
can be used with container_of and so forth, as is typical for a Linux
subystem.

This is the first step to bring some type-safety to the vfio interface by
allowing the replacement of 'void *' and 'struct device *' inputs with a
simple and clear 'struct vfio_pci_device *'

For now the self-allocating vfio_add_group_dev() interface is kept so each
user can be updated as a separate patch.

The expected usage pattern is

  driver core probe() function:
     my_device = kzalloc(sizeof(*mydevice));
     vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
     /* other driver specific prep */
     vfio_register_group_dev(&my_device->vdev);
     dev_set_drvdata(my_device);

  driver core remove() function:
     my_device = dev_get_drvdata(dev);
     vfio_unregister_group_dev(&my_device->vdev);
     /* other driver specific tear down */
     kfree(my_device);

Allowing the driver to be able to use the drvdata and vifo_device to go
to/from its own data.

The pattern also makes it clear that vfio_register_group_dev() must be
last in the sequence, as once it is called the core code can immediately
start calling ops. The init/register gap is provided to allow for the
driver to do setup before ops can be called and thus avoid races.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst |  31 ++++----
 drivers/vfio/vfio.c               | 123 ++++++++++++++++--------------
 include/linux/vfio.h              |  16 ++++
 3 files changed, 98 insertions(+), 72 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c3ba0bb1..d3a02300913a7f 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -249,18 +249,23 @@ VFIO bus driver API
 
 VFIO bus drivers, such as vfio-pci make use of only a few interfaces
 into VFIO core.  When devices are bound and unbound to the driver,
-the driver should call vfio_add_group_dev() and vfio_del_group_dev()
-respectively::
-
-	extern int vfio_add_group_dev(struct device *dev,
-				      const struct vfio_device_ops *ops,
-				      void *device_data);
-
-	extern void *vfio_del_group_dev(struct device *dev);
-
-vfio_add_group_dev() indicates to the core to begin tracking the
-iommu_group of the specified dev and register the dev as owned by
-a VFIO bus driver.  The driver provides an ops structure for callbacks
+the driver should call vfio_register_group_dev() and
+vfio_unregister_group_dev() respectively::
+
+	void vfio_init_group_dev(struct vfio_device *device,
+				struct device *dev,
+				const struct vfio_device_ops *ops,
+				void *device_data);
+	int vfio_register_group_dev(struct vfio_device *device);
+	void vfio_unregister_group_dev(struct vfio_device *device);
+
+The driver should embed the vfio_device in its own structure and call
+vfio_init_group_dev() to pre-configure it before going to registration.
+vfio_register_group_dev() indicates to the core to begin tracking the
+iommu_group of the specified dev and register the dev as owned by a VFIO bus
+driver. Once vfio_register_group_dev() returns it is possible for userspace to
+start accessing the driver, thus the driver should ensure it is completely
+ready before calling it. The driver provides an ops structure for callbacks
 similar to a file operations structure::
 
 	struct vfio_device_ops {
@@ -276,7 +281,7 @@ similar to a file operations structure::
 	};
 
 Each function is passed the device_data that was originally registered
-in the vfio_add_group_dev() call above.  This allows the bus driver
+in the vfio_register_group_dev() call above.  This allows the bus driver
 an easy place to store its opaque, private data.  The open/release
 callbacks are issued when a new file descriptor is created for a
 device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 32660e8a69ae20..cfa06ae3b9018b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -89,16 +89,6 @@ struct vfio_group {
 	struct blocking_notifier_head	notifier;
 };
 
-struct vfio_device {
-	refcount_t			refcount;
-	struct completion		comp;
-	struct device			*dev;
-	const struct vfio_device_ops	*ops;
-	struct vfio_group		*group;
-	struct list_head		group_next;
-	void				*device_data;
-};
-
 #ifdef CONFIG_VFIO_NOIOMMU
 static bool noiommu __read_mostly;
 module_param_named(enable_unsafe_noiommu_mode,
@@ -532,35 +522,6 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
 /**
  * Device objects - create, release, get, put, search
  */
-static
-struct vfio_device *vfio_group_create_device(struct vfio_group *group,
-					     struct device *dev,
-					     const struct vfio_device_ops *ops,
-					     void *device_data)
-{
-	struct vfio_device *device;
-
-	device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (!device)
-		return ERR_PTR(-ENOMEM);
-
-	refcount_set(&device->refcount, 1);
-	init_completion(&device->comp);
-	device->dev = dev;
-	/* Our reference on group is moved to the device */
-	device->group = group;
-	device->ops = ops;
-	device->device_data = device_data;
-	dev_set_drvdata(dev, device);
-
-	mutex_lock(&group->device_lock);
-	list_add(&device->group_next, &group->device_list);
-	group->dev_counter++;
-	mutex_unlock(&group->device_lock);
-
-	return device;
-}
-
 /* Device reference always implies a group reference */
 void vfio_device_put(struct vfio_device *device)
 {
@@ -779,14 +740,23 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 /**
  * VFIO driver API
  */
-int vfio_add_group_dev(struct device *dev,
-		       const struct vfio_device_ops *ops, void *device_data)
+void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
+			 const struct vfio_device_ops *ops, void *device_data)
+{
+	init_completion(&device->comp);
+	device->dev = dev;
+	device->ops = ops;
+	device->device_data = device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_init_group_dev);
+
+int vfio_register_group_dev(struct vfio_device *device)
 {
+	struct vfio_device *existing_device;
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
-	struct vfio_device *device;
 
-	iommu_group = iommu_group_get(dev);
+	iommu_group = iommu_group_get(device->dev);
 	if (!iommu_group)
 		return -EINVAL;
 
@@ -805,21 +775,50 @@ int vfio_add_group_dev(struct device *dev,
 		iommu_group_put(iommu_group);
 	}
 
-	device = vfio_group_get_device(group, dev);
-	if (device) {
-		dev_WARN(dev, "Device already exists on group %d\n",
+	existing_device = vfio_group_get_device(group, device->dev);
+	if (existing_device) {
+		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(iommu_group));
-		vfio_device_put(device);
+		vfio_device_put(existing_device);
 		vfio_group_put(group);
 		return -EBUSY;
 	}
 
-	device = vfio_group_create_device(group, dev, ops, device_data);
-	if (IS_ERR(device)) {
-		vfio_group_put(group);
-		return PTR_ERR(device);
-	}
+	/* Our reference on group is moved to the device */
+	device->group = group;
+
+	/* Refcounting can't start until the driver calls register */
+	refcount_set(&device->refcount, 1);
+
+	mutex_lock(&group->device_lock);
+	list_add(&device->group_next, &group->device_list);
+	group->dev_counter++;
+	mutex_unlock(&group->device_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_register_group_dev);
+
+int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops *ops,
+		       void *device_data)
+{
+	struct vfio_device *device;
+	int ret;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (!device)
+		return -ENOMEM;
+
+	vfio_init_group_dev(device, dev, ops, device_data);
+	ret = vfio_register_group_dev(device);
+	if (ret)
+		goto err_kfree;
+	dev_set_drvdata(dev, device);
 	return 0;
+
+err_kfree:
+	kfree(device);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
@@ -887,11 +886,9 @@ EXPORT_SYMBOL_GPL(vfio_device_data);
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
-void *vfio_del_group_dev(struct device *dev)
+void vfio_unregister_group_dev(struct vfio_device *device)
 {
-	struct vfio_device *device = dev_get_drvdata(dev);
 	struct vfio_group *group = device->group;
-	void *device_data = device->device_data;
 	struct vfio_unbound_dev *unbound;
 	unsigned int i = 0;
 	bool interrupted = false;
@@ -908,7 +905,7 @@ void *vfio_del_group_dev(struct device *dev)
 	 */
 	unbound = kzalloc(sizeof(*unbound), GFP_KERNEL);
 	if (unbound) {
-		unbound->dev = dev;
+		unbound->dev = device->dev;
 		mutex_lock(&group->unbound_lock);
 		list_add(&unbound->unbound_next, &group->unbound_list);
 		mutex_unlock(&group->unbound_lock);
@@ -919,7 +916,7 @@ void *vfio_del_group_dev(struct device *dev)
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
 		if (device->ops->request)
-			device->ops->request(device_data, i++);
+			device->ops->request(device->device_data, i++);
 
 		if (interrupted) {
 			rc = wait_for_completion_timeout(&device->comp,
@@ -929,7 +926,7 @@ void *vfio_del_group_dev(struct device *dev)
 				&device->comp, HZ * 10);
 			if (rc < 0) {
 				interrupted = true;
-				dev_warn(dev,
+				dev_warn(device->dev,
 					 "Device is currently in use, task"
 					 " \"%s\" (%d) "
 					 "blocked until device is released",
@@ -962,9 +959,17 @@ void *vfio_del_group_dev(struct device *dev)
 
 	/* Matches the get in vfio_group_create_device() */
 	vfio_group_put(group);
+}
+EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
+
+void *vfio_del_group_dev(struct device *dev)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+	void *device_data = device->device_data;
+
+	vfio_unregister_group_dev(device);
 	dev_set_drvdata(dev, NULL);
 	kfree(device);
-
 	return device_data;
 }
 EXPORT_SYMBOL_GPL(vfio_del_group_dev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b7e18bde5aa8b3..ad8b579d67d34a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,18 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct vfio_device {
+	struct device *dev;
+	const struct vfio_device_ops *ops;
+	struct vfio_group *group;
+
+	/* Members below here are private, not for driver use */
+	refcount_t refcount;
+	struct completion comp;
+	struct list_head group_next;
+	void *device_data;
+};
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -48,11 +60,15 @@ struct vfio_device_ops {
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
+void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
+			 const struct vfio_device_ops *ops, void *device_data);
+int vfio_register_group_dev(struct vfio_device *device);
 extern int vfio_add_group_dev(struct device *dev,
 			      const struct vfio_device_ops *ops,
 			      void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
+void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
-- 
2.30.2

