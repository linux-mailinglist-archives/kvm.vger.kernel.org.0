Return-Path: <kvm+bounces-39255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BDC2A45991
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE27D16FD36
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 343CE2459EB;
	Wed, 26 Feb 2025 09:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pi8WBhB4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F0D22424B;
	Wed, 26 Feb 2025 09:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560933; cv=fail; b=rrcCItVCE6LXhBW8HPTia27FocAm03ZSzmnmSOGMHKqdhCkJUwvQG2urIg9NiASz8hAZeGFexGWwUVhxC9VEjiT7WVeRfRf/6a1wNX8ncOXZMNRHqmrTS9TdB5kCnQaBrXNN8+QZd9qFcbkARUxVOmGdmI+iOsG6KV/iDPYXnOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560933; c=relaxed/simple;
	bh=sBl0RcMRuYeOw78Gx6dpREqRgNpOn9GE/YSds/XKWt4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqGEiz+Ntj3Awu9GLayl56fezctrrpboyFYeW+F33lOv6zfvN1L5QQRJGA5+SWkUvYNAf22TuGND38z96PsKw/htzAGmnSok3apYX8PzOCstXM1GccxDUubXyebf8L5VDWY3fvCCh6pkXDmSLa3/FFXazmqQjVM2jwezo00h78I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pi8WBhB4; arc=fail smtp.client-ip=40.107.243.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rFYpyPNpoPX1iIFH1x1VD7PueMOl4ijVquh0XNq93y9Jqcs2RNQUaBKJhHJTdRHCgoULuDv+04Z9o0JeUHW3WhTVBDTyiKBO4RPnrQcpfaXkjmrYmH6qieAQPOfBg1toBIO6xMhQ6JOUa78NYRUPj/a8pSnWFyj/Zis0To271hqjVx2HL2BcRzwkGP3Wvd61VBpJ20CARFi0NEwgjCRPCYI38WvyOL/D1406jOaLTOkNb3ZEE2NJCaPMpcaz/75d+a5mvfWLam0+vpqd+fDHsoymVVNIX9fLMMXYkiVpQ5L8R1CNTc2zV1EipgdsPpLT8u4wkcJ7OLFBvsKklGX3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uer3ntKLa4e0LQw6pRKvjRqGZGL66TiybHLuDufDVuo=;
 b=AFRTEbrYRp/ZhnWxL6MNqAAFPbrHcdeR/rejkDDrT0qPhyKpxu7w6zCaukEyEVSVJeul0iM1Rlb/aCGYGdcLxfjr3kn6E9zn6NduEQjhqSfel7bCQTNZ/KaQ5HO8XNtON6Y8X6y0tLXvil96j9M1rtu0tCT0mJLFr0IvVJIJVZbxkiu2PP/GGE0slZb0Lqp3baCqcMuKf/B3qwb74in1qjDpvet9V44FI/S87PLT590mCRMX1eYD38Wwt2x06joz8BS5QAK/zpSYzNF5cmdOyBrCU3R400dEMtTRTl9fmfWDIdlcc0pK25H6HdXLT9nAUAnMMYyUTakLOHkDSrQ5lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uer3ntKLa4e0LQw6pRKvjRqGZGL66TiybHLuDufDVuo=;
 b=pi8WBhB4ZGnWnvxiTRfwyE9L4dNJHBHx5+F8GdjNGbZAgr1vAjitUJgQcOi45l/Wt+7VkPabqQQFi8vXRZbReRNJ81U0sAfwZ2MekvlWcyssvnAQNGMYNE6/WmS0kc8PasH+tOBUpYZ5DL1GIe7rpMaHgcHdNajkXW11bUvHEmE=
Received: from SJ0PR13CA0045.namprd13.prod.outlook.com (2603:10b6:a03:2c2::20)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 09:08:49 +0000
Received: from SJ1PEPF00002323.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::13) by SJ0PR13CA0045.outlook.office365.com
 (2603:10b6:a03:2c2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Wed,
 26 Feb 2025 09:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002323.mail.protection.outlook.com (10.167.242.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:08:48 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:08:42 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 10/17] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:18 +0530
Message-ID: <20250226090525.231882-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002323:EE_|SA0PR12MB4415:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c494492-8721-4009-0254-08dd56452e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TZuQ/fv2UiZ8Nx0PY3U2nhjt7Q2VRcShzGE7FWvaNSYn9R9zXHDXSh46vGZ8?=
 =?us-ascii?Q?N9ZZ592+K1Dtm8Vq2STxZEp8P6LCU9SJwK0lYTg1B1pVgVPUJT1h7nj5jbhy?=
 =?us-ascii?Q?Jw+k1Fc76otwRUeDYwfTc0dXVsandQvxsRzvIBOJECoiVXnfXI/NeNUs+KqW?=
 =?us-ascii?Q?1jPd9N1rXaJ0BPhJlHKam24g72lVVynf6/6YhISUAO+C6TdxBmI6E47Dkhq7?=
 =?us-ascii?Q?YRmV+HMOsMrVqo3dF0MlcbQ0LD3RlSO5Hm5UL6d4vfUCrFd4xGOr65qL7OW+?=
 =?us-ascii?Q?XNBhAO3iRejf+h/Sre9hxr7XjmEw6isvr8NeSUv70y3H5dEYbO15KWan8Q0N?=
 =?us-ascii?Q?kM6OWQ0++8lkbwRnk+6SZVU2qztb/fT00m29URMzOm8BkTeAowro4I5ACXjG?=
 =?us-ascii?Q?sAhHsOyGjoAWwgxY3eAk07AB6cLvjw/7PgLmhhI79NcmKKEC5pvt6q4D26bh?=
 =?us-ascii?Q?Zw7wQxcUn028dPBFIh+xOkuA2W+FpycI/Triybk6oIfIr802WJkphrotCW0D?=
 =?us-ascii?Q?GlOn46GFpbg7xlmrFKDhWBOpXPRIC50fyUPEAIp740hNA6tOlfwgLcMgLC+G?=
 =?us-ascii?Q?D6RzN5dbD2IpjiB2TnuFg5SxfjNmcL2OC+dDZV+16YOu806RF0tmCZ8u6BE4?=
 =?us-ascii?Q?FNSe7jeGG5d4M1afAzd9MY0Qxm3ySN81lvja8O8ZApL/194mU/6dwXdSs2gv?=
 =?us-ascii?Q?65po9s11WamIxNIyoh/SzpqdvOLBZfnax2kc5x4YJKIQb9D5Q3q4uErTJ75R?=
 =?us-ascii?Q?MWLTw2VogNIz0+g3+K7tdtBJmwZH9Tmena2LsOPoOZR49Vzu2e5oHc0wGAIH?=
 =?us-ascii?Q?AuusUEbjcKzC/KoskVzXZD54uVjh4mq4aB+DnuyBA1aiHpg3ZxBpGL7chu8I?=
 =?us-ascii?Q?8sFwBo5yzc2Y3MOk1M3KbMrBLL1a25750Bc6IXEt/ZbFBoqo11JHy1nWSURM?=
 =?us-ascii?Q?snQ1wROpCcRwACs8SHW5s/BDM0v0sIWBdyVRApqkBSe0cKQxdBTsUu6/U8Ia?=
 =?us-ascii?Q?QIopGDkgWHQt9i9BHmZpoQ8QX+CHjykYiflGLbFAdDnswXyoZL5L+2cFykc+?=
 =?us-ascii?Q?j+j0NIz0vwPEJFCZN1wFE3s8y+NdsRw8hvsPXvS1KiRBbaPlEBUsuRwcuW3a?=
 =?us-ascii?Q?dIqzjfZ0cI77Qbk1vH5cekvq8BmiICjdBytgIecIQaklww0z9UpIk16adO2Z?=
 =?us-ascii?Q?vINW92iJApYkm1ibkf8g6GkaLU+jNDnrP6mRDFnGmgwVndxctI0sGBfmJN02?=
 =?us-ascii?Q?ugLsaJEXjeTCLElhc5JXBvnBCEqzpxNbWqfnTiPEG1TaU4n8W8iOMCRcf7I7?=
 =?us-ascii?Q?3Mw0VY8MjIF7XXZq43PcYdyf5dJqy7G5CNNPvCG1QNqR+O1k6M85FHA3e0Vi?=
 =?us-ascii?Q?R6z2u4AXISAzcM7ACO+rEz+9N/ZQcsOyA7EQaTUjtctAy/VoetTXlm4+CWAC?=
 =?us-ascii?Q?CCjWQaSJVCOQ8DxWfLQYt2LMuvOvS++8Ja9+47dHNIqXBLWybsP8+1+CDhWu?=
 =?us-ascii?Q?jHP1gRNBQY4b4bs=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:08:48.5994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c494492-8721-4009-0254-08dd56452e67
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002323.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - No change

 arch/x86/include/asm/msr-index.h    | 5 +++++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a42d88e9def8..a2dabde0d50c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -687,6 +687,11 @@
 #define MSR_AMD64_SNP_SECURE_AVIC 	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 0067fc5c4ef3..113d1b07a9e6 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -34,6 +34,11 @@ static DEFINE_PER_CPU(struct apic_id_node, apic_id_node);
 
 static struct llist_head *apic_id_map;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -401,6 +406,7 @@ static void x2apic_savic_setup(void)
 	ret = savic_register_gpa(-1ULL, gpa);
 	if (ret != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int x2apic_savic_probe(void)
-- 
2.34.1


