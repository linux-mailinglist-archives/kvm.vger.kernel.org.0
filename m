Return-Path: <kvm+bounces-34588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3687CA025E1
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A44407A2274
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2578A41C79;
	Mon,  6 Jan 2025 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C9Um787f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8376D433CE;
	Mon,  6 Jan 2025 12:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167638; cv=fail; b=Iw51dfGWuJFttPkTpR265wI6cpAnbDpK0FqNie+JF0rvgogW2hqgi7ZC7AFUmjMFB2F7xkufY9CFAzvUd+/SdnRV1LQLSoOu7XvyRLPTQoC62S0mUBDG7SPRQPgBpIijr5vxj1HNxXJccPjByIfg1ybbrfkV3cXXA/SjyWKH240=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167638; c=relaxed/simple;
	bh=wSpfOPouoAVLQNxP9qQMcZ4Haxg+JPzmTVvdZw7mpWs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KocNQNbxQiRg4BGB9+dyUMwgq/fAK+25wXr2ibwR4ZtDwrtqRnFGjgJh66L1uUXRFnnvG2PnQaCb3SwgBuioK2udtOGubzOxSBd5bhdYJItkOngo12mPVFem7LK9BrMAIpSgn0sOtYBFZM9TVWDdJEMnYDbZr6x2TmIxEo8Ock0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C9Um787f; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KpzPHT7veucDezz/xQ3VqIGGPfYLfMQ8or6T8GPX8Zymot0ZmyOHmidu01GxwAV1IU8Nc/g+JGWjsEFT50h04VBgceMHyz05UOmuJLcfyE2Ei6SJ/czb2Teg/XyYDoeRupN5I4j/13W5FUbLg3JPtSzjOJSR9UHjPOjpK2GUEDBoBTpl+vMVqoPKPQw7nYInggjEsEMBfmaKKg9xU835YtO/QXOj3A1XcSbTElTNPLji8yDkGOMC0Gt6Y75+YoCqlEgqWvUyl4FHExcj01S4FxhS6jnM5h6265xWOHmp8fCKLZ2b8whap3VddD3hSOVbXOIn+kIEvVrvvekB3h/hpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJJ6SZxjWvhd1AZdXMTE1H5k5Lwu+wz58viTHpu7vdk=;
 b=mq/UoV4X3zcuTnj25abcvCFWeN7oPNfRgmF2PHKUjpHBZOxNDQpOSksDGzF7I5TiOhir6YPXeFkGfOZCISw+p+a+aod4Tve8e4Mz9VZiRtlXLmffnM5ewmXCwWeFzcgQVMapf0PVGtbLhBoDtd2osrk6RG1yAmq1w2PD0UmRojooIRcTFuGPUiXrgKMZ0vmmB+2Q4Sa6V+Tl6rHKpsqHnbsKVqMMC2IL8RmIC1sUwShGKQMy7e1GTWWfgyu5u6mzyRkWw7zBkKILb+KzWJ6HdbKbvav3lDAfhLFUVg7lcTRag04OjujF4jysyQE1wjYWcWL4jfGaJ0+UJ0UWpVneig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJJ6SZxjWvhd1AZdXMTE1H5k5Lwu+wz58viTHpu7vdk=;
 b=C9Um787fj1ZslNou6s1hGG0OEqbxlzLZQEy1h0M7Vke80FsqonULStm5oAcbVa62rJlKYBdq398E6DLc780E2zQvyf5NyIK5xzhEp9SFNXVZeGleUlkullFpMA5yTLtQJ/RVDn9VE+SgbfSdDGFxsXD67fvREeP2+TYSpR0Wizg=
Received: from PH7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::34)
 by CY5PR12MB6298.namprd12.prod.outlook.com (2603:10b6:930:21::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:47:06 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:510:33a:cafe::10) by PH7P222CA0013.outlook.office365.com
 (2603:10b6:510:33a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Mon,
 6 Jan 2025 12:47:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:05 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:01 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 02/13] virt: sev-guest: Replace GFP_KERNEL_ACCOUNT with GFP_KERNEL
Date: Mon, 6 Jan 2025 18:16:22 +0530
Message-ID: <20250106124633.1418972-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|CY5PR12MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f158e3a-fe0d-4be9-c38b-08dd2e5039e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GjOpV7LEBwuYScuGGuSdnIaAquWu+cl3hBR6I2j1xMB+ZcFJaDXVptbyVJmJ?=
 =?us-ascii?Q?GFA5Y95ygNJ/n/WvNQ4kyD6RTNPC37vwSEEYIWSRVpjMhNdVPNJwEfHz8imr?=
 =?us-ascii?Q?IhAB04hrpb64I8XMkDpm5Yh7Pc1iE/vh0gGU9bcDn18NpBoOBl30UAa7dZny?=
 =?us-ascii?Q?VIFRlLoyD+UWOcRlwBc4FtfqHkTlwXTsDK+BqETQGcB9tPGCLKOvvBDXrbzU?=
 =?us-ascii?Q?rSJxVOcX7jSxt7OUqD+AiMsiiyDwo9IGqhO5f3/A+XwbRitwZ7C6kVDD6iso?=
 =?us-ascii?Q?yX6x9kvipBcc/tw5hyYU+4HNz3urVzOtK5NCp1AUbJqIJUYreYOeuvCZ/jgU?=
 =?us-ascii?Q?+VO9+SwaeLWDvszlEswtrspsfpmGg7k8QnV1jcuFiB9VlmsyclVIncKyJZOb?=
 =?us-ascii?Q?sWo5om2oZDQy9INg3hGeYwxxxXALUiPLcQc/HgCJQKAALHG9GQaf+kR5hg1A?=
 =?us-ascii?Q?1xMMz0Cpbg7HgWPgQwSjdw26sX5Zo2khIhhTUUwnQvBT5LJWTOtkorIYh4UY?=
 =?us-ascii?Q?QYtquiKzM7/awMlqtUgMnhHWC20sHt1yFHlNESYC5qSfCxpAWThzsWJlt63u?=
 =?us-ascii?Q?/w0wsmxmJQJAiMLg0j7bAxHcVqR9thYt+Fy6cdR1lkjiQ/Am1BoxJjt+vor7?=
 =?us-ascii?Q?QxdSbDyQRMZdOGUCJ4bup9r8GI5Jvr8flfT2P/wQEJ2HKIYAvQm5TN20ODad?=
 =?us-ascii?Q?0z6HOH1FMi53acLV83ORhj86YACGJludBhpxmmSvPCoD7fo7UNMI3TwcPCxs?=
 =?us-ascii?Q?fFyUQu9db7+iRBqxb/GRbC9Cy/HfxmWANM3AT4vdf0JRmI7Z9OFbqKocWOfT?=
 =?us-ascii?Q?TdHFHFnARDDrQVHOgZMyvEWPM6xojx1SmWa1VwbKdCibD7Vsb826vEbVJDml?=
 =?us-ascii?Q?mtVsePLAkJTQ4opKLVuwurDov8PxaXocUA0AFtUh5nPwWQ841ML5sm8CeRdb?=
 =?us-ascii?Q?bJNsHlD3b4DRClEQRR4EBRdsLunNy0O9kCIK405ig0322+UH0ua6ejKOA0iI?=
 =?us-ascii?Q?jEVgWOX5zcfKLjVPfeMTu9vhusewVpDWXBQU1rx4RcOMc/Tnei2F1nfY2tBy?=
 =?us-ascii?Q?Eqs7+87PUV4pWyJlah1Ztp2r9YC0dz8SOmKppUfeji4qoQpn/R+P4EYfBFzD?=
 =?us-ascii?Q?aPhzOXA/seklrRLEIa8DAofmSVuKSx+b0KbOiZNFkeMCZnoP/9Nqi3onV2vm?=
 =?us-ascii?Q?61pjFvcLo3A9OMc3upjNnxUaLkTQGi0gWO7jc/3mDA5gDW79RiuMSr1Jv4YG?=
 =?us-ascii?Q?gZyYb/mvruwY19I2W2Agtisq+kOqCtO8xpoBBf0q/BqsHseSMsTkL6GkRMmc?=
 =?us-ascii?Q?I9nIydedyaBsUqU5L+J8KXBJW4s94xYgAN6xEeU+mknfu72V2yNMoWv/9kY+?=
 =?us-ascii?Q?SlVRhiOdL3JEsW3eg4yI+zDvWg1HQkFBBB7lbQLhGIQPvcml5LluUel4oYUn?=
 =?us-ascii?Q?l+daArQv0DthO+VugJqIBDijK2vw/FNdlIdvCjIYDQeULgDTFi0aDUnNHqw+?=
 =?us-ascii?Q?5alLLuyinYlpU+g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:05.8183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f158e3a-fe0d-4be9-c38b-08dd2e5039e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6298

Replace GFP_KERNEL_ACCOUNT with GFP_KERNEL in the sev-guest driver code.
GFP_KERNEL_ACCOUNT is typically used for accounting untrusted userspace
allocations. After auditing the sev-guest code, the following changes are
necessary:

  * snp_init_crypto(): Use GFP_KERNEL as this is a trusted device probe
    path.

Retain GFP_KERNEL_ACCOUNT in the following cases for robustness and
specific path requirements:

  * alloc_shared_pages(): Although all allocations are limited, retain
    GFP_KERNEL_ACCOUNT for future robustness.

  * get_report() and get_ext_report(): These functions are on the unlocked
    ioctl path and should continue using GFP_KERNEL_ACCOUNT.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 62328d0b2cb6..250ce92d816b 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -141,7 +141,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 {
 	struct aesgcm_ctx *ctx;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return NULL;
 
-- 
2.34.1


