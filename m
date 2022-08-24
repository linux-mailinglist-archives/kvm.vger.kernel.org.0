Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9359F1CA
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiHXDE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbiHXDD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF55182879
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i1-20020a170902cf0100b001730caeec78so1378755plg.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+039iA4uWieDM1FoLlPM6gGPOhmWdSRIBEBxFzIaqfA=;
        b=LnzKgh+fsmxyVqCeFtW/+HpdFOSpDyvvsBz6eFinrVPd+Z5MIQXyyPsK2sPkwk/MDo
         dlPDm/08hiebHK1ZDnS8rQzDdzlv3I6YWxitbGYobhcFCbS2ZNsMSmgnn9QaWIydM2LZ
         QQQu4zy7T7mB4U8M4UBUfeYDME70n79iwEq1fOO6PhSHsUbclzXXGX+B4yoTLZJQVUlM
         3iIkNBowYBsWMqYMHV0R9ZjlyPB9h2AEECTg3PcXVwckt6ocMq+NZDWd8045ihdcZtTF
         fBFsTe9LW1ugXT+SzOPxzMW+VRTfc9W9EVsQ+HVWeY9tzAyEYA1WqTTjQuYM60mue/X1
         rTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+039iA4uWieDM1FoLlPM6gGPOhmWdSRIBEBxFzIaqfA=;
        b=PMts5tbfBFwj0NxgE1pZ11fdTWOqSnY2ljf1N/2zmJNis7ftxQf7Dg/NDHxykz1enb
         sngGZbg87UcLc9CKHySXDKFYvmNfCe3s/GsItSDLCh1rY41i4KTPf/KxjZF7fZNryo+O
         m5pn0M40PaPWQQEz4mfxdsFYEa605nlyBSY6npuC0OV/XtvJOFo2Xfw3NBZOO499gocH
         NlL6KUJAQhpk1PNZmdlmE7MOpFR1jU1llrVD/GDz0DwY2lr/5QIx2PUDRmgy1kGvJfal
         DwAFDqZSyOFmsiUJ2fomRp0m3NkIOhvJXJUdOMuC4MX0kmL3JnqXQl1ubw9HnFqFom92
         2oNg==
X-Gm-Message-State: ACgBeo0zx63v0i5SnWiH415xUG758nHT0JTQmsvAfmrclZHAttE+7z/p
        L1E0xUQf/lKfdq6vz/8yLzbDcO4QM2Q=
X-Google-Smtp-Source: AA6agR5+3OvYG6JIMucrfThyae4pNwfvuwvFg/fyWHlfTaWXysQFk36qKaQ1m+4DXu5BoLAmecTxe07oK/4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1b48:b0:1f4:f4e5:c189 with SMTP id
 nv8-20020a17090b1b4800b001f4f4e5c189mr5925193pjb.226.1661310154093; Tue, 23
 Aug 2022 20:02:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:34 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-33-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 32/36] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata
 handling out of setup_vmcs_config()
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

As a preparation to reusing the result of setup_vmcs_config() for setting
up nested VMX control MSRs, move LOAD_IA32_PERF_GLOBAL_CTRL errata handling
to vmx_vmexit_ctrl()/vmx_vmentry_ctrl() and print the warning from
hardware_setup(). While it seems reasonable to not expose
LOAD_IA32_PERF_GLOBAL_CTRL controls to L1 hypervisor on buggy CPUs,
such change would inevitably break live migration from older KVMs
where the controls are exposed. Keep the status quo for now, L1 hypervisor
itself is supposed to take care of the errata.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 59 +++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f6d8a008183..6d346edf546b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2489,6 +2489,30 @@ static bool cpu_has_sgx(void)
 	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }
 
+/*
+ * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
+ * can't be used due to errata where VM Exit may incorrectly clear
+ * IA32_PERF_GLOBAL_CTRL[34:32]. Work around the errata by using the
+ * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
+ */
+static bool cpu_has_perf_global_ctrl_bug(void)
+{
+	if (boot_cpu_data.x86 == 0x6) {
+		switch (boot_cpu_data.x86_model) {
+		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
+		case INTEL_FAM6_NEHALEM:	/* AAP115 */
+		case INTEL_FAM6_WESTMERE:	/* AAT100 */
+		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
+			return true;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 				      u32 msr, u32 *result)
 {
@@ -2644,30 +2668,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	/*
-	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
-	 * can't be used due to an errata where VM Exit may incorrectly clear
-	 * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
-	 * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
-	 */
-	if (boot_cpu_data.x86 == 0x6) {
-		switch (boot_cpu_data.x86_model) {
-		case INTEL_FAM6_NEHALEM_EP:	/* AAK155 */
-		case INTEL_FAM6_NEHALEM:	/* AAP115 */
-		case INTEL_FAM6_WESTMERE:	/* AAT100 */
-		case INTEL_FAM6_WESTMERE_EP:	/* BC86,AAY89,BD102 */
-		case INTEL_FAM6_NEHALEM_EX:	/* BA97 */
-			_vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-			_vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-			pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
-					"does not work properly. Using workaround\n");
-			break;
-		default:
-			break;
-		}
-	}
-
-
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
@@ -4263,6 +4263,9 @@ static u32 vmx_vmentry_ctrl(void)
 			  VM_ENTRY_LOAD_IA32_EFER |
 			  VM_ENTRY_IA32E_MODE);
 
+	if (cpu_has_perf_global_ctrl_bug())
+		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+
 	return vmentry_ctrl;
 }
 
@@ -4280,6 +4283,10 @@ static u32 vmx_vmexit_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
+
+	if (cpu_has_perf_global_ctrl_bug())
+		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
 	return vmexit_ctrl &
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
@@ -8186,6 +8193,10 @@ static __init int hardware_setup(void)
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
 
+	if (cpu_has_perf_global_ctrl_bug())
+		pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
+			     "does not work properly. Using workaround\n");
+
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
-- 
2.37.1.595.g718a3a8f04-goog

