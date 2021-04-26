Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AC036BA82
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241834AbhDZUB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:26 -0400
Received: from mail-bn8nam08on2048.outbound.protection.outlook.com ([40.107.100.48]:25530
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241806AbhDZUBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=br/akAnN08mBcciuBq08EnCp7LbS3pOVlQBz6Y2uEZsEmau95HzsxMryuXFE4BkMG7GXR0d8TFsk+x+7Cp5eXlGNbcmzS45Xvkhvsj2qP+KDZraSWh8GG1Mqn+TzmTW0XLWemyYSkhfmJRvlCDwB+X9I1BJRKSfH2hX65Vt4r+fHQitZzpCT7iHyY3u06iaqSx5bLOC16ZyyTASRGMk1XINOShAnKJDFt/VoSPEjqxlRnI9H1+FTSDHlhfE9fVeLYqoUjMzmEmb+XgoLF81LdD5zrJ0DN4D7I1wlsw/9kCP4aK5iKIqhB7/vOn4owCpVLiFlLtliEWY1ic9/n91D2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NiwbjTB/rf9sR4ZC2VUsBPwx5YVyjuS3PbGxjNeKkA=;
 b=jJjEwe+pIWWtqZOU/gt86Rua9enyHLDKqsK3ClTdmjdPkugwUL/MwacevlHlQN3y+doYuei2bohCmjK/XqurCMIwVpnwG4M82fvttqKFvxp8jXcTJ6sBIbo0RJ2JaONu1IcumNaWf3PQ7TW5TJZixT4dhePeUo1LkXebEC+ZNONfLYGvApkWsCvz5xYZ8A7+Bb3l4V62MGLsHsqNvZNUOanMgak3UqJi3/4SjPSiJZUqDw4ssXHLVn+WADtITZAmJz7gEBBeQJZ3oQOWPdFulDjWZ8sJ6eme5HTfQBnxUqF2LX4VfPuoFiWU1yPLuuljVAbfHSCOm/1iQW5dsLodYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NiwbjTB/rf9sR4ZC2VUsBPwx5YVyjuS3PbGxjNeKkA=;
 b=O+YgTjJm2Hq067ehDrZVosiKUyrIt7SnZ5WgxUgX0C9kA+ZNZ4yBzSWjM4LwNHqX85GmM1QQ/SAFYzUKNDKSk+BwZ8zlhWaMM8j3KlUqmZprenX01THkA2h5CGCfS5wtUb86Q6i8aGevvPICcckKxEUafpTVGp7joaX7xFASt4drIb3/qi1Bv27umpyeFFWxSYv+CNWfpJ5z1/B5TIqvcLF462hmWGVMLSiDLlMiuBOIfwuz4E837VGmUPA3MlcR00R63HAmYnNOG536yIFrlGneIAjPTWglMjT/10hD91cKwUTJSC8YtWevi2dF1srG6ms6Tt+n6gYkfNMWEBy2Cg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
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
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 03/13] vfio/mtty: Convert to use vfio_register_group_dev()
Date:   Mon, 26 Apr 2021 17:00:05 -0300
Message-Id: <3-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:207:3d::46) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0069.namprd02.prod.outlook.com (2603:10b6:207:3d::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Mon, 26 Apr 2021 20:00:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Ox-00DFZ8-Q3; Mon, 26 Apr 2021 17:00:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95c925d0-30e0-4b6c-e628-08d908edeb5e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3740510113A17D750810DDC6C2429@DM6PR12MB3740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRyEEMxGVJ3ZVxXz7XNUEsDZPHkdXTR6Ulb3nUNakawSqq0A7ExRLYLVtFoyWVM7yYhth6KiCPs3TYB1XmqqGEDiaQCpFq6HpqW5jyirs3GvRxQXgR1TxRM/teLroi9mzc8LA3EanFL7+D/9WgvKusgeI7kLOrBhjCuWPIVZJxjVWgyDVBSb0JUgMGP1rbsXCW3kDqpldhsRJi1Oj/XS7g2FBns6NjASYFI/WYnyuiDjxAWUcp8TWaSBtXG4a/s1bBYBwiW+ZqQHlMzATzWJszOhr2po1Gnnnf0dtCbveZlXRBU1MNkjaFUywvE9ywqkOQrGiZx8LPuICLQ8W9G5LcWWSlPjzYA9w7k/eS0NvtXYH9iQ10hksFVNewFOUm0p4Ix274M6x5hFHURuNLrUSXdGHVesNRNjZ/IFnsgFSqeO8a8M5LGmpyeOzzUE0vMlBxWJIWziP+59QSUV0NqvQitPI5k6csvw2M+YZ8ksck38QNo4VPWFZDBWwFbE7yM90RF2wx0/WpVkCdTg5x1gkLYYrc+6+dhrpiol1e0nOsix8wHkZcSII4FdhJW/ulWKpAmwZZa1v274RE8QDOMcUJYMmHXwHJZLKvguZxcltGvdw9FhKwiEmjmWieWK4sdySbdFI8GOlrz5Lq0u2ZlR0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(66476007)(66556008)(9746002)(6862004)(54906003)(426003)(37006003)(107886003)(186003)(26005)(6666004)(36756003)(316002)(2906002)(30864003)(2616005)(478600001)(6636002)(9786002)(8936002)(83380400001)(38100700002)(86362001)(8676002)(5660300002)(4326008)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0xu5M6nVAjs8EZWutocx66ywZKhAEJhrkT8Nxw9JT23UNRqFUGvbjvPhjFkb?=
 =?us-ascii?Q?EUppU1dcFj3675Lzko66pVKnejtg+0MVeBpO3sLsI5/oNiXDWIoHjf45EOm1?=
 =?us-ascii?Q?BI4M9gWqlcOCw0psgHkiLUeAyysOxIKw4l4CrnnQ+E/hNJM0oVfJAtemek36?=
 =?us-ascii?Q?HPu1kxO1b9SBoGd2ZgrDNhgmK3ssHJUOkV1ZP5zj0dlfZide5RCIuQmRT2IJ?=
 =?us-ascii?Q?v54ns042XWToAQAhOXLlYx6Tu9SiFwxuGgujjdw8SFOshIEvNJ+LK4n1mXjB?=
 =?us-ascii?Q?jn+ik/6zI7XYEDOReZ94j+nC0f8C2kzB2Qc69tn2eXdxR3ezOCUDs4bkWIHz?=
 =?us-ascii?Q?pn8FzzHzbVDzCpUDK0dTXCRYvMUDw8YI5xL0iTeLkUhcaRL9KpmDW5GA+GIs?=
 =?us-ascii?Q?OTsFoj7Wm4YVbii9PnBcPU8aBvisWmjI9oBvC0j2o2kLfBbIRX6by3OrmUR7?=
 =?us-ascii?Q?h1B1EtO8McXh2Md+6ICnKhZifUcE0pUH3752F6Os3HLTT09Upj2wD4gqw03Q?=
 =?us-ascii?Q?/WM5LcUmEwPlMFmvju2oXxv09xoWAILKkaFGIrvqkmUzt2VTfOCrXUnn5Omw?=
 =?us-ascii?Q?B7LID2cchjG8B10+qpIZ63+lzybitWpNKKU0FK2bdcWTxCY2w9Kju6FiXNB1?=
 =?us-ascii?Q?BX/PQE5dTRIHX8u1IPbXva43n/r2apRof64ClScYEpZRFv6tLp8ZypiHUIQd?=
 =?us-ascii?Q?Wndj3KfHqcr71FM0hdrmjKJMzQaLT5Lc2Bqn1LPoeSMOU1loFxdYlklAoGJP?=
 =?us-ascii?Q?GdcU3B5r9cVgbfZlcax6BGL2fU2q07448Pcw0TWCnzlWix+9aI7BKn5v0Cbf?=
 =?us-ascii?Q?EsIiqp2QYjCc9BzvzuPwDqkHZi5YI+HJOjbLqcxaaGlApFabtf+/oiAI3OS3?=
 =?us-ascii?Q?ZDAApg4G7SPeSFd+5HEh1NelWMn97brbeZMEtP7RHChSNf1tmLd5p3AeIbBD?=
 =?us-ascii?Q?AHahmsUMl8l0JQmxwu5IQGKHIQ7TG7BQTOHMKphoEb9QyJ5Jfy0mLm0ZxZr2?=
 =?us-ascii?Q?bLZLRgy2rY0d9XFLFm1OUmFeL4zgcwHfFiKlqRIhPq/NoBvwXYB8R6UIsgq7?=
 =?us-ascii?Q?eONz00/ECNe9cZHw9LTwBuK/DBHBfCXoGufuYAL/MdAxeBgzxWFKFSRlO4Tr?=
 =?us-ascii?Q?MqdU9pV7A6XXTRZf8Mz0Y6Tiw073autle0X7L5ywWHwrnHLuyF2Uv7k+JvAg?=
 =?us-ascii?Q?Iy5FraWiHtgW+aSeQdasUBxai9uiBR+Um+UAIT+ZiyxD3DAKk+DkR9MRrODT?=
 =?us-ascii?Q?G1iNz4s2hiiS7X94sgiuhAUz3KVOfUSORI5Dx4quwByBbBMBdW3YO023fHbP?=
 =?us-ascii?Q?se818RYBiqaOKnFttAZFKz54?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c925d0-30e0-4b6c-e628-08d908edeb5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:20.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66p/zIlBk3jOJaCtHiNr+MvwZoKyscCrFu1D4tjaVE1c0IzY09ucPUCt3gYeIt9X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3740
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mtty.c | 185 ++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 102 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index b9b24be4abdab7..d2a168420b775d 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -127,6 +127,7 @@ struct serial_port {
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	int irq_fd;
 	struct eventfd_ctx *intx_evtfd;
 	struct eventfd_ctx *msi_evtfd;
@@ -150,6 +151,8 @@ static const struct file_operations vd_fops = {
 	.owner          = THIS_MODULE,
 };
 
+static const struct vfio_device_ops mtty_dev_ops;
+
 /* function prototypes */
 
 static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
@@ -631,22 +634,15 @@ static void mdev_read_base(struct mdev_state *mdev_state)
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
+static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
 			   loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state;
 	unsigned int index;
 	loff_t offset;
 	int ret = 0;
 
-	if (!mdev || !buf)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state) {
-		pr_err("%s mdev_state not found\n", __func__);
+	if (!buf)
 		return -EINVAL;
-	}
 
 	mutex_lock(&mdev_state->ops_lock);
 
@@ -708,15 +704,18 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 	return ret;
 }
 
-static int mtty_create(struct mdev_device *mdev)
+static int mtty_probe(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
 	int nr_ports = mdev_get_type_group_id(mdev) + 1;
+	int ret;
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
 
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
+
 	mdev_state->nr_ports = nr_ports;
 	mdev_state->irq_index = -1;
 	mdev_state->s[0].max_fifo_size = MAX_FIFO_SIZE;
@@ -731,7 +730,6 @@ static int mtty_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
 
 	mtty_create_config_space(mdev_state);
 
@@ -739,50 +737,40 @@ static int mtty_create(struct mdev_device *mdev)
 	list_add(&mdev_state->next, &mdev_devices_list);
 	mutex_unlock(&mdev_list_lock);
 
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret) {
+		kfree(mdev_state);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
 
-static int mtty_remove(struct mdev_device *mdev)
+static void mtty_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mds, *tmp_mds;
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	int ret = -EINVAL;
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	mutex_lock(&mdev_list_lock);
-	list_for_each_entry_safe(mds, tmp_mds, &mdev_devices_list, next) {
-		if (mdev_state == mds) {
-			list_del(&mdev_state->next);
-			mdev_set_drvdata(mdev, NULL);
-			kfree(mdev_state->vconfig);
-			kfree(mdev_state);
-			ret = 0;
-			break;
-		}
-	}
+	list_del(&mdev_state->next);
 	mutex_unlock(&mdev_list_lock);
 
-	return ret;
+	kfree(mdev_state->vconfig);
+	kfree(mdev_state);
 }
 
-static int mtty_reset(struct mdev_device *mdev)
+static int mtty_reset(struct mdev_state *mdev_stte)
 {
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	pr_info("%s: called\n", __func__);
 
 	return 0;
 }
 
-static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mtty_read(struct vfio_device *vdev, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -792,7 +780,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret =  mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -804,7 +792,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -816,7 +804,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -839,9 +827,11 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mtty_write(struct vfio_device *vdev, const char __user *buf,
 		   size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -854,7 +844,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -866,7 +856,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -878,7 +868,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -896,19 +886,11 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 	return -EFAULT;
 }
 
-static int mtty_set_irqs(struct mdev_device *mdev, uint32_t flags,
+static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 			 unsigned int index, unsigned int start,
 			 unsigned int count, void *data)
 {
 	int ret = 0;
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
 
 	mutex_lock(&mdev_state->ops_lock);
 	switch (index) {
@@ -1024,21 +1006,13 @@ static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
 	return ret;
 }
 
-static int mtty_get_region_info(struct mdev_device *mdev,
+static int mtty_get_region_info(struct mdev_state *mdev_state,
 			 struct vfio_region_info *region_info,
 			 u16 *cap_type_id, void **cap_type)
 {
 	unsigned int size = 0;
-	struct mdev_state *mdev_state;
 	u32 bar_index;
 
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	bar_index = region_info->index;
 	if (bar_index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
@@ -1073,8 +1047,7 @@ static int mtty_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mtty_get_irq_info(struct mdev_device *mdev,
-			     struct vfio_irq_info *irq_info)
+static int mtty_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	switch (irq_info->index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
@@ -1098,8 +1071,7 @@ static int mtty_get_irq_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mtty_get_device_info(struct mdev_device *mdev,
-			 struct vfio_device_info *dev_info)
+static int mtty_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
@@ -1108,19 +1080,13 @@ static int mtty_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mtty_ioctl(struct vfio_device *vdev, unsigned int cmd,
 			unsigned long arg)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	int ret = 0;
 	unsigned long minsz;
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -ENODEV;
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
@@ -1135,7 +1101,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mtty_get_device_info(mdev, &info);
+		ret = mtty_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -1160,7 +1126,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mtty_get_region_info(mdev, &info, &cap_type_id,
+		ret = mtty_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -1184,7 +1150,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mtty_get_irq_info(mdev, &info);
+		ret = mtty_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -1218,25 +1184,25 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 				return PTR_ERR(data);
 		}
 
-		ret = mtty_set_irqs(mdev, hdr.flags, hdr.index, hdr.start,
+		ret = mtty_set_irqs(mdev_state, hdr.flags, hdr.index, hdr.start,
 				    hdr.count, data);
 
 		kfree(ptr);
 		return ret;
 	}
 	case VFIO_DEVICE_RESET:
-		return mtty_reset(mdev);
+		return mtty_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mtty_open(struct mdev_device *mdev)
+static int mtty_open(struct vfio_device *vdev)
 {
 	pr_info("%s\n", __func__);
 	return 0;
 }
 
-static void mtty_close(struct mdev_device *mdev)
+static void mtty_close(struct vfio_device *mdev)
 {
 	pr_info("%s\n", __func__);
 }
@@ -1351,18 +1317,31 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mtty_dev_ops = {
+	.name = "vfio-mdev",
+	.open = mtty_open,
+	.release = mtty_close,
+	.read = mtty_read,
+	.write = mtty_write,
+	.ioctl = mtty_ioctl,
+};
+
+static struct mdev_driver mtty_driver = {
+	.driver = {
+		.name = "mtty",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mtty_probe,
+	.remove	= mtty_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
+	.device_driver		= &mtty_driver,
 	.dev_attr_groups        = mtty_dev_groups,
-	.mdev_attr_groups       = mdev_dev_groups,
 	.supported_type_groups  = mdev_type_groups,
-	.create                 = mtty_create,
-	.remove			= mtty_remove,
-	.open                   = mtty_open,
-	.release                = mtty_close,
-	.read                   = mtty_read,
-	.write                  = mtty_write,
-	.ioctl		        = mtty_ioctl,
 };
 
 static void mtty_device_release(struct device *dev)
@@ -1393,12 +1372,16 @@ static int __init mtty_dev_init(void)
 
 	pr_info("major_number:%d\n", MAJOR(mtty_dev.vd_devt));
 
+	ret = mdev_register_driver(&mtty_driver);
+	if (ret)
+		goto err_cdev;
+
 	mtty_dev.vd_class = class_create(THIS_MODULE, MTTY_CLASS_NAME);
 
 	if (IS_ERR(mtty_dev.vd_class)) {
 		pr_err("Error: failed to register mtty_dev class\n");
 		ret = PTR_ERR(mtty_dev.vd_class);
-		goto failed1;
+		goto err_driver;
 	}
 
 	mtty_dev.dev.class = mtty_dev.vd_class;
@@ -1407,28 +1390,25 @@ static int __init mtty_dev_init(void)
 
 	ret = device_register(&mtty_dev.dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mtty_dev.dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	mutex_init(&mdev_list_lock);
 	INIT_LIST_HEAD(&mdev_devices_list);
+	return 0;
 
-	goto all_done;
-
-failed3:
-
+err_device:
 	device_unregister(&mtty_dev.dev);
-failed2:
+err_class:
 	class_destroy(mtty_dev.vd_class);
-
-failed1:
+err_driver:
+	mdev_unregister_driver(&mtty_driver);
+err_cdev:
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
-
-all_done:
 	return ret;
 }
 
@@ -1439,6 +1419,7 @@ static void __exit mtty_dev_exit(void)
 
 	device_unregister(&mtty_dev.dev);
 	idr_destroy(&mtty_dev.vd_idr);
+	mdev_unregister_driver(&mtty_driver);
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
 	class_destroy(mtty_dev.vd_class);
-- 
2.31.1

