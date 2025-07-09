Return-Path: <kvm+bounces-51860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 560A5AFDE66
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B5A2586D55
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3D321CC71;
	Wed,  9 Jul 2025 03:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q39/Ty54"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2057.outbound.protection.outlook.com [40.107.212.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEB81FBEA2;
	Wed,  9 Jul 2025 03:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032470; cv=fail; b=UklEEQLvU+9IhmCPoWeAGtO2Y0uTmtepb1ArXqjzLC+eU4V6i/xi3ebnWbfObK1/gsAoOEZTZ6lVfSCJfxxLyRDz0QT3gb8N2Nv/+ay7541HLPVGZKSkxSzaqoHofMlAkrCM5UBw2tpKzj/wfypurWzS07JWJKTK95Dqms1p48Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032470; c=relaxed/simple;
	bh=YKqCNJtUPUCRQPghf++q4TztWjTSpk5Ux4Wtp2lrjWY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etTLz14Gg+0PGcdDMYbpHKPK6BDNgnEZyyiamY70HlO658cY9vC41izgHZ97ZS/wdDmxPBV5Tygn0E9yxThigB34xGuMNbknxFTuk01VwwzWNv7uOXHhH9BuaK3/fOszkNKnCqzKaqzxoo7sLtjRHAIqlQOVqvPXMPyqx9XNUfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q39/Ty54; arc=fail smtp.client-ip=40.107.212.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gFXfGK8ImSpZwbRmbJcEhR66FaAq9HDk4GraPGZ/3uYzJKwG+fI8VgGl06cM2ywuC8Jcgw12KGRbK4Nu2OA1pfNvuUVkAvZqFF7BtS846Ft2bFpUWrNJNjwSx8KSvNTWCN2pn60J7T0S+hjPJsIn+G1MPvU0xC5lUDTrKoWb4yT58sxzrnoBOWFgVtLAHy43LF543qZxRM5YIolw29LHK2DURa8jXNozE6syAtXLfipB2XLgfV0AdYOuxe0cejyHzlwqXtnyqcywoH1mTPe2oD8AMq5euNZ7heKRdYGiAkb8BGO+IXftRgiLP+4ikXekwj9DlpUpMDmhK4sae8dfmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLFDhesuVmXZOzP5aiZ8KF0Jxhvg8fL+4aCGZhwgzmI=;
 b=J/SBzGKiXOtY1Mo1JPyTbjpOGwBEul9qsZsAlPJ/ir7w2LzYffYBkgh2x5co94yZeWMa91rhnOX1aBxO00hK15swT/e8KyL0MRaFaz6pvs+O57/w9B0OK7ZmU/27OD7igu0+FPH2j5kGz4BHF6eu8sVwUSjnzFv4izFTNokLWLMX0J5Tz46r014bi4WhERu/bC/cBiuUPlu197V8Llp/ILkC9+7EOBvd07Pa10g+yyfzqjUCeQY9mDbzmkWhYxQ5SlmG11oe1aUttX0gldKlIO1jIZXEH3fLM6OenS0mN94x5/wDcYA/9A+L1qc+j/+kc1h41hX2TJY0TyBfWLWByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLFDhesuVmXZOzP5aiZ8KF0Jxhvg8fL+4aCGZhwgzmI=;
 b=Q39/Ty54ErKkgWorzHn0x+CXV/YUHaQo3Q4djVWFAoPFSVUbWJFiLhaZ6iDis9iFgLg8VGRueH1Mz6MZq2j6zgl7iFme9URHN7jzxvVu1J2UIBmYpYSE2vKY4guxbPfOCJDyZQhbv4s7M6AbExaRJ+6YMJTfQezVbdSs+x4PdVI=
Received: from BN0PR08CA0010.namprd08.prod.outlook.com (2603:10b6:408:142::11)
 by DS4PR12MB9793.namprd12.prod.outlook.com (2603:10b6:8:2a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:41:05 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::62) by BN0PR08CA0010.outlook.office365.com
 (2603:10b6:408:142::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 03:41:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:41:05 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:40:58 -0500
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
Subject: [RFC PATCH v8 26/35] x86/sev: Initialize VGIF for secondary VCPUs for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:33 +0530
Message-ID: <20250709033242.267892-27-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|DS4PR12MB9793:EE_
X-MS-Office365-Filtering-Correlation-Id: ad52df39-8a96-4e65-b55e-08ddbe9a6eea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?POqEQNId+Hc7m34u4iFNWRl6N/DjLVEtKZcQUE+pRD6EZdfomlFT9DW1adiv?=
 =?us-ascii?Q?41Z/siyak6XoAhAXMMAa3at6U6DDYyULfxbet8mf3N8S0L5q4HCePdNUAUta?=
 =?us-ascii?Q?Z7kQQdiGp2Fu+vX/fGADWQzfxnzisS5wgO36lOEP38IhHAYcMLSgaySsKCxu?=
 =?us-ascii?Q?sblADj2wYs52mmdCCD96JfUDb3hKdYcC4bJpy105W5whmsLathCODM7ZXTMa?=
 =?us-ascii?Q?Sb2NvDJ8v6W7jrv8i+XpoMsNZDwTje6hNlg+LEB8Sp7zzTJaSPQWlIiLxYN+?=
 =?us-ascii?Q?ZwKlTLr3U/Im6QtYn9LkZfBqqKHd1kOAkz/R6oYhpKJgEpu1LhKPhDf8pFMh?=
 =?us-ascii?Q?f+l1Oyc/WP12eAZjXpwEoWLL7Y0TatH5nV7oVwsd+HpSwBLZddtFwzQtEyQi?=
 =?us-ascii?Q?YWmNGbUEh+3GcFx8dYZEJcqxY7EpSbt/+uCu0x/kUnSfcoA0dI/RnN4xKPqv?=
 =?us-ascii?Q?U2Z1wStqp9sxjJ5btj2E1VH6KC5cUe+xQ3YpflDpWKf0YMHnc/plX0DAtmC/?=
 =?us-ascii?Q?00cNZ61+IyaX+Rm8Fzy2dS24QAekWe0EbboYj6dLxb3tZtwUt0T1nHDCNwh8?=
 =?us-ascii?Q?kaPXw5cDLWL2WLc5K1ZM3mjLqsxmiYv9VWUgJyknt9bYRZgJ4OotzaJF5OXu?=
 =?us-ascii?Q?jYvHXHplZYT/yLUJwWzfMWkR4qJDT+WROwu2I6/7Bo/LSUuIo74apqUxEt2g?=
 =?us-ascii?Q?LwELnbTlhLkn28/P1XWmNVOh7L8SnBH7QOEo4CvuSlrnXIgVHtzKgCi8rj6z?=
 =?us-ascii?Q?rYYFq5nMs6vEiYz3R6vDjT93frhI1xFRJPfSTaqqOMsIPzaX3B1akXI8e3Lx?=
 =?us-ascii?Q?Mt2t+7hhyRjQy/X6IsQyB1KkuDduW9Y4R0V9i8SsqgB67IHb/UuI5VRKYVru?=
 =?us-ascii?Q?N3yjVEBfLom3gtBD8RCYHiBgOK+mGMEdj6QHRlSohpZz49Rbcg/Pih4M6w4m?=
 =?us-ascii?Q?IVKOJf0eTyTgZcrExZluzeqfqgeIVzwMMmtBo6gqs19Zj1Mys+xUn8tiHpBS?=
 =?us-ascii?Q?iecN5xkwbN5kP+B31FSV6wbtbs6TI+WVJFhgfS5FZMAWMxG23N1C6dN2CqSG?=
 =?us-ascii?Q?JIg9r1fg6JCsfqCPOh7wTgLxsozumhKQNrCsf35cRl0jlIPiXTnbhQ9ArMJS?=
 =?us-ascii?Q?H2QlJ1tdRIA7S1I+RkV7JpN2QWHfA6htWrcPyggqN4SiqSwqDADBIK187uV+?=
 =?us-ascii?Q?KJLl9CBa2xfFeuP5VZheZ+uyl936/JtOkaOHkHT2LO5rVX2Vg+eSuNRumtlE?=
 =?us-ascii?Q?tGiK0QvOmxW6NGgASoea7GRTHQEqpLbsm1XrwNS5qBWpO7aNQE587y/fOtr0?=
 =?us-ascii?Q?kOTG2iTTsGQ5ciz1NtL2Tq9cSYhCDvsj4nB3MqvdiFFoOvyTYHWySzk58Aft?=
 =?us-ascii?Q?slN9USPjgVIPvQRk/lPW5K2gndAkV56x9NlZHbgKxplHznfEVjgcWKho1UHM?=
 =?us-ascii?Q?+YuI+I0Ka60sVhcT5HVwRw/JBUPZvqEou0KXDmZ2xkR4XdSwPlRoV8ERrOp3?=
 =?us-ascii?Q?LGBSqWPC3xlMsXtCuFUXedMvEHFCEL2W9fYh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:41:05.1159
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad52df39-8a96-4e65-b55e-08ddbe9a6eea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9793

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires VGIF to be configured in VMSA. Configure
for secondary CPUs (the configuration for boot CPU is done by
the hypervisor).

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/coco/sev/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 3f64ed6bd1e6..e341d6239326 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -951,6 +951,9 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_ftw		= AP_INIT_X87_FTW_DEFAULT;
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
+	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+		vmsa->vintr_ctrl	|= V_GIF_MASK;
+
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
 
-- 
2.34.1


