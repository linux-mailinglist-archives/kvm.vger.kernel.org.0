Return-Path: <kvm+bounces-13112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD39892700
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9073B22F94
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 22:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A43813E048;
	Fri, 29 Mar 2024 22:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q9r7dIZC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DAD13EFEE;
	Fri, 29 Mar 2024 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753153; cv=fail; b=BYbUnnfXmxEtv1PkrIHV+7kzVO0y3a1Ye+F4TRsm29EL0omYnNLvNDSQwPMrK6Z80fnDzyU2l8EfE3Fm6gpXmT0qiFAbN87V7eOZwJzuqVAJ70gFqLeQEMXZ56g8tSRZScOkyyPbWGrEyHg/1rRmBrm3pQuOvLWGoHZ3WptkQF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753153; c=relaxed/simple;
	bh=32N0Xx4fpPiGgE4gdCbkfdfNikRkU8p14GCc9880qic=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6h1fEpizL+9h9BpHNiFVub3+3P5w3JD0lfdk8PZptPGziwiP5AnrmvxqeGRjE4W5Le1zkKGCVue4EUqS+y04Y+rXUZSUK9J9lyDqkdMCJHY1wU1Byy/7PBF40xIkza8bvGO9bcWbA8C/FJ2d55TKdQO+/guAX1pBzwbXtegNUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q9r7dIZC; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CA9+EpoNiZ9ayMmuF+uTwSeBjPBlCFrkeWODbOoFlUQYPDABUEHwtqo28a8PW/imB4XHrnE6Mt7E6/eCJocLwL2ciZisEmC7AJ22GL9xbPbPArTsRqEhdNCCbYLP8qWdMy7FpFKDiSu99P3EtkWJOVuZR6wJ1zXPkVsxJAHxQ1NZ77Qa85K/ObPQ8AXhBmWwf+YD98Gd+ZIg+6gXsRxooicVQa7Y3DkW94F4Dp2asJhZho3IOy1uRIKUanolI+9CLEqcJE1wd8Pj9ElUfYP1G1okbc8A1YOlkTe5b9ULGwMufalRk2pkDIBD7XR36PUU/mnLms1Qwwj+VM+0nGkajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=;
 b=XUVPXyEnaWzdYWoJNkvqerhl6Svq2T8m2knayzG2+AeIbpHftkICKGYxj3BhyGshE2fO6TH9GpjHVrVPkK/+CpJ64AIdKw86jsY6ZbM8HQwf8klvQ5RxPozzGqx8MCi//iIwzzm3KPNqhj3Ww+jF4+8AE9bU9otOpkMOebIPanjg1MidwxVrLnfjkq7hfRkk/I+aj940z2p1XCAH17I0WNoHu8EhR4AyoCVtX/44RDF24bsnopzDbUsoOPAjhJ/fk/qtp+XVd5ANyraXcDOdxzpXNzWDFF6h5vNh9oBEnYh/p27lBZGuXOhT4rZfFcCDSYu2vULKOAr2b0ovUb+ebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85xfxLH74OdKCMM2bG4Ka/efKmeDa+urj4S6khYBEhI=;
 b=q9r7dIZCmGAMsb5Qf5qevjsO+u2qguOTQwgvMMQeTMWFxL30f5651Ih1rIv4M6gqyWlZAEDGO0VJA6/trmWh7JWA1JQmddseBxmacNU4bozvpuXx54+2xHpPUF3BfBuyIDYp3RuPMt3lUtS6+dQfKoYUuLkX31Den1QT9hFH4FA=
Received: from DS7PR03CA0074.namprd03.prod.outlook.com (2603:10b6:5:3bb::19)
 by SN7PR12MB6861.namprd12.prod.outlook.com (2603:10b6:806:266::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 22:59:07 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::79) by DS7PR03CA0074.outlook.office365.com
 (2603:10b6:5:3bb::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 22:59:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 22:59:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 17:59:00 -0500
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
Subject: [PATCH v12 09/29] KVM: SEV: Add initial SEV-SNP support
Date: Fri, 29 Mar 2024 17:58:15 -0500
Message-ID: <20240329225835.400662-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|SN7PR12MB6861:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a450cd9-fdcd-4e47-ed16-08dc5043d334
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nsYawN22RK6vpJl8VU3uLdBNz2wKwfigLe9u15MYJjT0NXQV3Yzjn6a1OjYj4LPzeDO8cf52t0bld23f73IhgDjhPepqbc7IwHTzPhZ/pO0fb1Dc4F6dPKSdnsPrwbyyhJI21uoEBXlb9DpAIEIBOyVjZmH+wtq/OnN34HGIHNnAASx0iEdmOS44o1oEugf+lFgXmiA6AQWu+IikoKRj2YItSH3Txq0G7BC/TRGiWq2KqdmgFh+n5Hsot5lhcjxEP+iWzkso8UiBcRHFE8Sju6gjTCdVv1uIDSSjI3OvUAubuGZeTloeeL4ALMLAdXglcVDTAeML83k7xVUpdU2UJQx0wb/97jBfBau1zhrRC78B3NehLm2mU8sjwnExhuP/MfHsbmuX5VvLn2CPH9T81lSMjdxVYlZI/ytN2lzlTQ6vcxI+8hSPG9PpG923elprnKSAI7fsLuCaIOF+SPmZqnI+RcAfIX4fms89ZDSC6lffhLHDFAraZ3I86fN9ZemKTUgctwPvboQCfEG3mDxYzLPPQYhchCxYb1wWaG8jFR5sFSVsrE7JQ/SDBGTYpRHKn9KLxD3rVWSX7nTCof7mJAPHXd2W0DPkpcx9TiDMdcZ4+2WH9Ez1YUqwMRjAYVmxwirJl9RK3NI4in6GXQmovhcw4JB7RQikwOS3iiudBKTtfKGD6mR80tiSkJb9G8Bw9pvoQHQlT6bQl8BXfRTgx5cMzVuv0ny3ytgj4cr3PKrxvNDbOm6IUcK3cMc8E9Ls
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 22:59:01.5166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a450cd9-fdcd-4e47-ed16-08dc5043d334
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6861

SEV-SNP builds upon existing SEV and SEV-ES functionality while adding
new hardware-based security protection. SEV-SNP adds strong memory
encryption and integrity protection to help prevent malicious
hypervisor-based attacks such as data replay, memory re-mapping, and
more, to create an isolated execution environment.

Define a new KVM_X86_SNP_VM type which makes use of these capabilities
and extend the KVM_SEV_INIT2 ioctl to support it. Also add a basic
helper to check whether SNP is enabled.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: commit fixups, use similar ASID reporting as with SEV/SEV-ES]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/svm.h      |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 21 ++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/svm/svm.h          | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 38 insertions(+), 4 deletions(-)

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
index 51b13080ed4b..725b75cfe9ff 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -868,5 +868,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1e65f5634ad3..3d9771163562 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -46,6 +46,9 @@ module_param_named(sev, sev_enabled, bool, 0444);
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
+/* enable/disable SEV-SNP support */
+static bool sev_snp_enabled;
+
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
@@ -275,6 +278,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->es_active = es_active;
 	sev->vmsa_features = data->vmsa_features;
 
+	if (vm_type == KVM_X86_SNP_VM)
+		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	ret = sev_asid_new(sev);
 	if (ret)
 		goto e_no_asid;
@@ -326,7 +332,8 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	if (kvm->arch.vm_type != KVM_X86_SEV_VM &&
-	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM)
+	    kvm->arch.vm_type != KVM_X86_SEV_ES_VM &&
+	    kvm->arch.vm_type != KVM_X86_SNP_VM)
 		return -EINVAL;
 
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
@@ -2297,11 +2304,16 @@ void __init sev_set_cpu_caps(void)
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
 
@@ -2382,6 +2394,7 @@ void __init sev_hardware_setup(void)
 	sev_es_asid_count = min_sev_asid - 1;
 	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
 	sev_es_supported = true;
+	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -2394,9 +2407,15 @@ void __init sev_hardware_setup(void)
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
index 0f3b59da0d4a..2c162f6a1d78 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4890,7 +4890,8 @@ static int svm_vm_init(struct kvm *kvm)
 
 	if (type != KVM_X86_DEFAULT_VM &&
 	    type != KVM_X86_SW_PROTECTED_VM) {
-		kvm->arch.has_protected_state = (type == KVM_X86_SEV_ES_VM);
+		kvm->arch.has_protected_state =
+			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
 		to_kvm_sev_info(kvm)->need_init = true;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 157eb3f65269..4a01a81dd9b9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -348,6 +348,18 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 64eda7949f09..f85735b6235d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12603,7 +12603,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.vm_type = type;
 	kvm->arch.has_private_mem =
-		(type == KVM_X86_SW_PROTECTED_VM);
+		(type == KVM_X86_SW_PROTECTED_VM || type == KVM_X86_SNP_VM);
 
 	ret = kvm_page_track_init(kvm);
 	if (ret)
-- 
2.25.1


