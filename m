Return-Path: <kvm+bounces-71484-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCUJOp94nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71484-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:56:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1D91792B8
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:56:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5AD17300DF75
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9313B3101B1;
	Mon, 23 Feb 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z+gsA97Y"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010059.outbound.protection.outlook.com [52.101.201.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825D830C632;
	Mon, 23 Feb 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862148; cv=fail; b=AANHIuxAbZbALvMMFEpomM+yScidMYythKFNrNSDHhBOJhan6UI6zK9r5Z4+swJW6GMLq0nqPmctUpf7pGZdANt96ajcY/0mtjskAGkkJsBJbiua4slTCkY6Yli8+D/K2zlQSoGZ0tjTcCwbEaivOvOkdJvRARmwq6NUv72RsqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862148; c=relaxed/simple;
	bh=t/x3PIIH49dIA2r4AkyvHyyrIpBnkaK3FkdB7qGrKyo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ah+Q4hsnZuXioN/ZsG44C9Ly29ektFwHjQd1zeL32WkfzUkmuruwEC7S0aqIyAHSlRVqpsJqG7b2BpTssEDvo30bh0/iU4rYajEE/aWnqB/M6e6BiVfmVFRvUYbBwe1iIXuMa5/tLgSDeiFfnVuIiVQ+ExDMOM+Ux0ZGHA3eNSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z+gsA97Y; arc=fail smtp.client-ip=52.101.201.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DEy6gJYCBHgVvM8EpBLg148EPceN5eXX+kYRHkGOBK5B29s4oMc00FrEd7Gz57ydNHkc+VTd6XS9bJievoriqA9qKth6RE4hKOqVBcW5vtHLLL/Frn3nkigX+xQ8YBOrUi+lB+v1jSW21NtYW+jSjK9yBcDt6ng0TyFDfG/KPyxN/Utn9XzWXefazgYgkQIvF0/3gTMCc9ITio0NWGL190Y8FyAmuUz/pQZ6VPIDHPd5sBdbguLsmDNpcqoNFek1gybrVI3Ynrujt6MUp0Y3tehC9dK0K3RYP6i702s+yqtQYCm9CaZZscJBtNA1Tn/G48F7A0/Tw2U3QTyejtuddA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzJ+e4pr6eIhdtuH+3dJ2Ii5jpfG5RP1f6Yx5bd3C50=;
 b=FOrNXVJ+I1nEdX7Yo5St27p8bf511bnpXIVtkaK/PCZoevBQ2QFUsDAYdvusjGaEJ+Jiehf0bNqqvTctXD8M7RLQXvPFEhi7FfA/e8/8+2c6oF1AR0n5EcNs/o4xKDp5CvaWKsZWHxxL5xseK77tuJglUHReRriXFNxFx09VTAnSz7TPP5hszy6SykOx+K5djyH3cO5XFvuh3rJlJYYSsPOAuR8dNYaCMyJXmP5fetInmbL+5EbHcHgekapBEIul6S8gRaVvOW97BN7rndB27jTblJq/T86RFnSfr/6hLuukos2fCoXZz889NRA933TpSCOsgHNNY+kjUY1poII1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzJ+e4pr6eIhdtuH+3dJ2Ii5jpfG5RP1f6Yx5bd3C50=;
 b=Z+gsA97YcrRIIvEfZIuGz4iFIniW4IhU5hSpHQGd2aeuR5v4xPMZgrHp0uJ1Ltk/79WDneamdE+XhgJxrS8boEDgZXZj2Trr+nT+TjpbhscEaibpR0d6ubDRwhoBiQ8dIxq+TF9aUXcX87Ucst6M+W6U618D5M3QCNhtYNuisivOXhU7e7uvEvli0+vTXkMCRXVUGLySjeO+z7XcLHgvP6Q8NXoYBqPXLUL77bfWcAzPLlTQbuy/F1Do6O4aXCR9EyLAwGt5BR8hq/KeFCk7se+xqHLMObwNwOPqEZ3AHOW0nZsvOWXZaNeQh6ZihBXi3lvqGSMaop8TXP+Zv5SwoA==
Received: from DM5PR08CA0060.namprd08.prod.outlook.com (2603:10b6:4:60::49) by
 PH7PR12MB9176.namprd12.prod.outlook.com (2603:10b6:510:2e9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 15:55:37 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:4:60:cafe::e0) by DM5PR08CA0060.outlook.office365.com
 (2603:10b6:4:60::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:17 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:17 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 06/15] vfio/nvgrace-egm: Introduce egm class and register char device numbers
Date: Mon, 23 Feb 2026 15:55:05 +0000
Message-ID: <20260223155514.152435-7-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|PH7PR12MB9176:EE_
X-MS-Office365-Filtering-Correlation-Id: fa89116b-3ef8-45b6-6f6c-08de72f3fc33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kbzkcn5Rv+EX1Von6ruC6cvQ8PMJO4q8/jJoGGC5s9YRTV+2iu/4phzvOBJC?=
 =?us-ascii?Q?YM44WnthO4Quv6mBYCfwna/ErwVh5CQcc0FUu4wSiZ1OQmUCRriul1F0qF0s?=
 =?us-ascii?Q?dfuMigqvnyCLvt3M2MYoCNKskgXv7NjUW7C4Siow16Ilr0270njv7ADOPfFa?=
 =?us-ascii?Q?9uWiMLqB9qnhRsyyht9KcYDb5LBxik7iLwKGLn0DdcSc0m7K7laSOW7MOwhV?=
 =?us-ascii?Q?qs5TrT+5aX88ZlKqodvCnSYyPJ/qpPbV+QKmvgyhGC9FHUj9cqW7nBAIz4QX?=
 =?us-ascii?Q?4o+otbRe2ibyLcVd7jaOMVg1x27StGgGBB7T48/Jkj97UaSP8onWHWW23LBW?=
 =?us-ascii?Q?5/QWZJi/3LVrNqw5yUptYP/jGbCBE0qiC3VflgKQtOMJcb3taUnnA8xB2j5I?=
 =?us-ascii?Q?4EmIKLE4zsuFfUk1Vzl1+eZeLinCP94/1/pIeGe67Zp0N4aFTeQGJRR5FKg6?=
 =?us-ascii?Q?NoCUh8xq76uL6uLVw9ndaRSUr2FZm7ZcLq2wy+LugPbK1T62uj8eRKV4/2Ao?=
 =?us-ascii?Q?V4aJWVXK4+4HD/Gij6c/VrspbuaaAjCbXe3C0ikcNs54XQvmee3au0TaAwbG?=
 =?us-ascii?Q?FMUUZWaxUk/QZZGYiXEqB9xShFAeytv0e3KfwqboFGsn90TLEO8CoUmUDoz6?=
 =?us-ascii?Q?VPGHnpbO099HLiv2WnSJkxSvPmDUQp/6knc0RU7sF2TWutWG8r7CDHhzSzZh?=
 =?us-ascii?Q?HCrpPsvr1yna8LWOgAq3EPBn5GTVK4GhlPjQsrR+eUzPUCNCkQj7LJRRd8hw?=
 =?us-ascii?Q?UZRqcNji/zueKOufWLKrF8cyZgB/mbbXhHMfmYfkI8t9RSwSF56kzth5qp86?=
 =?us-ascii?Q?LOsk1H176ksIRDPfqfclWdMV5UMrdeDd5O7ImCR+HZPG0wjTIhmUTDz5cDLS?=
 =?us-ascii?Q?3DObH2J0NCF5P/+x3PiPQgctczHtH3sjVq0objQ4Hjvlw7xmBnnNfXi7JN0e?=
 =?us-ascii?Q?3n1bAtMmTidRovWC6unOO5zsDkBxGwLKDMW+HIOoT0Gcv4FXp9PcYeV2Lp/8?=
 =?us-ascii?Q?rbOcYQ9g5epGvvQfQhoPD/jXfTzdmsnxMBdEJi2y7lGSIV5eTzckt5vGiCGo?=
 =?us-ascii?Q?rTuUi6PIh5b70I07pTJrTX+5iOsEGM2HruuoGD9PIP7wx5CMjlfwgTt2aNLh?=
 =?us-ascii?Q?iicgMTZuoG+Jy7MZ/A9SXwOmlU5SHlACzfRjbzBkaoaQoE6fW4hCqsYZkHhS?=
 =?us-ascii?Q?O1BGpz8bRNZxDdA875BVAVHbvpWvAk2TwK2XB8miEqD+of5Y+cnly9VLSf05?=
 =?us-ascii?Q?zTesxJpgf3Nx7QnB5x6BOtcWqUQACffNYmsW8bYMblFhOru9MOVMrG4MxgNI?=
 =?us-ascii?Q?dHmuCKtGH+XwCH7Mz9vlbnqzVkw3BP+a7Tm4CA/dTLJTeM3Kpzfx5Dbfl3Zk?=
 =?us-ascii?Q?pq+ynNpyvOtPHIyN+itJh0jF0co/HSzxhQ7F4ZztpaZmOn8Y90JszLezELTj?=
 =?us-ascii?Q?mWE+2n2V6oHv7IJwJrVTBhrfTmNo/74b4vt7wyjJCLYxx1IfVIksuHGmzo7K?=
 =?us-ascii?Q?oVhtR8n+6p7hJNEB3fKG6QsZ3GqHa95Wb55ZmXaGYmsfyerXoi2UaMlh6R2I?=
 =?us-ascii?Q?VNd9nf0NNePkBE6lP23MUE0TelR52zQbc7egwecEklzS2+sncCfl4Wgz6rym?=
 =?us-ascii?Q?tbFSpp/WBOYWirjtlr8oxm0BdQ9PCCDDMd/HjS/XKgFaalpwr2ebLOZ0X5lC?=
 =?us-ascii?Q?0YdZ6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TDYgxJkUnmc7WwOvSDTLUyNOF0uNCWdUA92k6JdETjMkYmzT5KRMyJM4Z0CcS09ZyatYjb8eteZ9mAq5Z1t2HVDzi3mHrS3xsZAq1dyvBlNNCs2F9FdILQLb5h/PoUmSGd6wksmGyzzGBNhZHCeCFggtX8z9++diGTUQytv4/6kKsyA2nIb3N48vrTwN5fi68rNIy9U4r7kfunsT5WGbN3RdvuRso+4cGo3DsbCvn90wWbevsZ3KTaJda2IRf4LZgHW70UK16TZ6jQ92BxAYOw+SGYq3yOtcWrWIPtWhJ3zb+F1TmPlnadyn+0pRMakUJrV37OYOBmstN939C370X/DFvv0Appfz1Wsymga4U7NMtIIrOpoZ/wrSfIMnYesk6lq0nhXCssf801BN2Htj6lF/3kfPQl6BFZP5GbS7hhVX44tY6wB0GrwfCNH0MkSk
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:36.4650
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa89116b-3ef8-45b6-6f6c-08de72f3fc33
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9176
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71484-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ankita@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 8D1D91792B8
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

The EGM regions are exposed to the userspace as char devices. A unique
char device with a different minor number is assigned to EGM region
belonging to a different Grace socket.

Add a new egm class and register a range of char device numbers for
the same.

Setting MAX_EGM_NODES as 4 as the 4-socket is the largest configuration
on Grace based systems.

Suggested-by: Aniket Agashe <aniketa@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 36 ++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 999808807019..6bab4d94cb99 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -4,14 +4,50 @@
  */
 
 #include <linux/vfio_pci_core.h>
+#include <linux/nvgrace-egm.h>
+
+#define MAX_EGM_NODES 4
+
+static dev_t dev;
+static struct class *class;
+
+static char *egm_devnode(const struct device *device, umode_t *mode)
+{
+	if (mode)
+		*mode = 0600;
+
+	return NULL;
+}
 
 static int __init nvgrace_egm_init(void)
 {
+	int ret;
+
+	/*
+	 * Each EGM region on a system is represented with a unique
+	 * char device with a different minor number. Allow a range
+	 * of char device creation.
+	 */
+	ret = alloc_chrdev_region(&dev, 0, MAX_EGM_NODES,
+				  NVGRACE_EGM_DEV_NAME);
+	if (ret < 0)
+		return ret;
+
+	class = class_create(NVGRACE_EGM_DEV_NAME);
+	if (IS_ERR(class)) {
+		unregister_chrdev_region(dev, MAX_EGM_NODES);
+		return PTR_ERR(class);
+	}
+
+	class->devnode = egm_devnode;
+
 	return 0;
 }
 
 static void __exit nvgrace_egm_cleanup(void)
 {
+	class_destroy(class);
+	unregister_chrdev_region(dev, MAX_EGM_NODES);
 }
 
 module_init(nvgrace_egm_init);
-- 
2.34.1


