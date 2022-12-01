Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E017963FBFB
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiLAX1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiLAX10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:26 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77DFCC671
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:14 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x21-20020a62fb15000000b0057451601be4so3232706pfm.19
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PueUj9DN6y/B+t9EKbOQHEz5+gc+C1Dj1im/eZPScN4=;
        b=MS4rtQrmXPYim7WgQgTNM4fYna3dJdawLyxdI3gxmMYsAenENi/HoieSKBu4uCq4DY
         btGKvi4pzD+yD18bJlTr1pY+t7g7c1ZcDRdBWVFw0Ch5PmWQGP5l2BLkQx21HI+ugfze
         +HgPsEsOcYYQn2TTomEnrZSQL1LG+p1oNm58avOaTcv/nMMpWW8u44c8VlhNcp7hKpnv
         +1R2r7nqOOjK82AyKFm7xg6vbEeOYD4FEnU7AsGk7L65aC1LdgE+N6a8gBZYv1zrQiZ0
         ZT6aQxoincXgbjSvwlt9EuygYRjWnFdbD4gSsVajlwz9bNW2/XvbwVqQ3mb3kXY5jujb
         BRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PueUj9DN6y/B+t9EKbOQHEz5+gc+C1Dj1im/eZPScN4=;
        b=bx2EqTpMk/BZ4A94MrPVlRklMFYFXI+ZCjEd65972h5zbK4j16gdsg/3dnLmoxo1fO
         7NTM8/mz8XePzrTVMADVBA5cT7Ad4VGEsm2IUvAi2K3I6ovF0Du6XbK0mw3DbxqmBFtx
         Qr85cnPleBIqv7qFm8xvR+nd8mLO9Cwb5nPb576QVyQP1xu6x8FoeKBiaHMIgudHhtqX
         YvINgQlha7zhT/pHAorMjNUC5oPPQQ4tLrAG+Ko5OP3V2RLTZSIR7/PGLVLzWfyvq7Jm
         oaCS5s8DQUW01IvYfBTSh6u4KVxFKIvWuohQBGe5YsX2T5POe8vdokOrVFslwpyB7l8O
         gnxg==
X-Gm-Message-State: ANoB5pmaYDVvfLFxYuWagnHws70oza+HmFHm4jgcyL1DkpNiDqxBwPmp
        LSsCH14ZEZBZOQcOtaEEfiaBbtxR3o0=
X-Google-Smtp-Source: AA0mqf5tkYWPCh1BUcoB0u0U/ejTOx5LRiJtDeLILxQsyS796anrXkrYxrmQtli0SxALjOp6WWJHleCTUsc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:60c9:0:b0:470:48c1:aae9 with SMTP id
 r9-20020a6560c9000000b0047048c1aae9mr43149036pgv.4.1669937234233; Thu, 01 Dec
 2022 15:27:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:46 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-8-seanjc@google.com>
Subject: [PATCH 07/16] x86/reboot: Hoist "disable virt" helpers above
 "emergency reboot" path
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

Move the various "disable virtualization" helpers above the emergency
reboot path so that emergency_reboot_disable_virtualization() can be
stubbed out in a future patch if neither KVM_INTEL nor KVM_AMD is enabled,
i.e. if there is no in-tree user of CPU virtualization.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/reboot.h |  4 +-
 arch/x86/kernel/reboot.c      | 86 +++++++++++++++++------------------
 2 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index dc2b77e6704b..2be5b89c9a05 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -29,8 +29,10 @@ void __noreturn machine_real_restart(unsigned int type);
 typedef void (cpu_emergency_virt_cb)(void);
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
-#endif
 void cpu_emergency_disable_virtualization(void);
+#else
+static inline void cpu_emergency_disable_virtualization(void) {}
+#endif
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_panic_self_stop(struct pt_regs *regs);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3eec3cdbc054..a006ddaa1405 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -530,6 +530,48 @@ static inline void kb_wait(void)
 
 static inline void nmi_shootdown_cpus_on_restart(void);
 
+#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
+/* RCU-protected callback to disable virtualization prior to reboot. */
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
+
+/*
+ * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
+ * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
+ * GIF=0, i.e. if the crash occurred between CLGI and STGI.
+ */
+void cpu_emergency_disable_virtualization(void)
+{
+	cpu_emergency_virt_cb *callback;
+
+	lockdep_assert_irqs_disabled();
+
+	rcu_read_lock();
+	callback = rcu_dereference(cpu_emergency_virt_callback);
+	if (callback)
+		callback();
+	rcu_read_unlock();
+}
+#endif /* CONFIG_KVM_INTEL || CONFIG_KVM_AMD */
+
 static void emergency_reboot_disable_virtualization(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
@@ -787,53 +829,9 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
-/* RCU-protected callback to disable virtualization prior to reboot. */
-static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
-
-void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
-
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
-#endif
-
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
-/*
- * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
- * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
- * GIF=0, i.e. if the crash occurred between CLGI and STGI.
- */
-void cpu_emergency_disable_virtualization(void)
-{
-	lockdep_assert_irqs_disabled();
-
-#if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
-	cpu_emergency_virt_cb *callback;
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-#endif
-}
-
 #if defined(CONFIG_SMP)
 
 static nmi_shootdown_cb shootdown_callback;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

