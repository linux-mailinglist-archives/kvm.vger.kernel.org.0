Return-Path: <kvm+bounces-71491-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YLgHHPt5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71491-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:02:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B90DE17943F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E50730AC5C2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240ED3168E1;
	Mon, 23 Feb 2026 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BnhQu/wB"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010058.outbound.protection.outlook.com [52.101.61.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BD30DD12;
	Mon, 23 Feb 2026 15:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862151; cv=fail; b=DglZtQIYyIpe5PbygMZRwVpHA9IYmkbtIb9Y3Sc728NTZubMHnm+/cXlf36hvGiRHeP7xuj7RNktGv3UQWI/DqkdL07MzwK45w4O0oqBZLXxR187jCUiI+fKcO1nfQGz9eP2JzvpuYRdFLVuYrZl5tKE5dpuhmhOG/Gk4uE5zSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862151; c=relaxed/simple;
	bh=xpV1mVTEgJUny4G6PFv/Cnh511/X3QbQmlhfgVMVazM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CW5mBAgupx/p3uDFnuaAiqu0vz8Z16xyk/KyOcVApCWzwyPmGzz4yWdtG5v/f8LONUIz/vh1InDURFliT5O9aMmV/pfr5chx4z8iBa34rA+a86i8Yd9qK9GaEpP0MhVDm6UmU5Y48XoGZf7ZoPuznSIW27FePKCtrckMOCpBqII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BnhQu/wB; arc=fail smtp.client-ip=52.101.61.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bmv446DyNwW0XqgaOxUxnmNDXB8pyrDl+bW5K387KRrZeX1ZxVmVvLtyxOj9k0FO33RTClKyQB0OTk6Hh5hfy+TEigtoP/bj8d5I9Tt2kXgHsG4r+MMmhSeDvJgWTsYV/9dB3EsqWLmeb6YSvvuNBpSxhPFRWO22SEIQlp241sE4wfxHVswXBCjth4Q1HeCY1Api1+0w9EtEHlwBsIAMpPaNflJx1qu0kN1sm+wTmLZmj3igWP7aXWObIHbRhcdbm8B3FEVrlgY6J8fkwnck+pfRUXyjH2yx+BYuHoOrJuif37r7O0MRCcMML85yEd18w175FkKNTjxDM8lkT9lFOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iU9SNhUgBxp63sHFsBQEly8YO1b8ESgHB71rDFRRUjY=;
 b=PyzADHmdVc12crk8gOMJqIUlSL2j+t2cx1Kx0WZ70KHzYZTuR2veWL3GD9N3o99S8ZFSxlL4qG3kxF7AuQKiqvAttaEBxTza2Fyjt2ox+PHYjo3m6te4q+SQAzzpe+KnuH7/e0tuIp0roDaE+QBevaHYY3n5jW1/Y7pJ79KXCaJpD8NxlCr6kWUIn/8Ub1epOgiXuzDJzPJ1qDwBfQDxz3Aaj8d5BWTleBXqWKX2+eaW/j+A5njNwvylJLC88q5obAquORSJtOrkY+JBNt0JEg2uPflE/62v5mRFEGEkj26niiyIWHYEdlaJL2H4otG32sf1GOIyVTPqPTO51crpiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iU9SNhUgBxp63sHFsBQEly8YO1b8ESgHB71rDFRRUjY=;
 b=BnhQu/wBMoQmynYc9p3z8ZoJ/TBb/SVnWbmYngGauaLarZRjhXueiAHIF2THg8GKy+qnp2QuuNLIy6vYhiCMpRphyP/c2yDs3ejVFziNWvasWuwQ3xvG3y8u5kkUi9qJsyUkCInl7ut65HkfmJQjGEAH2QHfj3toE7D4Z/mOdm5uuJoAapH5kCwxXz4ViJ8ClXgny5g6tAquW/mmYDDZsusy5xUoOF6szMu3jB1b1lp8qBBLIV9Qy7uhYU27h2W6VhtJkqpv9rG3V0YjoR+lhj2TOTHDMKTFIzvYWWYE+46uLJ0tP1Nh2R59pG4cML8sC1ILth/hu1mTCp0CGa9FfA==
Received: from CH0PR04CA0058.namprd04.prod.outlook.com (2603:10b6:610:77::33)
 by DS7PR12MB8369.namprd12.prod.outlook.com (2603:10b6:8:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:38 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::30) by CH0PR04CA0058.outlook.office365.com
 (2603:10b6:610:77::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:19 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:19 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:19 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 11/15] vfio/nvgrace-egm: Fetch EGM region retired pages list
Date: Mon, 23 Feb 2026 15:55:10 +0000
Message-ID: <20260223155514.152435-12-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260223155514.152435-1-ankita@nvidia.com>
References: <20260223155514.152435-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|DS7PR12MB8369:EE_
X-MS-Office365-Filtering-Correlation-Id: 0173a496-98d3-4e38-9004-08de72f3fd4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Kn5RMgWngNKvOzrv2tdjK0gGNNdnnBGetWX2TxaFUBfq3BYr0nuoc1UZ88x?=
 =?us-ascii?Q?H4EtErJbybbzGlOdHqmA1llLb2DTdWa7fw9Lktilangm/+wvbX2osXnWh+sJ?=
 =?us-ascii?Q?GPVUKw9UVA6BZqdtMK8nGY/lRmV1xQv/8/R4FzmUb1Ikn1htM8LKfB+R6RG0?=
 =?us-ascii?Q?Tldpscd6QaaEUgs6aYXvFJ2R/1iZyBa3+ZHeTLdNrF/Au6KU/VBDxMVwd6TV?=
 =?us-ascii?Q?MsqaTrLh2dzOmsi8y90w8qLD3JUr3HH5hcSjOrsiw92FgPT0ZLWDgc2KbTrV?=
 =?us-ascii?Q?zI7thARv3TAJeLIm57DtjivnIL/gLVXLggAN2/K5VHkZk3u7M2jpOEKTG0yo?=
 =?us-ascii?Q?4A+ZSneeqCZFWb1u6LytN0s9jHuDWqBgRWoJEek1eIswwinzx6SM9Lhow6Hs?=
 =?us-ascii?Q?746qetyd2s2HhcB9UJIZP31/4//ARuDBatUDn2z/xM2VNQzEOffrIUgB/smV?=
 =?us-ascii?Q?N6gQlWlQ8wHJonta00upLzCkYkBjixv+Ansbpr5KF13d/Q+e1msdlb2sd7ep?=
 =?us-ascii?Q?k9z7lAQm2rAwBhQ9N6E5rLe+b/s7MtYnB3hw3lnLdZbqBEstx2aoAZ6h2tZk?=
 =?us-ascii?Q?wqODUHphHYJ7zhLRMxaaUiK/PVAeknaDvFRNvEbQCbUbW/Tbefi2t4SKtjD9?=
 =?us-ascii?Q?zvOGz5QJaMaOzUmZEdXP6VOUhsQB44yT0gcEIbkGSA9vra8io4DqEYCZCg+j?=
 =?us-ascii?Q?kR1cxe7g0DU3t/qiCl+pdORb52EwD8KQ87hDgMw6rTVIPhaYbMl775TeDRin?=
 =?us-ascii?Q?rMiI1yOAJb8T5PQ+DmNi1lW3vjMuFAhv3dPn4xjxNpbSWSYrpFc8zrQYJgeS?=
 =?us-ascii?Q?k3CFKYmUwjrPwTD7a2rhmoueURzulB8B20wZki6Au3AEgqXz6WOGcSzYaltS?=
 =?us-ascii?Q?82DCjVDhjMlkUPkcDRXBE6XmstopSqkSEw7/rt5fmQExwp44puR2cETmIUMF?=
 =?us-ascii?Q?AJRt7v/DVLwoJ5znqEs4cYrd3M4zvT8b7saMe/xrK94bslvugelhJ3/pGB8T?=
 =?us-ascii?Q?blcHVkbW3u5sjtdVx44DvqYXr2PHA5zEGvwNpCSchLcr8MXSpVjLRyBy1hsc?=
 =?us-ascii?Q?8+u0SGxPzKezPbqOG5V+h9Kfnfy2xvrYZil36lTXpUw5tdrG3eCkhS73An4p?=
 =?us-ascii?Q?avjWXEKymPyH8IQBZp5sWnk6+zY52G4iBakcRjoi+Cz4yxJ0viBjvksZgZwD?=
 =?us-ascii?Q?zi43NuaI2+JdMs9zOTbqvT/oipaRF6W1vRsW1bL/EnJYIN36V4BswoCxNo/M?=
 =?us-ascii?Q?NBvNosoQqprlga8g0+FLJnC5cqrJru0uOHJXtyoRHrvPEstz44jXjT3p+Ew1?=
 =?us-ascii?Q?LlGbaQDHcqu+tU2XY3uC6AIEL31aGM1A2gQnw6wItFYV3St37neaL9lr8rCK?=
 =?us-ascii?Q?UUkgG6XRpsZH8lQNQD1o3jImdh4A9NA+0lUw2+0pf8cLRZ0WWLybKSrM2MtF?=
 =?us-ascii?Q?XNvU52v5bb2l4K/REj8nBhOvgxHymxL1YonJ2dfpq739spDzRme9z5YxEQSk?=
 =?us-ascii?Q?eWa56yMN7BGwv3tKvf/9p5F1/NH4EPOsrIqbBoZOlFMRFm+xjFLT5XsNcxyp?=
 =?us-ascii?Q?vjgqCRkZNdN2hPVAkB0uA2bYAibBlCNLGfVOcTPRmJH4BtLGf+73Qb4NWh7m?=
 =?us-ascii?Q?jaqm/Y9gOgF9xztLRX3NLgViGoj7thfqcKvtUDYnbQHBG/oVGvrWRncMPUJV?=
 =?us-ascii?Q?JZj4Jg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lzFKqsDjC6/3+YaGqkKEjjZD8RC+GUw3nTRxi1rC3WypjaqbAks/nZjLi6pBWUSU1LeNZTBtAqfbaRrfy/KE4FokZCJQeGphg6fqIId3ED541OADygOrmhwEeSRw7M9HQLMh2IpiOJCCv+dehzH6kD9t32GXBCCs/QDthR/N2FBrU/xRcfnJ2RjwGgBsSyiPxXGtzS5vO4UwCetDeMVE6mBrGQ71XcjyTZWEbYZi3vHJaYv0xK36vaBbiIwN6/3bsS632BnXAxlGQBT+jqRt1hJPEt+ercBLiUfLkrgcFUlBmpMvRySrieswGgm0fs+uLyg2JMPhHK61f8qIyBhRXiLUMlsKRSKA6/Lo5o4SCyXi2GiTqffYmhXYtRxrWk8Cg44KZjMjLQzDSA5Z7W0su7G3+DvNieRFVtOggP78ae6S7aisonR3LSxSzt9tDmq+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:38.3872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0173a496-98d3-4e38-9004-08de72f3fd4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8369
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71491-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: B90DE17943F
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

It is possible for some system memory pages on the EGM to
have retired pages with uncorrectable ECC errors. A list of
pages known with such errors (referred as retired pages) are
maintained by the Host UEFI. The Host UEFI populates such list
in a reserved region. It communicates the SPA of this region
through a ACPI DSDT property.

nvgrace-egm module is responsible to store the list of retired page
offsets to be made available for usermode processes. The module:
1. Get the reserved memory region SPA and maps to it to fetch
the list of bad pages.
2. Calculate the retired page offsets in the EGM and stores it.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c     | 75 ++++++++++++++++++++++++++
 drivers/vfio/pci/nvgrace-gpu/egm_dev.c | 32 +++++++++--
 drivers/vfio/pci/nvgrace-gpu/egm_dev.h |  5 +-
 drivers/vfio/pci/nvgrace-gpu/main.c    |  8 +--
 include/linux/nvgrace-egm.h            |  2 +
 5 files changed, 112 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index de7771a4145d..077de3833046 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -8,6 +8,11 @@
 
 #define MAX_EGM_NODES 4
 
+struct h_node {
+	unsigned long mem_offset;
+	struct hlist_node node;
+};
+
 static dev_t dev;
 static struct class *class;
 static DEFINE_XARRAY(egm_chardevs);
@@ -16,6 +21,7 @@ struct chardev {
 	struct device device;
 	struct cdev cdev;
 	atomic_t open_count;
+	DECLARE_HASHTABLE(htbl, 0x10);
 };
 
 static struct nvgrace_egm_dev *
@@ -174,20 +180,88 @@ static void del_egm_chardev(struct chardev *egm_chardev)
 	put_device(&egm_chardev->device);
 }
 
+static void cleanup_retired_pages(struct chardev *egm_chardev)
+{
+	struct h_node *cur_page;
+	unsigned long bkt;
+	struct hlist_node *temp_node;
+
+	hash_for_each_safe(egm_chardev->htbl, bkt, temp_node, cur_page, node) {
+		hash_del(&cur_page->node);
+		kvfree(cur_page);
+	}
+}
+
+static int nvgrace_egm_fetch_retired_pages(struct nvgrace_egm_dev *egm_dev,
+					   struct chardev *egm_chardev)
+{
+	u64 count;
+	void *memaddr;
+	int index, ret = 0;
+
+	memaddr = memremap(egm_dev->retiredpagesphys, PAGE_SIZE, MEMREMAP_WB);
+	if (!memaddr)
+		return -ENOMEM;
+
+	count = *(u64 *)memaddr;
+	if (count > PAGE_SIZE / sizeof(count))
+		return -EINVAL;
+
+	for (index = 0; index < count; index++) {
+		struct h_node *retired_page;
+
+		/*
+		 * Since the EGM is linearly mapped, the offset in the
+		 * carveout is the same offset in the VM system memory.
+		 *
+		 * Calculate the offset to communicate to the usermode
+		 * apps.
+		 */
+		retired_page = kzalloc(sizeof(*retired_page), GFP_KERNEL);
+		if (!retired_page) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		retired_page->mem_offset = *((u64 *)memaddr + index + 1) -
+					   egm_dev->egmphys;
+		hash_add(egm_chardev->htbl, &retired_page->node,
+			 retired_page->mem_offset);
+	}
+
+	memunmap(memaddr);
+
+	if (ret)
+		cleanup_retired_pages(egm_chardev);
+
+	return ret;
+}
+
 static int egm_driver_probe(struct auxiliary_device *aux_dev,
 			    const struct auxiliary_device_id *id)
 {
 	struct nvgrace_egm_dev *egm_dev =
 		container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
 	struct chardev *egm_chardev;
+	int ret;
 
 	egm_chardev = setup_egm_chardev(egm_dev);
 	if (!egm_chardev)
 		return -EINVAL;
 
+	hash_init(egm_chardev->htbl);
+
+	ret = nvgrace_egm_fetch_retired_pages(egm_dev, egm_chardev);
+	if (ret)
+		goto error_exit;
+
 	xa_store(&egm_chardevs, egm_dev->egmpxm, egm_chardev, GFP_KERNEL);
 
 	return 0;
+
+error_exit:
+	del_egm_chardev(egm_chardev);
+	return ret;
 }
 
 static void egm_driver_remove(struct auxiliary_device *aux_dev)
@@ -199,6 +273,7 @@ static void egm_driver_remove(struct auxiliary_device *aux_dev)
 	if (!egm_chardev)
 		return;
 
+	cleanup_retired_pages(egm_chardev);
 	del_egm_chardev(egm_chardev);
 }
 
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
index 20291504aca8..6d716c3a3257 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.c
@@ -18,22 +18,41 @@ int nvgrace_gpu_has_egm_property(struct pci_dev *pdev, u64 *pegmpxm)
 }
 
 int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
-				   u64 *pegmlength)
+				   u64 *pegmlength, u64 *pretiredpagesphys)
 {
 	int ret;
 
 	/*
-	 * The memory information is present in the system ACPI tables as DSD
-	 * properties nvidia,egm-base-pa and nvidia,egm-size.
+	 * The EGM memory information is present in the system ACPI tables
+	 * as DSD properties nvidia,egm-base-pa and nvidia,egm-size.
 	 */
 	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-size",
 				       pegmlength);
 	if (ret)
-		return ret;
+		goto error_exit;
 
 	ret = device_property_read_u64(&pdev->dev, "nvidia,egm-base-pa",
 				       pegmphys);
+	if (ret)
+		goto error_exit;
+
+	/*
+	 * SBIOS puts the list of retired pages on a region. The region
+	 * SPA is exposed as "nvidia,egm-retired-pages-data-base".
+	 */
+	ret = device_property_read_u64(&pdev->dev,
+				       "nvidia,egm-retired-pages-data-base",
+				       pretiredpagesphys);
+	if (ret)
+		goto error_exit;
+
+	/* Catch firmware bug and avoid a crash */
+	if (*pretiredpagesphys == 0) {
+		dev_err(&pdev->dev, "Retired pages region is not setup\n");
+		ret = -EINVAL;
+	}
 
+error_exit:
 	return ret;
 }
 
@@ -74,7 +93,8 @@ static void nvgrace_gpu_release_aux_device(struct device *device)
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmphys, u64 egmlength, u64 egmpxm)
+			      u64 egmphys, u64 egmlength, u64 egmpxm,
+			      u64 retiredpagesphys)
 {
 	struct nvgrace_egm_dev *egm_dev;
 	int ret;
@@ -86,6 +106,8 @@ nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
 	egm_dev->egmpxm = egmpxm;
 	egm_dev->egmphys = egmphys;
 	egm_dev->egmlength = egmlength;
+	egm_dev->retiredpagesphys = retiredpagesphys;
+
 	INIT_LIST_HEAD(&egm_dev->gpus);
 
 	egm_dev->aux_dev.id = egmpxm;
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
index 2e1612445898..2f329a05685d 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
+++ b/drivers/vfio/pci/nvgrace-gpu/egm_dev.h
@@ -16,8 +16,9 @@ void remove_gpu(struct nvgrace_egm_dev *egm_dev, struct pci_dev *pdev);
 
 struct nvgrace_egm_dev *
 nvgrace_gpu_create_aux_device(struct pci_dev *pdev, const char *name,
-			      u64 egmphys, u64 egmlength, u64 egmpxm);
+			      u64 egmphys, u64 egmlength, u64 egmpxm,
+			      u64 retiredpagesphys);
 
 int nvgrace_gpu_fetch_egm_property(struct pci_dev *pdev, u64 *pegmphys,
-				   u64 *pegmlength);
+				   u64 *pegmlength, u64 *pretiredpagesphys);
 #endif /* EGM_DEV_H */
diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 0bb427cca31f..11bbecda1ad2 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -78,7 +78,7 @@ static struct list_head egm_dev_list;
 static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 {
 	struct nvgrace_egm_dev_entry *egm_entry = NULL;
-	u64 egmphys, egmlength, egmpxm;
+	u64 egmphys, egmlength, egmpxm, retiredpagesphys;
 	int ret = 0;
 	bool is_new_region = false;
 
@@ -91,7 +91,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 	if (nvgrace_gpu_has_egm_property(pdev, &egmpxm))
 		goto exit;
 
-	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength);
+	ret = nvgrace_gpu_fetch_egm_property(pdev, &egmphys, &egmlength,
+					     &retiredpagesphys);
 	if (ret)
 		goto exit;
 
@@ -114,7 +115,8 @@ static int nvgrace_gpu_create_egm_aux_device(struct pci_dev *pdev)
 
 	egm_entry->egm_dev =
 		nvgrace_gpu_create_aux_device(pdev, NVGRACE_EGM_DEV_NAME,
-					      egmphys, egmlength, egmpxm);
+					      egmphys, egmlength, egmpxm,
+					      retiredpagesphys);
 	if (!egm_entry->egm_dev) {
 		ret = -EINVAL;
 		goto free_egm_entry;
diff --git a/include/linux/nvgrace-egm.h b/include/linux/nvgrace-egm.h
index b9956e7e5a0e..9e0d190c7da0 100644
--- a/include/linux/nvgrace-egm.h
+++ b/include/linux/nvgrace-egm.h
@@ -7,6 +7,7 @@
 #define NVGRACE_EGM_H
 
 #include <linux/auxiliary_bus.h>
+#include <linux/hashtable.h>
 
 #define NVGRACE_EGM_DEV_NAME "egm"
 #define EGM_OFFSET_SHIFT   40
@@ -20,6 +21,7 @@ struct nvgrace_egm_dev {
 	struct auxiliary_device aux_dev;
 	phys_addr_t egmphys;
 	size_t egmlength;
+	phys_addr_t retiredpagesphys;
 	u64 egmpxm;
 	struct list_head gpus;
 };
-- 
2.34.1


