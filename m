Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF353466F4
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhCWR4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:15 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:36673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231289AbhCWRzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aen986qm/mKOyEs+xrwTELOcTEUxcYIlfx7vxoFVIy+R9B6U0an9bPKyHD7DFTx7uEjr0kx8zYxEd5bBGugEI2c2nURJLT/ZOI+pciJ9Mbz1UsgI8GLt4BfGo1vUy9hTlgcRTb5m7jLMy1V0g2bSltT8vShQoRqWqI6fLksuTV9aWTGAekinPTq6MnFws7cNATZxSbC0bjyjEoxpsba61RE0moT0LgENN4YdpFFH4BisIFLCwOhMJRIyElmELO0EPi4SV1hUjHaDGdOk1UAS/f8o8G72P8blPlfQ9kZ4zxwiqME6RIY9hvzQmaOTw+BVlb72Si63QB39UaY2Jus8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HixjnyqaX6yVAxduJa8LIeWJcCZOnXIo9+8W1iRdeaI=;
 b=Fckra1BMybYXWYNTr82q4ifUABVaZe0OVsJ4pIL/WMqAYALnf475EjjigXlDQqmHWhjdm29iZ8cYVpdWApVo/bJ393f6i77ds23FgR0oMSPsFzMxspjerDj+rwlkCJXAgge7ysfmK3QjnyL87D10vnAm87jpp6tW5Zr81VIkr4ObEWsM8H6zLSTVWxrQtdBGEjPJIcB3gAPd5ubIgaFNZIfjr2CwdrlVtlJuZALUnQWsNB4+Cikxmkkxn7maP3C4uYuQjtYNGYQcaW6d2RLpXQiunrMKBx/OQ7VbHWJSJ3JQk6kB+YbJjIUh/7wz8OACMyFeFcskYhCazPuM3zhvuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HixjnyqaX6yVAxduJa8LIeWJcCZOnXIo9+8W1iRdeaI=;
 b=ljtjnF+HtyqXFAq13qSDYp+dLll3gAxvCjBPR9eMe5iOJdHBhCKnYREHEzMeOX+H9oN9Z7mMjWCSrx+27KLzJ2fbVs+Pmz5qofugfebBOGAPcUr/ADeo2pHzLqiloKGbLqs8l84aO3reEaVDlz7cmsIBKMsl1WpFR9MmObO6x1jKRd3Ro7powegmRux8nYxca7UB1OngYYxM4TE5xQAFg0PEPs/h4NG7I5/S5LnBmTTQuIFyYGdXwmORiDDfbLgdSOhaMx1gCosqQdDtczQl1QNETxLv45pvlaPpYxHLLPBicfkEykNcKC8pLCO0acdKDTQYlbN4ICICYF1PzhKv6g==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:42 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 14/18] vfio/mbochs: Use mdev_get_type_group_id()
Date:   Tue, 23 Mar 2021 14:55:31 -0300
Message-Id: <14-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0188.namprd13.prod.outlook.com (2603:10b6:208:2be::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Tue, 23 Mar 2021 17:55:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001chG-Nn; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4fef12f-07cd-4541-0517-08d8ee24de88
X-MS-TrafficTypeDiagnostic: DM6PR12MB4943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB49438C65D253E8FF48FEB004C2649@DM6PR12MB4943.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69NXHs7RazqQfzPDh2hTDIYFPN4bUUUxxZpTHWNgQcFRNTCUUyKJr7jcO1qafsEHcvd/cJiwO7ucGtIbjaji2UKfmafEm+5ljjcz9KhyIkIrd1eKUeMYBS67LLB7H0CIDyxKz8UELPmIWEvZnRAU2Tag3eWyc7DTkifSuoiOQECI6mSSqEZLv+Si9WbrtIkzTrMEPZstpbmHLATCX/AClYw8mn5C8x/ESSU9YOwN1jaSouNMkc2n9/xkbE96LF72baxOVPSmo/0W3mZCkcA0cEIDUqcEvj/ilU3HJuUP+pCQ4+2vTjXtak/h6vloT11TOGhH+YX01xR7IbaKFFvG+Yf99zTKZl7MqecSf1szv7YZSss9RHn3I6U8A3q0ICJFXzfYT2Vr+wrLTJtC5ECvjCKPNgiY+9GAonXAqVNRxyfbKy6jiw13mCxZOux2HWI/EA9G7hhdyKblyk+hadR1TQ5n+iUdVx37azI3H1RGo2Og1pG3S5Fl0Uwu3lpHBIdbKvJqsuFgkmdu4nxLmhA7B8ckgdQ+jiLv/2bQ1A7OfEDa2YiJG5OajWO6gnfwKiRdD/MkQdwTK2ExFaypxfl3kRi5lFukzuxtRqj9toeOEqC0U4+7aBB6Tzp7m1egow5r34Ezy+rnTfpfCmIwvRZUMVBTe83Oarw45RaXk1wVaio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(37006003)(66476007)(186003)(107886003)(6666004)(8936002)(36756003)(426003)(86362001)(54906003)(83380400001)(2616005)(38100700001)(66946007)(5660300002)(478600001)(9746002)(6862004)(66556008)(8676002)(4326008)(2906002)(26005)(316002)(9786002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kLHHY0DaKz1VC9vjtZF6VdzwNInaETArjLsSpivz4ajed0LwN3HLkdIfkWIe?=
 =?us-ascii?Q?50+1q1a5NeoyrjOJRweWZ+XkOKN31mxhPEXM62mD/jRvvik3XZR/mP9XkxDr?=
 =?us-ascii?Q?x3JGcV9BIWpbVjtOOOFrQhjvmxkxz1u5Umg1O5oQG+CthJ19FMHffQPi1iY2?=
 =?us-ascii?Q?Ob0UubPAGcE5M/FAqdDimr+FNHQjBpP2S5Ix4CQzn8Bua8ri+JYUmLyB6KZp?=
 =?us-ascii?Q?QTNil8uzDu4lsa83OqvJRPGIRj60W1EKaCYvXqbe8qLFXLuJcf0osu4YimlZ?=
 =?us-ascii?Q?+VzvyIigFpPPDqKpW/mv51rHWtC9Ko2xvB9KwtsInrxyFMWuYOrAzfuWRNFb?=
 =?us-ascii?Q?0KFUTOH9gplrt4GOYjQbUyGKgPgcEq1FHkB6GNzTxIrLoZW8Z+uFzeBasfPt?=
 =?us-ascii?Q?OFGqFwVr0DGCAM1tsjMcGmcXLvgFOzND0vxKmQ1iNmyh10+ajVTy7tCtqe/d?=
 =?us-ascii?Q?ROKfUHikKGVNM+ETiMaxfU4ggj6zuBtTAnscAYED9GvMdcoOz81HLLyEJozg?=
 =?us-ascii?Q?qWf+ocbMorZRxg9GwU6gkbRyxj8hX7ti4yf5SjJm9ilG1YcF+AdMzT7kTTfI?=
 =?us-ascii?Q?d+Y6H1n6E+kYqZDiUxfFVj8yDapYySxmW63VwitefLTeHe4EkGFIl3MOgJAz?=
 =?us-ascii?Q?hxsOiMz60ULU23QUknc3Ldg64q7tm51LrqgXs80n6HFN8hOTqe6qi//ARSpX?=
 =?us-ascii?Q?dpykTtw8glJX2UQmkBDRiDqd7fRcRiox68F6VjxejNBK2b3sesaak3WOrx1L?=
 =?us-ascii?Q?OUjt2doseiAeu65vifBUMnLsQn7hoJwY/UbQf8AJ4nVrdNGTUJbWfP5hbsb3?=
 =?us-ascii?Q?pkVeJ6s/DMrdnL597LlRzTHEJA9OkO/PrvFPtByUJBR6DMiJSvN7UTiPNwrz?=
 =?us-ascii?Q?dORoJTKN+Uy9kx+T1t/7LL7XkI6hgP0ah5mjJjj+7DJlnaZBLdE5lnq3k9a7?=
 =?us-ascii?Q?uCyIBV9O28Zg4uVARXqcS2MOzstz8V0aFpNvJyizuk38HlGwHi2bYsJsdIG4?=
 =?us-ascii?Q?OJCovjEm95QnGgzKMmOyO32U7+1dS8Da/ExPfm3Dl5H5QSUxJmjABzFUISyp?=
 =?us-ascii?Q?XtPBf2Yi5dacrzVUphxcLQvadOmO/lJi33XZ3Flkmhkh+aePjT2JIlTeLoak?=
 =?us-ascii?Q?9oy0EPxnr67LpQ6U0lK4syynyr12Z4z7vz206ipCtsVPyM0CrneusR2y1ssB?=
 =?us-ascii?Q?4HVK0GUH610f/zznH9M1CAArUS4HpZNEcCnyh6OpFCa6oUqVgFdx2JtfLjQi?=
 =?us-ascii?Q?PMONonUVXUoU0LEIMTWznwEtxW9mF+wOGDz0opb/jVtFzD2krABQ7ieDR4ql?=
 =?us-ascii?Q?xhJXKqCIiqi1NUCBX9oso/W4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fef12f-07cd-4541-0517-08d8ee24de88
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:39.5373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9TE71FvXX7S/ZgNGj62zojWfmkJ+3ovYsQ5W2YBjubjzcZJLa1SkTHrwCaMZAYY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mbochs_types array is parallel to the supported_type_groups array, so
the type_group_id indexes both. Instead of doing string searching just
directly index with type_group_id in all places.

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
2.31.0

