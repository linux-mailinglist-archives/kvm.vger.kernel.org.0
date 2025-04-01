Return-Path: <kvm+bounces-42310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7CB7A779C1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8761B1886DBA
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626821FBC90;
	Tue,  1 Apr 2025 11:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3as81OQs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABAF22338;
	Tue,  1 Apr 2025 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507591; cv=fail; b=Ubc6UYyUGRM08oTYc1LlG/rS5o31nJDOtKO0g1Y5BVhb7YzNftfHOGTlvTA7enOoLgx/11PVt4MjOjsXBdXxfn2Ro12l7JVouATp/6zjkh3AWK7nDu69V8GC7vmcvizpCjkAs/pPm06zXpEQLP1NKx3c5ENlPCXN905xGVPx7gU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507591; c=relaxed/simple;
	bh=/856IKy5YYwRfAHyhKCAH1XB2KfgKx2c8k/nPq4YhfQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UW/8kvKHmB0IuPEYEEAimCTRId+4hI0NEhKqXhpF5sRVmwBq1Crd/+cbz7JM0+LehiKNZTyWEc7tGBl/D7nF3wEp4+nsv3toc/3WL5z4QBRz4DEyllrLjGJy6w05Hkrge9LAOOfcsUFaZWOt+vJLmgMN1okya2oDG7K8IyL8MkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3as81OQs; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NF1OzSyODKOGCynEm/2ZUYyLPT+8RN6XOwDCvk8cL3zBbB8U7tAYAcd6T2D5W6kpWBnTAv/qp5dUHxIAboCGskmbsUgDxDDnIxmNax3X0CFfehEHJJoRksgHu5V/wZAIa6vzkiUkByQEdvHtoMCSiN6wiPrOg5vaSu53tqO8qxmrZmx7guge4fMOvPUcQ1qFyudKY/VklKLhWnu/Xj/8kSGD3Um7q9xWECudScI6RLLxUw6pEQZdjvVYAJsbheQ33PMStWYdUViJekues9A6Um0R5aE2dummXqTrQj1o3EP/qlHigMjVWfu3ytDm+7xlsZiUmdvUaxcxkMd15yDVJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjHOPdk1N/YuL1BNYLcbP3Gbx5Vvam3omQ5tMBiO1DY=;
 b=R9YKQx2vmGUFhlaHfjBT3h24LPuwE8oQhFCC9KccumYr7rd/rbcSXLdCQr0SE8nfFhC8aCX57aSkPWcCFRgjVdCgv4hll0jEFaA/LfkTsdWi2NwzfM4NzYFgZOWcWJ9K+28GYPs+S6bSAbtmVkKcHs38wah6BHwM43/dHekcx/GRflVYTrA4uD6Pi1lMaXu6SXR/1TjWz4kcRExLFuu2VhjF44GGV/FAesqsoZjpuvGV1NUJpd5dWpvjFRjSAS1WqFnYE+Ry3hJRplFu/K+yRNgMwuKR0tb4el8xh5BUhVkKPWAzmqgpdsZrhe5kxt9LgTduZ7dg65VvEQepA250zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjHOPdk1N/YuL1BNYLcbP3Gbx5Vvam3omQ5tMBiO1DY=;
 b=3as81OQspGlDqFO08PAPI5ILUKmlmjtusE9HloiKBI40IPYQl7qyJl+RzmKqK+tyEiVzmr457kUKfmewa6YPJ6urRhVekMTZs38M3YuY3STcF4toNydBccyL9XHJ6N75PcV3w6NzBNwH6mQO6MXAqIWw7VPxkDc2LpesvqZpoDU=
Received: from MW4PR03CA0167.namprd03.prod.outlook.com (2603:10b6:303:8d::22)
 by MW4PR12MB5665.namprd12.prod.outlook.com (2603:10b6:303:187::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.54; Tue, 1 Apr
 2025 11:39:43 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:8d:cafe::77) by MW4PR03CA0167.outlook.office365.com
 (2603:10b6:303:8d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Tue,
 1 Apr 2025 11:39:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:39:43 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:39:37 -0500
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
Subject: [PATCH v3 10/17] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:09 +0530
Message-ID: <20250401113616.204203-11-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|MW4PR12MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b8fb8bc-c682-4419-cda7-08dd7111e599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JUakAc//bJBwfpcV6DdOvdludl25QdBDfGci8N8EB3bB7/waWj5Iwj59VGQj?=
 =?us-ascii?Q?QnFq70osrRa3DxM1DET9eVVYcLWoV927wCFQMGWlSiLZFV8Ov8riGk185cg9?=
 =?us-ascii?Q?bxjq5tgLehSSDcze1j+owjqCag2wAGyfLgKh/nXuiAUnqeKoUysWKyAIrTeu?=
 =?us-ascii?Q?gfyYrEAD/8HRmgx+WAoANKgxK897oGkGt8zGfb9cUAeKWbfh7uJfYSCKbx/l?=
 =?us-ascii?Q?qcOX/UJKbHb9zcavqxX2cpfNU3JxCC13gaW0xD1fMc0xV5rMKVL45KE0lmij?=
 =?us-ascii?Q?sPWuzEKglGg1gRlcgU0wjJ4Bq+SvGVj1TRlls43s3FofrwB6FfUq/uAyCq7O?=
 =?us-ascii?Q?+yN8T2MdJtCFT/HqPXNIaQoB8srBFVj6hubJcmYtsbyZylTGhTyrbS0Y2+KI?=
 =?us-ascii?Q?kKZbwVL1A+WpADZz0vkJE5wwHCEAXFb3yoAOMeaV2IGARIuViD8in4b/7qOg?=
 =?us-ascii?Q?I6mbyGth/GNXRNVFpsj7Vb4FixGMZZmpj61fv1F3GDgk+S1YZSBmhoOgh3hA?=
 =?us-ascii?Q?xqwiDzwTz+8Rn8STmfq2u5yizXMnvKWZ08oMAXfZe4SZZxhVHhfROnlG2lha?=
 =?us-ascii?Q?fCm5jwmFCYWQwJX4STz7bUbOVJkFRPEOVvaIotgEb6AbObuSJIi22cmCh98o?=
 =?us-ascii?Q?WHO0SLm7hGozv8SANgRtNsdx+XaWoEmttgWV7dWm9ROcaqtQJydMns965A0j?=
 =?us-ascii?Q?lrXUhgGZIXBFlPFjeev1mkYFlC32RjozkJyTUA1I3CVZCOW2cyg+b699axDp?=
 =?us-ascii?Q?hXWLoW37ecO/W+1FjkEG5Uwnh+2JnzSmBMfgIx/6bL0QunV0lqvfxlbTC4Wk?=
 =?us-ascii?Q?IS0bvPxYfyDSMMEoRilPSHvoU5jHYc9u4PSt0Ts/YYPfv4AYejD7FTsOk/eI?=
 =?us-ascii?Q?YCw7K6bP/o6Ykg2tei0BBOUOGzoTXkGbT7/kJQFdmoFBmRALx3Qid3P6VHzw?=
 =?us-ascii?Q?zZoL8gQ5m17/B0jMqljzRj/hhoogD+SWCI6nFsPndLRCh+GP3MgLLFiC0uGv?=
 =?us-ascii?Q?l9nDLAjdBAGNso16eM1n879z7F/tnX3MtgzoxDHW8w8pCIQiktk42xmjYtYX?=
 =?us-ascii?Q?1ELcCsp4xlDyuc9zLlRcu0MFz6CUnjo3nda3gq4Zt5haE6Oom7U3HTF3DoVb?=
 =?us-ascii?Q?Q1hPsptVN/JaOre6kXmWz9RfqRvkF4NQPDJxBznlUkmOJU/fHuXjuVnoeejY?=
 =?us-ascii?Q?3Xfr53s7e3NB+bMismIRLKlbQ8WH+cRbRYZ96vSp/LqkyeqYZp7TE6S2eof9?=
 =?us-ascii?Q?ykNEXyJN+6PNVCPcLNBAL+J4Pfh8VNvxt2EHwil0DjiuetHhAboIFLrKYQZD?=
 =?us-ascii?Q?e0oFSWuhiFnt/xmGeWm6vWIJ71ivei1R+t5XGCPmxQ1ke8BHZMr0TqfD2u0S?=
 =?us-ascii?Q?ro85viKufhXCaCpJO+zpstWS3O4cCo9chPrViIDVR1y/NCEZ5nFkkGM6/Tui?=
 =?us-ascii?Q?IwBK85KGsBKUT+F6GypKxsvF9KAABnLLlmu8s2GOHomvrcNuvj6KIOoPvAYG?=
 =?us-ascii?Q?L+IiA7u8stvVybM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:39:43.5445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8fb8bc-c682-4419-cda7-08dd7111e599
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5665

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:
 - Remove MSR_AMD64_SECURE_AVIC_EN macros from this patch.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 0090b6f1d6f9..28cec4460918 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -689,6 +689,9 @@
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
+#define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index f2310d90443d..845d90cbdcdf 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -29,6 +29,11 @@ struct apic_page {
 
 static struct apic_page __percpu *apic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -349,6 +354,7 @@ static void x2apic_savic_setup(void)
 	ret = savic_register_gpa(gpa);
 	if (ret != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int x2apic_savic_probe(void)
-- 
2.34.1


