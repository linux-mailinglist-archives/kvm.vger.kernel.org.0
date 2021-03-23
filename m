Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45CAF3464BC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhCWQPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:43 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:19553
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233167AbhCWQPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDoagTyEcJJ08RmITZy/X6hgd1/ov09zTjqr51mdlPZupgQDKfc1YmSJzpjA7U4fV0qIG9cL7Ph3UGvIm2gQd/Wij2x5pdtDze9jrANpRYpKJOlr7Wvyl0m13WM8we/2T3Jc7Yh2sF6FGtetQscay8XFedhsyMXCEWW64CrfH/K8RhnbAMvIJMQP55SQ/RJpecU1zI06nGQJa9zpgH3yMzSbL1fMnDFppyE4tfdXnMasQG0anEUt2dtV64JJXZoqwHo1xB0nEXY82z1WnGqSi888NUS/AueGtVMQjyr3gUXL/0IF16sH8UQ3EwsG+tUTiLU4/N4UikDHaMVCTAIcZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Au+jz4Mnc+9WPJjKoH1/bA/zwfibxm5kZdV034G6lE=;
 b=g4SiSUTokZalXZUlpFocC0opE+dzgevcE4+D8dgxrzMcSRmOz1rTZ8+X84CkxvXas5/Qy+wylTUzqgOWucm1ipt15QKyGT3ti0ZgcNNWgPnnmBDd5ONg/xxrSge9EpRF85Qnm2uV3EiCWwOXzLLAxagKkHu54gizCeaV/8l4yEkQPvZuu8gxjzLCeQUHYBf4CilDj2yKZDbk+xRLMd5GbVOXm8IXc+uNlJBsRGRpIkPZVC7v1IjVpZ+I01JW3gF1D2uL7eLQInZm6pejPWfMVHwb8MixyQyjUXKsAocxk3MuQkpc8V4zFgpggPnGsBok9t62S59J/u5nQrAXspxJYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Au+jz4Mnc+9WPJjKoH1/bA/zwfibxm5kZdV034G6lE=;
 b=aw80IOFKFscOCZXJDIA2p1L07k1oYp4yqD8XBH5Q7woIMjSD3c3YYX5+NO8uT6zkP46ShnTixRE1/rGOdkXZtDx8yuRo20qTVqZ3Cv2QqQGsdL6QynRFvPFnTgIlKR9MlHchQt0/ljLZFmhrZvSumOOY19XJbcbrOYSDcHjqRYDAkczauZYt1z5KFWSkrYCUaT+QDtMxM19ZpmYtC1v9hnxHqKxvRv6SE12z9BNbZHQNEdFRR/etuemACvWahFPFbwGTmaF6l5FS792KuGmSGBrLIJGPNAS57rZJmi7IMWRXRn2GenQyUljl4i9rnA1xZFbWquwZplDTte9buCcKnQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:15 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>, kvm@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 06/14] vfio/fsl-mc: Use vfio_init/register/unregister_group_dev
Date:   Tue, 23 Mar 2021 13:14:58 -0300
Message-Id: <6-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0207.namprd13.prod.outlook.com
 (2603:10b6:208:2be::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0207.namprd13.prod.outlook.com (2603:10b6:208:2be::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.14 via Frontend Transport; Tue, 23 Mar 2021 16:15:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCj-It; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ace483f6-563e-40a7-fef3-08d8ee16d595
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB426762CE8F6ED1E229725C98C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IwTMi2Z14ZVhTKAXt9IuYxIuHi0eTjeR8aV7xc8eaiyYcWxrrfpuRcHqfOIZ8gFcYvBAJy0hHMBkBcKfuYOSFAZPjs1XLCnnVcBBAsYH5v76VEY6lQYFMoANzFRXbWvgk6BoeHEi71W51d5KI3BASsgPMOg2a7fe1NqlmsY4Le0UiFvxPcQN34xMypdmWPoS99V/8AD6MYFpLiiws1vGhtyE9a7cm/SHWigqzYS6G5j9vA6EQwc2KaM2+g/wyeYi+LtZ9/h0Der3iWUYWC8YHFirZOxjd+3DOAo4UfsrVuoxD1VW+FOqgmRwMgCMUOlKk/dNak44JcMYRV8HevNUqTbDsLcF+jGq9nUTQRwDAyGLY3IJhPG9fMv/0z2lhKy7T45Pnnteu7FBS0bdOMcxBnC3cJtK4OmNWzGxN01m0jW06d2YKNiQeKxt2j/Q+zvumP10jZ42bufLOPQvsQARlfePE4hN2QzKs1e91XyhOZ+i1c9J6K5SHUlQtVGim2+JI6Bxy8qFml+N6bBDQMRkpM+L1PEead8INE/OTFjtk3+zFDafBDDAJcqVtGDI67q6mtJ9PxbTp3qsijl2tOubIqajM4wi4OOacCqpsnB4qF8sjuWY3wVWZjc+gsCtseN5V+R2OSZ+lr3HnX/pXsBnf8w0sCAr9/l7FFfDEUgkY8IlWWKRneDeAtxX7in9NY6V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(6666004)(83380400001)(426003)(54906003)(110136005)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KrwwHdrzalwT7w535bjfmbWS8z2Hv5nVS3eNz/VvnzGDQd50XycZ7KP8r3oS?=
 =?us-ascii?Q?jRLdLm1da8SRDM+FZjAswMSN9ejK1S30h2UCBT2BaQzoAwLtTJzF/P6JsRcH?=
 =?us-ascii?Q?W/ETbNyGzMOgDmcSuIgPdp35tqT9zBKqPZ3+rGJ8Mc11BNibmToovDcTFYlK?=
 =?us-ascii?Q?ngya676DStZRo9jzslTs1zgBpj3JYpo2arX2MshUd0VfqUcBEUXAGxPWx+yG?=
 =?us-ascii?Q?EI/O0C314SnTZpwYc5MPB3LrERt1BsbnZp5Ozqg9Rg6BeDGFD15C0GvahuOx?=
 =?us-ascii?Q?Yo9HGWDi9FUqRE80AXcsioEqDf6CcoNmwjO1OjVWbBJycWoYU7p2D5yi9UV9?=
 =?us-ascii?Q?dneghY9kZKNcjeK53zH4gmo0RXwW+R92ogkxDFtChWNUpY8XiW+nfcEBCGR2?=
 =?us-ascii?Q?z/+FlPfU59+P86scIXfzu0SMa3X/bw0dz20LKK2IoL6o6bNcTCp7d7VTfhJN?=
 =?us-ascii?Q?9Vi1OJS3JF2sPH1o2k5T2p+BfdcWXSTYGlSV/7kRuKNGUotYiqCKfu3SPaiM?=
 =?us-ascii?Q?MdNGnATbsoqDTPjMOIf6S1XKVGDgP3EKNm04bGqOfTvw8bDxTOjDH6SH/Qu0?=
 =?us-ascii?Q?buRJlJIX3LGCLjAKK6NiGoctLv7weCa9LFyNC9mnV7dLnXGxZSq8iUjpqGUY?=
 =?us-ascii?Q?1ZYxAznssh36C4JxRsZGR0TtA5c09V7tyFV79C55ahTHpeKxB7yuy2I615Cc?=
 =?us-ascii?Q?EwTzfugDNieP7raU9w6yXbPYA/cWuKCA+0aDbwdtEG+J1mnCMZSUvsSFDpEL?=
 =?us-ascii?Q?ex8XLDpPGwvT3sq6b0/jZRl6nIWX3RdWrUMMGuLI6oVhSq20ibCUVIjkUXGc?=
 =?us-ascii?Q?hmXxQf8x1a0k3lm6gY5vvwpuA8juvJAXnQIECHz4dgNksVMI+vs3+iM1pMuM?=
 =?us-ascii?Q?42KwZDDMYmIlnZ4uNTGZ3xButSGWjKv5la9C9b5amsaIPlKmdG4JpFMX3i5b?=
 =?us-ascii?Q?W11+OBtjcu85D3PecpC618qJ2NF2x+vjgX1vJd3CrcfrHY2LqpAXiYG9/Jtk?=
 =?us-ascii?Q?cIRm6AsauS6rJYtEMOqxHcf6fRmL8GBH04VpBVipoUKmBknCuH+VLFnZpFnD?=
 =?us-ascii?Q?mBpgjBg1oIFueDz33PPojYztecIub2O4KBf9yPeWBBs+4nyYn6ZNMp0KrAsm?=
 =?us-ascii?Q?DnUOKTZx0nGHra0XCZrAnZT1iDIMaU4HPO5nr95FJuVdIh0seBXHu6rZhCXV?=
 =?us-ascii?Q?Qj/sIO1NeQknRBd7+ziEt/EmiAHKiv56CUZX6OE79SlFPtqxuLdpZdSgg642?=
 =?us-ascii?Q?NIhE6QS8Y7/CCLQBxqZaMyR/SY3I4pfYN9n9g+ms4yngcPt7FQtQiXUm8Wk9?=
 =?us-ascii?Q?jGc9rSHQVWWKTB8XgZhYKnbH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace483f6-563e-40a7-fef3-08d8ee16d595
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:11.5422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yaZZpI++uRCaUNmriY8vJPUGJdkj5NftXnERvGyWXxgEfWWG2ikaqEbB2SWX6QkR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fsl-mc already allocates a struct vfio_fsl_mc_device with exactly the same
lifetime as vfio_device, switch to the new API and embed vfio_device in
vfio_fsl_mc_device. While here remove the devm usage for the vdev, this
code is clean and doesn't need devm.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 20 +++++++++++---------
 drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |  1 +
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 8722f5effacd44..ad6c6feeeb4b2a 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -616,24 +616,25 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
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
@@ -648,14 +649,17 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	ret = vfio_fsl_mc_scan_container(mc_dev);
 	if (ret)
 		goto out_group_dev;
+	dev_set_drvdata(dev, vdev);
 	return 0;
 
 out_group_dev:
-	vfio_del_group_dev(dev);
+	vfio_unregister_group_dev(&vdev->vdev);
 out_device:
 	vfio_fsl_uninit_device(vdev);
 out_reflck:
 	vfio_fsl_mc_reflck_put(vdev->reflck);
+out_kfree:
+	kfree(vdev);
 out_group_put:
 	vfio_iommu_group_put(group, dev);
 	return ret;
@@ -663,19 +667,17 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 
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
 
 	dprc_remove_devices(mc_dev, NULL, 0);
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
2.31.0

