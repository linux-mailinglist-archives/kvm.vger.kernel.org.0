Return-Path: <kvm+bounces-22790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B879432E4
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD2A281B3D
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709271CB305;
	Wed, 31 Jul 2024 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c09fXsl1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B61C8FC2;
	Wed, 31 Jul 2024 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438581; cv=fail; b=gNlZAi+gSVrk46U6sYWoz98NRWcHbrZWdOhk23B9HYl+0w6c+t/Sh6ak3mvcKoyf8nPyDOn8gO964j05jzoDP3yd8B7v874w6WD/gxrhFGlbu2YwZwbgLscrz9rAW+23e5G/SLgtt8CeZgnHKrV6s0K7NShxgfLeCOHHMJLB7pk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438581; c=relaxed/simple;
	bh=b37O4lQqBPKsNL0DwTG5JCBRVlps5U2jLlKi4ogaW+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eO/odZFMdVGhkbOQ//1TIO1dzXMhvR7cGTwBwBjjNENyVj72lwTlVpD3eiREY11zVMlaroqYSMj0w/ffq2rzxXIIWDdr/GK8IIVPlaum25mzBFfDEnEeuNRuKar8A4B0RcyMXJQknGO0qVWipTE6ErRbiRr8UI/oH8UdmhEldW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c09fXsl1; arc=fail smtp.client-ip=40.107.95.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UlyDA64P43EWMlAAKMaoQMqqD0Y8a5m2tnVKRkDuJ3Glwzp8R9uIEEaXanz7GipkASrdoXLLsSf+JJbZmdNeAQ4d4y2oqwxzSaUCNES3U/LqMdIEw524wMSA29/D/mWW6FpY/BjvFDXsvWI9BLnY1JzExcwt5HFht0Qpzgkhdq78d+0kqYN93OuGhxTrjqZ+j8bJeInUR2qnlE7NAunzqi7cSQ9qLeI0rnhZZxqXqU7Ol+p8S6iVqTnfnOobvFXjCo30GHLfD0oBeAzqWyFg1ODG94ajvT2pGa1jVwCGfXtFtXef2zh2ZYmw+rVEieDcX5LXZ/TK9WnTw1eTRHzgrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfT+hwz8PcFeBkDyFc9aLCH6nZ1dOhY63Bd+A2eXLEs=;
 b=LszWFosRArMGj5q6izov6PEUFTQfViDX864sM5S9Zes7vGEdfiJ/UgjOVk0weGUROJFIsei4QapwvHbsL2FYCHJ1EF3afj6rwX6qprJjwEjq5V8R3EhOFq89eaDYyN/1UMmFJTb+Bcyp6gVZmqvM/FRnUVfFIS+rNnwnyOhcxUwNS8g36oOijM7XL/x4p6gB+oE1MBIPJu6QTq7wzdmB5ydVgSERDBTHqlOezoIdsbsGQdbXW3oxz+vlR+GcKFlExupkg4qEh0xGhGUNzGH5eCsuN70OL1rE+KP3JwRJxjywt7hp7B/ywGtnj/ogppHkWfIadphiCZhSh+ANTeVFeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfT+hwz8PcFeBkDyFc9aLCH6nZ1dOhY63Bd+A2eXLEs=;
 b=c09fXsl1LaP60sH1SAF5WZMCGpP8ruP3a32JFCIRZrFSXYVpLs0kwC/vNmXKFMZwNhIhVdUlZXhR96zMVENc9rik6Qxnlec6SXdjJkVIDl5Eiyh8QOMbAWKFpcD4hPZyaOVUJG+jgVauSsKIHCh6n6grFRiAojpnXCJFXOh25CQ=
Received: from DS7PR06CA0036.namprd06.prod.outlook.com (2603:10b6:8:54::14) by
 IA1PR12MB8333.namprd12.prod.outlook.com (2603:10b6:208:3fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 15:09:37 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:8:54:cafe::4d) by DS7PR06CA0036.outlook.office365.com
 (2603:10b6:8:54::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:37 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:33 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 18/20] x86/sev: Mark Secure TSC as reliable clocksource
Date: Wed, 31 Jul 2024 20:38:09 +0530
Message-ID: <20240731150811.156771-19-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|IA1PR12MB8333:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c23a3c6-0a93-455b-b0f2-08dcb172cb51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/pKYobcDKtFSKgZ1NRctIHqp4EEvCMtiqFSfl6Am115O2NEUaJQfErmtpn5S?=
 =?us-ascii?Q?eQmerZ1wvXQlq+35Ypl1jgC34uG5CFXPDilOV4uEgSTrQF1HFVoN3Sgg/Q8V?=
 =?us-ascii?Q?4kCTk1092hDJLDP1brA7EIPJQ7ntcbg+yZSgZOrm08EhwTNcRrjkLuHWyNe1?=
 =?us-ascii?Q?1w3y2RVq4LWUIT794Sf0YL8tnS7QazjPtTl/MeND9aU/FloC6O5vBa8cS/uu?=
 =?us-ascii?Q?ctX40BwNLMVzsfDq8ADzPmNDbuS8H1FNQ2ubYYU4C+W9nzGObequxMFhQlqs?=
 =?us-ascii?Q?C72HyMoiQFRLxFKxKMmso3/CF3CHF2M42vgqlBSMBp8arpXqeR1LP6eoMRU/?=
 =?us-ascii?Q?XVYM7C5eOL+xQTPMIIhsjHt9YdR/u3bRQ8HZ+tbl3cK93qzDgPAaNjmEPdGg?=
 =?us-ascii?Q?hzNaZa3JyKX9lP+PdZ/wD3QvFGng7Vf9pqo7L9e7B4eyGpkhZToTB3r2grii?=
 =?us-ascii?Q?//4w3yUovpUosWNT/9Jm1S/l1M79XY6+rG02W/GO9TNplx/4dDjp5hSml247?=
 =?us-ascii?Q?A8iD0nrGqTboP3Ghb1nfOsmxCEmK68tCJ4pC/dSVy7IQ/6OOJHOwaClklnRN?=
 =?us-ascii?Q?YsacYs22zmg8vw19jKjKbeRT3h3O62aonU57bIHc4rLFdfFaOiBjya5coT96?=
 =?us-ascii?Q?ctXMv2Dam1skoK199nRFVsz2U9C35FiVRT/oObgm1B5OdNuzmpaicJ+h54BQ?=
 =?us-ascii?Q?YfVhjcnXDO4Niv4tNvyJ0QKRiRRIWP69TmsiMDSv8MtDL3UwoeBKWifBvz1A?=
 =?us-ascii?Q?yYUCtkPDPZb41EDRqT/I6I1ILWT9knGxzSEwn/wyJpRiXBpaJVDKU7djeSxv?=
 =?us-ascii?Q?MfMbZyHw2HMHJf4Z0sbGBsZPwu9tkVaotIpDsJASKHWksbeyGLRtVt1zwBYh?=
 =?us-ascii?Q?bYKQ6G14ISuGblUKvh0/DbPSpLLiiH577ppND2YqhFeSUKsO/o/7xdEPYVW0?=
 =?us-ascii?Q?22LgkGlfldcDMgEtgcVRtME+4F1ezvLtZmHpaehDvbBapWQ4NIaLz/kY6MtU?=
 =?us-ascii?Q?uGJ+NAt7j6fAiDIYNOGj5MV3X50I+//HbJJOIt+c6v8vwHGFuzFj1CmWzY/G?=
 =?us-ascii?Q?pUL3b5dEOYBFoGRDjglKDIVSjCoTg5jarTuKHjBHy4kUAkbQnZZNCXDHdEN+?=
 =?us-ascii?Q?/0SM6uC4pldfodOoRqxcc5d0dZv/j07/h1U9qYa1ob5kre8/GIi5x/A8V8Wa?=
 =?us-ascii?Q?ul3t4Gb0iaUKo5r9oHHbcCRM8tSh9tbYDPfOq7FTj8NMWcbWRSV0QoHv3vD7?=
 =?us-ascii?Q?b7lv7Q1w6OQVq2fir9/G7dacanqgU1Ih3rcdZA2dr/4ArT0qp++QHmaNDzSu?=
 =?us-ascii?Q?5JIHBawKGJZaslKmAkz0HhIOiPCt97K3ZlTEXlgARHLId/5Ko3UMQJVvteQH?=
 =?us-ascii?Q?737QpA/odKGMbGKVJ5ErFoPpP/KN6iRU5R3fAsTNQU9OMOSVImDlgU7a9GUQ?=
 =?us-ascii?Q?fPSPIYHLvM5WTKDxPenaIATUQXd3ikgl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:37.4190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c23a3c6-0a93-455b-b0f2-08dcb172cb51
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8333

In SNP guest environment with Secure TSC enabled, unlike other clock
sources (such as HPET, ACPI timer, APIC, etc.), the RDTSC instruction is
handled without causing a VM exit, resulting in minimal overhead and
jitters. Hence, mark Secure TSC as the only reliable clock source,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 86a476a426c2..e9fb5f24703a 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -516,6 +516,10 @@ void __init sme_early_init(void)
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


