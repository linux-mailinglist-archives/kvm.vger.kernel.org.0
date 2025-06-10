Return-Path: <kvm+bounces-48847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B84CAAD41A1
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57D493A4271
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C120E2459D0;
	Tue, 10 Jun 2025 18:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D+IvDQ69"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923791F1527;
	Tue, 10 Jun 2025 18:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578776; cv=fail; b=i82iAIq+qE7HyM6YNHkEBDpjdCkn1cvNPchfup8vzoUFOYIWlZ9jcudv3gqmuj6YZCsq3he042XGbK+3XRlQWYDYunofAcLfusQm29KQ2dGbe/YxMFV9Je2+Gm2hU0uHqtmcGXlnFR0SSLfReZ7k1KSPy15bmLJCqsRpTJA2OMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578776; c=relaxed/simple;
	bh=2vCOVnrJgYzjHjr6QiCaWCYUG1YTrkxia9n8E7KBgf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ne4AQc24uw9hoFGM8pxKXiCEbN/4hKnmwyLMmgBIjf+UiamIGzU29DqgC05nFAVn/I2j4wxLowyJiWInjDvEQZ3ItblclT3daHZpTDH0ETmJz+T4TixX62rOGsSb7t01R8kUBQluszf2E8ZcZsVjrWadSi4bPmu5OL9tB4jwOGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D+IvDQ69; arc=fail smtp.client-ip=40.107.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n9PIMOUHEoamQe1vOGtkdH9+mTRnTpglrm8BG2zNGcwdm3zdOjpK0JbZO1EOCzJgU3cQNJmA7bY1ROCYPA47Y0koCJgETtWqfBagFt1010HGsguJoFWYedq9aKsdgeC8tScO9vRfkb+1QO/qy9410tEsWBTzcRy2pM4Hrj/zmgavP52pB+k0I9c0vECD7nSxnGeZJDfgEtjVFdRYKUpi0SNMeUiWr8lj1iSJxS/jAPm4OcB7pKBhp3Jw76YhMFY6y67e/IVTTCqiMJqvzLKuUZBdrGVcysfFD9/mnjo3JOUoq/6lyTQ91Yz5NfoFjpOXdEbX+xj+1bTgaDtbnCYf3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmJPteNuWA7bMjljXgGlKQmzA9DE4fQ+S5NIue1jN6g=;
 b=MYa2Nm/wSPukeqaMoyzNzPPko93//hWzBsoG0kbBhTqIZVEgdFclu7lx8fddnRUYc9clPz70cIuu6ewvP+GCSZqeocq9FcljUE+ZOH1BRK/SfVx7pX8PSr5OFJbPKutTrcClvVKFQLIq84Bf/OVL+pj+T9REO7bhc1AeKFHZA+V6KE2oXmk5kyZlPqMRCtDpOHbh7DrMypFvm59AZZTFAIdXSG2xl2z/7NjPCW8GT1gsgp+xvLSk+ocy4+jd5na2WvprUwrP7L17Bfqt0sy6K/p+s1XA/LvfGLlN7dUmeL5eUuIgG4VYuX4MtSWkDblZfSgt1izk3FjUoL0MG0fkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmJPteNuWA7bMjljXgGlKQmzA9DE4fQ+S5NIue1jN6g=;
 b=D+IvDQ69qSrVKdLrBTqSuBhKEbdhXSyPLNoc+RXMaxIbDkLT4tKrkqx6Gwc3L7NRaG6qqnYuI85HSjSA5pZNYcqmjBt1wPARk0VdOjkqxD9rebpgCA8N1sCg4SWlcoHmdNUkDTKOc25wCGUyYpa/5SS/sU7/WMmbOBsHs75tdC0=
Received: from CH0PR03CA0357.namprd03.prod.outlook.com (2603:10b6:610:11a::6)
 by SA1PR12MB6970.namprd12.prod.outlook.com (2603:10b6:806:24d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.42; Tue, 10 Jun
 2025 18:06:11 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:11a:cafe::f6) by CH0PR03CA0357.outlook.office365.com
 (2603:10b6:610:11a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 18:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:06:10 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:06:02 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 31/37] x86/sev: Enable NMI support for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:18 +0530
Message-ID: <20250610175424.209796-32-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|SA1PR12MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 386ec633-a835-43f1-99ab-08dda8497b26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GDUUlF007w3ifriqRZ7YbxYB9zPNrx4DgSPprWbuvVE7MZwXDrFmEgVjTGPT?=
 =?us-ascii?Q?6g4tiEShT79Vk0CwYpqYO/LQjLcqieoC5FkSSqBdDJFKChhDEKmoGzhBBUv5?=
 =?us-ascii?Q?PAue6IagBaL5gXnljg6zqVYjSa7oBKRAWY0M3NrCw1Ht4GtpKVs1DZrbJjl0?=
 =?us-ascii?Q?+iwfwnTXt5uPzdKJ/eqBULMXwaOC3X+S3Cky9RKFIj7WRDBoG5a6GLT32g41?=
 =?us-ascii?Q?ZRK9MjO4qjcJkC5a0TetCDRJ1TwhCos6iRciNaYTPafJsoo/4mugUn7u4oOc?=
 =?us-ascii?Q?pcBGqSJec+z2W5n81wuJxec3La/ApaNbGBjR4AaPHFM4fkJOvbWfhXXN56lW?=
 =?us-ascii?Q?qIdbDKUaq3Y3DWWk8sywaWUnqdGqXOQXmA06Wf/k/JWFhY3Do0fq4r/uQInb?=
 =?us-ascii?Q?I8VR8tJmf2wNtwPaw1/oy3xqHZm2AptfDVb2enld800d7/gJzuODJVwp3kI8?=
 =?us-ascii?Q?bMCZRaOsEJuMMGRh1OdT3FwsTncnRJGG9rZ77T3erZuTgF1mrhs0PwU48LAp?=
 =?us-ascii?Q?MZuxXqM4DnBk37NVuyM+vzpHLbz56UrTDlxPf8StzYsYqu/zCNWB8+uP/3Zy?=
 =?us-ascii?Q?vX9BrEIf8+trPVZS1nGyq2tvI1PUsjwBAVzTN5sMzmtQhgvxt774XxoN7W4t?=
 =?us-ascii?Q?oGakF+tcmpc3LANozn16LlrHx5SuAuykW6wBjYs9arjuV3zjClU8wBbiZd5V?=
 =?us-ascii?Q?JfKNmzy038rcGUa6WTgFO3F7T2wJW1aI0nIeA2Wo9+JkY0ZZuqhc5BTU8fwJ?=
 =?us-ascii?Q?poQvqgKjsWyqVGKtG6PkCkExBgtqO+139Pz7ue9hNwhv5y8S8rzA1eaT6kOI?=
 =?us-ascii?Q?Y+D4ME1hTo0Wv0Bw2kzYUb7059yfgYeNe+RGfwgZ9sQojUg+uk9oOApW7mEa?=
 =?us-ascii?Q?3mbFReA3+cqfZ1wf9AN6xFUvcTqneiSWqeiBwOoDy+jmrR0J/VZzJQBxXN/C?=
 =?us-ascii?Q?dY0Y6y6t2lPcJVRz+LoacNfcK+OPk9mAKZAQS/XIHiLKMpf5PJx9cvL6SBMt?=
 =?us-ascii?Q?6f3BwYv5/6OVb64XHsc5t/PEC5in6kIbPCH1kv3WmRc0EQ8rRkNW3ImtDUmP?=
 =?us-ascii?Q?YKiWbYkxYOgt0b2toENm6ISjUAIgH1063sEXQ5fnCkm9GAc+/KsibvLgRxUL?=
 =?us-ascii?Q?7+1HXzV6v+9I6Mziji2WM9ds1YhDaE7/S64bd9SBvPdrlyr4czNQ8btpYsOa?=
 =?us-ascii?Q?y+eslw/NhtBdZtfnfeHpxzxRdl2vffsW52dZcMS28xpKd37OGMTzlQwhGO18?=
 =?us-ascii?Q?ASL7/ouiI1dL2VJKojhbW6C7Ev16tLmdZeJC0g9q3EvYUFq+o7ICh9FVGNJT?=
 =?us-ascii?Q?VYEKa1PRX5LODv6NYKIxN7+aCdBsyZBHJU4Awvw1QbwMqWMkaD2XdJ1bPNIq?=
 =?us-ascii?Q?gdxMwfFyBwUSiWVUrTwHZV7RXnjX6qrvUm4lAMFzdib0LsO2FQls1DRCT/Pt?=
 =?us-ascii?Q?sg1LX0tzmJR5vjeeZb9o7dXYVMXRFeUyBcjTSLY4wAacvPuE31p/OyUy5zxi?=
 =?us-ascii?Q?S+5NwnIZaBSdyc73M0sKn89ew+xesEe9+oNd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:06:10.8130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 386ec633-a835-43f1-99ab-08dda8497b26
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6970

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 7ff4faf94ef3..50166c16428a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -952,7 +952,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


