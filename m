Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D420D3466F1
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhCWR4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:10 -0400
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:33344
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231233AbhCWRzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lPcqXLo5mSFiSqY5RXix6njmklYfm7wuCE4HTIpyp4BJRmQJ1Gd7EZrmMhj1BrdIV7vur8hq5jkeneg6j6+JhdCb9pdBCmdEH3p+W9SyqO5V3AvORJ3iuXXsREwfbGaPz8lUQI7vt7KV0/bqupJJaFZ8ezDqpNlqArwC/JqYttcWjEaPt+cspUx8eKE3ZDnkljG1PxSl9MalvjGVMZF+46cObUFPB8i9rdd1RPRER4NdtSwr/4sYoPd7YrFWa91vceQ8loyFS+OCStUzyNft40oVKxwj0szFi923DiZGQynONy48w7XCMdwZLpCr0p+qR/C2wWMEBHYS1cN9WSzl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dG+ZJxYRtxo+uI1CX4c3eqjEmj+WO7rw943voWo+Wc=;
 b=U6CxoX3YjKTBBHthOu+WYvqpPuLLTO134bGDjd2qES8nIYKXgyHPqEsnNBXF7qQj1iU9gmQTdcGoVU89E3QCJ2EEJ0qCyzJM7bd/87+RFEpl605C3DP/JU1gTd3xdU5CZ08ikqD2hEwmwKwht4toN1akKvDsTHthACqOiCQFX21a5M2ydbP71khd6KETfYKWk8QxmAi95S2MUwefJo0JW7x1/v3Aoik/lSja9TCked1jCqSf47oPaHFtpL/RpcDx8TPAFKMHxPG+9JS4I+04nnUqjDxi1U3iXWat+PhJLtiHwsXbsF5WaEHKCE67a7QIAerZ36TKuqrnP4+8Swr51A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dG+ZJxYRtxo+uI1CX4c3eqjEmj+WO7rw943voWo+Wc=;
 b=UjxCey+4zQFnD+aefvwSay4SjXKVMLV51Rv8cbszzNeVBWc2+tYZ6tthh+3Ap68jg/q37vKjedIh2r+GkaO4YzIRlxsbwQm1cGp9svPHEdPyTgyKkknoUWrAIel+H4+rGX6jARMlQo3IZq9G37q2scHSLoyx5OEHSD6LUI9f2iFFmW0EemLS53taZnf1ozirrZaz7Gxl46Z5L7Q510rFdC4oh3QmGFW/KLNbklxFZK8UNiqorL1BQAYeJH45mh1y4eilvAUlcYpq/7XPFj2uegO8p1MGgfHBk5esTVH7B/cIxOb71VobMqsKA4JAaCmT/lFzcmcrl89rFbYo9xBAnA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 23 Mar
 2021 17:55:40 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:40 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 13/18] vfio/mdpy: Use mdev_get_type_group_id()
Date:   Tue, 23 Mar 2021 14:55:30 -0300
Message-Id: <13-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0196.namprd13.prod.outlook.com
 (2603:10b6:208:2be::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0196.namprd13.prod.outlook.com (2603:10b6:208:2be::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.22 via Frontend Transport; Tue, 23 Mar 2021 17:55:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001chD-Mr; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c37309dd-badc-42c4-cf5d-08d8ee24de13
X-MS-TrafficTypeDiagnostic: DM6PR12MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4483E2319BA89DD9D689F78FC2649@DM6PR12MB4483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k55bfNtl/VpJCggpP2c1PZMw4NNQmTT8QsIB/aMs3E2c4Rx6BCpQcrZn+KMUgnwY6UjMrKzw+iQPz2LGse+euftAkf/QnkotjLTSpG6IQeLJ7v23NUvjl/48IuHfddaCtk4Mxypv66IWvWl98QhLpS6UOJskmaU4vh8YSmu6Ta/1CgpUuv2nhVVNyuRLa37ApKV+7DKy9qsQIGLPnZ2si8wC1eAaivfvH+WQ7nryqbtAuzSLNwKzW7VB7x5p6qSF8Utfagi77kMmO/i12zdEr7NDVpEz6T8Zd7P4RlhSJr0HpGxmeSsiCp00x0Die/NrpYDSt4DZeG9cbALWIPxaAKI/U04naCP6FNAycQzH92iP0Gk2y+JHlpTErvECgLmvRpPDGQgzMUGQ2S0POWTQMOEc+Nd6AYdXI4TZXXM+SwZCdbQStrkaTFSVzOl4G+s89KQY7W4/33WfdjCSAkzIOKkWyytN+Vt79p7+U2xjlwTtt6jOsOEsZswLxsK7/clwzG5dysxWtMZ2C86ZwuHI2+oXGdpARh/qBOjfv9HeCmix0yhsfMBu7fMVJQaO7j8VgSednAxw9rXeDY/yOwU4If8Nm1k7tlwg5oUPCQ06p6ymkOzzJbWmlPUCUqTt+bcn2WXGVBt/8r7nEf0dhSFIw2grftTlsurbobpFNimGScg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(186003)(26005)(36756003)(37006003)(5660300002)(38100700001)(66946007)(4326008)(66476007)(6666004)(2906002)(66556008)(54906003)(6636002)(478600001)(86362001)(316002)(8936002)(426003)(9746002)(6862004)(9786002)(107886003)(8676002)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ljG2fpKxOD6qGT4u1gjEKuC3YquesfIhLSMsJD9uHErW+8c35AYM9AL7K85L?=
 =?us-ascii?Q?B7db8ufg7eM7vO3RjX6Wgx9wSp1lUtbNXrozANfaCb1ZyRjpXNYxCDEtsLa9?=
 =?us-ascii?Q?cjSBVSfOwNkEertvaeosK5EuzqAkp9KLqcSUkgkWnylY2uUnc7yxYD7+GSgZ?=
 =?us-ascii?Q?DGAxVIxMs7AI4JAsGDJ0p/nEeeu/JwiuSqyyR+cIjthor+/LT0PMrwGbsQt1?=
 =?us-ascii?Q?vuBNIiFziiR9ZkI0JF0q4jxPLWwGAPiLdeFHyU20vvYfjyMrzwoS9+pOLkYD?=
 =?us-ascii?Q?u9ITgNhXX/F5r4ik3D/8steqDMS1kJBy/xhEihmHSlunMxMQoVA+xY8PJegp?=
 =?us-ascii?Q?j4pd0kYXKZVaEmqUfa+HLo/VM+9+aEp1KIv88yk+Z1+AXRhInPmSxqF3HzHh?=
 =?us-ascii?Q?dZPUeTnbg8EsRDUTPsWF36yz1hVVajFinf/v/hjDH/p5ty0qtKnUDChQtONy?=
 =?us-ascii?Q?VSxtwSh5XJ3jFFHVHt3PBmVjW0lXLaLlc1PdAL/jz3ie7f08v+1rgpXPvFXa?=
 =?us-ascii?Q?FyCwQ1lGkHJLeDnIDZDotNickyGroska0rILUb49Ly+zhvml27Ysij8PnqBs?=
 =?us-ascii?Q?hhIutgkQiI/xbV8IIrEFN+pNiYNWlBVB45mR5YjDlQI6UmQYRUDeZarpEREo?=
 =?us-ascii?Q?ySSJDtrbE/yO7kosATQceD57Cp41ixy+H0RRYDQrIxPlQeGIm00i4/2lSKNj?=
 =?us-ascii?Q?9gVlDJgDoJxFi5FX6bji9qsaBJlnl01iP6JHvcKSQnGi4Knz/jm2I9gLNcVm?=
 =?us-ascii?Q?FslPuaz8dzV0yW2ssteOEKyzLK8cPb1V3E+raw6rFK+gSbg+py23VJ/Y+yT3?=
 =?us-ascii?Q?/K8ScQfdzGI10CenXLcibNQMaqUZi68/FHN4zbab26t08sZlcYjNtoWfu2RV?=
 =?us-ascii?Q?sYD+xnLai1Iw0uNqBB3cPl1yxOiYswYrNz6dNGMl3mgHdSkPKF1fSNVDUgPk?=
 =?us-ascii?Q?w+dbk66Dp6HFxKi5kZNyqGxFA9Uh7kskrLe5Oj28K+Kt7ahGUbAt+augCgxU?=
 =?us-ascii?Q?U3ZcG1TUvh6bhc17MJxuy0YFLq6QuWjwh+zeD+1iyHvM05SxbZS4ULIqlnOF?=
 =?us-ascii?Q?hmNXCMZ45CiGP17Klg3bplh96jRMIaQURqQKCja3l7+qm9zVMYUHUmsVob+Z?=
 =?us-ascii?Q?8aPrP6R7+QdLWivw8WrwL/dVRTzpJxQgbmKHJK6UNPBLinv1ZiAW+dFbQ90l?=
 =?us-ascii?Q?RiaZ4lZRLofvondzJf0sE/+3Uhpg9mbNAdyGNqiv85FI+2Ychq5SKzSG5EgG?=
 =?us-ascii?Q?lSNkRFOKMJwAZZOa0luY8obgJAgIVHi/OIqzTYrO/t5IFfy3cl6iZfKIiMHu?=
 =?us-ascii?Q?GQvXzggGMzbB39d2ebH4RRfS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37309dd-badc-42c4-cf5d-08d8ee24de13
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:38.7877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vu1KhjNPFpKBTcACtBggEKNlWZzYHQTMKXwfUiTu+6G74Gum9RpyQybFO93IOMOp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mdpy_types array is parallel to the supported_type_groups array, so
the type_group_id indexes both. Instead of doing string searching just
directly index with type_group_id in all places.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mdpy.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index d4ec2b52ca49a1..08c15f9f06a880 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -99,16 +99,6 @@ struct mdev_state {
 	void *memblk;
 };
 
-static const struct mdpy_type *mdpy_find_type(struct kobject *kobj)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mdpy_types); i++)
-		if (strcmp(mdpy_types[i].name, kobj->name) == 0)
-			return mdpy_types + i;
-	return NULL;
-}
-
 static void mdpy_create_config_space(struct mdev_state *mdev_state)
 {
 	STORE_LE16((u16 *) &mdev_state->vconfig[PCI_VENDOR_ID],
@@ -228,7 +218,8 @@ static int mdpy_reset(struct mdev_device *mdev)
 
 static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 {
-	const struct mdpy_type *type = mdpy_find_type(kobj);
+	const struct mdpy_type *type =
+		&mdpy_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 	u32 fbsize;
@@ -246,8 +237,6 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 		return -ENOMEM;
 	}
 
-	if (!type)
-		type = &mdpy_types[0];
 	fbsize = roundup_pow_of_two(type->width * type->height * type->bytepp);
 
 	mdev_state->memblk = vmalloc_user(fbsize);
@@ -256,8 +245,8 @@ static int mdpy_create(struct kobject *kobj, struct mdev_device *mdev)
 		kfree(mdev_state);
 		return -ENOMEM;
 	}
-	dev_info(dev, "%s: %s (%dx%d)\n",
-		 __func__, kobj->name, type->width, type->height);
+	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
+		 type->height);
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
@@ -673,7 +662,8 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t
 description_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	const struct mdpy_type *type = mdpy_find_type(kobj);
+	const struct mdpy_type *type =
+		&mdpy_types[mtype_get_type_group_id(kobj)];
 
 	return sprintf(buf, "virtual display, %dx%d framebuffer\n",
 		       type ? type->width  : 0,
-- 
2.31.0

