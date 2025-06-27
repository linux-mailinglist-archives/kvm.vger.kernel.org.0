Return-Path: <kvm+bounces-51019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC754AEBD43
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A8A76A516A
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DE72EA72A;
	Fri, 27 Jun 2025 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qiiTm6zf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2EA2EA724;
	Fri, 27 Jun 2025 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041608; cv=fail; b=qLOp7n/YVvVD1t83Ae39YMZIJe6FWDqpPYw5fqBvT0FGyZG3GP4u0WchJGLlJFAuEPJyx1fb9FKsSFNFZ0e3tD28aL69aEA02n8fRaJ1MaYIbJ3Z8Yts9IP0LBltiLjpF7ZrLbEUrHD0+jXEU1v7LRJA68OVJij3kHb6KLioWAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041608; c=relaxed/simple;
	bh=RRx/HsR5yRLofzEP7HFM8cwcJIXOLJNj80scS8Uw5NM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nlo6WXjAlk7EgsrDMZyOpg7MvpTKODFvZ08bMy86K7uacQOrEZIxPtNjBzgSMzhOEk9GDZgRCbQnzWxaJCFZTZUgZe6UqFWHWNrqndCFfdND7wxT5Wr+QG9nYx5Kz1+QQJyW9syWCOVjjfObQ9+Be6sREX9hy4s97qnYdN3pxKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qiiTm6zf; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWfRTzqTEuboatnsgb3A6Ynt/W8rfCg3/ByWRJL+dHkBl9haWeYM4Wj1TUV2Xz54v2GrKAicBl4294CQpphTtsZY6LhJcjM7e880tRRJEALBboCYQT7GdsoGH+tzaWZUzbhizXYxKALPg0PMinHGD+tMIqrNE64+4SXop81UBkWa4jdp/EwD2JzKX4CQbZHou0yCLTVCuXZ2N9D1QhxgLO2RwdwzZHavVivdToPZA7dJPhqzHGJUl9ToOcK4HpHDhZS6A+F/LZfAbYL6zKqaGkjy6JwizNMsATSnj9MragRLG6kTIEByzZqJ7QRDdwB5Tm1BKSuaCzNVJ6BPKftGXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ClwfL5sByww+cDyH4kUlmgw5d2s2LDFjLQbCz4zco8=;
 b=wvGy733XrKAYg9gWPfrbDmTWQaIIe+T5ePvhDKAnwdxstCqtwBSG+pXAXUu4ZNHrLqzbLjZvVCs6AIKtD1YBqS7GLQTC1VANzKiU07vqswh48NWUHNUtq6Vq53wULVx8ezhogFOusMX+dQcP1cRA/VDcihT11yS7n5BevxlGmxLBBfQH2jctZPkdcTB7w52nCd+OW8ZgFDgXKrKftmDrLKzrneEkATWIW7NRgGOy4FuAoPXdbzKdj1U5Dc+MHM2BQia/YtIlzKHdVDChHbIJUS4TC3ayIPYMOh1dVOV0GWxZyfOFyoWUOZFY2A6+gBxOIYS02Oa3+y99vtD5RnGw1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ClwfL5sByww+cDyH4kUlmgw5d2s2LDFjLQbCz4zco8=;
 b=qiiTm6zfgfcwLjrt2FXHDqj8bIOlQ6PgXVLo5RqYQQ3ipVE4prkEElt/l7Vf8qi1Uc9rFJ5IWSiRPrRgBxx+vKBW3wgj7OcRJYTzGDw9GzzWaqQDeCVS+vq7Jzl/4IUH8QYc4safmkXbfv8wrPaKqzKfj5QhB+8MtNpGVMMUW+w=
Received: from SN6PR05CA0034.namprd05.prod.outlook.com (2603:10b6:805:de::47)
 by DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.35; Fri, 27 Jun
 2025 16:26:44 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::20) by SN6PR05CA0034.outlook.office365.com
 (2603:10b6:805:de::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.10 via Frontend Transport; Fri,
 27 Jun 2025 16:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:44 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:39 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 07/11] KVM: x86: Extend CPUID range to include new leaf
Date: Fri, 27 Jun 2025 16:25:35 +0000
Message-ID: <20250627162550.14197-8-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|DM4PR12MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: afdb2ffe-331e-4441-8380-08ddb59767c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p/rEwbnjJ3gsvUxxBjtCtMAje/fRWHPSDjYLrdbEiwfyT6YeYd2CwOFp78Ez?=
 =?us-ascii?Q?FX0NAOvYXIcTOJK43erc6d4eqKFmKnBtmqLDMN7AkFJ911zsmXegkF10NdxK?=
 =?us-ascii?Q?QhL+tPOow2SNFsY0kBNlsOW2O0rzk84duZf5WMr66UTNjR4aFa6+t7e3W4tF?=
 =?us-ascii?Q?YcxKS5gn8UTGaOVZDcvmZvpXKMlQZx+afXY8/jaRbByFFCapnUdJ8+IKsF02?=
 =?us-ascii?Q?9KtryYXNY2VYYg4KFY7Qo40omRwXdykuhWtTBIpNqE0Xnia49/0nUsi5n0s5?=
 =?us-ascii?Q?Fvfg0cZV7gsvIZ1fOBYpb3T5kQg/AsVL4H3rqKeUlqZRMGOIzNAWYnAuome6?=
 =?us-ascii?Q?IyNYpjwmQ6n5o5RPgk99R+Bot3xCfMkbK9Ju5X1NtjkltCpW+lbjLunaVXjx?=
 =?us-ascii?Q?WTYPo7mJv5TUpQNN0T0BDI3+xwGDK4AQHITJdMbM+InIO4KIXVPyZNciQEDw?=
 =?us-ascii?Q?rEjmgbWA2RN+1CpYv1sfPB3IhG06T4l+FLlBxKb899luMDVgLHyAbXrGCT/G?=
 =?us-ascii?Q?lMZEoSdk+jMBPmfeFiZIzc48gVfreymTK06NlAunOBB3kDgwVgyD3f4QF+6V?=
 =?us-ascii?Q?hDn/VmG+vJsbuPU/zFOnAKQPqHsdoAF33MFYTpfELDGBsj7di6gXyM5VTuqi?=
 =?us-ascii?Q?E9T6VwfdGholt3uq/Njni4tswLj54m42YC1UsiAWV/dBDiWbsBiscU2TY/2w?=
 =?us-ascii?Q?ypJ3wO0L+FaAESaPK0uWH8WwNnVtmS75lTciWNriZGlAscDAwkSpVrhdetqM?=
 =?us-ascii?Q?ywgww3J4Z7UmLVeIrGTAAAM7jLyUkGUpCckIBw7NaSynzpVz4VrF2U2kLWyY?=
 =?us-ascii?Q?rj8vM8KLi3r8NHjsFwL7NKkYxBgJshElkXRNAxC+IKOcJHD/A8+jc+PQ0xMg?=
 =?us-ascii?Q?uZqh8ffhX8bwqZlxvma7V+QjsinhAELPEpOjV5eIqOL5P65wh20EyOIOZ329?=
 =?us-ascii?Q?USmw298KMvDDtlYncIYQuF4yys8NCbAMlPnoszUyrluzHeyzeX3k3L9Lhv3P?=
 =?us-ascii?Q?F93ELge3F4MBaKSC146CQ4a71+wl/65Er5eLvgqMB4faOqd532E4GhOEC031?=
 =?us-ascii?Q?29GMMwMeBi6xdJlAIzHOrObWxAxajkC0y9xobZVUSb9RVkqiHFghd5MiBYC5?=
 =?us-ascii?Q?0he/+8y+SllV/TydfsrBvrKGnQrMmXyQGFM999OR7+SZzwX3vD7XpWLl4OAj?=
 =?us-ascii?Q?SHmGF/QazP0b5vVyxKSUBfezzpWn8CEcn7hPkdCA/+9DUQ2cGbHGIDQSY+Yi?=
 =?us-ascii?Q?38rOJslPYpcqAujanb8KQcB6sx3ZlkfuIOtg5e3VF0IortmDNgMAuErp8Lxf?=
 =?us-ascii?Q?cbB60h3t7so4uMTX8zYbgh1fCuuDuVgt8kmb9BsJCkfE9ynfx8risfiQSbKS?=
 =?us-ascii?Q?tzo5o5evDE6crpyadBGSdXLOKeJO2cqNUyjxyM5oyPGqyB0pWlC/lnkxGjEB?=
 =?us-ascii?Q?xQnwMDJ5w2sLEFBhA9iZQlPTm+H4Vpbwat8qID7Y2I5UguqW24Hhpa9Lpkst?=
 =?us-ascii?Q?VNjYENRnIF6XYqLk4Ld8igRyjF6LfR8DoES9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:44.1700
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afdb2ffe-331e-4441-8380-08ddb59767c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6280

CPUID leaf 0x8000001b (EAX) provides information about Instruction-Based
sampling capabilities on AMD Platforms.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/kvm/cpuid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7270d22fbf31..d77184485e26 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1751,6 +1751,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = 0;
 		entry->edx = 0; /* reserved */
 		break;
+	/* AMD IBS capability */
+	case 0x8000001B:
+		if (!kvm_cpu_cap_has(X86_FEATURE_IBS))
+			entry->eax = 0;
+
+		entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x8000001F:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-- 
2.43.0


