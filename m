Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF683466FC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhCWR4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:25 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:36673
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231344AbhCWRzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeAtgEGMNKgao8LCsLj2kC6rLGk7+AWYl8hifFrGqx6oKnuRfpdFif6Yo6vd2Qc+YsG9HSXAptRddHEnV3M+YMOjj7Rx6D/dFQjwqADqRuwi/AuUEPpjVo3pnfRk7vg2ASW8QivvrfryJkx/I3qH8WAK5URlSw+HxKsXxdyrwcHkwEdjXFLzQ4EDK63qDIDuE5Qofgl6etcSdoWoUBW0IEjxuDAZkZZxne9ve24zPzcn7kYlDRF9gGA5tX/7URsHcvpb0w/TaXMjxfifNk5xju7q14yDqRAgXwneZEl83If9RkHxMlF1qnNt2wqtfIkyeasiVTcGQG1SQZF+7LnFpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tkys9WcGQ4F+7Lx5xg8CqqbE0vhRjctcm0xqW+9IFTs=;
 b=BbUQIKkF1J6j4i1Icn9ss1v21DIevSgT5OBsfKejZotKm6XPnYVh64e43r+SUIem3OjA7y+BLW12Jp3IEDpEeLPzjpPTP2fFfWpJ/j/pFK3BWDu6lVdkjMh/c45N+6evLT55v2aALCFHGmJrZ1V86PkTeiqX9+mnsDSWLkNeVasI7pwWuCk/yyeAaizyFmnNaO1wMIKJDcfKxi0XAWc/cbwfHvMo0ULS4ShrNX4D81rn8+nc80nldyRg4d7JZPwAp1tfqi+tNUQ854rkoG73LsDLp7GcFJWziEdp4tHbozTONdYvHvIkfvQ9V6xH7ZoF8xPLZ2LBh0itZ98iD3X7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tkys9WcGQ4F+7Lx5xg8CqqbE0vhRjctcm0xqW+9IFTs=;
 b=sFnnUxmBrlMWX7/eTdAcQ7b4WrVkqqF0b+4hZZoyONzyPCX9IcyuPhKfJtFFjddsHDPIaBgLDcddLgWw1Cd6x4X+NbWFsZ9ZyTdAe6EyXR4T2Mtb63GewC+p+zwvq4BDVCTybk38b3SySVsXluGGR9hFZHP5uUxuigGZfXwV+2d8BhfrWiEdobegN10J9hWEm5MARgvOVJq1N+L9pfGOJptRUS+RPr3MGAUlNFt8MR1HNCidq2l9cZBvgQp8i2NpMOxQ9hqrR5sTFRQHpjFGLZaLOoEF5L/6SbwpeC+4Wyaew+PUVB24/d96KP1BBSpR8GTW/6/rDxnHzEnK2f4vqw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 17:55:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:45 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 12/18] vfio/mtty: Use mdev_get_type_group_id()
Date:   Tue, 23 Mar 2021 14:55:29 -0300
Message-Id: <12-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL0PR0102CA0029.prod.exchangelabs.com
 (2603:10b6:207:18::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL0PR0102CA0029.prod.exchangelabs.com (2603:10b6:207:18::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:55:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001ch8-Lt; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9af3552b-7214-450f-f1a3-08d8ee24e011
X-MS-TrafficTypeDiagnostic: DM6PR12MB4943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB494397E2242BF8EBA73C60E9C2649@DM6PR12MB4943.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:298;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q9WcALfC8p/Sydg7/xK7THkVUqZtpz0Hm8ObVLf0AOjLtWJkDCJW90kOggkJnnc59ansHhLQHISIgtLku55vreIisLmUdM54iA/VXh29W2+xl5ifOWZvqGGNpXrKUOOcoMKAXmiMau1McbgTKi5T6GOvCebDtPIWILg9L57lgePQXashCmG6+waqRcAajHjfTiNZWNYeHlgcRZB2gCcJDX2KFTiaAuO3KS1SrMCPIJFfGYbHBhRaWHMBpWL3UtYAJIy5QPIXYWdF6SDiJMn8bJUtCW6dAgOFClqEtSx9ZB1DwQKTUQIVfSABFlgJv+1IoZ4rSvPVf7gd/NXo1VkhgYFA26puU+yNSX9ZecIe/6flA7dA4HjYy8j4OQHDy7ZzanDS6h1iS6qiV+e8kcDj78haZne1LchbcfFqbZRy7WM2eopIsGSyqElvLC0ZJazvl09fI+SUplxn1CiK6icWqThUs3Aq+lAbHqBpM1z5LnGddd8Ip/k7lli8LWGMSdOBJ/r5nj/ien/uVLm7AAiUF06nXPiRsyV+zEN6NOQ85I5BSWmhvcH3qFgNQUURk9ldpdvYy98prrF8FOYCUJXCgCJUy3UuQEULEXr4pi0dgNZ3St8g4Jp1wan7sWXVNOQp/EY2RsFsXse5r5lQGMprfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(37006003)(66476007)(186003)(107886003)(6666004)(8936002)(36756003)(426003)(86362001)(54906003)(83380400001)(2616005)(38100700001)(66946007)(5660300002)(478600001)(9746002)(6862004)(66556008)(8676002)(4326008)(2906002)(26005)(316002)(9786002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rKL57SxSxuqMkyzI07CaBnTI9vNuR/HQKPL4vZHPtdU4UuYyrtklMM+kQTVj?=
 =?us-ascii?Q?/jR3x2PgRHn8CMEmX1FOBIG/fmFoUuxQNK3E/F+lkHT/Zi1np71kDTDGc6gY?=
 =?us-ascii?Q?ONsDxL4SeHH4tYmiLQDc5ZbxwiuXJ5AqI5r8qjwlQL+OuNNjPeBhkBNnPaTg?=
 =?us-ascii?Q?T3MIsL86/NZUrAy++X9GrHGg0waFDLG3OpcGmA+dqJFwwqZl1TudChMsQo0q?=
 =?us-ascii?Q?4ciQ3F9AXocDVz7B7uI+RaMwpCwxm2sO2cV9nVpG4AYXkXKUiwod+cQASmH5?=
 =?us-ascii?Q?NyZk0T9g8yzRty81mEYzrZ4NL0lBz0zCB4+ywtUGWL9dwE/6wEElgg3wE81/?=
 =?us-ascii?Q?+5OL1WCHifZRQfvOnf7Dzg1/89al31g0pcOucBIathPWri+fE4XRI1q4vHKH?=
 =?us-ascii?Q?CzB1MfRXAkAouSMW6O5Tb8Lv75Qb9G4M76iKSIu6q2fw6A9TTDRLF3yyrvls?=
 =?us-ascii?Q?20zq4s7wJgo7pD5Nsy3m0hV2ymby58TuIKcHItx79hsudD39sigeT1bc3PpG?=
 =?us-ascii?Q?f/VJ8sDZPmG6MmXm2RklhGiugJfXipQdxbplyVl9+0UQPSjIPFYEqHok+BAQ?=
 =?us-ascii?Q?DP02+hxvC259vcHxI5/anVHsKeC/f+jGJFC7spBBp2+p4b+k5MGBNH0vrcwu?=
 =?us-ascii?Q?r+uP318mpY4ynZaYXqpRrLBqV9CwiqczIx4ydVD2yQwmXxGLI+y/vPqWbj8M?=
 =?us-ascii?Q?KVP/lYDEEETUTphujucIW1hkaQ73gNGAyR91iZ99VMR8vjtwmqM5fTpVLJ6Y?=
 =?us-ascii?Q?6xUTfHvrY3bm+XQ9bvNz1E9sKVuyEk3U617ZR8gWyuRcc1YY+vPlTtOX6Ozr?=
 =?us-ascii?Q?7MsAP+jsMuAxbOP7ldW1F9CmfO2Upk4CrrVcrGqRY75f+K7c5ZHyDrLapIE8?=
 =?us-ascii?Q?xnRaNFL0qCtLAVUVb5jtXs467yZJSd8KUaQ52v20VEo708OuEA+X/KJBXSe2?=
 =?us-ascii?Q?7SeY0ObJeBq3IUzo2QikYEfkq+0lwNmGMxAEh6yDPob4Nr9fey/8of91anNR?=
 =?us-ascii?Q?+YoK1RhqV3Q0/Iehr9Q54YdfI3Wfy4lkVXxPxoNlFVA/Olk2BFvP6W7C6/4V?=
 =?us-ascii?Q?3R+tFLeleqoOdk8xbg618as9nwkji1i8zicEeH5jHNU5x2yBtABSAFW9WDGw?=
 =?us-ascii?Q?sTxk3VqBGSMaQZIZk9WOdAxBYfPSyqCO8E+4EGCQiF3JXhzxB57bnGVP/nln?=
 =?us-ascii?Q?2JU6HO8wElQNJzTVzE8FBgrMUw0d8DLll479q16ooqI8ZSqrJthYqpKsjK+M?=
 =?us-ascii?Q?UIrK8EANHy9zBG5rkuPeXbL51w57xZKOs3hGn0IDKSs/ZGDk6jRdp3Ae5cAg?=
 =?us-ascii?Q?8wd6/fNYPXZ6C9BCFYtcsHkK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af3552b-7214-450f-f1a3-08d8ee24e011
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:42.0599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSnrNiTlaUFkZl/3ESUAlqKlauInMyAPQ2YoQN+OJUblZMRlo6+IrTyejBXn+snY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The type_group_id directly gives the single or dual port index, no
need for string searching.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mtty.c | 50 ++++++----------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index ce84a300a4dafd..191a587a8d5ab1 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -711,23 +711,7 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
-	char name[MTTY_STRING_LEN];
-	int nr_ports = 0, i;
-
-	if (!mdev)
-		return -EINVAL;
-
-	for (i = 0; i < 2; i++) {
-		snprintf(name, MTTY_STRING_LEN, "%s-%d",
-			dev_driver_string(mdev_parent_dev(mdev)), i + 1);
-		if (!strcmp(kobj->name, name)) {
-			nr_ports = i + 1;
-			break;
-		}
-	}
-
-	if (!nr_ports)
-		return -EINVAL;
+	int nr_ports = mdev_get_type_group_id(mdev) + 1;
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
@@ -1311,18 +1295,11 @@ static const struct attribute_group *mdev_dev_groups[] = {
 static ssize_t
 name_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	char name[MTTY_STRING_LEN];
-	int i;
-	const char *name_str[2] = {"Single port serial", "Dual port serial"};
+	static const char *name_str[2] = { "Single port serial",
+					   "Dual port serial" };
 
-	for (i = 0; i < 2; i++) {
-		snprintf(name, MTTY_STRING_LEN, "%s-%d",
-			 dev_driver_string(dev), i + 1);
-		if (!strcmp(kobj->name, name))
-			return sprintf(buf, "%s\n", name_str[i]);
-	}
-
-	return -EINVAL;
+	return sysfs_emit(buf, "%s\n",
+			  name_str[mtype_get_type_group_id(kobj)]);
 }
 
 static MDEV_TYPE_ATTR_RO(name);
@@ -1330,22 +1307,9 @@ static MDEV_TYPE_ATTR_RO(name);
 static ssize_t
 available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
 {
-	char name[MTTY_STRING_LEN];
-	int i;
 	struct mdev_state *mds;
-	int ports = 0, used = 0;
-
-	for (i = 0; i < 2; i++) {
-		snprintf(name, MTTY_STRING_LEN, "%s-%d",
-			 dev_driver_string(dev), i + 1);
-		if (!strcmp(kobj->name, name)) {
-			ports = i + 1;
-			break;
-		}
-	}
-
-	if (!ports)
-		return -EINVAL;
+	unsigned int ports = mtype_get_type_group_id(kobj) + 1;
+	int used = 0;
 
 	list_for_each_entry(mds, &mdev_devices_list, next)
 		used += mds->nr_ports;
-- 
2.31.0

