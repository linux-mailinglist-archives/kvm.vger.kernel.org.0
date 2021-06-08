Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B3939EB21
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhFHA5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:55 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:6904
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231326AbhFHA5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkI9xYpmhR14Fbt3hmvdWUvo2aIDNci0wqAnzMceWpizpvcL6sR1E1KsFeVpCjtUJ7aH8HEiDZeU8jzvrsqfX6LkZtyNEvNOpI5nlbFjdp+OoP5XaeGAXYZ05H50yMXDjyrCeg/wA8rlfV830nT77yQZzEasvQrWWGmMeX3C5nR7mvMkKQNYr4kWBgEHVZljvWHkJrJP2QbFNnp5EIdYr8Z3WBxgwZpk7mZJJ4nGrIqWdZXbaoP4Lzw1DkDlK8JKxfudW/tNWWPbdBRqSecthQWJhANnEt8DY3apc60PrI8wQY6ijG3sw2PTWZMNf2z55XK5gwTXoFKsFLmTjPHA/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZhPBpz/6THlXJs8mcNWgMUSX5lyq896uZnrk4Padc8=;
 b=WiMS+XMluw6HJjZw6odIVy91Kt0MsXYeYFVNqh/ChPDQ2YKMwWfxT035MDYPnyHgSwb5iO8quuBlKMw+ZC+SqYEDKedz2ErtOkKjnJ+o43JDeCgVkKD6bHWzzMqU/nG2evZJCmXEqy0zEj9vDH8Kpv+BZK7XjyR2cADtDjfVPldfLzRjzv6RQHkFdQRecEfx0aNsiqY3ZBQUMNqUchFRT8gfsANBAw8Ts1vM/Pnivu/SJ0qq9yDsaUmQ14M+BTy5yeAbQ8vf536RKxUSNu+3jJhtZnlv5RoR2IxDGUouiysd+0jOJRbrjCfvDgQHOXp0LHp2bfpdZnbMTpLG2v2iRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZhPBpz/6THlXJs8mcNWgMUSX5lyq896uZnrk4Padc8=;
 b=Cdssu2m2rHgLBv6Vep691ToyeQcObRRWAbnhIaSBhfxwjnoOaTv2Ri8jCRKj26pgmmpWTGs/sNfq/6PHlGF5FNAU83mN30Tic6jRbO5mBymNdHHpdg41QWanB2907ojTMySbJ6H0JTAVJkX+4RRv7q4HhkbspGouM1hOydHhplB2Tc1YX8QG8Ljk1jLiwcPAUTIes7JAPq0qKv8OKxyYwqvwKOzq+usi5M7tDs/6T5pSajSmuAKe6rmbFoOFptZxNc9eiUuCdqYBnwTzr9TqcdHNDnD7JR7jA626LkrVyrqbVadamCigD/X/Y8JQK+5VZ5nZDh07FoTWlNFLTu8D6g==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 00:55:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:57 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] vfio/mbochs: Convert to use vfio_register_group_dev()
Date:   Mon,  7 Jun 2021 21:55:52 -0300
Message-Id: <10-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:208:160::42) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR13CA0029.namprd13.prod.outlook.com (2603:10b6:208:160::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Tue, 8 Jun 2021 00:55:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKv-OJ; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca815663-d4ba-42f3-697e-08d92a182be5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5095BEF48AEFD4C29B16AFC0C2379@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:198;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MwD5eiJGoYYvVsZXEfyi/M7iyhQmVrkHZxbEw4EnWBGGNgqSriTIhbLuYsRrgkipL9ejsL2wfM5fbVUnUyY88OXNdxUOus+3c16WI3w+81lw4yEWFH4p041v5q5XoatJDZVOD3zvVhQuN3kx80bUGO0hZrsEohfvny0EnPwk5Tf9oheXcvEJJGqhkAPlhdAxvH0Ox8reNzVI9hr5CiXwHG68yq/woWWIcbM2ApHrpCFXpNV+cjM9NF1rtwNictWVAYCaa5IOXYWV4Dfp6nks+3pP8niIo6zsdU+bvLGKkBrAQs5LbnkoOaJhPNsmemm0eHPmoEVBqAOkZRlpAHja6WPle3sytAJGYfvc8504vW4nOU3YbMBL8dXH4SNXpY5O0VfXADwaU3zKJiksFjSHBrMTbpIK/jaXJV211GdMWbRRWs6iW80W/bbUTp7zibgz97AgYwneonkSuMXpqFeoN0CUW+KpCEU6MrryzI1F/8xrVKj57Nz7heInsLpgTm8U3HE4zSxfhRA+W8lr3A0L/ty8ZhpFYtlXcrvP9rq5Cf1JXnsydmdPIu+YgCpqrCYDgzn2nrwP1Mdi3njYEPn55Q9ceiuCITsATnVryj3Dlbw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(2616005)(86362001)(9746002)(6862004)(66556008)(2906002)(37006003)(30864003)(36756003)(186003)(9786002)(4326008)(478600001)(426003)(6636002)(66476007)(83380400001)(8936002)(8676002)(26005)(66946007)(5660300002)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lROJEOwxqtXBhYz7DCu3ZH0+hR3LNjNMuAiAA1s5PTR4lVo3PzhsjH5X2YPL?=
 =?us-ascii?Q?P4ZycL03eHoPOdYd1B2KfICd84ZQReGPrWrLLu/mQfdGAPHr56SgezWhiIlK?=
 =?us-ascii?Q?ehywaGRcq4o125RkdreZB6hW0u1EPhdTTefGaDxhhKaSxKvRTOq0P4hOJZG0?=
 =?us-ascii?Q?7QmE/888ZRjqYVGmwUzICJnzGIiG963xnqQXF8IAmAvTigrEXv3JOVMnokPq?=
 =?us-ascii?Q?VEaLuGtLjk1pzwjZ+2rf9AeULykB2wsSHxgkNfqHe5ls7qiS+3oh5i2a7uwk?=
 =?us-ascii?Q?S/9cn6vdtCVKiPcFT9fnXp1QKd0vsDbhoR9Gd5+0Ju0PF1R259ahBlDNMM6M?=
 =?us-ascii?Q?z/idhAQTMU42ICUmLBCYVJf/C49Vmmlv4NNgy1bmNlGz/HYbpqvxIbuBpJyZ?=
 =?us-ascii?Q?v4W7k4w+OqOe/WO+N6n9748g3jiD9e3nP2rpM9XYdpjp3TFXP1ReEC0YJCuT?=
 =?us-ascii?Q?YHqRNHVqZIpNMQ0tkDZINTPJlDuIlw96/fCUfVyV9zSH+lO1QL47I1SN1bFv?=
 =?us-ascii?Q?b97j1F2JApTym9qLuTluG0DkZipGD2dMORdNhPmuSFqzJPHY//vhsut/dlAE?=
 =?us-ascii?Q?6jtMJ9DTAOJPXWZlqR7T20kUe0BmfQov7UuB3ClG2c0SftodfSzeb4Uh0X9d?=
 =?us-ascii?Q?avOv2aqWkf/MjQj08pZ6wIcKmzb7QnMgwlxSIMs1DpJFYVV4KQhR1JMN3L+X?=
 =?us-ascii?Q?zjeS2JXdpakJU059tVsVn9H+IOXYIfKV34PCMKPYYHGXA0UZ115oDhIzuL3V?=
 =?us-ascii?Q?ZEbQ+iLYjdt1DYAJjyM6Ix6prPUYPpJNIvg8Tw3ba9J1dfnHRistnPSuDDLW?=
 =?us-ascii?Q?8EES+SeP+YY6XCoLZ357sbzhtGyuuusACaxh9jLI4rkeOZDJSPz396nrO8M7?=
 =?us-ascii?Q?oYzITsL65KpkIWrFGepJGD1Nb63DzHLX/oLHwNk0e0BlC538ub3jFXyl+L2C?=
 =?us-ascii?Q?81KnsEov31DNZrddO1x1SZdLADInHO9VfE/PMVZjOwibgHXJvOw5QCu+dkON?=
 =?us-ascii?Q?2aFxcwAqufshbnBKYQ0Ej+ZoC8Zfu7Hb/iySNvTKw1fbL9BfCiO+LujLRdT2?=
 =?us-ascii?Q?PBvgwfusohcJQxYsfajLuKFWS9Wfg6HTTJpEmV7AQkxoLEguSwZO053xmnMB?=
 =?us-ascii?Q?S61qVwLRLqKhQ8wuGieoYbSRfZKXmbJAkjjf1xOvHz/r8fSLhpUdeEkhl/bc?=
 =?us-ascii?Q?hVMKCVY2q/+no4m0B7Nph+QQp2+4aQdXH0Sh5WaJAcH5R7WK1631NjCwLUWv?=
 =?us-ascii?Q?nbk/Z1vPUPxS5MaXNgxolUHRLQKUAI1m+vhDDeERdFvCjGX6WwjtQpzwtk8D?=
 =?us-ascii?Q?ajp4ycMAScwieNZhJOPEeGAI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca815663-d4ba-42f3-697e-08d92a182be5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:55.5693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfIccK6ABdjI9SECoYbImHA6yKjRlu3tvsUdJr1TgRPBYQvXZ8Kbr2vStcpkPeMW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mbochs.c | 163 +++++++++++++++++++++----------------
 1 file changed, 91 insertions(+), 72 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 881ef9a7296f23..6c0f229db36a1a 100644
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
 
 	if (type->mbytes + mbochs_used_mbytes > max_mbytes)
 		return -ENOMEM;
@@ -519,6 +519,7 @@ static int mbochs_create(struct mdev_device *mdev)
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mbochs_dev_ops);
 
 	mdev_state->vconfig = kzalloc(MBOCHS_CONFIG_SPACE_SIZE, GFP_KERNEL);
 	if (mdev_state->vconfig == NULL)
@@ -537,7 +538,6 @@ static int mbochs_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
 	INIT_LIST_HEAD(&mdev_state->dmabufs);
 	mdev_state->next_id = 1;
 
@@ -547,32 +547,38 @@ static int mbochs_create(struct mdev_device *mdev)
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
 
@@ -582,7 +588,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (char *)&val, sizeof(val),
+			ret =  mdev_access(mdev_state, (char *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -594,7 +600,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -606,7 +612,7 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -629,9 +635,11 @@ static ssize_t mbochs_read(struct mdev_device *mdev, char __user *buf,
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
 
@@ -644,7 +652,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -656,7 +664,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -668,7 +676,7 @@ static ssize_t mbochs_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (char *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (char *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -754,9 +762,10 @@ static const struct vm_operations_struct mbochs_region_vm_ops = {
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
@@ -963,7 +972,7 @@ mbochs_dmabuf_find_by_id(struct mdev_state *mdev_state, u32 id)
 static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
 {
 	struct mdev_state *mdev_state = dmabuf->mdev_state;
-	struct device *dev = mdev_dev(mdev_state->mdev);
+	struct device *dev = mdev_state->vdev.dev;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	struct dma_buf *buf;
 
@@ -991,15 +1000,10 @@ static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
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
@@ -1047,15 +1051,13 @@ static int mbochs_get_region_info(struct mdev_device *mdev,
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
@@ -1063,11 +1065,9 @@ static int mbochs_get_device_info(struct mdev_device *mdev,
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
@@ -1121,18 +1121,16 @@ static int mbochs_query_gfx_plane(struct mdev_device *mdev,
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
@@ -1154,9 +1152,11 @@ static int mbochs_get_gfx_dmabuf(struct mdev_device *mdev,
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
 
@@ -1173,7 +1173,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mbochs_get_device_info(mdev, &info);
+		ret = mbochs_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -1197,7 +1197,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (outsz > sizeof(info))
 			return -EINVAL;
 
-		ret = mbochs_get_region_info(mdev, &info);
+		ret = mbochs_get_region_info(mdev_state, &info);
 		if (ret)
 			return ret;
 
@@ -1220,7 +1220,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= VFIO_PCI_NUM_IRQS))
 			return -EINVAL;
 
-		ret = mbochs_get_irq_info(mdev, &info);
+		ret = mbochs_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -1243,7 +1243,7 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (plane.argsz < minsz)
 			return -EINVAL;
 
-		ret = mbochs_query_gfx_plane(mdev, &plane);
+		ret = mbochs_query_gfx_plane(mdev_state, &plane);
 		if (ret)
 			return ret;
 
@@ -1260,19 +1260,19 @@ static long mbochs_ioctl(struct mdev_device *mdev, unsigned int cmd,
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
@@ -1280,9 +1280,10 @@ static int mbochs_open(struct mdev_device *mdev)
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
@@ -1306,8 +1307,7 @@ static ssize_t
 memory_show(struct device *dev, struct device_attribute *attr,
 	    char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
+	struct mdev_state *mdev_state = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d MB\n", mdev_state->type->mbytes);
 }
@@ -1398,18 +1398,30 @@ static struct attribute_group *mdev_type_groups[] = {
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
@@ -1434,11 +1446,15 @@ static int __init mbochs_dev_init(void)
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
@@ -1446,19 +1462,21 @@ static int __init mbochs_dev_init(void)
 
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
@@ -1470,6 +1488,7 @@ static void __exit mbochs_dev_exit(void)
 	mdev_unregister_device(&mbochs_dev);
 
 	device_unregister(&mbochs_dev);
+	mdev_unregister_driver(&mbochs_driver);
 	cdev_del(&mbochs_cdev);
 	unregister_chrdev_region(mbochs_devt, MINORMASK + 1);
 	class_destroy(mbochs_class);
-- 
2.31.1

