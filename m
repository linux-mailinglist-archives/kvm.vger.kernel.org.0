Return-Path: <kvm+bounces-39668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2E0A4942A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2922C3AEEDB
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062702571CD;
	Fri, 28 Feb 2025 08:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tv1pYrLh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2051.outbound.protection.outlook.com [40.107.236.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28C6256C74;
	Fri, 28 Feb 2025 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733034; cv=fail; b=sHjzSZKIXiTsZd9Nncj2QLIqKZo6LUSLWhWUgARUNQ4QD9dnh+bNsoUMZNYUB8WQ7gPujwLB6na0snby5DQcK3+N6rWxtqSXFF8vIhvbq+sAGCSKK5aDUf+1QEIPwBK53EQN0C+j+kRzGQ0nbVQNCwbO4mL2Q5MCMn8RyogqKZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733034; c=relaxed/simple;
	bh=eIT5cW8GqVTCoQCjR/UBbQ+EyY+Lhc94mgmcKN2mXlA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B8xQcQ/mcokUjNn7eZVpa8JaSUWxiFaIO/OvXths98yyr5GzC2FGa3GVft/dfHharWxTA2gnpAYtUl6c6xmoykpmw/VhiBZ2k+Bk63X45bG2CwN+Z6YRCXA6LY/+J3m+VFQPMz/y6/upHtcn9amQQh4hyiXSl1vcYx3+PbmSFBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tv1pYrLh; arc=fail smtp.client-ip=40.107.236.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqsIbheRI+JoR7rsUWYpj/tBPl2UBEJBz9L7MmGwoA74cXJQ6U1jY1VTdIL9mG6/6/vR5LwUAHpg6peCKgv1a1pZ0gfx7/ngRNUTRyJDK0nC0AaKvYtBGasYhiw9aWCdrqv12CDVTd34BiOrh9ixqKVVgATVx8yth7hsTVJlXugvgwVPymkS36LmkfJxKbeKvYQjDugwSJpMPA0mEtq7Hgm5dvNP8tRx/R7RjfI7TdQBZgIEvlU+Ifx1J5UqyWZCzAuEsim7fDkx6x0SPfuADFu0/jqlleVSZDbGXaKa/dIJLrGRAPOfvY7xwCHIyqemzIK4m9L/dIq3WGhJHf65gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7kiCyma2xPUQLUeTPXj9V3XZG1rlkw2+oiEWx33jfG8=;
 b=USJMKYIbURVrkT1ViWBOJ88bpqTqigWVwtvSgw8pqb+i/SFpj+vv7tRyOwOhLJQDLFK2t5+iEcB0pcTPupl1cACwPd8fdMKMFpaptUCUnIGTtHSrZlYSpiObBLb97Mv/YuNNgxeHTuR5k3bPYvRbA+3PaZcEmmdeKI+Kh+XHGtA/GWGW6NDnVBQV4ivVSkPUBaH61XhKlG9BaYUijOeN7DUL3+nXIL4BRhDeWIGAUHJCuQCZ8UXiORGxntVgdtMMMJoTvRTc16V7Zz6DDlQIP+TKDbal2u7sisVdh752vfT5NdEV1cnyjScvMZXK32m97RxEkjqxeaDz0nRnzR6ORA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kiCyma2xPUQLUeTPXj9V3XZG1rlkw2+oiEWx33jfG8=;
 b=tv1pYrLhYPrNTaiRtqG0wQWnRRNbRxt41Bn58roYRiY+iX4D3QSMe/NF00Hp/Ve4gl4KTldhIATrTBDgCswjaNNKx8trcjtU26DmIp0zBzMV4DJgYQ47kNdigrbLZXXgh39495BNyiGdxXQl6/7jrSjLDoG1QesZgvK+3vayTwQ=
Received: from PH0P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::29)
 by MN2PR12MB4174.namprd12.prod.outlook.com (2603:10b6:208:15f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.23; Fri, 28 Feb
 2025 08:57:09 +0000
Received: from SJ1PEPF000023D3.namprd21.prod.outlook.com
 (2603:10b6:510:d3:cafe::22) by PH0P220CA0024.outlook.office365.com
 (2603:10b6:510:d3::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.23 via Frontend Transport; Fri,
 28 Feb 2025 08:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D3.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.0 via Frontend Transport; Fri, 28 Feb 2025 08:57:08 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 02:56:43 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 03/19] KVM: x86: Convert guest_apic_protected bool to an enum type
Date: Fri, 28 Feb 2025 14:20:59 +0530
Message-ID: <20250228085115.105648-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D3:EE_|MN2PR12MB4174:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ef9f16-b276-4913-5032-08dd57d5e1d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2/hhI4jUN1a/NN5uASfJXpPGBdW9mdHjOMxDArbeLwHgvPvnKJzO7JJmrUQF?=
 =?us-ascii?Q?GD8x9avVhZu/rvm2C9Dj9XLi0DhLv36Zg9O3nu9zRgwuA9Tt1NiDQs/eQsG0?=
 =?us-ascii?Q?7G9CGLvQGljqZdubCf3HM4oxevcqlbKFlPPyLyd/z1XGfjQTq3eYvnqeKmJS?=
 =?us-ascii?Q?x7OAKPo22AHcsrOvRSpKqINnIQyk/VZcevdzyfmhacb8zlMZAw9vs2/W43EQ?=
 =?us-ascii?Q?5DsHZHUKkHNZ1TmuuxM//UTceo/p+K3IlORljj1MoWu9cCfujgmaGRB2EEVz?=
 =?us-ascii?Q?NW5U/KV9XHdA0mkiI4904u6p5c1cTaJMfhZisLhKsZsOk4SuADbZ5QmldiXX?=
 =?us-ascii?Q?IlK4xr04hXpm6YJU4E4lANSyxF/Cwe/2DCEI14uNFrdSvXkau0R1nbe7No0H?=
 =?us-ascii?Q?8vvzS6EA9L9fW5shMvNu8mp9GgKi2vqV9hB25eT/RvE/mhOHzMorwDFS4U4l?=
 =?us-ascii?Q?20bxdaiQfzFWNJ9lgv9riCqSbeY4P+XFFCjps2Z3tO1T0B9y3rW/dtaj/IUr?=
 =?us-ascii?Q?VvjVvbiArBxamehba1Go3+PUftZH3ekTD+GwsmVKFYtvar2DP+k0AP9KNifX?=
 =?us-ascii?Q?NrU5t/KWjYULKuJCL6YIyQjznY1mDT5vmYGTHIDQ9XRW8ByfVVwo4I/ULxL4?=
 =?us-ascii?Q?VO3zj32kltsnrPo6RBzYw7SZgOPjB+u1TiO2S8j4HvkOty3z2/jMCoSyvLxn?=
 =?us-ascii?Q?hR60kkAwx9h1HU8Ohi6m/OzMboFae/+CLyT3SnQM5M+r3dqeMhs41Yn7v0vx?=
 =?us-ascii?Q?IUHHZZ8wDJQGZi4L5JDsa49KTKvYcmy/xTYod6AbbOTfSR3HNGv0CIwa3cy4?=
 =?us-ascii?Q?jdxJvkbeiOC4iL16n53FdFjMzdB/Ud0asU8PlldGmI4zXdcibc0FkDW8TdSW?=
 =?us-ascii?Q?MHFnlP5KUEaXeW1UZF22N8iCc+cYpfmbYM0rLw5ip2ZVazx8r3wU413gngby?=
 =?us-ascii?Q?fShqI+R0ee0lj+Zyi3WHFmuLHEoIjkYtKP4CrYTxyJW0QHFTYG6uoIKuA6sm?=
 =?us-ascii?Q?U2XyTkt1YWUiFYPvKoYTV73TagVOGJ/aUExUCN7zXvo00j+IQRXt2Qun2rzO?=
 =?us-ascii?Q?pkk2o9ES8DVHwNucY/4iRYrkST3Hkh/kMY4O7HkXfkXqIo2LRzsXhWAH02N3?=
 =?us-ascii?Q?+Ao2lGBtDyowdHntp+nGIl5grDjO5Zblcb/E7ORgiZMFe1X0/2mIEBOseSZM?=
 =?us-ascii?Q?NiQug78xNlE3U9NAtp3fEiECMStFpugoSDYV6bLozSZ3ekDTEhjTSnTF2vI8?=
 =?us-ascii?Q?4FwU8cDNNWzpEMzs9535VZX7N6bIb2TyErLV4HQEk6LX9qIcOdcibR0ZhWwu?=
 =?us-ascii?Q?bnoHs4nNNeFk469pkCaxxZa06EGXaGLh4gTboDxifBAfKfvAgnm1YtmSHxG/?=
 =?us-ascii?Q?sAWTVbmDLvEr04RCa+HohH9gAqAAID0JFrAzvYUzs/Cw6v3bFrkphsZDP+Qu?=
 =?us-ascii?Q?L17NpaaVPxWNy8aZ5CZj3h/36kc1ShqFZ11oDLBeYd4PLEIMlQlSJ9w7kKG3?=
 =?us-ascii?Q?qYXnHTy5JDbrXHc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 08:57:08.3288
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ef9f16-b276-4913-5032-08dd57d5e1d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D3.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4174

Convert guest_apic_protected lapic struct member to an enum..
This allows to categorize guest APIC state protection according
to the KVM interrupt delivery mechanism.

This is used to distinguish between SNP Secure AVIC's interrupt
injection-based interrupt delivery and TDX's posted interrupt
delivery mechanism. Use value 0 to indicate unprotected APIC
so that functions like kvm_cpu_has_interrupt(), which require
KVM to call an arch-specific callback to determine whether
there are any interrupts that need to be delivered to the vCPU,
can still use non-zero guest_apic_protected check. Subsequent
patches for Secure AVIC-specific interrupt injection checks
will need to use specific guest_apic_protected value.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/lapic.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index e33c969439f7..c9ef9bce438b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -55,6 +55,12 @@ struct kvm_timer {
 	bool hv_timer_in_use;
 };
 
+enum kvm_apic_protection {
+	APIC_STATE_UNPROTECTED,
+	APIC_STATE_PROTECTED_POSTED_INTR,
+	APIC_STATE_PROTECTED_INJECTED_INTR,
+};
+
 struct kvm_lapic {
 	unsigned long base_address;
 	struct kvm_io_device dev;
@@ -66,7 +72,7 @@ struct kvm_lapic {
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
 	/* Select registers in the vAPIC cannot be read/written. */
-	bool guest_apic_protected;
+	enum kvm_apic_protection guest_apic_protected;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
-- 
2.34.1


