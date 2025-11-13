Return-Path: <kvm+bounces-62981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE04C55E98
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0466B3A5D7E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E7E320A09;
	Thu, 13 Nov 2025 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1jtHKwuB"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189C5320380;
	Thu, 13 Nov 2025 06:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763014806; cv=fail; b=O6tTqtxqmpzX23Ar0VjwlEg4kOsniH/I3+TuIl9R/ARpb8yc1pc29+N5LW5ALVmrPlb7/FvKhKIoT4vaIT/IUm6CZYtvr3kCWPDzB6M3jNZnoVNJe5/oRA8KJ54VGKAYCnwq4VFHtWuWX44Z3W3+18PixlneEITV4JAYYAHDoX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763014806; c=relaxed/simple;
	bh=nAG2BrbZub4D7YmSoCGVQpMnTN5QlATRmJq4KDXgUQc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIfUbQdmrJR+J2oEb7bQ8/3zw2E8iINO9KXZNuCvcfoH3DnhTRNzf9Hfz7/dfaK0Os6OMGMyEs52Xwez8dvd00fjzaMDjm/INobh1Yw9PQk0X58b7540QRrorAfVqFHRETmCPzvq48c+x8n6+ASMfZ6sTRf2ge4GB8ita10dXeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1jtHKwuB; arc=fail smtp.client-ip=52.101.53.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ay+m1O4O66WNpoBZP9MaUgu7Ta1AX++7slFeEi9KOXETmEyDAWbima1NCt4Rp8evALu36ea030Xb2Da6cNcM2GyaXaQB3gFvBy3gjn7+3l8lojq3n9w+dpXbUDCbAlYxDOxOtAgerOYsJcbjUA5JCGYVOCGZp01g/Aaj0s+r4m/Tw5c+zzuW0XclA8Zi1G5hcsfu/S/u520iduE3L0VleS0/NjAC5pIUey65sA0Tzj0nCdzCdT2WA1AOxmDrK3un6dky+yS95g7CeiBikGUWHfW5Z8MTpKT0LgUz/PMp+Aabn3eZssKpE7clj7E6MuTysgU49fPzo8/KkAHwADgocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j7FJm57OxkvPIYKq4e/xNpp3KDX+0sT4elXkukBcmTg=;
 b=jvLMDyEUfqHWbYBV/oM4wixivzq+K0EokUj5xGh0eNUAy59cN74AGnMPXpVoO2Gw+vYTZF/94bOYq2cIjxoJ2XBs6p5Y8W1VG5rcArgrQKM4o+jLXJIEwO973xfHgRcErB4k9yXERUY2NWRkVoRVZtnJhwPxgNoDV4Qaj9UyBU7WQoTz+L8oLcwD6kEMXUG1SNddeP/lBaCD8U4Lyef+tDFzbnPyScOqwUyHJklGVJQPnpD84o2Ty5SfbmoTiGdEeKr+DEhopveBIr+D99TTDUMLpVAIPsg8IrPzVfejY3L4XR54zjQxTiB1lqbZZndpbn4oazOUBFQHUVINL9jFkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7FJm57OxkvPIYKq4e/xNpp3KDX+0sT4elXkukBcmTg=;
 b=1jtHKwuBX2YTKXxq1NE1A60KyD/djQut0aA51ex+DokyL4r4xj8q+7qeay367qMjLzaUcHttPi2Bz0yIUt7FA2HPSGF7x1jnmlOtnN9mnKL58KpW9ynwayLl49BVzp7jxslXRvgZbrNkmHvYwnA6kwYB32y/eOdxrdLkZzBoy4E=
Received: from CY8PR10CA0009.namprd10.prod.outlook.com (2603:10b6:930:4f::20)
 by DS4PR12MB9708.namprd12.prod.outlook.com (2603:10b6:8:278::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 06:20:02 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:930:4f:cafe::d7) by CY8PR10CA0009.outlook.office365.com
 (2603:10b6:930:4f::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 06:20:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 06:20:02 +0000
Received: from sindhu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 22:19:57 -0800
From: Sandipan Das <sandipan.das@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Kan Liang
	<kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, "Nikunj A . Dadhania" <nikunj@amd.com>, "Manali
 Shukla" <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
	"Ananth Narayan" <ananth.narayan@amd.com>, Sandipan Das
	<sandipan.das@amd.com>
Subject: [RFC PATCH 5/7] KVM: SVM: Add VMCB fields for PMC virtualization
Date: Thu, 13 Nov 2025 11:48:25 +0530
Message-ID: <5bab84ef853e341f077b336ab185b56e761d00be.1762960531.git.sandipan.das@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762960531.git.sandipan.das@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|DS4PR12MB9708:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b3e9706-712f-4a9e-0554-08de227cadd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4+/uDlEOXdp3dL2u2jKIIa+5JDt27PV06BbtkqWAUetkeD13scpWkW30OEft?=
 =?us-ascii?Q?VJ8GaU1Mc0nA9z5ig2FncqETW8ODj1DZZY8ub+2Yv6LIvR3GqnsgvG9Gy7FZ?=
 =?us-ascii?Q?mQIUfozRHxTFeYhl/naZb74xDIptMo/tdNGZkNAUAQCGUb2GzIvt3vc4PXFC?=
 =?us-ascii?Q?EHKHVP9LJOe7YNcH9eBE9HyZJrZyIUT16HYiJg4tw539IzaH7Eq/YvZwGSR0?=
 =?us-ascii?Q?L98Shhkzugnaa3EEMUAvmxu9+HaTK4shdL8quklxLuyRCENUbye4UXFsX5UJ?=
 =?us-ascii?Q?b8reE2xAfUAuigL7QxPN8kuY+QbIV3tWyElG7nemcZVti/+URk27zcsO/bA2?=
 =?us-ascii?Q?DObDSYTonLX7/TnZa/Ii5dxO4LPhz5z0sx2/EJjY8jtXZn4wgwQITyLJeOH7?=
 =?us-ascii?Q?sBERlgjXFEjBnTkwcxgAuoBuQpcalg9WesvI07O+U2WIczFNdsnsbc+16jZe?=
 =?us-ascii?Q?NN1Ue3oh/qZ7fJXafm6NfYqDtN2pVkY8+mnsUymiwiqBmLpVCGqlcZYxt7RF?=
 =?us-ascii?Q?ALW9T6NWLhc1zVPTrakPnTx1lFkXbRztZjG/r4yKWITwrf0I7mg3fjLvOm4r?=
 =?us-ascii?Q?GF5YJ2UDhelY53nvuN+BnE7XYh5ScK283130tUCKy3tVbXG/BwQKv5/dDOf/?=
 =?us-ascii?Q?RbCnHdy3HCrJMoK1cYjs+xO6lgBwj8qYBvmDEwUfoD4U/VvCn//O2KiB5naQ?=
 =?us-ascii?Q?Axq57RMKqAtgVYTjL0e/yl3aF58z43jjyoQabjsfy15dqABwU8UFlreeD1mp?=
 =?us-ascii?Q?SAidPU8tu5GG4QFKOSbABQPidmjVA5AuS1gzPvJcOT/nLsoPo6cYGittT0Lw?=
 =?us-ascii?Q?A0V/0EbrVobGRPqZxf2+wvGGlSHZXFhIhDdmpj0Jnivbb0tY82p+cs920DUZ?=
 =?us-ascii?Q?rS9l7hv+9wlLHpu12s8vSsIFwPKzhxvGv+9Nphl6upjpkrzLUbOAdtHC8H7h?=
 =?us-ascii?Q?YwmOgaQB2wKWgIGzfkNqOtWsnB903RIYcB7O4EtEVNKGqu7MizUwmMeWF+EH?=
 =?us-ascii?Q?WzTaBoae0RJzDhhZisDweMNPxYR+4tt1HGm+515ry2YDVM8X+LtK9vPlVmkc?=
 =?us-ascii?Q?HLIn7v7Q1HaJvKO/eTMSRxTthO3RJpdhc29Qy0PxrA7XtgBKURGZQXZUcmL2?=
 =?us-ascii?Q?0evLmjpi04t76tck16GGWXsY1Qgl/rPf/IYsNb0TIhYoXZwgNAwJaqLU7so+?=
 =?us-ascii?Q?mllPccxb7cJrZ4lRPl8DIqPimA0Riw38cor3bYesMtfvTbRJJD/2KHeQhRCq?=
 =?us-ascii?Q?Z86sWUrDAwXfM5k4r7BOdpSSKcQEhxNFiwZbvIrVepSohgBWqCdVQt9rmyBy?=
 =?us-ascii?Q?LDv5yPsVFYlTSQsQ27kq0rwrRsIpWBtgQ5r3Mh53aaQZ11J1X0wIumLIf7vI?=
 =?us-ascii?Q?Wf0sFfMKLeEfxleosMr7OEXYbNKjWc9fXDmcr8qC4m5rxOMWXeYRCTEFUrUb?=
 =?us-ascii?Q?yKHniJb+bJjSyhQ7E3tmgKRczKi++/HiC59zafs57VlaiLbrkYmpaWR0Y00m?=
 =?us-ascii?Q?XIgCFH8AeUizodJZ6f7XJ2lyjIkqjVa6+rxAhmWOmn/u2BIHY7b8Z/cP/VmG?=
 =?us-ascii?Q?tPaad+D713ySUXeeEMQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 06:20:02.0155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3e9706-712f-4a9e-0554-08de227cadd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9708

When PMC virtualization (X86_FEATURE_PERFCTR_VIRT) is supported and the
feature is enabled, additional save slots are available in the VMCB for
the following MSRs.
  * Performance Counter Global Control (MSR 0xc0000301) (Swap Type C)
  * Performance Counter Global Status (MSR 0xc0000300) (Swap Type A)
  * Performance Event Select (MSR 0xc0010200..0xc001020a) (Swap Type C)
  * Performance Event Counter (MSR 0xc0010201..0xc001020b) (Swap Type C)

Define the additional VMCB fields that will be used by hardware to save
and restore the guest PMU state.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/include/asm/svm.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..a80df935b580 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -327,7 +327,12 @@ struct vmcb_save_area {
 	u8 cpl;
 	u8 reserved_0xcc[4];
 	u64 efer;
-	u8 reserved_0xd8[112];
+	u8 reserved_0xd8[8];
+	struct {
+		u64 perf_ctl;
+		u64 perf_ctr;
+	} __packed pmc[6];
+	u8 reserved_0x140[8];
 	u64 cr4;
 	u64 cr3;
 	u64 cr0;
@@ -335,7 +340,9 @@ struct vmcb_save_area {
 	u64 dr6;
 	u64 rflags;
 	u64 rip;
-	u8 reserved_0x180[88];
+	u8 reserved_0x180[72];
+	u64 perf_cntr_global_status;
+	u64 perf_cntr_global_control;
 	u64 rsp;
 	u64 s_cet;
 	u64 ssp;
-- 
2.43.0


