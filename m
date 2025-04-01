Return-Path: <kvm+bounces-42307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DE4A779B9
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E87B16BC8F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0531FC0FC;
	Tue,  1 Apr 2025 11:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p6q/3OkI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A121E1C22;
	Tue,  1 Apr 2025 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507530; cv=fail; b=Zi0uKw1cN1S2QrU/yiKaglpmaWYSiRxKuNDiTK3/my7HK2VWsYOp833S37FJw6dx4+ESt5ngeH7H4TL1io3cdQRuf+VG9Xj0iM9LPpm4n2TeJaWNdukLeInSI7ezZaVuCiH2fCX3ZuPkgKh3GHIJDccD0O3wJA4LvakhqeWBRpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507530; c=relaxed/simple;
	bh=R3Walva4TvYHCeoDX87PEfGddguC0Jc9EfENorDylUk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQSuWrEdB6HtLqs4n5MKW2WBdSiDW4Jdu9jofP/CXba1U+K26S1QeAgjuO3Jb7dgqfWZ0MLawX8m9LT/Trck1xk4b7JDN7Ja9X2rd4voQEhkvOIobZqllctj78k7CHCSOuoJqmahjuIB9FzON7HZu4bYWStu2uIB9icWt5wXe0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p6q/3OkI; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eP21b6WVzMyiXHRsiwoYGqXIEQ9NATrZyTAsP4ir+aDY/QGl7SUG83ssBF58Z1ghhJlJrxG6B2xPxDfpzStD+jDxnEZVWPVBSwYkspnoNsWgQZ7WqBTQB4kP5AqkfM4w9ILcyANhKMwLONjgbljt3r6djon2a2iBMXNB6EZKLSkhxRTeJiB+rVIGBilmD6Ss5vhJk23IsN545Tk/y3Py2Qb9mG83w81WjGY/2GP0h/S4HYjsoHP0YXUH/m7Ld9lSxoDcm0hn18svGE7wrUlANVv85QW8prAat5sy8OxloEa4VFxN3698BZmV1lsY5FwzxPZ2vmyAME2TpoZNl+pKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94U1IXp2DQDZznDtEb05nXOBV9doTs9pWgcKZFdBi6M=;
 b=YnBvDtYLOtYoc0SGo6awLdso7bklVNKyNcO2g62mQ5vpkgQQg4/mdKFRO16fQ0xrtclBSZ1j9PKmZRR3Li+unHTWpDRjc4cTgvQf6Gysk9P5uWZ1os31TA99TNCHi0xAZQ4nPXe1IHpb/4aDR2N4k9i/oTiGFSmiucnTEevRPmlBGwAnD6CPNHWrpBrPZExwTgJ5Y6IviBPArDWvU25MTzkOWRCW/nSjQZzzdydGw7pgsFaEbgO8ve1q06B/CVKWJuvgF2VvNHDhKMveGSY7yUluTe1WRYF31sPmWi7MTNJnZejyCwio238ukqwbgob1Cm2AKeqjstq5eV81kakUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94U1IXp2DQDZznDtEb05nXOBV9doTs9pWgcKZFdBi6M=;
 b=p6q/3OkIbx5P5VhGWOMfDcxZYL9EUv1z5m6zhcCGvzQ1pTpOCWmyZkq7t678BSbDYC30KDlWpelWvSsfm2sEKRWftgeG8IySMabUcvY8Uqos9aoPoZF9t9fq1khkTu6eBWghJgjMjHRG4Nla0K3pmiv+PtopKSpaN2lUmpDQWa0=
Received: from PH7P220CA0120.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::22)
 by PH0PR12MB7958.namprd12.prod.outlook.com (2603:10b6:510:285::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Tue, 1 Apr
 2025 11:38:44 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:510:32d:cafe::95) by PH7P220CA0120.outlook.office365.com
 (2603:10b6:510:32d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8583.39 via Frontend Transport; Tue,
 1 Apr 2025 11:38:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:38:43 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:38:37 -0500
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
Subject: [PATCH v3 07/17] x86/apic: Support LAPIC timer for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:06 +0530
Message-ID: <20250401113616.204203-8-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|PH0PR12MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: 8383f1dd-a88c-46e1-baa2-08dd7111c1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/dWKusUEqU89Vpb6qAp4rvacU4KaDgg1+ZLXVgLUpmiO0SvnGTLGymnubKTG?=
 =?us-ascii?Q?m/9gLwxkaggPxv4+rxoLMMQK0Vg3tm2bIW5014a19cxLrm9ZwWxkjKmy8id5?=
 =?us-ascii?Q?dCHGsCkBvV0oDXDLyBsEv0vBQO187JXl4gtCfezDkGCl4wCNoCU2Uy8icSh2?=
 =?us-ascii?Q?100H/6ijLk6PD8niaP92UMIsE9fyFaIakSR8TwXIbUF4PJjT8xkBju/OtCwP?=
 =?us-ascii?Q?vLnREMyBU5S9NDz+xIoanrWVAHZ/uOcqpjI4XyS0GYoG3TqLYheybePdFGA5?=
 =?us-ascii?Q?0WccuitKLo32ZV9aQrVMzAMdJ9DF+K++4sAbkx+BA8QaG/uj2EiDChd5m+cd?=
 =?us-ascii?Q?TcQEYzsJ2EWyIbsp2qgdbW3Wu83wpJbJ1016qRRuo8/9zifTDzvadGaM8823?=
 =?us-ascii?Q?/BOzxKNKpHHtoTHhP33D47yia/oMNQMHV37DzvG2/4YoLSqxNXyYlZmwr1QG?=
 =?us-ascii?Q?Te69PI7O8diakyemPt5Q6l4x/vq++Wp16K8PzI8ZZKOmW4SaEUyAbncxZWfy?=
 =?us-ascii?Q?ISyHvRrM1wQN9dLYhIMSfmAS62FG/fkfYAIPWgeRoIN4xd0sp9z/laPlrOMI?=
 =?us-ascii?Q?+sJK/yHN2vfEU3IaWUxXQ1+o3PGwsaLFeYb77e+yU+kdTRupM32j6dWAFMXN?=
 =?us-ascii?Q?yYtCO2KYuIO/VqYXlCkPSiRFfrcMNB0iFQ3MWxYvChwzvlz4rRRHysMGreeq?=
 =?us-ascii?Q?VUoNxVhlqCKuQH6FKOxSNVW1lJ1qnlruOlqJH7FKjrj2hM4deuwJmvvV+Cqu?=
 =?us-ascii?Q?MrfdUIDnFQ2N1JDtTNkkgZXlrPhT7j42u8U1ahNmiARR42ULL99mi4OPofIr?=
 =?us-ascii?Q?apc015f0cj6WLm6wmLEnlFTOVBsfw53+/Uco5X71qqmz1hinHTgIdMq1YzGw?=
 =?us-ascii?Q?7mvF9ODWpdJQAtPVYu46pnwyOstjk0FZMUSI2EsbJt90Gl6zHJ45balZxqQV?=
 =?us-ascii?Q?fbwTCwQ771bN4sEw6sAZ6Zr5eF4WIVDYkPSum89rUVO0LdcHF3E/n5ujI6lY?=
 =?us-ascii?Q?p1dtinQizzHaleCOp5gVDN9yMprxB7RrKy2yimhUpgPn0U/qLUB2zw2GVqdv?=
 =?us-ascii?Q?xCeJx1VC8+dBUQTQ2x4G6Zt8X9f+vPOVOM6K/koC19t1vFXzOnl87oeeOjEj?=
 =?us-ascii?Q?5P8n1Yf0wFB3VAK2URfY0WUeAm7Y3+wT6kN66PZ9UJ1GV5HyB8d03ipQtNxN?=
 =?us-ascii?Q?l2UHNWTZd/YUlQpBIwqG90ZLKNy4yUy3PvGyOKReLIMtW72tyZpS2c2MA34G?=
 =?us-ascii?Q?+5i16/QzfE4roN2AxnjmjOtufb02FG8s3dUb9pDVbEbd8ULL0CYSp9s5SalP?=
 =?us-ascii?Q?3TiSmj182Xp2CiqwQ/t7uh47JY0zGO3x02aPuDiaHpU8POmexPtYQsf3nF6u?=
 =?us-ascii?Q?w9pilhRDChkFombSNXUFv9twykEhJv1/UhMq/AdJeZcuuVXzihbbJrYyerrm?=
 =?us-ascii?Q?MSpmmZO9MUXm3n+/jQKUKNQu54aOat3uybqdAEkGiL/M8QeAXYYnZrSoY6+3?=
 =?us-ascii?Q?1OU1yO0sFSMOhYw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:38:43.4204
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8383f1dd-a88c-46e1-baa2-08dd7111c1c4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7958

Secure AVIC requires LAPIC timer to be emulated by the hypervisor.
KVM already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

In addition, add a static call for apic's update_vector() callback,
to configure ALLOWED_IRR for the hypervisor to inject timer interrupt
using LOCAL_TIMER_VECTOR.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:

 - Add static call for apic_update_vector()

 arch/x86/coco/sev/core.c            | 27 +++++++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  8 ++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  2 ++
 arch/x86/kernel/apic/init.c         |  3 +++
 arch/x86/kernel/apic/vector.c       |  6 ------
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 7 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e53147a630c3..1122cf93983d 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1502,6 +1502,33 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return __vc_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
 }
 
+u64 savic_ghcb_msr_read(u32 reg)
+{
+	u64 msr = APIC_BASE_MSR + (reg >> 4);
+	struct pt_regs regs = { .cx = msr };
+	struct es_em_ctxt ctxt = { .regs = &regs };
+	struct ghcb_state state;
+	unsigned long flags;
+	enum es_result ret;
+	struct ghcb *ghcb;
+
+	local_irq_save(flags);
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ret = __vc_handle_msr(ghcb, &ctxt, false);
+	if (ret != ES_OK) {
+		pr_err("Secure AVIC msr (0x%llx) read returned error (%d)\n", msr, ret);
+		/* MSR read failures are treated as fatal errors */
+		snp_abort();
+	}
+
+	__sev_put_ghcb(&state);
+	local_irq_restore(flags);
+
+	return regs.ax | regs.dx << 32;
+}
+
 void savic_ghcb_msr_write(u32 reg, u64 value)
 {
 	u64 msr = APIC_BASE_MSR + (reg >> 4);
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b510008c586f..7616a622248c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -338,6 +338,7 @@ struct apic_override {
 	void	(*icr_write)(u32 low, u32 high);
 	int	(*wakeup_secondary_cpu)(u32 apicid, unsigned long start_eip);
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip);
+	void	(*update_vector)(unsigned int cpu, unsigned int vector, bool set);
 };
 
 /*
@@ -397,6 +398,7 @@ DECLARE_APIC_CALL(wait_icr_idle);
 DECLARE_APIC_CALL(wakeup_secondary_cpu);
 DECLARE_APIC_CALL(wakeup_secondary_cpu_64);
 DECLARE_APIC_CALL(write);
+DECLARE_APIC_CALL(update_vector);
 
 static __always_inline u32 apic_read(u32 reg)
 {
@@ -473,6 +475,11 @@ static __always_inline bool apic_id_valid(u32 apic_id)
 	return apic_id <= apic->max_apic_id;
 }
 
+static __always_inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	static_call(apic_call_update_vector)(cpu, vector, set);
+}
+
 #else /* CONFIG_X86_LOCAL_APIC */
 
 static inline u32 apic_read(u32 reg) { return 0; }
@@ -484,6 +491,7 @@ static inline void apic_wait_icr_idle(void) { }
 static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
 static inline void apic_native_eoi(void) { WARN_ON_ONCE(1); }
 static inline void apic_setup_apic_calls(void) { }
+static inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set) { }
 
 #define apic_update_callback(_callback, _fn) do { } while (0)
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 855c705ee074..7c942b9c593a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -484,6 +484,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
@@ -530,6 +531,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
+static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f59ed284ec5b..86f9c3c7df1c 100644
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
diff --git a/arch/x86/kernel/apic/init.c b/arch/x86/kernel/apic/init.c
index 821e2e536f19..b420f9cd0ddb 100644
--- a/arch/x86/kernel/apic/init.c
+++ b/arch/x86/kernel/apic/init.c
@@ -29,6 +29,7 @@ DEFINE_APIC_CALL(wait_icr_idle);
 DEFINE_APIC_CALL(wakeup_secondary_cpu);
 DEFINE_APIC_CALL(wakeup_secondary_cpu_64);
 DEFINE_APIC_CALL(write);
+DEFINE_APIC_CALL(update_vector);
 
 EXPORT_STATIC_CALL_TRAMP_GPL(apic_call_send_IPI_mask);
 EXPORT_STATIC_CALL_TRAMP_GPL(apic_call_send_IPI_self);
@@ -56,6 +57,7 @@ static __init void restore_override_callbacks(void)
 	apply_override(icr_write);
 	apply_override(wakeup_secondary_cpu);
 	apply_override(wakeup_secondary_cpu_64);
+	apply_override(update_vector);
 }
 
 #define update_call(__cb)					\
@@ -78,6 +80,7 @@ static __init void update_static_calls(void)
 	update_call(wait_icr_idle);
 	update_call(wakeup_secondary_cpu);
 	update_call(wakeup_secondary_cpu_64);
+	update_call(update_vector);
 }
 
 void __init apic_setup_apic_calls(void)
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 897e85e58139..09eb553269b8 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -139,12 +139,6 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
 			    apicd->hw_irq_cfg.dest_apicid);
 }
 
-static inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
-{
-	if (apic->update_vector)
-		apic->update_vector(cpu, vector, set);
-}
-
 static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
 {
 	int vector;
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 657e560978e7..1088d82e3adb 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -83,6 +83,7 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -143,10 +144,12 @@ static void x2apic_savic_write(u32 reg, u32 data)
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


