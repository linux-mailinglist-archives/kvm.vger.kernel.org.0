Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541303464B4
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhCWQPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:37 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:19553
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233146AbhCWQPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZMbxaLfeSJ+z4oTsSsBDOlDiTWCThC06IxQzydGrxeDU8Cv0N1r+5V8CKa3PVbpU2B7+4HHOe8xzKw3bV1jk3ml7CWfUNmofoXlCcZIhdFzxC18woEQgTMp9/MhSCup7WxocqxZSzSj12hgPjuGpFsLE5ZmuDdPz92/KH/jQePTXX6og2aG3aIFeuIYdt2fjbRLmsaaOpMkSIKOhtqzjfLXcuEoop2ttuZVBGQAZyj+I09qndoNS/Dc+UVtLl7uX7HDPfgJObPtfovcxLhdQ4vjhN/bML6r55dJHlG4E3VzV2DScRP25slizVyS86fA7mI5hgWTTRDl8iAjLOgOqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4i/pnK20oCPGCb7cw03L+LZNTRDUDKni4LwtedBrAdQ=;
 b=hCPWMN755MoVX6MDaHmeCPTSDlUAiqsWA6sZYBQQNk2Ax5QBs+FF9sj0d4s7zjndVnVBSjGLjzXlOFLhoytB5rwko6XHMlnfqdZMkysY3OKMgNqqqikf5Ohm50xBwbbE5TGzgbE1bYn70xhYCsMHtRPnR9yyfhiyfgSkAlGOxNbDgVzRONwXE5EFJ9DEC60ePEWglMT/HC4RONT2b2LffjEm11M9ybQm9c0b/ZFoAjEpe0dTPfkt2K/QanH7XmaLVTFY2+r1mDGrx+HrVlzIRdU5OPoIHk3ONOUUSXK7g6VaCaMhEpVQOAKKAMHd8OJNhfM1/49F+XeglfvJon1Buw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4i/pnK20oCPGCb7cw03L+LZNTRDUDKni4LwtedBrAdQ=;
 b=JlElBcJPoYVppV1n7RLrHYYAO3EXCvCK1t4KCsFVdVHsHlK+QFantj1ZoX7neok+VftKudXG+wsR8CSwUS2Em7MLcj7yAhaslv1QN6us+7dVrebPddM6LXZN8QR0OBlCffJQbmCWTAqxyv05CJQz0rY1501JYZOaaKRY+AyzbzG2kguzGl/owqTx5elSZiZCQbjgU9flmJC+vr/fnetktrCrlJL+5NwVAP6rleJYyHarfr367OYl93MzGY5R0D4U0EiSLLhoJ2Rw9N1FkQ3bm41ijAY4ceAe+0a0ldOF0AA0nyhdEjUOOlgqULejk83veqvPttwOo8wWQRnkoJ/mcQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
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
Subject: [PATCH v3 09/14] vfio/pci: Use vfio_init/register/unregister_group_dev
Date:   Tue, 23 Mar 2021 13:15:01 -0300
Message-Id: <9-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR19CA0017.namprd19.prod.outlook.com (2603:10b6:208:178::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 16:15:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aCv-NX; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a89e928-08a0-44a5-e5a3-08d8ee16d492
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267EFC3FCA16D726372CCF2C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wX9Bk5pURbMpd02E9UCMX7Lxq77npajuxgM0bXgJz0dQGA2/WtBJTh7cWIKZZottTFyuUCoXQpANwYH6HA1DXC8fxY0xqefQeR6+UnLO6IyAfTXSQDYhmW+vIRW4pXE4AfS4Rvoy3dQ+22Njzye8KV617giwRSLTskWQXRuKfxPVhRDzVQrsvmTByJKpHObY1xFpYeuLilvCkzbxLx/24LUBKE6qbVZX1kGy332f4vDGPUeVfXcdyMDFxeHXZ5+tW10DP9Hrl7Jy4fbTLsBBrjg1q47p9SfDJ9HNwo2oYUsCwaaJDbvTJfTg8hN2v7fpIabDyy8ydjsJ9SQXFt/jnsV1CLtwg6IHKTisFYCPfv7PWh4HYfVn+CqM1XKZW5ojI0/ZbLomdwKFlLFxKAI30vxDin2RsadXtspvZ32J2ty09zJgiicGVYANcKwluh7vTQnStNPKqGfQLxwNEgbVwq0tW7VzvKLG6MPjG+yJalyYio3tBz6fRb5nO2Yqvmdvo1mVNpMlSNff3MHPCa5r9WHMAbY4qd9uwiq/snPWqe0xHeV0uRnwP4p2xI4quzGr/bNeqVo6o8AykZAo1IYsjbRuQZX5G0W8/DQ9aEJY6oZHa8fSr/Fu+3sjvD/xYe6UZbhfTIcF7j51697Ef4JSfw/u/30C9UJp2VNIVR+UryVKT3YQyxwIyVD9mFktmF5k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(2616005)(66946007)(66556008)(2906002)(186003)(7416002)(6666004)(83380400001)(426003)(54906003)(316002)(8936002)(478600001)(8676002)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VmvFKfZCr09fIVtLfM+hEseEwDO0A7J+SQMkAz2O9FUsv1hn41ZvpblfdW8m?=
 =?us-ascii?Q?ZlcxdTyzD4lnsjy/Gv8eklEK7vO9XtjwvyGdnzsTV4v9OuguflR31qQ1bsqw?=
 =?us-ascii?Q?rOohP24bTd/ztPxFZdpyfOgrq+998Ajn6KTb+83nyN7GB1LQclNNnyGmADl0?=
 =?us-ascii?Q?5lxk96K2FdJO16DslO/upXebWkE5pMaY78k0pOVBWwKQnfrJ17tniZzhBEe1?=
 =?us-ascii?Q?Nm4bxXarBQEGmE7W8ow2mUy3OD+KmqVfeQZ6n7puaGQDo1htwYL/n65nZ0wN?=
 =?us-ascii?Q?NOY6pBjTM+IhlBmN6d3VM4w8ZbErDgINpMVkJaIq5idC1FldQ9gXN73AVPqV?=
 =?us-ascii?Q?YD8krs6gI6wkpXxoM1265G/u1qcD3yzZGLXldH1cRLnJXCawGnmPwEdnfIVd?=
 =?us-ascii?Q?4XhM56U+3Rg647CRAUt2nAd1jJRvTRFCZUrzKzkcn0j3RYuDx1+23cgMGO+L?=
 =?us-ascii?Q?Yv2KxahCMBSyzY9dnMCE0g3XSIq6qf8ZmzLNIzBIl4pAF/j0Mkwn2k7ZEVhT?=
 =?us-ascii?Q?0d6otMO8FEJcainD+WVX6AspKDZ3HNZaxawJ1f5w6IFGRE4QPeE9KhA5Dh8y?=
 =?us-ascii?Q?Phf/NcXLpsgxj7G/G5HF+suWaLE3uT2i0HtgJvw5Lu/e3iQpYwpwKKI3wSGi?=
 =?us-ascii?Q?QJgUENC7dOw6jVrjNvNiS3ic+s/6TLrOLk9817MOmA4LUOioUy16c01j5DGA?=
 =?us-ascii?Q?WOR6inAJlBMUnkdyKTErPXb33dH1hhShcAlRgpyzEtdmp5eI1b6o/OSVu7PM?=
 =?us-ascii?Q?vd4W/9KBhOjd0vL7fLS1fjUYcYlORV+UKE0E2CQT4EmCbPjHOrzJEuScagO3?=
 =?us-ascii?Q?WL6UJiYVRk54Rf6NeSiZ35l7Dy9IKrUPypYIcD4rsmQcg9AWhDqhTar4mMBl?=
 =?us-ascii?Q?v0zMLnOwukZfYNLbTI1OnR54o/MpdCskdwKU6/S1DGsFaTaea59nTvQ8EBAH?=
 =?us-ascii?Q?IniDiOthUnCeI8Ghf2kqSJ3QK7ywFsNSV1DZXvwS1vm64DadVLfaycq1HU5+?=
 =?us-ascii?Q?ybHud5LW2Bbb1Yvd8m/WWtgzlriBdDaNjNMtcYELcWxtjK534Ye/+ohGk45M?=
 =?us-ascii?Q?ATuCt3bW/6VCT6Zli8pGw++CiH3syITNoyJQuHJDy6tYnc7XuHyQq7DlC3+Z?=
 =?us-ascii?Q?i6P/awX4sTQOby0usgqZTHAyvqdsRx8BPdjzmz0b73Dp/lMwJW7ozNDzyZbD?=
 =?us-ascii?Q?4Hwy8OhLScS+rAB3KvY8C+f0W/BQoY31ik9YgCVBjX+e7LY4BvrbsnnUOn+W?=
 =?us-ascii?Q?3aGtnNVc5f7rAEl8YWhIOB+Wa4izQaOMOVUBD9/KkJpleg/6A94jYp1y2YzZ?=
 =?us-ascii?Q?HDkQ3Ubz/K+dcYtW7hWP+CeU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a89e928-08a0-44a5-e5a3-08d8ee16d492
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:09.7442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6HirdCHsSI9eDBrKzXvVP07W5FC8haooRVYcgUbIxLXV4XHZ6m8/4rdTwu5hGkA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pci already allocates a struct vfio_pci_device with exactly the same
lifetime as vfio_device, switch to the new API and embed vfio_device in
vfio_pci_device.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c         | 10 +++++-----
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 0e7682e7a0b478..a0ac20a499cf6c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -2019,6 +2019,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_group_put;
 	}
 
+	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
 	vdev->pdev = pdev;
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	mutex_init(&vdev->igate);
@@ -2056,9 +2057,10 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 	}
 
-	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
+	ret = vfio_register_group_dev(&vdev->vdev);
 	if (ret)
 		goto out_power;
+	dev_set_drvdata(&pdev->dev, vdev);
 	return 0;
 
 out_power:
@@ -2078,13 +2080,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	pci_disable_sriov(pdev);
 
-	vdev = vfio_del_group_dev(&pdev->dev);
-	if (!vdev)
-		return;
+	vfio_unregister_group_dev(&vdev->vdev);
 
 	vfio_pci_vf_uninit(vdev);
 	vfio_pci_reflck_put(vdev->reflck);
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 9cd1882a05af69..8755a0febd054a 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -100,6 +100,7 @@ struct vfio_pci_mmap_vma {
 };
 
 struct vfio_pci_device {
+	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
-- 
2.31.0

