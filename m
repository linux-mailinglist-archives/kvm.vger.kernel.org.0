Return-Path: <kvm+bounces-48834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F26FBAD417C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE50A17C300
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F4D247285;
	Tue, 10 Jun 2025 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C8FVRewd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40FF625;
	Tue, 10 Jun 2025 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578495; cv=fail; b=RKQgvBNs4k1AM3iY8pOnAK1876dZS+D0lgQDnQBJP93BgnYDY/GS8IglP4mr7eWgbB6fOux+/TPgd9wN9+jpvdhXYVn3obTmB2icL7Ch3sqvdNquUDkRclovhV7GpM3r+oVOZrRl27nXINU6VOjYS1LBUvJ9VktazvzSBGFV1wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578495; c=relaxed/simple;
	bh=zxgj12Bd9jFsDU/q8WfqY9LfydKUL2peXiwwrSxVrkU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rq52YyXR9mjMeg46olCNHyUSuCEP9IGh+9CqUy2S8AYM+VTfy0RLBlw0FYj+rkAtEuIxY9cQeUsWBOzi6B7XFOynEUo1OaTDuTNR0c0608vs/3XllHP7lqKS4ByyHFDUm6LQZudM3ZHj43UUy1Q/AoYeVN7De7gQMzEY22MFZIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C8FVRewd; arc=fail smtp.client-ip=40.107.100.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pubfh3tTpLMwBo8byrlayty9WeaHeakRHyH5DbqxzKnj77ZvEAxZDBw1Dfv0iU7RPaz38Y1kOICp063qcJy4wMMjcUuSYio2DfsMlc28htaILsduo6KefQS4Pb1meAZOvdRkluWp2qqha31T+96B2yhr1QExVYusFx0j+rayYumLBSNSkqfcgGUsQkdlM+3+RDYpiBYITJM4WGTBWKTVi6GVP0Wkom+jbHWeSxlSP/hBqQq85vuwSGZnVTrLKhk0UnxTgEJdQ6tBuHSjY77DC+oUo1IaV5P77+HxaGSySU2XeXNcxDQMwlb2/CDbbeCEjuzfccLovOBmpTBtxjUssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1+rpu9pCzctk/884afs7qS6+3+tPCRGHTxM3H5tWng=;
 b=iX1K3MME8Dpcfnrus8eyEL4PVMBsFQYJ0/IjCmdghDEbZy9FecocJ7UodNWOaMCas3kDp844oSS00YESZcMC4pxyxzwd4yJU5Mv8hoDDWk/P9ESYOzu494N3yShMafNLb+Oq3shSDeMlXf9Z9Yjp2ovniAEvHaZO/3wdZIarwNBJFHXaoKbX6uL3uJY/5YTUScD1RHVCYaebNwYyqnTKlnpb+eMqpkwwC000y3Ub6JJL7+Ijjzgc0mP19nut70zLcy2IshqXEGCN4E1HZQbZ+Yh2h2GOYWh3ICmwLVgxdoOu3znw9HxhUimv48v6frstZ1erlRPBAQaIyJm36RPAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1+rpu9pCzctk/884afs7qS6+3+tPCRGHTxM3H5tWng=;
 b=C8FVRewdEt84WUjRrw1P/PWlPSB96ccdY5PeXDGKbYmXo0XtkRAmEpkktiUht8K5j23pfwmPgrQmCi3e45DVgAVXDPC2+kEiTkrjsaKHBCEnKPrbis5RUjjt5Y8m4p+90+IWKY02gYf81dpnLo4xpokqEApnPdhulNO2e80UzhU=
Received: from BL1PR13CA0202.namprd13.prod.outlook.com (2603:10b6:208:2be::27)
 by CH3PR12MB9146.namprd12.prod.outlook.com (2603:10b6:610:19c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Tue, 10 Jun
 2025 18:01:27 +0000
Received: from BL02EPF0002992E.namprd02.prod.outlook.com
 (2603:10b6:208:2be:cafe::a3) by BL1PR13CA0202.outlook.office365.com
 (2603:10b6:208:2be::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.10 via Frontend Transport; Tue,
 10 Jun 2025 18:01:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992E.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:01:25 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:01:14 -0500
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
Subject: [RFC PATCH v7 18/37] x86/apic: Simplify bitwise operations on apic bitmap
Date: Tue, 10 Jun 2025 23:24:05 +0530
Message-ID: <20250610175424.209796-19-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992E:EE_|CH3PR12MB9146:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e88511e-0d48-4443-4205-08dda848d129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QhFADx706Pho4VrFJmBE8kRTBakkSUws/qAbJUIBQ4GDp80epm4P4WRGgfJn?=
 =?us-ascii?Q?B5bpvAAJlwm90ngBxa+GWVPRp1gUcq0iW7in3Z6xcjkiw0MdPTbIUEyxXWiv?=
 =?us-ascii?Q?NOYK19oYFce/jjnl8Hl7lCmmp5kcahc2nQHHrT2+D/OlTGcVS+nDGQBrDbvJ?=
 =?us-ascii?Q?9AtpteVz39pE1/ZGi99gYQccc4wAo0NV/5Hw6p5gwc9m22y2fx3klwCzpFBa?=
 =?us-ascii?Q?ChqA+Xqhrxo5ZZBkdMJKV2Zzxtx/a1JMSblniXeNWpYge83SLsIdFczygzj6?=
 =?us-ascii?Q?WVzMXMJKP/19yhL/ucWo04SNMwftZPP2Qp+RNF4b1dkTS2t/KJJZPLceb7Lz?=
 =?us-ascii?Q?KXnwtq3QI5HyE2iuhOWGU92dRkE9VIVDVMZ9qpe0GqwalIXA5+p9Oxfrzki8?=
 =?us-ascii?Q?uxavnh4bPI6sULxbg1JTFk9I/GQTI5aCCKCrrPk2IPLdgjhfxjmDqBsx6rbr?=
 =?us-ascii?Q?dJVIS+7nogUTj/CgmpNa5zHwl4ETE3yy4moocVXUPf+KetvWo9mwnrwVHlYC?=
 =?us-ascii?Q?p5pG4xvihpD4sL6ImJufBKyY62KaGTKBQbKPzJNHYgEjts2oqAlH856NXshk?=
 =?us-ascii?Q?Hy6vJ6aVEiNWGG4ZCZ+hnqr6DBxHmzBRfPHxIiu8BK25iI9NiEH7wi3B1Idk?=
 =?us-ascii?Q?gcXiIgD/xivB7wvxAT1lH8cj3h6hi7Gph+T/g3scjD3oP3YYI5TApKoR5Oyd?=
 =?us-ascii?Q?kOtJu4xY2A8kF7JWRRq6geaHg95OIBnmHS9Y+4huNT+J1Hl205GwNEPr4X2O?=
 =?us-ascii?Q?yL8eMX+psRAzO5pxJcQVwssTtSk9L3RwqdHWWceYzA2/INA+xksPgz2io9NQ?=
 =?us-ascii?Q?ZWXnmtPybpZR4DpRiIgyWv/JDVY8WpUlbi2YqWjai27J3rjWkTOxNm6V2Auf?=
 =?us-ascii?Q?ZH+zATQoTj3R+3oxE+rJK3SWfzjPVMjRyYbwYThkbO1qov5eRebkhbN+LSzM?=
 =?us-ascii?Q?3dsuJScXZ0/b8cs4MMkujHejKRnLYPkB4y9NAi09k/9jmvWpMnZXhioC3Uaj?=
 =?us-ascii?Q?jzSTzThi45QAOExecB17VNueEuvfwPhNbXhSon+hw5cqv3uhmhr+eVNnJ/5E?=
 =?us-ascii?Q?57NL+pn70sVui2gve1cYMn0IUKW7bBdPoVqRA6Y7e3P+ZkMn2aEC9rCMIO24?=
 =?us-ascii?Q?MI0MgIjHu3+l15r3En+/37G77fnm+OwEuI3C1l4Bco5Gw5pfHAQGQlsbEV11?=
 =?us-ascii?Q?7p2Wc7ocrze9kHlCLREFhXN/cXAS7K9/uiZ2GSXy0G7i1Od2RIKfsk3bM8i/?=
 =?us-ascii?Q?JHoDyjn8JtfZYiS7BUa+6pJHjskfbFkOnzJQat/p3SWbwcwEIXJv6rO1l1FP?=
 =?us-ascii?Q?eDCuj+7ifEYujfVQzBcdChxoZu9BWGcuQqv79+0OAHQkcK4hjGQXQK5dH52u?=
 =?us-ascii?Q?h5RCiDuJjeTFZxnyvEZ5RzTiKUTGdjsqN2B3RGgkWP32x9iBkaQlX2mPrOY0?=
 =?us-ascii?Q?7ay2vq41BXx3sfKv3d30EFpmazGb9TQa2/gmsh4KXK43rIcg27JmSAU5Go37?=
 =?us-ascii?Q?IS2wedC9RWsyxHX2hlHS/wqswGCxu+coIWPm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:01:25.6280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e88511e-0d48-4443-4205-08dda848d129
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9146

Use 'regs' as a contiguous linear bitmap in  apic_{set|
clear|test}_vector() while doing bitwise operations.
This makes the code simpler by eliminating the need to
determine the offset of the 32-bit register and the vector
bit location within that register prior to performing
bitwise operations.

This change results in slight increase in generated code
size for gcc-14.2.

- Without change

apic_set_vector:
89 f8             mov    %edi,%eax
83 e7 1f          and    $0x1f,%edi
c1 e8 05          shr    $0x5,%eax
c1 e0 04          shl    $0x4,%eax
48 01 c6          add    %rax,%rsi
f0 48 0f ab 3e    lock bts %rdi,(%rsi)
c3                ret

- With change

apic_set_vector:

89 f8             mov    %edi,%eax
c1 e8 05          shr    $0x5,%eax
8d 04 40          lea    (%rax,%rax,2),%eax
c1 e0 05          shl    $0x5,%eax
01 f8             add    %edi,%eax
89 c0             mov    %eax,%eax
f0 48 0f ab 3e    lock bts %rax,(%rsi)
c3                ret

But, lapic.o text size (bytes) decreases with this change:

Obj        Old-size      New-size

lapic.o    28832         28768

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Converted assmebly to AT&T format.
 - Added information about overall kvm.ko text size change.

 arch/x86/include/asm/apic.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b7cbe9ba363e..f91d23757375 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -564,19 +564,28 @@ static __always_inline void apic_set_reg64(void *regs, int reg, u64 val)
 	ap->regs64[reg / 8] = val;
 }
 
+static inline unsigned int get_vec_bit(unsigned int vec)
+{
+	/*
+	 * The registers are 32-bit wide and 16-byte aligned.
+	 * Compensate for the resulting bit number spacing.
+	 */
+	return vec + 96 * (vec / 32);
+}
+
 static inline void apic_clear_vector(int vec, void *bitmap)
 {
-	clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	clear_bit(get_vec_bit(vec), bitmap);
 }
 
 static inline void apic_set_vector(int vec, void *bitmap)
 {
-	set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	set_bit(get_vec_bit(vec), bitmap);
 }
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
-	return test_bit(APIC_VECTOR_TO_BIT_NUMBER(vec), bitmap + APIC_VECTOR_TO_REG_OFFSET(vec));
+	return test_bit(get_vec_bit(vec), bitmap);
 }
 
 /*
-- 
2.34.1


