Return-Path: <kvm+bounces-68244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BC2D286AE
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89E6B30B9BA5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F32523909F;
	Thu, 15 Jan 2026 20:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JEcg5bOd"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012006.outbound.protection.outlook.com [52.101.48.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35F43242DD;
	Thu, 15 Jan 2026 20:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768508963; cv=fail; b=ktAfrbNYRTmkpGA3kLuXM5Ld0EKmqFzzAnc2FtumWrv+9TO8bfwZjhiwU1owHqaa5BuICrxP/ii6IOH2id2caulInUgziYExuZ+ns1p+In7E3wVx/szNxiwVp1NWWWnXMdi5WRQjV94RS7YwGJAGJ6UVbY39e1DkyOuwWfZOXX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768508963; c=relaxed/simple;
	bh=OykvN3WVot5YOHuMxy9/W6f3FTTD8MGg/f7XDgP/H3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8zS8xpgjiaQWfaRg6nzhNQSQ5IK4PEm6IlR0E6LhItoxP1LOp1mrqU5X7PVJt72j128ydLiSz3aCHzJNImkjopseK09uplmsX5ptOoSlts1ABjONvkiHi5jKY7Ieyb4GJQLZARCQ6l++qxkz0hzQHJdFAztSn9KThc1IEBVVUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JEcg5bOd; arc=fail smtp.client-ip=52.101.48.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qSYZrsThxwKV5mVSBWli2jphJrExEpm5W3ZQ4r117t67glgu/eh4bjjox1bhnZ8XghmkVPvQ8pvVNfp0MBLrppHVl1+C8hXRQXIomTWgSehf1TIMCG8lQm2PlPmUIW5nni46V7e5mkO7IWu1s1dfBIC5z13QPqOlBJN223QNRq3b5EBMr4Hobi+EcplkIeXBS5Og+GOJgT9O49hcRv/HdpM/hpMipqnD4KQdfm23YyYzhzO7BPefDsXjQm5jVUxK2hGYHO90yMWDo8IqAgSsuHawzN6ADoYpDsi8/hGz58V8hTlUQWN8kLfxGpRPHhodJYQsWBSKL/jWDuXizFmvwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=D+5ghpmzHffyaPU1Exe7Rzo3a8coKuQM3bGLZJIMg2XrXl6ijRenp2b2w9qTfsxljZMhUROQ8mo+D0wJFIdF/gps1TzoOXxkvxqUVph/2uEbhGVxUL8EltdLo31C/kbVldO6rjM9/hEHfEwY9WkncJaDcbpAjHRoi743Kj6VEHyRcr1UGIOP7lklupRoQSN+sZgzd/88fRbHPeH2jjenqN4k2lVapvmnE7zCY30VQa/GM+QayJZD7Q7TLETaoDSBNsXTNb6nXc1Q6/UMERUyZpGVp7AL8mWFqWIEKzp3lh9N0Y8zhTgRt4HYAONuBsSfG9mmdZmH4d45ZQ92DFtVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=JEcg5bOdgkOBL9SzMYr+2kL9naywV76olcx+JtjIGu4SBT0nZoMJ8KBqb9mK6Xlr98Kf00ibSahXzZnh/mvJ/MQPFYvfr/hdv7BW6MmObUKJVf3LFLbRSzrVyTqh0uRGX7G/JlCso/Reqj3x/6uyeQJHuxlUUX+VW8N5lxlE3TfEeeCaxxxLtr8ewHGG+k9Ej2t3ZIaE738Uly26gYT3ZoQOTKr7Nf/ihWx7EoHDS9wHmYm8r3egXLVkbzN3hfOnfo+WyHeZ2MA4y0dDKFlBYWl+2ypHH3rKh2/UlLyl4WtDEWU3b8o/GXsZEq23lmIr7luH1N+5LyWsQjN2RFFN4w==
Received: from MN0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:208:52f::8)
 by DM6PR12MB4465.namprd12.prod.outlook.com (2603:10b6:5:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 20:29:15 +0000
Received: from BL6PEPF00020E65.namprd04.prod.outlook.com
 (2603:10b6:208:52f:cafe::57) by MN0PR03CA0003.outlook.office365.com
 (2603:10b6:208:52f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Thu,
 15 Jan 2026 20:29:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00020E65.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 15 Jan 2026 20:29:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 12:28:52 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 15 Jan
 2026 12:28:51 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 15 Jan 2026 12:28:50 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 1/2] mm: add stubs for PFNMAP memory failure registration functions
Date: Thu, 15 Jan 2026 20:28:48 +0000
Message-ID: <20260115202849.2921-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260115202849.2921-1-ankita@nvidia.com>
References: <20260115202849.2921-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E65:EE_|DM6PR12MB4465:EE_
X-MS-Office365-Filtering-Correlation-Id: 4edc3f02-05f6-466e-8cba-08de5474bf2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ADgPXJjKy5/WXM7m+u+1q001YoaKpEe7ABDebyz++5PC7f+yG/3TFxgFXe/o?=
 =?us-ascii?Q?R2YJWDPdtZ1upbxbfkd9JmwjM04XwRRUc14Uc5eGvjiVkn3Kt+s9+laVCQ5+?=
 =?us-ascii?Q?pmSTVxkC22rTTr9zAUv8uGDEBn1cuduhmpRBWffHPYcIS67tEtB86xEov8Zz?=
 =?us-ascii?Q?sBmBs9jz9gvuBklNYILKXojFlHY863TJL0EVJ6qQ41gR9D5jY0up8ow6Gb4V?=
 =?us-ascii?Q?6nOLW8gigfR6e68Q6j8u0wDNIjrPCboweBh3jqOmmS8hVGki/XT0oQRa7CFb?=
 =?us-ascii?Q?09kJns3UqRuNMzIQ73Cr574oOm9v88zKdA9L84+gnXDW73OsjJTEQ0rQ16Xf?=
 =?us-ascii?Q?gxXxlr5XTAiONABBECleXRcmx1+VloEKJF6GZTgpeqzGyDFqw+D/mt4CKk/W?=
 =?us-ascii?Q?ywuOUlMAhpfOm8eWYuAxWQB6tfUa1jwazQ4gembaZlgN2FUEoTmxcbPsAuwM?=
 =?us-ascii?Q?RXEq0YOrDRI3MjwHgK/svQHb3xGQNfSIRuBEF5L4umZtAQObZzFbqW2sERVM?=
 =?us-ascii?Q?0TVqdQKcaOq84gNtNUkw7qoLKws+RFMVLyHBJbNPSiA4TP8x0kvAtYKO2co1?=
 =?us-ascii?Q?98eWxB74LkqWZHs0f6K3lHNwx37jdau+mezwNDNdrHy2mJBdjArlA9yzNWYN?=
 =?us-ascii?Q?ctBwiV7ZoHjEaOsOUg3qe4PYG1pRKOlmONKGM2EckGzbaa6E3d0hDopMEyzW?=
 =?us-ascii?Q?j1mhJoPM8pvLs/vlk9jr+gZEn3GBrI3oOJjIN0dHZ6HXa4FVi5h0WBGS/UeD?=
 =?us-ascii?Q?/AI/p7sJNAIwUHkYL8u1RtOhiP10xyK4B1KveYK8M+W6EE507o8x6h7PieI5?=
 =?us-ascii?Q?1JqwZ3uQra6hzFoCawcSjU0wUH/15ZD9OFsTPhJJkhfQ81vuocmOxlfCRmJ3?=
 =?us-ascii?Q?JPh8dBdM7/iRmJIAnuKdLNNDvNKqehYzyzNEdMRTDWhKWeIegl9R1KHjwIpg?=
 =?us-ascii?Q?OkLxo0HsFVMfmVylF+MBnRJ4552USOPcMTVNUxbLKHDrcfe6Xi2Z+zfAbVe8?=
 =?us-ascii?Q?vtg5XFj1NYX5uhQUSb6KmlXKhyqAE9Ui17ydq9FGUc1iUaiGQIriN+iPO30P?=
 =?us-ascii?Q?eImA1gXbDjHMRv4TXJeeN2oF3cvgJpw1V1z0jZvWfmAMDrrvVRB5ci3cdqpQ?=
 =?us-ascii?Q?e+wj+KEOLCxCc9ruKB0UNnGrzYA+WgGPbkSxOIxLIc27NUOIBo9zP47sdaHE?=
 =?us-ascii?Q?ALwxqWQpKqllkypV/nklX/dYff8lst4utQDmOYZj/urZIO0sPy0jZ8PuAps4?=
 =?us-ascii?Q?eej4KGjuiPtyLEqtg+/9eHQfFTz1HIsz1Vc6ga7+UNGP78TMJ1pO650PTPha?=
 =?us-ascii?Q?JF3JFnL9lPp06s0C/AJLXu5Y+QcMRyuANOiBdHe7YciCV12b7av23aI6u42P?=
 =?us-ascii?Q?n8m+sPsfe5qpkfY5xF/K2x9ChMKVTdasCtzVUJpMOhSzeOmjHiMYJwzURduq?=
 =?us-ascii?Q?2y4QHEakM9jbNRJWNUADkv8IW87OOs/odgH7dmxrrLX72m4w6EGwZU39MjgJ?=
 =?us-ascii?Q?Ew/B2g/RItV8sdvfJXiUf+Tsd/DJnUK6Nxi0Vztf+WkY0l/rSjrZG7Bd/SVV?=
 =?us-ascii?Q?f9UfYd31xWwDl6WUfTSrTRGESSoZTybGk4m0VqWy+Ga1ayGcUKce0wd/G8jJ?=
 =?us-ascii?Q?Jkmkr4spuNNELgIf0sKqzNPXG6Xuz0hGSB/YLjepOviJ85tlmLYaeRzJ8CMF?=
 =?us-ascii?Q?Vok2bw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 20:29:13.1702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4edc3f02-05f6-466e-8cba-08de5474bf2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4465

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


