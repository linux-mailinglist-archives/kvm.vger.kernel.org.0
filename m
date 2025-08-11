Return-Path: <kvm+bounces-54391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FB75B2043D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:48:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14D613BCA58
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34386228CB8;
	Mon, 11 Aug 2025 09:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jnwv0ZsZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334321D8DFB;
	Mon, 11 Aug 2025 09:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905574; cv=fail; b=gN2aFhutvuaYe7AFxddfYsCSEwBhNX/vT77vKna80SkANk5vvkY5A+93YK4lHj6xNBhKXcpF8CfzDEst5UHjGv1EpXWDnoVJje77bVVELBNeNWqOGK05YgPZQoTDCwB610474TBipyWBW/eguluATG6FNN2m70KBTJI/6gk/KK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905574; c=relaxed/simple;
	bh=82WmLuDjr2EBjXEFHSsPnHV8UjiIFx77VcDHjcmV9GM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2FqcEzCig4XMTeH5EjcoXyeVBHESHaVRw/+o0Xpt7+3SqZiQbUbdCtb7AOwLuwIVLxMUGFjs4v6WwU+c+MQhS/bwkPch2Wd4a30Zh1lhYVkbbzmqwvw431tCaqz2wZJFAVkrjNEE9VMuZEoBQILkNQLkBi8XZ5sTiCf8/CKTmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jnwv0ZsZ; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Arz5o7opadWERMRxWFzjKpuAUpaRYfxFzZdO1sMj5i2lpgpQRxa2Vm8Y9k5Q+tonSqD/g64Edd4C8AJ4Y2p/Rvv7HQVcSMnBvrCqADDZNBZkWowiN9RnNOmrSCWTsbz37Qm8nz+D42431zdsZbsCt97BXh0CN22zkwDHES5hl8uu473qGV0poLSwb78eLIhgjL3fubdmx5CB5GLp7bn4mwiVlab2LrwEC/nqMCUjRD9FpJkWsMZhtjmLkzfGvnqBl1Ar1Hs7L54btKSmV8B2Z83N81K5cwqXqClHydrgofZcpOXWD9C4w9cNqop3XzXP7hTrQyhE3DHX/t8QgPRr3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQm1oLm+yqi6srvY8dOoW5RGgXDhTY5SnfegIdK3tSM=;
 b=an6e/DPDYVvieiqXg6A99FPPiif8UDqRHd0i7UuFztpyxRMv/UplugdunPc4jsub6GqyyA9bIidNApZvuVG4bsEsZeBcJUN1Zf2t7zRqxSK/bL4FVApuoj5aM3Z77vDkrlW2E9QG4D6CQclcOc87ZOcERmO37FLZGGnuq6TwGz6ToJ9/IXU55hng6ls2YtAEXIgsIwZ0wD77ngFxn4/8EKtbMLli6PdbfpIzYwzx97RlWfzl544K7Olh4KDjkxaRHH5UkVHRqOe8pfSfmE4bS5W3NjWrN/MwviWHtJuoFdIf5VrinG8uEHOmYrOvPwYvwOC2LGWaPyNQ+cJT8uMhfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQm1oLm+yqi6srvY8dOoW5RGgXDhTY5SnfegIdK3tSM=;
 b=Jnwv0ZsZLvdBzvAQcv/Q25hzbTtNr2RQ76trCwXi4ZE0H5vZ4DEqgX7jJ7aQS55yQLVT/mLABLjP+MrjimY09Vnd6V46Y7Jd861rhnJm4kXL2rYd5SwBlwfXRrvf/BN46CSozwCMJr4Vx/SckieBvGmQaKEUXuXUXzZNphsVFXE=
Received: from CH5P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::10)
 by LV8PR12MB9668.namprd12.prod.outlook.com (2603:10b6:408:295::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:46:05 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::41) by CH5P222CA0021.outlook.office365.com
 (2603:10b6:610:1ee::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:46:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:46:04 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:45:57 -0500
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
Subject: [PATCH v9 03/18] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Mon, 11 Aug 2025 15:14:29 +0530
Message-ID: <20250811094444.203161-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|LV8PR12MB9668:EE_
X-MS-Office365-Filtering-Correlation-Id: c2af1fa9-9047-4e25-ca7c-08ddd8bbe3c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M3O+dFQ9tCzk9bSKT01z/uE57jdRsnxsGEBkzcz1lLHJyMl+mczq6K5tb2mH?=
 =?us-ascii?Q?3kP9wiE7tmw/HwQn6DbVrhGwHXRqGs1vKUkuaZVvyjvWv0CfucVgWm7tUJcF?=
 =?us-ascii?Q?+NI8uxZZp3usq1kS8K53F37bGeMD0j9O1n+AtSXvCynCSXK9P89sgaYg4yvu?=
 =?us-ascii?Q?KXzkLC0FH7BCBAdA2qAfpy4Hzr6kCHC60AbKTZVL/npD/XHWALG+bGpK//Z4?=
 =?us-ascii?Q?JjIYnBAdBQ+6/DajtOzPDllDtcT5ekQYHceYD/KhRYvLShZfK/xLBDlNgxZL?=
 =?us-ascii?Q?i9O1nHlfERkzpkSotSYLRKG4ZeRZ/f/SRw/fim9rMxWS2RPlGvID7PHx7+YH?=
 =?us-ascii?Q?MrcYNtz7G9e0xV46MbzEtIaRhuhzeHNUObhNuZ/D1SRVqNh3gRgcqtDWLrO6?=
 =?us-ascii?Q?cesa5dpmTQKb8AKg+icg34cop+8BqeXZpHde10dQPB0nzAm/P56SHj8NxFAv?=
 =?us-ascii?Q?oxz2bl9Wgy/WTk03uz7X669sZVgvhdSg4TXYM20H/WBTohlaE9murH4heUm/?=
 =?us-ascii?Q?+oYGl/SOoEC+7seTyDKedY6f87cM1qRcKk32mYvfPo//DPNTxXEHY/t+957E?=
 =?us-ascii?Q?Lb3xM0l89bkdN4KyL7+9yIes+1I2n9Pd+EostodNdjKszl89JBq3ugblm6cs?=
 =?us-ascii?Q?ijysBt88dXP8GgmVpFFwjDCsQSS3K/za615N6cBsuo4CXh3TlO3qdqgZ9exf?=
 =?us-ascii?Q?y7TLfiLFZZB6Jn5eIDOCwmu2RanvMr3nyPIWqpQelshBNda4ZKi+feUmAE01?=
 =?us-ascii?Q?IY/Y63HxmnWfTYbJuXE3ojqMR7/d4mNLGeDmST4Aq8kyOwizfyKcpGOeCI1B?=
 =?us-ascii?Q?DotoTu6DmyMoyLZdjxFzjN/TrT/Cki2uRQIJMZgDln0LQDqCXhPWT/aMlvvT?=
 =?us-ascii?Q?x+bOb4++mp5jyvGosgArYtZ4i0n6eaj8ZGft3m5DJqdJU37xorAfBV7Yhzta?=
 =?us-ascii?Q?jQ/u94c2v0Yux4K7Pvey76EPNayUnm4cNZwV1YF4eB5dN639CU7/LC3Sngrh?=
 =?us-ascii?Q?ezSgSqd9ByIZgBGlK6+elMS2sebE0BEN8WbAnjP02M/krw6TUl6oz4+rfXBP?=
 =?us-ascii?Q?jUjdh58soVjbTIFcA2Sfr74znlcyNwetM7mEJOpQAiCb//7iNpmnK2T4JeZZ?=
 =?us-ascii?Q?Z/wXa7XUJKkPoeKZ8JWQgNftheaNydb4hxiKhzz9na5dnXBgSw+r/4VFWcqQ?=
 =?us-ascii?Q?O9W1PK8jBK7OjDN9asr3YOMIRdr3hjzH7fn9Lw10LWAIoWGajHBeoCjhNqO/?=
 =?us-ascii?Q?uUcjG4cZThZRJ/PhXYfo3pbqeJHfG8U+BnZO/crkYF5EqT6kR/YKqR1imiX9?=
 =?us-ascii?Q?oa6MYduDT/br3QjJrNFmookXLc1OSEinUB1q1Ke95PoezY9U1FSeCJaAhYdX?=
 =?us-ascii?Q?DbENkQFKoHezXVBj/8YgvzhROLTpCMb20NfiLrrxMu0/fcMz+TAGyU3JcWEM?=
 =?us-ascii?Q?EFTYX3koA+gcD901JECYxclbExkof87o8+nD1wNiCzk5hVGdJV4ijDzZAVZk?=
 =?us-ascii?Q?nSPagalncYQHf09OcbHPZnX/fUdPMjPfZaUT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:46:04.8007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2af1fa9-9047-4e25-ca7c-08ddd8bbe3c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9668

Add read() and write() APIC callback functions to read and write x2APIC
registers directly from the guest APIC backing page of a vCPU.

The x2APIC registers are mapped at an offset within the guest APIC
backing page which is same as their x2APIC MMIO offset. Secure AVIC
adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
within the IRR register offset range) and NMI_REQ to the APIC register
space.

When Secure AVIC is enabled, guest's rdmsr/wrmsr of APIC registers
result in VC exception (for non-accelerated register accesses) with
error code VMEXIT_AVIC_NOACCEL. The VC exception handler can read/write
the x2APIC register in the guest APIC backing page to complete the
rdmsr/wrmsr. Since doing this would increase the latency of accessing
x2APIC registers, instead of doing rdmsr/wrmsr based reg accesses
and handling reads/writes in VC exception, directly read/write APIC
registers from/to the guest APIC backing page of the vCPU in read()
and write() callbacks of the Secure AVIC APIC driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.
 - Code cleanup to use struct secure_avic_page pointer.

 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 113 +++++++++++++++++++++++++++-
 2 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 094106b6a538..be39a543fbe5 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -135,6 +135,8 @@
 #define		APIC_TDR_DIV_128	0xA
 #define	APIC_EFEAT	0x400
 #define	APIC_ECTRL	0x410
+#define APIC_SEOI	0x420
+#define APIC_IER	0x480
 #define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 1c70b7c111f0..86a522685230 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,6 +9,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -26,6 +27,114 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+#define SAVIC_ALLOWED_IRR	0x204
+
+static u32 savic_read(u32 reg)
+{
+	void *ap = this_cpu_ptr(secure_avic_page);
+
+	/*
+	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers
+	 * result in VC exception (for non-accelerated register accesses)
+	 * with VMEXIT_AVIC_NOACCEL error code. The VC exception handler
+	 * can read/write the x2APIC register in the guest APIC backing page.
+	 * Since doing this would increase the latency of accessing x2APIC
+	 * registers, instead of doing rdmsr/wrmsr based accesses and
+	 * handling apic register reads/writes in VC exception, the read()
+	 * and write() callbacks directly read/write APIC register from/to
+	 * the vCPU APIC backing page.
+	 */
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_TMICT:
+	case APIC_TMCCT:
+	case APIC_TDCR:
+	case APIC_ID:
+	case APIC_LVR:
+	case APIC_TASKPRI:
+	case APIC_ARBPRI:
+	case APIC_PROCPRI:
+	case APIC_LDR:
+	case APIC_SPIV:
+	case APIC_ESR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
+	case APIC_EFEAT:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		return apic_get_reg(ap, reg);
+	case APIC_ICR:
+		return (u32) apic_get_reg64(ap, reg);
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
+			      "APIC reg read offset 0x%x not aligned at 16 bytes", reg))
+			return 0;
+		return apic_get_reg(ap, reg);
+	/* IRR and ALLOWED_IRR offset range */
+	case APIC_IRR ... APIC_IRR + 0x74:
+		/*
+		 * Either aligned at 16 bytes for valid IRR reg offset or a
+		 * valid Secure AVIC ALLOWED_IRR offset.
+		 */
+		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
+				IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
+			      "Misaligned IRR/ALLOWED_IRR APIC reg read offset 0x%x", reg))
+			return 0;
+		return apic_get_reg(ap, reg);
+	default:
+		pr_err("Permission denied: read of Secure AVIC reg offset 0x%x\n", reg);
+		return 0;
+	}
+}
+
+#define SAVIC_NMI_REQ		0x278
+
+static void savic_write(u32 reg, u32 data)
+{
+	void *ap = this_cpu_ptr(secure_avic_page);
+
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_TMICT:
+	case APIC_TDCR:
+	case APIC_SELF_IPI:
+	case APIC_TASKPRI:
+	case APIC_EOI:
+	case APIC_SPIV:
+	case SAVIC_NMI_REQ:
+	case APIC_ESR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		apic_set_reg(ap, reg, data);
+		break;
+	case APIC_ICR:
+		apic_set_reg64(ap, reg, (u64) data);
+		break;
+	/* ALLOWED_IRR offsets are writable */
+	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
+		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)) {
+			apic_set_reg(ap, reg, data);
+			break;
+		}
+		fallthrough;
+	default:
+		pr_err("Permission denied: write to Secure AVIC reg offset 0x%x\n", reg);
+	}
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(secure_avic_page);
@@ -88,8 +197,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.nmi_to_offline_cpu		= true,
 
-	.read				= native_apic_msr_read,
-	.write				= native_apic_msr_write,
+	.read				= savic_read,
+	.write				= savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
-- 
2.34.1


