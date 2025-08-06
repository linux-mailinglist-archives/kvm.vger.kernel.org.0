Return-Path: <kvm+bounces-54190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CD7B1CE08
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5084A565AE0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7787B227BB5;
	Wed,  6 Aug 2025 20:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JROWewBd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB57226D1D;
	Wed,  6 Aug 2025 20:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513180; cv=fail; b=jAMrSU15BvOmOQZ7V8MpcFFDjU41VzVtNIJybaVoMxl8r5KLBGc8B/1MxCFAP1w29dTJoPhnQ52pC7Bkj5RgNeUpfFg1kZImuILqhUvSYsPbZUWJw4HIusRszBlMW3G1UHZBJcahbYbBn9kllcLZr0H11XDW1b2WC63mutctBSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513180; c=relaxed/simple;
	bh=Wjj9M3gdvfZ1ICq+70+UKVEsVx2p3HGxca9z+OjVKUo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f0Fm/g92TG4oZ+PKhiAs7mDh9nRZboakeRsVx2uurxk7jGdf9Qo2SZqjZuJE02EXQoBCBh89ieHrrLzrAEePi1RxURcS61SXKEW7DukwQN5+lZ42o2LDbkkRm3mQlIqoZEXoRHR6dTun4ct9eL0fw6XEuP5xyLb5OEU0Tdv0pCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JROWewBd; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fZhBv8EYPiJIP8CrpddZtS5D1nFRvNbc9wAfpONN2c97LjXmeoBuXvehTwBmlvRacynMJ3cWdZ9WGWmByIDlBikhlMlAfMqiBSrL98DO9ZjVeejHL02IdbszW/EZwlyqSUIsK6iKahThkvwzJCflSyuIHlLV+2WSWhOFA/1J/ExWJ2EX0rDVZ2HtlnIn9wNY8vrcVJCFF1y4M4iSIfVVjJAI4nf0RAfLE7gzYumx8zdomWAZkS9oyd8Es7DxRHeKJwcl7blc3JKgK+iS98u5JE+Hrd71htACXwv3I52+7smMaXGKS3wEtCE570/zWYnldS+PxLGcxyPVhj2x6sFCNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pF9+jmtpIr/42f9a/vRqC+Gzt0ICAYjGvnGn98mZ1SU=;
 b=ct61gZYKWqaOJ+HDyTBAMn3kAlU6ixLJy1YzzapK4aGtrnz9EP3jhu/0Fh/nYDRGHYoHPMaAJiN3mFoCgJp9QaVIGq664NsyPdR9lOBU4Sqx5MetAUmRGIbrN+EhKvJIZfjpusARxDNG+3A2Z0nwBrY5Ns2z6cXgrWV+QulYG/BuLht+Olm6eFCnRUOSC2HEoEQ3uNhpmZtlPaM8j689FdI+JVquoD03UY9/XrquyqJSRgmBZap3BqXakM8JZPek6QlaCLguiutB2Km+6eVJ61/C8DXboyDHZ9qlVXIDAgd8VD89/a2DeWY0TwGRgb/e8VGRNiG52uoqtQYwcAut2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF9+jmtpIr/42f9a/vRqC+Gzt0ICAYjGvnGn98mZ1SU=;
 b=JROWewBdZLLTrV1eAUNiVS4sGGOSUrxSyKy7iJjhYXG9ywJudDtp69jRWv+iNr72TG9wpGnrfgR4nr1aA0zh81Rda0cUwPxexL2T6hgGyM0lZqK/C2roB2eLpjeO+61CcvMFgqc1O3bkoeI68AIQwyTrF7Pg5LJjtMyKKoJgLBk=
Received: from BL0PR05CA0021.namprd05.prod.outlook.com (2603:10b6:208:91::31)
 by DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Wed, 6 Aug 2025 20:46:16 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::27) by BL0PR05CA0021.outlook.office365.com
 (2603:10b6:208:91::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.5 via Frontend Transport; Wed, 6
 Aug 2025 20:46:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:46:13 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:46:12 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 3/5] KVM: x86: SVM: Pass through shadow stack MSRs
Date: Wed, 6 Aug 2025 20:45:08 +0000
Message-ID: <20250806204510.59083-4-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204510.59083-1-john.allen@amd.com>
References: <20250806204510.59083-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: f37b34b2-1544-43d0-ca48-08ddd52a487e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hl4K4P4Y9FUD7HpYMnqD8pktkTW1uTm/FXAWTHLbcxXbGJNolxtRcxIxzNHa?=
 =?us-ascii?Q?9vbAb3PNKWPqEUl2ZZ0Te21VGjYMRBzKt3NcwNjutD9geASa8C+13PMbyYpf?=
 =?us-ascii?Q?+2NWSFqDMhbY7nkJIyxtlFb7MEmonNzZD4QpDon6k8WPGMesHena0jnJJX87?=
 =?us-ascii?Q?6ykkZt1HD1OkZ1nSkx6hFxGhH6IQv1QqIyXTesL/ZsURqJe3fM/YINSAIlIU?=
 =?us-ascii?Q?7Jy9t7hK8kK/F3WoaJJojRwmR56sm00o+Cx9a4Jn1DTzNHHS7qz9RrKgmN13?=
 =?us-ascii?Q?maQS5VpwCqsd1Vg+7X6OGdQWdcZVDdecqhCa5wcYzheG4CVtDN3qH+A9uMIk?=
 =?us-ascii?Q?rZlBWZxYIS/I/B7bIHF1iKeh5ioUuiP5cwiAtEDt8Ma9qTvqcxndoaBQSuAr?=
 =?us-ascii?Q?aRIT0XfHSzYGrfq4HJ2qYXfRUXBy1oqiNM9Njp2P44vh2UK5BHITPpjKsM/V?=
 =?us-ascii?Q?sAQj6VnW3gcEa3L2fIs78X2Dj1lnlQUa6uVlSXpy/3HtoNS1L1zO1uoKuOII?=
 =?us-ascii?Q?FeK6EbLB8DaeSTkHIF2nk8gUSgSIBqvvQCYiqI19f6Iywm6s/4iiNYsYryzd?=
 =?us-ascii?Q?/TeHztu1SLYVaAXXGjcR7kGm88bkiXF0JnNA0wQfe2RxP9VcMc9vknYIypjT?=
 =?us-ascii?Q?yVfMG07NZgmap0hRm9ight0sQBWjlHLJvaF4KVdIBi+s8QQ9tS7dGJdN6ZZt?=
 =?us-ascii?Q?gFO2PX7VhQqH+ur7C39hWcd2bJzo4p+9Ku5PfdtvbGrqjnsbSm1frhYvfnW4?=
 =?us-ascii?Q?8IAqjE8B0vuGOXQHz79AR5+JJTr7x722eJbUVWwYIsDQ1BDo4dXxerI6aBfi?=
 =?us-ascii?Q?dcWzgbbMODbC2N9FARax58qAdX80h9EJhcOGnNHeq9ShvEifbQmqbRY0Y2nE?=
 =?us-ascii?Q?buYdV/rv7Qq5UZwVu/57ubMU7SViqQcKR086InH3tI2Mr7HT6AuCZj72AxSO?=
 =?us-ascii?Q?WB2huGvf3aRNxfQoGG3oqlUtL/cOHw0QY2cnAAEbibZCtUmxYK0Q8FYA3GtD?=
 =?us-ascii?Q?Z0qtk01Z31rTa1b/rFKk9Mdle2RWQSYaa4e5HfIQAgtbFV1oitaMgnbmuWnA?=
 =?us-ascii?Q?EQ/zHTwLZrPWyKesCksm7XWLiBiPJiLwFF0+wod5ywPcgyK28OgClhbfIpxY?=
 =?us-ascii?Q?wamebGTAzFTDCpZFS+Df236yVCyxhL6+mj3kHgQiM0McGGbVnXVFVLYtdDkr?=
 =?us-ascii?Q?FmmD2jjkDHrTQcWhrobi5i8VyxfLM2hbXkzfwuMcAMgPCs5oRyvdlYEt61kR?=
 =?us-ascii?Q?gMW4OWlFEtIjFWjm4MYRAzvRjYMYsyYTnQG6yvq4UrcHyThMCJYGz1EOcbfP?=
 =?us-ascii?Q?nliYfr/0DIrmry5mlUt7v8YOnh3AY7Fxf0yaTaMBwT3jEgj+qCsXUGn9bMOR?=
 =?us-ascii?Q?fxg0oUd9KVx+UpMGbAbIPM0eHwRhG4WkVgYKGirU7PAyYoAwNhaSyolz+h1Z?=
 =?us-ascii?Q?/wYweFETKyhpth6ffyAZiB/ERkRuQtAnN2pty8zomtv2XOKlOPsNQZSIh6gF?=
 =?us-ascii?Q?fGcYeUktRc1LYiKbMQNqW0WkX1ZjQwdJhCj9?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:46:13.7629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f37b34b2-1544-43d0-ca48-08ddd52a487e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962

If kvm supports shadow stack, pass through shadow stack MSRs to improve
guest performance.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a027d3c37181..82cde3578c96 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -838,6 +838,18 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW,
 				  guest_cpuid_is_intel_compatible(vcpu));
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		bool shstk_enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, !shstk_enabled);
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, !shstk_enabled);
+	}
+
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
-- 
2.34.1


