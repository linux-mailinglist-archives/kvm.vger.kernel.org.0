Return-Path: <kvm+bounces-42309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1518AA779C5
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AF343AE13A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2801FBEAF;
	Tue,  1 Apr 2025 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="siJ4OHYd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DD322338;
	Tue,  1 Apr 2025 11:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507570; cv=fail; b=Vdu6QoGRZQceSQloP9hmV6boeF3lXDRQmbaUGZ2zmJTHPKyilhnPKApyUSts3NN4kyYe4hV2oKljE46aVGB+kQ3yJ56bMXWgxtM5w7t/uF9Reg9N3O6gv5WlJyCDOWS69oY7Vxe60DEc4IIoxnBb+HVwxDiVc8kEIX+P8XaLqhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507570; c=relaxed/simple;
	bh=mzDeMhiBUT80pUXFMZNyXsfAowEEG03sqB1Vjh9A2BY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DgiDiCFzTAzrq4EqX4h02CCiI3/tkKkErcBhOwa3Y2oVhJheqDrlxGPC9Cdcq0xRSy15HfHEVviPYRiW4g6DqCK9I4T9nUntROED+4Qe3MnBTZGqWSeZwe3esnFHkDjxobqzhySSvEBgHq/vgFmeGab1FBl+Dbu6WLzHg3GZed8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=siJ4OHYd; arc=fail smtp.client-ip=40.107.237.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MXfckLmnWGB9ponOVsb1n0Ih2LgVR6ajhSZqz9JpZZUbZEBBvOawMrqkihL9UBxlJ5qOWE+kIU1J5S8fP5NySS6r23qKZYrougLT/kd9w9TYrswNJx7tqxHtVX+Lvkh+32zjpIav8YcW86Wd3d+6llLpXQHFjlDquujDTiWD16v61eub0+7ZLLa4sxFURdwUYZT40qb/JdVX2lfcVSZAKWMsOIjUKE/xWCk3mHyml12joqImGnaVrrloIeId3TKeID6KYoVfuG0B51xn6TLYdmlhi51UqqZrHniMBNWznspzA+fUFQXQjyQlihF8j+6vyWCjQEoB9dMbEIF8aZ0kHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JOmHFF2yrqnPBWF+5CikR6htvVnRxk2D4iMCRdwa8T4=;
 b=m/ygrowWwR4rhsihNxmFZmMA9hUOntRiOY2vv/y76EHiezdR1oo8Gz8rAwoPVbwJOhF49lePbvfdoxmU4BuZVZs9oebgBdY9jIv4zkt5FdsMS4PeQcbw81o36+wF7qZwtIsNrm5ZX0p7Q6ANGoyc23oEXIJhPDKVxoJyG4PMNsMkU6Zzy1XcChi1/dHN1ORrjPZDdCq6a9QVpvRfZdZ7KlyscVZTytrU2PhNPaQWQGvVXEV+PL/bVxiBxJ/1xjyl+lWgYqjPd5yv8bz7Ven3Cg4yDbK7/NuoKahqj5DwYA63SVhTbXrFi6a8r4AKmY3SiGUMjKi3YaPtS7ew8nHARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOmHFF2yrqnPBWF+5CikR6htvVnRxk2D4iMCRdwa8T4=;
 b=siJ4OHYdZHD6UvMhrBielUHujxmU/oJ24G0N5/acoY2dZ9hyBkOksiRJwgfNNl+G4dOc7kjpOq2DuuK0vHwaVK8OyR4t4fkvTt0BRCKI2d9IQiLCSgW19OaJzrkVS/GgY32nHC4rzSt73XaRTg+brlkGFVGjSAYHgK2TISQVFIk=
Received: from PH8PR21CA0008.namprd21.prod.outlook.com (2603:10b6:510:2ce::29)
 by SJ0PR12MB6830.namprd12.prod.outlook.com (2603:10b6:a03:47c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.49; Tue, 1 Apr
 2025 11:39:25 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:510:2ce:cafe::9c) by PH8PR21CA0008.outlook.office365.com
 (2603:10b6:510:2ce::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.6 via Frontend Transport; Tue, 1
 Apr 2025 11:39:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:39:24 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:39:19 -0500
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
Subject: [PATCH v3 09/17] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:08 +0530
Message-ID: <20250401113616.204203-10-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|SJ0PR12MB6830:EE_
X-MS-Office365-Filtering-Correlation-Id: ea3de6fa-4b5f-467c-d26d-08dd7111da89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JLIRUOqCYuWlhahxKF04g3g92Glt8YRAyhCGXb/K++Ducc6YdLvaR1gjT7wC?=
 =?us-ascii?Q?VGsk4tDoyODEWMP8dnmXNNWGwg5O34sj9RkaNYyrjDHeVwARX7hWhj7Q9BzV?=
 =?us-ascii?Q?V9c38oWrypCzpQdcFjwqdOc26zLCGqXiwgmS/s0JbAARptivxy/+GzkbPIwM?=
 =?us-ascii?Q?b3gnxXW4ofjWIdnfmVlgXLAMIGnkvxhZHncD2mk/jyF4kHrTf4xvgGuH8sL8?=
 =?us-ascii?Q?LVSng3PQxZBsdE+7zW50xYVHe9BeaRMZ4zO9g2G5XVMODcuO7uByB2ujjyaB?=
 =?us-ascii?Q?dZx6bm778qwWpZhza4gDmSTyXiPF9YFxECLNjlzaTr/NutldHnDRw3JjgSvP?=
 =?us-ascii?Q?BQGZGD5f0Bag7BAgFbbUrZEBvZ22o649PScFXeru2OE6WmR7oc/yY9AojIG0?=
 =?us-ascii?Q?Z+qQGCyu3zfq39+6GuBXHByNWJlGRv6Awz4F5gay4712Es8lVAj7B0+NBI5Y?=
 =?us-ascii?Q?NxibFhlTv4+MJ9h2oc6nQ0UxcZlnSJLuqde4ufi58uAjE1VaJMSwA6CFoZ3V?=
 =?us-ascii?Q?7MlinYxajTXVpjiUvGn9SJJseYD7UMAwUjJQes7bDqjKcL4RftlAlO5EfKVk?=
 =?us-ascii?Q?HnH3TNIeLP01AaP1Cbie4UsYAMW7ntQF1XDxRz9NrxRBemeC/xtMJuYjiuJw?=
 =?us-ascii?Q?l454BD+HTLMZqg0hHdp6tpnfx6znWqM2b1L6d049jakOZxcj6TO5ebC5R8Y+?=
 =?us-ascii?Q?6fUZqQ/rO5QcecOW7hB1OinbnzF2b81DAN90hRA/XoTBvgnUWrwyq36D30yK?=
 =?us-ascii?Q?M3/pqEDvaJ8XEyByUsfqrkMTBcE9ZPqNH8JLKG2rB5AhMBVSnFPeDakowHMa?=
 =?us-ascii?Q?bftLT1U+iy9jamh8F1ByH717rRBrhbfG2TTLDu5PtHIdPCI0WcYf6mq3GW6Y?=
 =?us-ascii?Q?XtS3UCPzXYzQPrVd8eXZZ2fehb8daZIF/Wl1LXGkrAjXJVaIcBJUuQlZhpRP?=
 =?us-ascii?Q?2so/PZX2uWH6Lc5uJEZfvgc7Y7TuD9rveAA5isiu1rnYhmOzSS9nPiHx0KbS?=
 =?us-ascii?Q?euQfyORNM2t/n+g3ByRtC5sz5VqLP898+aXGn72nPdkIIlgoUzt8QaGcmTbC?=
 =?us-ascii?Q?8YI7ZxiytTD4L6oBM2oynkokg6XzRTxuZ6CqyhWXsg8CZd6+CRaO63p7JrC6?=
 =?us-ascii?Q?koI3cMU1i3eUCQ1IbeGHQEgMLwNsEKGaB1MNOTcSJvrH+i8+atjxVY8iSOkk?=
 =?us-ascii?Q?QpC8ak7n4dvN/LLT7XnJnRDZFVxWNEyni+j4JrvAsZOB8olmkCol+4UqSbAn?=
 =?us-ascii?Q?BX+svXHTOQtfbCm9NJh7KXPrtunYVtKhQ5/oM3CQnszWzdTAfC1W5JSLPY9X?=
 =?us-ascii?Q?20nW7m4wk417ocuQ6gl8uhuvLY1VDK5P8+T2mpqewBOzG1n6jKb7Uw1geOkw?=
 =?us-ascii?Q?ZFM6N2GwEwhbjdc5YgQizgO34Lwg2h2OjEZsI5EaYrKTbz5aD0h40bY8YGYB?=
 =?us-ascii?Q?lLCRpNc0Rys+5QXTgJWlcO7vK8QHKGJFwQqRHjz1VqHq8xbsWzvNW5d0WMCE?=
 =?us-ascii?Q?lC+KP1FKvMGhHyo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:39:24.9841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea3de6fa-4b5f-467c-d26d-08dd7111da89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6830

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

This also requires Virtual NMI feature to be enabled in VINTRL_CTRL
field in the VMSA. However this would be added by a later commit
after adding support for injecting NMI from the hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Updates to use per_cpu_ptr() on apic_page struct.

 arch/x86/kernel/apic/x2apic_savic.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 1088d82e3adb..f2310d90443d 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -180,12 +180,19 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	}
 }
 
-static inline void send_ipi_dest(unsigned int cpu, unsigned int vector)
+static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
+	if (nmi) {
+		struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+		WRITE_ONCE(ap->regs[SAVIC_NMI_REQ >> 2], 1);
+		return;
+	}
+
 	update_vector(cpu, APIC_IRR, vector, true);
 }
 
-static void send_ipi_allbut(unsigned int vector)
+static void send_ipi_allbut(unsigned int vector, bool nmi)
 {
 	unsigned int cpu, src_cpu;
 	unsigned long flags;
@@ -197,16 +204,19 @@ static void send_ipi_allbut(unsigned int vector)
 	for_each_cpu(cpu, cpu_online_mask) {
 		if (cpu == src_cpu)
 			continue;
-		send_ipi_dest(cpu, vector);
+		send_ipi_dest(cpu, vector, nmi);
 	}
 
 	local_irq_restore(flags);
 }
 
-static inline void self_ipi(unsigned int vector)
+static inline void self_ipi(unsigned int vector, bool nmi)
 {
 	u32 icr_low = APIC_SELF_IPI | vector;
 
+	if (nmi)
+		icr_low |= APIC_DM_NMI;
+
 	native_x2apic_icr_write(icr_low, 0);
 }
 
@@ -214,22 +224,24 @@ static void x2apic_savic_icr_write(u32 icr_low, u32 icr_high)
 {
 	unsigned int dsh, vector;
 	u64 icr_data;
+	bool nmi;
 
 	dsh = icr_low & APIC_DEST_ALLBUT;
 	vector = icr_low & APIC_VECTOR_MASK;
+	nmi = ((icr_low & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
 	switch (dsh) {
 	case APIC_DEST_SELF:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		break;
 	case APIC_DEST_ALLINC:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		fallthrough;
 	case APIC_DEST_ALLBUT:
-		send_ipi_allbut(vector);
+		send_ipi_allbut(vector, nmi);
 		break;
 	default:
-		send_ipi_dest(icr_high, vector);
+		send_ipi_dest(icr_high, vector, nmi);
 		break;
 	}
 
-- 
2.34.1


