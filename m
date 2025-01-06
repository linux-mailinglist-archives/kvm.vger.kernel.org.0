Return-Path: <kvm+bounces-34595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C91A025F2
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:50:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A54316481A
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B60421DF270;
	Mon,  6 Jan 2025 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WKZDskFg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB41DEFF7;
	Mon,  6 Jan 2025 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167664; cv=fail; b=RlFx2Zi2Kwmyv3RGXcuI6QQDiHj1b35YTg2WsBiR++BwcaoTBlVVC1PBwkH+5GkRZRFY8p8aIAZ3FZmfI7nP+G34Pl/0s+18LgPz761G2F81zRvcj4x3gHgG6sJjva13FP4A1cEFMZHwGoL1lXxXXvXPJubD3IKpMoKZaRUQb7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167664; c=relaxed/simple;
	bh=w4JF1BsypmiAtMx5rcJ0oEC9BR9U5wlldptjLU+7VdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0Hzox0W3UXPsihrmmQFncDtPSr2CZnXLiMthg6PnL/pJzTW9P8TS19NA11y17MQb0X+n7qkcpVlg8PeJOoTXI/eYaBOET/N4qCkgf96CS7cKQzqB5lr/sTAL4PxilHhOuQuljhtYxeZe38MvEx6/SaD/jJiznbr7qgfBTqfjkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WKZDskFg; arc=fail smtp.client-ip=40.107.220.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDV+X76h+KoGzSavG6SMlmtKFwxI1EslKD8wR2ifjMLR48sWbt6sm6URfRz0j6ZRMhcWCnlqtpF1lEcEdAZv26ZskJCgw/PrlsZm3yZ1jiScJ1Gw2eLaKpEqSD/bFLW9hB02Z7hec+275ZLLzV2R16wdkVPmlP/uARcMzgGtv3pibP50t35/inVeHEulDNTDScsSmt0eY3Ff91S1JLilupQSQKqkh49aJY6yoFneRIAHYSX3FV722RGM6OieMIXBRQ2ASbeD0qhCRHD9yC9CNMYIEIUhwlu74B26cyBDhWBFjqxujTfdtf3CWXc5fYllG5lyz2vgnbxx51npCII67A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Am8CZG0IEztf4DaYRJD9YIDRhI1BpmSNVZb7FO6xBc4=;
 b=uVaWsxPx1eGDUUKf6hr3ZF5ihJDxg3n+86VAcnXaxc3R4AMjr9b+HqoBCcdwqkYfWPvaKBg0DyCHUqGnkoPyI3y2G8YIj4cWFxVaVTATT2Rhyc2rN0yw+5qNA1uLavqfCC9dmiW2jUus7fkMnaY3Z6LfPPrnXKMSVWon8AAjbCII+XOik0eKr9mE/pfWsCX2s/z759dewjmkA6I6dJpMWhbXWsqBk0z+Iy4VE5O91WCs7kcQN3fDY+Xrd2T4hZuOh1ppcPRoDtv2Q8rJ3BNNrOY0Lkp0kRy0FBpf6SetsqO/A85CyeNcG3/x3fDMsjJubFAqMgWa7pth0xmkqrJgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am8CZG0IEztf4DaYRJD9YIDRhI1BpmSNVZb7FO6xBc4=;
 b=WKZDskFgNVMXDA2sdnIrqHqP017U1XE8xVn5CqlHtYTPXXP6teiw0aEwE7DiP05bU+a5zCgCbQ2O9ZPTe9KA3osiwY4qOq70lbvlInBg0s4o/qmYBRTXSrE29X18wBF2FHLd2jZjQVtFXmWFMPqsGUb0YkYID+XCnzwU2gZ7oKc=
Received: from PH7P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::26)
 by IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Mon, 6 Jan
 2025 12:47:35 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::15) by PH7P221CA0008.outlook.office365.com
 (2603:10b6:510:32a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:34 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:30 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 09/13] x86/sev: Mark Secure TSC as reliable clocksource
Date: Mon, 6 Jan 2025 18:16:29 +0530
Message-ID: <20250106124633.1418972-10-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|IA1PR12MB8189:EE_
X-MS-Office365-Filtering-Correlation-Id: 02c04b73-bdde-44f0-471c-08dd2e504b19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J6Xxxzw7x8rnHwOLvBqz00i/HqYKr5B/vZAEMAh5dnYSLCksJWwOVJKk5OSL?=
 =?us-ascii?Q?Xky+ygX+9dzICE1WCBW8SnmFQepm7cpu80/NFW6lHZC7sBnwAgVKz27R1WR9?=
 =?us-ascii?Q?CgXIIMQ92cYs9uSrh7HsYPrPNyeyj6V5oVfHMRozcsbgW9YjMNMAt0HlcXG7?=
 =?us-ascii?Q?Na8g9H0ukngXg6Xhs1pxDwija8R/9pZGIzkye3+qA3hsqtJNXnsN7jaVNjtu?=
 =?us-ascii?Q?qr4gZyqf9ZfsKpPwPUqcSQK6IVwc+gtDA77mh3BbcSRK6aAJXQA+cd1c3SQz?=
 =?us-ascii?Q?ec4P7wN0c/YXAYPFrBZaiLN0Q2tG+jLRNmAZpZKhrQh/x4xQVWT+vNJTcWLF?=
 =?us-ascii?Q?GUON+Dk9ZQeC0ARRkJOy/uD22UN+dV4goc0v1+o/yRy/TH98pBsIzNrxv90X?=
 =?us-ascii?Q?GtiXSlPcAthrXNeR85FpTjOfWw0PdwZRBOFSvY9MA/Y4nklC+l42VYrj0Hdu?=
 =?us-ascii?Q?OrMDcdL3FpqfB4X4HMBykUrC1hTzZCtyGEX77FbWkqZjADTSRfhTyNfB1t+x?=
 =?us-ascii?Q?2UmVzIksuvzfKFEErHlLSwE9+jEHlLes+stEk69KBVzDiMejyNyiwmezjpEv?=
 =?us-ascii?Q?SMgztHPhmm+wQaAx5EzMLtcg1zIekkuC0375k3r6Og0rc3dDGCSjgop/RWZl?=
 =?us-ascii?Q?s1poNq4jPvz1beIpSLq8Wngr4bfKXiZ4/VxMPqDUKkT/DnGHnMe0q3l+s5Uh?=
 =?us-ascii?Q?2cgWBm5YxVlgadQDx6ZP1Qy8elDpbwYOpBcD6BSIRQKKqpa7SQ5c8QMo0tEg?=
 =?us-ascii?Q?4Vv95UunzAPEu3dyfFDHLU3wuIx6mLUfyN0xE7ONu6ZBTWHe9M/0ei+Hmmtn?=
 =?us-ascii?Q?8/LhcE+Tc0KsVDGgqEff6uNrxnsElo+EB0YICCM3EaZTesjn4+8WvbqdksOi?=
 =?us-ascii?Q?i/rn1qdg/OiTz8mzGk6+SuvHGZuZ9yLphygEQJH6wZXI9OvkL8X9xWKiy5by?=
 =?us-ascii?Q?m5fmyUVvoHTLwRu00LQi3WYzhkRO0Q0TFKfhD0Ww02upMGO5nsCR8+YmMfdc?=
 =?us-ascii?Q?EcBYwQMupo9CDBjJZT5QMPxIzidTxJtalJn08a74aY7iQOahmyoCZGLOh19I?=
 =?us-ascii?Q?N36Su5orumUBhLAq4/VESXq/naADMxj5NcauvwPUW8TAUc3C1n8By7pK6qhc?=
 =?us-ascii?Q?tNYfECwOHNWoqhim13aTpLip/CX7UnLN3RGLZ2lgUTxY5a304ely5uzAIQ4A?=
 =?us-ascii?Q?tlnvdgUbogOwWY94xmeN7bZSrr3t9ZJ01SuOc5ywU2G8A9YNTB75mDiTQGi8?=
 =?us-ascii?Q?+z1BVNdxkxqqsb3DiiVSMMQxgdXgWE+2y0wJDV+5xYXBoF/3IovjC7/bzd5a?=
 =?us-ascii?Q?T9/05zkmH4LE7fFoYVxihXVv2Xe/6QKc9wjpwzy5x6pUY2z7+vv5ZfGkHCz3?=
 =?us-ascii?Q?CJYg3j7VKAVJLJdzWMsNbR+A23B1JVAiKRM/jPT3FlXpvEYSqNg6ArULfHXp?=
 =?us-ascii?Q?rGJWhQvyLPfxQ4eJcV0Q6V510ZmQsv5t9SpIhuVl8K1cDzm7UwmAUVS6mJmu?=
 =?us-ascii?Q?NkkqSxy9tXCBAAw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:34.6968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02c04b73-bdde-44f0-471c-08dd2e504b19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8189

In SNP guest environment with Secure TSC enabled, unlike other clock
sources (such as HPET, ACPI timer, APIC, etc), the RDTSC instruction is
handled without causing a VM exit, resulting in minimal overhead and
jitters. Even when the host CPU's TSC is tampered with, the Secure TSC
enabled guest keeps on ticking forward. Hence, mark Secure TSC as the only
reliable clock source, bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 774f9677458f..fa0bc52ef707 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -541,6 +541,10 @@ void __init sme_early_init(void)
 	 * kernel mapped.
 	 */
 	snp_update_svsm_ca();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


