Return-Path: <kvm+bounces-26802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8B9977E95
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 371E02847B8
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF761D86E9;
	Fri, 13 Sep 2024 11:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j4lHiMo6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C3A1D86D8;
	Fri, 13 Sep 2024 11:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227517; cv=fail; b=WNZ4NfYuhVinP4SCemJI7GqR+I0mK13zOMwvuckKpArmZHKg+BvSDROMYLJ+foo5Ym/6U5tk+yE3587HipHE7Aj1vBJgBV65wb95oj/awInj1GvZogttSED7T1GyWDkSd5c67awYfPm3lrv0AsTsOhGkSttcmjglabrIy/GOU/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227517; c=relaxed/simple;
	bh=/g80h7m1trobD5qpOSBjyHmZTGda5QBtre431gxqujE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdzEBNR2s/G4WJCz3ATs4eS8Y+8UsybJ/itgAwd/BZVeNtZv3QS62BaL7jThQrcWgzVBylnQZ01bVeTzJ3ZtlP8hJ8giITSkh/NYC6e1LDFVqx/v82AdHdDFxJcCgL+rK37L+ppynmb97mm0FURDudCpdsA3bX1EaftyuP+O/zY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j4lHiMo6; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dI4sQtCMmb29l1FQqP0llQh+FGbJIiaxxLTIRvqoNEhwqnXSSm1K83wbIxTl856S1v3iVfzrA7IQRLRNiV8JlxHC+BSXw9mRSW5uUCxob/6A3ds/Le21c8fgMWCIb+hrNTcUly+++zLKCo6y4wYRtuafNoh1R8rpUYMHa4OmjRJjCgEXaqbYxuPFIh3KtDdaI1zkUXfJh0AxUZ3MmeoCuJwNKNYTi9f4E3NWwvgR5aXUea3YwQA07osFC7ZQGP6cWpF4uQH9uAAO6BbnDLi8EjdrsRj7/FBy79i2Q1g9vqteQDOuOK9z4XLjU8+zK1pnBhZ/TFmVenCcCO9wBO0FUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p45UyZLAMepyQCNoiAwbVCYaoRz41qRisYaMzUm/ERc=;
 b=OFKPvdmEDZ+eHk4Cvw89Yr4FB9KJ2zXDFP1nvwtuXNwwKuSrFKoA1EvvgNMjozVhivKyoWi62pFVZuEy1kt/twlgRYpsCWkzZ1JupXQsMCU7dsjki1cgb7IZqCNIKwdzjsiDoUQ/mqZdWQTou3jTkVUMS/IZFSb6BHN7nk+/C2MXp/YELCvKc8Azv6RNIlHOsGS0VNJiWp6s/CenfdxEnOOeeJV/VhMapkPO9ajvMGKvtiNuMOAr7h/w0eM/ljSpdqiXBfM14rkBsBiirdJmu0wKhWXLAZ3KCakoCsZ/77gXoBkQOTLha2SX3xtercNbasx6PSQqMsAJQXDsfzlj4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p45UyZLAMepyQCNoiAwbVCYaoRz41qRisYaMzUm/ERc=;
 b=j4lHiMo6VN0Gaoxt6YjqoGacXDAH1oabuSZjJh4H7XJ5IcPWMg/sK+27PA+Irg+8xbF2AHIv48LQJzFJqDZq9V8NHZ5BDDr+LoVRysofGdsqOMHVP9wgX+8WsWw7M1uJzOmMMo2uovu/KnDnGse8GnRRTLA+yKztdwnZCYmceTQ=
Received: from CH2PR12CA0022.namprd12.prod.outlook.com (2603:10b6:610:57::32)
 by SJ0PR12MB5612.namprd12.prod.outlook.com (2603:10b6:a03:427::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 11:38:31 +0000
Received: from DS3PEPF000099DF.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::46) by CH2PR12CA0022.outlook.office365.com
 (2603:10b6:610:57::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25 via Frontend
 Transport; Fri, 13 Sep 2024 11:38:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DF.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:38:30 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:38:24 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 04/14] x86/apic: Initialize APIC backing page for Secure AVIC
Date: Fri, 13 Sep 2024 17:06:55 +0530
Message-ID: <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DF:EE_|SJ0PR12MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 440f955e-b486-41b0-f0ea-08dcd3e8976c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WJadrVW48/os7KavrPYcLShiyHdxXrpEi0in1ZTyTAkW3jcVh9+9TIkAPKEE?=
 =?us-ascii?Q?l/PG6LFsn719ax3IgB4jkfsIt+lSqxsclfB9ughhIIeatkPxWL0YO5JBMALo?=
 =?us-ascii?Q?vCcrHo+HZHPOZHV5FVgVtF2VsCkM97LFXXZfNwmVeNizV3vdgwYG8YDcwVOS?=
 =?us-ascii?Q?79lRmzG6pz1lGqv+oJEZR8h1H7/1hieWobJ5mF+7C0Wd6qkuzXtvxXNiC3TG?=
 =?us-ascii?Q?19LfxshJDcg8uTrwDh2gD3RiRSY1rxieYW86b6GpyUoNMzeJlXaDQcFLhL+P?=
 =?us-ascii?Q?/3sJ2nlBwg+IWoB812KzhXD8NCaNXHVR4uYqVyUBY11lx24DBx/0DUHTfM7Z?=
 =?us-ascii?Q?JNeo50jDlaMKaUHo+AZ+1loKCwdwNaSnGd2DNgsxBFzMSGt2aSk/nnREwBZh?=
 =?us-ascii?Q?prUuFYUR63zVx1tG+HSp0PcwPsuW86QKDuacCes9vY0gvUnCKgHzJTvEtXWo?=
 =?us-ascii?Q?oYJQIcBYTKMKuYLyYFrOFOZOulyXNXz7x2AeQMeh7rjsIYaze0al60Q93C3b?=
 =?us-ascii?Q?q3xH8/C4h0dEBFbTdpGZHcdBtlLRet0JPUbo+Ya6FFXQQVC9PoJlZYVxRf+z?=
 =?us-ascii?Q?y0gABCUdbTa5WjQajcCW7vgPvVGMMSqcip1u+cOEAnOtDHqCV9qF2ix0KY0Q?=
 =?us-ascii?Q?FdweRPBB/cJ0zbMEw0wwJC0XdYoXblfd/nzJ/K+AVTf/CHrennUOeQQRuOco?=
 =?us-ascii?Q?Yz1i3h/oOHLuWNCOgtsivKi40bRrnEZ/tqvxamfjmQBgxxSbdCY+n+MwbGMN?=
 =?us-ascii?Q?8w7/lSeoSaVJUn3Div1HjkJyL1NYxceaEGAf0y8bDnZsYcMMqzXgVgeyDxpF?=
 =?us-ascii?Q?I5mMrqbQAK4Bl93ypuBAtxJDUU7w7nrSESvuuJtvhNYIq7B6QU59wMhFWbXV?=
 =?us-ascii?Q?y/xYna8uqyfFSNCLTuFqdxc1BN1TRte5EJqL5CTXHPMJOZihvY8Fc/iO8n7R?=
 =?us-ascii?Q?ewabctoAa6QUodGbAYREEDBD5XRBUKOHepy+b5NNAw29YOqI952jWnKUy/iT?=
 =?us-ascii?Q?ZAxSUBhBnjP6HlhRsFsLf3yA+q8sZxDuvGN/OoRE3hrsSYEDHypn1yq5VUpQ?=
 =?us-ascii?Q?vgc+k5PqLTv3Vg77VCELJmq6pQUhF1LjxZL2cFI4hlj+2md5+o1b4SRlKyIz?=
 =?us-ascii?Q?Xg5XpS12y6Y++daDcZFt5Br3OKp7B4crl0yavxNBEbAA7QZOSv0d4OSYJgbl?=
 =?us-ascii?Q?wNq4XzomJpJ/ndvtfVYZS1RDkw4MCnoSmncciyVCN1QKrkf+TVffKJLLVuoU?=
 =?us-ascii?Q?6H3ZHl6Yer+Y8SSUtGa30scqeUM24HJyPiJQnS/0K7j1Vpf6O41xtoLseLkI?=
 =?us-ascii?Q?gZYTfKtvuVANM+TGuzfMDj6JFlO9pgyhEv8vXHuAWRmn50dkN585B2A8AUMt?=
 =?us-ascii?Q?UHZj7wY3VEQ6w8e7AeXg9zRprctNAZfSkQatiSOdgPLpBOnW1ZeonnTzIc3m?=
 =?us-ascii?Q?fKaqGmaS8XHrfJS7JGb0fvEmna+szsUh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:38:30.4577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 440f955e-b486-41b0-f0ea-08dcd3e8976c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5612

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC lets guest manage the APIC backing page (unlike emulated
x2APIC or x2AVIC where the hypervisor manages the APIC backing page).

However the introduced Secure AVIC Linux design still maintains the
APIC backing page in the hypervisor to shadow the APIC backing page
maintained by guest (It should be noted only subset of the registers
are shadowed for specific usecases and registers like APIC_IRR,
APIC_ISR are not shadowed).

Add sev_ghcb_msr_read() to invoke "SVM_EXIT_MSR" VMGEXIT to read
MSRs from hypervisor. Initialize the Secure AVIC's APIC backing
page by copying the initial state of shadow APIC backing page in
the hypervisor to the guest APIC backing page. Specifically copy
APIC_LVR, APIC_LDR, and APIC_LVT MSRs from the shadow APIC backing
page.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/coco/sev/core.c            | 41 ++++++++++++++++-----
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 55 +++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 93470538af5e..0e140f92cfef 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1331,18 +1331,15 @@ int __init sev_es_efi_map_ghcbs(pgd_t *pgd)
 	return 0;
 }
 
-static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt, bool write)
 {
 	struct pt_regs *regs = ctxt->regs;
+	u64 exit_info_1 = write ? 1 : 0;
 	enum es_result ret;
-	u64 exit_info_1;
-
-	/* Is it a WRMSR? */
-	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
 
 	if (regs->cx == MSR_SVSM_CAA) {
 		/* Writes to the SVSM CAA msr are ignored */
-		if (exit_info_1)
+		if (write)
 			return ES_OK;
 
 		regs->ax = lower_32_bits(this_cpu_read(svsm_caa_pa));
@@ -1352,14 +1349,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	}
 
 	ghcb_set_rcx(ghcb, regs->cx);
-	if (exit_info_1) {
+	if (write) {
 		ghcb_set_rax(ghcb, regs->ax);
 		ghcb_set_rdx(ghcb, regs->dx);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
 
-	if ((ret == ES_OK) && (!exit_info_1)) {
+	if (ret == ES_OK && !write) {
 		regs->ax = ghcb->save.rax;
 		regs->dx = ghcb->save.rdx;
 	}
@@ -1367,6 +1364,34 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
+static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	return __vc_handle_msr(ghcb, ctxt, ctxt->insn.opcode.bytes[1] == 0x30);
+}
+
+enum es_result sev_ghcb_msr_read(u64 msr, u64 *value)
+{
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
+	if (ret == ES_OK)
+		*value = regs.ax | regs.dx << 32;
+
+	__sev_put_ghcb(&state);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 enum es_result sev_notify_savic_gpa(u64 gpa)
 {
 	struct ghcb_state state;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e84fc7fcc32a..5e6385bfb85a 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -400,6 +400,7 @@ u64 sev_get_status(void);
 void sev_show_status(void);
 void snp_update_svsm_ca(void);
 enum es_result sev_notify_savic_gpa(u64 gpa);
+enum es_result sev_ghcb_msr_read(u64 msr, u64 *value);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -437,6 +438,7 @@ static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
 static inline void snp_update_svsm_ca(void) { }
 static inline enum es_result sev_notify_savic_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline enum es_result sev_ghcb_msr_read(u64 msr, u64 *value) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 6a471bbc3dba..99151be4e173 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -11,6 +11,7 @@
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
 #include <linux/align.h>
+#include <linux/sizes.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -20,6 +21,19 @@
 static DEFINE_PER_CPU(void *, apic_backing_page);
 static DEFINE_PER_CPU(bool, savic_setup_done);
 
+enum lapic_lvt_entry {
+	LVT_TIMER,
+	LVT_THERMAL_MONITOR,
+	LVT_PERFORMANCE_COUNTER,
+	LVT_LINT0,
+	LVT_LINT1,
+	LVT_ERROR,
+
+	APIC_MAX_NR_LVT_ENTRIES,
+};
+
+#define APIC_LVTx(x) (APIC_LVTT + 0x10 * (x))
+
 static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
@@ -35,6 +49,22 @@ static inline void set_reg(char *page, int reg_off, u32 val)
 	WRITE_ONCE(*((u32 *)(page + reg_off)), val);
 }
 
+static u32 read_msr_from_hv(u32 reg)
+{
+	u64 data, msr;
+	int ret;
+
+	msr = APIC_BASE_MSR + (reg >> 4);
+	ret = sev_ghcb_msr_read(msr, &data);
+	if (ret != ES_OK) {
+		pr_err("Secure AVIC msr (%#llx) read returned error (%d)\n", msr, ret);
+		/* MSR read failures are treated as fatal errors */
+		snp_abort();
+	}
+
+	return lower_32_bits(data);
+}
+
 #define SAVIC_ALLOWED_IRR_OFFSET	0x204
 
 static u32 x2apic_savic_read(u32 reg)
@@ -168,6 +198,30 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void init_backing_page(void *backing_page)
+{
+	u32 val;
+	int i;
+
+	val = read_msr_from_hv(APIC_LVR);
+	set_reg(backing_page, APIC_LVR, val);
+
+	/*
+	 * Hypervisor is used for all timer related functions,
+	 * so don't copy those values.
+	 */
+	for (i = LVT_THERMAL_MONITOR; i < APIC_MAX_NR_LVT_ENTRIES; i++) {
+		val = read_msr_from_hv(APIC_LVTx(i));
+		set_reg(backing_page, APIC_LVTx(i), val);
+	}
+
+	val = read_msr_from_hv(APIC_LVT0);
+	set_reg(backing_page, APIC_LVT0, val);
+
+	val = read_msr_from_hv(APIC_LDR);
+	set_reg(backing_page, APIC_LDR, val);
+}
+
 static void x2apic_savic_setup(void)
 {
 	void *backing_page;
@@ -178,6 +232,7 @@ static void x2apic_savic_setup(void)
 		return;
 
 	backing_page = this_cpu_read(apic_backing_page);
+	init_backing_page(backing_page);
 	gpa = __pa(backing_page);
 	ret = sev_notify_savic_gpa(gpa);
 	if (ret != ES_OK)
-- 
2.34.1


