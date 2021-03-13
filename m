Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320E0339A99
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhCMA4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:34 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232223AbhCMA4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXgFH2NvCRlxGbKIt6HWs8ZcUpd0SRz7cxNOHvSvarCjM9+XwHINgGXViFnxnae65ptJ9wspwz77IwTIV/+eB6qvrRKO0kNLc1NGEELndNrKgAWV+XTisFFy8YN20a9XPktUOMD27ZL8MrvtnkOrO39u70FYmEF9V1fgyOhbgRyneV4EkFWLKerI6FNSBlB7ppxBOHmnDMB480fWL1Iz/hbH6r9yWedZsHp5EM1uiouwNXSq+CV2KvVP40HR6Z+gT/3KK2XwCIWw3gjvUwTzOqZoV46RwIEoFbpD21/gFmmy+saCyUieCjyMvThILvZzUDjYTnuCyvpmM15nqmOYIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMA5eI6+0w3JuPIdmz4FGsnE5kNex/3uiNtHiAJ+31Q=;
 b=Mw6wh8A7XV0Gd5KhOEU+I5jkHFguVP0nTqnp/xQ2yBSlblbyarBifi0vrxsXeUso/7zdJRZC+glwsmXXSOtXd0e5iAC2sdptk/p/nq122UnTfdmFgioIpeIvqT8ZljIikk6zqw0Q8nszE+46pIb642hPnUy1prcZasqcCk3Qmgf+HMDKxY6RkP/Fr/3vPHuPtqChSX22YC0KujWoPPaRiR0aP/iHuPRdBbXI+B+1S85JICnPo/6CSz/87/I05dCP3A83q6R8bqzRHZxeLe6zgF1ehUArzMiBZ1ZCTEPEf1CfQxSHJBG+W4JyoR0IYFxcjY0GBD5WcSxlfb+qzS5j0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NMA5eI6+0w3JuPIdmz4FGsnE5kNex/3uiNtHiAJ+31Q=;
 b=dH7QBAtQSbmBhUoJxtHCiUOMZiLMDXMPmJkpVuu1pOJxw8bzrpA/xCrkXilPc2MrHwNYOrutnbXu1xqjuMfS7JN7qMpEFFn/PwWIqI2viVWIbPWCcDiAq4aXVcf+iSk4S0l82rmTq2zN4CL5VJQDdGq2I1lTMQiXxsH7CJf4DH1wQfj/BbfPyZvtA+SIroKMmX5OPJGukBGvS7MGTOk1XtoMOj94IqRH3A+0ta09DhTHSbe6e7DNWUcuUVRQBQyMVdZgt1a5zI6RNq2pJT4H1h7m3MnuPTkVHGpcWfvoiTsWRFlcoSy1eR0IQa7terIuOAvloaYo+TT09gtyMuKxrQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sat, 13 Mar
 2021 00:56:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Sat, 13 Mar 2021
 00:56:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 14/14] vfio: Remove device_data from the vfio bus driver API
Date:   Fri, 12 Mar 2021 20:56:06 -0400
Message-Id: <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR22CA0027.namprd22.prod.outlook.com
 (2603:10b6:208:238::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR22CA0027.namprd22.prod.outlook.com (2603:10b6:208:238::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMBc-A7; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b1a769c-facd-4db5-d9e3-08d8e5bacb44
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB294090CC4B9FDFBD69810DFCC26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+I2DlF+pMSG1oZC/zDHCTLpH9NN6jNZk/WRs7ogZcTZjPh8dx8mNRKKu6I02scy/YQM+2NMzqfE3+nvnc1XoSUvl/XlnB1Sw8wajwbfzZt2hx+G/x8KG3pEazmpOUz2hiWca3MxqTrzlhwhK8tWcbF/oH1zbA/ncI+zEEMTxecSVnY492nIATzrCWuZw3Rp7qWXYSGpR3WtcblKYXFrvftSrgp3t+PDsH6vFVrxGFiBd/Yzy0D+80JwstVm+0bMjTSGFKc9PxqhYkvIwg3nBO8K/fQbF3Hq4TsI+9z7PNgCQ0mOKYPHfwxQjEr534AGD1N94lUaXZgPk61U3aJq9AbMsvGsjKvJQaW38JKzgI0Uz1tpoKM163q1I3mb5bTzvl67P3sIShnQcFrrBtQSlvsMYAaNe3gB5Xk6S76CuAf7D8g6l8rBZtcqt/V2PHApuAL5vYPv6abf+Xuj5QEESvW8JQ+TpElEuRu2elr2qPlq8+wfoSvIxgpVo0Fq0Dgn5K8+QJiBF67ExsFjai4jNgDdGlYuQYiBRUxhRtit27K19rPJx6J+VgG/AH6ncvbF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(7416002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cCdPaAs2X3qcV3kFttmwpI4a6ixvGoQpOdTtyzXx7DQBkuP9LzGNZleWd0br?=
 =?us-ascii?Q?sfKbvkA5/+2flK05aDYEB1E+cfwUEObNel6T6C3HjZYUjZoZ+jQE/8kDFiKE?=
 =?us-ascii?Q?BmJ6FqQYLefi2CwnrvTgiQQMPYXGHkHLr2rTSRK6kxWkSSJm1Lk+yqMjHVxV?=
 =?us-ascii?Q?E9QpRSMA3H3fynrIzIX4/khuQmhXP8dRURT+w7F1b+wlq8VcGSUxcLxEx6Ih?=
 =?us-ascii?Q?ulC3pKgmdMypaEJuOFvJqZhqKWbXLt+HOeFsTXTjgDN3xWmTatbye7nAsAeZ?=
 =?us-ascii?Q?k2jiu5cAAKV0CVEL4vPQytwwfzmK2MnaWRBTvAuchEDxa/epcVUMe04+btdU?=
 =?us-ascii?Q?6BrVUvpXJt7BNnfTk8guoH8yzaXy1CGRwIF9UuuvZxsMhjaBzgT+dwU9Xtnj?=
 =?us-ascii?Q?27+bCEcR7fQJSltlXHPVinkWWNN0nhtAD9/ufj55xf5vIV73wG+agceIbAU6?=
 =?us-ascii?Q?HLBV+VTb4M0uB1zz9dSs4bkrmX0SU74z/rzVdGxlSJ38G8P1dpQAnuRWPQeP?=
 =?us-ascii?Q?1U7gqhLikYt3q97EzkW82eobqYKQS7IQrdxUfb/w1gjleypZSH1ty5Dd8UlJ?=
 =?us-ascii?Q?avE2evcwnUUCXujtqcPaB3TNI6ieW2bM7g9+PxpgZ/H37tj73qoTsNIo7tAc?=
 =?us-ascii?Q?wP4mzOWAVVAnMU8pvbsOounwYqqt+tYjuLGk/sy4Ir/nSwzesr3fYyL4N1/v?=
 =?us-ascii?Q?rrNkMIY24vXfeiECHnqg0wDfSoJf0s3b1GMAp1lzYUehLFdKqHKD6+P1eMt/?=
 =?us-ascii?Q?wjqPGw/TnDgwBp+L/icwC8bkf1SOgCcNtcNNWWsNKbL3z35MVheDn+3Ou/5L?=
 =?us-ascii?Q?kyJAOuXddMMhoNPp9ce9CdJLVy2HZGgYnkH7xX6Ve8yKOy41lV/9RCbpmeec?=
 =?us-ascii?Q?yp8c4gDTNsPuA2tkInQukEX9G+qCKOkOl83l13/3xcV0yUJd9qbIMH9gg/4Y?=
 =?us-ascii?Q?0+TPYpMcJmYpbupt2foBKHqrS+c0ts8RpzLjer2JTfmu3u3uio+dCXGkweVi?=
 =?us-ascii?Q?CALaiLz1LJo5OGhoVd8nKZz9KREKspVeSaNb9L733kJONPeCEH+sm8NnFnUc?=
 =?us-ascii?Q?vmfmnYMfXTThtjJRCkbrLVcM4jm54XBOA0/AXXjx4PG4bmK3vwLcRbxC7Eak?=
 =?us-ascii?Q?itwRlpD+t2j/pgtn/+Ci61xuIDFTHo6j8xagYPDwaJk4Qp9QYIKLELPrUGcX?=
 =?us-ascii?Q?+LDiyHmPk2Rp1aki7TqpmoBQn3fjxcV0mE5qAaO2e80lEHFdNr2FyjttaYao?=
 =?us-ascii?Q?PqEEhmO89n6fOa5L9ltgymqhMmVYMlspqVrdFsRO36AyBOPaZjuJb9pGKwfd?=
 =?us-ascii?Q?wlQWjCTECHVWSg26BrmI4FVu5oZ8oAD4DWJozKg2EwqfIQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1a769c-facd-4db5-d9e3-08d8e5bacb44
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:11.2888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wWowNwzXCYWvfQ9oWFZoSbysFkl/oSwLWa0/MZ2r32LZq7CURXlK93JO/cjL7rck
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are no longer any users, so it can go away. Everything is using
container_of now.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst            |  3 +--
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  5 +++--
 drivers/vfio/mdev/vfio_mdev.c                |  2 +-
 drivers/vfio/pci/vfio_pci.c                  |  2 +-
 drivers/vfio/platform/vfio_platform_common.c |  2 +-
 drivers/vfio/vfio.c                          | 12 +-----------
 include/linux/vfio.h                         |  4 +---
 7 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 3337f337293a32..decc68cb8114ac 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -254,8 +254,7 @@ vfio_unregister_group_dev() respectively::
 
 	void vfio_init_group_dev(struct vfio_device *device,
 				struct device *dev,
-				const struct vfio_device_ops *ops,
-				void *device_data);
+				const struct vfio_device_ops *ops);
 	int vfio_register_group_dev(struct vfio_device *device);
 	void vfio_unregister_group_dev(struct vfio_device *device);
 
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 023b2222806424..3af3ca59478f94 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -75,7 +75,8 @@ static int vfio_fsl_mc_reflck_attach(struct vfio_fsl_mc_device *vdev)
 			goto unlock;
 		}
 
-		cont_vdev = vfio_device_data(device);
+		cont_vdev =
+			container_of(device, struct vfio_fsl_mc_device, vdev);
 		if (!cont_vdev || !cont_vdev->reflck) {
 			vfio_device_put(device);
 			ret = -ENODEV;
@@ -624,7 +625,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		goto out_group_put;
 	}
 
-	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops);
 	vdev->mc_dev = mc_dev;
 	mutex_init(&vdev->igate);
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index e7309caa99c71b..71bd28f976e5af 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -138,7 +138,7 @@ static int vfio_mdev_probe(struct device *dev)
 	if (!mvdev)
 		return -ENOMEM;
 
-	vfio_init_group_dev(&mvdev->vdev, &mdev->dev, &vfio_mdev_dev_ops, mdev);
+	vfio_init_group_dev(&mvdev->vdev, &mdev->dev, &vfio_mdev_dev_ops);
 	ret = vfio_register_group_dev(&mvdev->vdev);
 	if (ret) {
 		kfree(mvdev);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 1f70387c8afe37..55ef27a15d4d3f 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2022,7 +2022,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_group_put;
 	}
 
-	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index f5f6b537084a67..361e5b57e36932 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -666,7 +666,7 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	struct iommu_group *group;
 	int ret;
 
-	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops, vdev);
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops);
 
 	ret = vfio_platform_acpi_probe(vdev, dev);
 	if (ret)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 01de47d1810b6b..39ea77557ba0c4 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -741,12 +741,11 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
  * VFIO driver API
  */
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops, void *device_data)
+			 const struct vfio_device_ops *ops)
 {
 	init_completion(&device->comp);
 	device->dev = dev;
 	device->ops = ops;
-	device->device_data = device_data;
 }
 EXPORT_SYMBOL_GPL(vfio_init_group_dev);
 
@@ -851,15 +850,6 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 	return device;
 }
 
-/*
- * Caller must hold a reference to the vfio_device
- */
-void *vfio_device_data(struct vfio_device *device)
-{
-	return device->device_data;
-}
-EXPORT_SYMBOL_GPL(vfio_device_data);
-
 /*
  * Decrement the device reference count and wait for the device to be
  * removed.  Open file descriptors for the device... */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 784c34c0a28763..a2c5b30e1763ba 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -24,7 +24,6 @@ struct vfio_device {
 	refcount_t refcount;
 	struct completion comp;
 	struct list_head group_next;
-	void *device_data;
 };
 
 /**
@@ -61,12 +60,11 @@ extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
 extern void vfio_iommu_group_put(struct iommu_group *group, struct device *dev);
 
 void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops, void *device_data);
+			 const struct vfio_device_ops *ops);
 int vfio_register_group_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
-extern void *vfio_device_data(struct vfio_device *device);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {
-- 
2.30.2

