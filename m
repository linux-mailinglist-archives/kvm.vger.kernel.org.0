Return-Path: <kvm+bounces-43546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E66D1A917A6
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69D103A6464
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A714222B8A0;
	Thu, 17 Apr 2025 09:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zEvcp4Ai"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2819B229B32;
	Thu, 17 Apr 2025 09:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881647; cv=fail; b=cpoUwaJO9TAL++ZtLx6e7bI/CwPU9tRc5T8PErgiBbd3eE94McVOR2SPT/MvrOodOQeXDLtZFhwWRfvR538YZI/hZnSQsHLKZF66dVEQslWxDoRRU/m/Tx0bg8SvtVInT5LZn4oZZ+PLnvkCWg420KL3cqVeGBv75Z+d7kO+kNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881647; c=relaxed/simple;
	bh=W+MzOeOpn4LxWMK3WZt4QJPDbPmTBAsV+DEMkFH2vKQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gsWZZgiMCUV2PTivzuEtD/pt95G24Bb+YqKRn1CnT9BQW0iAhJzU/QDFPF4LtKnak5VG7tYRYD6qcKgFq78twXDJF+TNPpq5IMvMmf/ge3ADTmFIQNHViB+nY4mDYi/P1m4CW88xszEEshYzFFl1nx8YE0JZDHs6tuDruPXvh7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zEvcp4Ai; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYolLw8hrH3tHwO3F0WOoQcAQA2nfHghHJPf3vVp5w08AVw/h+hTYdhS4aQ78FQt2+tP39GO17ncIvpkpeAKn4K+mMWv2g9CyKjZS4NnkbFwObUBC9yDuusMmtJS7n76MnBmnwXN2rFNHl0PLv9aCtU/7bu4+uGEoIvVyhQpheJVXlfONR/W/FqSxy1IcLQDBxwLhgJt0c9fGhcyI1gnGTRprnxR/OWhYtAYD4feC5Cq6ZOhIbLI7mB59bsYzTuZ1GYzBfx6K82Q5pesXkQjAj0PqFwTuidgjTAxEasX5Fgp14O79FN43diwkGGAuAYggd71Tfm9T/wSHknm2Tgk/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9iyhafnf+VaVROXOo83oyrQKc88VdUTQtIy93Xjxb7I=;
 b=yBKKZqRkWre00J23phyZY+oxvS/aJVE/bVpE9j/tq3GUCA3RmyAy5GMCUpW+muxBY5GJmWu24Jm/qcvM7aFY0v+TC7Ht94OqmV52/i1dBkI3F0wFoJ5428aZygpbpf+pU++gK/P1trgSCda/mcNmQpKQ+zqs2xqi9uJjjDLMF9YkZholkCs21Jw+jX+jWDtpbrzyGY9jjaQYNbqgg2cRZtPtacRsN/8YVs2zG/dM2Bi71/Wgt0g+6jGpj8CftpcTLJQWhQhbPrCnwsiC1iJMkn6LkXtGbMxv9i850gLsUvp16t2fzE1sIqMt3dRSMZ63RzBJnldfBt2kLwf/vY+PFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9iyhafnf+VaVROXOo83oyrQKc88VdUTQtIy93Xjxb7I=;
 b=zEvcp4AiB018GjXwg2+EKOTe887YitSXD8JrkTh+/MHx+q2Wpt7jCL0aZWuXMG1TMZlMv7ZAE7jouUZYAaN9+mwjIaQQZJAbOGVcBa/8UHDfvA4uCqUzdNwuU5iBY6lBSalPPJWTaRO3tLKkDnkmL/+WbBQokxZ7iNON1bdY/a0=
Received: from BN9PR03CA0189.namprd03.prod.outlook.com (2603:10b6:408:f9::14)
 by SA1PR12MB5615.namprd12.prod.outlook.com (2603:10b6:806:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Thu, 17 Apr
 2025 09:20:41 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:f9:cafe::df) by BN9PR03CA0189.outlook.office365.com
 (2603:10b6:408:f9::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.23 via Frontend Transport; Thu,
 17 Apr 2025 09:20:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.4 via Frontend Transport; Thu, 17 Apr 2025 09:20:41 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:20:33 -0500
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
Subject: [PATCH v4 08/18] x86/apic: Support LAPIC timer for Secure AVIC
Date: Thu, 17 Apr 2025 14:46:58 +0530
Message-ID: <20250417091708.215826-9-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|SA1PR12MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: df5044e6-6c18-47f6-5037-08dd7d911fec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7BSvfJjsCpp/F4RntKOeIX9y8kNvkcy5rMfAZOBulCCQRFU+/XYMF8eoAQlO?=
 =?us-ascii?Q?Y1BX8p/UobDAZzTmA3Vsnm9B+0VYrNWhNrPpcsxii2cvGzuwlvVOhjKnim+n?=
 =?us-ascii?Q?d6sZ2qOfStivwzNcRoMmB6guKvx+GmkCN50DKiKc/q4Cc5f8REQ+BEc+AmHq?=
 =?us-ascii?Q?S2pHTGkjNUxf7RlxO9jroHLoiU27+9aTPW4eT9hidX9HkqbFYiis417HgVXk?=
 =?us-ascii?Q?YRkBgcNrzXe8Iljm9mSr+j0L9bZdgttT3RYZyqu+ocBy76wwOMvJNfUa2rKw?=
 =?us-ascii?Q?/wqIq6YSUSLI7hTyAMtdop9sRCxodkjtPlt2zchd6UX+uPtH7yArFNWQ3v6D?=
 =?us-ascii?Q?lP+OYk9SyG7WqLuJksbdW7Mo2tSuh/dgSbJx+nMMnZNxI3dZvEEMlAKoPOTx?=
 =?us-ascii?Q?hOwGJDCwE5Tr4fFd5Q7y/Aj4mRmC5OG4iz5SjVl4XgsCpswVma4kuk3y/3lj?=
 =?us-ascii?Q?eP5xFNgR55FetyFJuIVxkH6CGoSh/J/I3hiUne+Uvx2EKqNkJNBpX3eUxORX?=
 =?us-ascii?Q?EakEdQlKcs12eBmerLnD+05xT03jzJL1XrANRwMmHWQ8XxinRBdAiSgbfMW0?=
 =?us-ascii?Q?+mhIoBsib2bTm8H/RBR624Ph09jdwyxnukuqpdhbLLfKhi0uZWzEuvYctkeE?=
 =?us-ascii?Q?7MIDGbmpA3mjKssyCQc2dMCZpv2UUpk5FTYyc2880rk7TVFSEkqb7DW1QM67?=
 =?us-ascii?Q?4Skng0tZXw8/7tEcW5LKt9AHVzlavNVNR6ucu1Fm44an0XG1DI6pGzH48nvq?=
 =?us-ascii?Q?Jh/rkdQ3kVcwoOhE6Kc2E3B929GWLgnhHoa+Nw6h9DmwSUlcfCQGzW9vpgNo?=
 =?us-ascii?Q?QvxKXAWmMzVOrDig/Lu86L/kkQLGbcJikLP/oEOe4/7kJpqffoWhuS/rFsxX?=
 =?us-ascii?Q?1lkrp2gCSRlS2FAziWZPtlH9oAAJMbT+9BTG1BtEzX6XiLbq1VCO+IJUMR+Z?=
 =?us-ascii?Q?BAFj0RVXvwMdw/9i/dStKsAiYw9TrR6750NydH/G6CRbdKhoeVfHB54IL6SY?=
 =?us-ascii?Q?sbAuFPjtckqQElGScmyCMqjN14eSdqGbCMV5XCgTKNiZqKCBPcHnPXcNbZ/p?=
 =?us-ascii?Q?6rweJuboZRz6H67iHqi8JVVmftU2n8l7T+VJRLGA5Q1qdeae04RRaE3rr3XB?=
 =?us-ascii?Q?VnPWqpBVgUNEXC2ndDR8uXbdav08nzMgPatcFemfOpamcysPEpLNNTtINE27?=
 =?us-ascii?Q?KQMQLvTGMGcF5/Ij5ec4KtkBF2YxyHW6u42LSB3LF0KVvHld2aX0sw7NfIzS?=
 =?us-ascii?Q?h3lXYy1q2xkD4N2vS8huxjoQyzcsmE230cYMe1z06nM0sDGrz/WarMZmulZ8?=
 =?us-ascii?Q?Nu+ZDgK9ykmFilZMBGb1ErPV9cl0SDKWTxlGdsQsm1JYlYtKCQ8TcC0+6wVU?=
 =?us-ascii?Q?+r/5+HWQ+/QDZURdrwDjEkCeG25haTiX41DexA7iP9nEgg9uJLgjqIaohQeM?=
 =?us-ascii?Q?4f7xLmD5qm+C+aO3tjYh+Iqp1W5sGrkINpEZ2bb7I1jlNHdwwYse5YLguGrW?=
 =?us-ascii?Q?q9lXt5op/jw3jTq8PaUqzBEG50iORMNxAz24?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:20:41.5359
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df5044e6-6c18-47f6-5037-08dd7d911fec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5615

Secure AVIC requires LAPIC timer to be emulated by the hypervisor.
KVM already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Remove apic_update_vector() static call.
 - Use guard(irqsave)() in savic_ghcb_msr_read().

 arch/x86/coco/sev/core.c            | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 603110703605..aa335e0862eb 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1420,6 +1420,32 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return __vc_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
 }
 
+u64 savic_ghcb_msr_read(u32 reg)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = { .cx = msr };
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
+	res = __vc_handle_msr(ghcb, &ctxt, false);
+	if (res != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) read returned error (%d)\n", msr, res);
+		/* MSR read failures are treated as fatal errors */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+
+	return regs.ax | regs.dx << 32;
+}
+
 void savic_ghcb_msr_write(u32 reg, u64 value)
 {
 	u64 msr = APIC_BASE_MSR + (reg >> 4);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2056e7be41d0..fab71d311135 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
@@ -574,6 +575,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
+static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 839397eab8fc..bad60bcb80e7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -591,6 +591,8 @@ static void setup_APIC_timer(void)
 						0xF, ~0UL);
 	} else
 		clockevents_register_device(levt);
+
+	apic_update_vector(smp_processor_id(), LOCAL_TIMER_VECTOR, true);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index d3e585881c5c..69605e14ab75 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -92,6 +92,7 @@ static u32 savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -152,10 +153,12 @@ static void savic_write(u32 reg, u32 data)
 {
 	switch (reg) {
 	case APIC_LVTT:
-	case APIC_LVT0:
-	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
+		savic_ghcb_msr_write(reg, data);
+		break;
+	case APIC_LVT0:
+	case APIC_LVT1:
 	case APIC_TASKPRI:
 	case APIC_EOI:
 	case APIC_SPIV:
-- 
2.34.1


