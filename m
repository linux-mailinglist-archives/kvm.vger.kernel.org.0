Return-Path: <kvm+bounces-56054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE17B39813
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA5FF1B27589
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131352D0C6F;
	Thu, 28 Aug 2025 09:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uU/khuE1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8309A18C011;
	Thu, 28 Aug 2025 09:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372866; cv=fail; b=c0J4LOL6x5fqjXOEWs7bhkG/SjVsWYzwTn/1p6m9z1Z1+frlpf5UppLAejQ0jUiWwbdq8VP2uaYXXLZqBUBC7kV3a8n9VR+V4s51SCJFXwxYs4KGv92hO8vM8Wfcgo2Z5VHeZlyIpawQBNcDt3ivvUly49VpM8B3ccZ0zd4vuGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372866; c=relaxed/simple;
	bh=XoRxKMv52/s8vK+EwCU5q+qg5QlMilgNsX2NYuAs+W8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ux/+xKDG3Ik/u5lJY/j3O+vc9siwe9ysgP00VTHtkiMul3/WeHRdTcqjKd2+inhBv//V9w9or09mYeP6qKuLRUg7dqiqUcqKhewUGRln8mpCMN2vdBqfw6zOUyRXDrO9782JP/fUX52gAeZzFUH/4dicF2dBwkhXL1g2G9S7Mr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uU/khuE1; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EX4YT687ge0qh8cn/u6ICqXXx9XqEuSwh9TAA8uT6u2HDrP75U6jLFy30oFmS31/4+13qjx/3zaCC3UhupMgZBLEHAq66XTu8SRasAfeAsJ66XOT4e+B2a4SiFUxVMr5onZEfD7cFhow6O8RvWB4xiSe67G0FaK69aGij2SnE41cfYRKYlA42Umvuea0zgifHnxLp50B9OSGGqFRZ4oWP1kfTdL0xGzqSdkkNuFgniwpOBl+7dJHpC33HjKehEEh1evW3+8nppUQdWzZxWaneQ/Rq3TKd9gNxlfBCKuMg/hM8cEjABf/vU/CXCF/0vimRBYdlvP/2pXLj3PqiX+UeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/tpKY6KEnBtcNC9boBtX7q2L2Qpahog3LG0mTbhCzI=;
 b=Mgbh14p8mr/fW8gsPlI3NmoW7Gfhg5KY9JudklDm089wx4cDFGN7f9fz87fspxu8Ttm47rKffUtYxBAgBm8mgUrjai3ZRk+RpXhJuHqquJN/d8Qz5oWMfUlR1NQmoFRfrsrsnYqHQet0LhHsWYFYXCi7+GMQJCGrSxNhcB47IqFjrYUJXhqUYNpbl4+M7Sc66kMSoKtd80n7kJJxq73URY9bv0dVqoCh+t/Cx/V0mlRI0C0c46SrS529MvMI0OxlSPpdVAgB2BgRAV2VtVFG6NbscXshRtqEfIx4eHCIQo4pta3ERJ7Pi+pLmYUuRpr7tqUVoxmTsCCOutbv6YXKQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/tpKY6KEnBtcNC9boBtX7q2L2Qpahog3LG0mTbhCzI=;
 b=uU/khuE1dyaPJmL9fygL99LWxlM/uRzJMsN86H9Py1PEN+jO6wv8589yBEfvMd5XH71Uew+K6EJ230U2ysZGhKL/uJyvUOS3tWq+q97uwU7lsz7SNjHivyELmLUjjbAQQi+R2RYc49+uMNXyvBaKXcAZn7RzAbxsFbEyhk70SPs=
Received: from MN0P221CA0029.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::20)
 by MW4PR12MB6803.namprd12.prod.outlook.com (2603:10b6:303:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Thu, 28 Aug
 2025 09:20:58 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:52a:cafe::2a) by MN0P221CA0029.outlook.office365.com
 (2603:10b6:208:52a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.19 via Frontend Transport; Thu,
 28 Aug 2025 09:20:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 09:20:58 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 02:04:25 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 00:04:19 -0700
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
Subject: [PATCH v10 02/18] x86/apic: Initialize Secure AVIC APIC backing page
Date: Thu, 28 Aug 2025 12:33:18 +0530
Message-ID: <20250828070334.208401-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|MW4PR12MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: db52ad97-8b1b-4c42-285e-08dde61432ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Y2W1kIZfZ8aR2JvAgfK74iP+cPELcpCwGdg+IHPar5trPB4tRfWb/pXjHnx?=
 =?us-ascii?Q?uTnGGjEscRgQnDIvIc1EzvicjtaYnJXUkq2lGhGBZkLy6UoSZbEKsrJyVPe3?=
 =?us-ascii?Q?Sktn+psU7Kv+4CyIxZF1D4n6qGBo9sHG/4a32upL2pMH68SXA+C1rfxvlzF0?=
 =?us-ascii?Q?RbyokX2BOQljS/V7ey5y9v8UeN/Dh+BmpMVfx3GgZOMW6Tg5ex7sNRMWKpYK?=
 =?us-ascii?Q?h6o3frEphwKuAqOjfrOYycHclp9EGQ7dgEzRVnYE5NzZIGbBGaW7Y34VTmDj?=
 =?us-ascii?Q?PCVq0WRF6+BPo7pbDQM9gQhgg2EeHvsd41vHS9kTFcCGtm7MUnYHfs2iqCk1?=
 =?us-ascii?Q?Ow+MoqEQWy7Bzw2itcrOoasARRXxoLqGjJTzRp1kQJTMApnhYEYmMSDqy+ra?=
 =?us-ascii?Q?QMBlTHO+PDF4V9XC6fU6QpHxsrfGXGTmGuQtl9vxd0VgS+u7wPfG2cj1ht83?=
 =?us-ascii?Q?SClCcY8b6fconhVDGaTNOU8hCGV83ciCuqhaO1gWjkQ4gOVOa6wgLVt6gsos?=
 =?us-ascii?Q?qDy+2qpuCQzZB74NsjGBftqzZdLTR7bzwNcNlHujK/s1tDbpqQzIzlj2ICcg?=
 =?us-ascii?Q?lMGU4hGe61k6R2RpwU4kJB6Upvz+MSFjpp4iZaPaD9QaqPhWBiRDJymgfimK?=
 =?us-ascii?Q?Mts8LIF4v3uC1VKDbmr114ReFWeW5m9NUoL3EKkbRe84UoM76Id4nZYkvVyt?=
 =?us-ascii?Q?zYK/NLHtqLpXZ/gKSA/Zq152Mbbxj7Rlsg8KSIXpUhpdnEDvBqGHvkuN/mwX?=
 =?us-ascii?Q?j/ZlVynnXB2EgxJpHHMNzxXhmUM+esP8sYNMoq8gvtYBkNZhS9NaSjTwFLQX?=
 =?us-ascii?Q?Vp5h/+TVvCUXh1nVbU3UC/wwSMp+b4L6dZVr9GYRGlOzoqiM0LHKWnPhe6KD?=
 =?us-ascii?Q?Qxtl+zokxrLGB15dVG3dEXU46GNBO6afsxbzMU0mnBSvv17z5Ky8DZNarERs?=
 =?us-ascii?Q?szJcjd3S+5vBhd9nXo67vw4dLq1fcTtPHxnJJifOTZBSMeNddOwLRlXxPk8f?=
 =?us-ascii?Q?Dx6GOu/4eFPJqpAY8NXWFt7V8oWbS2X6hxjLZFGVxatvcn6jpXmLnIIC9J1/?=
 =?us-ascii?Q?eMS9mTQ5nvJqPnx2qY8WquIY3rGxNVM2W7fKc3wu8BIicNzzF2cBClvIY4Yg?=
 =?us-ascii?Q?k8ZvV7SW3I5LtdTShTjG3LXhQ4PVosQgnOZA5M1MTQvHncbip1bxsSTyR0+e?=
 =?us-ascii?Q?yW0ThLMyZ1d3TsA7IZFZ/kegSXYEl6CXkzcDjJdIBFuIcfG3qydLVWa6KsM/?=
 =?us-ascii?Q?/yev5zHXC4jsEJ1h3g6h1oyZUmGIk6BFh6bG/N1wJhxd39aWUmedN3FMRtq5?=
 =?us-ascii?Q?HH0s+e9eV6jE1MLLTK3fSBGMiij82nLkXMJn2+/cBJRxM7jYYyNY+a1le/Dn?=
 =?us-ascii?Q?f1EVoMZ5bl/AdJ+vaA3ZCrU6RScs3DQgBUsqkKX+Vz4QhEcWFtItvOT2x8ti?=
 =?us-ascii?Q?kaapxgfBJn/W5yg9NT/eNOPJtya06ZzRtHjG3BMoyInCp2ayJeIaYE+HvMkb?=
 =?us-ascii?Q?a8L1nJE/0CTwfhTMga+fvzE3+mH6SZTxA8tU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 09:20:58.0840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db52ad97-8b1b-4c42-285e-08dde61432ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6803

With Secure AVIC, the APIC backing page is owned and managed by the guest.
Allocate and initialize APIC backing page for all guest CPUs.

The NPT entry for a vCPU's APIC backing page must always be present when
the vCPU is running in order for Secure AVIC to function. A VMEXIT_BUSY
is returned on VMRUN and the vCPU cannot be resumed if the NPT entry for
the APIC backing page is not present. To handle this, notify GPA of the
vCPU's APIC backing page to the hypervisor by using the
SVM_VMGEXIT_SECURE_AVIC GHCB protocol event. Before executing VMRUN, the
hypervisor makes use of this information to make sure the APIC backing
page is mapped in the NPT.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:

 - Commit log update.
 - Change secure_avic_page var name to savic_page.

 arch/x86/coco/sev/core.c            | 22 ++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/include/uapi/asm/svm.h     |  4 ++++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 35 +++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index f7a549f650e9..7669aafcad95 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1108,6 +1108,28 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
 	return 0;
 }
 
+enum es_result savic_register_gpa(u64 gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
+	ghcb_set_rbx(ghcb, gpa);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_REGISTER_GPA, 0);
+
+	__sev_put_ghcb(&state);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 07ba4935e873..44b4080721a6 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -305,6 +305,7 @@ struct apic {
 
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
+	void	(*setup)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 02236962fdb1..9036122a6d45 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -533,6 +533,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
+enum es_result savic_register_gpa(u64 gpa);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -605,6 +606,7 @@ static inline int snp_send_guest_request(struct snp_msg_desc *mdesc,
 static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
+static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..650e3256ea7d 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -118,6 +118,10 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SAVIC			0x8000001a
+#define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
+#define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
+#define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d73ba5a7b623..36f1326fea2e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1503,6 +1503,9 @@ static void setup_local_APIC(void)
 		return;
 	}
 
+	if (apic->setup)
+		apic->setup();
+
 	/*
 	 * If this comes from kexec/kcrash the APIC might be enabled in
 	 * SPIV. Soft disable it before doing further initialization.
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index bea844f28192..948d89497baa 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,17 +8,47 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
 
 #include "local.h"
 
+struct secure_avic_page {
+	u8 regs[PAGE_SIZE];
+} __aligned(PAGE_SIZE);
+
+static struct secure_avic_page __percpu *savic_page __ro_after_init;
+
 static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static void savic_setup(void)
+{
+	void *ap = this_cpu_ptr(savic_page);
+	enum es_result res;
+	unsigned long gpa;
+
+	gpa = __pa(ap);
+
+	/*
+	 * The NPT entry for a vCPU's APIC backing page must always be
+	 * present when the vCPU is running in order for Secure AVIC to
+	 * function. A VMEXIT_BUSY is returned on VMRUN and the vCPU cannot
+	 * be resumed if the NPT entry for the APIC backing page is not
+	 * present. Notify GPA of the vCPU's APIC backing page to the
+	 * hypervisor by calling savic_register_gpa(). Before executing
+	 * VMRUN, the hypervisor makes use of this information to make sure
+	 * the APIC backing page is mapped in NPT.
+	 */
+	res = savic_register_gpa(gpa);
+	if (res != ES_OK)
+		snp_abort();
+}
+
 static int savic_probe(void)
 {
 	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
@@ -30,6 +60,10 @@ static int savic_probe(void)
 		/* unreachable */
 	}
 
+	savic_page = alloc_percpu(struct secure_avic_page);
+	if (!savic_page)
+		snp_abort();
+
 	return 1;
 }
 
@@ -38,6 +72,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.name				= "secure avic x2apic",
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
+	.setup				= savic_setup,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


