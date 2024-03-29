Return-Path: <kvm+bounces-13137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AF418927AB
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D66F4284665
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E855113E8A2;
	Fri, 29 Mar 2024 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GOlB2zK8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8409E13E05E;
	Fri, 29 Mar 2024 23:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753672; cv=fail; b=nKDedZL5gKcsBjsrZ7323Gcc0NWlrapgEgvPAT/rS0dBziRzfZNQzy2469ldBB3n0JsDjrHRZHfqS3zzFsuTJqWGBbwjSb8iUkfJqvLvgQOBdy7YyzV36L+tjS7MayL56b2EJtD4jCMmFB5N4TkXDOAz2b3aX4vHFNlR/MHyfmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753672; c=relaxed/simple;
	bh=CVK22NP2eIpQVKE73iXlOJGbXwK28zJ/Xq8xUv6iYyw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZa32A8NlFicEYt1L4jxNMbbvtJaVzFI87kt6V0TQ7uHmAsU1ESp3Ahucp2VT4y15iPRVclyspRqw2ZWhmazgyxiK9Xnwq8u3BuxGvRnXFE7ZoLsDWQejYZAQqRN2Pl4Uzf4E5KRKX5AvMo6dPqCGwmELbEhNCFL89YFeXZiWwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GOlB2zK8; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKFCScsYK9S0ubdiieagc30QRTt0eFV8PICLiVkTI1O6UXtgy0Hyhl76V/cFdf2XjQah3HAQkQ/d+QCW6ufkzoUlTMw5w3aD/7ASCb6WBIEWKT2boCf9/jX783j88iQV8uicucXHfq5qf6znLD2pj6V7aNjTD0iYI0GveHkfGHVWfGDRbNxRO4MXDIMKYDoE+mJDtoaWWrwSlglUUowz03ZKDzNMGxJbojeq75Gr2Y08EpIVD2eVsD8fOZLyqlqJ9B9nf/HZr7xaKL+NWgktBfZW0LaH3319PPPSd6Z6EMCrQ7okd+cSdkE9SiT9nhDSGIIlmH9tzBrSZ5hlXC07+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nULZeef4xP2fEmjngUjUfqMs/tV1ZJj/0r9+cFnB/D0=;
 b=ICQEICe7fnxmv4W3wDd0cqF+QlFL/QvaDeTArLWci+KUuZ/hTfhaWqU42A76vjlQ06fUb5dh8Av0C3Cll6UldtRO2pP7yrxn1s9fcQ4o8AoqRvTu4qZCsygyj2KXPB/G4Aqxv0jx5jClxrCXJuQ/vcRqmTelQqaQZ4ETiKna0Jz67ORPaVtN2uVUqH5CY9F71gulakKygC+Enz8ZOEc0ES0iaw7xAJYpMrWkypZOI9IbSbMywR4EX+UiMJ4zsuDkTJDM+jWqpvcrV8ngfe/Sk05T0YHw72AdWpEeH4CeGjx8A/9HPyto3lxmloCRw0VXPRCCQWGM7LhG12uUYf1qpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nULZeef4xP2fEmjngUjUfqMs/tV1ZJj/0r9+cFnB/D0=;
 b=GOlB2zK8wdeCjuvMI71ggX3+/qkNo74jtlvhg3Mc7r4+R540S0CekmP0DLB+100tW66R1vsUsfWCXmFHTyH9LRwyRCiIt9iyQzhjVLrzu2q7E2KSaadqtCVS1ugX5TgNaSwSAN5wQd7TjVMmvEmyClEV9HwUKTLlNWCtiPjgWFo=
Received: from DM6PR02CA0163.namprd02.prod.outlook.com (2603:10b6:5:332::30)
 by LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 Mar
 2024 23:07:45 +0000
Received: from DS1PEPF00017093.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::c2) by DM6PR02CA0163.outlook.office365.com
 (2603:10b6:5:332::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:07:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017093.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:07:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:07:44 -0500
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
Subject: [PATCH v12 04/29] [TEMP] fixup! KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time
Date: Fri, 29 Mar 2024 17:58:10 -0500
Message-ID: <20240329225835.400662-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017093:EE_|LV2PR12MB5847:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f755c2-d34e-4f40-6b83-08dc50450b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E6gpnOHc/EaV3ZVSoJ+V83oX7DdQXZi/QNIi/vMg2aRWXsYHp4M+bajUH6UL9BQ+rJk9v4YlhZV3yyDbyCJulTvnR8BwVzzp2QIFc9XPR6SuUWPZk2Z5dqy2EZg1A1irBoc1gk8JreDLpIURwGyTD3XleefPxcDBwIXSxwsTcmgP4WLuZH4BUuf/rFbwIoGm2qhDBQGTQff15llobbU0wUjKa+whU+7xX1ginmHbowMrhRiG5SS3yuqkGQywzjAtjQ2YW1JAauVb37PxIMbSMuU1WJcjEoyQ3L/KCfj1djQvHIaHorc0soU8RwHdlVeW4jwRhQFaa3BJdpzh/md6/yPf4q432xFQcVGN3toBxqwQAD8bFAZrwyzCHkFFuCrREHH34NI/DJMicX6gmXwTZ9fF1jZjuBVHSFTl4xJ/DDv0X5QHTHZNE7xh9okEcDMfudlHD27QXVWj/DzyVhUudUt2ZDyDowUha6+O9s7p/92zmi1kKy8QVwNNcXz76q25WznbDrENJU2iMO0gMt3JRD220m8kuEkq69DElX5KVEingcDmZ0YWMd6AQGRbZDvXiz3Ydwu3Y3C5i1eap7GbbYPtI7vC87UgCDeszv7CAScs6rcHDbgg7kuacXqrtdG7F/Phtizltd1ZqMycRu63k3yzJafmu3oSJR3TabjIxRrp059c5k2PmSxdF7D1p18RqN6/cYqjqp1InTEqFfmHfSAzTbdWy/PV+hgUW31agt2+eG28WPFzrbYsHktK8dhk
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:07:45.4852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f755c2-d34e-4f40-6b83-08dc50450b7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017093.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847

From: Paolo Bonzini <pbonzini@redhat.com>

A small change to add EXPORT_SYMBOL_GPL, and especially to actually match
the format in which the processor expects x87 registers in the VMSA.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/fpu/xstate.c |  1 +
 arch/x86/kvm/svm/sev.c       | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 117e74c44e75..eeaf4ec9243d 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -990,6 +990,7 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 
 	return __raw_xsave_addr(xsave, xfeature_nr);
 }
+EXPORT_SYMBOL_GPL(get_xsave_addr);
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7b872f97a452..58019f1aefed 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -679,9 +679,17 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->x87_rip = xsave->i387.rip;
 
 	for (i = 0; i < 8; i++) {
-		d = save->fpreg_x87 + i * 10;
+		/*
+		 * The format of the x87 save area is totally undocumented,
+		 * and definitely not what you would expect.  It consists
+		 * of an 8*8 bytes area with bytes 0-7 and an 8*2 bytes area
+		 * with bytes 8-9 of each register.
+		 */
+		d = save->fpreg_x87 + i * 8;
 		s = ((u8 *)xsave->i387.st_space) + i * 16;
-		memcpy(d, s, 10);
+		memcpy(d, s, 8);
+		save->fpreg_x87[64 + i * 2] = s[8];
+		save->fpreg_x87[64 + i * 2 + 1] = s[9];
 	}
 	memcpy(save->fpreg_xmm, xsave->i387.xmm_space, 256);
 
-- 
2.25.1


