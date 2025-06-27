Return-Path: <kvm+bounces-51022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0018AEBD5D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2417018842F1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844FC2EA46A;
	Fri, 27 Jun 2025 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LYCZPVSc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE062EA742;
	Fri, 27 Jun 2025 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041620; cv=fail; b=luAslvuIqYmtMutX3hIgEI8ESlf/8vWtMqPUcj8eHSRk3XH+LXwPgSce9AwdEjcydGgebSFVjwTMm1omeGZEWSp8f6OLJryVagAXl9qvy9zH5ZUid83ZYsM6yT+vYucykPwQ+J2V/K9XSJppZxIR2Ll1M0jkfoJgWSy6Xi3bGUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041620; c=relaxed/simple;
	bh=jB7ZYFq1izIxp9DzozFVDEfeoJeH3Vbpmfptq3nAqKM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjGatfExgoVlebq1wHtjAX+q6lpMmEnSrCqXr++iRKDiFkeSQDGxXhlXRbxR92XA/HZE31sG/SeLyby9sU0++adCjClokxAYQjSNSYyU2vWt+U/ycsmls6CUFj1wlPWDof1qVijjj1SH7Yjl4H1MT31XjxmMFserZU3gWmJFzFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LYCZPVSc; arc=fail smtp.client-ip=40.107.223.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GUPZ9DdHVBtwgOp2xdOh/JKrtIoZ8b4rmkUu1jxTVVyqkl3YEQhW/8kL+nORfhUgFwRFrC5pUl39XL18YBiUO1NfCy5uepj2mHYAXSHqEU88CZ0xnCVUPqaKxeNKC/25+OuT1y5WCNYlwLdEpZ7xUWf+flQzLe+lGr91wEg/FNZ15bU5lu+BM99RRP/jiDjm6/Pv3fdCrE/w2i4KeCUFZpygcnO4OzfSe17i5DDWvgNHqi+r95YE9f7ZkPkqZTuukHZw5RwlPCN0+E5xVG0D+mWTlwz9J5gmjOKRJ2Kjb3I3nS7T9U03BzX41ZIMAy6TX9Slu7nKjoZ6Sn5PPXeh/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKqbbQbl8rEZdol1xmmSI/Shpt4CKgpxRrUsiy08Y/Q=;
 b=W9RKpIz4h5PPPSX2u8guAtATmFAnv3SemAtLSxGAerOng1Qd4bY1PsFWH8rHYKx2AdNnX1R8xAmXFN+VRO4O0MllLtbvB/pzRg2XJa96+Sbj5GWwtxKTcX79PPZQEQoM47e07JcLRQYM2xnlD3z1zgw3wNhZe0kyQl2hY0OVRt3Mk6vc+IeJxQ/nd6PZIXu4kE4j8VkikJY0Dpm2O1GWGmH72PReH5g/bozVy03/4PsdmLY5iO/J6/JV+n/XsTfVmp+MFbclNpex+NSrYteGnba7/a80rXizeVQ3CEX9juQpUNHCdqUj0+Zel/RQXgZzKFm7t0D9FUacPFJXVkLBtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKqbbQbl8rEZdol1xmmSI/Shpt4CKgpxRrUsiy08Y/Q=;
 b=LYCZPVScN3H3GHFE2SLC/s4UysmWweCJySI2e7ttrdJrZptA4KCqf/+3TS4UKhA35Tep1ge/6u78n7uqg0QrFzRtix2krKOBYLOSPRO+PxU3vqU5jnxyxJQkF1aLAEZ1pPJEw5UWU6DCYJLjCRGBLH7CDlcR6vcczke0k9QGvSQ=
Received: from SA1PR02CA0015.namprd02.prod.outlook.com (2603:10b6:806:2cf::19)
 by DM4PR12MB5746.namprd12.prod.outlook.com (2603:10b6:8:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Fri, 27 Jun
 2025 16:26:57 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:806:2cf:cafe::10) by SA1PR02CA0015.outlook.office365.com
 (2603:10b6:806:2cf::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.23 via Frontend Transport; Fri,
 27 Jun 2025 16:26:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:57 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:52 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 10/11] perf/x86/amd: Enable VPMU passthrough capability for IBS PMU
Date: Fri, 27 Jun 2025 16:25:38 +0000
Message-ID: <20250627162550.14197-11-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|DM4PR12MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ec0e0a-5d9d-430b-312a-08ddb5976f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UaMn9uvi1fv3RpBXih2K9QvnN4241fZTMEhJo0o9DDsphQ4Iet761qsrKv/u?=
 =?us-ascii?Q?oJcet+pRZJEvGbH9qazH1yELKB4gGuYlaGDACAGcU/0OFO92kolb6TkN4+ac?=
 =?us-ascii?Q?iQwgkrEkYDiqqCPBlur09cTPbqkpYi2rL/+z9xZ+CoWPtwlKmqeqtlelzdex?=
 =?us-ascii?Q?20EJCChPyiEA55UagkW1LcG6NRUOsHZvBafTRmWIEOYRu3tYNVN7cQjQmw3Q?=
 =?us-ascii?Q?M5CrdKlzDpTqL4KeLwSUg+ZNkcFCprSip7Xx2H7MDuvMzpsO7SKDc78AHkX7?=
 =?us-ascii?Q?I8fBFIiWC8ZidoKkjvOwER9LXySYO2W7uEWNfkztjwd+s3vOcxqpI5RzBBZj?=
 =?us-ascii?Q?m8TcBm3MOOQu7gcMd//j8f84zF6gmthm8QQwHs8u/BYGJD+lD6QNtim03vc2?=
 =?us-ascii?Q?zeQC41zBys3tGDYMtXe+sdbfXu63uGL2t25vXCBytyEM8OkKsz+Op4TCNolb?=
 =?us-ascii?Q?+QjQsx9FhVwHmNUbeVOSlMHwEcsi9wAu5Ky54pvhwgrQZU7cAYLAToj0hhvQ?=
 =?us-ascii?Q?XUbogXnboR3+CWAb1Ql62WDHln/HdZErU7XreQBnCDt7NYoGIwg9jH4sryQb?=
 =?us-ascii?Q?yMhHkkyYr1546O1HpKY4A6qpXHvcXeS+uR0T2EFnjy6mM2+kaqkD6eFuqa4H?=
 =?us-ascii?Q?Ji8lB/MAIuOj75+pqvGnqUF+X0xD2v+r0CaKsFm2mwaLIq40N2Hwnei7KNRO?=
 =?us-ascii?Q?qCWEyvLClUh3jwnTE7wWMGRdTOeD2dTLEghVamjthFphz9ZryXFVh/A80gFO?=
 =?us-ascii?Q?hgBKDEp1P01rqRmYr6K4uUtrQ3AZrvdglWXj74YTPXj691Y8UKoBsOxKODGt?=
 =?us-ascii?Q?H/byur+0r66ryBckH4GfTAPSHeCWBr0jqxue74B/vukumTdIlchvV2y7vqPd?=
 =?us-ascii?Q?drcfwKNgQk22QpY2KWVPSPGTJjhDs5iZkYPOpWAMvn8+DYP7rlGYSbtNhA5X?=
 =?us-ascii?Q?0WDQy9CJxxO+IaFm7nmeWf/W5UHqe+NmjL17ZgRxCcBhyHkfeCLng49N7DcL?=
 =?us-ascii?Q?KgzPaRJZ+qrKM8B576mhOnmEAt650DJvuyAprTQlL6ARB4F8BaGyk6NkeNHf?=
 =?us-ascii?Q?mk/EVS0lta+dO6joRgMRozYGeayeLcOSkF6vmH4OHGIMUchANQwBKUUzLBlK?=
 =?us-ascii?Q?dSLXILY+4v93FzsYDROCUbiPjjM1ipToQRgKUlFrV0wE5WpQCEFDmmobCE28?=
 =?us-ascii?Q?wN4qwdJsUsGUbGnw13L4YynOCbcbD4sh05Q9nOqSlHZ7mh/qiTeIHhxVYZDk?=
 =?us-ascii?Q?B28ljD2SOWbXk8JAuiX5bvKKXG0x9lLCMD15rAja6CScYGxj30DNdWTbBHm5?=
 =?us-ascii?Q?GS7RWB28M7b88d9dA8lqrzqGKfAaLbwtUTsgA3XM2gfIW3migQHuLNpe2pgM?=
 =?us-ascii?Q?8IxTOqQlb/HV68RkDxKzZXTUt3nTG9PlC8XIRuIySE03PlNl7J59/Cb2oRFw?=
 =?us-ascii?Q?CL/qWwO9AmmBPtTxzPXTEnYYJ+x42vIUMLCrczCDPXX5WGMczyIasKV8YS65?=
 =?us-ascii?Q?uHWIyuUOXFTaNXBMnwRnYa6wydGnrwm5xIDv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:57.2111
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ec0e0a-5d9d-430b-312a-08ddb5976f8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5746

IBS MSRs are classified as Swap Type C, which requires the hypervisor
to save and restore its own IBS state before VMENTRY and after VMEXIT.

To support this, set the ibs_op and ibs_fetch PMUs with the
PERF_PMU_CAP_MEDIATED_VPMU capability. This ensures that these PMUs are
exclusively owned by the guest while it is running, allowing the
hypervisor to manage IBS state transitions correctly.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/ibs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index c998f68eeddc..00c36ce16957 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -792,6 +792,7 @@ static struct perf_ibs perf_ibs_fetch = {
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
 		.check_period	= perf_ibs_check_period,
+		.capabilities	= PERF_PMU_CAP_MEDIATED_VPMU,
 	},
 	.msr			= MSR_AMD64_IBSFETCHCTL,
 	.config_mask		= IBS_FETCH_MAX_CNT | IBS_FETCH_RAND_EN,
@@ -817,6 +818,7 @@ static struct perf_ibs perf_ibs_op = {
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
 		.check_period	= perf_ibs_check_period,
+		.capabilities	= PERF_PMU_CAP_MEDIATED_VPMU,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_MAX_CNT,
-- 
2.43.0


