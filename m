Return-Path: <kvm+bounces-71488-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGiNNsd5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71488-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:01:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4919E179415
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BEFEA31C0A26
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF28313558;
	Mon, 23 Feb 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E9xsGQP0"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010024.outbound.protection.outlook.com [52.101.56.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AD430AAA9;
	Mon, 23 Feb 2026 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862150; cv=fail; b=VVH3/VxP+FwMzzYJs/6qjPFqR2qd+wUK0o+zFoppYQTr8ihtqeYVIyhSEzGmuPzbkX3EzxsnfDEBQ8RhCOFlxXKd45W4A5JHed5w5YMN08McRtyTo4A+GMF7CAJXXXzz5YyILY5xe0dI8D6R0KiBiW33Q5MLUe5cw6WAu6j2lB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862150; c=relaxed/simple;
	bh=g6r/8oIAVimzZBq29YK1UI/PGWw1WlW8HsNv6BBZb4U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SyH3413Ze8YQ2yR2FNW6edpZ1BX4qqaG+VJNiwn/Fe+G1YrBTq/a1z5+JA4sFJTbrAyhhjNzc1oL09atectffCdSnenN62Y0bZsIHFp4UC8PEh69+/zPSLZv+ZQ1ZStQP1CQbvgcmi23xuBBjssMwtC+X2x9Kr5UqzrzdwBdh1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E9xsGQP0; arc=fail smtp.client-ip=52.101.56.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSYbaZUlLwI2oslnf8E4WiiS9jdJ3GfMrozPM1Wx6lfnLqOK0S6jnksoBpFFX5FV+KGIQUqpE7h6qnW/+cmhJGYXhQCdAbdPF99ywHVciiJaqDwUAEUFvJr4ERXXoUJHWNQaNiJb1U8hhAD1jQ8cIM8RbIxUEnL5LneYLk4uk6doDFF92hOBHddLt0popWMiASFqjQ+gUuRg+wDTa3YAwP33mB+suDhEbr0/Sk0nG5lZryN1sHn7YkILCXUpnqIaw97pstmtWCaLY0ufqvFLxOx01tT4+dBQb9eYm6K0WSKb09s3TvWXceu7aLqVr5iPNR3KVIWCbOAWg83poLEv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XG1Emf5niFZeaGGr1StNoL/JjI1MdxauRNQHOsbP7r0=;
 b=NeBh8TdKF4+ByhQnkyIJXsQub3KIRH+ExfQneBtg642kbIXsSnfZAkLBTBlKPijEHwhK/DoYzXV4OST/vGhNTjL6S/tm2wVF2hHCCwLwy+okRHY0eGKNwHBJDBmByJQGtWAfOPqvJY4KdK/M54IF+qP0LP5natN9/CJWGlAlAmYZTGlsgAZJM3P9jxZbGLtCkSEXhYbHHLwdK623ZlKXqgX8ZuB8sxHH1tG6PCrgKIYd+iL2bdjD9tnfrUVkw3ibMaaxpXaBkurl7Z4y6S45KQx31g20+4kW1b1Sb3d3ZHpv/U4z2zqcmaDSfJkeYU092nWbDOQZ1j9b9rhixlOxWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XG1Emf5niFZeaGGr1StNoL/JjI1MdxauRNQHOsbP7r0=;
 b=E9xsGQP0IFud0iTxiVJ1oh2LXSTiWdtb206Yt2L6RDp9eHTJgkUJ5jMIcotd67QJ5iAe7BEI8uNBJ8f8lPcZ9DiFRTpkbap5C4b3NsAkuXqVjrdGsgbT9j40L48UBBkeyTiIB2bBPljQu3xNKyh4HixEIGK8rYHORhShnm0HA9+pKj4bdEzCIx/7r3Sz0hCqjD3Azojq4LX3RMnAO7OcrgqVA1CwkPSTHzKMWh9niYkxl39LzOP3H2Y9HC+IFWT3gX4c8UErxFGTB7kQV5PPVPlPLJySnue+RvnoZJzWjx31fmGUdcSnovzCNR+WNPWOdMaEfzcZzaZL9R+3Jk62NQ==
Received: from DM6PR14CA0069.namprd14.prod.outlook.com (2603:10b6:5:18f::46)
 by DS7PR12MB6071.namprd12.prod.outlook.com (2603:10b6:8:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:41 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:5:18f:cafe::f) by DM6PR14CA0069.outlook.office365.com
 (2603:10b6:5:18f::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 15:55:41 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 07:55:21 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 23 Feb 2026 07:55:20 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 07:55:20 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 15/15] vfio/nvgrace-egm: register EGM PFNMAP range with memory_failure
Date: Mon, 23 Feb 2026 15:55:14 +0000
Message-ID: <20260223155514.152435-16-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|DS7PR12MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: a118353b-f719-4c3c-e850-08de72f3fee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZzjfmrpmvA8tE6fO4+ucA2kYg56b7gACHHiesfEM5VTkpasOYUrnHixaQA6e?=
 =?us-ascii?Q?Hp8NSijF8VZIW1WYuisojZVt1APj1/sZWOyjBjmn+Nx/lA1vavJPasSUxjCA?=
 =?us-ascii?Q?7i9N3HHIkXFyFbTxfEFeD7VJrG4e6yLY7j3GBzuyjarypmK/6nim/B416tIK?=
 =?us-ascii?Q?Vn64dU9fTEAgzH7WyqhNzfLLlCYxXMjiuE5i0NEBNOjW+YVLweXNVb1Ocjcg?=
 =?us-ascii?Q?fFNy2jj3E7xmBqH7A7it1JE2pWkvpCbbFJ4Kve36rMVJisS+LA4wJh6NGSrn?=
 =?us-ascii?Q?WXHJZ7cZi5YepU/y4pN2bkVNU94OzHHszsdFqzT32O/B1xjRfdGdHRGjZdXi?=
 =?us-ascii?Q?xRXq6rcnsABwTjcn36zkhMBPALddhVtGEVuOJV8XYoqhC2HH6tzPa+CwBzas?=
 =?us-ascii?Q?VTQeTyKAYS5VzxgthuoNzgAPLmJdYIq3LzkcCkgmJJcpeybhGauQZKdw85LB?=
 =?us-ascii?Q?QPl9B/UwaEQU7w4oqqh9KK2lUDd4cvJvVxfov0bpMbTDOqbdpLf9/Fp2HIUW?=
 =?us-ascii?Q?GxuJtzI1AH0dRTvd7nFBGTjJuvUrMpE3ahcxOm8WW8FrDiyM/KXHt2Dfuqvd?=
 =?us-ascii?Q?DFvTpewgM9T0hUW3/2ipSEpw+JOqs7QZuwZoJpJdbWR0jm6+TxN+ZZjQD6Fb?=
 =?us-ascii?Q?pRgLLGAVnQ4EiL8TQGXTBVLOAhDnuszkXBzuSYZEPSj0IBrFP50L7DJRjiHG?=
 =?us-ascii?Q?fm9FYb4rvoE+ZZ5tUZSaYjFdyRFPegCVhk0mi7nvBfIy9duVU9dEkhFAqkvd?=
 =?us-ascii?Q?x+meQaY4Xg5XrOBkHz3ww0wQd8tn/B2W1bxFLOSkwMQl57RjQL0YCosHon38?=
 =?us-ascii?Q?X1xUEiCwvcfzwOx3p7YpJI5lnGAqtQRLfiLPLhR0PpGlH+cZKznmDkwNgwXV?=
 =?us-ascii?Q?OgwqujrqjtkKVq7aXRErKO0b70bnqQ8PmMeWhtR/IMvU0ZfUntEwAeI0DZNL?=
 =?us-ascii?Q?HIp6SeGDSR2XNJRKwSAwk2l1QpoJDvPLHZ5hGw4n4ogFniTcdftsVSG2RDGJ?=
 =?us-ascii?Q?XpNye559om90NV47qRblnZz4P6Mpjc6XOGof0Irz37p4VEwhIZdIwufCQmXs?=
 =?us-ascii?Q?0mgI7m3YD4MqZVDwV528gYr00qOvUwA/JsW5UIf79QufM9swuoBwG7gDS78a?=
 =?us-ascii?Q?1eOjhjHbrqROKcMkrUjFrioTU31Yrmqm/OgP4/xGnHCq7cNv6SVQPNSOFQGJ?=
 =?us-ascii?Q?N+zApQEbPBnK42CubRlamU4WV7OPWdjR2A9TmFIOmcUAHWZQGYNEWieQFvIR?=
 =?us-ascii?Q?1o0jsN/WRvYcCbQMEyWyUnoIFsrAfXTESHj86ioL4ui30zXrBBIxySwIkhI7?=
 =?us-ascii?Q?4z0kqph0ucoQE4R3TqfKVBJGJgrWorxFE/s9707/sBs7eajLTgMLRff/s4vg?=
 =?us-ascii?Q?N2J5H6jJCRXpc96AI7BMUeBl/mENrhV1Vm2ALrO+1Juk5tLfFglJMLe8E+ri?=
 =?us-ascii?Q?CD0VdcNwqCpfbJYB4Hp3iS65VPj5XAhF44U9u27L1taObQh6KL0UgSNVCQru?=
 =?us-ascii?Q?ySJ5OfbAeuzp8eHrL3jZsM+YLugjnKLuPai/htv00nO7I4439pd/YZfGXsnO?=
 =?us-ascii?Q?i7nFDEfr6qL6QVWNnzE2l6mcdS4/Hii6dBMxD1NLVyGJ9QYThzcylS65hoJk?=
 =?us-ascii?Q?97CK9+CW+NTVqlfg9K05p3CGsPMSH980dc/utO4igzm/n5xoBb9c6e0Zw9dJ?=
 =?us-ascii?Q?abCNjg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	g9r1rNs2LdmBcky2OiSDcVvL/ZnA/PbZ+AZ+bclIawuhH+vzBZiS4CtNlkBVvrmea/oELyBFC+aI9i/0tQjr7s0jbxv2kGwFrdkf0+H1zk8oVOuqRykR3hLFdG/ME8jNr75wzg7b9+pKbRW626YqX7Lcaylp04bIMwLE4RXOitqUZ8+mSibu6HQXThEvwiEv5Ba3IqekJYyYUeK9zVSKDNZfgjRzUZzq+6Kaoq08ZbmC1cIjWcfx6ljVqTvr67EEvOK0P+YEAva2LJ1pLPAPII1r3yfux4Ib7t/OnrHLGVdJn1NJqDhwvMwesn806QvY6HSY9D+RwbhtDnih/jdEuqr4dD0pFU3LWzaSgh/oaZT3g9lgqRXDyxuT1kQUN2fXd/D5qfKRygE74WZW6bnRztXR0B9BDPhXGpx8XIjWD/eiPdxDdVSn+AAgZctioVhK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:41.1001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a118353b-f719-4c3c-e850-08de72f3fee5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6071
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71488-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 4919E179415
X-Rspamd-Action: no action

From: Ankit Agrawal <ankita@nvidia.com>

EGM carveout memory is mapped directly into userspace (QEMU) and is not
added to the kernel. It is not managed by the kernel page allocator and
has no struct pages. The module can thus utilize the Linux memory manager's
memory_failure mechanism for regions with no struct pages. The Linux MM
code exposes register/unregister APIs allowing modules to register such
memory regions for memory_failure handling.

Register the EGM PFN range with the MM memory_failure infrastructure on
open, and unregister it on the last close. Provide a PFN-to-VMA offset
callback that validates the PFN is within the EGM region and the VMA,
then converts it to a file offset and records the poisoned offset in the
existing hashtable for reporting to userspace.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/egm.c | 100 +++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 2e4024c25e8a..5b60db6294a8 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -6,6 +6,7 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/nvgrace-egm.h>
 #include <linux/egm.h>
+#include <linux/memory-failure.h>
 
 #define MAX_EGM_NODES 4
 
@@ -23,6 +24,7 @@ struct chardev {
 	struct cdev cdev;
 	atomic_t open_count;
 	DECLARE_HASHTABLE(htbl, 0x10);
+	struct pfn_address_space pfn_address_space;
 };
 
 static struct nvgrace_egm_dev *
@@ -34,6 +36,94 @@ egm_chardev_to_nvgrace_egm_dev(struct chardev *egm_chardev)
 	return container_of(aux_dev, struct nvgrace_egm_dev, aux_dev);
 }
 
+static int pfn_memregion_offset(struct chardev *egm_chardev,
+				unsigned long pfn,
+				pgoff_t *pfn_offset_in_region)
+{
+	unsigned long start_pfn, num_pages;
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+
+	start_pfn = PHYS_PFN(egm_dev->egmphys);
+	num_pages = egm_dev->egmlength >> PAGE_SHIFT;
+
+	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
+		return -EFAULT;
+
+	*pfn_offset_in_region = pfn - start_pfn;
+
+	return 0;
+}
+
+static int track_ecc_offset(struct chardev *egm_chardev,
+			    unsigned long mem_offset)
+{
+	struct h_node *cur_page, *ecc_page;
+
+	hash_for_each_possible(egm_chardev->htbl, cur_page, node, mem_offset) {
+		if (cur_page->mem_offset == mem_offset)
+			return 0;
+	}
+
+	ecc_page = kzalloc(sizeof(*ecc_page), GFP_NOFS);
+	if (!ecc_page)
+		return -ENOMEM;
+
+	ecc_page->mem_offset = mem_offset;
+
+	hash_add(egm_chardev->htbl, &ecc_page->node, ecc_page->mem_offset);
+
+	return 0;
+}
+
+static int nvgrace_egm_pfn_to_vma_pgoff(struct vm_area_struct *vma,
+					unsigned long pfn,
+					pgoff_t *pgoff)
+{
+	struct chardev *egm_chardev = vma->vm_file->private_data;
+	pgoff_t vma_offset_in_region = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	pgoff_t pfn_offset_in_region;
+	int ret;
+
+	ret = pfn_memregion_offset(egm_chardev, pfn, &pfn_offset_in_region);
+	if (ret)
+		return ret;
+
+	/* Ensure PFN is not before VMA's start within the region */
+	if (pfn_offset_in_region < vma_offset_in_region)
+		return -EFAULT;
+
+	/* Calculate offset from VMA start */
+	*pgoff = vma->vm_pgoff +
+		 (pfn_offset_in_region - vma_offset_in_region);
+
+	/* Track and save the poisoned offset */
+	return track_ecc_offset(egm_chardev, *pgoff << PAGE_SHIFT);
+}
+
+static int
+nvgrace_egm_vfio_pci_register_pfn_range(struct inode *inode,
+					struct chardev *egm_chardev)
+{
+	struct nvgrace_egm_dev *egm_dev =
+		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
+	unsigned long pfn, nr_pages;
+	int ret;
+
+	pfn = PHYS_PFN(egm_dev->egmphys);
+	nr_pages = egm_dev->egmlength >> PAGE_SHIFT;
+
+	egm_chardev->pfn_address_space.node.start = pfn;
+	egm_chardev->pfn_address_space.node.last = pfn + nr_pages - 1;
+	egm_chardev->pfn_address_space.mapping = inode->i_mapping;
+	egm_chardev->pfn_address_space.pfn_to_vma_pgoff = nvgrace_egm_pfn_to_vma_pgoff;
+
+	ret = register_pfn_address_space(&egm_chardev->pfn_address_space);
+
+	return ret;
+}
+
 static int nvgrace_egm_open(struct inode *inode, struct file *file)
 {
 	struct chardev *egm_chardev =
@@ -41,6 +131,7 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
 	struct nvgrace_egm_dev *egm_dev =
 		egm_chardev_to_nvgrace_egm_dev(egm_chardev);
 	void *memaddr;
+	int ret;
 
 	if (atomic_cmpxchg(&egm_chardev->open_count, 0, 1) != 0)
 		return -EBUSY;
@@ -77,6 +168,13 @@ static int nvgrace_egm_open(struct inode *inode, struct file *file)
 
 	file->private_data = egm_chardev;
 
+	ret = nvgrace_egm_vfio_pci_register_pfn_range(inode, egm_chardev);
+	if (ret && ret != -EOPNOTSUPP) {
+		file->private_data = NULL;
+		atomic_dec(&egm_chardev->open_count);
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -85,6 +183,8 @@ static int nvgrace_egm_release(struct inode *inode, struct file *file)
 	struct chardev *egm_chardev =
 		container_of(inode->i_cdev, struct chardev, cdev);
 
+	unregister_pfn_address_space(&egm_chardev->pfn_address_space);
+
 	file->private_data = NULL;
 
 	atomic_dec(&egm_chardev->open_count);
-- 
2.34.1


