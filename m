Return-Path: <kvm+bounces-43549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2AECA917A1
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D64B188D3B8
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6F52288C0;
	Thu, 17 Apr 2025 09:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pkk5Rzve"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A918BC0C;
	Thu, 17 Apr 2025 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881727; cv=fail; b=EjVpTVzb/AxqHKcy/7eZXrxe6rP4eK/SX0GnZPe0c5lCo+SLEHZniQ5tgs8k57tWD0F5N1pPSr4h+7tv0vvrAKbtv3pl5JvbEB65YakSrfZnpYgz6cDxHYsWj95tf33qjN3Dy0o3KVVwLGaYSi0fAeChNvW4hThpwFY4hhlZStU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881727; c=relaxed/simple;
	bh=oNRvjdBJc+w7VJvMaYvWXGQiv1FHluveN1RvObAg4GE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBmkdVO6rackfZ+B3I5TWP+kC6uQfpYILVNEmWANLkBhavsczDg0Hgv5lALgAyUgX8paKzhPM2ff+j3gdl1MhXg3mQxWvvTarqPpbA6uM8ymKZb8dpLMsNLZI15b5gw03/JOeiJENZ5mi6+qu8ah5iBWePYG0dtj4YeBZo3ntkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pkk5Rzve; arc=fail smtp.client-ip=40.107.102.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gEEBk7TLJo8wDU+elC/P7oZFeH3XXy+OKylRYSMzX0Uz74y7d3fQVRWyM27cHc7Uqg1rFmoVQ4gj0n+MiJkx9SpgGC0/+FBlq2ZtQK3yvAdRQQYpre9fo+gQgyJSk7zw7WEp+E9kUYoroAGsaogcFe/103r8FProU77XK9u2BBAGQLKpgkJ+MxHbl4Bno+lI1YzdH06PbBwUnt2qDZo9F7UzD/T2drcwmTAdFe52dKPVRq5MDzGp4a3NumPiOmPSIAcW3moSf/sn7z482InM2Ur3QfWTH1S+oTlIKqG9alCRjSopMglmLJeDjfJcJauwVPPWTRyDDCtWX6ztR6qy9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x46n83GaWQtihXUGPNPb7NoeGnreKsHi9fZuCNcVZxU=;
 b=Csrthlwm0nrRuulfV1kWQPJjsQ+AxDI1dDDvZwnRYVKfLs/hYFhJrU/RKRfnV+ra34naakhpoUTlWxt/5zgkLV1u7+fapGJHEG059Kaxh6zMS+yW2psVLEV85igckW4RmfYRg1BQky+IJRs1KUKxkwPTjhaTa6N3ZMGkdgAnzX3gvP0Bv4RdB6XJkb7hp4Ix3dbk123X7PwW9k0jZXShSk8dUvTB1z5qzu7Gbrh0QCQoTZ0bkuThpMEyKsQz6BPI7KRmPEbHeD5kconRrKlk68OEUXTPmtSgHIC3TtPo4r5n1JDj2//tAbdZymLllNSDDd2R7FojRphr70W8kZBRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x46n83GaWQtihXUGPNPb7NoeGnreKsHi9fZuCNcVZxU=;
 b=Pkk5Rzve5nIPrsUJo8+J/+VkbMOKR3P6qlVOKmLXr/NnM+OQxkchB07h9lwtq/EgYS/EizdGTTdqkMDdkNZ6rZZ2koCGnBSwPYeptOkxF2FusDFivpYONWW2Rz/5VWwQTqKDP0hRKH/SjnfPbLye5M7oVDWZzKRJz7VTw77w++k=
Received: from BN9PR03CA0386.namprd03.prod.outlook.com (2603:10b6:408:f7::31)
 by CY8PR12MB7361.namprd12.prod.outlook.com (2603:10b6:930:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 17 Apr
 2025 09:22:02 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:408:f7:cafe::85) by BN9PR03CA0386.outlook.office365.com
 (2603:10b6:408:f7::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.18 via Frontend Transport; Thu,
 17 Apr 2025 09:22:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:22:00 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:21:53 -0500
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
Subject: [PATCH v4 11/18] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Thu, 17 Apr 2025 14:47:01 +0530
Message-ID: <20250417091708.215826-12-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|CY8PR12MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: f8d2bba3-c861-4e80-97c5-08dd7d914efa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8zF7aH6sam1shDzSCAUzIK8zk8g4u/HuDbccEPScfxYKgcC6Zmwk0bqJhp5u?=
 =?us-ascii?Q?ROo+rS3x/gmZ7uEZplSrRpvD7tJgbEPvb5F4vfrJ3IZbt/wR1xnky9EWaSqn?=
 =?us-ascii?Q?2/CiysznmnW4LNK75dG73QWmX2ZrUbVV6uOOc+e+AfoKNbk5DNnI5ZWqkjSL?=
 =?us-ascii?Q?rnBIOICrJcYv8DrdDxSZq7Dk4nffVqLrfk9oHMDk+1d1jcTPuT0Awki1f8Z9?=
 =?us-ascii?Q?kgYWJ7hw9pO9Jr6ZxIypASaxyTl8SCe+mQYFXiY8yjC7BOF+kHN94c/siXUd?=
 =?us-ascii?Q?rJc/NonoX+1fUlug5JJtQ3NBTbhIKXhDCueyLuaLsqEsqgkZ2KF6X8Ce/Jmi?=
 =?us-ascii?Q?dIOUs2SvuY5hRe4wH6oqQh4Zgxy7CgoTSh0i/aUrJMenCUu6b/GgCMHXhZKK?=
 =?us-ascii?Q?xvZ4kiRNBabk2J+QBcLGqbbiCFaOflTDPGTf99SQInpt+5aizZ5GTmcQ9nf0?=
 =?us-ascii?Q?o0uyEzIyJAHEr/sC1wGCjDcqAkK2SnehJylSXthf2o4KxtfAgEUK02oUZDVU?=
 =?us-ascii?Q?ylo0FQEQ+2n0+A7t9RgWBnUvrPe8km52VM8PVJ+gtIMgVFsfzoGUG0fMQUjE?=
 =?us-ascii?Q?dnFEbf2t4Xz2qz1FTzHkOIdrXhcZ187sA3R9LE0lI6g+yEN4AbeY/K5IbNRr?=
 =?us-ascii?Q?CZlX8s0qD9LjEulXQveGANN9WmtAvxI6jHfIvuA6+eVN+BzTyqhI0zVMa7rs?=
 =?us-ascii?Q?Z6oaUL80OaaB+WMANaNWqWbc24XLi8GdP4MKb0rAPzVCDfaf4krTxQImiM8V?=
 =?us-ascii?Q?G1ZQGXCfhm3rLtdpsn9SrvaKrC1MU9UjRCZhKwvMXXKL92OuOQj/VBO8I/q7?=
 =?us-ascii?Q?hSMu6LZUbteyjDqaqImTLXqrOhnuSyJ0F5Y96e55VY1uwPyPZ/YZr1v0YkZr?=
 =?us-ascii?Q?5CYzXqW7XbtBe/eF3cxzKrImxFEkzcLbOkmjsOVomAD56DQyCYBtPP00M9SN?=
 =?us-ascii?Q?sR0LjNB7IhV986d+nG7g5Zi3lGYAdulNMps+xGKE0OvDEe5ySP2attn2fPrn?=
 =?us-ascii?Q?Ac7rX53LcvAjO031HIiIuhfRWNU179h+Ufz70OFyBSis5x6n3Aol6U71zR9E?=
 =?us-ascii?Q?fXSuXJsbh30heTRxSmJm+KQUxUJApX97FX8LL8ZEgRl9yo2DBqqnNn/p/1TJ?=
 =?us-ascii?Q?Ktc6fuFBG51nY5KD7GlLGFLwEH1pFZidfXjB0FI3PcLnuUKEhdxYtoS9NyGq?=
 =?us-ascii?Q?bKv2qhQq6UePwysLapz63c+XrVBP8bUIOc9cLZCMLjCRPO9tVYw+aC98Beux?=
 =?us-ascii?Q?3TPWaadRRFco9EGcvvdc8J0nopw5mQ0gRtuWnzL8c1tpvAK1N5h+4IiGjbsf?=
 =?us-ascii?Q?vQ90BED41l69tE2m++hvXxe1cpGwYJfTnalZuNUVzVSR1EOoEepPeZl3gHwK?=
 =?us-ascii?Q?zmFvpTXBQyhIYqH+KLex6M4qLs40yokaJ212sDtFN0uLbNxeOx912FxEc4uo?=
 =?us-ascii?Q?3Nc0Vlor4xzCxzkuxSCDWhCPM9PrwzRwQxl/yR6LISt4RG2rZXCZDknMHzKa?=
 =?us-ascii?Q?1De/ZRxNuvWktDY1/3HdjV2xcNyh6PvnsoNU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:22:00.4822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d2bba3-c861-4e80-97c5-08dd7d914efa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7361

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from hypervisor. Set "AllowedNmi"
bit in Secure AVIC Control MSR to allow NMI interrupts to be injected
from hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - No change.

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d32908b93b30..9f3c4dbd6385 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -693,6 +693,9 @@
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
index c95a61109183..552581ce6b36 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -29,6 +29,11 @@ struct apic_page {
 
 static struct apic_page __percpu *apic_page __ro_after_init;
 
+static inline void savic_wr_control_msr(u64 val)
+{
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, lower_32_bits(val), upper_32_bits(val));
+}
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -351,6 +356,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


