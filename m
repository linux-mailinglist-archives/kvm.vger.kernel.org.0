Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6386749C8
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 04:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjATDNR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 22:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjATDNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 22:13:09 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CCAA261;
        Thu, 19 Jan 2023 19:12:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osk6df7171teTjJgVozlh+nyC7AL6wmSgksvPiBNsSI4JSyTk8G/AatBXIoXtr8a2kM5fc8x02EeU5vFE1LwsDFrsZGoBhLXlIT3rw51PT4vmECkgMh3+jzgJt/9zmeHN3k83a1A0SowopCcYVZvwLk8icPdXhtnvCYUrPdfBfzYkZDXfSNMcYo8mH/mSjWLBTa9F1gAwjHKgxnDrofzcoC5eICzyY/EdI6h8HykTZyShvEQ1gotX6tjI4n5IZU6AVzCvhqlybD2lmuh9naGCi7G7qSPnAvUCE+4FjEXawWnmtS8IKOYekiQVeNz1el6dRhXDR/PfpasYgtmyrvWew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12/ZbAnMQUE9W3kfS+a+xzOcPcWwC0K/TIyDQl3EWWw=;
 b=CqsxsFOaP3W3HC6zmlhGeVNjYt5dCMC07Rz/r3YfT3vm21ETsTMeSFXH5S0erKS8LoSeJrEC3+HjW0pC9CKSgAnAu7GFqkmY9agXT4KLP3GNNBAuEd2mrrG3t/ccls6zTuRSE+wGIypWsswzWKcQVIh+vSqK9ZSMm6++Jg6NTysFoEapvv8ce7iyyVGteEs5U3WV+71xXO2vcZ3uhyyo8Zk6vIYuZwlOlLM4rEoyRgngie56tKrwEXYb+nMIjVOJizBdW9Nsru2A4YChnIkrNT46NcVvycR7nXQ67kQ5PO4SPYvHb1EmpMcqTTBN7LZP25XaZPHR0fYLWY/+SmL/vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12/ZbAnMQUE9W3kfS+a+xzOcPcWwC0K/TIyDQl3EWWw=;
 b=HIMcBVehAqW/RhG9MAHE4vl3KtWy7UxuP9Zsf9Wy/iE6RtUJ4h2S76fAryoNBLRD38liwnMpygIkk7I9WRqSY0zVugdyJZ2zFgB7BMFSKzCmuQnq+Ibexx7jev78bYuiVGrud9g0iybJyT5X9f9o3nmd2BTFVcfDKSfhDBKL8yk=
Received: from DM6PR05CA0050.namprd05.prod.outlook.com (2603:10b6:5:335::19)
 by CH0PR12MB5346.namprd12.prod.outlook.com (2603:10b6:610:d5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 03:12:53 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::b1) by DM6PR05CA0050.outlook.office365.com
 (2603:10b6:5:335::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.17 via Frontend
 Transport; Fri, 20 Jan 2023 03:12:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Fri, 20 Jan 2023 03:12:53 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 21:12:40 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sean Christopherson" <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH kernel v3 2/3] KVM: SEV: Enable data breakpoints in SEV-ES
Date:   Fri, 20 Jan 2023 14:10:46 +1100
Message-ID: <20230120031047.628097-3-aik@amd.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230120031047.628097-1-aik@amd.com>
References: <20230120031047.628097-1-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|CH0PR12MB5346:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb716e6-1cca-4e40-d1d6-08dafa94383e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q3gkdyf3yNpWMZXLk5bN0By5Yehl114+0KxT1rW/gFIqtUKZieA/rr5EEC9wANTU5W2iaZ5Pdl2i82+xwu7k+Golaa+0nn0TX1RB662HKIJPaDl0WdUDJ4nTWtfmXKd0AzVUpP/7OobU24mtvnr1udKV9m5P7qmJa4NDz7gtcFDx4NSwxZt02ZfooS6flfdt6xeXkvVq4UeR4HmaLg9d8A4GyKBEAh4pA5BlOGpVfxzGz7+tN8X85wX8hqv7C3SQzlbNqUpHOuFenUuYa573BDgRiS0i348E8k6k5rYAP3ox4ztl7JpLXZJFvrp6gguL0j9rRGJyn8uQ5ySVP0oqsb9O+IEfp5XgHhiSi5ry7m30fzI50/pJINiVT1vbAgAeW25z61eXLApK31uwPKMazoj4C1SlXicKuXWIj383MDRAlOslUwZVRt0sMJ/0jl2vXpt4FyQ5lQF7uJeGBnOi8fGqMtnBEUmKg/d9mxTjK0cxs0dj7Lrb358gUeHkp6/J5XDSWz4PEytij37ra5TdX0yPrXVErntVGXtZmQI1ud7hDv3NnlVV8136pd3khooJi7rKIFh6G4x9bJGIyvGQIwh7yK0hVRpmSmM/MDs+Zo1Rv3H38kCi9Bz4Zi0IxTfWKtqO66rdvQHDeH+EA7FOpqeCmFK2MOmxxSqJc1JynuHN11AZYYKFHS3OazI/buc88pYqFRlEQBhui09J05RcjC1GrwSMI9DFuNRHzZm7yhY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199015)(46966006)(40470700004)(36840700001)(82310400005)(356005)(6200100001)(40480700001)(36860700001)(478600001)(336012)(2906002)(37006003)(316002)(82740400003)(7416002)(1076003)(5660300002)(4326008)(2616005)(81166007)(54906003)(70586007)(70206006)(40460700003)(47076005)(83380400001)(7049001)(426003)(6862004)(41300700001)(8936002)(186003)(8676002)(16526019)(26005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 03:12:53.1153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb716e6-1cca-4e40-d1d6-08dafa94383e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5346
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
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
 arch/x86/kvm/svm/svm.h     | 16 ++++++++---
 arch/x86/kvm/svm/sev.c     | 29 ++++++++++++++++++++
 arch/x86/kvm/svm/svm.c     |  3 +-
 4 files changed, 44 insertions(+), 5 deletions(-)

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
index 4826e6cc611b..61f2cad1cbaf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -389,6 +389,8 @@ static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u3
 	return test_bit(bit, (unsigned long *)&control->intercepts);
 }
 
+extern bool sev_es_is_debug_swap_enabled(void);
+
 static inline void set_dr_intercepts(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -410,8 +412,10 @@ static inline void set_dr_intercepts(struct vcpu_svm *svm)
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
 	}
 
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	if (!sev_es_guest(svm->vcpu.kvm) || !sev_es_is_debug_swap_enabled()) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
 
 	recalc_intercepts(svm);
 }
@@ -422,8 +426,12 @@ static inline void clr_dr_intercepts(struct vcpu_svm *svm)
 
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
 
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
+	/*
+	 * DR7 access must remain intercepted for an SEV-ES guest unless DebugSwap
+	 * (depends on NO_NESTED_DATA_BP) is enabled as otherwise a VM writing to DR7
+	 * from the #DB handler may trigger infinite loop of #DB's.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm) && !sev_es_is_debug_swap_enabled()) {
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
 		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
 	}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 86d6897f4806..e989a6f4953d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -52,11 +53,21 @@ module_param_named(sev, sev_enabled, bool, 0444);
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
 
+bool sev_es_is_debug_swap_enabled(void)
+{
+	return sev_es_debug_swap_enabled;
+}
+
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
 static DEFINE_MUTEX(sev_bitmap_lock);
@@ -604,6 +615,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (sev_es_is_debug_swap_enabled())
+		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -2249,6 +2263,9 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	if (sev_es_debug_swap_enabled)
+		sev_es_debug_swap_enabled = sev_es_enabled &&
+			cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP);
 #endif
 }
 
@@ -3027,6 +3044,18 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 
 	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
+
+	/* The DebugSwap SEV feature does Type B swaps of DR[0-3] */
+	if (sev_es_is_debug_swap_enabled()) {
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
index 60c7c880266b..6c54a3c9d442 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1190,7 +1190,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	set_exception_intercept(svm, UD_VECTOR);
 	set_exception_intercept(svm, MC_VECTOR);
 	set_exception_intercept(svm, AC_VECTOR);
-	set_exception_intercept(svm, DB_VECTOR);
+	if (!sev_es_is_debug_swap_enabled())
+		set_exception_intercept(svm, DB_VECTOR);
 	/*
 	 * Guest access to VMware backdoor ports could legitimately
 	 * trigger #GP because of TSS I/O permission bitmap.
-- 
2.38.1

