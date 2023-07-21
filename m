Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DC875D57B
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjGUUT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjGUUTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:19 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1064C35B8
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:11 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b9de3e7fb1so13819965ad.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970750; x=1690575550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IIqhdp8WqL0kWTvtPZo4YKSDQAXM01F7uHc3z46B11M=;
        b=N6+HAnOlKDhLqVNY9edBHUTpkSa+XY7oBMtLhV0W+2bPtkJJTDUxW1hvkMsrnQHj98
         oiQUl+6svRNCcwf0uFTQJMji4LvzrNr2XGACfpM6JfC8YBqlliASriW/eTzwiz4Cj+qw
         Q7/LFi0tCAvBmJlOSW1stt1jDJo1Q/5KJupzQaFRZ4qAZtYc4HevNfBNLG3CVgQQlkBK
         bL97aMTEWyf0Y5VvSMMlEKaugqItpB+/9EF1SUMbEX1j6K5nBib+wPVofkxxhooK+5V1
         rq7l+I5yiOcLjTL43F7br+tt0K4eb8nGYIQxsVTwHV54sBhWTWHF8rKe2hB8x2y2ZwjI
         A0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970750; x=1690575550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IIqhdp8WqL0kWTvtPZo4YKSDQAXM01F7uHc3z46B11M=;
        b=UcUUGvtA/mVbMYKpWMXRCoW4UA+ZL/u7kFt5f7KpoJwOYWfuSKvqSKgPGNuwkBelSO
         IpemQAMCLH68oSHX4hfdl9q634EiyiGIhsxDWGCJEqVpRk/YR5PnI7Y9RLVVhd/nLc/L
         9ZWtqqL9d7AoMH/d9Ow/7HDXwba8dmonypEA6Pgpv2Np3LeRU3C885HBbH5gXuX0YXM4
         0Dp+n0xrXuFXex3UGwSEIdqnS5a3TcGunZUtBUTJ/zkkHhVwysyFG8JCIqGGXQiEnnzM
         IdDfktHkoJg9paPRPJaQ27QqlIJydiCxI0geFmTFR3HB85bzVJDi00cOeobBHCozbNVr
         8Rfw==
X-Gm-Message-State: ABy/qLaUVcYXdYI4d3NBeJ4rdbx5Kci1hRlEjzM+P5rd4SwsT8uz6pBP
        0OPrbXrsY7SFlKJW9SxFOV2pEDFeK70=
X-Google-Smtp-Source: APBJJlE/7vXHTCq9jJ6EV6q2DuyaSpyg4++NHPOMxgndH9mm+1zOSzr4NdqmL9LH5P57nPMWJEhYoKBpUWY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2291:b0:1b8:866f:6fc1 with SMTP id
 b17-20020a170903229100b001b8866f6fc1mr11914plh.0.1689970750480; Fri, 21 Jul
 2023 13:19:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:43 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-4-seanjc@google.com>
Subject: [PATCH v4 03/19] x86/reboot: KVM: Handle VMXOFF in KVM's reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use KVM VMX's reboot/crash callback to do VMXOFF in an emergency instead
of manually and blindly doing VMXOFF.  There's no need to attempt VMXOFF
if a hypervisor, i.e. KVM, isn't loaded/active, i.e. if the CPU can't
possibly be post-VMXON.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kernel/reboot.c       | 29 +++++++++--------------------
 arch/x86/kvm/vmx/vmx.c         |  8 +++++---
 3 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 3b12e6b99412..5bc29fab15da 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -70,16 +70,6 @@ static inline void __cpu_emergency_vmxoff(void)
 		cpu_vmxoff();
 }
 
-/** Disable VMX if it is supported and enabled on the current CPU
- */
-static inline void cpu_emergency_vmxoff(void)
-{
-	if (cpu_has_vmx())
-		__cpu_emergency_vmxoff();
-}
-
-
-
 
 /*
  * SVM functions:
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 62ccedeb5e2b..d2d0f2672a64 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -787,13 +787,7 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-/*
- * This is used to VMCLEAR all VMCSs loaded on the
- * processor. And when loading kvm_intel module, the
- * callback function pointer will be assigned.
- *
- * protected by rcu.
- */
+/* RCU-protected callback to disable virtualization prior to reboot. */
 static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
 
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
@@ -815,17 +809,6 @@ void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
 }
 EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
-static inline void cpu_crash_vmclear_loaded_vmcss(void)
-{
-	cpu_emergency_virt_cb *callback;
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-}
-
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
@@ -836,9 +819,15 @@ int crashing_cpu = -1;
  */
 void cpu_emergency_disable_virtualization(void)
 {
-	cpu_crash_vmclear_loaded_vmcss();
+	cpu_emergency_virt_cb *callback;
 
-	cpu_emergency_vmxoff();
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
+
+	/* KVM_AMD doesn't yet utilize the common callback. */
 	cpu_emergency_svm_disable();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 019cefc65142..682c20b33a96 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -744,7 +744,7 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-static void crash_vmclear_local_loaded_vmcss(void)
+static void vmx_emergency_disable(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
@@ -752,6 +752,8 @@ static void crash_vmclear_local_loaded_vmcss(void)
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
+
+	__cpu_emergency_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -8590,7 +8592,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8640,7 +8642,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(vmx_emergency_disable);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.41.0.487.g6d72f3e995-goog

