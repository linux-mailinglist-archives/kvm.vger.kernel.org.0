Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BDA5175D7
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386662AbiEBRfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355294AbiEBRfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 13:35:10 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF4F2AE0
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 10:31:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWBHreAjSf4E95gJtXAjpE0sMbJ6cZACkQgKThAg07R0GCqKxPJdRlCzHSATxRlnE36UB1b5RwAH3OC4bPQZdqUKg1XTpDBa1hBkgHTUDNTytktuGLlJ6qHxWJjX2b1ekf5sIWlz4LnS6nCltTvtdWwx/KGbT9626LzMt7m874037rI1wMiIW0Lt2ckE+LmEDDTM7nP0a/RX7Ru7jFS40WgBDSSpQFlH3c9N1lW0D1SNuUVMdhXdNFlRy+UoF1/g4V5RCNGmwzxqgzrBawTpckuMFkP+VrvsaaV7oTB7exsqJ2QXAzR7xzP6C1A+fnAwAHQ++CMaex8rWWb/HrTMTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LrDPKMVIsusxztPgCpb23x63uX0ihT59Q0QLuOEqwE=;
 b=gcBuxBSZIto2QJBk+PZHjeWsRHPVHmQT4IB4eg66XZy132RNSdQQXgExLWCZUW6xQj6eY45viTtkBZgWxWlnOs2kMYqnpDCOb2mfcVjC/9f9aHMhWVjEIvQX9TeTF87BtRvPq1Bymrw4uMJqQYR/83PeHpzsCD0mVxUeNA41kFIY6v7FVef3JuVenEKYcuKjXm6DAB1Htx3BjnRL9M8Mi2PICkSvshlzoWy1IuE9eRS/o/39xFhaQRoHfGQl6QhsypLIwql1jazthLl01qmNYaWtakoFaSM7q4QAxnERZULAa85nGszTQBCnb8bgJPhFwjgs5CkwDIhA9MHKN5rnAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LrDPKMVIsusxztPgCpb23x63uX0ihT59Q0QLuOEqwE=;
 b=Gk4MtPNKxVi8PjeGr3++4qjX0h5dRojwKE/U+yLxjuq7D/D3eYNAHjbCi1iwGtt9ZWRxEHvK0z3cSSePAOIoLEt5R/cZW90d7RBw4XNUjGnNYO1E0ErSdZWwrSrrHrjEuNDKhD6WT/lYcS83FmEqPaj/u67uHHrh2J9OfIUEM16xoFjcFG9+NaoZmT1O5dt/Ce0PvDQtf2H4bpjYgI31Yclk4Rh5kTtm0ZMVNgI/HQueB6QIvt0xlDR9tZxQtuJUTknRKdkbR1laYcO+0wAVcgQxGBP1ek8aXsBqIKLdQaE0foQs/RFFIRNHmFNf9QA4yQ4yoOnPodFDaBBiZAibSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB4709.namprd12.prod.outlook.com (2603:10b6:a03:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Mon, 2 May
 2022 17:31:38 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 17:31:38 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: [PATCH v3 2/7] vfio/ccw: Remove mdev from struct channel_program
Date:   Mon,  2 May 2022 14:31:32 -0300
Message-Id: <2-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0059.namprd02.prod.outlook.com
 (2603:10b6:207:3d::36) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d02ac7c5-2485-4335-1598-08da2c619cc3
X-MS-TrafficTypeDiagnostic: BYAPR12MB4709:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB470910545CC66612663957C1C2C19@BYAPR12MB4709.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lG6lG3RgK5FMbaRCwnPhSNRX4vXEgV+6HEU3e5XZa7GlFmMNYAfiSeFfLd98g5pd8X3ib00FZ+E2QGJOxY2HJB8noMcPZE58Z7hkbEl8vUlq/OVg2o13BMn8kWOiNnG5mGjYvYI0y+35wiWOgMxbUBYXIRKFs7jImqvBDDeWxhh9cvicU5yEuowUPSsF5+D8RKvSM8Qt/EIv2OBjCTeWrIGfTC9M0D3TY8zjsrXWjZPKQk/I0vWyHFr52E46a/BlDAB4jb56GELxPayWtYHm9GhAIbT+DNrX/Py/oF8g5cBgE/GwXoCDulHYPIccwNqzqaAv7k0nnSUlC3bquDpEyiSD90sRNvTAljiSOtXzMNnIeE3CCSUQYbOYzracev7dIuvwkIbyrc3B7ZWcjUL1y8FlmpUFNOm/+dmHKvRJrH3ftbP5PXaSlgmmxNWxb3qGVADpvXjCTlSL6tdFY/zY6C6iyBXSFuAZVtMpkDHe1+vidyFqePpeAbpxW8RAHSZoV3IlQsbBpT63Iq6w5KEVfK2gT2adNiUD/jvLFeqfoPiE8m6Rbgu3OEEzJkTmEt+yWMLJ518+JJIr8YrTp8bAtRLrY/r9QETiOwd7KsIjr4Kr/lGgly32bAuc2G6efNN/ANEJx1qasm2tG1CTP3MMTQuep96b3Vo8jv0cYrOW8y0nzEScrDm/ExctRoeFT1PYA9cnAfh4bQjGyKltbvANQJSqwzpUDTFXX73XqJWA/X4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66946007)(66556008)(66476007)(8936002)(8676002)(4326008)(316002)(6666004)(38100700002)(86362001)(6486002)(36756003)(2906002)(6506007)(2616005)(186003)(54906003)(83380400001)(508600001)(6512007)(109986005)(26005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4iIdHHx5im+RJFa6Id6DxnafPwgJcPvlfY1YPaviu5VFnkD1ssu845XxAmZS?=
 =?us-ascii?Q?x2SyxJv3Nby81r1x2UNMEbcmP/G0xIp5sFswLHtU3JAi3TYkKsH1NCztJ4jO?=
 =?us-ascii?Q?iae12rs7JrJL5v4QXFRY+Tb3V/jLAFm1x6NPKvytGQbFtOwmz/s4YC0vCInm?=
 =?us-ascii?Q?os2GZX7wv2dAywEjy0Qic5vkVkWYfet/HVZgKte9R+vWjcvWrEG7sawQMt/+?=
 =?us-ascii?Q?+kda/09gd1M2SWQtGa2ePuWrTr3SEO8McP58WGEmkpaq6npu4kXYCY0PxRlN?=
 =?us-ascii?Q?n3PB2UUHpI9ELXTMUO8DUYIWRzVvl2EFserWZkKC7IwDYeXWovpmS4vOFhsP?=
 =?us-ascii?Q?CQu101ZgC2hNbZj3gnHof9fI0SiO2vsiY8Y6dJw/O6kxro0bXJWYzmMQl9I8?=
 =?us-ascii?Q?geJ8oZiE1RiWy8Dm2xlQiEaqu6zCCnI+out3VDgKXLm1GrtUA1blz0MGQxJS?=
 =?us-ascii?Q?6ceBrCv8cu1DZ7uCSzN2yQVAdFXacQt0r+kqe2Fk6ZH/kuuH4d8fTZ5cfMlk?=
 =?us-ascii?Q?0VPPzM4hReu1uCQpRzArb+KxiPcXt8BUeFeBv7LzjFhSME8zmCIu/+97MbDg?=
 =?us-ascii?Q?UhnnP1wLRLmlioCeM3dKUcbj80vSZZOa4+WqyO+LmPT0Ybcl6BAlR9YR6+5w?=
 =?us-ascii?Q?FioFmAR6lfQIfg9+pN4Ui6Y1zRwPk004zQkwHVvB27gnTSN80A+ETV8hWAYy?=
 =?us-ascii?Q?4hBhxyiBGDOCWWrYpbJJ6ETVlHisLYXT1f4QPsVQQ4ISo/wxoly3WxHQJ5Eg?=
 =?us-ascii?Q?zfnidEC/+XVRgkfkAh3Zyo1UpPa8XaBMxbAzrmXMdwTYvP7X8y0hFZbRwQBn?=
 =?us-ascii?Q?hki1CHV4z0Kc3lDitRxZQyDgWY+HgReoL+qjsV7VY78xdckLVjS0d2/42QiW?=
 =?us-ascii?Q?MSHq/m51WpenONhOY79Nwh6UwPt/Y1x0vg73qlaMtzrhVMMYen3JP17S5YVZ?=
 =?us-ascii?Q?yeXCB7qrsLWO12agwUd74uI8c4vhWZDxnamnSuCLri2yXdzptC6MyWZMjNjw?=
 =?us-ascii?Q?7CnekiCGkzXLC44DA3dt6wHCU94eEiM/skv+yOpnbVujJpeAYOoQUuBz9812?=
 =?us-ascii?Q?RPi5aAbBLEFq4l8dOGsZFtH8c72RDQbEfGEGo8MEku1bUQOi7irDsDEyBenJ?=
 =?us-ascii?Q?M/1bmBICytr4fs7Zo8JJnZW+TsiMCfILLtAaBLVbAz3DaFUaoxqk0E21XWwh?=
 =?us-ascii?Q?NabBWco8CyuaiGrdPdDaNXuk2Oy3Hc5o2XXb/E+wUpeMapzjc7+wCgkp5doD?=
 =?us-ascii?Q?UA39hu8s/VyQRWprzzcmcTDuGTHLgRGJs0ul6khgBBwlHf0ZBQwSnrFvrsVg?=
 =?us-ascii?Q?tIeBqgIUZNAz+yeZ47/WMcE4Xw0qJYh/53lXrmr94vA5TfzCahTwgHJnbYtP?=
 =?us-ascii?Q?R10nVLtAjUKieFqFnNQxTwZuoSnz4sQOLfhu67aGotFTXnx3+zD162LBr9HF?=
 =?us-ascii?Q?NuJIX5v5UbpVqLPyUju3pATwIoK/VMXkC8hHilwJBvLAiLWOa7OyVan/n4FP?=
 =?us-ascii?Q?lfakJQR6PIkZKNriVGL2Ji1fOQYQ91f5Q4V5kk2xZ53G2ZsdZoEg/G3M5aha?=
 =?us-ascii?Q?zIITepe27KTGTNeZazhA43vRnG5KVsVT8oxc+Ics29FFkeYg7b9G5vYQFEL5?=
 =?us-ascii?Q?1KaTb6L5rZBKrmOs2+gsdy6pxLpDmW/vCzBMMWt9annfl2Ow2LnEKHbfFjcL?=
 =?us-ascii?Q?7BmIBs5I6fa9nd1Yh0eZJQMEwjZ87khCPvwK2mGwKWjN0O5+6lYAsID9LiZi?=
 =?us-ascii?Q?wI3uoQN4JA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02ac7c5-2485-4335-1598-08da2c619cc3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 17:31:38.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hxZRfP8T+nvrTroFQ8eZiJePiMGaN6GHXxXjqICgvdVs1HXoU8Fi+kKSwEAmA0cq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4709
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch wants the vfio_device instead. There is no reason to store
a pointer here since we can container_of back to the vfio_device.

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_cp.c  | 47 ++++++++++++++++++++-------------
 drivers/s390/cio/vfio_ccw_cp.h  |  4 +--
 drivers/s390/cio/vfio_ccw_fsm.c |  3 +--
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 8d1b2771c1aa02..7a1cf3091cd647 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -16,6 +16,7 @@
 #include <asm/idals.h>
 
 #include "vfio_ccw_cp.h"
+#include "vfio_ccw_private.h"
 
 struct pfn_array {
 	/* Starting guest physical I/O address. */
@@ -98,17 +99,17 @@ static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
  * If the pin request partially succeeds, or fails completely,
  * all pages are left unpinned and a negative error value is returned.
  */
-static int pfn_array_pin(struct pfn_array *pa, struct device *mdev)
+static int pfn_array_pin(struct pfn_array *pa, struct vfio_device *vdev)
 {
 	int ret = 0;
 
-	ret = vfio_pin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr,
+	ret = vfio_pin_pages(vdev->dev, pa->pa_iova_pfn, pa->pa_nr,
 			     IOMMU_READ | IOMMU_WRITE, pa->pa_pfn);
 
 	if (ret < 0) {
 		goto err_out;
 	} else if (ret > 0 && ret != pa->pa_nr) {
-		vfio_unpin_pages(mdev, pa->pa_iova_pfn, ret);
+		vfio_unpin_pages(vdev->dev, pa->pa_iova_pfn, ret);
 		ret = -EINVAL;
 		goto err_out;
 	}
@@ -122,11 +123,11 @@ static int pfn_array_pin(struct pfn_array *pa, struct device *mdev)
 }
 
 /* Unpin the pages before releasing the memory. */
-static void pfn_array_unpin_free(struct pfn_array *pa, struct device *mdev)
+static void pfn_array_unpin_free(struct pfn_array *pa, struct vfio_device *vdev)
 {
 	/* Only unpin if any pages were pinned to begin with */
 	if (pa->pa_nr)
-		vfio_unpin_pages(mdev, pa->pa_iova_pfn, pa->pa_nr);
+		vfio_unpin_pages(vdev->dev, pa->pa_iova_pfn, pa->pa_nr);
 	pa->pa_nr = 0;
 	kfree(pa->pa_iova_pfn);
 }
@@ -190,8 +191,7 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
  * Within the domain (@mdev), copy @n bytes from a guest physical
  * address (@iova) to a host physical address (@to).
  */
-static long copy_from_iova(struct device *mdev,
-			   void *to, u64 iova,
+static long copy_from_iova(struct vfio_device *vdev, void *to, u64 iova,
 			   unsigned long n)
 {
 	struct pfn_array pa = {0};
@@ -203,9 +203,9 @@ static long copy_from_iova(struct device *mdev,
 	if (ret < 0)
 		return ret;
 
-	ret = pfn_array_pin(&pa, mdev);
+	ret = pfn_array_pin(&pa, vdev);
 	if (ret < 0) {
-		pfn_array_unpin_free(&pa, mdev);
+		pfn_array_unpin_free(&pa, vdev);
 		return ret;
 	}
 
@@ -226,7 +226,7 @@ static long copy_from_iova(struct device *mdev,
 			break;
 	}
 
-	pfn_array_unpin_free(&pa, mdev);
+	pfn_array_unpin_free(&pa, vdev);
 
 	return l;
 }
@@ -423,11 +423,13 @@ static int ccwchain_loop_tic(struct ccwchain *chain,
 
 static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 {
+	struct vfio_device *vdev =
+		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	struct ccwchain *chain;
 	int len, ret;
 
 	/* Copy 2K (the most we support today) of possible CCWs */
-	len = copy_from_iova(cp->mdev, cp->guest_cp, cda,
+	len = copy_from_iova(vdev, cp->guest_cp, cda,
 			     CCWCHAIN_LEN_MAX * sizeof(struct ccw1));
 	if (len)
 		return len;
@@ -508,6 +510,8 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 				 int idx,
 				 struct channel_program *cp)
 {
+	struct vfio_device *vdev =
+		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	struct ccw1 *ccw;
 	struct pfn_array *pa;
 	u64 iova;
@@ -526,7 +530,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ccw_is_idal(ccw)) {
 		/* Read first IDAW to see if it's 4K-aligned or not. */
 		/* All subsequent IDAws will be 4K-aligned. */
-		ret = copy_from_iova(cp->mdev, &iova, ccw->cda, sizeof(iova));
+		ret = copy_from_iova(vdev, &iova, ccw->cda, sizeof(iova));
 		if (ret)
 			return ret;
 	} else {
@@ -555,7 +559,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 
 	if (ccw_is_idal(ccw)) {
 		/* Copy guest IDAL into host IDAL */
-		ret = copy_from_iova(cp->mdev, idaws, ccw->cda, idal_len);
+		ret = copy_from_iova(vdev, idaws, ccw->cda, idal_len);
 		if (ret)
 			goto out_unpin;
 
@@ -574,7 +578,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	}
 
 	if (ccw_does_data_transfer(ccw)) {
-		ret = pfn_array_pin(pa, cp->mdev);
+		ret = pfn_array_pin(pa, vdev);
 		if (ret < 0)
 			goto out_unpin;
 	} else {
@@ -590,7 +594,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	return 0;
 
 out_unpin:
-	pfn_array_unpin_free(pa, cp->mdev);
+	pfn_array_unpin_free(pa, vdev);
 out_free_idaws:
 	kfree(idaws);
 out_init:
@@ -632,8 +636,10 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
  * Returns:
  *   %0 on success and a negative error value on failure.
  */
-int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
+int cp_init(struct channel_program *cp, union orb *orb)
 {
+	struct vfio_device *vdev =
+		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	/* custom ratelimit used to avoid flood during guest IPL */
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
@@ -650,11 +656,12 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	 * the problem if something does break.
 	 */
 	if (!orb->cmd.pfch && __ratelimit(&ratelimit_state))
-		dev_warn(mdev, "Prefetching channel program even though prefetch not specified in ORB");
+		dev_warn(
+			vdev->dev,
+			"Prefetching channel program even though prefetch not specified in ORB");
 
 	INIT_LIST_HEAD(&cp->ccwchain_list);
 	memcpy(&cp->orb, orb, sizeof(*orb));
-	cp->mdev = mdev;
 
 	/* Build a ccwchain for the first CCW segment */
 	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
@@ -682,6 +689,8 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
  */
 void cp_free(struct channel_program *cp)
 {
+	struct vfio_device *vdev =
+		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	struct ccwchain *chain, *temp;
 	int i;
 
@@ -691,7 +700,7 @@ void cp_free(struct channel_program *cp)
 	cp->initialized = false;
 	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++) {
-			pfn_array_unpin_free(chain->ch_pa + i, cp->mdev);
+			pfn_array_unpin_free(chain->ch_pa + i, vdev);
 			ccwchain_cda_free(chain, i);
 		}
 		ccwchain_free(chain);
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index ba31240ce96594..e4c436199b4cda 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -37,13 +37,11 @@
 struct channel_program {
 	struct list_head ccwchain_list;
 	union orb orb;
-	struct device *mdev;
 	bool initialized;
 	struct ccw1 *guest_cp;
 };
 
-extern int cp_init(struct channel_program *cp, struct device *mdev,
-		   union orb *orb);
+extern int cp_init(struct channel_program *cp, union orb *orb);
 extern void cp_free(struct channel_program *cp);
 extern int cp_prefetch(struct channel_program *cp);
 extern union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
index e435a9cd92dacf..8483a266051c21 100644
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -262,8 +262,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
 			errstr = "transport mode";
 			goto err_out;
 		}
-		io_region->ret_code = cp_init(&private->cp, mdev_dev(mdev),
-					      orb);
+		io_region->ret_code = cp_init(&private->cp, orb);
 		if (io_region->ret_code) {
 			VFIO_CCW_MSG_EVENT(2,
 					   "%pUl (%x.%x.%04x): cp_init=%d\n",
-- 
2.36.0

