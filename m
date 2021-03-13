Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4E0339A98
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhCMA4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:56:32 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:30549
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231906AbhCMA4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:56:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMdGO8i9xv1DmTXkNYEQOV6qOaNPk+oQx936qm/aWOET9LZ3tKdW2qypOi3ndXIiMd2Lyg3CVhB7TZwEBVpUXv3pUryqyvI99nBQB+/tr+nhO0cMKzKiaF20gT/J/Lj3P10FwyYNEFd5fCGhHVMv4DQaa7fIFjgTPOqBcwVneOgKN556od8DdU1RessdQG03WFpfUOGukSgEa2YR+Hp/fK9yVJhBlxDGn7D/QAHyII4kBIZVXAUEWi+2QSXOYOSGg/rOSyRzMFrfLrxxdtZ78scwtqBbLzkXvF6xrL2HGNpQsLXu7bSURqPa28vCo0HOQKlQVWYWwA9Tj2a4WIswkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RwiMB4dBUAI2v3IEE844Lu5CZunbMWQyKshCzvVj50=;
 b=XJaD6X0v4E8g5IoNA10XmnNzOteC4gv9H8TYefmX6tvgweJFkuUSa7BYIKsOrpMTA7N9X8VoM4nTEOF+ZueyJn3Meo3KUwawLUNqA4nkh/zks+9KyN6BGPcVeSyPn7EVNfD6T6xSEhnTiI80asi4JR9hsto5OLwEx/SxjBHj/c47gRQ6MkLmWP2XXWO8yd+sa3jMK8nX7VLTqyY7Cx55KWmR12XLSrAbbNMFRDOxh6MKubY0dnkynEH7mAv9Z5ZcLX+QRFwT8g1GqfRa+2vbSVGJhFNyl5e/0fCNCYjqwP8K4ZluRh+LqrfmRgSyBP9IEfI2nNcQlHFjo7O19oMngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RwiMB4dBUAI2v3IEE844Lu5CZunbMWQyKshCzvVj50=;
 b=gIe4oBqZz/BFGRIL/rS3iMwfAMF4BsPKoR7X1tbNsaB3It/qxtug3udcphz5jfXNH5f7fuVky0OUBc+VV0nVX8oshnD9RKFQwwHXyBALkt1gE9+9JD+8fNR6D/wWxUpAup2c+/FMO6oIdwQiDQRoMSzPPpN0Gm4eZxjR60meVvGcrbZ/0igRhLZwhUf6h/+vgNnvSMtuovkisLdS+73KGHMD9CJIPBxeQxUq+J2PSP6bEmr7TFCRy+eIIz+3W9Qu+h7EIxbwF5q4pH7lRid51NApFuJuNtJgrfK+5pCUokt6BiMV3I9RcjBX61R98NJMkB1XgyRRo6UT0Mmkdu6tpA==
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
        Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 06/14] vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
Date:   Fri, 12 Mar 2021 20:55:58 -0400
Message-Id: <6-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0149.namprd03.prod.outlook.com
 (2603:10b6:208:32e::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0149.namprd03.prod.outlook.com (2603:10b6:208:32e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Sat, 13 Mar 2021 00:56:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKsZb-00EMB5-07; Fri, 12 Mar 2021 20:56:07 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eef32a2e-3a4d-4b63-fec4-08d8e5bacae5
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940B14F73B04842B5D95280C26E9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nv3MoRBiG0UThK8aHIqh/lnRvasQCuIHq9MfUtUmt2mOqR3SL49gXm+cdWir3eT1ZgtmB+Vop/nep8yDBonR8WL4kJTTUEDOgGqgOVVwduaSUXxwDgbRXUM9jXCX5ExCQcyXzFX2oCSU4GsgBJ9ZwfVmVcXH1JUJufeMRf4xbs4fLQi1qfmWFSQbxOseE/d0vw2OXubLCllCq6w2OF0Zg1be1VCwn5HHX8PxPD5fUt0ujl3kXm+T6H83Zr2HhETwkvG87M0iaEM44umFYrvth6h/ejqTjT/Dut/JObwdOTlgXo/CmdGQso0cwBb4Ad+sh8luBJRSILGTALNe1binsp7OPh1XZW96kr86Mgmt79tJaWwBn2r8+4iXONGvvAuvlcZFiyHMC7l+wrRXMjbdJnDH8MTIIAebvRYoHJQWQIn05+AKpPYbUqghho9pshtOjKWpHvS3dC2BoB9tykW9nJZM2X1L1vS9UC7ongRqJhnFJPiGgpw1h+kdWlZ5rFpe14KGcA5m4kS+pwKSbdSXxC9rnEcv+WH7mRv3c+KyTMu/BAn6Y4eA2vN60tnbzRFmxYZjClboj1e+amjrSvdH6Afx4Wg+W5vxTpWHxRE3xoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(9746002)(9786002)(8676002)(6666004)(4326008)(107886003)(54906003)(8936002)(5660300002)(36756003)(316002)(110136005)(83380400001)(66946007)(66556008)(186003)(26005)(66476007)(478600001)(2906002)(426003)(86362001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sh2NXLUM/MePgpgti0/69qwapV651p3CQzCpHiMZMkG+j251diN1Rw/f5F1h?=
 =?us-ascii?Q?bI0oQXr/RHv1fvHK+M/Uf3Oy1x8RSPTdsuieSva22pjOYkALTi+y6gjAwIsU?=
 =?us-ascii?Q?R760myGtOXa1rwWAxl2LjaPJ6E9HM3kxedHIuVW/MneRttoQFJFhruAnGKVU?=
 =?us-ascii?Q?YWUIOkv2m+achf/GfZtxcUMo2hUQVJaBKgt+Ul9O3u/I8uIF4x9YL+NU7Lox?=
 =?us-ascii?Q?djCwzMs84CAad+XsiIRRSKN9vGWxLsj1U3nCbkAFxYw4fJzap8vBaqnYjqBR?=
 =?us-ascii?Q?vwf98CQhyyWSQKIFmkIRcMNc+DLuWs2x4JTlJ/JNNtNRv7dmnAyNuIcnGI/C?=
 =?us-ascii?Q?Ni2+tThKLrq9njE8Svq4obUmOVehJmVpWV2BESXUPRCBBsr8M3kaS1Ukv+b1?=
 =?us-ascii?Q?vFtBx/elL6HFM2lRRe2Zy2XO7/KUKLc2X6QC9pxZLFOeWRddBoK7kNKtqWb3?=
 =?us-ascii?Q?3n0Mc5ga8uQfcABaLgv/6KpjV/xDvup2Hn6uA386ao8yrS3TU495JGBPAfch?=
 =?us-ascii?Q?K63nQtAKsnr3qFi6QohdhmcxnB9jHc6kXdjiQsurqRh6DEI11OEERs2geEpX?=
 =?us-ascii?Q?kH4u7tMNOgeFLdJ0QvU1P+0SZt6tXIwYpw6fFwHAX0E/UnMphJjUa9dxUPoD?=
 =?us-ascii?Q?HsUkW9ogJtHGhKYWCPKDSjtbvVWpjIvX7A8BUb3zW3q24qzysJvwS8te1EsG?=
 =?us-ascii?Q?OIiBKHDUi0bpprNjZMTA1DYYnOEOZXnjgSotF3DqXmP4G0TPDacqLudhQJ6e?=
 =?us-ascii?Q?KigeK1Vut8elkyGY3Px/Li9eWOSBg6GnuZ5cO22vrHVLpDbDW0TUw9ObbmbM?=
 =?us-ascii?Q?3tc/YcE95WgWYNY/bWUMy4vV2ii7pX9PTHyWY8+6Z1UV+Y6TdmY/b3zKcuQx?=
 =?us-ascii?Q?Ravd0P815T7gHKYFPl8G55gQik85u/2gLiID9FOINbc9IWhenfcOmLGvPNM1?=
 =?us-ascii?Q?Hfw4TI92+e+kIW22ngpHUxmpmb6U1HVrexTMKKm+4YZk7ze4J830+Ufhvhud?=
 =?us-ascii?Q?+OcxYfl1vxvpmU8iP6fE8ok+5MazlBSKORXKhhGKs+Fd6aLXsgj4ookvx5Pr?=
 =?us-ascii?Q?KnBXSuswMYe/q8nPOJTNL4UyTkfhuoLUvMuquqmu4Gaw7Iopxnme+tu+uwGw?=
 =?us-ascii?Q?UGthJjQgI/n6CvV4DWHmbFk0Ec0lIDExzY/Uf1fEVddYMmhiQnPHvArY6Gjg?=
 =?us-ascii?Q?Gn93vglOas508XrFQPKb8aVCixuB1VaPF7uG/odbNL0OKh46wExy4Vr8TaoK?=
 =?us-ascii?Q?NuA9p9WL/hZu1YJJ0GZq7LRgpVvUnTc0KMs2n0LazvGkrILkPZmMR4/Ywn0I?=
 =?us-ascii?Q?23RGeJpCN7v2WKGaZLqY8BfFdWMt2gRTXD67nLzokt6y4g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef32a2e-3a4d-4b63-fec4-08d8e5bacae5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2021 00:56:10.5712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1gkVEnP7MouVU0RQ4uzTOGVzNHVO4G1Dirp2neqcmixK3MEZ5AleYzBFySbc0dh6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fsl-mc already allocates a struct vfio_fsl_mc_device with exactly the same
lifetime as vfio_device, switch to the new API and embed vfio_device in
vfio_fsl_mc_device. While here remove the devm usage for the vdev, this
code is clean and doesn't need devm.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 18 ++++++++++--------
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 881849723b4dfb..87ea8368aa510a 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -610,34 +610,38 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 		return -EINVAL;
 	}
 
-	vdev = devm_kzalloc(dev, sizeof(*vdev), GFP_KERNEL);
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
 	if (!vdev) {
 		ret = -ENOMEM;
 		goto out_group_put;
 	}
 
+	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops, vdev);
 	vdev->mc_dev = mc_dev;
 	mutex_init(&vdev->igate);
 
 	ret = vfio_fsl_mc_reflck_attach(vdev);
 	if (ret)
-		goto out_group_put;
+		goto out_kfree;
 
 	ret = vfio_fsl_mc_init_device(vdev);
 	if (ret)
 		goto out_reflck;
 
-	ret = vfio_add_group_dev(dev, &vfio_fsl_mc_ops, vdev);
+	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret) {
 		dev_err(dev, "VFIO_FSL_MC: Failed to add to vfio group\n");
 		goto out_device;
 	}
+	dev_set_drvdata(dev, vdev);
 	return 0;
 
 out_device:
 	vfio_fsl_uninit_device(vdev);
 out_reflck:
 	vfio_fsl_mc_reflck_put(vdev->reflck);
+out_kfree:
+	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -645,18 +649,16 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 
 static int vfio_fsl_mc_remove(struct fsl_mc_device *mc_dev)
 {
-	struct vfio_fsl_mc_device *vdev;
 	struct device *dev = &mc_dev->dev;
+	struct vfio_fsl_mc_device *vdev = dev_get_drvdata(dev);
 
-	vdev = vfio_del_group_dev(dev);
-	if (!vdev)
-		return -EINVAL;
-
+	vfio_unregister_group_dev(&vdev->vdev);
 	mutex_destroy(&vdev->igate);
 
 	vfio_fsl_uninit_device(vdev);
 	vfio_fsl_mc_reflck_put(vdev->reflck);
 
+	kfree(vdev);
 	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
 
 	return 0;
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
index a97ee691ed47ec..89700e00e77d10 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
@@ -36,6 +36,7 @@ struct vfio_fsl_mc_region {
 };
 
 struct vfio_fsl_mc_device {
+	struct vfio_device		vdev;
 	struct fsl_mc_device		*mc_dev;
 	struct notifier_block        nb;
 	int				refcnt;
-- 
2.30.2

