Return-Path: <kvm+bounces-48835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A49AD417E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09BE13A1211
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2513246799;
	Tue, 10 Jun 2025 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="12hcP2Jb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA13F236424;
	Tue, 10 Jun 2025 18:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578511; cv=fail; b=IMRpuZXuUYLJ141S9ppQAAXu1oDQsKjdya8KVI9VymRF2JYtTuZf0mmkhMS+5390i432MaLRBSmGTvGWwQpbHC+kPI6IDCaw06xu4k3+Sdr1b4IMk2QDNmVauQjmWe9PJ9rbbKKlRdORnb4CY/2E9gqQLh9KNlEMcSqytBLT2jU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578511; c=relaxed/simple;
	bh=Ddtv226hmHsAKb0qANZnE6CYQoovghkOMM6iqcmaCqg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ff+NsMdoXpKwmvWp+9E0RdcwMm3wLsoJdT9bUiZUBIctVKzFZK8gQWxMyEJ25yA+KDSM/GMabifRBeMhik/0Twp15ZSc893JQNVM3A2bxM+22lC9CaQRThvm8X5QYzm904Kt/gS73Ny0LVDhNbIhzdsbG2JD3cfY65qZ4HZbTkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=12hcP2Jb; arc=fail smtp.client-ip=40.107.93.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jj9rIHxOv9WkP4qIZeGi0PuABCsdpVrs4u77th7od9VHDPNQE3Za7tg2vu7eqXq6fN6KI7UF/MYo+lPEc1of0YtfQMzi7rrpQjOoXv+AMirGgghPY2X28CRtFwywfWy1HkR+iot0dGTglesctiZ59/tA7kJtfvAcFSboRaUw5IJxRu1HW5GxN0/RYCPreXVBaz7bsTI9HOZ07wY+0TlEe3d8mLedJv38xsp85tHRDBi3K6/46XjjBdeZizfuCfb+Yrvs/BRQXerCQO5Nu41HgoTiE4Wzg9xnnPft6nQlzWKIcQePGr8RIffbSL1gBKfZolwkcJ36aUCZdDa9Hxcsyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ZmJfqG0kOSb2seuwfHp65fJ43cRysHHgmhFVo+9wuw=;
 b=atKZJoDotluszUoaIcMAzeAaOV5cqxEwg6CvyBrwy7sJeWvCRirctZhEylkvJoNFII7v6JgD8i6/wXDHLT/a53pSwFobQ5I9yCM4PlANn6SgRIdkiT+0cPdnPlPrzSvLVOkQFZx10DRyJgv8LbKMaP4rNhgwW1ptzW6k4YQkTeLRI86qCRBeslPRm3CU2t0J4K4EKu1eTFmRLHOLFWCZ4HhNGMl/eKki0KVHUw4D8Omj8F+j6ppMlZUrVqJ814SejLamQxTKCnFna8SWQ4eOKzUA9nFr+Z3LDPHRtEIKnrUN049oP40jYTFp0irKjR/o4l9NoSMgX2sYYGymNz8Onw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZmJfqG0kOSb2seuwfHp65fJ43cRysHHgmhFVo+9wuw=;
 b=12hcP2JbdbsJWZyJkBwFrYbWszFZ1A3x5YtAPpAqIrP4MblFWx0LokFaIQQvKNhqWMgoqs5xvX2m2zHQhaf3EL3uaB/i19KKuvCe7yU2nxb6Pf6T+YoKKSVgAQlzeoQzS+4aNxxXHHQ1Ccfv+GKiKlqaPE7kRrMJKrqjps3kh+Y=
Received: from BLAPR03CA0077.namprd03.prod.outlook.com (2603:10b6:208:329::22)
 by DM4PR12MB6350.namprd12.prod.outlook.com (2603:10b6:8:a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Tue, 10 Jun
 2025 18:01:46 +0000
Received: from BL02EPF00029928.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::a7) by BLAPR03CA0077.outlook.office365.com
 (2603:10b6:208:329::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Tue,
 10 Jun 2025 18:01:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00029928.mail.protection.outlook.com (10.167.249.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:01:45 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:01:37 -0500
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
Subject: [RFC PATCH v7 19/37] x86/apic: Move apic_update_irq_cfg() calls to apic_update_vector()
Date: Tue, 10 Jun 2025 23:24:06 +0530
Message-ID: <20250610175424.209796-20-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029928:EE_|DM4PR12MB6350:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d3f0f4-e08b-419f-c66f-08dda848dd00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u+mv5W2ATVXYQmiVWP2I6FB8jtSqehhXpWoIBezHrPLCe0WJAIN299qVQVX2?=
 =?us-ascii?Q?m6cUsv1yPZe6Bos5aT2AY6lpbTl8WQ/RoOjYgM9pSW8UPMRh7Pa7PPXbKrm5?=
 =?us-ascii?Q?CgLB4Ps5jGHkNm+2SDxDVFo+ZDL81K6C6QncgVmdA2GhZ3J7cQCewB9eskyw?=
 =?us-ascii?Q?MeTHVL5sEWXB1/uCXM0pTxeS6PK+NVnDcc41Oh8MgSXnpC500yOm074kRmsH?=
 =?us-ascii?Q?aJbktecYUPQxefOdmK3sCcW/xnMJU1V4Psv497GZkCDgddkALpLHVKXxzapU?=
 =?us-ascii?Q?+O6fW1RLXa4V9afRzRjC1NgVCSpQGyQjoacRSoH7K63gL1UGKanlrZ4kB0Fo?=
 =?us-ascii?Q?gg7mI5ncJMz7l0orGh6bbr/sf96FJ9JmxjZhOmOZ2ABDgxNTKboRSHMLjht8?=
 =?us-ascii?Q?3jTJlUKAF3on1FZYjH8qrOrAa2KFDpJU3BiQDE5WRX5z0KAvbOpkWcfkNCR9?=
 =?us-ascii?Q?18ZV09kCg5/YZxMw+Br027H2zol53vymheuPHLnWsfjfJ+HBsnD/WyPm3QLB?=
 =?us-ascii?Q?OBQhOC8mPOKsalJs1yoMFDHGnHTi+JD3hQbSOO0sZLRX4MQAmCQgl2dOgUCJ?=
 =?us-ascii?Q?jxI8VEUK5v6GlpImJM6HnqdLEYY3kgByJzpa1vsl41psQ85csXlD/qju3eV3?=
 =?us-ascii?Q?EqR06XOPwxstdgzzXfeL0COzpiGfTQnfJIfZcGXvpf0eoPZTJM05WWGKiCIt?=
 =?us-ascii?Q?AX7UJQ4h0gTZIYDYiWOB68S72bp/G3cuC4KEfLDQRFuAxseljr9dZAr5DvTX?=
 =?us-ascii?Q?CR660W5+iYgwmeQwdryQ11YCNSdBucdlLCcBcgwLPH++QbcVLahU0QqIHPE8?=
 =?us-ascii?Q?zG+sID6ZqRJmH2ZDOuZyEtjDgjgZATB7OnX2gFjSPYwbY+JuWt9UthEpITAs?=
 =?us-ascii?Q?SPonXkdjaDTJmn3s8DIaEBE9jAVZOiDhZaeeViSSIzGZCD3zzsVY63mzyWXt?=
 =?us-ascii?Q?03q0KeHNY3u5grRB8tFfhoDaMt/Xh+2N9XZAYwJP76wHgmv1+oUJcsn9Xw+W?=
 =?us-ascii?Q?On6zBjg9XSlpqL+5u2QCz1McwVXWJnUS0/hoGG4bg4Ceq0HnuKdM9vJfOXox?=
 =?us-ascii?Q?HVU/fk56HR2c0U8iWv918mKArwwY8hPIEWgfSYQs+S54teBytsepwYs2UHAw?=
 =?us-ascii?Q?q1Vw7NS+qF4fgz8WUy9TMcfe7rHTvI9Fsp+3n3VYT4TPy0//AwzMmH6MyNIR?=
 =?us-ascii?Q?v0i2Qy9Pb2K7QGHRDOO+g/ee0ep1MKEG8Ogwe25vGJr9uVSagZGbw6biR4wG?=
 =?us-ascii?Q?YNAIxwFK5oIgKMbvp0Dm3oY8WiphhK3sAlVvVFWa+WhP9jWtXX/zRChE5Nhc?=
 =?us-ascii?Q?jEFWHyH+S2nfh203ibBo9hsXwrhgMqagVSpJVYaj95POiW6eS2bNJqU/rTQp?=
 =?us-ascii?Q?j4K8wQscV5IL9uusS9rXwgnexQq1pEvb/ZKIth3TReAe2U8ULF1lqSsX1Gll?=
 =?us-ascii?Q?P4VZkzh7vyV8HrN3vDyM44mKBSMxq2sWXNaR7iWMC1w0om+kEde3Qbsq6GnB?=
 =?us-ascii?Q?3aGocu9hFme+73WQEInCHwIPAAbdv3E7JNXu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:01:45.4691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d3f0f4-e08b-419f-c66f-08dda848dd00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029928.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6350

All callers of apic_update_vector() also call apic_update_irq_cfg()
after it. So, simplify the code by moving all such apic_update_irq_cfg()
calls to apic_update_vector().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/kernel/apic/vector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 93069b13d3af..a947b46a8b64 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -183,6 +183,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 	apicd->cpu = newcpu;
 	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
 	per_cpu(vector_irq, newcpu)[newvec] = desc;
+	apic_update_irq_cfg(irqd, newvec, newcpu);
 }
 
 static void vector_assign_managed_shutdown(struct irq_data *irqd)
@@ -261,7 +262,6 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
 
 	return 0;
 }
@@ -338,7 +338,7 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
+
 	return 0;
 }
 
-- 
2.34.1


