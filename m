Return-Path: <kvm+bounces-38356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39827A3800C
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87436170873
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1556216E3D;
	Mon, 17 Feb 2025 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fZh4Yfts"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2C1215F5F
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787785; cv=fail; b=AZ/gw9Gi0F90k6BW6zvCibWMPOuyeOUmC/h1h2hPkaI4I8ul+qzhnh+g8IeF9jY4K+pp5F8zBFH2vCMqdRh8nbO6JXalSP4/th+uZPraj4/dJiyZ0BkDRKr3OUAD5wrlTAt5fB+9MjSuXLQDQi+SsSPOCr1fu8nWCf+X6GcKDvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787785; c=relaxed/simple;
	bh=DXMpB79KV+RwNWujnZrVtlq7nnzFnhjzW/hcu3zrnCA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gsYoIpO51x/7ZzNHqcnVFKrWhmicgG99sSR6w0QEXrwn2ndrU18J3nsaY1vQQe40NPPemPYIjihp0iOPWH3Nv5StkugmjUoKPAMmAb75W7umsytKcpNme2povnVytfFThjC4kNTqqQdnyozZJLelkdrjGCvm/vmT5iEcb9TFG8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fZh4Yfts; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t5tZ48apspC4vuC0H6uJxV4R93ved56WQ8MKFBqM4StRP3cYmEpU3kXsV0Mk0UlAvAyNJsuItWDEdH1PK/34ZJllDRBlitZRAwmbUN8vf0914SZipE2o4HcblvV6LxBSUkBbFAuqoGhgiqwzjwGo1n+EDmdzAQfgORzZrajFLb8Okl5pkOGICEGXJhukaluLbDPCmDYI0rgQ2p0xZhaYFvd2bSCR8tuinfekUsF810boltoivr2VehdbcZvWZpvm4achNXl6bh5QQo8sFkdhBX64m/evxvrjrPVwtdKbETXnOnFTglzogma9D7lM1dRZiKhzvmFuGxf1t+mD1IVydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIMmr3nVkv50kO6hjTFUD/Bn0YoKd4MTJMhFroyuuHA=;
 b=LNZCruj5ctRp5sitX6JQVBocHAHrfhoLR9HzV4TrdAz2rhlT/PRTfQ7fAY+WYCQJINlIeVjkAJcGWHiQl88MPEuW6Cvm9fJFKOXJcttmRalrFtJlqnnUKKB3pH3EZcflw4zGP7UrYtNzDdaLCIUq1rLZXNWM+5hhBlWvKmbKOG8tNtyCBiEXMjXxpucO1WV7BgAxQh0UO09fzjLqqQdPvaIyGwY0XlfWrAs835JCQkEDHrwq+4KwllYAt4KgiMbThyXu/PgVM2JmbNqKvX4C4v+GwZgPc6aT6YIo91Zn3R39L3KB7btvuYPB4Ngut38h0HMEz5xrcZz0m7QWGk1YUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIMmr3nVkv50kO6hjTFUD/Bn0YoKd4MTJMhFroyuuHA=;
 b=fZh4Yftsxm8S4DC3Z0j1rz/C16gjfbe2iCqud5JuVmLeWHOr0ygL+gycqfkIggROPeOktO3FQ749zeymRvF0jiOQqoY1ahH3Raxy2M4dhfyDPOlsxcyOb54ipQjR5JULopSRqG8VHZ3BNYPP7GAyScHRPC3nUOSsjzdU3GPNh+k=
Received: from DM6PR06CA0074.namprd06.prod.outlook.com (2603:10b6:5:336::7) by
 PH7PR12MB7305.namprd12.prod.outlook.com (2603:10b6:510:209::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Mon, 17 Feb
 2025 10:23:00 +0000
Received: from DS3PEPF000099DC.namprd04.prod.outlook.com
 (2603:10b6:5:336:cafe::e9) by DM6PR06CA0074.outlook.office365.com
 (2603:10b6:5:336::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.16 via Frontend Transport; Mon,
 17 Feb 2025 10:23:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DC.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 10:23:00 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Feb
 2025 04:22:56 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v3 2/5] crypto: ccp: Add missing member in SNP_LAUNCH_START command structure
Date: Mon, 17 Feb 2025 15:52:34 +0530
Message-ID: <20250217102237.16434-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250217102237.16434-1-nikunj@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DC:EE_|PH7PR12MB7305:EE_
X-MS-Office365-Filtering-Correlation-Id: e217fc7a-6fdc-4c24-6b3a-08dd4f3d0e11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+e+JDFdWi+STkQK9YRoFWjuQfJ29FUeeXKJQt7JHDitrcsTT1ulENop2i584?=
 =?us-ascii?Q?FQ2bKshX3qoJ/Yl+kCmJr2ca1Hkz7WYSQKIwqjHMqjrrOj8odGU7liwF9mDq?=
 =?us-ascii?Q?juEJN4Rre0nMmx7XpMRecMuJO6LYGwcgGMR0Lt4olHLsRY8ZiGNLI9o+G0FP?=
 =?us-ascii?Q?fMbt8eGsjdsNUbAEP+vxZ/7DWVdRgh27PDrpNmhXR0EWhfKn6+GKmczd9Evu?=
 =?us-ascii?Q?VaGldgD6kp1l5+bnNMvgaYOgNi8NzpJh2h458YvJzQryO6vHxZZurd8aQNke?=
 =?us-ascii?Q?yg7Oa6K5bN1Q1LfyfzrHmRrLK+NVxUL3UViDDx612HwnyiirRvGltzY2L7Lh?=
 =?us-ascii?Q?yTst62wJ1pVETYsU45eUxgO+qgXbNLmqrLNvQC4mt1sPll3FBpwSf6OZaw/l?=
 =?us-ascii?Q?gBM6YiJRQXajl0s0DIcvwZBWGyINclxZCZky6xCuIww33FVsoAs+5NfIFhct?=
 =?us-ascii?Q?WmREveDMjuQtAnMdu8B1q/j/eN79Y7Em5Aex5pAYqKfnLIdG6Q15HjcMoUN+?=
 =?us-ascii?Q?NdeWIY/KEWfO9L8eZBbsHh6/dtMUq7QaqIn+0XcbAGtsS4+DkLD9IGNNkeDB?=
 =?us-ascii?Q?E9LrgTMLeo19rEbD7TiCQwQGQYfsdBq8nwUdW6pHjyad8PH9hzngzKBVvbaY?=
 =?us-ascii?Q?XUwqQUT+/lMq4nM49tvwxmBDBZrZZv1ut8uXKwvGNPctp4ZfoBHLkhQaXVrT?=
 =?us-ascii?Q?qim85W5CHQCuvynd0aMz0Sas5dOEmcrv8KKeGZjmIx8WFgSQdHGWxII6JLhF?=
 =?us-ascii?Q?Bq82dkCjSfIM1jQbk1OYWr6oas4WQFfzN9wD/hGaepO6DvCmqzJvKccJquEt?=
 =?us-ascii?Q?8Lb+ozGYfawYtKafPubxeuPCEK4qTGIExbCfQGzn9zWXues5p2fFK4h/renO?=
 =?us-ascii?Q?4L0uLxWh7k/PhY4SmdWSez/0WBl6pMEiIMU08x4jb0BpzgXPYdqLF0+rkGdT?=
 =?us-ascii?Q?5QOjBg8ydUtiWhCRPh5//nRPne27e159mvBC1Aqa64wQHBYHRHgXzyd7V+MG?=
 =?us-ascii?Q?n9zqEc6b32NU46CcO6N3wtYREVYG+RAEfHQPMBdguggd0f5RqlLzKQWo5gr4?=
 =?us-ascii?Q?vELQZzEm7Y5fsq1ofAkH+/hI34immqjj43FxWJMja0bFXNA5OJ1PUmQ5zR17?=
 =?us-ascii?Q?2bKD6rNF9dys/3zQjLOCVDsffQNjAwcVwacTNXeySrHLWlvH6JU+RuRBJ8PL?=
 =?us-ascii?Q?5OomVpGvNkW+jZrXzgcEm75ljXCThzMn03sxWJRkF1u7F5GDtn4EQZNKqt13?=
 =?us-ascii?Q?31/r0CQoLC334fMZokXI+vd8rGHk7hHXh2j1lLXVf7z5V19LRYauRNAfD+qO?=
 =?us-ascii?Q?n0I6NNykK2L6wbHhMBkbd9Ht4rLlrYS1TKQZUQfLZtWbtXW79N4rV382/BGT?=
 =?us-ascii?Q?fAzcE3XEA7/m5QQZYFvRJKCmEOA3bREy+6aX2xSWfZJUbeNyDHrXNlGBDyR/?=
 =?us-ascii?Q?4k6cTaijuS+UfpgKVNK4qq3eTXKMLQjQvE5XqTmLd9kZ2wwkDc4bpZdZeGuR?=
 =?us-ascii?Q?caUVC0iDFwGb8vk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 10:23:00.3006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e217fc7a-6fdc-4c24-6b3a-08dd4f3d0e11
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7305

The sev_data_snp_launch_start structure should include a 4-byte
desired_tsc_khz field before the gosvw field, which was missed in the
initial implementation. As a result, the structure is 4 bytes shorter than
expected by the firmware, causing the gosvw field to start 4 bytes early.
Fix this by adding the missing 4-byte member for the desired TSC frequency.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
Cc: stable@vger.kernel.org
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 include/linux/psp-sev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index f3cad182d4ef..1f3620aaa4e7 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -594,6 +594,7 @@ struct sev_data_snp_addr {
  * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
  *          purpose of guest-assisted migration.
  * @rsvd: reserved
+ * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
  * @gosvw: guest OS-visible workarounds, as defined by hypervisor
  */
 struct sev_data_snp_launch_start {
@@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
 	u32 ma_en:1;				/* In */
 	u32 imi_en:1;				/* In */
 	u32 rsvd:30;
+	u32 desired_tsc_khz;			/* In */
 	u8 gosvw[16];				/* In */
 } __packed;
 
-- 
2.43.0


