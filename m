Return-Path: <kvm+bounces-39246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F502A45976
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:07:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 189A17A9BB4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1ED226CFA;
	Wed, 26 Feb 2025 09:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XBhZH8ku"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C136224222;
	Wed, 26 Feb 2025 09:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560821; cv=fail; b=NwQg46HqDuuXhOg6CfPEmFVnq5Yv1zeSFNq1wtuGyDtnY9UIMKYnjCBWgiU8Y50Hk5KXOnKjycEsYtnRIWxSv4ExfvV3KseWKX0BIoQ493Y370h8XNT48YjZxVZ1Wbe84ISWugKYx5mt5UiwiaVpIjKTVByycjVZs3y27v5T/QQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560821; c=relaxed/simple;
	bh=XivFbG9n21eQqwa05fzmt/Zn+cJNEcsotV9yPVWrwP8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBakbn0lHC+mcpBQ5pjfE8XZwmuMtpisveIh6Rar0pXKsBlUHcKDlw5GAF6KwUl3tehmTbfZy8Uj1rcwBVtNo2vArkj3US6kgY+JMih/vpnxxGPq8lxhtqbbvJGYCG+y/uWL3pGs6gWse5fqgONZ1LA1pD4k3C3ilhaveDmvd4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XBhZH8ku; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DhV4VY+MyPiO29LxD9E7rpc2t4M+xECLvH0+7f2wIoXLjs1GVZkcmcPyC2DabGgz5iq7ftj1x+f3sO7FztLm4cm8IPCUlp75l+VQ+RYrWY1JVkOL7cJgtdPxK0BmSEHOEvnJQpTvTYb5AGUvPOlg0Oja91cz6hkbPSuYG0FPQi4yjajOt4z0wEf7E+O77cWW3ivC5syEFTQQaKdowJPlYhMpFsmMkNDLmHpVL5qF0WokZwzkJw4X0hISyzeWQT67nKy0GEhgt7vFIWUOH7mkz9z/B3NfytDOopKsYe8Uk6b5ABo7X/sltyqcVneawIZf/GZXlm3IPk0QldYv/d+9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53vV5LTns57yYnQiQPZu5dZ3argO2heuRyLtysJtz/A=;
 b=T6ShfpRN9j0A39N2e5EeobXlaxXbWiwhTTxbRI8cR9OAkV2PiwwmIKwQ3KzftV4OPLqtq/0+l474sFoUJ/dTLZuvm7bWnigHeN6AJS+2csVWpdDWmaNWawRmybyH+TIFHZWqIWZmzt7bevW0hPuBXQ8YohF3QOFi03SPRTHIBWiOF0VZ7nvm2q+V6bY0EvxMw1SAYdTDHbSbHK8HEA6+HHxTi5E7jxlMb5bBwgRYSe15AlfnSltC7nN3OUJD5kzNR7Z5eK9SHNpo3RyaF/Wui0u1vjN5BULwqtANwyIlj5P0s3hM/wgJAVQsIMMkgAHLdZPFkTYlFyofUQLr55BaiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53vV5LTns57yYnQiQPZu5dZ3argO2heuRyLtysJtz/A=;
 b=XBhZH8ku2KNZjaSqJLOWTcW/9JDTizBBQxzJ4Gbk+mgmIc7xWIN4ZB6YQsmDeuPs7Yi4GfyXLL0gEOUuZ/kawcfb26N1T3dmzYHJyO6bfYOrhFJgPGWWWwBAefqoPDb9QwITonrrJ7G+aLFywSwEwkNZFN/zhc2NC313RDG9VBU=
Received: from MW3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:303:2b::31)
 by CY8PR12MB7244.namprd12.prod.outlook.com (2603:10b6:930:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 09:06:56 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:303:2b:cafe::39) by MW3PR05CA0026.outlook.office365.com
 (2603:10b6:303:2b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Wed,
 26 Feb 2025 09:06:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:06:55 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:06:49 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 04/17] x86/apic: Initialize APIC ID for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:12 +0530
Message-ID: <20250226090525.231882-5-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|CY8PR12MB7244:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f5d822-39f6-4314-e5f7-08dd5644eb28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eTHAp3QaTW5h1SYdrfAsNXl6o/0e0r8K2BFC4QtZRdwCqe0OOeBcIUSl4uE+?=
 =?us-ascii?Q?2mRj7/37lu9Z8CmdESMRJs8JWjoQuRDIm0ajjo6Oq8HZli5lS+NQqKw2Yaw7?=
 =?us-ascii?Q?5NB8rF7KfVEJWfUAHz06Cg+xmJ3UfYK7BxnSuyA7MNC+EXLHhS/ivWfGI46y?=
 =?us-ascii?Q?NzqDula1X2BoSR0Q7oHRJcoMMsrxYgU20sDPqRPkmsDorM+ps7UMBR9mkyP3?=
 =?us-ascii?Q?PZTv8fC02feqgE9opt9xlhAj63ofXxPK2cXdLVwCWVHg+/+cXgJxezzQb/Z0?=
 =?us-ascii?Q?LxoYY1ixBbbN/y9sd6WCC2RZviVBs2KlvQsujehzURclDtpuca5ndEwQSOAc?=
 =?us-ascii?Q?sJfwUapMbYMkYgxEbCfMccy33ZE7Fi3vecrBYDRRrGnl47WHeycxMAgirkIs?=
 =?us-ascii?Q?+ooBQyzNDMEDRObXwJPm8FvX6gHoQAXbQAJDxOAqkiDuSqOwZHVTOrZNA38M?=
 =?us-ascii?Q?79KcHwZ/WSZtKj/PdDQo2Vhfz3a+Cxz/vy7fNpj/vEMjId6g09DRVrOX0Yjn?=
 =?us-ascii?Q?aFHsBZhrp47lFJP9ayIIrgQMqjREWBPlG5QyIVLJHx/JHi6C5Q3aAU19vzcX?=
 =?us-ascii?Q?vrfX8bFqhEGK5fWfQbWWmK3NVq0zEifc1ZLBdf/DUuLkohrJ2Z8q5ATLD/F+?=
 =?us-ascii?Q?dWrEHPb+dZ3+b6P4gcxOQ8krtXh17zctkOYaYpHoJYUEHKoWCWzY9+4UNBUJ?=
 =?us-ascii?Q?0j8ZEbwdY5HlSyXcx/eFddn0ASBbkvAiEglC6HiIAvR/+9D5CWHiqwVDy1wA?=
 =?us-ascii?Q?qSydcqnUn3qR539CHzfoDVExmM+clkIB0QdhyH2DwY+y/A0kTMylaBIqJpxM?=
 =?us-ascii?Q?zQcDeU356J8ASy1r2jHwL1osrZ3FjZkdcmi2KbvRKRap2qjJk9diNbfciNec?=
 =?us-ascii?Q?QoJfXTMbNRr7E+UdRYw40imM4iq3pJV7cm7USGcea/JAA4JcUG6zyi6PzGYF?=
 =?us-ascii?Q?r3tAWud1Rj+pwbVXezir77v5JCKltAsFJFlrNXRv6AoSRqAWSQMITSN4/ILB?=
 =?us-ascii?Q?Hs0BV5QqJS+yW/2+ZxhSFtftxC5NY45fce17Ld4BiX8MLBG61J71RAM8YXY/?=
 =?us-ascii?Q?FxLQGhIT7A9uHLUHqGoGocaH7bJKzKRVJCtk4n+LDMpyuXjUjCF23/7DuzFP?=
 =?us-ascii?Q?PBsDRxuSl/reTafSm84J2Rkb7uvh6hrs+vaNSyceyDd8m6BpqNit0CHHv3QL?=
 =?us-ascii?Q?zPwRwiQ54LZo71f1OlniKNlYCcNIoCrSlwC5J52Hb5ProTq1dxZhCQyBDidr?=
 =?us-ascii?Q?k4TbxFaPw1j8ycxAvmnqc2/vGJS83tcQj7AJv/yw2tkj2jg1H/fuvC96Xlbe?=
 =?us-ascii?Q?0KdWAUCYjQGy4hkcr9U5zJgFnKmfRZn5plO22lGKyWN0gmX3y6jh0B4WufNy?=
 =?us-ascii?Q?syB6Yk3zuUJYDaahV3IvmZ2VTjeFQS/a2292J4DlQMyoAkvddAMz3eDMr0tS?=
 =?us-ascii?Q?BxmUWXbgKUeVwSxQ5DyLtN5qcH0EP502r80f/UFMz/1a5biKPXVfTzdVB5OO?=
 =?us-ascii?Q?PCmq39RTohLhRVA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:06:55.7850
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f5d822-39f6-4314-e5f7-08dd5644eb28
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7244

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. Maintain a hashmap to
check and report same APIC_ID value returned by Hypervisor for two
different vCPUs.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:

 - Do not read APIC_ID from CPUID. Read APIC_ID from Hv and check for
   duplicates.
 - Add a more user-friendly log message on detecting duplicate APIC
   IDs.

 arch/x86/kernel/apic/x2apic_savic.c | 59 +++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index ba904f241d34..505ef2d29311 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -11,6 +11,8 @@
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
+#include <linux/sizes.h>
+#include <linux/llist.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -19,6 +21,16 @@
 
 static DEFINE_PER_CPU(void *, apic_backing_page);
 
+struct apic_id_node {
+	 struct llist_node node;
+	 u32 apic_id;
+	 int cpu;
+};
+
+static DEFINE_PER_CPU(struct apic_id_node, apic_id_node);
+
+static struct llist_head *apic_id_map;
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -180,6 +192,44 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void init_backing_page(void *backing_page)
+{
+	struct apic_id_node *next_node, *this_cpu_node;
+	unsigned int apic_map_slot;
+	u32 apic_id;
+	int cpu;
+
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are
+	 * intercepted. APIC_ID msr read returns the value
+	 * from hv.
+	 */
+	apic_id = native_apic_msr_read(APIC_ID);
+	set_reg(backing_page, APIC_ID, apic_id);
+
+	if (!apic_id_map)
+		return;
+
+	cpu = smp_processor_id();
+	this_cpu_node = &per_cpu(apic_id_node, cpu);
+	this_cpu_node->apic_id = apic_id;
+	this_cpu_node->cpu = cpu;
+	/*
+	 * In common case, apic_ids for CPUs are sequentially numbered.
+	 * So, each CPU should hash to a different slot in the apic id
+	 * map.
+	 */
+	apic_map_slot = apic_id % nr_cpu_ids;
+	llist_add(&this_cpu_node->node, &apic_id_map[apic_map_slot]);
+	/* Each CPU checks only its next nodes for duplicates. */
+	llist_for_each_entry(next_node, this_cpu_node->node.next, node) {
+		if (WARN_ONCE(next_node->apic_id == apic_id,
+			      "Duplicate APIC %u for cpu %d and cpu %d. IPI handling will suffer!",
+			      apic_id, cpu, next_node->cpu))
+			break;
+	}
+}
+
 static void x2apic_savic_setup(void)
 {
 	void *backing_page;
@@ -193,6 +243,7 @@ static void x2apic_savic_setup(void)
 	if (!backing_page)
 		snp_abort();
 	this_cpu_write(apic_backing_page, backing_page);
+	init_backing_page(backing_page);
 	gpa = __pa(backing_page);
 
 	/*
@@ -212,6 +263,8 @@ static void x2apic_savic_setup(void)
 
 static int x2apic_savic_probe(void)
 {
+	int i;
+
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
 		return 0;
 
@@ -220,6 +273,12 @@ static int x2apic_savic_probe(void)
 		snp_abort();
 	}
 
+	apic_id_map = kvmalloc(nr_cpu_ids * sizeof(*apic_id_map), GFP_KERNEL);
+
+	if (apic_id_map)
+		for (i = 0; i < nr_cpu_ids; i++)
+			init_llist_head(&apic_id_map[i]);
+
 	pr_info("Secure AVIC Enabled\n");
 
 	return 1;
-- 
2.34.1


