Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFA4355C6A
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244917AbhDFTlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:08 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235032AbhDFTlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:41:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FWFb8OqxkAewOHhmLwK+Xga+szDSQYjwQimqMpMUYpqAIaTTx53+c6mTDU79d+8HkmUZfX/Wk5aUzeuozW9pbbHuA/2D/WAJ84qDgvgCpoFrV8lijgTHRqM8HZXhf2VcGFX1587EKP3buCvnAaWe1sgspgkRB0h6qN7yErfp2KrPq9MW6Uqx6oIFmBuTW+r4pjWjAPFRggs2LuUMXwlSRdkZNZP3Ung7OoUJAJZycgiEiKJ4rMMmJEJ4b2f/W1g2TO8t/Pmff8RYjKU3EwK5HfHtLJTd6mEG+ew1ng7/RXosoI1GU614Y+nIgULX5wwJQelfLbPBCd5F01zgJnbe+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPUQK6SRzWAqaSFa435Ur46M+774ajpZWQ7Q4vd7U5I=;
 b=S9iyAFTxV9afupZvIMngz5n/nUrVTZ2uXM+O7wNsSEwO8eZdNHd8TbDG2N7dwIh3ajAPAqJbq1VbVol2LibN62Sq6IuT2CpzETIKfXHjm502GYwQyw+oeue480MXShWhEc9S4dSUo4AEfpn8NBx/Y2fDoJQEINBpz6My3GVHPKj6ZSK2pGa6VmDmrcNqDXDYoSxp6iYJNC1a6e5aW0dGMoXUwGciMPE7gdi7tHB2Hv0z4SXODSdU5yQBE8iVQObtm5uPwSjx2wdE2X4pYeKoDmeAQIDSCLyHkrX+fUJiGLgY6YNa+6HbjAsE6FU92rHOiUENFlekwqa6LW+9ctXoPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPUQK6SRzWAqaSFa435Ur46M+774ajpZWQ7Q4vd7U5I=;
 b=gb0MMGf6tvj8i7lJUKrKkLUwswLJ2xK9wejyMpdTm7sd0gt05GAVRk741Q4mY0jXCE/j5ki+RLRO7jKlhdVGRwt/9r/VaSHSm9eo74HPqWIOr46BZzfWWbKiU+Ljb1tWgnv0avKTPvLfFDhm7QMvymgG/3jxr0Lk3eKVwRWkjfQxG9GSEtiDaF+mo4fMIaokbtFcqr8jqhcV+bOZ3AR0N15zymGrWpet9HcmGEBhUEPgYrsMID+pTGtP3Rq0JU3aBieeW3wzdTRA3PMBjm2te+4TgGUHGDwDG8AsoNubY2xkMwX9k3CQR6+Y35fsV+StzZog0C0FQo/g85H6UCFVUA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:51 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 14/18] vfio/mbochs: Use mdev_get_type_group_id()
Date:   Tue,  6 Apr 2021 16:40:37 -0300
Message-Id: <14-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAP220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 19:40:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXi-BX; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fcd1cbc-455a-4d1f-4082-08d8f933dfd6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB423546C3E25A144DFB5759D9C2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSHZNzqw4cLYIM2NkfC3Yj4SgLx5PYAyqUZ5TJigawoERXCiPQK2s2OMGvFTqVYIQ6p4acNtiCfIco86E0JOo9GbNZJGPB0ees04G32w+p1pNXHqYEER4/HI9KONVUAG9vvI2l/7ZDMTocgLJe/PKLmCClsN/79JCQ2reD0f/VIbZKeQhSzy8FrZOT2zIFJyjsdXEoAULOc0YGVjsPfeacyr3ymSwHJ6MnIb2IWKSdezxZ+2V1HepIAp3G1iuJ/8uNHOXtvwTK+UV/JdWmRE4n2ZcsiYGaxP0L5tBIo+mLkwysro9S5FWvgSMb1QQVndNxLp4JJMh1gNw4RyrPBlqWg5UvW+Cmn/2jkg2UD3LH0m3k3mk4MJRsKFIM/hR3awoMeo8IMR1QAra0qdK0kr63OSUg+f6mDrE3uYNn2Ofu/koott6NLMwVE3dy8cbDguIXOTvgMdNgc0lV9MxVfKybyUHp6h4Skqg35yICrmIQUTFSb/qbbyeEV2gG+9ajXwAmxGdcL2boQBoiRyLUr3Alw5c+z7/uHAaKbc697tdarkDuaoyemQOedeyeH7Rh6aTsfikHf2kl3RZPQmVlrFwqWZvoo4dBPQ/DBZjJZEBYKkclvEDwsSzG+Ff0PObBLzUZivubNhv3uGm21g9INWWrPP94nucHgw8H3OqUnZWZo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(6636002)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(37006003)(4326008)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dUat6f0JCAdHd2r71ksT+49i5RVIJZn8NUfk8p+EKcM2AT3y1x4YFRcExuyS?=
 =?us-ascii?Q?F2K59Pt4P5Cv2P6xzilIVbZKqmjE7BvPWrwBY5oVilhuFKOWthVI7N9gA3KW?=
 =?us-ascii?Q?4LwLvVQELxDKOwezq7Ovo8kcJtBqmSrZfkC4exeZO8sXiw5km94zydPwzqBV?=
 =?us-ascii?Q?O5gFQBWOojOZ/WokzxeH3AfmHqjR8CdtXQIcB1a55k8RSngGxtOEpfNsHvoM?=
 =?us-ascii?Q?4n83OS9l8X+eH/I59SuhG0lM6X8dw69OhO3DFRBG/i824EzNCFOE0OyTplR+?=
 =?us-ascii?Q?WLBBmRnNwmpaHxvol4+FVdKVHjCkpQOK6Wu4qbcINRfY8oUBbnjOw6f3WOL9?=
 =?us-ascii?Q?SBCKraNeNnUrmjwvn3e1cdoScBlZHEjwsbz3FcXrTEiwY2RW2ibapBa2Xoal?=
 =?us-ascii?Q?iuKYjtu+o4FdPHwj6gvG7J3xib8otCpvT7o5xHnSX+VtfZZdjRTkPv6IHu81?=
 =?us-ascii?Q?a1dWSxn3hKT4tcDMVNOPdhiabJeHv8967cOariTHOz7RbUBuZvrDSFMrmR8G?=
 =?us-ascii?Q?DEOANSn+Q6r6Sdem7M3cu/jWDXK4AysW5SJKG3UvxR8+a2zfORX1Lw8uAdPp?=
 =?us-ascii?Q?qcBuo2FNce5mhUghPrw8LQGAfB/ORSMaBFpsf2TsqdfkeAvzayj3k6y8Ra3L?=
 =?us-ascii?Q?6eNXJBZ6oAHdkmpNcs8++P6SNhGvgVF0yFe0ibPvaWLTGAsOQBAMXpX2otBR?=
 =?us-ascii?Q?zP/h/x0UkXPkBhv7sFkM3jJAD0LCs4CDwgtAVN7VJEwITBtWGOz2mBTADs8b?=
 =?us-ascii?Q?qQ54kpc/aFsinVdOxXwYjrw4ItFaHpfl9JpTJmaUAaURqzrB3I0cxVP5HSQM?=
 =?us-ascii?Q?W6mlpfAtGV7u877ub1ChFY1Uj+gMPHButdqVxMy4MInre82aYAqFLcErwVYj?=
 =?us-ascii?Q?mLIWb8NLwzqC6am/KiTlJunn4qr4AOnlvU5dAax0YJyJwD6HzBRguRVkhSeT?=
 =?us-ascii?Q?BdXryA3KVPss8spfCNMhAkzL0xg6Iu03/OeKUHRV6jhwKvat6Ra1WLFIqZ9B?=
 =?us-ascii?Q?+xLBooHYdLudBl5b1hqJAmjMVkr2l3ReQGnlZpQSeId7slhA81W9w8kElKdt?=
 =?us-ascii?Q?5vNCRIzKFrILYMiyr1xlIwCmo/vETueLUvVF68PMlsHUu0ImyEZDOE/qUh7f?=
 =?us-ascii?Q?0S7MwSmA/f9MLfI8hPQOTp8PymcchsAzHJdPoIp64cdbM+M8qzs2rViRlK7s?=
 =?us-ascii?Q?iS70XfpCf5IJ07VlNeWqr15214X9rSDzpEddi2v5eFDHnrQswJjH4IEGgu6T?=
 =?us-ascii?Q?ydtSBxft+jK8kJ37QGB1M06ru4vJpAp4WqS5CmVVicSxHiA3qE2I0g3Ffkwz?=
 =?us-ascii?Q?dgb2ZtNnpAdSoMrAEuSsiPVVpuIFDI3j+q6f+nVb3kmrPw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcd1cbc-455a-4d1f-4082-08d8f933dfd6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:46.8532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+lrh5745gowm+V2FSxt4YkSPAIEXTA7xyKysW8GyXAhxmINpPWffVv/2jJlLfal
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mbochs_types array is parallel to the supported_type_groups array, so
the type_group_id indexes both. Instead of doing string searching just
directly index with type_group_id in all places.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mbochs.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 365afbe2dea558..a1af30df10a2ee 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -205,16 +205,6 @@ static struct page *__mbochs_get_page(struct mdev_state *mdev_state,
 static struct page *mbochs_get_page(struct mdev_state *mdev_state,
 				    pgoff_t pgoff);
 
-static const struct mbochs_type *mbochs_find_type(struct kobject *kobj)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mbochs_types); i++)
-		if (strcmp(mbochs_types[i].name, kobj->name) == 0)
-			return mbochs_types + i;
-	return NULL;
-}
-
 static void mbochs_create_config_space(struct mdev_state *mdev_state)
 {
 	STORE_LE16((u16 *) &mdev_state->vconfig[PCI_VENDOR_ID],
@@ -518,7 +508,8 @@ static int mbochs_reset(struct mdev_device *mdev)
 
 static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
 {
-	const struct mbochs_type *type = mbochs_find_type(kobj);
+	const struct mbochs_type *type =
+		&mbochs_types[mdev_get_type_group_id(mdev)];
 	struct device *dev = mdev_dev(mdev);
 	struct mdev_state *mdev_state;
 
@@ -544,7 +535,7 @@ static int mbochs_create(struct kobject *kobj, struct mdev_device *mdev)
 		goto err_mem;
 
 	dev_info(dev, "%s: %s, %d MB, %ld pages\n", __func__,
-		 kobj->name, type->mbytes, mdev_state->pagecount);
+		 type->name, type->mbytes, mdev_state->pagecount);
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
@@ -1349,7 +1340,8 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t
 description_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	const struct mbochs_type *type = mbochs_find_type(kobj);
+	const struct mbochs_type *type =
+		&mbochs_types[mtype_get_type_group_id(kobj)];
 
 	return sprintf(buf, "virtual display, %d MB video memory\n",
 		       type ? type->mbytes  : 0);
@@ -1359,7 +1351,8 @@ static MDEV_TYPE_ATTR_RO(description);
 static ssize_t
 available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	const struct mbochs_type *type = mbochs_find_type(kobj);
+	const struct mbochs_type *type =
+		&mbochs_types[mtype_get_type_group_id(kobj)];
 	int count = (max_mbytes - mbochs_used_mbytes) / type->mbytes;
 
 	return sprintf(buf, "%d\n", count);
-- 
2.31.1

