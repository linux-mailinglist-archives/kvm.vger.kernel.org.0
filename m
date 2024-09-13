Return-Path: <kvm+bounces-26808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 169F0977EA1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBCF0283629
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CCB1D88BC;
	Fri, 13 Sep 2024 11:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z0hSw2jZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2045.outbound.protection.outlook.com [40.107.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221BD1BD4E4;
	Fri, 13 Sep 2024 11:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227631; cv=fail; b=MUKC4JgOCVCxEXrcf3qQW1NbvUptZGZOz14yg4SDvFzLPLw2/IZNNolCerC0D/VlzLcwErO2QmUqvYxBu+c6kR6t/y70+Tk6qAHpG/0IBLJimuki8iyjZEmj0yEnhuFiBI2mM/oNVeE0Vx7aIA8rzrpLGuVP6z9Q+b45VdO7rLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227631; c=relaxed/simple;
	bh=Lm303iIpSlsyRQFSsuUSxbebtBZYSEw58wdB6HeeDag=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=un56KH543v7hME9b6+U/VtN2AhJBpkIfrtphu7ejHDWEMMCXOlQ/mVkyxEotI7NjOFfWgO9lob+U4ZOAkMMod66ElR8Vm3jv/kXqG8j0Jx9Mb/ZmSWy634N432sp26Of8dq4lFrrtHR8ABwcG3DeVu+gYNk+Mc/XHObgaBdq8T4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z0hSw2jZ; arc=fail smtp.client-ip=40.107.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s3ICy69xVRTfmIVkdgYND6jzvwAD/tUUcmbONWGYb3fsaQEUMU8XkbxgepOrPecl9eUw1Ei6MJw2rZVVcIf3flZYzkdiE2xLkzQ1EflcWMpxh3Uc9XxXEZlNLjDJnFjCck0fzgEbOU5P/Qw5VYz5iOVXtIEQbXNhRPoUsVIZnXYWFsbqpU1klT/JA83nUTZ+QEEtmrQtNICJv4iaY/knP1sxyoSIJ3/200B91qqjfrH8HCiSGin2CD62Jtnizn6tAlLE3NoBpX4Uc7QKuTbUMStC1fK5n1hYgyaT6HmQH6kZoBpBuZrjPMrxpR6F5MQg/Q3RWxZQGbMhVt+AcuUvSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvdWJjQzd0CYe7M5dkzRNUvdNB/HNjQ7sjGkmwfx9Jg=;
 b=h9ZFoeTFp/qsRQ8a8+8xnpov6AkwjapwwBu7g6teklN722iWtPoGIYZH+x4TraqKpr5iXjfaTcfk5/R0eH/znY/gWGjj2N7ltZhkVMW5XopzQZIlAytaBKhiRjrKREg3z46kqVDXzpXXFr/OTEyGrRBaxa2BoMyBS0IUbP7c30OkHDLI4+C+t47pGOXFVkxVK48KlFsDUflRmJxh75ly/E7waCO8p88wScsieRKRhNStKcSX9eKSNOBNK9x0h+LMR1KebSK93qxLYqVCavdG2tT670r433lfSIgFqkmAjueXUekI5tpI2wsxWafUpiNbkgCCJNEHpqCVXjXq0mykag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvdWJjQzd0CYe7M5dkzRNUvdNB/HNjQ7sjGkmwfx9Jg=;
 b=Z0hSw2jZ23anl7s89yCAncQUj92Y6xTigtXevBteF6kVMxFMInzzkSCOFOnKl7Nj0VIciTCA6ie0R34UJpV+J3XgRpoJ2tyXBT8vnLJiy8jgaBy5B5CRAg0K5QTh1/RNFb0Z3SSd2Re8q+PjinAO7b9quFWhTIyCgAkUAew/JP4=
Received: from DS7PR03CA0195.namprd03.prod.outlook.com (2603:10b6:5:3b6::20)
 by SA1PR12MB8093.namprd12.prod.outlook.com (2603:10b6:806:335::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.27; Fri, 13 Sep
 2024 11:40:26 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:5:3b6:cafe::71) by DS7PR03CA0195.outlook.office365.com
 (2603:10b6:5:3b6::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:40:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:40:26 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:40:18 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 10/14] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Fri, 13 Sep 2024 17:07:01 +0530
Message-ID: <20240913113705.419146-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|SA1PR12MB8093:EE_
X-MS-Office365-Filtering-Correlation-Id: b8aab8c8-a45b-48a5-7acb-08dcd3e8dc61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K8eADU8DjFIsswyqh+IBdPPIbyA3103ZeOf+i54mXwG+6bj4bH4GXTJmdCHI?=
 =?us-ascii?Q?T2hYyV2p2mx1qdUhbLD1kw7b50hb/W1EEO3Lqler6qxc6AeNhCzct+o6na8k?=
 =?us-ascii?Q?q553Npk+MF47yldgoSh1YTdM6VwKK1nnFg2fDiQms5eOB149mB6W7MlFUrWN?=
 =?us-ascii?Q?J1k0f+svLQnDmyKwqH/204cq9KS6DgygVGVjXpi5JWZLyGFR/rgcPtAZeRaZ?=
 =?us-ascii?Q?cPM6gvNRl8VZFX5uaeaycbQGvib9v9YO4NewfJm/RR4r4nciwwN1v104beci?=
 =?us-ascii?Q?1Sa8M/hUcSKnhGNm2R2cWzD4/KpQW7XXweHNBRucZRJWOUmqZYeQeLazbpa7?=
 =?us-ascii?Q?BHkAFr2F5NJkR/klKMbm6eNc3q1CQ9B+T94wZqO94C2wEJzmqKi6/xxbiPo/?=
 =?us-ascii?Q?gFWhqcK+V04W8O8/7Beooo5q+4jK4vzegMrU6QPpsf3+SO7uGtF9D0k+mxv1?=
 =?us-ascii?Q?tDKr0e8hGa1PPd+0Efygaur4KB7MjsUMywcjL+uZNhkikkEPaWi4G6cEHsnq?=
 =?us-ascii?Q?9z8oLdVqRdVyvthz/BomXByhvwTXd5jlXmmyn8lMg7WD3gbOdhm60gdR2AdI?=
 =?us-ascii?Q?jRrNrDyyG/YZvNrXeWvti0ArE8L/7xLdGHQasNk4Dn+4NS3tx5pxsoDgsd9M?=
 =?us-ascii?Q?DEOL1cX2yGgb8XiaerghNlCuSHhpiK0JSsbiq4pCqkypwiwBF1zMx1SNNtZB?=
 =?us-ascii?Q?Mq/po9pizsSPSvyPcRqu2FKDUn5KF7AWYdPnQc4Afo7DZ8fkj/6HFlG3E2VI?=
 =?us-ascii?Q?5KmlaEXJZaYbw605QLduKa9XzOHJBnWYtViK+i8eMj78Z2f5seCi+brCzmjU?=
 =?us-ascii?Q?KONK5haEEqDil0nFv3rImgMaRC1eEIWspTFeyzrDtHtX11fdb3Mrc5B1MCa8?=
 =?us-ascii?Q?d3nI3GupLTJUiwTlQSYBxPZQ3zpq0BB0IG4C9B9XjJbQX84qeW+RqjbiximG?=
 =?us-ascii?Q?f+gxYk/4wT+piF6KkNCgPLvqNL9c2ZQzh5fvNprOqG2iSrvgbNZmxMmUmrpl?=
 =?us-ascii?Q?Ac57qhbISR0io0zvlkWQQlrBB3mxmdJb+WyfGUSlFPGBMYvL6rArSDmY+aft?=
 =?us-ascii?Q?1Z/Ai0XyHmlX6VItyT7jCZvUQ99B56wlV84NzIHmP1SvxeLwoom5B+i4Tm1a?=
 =?us-ascii?Q?6IW5Ba5Xew/vh0kultWUeZBt1M4K3SKI64lZVIl3sfp2fcxW/7gEpsPhWlsP?=
 =?us-ascii?Q?Vla2E3i21/gP8xvNtF3Q/ljPdM7+h1TcsGaIf0ZkOEGnP+oDW4y4SgOqKPyd?=
 =?us-ascii?Q?D0gD6B06cD+ZwwtVAvGGAWu13wwyoyasgD7OBNs1elisAURh/c1rAsr+bHXG?=
 =?us-ascii?Q?JCUY2MQbkwwAAnGDBGDd8z1KQUISzU+Nq865PEpruwKuEni+p2BSKbLjQMfJ?=
 =?us-ascii?Q?puvqOAwpCAwJNSAUVwXqe1Ntrcu3uslkkEuzIEJ3y5LQ0hOfZ1m16Vc9Sjaq?=
 =?us-ascii?Q?UnaA2ZHSjBtu1yZ9BTgUNCuQh2T8brf1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:40:26.1923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8aab8c8-a45b-48a5-7acb-08dcd3e8dc61
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8093

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI.

Add support to set NmiReq appropriately to send NMI IPI.

This also requires Virtual NMI feature to be enabled in VINTRL_CTRL
field in the VMSA. However this would be added by a later commit
after adding support for injecting NMI from the hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kernel/apic/x2apic_savic.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 2eab9a773005..5502a828a795 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -183,7 +183,7 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	}
 }
 
-static void send_ipi(int cpu, int vector)
+static void send_ipi(int cpu, int vector, bool nmi)
 {
 	void *backing_page;
 	int reg_off;
@@ -195,16 +195,20 @@ static void send_ipi(int cpu, int vector)
 	 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
 	 */
 	test_and_set_bit(VEC_POS(vector), (unsigned long *)((char *)backing_page + reg_off));
+	if (nmi)
+		set_reg(backing_page, SAVIC_NMI_REQ_OFFSET, nmi);
 }
 
 static void send_ipi_dest(u64 icr_data)
 {
 	int vector, cpu;
+	bool nmi;
 
 	vector = icr_data & APIC_VECTOR_MASK;
 	cpu = icr_data >> 32;
+	nmi = ((icr_data & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
-	send_ipi(cpu, vector);
+	send_ipi(cpu, vector, nmi);
 }
 
 static void send_ipi_target(u64 icr_data)
@@ -222,11 +226,13 @@ static void send_ipi_allbut(u64 icr_data)
 	const struct cpumask *self_cpu_mask = get_cpu_mask(smp_processor_id());
 	unsigned long flags;
 	int vector, cpu;
+	bool nmi;
 
 	vector = icr_data & APIC_VECTOR_MASK;
+	nmi = ((icr_data & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 	local_irq_save(flags);
 	for_each_cpu_andnot(cpu, cpu_present_mask, self_cpu_mask)
-		send_ipi(cpu, vector);
+		send_ipi(cpu, vector, nmi);
 	write_msr_to_hv(APIC_ICR, icr_data);
 	local_irq_restore(flags);
 }
-- 
2.34.1


