Return-Path: <kvm+bounces-56412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CCD2B3D8BE
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:26:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A77E7A6E05
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:24:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FAF239E8A;
	Mon,  1 Sep 2025 05:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MNuFfWdN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A33719AD89;
	Mon,  1 Sep 2025 05:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704385; cv=fail; b=DLMr6SO3m3bT10Nop7wQqrwntc2VoUBnaCSGSrdZKwvWU3joXIwjROk2Ah7yMJ+zPxJZLJdqt5+G4xBpxag77G0ePJdQi5n/Kb6814ds+kSSF1k86mcDn/jLfVkKoV6LeSR5hafcQpv3LE67zsNnt5WH2kmyb5dOjznXCPCD0cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704385; c=relaxed/simple;
	bh=SQ9Zm+OO18tA+8owIZSgnVKWOX3BEpH+zr2BJdFHN74=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n17n5VBksZIbxSAbMYuQOCKb6KDR5z4jP1fx2NKDij4VTgqsReuiV5W5AoCCvpSqumLslnZzBCWt7zmmvKcN4i7oMq5Vj7CdQ+aE83DrHX0YcGdp4MVNmPdEG3cHXUpJEprAGa7huET9+uxcoVmOM4OLvRSNDT9eIzaG/aYT4M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MNuFfWdN; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FC9LnoQftZryd9jx0Ws87H8VJmm0Lqh6E49F2er6HJnexj/Cx5bnqT6fqPyawyJmOGZM371JTej5zXnVleJfIVmvm+Er2YRKscUZTxggIc45E/+aElTD83wns8oZYtIqu5TD/jPjEldIapt0u/ggrycVKeXSCrA/kdwGuhUxkiAKd5fAZROp5yfJ4hvyzOsO1ZEtSwD740KBrrXsA8av1XG3Ju6v2XbNAi1bsSkhJ/6bdAS6fYlwYOiLgD3Cjw3SmEWgOsJpoVkSOG5UzMkxiA2zh7/v4kItU8OFpo6nY6ul3c6seqFhIK0WoOGI/ts3v04ffwRtCGZd2kkq3ERciA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OF19bDoZCcotwjsJ2XpCU+fdHsApM8hIcoST+kcE7Ig=;
 b=K/A8ZxgTDjBFT6FGTwwXODmbntP2mgvpdcJILVIu+OgpMvOxpubo4gSTEcA6JmAhtSIgDdkb2Y8r7Hwd8KKT/l6oPSpqg3jxnGwam5VC8vEfV1On0kd3IMoRDQGbiFKgAAEIz31OmZhNv24OhZUXiRa6bFcZJHKAnrN83HZ6YYld7RDEHW2B8pX0TEJ4gqZixEp+HM0bg1WdE3oc2SyaQxuF/0m92oGuc2NBkzkYK3GN8mUbneCmsS4BSk+xMQGd4PcbFB0cAdorJ5nvcfgiThh71YmkthrWbo1foWN3WoOLygrkp5z91Usc3YUZtKdGAppBYygzSfJHIe1cNxVpOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OF19bDoZCcotwjsJ2XpCU+fdHsApM8hIcoST+kcE7Ig=;
 b=MNuFfWdNKzm6H+Q+oX+XqR4KbXy83llZRcHgP/muezDmJ4ZjHUjO0z97NsbHdIjXX4bA3uMEgbrfKyzIj7XfV/0TIflh1VR5xkET6MlEA2vefb4bjehq4qlvIsCr2Yo9xd7EzdGrl6frS8kOtSBMLDPeM+w5N4V8bY5YKv3TnPg=
Received: from CH0PR03CA0306.namprd03.prod.outlook.com (2603:10b6:610:118::35)
 by PH7PR12MB7985.namprd12.prod.outlook.com (2603:10b6:510:27b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.24; Mon, 1 Sep
 2025 05:26:20 +0000
Received: from CH1PEPF0000A34A.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::fe) by CH0PR03CA0306.outlook.office365.com
 (2603:10b6:610:118::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:26:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34A.mail.protection.outlook.com (10.167.244.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:26:20 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:26:19 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:26:15 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 11/12] perf/x86/amd: Enable VPMU passthrough capability for IBS PMU
Date: Mon, 1 Sep 2025 10:56:02 +0530
Message-ID: <20250901052602.209264-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34A:EE_|PH7PR12MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: d6cda5bb-ff96-4093-8860-08dde918153b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DWXLcWgT2hL56qvdVGZBJ9lxkmzcdbQ7CjGz2siOO7euuEayDk5VGLRVCh4D?=
 =?us-ascii?Q?1SgYE7XENgalRUuz0Rrolte9+xwpfBTi36EETTpxkIwszVZlsXcNWDwhUJyZ?=
 =?us-ascii?Q?OG9i4yTRF53sc3bNNLFkpk1iFwYl4VwsZHsP3AeaPknkz8iyGKQLdH15KLhU?=
 =?us-ascii?Q?4dGov+P3Ss1Nes/3TJfmiweOFv67furi9K7xTYf9JcevYsR21RIfEZZEkalM?=
 =?us-ascii?Q?qFWdPa7Lt41JtHTHftGLM6/4a9ylRxCjIyuWuwn5YYHznJMr/4EVIc46e54F?=
 =?us-ascii?Q?mWDIn7kFeWzMDn6R55QEEuOdC9p45Hdd/ATbEHbEK6f2RNkKhD1TUEZ2NO+T?=
 =?us-ascii?Q?rroY7nY1sGHqAnUNcLXYLtLte3coTetpAmXXw5PIC3Xk8obgHNaHfqD2yLav?=
 =?us-ascii?Q?TUgbmuxy+99FzJ61+DlRO2q3KELuSgPxngJi/iVn4GVMubIDZwKPP/stbHL3?=
 =?us-ascii?Q?OgU6PWZV+G6NaFa8b1N1knXFPmLFmEVpTEbbJlktdIfgbauEQqw+BvYp5oIg?=
 =?us-ascii?Q?XYIPR25iIPzil0QwgFd8tvffUF7SIcD5APXHZfkby5CqWxJ/itsAHA1C4iz5?=
 =?us-ascii?Q?vfA/ZCHjKvI/jOQ8r7MK8nldsNLNpkRNFO0j7ES0oa0hC/41ChhOZ0vw6I4T?=
 =?us-ascii?Q?Hx3O+aQpmyMCtuOZrUxQRRwrdwduZpF8X5cjJM9yqw12ro9BbKhKLqALFy7W?=
 =?us-ascii?Q?hrc17J3f/NFww0z1/eao1GdhVge3ElZkQO40HPoJltGSGKH4HyDCC7paJOCt?=
 =?us-ascii?Q?ZEUBJgm659yJlZXa0yD3C3rHQcZJLo70oCFFAlseEnxbcWBE4JDgNT/pPQNK?=
 =?us-ascii?Q?kyVrpODFU2Y1MkucvxXDcR16TasgFZJsVuWlcKMJC5CsOP1h5Y1+p5wS3TfB?=
 =?us-ascii?Q?gFECjtjioX+6Qp6fAQFb1PVAcYk2iiwVgNOGttk+Q6MnE4wsdH2MgNWuqmpD?=
 =?us-ascii?Q?WZhzsZajgmYJBVY6pM3dTGee1muqor8jhsLWpQIisnlZLXAjeVeOnYT4KyVO?=
 =?us-ascii?Q?7PBbHQsZqVJY466j619aC91Uxu6j5wKpOo/fBm1y9ucmmmFYJGWgvhj1Ohol?=
 =?us-ascii?Q?EPWr53USpBUFVnYLCZ5vQBCq0+JdhiPboWfxt4PlEejB5nJDpNuMqJqUPobq?=
 =?us-ascii?Q?CHNqjS9tYrqYW+3+S/tmAeAE6b5hF7zuYQsnyR4B2KkuH32ws9/dXqH0e786?=
 =?us-ascii?Q?rzp3N+UXUpTW0Hyc+c7WlrT2AHgGqd0vW5318ofNNjmEsPm4Zd5N8x/nSTNd?=
 =?us-ascii?Q?731YqOmy1kNfWwYPxFK2LRsUwMgUAn1mw9opdrSaim9DsCqfN9G2/9lDM+n5?=
 =?us-ascii?Q?yXAK+JWlv8nKdwwAi3TjWB61gzgWkB74Itf7M6STq2uzKN2o9dfboyN1TxoV?=
 =?us-ascii?Q?7Dxw/7hyXWWsr/enrFwqSwTzEhYNfYs51Rr5jmtR3d3r9QhDEdJcC1vSK6Rn?=
 =?us-ascii?Q?ZlaFjFRbVm05mzz+MtmH5ANE0uHZ4ryX8Ru1/cKKoo5s/oVRhGVK0CaLR45H?=
 =?us-ascii?Q?frnQgTjdMGl+BkUUvuJ7Rwy7rb+77pjFMc5j?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:26:20.0640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cda5bb-ff96-4093-8860-08dde918153b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7985

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
index 67ed9673f1ac..6dc2d1cb8b09 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -793,6 +793,7 @@ static struct perf_ibs perf_ibs_fetch = {
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
 		.check_period	= perf_ibs_check_period,
+		.capabilities	= PERF_PMU_CAP_MEDIATED_VPMU,
 	},
 	.msr			= MSR_AMD64_IBSFETCHCTL,
 	.config_mask		= IBS_FETCH_MAX_CNT | IBS_FETCH_RAND_EN,
@@ -818,6 +819,7 @@ static struct perf_ibs perf_ibs_op = {
 		.stop		= perf_ibs_stop,
 		.read		= perf_ibs_read,
 		.check_period	= perf_ibs_check_period,
+		.capabilities	= PERF_PMU_CAP_MEDIATED_VPMU,
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_MAX_CNT,
-- 
2.43.0


