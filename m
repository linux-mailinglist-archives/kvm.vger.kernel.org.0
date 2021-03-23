Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D05D3464B7
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhCWQPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:39 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:19553
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233159AbhCWQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ns1rs91FtesS24C27g4Xv1EjBkppLeBPAJA/Eq2iaiWSjy2InDe2HXNCWTv7LOCOAENLaTlaQvZzwI3YkuwJ6VwgJRgLDxLlNg06ETTdAYxWkvfSb5pXErzIwFrmZ5wfrXnxkScgk61D0jRTe21yX2yvemI3WfZY2BVYcDSNNT5Qp1iJoybGIPk0pIuopV+ALA29RzfSE7D0iKdorCTOOWcHRXDNOM0HU4VUlgaj8vFzJx5uAOd05o5mu2aJD2VkYfDmY5YkyRoSO538cbSnM+oM5/0xkzg4V7joX+XVlMogowkuEczhosnR4pWjlvXG/siS5FdVrNJYIw6lnqb7Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xPBC3xPaI8fc+7REGhZLu3AHPQyC6odvVGpV0xzeNo=;
 b=LItbQZVVUb9h3z+/R+vMJ5OkkWBsOKwOYBDXAORCWpU9HQK0JV+DLilNk54deeYXK+eoCHrkM+CnmBL42mkkai7GvZacBPLF1suWexURlUzwLPwzGC6fJpecLQuVcEuOwSlZpg4Ytl1soX71LTW1+kCTYDi+TBIh76pjrNIossEbW1BmCrA5fZGRLgOheu7gk9XREDKTgbJmcPiGpc3F3/pkoWf4vHjyG7glX8auZjYG1VbsG0Z2YZht++DECDf5XfDwMzZDHy67rGk3aHDNBDeKzrwTuT8RefvuJFn95AyKBmo+C3ZDra/6xfi8HQQygbRsWsyYc6oRZWkaeqXvgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xPBC3xPaI8fc+7REGhZLu3AHPQyC6odvVGpV0xzeNo=;
 b=JA7QU/g5XBtxia12dDlvaCxo+TBfTvB01z7aWxPSfKVrQy00PX5IvxqRk8+UJxmmRy5eChcDodAC69F6/Xcj2SokyqYr7UJ83NPfdSDLrYrd7PWEbZQ8jGDoZpBNRnG3Nxn2qviUxjfMOVUC4cocq2nWI7tXYqKwRwNBw1GP9J5SLhOYazUIWUjCa2nPWt7IobAbR03561Zva2FYEuQD9YfNRugmYGQAYXijq/QWoxKFQncO9kliP6t1/EfL0xOg7fycQqkJ0rHeOFxs1m9qCZVxmz1o6tAoVKMTOvbzXyl2D32p9ZfMjHN64cR5x74Cn4763dsQNvUxGauTG4eT+w==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 03/14] vfio: Split creation of a vfio_device into init and register ops
Date:   Tue, 23 Mar 2021 13:14:55 -0300
Message-Id: <3-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:208:2be::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0208.namprd13.prod.outlook.com (2603:10b6:208:2be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.14 via Frontend Transport; Tue, 23 Mar 2021 16:15:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCY-E9; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a19d3db3-8609-4dce-cb7f-08d8ee16d4d2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267A130CA93E21A7CE1B04BC2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c0uY+sVyS8SBfiT0GSQ5UHyMDY+3PDrn7vhj7BDRKCtEyGJZ9cAvMMRPd7/jtr9MjA/b+cim0JZA5kHL0HLpUmdCTXaSVeSuafN9UZoarYNQHDn0H4Pg8fiXx6i4t6sH2sRAMI3XY/DcjTwUs88CXfEWMcRWobBV1mA1Xe+5TguIK0A+fbG2pkJLSJxMaj7FgVJW7wpHZmF4tDw2ECAfQXnLGVd2gzXbKrnUTMuhUNHzzjCrmv96L5FdIWMnkaGqtDKxMWCE7WobOYby9jjtAYIV+QxgPm1+96rdouXWmKLTiC7lZRlUvBnn9tDEMioYCxZnDfEHnRM4JSrkm31dli1o1rYCXk4rEwCYEpBHWYTARFEtV1s27omBXQX41bP/O0/EVVOaDHm8qu9zs7Iqgr/05vMfsoxgwhAbQyASXdVxLYCtLd/gShU3ckFT6BklY5lvxSg7lSEo3qFnc04UfTYGPA8EK9bh36Mwc8r7FQ7xv65GlSMhm35HzXq6Z9e+ZqqTPVx2CtwEFZ02U8SNelZZwOoXJ2DsR9F1hv2vyRcxbznFCvKufCcyLO/3Am30TcdwFW9OIQ3t147jLCU10sgwqFamoEnFxJZOZA8aaVfaxulTZTMKSASWdI85t8kvezNEwTzWYwH14ZyJvuIDli2teXwf7se7nuTyIMRrwntDSEB0fxe3pqzIWy7d1nsP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(30864003)(2616005)(66946007)(66556008)(2906002)(186003)(7416002)(6666004)(83380400001)(426003)(54906003)(110136005)(316002)(8936002)(478600001)(8676002)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hd/QjxBXufRo+U+3cqDaCl7rMs++NdT3il0W0k/fQfMVc+g+xlaVHyVpHomx?=
 =?us-ascii?Q?TesTq+7LWD6JOrS7l1K9GWdBDU7f+FZAP/K7J0aadwUoL19xsjXR76D82wOB?=
 =?us-ascii?Q?ccMpvwxUC1JEBjyfvk85F7szC4CaOIbBZxl3/nqVWdtqIgUKmli570kmX1c7?=
 =?us-ascii?Q?g0sv5jTXwS7fV+8s+6GwaaRaGZL6MLsqT5nAeUBcceifJsJcNHrMyffl0s2b?=
 =?us-ascii?Q?WX0i4Dl7jBSheGUSLXyeh0wTC+ths5ADZyqeYGCIwXUgMM2oPbLF/WnIkVou?=
 =?us-ascii?Q?nrhBVyByR7duMavBnu5CJs6Wj5sRVps/DADdeqdQelCEZUTY/bUf3RsxtRPq?=
 =?us-ascii?Q?8TP7/Uv2r9uhixrRIbWjlyUjMT+G4EBxZFFZCDBjV7CTKJVSGSfwwor6/d6i?=
 =?us-ascii?Q?e7O/ePderVjJsXJRwZL7XIOVzHAb7xmXZBoSgy2v5QUSx+5eHphcbzARRNOq?=
 =?us-ascii?Q?x1yvGYUD/Vubb0I5+BkgOsONNSnnK02Q7TgJobQtcGhdkC4RpJuBoZmMX3tc?=
 =?us-ascii?Q?dvkQUC8wQO64ve9IOODvYyi87phX6MVUEKV4pVCQiG1/V4ojikvHDWssVpc2?=
 =?us-ascii?Q?L9GgUVraZhlb293bjdnyOqVZ6Lc2wGA7LjtGGGOu4lRsh1eDCCzNEjqPMOzf?=
 =?us-ascii?Q?0WCgwwCORnoR4mzBF8HXg7ANf/YIAlQQalyNcaYffdbOwwfqVll83FnrMOCD?=
 =?us-ascii?Q?Urj6pDQaQl1ERiZMDTEyKqiKE6iYVVbkJ89lN7E76zCnXNVMfQXZY6py4AWK?=
 =?us-ascii?Q?sTUtet+mQnRXxjiuMdhxHei4Ocd8ExpyOOFKy0zFJYsMcx4OLg/zfAA16r1M?=
 =?us-ascii?Q?wigwFs/OM1TrhKyPW+cAmoY7xPF4Cu1hhYG48bh/hzcxU0rueTlFzRdjj1D8?=
 =?us-ascii?Q?N0Q22QIV3oce6kdf5mjZ9H9a2VZDG8WnqCo+wVbo8rqpVNL2fVTHHlHXMHID?=
 =?us-ascii?Q?+H+84oEC5iKTCL3IfVAay5tHvd51MSP3XRvF+FSQYUD83pBVgw4QYPxIP0hK?=
 =?us-ascii?Q?lkvYe1l+GDCGAwTRrU9cfIP6y9Us8kEvp76dwVdcP2XgjkuOrtyVrr13gZLA?=
 =?us-ascii?Q?F5lw2jquT5Jxsy/edXUPTsYalFATF6dFMdTKEHqFsDXJ5JcqnheooPSF6nY3?=
 =?us-ascii?Q?ir9eSijcB/DPv4Lup1PpJPbVSEu1qd5UccEl0O3Y3E+8HO3mHFRr1XiHIbGy?=
 =?us-ascii?Q?YR6FAMzcGp7UEjgNmDyAvOC6IYf49sHLf8SlHgzlR6Nxf5xVn2mYGJnEQNeg?=
 =?us-ascii?Q?mJt80ZtuGDghRZgDlRPizr+lzs6frr2sJn2bVfnbG8rhipsMv23J5t/5wkom?=
 =?us-ascii?Q?g+e5Q5E5Z82xjPX3hDsUTojJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19d3db3-8609-4dce-cb7f-08d8ee16d4d2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:10.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IARZt3T9BD1or7Cdfbiachz2NWW69fXKVit3Al6NiwBLtlWcwbxuUzzfV5PIZ1ax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the struct vfio_device part of the public interface so it
can be used with container_of and so forth, as is typical for a Linux
subystem.

This is the first step to bring some type-safety to the vfio interface by
allowing the replacement of 'void *' and 'struct device *' inputs with a
simple and clear 'struct vfio_device *'

For now the self-allocating vfio_add_group_dev() interface is kept so each
user can be updated as a separate patch.

The expected usage pattern is

  driver core probe() function:
     my_device = kzalloc(sizeof(*mydevice));
     vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
     /* other driver specific prep */
     vfio_register_group_dev(&my_device->vdev);
     dev_set_drvdata(dev, my_device);

  driver core remove() function:
     my_device = dev_get_drvdata(dev);
     vfio_unregister_group_dev(&my_device->vdev);
     /* other driver specific tear down */
     kfree(my_device);

Allowing the driver to be able to use the drvdata and vfio_device to go
to/from its own data.

The pattern also makes it clear that vfio_register_group_dev() must be
last in the sequence, as once it is called the core code can immediately
start calling ops. The init/register gap is provided to allow for the
driver to do setup before ops can be called and thus avoid races.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst |  31 ++++----
 drivers/vfio/vfio.c               | 125 ++++++++++++++++--------------
 include/linux/vfio.h              |  16 ++++
 3 files changed, 99 insertions(+), 73 deletions(-)

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
index 32660e8a69ae20..2ea430de505b3b 100644
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
@@ -960,11 +957,19 @@ void *vfio_del_group_dev(struct device *dev)
 	if (list_empty(&group->device_list))
 		wait_event(group->container_q, !group->container);
 
-	/* Matches the get in vfio_group_create_device() */
+	/* Matches the get in vfio_register_group_dev() */
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
2.31.0

