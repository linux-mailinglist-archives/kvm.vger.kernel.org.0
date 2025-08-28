Return-Path: <kvm+bounces-56091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B224B39AF5
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFA0A1882C49
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55B630DD1A;
	Thu, 28 Aug 2025 11:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FN8RKg99"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F17514A4DB;
	Thu, 28 Aug 2025 11:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379072; cv=fail; b=uD3VecBpUpanbjzT3/xl6gFi4a7QA6PAAvarV+sxAJSSX/BHzD2ckIN9fkxvDF7tFrvPaIQwNpX4VQGBiv8hGksPAPMpnvfnaPKbmCm+LYgKQu0ENGBEklI39KB51WSI8VQsaiuJNb1KRzIe6tVrNHzHq6ZVFK0t7kxqwWa5Fqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379072; c=relaxed/simple;
	bh=jj0Ds5ZuXOLdV2wC7uwnVjsQMJJ3SR+8vqg27dTLmec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+z3ilbyuHV/9UpcvKw1+XQO6QK9tMrpfp97VBswVoW6EcbY2SfAvUFukJl9jCmqd5+DJ8EeF3vjXN8vUY/Bht/8T3NYwbBfUgJgeaNuVqqgyFaZI/8GAwmmHMRQRC+dUDMYOqE3Lr5VDXFf+BACA/ClwAqmeXm6NUYBqEbJHCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FN8RKg99; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mz1zyL4cSKpyKxrBVXYNukQlVWXk8IHSTKG7wmED1hUELIt5fgZ4rQQJl5kyGJPzB0Q4eVcitTmddC9e4WcP2B8unKdVN1aN8/eq7kJAqXtIiiCjgjEmOiA6i9G9OcYVIctDiB+ducl7tDHqLrl95C4HNrvx6yjp9ErcxKGKJxSi4h6govsISkEeU/351xFaIiHl6dUM4KouSPDgisL94YZsIZ5Ezbd2sy1CDO0/PXpFC6OyCXLoECstD+msLGGEiAUYpS6fcMO6pmZWMxvBQvO+8G8eCbZ5LQJRCHd9E6TEbj0R64mAN1+2s/QWPdRmrw82hUZHTgiDEb+tgcQuKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7EIUX84ov2kovhOeTWKUvMjTleFw1LGowFTLhpHh18=;
 b=j9O5VK2gmIQr8ElGf1Qn/rkzSfXFPFObjhWevhniJlAM8pg1v7i7q4Yukz/cygTE8JspEiAFR0D4az5LBv5V5TPSsVeQnlHUwCBwgeKulPCSI9RmXHEZQYi6xk2EWn2BkywVLZNbdMNLhlL3Zfbqq5l9LAYouCGr39xItRI4Tm4ZvR36iJ30MvbA0bR6hHQqDWWl6zo7XyCF1TBTWQAzhWeZDujc7AHdL26kTuwNKbpMnEFevtGcyqtDHjTxn33hayvB0eG7E3choGF2FY/wECRfeefuZuZaexlXCaIU2Siy83a1ZmoEPkfo9P1LpmJVOGryx4X3X+16hIFo9d+CAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7EIUX84ov2kovhOeTWKUvMjTleFw1LGowFTLhpHh18=;
 b=FN8RKg99FLuptn0Dk0ZQ0CPFmkcPF+UOyRP3yn7Ks7FOTEWrn3T7zEZIkWQr7gkPXKpDxj3c/NEmuS1ttquxjEvRfBzgu/Z7lnxhlRawLbvZK0d5280bnzXrDX1W9UVwplap888bPPcssjjJCUQZGOjLe/9rG0A/Rik0cLFf94s=
Received: from BL1PR13CA0301.namprd13.prod.outlook.com (2603:10b6:208:2c1::6)
 by CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Thu, 28 Aug
 2025 11:04:24 +0000
Received: from BN2PEPF0000449D.namprd02.prod.outlook.com
 (2603:10b6:208:2c1:cafe::28) by BL1PR13CA0301.outlook.office365.com
 (2603:10b6:208:2c1::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.19 via Frontend Transport; Thu,
 28 Aug 2025 11:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449D.mail.protection.outlook.com (10.167.243.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:04:23 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:04:23 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:04:16 -0700
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
Subject: [PATCH v10 06/18] x86/apic: Add update_vector() callback for Secure AVIC
Date: Thu, 28 Aug 2025 16:32:43 +0530
Message-ID: <20250828110255.208779-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
 <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449D:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: 16adc399-e823-4a0f-cfe0-08dde622a59c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bUNC7WXLk2XxOeAwPhJTg0DC2nHoSagHiL8xIW4Hi3xw1iBAJklBQ5jKAO3T?=
 =?us-ascii?Q?FooiZV5/qc4RzRMlPhlCeon8PbgamMaUrvFruhzNUuCJqBQYjEdGZA1zHMQn?=
 =?us-ascii?Q?SF+kCRFlaOV+02fTEmW3mDxH+MCXKX8BFX6sH8EG4iXs5h0C5Pyj0EscVf9F?=
 =?us-ascii?Q?VRgooTMOQJpEdTDcjB6sOqaeXSepfSfLxN3X8NbsGnST6KO0tfrwDms+fs4q?=
 =?us-ascii?Q?pV+8jtEK1mxxR2mfoZbyaC0SNUmT/zYIx5WQdzMH1sFePXpIueu3/OoxCqqg?=
 =?us-ascii?Q?Hkg4bNfJ9fQCCU0e8Wtdv+8qh+TyUUszir01oW0zkUSra2NnlTLR9EBVDHcP?=
 =?us-ascii?Q?ZU/Qs0nKdYRsRuzGTvIn5b0lQpaG6poLMU8T3j0oYbDr5klxOaN0Aq7E0Ywc?=
 =?us-ascii?Q?GCwrPGQ92H5a6Pf6YsJr2Kn9YcGcDt5GQX7gMMil9r2rIwf7N/f2fljSkgTm?=
 =?us-ascii?Q?zjWG0auYIJP587gFHn4KULYcDxJltSNAXcVIbKBYv7CrFN+ltpU0MAckZyIO?=
 =?us-ascii?Q?JA40wKPqYgz6KzP02q6WQVEQt1NcD1PaPuMbefgGly083OgZhC4+DqnEwswm?=
 =?us-ascii?Q?l//Cvh+fS9A9/oP/QY/iS5jKcamGYTe09gzbmsq7xcS/YKMzUvE7fQvfWC91?=
 =?us-ascii?Q?1VIxeu7P0iANItv672Yn437/g/0K4RgRqYNgpa9nXybLWnq/dw6ToZTWEZRY?=
 =?us-ascii?Q?NT2GLdOb6Z6BCN1C189R6DbQidun2ElFc2/0JEfaxce+MYe1kePaPB1+2dTi?=
 =?us-ascii?Q?ufvz06DRGe1TNxkojwzBbj/wkAy0pgrciMsG2kunc9VVGUW2MqBkfSRGm/GX?=
 =?us-ascii?Q?1kyHWkinKKwj9p0WSk4PBO9zXVFe7rOEATugM6bvmZJUv73gIS/7/4L4TBdH?=
 =?us-ascii?Q?LQmUYoGdMuCJOrGHbYqDxRFuRZPtlGZYlnTJQYrCd672GAgKCZfLHNepPxMu?=
 =?us-ascii?Q?94hH2aode4lsOXwLFsXvEIjE6tHhKL92H8F0XLFMdT+f89EcB8VovjjPn4eZ?=
 =?us-ascii?Q?ln/lGp022pMHb+2htQ9ZelAwpdT6kjUPg1/0LOOLaLQZI5rd6klIzVA+I53V?=
 =?us-ascii?Q?LkWbBFg4ADngsC0aYUUgCmguRmSswWPkxG8Nm2xiv590rO+rham2GzpCekas?=
 =?us-ascii?Q?a9MCXFhWAmhhY+8plroD0OLpJjkXc5VJqV3UJn0EJorfBDXlC9afuW9FvevZ?=
 =?us-ascii?Q?hr5Dnj47iifBqHjzgkjdEI7uVQlAKgEctkK9b7rLNv9mwxUdjaldmwCBr+68?=
 =?us-ascii?Q?eHP4yhxZUoFEzkDv/9TBreF/1o0ua8YQhRWE21oCH0MSecJCgfwdBjlTQfZt?=
 =?us-ascii?Q?rih5VhFuvBs12G51eQ7g71CCeGqO/IQiTIrV97HegKzL5KLoTDbRngXiJb2Y?=
 =?us-ascii?Q?uk2V6QC0rNfmeEZxbpu8GlxzXlm489sPOH7NU1BaC6EfD+Ik8JFii4Po7wBL?=
 =?us-ascii?Q?29m1tnDO8ZGcTbpT9VhhzkLzRZaFuQRwakTyE/2hoDcz0gTOhSaqiWXVhZ1T?=
 =?us-ascii?Q?DFwt9C6a+La5oMoPRqd0CMtJKems0vImrQx2?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:04:23.7847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16adc399-e823-4a0f-cfe0-08dde622a59c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015

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
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:

 - Commit log update.

 arch/x86/kernel/apic/x2apic_savic.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 56c51ea4e5ab..942d3aa25082 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -27,6 +27,22 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline void *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	return &per_cpu_ptr(savic_page, cpu)->regs[offset];
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
 
 /*
@@ -144,6 +160,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(savic_page);
@@ -217,6 +238,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


