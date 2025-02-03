Return-Path: <kvm+bounces-37164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 892DBA26638
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 22:57:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D08F18862B7
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 21:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8109420FAB2;
	Mon,  3 Feb 2025 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AT55O0hL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE96220FA9A;
	Mon,  3 Feb 2025 21:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738619817; cv=fail; b=RKEMisMmc5kllmET0rzqdYiQ/y02+qwJ5FWJQLfiNFq5JVufW6fOrledNcANd8RyseRr1roPrapYFIphnGiE2qsIntldGPEOiX96Qywz+LBgBYKRjSW+lHYQ1r4Qz1cbPxRS2IHZwA1QH+9nxc9SUomYIULiq6XTEzBF9F2H71Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738619817; c=relaxed/simple;
	bh=7WPyINjt4vVECCZnSSPFcwG48U0l2woE59xvg7GyExg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T/05k2/mYN8wNTRv7RsVKwIGZccH0e9hvtPp7lAc9KF/TQWcDATe1/Jv2WfaCQc4aIfAlc0kbqWCAeW+1N1srRjDDCCXgcDZ0/4DsqfDkQQJLaJNK++wG6125M9qzbgH6GjQmwkPRpZEXfdZJV/rZqOmMuCaYysldtkqR15h63g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AT55O0hL; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJGzTdM+9ARYxskKBr0sVRw0AaUtjxH4FfAvyo/M+6SChMr3I3M2NJyT4w9hz3lxGNS6fu4qkKLigr5LDmFzbfFnYumAXIL2m72qs8QbFG2KYQ0MtmrLMsI9Xy/5qd483JQHBj6oxm7+V/p3LA2SxKUcYUiBESuRQzJFdYu2topdhcNy8Vg5DuL2hBaykg2Hr95p4x1BqYdiecScjM+VGBmyofGzidsUjAvBzXyEdEe9E/lYrv0iyyOHnfUHEScxDQfdah8Sw0CqpVaWbsNB3EJoSi39nfv8b5eHB0yDDkA3NghhP2VqcGo6oHf1zrKCfkzzNUwDpopXN6FfINkmPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hww26veQwhWBHwE2boXJ5gZejKVoBbnRh9idtz6eCJE=;
 b=gmPo8yZtAmyI6eO+xs7na4Lph/uIMUzSB+Q35dMS8ggZqJsuJmHILd0lHdEB67SBhIZiEqUl4wUL+Kbx8D54LUhuWPZteRV7r+TZgx/8i9F0uGn0od4S+8hiJRLt+97YsBrFJwi3sdx4mh6vUXS2sbCyhk2XWoblpdmuaufbI7Xcjn/LqCbBm3+FJNmwaJN2cV9i5PcNDfCQmE9047HqKlsQCieH4PQ/SZUmvNXq3rz6Do5JKEtqD92wAwiOn30I6PR8x7Hx581zpszCZD1FZ0Tv/PyAw11EuTXB2jdvGxuRA43ejMyzyp1fMda2udwDtfRuPPb3cBIV5rOlnGSWZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hww26veQwhWBHwE2boXJ5gZejKVoBbnRh9idtz6eCJE=;
 b=AT55O0hLW3F8e25hUUQTRhmh0F4yCH7lger6ekXp4Mu+0B8EfO3mXk9M5D+GA1DAkfPDwZLVcEvXNLnnDwcGgYu1uERFtq3QWg5dYG5tk3Wx7o7x71dHJW0WlAFQFhjZBMj/rw6jbApeN1I6XXR9O3ZK2xw98I8Ed/BBpUA9CbM=
Received: from SA0PR11CA0136.namprd11.prod.outlook.com (2603:10b6:806:131::21)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Mon, 3 Feb
 2025 21:56:51 +0000
Received: from SN1PEPF0002BA4B.namprd03.prod.outlook.com
 (2603:10b6:806:131:cafe::f9) by SA0PR11CA0136.outlook.office365.com
 (2603:10b6:806:131::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.24 via Frontend Transport; Mon,
 3 Feb 2025 21:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4B.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8398.14 via Frontend Transport; Mon, 3 Feb 2025 21:56:49 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 3 Feb
 2025 15:56:47 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH v3 2/3] KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
Date: Mon, 3 Feb 2025 21:56:38 +0000
Message-ID: <bccabf4ca1c19093d5a484912cd71566102c069e.1738618801.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1738618801.git.ashish.kalra@amd.com>
References: <cover.1738618801.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4B:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a19116b-a22b-489e-78ac-08dd449da90d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+nLRC4II/fjIeDpW+ncUR6+IkOLGSsn+q6nC60KQRev/LSgchT/pfgpHqyFR?=
 =?us-ascii?Q?4I9s5nN+cBvo9jczd+A+Ljzw912nRTdTOlIItr4B05iB05n4cms0WopC1Fms?=
 =?us-ascii?Q?UylaiufnT/WZz3TsKHtZD91nfZagTjz4LeIKsGDtf3858nT2qdsFS8q+COxr?=
 =?us-ascii?Q?3Rg93IwHsDZthHJR3zS1RA1ZQ4Pj1gOXcdQomRfbMkq4KkNU6ced+6miL0/6?=
 =?us-ascii?Q?RNtKrAmXazKytlllJa9dS9azZymTPZYo+/9g0wEKil56SaI85bRL8XqzYWyA?=
 =?us-ascii?Q?SMiAhjXfB0i3PnsLfKhASJf/xGk55z+vzn3JVYIxaWYwH2f/YEwq1tpTQYTJ?=
 =?us-ascii?Q?2I5qUFxATNw7rOBnwld0n4g3vNI/qDRXhuNrUvh4UfmIyh5lBp0kURQDn8HP?=
 =?us-ascii?Q?e8HxT8AkuecSfNk5t5cGotKNN4HMHZtM5pZF6sHC3epCee1VNyYPBdGUMpMf?=
 =?us-ascii?Q?bxNZ/3+9J7mezOAjocVaOlrGR9DIsLLQPgkaVJqgLyHw8aC3EtLVsEDzSpsJ?=
 =?us-ascii?Q?f1YN/kJY/00pzac1HVmgCfmWoa0tZ37Uzo9/A1fv3LiFuP8m82umh3VvQb7o?=
 =?us-ascii?Q?sKxOWEJyU94eWNaFzfC0EibOLyTSyAznQ1nCa7jQL+Xknp5TvyhBCweUGwIB?=
 =?us-ascii?Q?QAOrH2DBOD5DG4LKH0ONyvWfYU50NfAeZaCg7YGTdffU7fB8Ng8J5HUzq2aj?=
 =?us-ascii?Q?x5SkkdUeM5Z/GSHhMY8zGaPmgNaYT+C1SEqQSZa9Yc7lg70g6GYPNxLl7F0o?=
 =?us-ascii?Q?lureejOO82JqFJTARHeRmQ/ns6eygkAcPGtFb9eO6WwsQOR3uY6lOQzIzLyC?=
 =?us-ascii?Q?8f8ZGDB/PW5jGE1yEkYmMdJXfh3uitISyScJtydAiwzca9/VAqbO+BZXuVEW?=
 =?us-ascii?Q?dhE7quWszn8OOX3ulI1YUUK+MaOnIiROYIBA9Iik9CQEZgOYtCqs6gJn7AdS?=
 =?us-ascii?Q?ZNb+RyWu+vpPSys5mWlDuairdxZw/A8jSB5UUnDVkOV8BJP4q0Owx3IyFLuI?=
 =?us-ascii?Q?BTBSnthptSGHO2HRDOkuCNXwGGawvFB5Zf8yOMdQT2t4ADpbwO1OXTdcjshJ?=
 =?us-ascii?Q?zZMcWt7dOzBYGWPU3S11ZpOabFtV2x7NkxYroAnm+js7eMAcaNPzsyxbRBJl?=
 =?us-ascii?Q?Kjtuj/l9Cws/HYdiPW7GnXaO9FWZzexFwWozdFWUzUKRgq8g8LnYWdT/lj07?=
 =?us-ascii?Q?3140QL81RAyPJg7J68tzaYkFnUfu0ymMJTEO/dYQl4fFTI3v2LSzjnNwhnsw?=
 =?us-ascii?Q?3TaTAkuc/8w4YlB2hwUmcMoc1qU4GueQ19EbYhIbuKyEdh1iiIIPvnZfogqR?=
 =?us-ascii?Q?zL/LZ3iv5ENaKaM6rrNpeqLBeaw+56b5PX/2hvrS9Po9v72AkZe/7qr/oz3M?=
 =?us-ascii?Q?1pcm2EoRDnx3I7diSrYuLG/doqol0bwabEDknnlt2Qm9cukgS9GV5UWYP3w6?=
 =?us-ascii?Q?LbJMJwiqNI/PwuaX5TA8bEA2QHkUO3BN0nGyKJl2vQT6sLbRALBl6XX7BKpB?=
 =?us-ascii?Q?/Zdl/8bs8LtWH6W/3/2SD4vik/T3mjK35Ujt?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2025 21:56:49.2483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a19116b-a22b-489e-78ac-08dd449da90d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458

From: Sean Christopherson <seanjc@google.com>

The kernel's initcall infrastructure lacks the ability to express
dependencies between initcalls, whereas the modules infrastructure
automatically handles dependencies via symbol loading.  Ensure the
PSP SEV driver is initialized before proceeding in sev_hardware_setup()
if KVM is built-in as the dependency isn't handled by the initcall
infrastructure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a2a794c32050..0dbb25442ec1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
 	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
 		goto out;
 
+	/*
+	 * The kernel's initcall infrastructure lacks the ability to express
+	 * dependencies between initcalls, whereas the modules infrastructure
+	 * automatically handles dependencies via symbol loading.  Ensure the
+	 * PSP SEV driver is initialized before proceeding if KVM is built-in,
+	 * as the dependency isn't handled by the initcall infrastructure.
+	 */
+	if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
+		goto out;
+
 	/* Retrieve SEV CPUID information */
 	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
 
-- 
2.34.1


