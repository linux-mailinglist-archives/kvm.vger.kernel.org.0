Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C265369D0A
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhDWXEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:04:13 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:21884
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236667AbhDWXD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:03:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uec3zmrcYHQG+x5OIrfZ+akptjlYLCme5Tome+3lRDZmotNnQ2wCuzk6pRryr4dWaXaHeKGsGr2mERJNjPPLpYMpCjlVtVKHg6kEOjFzRY23Rw8QJ09GVXcEXCrFevzNLG8pyy3OQnUXCFR08HV3k1/EgSnJ7d1WE7PRHKQbjNDK7pqAhld2Zdq0duRWsfq9JF91xdecqsZYRnSumF0hAuPqBCHu1i4rf0GATor7xQ+LH6BTE9qgqQKd/CsLrw41D8Hux0/oxHXGVxktGy6P/CJ3dkNJ5vHiRVMEQSex2TQHM0IwES3RSZd0EVIg9SF9iWOuRp9sYwmTGSuQZlDyMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+blPFGMVcfu3GVQnP/CsQ3xqCUZpm3zrg0rg5IwplDs=;
 b=HHYCCkddZ8BKSGreoY6j+br3fXmQsLTGypTljFeYoug2SeH4vh11PbEHCMc98Palp/DCoeqGFmo3A0yWJFDjjiMtrQkPshkIHuBsz6BOgqPukerjtcnPlcU8jBSBluGUcNJds19221jqUqQjbS/dgjKg7CnqFN60qYD0j3smECVNAFtb9zGFOoxpClY9jGupRUwoGq0KS3RTPjNX6r42f//Yw1cg4H/bhcy+CvA0Gz03QPhfpWGm2S9hMTiEnhJGLsmiFfZj+bDr7XfV3wScy7eO5WmPETiPXmeEENIodCFKZZpLWcGFogBoPJNbnSyerv6/P5qpLIId5YHUO3Yz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+blPFGMVcfu3GVQnP/CsQ3xqCUZpm3zrg0rg5IwplDs=;
 b=EBmzZZsRW3zZOXbjyrjo+Xb7D4Kp7dVRGCif2dUCHzPGkO/mjAZOl4ORolCHiAULsX2IUr0fCU6NTB8tTcHVXtJqmXQh8bdLw+uru92Pt+QzYWBssxltNpCednijzX/u/FYQf00V5M5xSTDsDgIGZg8F3O6Rxj6WHl+F/NgiS9GxqJm2IFM2pU6AmGP5pb3S9KckKPIsdh/vgJWA7ou/M+jwVx20bnp1Xkh8hKexS5v8zNKn7Cb8cpY5TMO5vJ7aziGqBUSfd0HS2qCjqa+tBxJyVNNJ1Cu7D0za3BdwfRjnfTGaK8qysJy+dv2uHyT84hUfMyqVOrq62B3DgpE94w==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0203.namprd12.prod.outlook.com (2603:10b6:4:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 23 Apr
 2021 23:03:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:16 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 07/12] vfio/ccw: Convert to use vfio_register_group_dev()
Date:   Fri, 23 Apr 2021 20:03:04 -0300
Message-Id: <7-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:208:23a::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0021.namprd03.prod.outlook.com (2603:10b6:208:23a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 23:03:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CHzr-8D; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51441ca2-ec11-4a27-93cd-08d906abf8da
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0203:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0203599B65B18A7CC586D40AC2459@DM5PR1201MB0203.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CuYQ7S92OszACX46gK0Oc/52TErY8VKialBn5spPQQ2a4dqaotYV8kO6s6hcCW0CuQqtKf3OhY9dwIR7bRlPgIrNmPnBNB1/nolVo3RLa+TuFxzBCKjEGQsjAUksc+UYyEXyYClc64n9foF6Qe5STXjXMNIy/LBVh4poJhW6BY/hO5mP1LB1KriS34UQCXm+Ai/aQX7tvw+DxXFDzVPuTqdD5glFRyicFrfCKtNCyQe2D5hYSfRl8w4VEGVX9PKJWeV+cGTkZ/zs5tNjZYRL+hu2p79JjLmzTeVJnR0UiSz3vLt9xSL1+YiTOKGO2+8AMsgEna9LNY2NP0fHWWNhbHMjdh/9Ua78rtUsSt835BBbqBuFrbxrzqFWrEl3+RLEOG3hid8sg/MfSntyMyOvhqv6kA2eXKd7fiqSiEQbctvMA83CNI+kdkqieTT4kKuO4MCYpvq84eieRLvs0DKYZhnCbwEGdVqBBqehbJD24iq8jd8hRp00Z5NK8sHAHofb6I8J/RIRZ27suXx8FPTGli3/bvDS7AOWyEfDknNRD3sRxd96IhIGEupmVc9NnJvXjiKBZbyDlrKx/WfLHd5aRJryo0SGzl5Md6Llq1zcjp41WIKcFvFUQxRe5jnsgWdO+71KnlrI836gFfQi0eG3/+dUXAQ66MRLoRXIr9a6whk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(6666004)(86362001)(2906002)(30864003)(66556008)(2616005)(426003)(66476007)(921005)(107886003)(66946007)(110136005)(38100700002)(36756003)(26005)(186003)(83380400001)(8676002)(54906003)(9786002)(316002)(4326008)(8936002)(9746002)(5660300002)(7416002)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ciTp0/sXxCe3KJPrZVikyh2chk17Zi0gDRYfv+plg7Fsh2JmyFjiRZCuPvx1?=
 =?us-ascii?Q?XN/9y5MxbV15/Uo25T+JfqfDfBM5YDEeuE2WONaZahnMW9zheJWm4aLJ0Yd8?=
 =?us-ascii?Q?GcpYj/G/JmQo1D8AY22ActIN2KiREUg+rdnlLggVEw6y6sJdxixuqFeT8Zj3?=
 =?us-ascii?Q?9kS9jiIXyIX7Eq6JnVlZ2wHlfEDWkxTviIuoaGZFkcBWDeiWXwV9EXO+ZToz?=
 =?us-ascii?Q?7ofZswPzOELNTKpatdZpD6mDKtNWAuJeFefY8eIqBw5jizhARI6KqEraZ2Qc?=
 =?us-ascii?Q?THIXtAv/4q/bY2YxN9Ex+FG5f/x9ZXEplJVzM+q8waNuAJXHfO8XiKE9O2KH?=
 =?us-ascii?Q?i+d80tCff8b63ZE8AVK6nTKIX6Y5xl0iw/3GMa8bV+bQTKp4ohBtDhna7bvo?=
 =?us-ascii?Q?kUNxulqkKxkT72KPLuUprxcgOLVwaE6BRjDhTnPCLH9myWl3jyd62Ctlm/Uf?=
 =?us-ascii?Q?+i/41l49FDINw0fgPJvkJVT9NeamfmsX/uxsYRjmWCJsZ6XAaYt22iM3xqOS?=
 =?us-ascii?Q?8xdjjFRid2kVQczEvCA3+6cqnKAC7lF9niHhAdT2bTf84MZTOSxpimfKlenx?=
 =?us-ascii?Q?qEWuzofFFztEQ01d+TYdj0IwI94lwcg4+fJxyLSPnKeyCDkLNoo+5EZhxot1?=
 =?us-ascii?Q?YIIVIfYg6M2CQD2yvil5iaLqYdeXDyQW2oiIFCljHmZkU08t2x8oGzUXZA1n?=
 =?us-ascii?Q?A4vaI/IcZkKc+yBASd7Ak40JPukp1HAVQBUfaA9BL5bEpIHd021r6OJdldyb?=
 =?us-ascii?Q?jalSt+oHGPuebZgx/sH8+l62VhLchMOPNg9zD/dtHJNKTK6Q4BCnIwpcP7dX?=
 =?us-ascii?Q?eHIHN90iVax6tiLdbj/tv1Qd8kJhnXDz1TZOOSdkTtv01u1b9OUQs3gAEUrq?=
 =?us-ascii?Q?V6gLlbUF5+NGNXSDYvi8tWvlk3M2B/Rf01E/rWuaAWNYi+DyHhd9meB0iYD3?=
 =?us-ascii?Q?pkrfQ7KkOKD/dStARTn98nROxJ9JqSpIDSfo5A5iEY3l8opPXnMDqRHT8zLV?=
 =?us-ascii?Q?f7gdZBLXF6cBZG/7lusjwY8R/WSZvoEPMrjzaLW8KqxTfbN5+pR3Z+m0ocEv?=
 =?us-ascii?Q?lrzet/NLRU/1xSTvhUZKBCIn7AklJyGXFCDUw7K0wc3z+wXQNp+Mu2G+Benl?=
 =?us-ascii?Q?1LlEBFA1jBgvj1NmiO5NVrx4DGWPV9njL74J+2lRcx68ObptJpJq3g45rFsF?=
 =?us-ascii?Q?MU8ZpxyhXirmwzkXSdmHko3qlJjBHoZOIV+4wsNO20VTHjwsXDCMb+YlML1D?=
 =?us-ascii?Q?GLHQ3WryB0xTDO/yv2YLhdBcAA7qvfNm3XKBKaq9i7PQY7sglHwUpVHzj3RQ?=
 =?us-ascii?Q?9PbQ6EYny5ADOCl1mScsFvjv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51441ca2-ec11-4a27-93cd-08d906abf8da
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:13.6642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDZcUAMK5MIzwHA9zHEiggYt9Y9qS9OX5yX2tLNOc3Tp3pTiwOuvnAy3pccybLKW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0203
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is more complicated because vfio_ccw is sharing the vfio_device
between both the mdev_device and its vfio_device and the css_driver.

The mdev is a singleton, and the reason for this sharing appears to be to
allow the extra css_driver function callbacks to be delivered to the
vfio_device.

This keeps things as they were, with the css_driver allocating the
singleton, not the mdev_driver, this is pretty confusing. I'm also
uncertain how the lifetime model for the mdev works in the css_driver
callbacks.

At this point embed the vfio_device in the vfio_ccw_private and
instantiate it as a vfio_device when the mdev probes. The drvdata of both
the css_device and the mdev_device point at the private, and container_of
is used to get it back from the vfio_device.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_drv.c     |  21 +++--
 drivers/s390/cio/vfio_ccw_ops.c     | 135 +++++++++++++++-------------
 drivers/s390/cio/vfio_ccw_private.h |   5 ++
 3 files changed, 94 insertions(+), 67 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8c625b530035f5..55c4876dfd139d 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -442,7 +442,7 @@ static int __init vfio_ccw_sch_init(void)
 	vfio_ccw_work_q = create_singlethread_workqueue("vfio-ccw");
 	if (!vfio_ccw_work_q) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_io_region = kmem_cache_create_usercopy("vfio_ccw_io_region",
@@ -451,7 +451,7 @@ static int __init vfio_ccw_sch_init(void)
 					sizeof(struct ccw_io_region), NULL);
 	if (!vfio_ccw_io_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_cmd_region = kmem_cache_create_usercopy("vfio_ccw_cmd_region",
@@ -460,7 +460,7 @@ static int __init vfio_ccw_sch_init(void)
 					sizeof(struct ccw_cmd_region), NULL);
 	if (!vfio_ccw_cmd_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_schib_region = kmem_cache_create_usercopy("vfio_ccw_schib_region",
@@ -470,7 +470,7 @@ static int __init vfio_ccw_sch_init(void)
 
 	if (!vfio_ccw_schib_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
 	vfio_ccw_crw_region = kmem_cache_create_usercopy("vfio_ccw_crw_region",
@@ -480,19 +480,25 @@ static int __init vfio_ccw_sch_init(void)
 
 	if (!vfio_ccw_crw_region) {
 		ret = -ENOMEM;
-		goto out_err;
+		goto out_regions;
 	}
 
+	ret = mdev_register_driver(&vfio_ccw_mdev_driver);
+	if (ret)
+		goto out_regions;
+
 	isc_register(VFIO_CCW_ISC);
 	ret = css_driver_register(&vfio_ccw_sch_driver);
 	if (ret) {
 		isc_unregister(VFIO_CCW_ISC);
-		goto out_err;
+		goto out_driver;
 	}
 
 	return ret;
 
-out_err:
+out_driver:
+	mdev_unregister_driver(&vfio_ccw_mdev_driver);
+out_regions:
 	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
@@ -501,6 +507,7 @@ static int __init vfio_ccw_sch_init(void)
 
 static void __exit vfio_ccw_sch_exit(void)
 {
+	mdev_unregister_driver(&vfio_ccw_mdev_driver);
 	css_driver_unregister(&vfio_ccw_sch_driver);
 	isc_unregister(VFIO_CCW_ISC);
 	vfio_ccw_destroy_regions();
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 491a64c61fff1a..0fcf46031d3821 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -17,13 +17,13 @@
 
 #include "vfio_ccw_private.h"
 
-static int vfio_ccw_mdev_reset(struct mdev_device *mdev)
+static const struct vfio_device_ops vfio_ccw_dev_ops;
+
+static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 {
-	struct vfio_ccw_private *private;
 	struct subchannel *sch;
 	int ret;
 
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 	sch = private->sch;
 	/*
 	 * TODO:
@@ -61,7 +61,7 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
 		if (!cp_iova_pinned(&private->cp, unmap->iova))
 			return NOTIFY_OK;
 
-		if (vfio_ccw_mdev_reset(private->mdev))
+		if (vfio_ccw_mdev_reset(private))
 			return NOTIFY_BAD;
 
 		cp_free(&private->cp);
@@ -113,10 +113,11 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
-static int vfio_ccw_mdev_create(struct mdev_device *mdev)
+static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private =
 		dev_get_drvdata(mdev_parent_dev(mdev));
+	int ret;
 
 	if (private->state == VFIO_CCW_STATE_NOT_OPER)
 		return -ENODEV;
@@ -124,6 +125,10 @@ static int vfio_ccw_mdev_create(struct mdev_device *mdev)
 	if (atomic_dec_if_positive(&private->avail) < 0)
 		return -EPERM;
 
+	memset(&private->vdev, 0, sizeof(private->vdev));
+	vfio_init_group_dev(&private->vdev, &mdev->dev,
+			    &vfio_ccw_dev_ops);
+
 	private->mdev = mdev;
 	private->state = VFIO_CCW_STATE_IDLE;
 
@@ -132,19 +137,28 @@ static int vfio_ccw_mdev_create(struct mdev_device *mdev)
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
+	ret = vfio_register_group_dev(&private->vdev);
+	if (ret)
+		goto err_atomic;
+	dev_set_drvdata(&mdev->dev, private);
 	return 0;
+
+err_atomic:
+	atomic_inc(&private->avail);
+	return ret;
 }
 
-static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
+static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
-	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+	struct vfio_ccw_private *private = dev_get_drvdata(&mdev->dev);
 
 	VFIO_CCW_MSG_EVENT(2, "mdev %pUl, sch %x.%x.%04x: remove\n",
 			   mdev_uuid(mdev), private->sch->schid.cssid,
 			   private->sch->schid.ssid,
 			   private->sch->schid.sch_no);
 
+	vfio_unregister_group_dev(&private->vdev);
+
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
 		if (!vfio_ccw_sch_quiesce(private->sch))
@@ -155,20 +169,18 @@ static int vfio_ccw_mdev_remove(struct mdev_device *mdev)
 	cp_free(&private->cp);
 	private->mdev = NULL;
 	atomic_inc(&private->avail);
-
-	return 0;
 }
 
-static int vfio_ccw_mdev_open(struct mdev_device *mdev)
+static int vfio_ccw_mdev_open(struct vfio_device *vdev)
 {
 	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
 	int ret;
 
 	private->nb.notifier_call = vfio_ccw_mdev_notifier;
 
-	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	ret = vfio_register_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				     &events, &private->nb);
 	if (ret)
 		return ret;
@@ -189,27 +201,26 @@ static int vfio_ccw_mdev_open(struct mdev_device *mdev)
 
 out_unregister:
 	vfio_ccw_unregister_dev_regions(private);
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY,
 				 &private->nb);
 	return ret;
 }
 
-static void vfio_ccw_mdev_release(struct mdev_device *mdev)
+static void vfio_ccw_mdev_release(struct vfio_device *vdev)
 {
 	struct vfio_ccw_private *private =
-		dev_get_drvdata(mdev_parent_dev(mdev));
+		container_of(vdev, struct vfio_ccw_private, vdev);
 
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_mdev_reset(mdev))
+		if (!vfio_ccw_mdev_reset(private))
 			private->state = VFIO_CCW_STATE_STANDBY;
 		/* The state will be NOT_OPER on error. */
 	}
 
 	cp_free(&private->cp);
 	vfio_ccw_unregister_dev_regions(private);
-	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
-				 &private->nb);
+	vfio_unregister_notifier(vdev->dev, VFIO_IOMMU_NOTIFY, &private->nb);
 }
 
 static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
@@ -233,15 +244,14 @@ static ssize_t vfio_ccw_mdev_read_io_region(struct vfio_ccw_private *private,
 	return ret;
 }
 
-static ssize_t vfio_ccw_mdev_read(struct mdev_device *mdev,
+static ssize_t vfio_ccw_mdev_read(struct vfio_device *vdev,
 				  char __user *buf,
 				  size_t count,
 				  loff_t *ppos)
 {
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	unsigned int index = VFIO_CCW_OFFSET_TO_INDEX(*ppos);
-	struct vfio_ccw_private *private;
-
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 
 	if (index >= VFIO_CCW_NUM_REGIONS + private->num_regions)
 		return -EINVAL;
@@ -288,15 +298,14 @@ static ssize_t vfio_ccw_mdev_write_io_region(struct vfio_ccw_private *private,
 	return ret;
 }
 
-static ssize_t vfio_ccw_mdev_write(struct mdev_device *mdev,
+static ssize_t vfio_ccw_mdev_write(struct vfio_device *vdev,
 				   const char __user *buf,
 				   size_t count,
 				   loff_t *ppos)
 {
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	unsigned int index = VFIO_CCW_OFFSET_TO_INDEX(*ppos);
-	struct vfio_ccw_private *private;
-
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 
 	if (index >= VFIO_CCW_NUM_REGIONS + private->num_regions)
 		return -EINVAL;
@@ -313,12 +322,9 @@ static ssize_t vfio_ccw_mdev_write(struct mdev_device *mdev,
 	return -EINVAL;
 }
 
-static int vfio_ccw_mdev_get_device_info(struct vfio_device_info *info,
-					 struct mdev_device *mdev)
+static int vfio_ccw_mdev_get_device_info(struct vfio_ccw_private *private,
+					 struct vfio_device_info *info)
 {
-	struct vfio_ccw_private *private;
-
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 	info->flags = VFIO_DEVICE_FLAGS_CCW | VFIO_DEVICE_FLAGS_RESET;
 	info->num_regions = VFIO_CCW_NUM_REGIONS + private->num_regions;
 	info->num_irqs = VFIO_CCW_NUM_IRQS;
@@ -326,14 +332,12 @@ static int vfio_ccw_mdev_get_device_info(struct vfio_device_info *info,
 	return 0;
 }
 
-static int vfio_ccw_mdev_get_region_info(struct vfio_region_info *info,
-					 struct mdev_device *mdev,
+static int vfio_ccw_mdev_get_region_info(struct vfio_ccw_private *private,
+					 struct vfio_region_info *info,
 					 unsigned long arg)
 {
-	struct vfio_ccw_private *private;
 	int i;
 
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 	switch (info->index) {
 	case VFIO_CCW_CONFIG_REGION_INDEX:
 		info->offset = 0;
@@ -408,19 +412,16 @@ static int vfio_ccw_mdev_get_irq_info(struct vfio_irq_info *info)
 	return 0;
 }
 
-static int vfio_ccw_mdev_set_irqs(struct mdev_device *mdev,
+static int vfio_ccw_mdev_set_irqs(struct vfio_ccw_private *private,
 				  uint32_t flags,
 				  uint32_t index,
 				  void __user *data)
 {
-	struct vfio_ccw_private *private;
 	struct eventfd_ctx **ctx;
 
 	if (!(flags & VFIO_IRQ_SET_ACTION_TRIGGER))
 		return -EINVAL;
 
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
-
 	switch (index) {
 	case VFIO_CCW_IO_IRQ_INDEX:
 		ctx = &private->io_trigger;
@@ -522,10 +523,12 @@ void vfio_ccw_unregister_dev_regions(struct vfio_ccw_private *private)
 	private->region = NULL;
 }
 
-static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
+static ssize_t vfio_ccw_mdev_ioctl(struct vfio_device *vdev,
 				   unsigned int cmd,
 				   unsigned long arg)
 {
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
 	int ret = 0;
 	unsigned long minsz;
 
@@ -542,7 +545,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = vfio_ccw_mdev_get_device_info(&info, mdev);
+		ret = vfio_ccw_mdev_get_device_info(private, &info);
 		if (ret)
 			return ret;
 
@@ -560,7 +563,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = vfio_ccw_mdev_get_region_info(&info, mdev, arg);
+		ret = vfio_ccw_mdev_get_region_info(private, &info, arg);
 		if (ret)
 			return ret;
 
@@ -605,47 +608,59 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 			return ret;
 
 		data = (void __user *)(arg + minsz);
-		return vfio_ccw_mdev_set_irqs(mdev, hdr.flags, hdr.index, data);
+		return vfio_ccw_mdev_set_irqs(private, hdr.flags, hdr.index,
+					      data);
 	}
 	case VFIO_DEVICE_RESET:
-		return vfio_ccw_mdev_reset(mdev);
+		return vfio_ccw_mdev_reset(private);
 	default:
 		return -ENOTTY;
 	}
 }
 
 /* Request removal of the device*/
-static void vfio_ccw_mdev_request(struct mdev_device *mdev, unsigned int count)
+static void vfio_ccw_mdev_request(struct vfio_device *vdev, unsigned int count)
 {
-	struct vfio_ccw_private *private = dev_get_drvdata(mdev_parent_dev(mdev));
-
-	if (!private)
-		return;
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
+	struct device *dev = private->vdev.dev;
 
 	if (private->req_trigger) {
 		if (!(count % 10))
-			dev_notice_ratelimited(mdev_dev(private->mdev),
+			dev_notice_ratelimited(dev,
 					       "Relaying device request to user (#%u)\n",
 					       count);
 
 		eventfd_signal(private->req_trigger, 1);
 	} else if (count == 0) {
-		dev_notice(mdev_dev(private->mdev),
+		dev_notice(dev,
 			   "No device request channel registered, blocked until released by user\n");
 	}
 }
 
+static const struct vfio_device_ops vfio_ccw_dev_ops = {
+	.open = vfio_ccw_mdev_open,
+	.release = vfio_ccw_mdev_release,
+	.read = vfio_ccw_mdev_read,
+	.write = vfio_ccw_mdev_write,
+	.ioctl = vfio_ccw_mdev_ioctl,
+	.request = vfio_ccw_mdev_request,
+};
+
+struct mdev_driver vfio_ccw_mdev_driver = {
+	.driver = {
+		.name = "vfio_ccw_mdev",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+	},
+	.probe = vfio_ccw_mdev_probe,
+	.remove = vfio_ccw_mdev_remove,
+};
+
 static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
 	.owner			= THIS_MODULE,
+	.device_driver		= &vfio_ccw_mdev_driver,
 	.supported_type_groups  = mdev_type_groups,
-	.create			= vfio_ccw_mdev_create,
-	.remove			= vfio_ccw_mdev_remove,
-	.open			= vfio_ccw_mdev_open,
-	.release		= vfio_ccw_mdev_release,
-	.read			= vfio_ccw_mdev_read,
-	.write			= vfio_ccw_mdev_write,
-	.ioctl			= vfio_ccw_mdev_ioctl,
-	.request		= vfio_ccw_mdev_request,
 };
 
 int vfio_ccw_mdev_reg(struct subchannel *sch)
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b2c762eb42b9bb..7272eb78861244 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -17,6 +17,7 @@
 #include <linux/eventfd.h>
 #include <linux/workqueue.h>
 #include <linux/vfio_ccw.h>
+#include <linux/vfio.h>
 #include <asm/crw.h>
 #include <asm/debug.h>
 
@@ -67,6 +68,7 @@ struct vfio_ccw_crw {
 
 /**
  * struct vfio_ccw_private
+ * @vdev: Embedded VFIO device
  * @sch: pointer to the subchannel
  * @state: internal state of the device
  * @completion: synchronization helper of the I/O completion
@@ -90,6 +92,7 @@ struct vfio_ccw_crw {
  * @crw_work: work for deferral process of CRW handling
  */
 struct vfio_ccw_private {
+	struct vfio_device vdev;
 	struct subchannel	*sch;
 	int			state;
 	struct completion	*completion;
@@ -121,6 +124,8 @@ extern void vfio_ccw_mdev_unreg(struct subchannel *sch);
 
 extern int vfio_ccw_sch_quiesce(struct subchannel *sch);
 
+extern struct mdev_driver vfio_ccw_mdev_driver;
+
 /*
  * States of the device statemachine.
  */
-- 
2.31.1

