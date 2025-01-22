Return-Path: <kvm+bounces-36203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E63EA18943
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 02:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAA65188BB0B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 01:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD2E54648;
	Wed, 22 Jan 2025 01:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PrAU81Ql"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6130114A85;
	Wed, 22 Jan 2025 01:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737507657; cv=fail; b=FmbX49YCighjtaY0SoxnFEYYRTt0n2NMuKUA9Q8mIrWuTMGraoqAyJ5cp7rOvmb20m9sOYLEl/pzEwyK0wD0Rf2GLOfkqTpFcwpV5EwNgqIk9fIcyYyOU+AfvbGi5BJw6iGplQgGOxEBZ+jxiOM0QI4jUK3TTcVT6cEA41SjkFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737507657; c=relaxed/simple;
	bh=aXJoMg4LVxWH9beJKqOKPOelyJzXBk/BDGdCJBJoWDo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkKHdPtZhmzC4xvfV+YGbBblZ8yejrs+oDkhWLoVp6nO6NQeuqoEhe1u8Er52PBAko1ZL4M+4eDXZuGO2BkgpJi4GEN/lpcXpZqmvdWHXUnODZFMUpXjotdEZL35hTmo3KOF/WkiffWKIdTfTZiA05HXaQSb1GbFsLZmk100/V0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PrAU81Ql; arc=fail smtp.client-ip=40.107.95.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w++HAPGBmJrmT9yfJPxugbwv8iKRPh4iZ5RL/MRqmIU7WtR3OkYJv0Xn3B2SXfxQE/lU7z9uYS0QfybIj3MsMG5JD6W70PGMHF57qN9Jv30Nm0aqb/YMs1Izf9wY4E9P73G6t7N8Auv4vR2afyvxiLJqrEJUDyL5j19EVVe3ySQlT0uj4IRms2GxWf1+ZVsGlo7kHoTKGxqFhmupaszbcSCwaTbe7dOgH11T+30cwSbbyR1yuFT8qspFrFb//2OnsHoTuJZOSsY/iarr+IWe4qKEjUWy5Vot56ljCc4RFrBpFcraM+TjuoPx5cP6wr6y2czcVXp87x23zdNBHqRO9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0wzV9knh6WW7OSQtpVfYV6EQlap7kGjlSsXCKFxXH8=;
 b=IepSUIYgDxPqBVzBha7nVIT/oaK/y6IaHq/eUDeRZr//bqjs83p40bjGzVSA5hTTh+RJN1o8oPbcZ9YxW73dcbcyUVPdzlzDt5eWE2FXHiHXGjqwQDZAnhv9u/67PXD0UmBQ09H511ufnTU1Xf36PW+ROgnso2ey5vK4kDi5nTfPNxjnmgxU9sqEIn3BEefrnYR06Cyl13bmnjbl0Th+AqF2ZZ18ij/wsWAJDyXTTUseMgOQmOc5WExcytYYZviFwsBv5XVvm95BGlAOp/1VhP4qIq9jIJFXxc8eyuvEfbAb0pNCcyl/SwZOLwCE5aXk2ENq3FgE96fsXvKPH1pjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0wzV9knh6WW7OSQtpVfYV6EQlap7kGjlSsXCKFxXH8=;
 b=PrAU81QlKHYA7gWIgZzbMPHzeiiUeGcie/XrozA/K0wEA+5J5oed7o5StJkvC5nRSmE9NH0dFVPywl1bdeIyh9zxMLgcSf0PdjQhy7eacggsDTLSrdjvtnS27+rl0FVgbvA3U+Sq7OlyYkZpe0kjEIeiTmJdXKNnBTkJa3Io5qQ=
Received: from SJ0PR13CA0126.namprd13.prod.outlook.com (2603:10b6:a03:2c6::11)
 by PH0PR12MB8099.namprd12.prod.outlook.com (2603:10b6:510:29d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Wed, 22 Jan
 2025 01:00:52 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::da) by SJ0PR13CA0126.outlook.office365.com
 (2603:10b6:a03:2c6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.12 via Frontend Transport; Wed,
 22 Jan 2025 01:00:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 01:00:52 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 21 Jan
 2025 19:00:50 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<joro@8bytes.org>, <suravee.suthikulpanit@amd.com>, <will@kernel.org>,
	<robin.murphy@arm.com>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <vasant.hegde@amd.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<iommu@lists.linux.dev>
Subject: [PATCH 3/4] KVM: SVM: Ensure PSP module initialized before built-in KVM module
Date: Wed, 22 Jan 2025 01:00:40 +0000
Message-ID: <9aeb32dc2b7080c534e7894d35ee8ad88dcc2c6e.1737505394.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1737505394.git.ashish.kalra@amd.com>
References: <cover.1737505394.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|PH0PR12MB8099:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c27392a-130f-4c40-31f5-08dd3a8037c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GtMetmtGAupJ91TLQ1iBoRKfnFj2f8jyHCvObX4zneEENdhcj0KDFUF5rX+e?=
 =?us-ascii?Q?R+vvI+wTSG2Pd5STshWWzr0GFYcd9x/kcenR3/N9k1hSohoLtqsWYpegrDcD?=
 =?us-ascii?Q?a7MOWEtKQxUt9uXFzKRZUtZAeprhdGG5Y1K+X3zDnER7/LdlHigDQl9ADfo6?=
 =?us-ascii?Q?q79mKdNYsoYIDqF5oX8ofhYV5mvF6Laa3ryzSmuM+xmmmOfoI+pB4sbjirts?=
 =?us-ascii?Q?LIKeVJeFFd6np24sD18uyZAyvvEHxmUQf+DNV+lwUqtoUQCSrgUs0sj+lhHZ?=
 =?us-ascii?Q?8Sw65VYgCygGl+JzOgiJGRe2r3uf4WN5KPzBLAx5qNUHNakf0JuDI01C+dxb?=
 =?us-ascii?Q?fvPD9Tq1MhwyzDY6k5Qs+29Z52hqj9iSstU0HGlWb9qp/GRZdxIx8LN6IVYZ?=
 =?us-ascii?Q?xef8WjKVcZlIo+BpW7F0CfJHHtlQkMXqp/H/q8ONW1nmWHZondbl6UKQ4Xq6?=
 =?us-ascii?Q?lBu4ljzSx67QZ9sB0PFBicGD1rCNx6/oobDr5G0ESqRUcGrzJ5MDMoeB7TRn?=
 =?us-ascii?Q?R46ELwoVTd6ouGA36CFbpwlmJ366iZIUucXsPholWdwiHKMRgJkcjifcrRQL?=
 =?us-ascii?Q?EdnjGc4xxzJmKRKGJWLtCS00jM0jieeUendKLUYLPprliGAmiOEKQkPdWHaV?=
 =?us-ascii?Q?HMbHcj1SrMgjH9W7C01N42h5QpZCVfreHr+R4CklJLRzQQHFmloc1ckqiQQB?=
 =?us-ascii?Q?Ze6oo1dKiyoudB02dZcOVpK+Qg+LwR3HKEMheBosc+XBzveV7ROOyg4PoB6t?=
 =?us-ascii?Q?xl+aR8bY1VN2lJBPcCgGpBgj4ypuJ1JOaoIQqPF4IFn1ixXq+//ukFdjsznj?=
 =?us-ascii?Q?FQnOhN4n0Hn7aZ/33NMoF0Ko5xIamemPNRbThhb/ss+AG8s21Su4iSFf6qqN?=
 =?us-ascii?Q?H60sM/Ct8qeSiz0TgofVl1i1U7cj01BQSKu9QyGu/3iGtf7Qmdf8TmH3tpkk?=
 =?us-ascii?Q?4Dje8J/4XtcXLUx9vdZ4an8cq6AduwiMiLxM2mGULdK3dbL3fCBB6NvdLwzo?=
 =?us-ascii?Q?L2FtCXHHklsukmpBcv7xut1TlRaimQ0VoBjAdgQD5Jk8VJl9A4h7X/M6+9xd?=
 =?us-ascii?Q?DrdQDda/Z3FsJBHUJmqWCcvbD+oKBB9m3uJ0ny8Toj+8NSvi3eccRYXhbatO?=
 =?us-ascii?Q?WrVCL1uvILfa8exnuFGsiAhI2FMKE346VJCACDFThOCoVIwjzk9bn/znUkpo?=
 =?us-ascii?Q?8J5tZORhQ7Ql9l6qiDM+L41JeVsTgeDNIoNDO/ewW6tLnTK/6kZFwgib6XpS?=
 =?us-ascii?Q?rq1zlwSsnTKZ7O2pQEOJ+D8yz/9hJiG1YtjbNafb0ntNCEtAgpTjn10Fm2/q?=
 =?us-ascii?Q?GBfcU70JmNBEnkCmh48xQQRmK0poAHLgG7CtBmZDbeFTZfm3Nkp+LKiM2ZLK?=
 =?us-ascii?Q?fvKetMbZTyj4BcdcsVJYHJrzhx9AR9SMn08Wv9B3RoFr1wVQggp98NUxeVLb?=
 =?us-ascii?Q?4mBdVGtO8lxobvgMs5f83mXGMBdn3sJdhnnN6a9oN+oXspLj4W1aFd2ueHk9?=
 =?us-ascii?Q?3czbBqafpqOnM1QpIzz7cnGU++zDhihY8sWv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 01:00:52.0942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c27392a-130f-4c40-31f5-08dd3a8037c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8099

From: Sean Christopherson <seanjc@google.com>

The kernel's initcall infrastructure lacks the ability to express
dependencies between initcalls, where as the modules infrastructure
automatically handles dependencies via symbol loading. Ensure the
PSP SEV driver is initialized before proceeding in sev_hardware_setup()
if KVM is built-in as the dependency isn't handled by the initcall
infrastructure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5a13c5224942..de404d493759 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
 	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
 		goto out;
 
+	/*
+	 * The kernel's initcall infrastructure lacks the ability to express
+	 * dependencies between initcalls, where as the modules infrastructure
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


