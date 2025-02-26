Return-Path: <kvm+bounces-39250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 583E9A4597B
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:08:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BD3A3A7EDA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D61226D0D;
	Wed, 26 Feb 2025 09:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5PeVDhOa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A84E224253;
	Wed, 26 Feb 2025 09:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560882; cv=fail; b=txBGgXxDVpIwiaTmG3G1e12iTkTupavdOSJ6xX+4NOVELlmkCEp3v9lHLVCXf0Chv4GuDvihqjUnCreHY5XmNfjpCjZqr6NgvfsvKi783B5KGGJNAKS3B3Rl4shV3rsvsQyXfNatsT3u7i6SLLbqc2JLz26MYsmReVf3rEGjrbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560882; c=relaxed/simple;
	bh=/MMuvtDj8a8228sxBifHAJQ++0akJCRlkibauiRxvxA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFfA+d7QlrjIWjqmi6I6UZlIeA4fH6gMx6h+80TU0YBOUv5tvISvMPNbkTGJNqXhNszY48ZIhVo/VzGJUYx1uMpr+GCW4LVq2NLMMvmOadADj8AeXOr1u91Bzj6/ebXIONOXLqAEu3Sxpy+bG3oeJ+D44VAFQqQrIQc12t2dKsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5PeVDhOa; arc=fail smtp.client-ip=40.107.236.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXffbvzQc5nnZR5wYQ2oaEtiBcL8fmkqu1vCqF0JGL4qhVmvH1PVFz96wg8nTn4cLufui5AElDivrKSt0H4+qg+8U94Bi46K1XIr6XG/mKJfCIH24xB3u842hrs3jKUxPTKR7/ngzfBvvIJNRif0MgwBf8H6BIbaLKOOjndpjTzPj3lepvcEtYm3Vun/wsymXazdd4SwK4mt+2tev9tjNUQiaFy5ug6v6dEOUPNx03zcu5lTWhQthWZDe7enuS47zEvSv87KCxXIQJbuzZzM9JNQrDXJNUMVOoU+Rwyth94T0XBql1QdTTCXryNqTh+JRBDkoFfRoipX661UZZ3inA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e1a1vF59pbxo5bYwGCbzQVsQqlOZziLMDQYvEsx9bHw=;
 b=DRbgDThoX0UOWIFQUdmgkBYzn4rzQPB8TJ74g32D7nETq6VFj7TXZl9jQ8sa1KQz5/VyQhglkUnNfn0Iv7IHqSbC8u94FeiakYbiUVp5/EHGbhTC/nK32Mu6Asg8uUh32622OEApFPHCRpocAUvPv9WJ1GSGWug9goX4Z+sKQx4O1kp2seqR7bIvkkvjOYEaAuLrN0CgfYItwFJLQcIgUJqKPaqPdBvIZUiobKDfyRHlqhCNqtqeFTviQoJcXg+p/1gnch8/JO8Dwi1aRtWPruLP4+a28+1tybhmw0pFzDi5vDNA6h00IbTsPl6ijIwDwTUKIXyjeUGWT5iM3QOvyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1a1vF59pbxo5bYwGCbzQVsQqlOZziLMDQYvEsx9bHw=;
 b=5PeVDhOa7eaAiKoN9WRCNfh/bCen7fH5beiAwON3k7wbenOOI4rMPVjLB25rwZiytf87GIbpvENmgqCLUmFxnH7DT7kp0HlhfFsiExaGlDCLVjWucdbxnmWgaNX53jUZDaI/eiXEl+6vI3yYyKrqA4z2ClC0hpegchLSL1U58sc=
Received: from MW4PR03CA0035.namprd03.prod.outlook.com (2603:10b6:303:8e::10)
 by DS7PR12MB8250.namprd12.prod.outlook.com (2603:10b6:8:db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 09:07:56 +0000
Received: from SJ1PEPF00002319.namprd03.prod.outlook.com
 (2603:10b6:303:8e:cafe::b3) by MW4PR03CA0035.outlook.office365.com
 (2603:10b6:303:8e::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 09:07:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002319.mail.protection.outlook.com (10.167.242.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:07:55 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:07:48 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 07/17] x86/apic: Support LAPIC timer for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:15 +0530
Message-ID: <20250226090525.231882-8-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002319:EE_|DS7PR12MB8250:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fefbd78-3b8b-4df6-9cb2-08dd56450ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HsqTN9rDvYcLqKWrSSro+HQM44b5ia3tQnHvZwZT6HnReEmxBtPEuhz0U6XK?=
 =?us-ascii?Q?lfYGYUzX7wDBoRmw+DR+cQsL3KSAvmjjLIVv/pqgThGJok5ERMAu5RSvR05e?=
 =?us-ascii?Q?wSntsLf2XztOokHNHYoNaOpucffhrTQSoLj9b7TeMBoypWRZ3vZyAcm3gB9n?=
 =?us-ascii?Q?WKuAHvpHxeOo+nLpXq36T2jD7jmWd8cmQHjuKKW04JFad9l4iTi2OlHMfsFa?=
 =?us-ascii?Q?LmWetyHfx6btp9pOymFIq17e4K6OdHqyIT2koo+2uLeFsJ2EXoHCtl68ws/0?=
 =?us-ascii?Q?UHizYidFbjjOAMSkEfhLJTdwkaWfXdyK9xeKc8RyyFYYv2QtrOR8gdSj4h3d?=
 =?us-ascii?Q?OjYXhFSQ2dAGa7gxoKL5Yk5HqDbEik8AXTIkT0iXSO4nqaLiA8h7Q7mGgeqf?=
 =?us-ascii?Q?GzQr7AW0zP4KMTyIK+Ss5Vy4RvDwxw5qBnxQ8J9EBczSuhXVv/mkuB5Zb5Ob?=
 =?us-ascii?Q?9TahOsdeKgfEOmjiyxOONHrsEbfMqFXtkJxf30K4WMGfGpKQRoDZilQJ8DcL?=
 =?us-ascii?Q?MLHrjohYIKlSdpJzJycdeZ+3X36687YWww2T70EbYBz7L3w82Hm5kz8KR8xC?=
 =?us-ascii?Q?cRQ2sPgML+aC8zRNEA/HhZQnZyrBoO9axFsAm22kyurEDwx39eQ4Iq4WKL7I?=
 =?us-ascii?Q?t2BcV/l5f0PqzsKpbOKuvv4prIPWRcbDg/a4bhxQon03lmGd5FB5UN/CuVaM?=
 =?us-ascii?Q?EWlAEc1yW9YQ+c2oEZ6db04cYW3VX1Qj1CgbJTzVUcGq3x00UIHSbIwAQnEd?=
 =?us-ascii?Q?K/cvAGA5hUDdEATna2I7UufXTCXR11pbaJhZ5o/RrtowJTb++GABFwlm+jyq?=
 =?us-ascii?Q?syjMVMvBHeLsq0MgGB4XXk3peZt0+xjAL3K0ZftRA30Tlz38oTHpuUMxPazE?=
 =?us-ascii?Q?N/1Nalg2HLbmNOyXPcgLyJueOyOCPoACRlQavieaLUDySA0+C8+WSuQBhDah?=
 =?us-ascii?Q?zTEzz9lCZXs7dRXHXcQ2x6y1BC488EzQ409xFYVQArQ4YYlliT/xCgr6biTK?=
 =?us-ascii?Q?BKxYMmGb3Y7Usx0Wl+mUMDdNG2rzO4xeIf0y54oEkqtWvDmhV0drW+UzcZM4?=
 =?us-ascii?Q?5bhd48u4Pgw1gHfXrNJiIBin7J4MSdYuxHSa9BnejJgLlz58A9fklveMtPcR?=
 =?us-ascii?Q?0xPublabMPkltWHuyVYOJkYsQ1c5+w9+/dVTXaPbr5YTP83lfXKPsL6TGLOQ?=
 =?us-ascii?Q?y4R03vfPP16c985g+3g734kIaFKlNCmEEoNfDIm5GVePU1r/cXPlijkqdwX/?=
 =?us-ascii?Q?cDnlB6fSayoUF9LEvDwH9HV8gOfK1t7fAHN/FOR4DPRbvr7ujKMsy37kbPhj?=
 =?us-ascii?Q?N+S2loVThV8QeYvsVgoFIoHDA9dggkkgizA59/gwI4HmP1k/BCof1FvREuvx?=
 =?us-ascii?Q?f3IPIo8Wf4TTI2soQLUbq7Tkkdvoa64YpQYP2EdwzKCenWK5reMs0ggIUAMW?=
 =?us-ascii?Q?p+tSdZIRbCfDMT9wKo585nxPzVwp1/KZWn6gVPYvlTzwz0+F/XN8YDnw3i2e?=
 =?us-ascii?Q?KebFvU/KPPSy7aM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:07:55.4668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fefbd78-3b8b-4df6-9cb2-08dd56450ebb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002319.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8250

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires LAPIC timer to be emulated by hypervisor. KVM
already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

In addition, configure APIC_ALLOWED_IRR for the hypervisor to inject
timer interrupt using LOCAL_TIMER_VECTOR.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:

 - Move savic_ghcb_msr_read() definition here.
 - Call update_vector() callback only when it is initialized.

 arch/x86/coco/sev/core.c            | 27 +++++++++++++++++++++++++++
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  4 ++++
 arch/x86/kernel/apic/x2apic_savic.c |  7 +++++--
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 4291cdeb5895..e4c20023e554 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1505,6 +1505,33 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
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
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 1beeb0daf9e6..043fe8115ec7 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -484,6 +484,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 apic_id, u64 gpa);
+u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
@@ -530,6 +531,7 @@ static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 apic_id,
 						u64 gpa) { return ES_UNSUPPORTED; }
+static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 static void savic_ghcb_msr_write(u32 reg, u64 value) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 1c0b5f14435e..23a566a82084 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -591,6 +591,10 @@ static void setup_APIC_timer(void)
 						0xF, ~0UL);
 	} else
 		clockevents_register_device(levt);
+
+	if (apic->update_vector)
+		apic->update_vector(smp_processor_id(), LOCAL_TIMER_VECTOR,
+				    true);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 7e3843154997..af46e1b57017 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -71,6 +71,7 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return savic_ghcb_msr_read(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -123,10 +124,12 @@ static void x2apic_savic_write(u32 reg, u32 data)
 
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


