Return-Path: <kvm+bounces-39252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34415A45984
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:09:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29D711892925
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEF6226D1E;
	Wed, 26 Feb 2025 09:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="48C+m7WA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2075.outbound.protection.outlook.com [40.107.101.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4920F22423B;
	Wed, 26 Feb 2025 09:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560899; cv=fail; b=VeERX+uwxmeXlmgKrBYJWTMrvPxWqVJ/AYEyCVCUAONbwhZub08SsQuDFwkca3Eb0Ktb7QMpjQVieN6QD9nEdYJHCL8k/xdRw9SNM4vfBZ5eWWMXUEFq4UjelpMv4x8thIzd/GGZ50jraQlmKNT3abyWNrdxkPV4lO0TkhhUdLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560899; c=relaxed/simple;
	bh=Q4ewJy+/b9emzrE86tyS01vedacOusRUYe+WkN3fdXY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/H6dVXDxET0WWeW7W1jJtD0QsxIKoQ97QAPYjI6u1NxUEuIf3RJ1dAMbqndDQA06JANGmCZoXiX+3rdZKsoVcQ0QY9/4O0TB547HU0rtuytZyq6HYksYvZj69EH71yz/PbZ92LTlfSMr4+5dOI6C3tlX9kNi8+oVT3ScKILtdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=48C+m7WA; arc=fail smtp.client-ip=40.107.101.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UJreW7oyQr3aoR604rugXb0nTSAhwAqejeLaEDm88c1t7KWxbN31e+v5lbWYNlLgnLSDOlxgkJDytKcKH5mSiJ+TMO5Ttl1e38PG0Kxo8EUjzBoPLj7+S5PYmzKu2+PrZ9vfpwmVCcMUSg9j34gsl0hAL35NtoAakWyAiJCBzZq4DtkRu4ibDcv1ns3igZv/OJmNxwDWgB+a6FFzn9EU3oJtsvq4URBdbfVSzL48WStNKSLP0/gz11X1ZY4/HX0jAuk3vj8DlGEH7k7jI9m9d3nz0Ist6H3M/0d2tYoPpUa5HJ+6G7/leZ0yQIMFcyUqbf1L0k1ZoXGY96+gtS51dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Afvjz4oVA3db8RvCc5lQkmhYdl/GAm1UoLIki0a3j88=;
 b=ZPSSYrdzyM1hp2UeAaEd9itWB7pk+YbyVq/E1hxRCWM/RzHlq7Jy3K930cYMvwoGSyGv/WydIjImRMEjZqZjN1df/kuEESjw/e1bKub0ucBcsPmOFSd1KSDmPz8VulHqrtdr/RQ30LsLYvvTQTh6Zi/HI2jncRBXoDS/gZKDnrQt86XyS+FXJ1x1LW8I85nMcp3gyltKG/9p6pYpYglRk+Era7hk26TMHwD+e03kBC3KS2kdGf0Gx9dZ0Qac6ERPSxDzliipZSdqfVbjreTkX7FsrB+WcembCAJDjpE5df9/e2VfPazP6J5rjLQpisYss9sUI/xlzIfuBAG+Im/u3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Afvjz4oVA3db8RvCc5lQkmhYdl/GAm1UoLIki0a3j88=;
 b=48C+m7WAQMwK3bh0kPILkkw+iuyUDByk2tKPkgUbwVjNN5WCTn8+ieovnxazcDcq30sjQtXUWUkBg4ijl1cNDmL743ivwsgK420oTwmFC9q3qGpNEH0+My8qPQaMwgkSHox+dB0klC6UeBmpDuRLeKtLwvsobpfOIOL96ze/kZA=
Received: from BYAPR07CA0031.namprd07.prod.outlook.com (2603:10b6:a02:bc::44)
 by PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 09:08:13 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a02:bc:cafe::59) by BYAPR07CA0031.outlook.office365.com
 (2603:10b6:a02:bc::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Wed,
 26 Feb 2025 09:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:08:13 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:08:06 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 08/17] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:16 +0530
Message-ID: <20250226090525.231882-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|PH0PR12MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c68cbe-497e-44bf-60d6-08dd56451951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0emZNx6eklv0cx/64SnFCjrbaReilr4Zatwj8iTKK0K0pDnWh/r9OxRhrKwt?=
 =?us-ascii?Q?dYKDDjR1XZvIqzUHS3TX1KYCE/3kxhRb/E12acP0WuC6JJvXlmYlmIzzzSYn?=
 =?us-ascii?Q?GwAPpoNpnaKR0D1q8ZmqexOwzqf4gkd/iezgJElmZlsPrLHQdETT5/V0gXB6?=
 =?us-ascii?Q?ubhGLlNWvpQbaf9J0BmE1xRvsWs7rmDb5dFc6u+LSR/45mfX32xu8wtVmilC?=
 =?us-ascii?Q?fqjwCogBP0oa2kZRDls0ojtKiVOukllzFGgPv2cxJZEywZtfKJmkjAnI1ol9?=
 =?us-ascii?Q?VtDRJchMdx8Klmb65VWux815sGOff5ohguyuud5gsJ4isZqemuqnTiyPHBwb?=
 =?us-ascii?Q?w68+ZF33LvLEgU0096e07HvL7AS9hverqrEKYH20A1aJx+yznIRXmZsE0SuF?=
 =?us-ascii?Q?ThdUBs6VgRqtsy+V3rvDxGgqwsRsKrJ62wlNi2V1o29f/W0TXYi84SRMMzLK?=
 =?us-ascii?Q?mu43xiRhxd9jfWZWW+syf5mkBv8tjaHZK3scszWYUFqcopWoCCqKgoxWVEwb?=
 =?us-ascii?Q?M/TmFgvqbZUS/B1elfLG7c0JnD5wyMlGUInHJdYN//++B5UWJqnxi4H90A4X?=
 =?us-ascii?Q?rfTxd4+AZ0rtmzhXoWzZi4/mpAzU3i1rjRi7hvwjbHjHkcJezYzyjasnCYGj?=
 =?us-ascii?Q?xSPGOEOwvig3gsrLqzc6Z0s6dpxpD1W9m0GonBPHKFeN/Pj3fTFuXBTi2wvV?=
 =?us-ascii?Q?7yZokPNlBeT6lDdoc/yg7IV/UZUTpw9ConIOHAxva2dGr+ozL3BDfjGMnI0M?=
 =?us-ascii?Q?WAML2hvqRDwFQBjBj12kjgLt98hwozkV2LhT20CsoMCEy9wFI+KrD9CZZ6XM?=
 =?us-ascii?Q?PL33/2TxBpZTjgHVmGOLQVQhO8WXfPNblY5brjEK/oBzptE5uk1CohxMvsgZ?=
 =?us-ascii?Q?fexpD4qYxasYM/EwUgNEymjnNvElM6tp1z23NeE2ntKvvGSt4aNf6kaWk9Ih?=
 =?us-ascii?Q?eP0oPOw1AjqwzhmbABvo3Cb75nQUJGi0QkQTzipwW6+7OmLks9/1VYpbnKju?=
 =?us-ascii?Q?Hq6zrT+ZLDOLsubIB9VghUMqnhUPuXWUayB163BjmCi3ieaEGfFSvOhjrh8W?=
 =?us-ascii?Q?gEnKHQ49ExGpFWcyQ64jfZPiAWqrXyr/7QinjqUqnQ9HoyIjNMMmAwUKdF4n?=
 =?us-ascii?Q?JFwRg1BOgtJI8GRpmnXWPO0J9QwAgvhX6M4GI5Na4IxiFL7OTd1vvvk/OVY1?=
 =?us-ascii?Q?vjblJ19epqcGhGvbi59G2AU/6/mQflKwX65mNUa+qCeX03+VRkoDlYDOfXdb?=
 =?us-ascii?Q?UfXqd+BwIjopM2EDLBnsZx+VkEMpxDMvMfACwIPJk1MxHH1t2If9AkU2Q7kB?=
 =?us-ascii?Q?YQdLmK+uZlkoDvJYipumiZCXbBlcDsoEnCPjP6ZgiiOh2Sooe3LWF5+k1Aha?=
 =?us-ascii?Q?UuDwHJshFuZH0WldDypXDK6jiGtbjQpa4Ox9UcXEATC27mV6jv9OepN1Aahb?=
 =?us-ascii?Q?DAFhyyR8/VCUwbt1Xku1R9ULsKAiyNEScrF4GREKpZc2R0enI0o+1b0SUJzQ?=
 =?us-ascii?Q?qmDu6SkIRqXO1Fc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:08:13.2411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c68cbe-497e-44bf-60d6-08dd56451951
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary vCPUs (the configuration for boot CPU is done in
hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@amd.com>
---
Changes since v1:
 - No change

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e4c20023e554..8a4ad392d188 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1272,6 +1272,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


