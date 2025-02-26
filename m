Return-Path: <kvm+bounces-39245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D260A45973
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E8BE3A9A9D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6AF224227;
	Wed, 26 Feb 2025 09:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x4GFlAWb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102DA2135B7;
	Wed, 26 Feb 2025 09:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560803; cv=fail; b=f6k+9azTZz2b9+0P87Nakffa9m9Y1RgovT+N1I8uezg/Gh+qKiJe+XvLK0UGiOz+jTc+ZwtgF/S3haOSWHKYemGeF6P1dBAXd+KypEkQ1dKgaOIE2pNiTEMvaAqHnauka6SFhfcVgVZiuO+QmDyR42+uRpj08/gyDTIvczIkMIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560803; c=relaxed/simple;
	bh=29DCPu6PYbPoNp9CleIiURSMkuo5Oax5j/JhjFrQuqg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P920a0o68aw7y3lZ+YpZCWgx/pF+ld+mlYiUR8wmTA3YPECrmg3+nKMHv4aNVSRb2ekL6GSTTV5B1KFiFgbB9l1y/JqJFSDHMsCGtwODmwTnAdM44xmwJEMx1EjgBdO4LUcgWCFHr6RUWozMtDbEx8WKLSedZUc+iDFmcM9RM+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x4GFlAWb; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vxYBquI/NHwziREtQFUmbxLFE2GFVV81lO73xxmA0TH7pottbmUG4DDGh/R/BeePC2oyZG25eeLjZUodV0oLQtNl2s+WSTdq3Itl8ln8mDCjperXYExqnU3aU2M/uTGLL7l0ouCBmDrqe2/e1PauxVDmE/pVPtj6L3iD3PK1BVjqa3/CJaDLyfqJ2z6n/JD6OpcNPHoEs0dw2XiY0yvQXSZ+7a2YnXOr1O4Ppm8BOjRsh0W/1u0q8Ajc6Kc6yjZb+00ChtApCkNXjueh7/QnrQ4l/xcyjh7DGkiNlU3K/et/cQMCmk3EAavw9oYGdTNC0AUhh9TEG4He80y4JTvmXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vlOI/TnpcwrbfTWAvslBQn0i6Sn/KczzFfbkyF1ffi4=;
 b=mxS71VN+YfHlkNMHLoGROb9JgKjv5wfmK2BvHDYn7Q4gPbb61dOYaC11yrT88zwVndrNdWnOaMrYhd0R0Pw/Ltdnk8XX9RuMWtLx1Cqc5wgBhwRx2YA2evK1oyW9grGl0tHg6QOKYpl5SQXhfRQYeEQX4tN+XyJYCZEuhX/go68Gr26hj2IuMKQOtkefVg8dXDT+V5NmO8vC6hJW6/O+z8dnpU3MmjoNPJ32bmxk7NwfpliSxl76DI/4yhD6dMu5sJ4jIOoGkf6XxmS8usQOv4UQ7z34RK3CIkRGCTbQ3orpcEKYL3SIFUHBVheZBt8iQqultk/nhVP3zCMxgN8ETA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vlOI/TnpcwrbfTWAvslBQn0i6Sn/KczzFfbkyF1ffi4=;
 b=x4GFlAWbSoO7Lb8Iqb/ZLXB38jS5pSqLwHlcrTb3sNzAKoOU4RkNQhSc6rTF3naO40pkD03lN8u0g8Parz1fy6sBvDnjZSs1iKW8GfKzLhWhZoUwOo++kYNE5J9RmCB855tIXqa7zAECxotbsyz8jAw10HBDhVOcSmIYyCmcwbg=
Received: from MW3PR05CA0015.namprd05.prod.outlook.com (2603:10b6:303:2b::20)
 by DM6PR12MB4372.namprd12.prod.outlook.com (2603:10b6:5:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Wed, 26 Feb
 2025 09:06:38 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:303:2b:cafe::ec) by MW3PR05CA0015.outlook.office365.com
 (2603:10b6:303:2b::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Wed,
 26 Feb 2025 09:06:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:06:37 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:06:31 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 03/17] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Wed, 26 Feb 2025 14:35:11 +0530
Message-ID: <20250226090525.231882-4-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|DM6PR12MB4372:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cea5c9a-062e-495c-ece0-08dd5644e06b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BC2QpXe/aIcNoQj0lF1wlWQ63b4Yl/YDMerpz65DlrFwcEz8waegsXD3oSMs?=
 =?us-ascii?Q?wC95mVmuU7w7qLhUhvEPc2t1phgRbxqCMCLM8n7J54bgVoyz3HXIfEyN5XMQ?=
 =?us-ascii?Q?QK5/cY7DbgFFExapfWcJ1JtrCHsiIXffcdKtbnPsf3hg/vDcqRQKxxOoy2Ry?=
 =?us-ascii?Q?mto/RT4gZU7/qWVc+9LVeOZZAhIPymKmpt9KrwJIDBRpeIuJpmeqsQtlvOgi?=
 =?us-ascii?Q?YjT9xKAxk3UQls1A82HIR0xTIivGRtIO5VgNjQ0D9WQLtHxVyBvIFI36+kqN?=
 =?us-ascii?Q?rhjgTrwIvsiBjlm4sAo1wtgjuX6aDJQrn/Qr/PrzCvRzMKiJPdXPQZgZCamp?=
 =?us-ascii?Q?JsFwl9VH/tcMzYqPIf3nmtGabdGbjpodDafXI523iXehOCPp2q3MqGuPsDel?=
 =?us-ascii?Q?Tdz3t/OkNgrf268zRX9MoQAiRcY5waxIYd0GeObbFWPQ+bi8ttEDrGv+j5nb?=
 =?us-ascii?Q?3byRwy06nXdoKDNsmapgCq6CwJFjJSaBVpp7BrAOkkOF/97bjj99JNIkJMMy?=
 =?us-ascii?Q?09zUXBd5yvlzmlJ13/GO/MPGB/fJGClPsXDvvAZN8cOuhOD5tRJ8xxvvfUMn?=
 =?us-ascii?Q?KJxNhP6C3wsK7rvHsBLYQFimHLFMkH6TOBeGT5tm3UyKgfMjpw/bADX2LShP?=
 =?us-ascii?Q?i7h49xy/xteCrGxKk1Rd2HjSgm4pLIFAKAuUFjd/zFU7vCS0SWTK42OEJxFr?=
 =?us-ascii?Q?uUllS9qG2ZhZVDLBTX4LD5y8pPUyj6DKxP8l8y9GntqFtyhIdRjZX2QDrNZ4?=
 =?us-ascii?Q?jR0t+8CRSOVKdRS8DY0CftVSZrtL1t84JSLupnMen1Dbf+n/dSYjbRU5G6/a?=
 =?us-ascii?Q?emNL0S5ppsi6RZOS+/fHZjvU0Hiou9MTOERdi01savxS19v/hDo+F+2wu52b?=
 =?us-ascii?Q?7FoBRBXxIVPQyDsYqmBtYKGhgct8MU0GeeHtQQDiWvMtbFPjmlOgqMYvrONM?=
 =?us-ascii?Q?QuZ5v1EvkvX9NqpO6s+CmE4UCrvyylwj9Sw/JWhuGx07m5ivyFAcQjRUo0LX?=
 =?us-ascii?Q?ucIt1tyHMTomzMz9HIhsaClvqpphxdPQnUfqUG3LiQ+FegzPRljUwko3rfZi?=
 =?us-ascii?Q?mQWJJGfFcVKE8kZO+OEseivylDNuaoZjoSomm3l0QE+RKTmWM3/R7oNZcyFo?=
 =?us-ascii?Q?J7nhd5DKrzH0YUrwXgNtIPTi6LaQ8pUxPdqka2vHB7xivj0pSDbB18aH6l+6?=
 =?us-ascii?Q?ljIB/ZkyN8qcIndGCE68w6/oSOgDCd+Xw+0BFMBne8FJhHJP3249c0H213TS?=
 =?us-ascii?Q?7OmWIa6STFi1p4USV50HYOnhyKFVRSxNVUqmyuBEoBNHYIs3Zeahe22Hz6eN?=
 =?us-ascii?Q?KGCTMKnWJkJLZQXcoVv4/YN2AETFGoXjY4oupsiJYdNrxgSGYoJvM+L90kBS?=
 =?us-ascii?Q?VnuXlGS6THr5tMBO1FoDBFXDij25TH4DDOchU7I/aGtf1ReK5el+aL3vI1Wm?=
 =?us-ascii?Q?VeKU2IH1Iwa+hZfXPcw7diyhMOW+Dzo/DNBxUktJBxt34ElR53IZZtykXz46?=
 =?us-ascii?Q?oCltqMwSmk4uqVQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:06:37.7693
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cea5c9a-062e-495c-ece0-08dd5644e06b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4372

The x2APIC registers are mapped at an offset within the guest APIC
backing page which is same as their x2APIC MMIO offset. Secure AVIC
adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
within the IRR register offset range) and NMI_REQ to the APIC register
space.

Add read() and write() APIC callback functions to read and write x2APIC
registers directly from the guest APIC backing page.

When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers result in
VC exception (for non-accelerated register accesses). The #VC
exception handler can read/write the x2APIC register in the guest
APIC backing page. Since doing this would increase the latency of
accessing x2APIC registers, instead of doing rdmsr/wrmsr based
accesses and handling apic register reads/writes in VC
VMEXIT_AVIC_NOACCEL error condition, the read() and write()
callbacks of Secure AVIC driver directly read/write APIC register
from/to the guest APIC backing page.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:

 - APIC_ID reg write is not allowed.
 - Put information about not using #VC exception path for register
   reads/writes as comments.
 - So not read backing page if WARN_ONCE is triggered for misaligned
   reads.
 - Cleanups.

 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 120 +++++++++++++++++++++++++++-
 2 files changed, 120 insertions(+), 2 deletions(-)

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
index c444161d81b3..ba904f241d34 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -10,6 +10,7 @@
 #include <linux/cpumask.h>
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -23,6 +24,121 @@ static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline u32 get_reg(char *page, int reg)
+{
+	return READ_ONCE(*((u32 *)(page + reg)));
+}
+
+static inline void set_reg(char *page, int reg, u32 val)
+{
+	WRITE_ONCE(*((u32 *)(page + reg)), val);
+}
+
+#define SAVIC_ALLOWED_IRR_OFFSET	0x204
+
+static u32 x2apic_savic_read(u32 reg)
+{
+	void *backing_page = this_cpu_read(apic_backing_page);
+
+	/*
+	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers result in
+	 * #VC exception (for non-accelerated register accesses). The #VC
+	 * exception handler can read/write the x2APIC register in the guest
+	 * APIC backing page. Since doing this would increase the latency of
+	 * accessing x2APIC registers, instead of doing rdmsr/wrmsr based
+	 * accesses and handling apic register reads/writes in
+	 * #VC VMEXIT_AVIC_NOACCEL error condition, the read() and write()
+	 * callbacks of Secure AVIC driver directly read/write APIC register
+	 * from/to the guest APIC backing page.
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
+	case APIC_ICR:
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
+		return get_reg(backing_page, reg);
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
+			      "Reg offset 0x%x not aligned at 16 bytes", reg))
+			return 0;
+		return get_reg(backing_page, reg);
+	/* IRR and ALLOWED_IRR offset range */
+	case APIC_IRR ... APIC_IRR + 0x74:
+		/*
+		 * Either aligned at 16 bytes for valid IRR reg offset or a
+		 * valid Secure AVIC ALLOWED_IRR offset.
+		 */
+		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
+				IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)),
+			      "Misaligned IRR/ALLOWED_IRR reg offset 0x%x", reg))
+			return 0;
+		return get_reg(backing_page, reg);
+	default:
+		pr_err("Permission denied: read of Secure AVIC reg offset 0x%x\n", reg);
+		return 0;
+	}
+}
+
+#define SAVIC_NMI_REQ_OFFSET		0x278
+
+static void x2apic_savic_write(u32 reg, u32 data)
+{
+	void *backing_page = this_cpu_read(apic_backing_page);
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
+	case SAVIC_NMI_REQ_OFFSET:
+	case APIC_ESR:
+	case APIC_ICR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		set_reg(backing_page, reg, data);
+		break;
+	/* ALLOWED_IRR offsets are writable */
+	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
+		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
+			set_reg(backing_page, reg, data);
+			break;
+		}
+		fallthrough;
+	default:
+		pr_err("Permission denied: write to Secure AVIC reg offset 0x%x\n", reg);
+	}
+}
+
 static void x2apic_savic_send_IPI(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
@@ -136,8 +252,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 	.nmi_to_offline_cpu		= true,
 
-	.read				= native_apic_msr_read,
-	.write				= native_apic_msr_write,
+	.read				= x2apic_savic_read,
+	.write				= x2apic_savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
-- 
2.34.1


