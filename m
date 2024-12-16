Return-Path: <kvm+bounces-33891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 719E39F3E9D
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:01:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E21D16E210
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337C81411EB;
	Tue, 17 Dec 2024 00:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mhgFkrVU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03B1DC1AB;
	Tue, 17 Dec 2024 00:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393616; cv=fail; b=iFOP1uCUc/1b/ZKY1FU/S2W2dRVgRQji4ZO8OjnS1FQfqd/+bGcv66PuZWrVcJc84WCCUajC/HenxIBOPNDrKVTBHEcGFyT1Eh+3TiWb0Z26k0FdSMQtT0b25kGGeGB25ubbW/Du0voI1t8wtwDopWsgUC8HszQJmgdcZLzZNjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393616; c=relaxed/simple;
	bh=PZqpkQkI5q5yC6HiU1zkPx5QkhFsN10540a8ZSxmCGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0J4F9W1qx646nYyYpqzgL8yEp6H40V4PEfkQBEa6IAU8gF7mAXrh4lycWqDgUEUdEGqjOjEBvvC5P68YAiBkA1Wd2uNkHhRyQJ8UOoqCyfYbe++0GW/QdiaXvcRKT9O1nNod9Y/2OUuO3LToeBBKnf7UKee9r+TyN7aXNpzfq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mhgFkrVU; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lp3gB5zoVVHgTWefC9thS4YbhjRf59fX/uYyhWbLiP1NQQvrLIjy+OgTbNPeL67gSZtDj2r0HzPkB6K99HiXB3DO1uyKxBxBFgVj80lwwB7m5q7npBO49oh+0b6/wr6tZxZxvubkntlm6VmW2KhashBv5pE3Syezx6gco/ZqN77i4+yLGYveAeGezhXtli4/TrilOGOFmXetUQTX5wOlVgbaWqAj2AunDonlluNjWxl6007CkcFihvPCkEH+YPR0sq4TlJhSv197oqzMtVOgG0p+4fybtcYvUrwUb7OPo/Tj5semjAzFDPF0fOO1e1lxzWpYZ5PYleFzbzYaMtlheA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/L0ESsB4XPvQz9gVYZy61h+6bZPX1Eh4KsvIiZkkPZE=;
 b=oCsR/IIXlFrCX0JsCrvn/LWpyR+r0kjycGlJGcPcSj5IWoDaZ5Oqk7cmj9sdIbDG2Wm/Bzgnzm2E69URhSJYw77+ugmE8t6KG5iOBphx+W2hdLCJBwl2qs0z+GYL0S1es0PZBgd9eJODSHtjTfmxL06ZygmkSxDrF5wbwkboL6CkKT+mKp4wQ99k6RdTRcCDpRUfNeO9hbVH8P0CVDxv8yOaf2+hgz2vT0SMEZDs/rlGNQPpKYwwWmT1+vcXhovtnKzikrf8mDMpKE6DSi05+noBDvY8T11VoATJBMNe1TsJTzF6PyxmUyMcsfHsYzku9l6Soakoxglk2vdr+F/g/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/L0ESsB4XPvQz9gVYZy61h+6bZPX1Eh4KsvIiZkkPZE=;
 b=mhgFkrVU1jlbGkhSMLdb/bCCpwh41dEDJ4MJ+p3qDMhCPnsmkGMAh1+bqxRgpFbzO9ZZ+zF6agV0dUW19VS1yzJHD9M6q5owvz2A9n8BbVF2ojk1GVuEmrLi/P6QEm/VK9pO8hQJPFOAi4I8X+QPt/wFTI/iQucEcMJOqsPQwl0=
Received: from BN9PR03CA0421.namprd03.prod.outlook.com (2603:10b6:408:113::6)
 by DS0PR12MB7826.namprd12.prod.outlook.com (2603:10b6:8:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 00:00:09 +0000
Received: from BN1PEPF0000468D.namprd05.prod.outlook.com
 (2603:10b6:408:113:cafe::4e) by BN9PR03CA0421.outlook.office365.com
 (2603:10b6:408:113::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Tue,
 17 Dec 2024 00:00:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468D.mail.protection.outlook.com (10.167.243.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 00:00:09 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 18:00:07 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 8/9] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Mon, 16 Dec 2024 23:59:58 +0000
Message-ID: <bc82a369d20b82177c3aac97fc5df0d9018c9fbc.1734392473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1734392473.git.ashish.kalra@amd.com>
References: <cover.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468D:EE_|DS0PR12MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: 73adc577-1112-41b2-93c4-08dd1e2dc592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qugFO2isgNUelLp09P9NLUTMvWLQccJf977yXlwODm+F4rhiTx/ywuGCUOwX?=
 =?us-ascii?Q?uQWeeXyfAYqCCg2bBNMGEmEPUmUujJwjIV+qWqZ9qvbpmKhSfu56D/l1MYDA?=
 =?us-ascii?Q?AQxbNeeEF6wF/VhHqlLwApk4Qa6hhqjvBuuJxNn3cdgvjxQeuJ9VsxHGplhV?=
 =?us-ascii?Q?G2sKu9HgHgW3wqIVkzN8enBQWnp0l1zwS3ovrBo6OfozVhSenphTZiujmpDV?=
 =?us-ascii?Q?oFaxUkFXPB9JN36Z7GEdV3cbdK5UArIloRJMdBYNs17F/S04kZbDaXtLU5ZT?=
 =?us-ascii?Q?cAWtxH3gUKEEo2vM1RxocGNOfa2zCA9pGfzxUIkFugwhCqQRLrUNes8rI/Ge?=
 =?us-ascii?Q?vdXfYoa+THOs4x4Jzv2wSN18Idi2rcF44rRW7M2TNsZ6EOgu4zF2ske0+BZf?=
 =?us-ascii?Q?x6iTSfgP1iik06VBK94HGWKaWKRLDJZ7lye0zRrb59aVqNI1XIm67OBkafKV?=
 =?us-ascii?Q?OsE+YYoTW6fk8bdlh4I0ODPmwjYSiLAVMeRiUyEwRM1soMDVCogjohwO7poZ?=
 =?us-ascii?Q?CZiXBJn0r0DOsGD0UkRfCvsOgOjXCBv0K5CwQl4lKTcF6umNPCGrl2jffA+R?=
 =?us-ascii?Q?In/bjY26UH7FR8xPBNvHXxbTL04uyco5+d9Gj6cAuvEyPJvjtXZGAEUsHyGY?=
 =?us-ascii?Q?fAo3/EA317DIyXmGzKKx5sLkw8/o+dE0MIfIRdButSGzG63Gxz0JGfZlMLVN?=
 =?us-ascii?Q?dTQTr3fe9ZW/h0P3537E+HoijjVTCSj7LiBt1TaRqdEIx/q7SeQM8KR1ROdF?=
 =?us-ascii?Q?hZkYKhkPReTLxibGqpXvRXVBxWKNPlu04Byl+QgmtzzBgmK0AjGvIu7VQsJn?=
 =?us-ascii?Q?P4eLunRht8eE3AfxySTb3vJVttHM3dRYyWVFKVU0AsAptLLCRxJZP1bH4Y7k?=
 =?us-ascii?Q?bJnbSyNlgYLBTqR4EVmPwOkQVVyZYxnPGpKO077jmQbIUJwW9OatwySVEvu0?=
 =?us-ascii?Q?vkIrHaIJrocAAybKYOJ02T6FlVpgPh7/E6exu1dVjpfu0uyUUBuX2kJnCyIa?=
 =?us-ascii?Q?24vo3nICBs7ejQAjp2I+PEN4MWCyjMhQL4Zrd43o358qhnvjho6+cu7b0/NZ?=
 =?us-ascii?Q?eutRhDHyduASgr16wF3JzaG9Uga8LbTJ1vAT/QawtMGz5JZ5IGEGu43aCCjp?=
 =?us-ascii?Q?A+UlH7XUo35rK7RwT7fuqYDS2s0lCB610c2lUUzWOqply1VLd7vIoZFFW2Zu?=
 =?us-ascii?Q?WRoqSOeOkqDl8FPYhjw9EpS32FDah60R3+NchC82VU2fijXNTH0/3QHNluDt?=
 =?us-ascii?Q?clrF6Pzkh1l9HwH3Xun2IiG4+LWSKaykPJfXiH1xY5t6BXABtE8R0XFE5Xv6?=
 =?us-ascii?Q?hojGNNMctICOQLktbY9Q+atZdB9wCQeRoTOVAF3nAMeWn0kscuFCROYewEHW?=
 =?us-ascii?Q?rzU8z1C9Jx+XrEigLzlXk/OpR01eDHEL8+xlm/UtFfc94bTu31DcTn2yYDqT?=
 =?us-ascii?Q?N0Q//aYD63dafij/5Ug2+hs/tI8zH7xShzl1GUs8yQZ26m8yHstfibGwbn7g?=
 =?us-ascii?Q?r0nPTiMgNAtBDuRAU4pqbFa/9+gdP3DHQICr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 00:00:09.2932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73adc577-1112-41b2-93c4-08dd1e2dc592
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7826

From: Ashish Kalra <ashish.kalra@amd.com>

Remove platform initialization of SEV/SNP from PSP driver probe time and
move it to KVM module load time so that KVM can do SEV/SNP platform
initialization explicitly if it actually wants to use SEV/SNP
functionality.

With this patch, KVM will explicitly call into the PSP driver at load time
to initialize SNP by default while SEV initialization is done on-demand
when SEV/SEV-ES VMs are being launched.

Additionally do SEV platform shutdown when all SEV/SEV-ES VMs have been
destroyed to support SEV firmware hotloading and do full SEV and SNP
platform shutdown during KVM module unload time.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 72674b8825c4..d55e281ac798 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -86,6 +86,7 @@ unsigned int max_sev_asid;
 static unsigned int min_sev_asid;
 static unsigned long sev_me_mask;
 static unsigned int nr_asids;
+static unsigned int nr_sev_vms_active;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
@@ -444,10 +445,16 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (ret)
 		goto e_no_asid;
 
-	init_args.probe = false;
-	ret = sev_platform_init(&init_args);
-	if (ret)
-		goto e_free;
+	if ((vm_type == KVM_X86_SEV_VM) ||
+	    (vm_type == KVM_X86_SEV_ES_VM)) {
+		down_write(&sev_deactivate_lock);
+		ret = sev_platform_init(&init_args);
+		if (!ret)
+			++nr_sev_vms_active;
+		up_write(&sev_deactivate_lock);
+		if (ret)
+			goto e_free;
+	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
 	if (vm_type == KVM_X86_SNP_VM) {
@@ -2942,6 +2949,10 @@ void sev_vm_destroy(struct kvm *kvm)
 			return;
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
+		down_write(&sev_deactivate_lock);
+		if (--nr_sev_vms_active == 0)
+			sev_platform_shutdown();
+		up_write(&sev_deactivate_lock);
 	}
 
 	sev_asid_free(sev);
@@ -2966,6 +2977,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = {0};
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3082,6 +3094,16 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_enabled)
+		return;
+
+	/*
+	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
+	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
+	 * VMs in case SNP is enabled system-wide.
+	 */
+	sev_snp_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)
@@ -3097,6 +3119,9 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	/* Do SEV and SNP Shutdown */
+	sev_snp_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.34.1


