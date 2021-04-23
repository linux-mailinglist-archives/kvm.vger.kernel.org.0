Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE57F369D0F
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 01:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244108AbhDWXET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 19:04:19 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:21884
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237189AbhDWXEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 19:04:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PT2vwRpyo1+pDc94oBbOhF7gTLx4zRhUN64AtlFNfrEQnzAz9YiySN4cpfs7vRo/VpxP8x+YaPMnaj3Wa12ewCqA5D0yCpdTTMJTYznJX4fbJ9tBE/xYzNs9vOLs8BWFkZXcPhKorLFjv1+1rF9twIse8b1z+Z7H6NG9xrXDrNcsex4OdBR6iABrxcoROBRJHYMNi18vqX4nVvSklM3BB1zPPNeNsi8memYsjYm95PmBVs9UPNb3/hREqJ6kf5NlXrIGUessHM5obiEuFJNXtBZIkrtlvMOUcYci2015Tf1NPNMnvforqbv0eKoz/XSdqvmMga+4H0fmKVA6a3Et/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOc5E8ZvEvabyYJZRerXyS6/gS4zuSu4pbDggtMSmmQ=;
 b=jlxHCtBqsitGGwknCXHNqytvCU3dwj7quTcMOoHExUItkmL1SlLxOMVNAFhqLAT9ED68qzIM0HtAhb5Bp98+EYTYvKS5WBevkaEjBku7QcuszRw8SY9+6h3iMVCKnCIcmksvCRUP4V0ngORskeMob6MM5XgHuVaGxEYp2h+0CzEzYP4qQGWTJ0oQCXdbOoV2eiJWzQcMj1DowBp8h3a6/vs2+PZFLX9d3W9ANvwhTQw9IYYYI8SvbEYNpShdOZUPO8MOO9q1fV/Mddz1fGl2jxotj2MRA1qNRRv92EFKinpvLE5aVrdXaLKtnTvREZkbOXDOK074S19kIb5U4N2CEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOc5E8ZvEvabyYJZRerXyS6/gS4zuSu4pbDggtMSmmQ=;
 b=XLaovep+WsyYDAANRpuoAGxDf65hEF4kxfmAa1m+L3D/egAy+FO29QKfrHXDjLksrmIZgIDHno4/Ch9sKiuTFK3M7cyIevnxqR0GeBW9LDdxjKDrBR7DLO4UyRUnUdZeu2U+HLGOCE5Ybb9ZQpyKwpLUmBLgVS/mvwobqdDqBlGOShZLOsrhQufmOC9MpJ5ypj3A3K0fr6cMXl3CJNiLrzt0+fMNXkYxiaU4LFLqtI8dhzlbFJE9xQOozEINqaRg8+CsoXRKe3XiaOCVGsr+37EtZl2+DgGBX++TbQaDlHHwhLc3tbkG1XG8JYCYLXI3qAXdod+RS6mdyC2kN4xBVw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0203.namprd12.prod.outlook.com (2603:10b6:4:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 23 Apr
 2021 23:03:17 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 23:03:17 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 05/12] vfio/mbochs: Convert to use vfio_register_group_dev()
Date:   Fri, 23 Apr 2021 20:03:02 -0300
Message-Id: <5-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:23a::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:23a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 23:03:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1la4pK-00CHzj-3s; Fri, 23 Apr 2021 20:03:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db39fbc8-87fe-4f39-d2c2-08d906abf938
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0203:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0203A5BC025872B4723DB22FC2459@DM5PR1201MB0203.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:198;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfv0CfzSlMnPb+hLDpQmbqU93+yHgab9K7CtG3fbf0rlSNl4TEiGxdPIJihVKHpinDOSdzQJbfuoYW8rRe5mSfjTI+CK7jN/x+GF0qjbzWoPhQo/WP6SWR1eN2mrUXoVx/kqHMXsJLX4+wSZk9Pk6MFyuGRH0Dp2yFM7Loer3Oh3SI83qeFaUa1JySWtycrou4HphNeMn0fTM58R0BT+MZwSL/Y85YPrkcIf/eDqXLyCXjVQskSP+nZzsscIWZUKCfxybiqZbbFPdHCP1wnbnNv9jkCZnaHRe0WWFyhTOPcILJm/VPYp0Ci8gNDBfsWRCJmIOjZ6Te9wtIznb0z7FSbtGkXhMJ2HWimp3Vnbh1JY1TuAO0VPdWO+ZS/75L1n1ABXVKhzDMTAyiA7g6UDXQxwVF0pQ/iALRyaoKxKRywC9LaQdYmWkwK11FccN8NDaAHQk50I8oxXMEj4p/UZGG9m53D2OhQpg8rfmV94qC5/KikCV+mdSOPEMn1SCPInph7grJqf063kTauLeO89cwU9FidLFduc35lK2X/SsxIkV26PNmz7QmG9QIBj76bPk5u7hJUlx3SxoEnD8j+e2RZ0TM+KHWmB6jeF6VajS/nn51T93sXFTapjnz7aaea/ie326o40EA++ptSZ1068cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(6666004)(86362001)(2906002)(30864003)(66556008)(6862004)(2616005)(426003)(66476007)(107886003)(66946007)(38100700002)(36756003)(26005)(37006003)(186003)(6636002)(83380400001)(8676002)(54906003)(9786002)(316002)(4326008)(8936002)(9746002)(5660300002)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KNI3yGDB0qA0s7qpfupRXk1z3UxKyv6+1cB+X7YYWS2tb5sBp7B8/yl4+A6o?=
 =?us-ascii?Q?YOvAslM40mNAd5+9EVZtQ9iYRKmRUGLSDCc63uD+TX8671Poi/Oybkwv4dlx?=
 =?us-ascii?Q?zB98X6/zgdgPIIm8laXsaU9FniNmQfMauKvliIvsIUId7KkuIy3KW0sepGFk?=
 =?us-ascii?Q?RSwF9Rv1hWLv9+CCN0aM35YtUbaX4wB6rrdgkpyZ1bFvZZDMi0rkDiJpqrs5?=
 =?us-ascii?Q?vQaWNY654+pD/ltl5m9kks+WRQEpE5RdhQ/tIhKxjnkci/ckrKKR4pYrmpNR?=
 =?us-ascii?Q?n6JVHnr7d5wdathOTZj2h9QwB7xHqibNfX4KK33s315oA9vf1pzpJt1Zt/Pb?=
 =?us-ascii?Q?5gfL5Y6Q2mw1hRxh+Q9cwJSF0FkhByUArwkeSxcOdSdogSw3x2bkK5ejBivA?=
 =?us-ascii?Q?1S9HaZICBhGdBv9nOflgsBBQMrPG8VsGgcbpbqj0Ykf4XIxJvyx4gRCjiTVt?=
 =?us-ascii?Q?4jzTmVFAMffQhZUHkc8sY9EAYWAMIVQErH/vUJ5PthVTcKUbVQzozTEJ+ffZ?=
 =?us-ascii?Q?Nq2f561xujKsbp61wBurgOaEr7jwr//XIcmfjLuRERjN9byJrpxZXy84Y3W6?=
 =?us-ascii?Q?3wksTWp2qkKuGoejrRd0C35aDrYUPOuJhU97zc5lbJVw41JJHICzOzQMdxzK?=
 =?us-ascii?Q?WxLV466+W+tfIoqoJirculJSYqkSlP9Uizhilieq+Kq3xInUCBvbM1Vryllt?=
 =?us-ascii?Q?yNmS+JQDlUeHrAxYEZbr95cU7a04COgGi49X1Td3VQbfWD+eclo3ey4DW45m?=
 =?us-ascii?Q?5jniaZKO81kLFEiRWoV4wNR5OKiMTDVqwdR6Jf+seCv44I2ECU208q7lX5w7?=
 =?us-ascii?Q?UVEI7OxyCY8QWPGI7YkOR6bBbmKPsT4OKpPphHIUOgt/2ZpIfupgpJm3wJBv?=
 =?us-ascii?Q?0pRPhR2h5E5gxlTU44OIJPd9qtmwXQzf8yeGH5Wct7kw+Z69S65XRN+I5xY1?=
 =?us-ascii?Q?LoYtiuM6+ORZxdwvN4aJlipjkurC2O2zzhB9fxToWJkvgyqEg9SR5j5bv3cG?=
 =?us-ascii?Q?3eXAxc0YY9zvZyGjI1rfjttdzahSSnKj671To/UatIJfTAXYPdtI0vlKkWwb?=
 =?us-ascii?Q?1KkRoGQPz7cy1TWAdNJmB5pD5VPK2ryUioblvOv8KZxCGxpzwYZzMLgZig9h?=
 =?us-ascii?Q?d6PgSu9gYymsurWyKh0ADaTYbsz1BDglp8gW5POSJ5SAz3UXUR4E5aNdjcz/?=
 =?us-ascii?Q?knZ09CbTFnb9JTt9FQbt6pbB+nO+uARq8jYf4NrOPvHHRQQO5S426rtZKwt5?=
 =?us-ascii?Q?7Zvuk0yHdLLXvjhvJVzfDibtSy/oPw3syyNBkOfV0jJgt2qxZSFqZ7B+qzKP?=
 =?us-ascii?Q?TZCWzTBV5a0oFQItNZsjRThU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db39fbc8-87fe-4f39-d2c2-08d906abf938
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:14.2709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qg6hXKXGROZK3Jsrelwk8TFlWnZDMKbpNo5uSfheLzvHOPhhlXX4Z3LCjcdjT93L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0203
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mbochs.c | 163 +++++++++++++++++++++----------------
 1 file changed, 91 insertions(+), 72 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 861c76914e7639..e18821a8a6beb8 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -130,6 +130,7 @@ static struct class	*mbochs_class;
 static struct cdev	mbochs_cdev;
 static struct device	mbochs_dev;
 static int		mbochs_used_mbytes;
+static const struct vfio_device_ops mbochs_dev_ops;
 
 struct vfio_region_info_ext {
 	struct vfio_region_info          base;
@@ -160,6 +161,7 @@ struct mbochs_dmabuf {
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	u8 *vconfig;
 	u64 bar_mask[3];
 	u32 memory_bar_mask;
@@ -425,11 +427,9 @@ static void handle_edid_blob(struct mdev_state *mdev_state, u16 offset,
 		memcpy(buf, mdev_state->edid_blob + offset, count);
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
-			   loff_t pos, bool is_write)
+static ssize_t mdev_access(struct mdev_state *mdev_state, char *buf,
+			   size_t count, loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	struct page *pg;
 	loff_t poff;
 	char *map;
@@ -478,7 +478,7 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 		put_page(pg);
 
 	} else {
-		dev_dbg(dev, "%s: %s @0x%llx (unhandled)\n",
+		dev_dbg(mdev_state->vdev.dev, "%s: %s @0x%llx (unhandled)\n",
 			__func__, is_write ? "WR" : "RD", pos);
 		ret = -1;
 		goto accessfailed;
@@ -493,9 +493,8 @@ static ssize_t mdev_access(struct mdev_device *mdev, char *buf, size_t count,
 	return ret;
 }
 
-static int mbochs_reset(struct mdev_device *mdev)
+static int mbochs_reset(struct mdev_state *mdev_state)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	u32 size64k = mdev_state->memsize / (64 * 1024);
 	int i;
 
@@ -506,12 +505,13 @@ static int mbochs_reset(struct mdev_device *mdev)
 	return 0;
 }
 
-static int mbochs_create(struct mdev_device *mdev)
+static int mbochs_probe(struct mdev_device *mdev)
 {
 	const struct mbochs_type *type =
 		&mbochs_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
+	int ret = -ENOMEM;
 
 	if (!type)
 		type = &mbochs_types[0];
@@ -521,6 +521,7 @@ static int mbochs_create(struct mdev_device *mdev)
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mbochs_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MBOCHS_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL)
@@ -539,7 +540,6 @@ static int mbochs_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
 	INIT_LIST_HEAD(&mdev_state->dmabufs);
 	mdev_state->next_id = 1;
 
@@ -549,32 +549,38 @@ static int mbochs_create(struct mdev_device *mdev)
 	mdev_state->edid_regs.edid_offset = MBOCHS_EDID_BLOB_OFFSET;
 	mdev_state->edid_regs.edid_max_size = sizeof(mdev_state->edid_blob);
 	mbochs_create_config_space(mdev_state);
-	mbochs_reset(mdev);
+	mbochs_reset(mdev_state);
 
 	mbochs_used_mbytes += type->mbytes;
+
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret)
+		goto err_mem;
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 
 err_mem:
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
-	return -ENOMEM;
+	return ret;
 }
 
-static int mbochs_remove(struct mdev_device *mdev)
+static void mbochs_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
 	mbochs_used_mbytes -= mdev_state->type->mbytes;
-	mdev_set_drvdata(mdev, NULL);
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	kfree(mdev_state->pages);
 	kfree(mdev_state->vconfig);
 	kfree(mdev_state);
-	return 0;
 }
 
-static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mbochs_read(struct vfio_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -584,7 +590,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
+			ret =  mdev_access(mdev_state, (char *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -596,7 +602,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -608,7 +614,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -631,9 +637,11 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mbochs_write(struct vfio_device *vdev, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -646,7 +654,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -658,7 +666,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -670,7 +678,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -756,9 +764,10 @@ static const struct vm_operations_struct mbochs_region_vm_ops = {
 	.fault = mbochs_region_vm_fault,
 };
 
-static int mbochs_mmap(struct mdev_device *mdev, struct vm_area_struct *vma)
+static int mbochs_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	if (vma->vm_pgoff != MBOCHS_MEMORY_BAR_OFFSET >> PAGE_SHIFT)
 		return -EINVAL;
@@ -965,7 +974,7 @@ mbochs_dmabuf_find_by_id(struct mdev_state *mdev_state, u32 id)
 static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
 {
 	struct mdev_state *mdev_state = dmabuf->mdev_state;
-	struct device *dev = mdev_dev(mdev_state->mdev);
+	struct device *dev = mdev_state->vdev.dev;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct dma_buf *buf;
 
@@ -993,15 +1002,10 @@ static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
 	return 0;
 }
 
-static int mbochs_get_region_info(struct mdev_device *mdev,
+static int mbochs_get_region_info(struct mdev_state *mdev_state,
 				  struct vfio_region_info_ext *ext)
 {
 	struct vfio_region_info *region_info = &ext->base;
-	struct mdev_state *mdev_state;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
 
 	if (region_info->index >= MBOCHS_NUM_REGIONS)
 		return -EINVAL;
@@ -1049,15 +1053,13 @@ static int mbochs_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mbochs_get_irq_info(struct mdev_device *mdev,
-			       struct vfio_irq_info *irq_info)
+static int mbochs_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	irq_info->count = 0;
 	return 0;
 }
 
-static int mbochs_get_device_info(struct mdev_device *mdev,
-				  struct vfio_device_info *dev_info)
+static int mbochs_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = MBOCHS_NUM_REGIONS;
@@ -1065,11 +1067,9 @@ static int mbochs_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mbochs_query_gfx_plane(struct mdev_device *mdev,
+static int mbochs_query_gfx_plane(struct mdev_state *mdev_state,
 				  struct vfio_device_gfx_plane_info *plane)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	struct device *dev = mdev_dev(mdev);
 	struct mbochs_dmabuf *dmabuf;
 	struct mbochs_mode mode;
 	int ret;
@@ -1123,18 +1123,16 @@ static int mbochs_query_gfx_plane(struct mdev_device *mdev,
 done:
 	if (plane->drm_plane_type == DRM_PLANE_TYPE_PRIMARY &&
 	    mdev_state->active_id != plane->dmabuf_id) {
-		dev_dbg(dev, "%s: primary: %d => %d\n", __func__,
-			mdev_state->active_id, plane->dmabuf_id);
+		dev_dbg(mdev_state->vdev.dev, "%s: primary: %d => %d\n",
+			__func__, mdev_state->active_id, plane->dmabuf_id);
 		mdev_state->active_id = plane->dmabuf_id;
 	}
 	mutex_unlock(&mdev_state->ops_lock);
 	return 0;
 }
 
-static int mbochs_get_gfx_dmabuf(struct mdev_device *mdev,
-				 u32 id)
+static int mbochs_get_gfx_dmabuf(struct mdev_state *mdev_state, u32 id)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
 	struct mbochs_dmabuf *dmabuf;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -1156,9 +1154,11 @@ static int mbochs_get_gfx_dmabuf(struct mdev_device *mdev,
 	return dma_buf_fd(dmabuf->buf, 0);
 }
 
-static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
-			unsigned long arg)
+static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
+			 unsigned long arg)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	int ret = 0;
 	unsigned long minsz, outsz;
 
@@ -1175,7 +1175,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mbochs_get_device_info(mdev, &info);
+		ret = mbochs_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -1199,7 +1199,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (outsz > sizeof(info))
 			return -EINVAL;
 
-		ret = mbochs_get_region_info(mdev, &info);
+		ret = mbochs_get_region_info(mdev_state, &info);
 		if (ret)
 			return ret;
 
@@ -1222,7 +1222,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= VFIO_PCI_NUM_IRQS))
 			return -EINVAL;
 
-		ret = mbochs_get_irq_info(mdev, &info);
+		ret = mbochs_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -1245,7 +1245,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mbochs_query_gfx_plane(mdev, &plane);
+		ret = mbochs_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -1262,19 +1262,19 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (get_user(dmabuf_id, (__u32 __user *)arg))
 			return -EFAULT;
 
-		return mbochs_get_gfx_dmabuf(mdev, dmabuf_id);
+		return mbochs_get_gfx_dmabuf(mdev_state, dmabuf_id);
 	}
 
 	case VFIO_DEVICE_SET_IRQS:
 		return -EINVAL;
 
 	case VFIO_DEVICE_RESET:
-		return mbochs_reset(mdev);
+		return mbochs_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mbochs_open(struct mdev_device *mdev)
+static int mbochs_open(struct vfio_device *vdev)
 {
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
@@ -1282,9 +1282,10 @@ static int mbochs_open(struct mdev_device *mdev)
 	return 0;
 }
 
-static void mbochs_close(struct mdev_device *mdev)
+static void mbochs_close(struct vfio_device *vdev)
 {
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	struct mbochs_dmabuf *dmabuf, *tmp;
 
 	mutex_lock(&mdev_state->ops_lock);
@@ -1308,8 +1309,7 @@ static ssize_t
 memory_show(struct device *dev, struct device_attribute *attr,
 	    char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d MB\n", mdev_state->type->mbytes);
 }
@@ -1400,18 +1400,30 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mbochs_dev_ops = {
+	.open = mbochs_open,
+	.release = mbochs_close,
+	.read = mbochs_read,
+	.write = mbochs_write,
+	.ioctl = mbochs_ioctl,
+	.mmap = mbochs_mmap,
+};
+
+static struct mdev_driver mbochs_driver = {
+	.driver = {
+		.name = "mbochs",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mbochs_probe,
+	.remove	= mbochs_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner			= THIS_MODULE,
-	.mdev_attr_groups	= mdev_dev_groups,
+	.device_driver		= &mbochs_driver,
 	.supported_type_groups	= mdev_type_groups,
-	.create			= mbochs_create,
-	.remove			= mbochs_remove,
-	.open			= mbochs_open,
-	.release		= mbochs_close,
-	.read			= mbochs_read,
-	.write			= mbochs_write,
-	.ioctl			= mbochs_ioctl,
-	.mmap			= mbochs_mmap,
 };
 
 static const struct file_operations vd_fops = {
@@ -1436,11 +1448,15 @@ static int __init mbochs_dev_init(void)
 	cdev_add(&mbochs_cdev, mbochs_devt, MINORMASK + 1);
 	pr_info("%s: major %d\n", __func__, MAJOR(mbochs_devt));
 
+	ret = mdev_register_driver(&mbochs_driver);
+	if (ret)
+		goto err_cdev;
+
 	mbochs_class = class_create(THIS_MODULE, MBOCHS_CLASS_NAME);
 	if (IS_ERR(mbochs_class)) {
 		pr_err("Error: failed to register mbochs_dev class\n");
 		ret = PTR_ERR(mbochs_class);
-		goto failed1;
+		goto err_driver;
 	}
 	mbochs_dev.class = mbochs_class;
 	mbochs_dev.release = mbochs_device_release;
@@ -1448,19 +1464,21 @@ static int __init mbochs_dev_init(void)
 
 	ret = device_register(&mbochs_dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mbochs_dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	return 0;
 
-failed3:
+err_device:
 	device_unregister(&mbochs_dev);
-failed2:
+err_class:
 	class_destroy(mbochs_class);
-failed1:
+err_driver:
+	mdev_unregister_driver(&mbochs_driver);
+err_cdev:
 	cdev_del(&mbochs_cdev);
 	unregister_chrdev_region(mbochs_devt, MINORMASK + 1);
 	return ret;
@@ -1472,6 +1490,7 @@ static void __exit mbochs_dev_exit(void)
 	mdev_unregister_device(&mbochs_dev);
 
 	device_unregister(&mbochs_dev);
+	mdev_unregister_driver(&mbochs_driver);
 	cdev_del(&mbochs_cdev);
 	unregister_chrdev_region(mbochs_devt, MINORMASK + 1);
 	class_destroy(mbochs_class);
-- 
2.31.1

