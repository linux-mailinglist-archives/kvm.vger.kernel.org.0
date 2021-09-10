Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593374073B0
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 01:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhIJXHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 19:07:45 -0400
Received: from mail-dm6nam12on2044.outbound.protection.outlook.com ([40.107.243.44]:52128
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231742AbhIJXHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 19:07:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEQriZFUMRo4KS/vykSOI21wAEj2lQwTOrvdu0o2RTfWfC8r5aw14TGsiL0qGhHya1Z6rwdxf+Y4WS/KzjYxaCBIGSfQsu+Swzf4WW5+WD+FBzWctihbjgiqSpfC+AuxRmHkzJTyCLY4Tsze6/VPxSKyyvE/Mhn//YILMheuaAgh5bEVJIRVI5E6op24N43CH0+IGzo9NbDRXP42NAzPlkLG/zYSJaYYeLYPkkIIhXryfDzSYYVgU8Pg2mgQPLOaMdpiLJJ1zoVmiy0OaSbFxj9/g8hUxXP58Vs37CU5MdA2dMXDxKGyy2fMGaAcrVYp098TvzRATwKXCmwqxvLiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=h+vGxovTxT+s4XRJBP7hm7bjpDwMQsyUjt2i9ZfnRT4=;
 b=NKTLfAw6TreP6sidpM6EPZYOWF9dNFmoQo8bRYloqLFipsCURG5AFS14djQ1L/cr0tvGauxKfnYjSD+bnh/7O3+LLd10K96HjHAsMk94unoMVur1xdfM/yFC0RefSC6Hj1TjcLAJE1AddsBxa84mMAL97OD5VGkE021Io4XrU7pdeJ2WVrdmlUtCjwoUWt8c3SrirKFTxoLia+AIhewb+jeJMW36OJQ5tlcs+tGO9ScrVmiViEiX0pT/Zpr0fQ9RTr2DzLvR/H3y3VIOKd+8xJs/bomGnq63s/Mhi+vdYY16zKhwyakg7ruJYegLkr+Df2azLchuPhSiimq8xd0KcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+vGxovTxT+s4XRJBP7hm7bjpDwMQsyUjt2i9ZfnRT4=;
 b=uk1WzswteG9ka25e1yt6mySwbooir/wwPmspq6DOcX8plLJaiu1uRbE1k6ot+Mtdmfro/qVUUUsO7JeUF9694/SorV/S6Neg0gk5jkLGTMzVgugZ+W9J/SDASULccMpgQHaOg4OmhsCRexvrNePcUCDoK3fyGBbA36cBHx7Kl7EeCGa8dojuJFigSvFZ7yzTfxH2zSfMsP0LO8F8sVS/e1nEb8yVuZtVIgX8KmTqRVxQjECsbaiU8vHzsq1R6TkAKcBj0kmkkbzbXUJS/IBP987kKQ1D1iHDPRNwblpFUNMPk8RiPOMOPDsCgS+w4YZGMHfZI7U0hj8hG6vfKi853w==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5093.namprd12.prod.outlook.com (2603:10b6:208:309::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Fri, 10 Sep
 2021 23:06:31 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4500.014; Fri, 10 Sep 2021
 23:06:31 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: [PATCH v2] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Date:   Fri, 10 Sep 2021 20:06:30 -0300
Message-Id: <0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:208:257::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0033.namprd13.prod.outlook.com (2603:10b6:208:257::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Fri, 10 Sep 2021 23:06:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mOpbK-00FguE-MK; Fri, 10 Sep 2021 20:06:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d10e78d7-ef8b-4ca6-9110-08d974afa0bc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5093:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5093B1795862D393970DD99DC2D69@BL1PR12MB5093.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:131;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWiyG8T2ix+HMVWDcnuzMb9DEYduana+QBLuZ9QOLkHxywwNK5QM1uLEXM6Uy0AmuO+2UP3sjqyhdbrC5g8nJ7J5bkGST4yrev2NqURDuud9YTHMwPcSdX/Xq2KZ06E6Zk8vFif8dxoxAS93241RLRHTbk5Y2frE9p8u1CTq46G3t0YoJuO844Hwiud2wKsa9ft1mo8F5mQtArViLYm8RSAQhS+xV9A7ZoVr161dpBrY0xCSWHnasi0zEeS0urc/jX1YDC3eFZtFXAHOmUMrP0EgNpW2o0f0/OHtJnRfZQ/fr2dBNJtHENtR7VNAbGAEhuD+3ektkqtT/gnOesVDwBb0c5dmc4gOKNZlmlNZKUbQgHpEVnqE+/hVMcaDCIy20ASDeMjLIBeZFAdEoRfz29aD1Hd8wgVvR4qGIcDgqLaSuHORUzuo5aSUzOi+g2AvI8iEAZllCzT9IkNLIvaOU2JAUQT9yZKokUOiA+QKchz4Pfnu8YB0ik+l9r2dI0qGBJbseDQy9wnnDl9t3PE7I6IaJ5B7vgMtB+m+i7U8zKkqVpAHLb0wMfR5Ed/lNvX4kmiy0S+E5ozIc1G5SLbCIL1RissvFgpCEV/tP60jy0LdEXW/QkioGNGVEsmWpEabpAv4ZVj14H3p+e4Rs4CeoclLHo1qCrsQIgAiHIKgx3RP9yl4qDFQWBafq8j0y+8itX+4G6BPvYhAmNT2N+P1aysgWJZi3LOYNjqoBv6B+D/YrB+Izv0y8Svax7uXJSYIFB/bl43jLslrgevVhiOBgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(2906002)(54906003)(110136005)(426003)(7416002)(4326008)(86362001)(36756003)(2616005)(316002)(478600001)(9786002)(9746002)(186003)(8936002)(83380400001)(966005)(8676002)(66476007)(66556008)(5660300002)(38100700002)(26005)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTiXwe/8tempuDY9cR+naI/nw8Dof0QKXr/uyaBETt4QAmVQuCNAQCJSoxDU?=
 =?us-ascii?Q?HLDHkBWNyfPOurZL7vcnZz4mVN7e/C9JlXPwAXJ6qj+LC7xTx/+8bwSxW3Fk?=
 =?us-ascii?Q?ZEt3dnawrw9kJTVkcuggS2Utq/EoEPQQfJ5B4rZZ0gJpSM41pRTJgtm4yGjE?=
 =?us-ascii?Q?KcB82UqmYlcTlLTfWKrqMX52MRNuNISbdm6D9XfC81KRmqT5ObIM9BVkPufb?=
 =?us-ascii?Q?WsHpqe4D7TztEadK8fS9d+iPHNvWzpvJxsPV8pG9L1InKKjaIDAEFytIUnUj?=
 =?us-ascii?Q?XVJ68ayo6U9KT901aNfJmEmhLh5n28QUwzLkiVfaKyzlTPqkjLtpFW9Rloh9?=
 =?us-ascii?Q?KnnFEb5DKUVs9rZJjX0KySioZMdOk9/yPgnwIUDNo/L1Ei3AaglvIUgK9w1v?=
 =?us-ascii?Q?12f4HBZploI+jMraFWr7RW6AvPKjzujgcAboFvHlckeQ/B5g9NzPArGlFurd?=
 =?us-ascii?Q?F3uDB2MNMxq2wiqmVwAmDNp8ypkirilU3Pjg9KuVqvfavLX/clGHA/qqnuiE?=
 =?us-ascii?Q?5Kqg3UjTWn+t5Zw0IcOxXxsrm+AhSEudMzJY1COlCkM7LmJ8tjJMT+05eoJS?=
 =?us-ascii?Q?QyEon6nYl3YjnXyUOrCcvSpZCbUNajda6Pk/bHFBl3tW6EgvCWwMq9OXhrt7?=
 =?us-ascii?Q?I62iStv9tZGEFqVL9iWxH7bstnhdsu06B0o5Go/IQqGna8EA8R9ZJLHUJaUZ?=
 =?us-ascii?Q?8bJ78QBRwUxbCPFVyJwpWaQFFzk52vgx7OsTCyiiU61tcICM60FMwj5YXzSN?=
 =?us-ascii?Q?9+8+7IoGw+bIfHsMF6i3/YmP6gtoiMf11oJjvT3iuC5jghs8hTjDfBxB3QPP?=
 =?us-ascii?Q?ER7k6kuyjQzB0a2VwYokWyGSddt3yLiITnY+kG1VoICHeck2GGHZM0EJLv35?=
 =?us-ascii?Q?t3snnlUpXYwE4ne9ONKRb5nwIzQOisMVskfW7pG2DB2nxeOcYl6Jkd6Af5fc?=
 =?us-ascii?Q?bqv7fm7c2z64IULwo8xDOPo9tOGE4zeIOGCEEp3Wm1FH/yHfwK/KmDVT7zo7?=
 =?us-ascii?Q?ywXW88337yLCa7A68J/yMYKPZURs8Tf2hL94RbOXYordoK3Y0WiIivHjHE99?=
 =?us-ascii?Q?MqlqtwTdkll26ov62xCuRdXWwBgS4ypeWT4q7uwBRfodePD7AtviMBPJmp7q?=
 =?us-ascii?Q?SKB2vP0LykOaWb24YWX4WYLRT/udP55QNpgVBHHV4XXIYbb/g5g902noPiXJ?=
 =?us-ascii?Q?mwJvdZLr0WSc4OXP9AdQMFTku83aoRazsiro3IH2y0PC32AVtEVkmRLItLK5?=
 =?us-ascii?Q?NN2ACU/Y3pXkmkCFA31/cUXhLnnvYZFx/tYuJkJooiK80YGrDqOBqspJqWnq?=
 =?us-ascii?Q?mUIaDmEwPasW9M5J1Kgq7Lag?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d10e78d7-ef8b-4ca6-9110-08d974afa0bc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 23:06:31.5373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tl0Zgx0M398l+rmi3lYJXBO1zOmk/vgiQZlS0UwJbairS8Kx87nhXLdpmub1/CSx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without this call an xarray entry is leaked when the vfio_ap device is
unprobed. It was missed when the below patch was rebased across the
dev_set patch.

Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 ++
 1 file changed, 2 insertions(+)

v2: Fix corrupted diff
v1: https://lore.kernel.org/all/0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com/

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 2347808fa3e427..54bb0c22e8020e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -360,6 +360,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
+	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
 	atomic_inc(&matrix_dev->available_instances);
@@ -375,6 +376,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
+	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 	atomic_inc(&matrix_dev->available_instances);
 	mutex_unlock(&matrix_dev->lock);

base-commit: ea870730d83fc13a5fa2bd0e175176d7ac8a400a
-- 
2.33.0

