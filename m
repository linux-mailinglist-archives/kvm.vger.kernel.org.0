Return-Path: <kvm+bounces-48844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C95FAD4199
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 021417AAFD2
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19682244682;
	Tue, 10 Jun 2025 18:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VDt7pOek"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0920244697;
	Tue, 10 Jun 2025 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578710; cv=fail; b=uTDJRKfy+/qMw55s21kkfXFc836nnlwrERGK+lW/nrPJdVnmEq6XRMEXPCWL4lojtljP7J2FO5ZWysah97L5mEB3ac9otTGfAnBDbGy780hYTpM1WLG3TzqZIDxG8LCAU9bD9o6mGB8AX7cojRbbRwbJPg+zONSIrx58oPFz8QY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578710; c=relaxed/simple;
	bh=pdIpMIO4v9gmMI/tdO6eKY20ebIogeMadPf/Jytdee8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qKrbQ4XrkuU8WZ5sf/tjK8a1aYFiq9LIAE21d2iy6wBL1gZ2rbTTTVI3UzagVBjYJbUmiwKlbgd7/OF70pPRe4EWo9BS/rrVBikPBV7TIEO+qH9GzN9xPcx8wNgHViyyaI+gOBFz8WY2fwHOhEd8+wLpn9S44HsMGYenUYXuESI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VDt7pOek; arc=fail smtp.client-ip=40.107.236.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgyFcJBksafrf70v9NZfziGrWdpKiD0zHPujkfqNcT92kj6vos+MjpbD/XQmXV+rCxUt3uzsffxgNGKy86nWWxUDTP0Gf/FIq240lnyqh9A1ELTQgaUPSTqtpIC3MJCScJuBq+rwPyQWUMVZubskOz5RanOyvc6kxvUuJEANbvwp8QEaq5DG8LRg9pRq0rDpR7LOFWnWZSyw4mvCvNwEDsTNUjZ4ODhPo+YUuxVJ6AeKJ8AmzcLHVx4KOCBFqEbrJYWXotGZGonvlJqcVtZzgxt1uXMNp7cB0JB+y37FzPY8uXaez5+DR9lMNADWnLtkxKKwVYkSMUjKM+4nH/56Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQ9xJ+v3tWxgzcqDp78K41TEX7u/AZ70knMwXU68Y6k=;
 b=PF8Cz1EH1H8A5N+vVVDsjB3eBFALK4LTnpMsfLnKA6BaMzXl8fU6wajhbmfqgasj/npBKvcUPtP/wuUhNwDz8C3a6XP3oxl8uRpaSYAsErUHUzFqAfRto+1Blu0pA7XjSMvsSFEQRgIPVEpPtqe1zNiRkRoQ60bMA1gQVKL0nh1IoR65YoILvk1r20x8UMWgUikG5kWIAIbcJ7fcGi+fuME965x1qWywIo/qFyKtvrOALWC1XW/PoNdKgi7dQuwhj3moRm3HL5U826bYYecK30sUkZGGxMB41Ael+/WwbaEQfgIqDAh2U7fkDBZXN7LWnXpKpIDs2I7e8aCRfTYhgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQ9xJ+v3tWxgzcqDp78K41TEX7u/AZ70knMwXU68Y6k=;
 b=VDt7pOekjMA5EqUTsxkDXhb/GrEwXDwoTJPtJJMc4bfN5kvLydjvIHRP4ThsP0L97heW5oJHJotU0HeKU1GVb2Eyy0TP29owFOzWm8f4JpBONtT1VvPXL/0goYbiAUIYxFUCKRyXSuE0R/bkF6c4sQX1HQ4QXMupdX7QY/5r4JY=
Received: from BN0PR04CA0206.namprd04.prod.outlook.com (2603:10b6:408:e9::31)
 by IA0PR12MB8253.namprd12.prod.outlook.com (2603:10b6:208:402::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Tue, 10 Jun
 2025 18:05:06 +0000
Received: from BL02EPF00029929.namprd02.prod.outlook.com
 (2603:10b6:408:e9:cafe::5b) by BN0PR04CA0206.outlook.office365.com
 (2603:10b6:408:e9::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.29 via Frontend Transport; Tue,
 10 Jun 2025 18:05:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00029929.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:05:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:04:58 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 28/37] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:15 +0530
Message-ID: <20250610175424.209796-29-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029929:EE_|IA0PR12MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: 15419faf-ff4b-4dd1-8f84-08dda849548f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?11EdpmKNKW5pP+in6vF5My44TGJfMjKRn5OJK+UPg01AritT2MnmNkB8Kx51?=
 =?us-ascii?Q?z2Jbf/X619V8jTCooqFzqtk5s726RiR5WRDgp1HeL6R7lzQld+T9w87VM2qi?=
 =?us-ascii?Q?zOMfaxsPDfuUL/CdepLw7nGNUYwQDiGVQIYAD8MYVUTaHj1P7Mn6pcvl7MaU?=
 =?us-ascii?Q?X/Xgbumk1u31RKmnFZydLZ0qawHRuJBPLbhG7Dt7hi1TaTLKwl4+ELjC/aro?=
 =?us-ascii?Q?BLtIgfd3udzmVP5Ox0rblXsJb8yus6F1yqtZLKVRV+Re3cHIS4ER7UR0pjVA?=
 =?us-ascii?Q?W3mDN4fa3wqVc4sBOulizH/pitKeD1A8tJp2SZiFfJmGKUGJzt/LszovyE1K?=
 =?us-ascii?Q?dTNi5SVIgOsL+Oi36Mew4pfSCa0yOc85pNSujYwWpc0WtgGha63nGlf5pIaV?=
 =?us-ascii?Q?kDk7yTvPbxz4aoBHFmBLkcAiMH9JQNJ2WesHqQ9TK4J7lBPPnu26PptGYsKO?=
 =?us-ascii?Q?OlJCUu+CuviWgcqH1ZleuOnqUJwwFRKOyUqfAyxAU/J9tESdXkABVTdRoWh6?=
 =?us-ascii?Q?VqQ0HFtI2CoFHb7G3c9sNcQ/mnMCr0LxrluiVYpBE77NWA98K50bPSaiRpgK?=
 =?us-ascii?Q?/RJ34Rn+6ljHT892cu6FwLxsFUW56J+d6xBgXm1H7YH780KT3quFkNfq099r?=
 =?us-ascii?Q?mf7zH2S9I/VSWpdWzn4F25pKHJ4CP6wnrsGafCfkXdaN5J7x/mKsg2i4qJ2C?=
 =?us-ascii?Q?Pvw9AetN/SNZ0nvc23vx8Q5Ku/fMHeT24H2KVx1Ndg87jXKrWcdaHfBGyIsK?=
 =?us-ascii?Q?Zp52NcUoHo60ocS1+6HI2FIyy6MDj/iE3QrFjDljmuTPNb5mnMwCO3EFPojP?=
 =?us-ascii?Q?u4r+U39NkiwXbLBjGhnHjNxrZfljwW4x9X8gIv0V05uxCVrTVWANeXX+jr51?=
 =?us-ascii?Q?wo2sEts13uw87IXWuCLE0D8CIXwERFjbuxU5jH+qSikrNKYq4URyLgdXZdQy?=
 =?us-ascii?Q?myL3rFyN2MQ7zw3DDcjdsY+VxaB2/coz+kaCWPBau1zMPiGdNmErXO1reJ2+?=
 =?us-ascii?Q?iIrfJ8Hdy+0MZtyHNQgwK2x+3guFUZxB+gdrHdnCflDSvESLHSnFY0kyvIfP?=
 =?us-ascii?Q?QJhjIpayiHF1RHRnuHsuRoujA1lDvYjV6bKOYteiDGkOgsqOdwT7+YmCFIox?=
 =?us-ascii?Q?VdLS1bcs4HtMH7quDbXpl2uqKZbS3ev6Qo+RL6wFDzW5BC30TL5wdfiTCCb0?=
 =?us-ascii?Q?hvFGWefPKsaiBEhKiRyySjoSvQzc0++AtnewL6sNSgOtvVKzzy37Au+PGm4B?=
 =?us-ascii?Q?t54wZUmHFGBH2aabhxPzHRYCrzCvW6dB+STQSxtYDcX/8ZI8EIdxXemjMEn3?=
 =?us-ascii?Q?btigBPAUbqjQGPr9Iev35O9n7Qx5kPyFV1+SbsLJZgM2ztVYFvS8XI7n2Nfa?=
 =?us-ascii?Q?e8aq//fUW+8j4GRwjIpft4eMAbZd3iC+2qXpyxHvfyOYIXxvI0XZbpuwg7e8?=
 =?us-ascii?Q?2i5XJ9U6ImXdwx6mdvTV4zqY5ykMCanCb2a+hUjHrxtNgpZRNeFyG4d+gzgS?=
 =?us-ascii?Q?OefG753HldcO3KqjZjPNBZyA6/jQ6/tKFT/9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:05:06.0819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15419faf-ff4b-4dd1-8f84-08dda849548f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029929.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8253

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary vCPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index abe7b329869a..7ff4faf94ef3 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -951,6 +951,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


