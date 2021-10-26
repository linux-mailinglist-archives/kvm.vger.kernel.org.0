Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C2743B8C0
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 19:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbhJZSAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:00:07 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57056
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237988AbhJZSAC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:00:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F49NpBfTyGkjxY9w6+QUlzjXrbDJ0SPBwbglqRBNxqKcwVlI3xfQVCn9VYu7VvoaLYuKXIBN859+yhrtTroyXa1ddhPdploPA+JN1a7vqjhUbzSZh/vd+HrxIP4AOz0XX7ekfdrf7svhPbzgJ/sAYmnQxhnT1b+A/ivPV/iHU1dZwJbNX+dZOVSbDPzgBbpbaB5hGDz1J5HlkYEjso8xOicGlYbO1YtUttPyYo30E4ifwVsCyBYZOY/YorLDQ4VtdCUHVJPRqgcm/dZdNnyUjELNsH4R/xVnqOQlde/veF/OtD0wO+VW2qXbtGFt5r+nE/vr1T/FiaVIK3EP+j/FlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYcXEm6RVhMLVup7gQaCrlAlylWOGFSxlS3RrQwdBjY=;
 b=ligw5zzyoTDt3tW0ckRDPPMm+jOQIrCG22UBWTf5/NzXgPnUjFqSP7i+1vM5FUD0OZ3r9QCQpGmjxgwohjnlrpNIjjw5TvAT3ezWL2YUKkXu8wb1wqIj/C/0o8MqAXvloScGFTFgHuIbTlSOs6HTntZ+RHGYmLg9ycx85MkG1NnTV8V/jj9dLdADILquSQJJhLVHmefwtRwr+l5kNtYs2BgO7LsmNHdgrtQwAkUJnKTajTOAHRlplZ+HBQA9T+9vIft6D66QyWhwoNProEDtj9G5ibiy2jNW7ejGRWQY9fWEkOfaJ+QpjIqvRHuaSo5wp6tVoJzSsckJLrhnKhz/Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYcXEm6RVhMLVup7gQaCrlAlylWOGFSxlS3RrQwdBjY=;
 b=G6iF2TUGB+6W9M8fNu2Ruy89HDIqbnuRV5KhX2qZ+3OIc/PTuRzrMTX1bCTEBqgUbUeE+1mey0GgyiJ9TswQid8EYfHOV1MHw4o0338jklwEQEsJnem2tTvtrBiGpI4DMt0TWgzZRTH6QA7Es1BKU1Ts6NZ/XWd1nIYlat98Hon7MDA2eibhN5WLv1sQxxugc604KJ07xYHqYHH9WJzJP4kUVkdCydeFQiQM2AmnOCVT8n3ysvbZ2FKxY6livsWHKQt0vff6qlnJw1SrQ3+BGNqN7DsM+mRRxlI7/Cjtijqh372+pOvgfvLApCmoD+3jQajAT9JE2b0RH9DxBycvzA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 17:57:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 17:57:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 3/4] vfio/ccw: Pass vfio_ccw_private not mdev_device to various functions
Date:   Tue, 26 Oct 2021 14:57:32 -0300
Message-Id: <3-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
In-Reply-To: <0-v4-cea4f5bd2c00+b52-ccw_mdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YTOPR0101CA0022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0022.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 17:57:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfQhZ-002BK1-Ha; Tue, 26 Oct 2021 14:57:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cb06bc1-7ea8-43fc-9366-08d998aa173e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:
X-Microsoft-Antispam-PRVS: <BL1PR12MB504854D09742E346ED7B323DC2849@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ESun+9LqGhuDx71rGyc0dnRJSTCrPpJJLmWiSvEJg5OndSk0ddY+PvBFDBIpOLZ2/wo3IPA3aXn+0AALQZtTWLHTIWSGtm7GeKZBX/14PZQGa82dNv3krUzXy12oSMCkGvzExTZWsEogEKHjxIN7sMtsmzPtERA7SMjvRYyYv2l7tQm6enSJ4SKSY1pkKLmrtuR78HTm1eo79PLX4Ta+gRA7Z0b4Vi/OwKksx+xp0JHmKnOfnczoq5AaeNbwIfmcfJBZj9LWPw+Uv3WC9YVD0MhDQKO8sE8B549FWLRwSaZcRK1e1GOebxPUMHZCLZqrEViuuJbQAm9wdHr5FL7IJys6l6yn33g50IGzpgguqiw/U75gAmIeVvN0asCIy5P9Ufjo+ro0OW8f4WhaObvSjWob78jy4PiWFhOM7LA6bu+6VYkvc51ic7/eb4qtZOT8ipHpcdyy1BBj13VZD0Yn86Q2uKTey0kGNAVzkhAaN64DTM8ty6ZX0i7FrdKy39gtAtCmTQdBm/uUlD86OUr8l6bgreITeICaWOUHY8LuO6mKQ8bml4f/dxzAdc2FvXdDzsIUzrF6ip8Ct3/hC7TETwZD8boeTrCneWrwSiby9kp4xMsp9wazp5BoazLszMK3RUX93P0XWUtazBj3FaisMGA+/uYj/nevp73yTqFXVbOL04ZkxElmIoohX0SEVYflBn5CXfSEi8p8feuPskIXAu+1CHv75dZ0gKl2dzKMqjA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(54906003)(2906002)(36756003)(508600001)(2616005)(9746002)(316002)(921005)(426003)(8676002)(66556008)(83380400001)(8936002)(86362001)(26005)(5660300002)(186003)(38100700002)(66946007)(4326008)(66476007)(9786002)(7416002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MTpr1HtwYT0tjMEsy40pFVmr3+JouiDEIbKdlXbJMokljDoSSMNBH8nNoEqP?=
 =?us-ascii?Q?yA9O1kfDFScP1+u3ibP+F09wsqGoThmlxQRWxt5mjaWvasIXTah7tbV723fu?=
 =?us-ascii?Q?oxQukpp5ea0oDqL5838NrJ4JhhsZRJFblmmkeZgbvjYhr7wHnrgoMoOxwUa+?=
 =?us-ascii?Q?7rXRQsphf+iBTy0YR+3XdCON4Bxy8Vs6TsQ+QB1wQ/TUuw4JgGzXCL+mgyW9?=
 =?us-ascii?Q?Hlel8QRYKiuFweun843lOrXS5ZtuSXHHbqCr1eud1wChcImYW0ViJ+mhbUak?=
 =?us-ascii?Q?11SDgRvMfgkB1Pbd6Xy12XwAgHix9fmtK1KPgHpZ32FWWqiBUbhVk7k3lnTU?=
 =?us-ascii?Q?C0SK5on/Z413IURSZ4GPWA588nirBXBUgPSAeZ4OcS6eroWT07tmoCXBKHDB?=
 =?us-ascii?Q?WMdVowKWjeH9BaoUbNANWv+EpL3Q/S3pyFbEF8Q+2HM2iagA+Mqz9PsmSOij?=
 =?us-ascii?Q?6/YSye5dHDW2O2ZWEKMtyc8jBJA7nIlWtoWWS+Owyg/ytGpPzuFJR+TWoZNh?=
 =?us-ascii?Q?oPyRDEY8rBICXZSPKYoxyTvzqQbLaz+einxp13jpxhDJdycqWAXlJP8PbD4a?=
 =?us-ascii?Q?/o7hvSw+2iZ5Aqe6ZIOrEvp5ORZ73mWmOZ1UMVSGfKBfN7CPYPTc98uQgWdz?=
 =?us-ascii?Q?a7oLEERaMdcWcnNEx4CQb4bsNAS6MJIHvKD+n/8bPeSnY0HO52ghm94j7HW5?=
 =?us-ascii?Q?L1q9y9Yhr+FzNAVIJC85mhN+9cN1/rLxHYSjXT55J9aOaB9LYwleyCBS+crg?=
 =?us-ascii?Q?7CzrIPB8kvaGPBp3dxk2wkJm95WRBKeE7N5L/imCVZljQJVsHajfQu91Atb8?=
 =?us-ascii?Q?cGDGB+zuf5JmnHNousx9PkU9Lyf1mfeDee9adv/rXMWBMOcxUiQ484RlitO+?=
 =?us-ascii?Q?a7QgUiUSrj6iXFyEXITlVoYvM6V6y05RAayqLoMDTAo+KbZnGkDtSYMMJ7tV?=
 =?us-ascii?Q?7foxDhcGQDfJ706UgnKHeeA0wn3FAmvtmlaXdu7XVFjt8sU2PxvBdFif1w/Y?=
 =?us-ascii?Q?SuCHZpDyo1RtNFOKJIqPx3/8JHCiFf5h7QYM4LjR1S9VJEKq8asgBM9Leg5S?=
 =?us-ascii?Q?FxrNblKsaNTQFHu116/NImPFUQIls6zCMm60kohRNw29K61xtGwRYyDQ2sUS?=
 =?us-ascii?Q?Bw5DqS1BLezJQx1w+14HmMwvTL8pSJnSHOHARpDlyNsjz4MVCcYLZ7XJVjoo?=
 =?us-ascii?Q?Nmd9neyboAGB3SAh49lEhh7HTHJ04MAaEf+JCOdtLfG5zobOx6+v7xKxxzM1?=
 =?us-ascii?Q?ThKRBhnE7pzguUPS+9MTSXgLYyYqi1GZb7czsiHUJj/0LiZ0ITG4j/Gdid1O?=
 =?us-ascii?Q?EUTmzRcmaUZJMLNS0EIxBi21SV0M5TJp5/izWefdsh6eW6DTUIsB0gCOZlRw?=
 =?us-ascii?Q?4FBZ7+tJpor8wKNuV/dI99iXnHgc2kKRdhOH4ljjJt+8RvV6KhQS7hPU6BUW?=
 =?us-ascii?Q?mviy0Zgujb+85845bzRVg/gXxCCsulEM7pQp53QUep07y3Zxar+XA53YAJXX?=
 =?us-ascii?Q?/TX6t1OnVL5tKkP2IAzeSxpOZv5wOZ82z0iQsf9mxJ+Vg4/5R84dwCqlvx8Q?=
 =?us-ascii?Q?tp+C2so0h46zjlBDNx0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb06bc1-7ea8-43fc-9366-08d998aa173e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 17:57:35.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K2dE3HAD2cwyWq4OXWcbhU5pfiEdcXb6x58sdwZJ67QG1WnoEfCJ4E6CAbqr7LO0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mdev_device should only be used in functions assigned to ops callbacks,
interior functions should use the struct vfio_ccw_private instead of
repeatedly trying to get it from the mdev.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_ops.c | 37 +++++++++++++--------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 7f540ad0b568bc..1edbea9de0ec42 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -17,13 +17,11 @@
 
 #include "vfio_ccw_private.h"
 
-static int vfio_ccw_mdev_reset(struct mdev_device *mdev)
+static int vfio_ccw_mdev_reset(struct vfio_ccw_private *private)
 {
-	struct vfio_ccw_private *private;
 	struct subchannel *sch;
 	int ret;
 
-	private = dev_get_drvdata(mdev_parent_dev(mdev));
 	sch = private->sch;
 	/*
 	 * TODO:
@@ -61,7 +59,7 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
 		if (!cp_iova_pinned(&private->cp, unmap->iova))
 			return NOTIFY_OK;
 
-		if (vfio_ccw_mdev_reset(private->mdev))
+		if (vfio_ccw_mdev_reset(private))
 			return NOTIFY_BAD;
 
 		cp_free(&private->cp);
@@ -201,7 +199,7 @@ static void vfio_ccw_mdev_close_device(struct mdev_device *mdev)
 
 	if ((private->state != VFIO_CCW_STATE_NOT_OPER) &&
 	    (private->state != VFIO_CCW_STATE_STANDBY)) {
-		if (!vfio_ccw_mdev_reset(mdev))
+		if (!vfio_ccw_mdev_reset(private))
 			private->state = VFIO_CCW_STATE_STANDBY;
 		/* The state will be NOT_OPER on error. */
 	}
@@ -311,12 +309,9 @@ static ssize_t vfio_ccw_mdev_write(struct mdev_device *mdev,
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
@@ -324,14 +319,12 @@ static int vfio_ccw_mdev_get_device_info(struct vfio_device_info *info,
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
@@ -406,19 +399,16 @@ static int vfio_ccw_mdev_get_irq_info(struct vfio_irq_info *info)
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
@@ -524,6 +514,8 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 				   unsigned int cmd,
 				   unsigned long arg)
 {
+	struct vfio_ccw_private *private =
+		dev_get_drvdata(mdev_parent_dev(mdev));
 	int ret = 0;
 	unsigned long minsz;
 
@@ -540,7 +532,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = vfio_ccw_mdev_get_device_info(&info, mdev);
+		ret = vfio_ccw_mdev_get_device_info(private, &info);
 		if (ret)
 			return ret;
 
@@ -558,7 +550,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = vfio_ccw_mdev_get_region_info(&info, mdev, arg);
+		ret = vfio_ccw_mdev_get_region_info(private, &info, arg);
 		if (ret)
 			return ret;
 
@@ -603,10 +595,11 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
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
-- 
2.33.0

