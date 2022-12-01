Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23B63FBF9
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiLAX1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiLAX1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:20 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E31CC659
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:12 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id z4-20020a17090ab10400b002195a146546so7551874pjq.9
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=N1MKEpLC40vm6+kyhw5xs+CtLNykGWLPO1eTQOZjc3U=;
        b=GfJDQ/9peKOon7QfuMScKrcJcuXlJoBRDCKCmFSBO1trRWmCwApGQXz1DxOCbQtu/3
         Bml2/OASO5LhkfH24P9S8CMso0T48H5ERZZCMnquEISh/5N3YCdSWvIN9vogM77nu7do
         1JiFutI9smzRoiX2Xmgn8/FR9FqytQcFoa/ftWaCHX1gXByWXi2MzGFXM5RyGSruj+T4
         zpgHhHN+Xr11wpdmxgPwOHkiHSthxQgIuQpf7KAJ1ILeB4m9S2+cGoXynZ0m0yw8Ugbz
         GVODLTY87cfYie73+3wRWKa1xc0gqkv/xEeLPQBM1DXCuvlAN9k1+NWZLJ456sdiHbXw
         Uh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N1MKEpLC40vm6+kyhw5xs+CtLNykGWLPO1eTQOZjc3U=;
        b=6peZITb69VtY668urQ8Rf9I3lvOx7OJOVvJi/QE0irndR+cPzsgV4vA4Ohubu/pplh
         QH/Gub/nsP3H0bJ6w48102T87zQgBoJrjkLopnaKslAw5y3M+OCbUzOqAWpSakGkggDg
         TiDhy6upXPvVbz1a3dKZMtAWyWs4/QjwYVtkzNFNLUe2kGcnc03A59RnkQy0FT/RR0+x
         6BewPboP88ZmxW1mitV0UuykbwzmfZTzijaK2qVjHj74i01Y9fLJL9oanoZKIrIFw3JC
         4tduI6ZjIVMd8miCw+BFUinS6GmsVI34lfF3KdmMTRDxSzUI2EdbWCtlRB8Pcq0Yw3Fh
         TjcQ==
X-Gm-Message-State: ANoB5plTF9gM8ra61FD73aAiOVr4sY70cYWTmbOQTMterWKstm4vfQD5
        pAElrsn5LRZMxn29VxU3kh6KsmUsoPk=
X-Google-Smtp-Source: AA0mqf728o14x2qPtbsV/svyt/B0IMOGeXVA6OC8OQvU7e9OrEVnZ5ZliFnbfztRETZFFS+A8vGyIpBzzc0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a601:b0:189:8001:b54f with SMTP id
 u1-20020a170902a60100b001898001b54fmr25838795plq.37.1669937232408; Thu, 01
 Dec 2022 15:27:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:45 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-7-seanjc@google.com>
Subject: [PATCH 06/16] x86/reboot: KVM: Disable SVM during reboot via virt/KVM
 reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>
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

Use the virt callback to disable SVM (and set GIF=1) during an emergency
instead of blindly attempting to disable SVM.  Like the VMX case, if KVM
(or an out-of-tree hypervisor) isn't loaded/active, SVM can't be in use.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h  |  2 +-
 arch/x86/include/asm/virtext.h |  8 --------
 arch/x86/kernel/reboot.c       |  6 ++----
 arch/x86/kvm/svm/svm.c         | 19 +++++++++++++++++--
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 1d098a7d329a..dc2b77e6704b 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,7 +25,7 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 typedef void (cpu_emergency_virt_cb)(void);
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 4f61283b1f52..97349410c937 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -130,12 +130,4 @@ static inline void cpu_svm_disable(void)
 	}
 }
 
-/** Makes sure SVM is disabled, if it is supported on the CPU
- */
-static inline void cpu_emergency_svm_disable(void)
-{
-	if (cpu_has_svm(NULL))
-		cpu_svm_disable();
-}
-
 #endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 85ea1fdebf4c..3eec3cdbc054 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -787,7 +787,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 /* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
@@ -823,7 +823,7 @@ void cpu_emergency_disable_virtualization(void)
 {
 	lockdep_assert_irqs_disabled();
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
 	cpu_emergency_virt_cb *callback;
 
 	rcu_read_lock();
@@ -832,8 +832,6 @@ void cpu_emergency_disable_virtualization(void)
 		callback();
 	rcu_read_unlock();
 #endif
-	/* KVM_AMD doesn't yet utilize the common callback. */
-	cpu_emergency_svm_disable();
 }
 
 #if defined(CONFIG_SMP)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 46b658d0f46e..d56d5fe42262 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -38,6 +38,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/reboot.h>
 #include <asm/fpu/api.h>
 
 #include <asm/virtext.h>
@@ -565,6 +566,11 @@ void __svm_write_tsc_multiplier(u64 multiplier)
 	preempt_enable();
 }
 
+static void svm_emergency_disable(void)
+{
+	cpu_svm_disable();
+}
+
 static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
@@ -5084,6 +5090,13 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.pmu_ops = &amd_pmu_ops,
 };
 
+static void __svm_exit(void)
+{
+	kvm_x86_vendor_exit();
+
+	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
+}
+
 static int __init svm_init(void)
 {
 	int r;
@@ -5097,6 +5110,8 @@ static int __init svm_init(void)
 	if (r)
 		return r;
 
+	cpu_emergency_register_virt_callback(svm_emergency_disable);
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -5109,14 +5124,14 @@ static int __init svm_init(void)
 	return 0;
 
 err_kvm_init:
-	kvm_x86_vendor_exit();
+	__svm_exit();
 	return r;
 }
 
 static void __exit svm_exit(void)
 {
 	kvm_exit();
-	kvm_x86_vendor_exit();
+	__svm_exit();
 }
 
 module_init(svm_init)
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

