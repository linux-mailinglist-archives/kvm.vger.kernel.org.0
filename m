Return-Path: <kvm+bounces-39187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F484A44F09
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C6A416F1D6
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6E920FA9B;
	Tue, 25 Feb 2025 21:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uP5D6uYA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BB51925B8;
	Tue, 25 Feb 2025 21:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740519595; cv=fail; b=UHSZhiXysKyXd9eMjDuCJM2ZUQgSpMBo5374AA4/FMxl3yqAtIzxQZWQHrcJBidLRAOP37BqO/wVCOILHg1ey8Sby3Z6l8557UQS7ePMztcr27pAMOWWkDLcNverbZWeQ3zFLNHJwPNSpAnw5MFzSEWZTnxaX0j5toxPB8xkYWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740519595; c=relaxed/simple;
	bh=FSA9uzl/SPN7OFMyhljhAPW17X7uE7Ad7ZkrQdvZeHc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZOTx+z5qp8jFfzgyEGzAZWewy8xPLm1o6gdmb+A8lYW9v4ETjUYFiNEwlTXdZXlMOZeI41byqCKTCWRjhbESFv6FU4xva9BtnNzrHBvS3Wk+WI2Q1S8ovE5j+OH8pH/ZG8wu3LON4WoF1NvSOVppyixyE1KC6EFl+/4E8Hz+lqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uP5D6uYA; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/RUu7xKOGo7YbDbrz4mTO6UVhcbiLy75Giw7kguf/NmyNxBfRLw7iJs1Mb/KLrF9a9MkfcE74k+j3czKyqJpacJJtxycsn/702Sr/fgpKSTLoTMIj/T3zuYVc5VaFVqcFsI/4iZRnyK16XIr7/xcSoDDsUkOhD2mk/93n9+ZbMXVFBbItcEXk+IVao6B/rMniE6qSUVLPlyf1iHjBg5YEDdzO/fURBofzsj9DVjkiuwf4/EDdj0rodTtfPWkzVsUXODZ9GX3z+Amh2uxYWftoP4YZRjhyHN5mzaGDmxdBB1RNC04EXZfpBaA646rbrdQ4UX6x9NFXTl4CMYSIG5bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wv3wJdB53HnkFG/eBG6BXhYDKS3AfM63sWiNK+RtS80=;
 b=jkvahOGh9ll6ywwmhJX4tZ8mV1puJ0T5htNBfCUkvX9iNjkxqBGhDKJtfzIT+XjARThEcC6CQDjVA6VnkQeJfEDJfUDzIh6AnziETQ1Zhigf5ymFz3cCVHUbGhvJLCPHm14Bn+Q+9YPJUCB8NSPXoy+1m+eNq8W7ZSUmDtTEFeoaZNzIwRYPTmbSqyPkGvxMc8q+gW5ctNf8aRzkDtyMuaIemJzpYihbaD40ffOeUCTCt5p8Yg7nqRGRL/fwGi5Ar8GPOLuSENpOEuxpmuA0WPD2GPKBUuHwxnvTcdBvUGIZqJV7HVtKPqtsHNhAg3ZhD1hgFWSaUc0UCLEnfg/DwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wv3wJdB53HnkFG/eBG6BXhYDKS3AfM63sWiNK+RtS80=;
 b=uP5D6uYABHK9rBvPwwfaIYlD+DRuj7Hr5ezNbSYBa98rqiWXW+sKyBS6inkgFKwZgeSrisQE06FsM+SC4JpG2pUv0hf2eWuSr1S7C2gM2BuwmM+6XFdMAv0+Av4IuIQj9dhEAPE7sIi+yI60u/b6lXVCLvGPUWgRwRH8iepw/TE=
Received: from SN7PR18CA0021.namprd18.prod.outlook.com (2603:10b6:806:f3::12)
 by PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 21:39:51 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:806:f3:cafe::e4) by SN7PR18CA0021.outlook.office365.com
 (2603:10b6:806:f3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.18 via Frontend Transport; Tue,
 25 Feb 2025 21:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:39:51 +0000
Received: from ethanolx5646host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:39:50 -0600
From: Melody Wang <huibo.wang@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Paluri PavanKumar <pavankumar.paluri@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v5 0/2] KVM: SVM: Make VMGEXIT GHCB exit codes more readable
Date: Tue, 25 Feb 2025 21:39:35 +0000
Message-ID: <20250225213937.2471419-1-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: 70571d52-42a2-43b2-f57c-08dd55e4ef79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LIajJvrW5lJ6WX4iTsHG1dTCUicDUdgauu8EfM9olWG/Lz01CRAXbVHkW2Cx?=
 =?us-ascii?Q?Ahrso7LuJ7EBbliFi1UVGxcwXino/OoheFedoui2QTuacC1Z1OJVkTOw2PFM?=
 =?us-ascii?Q?9mJF35Z1FZYpXosoSc9nxOwNiBfVtTnZ9DxGuRPyBX5Te0RozUADJ5VAn1Wa?=
 =?us-ascii?Q?ms24nESOhRlaQP0EmMDx1Ac10L3cIjd0b/Pr39U1X3tIdUWkLRDEJxWC8cEb?=
 =?us-ascii?Q?EKwTkMvjQFKN/PoUCV6kyzeyJ0g0GowgjGpjME2fyH4gx+kmuXDYwAJXrViX?=
 =?us-ascii?Q?9vI/7yB0WcrV+8sHtcwcVyjG1KPnw0uHAQA/kVzt0/9qEXKMTxFMo/SIPMp1?=
 =?us-ascii?Q?/0vr9aoRyBsSJ0s0FAk0T4duw84ZaQDkcjZrY+yf+co+tI9SZkJoPfABGB0b?=
 =?us-ascii?Q?utoIuNqGo42CTT1gmd9RSQVEHXP1wCNV3VIDvgnjn4tmLhRf5jiZx6ubJeur?=
 =?us-ascii?Q?0OI5jLKdNA88m0D5U6ky6q6rGfjSz91kw/Wq45VBskcpVq3ZBIA3vpRpmGC/?=
 =?us-ascii?Q?3LYrZrm0Us8y5CLZ/JWnP+fvaZhFmf9vMsO5sgcZlxGMEmS/T3ftEvfrbOKC?=
 =?us-ascii?Q?4a5X3qBZ+n3rY2RgFIoycIHH8Z0H7V5ezlULYet6J3Pt4sy3Y16jdaI4erR1?=
 =?us-ascii?Q?AjrRH7aEgLaULEY1s3p0rvpHSqZQrmP4yzSQ/HmO+ruK2mATqo9MITxvAqzi?=
 =?us-ascii?Q?4nZGtv75e60yBRzs3Dz+J2Kl6l6bQMJrQ7K4QoVGnLem8Lrf4NVnDDFS3QK8?=
 =?us-ascii?Q?bdd+YbMSyJksn8fTFaQezkreAiuhUGWk/MPB8+LDMeGJiM9kbfkLYj3aMfj+?=
 =?us-ascii?Q?Hibf17ZScvIWO7YkdG5h/68tNyvqayfFv6Wv7gJq3zvnqHoRdQCxUINPqMFd?=
 =?us-ascii?Q?pBMCaZuQY0FuqGbHjnn4hVKWOR2duBoFljRtTcySmK51mVWYwYiLsd7DinLQ?=
 =?us-ascii?Q?KQ2x3cQJYnUq7A0MGbzh6ZzbZmT1G7TCin9CZXH4ujqTBrp34sY3CGVZYQQq?=
 =?us-ascii?Q?X0HWHoC9AOT/Fe1EP3iZyexQSf7Dfhp0+UQbmCuhdOUc/Pk41wMrJPRDOX79?=
 =?us-ascii?Q?XKK+5KC6c5qPiK5eJ17ZjS0uVPUaPBq5+t3gtfwmWT5npOQD4y1aIF5EFQ7k?=
 =?us-ascii?Q?/hBNF6HUF+nZR5Rlt5oI1+zeVfjHrmNiiRDY8TLAS92Rcp1QKu3oDQQWsiRn?=
 =?us-ascii?Q?+agExSy2HEYpmjtxFPPxTth3rCpT5tXqwwDDE48J/0C5MbyurAM8ryx1YpWz?=
 =?us-ascii?Q?tASkqxZYwOfgFk8mGbUiO/hniIz02rBR0ru28hDD0dL4Q/08QOrFI0LvXM13?=
 =?us-ascii?Q?Zg5j9H2wt6SH9d5/Mvw1RxlBvn72GR92c3/fAhxrRs+b54R/XxWI59kShDje?=
 =?us-ascii?Q?d7hm96jaaDSAuv25uW+6z9IauyA1mrByjo2huaueAN5wjDqyLg6tUyY8Cwpb?=
 =?us-ascii?Q?H7GEiCAeo1x/jeNL1XLpgBcdLk08jtff0nVHPCxd27WxQEUCIDU9wXH05pWI?=
 =?us-ascii?Q?Q2xaNVfRB6377L4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:39:51.4349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70571d52-42a2-43b2-f57c-08dd55e4ef79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915

This patchset includes two patches to make VMGEXIT GHCB exit codes returned by the
hypervisor more readable. One patch coverts plain error code numbers to defines, the
other one adds helpers to set the error code.

No functionality changed.

Thanks,
Melody

Changelog:

Changes since v4:
* Add explanation comment about svm_vmgexit_no_action() is corresponding to SW_EXITINFO1.
* Add explanation comment about svm_vmgexit_no_action() when the request failed due to a firmware error.

Changes since v3:
* Document the weirdness with PSC's SW_EXITINFO1.
* Add svm_vmgexit_no_action() helper along with svm_vmgexit_success() to clarify meaning.
* Change GHCB_HV_RESP_SUCCESS to GHCB_HV_RESP_NO_ACTION to avoid the confusion.

Changes since v2:
* Add one patch for providing helpers to set the error code when converting VMGEXIT SW_EXITINFO1 and
SW_EXITINFO2 codes from plain numbers to proper defines.
* Add comments for better code readability.

Changes since v1: Rebase with the latest KVM next.

Melody Wang (2):
  KVM: SVM: Convert plain error code numbers to defines
  KVM: SVM: Provide helpers to set the error code

 arch/x86/include/asm/sev-common.h |  8 +++++++
 arch/x86/kvm/svm/sev.c            | 39 +++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c            |  6 +----
 arch/x86/kvm/svm/svm.h            | 29 +++++++++++++++++++++++
 4 files changed, 59 insertions(+), 23 deletions(-)

-- 
2.34.1


