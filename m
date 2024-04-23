Return-Path: <kvm+bounces-15679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A643C8AF3EE
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96950B23A7C
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C944113D508;
	Tue, 23 Apr 2024 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="41FS75/K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858513D62A;
	Tue, 23 Apr 2024 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889456; cv=fail; b=QS3XpXe9Xzsp9m2QGHy+vdKrMmhnJXE2yxpJIawuhl7x9MD4cQP41s6OakNC+vsNT1HPIinw2pDF8QeHFrHiBQnakj8YFHlYIG1JqXx3e4PZlBv4i8wHg9ZZDIs6FNEoLs7GjhEeXb3eAam67ftb6FHIGnilBZIEDqNGOvF3CiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889456; c=relaxed/simple;
	bh=77aDoFXRWl6n9N0DxIlH0dZHZmlwmNueOPoWx1ztjEw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSi698P1FbxYX3Hx1oMYCgVBs49qH2SoZ/mOStaVlgQ04SpgifUVLQduvVlyG/u/PMbqDciSp4M0+iZUh3Z4k2a2VxKlLgqC9FyB677SQ2w/PCrYx25tzX/JHcET6nvgv/OvyQBzEgJLKoacunV+neG/iEFYBkByG4Cqvi6ryOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=41FS75/K; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaGiWUn6ozUhSQFnBvZUkQj60BR/s8Aui9Yks9nOIoSyex+lgIeccwbFhdgM1pnQAVyjY/BcdI3PLtEt1MA8YTdBWqBqgbLhTcOPmLT1BIalAtJ/4LCBRLFYcKTYTC+y5PyIuZ4HSP5hZKiLIJg/rk5hBcud4xAcPQ+5jih5OWRzVkYHDyJHHwpao4g/Zxzz3X6njiZ5hz3zI3JIh+3zjVoPkziEo/uj1ofvkHRZGCeTsNCFVr3y/qAdnGBJygLABawpy3ME20gRrDnRbsEdqAR5AcRTV04xgL94x7eBqS3UGKjuCVpMzNR2iyIGLHrqBYbETDvyy4HqhxO652EELw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=42poRSSSZjU7ZDIoATOoyv6W5iD879/831zPKtREN28=;
 b=OVM2Nm4qweTtoHO/vFQXmYfbq5E0U0uTaY/iB5KP4ckVzCT28v641VwgtSfkIKYLezhPKw5WqA/5QAGSSePywQns9mC1hGsqfzpJhwYYAjj2smAcVZCy5M6YinAx0Ya2Dy0mJWFmxjHjvuYM/Yu3GCAI74qEqkBD+z9GnO+aiByOI4k4DWlha2slcHYbOITFW/4xbaVDOth+jo+TNPf7Tr81v74nEERdZdn/sbyYJW5N9nft4v2VsqI5y1FT/mqlqs/CsjQYxZvS15WtLQTUkfVLGfXVLmRhta0rG1r0PWAL6JE46PasfHcC5FEiu/K+f22jhpB04K2RUSDqg603nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42poRSSSZjU7ZDIoATOoyv6W5iD879/831zPKtREN28=;
 b=41FS75/KPaWpArDiiBZLd+PkK5YTj51RaEea0Jh+aEQv4jvZUJYowTYe+zvf8XC0K6jPS4oxFESWXPeY9eAjgYDT3j3N3AKcvj8wCtXznXggM4uumWQfbRVtfnUFCF881LUPRDb9T1PqrFf6xoO6ro+T0Ybw/4J4yY1eQkcvMlY=
Received: from CH2PR05CA0026.namprd05.prod.outlook.com (2603:10b6:610::39) by
 SA1PR12MB5637.namprd12.prod.outlook.com (2603:10b6:806:228::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:24:11 +0000
Received: from CH1PEPF0000AD83.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::df) by CH2PR05CA0026.outlook.office365.com
 (2603:10b6:610::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22 via Frontend
 Transport; Tue, 23 Apr 2024 16:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD83.mail.protection.outlook.com (10.167.244.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:24:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:24:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 24/22] [SQUASH] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Tue, 23 Apr 2024 11:21:39 -0500
Message-ID: <20240423162144.1780159-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423162144.1780159-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240423162144.1780159-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD83:EE_|SA1PR12MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e43b350-c4c4-4d9b-040e-08dc63b1cebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CClBPY/hTgsf3/TZ1EyxMIJJ65mWV0yWnXodD/weCP8SiKzFUmyns/Zs9Pnd?=
 =?us-ascii?Q?8QlRqugiHlst36tFTTadDsAZNlsJVUi3kjSx/ppeD8ybkx6GOWn8BWxYC96T?=
 =?us-ascii?Q?Ed3pQ2h5EN7oDcaVCwrMKt4eJXH6DJHqvD0yiOPdosXzm00Gf2vV+Rxkwa+J?=
 =?us-ascii?Q?RT1prB8O9HbPKpruwyPHcNGywDH1A2a4MRRnZQYCl4A+mLJhyOnQgdRBkCkk?=
 =?us-ascii?Q?4YGkI0PuH+gQT5G2szr/yxMtNmLYGNwy2Eq4SlGrvTbuK3RlfNa5J+yKPBpD?=
 =?us-ascii?Q?AkHxkSS4U2c3vdlA/29S/e+SF35Q1pmzbgreRxszIsaOLPjXZUhPH9UArWZ2?=
 =?us-ascii?Q?qFvAHOQLjOySFe4uCpi/QOLD8INHDZ0+fbNtqxtLUoVra4o0xTiB3OEx75AL?=
 =?us-ascii?Q?2XiS4CWVqI71E+NcHeOj6d+5wac9caecwm0xjdSAd/4cjdQ7CSur3tQxZ1Ol?=
 =?us-ascii?Q?D9B7L/xsNoWi70Jlt2pyAhZR0mMgdto7a7w8t8+YsLzoAxeVpA+99waPRZyR?=
 =?us-ascii?Q?h5YxXHzNHEvzM0gzJ45lEWHuDDqyaTSNEK4J2/lDRtnQt6jN34m0Kgvrb5HU?=
 =?us-ascii?Q?Gn5HG6h1XLVDX4osB67RXJLkvfp3QfH/pWQbO2XKSUbDYhXyB5N9WFiPtZ/N?=
 =?us-ascii?Q?h3hCguMSLKiAqRDkoXngY2GHpt4u1E5YZigdBbYCLS/bgtzD+Hl/LJ486FIH?=
 =?us-ascii?Q?VcpsfTJTkt+9gIu2o33YKML4qUUqRJdNUw6D7i/tWdl2M4kzpDN6aAdBXsqK?=
 =?us-ascii?Q?GAXQ+XTAbAc6PLh3cJGkXBeY4YVbJ513zeM7a9rY+PcrBXSuG1OpZyYxLF6Q?=
 =?us-ascii?Q?uaKWbj1pMATPObqskFTVZFhJ8FJHJzOs/NollXpKwdSUQU11QPv3q7rKOoii?=
 =?us-ascii?Q?JF8L4s+T+JlRyLgHjn1ihsvCFqvZyuPICKVmA26dLh0dKIJ2B5f/7iiCjE5m?=
 =?us-ascii?Q?y5Qjl3pRefmKHzowEQym9Bkd9HownqeHcVY4dIRwa+WpoVjUqOtRrqwTMmR9?=
 =?us-ascii?Q?C9prA1Jrly27ys6WX4Vu3BwHvmUt3u3121lyXMCUZDY4u1JKT94AM/D3dnQF?=
 =?us-ascii?Q?xN9Hzgswa3z/ev2vpH+MnB6v81U9eRj8vNDqdqFo6pjmFjqmNV/vRv4Ze8+T?=
 =?us-ascii?Q?Ts3GVq70NmmfCAhTI6IXvbk6YTAoI/0JCTW3n+g3/m9vUrcsEJUibMEsdzGu?=
 =?us-ascii?Q?/Hv2CrWv6f15qbUMQExlih71Dwg0m4QDD86sy1jGP66V+4NXKqyt5KUgU7K2?=
 =?us-ascii?Q?lHqm4J6hhEWt9U2EvLj0t1Pg/TKrcaR+MxdK075afJtyJkcqunG3vNC2trJZ?=
 =?us-ascii?Q?SvjkR+f2Tmo5Qum6ufmuGeRe+Cuep7qTwBWJQJbkZAIns+rjMzlBHWt4oH3G?=
 =?us-ascii?Q?YJHicjs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:24:10.7776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e43b350-c4c4-4d9b-040e-08dc63b1cebc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD83.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5637

Terminate if an non-SNP guest attempts to issue a Page State Change
GHCB request; this is only allowed for SNP.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 088eca85a6ac..0d8fbd5e25fe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3996,6 +3996,9 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		break;
 	}
 	case GHCB_MSR_PSC_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
 		ret = snp_begin_psc_msr(vcpu, control->ghcb_gpa);
 		break;
 	case GHCB_MSR_TERM_REQ: {
-- 
2.25.1


