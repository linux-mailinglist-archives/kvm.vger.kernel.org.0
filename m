Return-Path: <kvm+bounces-48841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26BEAAD4192
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21F303A8CD3
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80072246799;
	Tue, 10 Jun 2025 18:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nqUvMan4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4380F24502D;
	Tue, 10 Jun 2025 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578640; cv=fail; b=LF2v0MIJ1b97zBoDlIHSU6Q+AhYlZ1qMVBl4sQSWiPLyG7P9aw5zQXT6pmhZhP1RexYgA0S/geG3G8ZArhPIjF80zOtyMX1zK1SE6dAT7HQYdRt+5M31Ns8biACYHsXwHH3FdXR3yRu5daOn/LbEaEIDuqesfHBYUWUEpP7wWfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578640; c=relaxed/simple;
	bh=fb+aveKrE6saBIPmbYl4XGc2ta5Js6z9cMiwtlxs1fY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HhxPHVSAm3k1MZYIBwuofQRRe5UKadP6DR7O0f+VfmRkjxPENiqosou3XGaYMeUREnTgXh3cPzySGZDWnyJuHM9VDLkC/nzYa6lp2jdfKqSgDVv3UBxWcMDIQtHvZgz1Pq2Ygg/FC5oj7ZAc2qzw6scqQe7uJEoRpcIOXNAJmwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nqUvMan4; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGJiJFndvRdxbT1Csa0xqJV5WjxjQwINmkivu7szDhTir6fUNb+CJ00HHlawSrfVksuZI19OtYm/yUyHU0Hbm3xEfnKToPtIifJ62RCrorxxBq0LD1eRXDkRfO5ZU/q8xpkh3Xz3XPRRQ4Zq1rKluWzoYX6ROE4wgzk3BU6m1PTYTkqcBQKEZ2NKoAbJZjsB2xvZodiuYNDbkP37fzz/zB+HeT91KuQ36eD1ERj39WK3tD0X05unlAtQ3GXJM5enLYrz8MBdZ8jbPbpqSolkZ/5oS1fjHH6sS3qVcU9cQlbCm+CYPWd/VSfhJbJX/m0ADHZ90EaKhS81stdUd9b/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KV788CsukQ9Mw+BHiK7OeTrN8oEx1LVo0iMkWQA/0M=;
 b=bUZx1CsOfCuhqpoC1OJJPH795+olQlRZu5BwcEEKf/6//gvE6ib9zXtCsZ57JjAlVcrDIXpwU42CRK9LHGuWHHL3GaFL9IlU5/sEytmr/R1zOXC24mP4cdEcU9NPRCyKZ4bl2ArW8J8xaFDzts8utHq8/3doIh7h1ZTRADMlbTNY+lHujRjTLxdKxWur/N14LG78p+6nKcE47QrnIo+tbXyE/NWTwUDSMehcbNeQPFhjg2nQM8mazYDbal360S3FLVNu73ztFDegA8rks02bVsH6/uZltMyA77zUxxq+ZAh7/DOhWw7HssfKlaXvC6O+pfdd77uKN1CQ9pkCZ5E+kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KV788CsukQ9Mw+BHiK7OeTrN8oEx1LVo0iMkWQA/0M=;
 b=nqUvMan4psz2OQRDq/w57wNxBE7FJ5qQ5Xzit2V/ETTXOwNXbFAD1shMLvVjgwbxfjlzvvKFxUZgEWXt02paIYbovLIXTXN9x8nqpeEJGfv+843QWfe8BJ+RKz+jTIMyhhxBkaSUdpAVSXYFWk5sQAchLQpSehjR/WmRBH9vWuI=
Received: from BL1PR13CA0419.namprd13.prod.outlook.com (2603:10b6:208:2c2::34)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Tue, 10 Jun
 2025 18:03:56 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:208:2c2:cafe::6c) by BL1PR13CA0419.outlook.office365.com
 (2603:10b6:208:2c2::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.16 via Frontend Transport; Tue,
 10 Jun 2025 18:03:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:03:56 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:03:48 -0500
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
Subject: [RFC PATCH v7 25/37] x86/apic: Add update_vector() callback for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:12 +0530
Message-ID: <20250610175424.209796-26-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: 503c9146-f849-446b-c016-08dda8492af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ehJIsNGT3V/+7qj15P8yBuzX8/mFR/2Yliw13LvrGoqKbQAYakt+s3oZnMWa?=
 =?us-ascii?Q?5RT27YXNwhP6P22yeYPoKtQmS4U3K876v5cufjPE51TYLkTECIp6BTNZfe8E?=
 =?us-ascii?Q?QZLDRmGjjchAgyC5TvYjPn4PzA/YXYtjTgZENcdBvxtfLnECfv0TKR+klLot?=
 =?us-ascii?Q?r6NAyHjBtEsCDO4cPDlgjufbi/fdk8Nd/QOPjPTDQbyjy5Dfs3sjJE8vrPcT?=
 =?us-ascii?Q?FH/muQMftkFzTH6wAX9asmdH363fH3kyoY4hk340bDA2qiiYs7czCzQ8bJof?=
 =?us-ascii?Q?O9PhY3Xj5iKC/l+3KB4WA8nZzTCW3aWSdkti5uRu8D3q/DfcEWA+XvVxiwyB?=
 =?us-ascii?Q?4uKTeLDZPTKEXZfIh4KDj6tYe98hTaIq/vUhKcS28cw/e6jBx6LtAmLw5g0z?=
 =?us-ascii?Q?Pi4yzexvjTDw+pVnBbPK0LOU1Hf9NmHCNUQrXKIjY/bTstFUWfZqJqeBWGUq?=
 =?us-ascii?Q?qCEsSwB9nlWUDb0fQTDXCoCb0nY2AyIO75Me4llJTzr+eSKzQ0RoX3BZxgVy?=
 =?us-ascii?Q?kF62rom8IKSC6poGFoxtPEaPtLln6MsgBLh077oBmlj17VdwpUEHiIFOCPqS?=
 =?us-ascii?Q?yYdyOtIsAnlBz8a8GuJPgtC/8ANlpXlBF7mBZ8SYMWEERs0qjNpS58JmDVWq?=
 =?us-ascii?Q?h38ua/JQt+bTRpxuxK4rt7o/JK0j+T7VBBwMHGhDBY7QSwLVtCAKmk4KpAUK?=
 =?us-ascii?Q?ayOVkY7/jrQptuiUXeIoKjVzBFW1yzaznwCyrkeIkKT4VeVYdjv/tUWUO+vb?=
 =?us-ascii?Q?s6dXqHX7kAqhwivJVkKic7qvdsog6LrbtMHxzXeJatwoAsGoV8aEb6l+xprW?=
 =?us-ascii?Q?6Qi3AJ4xhwbzsNxTotvZaaayddAy6Dxl54GeW1EpAgC7NAnbL6JkG+QsV1Qy?=
 =?us-ascii?Q?ExklkeenVvsYZpWLPj61iJvEXYUuuFpSgO6YXCcYm2cYD7J4L9R4EW/swcE7?=
 =?us-ascii?Q?vAgzu1q0661o6tEol8vDEnZuZ+NjfDC2rhnlbUVpoDVoownYLBqJ8giO08E6?=
 =?us-ascii?Q?9VXRD0zp/67tuVvExbCAxSMzl1oZZ7ymZRvk1U6zl6+ZOQDmRUwJdHlBCSXI?=
 =?us-ascii?Q?QtrGthtji4+yzW+j8R62RYf9dw/r3RivJKcUemG1WMGw9qo0HX/5KXJRYExT?=
 =?us-ascii?Q?HUnb0TEX0dYuz+iLlhjU+9WkNuSr+jASVKfWOSM/7h8lrir4a2dxrIuNK/kT?=
 =?us-ascii?Q?k4D/fILoOd/xClitEfTZCy8dmOsdZxltFz/27Oy9TBTZ+wEjF5qfdeK86aEP?=
 =?us-ascii?Q?NtOsXtZTH2ayVCPJwC9iza0vox25+nWqsnCYjLQifDgnygVQ/f3jCoj6GMg5?=
 =?us-ascii?Q?EOve8lJxsa5Sskm0KjQa+IpMPtIfsZxyr4Cy+Q4bDOlh3u7t1CqtqlH1ScUI?=
 =?us-ascii?Q?yOCQqiEJybBZNFRgQ9KdNp1zWyyBv29qpO764gcwg71+Pf8DLEuKWPK4RVVt?=
 =?us-ascii?Q?FBnu+MId+WdEBGuGhPXbBY4y4HR3eg0LRwTADlWEAKGVbhFqWK5YihBhkwAU?=
 =?us-ascii?Q?tJbSW1J2gLgovmXPCHijqKFjg7a9mC2sKcqW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:03:56.2995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 503c9146-f849-446b-c016-08dda8492af7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

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
Changes since v6:

 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 618643e7242f..2e6b62041968 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -23,6 +23,24 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline void *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+	return &ap->bytes[offset];
+}
+
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	void *bitmap = get_reg_bitmap(cpu, offset);
+
+	if (set)
+		apic_set_vector(vector, bitmap);
+	else
+		apic_clear_vector(vector, bitmap);
+}
+
 #define SAVIC_ALLOWED_IRR	0x204
 
 static u32 savic_read(u32 reg)
@@ -131,6 +149,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void init_apic_page(struct apic_page *ap)
 {
 	u32 apic_id;
@@ -212,6 +235,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


