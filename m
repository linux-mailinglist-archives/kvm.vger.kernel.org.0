Return-Path: <kvm+bounces-51854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DFBAFDE50
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E171E1881486
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F57420C463;
	Wed,  9 Jul 2025 03:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AxdKnl4e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F1420551C;
	Wed,  9 Jul 2025 03:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032361; cv=fail; b=g4LwTvShfQRFqfhJE5GOcVSA8zbfyS8dX/s3aoJ0y4lCyLaXagibkLnlgmoFFbP/E7igkZgHktMU67Q0GAa+ZPYml8FQS/Dlkb59OtU84dEmIfMQhrjLE7/kqSyLdyHWm4CLfMuhjzmNY1H/TS0kcJzsxNBZtuvhha1mbpLa/Vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032361; c=relaxed/simple;
	bh=ooco1W6Vst4SYGjeiOaX4HT7Qr++cz7JGg43V7cjZE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+t7xapN1/BvukvKf0r30z09nIncxuoVJWBj32wDtRxPrnLQjb/i/bds2CgCb2VGSC/uYQejsKB5636vZPvzK6MVtM0z4EGUaCeToMUldHlzsuhWGZ6IG/WIYzjFxGo+46MFwkB1kwV1ARwnl7OFt7dl4EP3Y6Q4NsEq/6M5ejE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AxdKnl4e; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x0BlWOzB+xTKSWUqlVFyzYjtsQ3rEbkik/zriBHXA0m0a7RG3UXkrUo7zgGKjF4VMG9kyV0ocDnoDhKaF62EcEAsVxfQj/tTZfKOl8sGB4DmaIRh6EblFZDCyfdHnEh9I/3PeFPkvUP73QCz6cxseeCpxljcGxJAUHrlmC1Z4UyvAIfvkrGFQvZwfIFUd+RoxFna7Bg6p4ZU9E6M7kId1deBxxPbeseyZFdmIEvRbKuhflwiVFCKIU3FOfoK4b7pTMLQ3A17GQlYNCtivIM2uq6p/4BVp7Z+3Ydg/q5OgnBC+bEQ3Vh4X97dlyhHQSHpos+r1juUmZU//j9mSFo9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmojS2UxExdQrzLXoHEH7Kl2AL4p0Ia1SsqJq7ex1Ag=;
 b=B4x5x6eXj2Os+7NvWkv/PTDxgV2xhsnPUIeLu8uyeI3xXoxgAsq77wOT3wDZ+dU3+rlpKde/2Zycc8fVdxogJLu6+CI0WlzVq/HXEVafUhkOZVnr/0i6Tzs6LHXmcyt8td+ip139B88U79CrfJsjXL/1kYxdtUvo68wRtx4T97F6qDy4NsASkZW26ldr3+z0X1/IEGTud8abWGFajYL6RifgJu76x9j7zFdp3HQGMn/R1pKjGrpAEQI249GlEXyH91wPrb8sLcXyYXuhlIA32I9+HRYt4P2ITlNM4jqpUUtBTfLm6s5Ua/mC3DUQbgkoyqXsx+aNVZR3Zuw95uqFIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmojS2UxExdQrzLXoHEH7Kl2AL4p0Ia1SsqJq7ex1Ag=;
 b=AxdKnl4eFLUl6zP+LK6KRssMuHMCikTzTS5czjKtZrVlte0kdY7rgaqF8GSO8kRr9cgWZIAUnpuLiWUHnVoFhm46C1wyybX0bOQyGOdIZHR2kZ2ATzrhdycMbUGkm/T1YTRVVTRUNYpbn4Vggnix6eyON3m3Coa/wBI26mE5W64=
Received: from BL1PR13CA0196.namprd13.prod.outlook.com (2603:10b6:208:2be::21)
 by CY1PR12MB9649.namprd12.prod.outlook.com (2603:10b6:930:106::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 03:39:09 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:208:2be:cafe::d8) by BL1PR13CA0196.outlook.office365.com
 (2603:10b6:208:2be::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.5 via Frontend Transport; Wed, 9
 Jul 2025 03:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.20 via Frontend Transport; Wed, 9 Jul 2025 03:39:09 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:39:03 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 20/35] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Wed, 9 Jul 2025 09:02:27 +0530
Message-ID: <20250709033242.267892-21-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|CY1PR12MB9649:EE_
X-MS-Office365-Filtering-Correlation-Id: a388b985-fa50-4141-cedc-08ddbe9a29f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jUhwbbVVR6aQSM9cqumewjuIojiBMTILjOl42L8XWgKNi1zx0r1LVieaSPmj?=
 =?us-ascii?Q?WhJfaHxB5S0fQ7vR8xtF1BludllSwxoFRXiVMiWgrpzTMFyU1HpgIOLr6RRn?=
 =?us-ascii?Q?lkxzblTJzTunw3BGbjBXCAb8CUOGXS4ZTi4ixp0EIpeheD7ig2pnJ/McMJdk?=
 =?us-ascii?Q?yA6yqxJ481SXtVE9jIbp30D/SogHV72bgZ0AX4Fx516DftzRHiBh9iy1PkvS?=
 =?us-ascii?Q?V0CIOGm2KMt383NYKICaatkOcky55wSijNbh0KtDE2oSk+X8WZ8N7ZoAB0wT?=
 =?us-ascii?Q?rfBHzSXYdelmldSjx2huTYmgJ615AWlaeKNqsq3uXCbluYTTQAc7e2XQYWlk?=
 =?us-ascii?Q?6UB4kh1NY/lytNW+QQ2ZbYcsNp/2gcWHptphEFMR89ais+/oGQKhPzp3pE7q?=
 =?us-ascii?Q?3C5JNc7FZCRSZn8pdPeJZUFzY9LjUHLVfWtFrnZ7OxlGgh207BMT6mwe6ZG6?=
 =?us-ascii?Q?nYIpLNHxdHRGDElMqaXB918p+LQLvguUzry3+8jXv8+zIFzmfrkwIsyEJ8X3?=
 =?us-ascii?Q?zRmyLP+3zDKpbgDX+GnFKlbfTMmRK/cL5KtmE7Ucf+hjrIkDopjB9RudPvsw?=
 =?us-ascii?Q?VrUuAklUFCYdhxMPDckUg2nM8wuG0+22uZyAuu4sGri4bzsXtdLcDCmKwZ3a?=
 =?us-ascii?Q?YDl/H9Hq7NX1xlUEbtP2uxFWq51o/lewQqf/wLHaIO2BqeC1faLl76QOALwn?=
 =?us-ascii?Q?iKAfCMhWNc9eMwWFLF7nk3iyadb9g+mOjB66Uex9a+oXX0+zhlqf8F6zShXq?=
 =?us-ascii?Q?R2+9WzqwroymfTOzkRv45/N2SnHeinCeCxFa6dT851tLbi32J0G77RYxs74I?=
 =?us-ascii?Q?14PM+WroQtL4gx5gMEx+o+D3ILKp+VLAzE2xnladdu1YkvnnJfvxIqt8X9Ko?=
 =?us-ascii?Q?tc1IYl3RIcg0GeXCCzP54nU/GMCs9GBB/odDZgt08HaaqG8n+pLr7heWe95H?=
 =?us-ascii?Q?GZ3F6JKYHA/o6catnnyWYTzPU0TDQrVAsRWXf+XgzcBAWNhLSGbjdzWSQQri?=
 =?us-ascii?Q?he8Mxq1Av3Djaw7SxvgheOBnLAYqHh/gthg7a+959fF7uDXOYIt3LBDooAia?=
 =?us-ascii?Q?c4645zpuNeN1f/n/KrAIyoYCMGvplvW9bAjorsssmfVl7ZWhxL13nrP1KHBu?=
 =?us-ascii?Q?dxrQzjSoFLswR6+UuPWNzhWYO0yYOL8NR8DJV1byhO2/ijLgq1XNlUfgPxHn?=
 =?us-ascii?Q?fxC43/eNJlRxymmxzq9S47rcQLdusMr5WnjU7xRjd5uagpa5jYs4muFJMn9d?=
 =?us-ascii?Q?GqtfkZNyQE5Y740JFHvDqLkzSYSjbMkzrhwgpbk4iwxFS5oYfRc0nUw04l8K?=
 =?us-ascii?Q?YtBgdcJhHaehF1qlzuN+7Yt18AMWkdpNNRxrDWtkHeV4zec220SeeDIQ+gbE?=
 =?us-ascii?Q?mhSFF+YaOEe9WE8qlQmyWnD4j81ITYOAyeKXYRbpsHkF0lbUSAFJh2zZZQcq?=
 =?us-ascii?Q?1JR3MxlO1Un3Jo/EKcSeS/t5VA3bXsbfKo2a3EFbZTjOfCLbepRFpUg4sRR1?=
 =?us-ascii?Q?6367CY1HoBaKmalm/6ayQ4RdY3CH3y352fwH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:39:09.4135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a388b985-fa50-4141-cedc-08ddbe9a29f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9649

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
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

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
index a2747ab9200a..186e69a5e169 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,6 +9,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -22,6 +23,114 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+#define SAVIC_ALLOWED_IRR	0x204
+
+static u32 savic_read(u32 reg)
+{
+	struct apic_page *ap = this_cpu_ptr(apic_page);
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
+	struct apic_page *ap = this_cpu_ptr(apic_page);
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
 	void *backing_page;
@@ -85,8 +194,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
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


