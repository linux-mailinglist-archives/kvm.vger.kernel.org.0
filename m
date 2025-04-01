Return-Path: <kvm+bounces-42304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D42A779B2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89ABE16BB8F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D951FBCB8;
	Tue,  1 Apr 2025 11:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wPnXQf8a"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44DA1FAC42;
	Tue,  1 Apr 2025 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507474; cv=fail; b=X3ZA++k5t05lr5viVQOQPpbnWNym+T+zwa0hQF8uQiJkonh2VBn+ObJK0d9dyJOn9XHNgpM7FjkTjiKS2PWaNTj9BFXKR7yAK+FtXdIkjRJxS0I1leEJW6DSWkCjeNnDEu7viLYi7U8AEWREAkcZwBuuw0Lcqj5/0rbmF4lOiHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507474; c=relaxed/simple;
	bh=koXRG5KMO6EsJ1OiTAuOlpVrXtHs0HXT34+wMDFiXY4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKH8sAV6pV5vHQb+H7XzBabh+esUSVl+nZno8YhM7moe1LxclyT/t0TvlkxLG0NpMx6fNyHI52AmkqJ2DrzKhthAeqnZ2sHrHedg7YaXg+Bmcr5DVipdzQHqmc/kHox0v4N3SW1EYY4k1yQidgDqsYCGfmVm1r2rpYb5Gxy9n40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wPnXQf8a; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKLAuwMl59wl/JCS7s9aS+fkL+dgG48Dg0EnWfx6YlQOUioa1fdaSgDNq5tDHtvb3PoWfdFeCiZk7JSeGo6nwVZ+JqA2nRFnhiYI9K46AGNxuIW2TblUaMMB93f0OD4PnOUHXUakigWnXGgW+d5InQ6LlRTw019vU3TFZwKwPLZLbH6zhHTdg8MQIQUKSic2+aLrzcH1hv4HSWGEukitgagOUx8b0TMHPmmC9H9cVeG6NGndwTsMHWIacaoFQGmk0UJI6q42IDa3wDZRTkS0ovkU6PExMNWE0me1eqdVgSdilV5qOcDuq1SOnx4QRGFkrFjYU+JPj4dOIaMokteFnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yltuD29W1pRYgbgxSW01ff36nkdtJizex5B52GIFR98=;
 b=nHie/S3LctCvP6m2nVBlJr6065t6yLul1hnGkugIJeKIr0VGLO1WXllsQCK1DO0UdiTUiDJHKFWE3u0kB1w4yU3JAXFXIqHHKmVLVsea+e92ayqW9oSlzlvI1tN5WdbyxE9y1hT+4xLZVZAGpI3LsHG5W9EgqFSF+IrSgQUr1wSjSRCFbjiaqAoFYn83Rr7GTL4F2YA9K3Dz3+abn8388BooO+jTuxpkbChmiBc4W+4SyNluV/+48HdV/wG5v1PIYJ5REhmndMvHYo9G4ewkT94eObcfeAfo9lekt8Q6pCAxPGgLmnlzUl1Fkz7nMM9L/o/r9a6Z5ana/tBSKqHucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yltuD29W1pRYgbgxSW01ff36nkdtJizex5B52GIFR98=;
 b=wPnXQf8a//krBLL8NRkdYtE683WYVRkii2wmR4TeX0yYy0Mt89O8OUpoAglh+Zqwc+65r9Y93SMi9JK2hjLUcSAVFb5F3xhBFGXg5EZV8ZLlasJxi001QECxQPfOO5nnhaC9d41Ku8bsZ4C1s9DvxKA5Z4IbW+7mJEpgIthYO90=
Received: from PH8PR21CA0004.namprd21.prod.outlook.com (2603:10b6:510:2ce::11)
 by IA1PR12MB9061.namprd12.prod.outlook.com (2603:10b6:208:3ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 11:37:49 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:510:2ce:cafe::bf) by PH8PR21CA0004.outlook.office365.com
 (2603:10b6:510:2ce::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.5 via Frontend Transport; Tue, 1
 Apr 2025 11:37:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:37:48 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:37:42 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v3 04/17] x86/apic: Initialize APIC ID for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:03 +0530
Message-ID: <20250401113616.204203-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|IA1PR12MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: 950f4fc9-f800-446c-80d1-08dd7111a104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qBfi97WdumdgGUs66vfQpI+sxOtsLxQu7t6np8np3wecCEllv8CVw8+sWpNv?=
 =?us-ascii?Q?H+jVlAVRMt7ESoPigmTcaTc/E2GI3s+jfwOQpeRSkIGogcUSYXijU6EvBSM/?=
 =?us-ascii?Q?oHkHGIvWi+fUEX8dtoznjDYseRP/AHDkhgEDVW47KvLhb9Wk1iZjdyRYCeEg?=
 =?us-ascii?Q?rK4bsy8dICPCEA+H5WiOrQT2OEAzzYhBqF2YWMtrWgs1RtmYfZiTJIaz/fhl?=
 =?us-ascii?Q?Jr/HcE3ngfvCB0SLUXwmyKWt6sb6nk6zCWjBAsjNzmSZCd1F9kjJzMomuTkq?=
 =?us-ascii?Q?jA79l691jUktgtlHOx+osjzmuFa64/4WkM0Sp+jEwQcD3LV/wwWkZRMK2sCo?=
 =?us-ascii?Q?NNbtIUgoS8KiyW7G6IPuePh7aoW7iSfGc/0l365zdwJnr8gH4D7GQ2esYi3o?=
 =?us-ascii?Q?y9jV+pRxzL7fJ7Erw2ZUGASmM3k350EApwg59kD6OvTKk6GkqBpqS4xIMY+1?=
 =?us-ascii?Q?lZVva1oUtPc4rfjRy9KHO6SlEN6GBrO66ZGg/zAyctP73dh4aEtvxVUMbgIU?=
 =?us-ascii?Q?jyLkDrVaX/rvM2ZG+wZES5HUSQfOCNnQNZrw/Ag9yV+ggFgMDOBIn2GD0ONN?=
 =?us-ascii?Q?GqRh4YxqedN4fc3AUwyQkTx7xZbuxSKGfYfQlYf22tnbSTms+NHKxnT4FSER?=
 =?us-ascii?Q?pmRQ/K+n8Zr4zrdyCbo6v/J7mgRhk2yJM9u/TADscN7BQIuhjGJgOvg6yxL2?=
 =?us-ascii?Q?1TkzDAFzqF/XlccVCA61L4qNYSgTTDbCujW9lo6RhBj7Q5oIS+PFDM9OT/VK?=
 =?us-ascii?Q?2ON+oZDFpCOvC98dlvpilziYZMxtGiebAoTKR8gbk0mIr1uqc9x/avotSP0a?=
 =?us-ascii?Q?R8Aui+18g9quYVHPe93qUXr4cYMynqif1d3qUTo7XRWIdNNlUZXdwvwE5jFJ?=
 =?us-ascii?Q?RG9GavCrmwmXYypdL+7ioLl38PG3CC28xZvkKz8Be49v1o32LoPjunU0j5lP?=
 =?us-ascii?Q?m8jn3uKERRQAiVGcTEAD6RSKly7w3zIekv1o0AqanVtDygEAP5UqulS1elLg?=
 =?us-ascii?Q?cXr04cfTag8MGVotTdA2v1zQMs/Ng4jnXBbV1TrYhB8BVO8i31SRK8Aw/BZY?=
 =?us-ascii?Q?u6wIwcEpAOVkpBUrvAlelrp1VeEk+yKUC73i49pMXBpLWNBp/nUAG31Nchf1?=
 =?us-ascii?Q?bU17kSDiYvC72oB1SzrFA4MJg5QZs0Mg5Fhr8S7GcCkK0UsjQ/kJ+ld1Y/Ae?=
 =?us-ascii?Q?vDewC8dZIf3N2YLSiJpYOjaZLOqaZ1Y8SJpif4KxbsIUdv8X0Xj4croCSfsr?=
 =?us-ascii?Q?gKJc/N+WplPWLIwEe+khtstJ/alA54ijJrwSHrJD3ZfBVhBcNlQ28Wi9IAkt?=
 =?us-ascii?Q?mCDmXS0mtMAAzu8grj+c0ppmfXJU5XurGO03wjslRoeOHqGig6Ef0+9WcCSi?=
 =?us-ascii?Q?mlzbNaqq/9ZU1suzJONc6NMeOzNQf3hQqhLqoI2TKxpdyiYRUEGjsZhoQz8m?=
 =?us-ascii?Q?seoQExZTgbGVwbOYEKaHFD+JKbTyEvsdvjdDCzrN2qFyYAH2E2r+Aw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:37:48.4741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 950f4fc9-f800-446c-80d1-08dd7111a104
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9061

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Drop duplicate APIC ID checks.

 arch/x86/kernel/apic/x2apic_savic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index f1dd74724769..21f7c055995e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -185,12 +185,25 @@ static void x2apic_savic_send_ipi_mask_allbutself(const struct cpumask *mask, in
 	__send_ipi_mask(mask, vector, true);
 }
 
+static void init_apic_page(void)
+{
+	u32 apic_id;
+
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
+	 * APIC_ID msr read returns the value from the Hypervisor.
+	 */
+	apic_id = native_apic_msr_read(APIC_ID);
+	set_reg(APIC_ID, apic_id);
+}
+
 static void x2apic_savic_setup(void)
 {
 	void *backing_page;
 	enum es_result ret;
 	unsigned long gpa;
 
+	init_apic_page();
 	backing_page = this_cpu_ptr(apic_page);
 	gpa = __pa(backing_page);
 
-- 
2.34.1


