Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0C66238D5
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiKJBaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiKJBaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:30:09 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0197D18E19
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:30:08 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-377a1db4307so3079797b3.1
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8CUr/OIWb5uA6RYsOSzZ05CCdXKaCyDdB9TR+zmvZr8=;
        b=IY4Hnp9nEnEWHOuWMXN4OSnd8wrZeOFxLo/VhaYoC1w456+3TkOHkZQi3KGTexqOlH
         Wlza3rSXhvcTGaSu1ke2JOG5He/C2la4fpKvU6a4r96II3nfgG8NFyq2bZfez24vcwR5
         MMp4mv+xBL9FqzPVI6wZ/8zhspUXr+L0ZJcZAzk4dLDngAXinRZVhqexSTvf6IQ1P2sI
         C/JkLgKbxt7DhD6m0DRwPI+sPWJw3aQSpGn+589BQKLSa5hsWVsV80XRTSpUp7NzTaAX
         wkq3uOupa/TaJCuoKTr0ROikLx1i3bOUErGnsde6DLbIYqIYyVIJDNxTCcxhzDNO17+7
         bvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8CUr/OIWb5uA6RYsOSzZ05CCdXKaCyDdB9TR+zmvZr8=;
        b=zHQQvZTbxi6SANmsFDf1il20CDEYNXJdsWdo2KyGBrbRLQa52hMJCQXBX1VKC92WL7
         3eAcsMJga/l9g0rPyFsOORvaNRbhtJ+Q0ycJUc3WEjiRkK+rSjifrAOaXZQEjGxojXlu
         Kq2L8rX48RPQNGFbFNKXGRoDdWCsz7vxPSHhfyBwX9Ai1+6jCGb7An31U2XYLtAPvRil
         97kdXWoJnMaO4Uea0pzx0c2nu9ebkPQiBV2BH1q8lkNw+XAbNxApfIolK+KyxkugaQ5W
         esjFNhPionTw5Nil2ggiPkLdELwaPmVRHYiLVRBv8b/9AQyPkYhi97JPwBGSDgqAbh/d
         P0pA==
X-Gm-Message-State: ACrzQf363qD5njZ5UHoxeUgpsicjsivZ5Y29YYPmLqASXcidOT48Spk6
        28oTFDENJ7jnJUm++wD3ZTzLRK3yvik=
X-Google-Smtp-Source: AMsMyM6jb/pITCkYixYj1HZxDQpuTw6dK3pw9pKLmZamSyRBQqZOoSosj2O0g4F3+/IdFXLrxjUH5BFJR3w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2455:0:b0:6d0:465:e186 with SMTP id
 k82-20020a252455000000b006d00465e186mr1047003ybk.278.1668043807310; Wed, 09
 Nov 2022 17:30:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 01:30:01 +0000
In-Reply-To: <20221110013003.1421895-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221110013003.1421895-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110013003.1421895-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: VMX: Make module params and other variables
 read-only after init
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag VMX's module params and global variables that are configured under
the vmx_init() umbrella as read-only after init.  The global knobs should
never change once KVM is fully loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 16 +++++++--------
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/vmx/sgx.c          |  2 +-
 arch/x86/kvm/vmx/sgx.h          |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 36 ++++++++++++++++-----------------
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cd2ac9536c99..1339634ead07 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -9,14 +9,14 @@
 #include "../pmu.h"
 #include "../cpuid.h"
 
-extern bool __read_mostly enable_vpid;
-extern bool __read_mostly flexpriority_enabled;
-extern bool __read_mostly enable_ept;
-extern bool __read_mostly enable_unrestricted_guest;
-extern bool __read_mostly enable_ept_ad_bits;
-extern bool __read_mostly enable_pml;
-extern bool __read_mostly enable_ipiv;
-extern int __read_mostly pt_mode;
+extern bool __ro_after_init enable_vpid;
+extern bool __ro_after_init flexpriority_enabled;
+extern bool __ro_after_init enable_ept;
+extern bool __ro_after_init enable_unrestricted_guest;
+extern bool __ro_after_init enable_ept_ad_bits;
+extern bool __ro_after_init enable_pml;
+extern bool __ro_after_init enable_ipiv;
+extern int __ro_after_init pt_mode;
 
 #define PT_MODE_SYSTEM		0
 #define PT_MODE_HOST_GUEST	1
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61a2e551640a..bae81a50cbd7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -18,10 +18,10 @@
 #include "x86.h"
 #include "smm.h"
 
-static bool __read_mostly enable_shadow_vmcs = 1;
+static bool __ro_after_init enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
 
-static bool __read_mostly nested_early_check = 0;
+static bool __ro_after_init nested_early_check;
 module_param(nested_early_check, bool, S_IRUGO);
 
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 8f95c7c01433..ca66e6ce7e5d 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -10,7 +10,7 @@
 #include "vmx.h"
 #include "x86.h"
 
-bool __read_mostly enable_sgx = 1;
+bool __ro_after_init enable_sgx = 1;
 module_param_named(sgx, enable_sgx, bool, 0444);
 
 /* Initial value of guest's virtual SGX_LEPUBKEYHASHn MSRs */
diff --git a/arch/x86/kvm/vmx/sgx.h b/arch/x86/kvm/vmx/sgx.h
index a400888b376d..1e7fb11eabcf 100644
--- a/arch/x86/kvm/vmx/sgx.h
+++ b/arch/x86/kvm/vmx/sgx.h
@@ -8,7 +8,7 @@
 #include "vmx_ops.h"
 
 #ifdef CONFIG_X86_SGX_KVM
-extern bool __read_mostly enable_sgx;
+extern bool __ro_after_init enable_sgx;
 
 int handle_encls(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aca88524fd1e..c36d29416d52 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -79,34 +79,34 @@ static const struct x86_cpu_id vmx_cpu_id[] = {
 MODULE_DEVICE_TABLE(x86cpu, vmx_cpu_id);
 #endif
 
-bool __read_mostly enable_vpid = 1;
+bool __ro_after_init enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
-static bool __read_mostly enable_vnmi = 1;
+static bool __ro_after_init enable_vnmi = 1;
 module_param_named(vnmi, enable_vnmi, bool, S_IRUGO);
 
-bool __read_mostly flexpriority_enabled = 1;
+bool __ro_after_init flexpriority_enabled = 1;
 module_param_named(flexpriority, flexpriority_enabled, bool, S_IRUGO);
 
-bool __read_mostly enable_ept = 1;
+bool __ro_after_init enable_ept = 1;
 module_param_named(ept, enable_ept, bool, S_IRUGO);
 
-bool __read_mostly enable_unrestricted_guest = 1;
+bool __ro_after_init enable_unrestricted_guest = 1;
 module_param_named(unrestricted_guest,
 			enable_unrestricted_guest, bool, S_IRUGO);
 
-bool __read_mostly enable_ept_ad_bits = 1;
+bool __ro_after_init enable_ept_ad_bits = 1;
 module_param_named(eptad, enable_ept_ad_bits, bool, S_IRUGO);
 
-static bool __read_mostly emulate_invalid_guest_state = true;
+static bool __ro_after_init emulate_invalid_guest_state = true;
 module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 
-static bool __read_mostly fasteoi = 1;
+static bool __ro_after_init fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
 module_param(enable_apicv, bool, S_IRUGO);
 
-bool __read_mostly enable_ipiv = true;
+bool __ro_after_init enable_ipiv = true;
 module_param(enable_ipiv, bool, 0444);
 
 /*
@@ -114,13 +114,13 @@ module_param(enable_ipiv, bool, 0444);
  * VMX and be a hypervisor for its own guests. If nested=0, guests may not
  * use VMX instructions.
  */
-static bool __read_mostly nested = 1;
+static bool __ro_after_init nested = 1;
 module_param(nested, bool, S_IRUGO);
 
-bool __read_mostly enable_pml = 1;
+bool __ro_after_init enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
-static bool __read_mostly error_on_inconsistent_vmcs_config = true;
+static bool __ro_after_init error_on_inconsistent_vmcs_config = true;
 module_param(error_on_inconsistent_vmcs_config, bool, 0444);
 
 static bool __read_mostly dump_invalid_vmcs = 0;
@@ -132,8 +132,8 @@ module_param(dump_invalid_vmcs, bool, 0644);
 #define KVM_VMX_TSC_MULTIPLIER_MAX     0xffffffffffffffffULL
 
 /* Guest_tsc -> host_tsc conversion requires 64-bit division.  */
-static int __read_mostly cpu_preemption_timer_multi;
-static bool __read_mostly enable_preemption_timer = 1;
+static int __ro_after_init cpu_preemption_timer_multi;
+static bool __ro_after_init enable_preemption_timer = 1;
 #ifdef CONFIG_X86_64
 module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 #endif
@@ -211,7 +211,7 @@ static unsigned int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
 module_param(ple_window_max, uint, 0444);
 
 /* Default is SYSTEM mode, 1 for host-guest mode */
-int __read_mostly pt_mode = PT_MODE_SYSTEM;
+int __ro_after_init pt_mode = PT_MODE_SYSTEM;
 module_param(pt_mode, int, S_IRUGO);
 
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
@@ -237,7 +237,7 @@ static const struct {
 static void *vmx_l1d_flush_pages;
 
 /* Control for disabling CPU Fill buffer clear */
-static bool __read_mostly vmx_fb_clear_ctrl_available;
+static bool __ro_after_init vmx_fb_clear_ctrl_available;
 
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
@@ -370,7 +370,7 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 	return sprintf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
 }
 
-static void vmx_setup_fb_clear_ctrl(void)
+__init static void vmx_setup_fb_clear_ctrl(void)
 {
 	u64 msr;
 
@@ -524,7 +524,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 static unsigned long host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-static bool __read_mostly enlightened_vmcs = true;
+static bool __ro_after_init enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
 static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
-- 
2.38.1.431.g37b22c650d-goog

