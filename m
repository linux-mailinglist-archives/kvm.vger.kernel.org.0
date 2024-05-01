Return-Path: <kvm+bounces-16322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 617688B8749
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19A0628270B
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6445F502B4;
	Wed,  1 May 2024 09:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lg3SOjLc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EDD4E1A2;
	Wed,  1 May 2024 09:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554486; cv=fail; b=IbGrGRkhwv+tQMpacLxV83vabE7qFOeHjRfxxe9xGLCnsE7iZVWAiWCmhhr+ZnoQ43sidMdNQoeXnT8zimcmfyP4GDY9rf+WKHGC3Q+Pb1gYomrQpxKchAGTYQ9Ll3GEkyNZj6SDRvGXi53D5recYtUOG7PLz9j7sCqaikc12Pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554486; c=relaxed/simple;
	bh=Hp471QranugjUypt6cnWLkko5TpXESrkGYW44SWbfjs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJHFsfqR3n6z4VG/CnBCS5pATtxoMiSdEgr9FoeEROKQVgfxkXRjeXllh1ORtuSdxZ0gX6HuGaJ51/gBBM74r4mO7qBCuYoAxRjD8/grW2wrD099pBOr9+MQSoJwCY0Ntz8iyoDnCWR2HueWV2BDTCAsw58vBoTzuDW5IfHyxmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lg3SOjLc; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiC5Tm8kFPvajn6mGnrcvyRYSagm42VsJqJZwwZQEAbWa1kFKbQ8aRWrxlDiHYyt0F/f1afQYXEa2Eg50iIFMruyBgjf71fMMaFrg/kCvBKldpXyNjF8w4fVng5h8Wne6lw2Xmp/bRzIsdR53ZuAqbW8Pt/NyVa0v+7DNEgbnH2KEatYbUdPNwBQmwB80yATRamoEGs9Ki4earNwNqsmyBrky6ToTmTw3vABsMmp85rZkKuseHIP0SiOxTX7fmXRD6aJjqiGmnDDCuSxjhjFk3QDOlJ9CY6aquU3O1oXKsyNsjrUtxpmVx/9hMoBnfqxjAw8hgxH6ufsvbQasX/jBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JoBb4Rvwn2Q5aMHC/+7SFu3Ry/fPDAnvq/GxIbd4pvU=;
 b=IKKMngiGJtjlFIa72Zxim5hcC44HcgbWcIVYlvGycXfnQepBeywuGazyZbEz3JgKs2f8vn/e8RH3ZLxjadWkX7GGquciRih11a4VNQNmBS9O6+9AnVewanSyoGKCgdbj3Z+2D61hmFkBRIvwHVPATfk5v26Hnmu4mHOBlNFQ5Bg2264r9UCZb43bVl48YLqucRAz3Iuxe3AWGSSQJjliIoXP1vBY530nl3gEIx+YgmEmrcEqto9ZBeUQtwnVnm4a8TEDmG0Ok+5m4Qj/wkXzxKV10AgVxX12gj1hZiri9G46TGndkHf0B+1/sk55wiz+4tSpuX8ej93Y/S5GBCGZng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JoBb4Rvwn2Q5aMHC/+7SFu3Ry/fPDAnvq/GxIbd4pvU=;
 b=lg3SOjLcWCB6T8m9VFOQCDaqYzg4Jk5RoKC9DMn8ctQ60A8XJ6D2g+Zm8TdLJlMVBhpcQEyWXKpdfCFYs21Y0ofH+3B7jJsOoMN31XJaWe8PFLfzZA4FyCVsY+g92CChSw4GcQohE+wgC0/DyUIF6CHtWj2BixmesUpuauTypOg=
Received: from BN9PR03CA0650.namprd03.prod.outlook.com (2603:10b6:408:13b::25)
 by DM4PR12MB7768.namprd12.prod.outlook.com (2603:10b6:8:102::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:07:59 +0000
Received: from BN2PEPF000044A0.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::e0) by BN9PR03CA0650.outlook.office365.com
 (2603:10b6:408:13b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.27 via Frontend
 Transport; Wed, 1 May 2024 09:07:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A0.mail.protection.outlook.com (10.167.243.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:07:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:07:58 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v15 04/20] KVM: SEV: Add initial SEV-SNP support
Date: Wed, 1 May 2024 03:51:54 -0500
Message-ID: <20240501085210.2213060-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A0:EE_|DM4PR12MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e49441f-61cd-4171-1ec6-08dc69be32a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|376005|82310400014|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TVgMncpKV5z4L41/HScfFsZNk/okUuRy1J17QvGZRbgk36mh97fBpxLhS1pn?=
 =?us-ascii?Q?ZheiSe0z5eAQZTxZTfw17vEvBPsWecoFAJYliUMBYpkk7qOh5SAyufH93uXi?=
 =?us-ascii?Q?G0LXQc06WFF6QDM+BFiSDPiMEdH6+U0cLZILOTUvuvPnLLrEGS7qnBRiGMzb?=
 =?us-ascii?Q?KPlO2quOa19J9+LSO0y1SbX9ZEPq6A15I1U89PWQMXRJiVGbjJkehqGi1sXo?=
 =?us-ascii?Q?EELaKsiYriXo0nxSJ2QdX3K9/2snHOmOhepNVdtRjoGXn7pBY0N/MsuRt3Js?=
 =?us-ascii?Q?toE58KmhgPzUOF19fiN8XFX36gzkTMHarDTWE505bNNUNYRAOjacXvg8A1tD?=
 =?us-ascii?Q?R4b9+IAl/xuQAJdkPjwzMYOpclV9t2CGgL1WkjqzWedZ7oZMe6aBDrVL3UTf?=
 =?us-ascii?Q?wsGvva52jEirCIgxw181BuYFLddjqb55+h4jieTGEsAaPvDBKVDD6BP5Aq/c?=
 =?us-ascii?Q?ys14QtefPByjWoXMrK8DfM3QnVcy7CaSlAcx3ua0wiWdC2BIXu31cJ3OEYHa?=
 =?us-ascii?Q?wCPmo3pCAsuBqnUc0AlU1lxbNwDvc2ZaQ3D6cYasrJh+4mUEH2iUjrKdSv7S?=
 =?us-ascii?Q?CdFZhMOXafVK2/J7oJ6mdWHG/E33O85untbH/iQM2PXrfEsGIYZZ5mlctxM0?=
 =?us-ascii?Q?pEHi1KW+n2XFIkFeabg0nYhq0/XPmXhuIlmf9XcZ+NGC0gy1y0Ye9YXuSXZh?=
 =?us-ascii?Q?eiLBj/ZCDc6fROhFdCK3Bcyb3kZo4CgwOG3WD58beZ2zBHV1qdfOBWe0OCgY?=
 =?us-ascii?Q?geH4HxDVRpr2iK05pFyvNkn07gCaUrM1lkchIeBvBe+LFoEhDqZ7/iaIkd/o?=
 =?us-ascii?Q?V0Hc6/dOEsLDL3F6PMupYcFOz+YkFIww87GBVLd1kuglLrKsqVwMtrFwVyML?=
 =?us-ascii?Q?EyHewdETCvAAzVwTbgqXJorsgwPbtsANlCv0Y9Xpcz4PA7Lq3mymK5XTr44t?=
 =?us-ascii?Q?A4nP3PFhCL1iOss9iPQqvN9eSoBKEqsp2WlTz9ojJpKbKfWlKsX3YXhlcUSg?=
 =?us-ascii?Q?1iz4a5/gQ/Cr1hlL08gC9xAjJHnxTVPRPT4DtJZmWuOADoqjJrzrxRgKCmIY?=
 =?us-ascii?Q?SpE16w8jKi38axEu0dclSD6PGbFd/xlKGz72Djg3ABVrjbeEt50GnifVI2rP?=
 =?us-ascii?Q?HgR/8Kf4TZ8fFfL45O9dP+LDj6ni5m1jOMIolciTCaRhHxSafUO0SlnBahaB?=
 =?us-ascii?Q?6agHo+0U8nAAPF7VdaKXE7zhKV1KGDPYi5I3SzyPpJFriOA1g34O3bLQeUQZ?=
 =?us-ascii?Q?wB8aRyIZG40rmdFzlOQddQ6FuFX9x7GHQXbbGwrUiDKslS0+yuEK6zcmN5q6?=
 =?us-ascii?Q?CoUGKD8cnS/V938zGcQqYbI49SCklzPnuJaPilY8pNnPUre5MP/EjOiukrKL?=
 =?us-ascii?Q?s9hBFYP248lUHli6bzbtphknisDJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:07:59.3043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e49441f-61cd-4171-1ec6-08dc69be32a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7768

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Define a new KVM_X86_SNP_VM type which makes use of these capabilities
and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
helper to check whether SNP is enabled and set PFERR_PRIVATE_ACCESS for
private #NPFs so they are handled appropriately by KVM MMU.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/svm.h      |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  8 +++++++-
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 5 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 728c98175b9c..544a43c1cf11 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -285,7 +285,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
-#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
+#define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
+#define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9fae1b73b529..d2ae5fcc0275 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -874,5 +874,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a4bde1193b92..be831e2c06eb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -47,6 +47,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -288,6 +291,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (sev->es_active && !sev->ghcb_version)
 		sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
+	if (vm_type == KVM_X86_SNP_VM)
+		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret = sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -348,7 +354,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type != KVM_X86_SNP_VM)
 		return -EINVAL;
 
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2328,11 +2335,16 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
 	}
+	if (sev_snp_enabled) {
+		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
+		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+	}
 }
 
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
@@ -2413,6 +2425,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2425,9 +2438,15 @@ void __init sev_hardware_setup(void)
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
 			sev_es_supported ? "enabled" : "disabled",
 			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
+	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
+		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
+			sev_snp_supported ? "enabled" : "disabled",
+			min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
 
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	sev_snp_enabled = sev_snp_supported;
+
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 535018f152a3..422b452fbc3b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2056,6 +2056,9 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
 		error_code &= ~PFERR_SYNTHETIC_MASK;
 
+	if (sev_snp_guest(vcpu->kvm) && (error_code & PFERR_GUEST_ENC_MASK))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	trace_kvm_page_fault(vcpu, fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
@@ -4899,8 +4902,11 @@ static int svm_vm_init(struct kvm *kvm)
 
 	if (type != KVM_X86_DEFAULT_VM &&
 	    type != KVM_X86_SW_PROTECTED_VM) {
-		kvm->arch.has_protected_state = (type == KVM_X86_SEV_ES_VM);
+		kvm->arch.has_protected_state =
+			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
+
+		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9ae0c57c7d20..1407acf45a23 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -349,6 +349,18 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
+static __always_inline bool sev_snp_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
+	       !WARN_ON_ONCE(!sev_es_guest(kvm));
+#else
+	return false;
+#endif
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


