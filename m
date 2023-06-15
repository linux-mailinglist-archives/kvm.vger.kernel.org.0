Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAF9730F9C
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244268AbjFOGqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243555AbjFOGp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:45:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D8930CD;
        Wed, 14 Jun 2023 23:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoI+Z0/iK2FIjpLYvNxANBzHJn995WG2sLX4koBvlOGwt/hq6gpmp++xBL5+IVJB14VybK/q6t9g+t02nF5wKiAqIEDADi7TqXqc5KGumMCIsWwt1oWlxXjW+1K4ZvUF7guzg+tpKn+u0zRLDnbYvDZVakG+1ZUw+oz3NP7VCzEub83aPCGnqJmp3ql82ro0af/HuohIaF+0ABXNkgJ18bEaC3NRY5Q9Vc3rtfbt65Eze7ToHDVIbF1PlwRSimXYAIwUb6DmPrnm1e8hlPZ971fjMmyrLbMQyg8DtOUGbqQpIN8+ZkE9iTs9soCWTkV3u1WHSm9CSMeWcwKOHmqNLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOZnwyxQnsUUihmQQx5SEExZpjGh6KXDxM9kVsGQj5w=;
 b=bZW8eedVFjArZ/LADLs4gwmz9EaTodgjMLd6F1jYH84zGb2oC5a61jj1si216N9ELNscbUtUuhoWixZM7GzP7ygDYhgK5w9p3DgeJQZn6ANiLeWDt05e9UVv7isPdux01fENTURQWMOb9/BA0uZMM2oAG8dh+AYiy9vb4LH1w6NJ16T1QFd0dlcnt6/SuJ6zMUtk1QQfF7paa1a+9CflGXbU10frtyaGNTv4/GE9pujYybrB2b7PI8VNkh/ggE+Le8tkOA8K6mjRsCCJwKsGdPb8/L894+rMtPnOPOeaGNpwiCeUNvNwDyei7zo7AIV3rLRp/h8nXIkoVQyP8EQ18g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOZnwyxQnsUUihmQQx5SEExZpjGh6KXDxM9kVsGQj5w=;
 b=k6MYd6GIxPAuEHiYMXdP7N7sTQB921umWKjDKu3M8jVOAmtfQ1JAYY3LUV91pmd5ctXF6wXNdlDqLX1WPpNrfXviXRePJHL6RAKlcw/lAnVC0+78TWH7+4ui6sjgA+9QD9AKCG5nFf3ACTQb5n2VYqeARi7SkTxaiqmSPdYH8fM=
Received: from SA1PR05CA0004.namprd05.prod.outlook.com (2603:10b6:806:2d2::29)
 by SN7PR12MB6766.namprd12.prod.outlook.com (2603:10b6:806:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 06:43:36 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:806:2d2:cafe::59) by SA1PR05CA0004.outlook.office365.com
 (2603:10b6:806:2d2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.11 via Frontend
 Transport; Thu, 15 Jun 2023 06:43:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:43:36 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:43:31 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 6/9] KVM: SEV: Enable data breakpoints in SEV-ES
Date:   Thu, 15 Jun 2023 16:37:54 +1000
Message-ID: <20230615063757.3039121-7-aik@amd.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|SN7PR12MB6766:EE_
X-MS-Office365-Filtering-Correlation-Id: e961c737-f0b2-4939-487f-08db6d6bd8be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6LwQ+ocgYokurMVbdz9zlG+suhRaYe9L2jqff9tvwy1mLi4BlomXr+5v0GREOkrvmoR20+CAsQF+RrqjnNLFSmfVNt/FpSVLmZkHZZecQfyWwq4ZJ7PKg+rAvnq8b45f9kLgIJ9D68vdTRepq6YL7O793K0ROfKKCCTxB8ZS9f91brvOpZeQTepLeTKoJfASLjvhfQALXD8blBDfelvGP4yYCReSCgjV6sG7Ljzj5cdA9eMxX8zRdBQ8PIV0YMMkSNm9qlyP2nVqIzBXpvtxTmJ+jPZoK0opfXYZFyc9yWD5UTb6TMBXvzopI3d8qR9+62hwNCT7KqyaGnpm7jtf0pF4gi2HePCm5ITTBfBukT6+wCILYSi6VQ5IPZdkGgKGhtHH77FLYqiZrjq0OwWnkx2+B0E9ClWWKRa0NhZAUxaM8tb9RNAOLMtdLbnaLK8kF6ZEjrBOKaXSR3Ul95zPiTR6DijYAnEvpph7GhI+NGUHehn1k3SNAlofa9k7I94oHvcSocDiw5LaUBmrSd030zgTCy46h+YSSEP336n+boqtFMrLEuAhslHsqvrYNJrgVMybS2K6v/O/qwOzjOSE0RaUWcPt10UbkHYCwouJVCz39ul/BFRSZgGfTtidewAO51A2K9/WSljtoB1TXYJ/iMCmE4YhdNCuUltifb89ymmYWmaEAyWjvukk2NJyl+n7jLtKndIGv5/lZQecV4O9PJ/G5GaJNDBtyxyhejZ3g3E7jBQrQV4xFNFsEh1x3Al2sCKSvALzdLnAOdHRyWA0Cg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(8676002)(8936002)(2906002)(82310400005)(5660300002)(356005)(70586007)(70206006)(316002)(4326008)(6916009)(81166007)(41300700001)(36860700001)(83380400001)(47076005)(426003)(54906003)(336012)(82740400003)(2616005)(36756003)(478600001)(16526019)(1076003)(26005)(186003)(40480700001)(6666004)(40460700003)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:43:36.7709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e961c737-f0b2-4939-487f-08db6d6bd8be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6766
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for "DebugSwap for SEV-ES guests", which provides support
for swapping DR[0-3] and DR[0-3]_ADDR_MASK on VMRUN and VMEXIT, i.e.
allows KVM to expose debug capabilities to SEV-ES guests. Without
DebugSwap support, the CPU doesn't save/load most _guest_ debug
registers (except DR6/7), and KVM cannot manually context switch guest
DRs due the VMSA being encrypted.

Enable DebugSwap if and only if the CPU also supports NoNestedDataBp,
which causes the CPU to ignore nested #DBs, i.e. #DBs that occur when
vectoring a #DB.  Without NoNestedDataBp, a malicious guest can DoS
the host by putting the CPU into an infinite loop of vectoring #DBs
(see https://bugzilla.redhat.com/show_bug.cgi?id=1278496)

Set the features bit in sev_es_sync_vmsa() which is the last point
when VMSA is not encrypted yet as sev_(es_)init_vmcb() (where the most
init happens) is called not only when VCPU is initialised but also on
intrahost migration when VMSA is encrypted.

Eliminate DR7 intercepts as KVM can't modify guest DR7, and intercepting
DR7 would completely defeat the purpose of enabling DebugSwap.

Make X86_FEATURE_DEBUG_SWAP appear in /proc/cpuinfo (by not adding "") to
let the operator know if the VM can debug.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v6:
* rewrote the commit log as suggested by Sean
* clr_exception_intercept(#DB) moved to a separate patch (next to this)
* updated tools/arch/x86/include/asm/cpufeatures.h

(old versions from when this was a single patch, ignore?)
v9:
* changed the commit log to one from Sean
* moved #DB intercept handling later in the series

v5:
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
 arch/x86/include/asm/cpufeatures.h       |  1 +
 arch/x86/include/asm/svm.h               |  1 +
 tools/arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/svm/sev.c                   | 37 ++++++++++++++++++--
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index cb8ca46213be..31c862d79fae 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -434,6 +434,7 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
+#define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e7c7379d6ac7..72ebd5e4e975 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -288,6 +288,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
+#define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index cb8ca46213be..31c862d79fae 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -434,6 +434,7 @@
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* AMD Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* "" Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* "" AMD hardware-enforced cache coherency */
+#define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* AMD SEV-ES full debug state swap support */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 744bcc2e6a05..abc502ce7871 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -23,6 +23,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -54,9 +55,14 @@ module_param_named(sev, sev_enabled, bool, 0444);
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
@@ -606,6 +612,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	if (sev_es_debug_swap_enabled)
+		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -2258,6 +2267,9 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
+	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
+		sev_es_debug_swap_enabled = false;
 #endif
 }
 
@@ -2978,14 +2990,17 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	svm_set_intercept(svm, TRAP_CR8_WRITE);
 
 	/*
+	 * Unless DebugSwap (depends on X86_FEATURE_NO_NESTED_DATA_BP) is enabled,
 	 * DR7 access must remain intercepted for an SEV-ES guest to disallow
 	 * the guest kernel set up a #DB on memory that's needed to vector a #DB
 	 * as otherwise the CPU gets stuck in an infinite #DB loop.
 	 */
 	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-	recalc_intercepts(svm);
+	if (!sev_es_debug_swap_enabled) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+		recalc_intercepts(svm);
+	}
 
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
@@ -3055,6 +3070,22 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 	hostsa->pkru = read_pkru();
 	hostsa->xss = host_xss;
+
+	/*
+	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
+	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
+	 * saves and loads debug registers (Type-A).
+	 */
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
2.40.1

