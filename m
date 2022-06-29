Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3DD56041B
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiF2PIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiF2PHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1121338AA
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tR9oU39KRQAoB6WE5ZpPR1z9CGB7uFUw7cvsARqGFBc=;
        b=OnhtvQ8m9mzyOLwX5bM04oIbTHuFfvV/+jJ6pmWssH9J9ZY6L4ayuH+UsDJgDv/BrbqxR1
        J7p2JwQ40HOwhLOhGIB6++ozITZ/8+PzH2/WtFidz5KnMoiFdB30UffXIiDFYXErlCD0GB
        2LtOteK4QrrtZActNNz44ELw1kan1f0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-1nAnAriMOyeDp7vepwGLog-1; Wed, 29 Jun 2022 11:07:25 -0400
X-MC-Unique: 1nAnAriMOyeDp7vepwGLog-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50F9A3C01D90;
        Wed, 29 Jun 2022 15:07:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AA4B40EC002;
        Wed, 29 Jun 2022 15:07:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 23/28] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()
Date:   Wed, 29 Jun 2022 17:06:20 +0200
Message-Id: <20220629150625.238286-24-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to reusing the result of setup_vmcs_config() for setting
up nested VMX control MSRs, move LOAD_IA32_PERF_GLOBAL_CTRL errata handling
to vmx_vmexit_ctrl()/vmx_vmentry_ctrl() and print the warning from
hardware_setup(). While it seems reasonable to not expose
LOAD_IA32_PERF_GLOBAL_CTRL controls to L1 hypervisor on buggy CPUs,
such change would inevitably break live migration from older KVMs
where the controls are exposed. Keep the status quo for know, L1 hypervisor
itself is supposed to take care of the errata.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 62 ++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fb58b0be953d..5f7ef1f8d2c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2416,6 +2416,31 @@ static bool cpu_has_sgx(void)
 	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }
 
+/*
+ * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
+ * can't be used due to an errata where VM Exit may incorrectly clear
+ * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
+ * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
+ */
+static bool cpu_has_perf_global_ctrl_bug(void)
+{
+	if (boot_cpu_data.x86 == 0x6) {
+		switch (boot_cpu_data.x86_model) {
+		case 26: /* AAK155 */
+		case 30: /* AAP115 */
+		case 37: /* AAT100 */
+		case 44: /* BC86,AAY89,BD102 */
+		case 46: /* BA97 */
+			return true;
+		default:
+			break;
+		}
+	}
+
+	return false;
+}
+
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 				      u32 msr, u32 *result)
 {
@@ -2572,30 +2597,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
-		case 26: /* AAK155 */
-		case 30: /* AAP115 */
-		case 37: /* AAT100 */
-		case 44: /* BC86,AAY89,BD102 */
-		case 46: /* BA97 */
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
@@ -4188,6 +4189,10 @@ static u32 vmx_vmentry_ctrl(void)
 			  VM_ENTRY_LOAD_IA32_EFER |
 			  VM_ENTRY_IA32E_MODE);
 
+
+	if (cpu_has_perf_global_ctrl_bug())
+		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+
 	return vmentry_ctrl;
 }
 
@@ -4202,6 +4207,10 @@ static u32 vmx_vmexit_ctrl(void)
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
@@ -8117,6 +8126,11 @@ static __init int hardware_setup(void)
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
 
+	if (cpu_has_perf_global_ctrl_bug()) {
+		pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
+			     "does not work properly. Using workaround\n");
+	}
+
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
-- 
2.35.3

