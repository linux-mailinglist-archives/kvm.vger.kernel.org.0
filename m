Return-Path: <kvm+bounces-26811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E42977EA8
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D2E51F236A5
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125B11D88AA;
	Fri, 13 Sep 2024 11:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cmFo6HZf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80171BD4E4;
	Fri, 13 Sep 2024 11:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227688; cv=fail; b=vFDSLYeEiFwj00eHLdEqNoKWPc8soXkm/OUKB1TtQx1/DmIebhxNUbYj0SE7naxO/93zuWpdAeQLpb6bHSKJVfRK6xBu9xnZTBYvusrT2+qtYvKFmusKvBYhalcY99MgeC2PoF0ozfv8Ut0uZS8GdCLvI+mQN7n675/GhE1Maes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227688; c=relaxed/simple;
	bh=8Mcz+5leVEI+VilMdHvDbtI/tTJXdTDD4wJoOOMHwok=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=czLGDnlL2m/35k+EJCnjwqcEVO5+rOw09Ww6XStlNtvJk0CfIbHwiWWqHV5gN0/ie8Dm75703GkmdT2sw4UiSGF4HjP2HcVGfpfkXYO/fXwcni7N3jn9E0njB7n1E1rzSSoT1OJWqgczjeL5o81JnaVtnAlxvxWUJcYS+M8KXoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cmFo6HZf; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLKKhKz8aF/NBWFXqD5Lilt8BX73yhSiL6B3sgcVEW5Ls9UPULDINLF5E968htD8zD4pevFWXFuaEnAX+LJIApca3BPXOAbZ85Z2/KAcbjdWCI8UQ45+Bevq07EuFF6e0EBVXkhZu+2Mlnch9ffAVOKHKjASZgc8xBagh8vLKbA7uv9OXNS037SvNP2UnvDrNGldoQiMx3fqcABfLe1kXHUWhwm4SF9D9UGkfmmkK4xr0rIokjrFp6HtxgrOC5WvzrpBKe4ne85Z670xdeB/bFiBOEF+K1goUjNbh4611825QIKRitVq4YxtrxK15Wo6g/J8UGtI1i/GJNiZ7vYRAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMLJIL4pJ05aQB58YH5KPPKkwNNsYGwDxwQNaoUh6uw=;
 b=woyUvD1AoUaJFdh3FOI3VS5MmVbDwne2zQsU4Q23gYqOKHf5JWvnVNfVVNZcj4oGpgjcgrB+ljWRKQKwgucaVjqS0GA3ER+ejhxI7suECGWeU2gf5gQ9GmP3P+tlicFPTgcyLr17JfojZVkdFOOF9YxFnk5xAEKzKa3v4b1zWGOs5iPQ/XjA35pYvK/YmV0J4BAAVjRsliNH3QSSbYehtSUWY7KctgXqHSVjw1AIV4eO/EKbyChRjtkW82CpEalwsvNKa23JTW1B4n5ZNc/6Srh9qLg01LyB/DW7rtSy8CBcKOSv5w2RZ9Oerh794ElZqfPXl7smPE9RXz6Zb69jgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMLJIL4pJ05aQB58YH5KPPKkwNNsYGwDxwQNaoUh6uw=;
 b=cmFo6HZfIdlBD8ZAs9zDa8m6r+YMhByn1gGgHjDZ2697fKmt9+VIXkMETMefhYxFWTeNwUNScl7Q3UtYepK6iwRitk06vgQuKlNF183Kua2m/kUTxmWxPmpwewgMAr3g9i8fWzZJsXO/pHN+1Sc5zijc/JWCBwFCjiUQ0LFLHqs=
Received: from BN9PR03CA0692.namprd03.prod.outlook.com (2603:10b6:408:ef::7)
 by PH0PR12MB8006.namprd12.prod.outlook.com (2603:10b6:510:28d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Fri, 13 Sep
 2024 11:41:24 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:ef:cafe::f2) by BN9PR03CA0692.outlook.office365.com
 (2603:10b6:408:ef::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.26 via Frontend
 Transport; Fri, 13 Sep 2024 11:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:41:23 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:41:17 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 13/14] x86/apic: Enable Secure AVIC in Control MSR
Date: Fri, 13 Sep 2024 17:07:04 +0530
Message-ID: <20240913113705.419146-14-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|PH0PR12MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: 720f9802-26c0-444e-225a-08dcd3e8fe64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zliZrrBl/h9Otv9b4aYQUlyt2x0F9N9NpjUnwCiW7XmfUqX8kGxmIjOSd3Hl?=
 =?us-ascii?Q?tx8MuL1vhdA10WVimMh574omYu3lPm6N5FpwiqUrTMP9PJKVZ1aB7WKPGdp9?=
 =?us-ascii?Q?AKAws98yu02C5D0pNlyxEqD2anvgFQRkAW6NONe6xiTKFZDoDa3FG05blqJ3?=
 =?us-ascii?Q?F0kRihwKBL9EuI5ylcODne+WWwth2o9i04c5V34ffylC7aHyQYPD8/BNKtPH?=
 =?us-ascii?Q?0WT/JMWwYTYFMJfLNGrEikJ92KzBzpaMjikc/cS7NP5hgXHWE7RL2KtM5bB/?=
 =?us-ascii?Q?wKQbFQ6WndVbxLCtL5QoovbAHQqYIb+gDjZ3sEJZpx//t3h4TAoDTq0+cciJ?=
 =?us-ascii?Q?UJx6Y/BGkqlZCfmwFR/k0SZh2B48zonD+Fq1qsNwrE+FDMIyRY9kyOh7TWON?=
 =?us-ascii?Q?5hHBaq8PVJ9tDCSGjp8tl+hZ7AC4U5TSVfF4wgsAcgiNRZAH+UprazilrtcI?=
 =?us-ascii?Q?ihGyf5J9+y0PgR1Kw4U3fRp0ZaiatwUxpxf7w+Zdu3q6jKAJ+TaRzhu5Nh0t?=
 =?us-ascii?Q?G1V6FS22sTIokoppKUE3rPCsEshfapPn51NgZsp3Lv2DxpzI2O1bOyMSJQf8?=
 =?us-ascii?Q?H63KmVhJDdDMc+5Z7YL6VmKRoeQ7K9BFM5lGq31CjhZObuhLWLgFcKFpVYBs?=
 =?us-ascii?Q?Cw4s24K59BLlTfVzywPpny6M/alt+eT7P9kpMdj5wZrAO2hZAyJPI2y3q/v2?=
 =?us-ascii?Q?ZF26j7ZQVc5pev0LsfMVYF8CaKHnl3zSFayPX8ojfBKEe/QFqRUGVXgiTv9h?=
 =?us-ascii?Q?Cj1Af+r++jfGvOQaTxJSMEWB4nATGxJOJ2ZfKLZO5FqS6Ezsxbyz4ciin41O?=
 =?us-ascii?Q?qK5dtgZ7RVBENTiYBGM0pvDwizm73Rrj70qxmipOTx1vHAbb1+Zr87HF6bCl?=
 =?us-ascii?Q?QgJMCiZewZu8wo9FeR7N2c+r+LTbuAHEaJlJA3HQu01WpSMZZKogJDqwvddz?=
 =?us-ascii?Q?AtXqpS5dloelC4xk8jTOnezG3pfrX30T91DxZ3PZeIWnuwJQjHrFQVoHBafO?=
 =?us-ascii?Q?0Qnp7ZoxO5zpF40xc9yLxozovgfQaGYvaTrwvDmcUQTH2H0aFEN7p+nN673s?=
 =?us-ascii?Q?z3OiTNQr00y92bmf6004kKAKX/lManLGuu6M5djs26qYL33g6VN4y2Uk9gUO?=
 =?us-ascii?Q?F3O0dJU02ZtF9m29XZMQE0ig25Svu3wHZjIn4Y58GzorlFKHgyFKN0eTRtFl?=
 =?us-ascii?Q?GTb/0MOkKd2ooxScslQVmMCpTN9pwaH3ObQ+myaJBGp/dFisG26J0ts989ds?=
 =?us-ascii?Q?eBrH4k4AS8ANqySfECxR1uBsOOsDBjyuCX6XRx/4EjTSiX/8PdMxEXyYxZL4?=
 =?us-ascii?Q?P/epfwmFzrQkhS4WD/LlEmacjnSKaIF9nXAd3+5KpLKuxqooByVOjUp+1XbK?=
 =?us-ascii?Q?Q54diwylyJkbVhir+kaxgKW8WIPyxLNdp+b8P1sTjzEs1xwoO8RYUX7Pt+6i?=
 =?us-ascii?Q?nZUhigw4fmG2N7qzQz3ozTu2oRPuBLaV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:41:23.2835
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 720f9802-26c0-444e-225a-08dcd3e8fe64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8006

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
hypervisor before Secure AVIC is enabled in the Control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as #VC exception) operate
on guest APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 321b3678e26f..a3f0ddc6b5b6 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -406,7 +406,7 @@ static void x2apic_savic_setup(void)
 	ret = sev_notify_savic_gpa(gpa);
 	if (ret != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 	this_cpu_write(savic_setup_done, true);
 }
 
-- 
2.34.1


