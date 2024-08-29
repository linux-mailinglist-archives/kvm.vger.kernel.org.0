Return-Path: <kvm+bounces-25323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B739639F5
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6E2A1F2146C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2ED1487D1;
	Thu, 29 Aug 2024 05:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zNgj0qC0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46312E1D9
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909892; cv=fail; b=jqQF3tj+bU8iHS4S4GQ7crv1VnqtVHyr14z6rQQFH1leOfy5kV+udi3NlTcZNzIiEZvKF31WwopcQ6v348+FJ3LAyjeX+XwVFSs4VSGYylMgtUOQWWqX1naz2geMijWLKHjv29fdfAbPf9GOgl7iKolE2+pluH5h9Att9iuVzl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909892; c=relaxed/simple;
	bh=EPvKM75vhi3LQgwco9yj65vR9Z4LjIv4IBamllTu974=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSQJhbuV1EG9hTI18dD69EhRpqRjxN1D9Uk/OFTnS0q4+AvgWW0C5mttUvyfhB9bBS/HN67KuVxc3XAquItf+8ghbK6rr9u1NOLUYsSav8/L+0h0hnIuLCh27QLq62oJL8b97tOYsJnNkGllx3VgHoFqqex38KrNC/ZIkSk5x+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zNgj0qC0; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZxzkWazfGZ2Y4HJZfE2mY2sfPgl3PQ94QM2oiGbD9HMraSJhIC6cwAYeESd+/3bAqwv09IZbaOpnWu3gWN1ItkmfG6LekYMBIFR3BeWIx5LAuW2DS9pMLF1oMaHNDQN0h0B0BNRFBnFqrXkCiHEDM/zTZkbCI4MjK2Zdj1LNWoYY4WQzvBm8MzTL3q55dCIPm8S7v6bgGmJeZKdUMxD0J1/cWvZTZgfrzU9lPKQ0UYqpM8ajzyHEQebVgrfMTdniyTd5WnWMICZa2oadw2QLsBL1tskz8sTBJX44dNVMS/LNge+baefd6iKEloK1XckJmBn4E1YIe474p/AwdOL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHI1BCUnU6wKitST8s3HyhMD0xajD7knUEacgsf3Yew=;
 b=zTGDkWgM3MLIwpMjNjRxGch2mJNoTgAXYcJ7t22RFTDrA02XOOZvaVItgmNbgNBiP43J4ukTyGQ72QBNduMqBf+h0bafrNAxwGuDnyUtc4f1zONFtj+5CZjnmI6X7DP77RDYl/aJFGbMV2dI/UG/YXrwJ90MiFsv9HHFz684z9jbGvKseEEfNda8AQDkRk42hoDqXWYEg1uGcCsry0GVdPtEO5c9oWLt+kRNbjTjE2ULjXIlSjQaN7E50bG0tVMkGGTYkNdWyIVYjQG97oF82SVtZhv4S9RVTdMDcTFrNhydGMMrsZ0iZfrElvivGAvBLSaDhxZ29v4Tf5Q8qI7WPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHI1BCUnU6wKitST8s3HyhMD0xajD7knUEacgsf3Yew=;
 b=zNgj0qC0JnGBc6c6FnUYsZrL2OR6J/anylKbF9392n4JoKHrRlxBtK4g0s1kBP3Xv6orDVvKmhJYJyqSclYpysdbbeM8G5RIGpahZCJ8+TJtTzoxlbYZHiuQ+4Pj5yMQj/7+ArBS6NMhUA6PKtmjBnPhZTJCrJW5HL4MbZeu6uE=
Received: from SN6PR01CA0014.prod.exchangelabs.com (2603:10b6:805:b6::27) by
 MW4PR12MB7431.namprd12.prod.outlook.com (2603:10b6:303:225::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 05:38:07 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:805:b6:cafe::c2) by SN6PR01CA0014.outlook.office365.com
 (2603:10b6:805:b6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Thu, 29 Aug 2024 05:38:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 05:38:07 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 Aug
 2024 00:38:03 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>
Subject: [RFC PATCH 1/5] x86/cpufeatures: Add SNP Secure TSC
Date: Thu, 29 Aug 2024 11:07:44 +0530
Message-ID: <20240829053748.8283-2-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240829053748.8283-1-nikunj@amd.com>
References: <20240829053748.8283-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|MW4PR12MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: 59c5636e-2f30-457c-f990-08dcc7ecc2d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/uvJVewqa64t12cTMl6wBvutzWeKca+OJmME3V/9zT3UQMUUhIUsOehhjyp1?=
 =?us-ascii?Q?bsFbR56DTmTn0GahUFr3sW83Gp9Adoh1g42UybxptBR3X5mQRAt1e2ShJ859?=
 =?us-ascii?Q?UdLnC1XGTBijB2NGX9EV4t+JUe2yU6fo7gol0snEqTR04UmWf6HCzv5hD6Ck?=
 =?us-ascii?Q?VjMSvQ01b3qNxxuGFaxJA/6+Up0nZZfHPvRBT+kGdRGo5UZoKd+mOgo5UhBm?=
 =?us-ascii?Q?f1ZRI1kyIzbYiqf007d2eKGNTtan44qJUU9OkmSQcQCvY9wJH5OtpeEaXwtG?=
 =?us-ascii?Q?AwPICOWS6IzO9487ZIaevsR9vpbt8Zi6Qr9eeS4X7NUbyQQlm9VRCia3kBo0?=
 =?us-ascii?Q?ckGZEugKUhThCs+yaOfTCi6eXtvcYXnSGHU8SJQeflJp/32FfN775q5bSdlR?=
 =?us-ascii?Q?9waX3vvvEVBf3knUoUCli0U8gQFUOcgAnkeFAkwOlE59AQknqP8ezATYQc/I?=
 =?us-ascii?Q?IoKVUQwnqhlwWaB34l587jj//4W6QowHz1bKz3XGne3gUtnDE1jv/8fbsVko?=
 =?us-ascii?Q?50RPC1xGo9wu64lWO49nWyT2hKHcwCh+W7qKoe1bZ+34nBZyK6PzznBo4lym?=
 =?us-ascii?Q?2tJCtjg3yVXnWfSTFIqLFs1ZZO4atC1XNG6BVo1fJ2tawR0/V1MR1wVGawMv?=
 =?us-ascii?Q?VE/xENx/t2IBTzKbiOSF5m1nkC5FsRlWMvix7db4Hxk23Dqjy5IdrZ/P3L5A?=
 =?us-ascii?Q?PiTXqdYlJR5sMsYRShWDg/okiOhssmt4u+9c1ZWnVchHfiwg3upF4f/2dARE?=
 =?us-ascii?Q?7Ti497SxZML/t5huc+JK12liVkBDS0WcZvcIewiqFsTnbG0Ni+RgljfIh8fX?=
 =?us-ascii?Q?WAY8vAjY1aJeR9lrBlIAyvm7F7XxzBfz6JOmWaDyTuwT4LG6fclVSx5IS6re?=
 =?us-ascii?Q?9ApN2OCGI8mUxafYcASDyaiCUixLVvkZB1gRPrbt9vHIH2JZjSt/Oj3A/gSQ?=
 =?us-ascii?Q?tgBn5rAFcDO+D8+lprSaqBSfxEfqQ+9y8DBdB1G/yiuqlty1wZcWV8J1JdoC?=
 =?us-ascii?Q?uyvXsUXzk6udx1fOyHEhWoG7vMwk25RGO9w9jh/s7dtjrQ+pW9hDJ+JatGXI?=
 =?us-ascii?Q?whAeuwpIG01FkOC8yoMqqgWnx/o3kPLAvIl4ENCDHNlbA7RRBMb/j23adMwQ?=
 =?us-ascii?Q?DxAv6CYfE05PTn+9Tl/RgkTe03VMeLt8JioSxZzUXhs1Lg8UWD2ax7+Y30mZ?=
 =?us-ascii?Q?4+A7uxq/c5iDwIP0Smsxqz+EBnaLAvTu8RDV7bQyQl+4I38smnfv8KF6JqZ4?=
 =?us-ascii?Q?6MtZTyGb2ZfwTJH5dUIOFPY2ndPwaeYMfs4GdtecGHT1iGYVg3DhaQhdLF2W?=
 =?us-ascii?Q?Pjvn6yd179oML4EQosba/VExVGI7xOBqKnnkrTERGw4NBdC697KzzvJ069JW?=
 =?us-ascii?Q?Wk5Uyb0G8LrGcA6oYXLgTsK2J90xiYRrY6gU5NBAgFQHm8td6tkDfx5zXGmM?=
 =?us-ascii?Q?wT/hPGdNnCt/z6LgzasagZ6U83h0YEbE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 05:38:07.3036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c5636e-2f30-457c-f990-08dcc7ecc2d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7431

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. More details in the
AMD64 APM Vol 2, Section "Secure TSC".

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..ed61549e8a11 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -444,6 +444,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" AMD Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* "" AMD SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
-- 
2.34.1


