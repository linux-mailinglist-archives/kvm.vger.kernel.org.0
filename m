Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D54A36BA80
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241840AbhDZUBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:23 -0400
Received: from mail-bn8nam08on2048.outbound.protection.outlook.com ([40.107.100.48]:25530
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241751AbhDZUBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9HhP0AyzDFQ3n41Ogtww5sS/I62ec8YbjutkrtztEdFE+6+M+p3jFZyEU/nbEgV1dSHyp3DcuOJsGq0mndpPu+fHVxr8Q8xphknR9dGKKT1mk19+kA2gOmydojv+CBFGUCeVvO1sxVwtzA4HjDuD/aqeXUKIs62IC6z3RMf+PCIuahRNV7qO386bRvev+G4JAyMY32mHgW8XBFg1nSzog+0QZzbmf18RxpPCvEejcv6jdUiaUi2BJiZsU7rBKeHJkkCH8ScN6GFK9G9TNC0RknCMMAbT7D4/s33bmR/ygYz/xAX3okYw9y8tm+bZ8WZNhMmFh121BwZXU+xW/I3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nc+DIr0N8cUIB4/Mq+dyr9kmNs+u6iPfXLV8Mx51HE=;
 b=fssOjO0aReJNs2AjZtAdz1PKzx/BqoEaeuqSwkzAok0/SvaostdrAro1tjcPFp3Dz1ZH0lPfFhvy3viijexXJiQQF8qr4vL4xTBJX+9MD92nkvAtHhXXMy3x80+wjd9VTP1kO8ioUGMNQLjE3Ra7QkZV/h1gQkoqy0Y91uZShS87Yz1QGdc3uypmOcgLQWn93WL9n4y9A4ct17xA3jSMUS0Sm3Gi2snpfEHkemWd3FzRFxUKDQGqajXOov6dSMV72WAyRtZq8tYfI/mBF54hVBeoO1iCH+CX1T57AUX0o+8mdp5b1LCuZ2aad+capdQ+XerwlY2p8b1kv0SVejgN8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nc+DIr0N8cUIB4/Mq+dyr9kmNs+u6iPfXLV8Mx51HE=;
 b=cH3RQhPNXIsYvDU/aNMNnEX8LBIosVxbgzxFnKdn/naHtDnaKj3pP65nYNkhUtXXw/vDMyvjx77II1QiRV8Zr3WpEYes1mFyktRtz0YW6tfPucUd3P789BJENphTdy5LpEW0DQX57s98Ngdw+rhew/nnCtNSTXicb3Vg8uIfwIf8N4M4DRrY6pvnq6pqbMuV9u8Y9J8+3hV3dt7Vjmn+PWjhPOJ9kNYLdYkOvKWRf7ktgNXGSenLxdjByeyOAJcO6HhWWzYn/lvEo45Vvs6GAwIhCcXkCUeuUB+TX415clLcg7hUQvrv+Mlru/ZZH2BiFXf1ecRrz1QE+OxcazB3Vg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3740.namprd12.prod.outlook.com (2603:10b6:5:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Mon, 26 Apr
 2021 20:00:22 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:22 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 04/13] vfio/mdpy: Convert to use vfio_register_group_dev()
Date:   Mon, 26 Apr 2021 17:00:06 -0300
Message-Id: <4-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:23a::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0025.namprd03.prod.outlook.com (2603:10b6:208:23a::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 20:00:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Ox-00DFZD-S3; Mon, 26 Apr 2021 17:00:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a2c3c47-85fd-47b5-88e8-08d908edeabf
X-MS-TrafficTypeDiagnostic: DM6PR12MB3740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB374064971D27A8970A759271C2429@DM6PR12MB3740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULHO86FevKUeEs7uP9i0dIaKqOFryUk7ccFMrSkBcR7jCkl7OuW58iWijVcM6nsqoI1Ak1My8hfS6DDw5y+jkpoCsruQy3UAAnQNDAemXgZoOI8OEppGdo9l1fh4q0j21kovRT25YOGZOSai8X8/cHGerBCV9JokMiuf+lql1DvZ3QkHRLkV81QanxzwggAfOribEOpXq2tI6LEgRf7J+XptpeSh+EKqLodOhjYsNxf+YmRlQ7pRVAD2oVrYgA2+qb24eEDhugQ7UkCQZ6snTqEzmapuCHlQC/I+HfR/K2rqJi8ngLZGw6SZpQ4CZr5zSi+ltb7iX9ID/7jgnqBdICuQWyArKRRC4YdA9o5hiKNZ9/KhhT8FE6vXmHa/ZU6wi7WAsITySNbn22K3aX/ODV7T+29ol4WvgYpH6V/DW3n9I5R6i3z3hhY5Y06B6CJWTaTWJXr+kL2GPeSjzUVgzBNuWnRTvHPuDlw7rTvyh+ZcR2rOFjCpDxUzidyhnuYcBQUDoiivGuL8AGT2G9OoI9w3KqbzltpdVwKNghu+Xs+tzl3C7A1PmtOEm8kbZJ+0RJArTrJb7ivOKUHxnebENKg7gmeQjmshffc/I1NBA3Vg4PPOIbSLPVxWyIeFeJkGxcyYtGPFe0jy+U4jDp6V7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(66476007)(66556008)(9746002)(6862004)(54906003)(426003)(37006003)(107886003)(186003)(26005)(6666004)(36756003)(316002)(2906002)(30864003)(2616005)(478600001)(6636002)(9786002)(8936002)(83380400001)(38100700002)(86362001)(8676002)(5660300002)(4326008)(66946007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?w1J18/waxHhWXQebzayaROO/gXFXQMbl0Szu+45weWSDj7rYWePZU80HKYNp?=
 =?us-ascii?Q?sAxuIUp8yzGZTHY6/bjiCHQqO1lHDeVNrwcvolihuOm9IzqLcNHOmXlDlwXK?=
 =?us-ascii?Q?5Ju/gM5UTn72xgG987WYKCOOhp1h7l2JJBFfPPpdSOZGKJMKkIuw3fLOBSMi?=
 =?us-ascii?Q?Hc/t2c4nEGwXYmkQ+viOGMi3nNTlcM5MjtvueZc/nro7QAcZ//dDKAcD7ZDQ?=
 =?us-ascii?Q?QpBcUvxgeC+7rMfR3Z7J9KHohLkfCLGlIT/CdKt5bUoHvfNGnscAJLuAB1fS?=
 =?us-ascii?Q?pZi+QrJzYV4vLKc+KcRLsyPZEcU7IlBOj1TYrQvWFRXGuQEr35eOHk6mplHh?=
 =?us-ascii?Q?xZhjwEKwMCDyNX50JnmjzPEnTeB4A2zUzB/ipFK/FDhgI4A3eiRM1X9snIRo?=
 =?us-ascii?Q?AUQEWE0Tb+MBUxCJcXqVeLsiShEk80ffaIujEGN59GqQK6GL3nrqQRpEcayT?=
 =?us-ascii?Q?7Wg320Kmje8Q0cBaoU3U/FrgJftiMZ9lVXNcFJ0Cshn1XPCmF6RV4ExbQ30m?=
 =?us-ascii?Q?r1j24hHU1qqyoy9KTNPZHeABxBOh5E+rN7wQ0CNTqj9rSyWmmcR1O6bb4QM3?=
 =?us-ascii?Q?0M+BipMa9428offPrMtgdHXk/I/xhAATu1S4ugyopAjiLwkFhCAGEK+ojVu8?=
 =?us-ascii?Q?Uap5W6xK5Q+kmX9sNn2kn5VjcmKJFXSn+WoNMbLlj9eHr7nC5recJ2iB6JTO?=
 =?us-ascii?Q?qvDV3pB9VUvhl99OTlO4N+/dskhv5IAxueLcD95a2RkDJrTbUcnivOs9796H?=
 =?us-ascii?Q?sm/WSwBUpHYh4seIiqdt+5opnQ7V2fa4ETtvAbod2Ji5TAk1cSIDi0hk/tq+?=
 =?us-ascii?Q?kYA1rJyBQuOhZRMHmgmISdeyBVFTi8DRoox+FQJIJX1O9jZR8J9OTQ82tOR6?=
 =?us-ascii?Q?vE6yIWdJSYokjb1jH5l0GKiCPQ+ny9U2mWlvGWzVVMeJRpv4JtfQvknRp+Qo?=
 =?us-ascii?Q?Ew3yPvHWW7rP0BwQ/yeDHvg9N5jNiLPEW1swOJTsxJuOOb5Dhz8YH7BegaTG?=
 =?us-ascii?Q?PZvBZwML0EXTXtPx/tpSPZ/wFv/SEPumpC0KNrsHlaWoGNfATOJ5g28EgzGb?=
 =?us-ascii?Q?DM8sLwqAclbpjqSw3Mj9JMjg4hoIRPtuumjWwn0PuWg5ZXG9mc8QrWf64sx/?=
 =?us-ascii?Q?iNVPkH63Hn2kZ8hqIfJCQhc996z8JX/eGq0bgJgrQ7KXEsyNJ0qnMQU7G2Kv?=
 =?us-ascii?Q?2AH55Po3EYWWc/N7WGYh+gkEyZCYEi5/5f652liaIC0PeMPSh7vTwZ9U9G9M?=
 =?us-ascii?Q?f2zhWvtcUs7U4O2qXwgkQhRFieBk95dUCDRLRL4bRCHtitbC14wqbsiVtjfP?=
 =?us-ascii?Q?wNtZxoNFH8MiY4NwDcAitTY5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2c3c47-85fd-47b5-88e8-08d908edeabf
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:19.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtBs+6spffBv9PMzeetoTqKHonP0hAqxO8Qy0Vqfznb/EISP7Gaks4Tb7dbF8vtH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3740
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mdpy.c | 159 ++++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 71 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 885b88ea20e234..82638de333330d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -85,9 +85,11 @@ static struct class	*mdpy_class;
 static struct cdev	mdpy_cdev;
 static struct device	mdpy_dev;
 static u32		mdpy_count;
+static const struct vfio_device_ops mdpy_dev_ops;
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	u8 *vconfig;
 	u32 bar_mask;
 	struct mutex ops_lock;
@@ -162,11 +164,9 @@ static void handle_pci_cfg_write(struct mdev_state *mdev_state, u16 offset,
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
-			   loff_t pos, bool is_write)
+static ssize_t mdev_access(struct mdev_state *mdev_state, char *buf,
+			   size_t count, loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	int ret = 0;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -187,8 +187,9 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 			memcpy(buf, mdev_state->memblk, count);
 
 	} else {
-		dev_info(dev, "%s: %s @0x%llx (unhandled)\n",
-			 __func__, is_write ? "WR" : "RD", pos);
+		dev_info(mdev_state->vdev.dev,
+			 "%s: %s @0x%llx (unhandled)\n", __func__,
+			 is_write ? "WR" : "RD", pos);
 		ret = -1;
 		goto accessfailed;
 	}
@@ -202,9 +203,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 	return ret;
 }
 
-static int mdpy_reset(struct mdev_device *mdev)
+static int mdpy_reset(struct mdev_state *mdev_state)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	u32 stride, i;
 
 	/* initialize with gray gradient */
@@ -216,13 +216,14 @@ static int mdpy_reset(struct mdev_device *mdev)
 	return 0;
 }
 
-static int mdpy_create(struct mdev_device *mdev)
+static int mdpy_probe(struct mdev_device *mdev)
 {
 	const struct mdpy_type *type =
 		&mdpy_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
+	int ret;
 
 	if (mdpy_count >= max_devices)
 		return -ENOMEM;
@@ -230,6 +231,7 @@ static int mdpy_create(struct mdev_device *mdev)
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mdpy_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MDPY_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL) {
@@ -250,36 +252,41 @@ static int mdpy_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
-
 	mdev_state->type    = type;
 	mdev_state->memsize = fbsize;
 	mdpy_create_config_space(mdev_state);
-	mdpy_reset(mdev);
+	mdpy_reset(mdev_state);
 
 	mdpy_count++;
+
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret) {
+		kfree(mdev_state);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
 
-static int mdpy_remove(struct mdev_device *mdev)
+static void mdpy_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
-	dev_info(dev, "%s\n", __func__);
+	dev_info(&mdev->dev, "%s\n", __func__);
 
-	mdev_set_drvdata(mdev, NULL);
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	vfree(mdev_state->memblk);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
 
 	mdpy_count--;
-	return 0;
 }
 
-static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mdpy_read(struct vfio_device *vdev, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -289,8 +296,8 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
-					   *ppos, false);
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
+					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
 
@@ -301,7 +308,7 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -313,7 +320,7 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -336,9 +343,11 @@ static ssize_t mdpy_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mdpy_write(struct vfio_device *vdev, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -351,7 +360,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -363,7 +372,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -375,7 +384,7 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -393,9 +402,10 @@ static ssize_t mdpy_write(struct mdev_device *mdev, const char __user *buf,
 	return -EFAULT;
 }
 
-static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+static int mdpy_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	if (vma->vm_pgoff != MDPY_MEMORY_BAR_OFFSET >> PAGE_SHIFT)
 		return -EINVAL;
@@ -411,16 +421,10 @@ static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
 					   vma->vm_end - vma->vm_start);
 }
 
-static int mdpy_get_region_info(struct mdev_device *mdev,
+static int mdpy_get_region_info(struct mdev_state *mdev_state,
 				struct vfio_region_info *region_info,
 				u16 *cap_type_id, void **cap_type)
 {
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	if (region_info->index >= VFIO_PCI_NUM_REGIONS &&
 	    region_info->index != MDPY_DISPLAY_REGION)
 		return -EINVAL;
@@ -449,15 +453,13 @@ static int mdpy_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mdpy_get_irq_info(struct mdev_device *mdev,
-			     struct vfio_irq_info *irq_info)
+static int mdpy_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	irq_info->count = 0;
 	return 0;
 }
 
-static int mdpy_get_device_info(struct mdev_device *mdev,
-				struct vfio_device_info *dev_info)
+static int mdpy_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
@@ -465,11 +467,9 @@ static int mdpy_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mdpy_query_gfx_plane(struct mdev_device *mdev,
+static int mdpy_query_gfx_plane(struct mdev_state *mdev_state,
 				struct vfio_device_gfx_plane_info *plane)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-
 	if (plane->flags & VFIO_GFX_PLANE_TYPE_PROBE) {
 		if (plane->flags == (VFIO_GFX_PLANE_TYPE_PROBE |
 				     VFIO_GFX_PLANE_TYPE_REGION))
@@ -498,14 +498,13 @@ static int mdpy_query_gfx_plane(struct mdev_device *mdev,
 	return 0;
 }
 
-static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mdpy_ioctl(struct vfio_device *vdev, unsigned int cmd,
 		       unsigned long arg)
 {
 	int ret = 0;
 	unsigned long minsz;
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
@@ -520,7 +519,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_device_info(mdev, &info);
+		ret = mdpy_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -545,7 +544,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_region_info(mdev, &info, &cap_type_id,
+		ret = mdpy_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -569,7 +568,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mdpy_get_irq_info(mdev, &info);
+		ret = mdpy_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -592,7 +591,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_query_gfx_plane(mdev, &plane);
+		ret = mdpy_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -606,12 +605,12 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		return -EINVAL;
 
 	case VFIO_DEVICE_RESET:
-		return mdpy_reset(mdev);
+		return mdpy_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mdpy_open(struct mdev_device *mdev)
+static int mdpy_open(struct vfio_device *vdev)
 {
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -619,7 +618,7 @@ static int mdpy_open(struct mdev_device *mdev)
 	return 0;
 }
 
-static void mdpy_close(struct mdev_device *mdev)
+static void mdpy_close(struct vfio_device *vdev)
 {
 	module_put(THIS_MODULE);
 }
@@ -628,8 +627,7 @@ static ssize_t
 resolution_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%dx%d\n",
 		       mdev_state->type->width,
@@ -719,18 +717,30 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mdpy_dev_ops = {
+	.open = mdpy_open,
+	.release = mdpy_close,
+	.read = mdpy_read,
+	.write = mdpy_write,
+	.ioctl = mdpy_ioctl,
+	.mmap = mdpy_mmap,
+};
+
+static struct mdev_driver mdpy_driver = {
+	.driver = {
+		.name = "mdpy",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mdpy_probe,
+	.remove	= mdpy_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
+	.device_driver          = &mdpy_driver,
 	.supported_type_groups	= mdev_type_groups,
-	.create			= mdpy_create,
-	.remove			= mdpy_remove,
-	.open			= mdpy_open,
-	.release		= mdpy_close,
-	.read			= mdpy_read,
-	.write			= mdpy_write,
-	.ioctl			= mdpy_ioctl,
-	.mmap			= mdpy_mmap,
 };
 
 static const struct file_operations vd_fops = {
@@ -755,11 +765,15 @@ static int __init mdpy_dev_init(void)
 	cdev_add(&mdpy_cdev, mdpy_devt, MINORMASK + 1);
 	pr_info("%s: major %d\n", __func__, MAJOR(mdpy_devt));
 
+	ret = mdev_register_driver(&mdpy_driver);
+	if (ret)
+		goto err_cdev;
+
 	mdpy_class = class_create(THIS_MODULE, MDPY_CLASS_NAME);
 	if (IS_ERR(mdpy_class)) {
 		pr_err("Error: failed to register mdpy_dev class\n");
 		ret = PTR_ERR(mdpy_class);
-		goto failed1;
+		goto err_driver;
 	}
 	mdpy_dev.class = mdpy_class;
 	mdpy_dev.release = mdpy_device_release;
@@ -767,19 +781,21 @@ static int __init mdpy_dev_init(void)
 
 	ret = device_register(&mdpy_dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mdpy_dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	return 0;
 
-failed3:
+err_device:
 	device_unregister(&mdpy_dev);
-failed2:
+err_class:
 	class_destroy(mdpy_class);
-failed1:
+err_driver:
+	mdev_unregister_driver(&mdpy_driver);
+err_cdev:
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	return ret;
@@ -791,6 +807,7 @@ static void __exit mdpy_dev_exit(void)
 	mdev_unregister_device(&mdpy_dev);
 
 	device_unregister(&mdpy_dev);
+	mdev_unregister_driver(&mdpy_driver);
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	class_destroy(mdpy_class);
-- 
2.31.1

