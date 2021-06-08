Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C9639EB18
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFHA5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:51 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:45339
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230382AbhFHA5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axB0rpglgF1w5W0X1hDmb/V6QI9pvbLcHCM7BPNwifmBnSqklAoesUGPibK3nw25Egeh/Q97XvBEbWLUrYreL1JqE/PFbxtu3LG/Zb2O9mLT1HnP8SV8i8PHmc+1GxVsJEPQb/Gy+L0xmLWuSyENsG3FE8OFW5IWj7xdkfvnvTD7RkIIws359LlQatV8StWkeQqhJ0HbVsxtYmgdk0P051ljIZMZoHnLY/6GvRBsD4pRzzZKp/33w4sbHnQYY0/uErNmDCv+/ll8VnU4cqDv6PNsEnG6Rw5P64Xiw9s7ZXlxvh3p7SBjLZ5llE0FLNDIyWMgMboOT0SS4azC3jXcrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubxl09Oh9RRiYUvs16zc906Eu8pK4TldYGiGc+CiB1Q=;
 b=Mudej4q5/GJg3OAY9NmiLWSD94UptJI/CdqOve4xBaVGdOTMQ7zy0BKBjWtXUB11V04jZoUyaWPwrIKLESotDoP0cVfn9fPxEr7jtLytPUSris3+ZCs8Kb0TCsVTgAzqQEq1B/B6GI3vzezo7UqeIBdpqeibjG4Pwjz4XNgd3Ej+ZyGLi0RKFWbE1uFTZaaEPPUKk4rCmWcb1/X3Gt6r3jkSq/eZP18b+t41oiGlKCYAF6+XIr96K8p5FMJ20MmUViW+DU9SPPiMB1hpSck9tXLNkMu/FKMRHu6KA2IwUtv0kBGaG2i97m0maeyttIIPp0TOwX1ggtCU5sWRCQbW6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ubxl09Oh9RRiYUvs16zc906Eu8pK4TldYGiGc+CiB1Q=;
 b=IITJyky4KtflY7ApeKPCEP/+Fmi6fO40om0zouBSMy4Q7Su2w8VSI5es9MGzGnWRSocKLqHp2wxzNhcsxuhHgUEpPqv5FvogBuBexxljoRRnwLoTHhIjtER24A5/VmbSv+Nr4qF0v+h5HTgwFOrSYNA/PWg2/u42I8+xUiNg7U2b6181OADEOI1y4ITgTTtv7XW+nqyBpUsTX5HUww2mK6enDxRS7/8TGDWgC+GWqE81nyhB/pEvq95hre8qYLfvhlGuFwlskNCFKa1PcP1eUneG+wJyfk8RCALHet7kz311JdmrRXGlVaGytIXw1fVSjg5y08oau3G3kJnX5ff3gA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5539.namprd12.prod.outlook.com (2603:10b6:208:1c3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 00:55:54 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:54 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] vfio/mdpy: Convert to use vfio_register_group_dev()
Date:   Mon,  7 Jun 2021 21:55:51 -0300
Message-Id: <9-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR12CA0028.namprd12.prod.outlook.com
 (2603:10b6:208:a8::41) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR12CA0028.namprd12.prod.outlook.com (2603:10b6:208:a8::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Tue, 8 Jun 2021 00:55:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKr-N8; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36d26fbc-cf28-49fe-0f9d-08d92a182afc
X-MS-TrafficTypeDiagnostic: BL0PR12MB5539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5539627BD1EC880B945A310CC2379@BL0PR12MB5539.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGp4lPOe37JHot7q3IBEv97spkw6aNHkEN9ktvCrVKzCSzBTQS0JFDw3WDvLBWw3ZwGGSUnJ27cubQL+N+WqQ/MDWDlHZO0o17iYSwf2F1dZ4whPViJ9iASBzFJiw9TYVoAqIaDVNMkmB+HMQCLtJj7ugGqNG9r94NsMSy91T8DDAocPBkQa/hKXBsDd/ec2bx06JqbE7XA91q22HwP5lMZcp8ACgG/0UBl/m0W2BJJe/dQY44tUFHTNIY8Bqb/mvhCA87WlEdnUa/ZRAYgDGq+Tn+FudKfBcS6poE+ldHpliTiwH30mJWQMeKuh3GSZTVQ74ABPwGU4A8Jxi7SM4A4LValMV7GQ0wrpEsqWEumBotx3r+WEY8lcGU5gU9WHkU4ahzAkcMrq/9ow31FRML9yTzP3n6d9FgMcwAl4O/mixTaNmnvhu/XQU68yTSNgJbdOH2Rn+tKFloNzd+cWFZThLyfJXj9mym94ltX4JdL7EYwco/V2qZ0PN/XgitBARQ8SNkKPYAI+DvBpA4uBA14RJFrSsFvJkugVRcm5aWiFmGZuX/49rSXwDHHUK6J/fbZRz7cMNDJ6ZU+1S7zfJj9gsa1FtIkx2Vs10DRbHS/DKTfPBNdBzqIR5oUmDOXD7SEWUTPB3C5zxJWv+ELrFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(9786002)(186003)(26005)(6862004)(36756003)(37006003)(316002)(8936002)(478600001)(4326008)(9746002)(2906002)(6636002)(86362001)(83380400001)(66946007)(426003)(38100700002)(2616005)(5660300002)(8676002)(66476007)(30864003)(66556008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AreQYkTmCxHH2IC2edjRttFFG8VyrHlnANXHzYs1ydfnnqHkoY+ZgNlhoFuu?=
 =?us-ascii?Q?ew7uqoEcjcjPMsvNtIP1JrYudKJADutmm40oqvJyTA49uWJ1icCM48+aQthd?=
 =?us-ascii?Q?ww1H+hSF5RiXtjSRop0uVXljRrwCUyxZjwWSN4HoA5+Zc4Yco3ptMJ3yy2cG?=
 =?us-ascii?Q?JYh5/Oa8aY2N6Ac6DOvvy94OANTB/63NNlP1njOntaQiYuv8qZjQMqyFJDWN?=
 =?us-ascii?Q?j/Y29fs9Ivtoc6U4on7Nty2gDq5w9TAjouICL1K0nABI755c2r8+yCZEkHVB?=
 =?us-ascii?Q?7oIv7M7SlVhk+CD9RJ4VQ00e8+MP5TJWAK4tFZ1IWRV9hFF+gBjtmm4SKOmG?=
 =?us-ascii?Q?bSo0qYMjEJoR6X9+dyi1wARP0H7FWYKXfvv6Eg1ykNHYjZD4FGUNtBQ8J7px?=
 =?us-ascii?Q?mGlmxHcT5vYcYkvoFMgjP4ASf8WBHyGOMkAgUZtJzMTW9mYm9c4tDJX29ONq?=
 =?us-ascii?Q?Pwwyyz0q7cp30Tght2PXbxKJQC0R74VedthuiWhN6MiyLR0vramWWT+MaRdN?=
 =?us-ascii?Q?DC/0SEw8Yf3WxBzLoO7BO9OZS9+18XXDjIIA7jX5++RNUX4vhix5kpSjmQ/g?=
 =?us-ascii?Q?G4fc6IrRJcVQ8DT2xMmMZVgBdk4hbKZD5Q9Ri6E83AOzg0ehZofe+qRKYqpu?=
 =?us-ascii?Q?FjFSFm1X92UEQ2N/qDJgFfT9wyHtPfOhLem6iPzK7D5/tsht0/1NPrp0qHqz?=
 =?us-ascii?Q?8Q7dTMskTyjvXmXRA9pRL0cH0ksmCMtWxVc+R7bLpF41YgDQYHh2P2C43xA7?=
 =?us-ascii?Q?j/oRKm1CJOD9JbJHyhScTBClCJAlBl0bwqKZRCG80qWE1tcj4qtpokA3PX8C?=
 =?us-ascii?Q?xPzD+GLF+hMZwbIUbawd7d3KhvR0KPZpY0z9xq8eEtMDU4ZtF6CftNLUWyvB?=
 =?us-ascii?Q?NCjCdPTTtHKWaowpxdVIN11xNDi6OS4Ea2XnHe2WYs4YX5Gv8voZ0/XmMUjf?=
 =?us-ascii?Q?SWTxV/IzjYwCKiRM4795G/hR3cHpA8teuKPufVHnpaTgbdr1OeUEHRfGhY14?=
 =?us-ascii?Q?F+z5kUxNRueiy07k0J3CVPSU7al+eDZt5GRczdxtU8/vTRoFmp4nAgs7f8LQ?=
 =?us-ascii?Q?jdPnCMVnK7jAxKRJjpzAuyu3CtJyE4okbrgk/HLi3EPZiEFYG6u4MY77pn1h?=
 =?us-ascii?Q?D4lKrmIy+wbtMp3umZ9oh6BwS6vNom96RpXVc9GTiviwXCqy8LVx661nhNWQ?=
 =?us-ascii?Q?HTk2wSnFFfpuAFRy65ou/O+VaGXT5XMrnykXJpy9EbANu5l8MHnflX8lkWBZ?=
 =?us-ascii?Q?sZxmC66COq1peG0zqRIJpDSexTdUHrLwTndj+yXWPa9cEGGSFb5torVcQZ5m?=
 =?us-ascii?Q?KNr69RS25hBDwJ+fXTKl8aHO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d26fbc-cf28-49fe-0f9d-08d92a182afc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:54.0301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsnViTCb/bDmfFbTpCzJLShCHSc7WZF4ApbDOsTE1jzymvxYwXkL4HIijqhmPcbU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5539
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
index e889c1cf8fd1cd..7e9c9df0f05bac 100644
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
@@ -409,16 +419,10 @@ static int mdpy_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
 	return remap_vmalloc_range(vma, mdev_state->memblk, 0);
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
@@ -447,15 +451,13 @@ static int mdpy_get_region_info(struct mdev_device *mdev,
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
@@ -463,11 +465,9 @@ static int mdpy_get_device_info(struct mdev_device *mdev,
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
@@ -496,14 +496,13 @@ static int mdpy_query_gfx_plane(struct mdev_device *mdev,
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
@@ -518,7 +517,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_device_info(mdev, &info);
+		ret = mdpy_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -543,7 +542,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_get_region_info(mdev, &info, &cap_type_id,
+		ret = mdpy_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -567,7 +566,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mdpy_get_irq_info(mdev, &info);
+		ret = mdpy_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -590,7 +589,7 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mdpy_query_gfx_plane(mdev, &plane);
+		ret = mdpy_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -604,12 +603,12 @@ static long mdpy_ioctl(struct mdev_device *mdev, unsigned int cmd,
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
@@ -617,7 +616,7 @@ static int mdpy_open(struct mdev_device *mdev)
 	return 0;
 }
 
-static void mdpy_close(struct mdev_device *mdev)
+static void mdpy_close(struct vfio_device *vdev)
 {
 	module_put(THIS_MODULE);
 }
@@ -626,8 +625,7 @@ static ssize_t
 resolution_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%dx%d\n",
 		       mdev_state->type->width,
@@ -716,18 +714,30 @@ static struct attribute_group *mdev_type_groups[] = {
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
@@ -752,11 +762,15 @@ static int __init mdpy_dev_init(void)
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
@@ -764,19 +778,21 @@ static int __init mdpy_dev_init(void)
 
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
@@ -788,6 +804,7 @@ static void __exit mdpy_dev_exit(void)
 	mdev_unregister_device(&mdpy_dev);
 
 	device_unregister(&mdpy_dev);
+	mdev_unregister_driver(&mdpy_driver);
 	cdev_del(&mdpy_cdev);
 	unregister_chrdev_region(mdpy_devt, MINORMASK + 1);
 	class_destroy(mdpy_class);
-- 
2.31.1

