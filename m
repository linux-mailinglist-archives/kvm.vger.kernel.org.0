Return-Path: <kvm+bounces-37757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0CDA2FDD8
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 23:54:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1DC93A4DCE
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 22:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A4D254B16;
	Mon, 10 Feb 2025 22:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pNgqVZ4X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768BF2586DE;
	Mon, 10 Feb 2025 22:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228059; cv=fail; b=QeKsU3ojF+NbsJSqBLqqs/2PAf0e3eq7pKauQS5qn0AxWp/oBZ/TIdxhe6A4HNAv/xtxWajQvfZJc9lQKIo3ZaydActg7NxchvFgD5iHCG/fGs1PNguWZwV503+Yn+/wey45OjF56lOuKe1o2uUePTMPZ3ELDhSYIyu2D1P8VsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228059; c=relaxed/simple;
	bh=gVeO3gJAHftMMLylj9jB7IO3TwAHnGDEnqulCtADPso=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVbrgaHXFZe5InyaiyQ8kdzKAaBrr3dF622VIuqmHDlZI/jykpMickO7ROXQGGaCo1SfGoUANhoQif42KmTxRio2kT1OzH6d1XMl4Nx4aWBzQaZ45KLci9RetDWJaiofmZAZ1Az5lKRWNYviGD7eq53tqETxyMNaY2b9v0HpGPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pNgqVZ4X; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qujy4xQ6DWm/vVmyZOIIJMFCiwHJ9108TEVPzUychTbb2DPtytOtsGKl1vuMLMOB6Z52R8xn0PYgZsgCitAgByjfY4EZo8rCx+YUUydKVdEwGQ1zjUi8MAEvYzmMju/OfPY4gpaAUXHgAg15r49wBhKQd4psuGWclnEXNcDkN6b3XjTyO2lP8zFBYjkVge4gzc3QCnHg2fWJFtm1LKjfCVqmmIoKn6s36oDt+v7bfF5bo9cssoI2HKX5pFqULEPPf6s2F3WcOovwfplb8NGWTsZKkhPllb+kkZTS/ovDxiftPlvVtq7keBwgeybai2YUe53EebXOIlBAJG0V+iUN1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OUtDsoxi1l32N8JJ4wfFMXlbzClj4sCYDy2iJqhnLA=;
 b=mJ955lDiOLy45owvuR6kjdVjxeWmBhTZHdpJCkR9VQG6q6pVnMg9fzpIgY+lVCkqt5Zql+S7u5M/M54YWMoEtW4FZIHi//tmSU664/G/CWCY96CfTdzQHKr6UQ6jZpGnuLtfIXE7nZArtHMKE5CgiJCtfh9xrhmMRhcgitkS1/cyNKTjwJ5u+XtqtB/7wAjsMNvW2j6OOabFBRr7RAa64Ne4fdI/jkQhF5/BgFS850qW0qpDO/NmgJmVSKDSH4Ec6IoE1V+CexgJIiMi06J8Seisr+35ZgZRHPPiqXsUFros8zvabCj+aVS0tz7/kWPCxp/eBmR9ai0t8bHsxkGk+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OUtDsoxi1l32N8JJ4wfFMXlbzClj4sCYDy2iJqhnLA=;
 b=pNgqVZ4XEA54w7sNKDJSzs661H2pTMv7wzOQGKBxusTHuxxY4ZZdEogrzfBAG2FKRQ98OlqlwckSKYNZtFw/W0A7oC0pDZzsL9P/quLZ4dvkzxTN7HQjVepoFQiIVEPaUG4/1gfDCkv3P4XRMuHhxNo/HbXa/iu82TvPtc/1QFE=
Received: from DS0PR17CA0004.namprd17.prod.outlook.com (2603:10b6:8:191::12)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 22:54:14 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::ab) by DS0PR17CA0004.outlook.office365.com
 (2603:10b6:8:191::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Mon,
 10 Feb 2025 22:54:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 22:54:13 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 16:54:12 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<vasant.hegde@amd.com>, <Stable@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>
Subject: [PATCH v4 2/3] KVM: SVM: Ensure PSP module is initialized if KVM module is built-in
Date: Mon, 10 Feb 2025 22:54:02 +0000
Message-ID: <f78ddb64087df27e7bcb1ae0ab53f55aa0804fab.1739226950.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1739226950.git.ashish.kalra@amd.com>
References: <cover.1739226950.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: e5cac247-8543-4bcc-0e7a-08dd4a25d714
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IzKa6+cMUKaqz0WgH4HFWeuyyoDcuIOgI85l30ZdQ8dYCyDLg0ysdvTB7wRM?=
 =?us-ascii?Q?SDWEtUCbnAEEjR2TgteosIoTbGv7bTSiz99peyoTZSbiR+yvQ6rMfjcQU/WL?=
 =?us-ascii?Q?GG0MxUs91WrOOY8ak8oVHiQ/eyM7WiN/zEL7QvjskcTeNbNDoDBZD7i8t23w?=
 =?us-ascii?Q?DgJA8J2s2/WgbJBK6ij1tgmgbRS6Hjs8jFSZF1qpPb5wqRzYcF3FjTSlv8aO?=
 =?us-ascii?Q?rzw2ybAhP8WoQcmmp5YEvMPYkwj6aQbGuSfMi0EgTXTwFk7XnGhEdt8Em6pQ?=
 =?us-ascii?Q?AAcISUeg/ftY8vMn9RWh3hwb2msZagSYAp4/i4O8zKQaW2cpPmkcx8QdXS5c?=
 =?us-ascii?Q?6TriJ1loH4Po6EUwy1PyLfQZXCsFM/RZJ5VIvEMG1M7O/aVgNia5c18Szd0U?=
 =?us-ascii?Q?2s3jB7BwkjwrAhO5eii+Hdgizj8pDhFfxQnenkVIoo5rsy3BKola74hs6yvf?=
 =?us-ascii?Q?9Z8lHIryVNWD1pEK1is/WV5oIpt0tfPeZg65AHeGadvMxpO6OhVz7mWcXORg?=
 =?us-ascii?Q?Fbw50CnmD8rF4NKet/mdqtPpHEA0+xhs2l/P6zB7aC1emhER0eQYGpQc9/z7?=
 =?us-ascii?Q?Yp7CHgvWTN3c0pud/wqmdlBK8yS3rviecW3qfJAgnZF8HFyEbw7+Q/MrILON?=
 =?us-ascii?Q?y/H1vns2cnULhtvkXUwgZeMWLzyK7pY3aGF7wWOWb9DfVrF8ku62G4ckHnr4?=
 =?us-ascii?Q?P85kQpSclXve8njetP1mm6LeQTLltQOTjc8ybt09til94wb0GGhTdofhUq0n?=
 =?us-ascii?Q?IqwS0MqqEoIE3pSAXYRy7y36uofphLaKkKUC6FtdtyBZ/77bB4U6LddttyNp?=
 =?us-ascii?Q?Sx92qrsaH3M+1eB+UZO9ymI8chJWNrSNkbNEHRDCOlbGz2389ke4aKb+/4Y/?=
 =?us-ascii?Q?XG7tHMWoqRGRElP2FxzTZ8fxLH0KUHChjHy+r9KJ6M65CINiu+WACpRwjfbt?=
 =?us-ascii?Q?JCNCYC+B6je2XiLMFRLDo7BLY2h+cxJz8Mzw6HcgTd9YQ8AWs3UcIzSiieiv?=
 =?us-ascii?Q?jFXShb7Sox1HFmH4Z9iCE6piv+3OvRI26/xJEI1mo2yHGIX1SFXakFPNeU38?=
 =?us-ascii?Q?21eYwU1wieWFBCwoj9kWZ48CcLN3hNj2YRSBpJclYHeFpMCCH7Na4kKYOh+i?=
 =?us-ascii?Q?0nY9LhisiSDO0WVFSKFpTTEUtZ6TqXJCF2yzMAzBZQSjInlVWLkZasKbfRyg?=
 =?us-ascii?Q?yqOTgMAxOGy+4jm5wxdYWIsyEMK5Anj1juTyMvOMU9ScnJEp5IA/sEOkJh6r?=
 =?us-ascii?Q?cdtkzGKBM2u5rEbcFt2cJ9iNY2A6U9MPCIH8mUIr5rIeHEPxRKl2Y0+hEBgv?=
 =?us-ascii?Q?meMhSslurYhxKdDG6MNW5WiS1SK3bylw14z5GtvqaEYxoRVAbU3mldxFRcq+?=
 =?us-ascii?Q?DzNzIO3rCslJm/rzEMSj2vn33mxlOhFAKoK6s83ti4pWtWIAdBJ3Wnn1URC5?=
 =?us-ascii?Q?TTYahEWgrflxXHjGLpT7vX03HHehaj5EREFztc+rIoZCemkXfhKApXEEptfo?=
 =?us-ascii?Q?Ckhe3FukS7SC3w15y5PdJYRTKCMHOMolY0X6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 22:54:13.8045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5cac247-8543-4bcc-0e7a-08dd4a25d714
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

From: Sean Christopherson <seanjc@google.com>

The kernel's initcall infrastructure lacks the ability to express
dependencies between initcalls, whereas the modules infrastructure
automatically handles dependencies via symbol loading.  Ensure the
PSP SEV driver is initialized before proceeding in sev_hardware_setup()
if KVM is built-in as the dependency isn't handled by the initcall
infrastructure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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


