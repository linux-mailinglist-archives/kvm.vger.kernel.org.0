Return-Path: <kvm+bounces-51868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7F4AFDE79
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:45:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C76F3B5508
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DAC120C494;
	Wed,  9 Jul 2025 03:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5JXeQjRj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D151FAC37;
	Wed,  9 Jul 2025 03:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032623; cv=fail; b=ZCL38F6SHBACGRUYTYF3xj6Yrk8dEBfztlWqarzejYSXxOrlAXGv3cjxerfh/WzHyoJGYsU1OhbF07eXeLwhYwOK4w6jhPrK12z+uobnuvwf3HA8Ptl5zzQSColt/DsQJS39n7nXODCIi7KBYhyHEqKmfRkXqmhi+9dyH7Lq4+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032623; c=relaxed/simple;
	bh=s6OMQZ87PueDe1coDI8NLNHM/CPl8NraH6a9eHXlVXk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=od7B7THK99EubAZpXLc/swP1WAAseQNul7qcSVMmd7ofydM+M9HhnyYxCzShdJkAn/HyaKq+C+0EDTQgbnKcngrQUWa+lQa4hLF1fBxO9zFVPOsA4ezO4tzHuZzMPh98A0AkMcCPl3h/eOSWji0lluKGfV2H9qeHoMKwVJ2ETFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5JXeQjRj; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrSTIUJkZFGLIxN/was1Ql+Dbq+1vXA/N+3MUiiy+inunHNecHYj92t786XfXqpV1hQMx/UnerU1ImAhnMLWptIuliUMTLgbut1k84R1gEd53VU1aKlRjRL7fDOtZrhw0jTxbB3AReqYNV5/YWq17vxJ1MONt3wfIJzVwwmWxKECuk0GXMvaNgR5FADR9GMBiyXcC//7i6JcX40uZpDmtnyBhXMbySZMjS2RpEvDjVUP11aK694xyLANnFvxk8FykNFAze1Bb92AYAtBIVIjV2Yy1ttdKHvlyk+LdWFJFJmbQsSs1IcD7ZUb+jFYMBLjrmWFrsd2YLQ+PIx6KkxqVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMsj+dHhVuj0gOzk5NPK+zuwzdD9k9HxlS0SBwMuNxk=;
 b=DO5ZA4d9ZW1tLu20ov6IKgAdYJP5PXpQZMxgAcbQlphl1ARj/u6Pj3x9JyYAn59JjfWaT7suUOnAMdur0yKyvZxhDRaNWsWmtHtPh+jcs+R8X5t6BXH7O/ld8ABZyXxKavnBqx8QY6Zqz0i+ccW/Ix7lOv2eywU/N1cpEr5gE6YH1FYDfhfEojkr7csA54W9lFtar8ZUBqGNarPGujyW6W0Xu8fJ1a/L1pPdX7x64FoeoprXPW303yKm2SSANcxEJVi4VjvDMO0AEE8QQ8KMVPWWgB1wlKM3i99RuKdaTwq2E2FlGwTaPxaLG5yAIyfi2YjSEQyT1+qrbessmdas2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMsj+dHhVuj0gOzk5NPK+zuwzdD9k9HxlS0SBwMuNxk=;
 b=5JXeQjRjdaFu/Xq52ZeuNyAmoqblHHBOSKZ/tvkXIPJ03zADQZ0YM+8R4jlcQP2yFIWOs3X8wozAzYmM9Zw+3XdzHtC1Wzz7wGOTGKwNYWd8QVAPYh0b6u43yVfPsaYX0FWHtIkQGgtzqR0sDvVlZ+BSftPH0fPE0SOPTv67m7E=
Received: from PH7PR17CA0057.namprd17.prod.outlook.com (2603:10b6:510:325::6)
 by DM4PR12MB6010.namprd12.prod.outlook.com (2603:10b6:8:6a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.24; Wed, 9 Jul 2025 03:43:38 +0000
Received: from CO1PEPF000044F8.namprd21.prod.outlook.com
 (2603:10b6:510:325:cafe::46) by PH7PR17CA0057.outlook.office365.com
 (2603:10b6:510:325::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:43:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8943.1 via Frontend Transport; Wed, 9 Jul 2025 03:43:37 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:43:31 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 34/35] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Wed, 9 Jul 2025 09:02:41 +0530
Message-ID: <20250709033242.267892-35-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F8:EE_|DM4PR12MB6010:EE_
X-MS-Office365-Filtering-Correlation-Id: 237da78b-5c8d-4bdc-ee57-08ddbe9ac9b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AKFBFWIfaU/8x/Aud+BgSZrii1EopfOl/+YuqKLat1lWc6HBzYOnoxFo8sU+?=
 =?us-ascii?Q?V4WnU3O6dkRBKyiyAP783iN/uQP2mUk/vIl3qHx4925jpPN2KZEvnnvpQXJl?=
 =?us-ascii?Q?HcmCxSFXMoOPUVxToVHOLUpXxib5S3LPdZObC10ljpVM+JWE+YiqNtYWhSWv?=
 =?us-ascii?Q?fHhYEvsP2hoOsfi6U4v04bZpYLp6ynYKuqJpWMuB60d35vOLlTncEsyfeXU6?=
 =?us-ascii?Q?spy7tjTpQ+IcMg/ujGoXS9eU9lMAVTRjLqPK+lqVTCxVBSZvUkFnBLOc6QtK?=
 =?us-ascii?Q?34lmC99gR1nDivWrHzI2Mvg1mTw0pjqHIMnboVaGjoUOuN7MHfWyvAQ4Bybc?=
 =?us-ascii?Q?JrzyI9yn2ok9/omApt0CHwJCbtGhvNM13usE6dUIJh2cSpnp8ES9jQPUijUe?=
 =?us-ascii?Q?pqE9DoCS7IWE9hAdv1pty9ekmkoMZlhvCqE9hJkkSJw8LW9yk/f7XpjnKAVn?=
 =?us-ascii?Q?hZpWtZSJojCZG9c8Gk8aruHZn+irCThnpReyCfERgz6Du0wPMa16Hpml2hAm?=
 =?us-ascii?Q?kuv9SksPGvzGzbvwB1KaK6wtoAN/42v+pJ4MuYdrf3qB68/r57Qt29cZVYcP?=
 =?us-ascii?Q?Ox5LZ4QbXynC2hrqz+hoT6PuxaxaXFIBQZ5vOlDxDV+RAi6jtpZx27Kf6xIK?=
 =?us-ascii?Q?wVRJ4qMayK3RjU7E1MBhwwJ0meLStsMy2PeSKBFaLkQ6XEnFmkVKD/UYnPd+?=
 =?us-ascii?Q?IzPBPI08fINEOZ+TVqsrpqWLuFln+kF8SMwJ+G5Hfs68ZY0FmAHB6cWMQKmZ?=
 =?us-ascii?Q?ZtEdzOkMxpR7KrntuG1D+FrYO8O4WSd2RxHSZ4/k/00UEREugUiFyqV3kZd+?=
 =?us-ascii?Q?QnAnLGHYeNvBlq06FFIzbujkCzWEf9zeW4cKYaA6NSrV26WLzRr6RXg0p5yo?=
 =?us-ascii?Q?yhHnbzaPMWBgVzYFsJ6e9JNX671j3HQT0tCrrvq/yhbuJfvypUyAKRzg/eb4?=
 =?us-ascii?Q?0PZOOyNB47LKybYlkpfJWaaKZXj2QZBXmfgW24rtigAvmyZv2Lm/TY3o6T5Y?=
 =?us-ascii?Q?HKLz8/AqijgPJKChRmrnFeItap7Qj84v8jFov7/XY6luM8B4P6QpjismxOtE?=
 =?us-ascii?Q?LuaMU3zJSxbY4AhyAsg560WrUH5j7KZxgwpJBc+R/eITbf8YsfS0u31OvxVB?=
 =?us-ascii?Q?eu1hvivFQ41+CUTJ+wKxuQikwXoD3OuYLSyXrithzfRQyMyBzteSxZkhZpOd?=
 =?us-ascii?Q?qFOQxT5c1XAPjgnLNyqW65jlv/iqzJDLY1Tez4r4r8gAMZKkTMIzKKvi05oZ?=
 =?us-ascii?Q?bsWf5lQUbb1GQp7H6kuoWzYBUsjhDq5cJJYNdJnr+qvWbzoZvVZZKXOerC+J?=
 =?us-ascii?Q?looLLvqWF7oKphV2LtkRPJYS5+6B/aQAkVKElpgl0+2uTb0ZXvP9nvv8lhSn?=
 =?us-ascii?Q?woATQAGRYm7dtiSHDnD3Vv9V5VNEwmgAFcYTjdiHfmNyqHKrM3dQ709EJv7Q?=
 =?us-ascii?Q?H5MGPjboCB4SQCyiPnqbgfRAUnooNRvFvZcCCiQWB4heY2o39QZ1NwwrRCcu?=
 =?us-ascii?Q?gtFShapynRklhbTnpZn1h51ZNUKaPDW1hDUv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:43:37.3722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 237da78b-5c8d-4bdc-ee57-08ddbe9ac9b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6010

The SECURE_AVIC_CONTROL MSR holds the GPA of the guest APIC backing
page and bitfields to control enablement of Secure AVIC and NMI by
guest vCPUs. This MSR is populated by the guest and the hypervisor
should not intercept it. A #VC exception will be generated otherwise.
If this occurs and Secure AVIC is enabled, terminate guest execution.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/coco/sev/vc-handle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index fc770cc9117d..e856a5e18670 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -414,6 +414,15 @@ enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
 			return __vc_handle_secure_tsc_msrs(regs, write);
 		break;
+	case MSR_AMD64_SECURE_AVIC_CONTROL:
+		/*
+		 * AMD64_SECURE_AVIC_CONTROL should not be intercepted when
+		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
+		 * if the interception is enabled.
+		 */
+		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+			return ES_VMM_ERROR;
+		break;
 	default:
 		break;
 	}
-- 
2.34.1


