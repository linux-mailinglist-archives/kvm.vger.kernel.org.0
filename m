Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE4E369D0E
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbhDWXER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:04:17 -0400
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:47680
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232283AbhDWXEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:04:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1xFeoCOGAZexfrgmtmaR9RF1qgAvzSNdG94S7gCKTTjO/MjDc8trLp1q/OQQQxAGVbSnvVruQl+GI0MFEqbzFX7cXz10igdxWjtpWLqwDfmxd2uvetmxg2ZHAfXbdsdsOWDluRnfjed7BpFoq8Tts6pNTYrNYDpKgcapJQHrhb+qAuHcf5vRojF5acbVjEEN6u1okfPuhTM3J54wh8W6Mehvj2wL/5AiBJqC+E4KSEpk2LN89O7iLDUipb2bk5yJLkSoLQwXDnsNuqa3nZlB/VRgwrlvndo4VNQyXyQQWFQRskRJx4Uu2SN2vr7a1oMc/m9+WQPIkX7lUYbUw8aUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7nyJfFxlwXIfTVwURbF6L5VguCs/1EVEL7N2Z+mXH4=;
 b=KIxW27fZxrRpuGvRxpwwFjsuavoDtTK8hygxhaxIjmV7AkjXlbZxVpZgFCACd8Y8OcbIhokdqYM4web5ketBC7xnw8I2K5foshDr19ALcATFCLMqsDZ9c9Jg/uKFvueRiAQJU5hsyowDJaLJ5TmXGlj5fs+xm0pSCdDTjVu3EbKV+fdFpIcGrt1byIagEv/QbNKMCggVt0ZtESyIx0o2JchaI+mjekhBYv1/feN3yf++VG5ak0O94s5qb0k5MpwM9l5RNMpZ/3I3tcv+A1N735nl6Etyvy63nJk+wXRE0JCBvveSYDfNm3Tp+KZYn7SY9gGkjHiZuZSm6IjUN27kuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7nyJfFxlwXIfTVwURbF6L5VguCs/1EVEL7N2Z+mXH4=;
 b=dZH40s04AV6fTYp+VAcIhxrhOFDNwS9im+ajm5fvXsf2SeLWq3p0kkPJ6OdxO+sPk6c9Yj9FtRSnFVsv2xhr3hSkfDZaSHCVvBrzhgd8318R13Fwmf2+kH8CvZi805eOVeyiwxYNNrbbknVVVNBDWCQ9Z0HQ+pivTP7Tx2eu++YXG8/jXS67cywQxliLWLi1fk6EK8dbnG7L9cOBotRCNZM8C8Ueil9WBXUcKoth1FBPEeozPqV8mG+sFGQtUvAfnbXwjgmyemOZNT2p0otu8hsWwk9Bj6pRpa+uAoisC1DxmQUuWGfK/2bXzDl9/Ri8h5WsABhpqQ1LKGD9qFUIhQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3513.namprd12.prod.outlook.com (2603:10b6:5:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Fri, 23 Apr
 2021 23:03:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:15 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 03/12] vfio/mtty: Convert to use vfio_register_group_dev()
Date:   Fri, 23 Apr 2021 20:03:00 -0300
Message-Id: <3-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:23a::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0016.namprd03.prod.outlook.com (2603:10b6:208:23a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 23:03:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CHzW-0c; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd4006c3-2ed3-41cc-292c-08d906abf841
X-MS-TrafficTypeDiagnostic: DM6PR12MB3513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3513C2F4E625F934F8D51787C2459@DM6PR12MB3513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fWe433sUWNti7CdF7COJcxwitUWOWjIK+02rm7bOaSBcMsBttSu6xzSqDPGhl8mPWCfq1LA6vlWqWtJpwbWO9+F1RjS0eWTmnothSK1n+/NpgLKqYh7sERSXS3CaoGDtSeixTlGt8IckOHljvmNRmjp8xsnnLhZ53gxESB+GApHY1ircUNc2i5OKBlzRtfpLyW/MfHogYXF8oXq8k/ifeO5WW6jpbkhfj4Ty2S2rOPfEsbhx16rmPmYFzKw/5PC4zwPMAohBExKDytm6P7Iq1ykYGsgGAKfgZinJ8fkVvNYioJrOeV2vH80Gi8mnMP84+KmkE50KeT33qH0uueT+tVP/Tmuc4QofXcEzeszWE16vdumbCd8qsmAQ/1lqvGh3gGg61P7UaZZk3t5ZBwy2z/4E7iYmoqQ48d4eZ+KKqLDbxxwX+LJnI721yd9yV2/QyqhvMVxU357v1EtMjK1l89bmQpEjYzt4bijWQgHiB/1jP+jlShoeVGe70YwbHR/PD4w6bwlacuQ62X/S3luxcEjPJideg8Do/5lsoEaOGn/x07lj0f+60PMjZrz+SepyBFR80TdXtGURGSQWl4edcRxYO7+4A3qtUw0j4RvOgltwuQN6uR165xLkz28NzqKR2txXK4ItHIxCEjMlewuwzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(36756003)(66556008)(26005)(66476007)(107886003)(426003)(8936002)(83380400001)(9786002)(5660300002)(186003)(86362001)(9746002)(54906003)(38100700002)(2616005)(316002)(8676002)(6636002)(2906002)(4326008)(37006003)(66946007)(6666004)(6862004)(30864003)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4qA3pnc5DWL4kWkm7IEnMuFdy4oQPPnTkHpLiHtMds09oAIEsZDHilKL/iKD?=
 =?us-ascii?Q?zSfF6Eo291Tefn1mA/sxJFTEEC9nJmA3z+QwGwsDuXi1O53Kqm1wwDXBNAo3?=
 =?us-ascii?Q?joSAPGDSG/pBBiYk9jjRhGh4t1ggzRI/uJGjJ5obd4GdJCbwvOImbpP2Wdlg?=
 =?us-ascii?Q?zBUn8V5ZNjVyvcJlHaiB3XK+EUiA9QjcJm74B6liL5zw7WqTgU13/ynLdPLA?=
 =?us-ascii?Q?zZBJuNYP6P0ZNW/lwGXehSyBmisWQxsSoRFHXUu+Tmnu4v7JNhYfGOwjxmxy?=
 =?us-ascii?Q?LaA9L/KZaUe8B6vA+Q5v4m53ljG4nkR/+GEUGq9VMvFn1cltcVL92f/BiEw0?=
 =?us-ascii?Q?XKxT4H+Dm1S4BBjKUzDg78pcm6ejC+cY/aWWMyazyo4FdeMu9tdVQKUXOfW2?=
 =?us-ascii?Q?QlZcQ/fnOwdI2I8nVQ7b+vGnKJrpsb/53FjLK+CyxBMLTiBWayUXFTHlUw3/?=
 =?us-ascii?Q?DMcv/XCTakXictni8dvMAgOxo7NM0SZO7bF9QaRbEbiBg4RO7WKm0cHS3M4L?=
 =?us-ascii?Q?q2nZAx3nhXgELnr+oaGkRCbnVqqnKNZjV+IY35WQkSl1ZbD+yABY34r2pU9B?=
 =?us-ascii?Q?Q2NV/p8MAj+kHMs7Ur0r6vT7TZJ3Pu9flsKf+yKHEjrxs5P6rbHo5hJi+Cmn?=
 =?us-ascii?Q?FeeLWh1nmV5T52X+/9gbD8Soa20lp0pPauGm6M3uV51iqboCXnSq8EVq9h0X?=
 =?us-ascii?Q?JJnsmSR1OLaqspIap99/9xE3xFCKZFOtRTlSbo79+v/JDXSzmz5Hth/YNU38?=
 =?us-ascii?Q?x5h5apVAoYwSteVeIQoWsV1OWHMyDOOAM+UPGfXZ1qnifAKIyxQpQpCID/6q?=
 =?us-ascii?Q?GBsCAN+NXAGWiHwVZBvl3W+a8L8vhXpvwE5AyAN/g0dtXsxHClJHTLcyEnI4?=
 =?us-ascii?Q?js2FDtKrYzjo5ght7oH90XdaebaZIf5Vmk91oSDIQGQsg0yOtVStIFICAXcs?=
 =?us-ascii?Q?Z2B8HSeZkxTqhy1riBAgsxsDi4+NLmkOwEDnP3nDfL2sBDncSmpSkL5HOXxz?=
 =?us-ascii?Q?h2BcHAMFYU/Nz6VonAyjY5xgb6D1CwvLO+WvsjIMtGJouusqXi8WhPmgLyRx?=
 =?us-ascii?Q?uuqeis+L9cxfzF4sKW7SGE/5hqAVgx1KuW8bSrJz9VsDfBo1hSUzb5GWpCcs?=
 =?us-ascii?Q?ALv4GXwMmkthroBkYAEyalLaG1z5KwGE3imjv6mxX49eygHgWUsGslVH5PIG?=
 =?us-ascii?Q?tnIHrLFK/bV6I51t2DUlE+RzaU88Hhod7OF7tT/ZnsmUNtnd/gBSsWTlh/yw?=
 =?us-ascii?Q?DHWJ2+6P+pjLnbBZxzoyytWmkG+ODDogKPguoZSzYA9g2jCewja7LNAoFtFV?=
 =?us-ascii?Q?4yvy/i9XW1kEVNfIpgHwT5eh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4006c3-2ed3-41cc-292c-08d906abf841
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:12.6498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GO2cNe75z0W6nR6eNyiv8m68CyWlBckF82+ljgfjCugAz7w4oa5FLyAyYT9G90aN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of()

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

