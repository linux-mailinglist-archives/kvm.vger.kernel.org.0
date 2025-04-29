Return-Path: <kvm+bounces-44696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 889B2AA02D2
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAC39163E64
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8525F274FF8;
	Tue, 29 Apr 2025 06:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gOTbLCYx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0624327466B;
	Tue, 29 Apr 2025 06:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907219; cv=fail; b=KcVzkOJDAFq2xcc0EWnCGDW6d5Bh9/fw7FckjXayuGhfvx0Ht/DdkwMjWh1gDLe0AMVlveNyupyDzFvXSNsnJbrhxOTfj/EG/tJAa06lNvFmE1TfGZ0lWp++0y8zztYMjU00hnlSHgfo/tGOw3fP81EVgbeAIDksFC8V9DKFz8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907219; c=relaxed/simple;
	bh=srF16KdSj2kgtm8RSI2RVkSeg6DVtXeNWhyTNTDwpc0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1VpifXbV6UG+DrzGk3nrqtyVODTA5+1pRGOC2lP1MSn5fcVRHtwHMCO8hNasbGs5GIXlDHdd5FjnSIULVwCuiAobzGzLayQ7XxkaDq7knuHP1PlEgxBiDMk/yjrQItWV1X1d+McUHLPy02LBoifYeamJ9cWX5qP75YO/iL9N/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gOTbLCYx; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKlbj1DDGz1SA9gLfjkVPLZC2eJtqkZ14o1vFVyMpdHTFGStY1BrBU2abtBH/jOy9TmWi3lWOyLDAsTgWOst3e3PcnN2D589WBoBLXjfVxE1yKjLIfXZINUfsaFXal3muqDOjPGToaN6zMulRGtxx20D0QvfxMQYkrIG4l14wjjcLq4f961aqGVvnOsRPQvWE1YxqITVt/jcRwCoKiI/B7tNg6Ft5ieK0isKtRCQcjA00gG1UYM0coPOZ+KL+QXUMm84xBTNTdFjMA61gTWHST3o6kQI9AlpWq9ttHshNrUcOMz/XMVrfwqXD0RFmD0bYi5sm/ENPWX8IYjfJinPWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+PWd6AgBw5blmdjkuIzrNdcmRiYNUMa4OdsgJcXMgw=;
 b=gWLVjF3QKNECbsiDoAhtNI1JmMiy/85C0NIANG6/orANPhlqYynw/ifEbtyOvGaRFSZyp+ANvp2CPSSM1/gYc5vyZyB2CAuRJ5q/9EThm4sdTDZwCZJKd3sdl6bd0PlDrNnqnoDEk6M/0iYOqxr/DtHMWUGKcYpGR+4RMhvf3ziHTfWOJCK0qkjNV12xkuP6LjcxXwfDvqJw9QuMa4sjfnj5bqAgfq0AKtAcCVdNFiXT6JMDrD9yM1Kb5UKRUaPr8TgC1wYdHgaBzhLbjFTa429eROnTRU9TjgWU5377Xn+jHYu6IPnKEWaRcvSaxkJphDZroTigUf+FqKdKhiYNlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+PWd6AgBw5blmdjkuIzrNdcmRiYNUMa4OdsgJcXMgw=;
 b=gOTbLCYxGF67T1AbRh5F9aKFe4yBVpzyzdtptl+kUwoXea7yOCb+SYdYNLEFRLhQU8Dzs624DNfOoS3ZTDSdIijK7U+FsegnWhhbeaQ++zkLUwKPaOMVvl1cJCFc6b/07NeX7ceyL9o9gFtqcI418fq3WQgOi1B9uBvGggPRp4o=
Received: from MN2PR19CA0044.namprd19.prod.outlook.com (2603:10b6:208:19b::21)
 by SN7PR12MB7347.namprd12.prod.outlook.com (2603:10b6:806:29a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Tue, 29 Apr
 2025 06:13:33 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:19b:cafe::3c) by MN2PR19CA0044.outlook.office365.com
 (2603:10b6:208:19b::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.36 via Frontend Transport; Tue,
 29 Apr 2025 06:13:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:13:33 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:13:19 -0500
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
Subject: [PATCH v5 08/20] x86/apic: Add update_vector() callback for Secure AVIC
Date: Tue, 29 Apr 2025 11:39:52 +0530
Message-ID: <20250429061004.205839-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|SN7PR12MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 49fbc694-bbb5-4938-7bb1-08dd86e4f836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F9NTga7PptbAIG+TKed6zgiuwOuldVu/Cmq37vIXsDeQYc/tF9kX6/lQEL5r?=
 =?us-ascii?Q?N6rBDNwOUmDy3lLALMP5ulqjzPtmf2243f9osQku+NCzV+N2p97akPG+F28A?=
 =?us-ascii?Q?j5eVW3yoxlGFZsvs3JJB3ZBN057GXOXagMENEPOspPW6i26Y05nD+ezUV7Iw?=
 =?us-ascii?Q?4FRyw84AKeutlUmCXtRxh5COqMTC4s4i6AHZfmE1lzcs8t6/EZJQ0u27OpCQ?=
 =?us-ascii?Q?iyk4i2DiKmTbV5q87Ima36+oemvxM5BEYHZ4qiMEwf2S/4j98w59po9ITDdM?=
 =?us-ascii?Q?7aouNvy1jggofbaOXIsl9pML9gyRYur8l3zdRkRRdih85tKa7OZlTfMxodd/?=
 =?us-ascii?Q?3jrc+S6wHokkhfFz7fB4nTziaysac86MHjAXa7qEKXI2GIYkN2XECXqYqlXZ?=
 =?us-ascii?Q?viegYPNUet3w05RmYSBm4TPn40o7tsBr6WVuIvgLfz66G6NvreA0TlSXKMEV?=
 =?us-ascii?Q?QcKGY5Kmx+3VpYP9wr5ckK1+QCDhKY1LFXylf221Xb3BBQsApOZODI3gUfMp?=
 =?us-ascii?Q?GEsyLY7QaPnt1vbRr+PdHxrCSa8/dbXv5Q145nKi2Qe7OgO5kUgGDwzhHj4F?=
 =?us-ascii?Q?H8KSqw8KaEyp4hkQplbI/mufgco+Gp58ciR5gx96VhSGpwRxwwqwM3GzivP+?=
 =?us-ascii?Q?q4ofeB7rulosRHfqSESx8JTVFi04PoEqdsYptTUaO/DKyV+9wr0ufYtHufHX?=
 =?us-ascii?Q?NKb0A5rjYb7DOBhVd7enQWpC/jUXQ7ynIlCC8gEi1PNFfPsig73BLJREMlDX?=
 =?us-ascii?Q?zZ5GMheNnIhSx5v3OMUOzU+aPjbxfPktpusU4iNsbOWQdbqWM4OkpEymqioA?=
 =?us-ascii?Q?FdmKGiKI9pgtvFFQN3EvVZf9qqUMBK6UBhbN2kH+hBnxarA4VT3bvfTHwwZJ?=
 =?us-ascii?Q?hMcIxm4WBdGH+B66huhNbpFE8BB0vkPssONlzjS7/t8ixVAlGuWvA4ahxyzv?=
 =?us-ascii?Q?yNqtf41pOKACxYCLNZjPFQF+h9dfc5qClbLgwwJUZooxla+gSnxf2lgLafNQ?=
 =?us-ascii?Q?Bmu8uOoTORWGlWmMHZC0zzq3J0LtloNqo7MxZwiMiuKROtx3tVgNgHPJV9pV?=
 =?us-ascii?Q?HJgz3mMLmHJQ4sO4q+X9vBd2l8O2bH5Ra8fQX3BLF+sBLcq+OQuZ4yHBCy5z?=
 =?us-ascii?Q?eYh7lyKreEioKpa5BDiaPKYYkYb5hSQXMSWFXVrbtXKkHUFQk9n2uLs+NqHp?=
 =?us-ascii?Q?k8MyaL4qMIpczn8WjlwHoJmEB1Fetd6DLNsQM6vHharWXkxDmuUi/0LE50sQ?=
 =?us-ascii?Q?xn6MI5y/7gkQGTb93zkHOgyT4SLgksJit/dasiQdI97roSBliLcjYVqNjCGW?=
 =?us-ascii?Q?1eJagOQuWmoFL55RZxKLF0W4jiaZR8RshYNzc8unVnTau7yG7o7c37SN9xVN?=
 =?us-ascii?Q?tj3qxOX/ypHzg++8GWJJ0F4VFA5lm1GHxgxzOgPdzVDGIfSBno4761gaBRbW?=
 =?us-ascii?Q?Cl7d+0odA+UtZiRBuNnRLMYlE/cUn+IBNDrDyiiDt+tenRSL6gNlCu2PqIUE?=
 =?us-ascii?Q?36D6UBBEqD619ScueNtg1eOWi69C1ct202jy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:13:33.1021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49fbc694-bbb5-4938-7bb1-08dd86e4f836
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7347

Add update_vector() callback to set/clear ALLOWED_IRR field in
a vCPU's APIC backing page for vectors which are emulated by the
hypervisor.

The ALLOWED_IRR field indicates the interrupt vectors which the
guest allows the hypervisor to inject (typically for emulated devices).
Interrupt vectors used exclusively by the guest itself and the vectors
which are not emulated by the hypervisor, such as IPI vectors, should
not be set by the guest in the ALLOWED_IRR fields.

As clearing/setting state of a vector will also be used in subsequent
commits for other APIC regs (such as APIC_IRR update for sending IPI),
add a common update_vector() in Secure AVIC driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - Moved Secure AVIC driver update_vector() addition to this patch.
 - Commit log updates.

 arch/x86/kernel/apic/x2apic_savic.c | 35 +++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 81d932061b7b..9d2e93656037 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -43,6 +43,34 @@ static __always_inline void set_reg(unsigned int offset, u32 val)
 	WRITE_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2], val);
 }
 
+static inline unsigned long *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+	return (unsigned long *) &ap->bytes[offset];
+}
+
+static inline unsigned int get_vec_bit(unsigned int vector)
+{
+	/*
+	 * The registers are 32-bit wide and 16-byte aligned.
+	 * Compensate for the resulting bit number spacing.
+	 */
+	return vector + 96 * (vector / 32);
+}
+
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	unsigned long *reg = get_reg_bitmap(cpu, offset);
+	unsigned int bit = get_vec_bit(vector);
+
+	if (set)
+		set_bit(bit, reg);
+	else
+		clear_bit(bit, reg);
+}
+
 #define SAVIC_ALLOWED_IRR	0x204
 
 static u32 savic_read(u32 reg)
@@ -144,6 +172,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void init_apic_page(void)
 {
 	u32 apic_id;
@@ -225,6 +258,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


