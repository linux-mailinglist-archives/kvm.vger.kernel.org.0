Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D3C36BA81
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbhDZUBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:25 -0400
Received: from mail-bn8nam08on2069.outbound.protection.outlook.com ([40.107.100.69]:56800
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241741AbhDZUBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQ1fqIqVXM2fs9AWIW3qyaf078qX5LPVe7hYiJe2ZtyqpFDf4kJZhJcGlxGEfPEw8HO4BgDM3zADSTsdVEQ8aX3gayjLaPFCXkoQPHuwWDlbeTj9y68mNHsZbhE+da/LfUs/Lz5ftIl+X3+kzbm2JOX/VoxQB9OQ613nnmjgnqOwiXvlntANB9Jd4UNPvat1qqESpSHt/b6e6TNqjdpfmXJLE1Vayz7ASmK+S0AkVfu1QrHVGV6jTnNL/I9BcGsnbcDe6gVlPnF0CNPoRj0OKhZsm/L/Wble3R6NCNIdQyIZiDOvpnMjvwX48xJZwjxvES880/7MdNb6VZKHiU95gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+blPFGMVcfu3GVQnP/CsQ3xqCUZpm3zrg0rg5IwplDs=;
 b=hmuzR+U7fVEEN0NbVTBLDubFkspf1kI6ADRhvk5Jfdq6fB+8+ibMIhOE+Y8NhgiInrGKIgjyA0/gYCYR/EPwNKAMHUWnW5ohlfMH0QnFRw2IXM3GqBp1E7kq3vuwGwMCFpeXKJAluh/uqJdhZoLp6nZtEDtUwYNhLnHHYkvgMiJ0wrDTvWYqbqQKoMMW6BCtVSasAKDOnaWSvolIjG6VZwe04/y4R22ygAhVJezRzGUj7GUVzNE6oKKv63FblX5/DQVQEiMZpDXmjI0gLto1HGaX+LGsF+I6YfM5TfPYxMlZ2fpmR9djWCxvNmynxVqFO+5VuIL/B3lZmcNkdokZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+blPFGMVcfu3GVQnP/CsQ3xqCUZpm3zrg0rg5IwplDs=;
 b=Bizbyv/xTpSkywdlAQXwAZ7rNunwvRWUDethR5s/ohXyltm5aEZEdYn0eSqlZnNTOz0idi6aLwdEKTqTYmy9Kcn/NYMYSv4vH/Lyi+SqGnhrytbGYYCfPXvFAKJe8af8pQycKdaEci1tRpJiZu+r5SE86sBdd2LcqB8r55I6GiemteAy0skvrhlTGVeCnS+82CyDjg+dWM6PdUofLQOj4VNok3JHO1c2S9xwiIDYU4nrdYdjN2EXUpTTl8u3lUe2kaB3cdR04uSnYfsn71DM17Xc+smgMn0xN1+6EnA1JsVJNQ2v4WnBWlBusQMhVTJazKS1oNV0+aho46GeGui/4A==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3740.namprd12.prod.outlook.com (2603:10b6:5:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Mon, 26 Apr
 2021 20:00:23 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:23 +0000
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
Subject: [PATCH v2 07/13] vfio/ccw: Convert to use vfio_register_group_dev()
Date:   Mon, 26 Apr 2021 17:00:09 -0300
Message-Id: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR01CA0041.prod.exchangelabs.com (2603:10b6:208:23f::10)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR01CA0041.prod.exchangelabs.com (2603:10b6:208:23f::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 20:00:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Oy-00DFZQ-0e; Mon, 26 Apr 2021 17:00:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 070cd515-ca8f-4636-5e57-08d908edeb32
X-MS-TrafficTypeDiagnostic: DM6PR12MB3740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB37400276B0ECDEA7BFCDC24FC2429@DM6PR12MB3740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMGqygIcZ9bXyvDZmqEIu5NOfGqnW7rwgay6TRFVfautPqWE9+50A5R+O+p+lMOGs9XjB9IYDoeIJbEkVRjWzXlnOCnDEuEeBcL5RdU10rcXZDahS5Wz6urzDZWbfEHLVxDCRqSnFFgIaf1FfrBJRgHEQct7WACseCY4wNPvNpLoY1fKNQ38uDwNmE09XJdOp4KYYmWiPSrtGx6Ff+VTtr4hUfK188nvPziArGDOvIFvxF1b6Q4mh7Fd5e5qfb3s9fpNvV7R3LPteQ9Os6x6QxLmQYgemRKCxzWXjoVLb5+9uoOu3zDnTq+eaO3RnGXxJCUMUZKdvW1T18ug0T2g0x/Gz3OZ5q+BaTgtgxfmhVDbIxbsBYeVov3BvY89WgBuL8oy+TsPeldybeVchQvIke2qNWiTnRnKQEwzjKLjb9UixkdxBInfAx7NFI9OJoF8pK+rHAWnnVfCA8WvTJSJ+gPRBXX3kIEtAX8W9tNdTcUbTPnzBmCDTR233gAFa9jXQ37lYVfwOairYSbB1ExxkEQJJoqumdJFxlilrRwdtYphRRIp4uXocK7XoJVBSt7hbHJpX5ijTq/gPfiTOee9Ks2kxVjvupyVoaZaajmZVUJvaF/7IAWnDQmD70TG4DXDNBUwtp+evQk3rVqbOcyHTE6vwruoe3xNYPOo3QHNtj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(66476007)(66556008)(9746002)(54906003)(426003)(110136005)(107886003)(186003)(26005)(921005)(6666004)(36756003)(316002)(2906002)(30864003)(2616005)(478600001)(9786002)(8936002)(83380400001)(38100700002)(86362001)(8676002)(5660300002)(7416002)(4326008)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+JxuKjXHny5YC5O2z7gv7e+/mo/Lo0SxJK8TloeRU2+xGzd19gEunon3F0wX?=
 =?us-ascii?Q?EzTSbTCUs9qCkAO19uYvocJoqwbiyPv6a1yvAVn2iBAcHBDuTJ3r10lxa3my?=
 =?us-ascii?Q?btw/ru+WwDQLbTgnhg3V1OCglIPM57EWMCKHr6i0ySvusBotf9YdaR5hwo2q?=
 =?us-ascii?Q?5F1N9ecNQOPhDMKz9OOkH3spmI2tjH53IGnrdE+lmudJPbe/Be15sA+wbFeV?=
 =?us-ascii?Q?W1+YqY7U4Pga18T/ExtQAUmyMNuiDL+jh+444TB+KWM7w7SrWfqn4guGB51F?=
 =?us-ascii?Q?Nm160p+6z3zrHIffYeFJuTMS5hg69meD+zum0+kR6dM2YR6u1gr87ARAOo83?=
 =?us-ascii?Q?4BeaaSCTJOw1Y0izJGvnHqKwu/yFCziqrCQAb4mQ6n94YpsukO3AXMq1/mMw?=
 =?us-ascii?Q?/J4au3n3+1/VzSiI2ljVp/bxuDo9sfxWqs9mv7s475jHW8Zjvc/RyH6/Nw0i?=
 =?us-ascii?Q?ZHkeWD3p0LzTGB/lIgF896fjf37YNyBL870/rj7mrFzLwdYKwhdBNxib0eLf?=
 =?us-ascii?Q?qLIXxJqrC4+V02zwi/OaIwjMc9LsoMVkharR5WUQmnRxEfn/yGADbHWTea2h?=
 =?us-ascii?Q?gcfQDIj22LkE0m3jl/Sx6ykQ6+zNI+Gf5hz9iohR2VFSDgz3HRLDQPu6b1Kf?=
 =?us-ascii?Q?aKO9eKd8MofYexugiQ7kjYnGfiLYQdvaw6kc+/1Dg4IpGOWGKDQ12NCSvT4l?=
 =?us-ascii?Q?6OrBxmDWu5K63vVjQkiH/aaTahQCJ8ntWPK1Bo1Lr7/KtuEqC4owTYks0GVm?=
 =?us-ascii?Q?whx6CW4FROZTTdGWryNa3p5csYGnsUpFnxCInPk9cmgwRWG7zKGi4NBUi9B2?=
 =?us-ascii?Q?Uykz2Sw1e3RSR/yHtERiqxXcp9ZprbkZWBfSyQ53/EhaKz1s9WLv2mILWBLZ?=
 =?us-ascii?Q?y83MKSmoR9145xe23V3AXWl94cVVknh6pINC4MuNPdxYRkYFGk7s86cMciE5?=
 =?us-ascii?Q?tPHWdyNIoDC+vUQU+irwXAq56cHzyWhKqIRcf4w/ksxCihuesICSg6GkkaG+?=
 =?us-ascii?Q?LuMZSmzSi7FYlPcuNvkGLFjQdV/UJtMMe0g9I/HAQzlWFc0z+S/issgmsfw1?=
 =?us-ascii?Q?eyBDG8LWCob84KiQ0jc7joAAl+yaF29KKzn8lReHBKjZ2lXht+7/I1XMKBBO?=
 =?us-ascii?Q?sVqy1m71WY6p7lDlOIyY7W0NxXRt32Bae9d+jmfzFQOiGAKQql4E3Z2HWAJ7?=
 =?us-ascii?Q?NyZcirvccX2RogbjB/sYAUBamR57p+b8vUAbINI60MTdALO6EMlqUQeUVaef?=
 =?us-ascii?Q?zpt7FX9BNq65fNBPJ+Q1APR6xxwzHm5shwR/6H0+px56upi/h1qJ0/f3FwE9?=
 =?us-ascii?Q?sLmkP7mS8TdnDSjDyBdrb88W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070cd515-ca8f-4636-5e57-08d908edeb32
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:19.8032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zQRtW98vuIhuIlrjLCGMcmhAKkBnlfFb/v6SsSsVx7+6VVL6tQBBL7Z6NoGmQpq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3740
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

