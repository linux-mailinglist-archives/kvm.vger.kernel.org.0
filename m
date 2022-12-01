Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281C863FBF1
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiLAX1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiLAX1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:08 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E24C9374
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:07 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id s15-20020a170902ea0f00b0018970bb67bfso4043527plg.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vAEGWmnkIaZN34ogUmGjDhJYcwm+21Yr0Q/GOJt7SsE=;
        b=e10rLrq5H4tRsG7RSONr1Pd3P75SakXaOIfcayuGuSZ6bvGnGfPv/7fvWzv/vMg+7c
         AivT7YnVzAxUudzOW+CmUZCcaBSrPbcyDHmhrV+SMv3LlngXPKcYiarG+ekynwhyY9Dp
         avGLrSmjQfqAxmGMc2Usq0sUX8wgLB003WCKE/5Edl/j7mNlxhS9grYZzODJFZsoFLlr
         UXNj9KhRfaMjg4zXHoVINjeHRdawsSdC8e/TIg0gFqd+Yje5ApPbCMSOm/5fW7kt9bvd
         iXVsbzaWdwaxGNxOOYvkFR2vjx3Vcq/e0jas8nkQaNbq3TV7KhUnhD7xfP7Qei8Vd+6M
         jvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAEGWmnkIaZN34ogUmGjDhJYcwm+21Yr0Q/GOJt7SsE=;
        b=SdQOA2YC37dyzAJjrtxYyDLhr1FzfNAVy5z8a/DsnAnBnD1bxaK97baks241jsM05M
         Js0AN9v9X8GK/uN+ACCYPRX2/W8u+KI1nJFGm5ZdQOllGkdhOOSQOXe5V8kCb7Dhmf7+
         HCw+xF1IAjrxkm5m9MlgIU637g0tecUrKdz6yE3uf9rFwjJBQ+dx723V2kgmPMdkL0SQ
         ZsC6Zj/+NVJSdmiuPHj5KsmDYXUtJ+XuWWd3y9QAz9cHr4C4pcALkgm4aiR3Ox5F+PPR
         3mckaVWDugHJKosbgnThxdyxQ1I/+E2OY/HMW5gv/DOAtWHnl/HQldW4MwyEZDPe30nG
         YDvg==
X-Gm-Message-State: ANoB5plH6Mm1qS5sx4QrGrxE29lHw1v2RwhJZw+DNpv4/+8bG24UfhzI
        RZoj/cwLb1BNEgGu7aypQxPvB0g74hQ=
X-Google-Smtp-Source: AA0mqf7DRwRAd3vNXDO1D/ZnrZUXZ2HH/PzmnJlXmMkLPxnQWY9lwrVg93IMK+sm/0rU7+321MVzITapx8s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:43a4:b0:219:1d0a:34a6 with SMTP id
 r33-20020a17090a43a400b002191d0a34a6mr3023592pjg.1.1669937227185; Thu, 01 Dec
 2022 15:27:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:42 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-4-seanjc@google.com>
Subject: [PATCH 03/16] x86/reboot: Harden virtualization hooks for emergency reboot
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide dedicated helpers to (un)register virt hooks used during an
emergency crash/reboot, and WARN if there is an attempt to overwrite
the registered callback, or an attempt to do an unpaired unregister.

Opportunsitically use rcu_assign_pointer() instead of RCU_INIT_POINTER(),
mainly so that the set/unset paths are more symmetrical, but also because
any performance gains from using RCU_INIT_POINTER() are meaningless for
this code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h |  5 +++--
 arch/x86/kernel/reboot.c      | 30 ++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c        |  6 ++----
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 33c8e911e0de..1d098a7d329a 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -26,8 +26,9 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_APM		1
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-typedef void crash_vmclear_fn(void);
-extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
+typedef void (cpu_emergency_virt_cb)(void);
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 #endif
 void cpu_emergency_disable_virtualization(void);
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 6c0b1634b884..78182b2969db 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -795,17 +795,35 @@ void machine_crash_shutdown(struct pt_regs *regs)
  *
  * protected by rcu.
  */
-crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
-EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
+static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
+
+void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
+
+void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
+		return;
+
+	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
 static inline void cpu_crash_vmclear_loaded_vmcss(void)
 {
-	crash_vmclear_fn *do_vmclear_operation = NULL;
+	cpu_emergency_virt_cb *callback;
 
 	rcu_read_lock();
-	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
-	if (do_vmclear_operation)
-		do_vmclear_operation();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
 	rcu_read_unlock();
 }
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ea020456dd0..6e0cc4d03884 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8526,8 +8526,7 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
+	cpu_emergency_unregister_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_cleanup_l1d_flush();
 }
@@ -8577,8 +8576,7 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
-			   crash_vmclear_local_loaded_vmcss);
+	cpu_emergency_register_virt_callback(crash_vmclear_local_loaded_vmcss);
 
 	vmx_check_vmcs12_offsets();
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

