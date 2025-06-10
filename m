Return-Path: <kvm+bounces-48848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBB7AD41A3
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 129AB7A63FC
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2632D245035;
	Tue, 10 Jun 2025 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SpojULxa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7AA186284;
	Tue, 10 Jun 2025 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578802; cv=fail; b=e04bmX/IVAX+Cg62zV0+weFTZUCOJQrWhVRR/CiLJGN01yTGfedO+d4q2UI/+aw2+XHIo8me4lp+60TKE6ZCPx0/8EaodPzdJhhsmkYsxK7VAEV5HZd24mf1zhYzBAb5Xr3fxVrS53JkUGxT6qFpPorKVpaycXwxPU6QZ+gO7Uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578802; c=relaxed/simple;
	bh=idJqmeciD+PkJvdJ+lD0xSEiOQlBabv13H+p8mMyxyg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUUa67cOZBiC3qP80H3mTi+8jwaqHgJa0mo4/zw+ClZM1GhxPx1pu6KPt6ivhPlvH93lbDjjbp5StKC4vfDwKYUwCCqu/Qu5CfI8t7ftsfiSaj2e1E4eqQuff54eADoeBZqNgA22qOj1DFPpP1Pg5+EzRmLHoPX7PMAKezQyDoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SpojULxa; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VO3VvckoBqOfbxKzhA8I1AHoC2KuRIdNlEMZCqTQltuVs3OZRR8Efhe8/DFgze7oP575UtEEGMKkPAXTay9NsyRD5+GGtu3IYUD3WvCluT18pIF+msOuW5+oDrqjvqwF5dPML1PM8VWynmZb4vlXlGcDtQdtHDrEIlqnTNNNwQLLmKR/gVDh6ID+wHMjhIuhxD3BDmNbkJj7W+WPaogP05IAzpnhgzt3C+rPfI30EQ8aF6sSYPs4NQ8msL13TOdtnlwv4MfeDCzQ2gNxBLz//eujy4S9/8u8M7kmWO7NsXHpVy3frsXBWGDxSySxDyXni+OswzZS12v5IENSIFFi4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXFukSqAwByhtXEbmS10eUSXrdXsNXNrWLkroMdZhoQ=;
 b=dRdX+rGAqarIw+F/2mRX/bnx3CvVSm6sQ30Btg1MY8Dh5EQPYH97DYi+BgjIFZnCE3UCv7ZAnl2jO65UQDjbWEmpCe21h9FFsdevtHo4bkS2cVasgHvEZTJbvarh+EVn+CvVVECR5Tj0XS8QLf42aIgTQBvPZtRID4FkYx6vCf2DpNhIxIoBJ7ChF7YxGhK+MNydhfhsr3f03qQcMZeyLyJVgq/vUq3+goRAQTTay3h5PE+TZjmrCu3enjfP5gSgxa+G7EF+BnkwiGUujvz76njhVpWqlxjn4Qoab3Yvv61GCRB/39wYj3YGCR98hV72RZP9H2rBNwq+1OOuyjE26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXFukSqAwByhtXEbmS10eUSXrdXsNXNrWLkroMdZhoQ=;
 b=SpojULxax+4HGVms2tOfumbtqPKKJGH1sRjInB2B69QhZM2WFOijbRizCH1ofeTa5YvAZWwGMbGYwjTK6VS01Rz+UJ9D81ETSK8ixOvvfJRgzwzcIbDKOJIX7m67TjwMGsg7AgZieQKvtRYMM1SkFI/4PvOfbwaOyC/uByXZ7k8=
Received: from MW4PR04CA0309.namprd04.prod.outlook.com (2603:10b6:303:82::14)
 by DS0PR12MB8574.namprd12.prod.outlook.com (2603:10b6:8:166::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.32; Tue, 10 Jun
 2025 18:06:38 +0000
Received: from SJ1PEPF00001CDF.namprd05.prod.outlook.com
 (2603:10b6:303:82:cafe::c2) by MW4PR04CA0309.outlook.office365.com
 (2603:10b6:303:82::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 18:06:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDF.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:06:37 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:06:24 -0500
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
Subject: [RFC PATCH v7 32/37] x86/apic: Read and write LVT* APIC registers from HV for SAVIC guests
Date: Tue, 10 Jun 2025 23:24:19 +0530
Message-ID: <20250610175424.209796-33-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDF:EE_|DS0PR12MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: d09326e9-a417-4944-1fe0-08dda8498b4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A9QEp9tUHs6jnpD/FrnNE3Kn5f5tDmb0g7hEffrCQFLeWbxG+oNreSLx6R78?=
 =?us-ascii?Q?hJ+T25JSn31hEVnIMGGtZftfaQGpqk1v/nhhNlSoEcUGb/uUkeS/EP1nnjdD?=
 =?us-ascii?Q?rcFdLwxG1i8cuZYHFttX4hNJ3LoDAt1AFNALKceCzs5PtU3twWILCKQoSB4S?=
 =?us-ascii?Q?whEddBDx7spnc6ydGZ7B97Mqg1qpbnRlgD6Hk820oi5V4GTK8Ehod/dFmXAH?=
 =?us-ascii?Q?jkquiWIvw9meqHoQi6gb55hyxs2ueUieyNKkQ92p7yBVWq8UZHVvmi2hfMCM?=
 =?us-ascii?Q?+n68jmawO2HUMWFGKD5diQRZfv1/n457rJH9LXYVn840/SldTqGSK+SvmtGi?=
 =?us-ascii?Q?iY+xgYOYPdngboMgn3g7QZuHcx3SkJEBKaQ5t/Y6XRMS29ZFjG4nxjZ1qjmY?=
 =?us-ascii?Q?QLJHGmYfo//EVmQSXEWeouCg4xh/jjKNB15ZnCVtCOYnnwQfo0kwZFpAExPf?=
 =?us-ascii?Q?YuDBnvdI3FKL/ODmihlrnWYvVoyig/1ibjP01IovD9pZjOzodU6QJ7KYygIE?=
 =?us-ascii?Q?hCsvw4J7V2puStBgb0BZ2XrIPX3eZ3w5Wk0Qr2ag7WpJbme4vJPPwyhzS6Ot?=
 =?us-ascii?Q?AYiSINcjwtJUC6mMRPeoqqO9ubN9+pRYxj1l/Qhi1T/npKwSMnYTNkG0WvtN?=
 =?us-ascii?Q?hjWh8DcXS2Xt9EmkKsl3kr/cuXgvdkKTtuZT9Mgi/mDOvoak2HPARFZthJw5?=
 =?us-ascii?Q?jvslVeFQfdOtc9qHUveeynfmOn8nXvcxhR6fO8KW7kvEqWlmBRyHEPIOcG6V?=
 =?us-ascii?Q?nrcFWtXFmvL2zqBpMvbFSbhw3Jqt5eoQPmhqxRkEc2Qe7qeaqLC0aRYBapev?=
 =?us-ascii?Q?xZF4nlghAYprXU2X57QPZQ4zqr46yyw+3NsRFhU+BJkcsKTAFRTvQ4+rVUbj?=
 =?us-ascii?Q?C9hs88YTKbeGFSd/8KpEvKijR4/kzpQ4w/SQKP9FngVgkMwm22lH+9S5sst7?=
 =?us-ascii?Q?mmqUfnmGwpxGsi4koJMk9G4pXEtKDMzYLSObibEBnXg9kzSn2T/HDA03EWGh?=
 =?us-ascii?Q?ooE0XEpAdpRHnCyLTuTmJMt0dK5sDkr2SFdsrRog6vAFWQXT86hnKvPea/Og?=
 =?us-ascii?Q?LRbBhLCzwDgb9xqLlkHuYOIUmibFdJbZIpBotWblTpSknR0mdOHn799M3Lby?=
 =?us-ascii?Q?mwi0ZYkBvcVhxTKX36W18xh1KKCIBoZUd/HcDL0BTqlgOnvrdvd3shxcqOXD?=
 =?us-ascii?Q?VktDr4g1SZTbx0H1Jv4qCvD5F9p27l2uPsXKRgK2Vh2hot8XYQgauWXocuVW?=
 =?us-ascii?Q?Gb4BjmgPIIv3i+vg24JTiFgwjgjoMkJ7Epfz7467fGyOF3x8KjkiQYJkxgnE?=
 =?us-ascii?Q?1E9//EwmmtIldZM7q7ZJoKOcDiH6sdYIgMHPZpOUAhL2Y4AIAzqqDBdxggGw?=
 =?us-ascii?Q?Qm5r8p69kLuUBsE95UXVlsghe1YLT2SRMQwSsZjjg+nypSCbh2DSi1z6CL18?=
 =?us-ascii?Q?NGwDnGSMJRoztZMpeLcLTg91dixPUf4gFEdI14vDaFyAZyqNmOFmPSCu9JYb?=
 =?us-ascii?Q?Gswl3DEH6PX1xxloHPnwizJdMfXj/yQphs3/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:06:37.8243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d09326e9-a417-4944-1fe0-08dda8498b4b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8574

Hypervisor need information about the current state of LVT registers
for device emulation and NMI. So, forward reads and write of these
registers to the hypervisor for Secure AVIC enabled guests.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 583b57636f21..0fecc295874e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -69,6 +69,11 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
 		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
@@ -78,11 +83,6 @@ static u32 savic_read(u32 reg)
 	case APIC_LDR:
 	case APIC_SPIV:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVT0:
-	case APIC_LVT1:
-	case APIC_LVTERR:
 	case APIC_EFEAT:
 	case APIC_ECTRL:
 	case APIC_SEOI:
@@ -204,18 +204,18 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVTT:
 	case APIC_TMICT:
 	case APIC_TDCR:
-		savic_ghcb_msr_write(reg, data);
-		break;
 	case APIC_LVT0:
 	case APIC_LVT1:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+		savic_ghcb_msr_write(reg, data);
+		break;
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
 	case SAVIC_NMI_REQ:
 	case APIC_ESR:
-	case APIC_LVTTHMR:
-	case APIC_LVTPC:
-	case APIC_LVTERR:
 	case APIC_ECTRL:
 	case APIC_SEOI:
 	case APIC_IER:
-- 
2.34.1


