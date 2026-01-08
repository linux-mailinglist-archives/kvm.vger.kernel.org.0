Return-Path: <kvm+bounces-67402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F442D04267
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 16B4F3195ED0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 15:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882A834888A;
	Thu,  8 Jan 2026 15:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XmdxSfG6"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012054.outbound.protection.outlook.com [40.107.209.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FB6345CAF;
	Thu,  8 Jan 2026 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767886578; cv=fail; b=WZVnw1JGN6c8YzaeDe9QZtIK7kAVtVjB5PhswShrWxoKmsTue2g6vmkOCYEP9LFKozQiEMz0Rqldaq61jNxTwJMTKawSGkCH3FsmHRjfAlcym09YllbPvtUoGLzXbK2uFBsdllFfy2PcQyZdLFDlNs7q6atBi6FwSHdg09eKtJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767886578; c=relaxed/simple;
	bh=Lo4LrgYA4y/Q7uNSYf0hVJrhu0cCWRGudaRdo6lXlJU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qOshqSKw0IH1KFORLj+gS9iizUTD1pBkUO7chSeKvtbt46eicxhKG50z7RG8BrH/9mM1W/uIm9Qy9XZNZVLZOrjobL/Dz49r/6URCfQ9GCXfWQfFRHgiD4V/AcqWNPl03hlaOsdC1kkRwjqoXxmHZzmz77DmHG+jB6ZX0EBFU6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XmdxSfG6; arc=fail smtp.client-ip=40.107.209.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v4z1JF7na9aMkgwb0WWtXh5Ai69J5m85RLFIdNFCeytH1ZK450ZbmAXjtXFg2Ijn2RqwzhsE7lElejSCIF/fiyZTCaIl5/o4MF8Kj2sNUMMvSShntzr0aZTKsQItOBe6AIema/IQCQxB59Fa+E+EqwqzaZvq2X34oCtvSCPuLbwWm+LT8kqN/zbLE2iqxFei2Zjwkv2EOBd6CPm3nOAMlRG2xB13QH/C9e8DGRLn0P8gfirpK3eA+lmogDwazgyfRiD1V8XCg/2dVa1xvFbwOiIVsFbYTbic075/mTNzcG2QYZwN5azCUpCOj+QMnSV4CdHCCEC9UOJr6wwelMKg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NeimiKEaWKBODPAhOJjp9hW8Wh4xaO+QWH7ytv/Kw8=;
 b=FdWx0w9dpy3QKu0MVre8GprQJ0qWCTyugvgVdTnX2P+uY6h4o4snTD+ugjNgq4Meia8rO7dRFcy0O43RSiEzcsRNG0njI1KeodQ5VVc1kXwuJgWxj8Di2rLFCNAo2Jq6fNJl9McQy7ezf0UdzYg95z+ZdcyUBUdHqhfR+JcackIa5NxkWfyPtpIKETqtkmNU77uuNK+kiW7VOyWzNcUmsJBJWwhyrb+EoudESW7AT8m9Licar3OqKqpvxk4XAcKGUInF2O/ccPr5eUKUMa4sj17egZU89e7h4AjANKjpKH4sfzzfcbwPRrFSWNMrVTSGh+RTBS+vfwmV3dwqSMsQig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NeimiKEaWKBODPAhOJjp9hW8Wh4xaO+QWH7ytv/Kw8=;
 b=XmdxSfG6aKHZXNaPRhr92IKdBPYsoxCcGA7/0oqWsL5jTmPY3goh/ubj3FF6v/Nlf94DK98qgB2kl2+9HFxTJG0JaBJO7XZJNBxpNLIKPq7Xn65Atm8cNL7RoG6biZA7FbTQsQCSBneFnXCY+AxFm8A4AQNOEX0kClTteJtXhALv4QrUX+9ms0JPBBMa4Csfoq0axkIpLpEj68FkdHgqKZFouYw9dBf20cLi4xdjnAk1D0HWp0/nquQ1sKgYKOIlgRes3DnZmH1VzQviKU+ezUWuwg45J+iI5TUiPOeDOT5YrQBnbRqxfV+/fMPWd3vy07u2ZCDnx0rET7m3AFAAtw==
Received: from SJ0PR05CA0054.namprd05.prod.outlook.com (2603:10b6:a03:33f::29)
 by IA0PR12MB8905.namprd12.prod.outlook.com (2603:10b6:208:484::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 8 Jan
 2026 15:36:10 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::4c) by SJ0PR05CA0054.outlook.office365.com
 (2603:10b6:a03:33f::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.1 via Frontend Transport; Thu, 8
 Jan 2026 15:36:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 15:36:09 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:49 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 8 Jan
 2026 07:35:49 -0800
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
Subject: [PATCH v1 0/2] Register device memory for poison handling
Date: Thu, 8 Jan 2026 15:35:46 +0000
Message-ID: <20260108153548.7386-1-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|IA0PR12MB8905:EE_
X-MS-Office365-Filtering-Correlation-Id: 490cb19a-a7e5-4ec3-4434-08de4ecba5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VYFLA3+MugzL0fFErz/U5ONDrx4HGzyXWpjncMQ9OYgkBU6NfTGRazbtEEzD?=
 =?us-ascii?Q?JgU6wlFBf0b4drr2jW1O9NfLlgTKF9vfXVQcEOobwlpYITgAC7s7lZCh/edc?=
 =?us-ascii?Q?mwjIdjMnblD+XhPnt4I3t/4FzD2alwcj1sT8iXK1y4tO1cjtLhTV9DPMCII2?=
 =?us-ascii?Q?pZD+oWv+zxfww8V/NtgLK3Og/G1mc9yivgSa+hfUIcKgg2R8Y5CINwRDz0wr?=
 =?us-ascii?Q?NDogx86mnQNvgbrMgk7DWZCGi6lrrVpv8ga0R8pr4lez5CsLHvln9w1qETi4?=
 =?us-ascii?Q?TTkdmuK9Iac1/U0w+QDLchuUKJYmlHaOut4wFI1A5CGKv2nn7Nup19ASmaDj?=
 =?us-ascii?Q?Mm7e2XOAZR+MKic3k4cHyekDGSblZd5pdDzo51QGHI0TNRNlgchowgmM4gU0?=
 =?us-ascii?Q?I2Th7scjbXFyPDFmgI5qAR4C5+r+tjjo49CZVntcjtPKgAgn8ESbXL2dNCpV?=
 =?us-ascii?Q?nWNchJsra+cCPUSYD+A5syg8/31QxQahCpMbQNwOGBQcTkmQB1CBofLjvr+E?=
 =?us-ascii?Q?oFgTVLtc/hEY5forB85iI/N12dQWhgmKgrwwBOWJe0mzafJLM8pTN384UqIx?=
 =?us-ascii?Q?VTQ0ZzAS6IUiClUkkibJfZCKde/sPXDfLApdr7NsCjQskPkIRXR4Y8gMYohN?=
 =?us-ascii?Q?UkCs8xTY2PK51SpoXVEH+cZPFmR3aqbE3qyVP7HcR3i8gX0Be/wVF43PbMrb?=
 =?us-ascii?Q?TquzfgHQZYJjGV9fuPPgGpLL+nbV3x8O9BzkwuApNivsyWqyjX9rl5xxkbMm?=
 =?us-ascii?Q?/tp55Egm0FhYW1aK4IVF+A/bDScfFpIovQnJCyMmCYLr2wYh7XrscoCtFb+1?=
 =?us-ascii?Q?eOltc3thaQXWr57PbNbWp5KBnAjpj8aW3G9Qb6oV+72ON7U5xPs2N/3fMyu4?=
 =?us-ascii?Q?NLGfv8D0FV14yGaZJj81Ll3nSQF/WTt+xzrynpmzXjw8TKo6z+G8qVAL2oSt?=
 =?us-ascii?Q?lMqZKGBOojrx3bvbBCGUqebqAbldOHDfC85fLQt/6MYeFDwQtD/p4yyj+zla?=
 =?us-ascii?Q?5isAGGlxa7qaUazOKrWqRKTHhNqhO+oUJCpqsL5OuNjlzcIiB6PKb0Zez7qn?=
 =?us-ascii?Q?BCL+Bt6Ia+F1R8UnwPkfN3LCngrD7NPm3NiKfEz8a6v8rnUYF4Il+hEJF7og?=
 =?us-ascii?Q?pkvv+c9hYoTz4Lewb8p747bC5uRnt3OTtRNtH2ocqNWfQULrnC5i/+waAxK0?=
 =?us-ascii?Q?ZnsHt9W7dpNAZ3Z19NFJsfV+ytfyITX9XrXcHa/wr7WIoiL9vvrHVA6ZWTut?=
 =?us-ascii?Q?OE7yNUMzou9aO1hUzLeXgLUytZJb36RS6j5u936yDjxRgi3drT88YKCCD+eG?=
 =?us-ascii?Q?F4m0a7bHj3vlYD7Zk9Rj91h6NFe0zfVTVZZsUMzqqjyo++uqXntTcCj9Gw4X?=
 =?us-ascii?Q?Y4YWnsJA99212XMFFhrmRaotkIJwtTW+AeB2EB7aDGTo/85Af8lNzfTM69bO?=
 =?us-ascii?Q?r+e5Zdj3Yhlf6G38nKdnWy8/WjztAdK3ari2MZwUMMS+Lw16H4zh31zDIRxe?=
 =?us-ascii?Q?ubeeRNuRtD24MurQq0aAy5kLaPCJme8nP0RgSf5revXNTfeyNucvlJzu/fjG?=
 =?us-ascii?Q?CW5NxpK7k9DRPrWPEhM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 15:36:09.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 490cb19a-a7e5-4ec3-4434-08de4ecba5c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8905

From: Ankit Agrawal <ankita@nvidia.com>

Linux MM provides interfaces to allow a driver to [un]register device
memory not backed by struct page for poison handling through
memory_failure.

The device memory on NVIDIA Grace based systems are not added to the
kernel and are not backed by struct pages. So nvgrace-gpu module
which manages the device memory can make use of these interfaces to
get the benefit of poison handling. Make nvgrace-gpu register the device
memory with the MM on open.

Moreover, the stubs are added to accommodate for CONFIG_MEMORY_FAILURE
being disabled.

Patch 1/2 introduces stubs for CONFIG_MEMORY_FAILURE disabled.
Patch 2/2 registers the device memory at the time of open instead of mmap.

Note that this is a reposting of an earlier series [1] which is partly
(patch 1/3) merged to v6.19-rc4. This one addresses the leftover patching.
Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
(alex@shazbot.org) for valuable suggestions.

Link: https://lore.kernel.org/all/20251213044708.3610-1-ankita@nvidia.com/ [1]

Ankit Agrawal (2):
  mm: add stubs for PFNMAP memory failure registration functions
  vfio/nvgrace-gpu: register device memory for poison handling

 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 include/linux/memory-failure.h      |  13 +++-
 2 files changed, 123 insertions(+), 6 deletions(-)

-- 
2.34.1


