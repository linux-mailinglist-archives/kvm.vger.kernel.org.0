Return-Path: <kvm+bounces-56092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DBAB39B0E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 572B8983512
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EBB30DD1D;
	Thu, 28 Aug 2025 11:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QRtIENEU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B14E2165E9;
	Thu, 28 Aug 2025 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379330; cv=fail; b=l4hIL4yfvVdN7IHBzqNn0UGlOkJo4zqMJzKKfZ3BVi5LJK1k3bPFGwlXXKwHsOrStU6coVtA685TiLhwrObRCbsypuIuhQnFZk9VeJq0aWvbap3EOaDqLXjpYs1NvXAYuMvLJCZ/g/xvfkkiArCnoOKLTpVV+al7OLE96XS6p9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379330; c=relaxed/simple;
	bh=s+lZrDTx5/LIKsHlx0hhxAdnccO8t2ZrXP+WnmWcGs8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXGRYJxbYuzIKJK49MXEnuThnhe78RSmjFtIrB4k/XkW+xS0CzyzynWdxeSC0DaR7fAA0M8c+ywzS4om6XXfq9U/4kDWUeUWrKIzC8OewxGKCP9DB3veP7KbSmsfuw7f8e35gEJZlmPnSo5qLzAALxxn7VGjf2v+PBd/Yl7eiEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QRtIENEU; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qC5iSPWXHUAHM20kcJQHu5HVbgQ8gS3tDTBb9dDVJvv4tzxgCNztf/UuXK6ybyiu/wSPs4bl1lWpvQG5gPfhQVj4oB91eUk95WM3ub41GaQtsyNXQDKG+C10KQEbuU6jsxT7+yPxdnXQ0+1NDoGkYPe6BgRxJe7yUP0mI1QVH2Z6/LlGgZrsSg1oFQRVA8DxYaI2cxPaAy4W8Ati7DBkxFh/NUCCOjr6SWn9zcMSrISEfdaQ/pNgGkcmzTA+psmBXXjUgfiNZmL4BQm5Rscl5pvTY1yDuB1ftzSFT+CN85AoW247rnZoLI5N5NVtqyUTcyUlLEgOYNZlFM8O0F770g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOdvOcSu9JHNShdcqqlNSwpAN33AraqsRTpmxrXguU8=;
 b=jqdwjM/BB83VjldttVzDhd3/JFoEwc3pLmilulzuCCk6Y+X2DrdVyeUnSJPaRt7fNlAw90pLvw5tIh+rkyQTbH0oAWdU6cGcFp3j78B1lzxfEGvyyq0Oi2A4m/rxBEb4DrCyBTUsYiJmcX51jBElBczt4rWlNUokUPfj5Mk7Xv6XMcuREj7hMtz/Lg6ZV/mxXURZtKfJo20Fnrgwu+1gZT5UuWACZupQHNupeSj5TkUSDsfQwVpi75dwnG4wOXDeyFAJjAySyxgHC8hXPL7KSdhzoYm8ROkEHQX4nwyUdqOB4w9HlfjK44ZzWba1EOHNKA3L0M7+ZDAy/HS1fQwXvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOdvOcSu9JHNShdcqqlNSwpAN33AraqsRTpmxrXguU8=;
 b=QRtIENEU8+rdUv9lQnuXq1oDnCh6Ff6xyk96ks8x4xMTXF/In7LYc9TAqDdKHZWlfoQj5fYMFdriQuodTw8ozRBZ8vLwjTZnb4GWfIQksBOQdqpCvvaSuGC5rDzZhhJQqJPgzMQdPEO7YlCwTh9pnE5d/Y9SpmKFDRSgx8ncpPg=
Received: from BN9PR03CA0803.namprd03.prod.outlook.com (2603:10b6:408:13f::28)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 11:08:40 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:408:13f:cafe::4e) by BN9PR03CA0803.outlook.office365.com
 (2603:10b6:408:13f::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.16 via Frontend Transport; Thu,
 28 Aug 2025 11:08:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:08:39 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:08:39 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:08:32 -0700
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
Subject: [PATCH v10 07/18] x86/apic: Add support to send IPI for Secure AVIC
Date: Thu, 28 Aug 2025 16:38:24 +0530
Message-ID: <20250828110824.208851-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|CH2PR12MB4038:EE_
X-MS-Office365-Filtering-Correlation-Id: 175480e1-2a73-462b-08f8-08dde6233e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DOzsKf20NbED1k4illqoRILbdVCtuMAA2r/KDUdmlDIprzop9ZJgyvgtVxwr?=
 =?us-ascii?Q?fBwS0WIcFTYjwN/EqsuuMfJbP0Uyomsi3FtQMdirackwz9CSgbnLxxYSnwg6?=
 =?us-ascii?Q?wrVF/tarRXjg47rMpYR0VUFIU2uRTTI02lxEat9W5YojPzTafEe80xMiUCMT?=
 =?us-ascii?Q?DeM5heT82pmnwxRJBpUU6FvXhl39ggWg8ffDfvfOju/m37VwYe9ncnh3gxmO?=
 =?us-ascii?Q?qS1aOVOdHvzZfQa4GJlhowKI1s+mMlnH5r/ZhK2RB2Fi+0oPxysu3p7gPjAR?=
 =?us-ascii?Q?4nFsSpZJQIFQH4TJkm+w/xaz0WX248pwTB9Kd17zLa+gHgiLULIdlIbor/Qp?=
 =?us-ascii?Q?RE0WAW5+VsOXWBKx4j200VZhmIGGlJ94jiLlup7Y1DJm0wybgxxe9tXapkIM?=
 =?us-ascii?Q?L3227iyYgI0mwG5HZ1/NAYGCuvsFC7cscURvIOvuC7HwdAZX6yDL9/8JaiX0?=
 =?us-ascii?Q?1VghV2KzBtjeQBEUwLq0mMK0FI/VDE2jWjjmBFxeNNE9dqAYCQhxDq6CBjv8?=
 =?us-ascii?Q?WGes0wfH7D+jsnBOxyemEAthYrMVsjknEapJwxX60W6oAfDQl3eId7Ne7lcY?=
 =?us-ascii?Q?Dzz/48TpXBHSz6EdWb19q3rOQsu7Pj+NIx//E2xiUPe78C9BMM9INXghAE11?=
 =?us-ascii?Q?ol/vvRdnY5Gv5qObb0auZngP28f4YM6QvRRB9PJpQsAl6I/+0PZch68j69FP?=
 =?us-ascii?Q?bQE8u0TuINJaaErprKV8nKPL6C08BgpH0HBjJip+kCv4QQ1bmJ2RPi5VXU46?=
 =?us-ascii?Q?FolyHViKPVln06uFiWMV0j4W0j0hhUyW5aRhanhZ1DtKfak6jySUIHEyU+9P?=
 =?us-ascii?Q?HVkqqV0ONYjZMSRBF8+i4+RYd3hj/eUsFcinksHgEgEy1zbKeiGsmlArzepf?=
 =?us-ascii?Q?42RTImp4ZiJZoYkz37GU7L0/AJTmXknsdBL59S9chYQp+8nJY/uub/Tw3IHB?=
 =?us-ascii?Q?XqqX5dc8elQbWNu3bidYcW384higm+qyt+xdXPn+RSMmKfF8VrMAPWAMoZMZ?=
 =?us-ascii?Q?jL5FpiQNiYLt965XT0AQFGaMkC8YykLKgHq0wcOa8+Gnl85076LMxlIWRt2u?=
 =?us-ascii?Q?85hKRX19Ez+8lEqkNF7ezCMwkCWkzQH+zInMwl6p4bLdeHu1hDyeghu+Tohn?=
 =?us-ascii?Q?PO2olfdCoh6mXbfm/k1sD7n3Hx75mQwcWUdEAu4ZeZeil2J4tKXbISwy4B+X?=
 =?us-ascii?Q?FAr5qHbbU3vslJ02bAyyRZQr9LWrs+bqpueqa6xfKZzHLs3ejC+UCpXfcdCt?=
 =?us-ascii?Q?bdqt5/KpOoyy/dWcStJwcBIOpYYklMfkwYck3XRnhEB7aMPYAO+2QWPlSNaj?=
 =?us-ascii?Q?KEjLPwsZx2wywbNd+7Ev2fUIDIFtBk+AD//l92InR3wx7fGafHyebECpiycZ?=
 =?us-ascii?Q?8OIj6xaa8DjscppPP2JjCf5xSIqW9Dy50SwJnsWsv/jZlstTU1QswRWp8lEZ?=
 =?us-ascii?Q?Pw89VJuJPoPf2jGPeT9rX8SoQ2WcsfgT+MGlC5PEbwp+vfzHc9ZpTa/pKXlv?=
 =?us-ascii?Q?l9/t+YEBi37BpARSssym8psWaokh6eVHmD/z?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:08:39.9454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 175480e1-2a73-462b-08f8-08dde6233e4c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038

Secure AVIC hardware only accelerates Self-IPI, i.e. on WRMSR to
APIC_SELF_IPI and APIC_ICR (with destination shorthand equal to Self)
registers, hardware takes care of updating the APIC_IRR in the APIC
backing page of the vCPU. For other IPI types (cross-vCPU, broadcast
IPIs), software needs to take care of updating the APIC_IRR state of the
target vCPUs and to ensure that the target vCPUs notice the new pending
interrupt.

Add new callbacks in the Secure AVIC driver for sending IPI requests.
These callbacks update the IRR in the target guest vCPU's APIC backing
page. To ensure that the remote vCPU notices the new pending interrupt,
reuse the GHCB MSR handling code in vc_handle_msr() to issue APIC_ICR
MSR-write GHCB protocol event to the hypervisor. For Secure AVIC guests,
on APIC_ICR write MSR exits, the hypervisor notifies the target vCPU by
either sending an AVIC doorbell (if target vCPU is running) or by waking
up the non-running target vCPU.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:

 - Commit log and comments update to uppercase instruction
   name.

 arch/x86/coco/sev/core.c            |  28 ++++++
 arch/x86/coco/sev/vc-handle.c       |  11 ++-
 arch/x86/include/asm/sev-internal.h |   2 +
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 138 +++++++++++++++++++++++++++-
 5 files changed, 173 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 7669aafcad95..bb33fc2265db 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1108,6 +1108,34 @@ int __init sev_es_efi_map_ghcbs_cas(pgd_t *pgd)
 	return 0;
 }
 
+void savic_ghcb_msr_write(u32 reg, u64 value)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = {
+		.cx = msr,
+		.ax = lower_32_bits(value),
+		.dx = upper_32_bits(value)
+	};
+	struct es_em_ctxt ctxt = { .regs = &regs };
+	struct ghcb_state state;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	res = sev_es_ghcb_handle_msr(ghcb, &ctxt, true);
+	if (res != ES_OK) {
+		pr_err("Secure AVIC MSR (0x%llx) write returned error (%d)\n", msr, res);
+		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+}
+
 enum es_result savic_register_gpa(u64 gpa)
 {
 	struct ghcb_state state;
diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
index c3b4acbde0d8..c1aa10ce9d54 100644
--- a/arch/x86/coco/sev/vc-handle.c
+++ b/arch/x86/coco/sev/vc-handle.c
@@ -402,14 +402,10 @@ static enum es_result __vc_handle_secure_tsc_msrs(struct es_em_ctxt *ctxt, bool
 	return ES_OK;
 }
 
-static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)
 {
 	struct pt_regs *regs = ctxt->regs;
 	enum es_result ret;
-	bool write;
-
-	/* Is it a WRMSR? */
-	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
 	switch (regs->cx) {
 	case MSR_SVSM_CAA:
@@ -439,6 +435,11 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	return sev_es_ghcb_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
+}
+
 static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
 {
 	int trapnr = ctxt->fi.vector;
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index 3dfd306d1c9e..6876655183a6 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -97,6 +97,8 @@ static __always_inline void sev_es_wr_ghcb_msr(u64 val)
 	native_wrmsr(MSR_AMD64_SEV_ES_GHCB, low, high);
 }
 
+enum es_result sev_es_ghcb_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write);
+
 void snp_register_ghcb_early(unsigned long paddr);
 bool sev_es_negotiate_protocol(void);
 bool sev_es_check_cpu_features(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9036122a6d45..fa2864eb3e20 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -534,6 +534,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
@@ -607,6 +608,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 942d3aa25082..47dfbf0c5ec5 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/cc_platform.h>
+#include <linux/cpumask.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
 
@@ -120,6 +121,73 @@ static u32 savic_read(u32 reg)
 
 #define SAVIC_NMI_REQ		0x278
 
+/*
+ * On WRMSR to APIC_SELF_IPI register by the guest, Secure AVIC hardware
+ * updates the APIC_IRR in the APIC backing page of the vCPU. In addition,
+ * hardware evaluates the new APIC_IRR update for interrupt injection to
+ * the vCPU. So, self IPIs are hardware-accelerated.
+ */
+static inline void self_ipi_reg_write(unsigned int vector)
+{
+	native_apic_msr_write(APIC_SELF_IPI, vector);
+}
+
+static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+{
+	update_vector(cpu, APIC_IRR, vector, true);
+}
+
+static void send_ipi_allbut(unsigned int vector)
+{
+	unsigned int cpu, src_cpu;
+
+	guard(irqsave)();
+
+	src_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		if (cpu == src_cpu)
+			continue;
+		send_ipi_dest(cpu, vector);
+	}
+}
+
+static inline void self_ipi(unsigned int vector)
+{
+	u32 icr_low = APIC_SELF_IPI | vector;
+
+	native_x2apic_icr_write(icr_low, 0);
+}
+
+static void savic_icr_write(u32 icr_low, u32 icr_high)
+{
+	unsigned int dsh, vector;
+	u64 icr_data;
+
+	dsh = icr_low & APIC_DEST_ALLBUT;
+	vector = icr_low & APIC_VECTOR_MASK;
+
+	switch (dsh) {
+	case APIC_DEST_SELF:
+		self_ipi(vector);
+		break;
+	case APIC_DEST_ALLINC:
+		self_ipi(vector);
+		fallthrough;
+	case APIC_DEST_ALLBUT:
+		send_ipi_allbut(vector);
+		break;
+	default:
+		send_ipi_dest(icr_high, vector);
+		break;
+	}
+
+	icr_data = ((u64)icr_high) << 32 | icr_low;
+	if (dsh != APIC_DEST_SELF)
+		savic_ghcb_msr_write(APIC_ICR, icr_data);
+	apic_set_reg64(this_cpu_ptr(savic_page), APIC_ICR, icr_data);
+}
+
 static void savic_write(u32 reg, u32 data)
 {
 	void *ap = this_cpu_ptr(savic_page);
@@ -130,7 +198,6 @@ static void savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
@@ -146,7 +213,10 @@ static void savic_write(u32 reg, u32 data)
 		apic_set_reg(ap, reg, data);
 		break;
 	case APIC_ICR:
-		apic_set_reg64(ap, reg, (u64)data);
+		savic_icr_write(data, 0);
+		break;
+	case APIC_SELF_IPI:
+		self_ipi_reg_write(data);
 		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
@@ -160,6 +230,61 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void send_ipi(u32 dest, unsigned int vector, unsigned int dsh)
+{
+	unsigned int icr_low;
+
+	icr_low = __prepare_ICR(dsh, vector, APIC_DEST_PHYSICAL);
+	savic_icr_write(icr_low, dest);
+}
+
+static void savic_send_ipi(int cpu, int vector)
+{
+	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
+
+	send_ipi(dest, vector, 0);
+}
+
+static void send_ipi_mask(const struct cpumask *mask, unsigned int vector, bool excl_self)
+{
+	unsigned int cpu, this_cpu;
+
+	guard(irqsave)();
+
+	this_cpu = raw_smp_processor_id();
+
+	for_each_cpu(cpu, mask) {
+		if (excl_self && cpu == this_cpu)
+			continue;
+		send_ipi(per_cpu(x86_cpu_to_apicid, cpu), vector, 0);
+	}
+}
+
+static void savic_send_ipi_mask(const struct cpumask *mask, int vector)
+{
+	send_ipi_mask(mask, vector, false);
+}
+
+static void savic_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
+{
+	send_ipi_mask(mask, vector, true);
+}
+
+static void savic_send_ipi_allbutself(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLBUT);
+}
+
+static void savic_send_ipi_all(int vector)
+{
+	send_ipi(0, vector, APIC_DEST_ALLINC);
+}
+
+static void savic_send_ipi_self(int vector)
+{
+	self_ipi_reg_write(vector);
+}
+
 static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 {
 	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
@@ -231,13 +356,20 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.calc_dest_apicid		= apic_default_calc_apicid,
 
+	.send_IPI			= savic_send_ipi,
+	.send_IPI_mask			= savic_send_ipi_mask,
+	.send_IPI_mask_allbutself	= savic_send_ipi_mask_allbutself,
+	.send_IPI_allbutself		= savic_send_ipi_allbutself,
+	.send_IPI_all			= savic_send_ipi_all,
+	.send_IPI_self			= savic_send_ipi_self,
+
 	.nmi_to_offline_cpu		= true,
 
 	.read				= savic_read,
 	.write				= savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
-	.icr_write			= native_x2apic_icr_write,
+	.icr_write			= savic_icr_write,
 
 	.update_vector			= savic_update_vector,
 };
-- 
2.34.1


