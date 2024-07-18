Return-Path: <kvm+bounces-21834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23826934D6E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AF441F23A43
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED4313C801;
	Thu, 18 Jul 2024 12:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MjhlOu4Q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A4D13AA26
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307029; cv=fail; b=m91jVnqzrQDCq4V+cvyB8Q+z0MHtcpo07RvMOTHOY558m70TwelJT+HhKogzE26IYQeW1wXcpLjBWC0+Zj4FhsToht/cWE6S3UNnmgpJNGiu5m9Dq/dYJ2La1dRtyZKiMSSvSDL7jIHwEvuASftoq3rYOmJDmtvaXuronlmstUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307029; c=relaxed/simple;
	bh=pV2w5LtxhP5biISxfrq7JghFDXSiPZ6aH5cSkh3J2VA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQv/Uo6mC+/vbPDyu1yVtpBts5CoxnS4hefEiISML1Y23eajR8xgV+uNZd2wJD3pRLVfi3DGsysV4SUsnbfE6Nv7ELO1SRL8nZlv3HYh+U5n0tOp2wtJfWVgrjT1asRpyAHUBb84yt6jaayDWH67KZw4l9NWpPwfgTDeaKzKdEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MjhlOu4Q; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NpXTMR5TikaOJg9qw4D6HC02kheg2hbbfjs/LwoOzkH8M4QwQUiRzx0z1gw7O3CL4Qhdm3UIs4RnfH7omwfiz59bmRjnXj7wZlQ5TcxavAIjwMMqi+hg4viTlhf2abvyBKxFuMX5G/mVPLqafI8/QlYvO8HwTbb5HZqoKpX0wexaGshoPgptOMI8Q+RLbI92FqD4UxqEspJUwAgM2UqDmD4wHaeRQUWiNSFnXJyabuG9mIpog0qSrNiiWEj/9hIJWRzVr+j0puD+PEoQO0LWfndsQHQeMUqiOnaDJL6v9cii+obzy1VzKcc1Op6qT+tqVY8C4umEFuQJNVnuLKWdLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5LcT2h8y76p/bg7OKgIEwkwIq7TkVgQ26wnh1SgKQk=;
 b=qMAqqEBMnzCA6TU3PGK8Fcod2FODx2G1suV5PeEdB2nKhJ8TQTpRcbyz3Ht1bu6un1pXRb8rRy1QG0x/pEVoSBLCoi/tF2k6SZL9PuhLDW95KrVPKKEUN3o7Nl1FRmCTDAABxcIXj7dFRKqY0gRRBg2Mjm81ddn0JmzIrg55QjE9LHVQ4Ocw2/nXvxfGMfJFji7ipL/f0qrzA4RpqQ4WAtWVhDPrzc5brpEx8rWLdH5wp3IZQI4DRTarT226ozNlXBmmVNsOz2WpY7h8TkxE8cgyLLwRoid768abgsyc65jSOu/jNC4+ri1EZSNoQ3QZF6iY1Sox0aPb0HcsjvFdpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5LcT2h8y76p/bg7OKgIEwkwIq7TkVgQ26wnh1SgKQk=;
 b=MjhlOu4QDBB8cV2XS6EvrXyrfPYGAl1xH+7np8DWJDBoQOBsS/091/80toXoLv+FP/zyvb+Gvsk8XO2OSQpJLmLeKu3NxLX6cIn5neO6lkjiloP5CY1w7jKGAasnSr1xNtN/oNuik9Cd32iMwwBxZrv3J7Rc7YAbEmkRNrcGrYI=
Received: from CH2PR11CA0029.namprd11.prod.outlook.com (2603:10b6:610:54::39)
 by BY5PR12MB4162.namprd12.prod.outlook.com (2603:10b6:a03:201::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Thu, 18 Jul
 2024 12:50:24 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:54:cafe::bb) by CH2PR11CA0029.outlook.office365.com
 (2603:10b6:610:54::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Thu, 18 Jul 2024 12:50:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:50:23 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:50:22 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 03/16] x86 AMD SEV-ES: Rename setup_amd_sev_es() to setup_vc_handler()
Date: Thu, 18 Jul 2024 07:49:19 -0500
Message-ID: <20240718124932.114121-4-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|BY5PR12MB4162:EE_
X-MS-Office365-Filtering-Correlation-Id: d1c7eb0a-e783-495d-8151-08dca7283072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r1qs2nvE0ITqvv0dBvFDAdfOROggvBBmj8k36ieo8A3VcMsiQgb0IJkiSK59?=
 =?us-ascii?Q?d0VIMyuVIuPaYoWYSEOa1oPLwvsI5xY+EaHqZL/OyC9IZ305SXN9Q/PflrVh?=
 =?us-ascii?Q?L2OAqkNPB6YSZphhjAM38i/udYFY7wYDiSOFtp8v3fqyIUALf7m2vhoj/pmq?=
 =?us-ascii?Q?fhZUdCzMyo6rGQa13VqoDJihWIS3zutddixH3iVbS3VsY1rhvlM1b+mARtK+?=
 =?us-ascii?Q?2mfgCO55EjCOyunXx86X0VIzJ5aA2Y2WeioKA3DRxlQH0HRQUZiSHz+rxmua?=
 =?us-ascii?Q?W3buGY9krhId5JRyp2GEwjRd9Z7Adgu5Zk5LJr0hy9SOX7Zpv4DEHLa2nUMa?=
 =?us-ascii?Q?kaMVbImbxitTpjWrXa5cgMlM8c1fER8tqSSEMPnFtnQ78yEigJy0aWV3JsT4?=
 =?us-ascii?Q?PK4ug4cduNSkzOr74iodt3MRQeUMllHMUis2Ou7OaXP/Ec/ahQFiY2L6Qanb?=
 =?us-ascii?Q?jeWBjN5Gw53Zw38f+zHP3g5iEbbNVBcwSGLPsycLNkq/OwIBrn60LnxHfmpL?=
 =?us-ascii?Q?pzlEauHqICCaL0C+bl3K6kukDnc4y540uXehP10+px2hakX0d73wnsKJs/N3?=
 =?us-ascii?Q?3C+Mm7919G7qn1EKzuys5p3fCoPidxdspsXzHloMujC7zNVVjHea5MRZTh1V?=
 =?us-ascii?Q?1OglcdmGrcmDhOTGjX1ZKRTmfScYctmSBoWhKatvW7AI1UTmORa82fL82Qh+?=
 =?us-ascii?Q?+iWCFEccQPt1JuzXpC3G4VppgUXQWosfRGv+AEtvpGEICeFb64FrspT85hZ3?=
 =?us-ascii?Q?HXkzpt+ZFPdcqhbV6IOhXIQG88xLitblVDM2SSukHWeu/i5eF6ETiZtW2otR?=
 =?us-ascii?Q?05mmS+KLFo6P073GVY3uSE7VB1l3dgAe/3Qn4fIkX/ZtvfmByMYV+5oYeyWa?=
 =?us-ascii?Q?UaDKQYA8sltlbTpF1HZsauXLLCJfT6bpQlH3y06ezJZjdSooj5CBZZ+Nl/e2?=
 =?us-ascii?Q?/3SlQjxCI83Eb5mAQ/Xzs5MhkSNf+Pop5xTQP0kRMr/CbnRELxNTpGeC5MgJ?=
 =?us-ascii?Q?tF8j/leadAitCNaEc1982GvNUDdDQCBgqbsbX0qtM612BOMcw46zDp+5h/jX?=
 =?us-ascii?Q?rw0ORXTj59ON/b4hI15OYgh+ez++GyJQMI8q/YeAfRfyDS9zxsGUJNADW/KQ?=
 =?us-ascii?Q?1n1G3r2BxAcgTv4jV8Gl1lMYf1px5pbFbr+h2pWUGewOhnI/Q9fL4R2rzJCb?=
 =?us-ascii?Q?OfB154F93yr0JVOZRGBAytpEMiFJaqBlOyua6o1wyXk02cJW3kfosfjHPvyp?=
 =?us-ascii?Q?cnMPvR9hOkCy1z9oSFrdkvER1qYWXIdawMH3OiQFnZ1GKDwlgwNxc+gN66vH?=
 =?us-ascii?Q?jj85eOKqu6E1kKA7CAWxsDWM2J57DoGKQbaqsGOjpqmD2W7EMqhKXkwYabdW?=
 =?us-ascii?Q?y7iE0pBG4hYM2LBfYNzGf2CXJ7yqF/EDlLu4OizNAvNyuIMp4iUHAAoK/ufJ?=
 =?us-ascii?Q?JRjhFcWwvhssuAW1F9z1qYW1lN5uQ/0e?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:50:23.2171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c7eb0a-e783-495d-8151-08dca7283072
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4162

Re-organize the existing code to include a common helper function
setup_vc_handler() to setup #VC handler that applies to both SEV-ES
and SEV-SNP guests.

On configuring KUT with --amdsev-efi-vc flag, This setup_vc_handler()
continues to re-use UEFI's #VC handler. This is useful since it allows
some KUT SNP tests to exercise aspects of OVMF's #VC handler support in
addition to testing hypervisor support.

However, if one prefers using SEV-ES/SNP's #VC handler, then
--amdsev-efi-vc flag should not be passed during configuration.

No functional change has been introduced in this patch.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/amd_sev.c | 6 +++++-
 lib/x86/amd_sev.h | 2 +-
 lib/x86/setup.c   | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 987b59f9d650..ff435c90eeea 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -89,12 +89,16 @@ bool amd_sev_es_enabled(void)
 	return sev_es_enabled;
 }
 
-efi_status_t setup_amd_sev_es(void)
+efi_status_t setup_vc_handler(void)
 {
 	struct descriptor_table_ptr idtr;
 	idt_entry_t *idt;
 	idt_entry_t vc_handler_idt;
 
+	/*
+	 * If AMD SEV-SNP is enabled, then SEV-ES is also enabled, so
+	 * checking for SEV-ES covers both.
+	 */
 	if (!amd_sev_es_enabled()) {
 		return EFI_UNSUPPORTED;
 	}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index efd439fb5036..b5715082284b 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -139,7 +139,7 @@ efi_status_t setup_amd_sev(void);
 #define SEV_ES_GHCB_MSR_INDEX 0xc0010130
 
 bool amd_sev_es_enabled(void);
-efi_status_t setup_amd_sev_es(void);
+efi_status_t setup_vc_handler(void);
 void setup_ghcb_pte(pgd_t *page_table);
 void handle_sev_es_vc(struct ex_regs *regs);
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 65f5972adb29..d79a9f86eda4 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -334,7 +334,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	/* Continue if AMD SEV is not supported, but skip SEV-ES setup */
 	if (status == EFI_SUCCESS) {
 		phase = "AMD SEV-ES";
-		status = setup_amd_sev_es();
+		status = setup_vc_handler();
 	}
 
 	if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED) {
-- 
2.34.1


