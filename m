Return-Path: <kvm+bounces-65732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D36CB4F5B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 036AB302A3A9
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4339F2D130C;
	Thu, 11 Dec 2025 07:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cD2Xm5W/"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010005.outbound.protection.outlook.com [52.101.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669CC2C0F65;
	Thu, 11 Dec 2025 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436791; cv=fail; b=bloJk3hugIrzHzr403YDVWLVTaS9sBns9OWiNhlugpid413MNGaJuKuZuCBXA2HS7xLLMcEeOSrQL67FDS4IQxw5uQGgSRtUrOrDpiSwE8TqQXhD6kxEOA2Dv2C/iWoANpr0xpiUo+73zfk23uyJ22JltUTfhj8+LolMCZ6mT50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436791; c=relaxed/simple;
	bh=OykvN3WVot5YOHuMxy9/W6f3FTTD8MGg/f7XDgP/H3M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HWHstVh/sMn9w8gIXenfRZEklRvrbOW9cXY6fUi83WGYVC5JiRhn9v9MGJ1SoqOayYIrvXaEsWvirzhxfLO01UR9Vyjkw9aD7Gr8qZWUc/SReiV16hBXYA5CuHTQ6IyY/Edipp1C+khPL7JE96LrSekvLBl5hnXbe27Jef6GgqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cD2Xm5W/; arc=fail smtp.client-ip=52.101.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c+pCtEOXzWCNkUHR0QFfMCLBM3RAKLeWsLdoMpuopG0wsp3cd1PwlcvlKYalX70Ad0ZlsFZkn5EB+Sak3gkCQD3krvgG2Yf7S9dDPtb+1jcdTfzx9Aq1ULubgpDcCyV6ovFHvUCzoQFAFTpPxwWQ/sFxjWHc1VxubPS10QsF5U88SqwDN1SXe9GDLhKny52d2WPCYnKzcNCqc/k75GnrGr8AB58Ul5i0yiZmYL1tim4MuDUfpm+c5X7BQ4Rd0szmN9oaur9tppCYvc3r1+uZxddVGdcL3NWKfphM3YsXa40B6q+4nOzu0l0DbqyFvzWmtXpfd2ZtsZOnc3t2W+Xo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=UFAZMV9zKWb6tuXjvl9aNctJZwef2yKwazCPoQ++y0BnBWLd9BPWb9kjl4LuVR6/GH+b3g4hPrgedYMqAqg6DrbYxfnd7kd/9+UINA2AUJTPezoLVfBiBRp0OMpmVKGBILF4ap11YY1h8FfVFqbMyqLbNIqXQ7jXgbibIisLKup6HiFUQ/iVLSYPzXQTziJvHcYb+lmo3lWjf6n6OsEid47ZVMnbcA4ftT/ewM7LBu8LZjkY/Li/fwn9woebrSHZhRR5xJrAT4jsULkMQEnO074+Fj1LtJU577DI8W22vjeYl5If44eWr9a5kruFaj1USA3TMXoFkFWgwkm+homOyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+9X97v8oLGLYonIialThNeDaSCMrIwHdgiUJqYKE3k=;
 b=cD2Xm5W/mttnPptKyFPUbiKFinviKfH+CnyuimbeQa5SOxpzCRIcZaQcUscnrHek5celwlhP+aDSj092caCNH2a8VSeETqvSJ9j4pm2GBC4zBuIKAdMh4an3r99f/1wFI6LjbSAwbRFYIUm82X43keQ4uejMwr/YMAf0Ub8fgaiVsCyzePh6TImS0GofvoD5fJOu2Elfyp/b/QsqO2SkiY6xvCjhdK0pWufK3ozh0tpcwuxNkzPA7M0vWUmBYBAEUnLjvTOius5rnN7/KM70JKfkhd+eN+dfou0YEVWtlMvcIcQAkHPLoQ71f/Tp8TwGEdsGBhwg7W0CLTX91DB9Hw==
Received: from CY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:930:8::12)
 by SJ5PPF5D591B24D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::994) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Thu, 11 Dec
 2025 07:06:22 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:8:cafe::1) by CY5PR03CA0005.outlook.office365.com
 (2603:10b6:930:8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.15 via Frontend Transport; Thu,
 11 Dec 2025 07:06:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:06 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:06 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 2/3] mm: add stubs for PFNMAP memory failure registration functions
Date: Thu, 11 Dec 2025 07:06:02 +0000
Message-ID: <20251211070603.338701-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|SJ5PPF5D591B24D:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f14862f-775c-4041-c210-08de3883ca99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?40+rQgZWodE/c2vkadDygEokaM4Guw0keMLKCgTwEhbQjjrHBKFIpwnrpwVr?=
 =?us-ascii?Q?EWYDafaLBAZi9Kyfq42e6TdBNGTnPXKwzYBhagQzwFbbK0ZXVCD2VOUWyJgo?=
 =?us-ascii?Q?bR2eoPkFqrlSnnfZ4FHjQDmzPSHfPMLH2jrwg7A/djtLA2ESqiZ9FsK0kXiS?=
 =?us-ascii?Q?uZhQ5F5sVEfQhkXD8rZ3C59ybHjJZ+C0K1y2MQ9GWkcxPMtR0/AJwyMCao/7?=
 =?us-ascii?Q?8IFPu1j1SkQ8aaWUSsstc3S/TL79vmbfOuH+L85dOcZIaWn3rv2OxMY85A45?=
 =?us-ascii?Q?n6RN55E3HBnM1XZMdWrh8H7C7PJkSU6KHmbUxn+t4VKoZffPNURpm4qfIoZi?=
 =?us-ascii?Q?WySi+N8cOaPiduUN3zs3FUtd8kGDhg29CX5SjeBdyVKXDdfiyQCkuLUaGQLK?=
 =?us-ascii?Q?Mqv/p8bgluzKyP6Qt8Q/KBnHq5vpq5PMByYWQ5HjZZu5gn3JRIe2v6I4DTIQ?=
 =?us-ascii?Q?n1Qes5yMP+YpnYI/fPuQtubYLHPUOE7z0Ln1G44Y5/w5DfJciP1Zcsl/lFVN?=
 =?us-ascii?Q?0nk1Pdky3Qs8yzUk5ULhSJSxeQ155VkqhaLPpIjPGeUeJ8nDe9n0wUBrfbn/?=
 =?us-ascii?Q?s2NSNuFZneGrW4t8LtigXJlwXrbbihT7+8i3qvbnR5n9cZ9Pb0y7TZUO8YjU?=
 =?us-ascii?Q?6ZNbnn4OfBV+Wujis4nn6d2DwaEb/EdTUkTCdoybz0WmG3VaalxyYUvViyf3?=
 =?us-ascii?Q?l6X5Y4oNiT/uQnklqYu5pAsQtTw4sJyhCVPGIwZAvvVi/qW88LqLoLzTezWE?=
 =?us-ascii?Q?e8DbKz7j0m/+QuBJdSYvDAxdRjTyn8Mh7pjoywkk97QWrgfgteoNCCvoQ7yl?=
 =?us-ascii?Q?CeukBS4F/JVO+9FBRC6JrZ76B9p2rfSvzXv9lTH0Oof2x5N5UbfGqu5qZQgu?=
 =?us-ascii?Q?D0Jhlp2IEbhltFN0oEpCkBrXosYH824SIuQow0wLAC5aR2phJWhG4DV1nds1?=
 =?us-ascii?Q?ATDhQg0I/w3GNKFFC3pnQQLdN1Scq1ibcEYH7t7A6Z1zms7I+2pmcyzf7GOQ?=
 =?us-ascii?Q?3VAoVUQVZsOUKT+vyS+AVcBykl9TfjhjsS2ypHVaSIme3djt3uP0fEZuAn4z?=
 =?us-ascii?Q?lCtYLmTz6Ax3Rsb4Wi7xbN2mSTTuU0JxbQPRIvV9H48ThyvzrR7MDmrwEUGo?=
 =?us-ascii?Q?6LC28AGUiXrtbIzab/rAgJOiCBCerO6pz/umGHCHe8mLhzW7ey0VxkSZq59n?=
 =?us-ascii?Q?ku7qW1gElMrkZ7mN0vjhUiqGaig6SMINhwOaIKCMj64FFDZNQ3+TXZeOkKkX?=
 =?us-ascii?Q?rtOPJN57ZAX/0DlnvfWDOUQwZwUuN0MIw9pJy9+B5rns349YZjwkQ9avBwIc?=
 =?us-ascii?Q?ACUBzariHbcax4ZMdfBqyphFznCEDabYT8eP6cbBOCNyef+XiIoUdIvUrAqH?=
 =?us-ascii?Q?A8KiXnP+hKAzYwIUbpAVnhRYNwJOLkYqqvmWBy6uDb+qt6Zy6BdGkjY/ajz3?=
 =?us-ascii?Q?+M0slF8oozdzcfYNa4ZA81XqU6oKDYLgfMcbpcTY1e+e/FcQUv7RD2fvqz5s?=
 =?us-ascii?Q?ARjXmQJbtwPQ55nFbEKjcYqY+5uJqNOOBD2PIUVWVANxsdROq//LDR6uBLi2?=
 =?us-ascii?Q?q2L3lpYBr6yyfaX3+IX3Jm4sNwSbm+yBj6C9Q6kl?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:22.2968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f14862f-775c-4041-c210-08de3883ca99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5D591B24D

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


