Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315DB6DDB7E
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjDKM75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 08:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjDKM7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 08:59:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B77525A;
        Tue, 11 Apr 2023 05:59:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R59mKn87htRCDIlYSdychMje2Su0AAH2nRjB7eKgcLdh3SDCJO33Xq3vVMwFATF0Cd3XjrcELCYKvTyMobv+5FBDiUTDgnyTMODIdON6a0W1uIRGncfhjuJuinTnYr5P1wzFrwQ0q3cKzAq17FmqJeWb1Wa9XM+vZLd4trjChj2QSynWx3/I8avzejyPT/+6kuf7Bl0h8D2Txdb9kw68q5eoyibHT1cTXGiOB+RfdO7tiiLeCb2w4l/DGdhxxxI466bU1uBgN3RYd5PoVFxSaQ55jzYvsd3aKv/vVozRZa9SAE9GTxf7GqbJ7wwwcsNCXZ7klt0zPeCyG7/hLCUhog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIW0h8/Qm6mnE3Ce8k2cfEK7Nnv2b/n5SmnjoDjNels=;
 b=byGTfSgme1yKBfYIL93fa13WWce3MxHPL8HwMlCWg5TMPA9L9ujA5mCJYQHCffcTuq2W8dOyyv/KOnZ5+CRMs/mnvtQ308GidhdOuY6fK1+2ruTtb+B5EjOuYSVls5UySaRsioL6GmnV1PKKzyB7Fg9w6nuQEua41J+DWOZhAumxmpQ8hdKozx7b94hrU/LiyQ4VdpWdAb9mxBZHKqTe/cUuAnXvHt3WpRgBcdtDoNlAhJkz3edKM4arZ+MFJD5kYqnfUAXfBJmM6+Kl8JIBd8QBtz+OtvjqO5XcSDgso3LZjJFg12QkZ+EkhK83tyw8M2ooAAI41foNWE/YQHVLSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIW0h8/Qm6mnE3Ce8k2cfEK7Nnv2b/n5SmnjoDjNels=;
 b=BeUKh4l+DV3G3f1u1PfCbnj05EIQgwWiF28xE41ENujLG9yVNCOLemEQl/IdV/I8YmJGmQBRhSFjiLjygJmwoyrcasueBtQV+Tvr6yRAB/uO1IVQREJLiP6nCicX4R0O8/5RGn11lBs1HsfOMzt87FLg8yQlAfHNMdBVTIzqK7k=
Received: from MW2PR16CA0058.namprd16.prod.outlook.com (2603:10b6:907:1::35)
 by DS0PR12MB8247.namprd12.prod.outlook.com (2603:10b6:8:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 12:59:21 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::a6) by MW2PR16CA0058.outlook.office365.com
 (2603:10b6:907:1::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36 via Frontend
 Transport; Tue, 11 Apr 2023 12:59:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:59:20 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:59:15 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Pankaj Gupta" <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        "Santosh Shukla" <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
Date:   Tue, 11 Apr 2023 22:57:17 +1000
Message-ID: <20230411125718.2297768-6-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230411125718.2297768-1-aik@amd.com>
References: <20230411125718.2297768-1-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|DS0PR12MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 1459e85c-cea1-4d7a-60cb-08db3a8c9142
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wn5PX14lhWx7ZZepMf9jm/RfHuynjB6MrZWgA4XHVzHvfLe3Hut2u5MixDPJyBPOg4GYCT8RXxBluQK0vo0DqNtjcce8uiDqvcZMDLdBRVvC0hInQT8mG4EObQNBuLdNNy3yA43NrHlUzeVQVmErXEXpdPrPouUFhn2zBQfBEWXuCGmybEwDDkKZvGxWJ4I9ncerm6q2+Zuf3snKkDt8t7UJc2dA3sqHSopFcqcH5aZtJRtEUfYr3i2ctsXhVF5e6Y9f5QkAGbBypkTzKl4fir4D2mQgBtWqjMRQ7tecpQzeZ/6hsg3VHFRpGuAkryeNmmvDY/SvHHvXgpRlW4dMDTMZJ0XkhMGDEW28WgTCJ/cDfBQ8cPUqvtWCtBmPWHqzRSLIvLX3TcANwVNDETh2d5PdBwohUg5WHWFNyaem4+t07YXA7OREB9cD//NzZcA/E3CIa+E0R4XDYBN/6lpqIvgtYXEKf1MoVf6Xqe8CaeRlxR1mnuD6R6kDvljX13Mo6prt1u4N0QqQiwHs48bkWQE4yZO00Jes0zGGrxzyUpX3Y77hW0khmdNsSilZYdV0/sbdRXL6gJEWJLmPp8qI78/K7dh8Mu073MLXUf+kim2W21zwK4R2grOmiUTq+nv4GB1U4Qbo7PfNDGk+5rD0JpSJTCUR6h/rq42El1dWKjdlsOUgi2lIGNR2GhWCvH2vx5uRsHUv0qEyRiFCoS0USHSRoe2eb3In7nkZbHz6+QRmHYLH8v/ZAJBMuMr6xzVC9H0miu5ruWXCq0adr/BQVg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199021)(46966006)(40470700004)(36840700001)(478600001)(47076005)(40460700003)(40480700001)(36756003)(83380400001)(82740400003)(356005)(81166007)(426003)(2616005)(336012)(36860700001)(2906002)(54906003)(316002)(1076003)(186003)(16526019)(26005)(5660300002)(41300700001)(8936002)(6916009)(82310400005)(8676002)(70206006)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:59:20.8529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1459e85c-cea1-4d7a-60cb-08db3a8c9142
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8247
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prior to SEV-ES, KVM saved/restored host debug registers upon switching
to/from a VM. Changing those registers inside a running SEV VM
triggered #VMEXIT to KVM.

SEV-ES added encrypted state (ES) which uses an encrypted page
for the VM state (VMSA). The hardware saves/restores certain registers
on VMRUN/VMEXIT according to a swap type (A, B, C), see
"Table B-3. Swap Types" in the AMD Architecture Programmer’s Manual
volume 2.

The DR6 and DR7 registers have always been swapped as Type A for SEV-ES
guests, but a new feature is available, identified via
CPUID Fn8000001F_EAX[14] "DebugSwap for SEV-ES guests", that provides
support for swapping additional debug registers. DR[0-3] and
DR[0-3]_ADDR_MASK are swapped as Type B when SEV_FEATURES[5] (DebugSwap)
is set.

Enable DebugSwap for a VMSA but only do so if CPUID Fn80000021_EAX[0]
("NoNestedDataBp", "Processor ignores nested data breakpoints") is
supported by the SOC as otherwise a malicious SEV-ES guest can set up
data breakpoints on the #DB IDT entry/stack and cause an infinite loop.
Set the features bit in sev_es_sync_vmsa() which is the last point
when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
init happens) is called not only when VCPU is initialized but also on
intrahost migration when VMSA is encrypted.

Eliminate DR7 and #DB intercepts as:
- they are not needed when DebugSwap is supported;
- #VC for these intercepts is most likely not supported anyway and
kills the VM.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
Changes:
v8:
* added CPUID's DebugSwap feature
* commit log, comments updated
* redid the whole thing

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
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  1 +
 arch/x86/kvm/svm/sev.c             | 36 ++++++++++++++++++--
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d9c190cdefa9..3a5eeb178778 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -435,6 +435,7 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
+#define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 770dcf75eaa9..3a422d213010 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -280,6 +280,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
+#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f0885250252d..ba12e7962e94 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -53,9 +54,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+
+/* enable/disable SEV-ES DebugSwap support */
+static bool sev_es_debug_swap_enabled = true;
+module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 #else
 #define sev_enabled false
 #define sev_es_enabled false
+#define sev_es_debug_swap_enabled false
 #endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
@@ -605,6 +611,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (sev_es_debug_swap_enabled)
+		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -2256,6 +2265,9 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
+	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
+		sev_es_debug_swap_enabled = false;
 #endif
 }
 
@@ -2976,14 +2988,20 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
 	/*
+	 * Unless DebugSwap (depends on X86_FEATURE_NO_NESTED_DATA_BP) is enabled,
 	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
 	 * the guest kernel enable debugging as otherwise a VM writing to DR7
 	 * from the #DB handler may trigger infinite loop of #DB's.
 	 */
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-	recalc_intercepts(svm);
+	if (sev_es_debug_swap_enabled) {
+		clr_exception_intercept(svm, DB_VECTOR);
+		/* clr_exception_intercept() called recalc_intercepts() */
+	} else {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+		recalc_intercepts(svm);
+	}
 
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
@@ -3048,6 +3066,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
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
-- 
2.39.1

