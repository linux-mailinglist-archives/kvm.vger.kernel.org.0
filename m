Return-Path: <kvm+bounces-29238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 246929A5A14
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87316B22EB3
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78861CF5F0;
	Mon, 21 Oct 2024 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pMXdZeS6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186E8194A48;
	Mon, 21 Oct 2024 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490404; cv=fail; b=JS2y3FsoHXSM3IV0YFMPUtvNuINOIkiPadfQz0cbdziKh3Rte0eMCHA3UxXeDcVxziIS/HpTabSUFfCWhIO5ck54MZ409EWpjivKWTt8BLWHCpc/B73mH1mnwvVeDGFWqEfXbqguSJnVvHBvgCoNEXF1KmM3EV75llRZe03jDjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490404; c=relaxed/simple;
	bh=LRHQk2Qx/4F/Bb8BcSegTkEUfw3LpQDzDufMJPVRdAo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iU76fG+LlDgDkZXL21v/W7LZ94M19q5wXogAzWy4dsYY7j/ba20Ihd1Nsg4i7S0HWmhaWPqm4+1gv3oCtbslNa27eXsWKi2TGx8bLwmFKuyR4s84kHzX288kIkOzIT/PAkpmK+KwHuGVI/JTak+GshAbDZTRTGMGyg2ZGJk5CGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pMXdZeS6; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=It1pJqB/2jHRSxrJGfHjoAxH1pHFwsu2TwslPyco1Zs3HCmukkBwdhXA3U81HbmRZUuHBpw+11do46WYXW0LGZ3e8iKrIHr1YbLwwMPDu/KwZz+Mnr/jReBvXmNHEIjvWtogvsdZfAcUkRKHnMn1sAIDItm3sqmQyV0+H1D5GLEOXwsw3Fn0IO9irZt3XWs9DE41iLnzsVLerG4GlPyVeGaM1LyNYd99/5W8JmcIp0H4b6I+Hk3/GEb9qJmBpViV6jI+dFxsvV/g8B7BIPxjX7oFNKU4rYPDT5YeRIs2sC6Yksqgkh00L6Brp9GTaKf1jxs88KEZltr41cF5UPTDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJK1UfhW3p6Z22Px+Sqhezp3ZtdI/hz4RmkfZkf+C3c=;
 b=ENinbjk0SkVgrrrtRVBSBPZmeWG3uwP7Fq2n0nzPzVTBbIFM/wL2nsPV2KBFs5QPdpKicq378uwAyohopucmGE8TVdwMQG5XenqikWdxIFNTnQOvucJR2CTU+Df1Y+8iDMFhoe1Mdv3cMJFW4KJ89XHC7J+U8ZApOzk4zp2gad6FL20O8DOriEjJdKUA8VPEmEN6vmjz+1/9MVOFIcfJG5Fl84ZNiizneG3BEP+qNZ3i6IZA/Ifi1c5F/oOt6uoe/7FjhqMFCl6IMna0P2hiwWNW5gujq0Wry4BUdnquljDbs7nlyFHO8oVNZEhMAk//akBYAnD3FtYpWdO/qu2XjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJK1UfhW3p6Z22Px+Sqhezp3ZtdI/hz4RmkfZkf+C3c=;
 b=pMXdZeS6YIBJ+RasvzHFMjxIWzv0BaMVR5dTYXxYZCpOe+j2GRzWpDu89xYnqZL1cn1KSjEdwqJaACooME0HXfvPaT+uC1igd0YaAxnfGMc5/KIvKDtw+Otz1OLOwVjhm4WjgZPCnG+sq8viNJCm8dNnVFpVUOcH6Ib4ngsYp3E=
Received: from BYAPR03CA0004.namprd03.prod.outlook.com (2603:10b6:a02:a8::17)
 by IA1PR12MB8587.namprd12.prod.outlook.com (2603:10b6:208:450::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 05:59:57 +0000
Received: from SJ5PEPF000001D7.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::2a) by BYAPR03CA0004.outlook.office365.com
 (2603:10b6:a02:a8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29 via Frontend
 Transport; Mon, 21 Oct 2024 05:59:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D7.mail.protection.outlook.com (10.167.242.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:59:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:59:30 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 12/13] x86/kvmclock: Abort SecureTSC enabled guest when kvmclock is selected
Date: Mon, 21 Oct 2024 11:21:55 +0530
Message-ID: <20241021055156.2342564-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D7:EE_|IA1PR12MB8587:EE_
X-MS-Office365-Filtering-Correlation-Id: 359670f3-35df-475c-3d01-08dcf1959795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bq9pJA1z9MkMRE03pRFfy76uaJ8aA2qV6eYs03yweHOT0pTEUXJiPqxRLuIG?=
 =?us-ascii?Q?kb9T3TbJyTy+k1kGre/srvJgEwCOueiLGdlXTJAjXE9L9WNxEyFwHtJ+5RHK?=
 =?us-ascii?Q?yUOA396MCM/gOgOnnwuWDoDuO4/LMfL25noraprM0xQA+aPlMtaBX1wq+90c?=
 =?us-ascii?Q?s3idrpFpIGlGpW0nPHMIR4ktHQhULEtrt1Vaa2SQkvo3+k79enqA1Eg6Gzcc?=
 =?us-ascii?Q?uhTVe79c7k0BRpo0XpaRvwpPCJNvc1RNZiUtXeg1wYU+8GQ+bwhRwctFJSWC?=
 =?us-ascii?Q?VW6OkIwC3iXz75oYLydomq6AuZj+/xcEItsuCeqPJd2zHyHCTdQWIlA/fBAO?=
 =?us-ascii?Q?t53XBmux1W8A5xvXrNj/Bz3jW6SIYGc8cYV9a2+MKy/IVmWR7YBkKdHugTUt?=
 =?us-ascii?Q?uiw8MIKQYAQzJNPghAxt3FOChvbUSWnCnHY6htDhiTZMpTGtV8hfgZe2KxTf?=
 =?us-ascii?Q?4rDi542DnuTjNgXSSz1NthYaul3KbM4oGhtQYwRq2BC43cY+uumhw10znmnL?=
 =?us-ascii?Q?P3x/YynZKKRf0p7jy4Tyt6HB/0vdOFc3Hca5ixzPfXiaf0oI5o31losP+iSV?=
 =?us-ascii?Q?2jRIdasJxoX3+0BT5W8gkO/agwyyO5zeW/xQ1uUrdgNHKT3vtge0QOcEqBPA?=
 =?us-ascii?Q?ETWCUEk9mnHR0AYxVi9BTvWcD4fNcy3SKaZher3FEyeUEb/VMu0mqgPaU59P?=
 =?us-ascii?Q?wuE5meeb15p70r8x6hbk44RhZen85beEVcJX+7Um65ABCuMBpFMQwqty9Peg?=
 =?us-ascii?Q?6csrwO1waAgs0gRtS21dL8epR8GrdpLFq8i/E3m6//RJO5KlOzc4aI2qWCH6?=
 =?us-ascii?Q?saMaz4Dun67SXemfoL6+PBpCqerHP6genAcAEyYBVQHV0wHCrOo1gM82WEWl?=
 =?us-ascii?Q?29gqjYlulXZo/JAgJcCX3Pjysn3b8IjG+iE9z+CHhnSdz7bI2gdUfHKiHMXn?=
 =?us-ascii?Q?2ns3Q9YdveYf9Fmg0QrF+ZdAgMv6PHd3KXWYrl56USUO0UbDfCcEexkYMg3J?=
 =?us-ascii?Q?qwe++arrmFGgzg7pPTYZmFsLfhYPHQP1+v9NCFdK6VBCTf8dFfv8lQnfkfHa?=
 =?us-ascii?Q?/gg5r3IvKPPzbK7qsDm8k+nE8WySfD9Wb6lPpp8R+XqzFyeRKYF3DDsWMTmC?=
 =?us-ascii?Q?yV0R+vWDNsWO2Pm80GvgulP5CI+PZjRuxySbn3omvOoZwoLlILQERe/vyveP?=
 =?us-ascii?Q?SoJKRQEp/3IJKfm2BvotunDMIEOVBmOocCCl78zeESrwaqv6pjueQwyJVcV+?=
 =?us-ascii?Q?O3/7/G13HfCw+o7SKMV73Eh33Z/6/nGn/RC7eZ6snli4Vq/JkBRpl7jvj/TH?=
 =?us-ascii?Q?xLLrh2Gm70YwLpSvJMh0isC/z/RmkSI18gvlIhSGjIw01xiMaYf5jnvyrKE4?=
 =?us-ascii?Q?LUvi+CoUxNP+oClku1TO9L7qVxQsZn9PoOr+mjyFrhZj/X8uwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:59:57.3922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 359670f3-35df-475c-3d01-08dcf1959795
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8587

SecureTSC enabled guests should use TSC as the only clock source, terminate
the guest with appropriate code when clock source switches to hypervisor
controlled kvmclock.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev-common.h | 1 +
 arch/x86/include/asm/sev.h        | 2 ++
 arch/x86/coco/sev/shared.c        | 3 +--
 arch/x86/kernel/kvmclock.c        | 9 +++++++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 6ef92432a5ce..ad0743800b0e 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -207,6 +207,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
 #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
 #define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
+#define GHCB_TERM_SECURE_TSC_KVMCLOCK	11	/* KVM clock selected instead of Secure TSC */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 34f7b9fc363b..783dc57f73c3 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -537,6 +537,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 
 void __init snp_secure_tsc_prepare(void);
 void __init securetsc_init(void);
+void __noreturn sev_es_terminate(unsigned int set, unsigned int reason);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -586,6 +587,7 @@ static inline int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code
 
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init securetsc_init(void) { }
+static inline void sev_es_terminate(unsigned int set, unsigned int reason) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
index c2a9e2ada659..d202790e1385 100644
--- a/arch/x86/coco/sev/shared.c
+++ b/arch/x86/coco/sev/shared.c
@@ -117,8 +117,7 @@ static bool __init sev_es_check_cpu_features(void)
 	return true;
 }
 
-static void __head __noreturn
-sev_es_terminate(unsigned int set, unsigned int reason)
+void __head __noreturn sev_es_terminate(unsigned int set, unsigned int reason)
 {
 	u64 val = GHCB_MSR_TERM_REQ;
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..b135044f3c7b 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -21,6 +21,7 @@
 #include <asm/hypervisor.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
+#include <asm/sev.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -150,6 +151,14 @@ bool kvm_check_and_clear_guest_paused(void)
 
 static int kvm_cs_enable(struct clocksource *cs)
 {
+	/*
+	 * For a guest with SecureTSC enabled, the TSC should be the only clock
+	 * source. Abort the guest when kvmclock is selected as the clock
+	 * source.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);
+
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
 	return 0;
 }
-- 
2.34.1


