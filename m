Return-Path: <kvm+bounces-67404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5DFD04003
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 16:47:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ED8FB302DC88
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F4734BA2E;
	Thu,  8 Jan 2026 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r9ChSAyd"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012057.outbound.protection.outlook.com [52.101.48.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2FD348440;
	Thu,  8 Jan 2026 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767886585; cv=fail; b=r2xiak300po9d8et69J09fg9MsxrAgqZnqndjA7D1K04ari8rwqWZW0xVNDUnMr7DdMcEkiM5XE59fA/uRgx6GS1EwcSFt5caUCYkWwKz29JxDSdqx7DKVJDoBXt/BiNDkbGAdbMXDhPuZ5BY1mtFAkVizMtZsElQ9jtaJLDk9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767886585; c=relaxed/simple;
	bh=OykvN3WVot5YOHuMxy9/W6f3FTTD8MGg/f7XDgP/H3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5XJR2raK1tvA0NaQWWVartGCRYDP2xTrEZm3y3yYdrf5flcYzwsCf2Vimv1fH6HOU6yUc7W7UHx6GT/T0CsSA10+/oTPRvgK9qxKPZkxsYWCxNpVnHQ880GQEHmOmqEecc4/+bpOYqFn/BfIRb5/JahY84DJlrA9Dg7JMi1eao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r9ChSAyd; arc=fail smtp.client-ip=52.101.48.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vF4AxJUNqnurfIrVqLkxobbCrR21V08X+950n0Pq57xrbyRrqlWxEYMhzhxfhko4yP6CPIWOGZ9MIrJoIuIDdlwbm1uQU04X+S0GqQWpw67JAzh9GeqDIffdPyr7Fsmdsj34cfb5l3Gw9E0RomulqBMVmVzMUPQWaQAFZtAcvI8QEM1weYF/76ULV1bwTRb4QzYwTPvIt89lR5hjI8EXqVl/EQwk2tZlUmeGYnW55gBnZ/6s2v9o3BXmUUjvlRx0XhpCl59Q6DEdzvRLRYQ8covFXhO4oDbAfpr01mQiNEIxC7QRawUvQgkbJxk9OcSJDAYKbCTcIo6UaU8lXVSpiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=qrZy5IOSNksQW04LdhnSysGsgyc3/tAsCCwWWuf4n4mDOEx0e++u6Afv95U137QjuuADTCzKQ4aITX9ACYMX9vFcBoWT9j2nAEwpvdNXKBUM7VO4/fJCpDkw3JnyUQdfoq7UYusnD5X3rC9pUuvRatkQKPNce2bh9Wme6JJs925pb594teDmfcHfqQB3w/eKsamxq6P5jVFuR3PwqKAIp2fW9w478p7OIkBWBw3xvx7N1MAcescCCpxqNcuq3BOIaYF3HwYpkd+nOyfg8XfBYf70m58y8lvFX/ROrG+z4s7HOHILzsPqGdK0Cp3/1wRyHT5+FzIMfWcx29kXvMYWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=r9ChSAyd4T6Pb7RPDs6FcrVjwgaylfmQvqEzgBXqFLYetSpe+UKbJTcZoN/ZLcLNSR7a8l0nEOW2ga/7vrqwILzbrHyCTdG0fmPqfwVi5QHDwXntPVo0kfu3ndvV3QGrhyw53VOZhtfC3l/vhGjpvg6PiIlJ8/35a53X24vMF39BddjYPupY651nJbk/2uqwn8G+i7rARLkM5hCbcRvKtKNo30YP8/jeuIBYNGiwiSxzhzq1X5DXQ5PRtGV2a6lecKI7u+lTLuDJah3JbwYrH9Rwy0Z0wc9ozi8ytQMj1lF6ZjKivB1/hJm/EMSyud30Yn3woPzmR4BBpLqPkf1hiA==
Received: from PH8PR02CA0002.namprd02.prod.outlook.com (2603:10b6:510:2d0::11)
 by CYXPR12MB9386.namprd12.prod.outlook.com (2603:10b6:930:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 15:36:11 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::e4) by PH8PR02CA0002.outlook.office365.com
 (2603:10b6:510:2d0::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Thu, 8
 Jan 2026 15:36:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 15:36:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:50 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:50 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 8 Jan 2026 07:35:49 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 1/2] mm: add stubs for PFNMAP memory failure registration functions
Date: Thu, 8 Jan 2026 15:35:47 +0000
Message-ID: <20260108153548.7386-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260108153548.7386-1-ankita@nvidia.com>
References: <20260108153548.7386-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|CYXPR12MB9386:EE_
X-MS-Office365-Filtering-Correlation-Id: b696db80-f2ba-40cf-46fe-08de4ecba65c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?atX4ALc52W6Sy2JXMjldgG7D8xHRBj0MnzmF/2Hp475iUYFgnnBecN71BGJc?=
 =?us-ascii?Q?BNA0kDiF9oPQu+MxZ7/yTliqVG80UkSkHoReV0sTFhY6qjvo764GeUrLHpT8?=
 =?us-ascii?Q?b1OTWYMF2eOLygJfTjeevX9/eS3UBK90pTjeA5XpHpAORPlI/ciGtMo7mNtR?=
 =?us-ascii?Q?adfn/sRCjHrxV14aUHLsaSJNFPeHJywJ1uk7Oi9PYwy3d6aTjX40a2Fq4cMd?=
 =?us-ascii?Q?hN8I1Kboo3T5HpNt/eFzy6YgDSUb656dwfV9yUa61dbt1LMbyxDeD9aI9vdz?=
 =?us-ascii?Q?CwmzPv9t56aONuY/iYfahbCw07Wr2dU/bbvKwkEEZjvWEh4KpePcp4VbC9HH?=
 =?us-ascii?Q?o0TpuxIrjBUJeiU6hGufeXNVL8O34f6pxv8LOZrTsCkATLoY0ROWZEaXMFMp?=
 =?us-ascii?Q?AiV3yu8+Qj3Qwf7LSAIC87TPKhq2Y0AN14m6AFP+iGBzeOByQt+OOPko7GWb?=
 =?us-ascii?Q?bWdBc6lBC/hXLeaGbMh+NLdYNdGRZb1iXyn89LNZC8jhWn0bwg4rDcNc2OnC?=
 =?us-ascii?Q?+HsnK6Tzp9/xwX+Mq10+VWNnjwu1bLKmMY4xsyAKR8y4SPwKmHpA96CRcKae?=
 =?us-ascii?Q?JJU/d3UfLkwThyY3Php9BRftPIUH98yHOhJ0jQbKHREwRgiMbOuUxjPHfh4D?=
 =?us-ascii?Q?HFmHQnQ8kNblHqeHlNPSUfoOfjPKHW0n/z/9kK9BWxm0ISLOykNmB27mjFKJ?=
 =?us-ascii?Q?eS8+LFdLvvKniQs764vd4kW0cdcTqbcfB8Woj65EcF99O4eO1sEY1a88+04H?=
 =?us-ascii?Q?nULmvGyQsxwLOukYfd9+snIwXLGlPxC9jnW5NlxEZAL2Jy/4CZDXRozQuH0j?=
 =?us-ascii?Q?7uPoZDicVn02oU/UpgxiERV/3uSKYCeyvHfabbGiozHKTs2bYoMu500mOvRD?=
 =?us-ascii?Q?6M8x0L/Ul2UCdY0Ly4Hc9rfYsqr1yMHpmcW+9EBKvfF8ahsoR5qqY6CzMSQH?=
 =?us-ascii?Q?E9dfMvDuedkq13KNbmrfmmliQcUP0hyYaqkAFjFggDKTTghkzC39e5/1sLAm?=
 =?us-ascii?Q?frkjMm/0SKoU3ymzVuqXrSbc+FP3p08f56kUlDeWrcTi2629gBoX+FJAcoiK?=
 =?us-ascii?Q?IvLK1LdPfl1NZSiO4wDKOZmXxgSrRg28IWmq0QOXWrhVb1TzorOi9AWCrEAX?=
 =?us-ascii?Q?xyPX9QbtuzUGWHN94PLUPJA9pnmVoUZlpKoyAu+hwf6A0Eo/DUn/tHvRjqjM?=
 =?us-ascii?Q?BcHuMkvZLFO3NvTgOXq4aM64DA4pLPe8c+OS5Of/MaLohvtHJ6T22NJ97FId?=
 =?us-ascii?Q?8fnjPnfATA6asjbjjwnh/Rxzf6pze9d7gkMDFklRTsLCCwb1w2TTzWYXfYc+?=
 =?us-ascii?Q?/re0XAk2mD7SxEA1joI/xvIRWQGkgfbGVY3zwHCPCI/W+z7+Ern1skd2UhyX?=
 =?us-ascii?Q?tjAptX8zi7VG20lueU2Qa2AZYV/+d0jfBnuH4dN1A+zu/o0cJvBxa8iOjUs0?=
 =?us-ascii?Q?LSzbtmviFZAYA4ReemQceBpyL6Efw6DYBhRl2H3ggq9M+mOk0jBNen4TRRWk?=
 =?us-ascii?Q?K7Bl0t0cFj854z3Htd90uBevmRDg4yv7gMiBfdEpaFLSumO5sVekAVZizeQl?=
 =?us-ascii?Q?kiwbYGiuOQL9QYkXC0M=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:36:10.7961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b696db80-f2ba-40cf-46fe-08de4ecba65c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9386

From: Ankit Agrawal <ankita@nvidia.com>

Add stubs to address CONFIG_MEMORY_FAILURE disabled.

Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index 7b5e11cf905f..d333dcdbeae7 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -4,8 +4,6 @@
 
 #include <linux/interval_tree.h>
 
-struct pfn_address_space;
-
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
@@ -13,7 +11,18 @@ struct pfn_address_space {
 				unsigned long pfn, pgoff_t *pgoff);
 };
 
+#ifdef CONFIG_MEMORY_FAILURE
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
 void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+#else
+static inline int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+}
+#endif /* CONFIG_MEMORY_FAILURE */
 
 #endif /* _LINUX_MEMORY_FAILURE_H */
-- 
2.34.1


