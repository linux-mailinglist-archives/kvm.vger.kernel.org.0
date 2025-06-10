Return-Path: <kvm+bounces-48839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE516AD418B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45F173A65E5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4320124635E;
	Tue, 10 Jun 2025 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u27SxD+4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCC215C0;
	Tue, 10 Jun 2025 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578604; cv=fail; b=O3CGna3VPji5HngisPm5SWlA9ATio8ys4brvmMwajO2AXOIP0pwq9eqZYLSfuZ7AcGLBgs9JqMz8iHVNjtfHbWvy8lX2CfXlVcmgkKlVwiWUEWbFhOgE9DQJAP0tuW3HDFmp5GnB3HpeSvFVyxquBzve/L3RyKtzaNUrHuRDgfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578604; c=relaxed/simple;
	bh=/BhFBCmzpunjHu9xfKM3KzgvX8Z0Etk6CXDnulgWh2s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVse7mBthqPzPzCA368+g9ojnJSGaDw/FA55loI92x6avB+wRzlF1VYg2MSSZ+izmliez7QnyyIhFeeWUs8MQX5eocgVwcXphAc1Rk41+wqxuP5jeVYmo+NbgpSrJIK0yB7muuRtKWG4LYKFoYUp9PxJ8Snrmm1ArY1HTWVcR9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u27SxD+4; arc=fail smtp.client-ip=40.107.92.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LZUBrRk0RNen07bIvLelVwEDHImxxs9tWU9GIdsnhrPV/R4hMxu3b82aIEecMAghIbQjsxC7MBpYVORL2kXSYnc/ZwkyjGDGpixSBZXUk9sUSLL8q/SDnL8cB8PjfiVHVfhmxuS5wybFSPYF3oSE2oFA/qmNvRGysxmdb21Kpxr4PB2gR+HbzSibFWOaQBAPOh9P4JtwIj7kCK+orhGAFCRvrA5J0orNCAKKcdHMO13O7hnoypNOzGnnVqZpBmLlVcg6mudradCRdj3Uz6gxOhkF00dK5vDiAmNxLxOWlVbtytA0CRxom48b9mxKoVVfzZeYrv9vKQTXwuFMv5RM5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAS8Zat9fB6MOirWPE42JG2oLf7lRRsGgYfbvQaF2YU=;
 b=kcxcQ3NNMZ+C2UmZU9sGZ95bxOEtNvveUPdl+RZlaXAXUn5D9/YwO78dP5gJw+0nWV+udb4ScUa9Hk3snk/3QfYxqJVINB3b0MxgmaWjK65+tRZLVhfuHIYE4beRplQlYIJ399bCNGhe/vrPjzfMpANMafZ74jJZ/R7UC8M7yWoPMHp+QfITPmDN9bkr/RiTCC2o40qvLyxZ3hYCXuuwg900hmAzjNCwIPopCEoEchy/1ZXS61J2ZODesoHH/GU9cSIhFVqlwEtE3x/HQwOHqEZCmPOQd40maqPHpPCPUj2UUBrkqtzXrvy8Q/ugQ5MMh1+RLZlcfIEMunx/Mk0sxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAS8Zat9fB6MOirWPE42JG2oLf7lRRsGgYfbvQaF2YU=;
 b=u27SxD+4zjJjsNu/3Y+l2UAvVqPb1buNt8Wot0yyRpQTXCQOW9jfFSwAnoEm4sl48fk6DxPaCkS9G64IrTPoSMUP/ytd5RQy4NaFk9mkICkcmlHc3mqKURm36PaBlK6B1wy4j0PcG/SRZ4D1OlmPa/Yt220MXwMXp1i2Hv9xey0=
Received: from BL1PR13CA0391.namprd13.prod.outlook.com (2603:10b6:208:2c2::6)
 by CYXPR12MB9337.namprd12.prod.outlook.com (2603:10b6:930:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Tue, 10 Jun
 2025 18:03:13 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:208:2c2:cafe::cb) by BL1PR13CA0391.outlook.office365.com
 (2603:10b6:208:2c2::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.18 via Frontend Transport; Tue,
 10 Jun 2025 18:03:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:03:12 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:03:04 -0500
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
Subject: [RFC PATCH v7 23/37] x86/apic: Initialize APIC ID for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:10 +0530
Message-ID: <20250610175424.209796-24-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|CYXPR12MB9337:EE_
X-MS-Office365-Filtering-Correlation-Id: cc7e6275-b066-421a-b312-08dda8491100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZrM7WQelCiObwLYzTMm8yubB7vPRNSIhj5wqSAVFP2+igJ7Ek4hV7r/R8Awp?=
 =?us-ascii?Q?LKwH5Qys0qmFzo4KqR66hbeDhYVIVQau8hM5T0OGs5z/Ab/5q8usNZi7Yala?=
 =?us-ascii?Q?jPLSKzW2c+hcwtO3olL7ojepfMNw/FJs8xuJ+5m69DhmBdaHeQIf6DJlmCdw?=
 =?us-ascii?Q?XMF6M/2vOJ+XRpKpbHbzd95/d6YOk48VZ9gm9yXDIt4+Zvz8wyggQ4YwokyU?=
 =?us-ascii?Q?Izjtl5RI4Tmnje/tklESDwe/gZE6hk+XdltHYJ37L/AdrAxEV0pGLR0YpO4N?=
 =?us-ascii?Q?uNfUtKO6OlQBs32zla5w7Jsb5u1xKrUmW3bQyMHRfyWxLNfVooo8cJylenR4?=
 =?us-ascii?Q?ftRtgXb7cHx7RdVVNvcgjMWzTu6XhqRsCVUbIa7VXAfvS+HOrggVw96Etb7k?=
 =?us-ascii?Q?UpfNsuJ4NjVXNc4C5yGaEfRs/BaJpi3v4RY8o3UMggu0f0+43b//fFFgbtVX?=
 =?us-ascii?Q?Iuiud3p/v3ZikpTGWTOu4Q2X5yNCpmocmtIlFjDgHukINsaQYSP0h/XoSemg?=
 =?us-ascii?Q?AJWrFx1DRmbIqJSfxut8bvxH6+a8QhC5grmv+XL71iUZ1VXSD9sfz9WbbOHY?=
 =?us-ascii?Q?AufLFJG/D5lKfIy6UM5qLPVfm4qfsGI4/Ey9q5xXrycM93o3UkoTzT2CMmTd?=
 =?us-ascii?Q?doiHlPprNjnni+DfywDX0juLDkfc7QCCTmjeI888qeL/tvR/rh9p1Oy4vKBo?=
 =?us-ascii?Q?UANdqtU9KVILMo7KKMWh4En85i1tePlUXjzRbrx8V4C7UMCf0DMRFmXjDcev?=
 =?us-ascii?Q?ZBq6dN6K66W+m7F4GKoZRW8oxYvIAbBo7bbvx1q8wqDoEpxSAuFaxdUp7XV8?=
 =?us-ascii?Q?uP4PG0U4JNEwkVN92gOPa+jv9qlnLyLLk2KL93T2f5Uu4AtJIk1d27hjE1M4?=
 =?us-ascii?Q?ras/cUmKVKLSXaf3oo6xKjd5Bitgkp0VKuVlpzR+ngC7eVb1G3WRiUzGRCoZ?=
 =?us-ascii?Q?T3PkihEXw6m7RM2IxzH32y8kglfICAkwiA7CYpU3dxrWh6/AhZ0HxvfjEpIh?=
 =?us-ascii?Q?k5R37939fOGCaTpv/ZpiZRoJchLgIqeD3hNnsDVG6ddN3UlqTQtKyf+ybrVf?=
 =?us-ascii?Q?SxL1hsc35qLmYO+3I5GvKD38/25taBYHwLOzAUCHIX9MLlDggan78FWvYLVf?=
 =?us-ascii?Q?gJxEJCYeWj2y0iRyCHY6BhiXsBijv4mIVWd/2DsqON6nGOaUTBJ1kysndjKv?=
 =?us-ascii?Q?pcRlxKXpTWO6CoBbGKLDHwEVpoPh4hSn3LJFYz4vf+h7+D4L6EimBklWB91j?=
 =?us-ascii?Q?4AhQeblI5qLD5bJmqN0AN0mPrtyxBn675GRsRdjxqfJW9G5guGoazNy9yJ4e?=
 =?us-ascii?Q?Czfo2RaIdmNpVCcQpp68o1/ieWXMBp9w2JmRodZ8cTmxTGkULtl7Mu+a5KOT?=
 =?us-ascii?Q?3uBHO1HMIvM74SRmmLjlWDQZwdeGxRY48AbxyetiuC918c9fkqeEzFf6wJmD?=
 =?us-ascii?Q?228q2o+rv66voLQLNlHFHAiMJ/2zDCIYL77WhdzWokGxmhzEoN5OzNiEpIR8?=
 =?us-ascii?Q?lbFAIPFbGOjj8E87hLVqBoWha+jLYO8xvwdY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:03:12.7367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7e6275-b066-421a-b312-08dda8491100
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9337

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

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


