Return-Path: <kvm+bounces-29231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CDA9A5A03
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6F7628225E
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0348B1D0DC7;
	Mon, 21 Oct 2024 05:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="endGSvFK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C671D07A7;
	Mon, 21 Oct 2024 05:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490266; cv=fail; b=PwMqMvJ7pCSiY3305RVTBDyM1B8kbt1T4oymJJhvECNsp2lYNIjuUr65LgHwClGeA136WOtl733oR/WqJwchgHKk3sI/21dk44PhGEvHnGr894jyXiNiPz06pV7OjpImCi+huyzZcjc4Uc/vgGfXOZxzsQoGTb4byEUqQKFjsj4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490266; c=relaxed/simple;
	bh=G707+LHej3ZRnOkUOcjm98qrClfu0WCaSEd576MFwHU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cSAN42jW4W2OtN3VmNtO7vs8WFhTPKoM8lCTChGXPcsKDjNQiqqXG3R3PpF4YnJbCgTSsG/c4lxICIFc7kS03UNU6BhxHqKUgX3O8y/YqpS8EU28ANffkqWIIravq4YXydUfa8kmcWQbjc8Qy5s6MUnAPvDTc/j4XBQpfI2OcP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=endGSvFK; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OV4eKpMv+MqwyX7d+Dji8zfYdKx7VRNCcvLhKUl5W2jTyMVKaYbUMU2YhBLkQzdrH+YMvg3Xti5CG4wPru4HNAWego73xR7vvhfEw1TBXLGWYZ1HkYfN06UDkRJaWFmgWpp2bZo4W25CGQFwo7fCZuIqXFk9199zb+6PwnQsISlesMTYh297bJVSglkI34VYBHBB2TpO7o3vsGgEenlriXx9s04qxB4OL13SNoKTok7dQwStIh45jDByUgIy8wJaplM16oTVhwgFau6L6Zy4jtks4wIFA2irAAvnLG3yBAQgFUFyulGasfhiuR1/HTn18Gsfqnj+5urVJ57/yxCzcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCCXl1fpg7Y4NFffay/JYiqMr9QgRa2L0bO1s/l+npU=;
 b=DFjVGdGA1Z39kLjhNjJtdaazq2ekd6rsmXQSzJ7cdVpFrvwJ4CScLRSlaicJu5rlihAdtbgJG//BQ2+6Qo5K6HDK4FSOijVSyM47FYu8BWJ4j/xLSXpWNJAGWM8uwJc4oKEfyDaiZs2TYo4Sb1LShcSp6X2f90vLsVy9DOYyg+AGvpOu1QA7GbtcD2YG0kMRPyttcgVDMOY9ToeRl0QbC0RvtWe1eY+2Rf1R2QVFrdFmBKp5i/q5rbvgidpMLyypGWYsBZJErcZ/j4LRVBoAgYgbEAvU9Wth0x5pPYIgd+s3r4D3mc/aJLhVEVCqHQdtOv3rjVjUTw+JUtSATsrc2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCCXl1fpg7Y4NFffay/JYiqMr9QgRa2L0bO1s/l+npU=;
 b=endGSvFKrxf2Z4Q5cF3aqaLb210f2CDl5Ni6I7YctiwXWi22cvOsA12mNJG8azcE1TWMpxHgJ2WUuTx8zLa4az1lTSBQfCfOHOAnG6uo3dPLQ5Uk9plNqdAKqU25Oeh5hiJOhBwRyp7K8eBgegDmn4R/qTyJYtlYL8rxxoyNe04=
Received: from SJ0PR05CA0138.namprd05.prod.outlook.com (2603:10b6:a03:33d::23)
 by MN0PR12MB5883.namprd12.prod.outlook.com (2603:10b6:208:37b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 05:57:41 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::1f) by SJ0PR05CA0138.outlook.office365.com
 (2603:10b6:a03:33d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.12 via Frontend
 Transport; Mon, 21 Oct 2024 05:57:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:57:40 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:57:35 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
Date: Mon, 21 Oct 2024 11:21:49 +0530
Message-ID: <20241021055156.2342564-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|MN0PR12MB5883:EE_
X-MS-Office365-Filtering-Correlation-Id: 39fe3667-baed-4fec-e64a-08dcf1954629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5DPdD/XP0ya19G4nkvIArl4pscFZeKu0JGgaeyUXiB+97mPyckhpKQo/NEmi?=
 =?us-ascii?Q?3hX1Dn1Jl99FvU1qpFhNfX8S/0Bvq3kgAMIeI1hrAlVBTR13G1Qzql8VzTyE?=
 =?us-ascii?Q?xfkIXEu8ForC7ZSt+OjXsOx/8pwBhXuJRH2gSWCj2wXQGWR82NkU+l4Ffdgg?=
 =?us-ascii?Q?TKPGhKwzVcFBRV8JU06TT+6mvbOlqM1Nk+Kxy3rKLAtgQULmZWbpcqy/YTmN?=
 =?us-ascii?Q?InFxXV6GPAQWVta1ywwTQTMlGidY7dh4m6kduOA/S8nCIDgFJb0knkyauo6c?=
 =?us-ascii?Q?uRFo6V/79FzAkr0sVBVV3RC+M6Y3PwqSpqXdzn0/ujHjXlWOuzOJA0MgfnER?=
 =?us-ascii?Q?bf6pWx6ftvH8hWUPvJ5KCPoHq/4q8Y452FH8+Hh71EbX2BASnKNbec+j7NJQ?=
 =?us-ascii?Q?n8Rqb15EfU4UxwQU0CelAziDwQuG/0CfSRC7vDv9iKiLvMqTrlXleLwTy6LC?=
 =?us-ascii?Q?70S8Dh4X175kELK5DYDh9zGGtXzF/YLO7B+o9IrpYqamKYzgQOT2oY7YFf/Z?=
 =?us-ascii?Q?P6zijJ8EA3I6sW9tYS+yMJcc3gDEGKSn6Ye+GWvavgfDe9CgSrE4cgbzhJOX?=
 =?us-ascii?Q?OsbeIJlVG9KGBukmMpYCwwlb7Wa83l0iRVH9/rnKZZyUNEYbsSC/N/PvXE1j?=
 =?us-ascii?Q?buvdBLNvlseEc5RDnLjxrWi7DLQ3yVAM1TxmAqdn/tcaHVlVLl3umnDI56rQ?=
 =?us-ascii?Q?kGOYnG/OvExpc46qJpnVm8T8DfBpFBNWAeAKHtMerrYA+h2+6BLvJuS/pfDV?=
 =?us-ascii?Q?mk4sFsiAS5dVHNpmgFv6xMUuR3bMYStZ9+hyiPawwzAdExHbVVgMGA/m3Cj2?=
 =?us-ascii?Q?70GZAIxCIqZEtqziRu/UmNaY3v3AEGK5RJ8NtEgIpkjivnMYuwaHFmp8E9yF?=
 =?us-ascii?Q?fpmuWBWGkjhXrXihLUBdmAnlWwcjAToGOjz7LW8jL3MFCiMozEWItTtYBg06?=
 =?us-ascii?Q?dEzxVdSut3syk4AcE4GeXC/SPnGXlVJJ+qoMCE+tI3kk8lp3Xqxf/w2fN6qL?=
 =?us-ascii?Q?2ZkGA5C+831rbQ8xZor3jE5flMShMdTpu8gCZgBd/xTDgdz2r2pXoOcQ2ciL?=
 =?us-ascii?Q?LfFAwqNKsgX2TYke/d2z4MycGap3IdbH/hypsB7+LpC4kJyxDe2e6g7F/4MV?=
 =?us-ascii?Q?iOHthYYM9voVhdfexbfj3OlPc9+q4bUupNMQpstUoxgZdptoMhSSrCOTSNHA?=
 =?us-ascii?Q?k64zruk3qCKK4SaShMmZ4NRcdDAW22bIJds429Ail5V/OP4deCnZz5y4PzY1?=
 =?us-ascii?Q?3YI7vdCGh2fzGqghtSvqNeI3RGk3eqJMWILBnHkxzTPHxj++PaaLXdy+yE2w?=
 =?us-ascii?Q?U96hKfycGqq/ySwA4/sU/ibFClSPgy1r0iWjF3uKEPRHfP8ajUoeCflAkClx?=
 =?us-ascii?Q?Xi7GXbD+ttJqHko2OQRqpr4CIg7+GYYe1sObKDZ5urVxJGHYWA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:57:40.7933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fe3667-baed-4fec-e64a-08dcf1954629
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5883

The hypervisor should not be intercepting GUEST_TSC_FREQ MSR(0xcOO10134)
when Secure TSC is enabled. A #VC exception will be generated if the
GUEST_TSC_FREQ MSR is being intercepted. If this should occur and SecureTSC
is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/coco/sev/core.c         | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..233be13cc21f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -608,6 +608,7 @@
 #define MSR_AMD_PERF_CTL		0xc0010062
 #define MSR_AMD_PERF_STATUS		0xc0010063
 #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
+#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 2ad7773458c0..4e9b1cc1f26b 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1332,6 +1332,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ES_OK;
 	}
 
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		return ES_VMM_ERROR;
+
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


