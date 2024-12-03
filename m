Return-Path: <kvm+bounces-32903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADAA59E1692
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72F5A161575
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA011E0080;
	Tue,  3 Dec 2024 09:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BFXvB2ZW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D767D1DFD95;
	Tue,  3 Dec 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216493; cv=fail; b=l+Zuf+r5eSheKEAVQ1Krz3x77JukpXrEZjVuf51S31nxhh74wc6QjvYou8K4Dp94Zs0IYQ/ODmm9O6lTpSVjP2UeE6CbaqSYnKVGeyn9oo0Q7bTBgGaI5z/OeppGTvAeA/YUULgDShCrghsxrTts2NKY0YjxZiKGvIeZnQ9Tq64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216493; c=relaxed/simple;
	bh=xxgGhhE7eqLY0qKIzlmwkzy8uGXHWchoatB47ooDhUw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meHZSKVLq3Na3VqbIMt272dzPQQJL955dgWioQUUJbem1JD2Fc+p46BcEUV/7+3TFrE+rkgIkr16DHLyG+4fKR9b1rTxya/DsdIZh4ovOKXAEkZhVZ3VJBsY2WyprvSbO1btx7As3QMTrIKGOkz2F3x8GRzP55/GPxPmsFPx+II=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BFXvB2ZW; arc=fail smtp.client-ip=40.107.101.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qu2HSwh5bfj5q25RQainpCfHRZFOa5VONdoCrv/TfiHiYTF31sC8+V2Bao8UxHU9io092hF+VZZSYh80XlrV2ow6hVFbfHr6slkVbX/4NxtElyCqlqs4m2ZhVSEg3i4PF3EAWcNy6THyCaSI8qG6A0Mih7+EUqr9VIUm4aMjNeXYOCuffZvcVlCrefgxlYytRGsxWaTlseILiJ7EuMFQaG9SgI1bW1IbAYXjVZPXHYo4EnFp7OXeUtXk64NSp+Weqb6WKiEmFxkqxGo8TU5Fhm8XiNbDkgyEWim4GYnQ8ykl0A3QLrP1Nypc7FYoWuevL3VgZzzuBB8SjPfVAIYFzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hus6KSWzfISOR78FRMjPuc7o5ht2CzZat74hItkA+L0=;
 b=kx3fPu67N5Ub4Sk3Ac/kYTobduZatL+pUHC4TI8ZqP7opGKZx/SK1uCxFCqHT9uAkvUQ+bgpU2EBlx9Ow/bT7M96nQ7FaTXsJ0JrZ9QEPHJYYRkJS+ubh7Pv+BuyEonj/xmxlzaB2vENzkh79c4Fvou07QV4Az3sUFnRtUIPpE/cCN9TLIOcSJBklFr8MXYPSX8tafYAoihC5S87furHNFmcOQpvUJV5wDFKXWgYn7hgEDbuuokoKBPdmrNWIOCauZdVyzGglfiOOB1sLktMiBQAxU5JF5aokT6phG9x/bAw43Dix0xOreTR+3WN0IvCGJmtrjSO0R1n0pY2ue5IHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hus6KSWzfISOR78FRMjPuc7o5ht2CzZat74hItkA+L0=;
 b=BFXvB2ZWpRjEHr0MUDny7GXrMHdfNxod4T9LWLqFX/o69I2t+I6o0Pir/cOuckrxVEfVN+SO4h2jnvaXtorO60VCllhHxHBeIJg74hguT79PhgnLJCbBDu1vHUhsX8M0Wr/SY7Pl5mjJW42G17Brca6ZuppOg3CQqWNlI2J/wW8=
Received: from CH2PR12CA0014.namprd12.prod.outlook.com (2603:10b6:610:57::24)
 by DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:26 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::22) by CH2PR12CA0014.outlook.office365.com
 (2603:10b6:610:57::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:26 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:23 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Tue, 3 Dec 2024 14:30:37 +0530
Message-ID: <20241203090045.942078-6-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|DM3PR12MB9434:EE_
X-MS-Office365-Filtering-Correlation-Id: b043dfa9-b086-4392-12fb-08dd137911e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y4qJuQdGrmEfRpMs+JV5B0WM26HmynjiSifxvZXOmmce5Iwy/0P0+FSQy1Zf?=
 =?us-ascii?Q?rOMFVChPeK81B2H0FiwHnYD9gpIb0mQ0KaoAFBZQIiDJAfHewpJD5rBvzzyS?=
 =?us-ascii?Q?VC6jnm8jAhnL0slOQ8iN2dEVATc7pkZZRNkUSTh3uJaAclBdVozaCO/pik9f?=
 =?us-ascii?Q?e2Hzy51Sj7phSKi3nnGEf2v8BeX/wIpkikDb3Hb3OlV+NLiBe3X6TCKDWlfc?=
 =?us-ascii?Q?2yLojj8M14Wxr4lsHn2//AC+mSGs0dmOhZF5UMwIB+K/DM/7t/a3Xs0noWcl?=
 =?us-ascii?Q?EtmyYCLih8IcpcaJLv4NDOw2m07U6TXxrKJunya0rzeUBW+K0If+EQbqKgfm?=
 =?us-ascii?Q?zn/UukNMegLJPckMqntqVqw1T857zJ7tE/YDExgx9eMAcNG0tAJ0g4Dcga1Y?=
 =?us-ascii?Q?ySQuuHR3W5UGYZKoQCDDTBoIQZslThnaHOtn8tXDXHL/SHkjtXcMfk2k7P2F?=
 =?us-ascii?Q?q9Q4btTz2XHitBHEvJyAwRZXq8fndhbM/2CCK+t4Erk8A7q0Z6cuOf8+xcHo?=
 =?us-ascii?Q?3BC8nu9RTyM+DQ8Y98yl3OUxAVutiCrXFKUwfwXWhLmhqfDhFw+0sdB+shc6?=
 =?us-ascii?Q?Z48kPEOv7jAyvWl7617fKMF3ZTa78Mk9ksmuhNic+eFUTc/oGkemDEO3Oas7?=
 =?us-ascii?Q?QIDOF3Tm+4zXcg0L3Hz+Xu2nlhnH6Bw8WEc5bQs8P3tUwt6MdEQdX/abjElK?=
 =?us-ascii?Q?FYtgqxWhqgUWgddXKxWMJofDXwOvjyzYdMi9Jqe+9px4RqfPPU56iMLgWEOd?=
 =?us-ascii?Q?CIfG84flbMYrxLPbYm/ZjlbvBNXfUrnDmrNfIK3HJ+tPYPUl4hLsK7fOLxn0?=
 =?us-ascii?Q?C2j+9z5YMhG0PdIxdlNnIVeXm8IRr3HNMG6Sudj51UOYvVKWSBLD6V/AYvOn?=
 =?us-ascii?Q?cqaygcPe2F6jl6+WfO0+KsdDxdUOOcAxmh6cJLl8lIEk6gk90steSNxRqSJj?=
 =?us-ascii?Q?LsGeeb21WN7uzUt4ZWRBTr/Wja85nVM2an3YctHNflka9Rz4X7rk2TKHRCDC?=
 =?us-ascii?Q?QqdOhw/A8aa0jN/o37IPsr9LK4qggqT5MCexM2jvkuYdVk5y75OU2m+Ulnj6?=
 =?us-ascii?Q?df/FQ7rd3oLHVFCo+bKHxhTBsVeybPtOPSou2TPPl6KLF/mHiPcKuqVjwq21?=
 =?us-ascii?Q?+xh9JkJMTliIdVHbXrETMP9vDUD8VHmbyEx6equweEUHpfQsrJIpIqQn0L5K?=
 =?us-ascii?Q?PaO1ijZN0UpO/m+xL6Zy+igY6fypusHC62+BWTBToWXtBxJu4aB9lNkdN4DJ?=
 =?us-ascii?Q?4t/TG8pqThIljZTGi2boF5cfcCkEhgUEjS76gWdfgwW4OTb6pbQ6HqbOWVRJ?=
 =?us-ascii?Q?uAvcSdBXll/EG50Rv+OEtUpL1sSMJ7nzNfi1G499MexViRBeqH4MdMBeKmu2?=
 =?us-ascii?Q?a3AxKBUj58Er3gEMvIsykFPpGZl1GtDiYc8HqOGIKTKZnHyp++p3odM/ph/N?=
 =?us-ascii?Q?OuZuyJBrIwsWeNganCtzzy2nYAdXbXYv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:26.7893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b043dfa9-b086-4392-12fb-08dd137911e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
are being intercepted. If this should occur and Secure TSC is enabled,
guest execution should be terminated as the guest cannot rely on the TSC
value provided by the hypervisor.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/coco/sev/shared.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index 71de53194089..879ab48b705c 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -1140,6 +1140,20 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * The hypervisor should not be intercepting RDTSC/RDTSCP when Secure
+	 * TSC is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
+	 * instructions are being intercepted. If this should occur and Secure
+	 * TSC is enabled, guest execution should be terminated as the guest
+	 * cannot rely on the TSC value provided by the hypervisor.
+	 *
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


