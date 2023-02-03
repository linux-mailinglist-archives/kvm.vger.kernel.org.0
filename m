Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B978A688EDF
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 06:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjBCFP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 00:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBCFP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 00:15:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A84C62788;
        Thu,  2 Feb 2023 21:15:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXafzf3uEqIyzDHD5WcssOLTVVPDtss/rM/ov+1HSUQ0crAU4x7B/aGW96W5z3Eoe2mlYNM7ta6GMQ1GERKUmALLPu0LxUyY18rlx/5D5iktv+BYBqqPIsP+XGsA6ArQiGJYXwKacRm8m6qdWF9/qkNXdkjGW7V3hYb/5venRTL2P33FJ2mgxmLJCIVLbJLkTSsFsOm/aswbVrFyO72S5el90yRNNQFHF026MosQ3gjUdqt0+tW7c4Sz9ZhS8zcy5eEq0k2fNpF2N9GddQrqYMMM0D09iZNOLteUMfz5wiyQw5waeQLVHrD8NeRP1FhJ6uDz9F5EpF/gBSV3W7B46Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjjhNyTGwjsxi8FbMx7YtaMXDmlPUX0TY2ULP+jGX40=;
 b=KSeSZR9gd3PH8773FxMkJZIU9NoBV9Y+vAPNVdJ/QE0OhkQ7SZvUgHz3CAma7VxbRJEGGoq2A1RMF4DTDgtL8v2QPIdST1fMtDNsTAXCFLY52GUXVp3nPI+nM5X0zAYZbkYAa5DjEche72zpVVowIsKzxxfo5dEAbSefvWo9lpABwPP1Vh2ea9jMl87H3BVRROewZ2CZ7fISni91W7Q5dh5XcdSyCE3I4sPSUBYNkUkBRI/kc1PjL7XtQxjykpIBsoc7duLULP2zBtIGaaNTXxY85uRg3NTnew28fdt57AfdjXUo4ATihjPdcYPVeh30l8GrzFbcjcIjSTsTic8Ytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjjhNyTGwjsxi8FbMx7YtaMXDmlPUX0TY2ULP+jGX40=;
 b=a48UnATX86275XhLXuoRdth45iQEGIpHEK1gkH1Bc+KZPTIp/Srqn9yGXyYB8B6yLJ1Xcdp4N2f4SvrVDH8LoYYovxnBIPvu+14AdFsUSgOxfvFDUh8C6OlvOjxrSs+fC2a1VPuX9pj7oX+Yfmb/lvQ3CpXNoEbMpPVD7gtWmyg=
Received: from BN9PR03CA0919.namprd03.prod.outlook.com (2603:10b6:408:107::24)
 by SA3PR12MB8439.namprd12.prod.outlook.com (2603:10b6:806:2f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 05:15:22 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::10) by BN9PR03CA0919.outlook.office365.com
 (2603:10b6:408:107::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28 via Frontend
 Transport; Fri, 3 Feb 2023 05:15:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Fri, 3 Feb 2023 05:15:21 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 23:15:15 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v4] KVM: SEV: Enable data breakpoints in SEV-ES
Date:   Fri, 3 Feb 2023 16:14:59 +1100
Message-ID: <20230203051459.1354589-1-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
References: <3b3a9ebc-b02e-a365-7f68-3da9189d062a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT016:EE_|SA3PR12MB8439:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a7c4e6-ea28-49e1-f607-08db05a5a642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gkWSqqNvNhSA84TrMKX7Xm1vkiDCr2VVD9akxxK6Ve3vs6WuRDzCBjup/N/G1QSyHaHKMeZ+fGofMpovL0xHISiqCsgxaZZmjrBesDmCiH45QQjLcQywZiUjkoScZF65DTSdd6B/Xbv0X6BMiid2NL0S4vRKxu8OPeP/OZ85hvx9GZGouyt51aDi6XINvEvx61HISQ/v6LqRA9l3EreYe8pzjAfLghMb1w3/gfojtjV9kn7By70X+spHcCJMBSuVpltd6+qTAl/CcBmfiTxKHmH1Uj1Fpyl2Se4AfDQYmCzIEf/vdGuEcMcxcAxyw+9KlNoc3lk5J9JvKhPxuyXpVOoNtZl/wgMBy8nbj2WNLWnsJ7wterffnBo1acev6GfYN9nrDMA+G4shDcXMzmBupQAjM4ck3y3yLraBQbglybINOujLh+PwIsDJaDpNauFmzYE3obs/BnxCCuv4GZknJ9EwopBy3fH+xunlOocuk7mFkIpEyZLga8Mz5iSWZhrUm8OdTIvsbsBouvyL+hLcrDeHDRk28fB3SZUugKF28C7Zmtbdj0MskScYuhA5+UBgDezdaiVKdRKjh86VJ5porlfELwApFHTVEdX9OJcc2CUgN2xZRnxgys+kMX47QZOECQn7/2oIof4IYm0pmqaUGxeH8DSg5S5+zWTjb/7xQaNTl51PCK9cHxadHNUhTiVcVu1XyoNlZmqW90qSfsfzRFmlqSaDkV9/NS4g5wCmc8M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(36840700001)(40470700004)(46966006)(2906002)(54906003)(16526019)(478600001)(7416002)(26005)(1076003)(5660300002)(186003)(36860700001)(2616005)(336012)(30864003)(8936002)(6666004)(40460700003)(41300700001)(47076005)(356005)(6916009)(4326008)(81166007)(82310400005)(83380400001)(426003)(70586007)(40480700001)(70206006)(82740400003)(316002)(36756003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 05:15:21.9737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a7c4e6-ea28-49e1-f607-08db05a5a642
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8439
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prior to SEV-ES, KVM stored/loaded host debug registers upon switching
to/from a VM. Changing those registers inside a running SEV VM
triggered #VC exit to KVM.

SEV-ES added the encrypted state (ES) which uses an encrypted guest page
for the VM state (VMSA). The hardware saves/restores certain registers on
VMRUN/VMEXIT according to a swap type (A, B, C), see
"Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
volume 2.

AMD Milan (Fam 19h) introduces support for the debug registers swapping.
DR6 and DR7 are always swapped. DR[0-3] and DR[0-3]_ADDR_MASK are swapped
a type B when SEV_FEATURES[5] ("DebugSwap") is set.

Enable DebugSwap in VMSA. But only do so if CPUID Fn80000021_EAX[0]
("NoNestedDataBp", "Processor ignores nested data breakpoints") is
supported by the SOC as otherwise a malicious SEV-ES guest can set up
data breakpoints on the #VC IDT entry/stack and cause an infinite loop.

Eliminate DR7 and #DB intercepts as:
- they are not needed when DebugSwap is supported;
- #VC for these intercepts is most likely not supported anyway and
kills the VM.
Keep DR7 intercepted unless DebugSwap enabled to prevent the infinite #DB
loop DoS.

While at this, move set_/clr_dr_intercepts to .c and move #DB intercept
next to DR7 intercept.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v4:
* removed sev_es_is_debug_swap_enabled() helper
* made sev_es_debug_swap_enabled (module param) static
* set sev_feature early in sev_es_init_vmcb() and made intercepts
  dependend on it vs. module param
* move set_/clr_dr_intercepts to .c

v3:
* rewrote the commit log again
* rebased on tip/master to use recently defined X86_FEATURE_NO_NESTED_DATA_BP
* s/boot_cpu_has/cpu_feature_enabled/

v2:
* debug_swap moved from vcpu to module_param
* rewrote commit log

---
Tested with:
===
int x;
int main(int argc, char *argv[])
{
        x = 1;
        return 0;
}
===
gcc -g a.c
rsync a.out ruby-954vm:~/
ssh -t ruby-954vm 'gdb -ex "file a.out" -ex "watch x" -ex r'

where ruby-954vm is a VM.

With "/sys/module/kvm_amd/parameters/debug_swap = 0", gdb does not stop
on the watchpoint, with "= 1" - gdb does.
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/svm.h     | 42 -------------
 arch/x86/kvm/svm/sev.c     | 24 ++++++++
 arch/x86/kvm/svm/svm.c     | 65 +++++++++++++++++++-
 4 files changed, 87 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index cb1ee53ad3b1..665515c7edae 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -278,6 +278,7 @@ enum avic_ipi_failure_cause {
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
+#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4826e6cc611b..653fd09929df 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -389,48 +389,6 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
-static inline void set_dr_intercepts(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	if (!sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
-	}
-
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_dr_intercepts(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-	}
-
-	recalc_intercepts(svm);
-}
-
 static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 86d6897f4806..af775410c5eb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -52,9 +53,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-ES DebugSwap support */
+static bool sev_es_debug_swap_enabled = true;
+module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0644);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
+#define sev_es_debug_swap false
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
@@ -2249,6 +2255,8 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
+		sev_es_debug_swap_enabled = false;
 #endif
 }
 
@@ -2940,6 +2948,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct sev_es_save_area *save = svm->sev_es.vmsa;
 
 	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ES_ENABLE;
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
@@ -2988,6 +2997,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 	}
+
+	if (sev_es_debug_swap_enabled)
+		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
@@ -3027,6 +3039,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
+
+	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
+	if (sev_es_debug_swap_enabled) {
+		hostsa->dr0 = native_get_debugreg(0);
+		hostsa->dr1 = native_get_debugreg(1);
+		hostsa->dr2 = native_get_debugreg(2);
+		hostsa->dr3 = native_get_debugreg(3);
+		hostsa->dr0_addr_mask = amd_get_dr_addr_mask(0);
+		hostsa->dr1_addr_mask = amd_get_dr_addr_mask(1);
+		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
+		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
+	}
 }
 
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 60c7c880266b..f8e222bee22a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -671,6 +671,65 @@ static int svm_cpu_init(int cpu)
 
 }
 
+static void set_dr_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+	bool intercept;
+
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	}
+
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		struct sev_es_save_area *save = svm->sev_es.vmsa;
+
+		intercept = !(save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP);
+	} else {
+		intercept = true;
+	}
+
+	if (intercept) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+		set_exception_intercept(svm, DB_VECTOR);
+	}
+
+	recalc_intercepts(svm);
+}
+
+static void clr_dr_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+	struct sev_es_save_area *save = svm->sev_es.vmsa;
+
+	vmcb->control.intercepts[INTERCEPT_DR] = 0;
+
+	/*
+	 * DR7 access must remain intercepted for an SEV-ES guest unless DebugSwap
+	 * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM writing to DR7
+	 * from the #DB handler may trigger infinite loop of #DB's.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm) && (save->sev_features & SVM_SEV_FEAT_DEBUG_SWAP)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
+	recalc_intercepts(svm);
+}
+
 static int direct_access_msr_slot(u32 msr)
 {
 	u32 i;
@@ -1184,13 +1243,11 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_apicv_active(vcpu))
 		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 
-	set_dr_intercepts(svm);
-
 	set_exception_intercept(svm, PF_VECTOR);
 	set_exception_intercept(svm, UD_VECTOR);
 	set_exception_intercept(svm, MC_VECTOR);
 	set_exception_intercept(svm, AC_VECTOR);
-	set_exception_intercept(svm, DB_VECTOR);
+
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
@@ -1308,6 +1365,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	if (sev_guest(vcpu->kvm))
 		sev_init_vmcb(svm);
 
+	set_dr_intercepts(svm);
+
 	svm_hv_init_vmcb(vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
 
-- 
2.39.1

