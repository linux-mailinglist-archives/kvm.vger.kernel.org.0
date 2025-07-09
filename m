Return-Path: <kvm+bounces-51855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F4BAFDE56
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:40:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69F394E8407
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750B621D599;
	Wed,  9 Jul 2025 03:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mAnPeEm8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546D421C186;
	Wed,  9 Jul 2025 03:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032373; cv=fail; b=nGIDTNZf9Fdl787Au8t2rJUlBsdLJvoVtz3velKGD9fNLZOo+onHPg/vegL398/zz4iCujIhwnsSHT6ZnOYb1OhjucSqL9Kl5oQefeiMcze5dCRq4kFKuHKZER4BKHzC6bmtCPMXbJiyWu7hBgtOETRxLduvmA1wP50Dnnw4K6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032373; c=relaxed/simple;
	bh=cRPkDHC6qToufiukbxF++Wfl7rdvk5SuKpJMYSOGrwY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VlvZSDkP3JD6oSdVCrKQM+8eEqyiC+Vml17K5EsZvE0eByp11n/Cdque18Eqow7gmfW1DI+fmLZTKzkCSA3UmmYqI2MBzvqmnTL1RPjfUlZMAwkm88g6Sbqno9iuwVHKbTC0yP4p+5J2lRrnI4YC9m5ukQi5RO793wTzvIHpNdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mAnPeEm8; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=roJWp0GKqpUzdHvdIAwU/FmIjTMa/HltyN7SeTjexHBNxDnOlzoheUfK7E/Iv9dt5GLI9JkYnB4Jwpl2HZW++X7nyLX2VBC6RSxUQJCEFnvsg/ct3+y/04C7HZqCN/VvciiCAgKdEy4FD9LOL1UWpmuUcjptjJDm8ZxW3cfh1K3lTqNteiH9gShpC6kkda4zSh5vCx310h4vTg8SGBc4SjeifY3nQ+rUJNKHD/daXyaL899VgS02PLf3ojetBkQ2z2+dbLPZeOaW3ux/jIjPexmjXqh/TAcR9twQQSmWXDAJbLrZStLZh5QFzfKyiBTSgCGNk4JbUYsZJoRemNiBJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUX4Kp+/qWbwbHQcox9gvAs+bPQEnWiR77K78w27PvQ=;
 b=aLifYhTKBc7rCILSriAAGzrUtZNUm0ATwRaCPmLAnvJr0IjzB3asjNucmxpOmlhv3SvpGstP/tjaQON/f/zOZT2UUsOQoX+4hToz3g5eAnwb7FcH5HeBb43zR1LtnmWrZAsnDUcUmKg3Ud1erZn0OjyyOTZWdho98E6OSAZv6BDE+InIFPrF5Pgow8WoP5oE118MdXEMSYOC98hzYGX6GAoSb7KbG/kERmS57FFdF/pk6YuMBHbvNuv7UOUiGlOxw3exT9l02S8XcKsz4MPYllLEiHjubjbgGPZvjaTRFwX850ffvJBwZZcDIBt2zoeSjeaOLKGRD7P8sH5nCApIiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUX4Kp+/qWbwbHQcox9gvAs+bPQEnWiR77K78w27PvQ=;
 b=mAnPeEm83H6nuk2MzMmuewtDp/QE23TuLzfRqKs9s/4g0/CEEWRHFmhNS2IVHZtXbaJoPvUUb9t8NUNL21gTFT8tysk3dI96FsViV8/yHc51KBG8Oxz2RMXYQNz1ifxZXbE4QxTTbNMn330/HtCfplICkCjcpi/qV+czBLWrrbA=
Received: from BN1PR10CA0027.namprd10.prod.outlook.com (2603:10b6:408:e0::32)
 by DM4PR12MB5913.namprd12.prod.outlook.com (2603:10b6:8:66::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 03:39:28 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:408:e0:cafe::a1) by BN1PR10CA0027.outlook.office365.com
 (2603:10b6:408:e0::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:39:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Wed, 9 Jul 2025 03:39:27 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:39:22 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 21/35] x86/apic: Initialize APIC ID for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:28 +0530
Message-ID: <20250709033242.267892-22-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|DM4PR12MB5913:EE_
X-MS-Office365-Filtering-Correlation-Id: d972781a-cc11-46dc-7de5-08ddbe9a34f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6YKm/PKBOEsB0JRDFNvrK4yD6Nz9hUfnB2eI4wWd27EqrCn1btc2PqwYUw99?=
 =?us-ascii?Q?G5jIlfkAbNstSjoHdmY+Oj0YVLwMTcixVR4hBnYLkL08nbWCunnJHLLp1Ybv?=
 =?us-ascii?Q?eNlKxj8NBMEF9rnUdALaUzU537k3Oj1+3PZp/fkqy/bm7VXkxmTLcTlcuP9f?=
 =?us-ascii?Q?2sTqMQxZeHgR825xiiHegl5NKbZYxQngA6rK3f4bfvVKF0JeUeTxe41kn2gi?=
 =?us-ascii?Q?avba4nuFh7tfF0UGPWrtbMg33OJRAcs5ZS+v+jOtGdE/PVEpVl2dVXINEK3x?=
 =?us-ascii?Q?fRsTvhefWjwsnWzl/3RFVZ+ay/0oy4bUNV0LqBI+xsLuTYL2qhj5qfvZZWKa?=
 =?us-ascii?Q?npQMp7iOdFEF11raF1tBCeslRpBzahwBYYr8AZREVDWV3Ddw9Z6Zis2iLdYz?=
 =?us-ascii?Q?bEaYSUTNpL1zGacBAztUvVGaKmwwRa0PNMDf0JlpotcBVmtr4zRAxHFMeX9C?=
 =?us-ascii?Q?QGBpoQvWx52sJce8uIrhMNMxYAVsJlp0Rw6cq9REYuP2iXyLPPAevOsxJ5b8?=
 =?us-ascii?Q?Wh0g+HztLWGByOVQ3BTXgl7p8pko5yIlvqV2Ea0eLlu+yNzzD4ufdlFaCSgx?=
 =?us-ascii?Q?q3TaxYS6obYxYY2UbcNRgnuafhlo5/cIwmRKrGIcHKIRQVjDRdp7gHQqNQ3T?=
 =?us-ascii?Q?4jAmPRUqSlh0JzJ52RErxoLG/adlS+hSEK1kjNXwct4vNUBMj4DadEkAsLBG?=
 =?us-ascii?Q?WH/ZAEdcTAqhcoCcAIuUmdd/sEgpT9UpZbHg4vZwQkCDk0VIswP+4gK7Parf?=
 =?us-ascii?Q?+i5NCFGFmlodgMJZpLHXUVQWwIKUYuJ/onRPZEjCz2ShDn5Yg+2AmFMrym0E?=
 =?us-ascii?Q?7NdozsqZ0NaWBPO3lGFERpa169r7DaY9Ss2M/b/fB3rvk1NxgVO0CIH5S4JX?=
 =?us-ascii?Q?mEVzcxsnlmvcSy9zLIjDJ9/0ESN7qCPtdYqx/SFSo+0+9tbOdlt285rKplYV?=
 =?us-ascii?Q?FEm/LTmU8Vdzo8YKDbsXwubxTBxZRK3851qcaJlKBvnvUTjm3vL8SqUepW3a?=
 =?us-ascii?Q?NsgCbEuHjp+DmwKBY1juyEhH6XUqttoUVr7nWieL5PUuhZPb6zUNDXpxfpT7?=
 =?us-ascii?Q?GZ4HR2/qATFQifKKk53fMcOJzkqshhCmwBRMLfDAWKThYKiSPOzu9VUjnNvU?=
 =?us-ascii?Q?H6X8yQq7Rc+WoDYK/oXe58+zkuXDsmshR1xtXGCMPTzae7q8LzF5z0bnvYgy?=
 =?us-ascii?Q?d6e7UVNDuQBCVbEsC2v+3Madz6xDJJW/7zf62AkJV+q8X16EGi7S4VKbIijY?=
 =?us-ascii?Q?JJFPTaYqhwhHfEKnNaYAC6Sv9DbHt9Ks3gqrMIcEmiAaF/IpxbNO6XXD/oO1?=
 =?us-ascii?Q?hV5mycF8UxB/zDsGy9r7JDZ2jTivOyBgR5FJABwnaiOcJUCBwigMltmq1IOn?=
 =?us-ascii?Q?Pma4iqS2ObYgVGHZm+YwVeBG/u2XktujGDwssuIvQmEERTM0hen9pignAhBl?=
 =?us-ascii?Q?6e5sCCSCaoDYs6srcflhTQVk/38QUKn1dpCjPil+FTLhXT9At5XHqdDKvRhz?=
 =?us-ascii?Q?VXtPLzafTsvgBcwaiz2kQ+X+tV0Y0vl6bR2r?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:39:27.8461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d972781a-cc11-46dc-7de5-08ddbe9a34f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5913

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 186e69a5e169..618643e7242f 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -131,6 +131,18 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void init_apic_page(struct apic_page *ap)
+{
+	u32 apic_id;
+
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
+	 * APIC_ID msr read returns the value from the Hypervisor.
+	 */
+	apic_id = native_apic_msr_read(APIC_ID);
+	apic_set_reg(ap, APIC_ID, apic_id);
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
@@ -138,6 +150,7 @@ static void savic_setup(void)
 	unsigned long gpa;
 
 	backing_page = this_cpu_ptr(apic_page);
+	init_apic_page(backing_page);
 	gpa = __pa(backing_page);
 
 	/*
-- 
2.34.1


