Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91B16B52F9
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbjCJVmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjCJVmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:42:40 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564BC1308DB
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:39 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o17-20020a17090ab89100b0023752c22f38so3259183pjr.4
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ef7PP0SQ7R8DCF78GLBtkjVAZkkgPEB1VXa9M7tBWJI=;
        b=Un8MBYCmNnLoukZjJV+nUJt8RrbN1Wuz/29ZYWJZGTk2dPZ5X9qMkdfmDLXpK6nWai
         hCnYZQbiJGX8XRqFa1KD6lVkYvkWoAbqL62YxFG/yJKKljUoX2BnFUaKgeVDc5u5LGxN
         PyLIxDhvz7dvMSK8rLvrMj/Db8H5ad5uFl7o2jROvRPRjCfyiaV4RReQzCegQGzv5VAK
         wCYubxPB2Q6XJlzhUIPpzUhA5azOQTTyIE/8R+SkPGSbhqr8wQgcwBYVLgtEl8IPWuOh
         ozerfx7inWzUZLxL/dlwiAilvkE4hChx0tvu45zH/d1mD9WrKJsnHVXyBa/ZXeLW1gpj
         tq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ef7PP0SQ7R8DCF78GLBtkjVAZkkgPEB1VXa9M7tBWJI=;
        b=StV5UUQrQeKLdwmjffldpDt+seXUwxtITCDwOJXW/gp/Hok8FwFZBjxz+6jupWoMHE
         7hqaLEVETD/WlaUXRzqnh8hlRBrqCVfEpfhupPBLwCJgDWcTvUKupMgMfobCjzpRMalP
         uhawJOjSsjCi+wxYlSx33vrQSUeSExq/qQ0Axuy25EEjY2rlHY3fmjUIsEFG66LoD9Lu
         CLhduAnqEs9d7vKj9JtlXrkQBaFsRfF48v/V/EzSxYfBpvkvm6JFLUSYw48TdZcqtMgx
         /p2QAI9IHgW/ThhXRHM2uKAsJ1AC5F2GMRAH3/0Rv0rc4xbf5p6L+c2UsNSvW0zYLvZe
         HDKQ==
X-Gm-Message-State: AO0yUKVvaH3Vf0eE46iX45/F1tcinzlV6LVJ0Tx8tAfi/jEScEKVPi3T
        pbspOUXrK+FgCUctBsn1ZIH5kdDojiA=
X-Google-Smtp-Source: AK7set/tAkvc7UNnY9aIsf0O51rwZa0m+kVkoq5Dwi9O7vW70UvxQygmv4gvI5F6wcNEIKCIBPQhDMz776M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a38e:b0:19b:42d:79f8 with SMTP id
 x14-20020a170902a38e00b0019b042d79f8mr10655656pla.5.1678484558868; Fri, 10
 Mar 2023 13:42:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:15 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-2-seanjc@google.com>
Subject: [PATCH v2 01/18] x86/reboot: VMCLEAR active VMCSes before emergency reboot
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMCLEAR active VMCSes before any emergency reboot, not just if the kernel
may kexec into a new kernel after a crash.  Per Intel's SDM, the VMX
architecture doesn't require the CPU to flush the VMCS cache on INIT.  If
an emergency reboot doesn't RESET CPUs, cached VMCSes could theoretically
be kept and only be written back to memory after the new kernel is booted,
i.e. could effectively corrupt memory after reboot.

Opportunistically remove the setting of the global pointer to NULL to make
checkpatch happy.

Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kexec.h  |  2 --
 arch/x86/include/asm/reboot.h |  2 ++
 arch/x86/kernel/crash.c       | 31 -------------------------------
 arch/x86/kernel/reboot.c      | 22 ++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c        | 10 +++-------
 5 files changed, 27 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index a3760ca796aa..256eee99afc8 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -208,8 +208,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #endif
 #endif
 
-typedef void crash_vmclear_fn(void);
-extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
 extern void kdump_nmi_shootdown_cpus(void);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index bc5b4d788c08..2551baec927d 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,6 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+typedef void crash_vmclear_fn(void);
+extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
 void cpu_emergency_disable_virtualization(void);
 
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index cdd92ab43cda..54cd959cb316 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -48,38 +48,12 @@ struct crash_memmap_data {
 	unsigned int type;
 };
 
-/*
- * This is used to VMCLEAR all VMCSs loaded on the
- * processor. And when loading kvm_intel module, the
- * callback function pointer will be assigned.
- *
- * protected by rcu.
- */
-crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss = NULL;
-EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
-
-static inline void cpu_crash_vmclear_loaded_vmcss(void)
-{
-	crash_vmclear_fn *do_vmclear_operation = NULL;
-
-	rcu_read_lock();
-	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
-	if (do_vmclear_operation)
-		do_vmclear_operation();
-	rcu_read_unlock();
-}
-
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
 static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 {
 	crash_save_cpu(regs, cpu);
 
-	/*
-	 * VMCLEAR VMCSs loaded on all cpus if needed.
-	 */
-	cpu_crash_vmclear_loaded_vmcss();
-
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
@@ -133,11 +107,6 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	crash_smp_send_stop();
 
-	/*
-	 * VMCLEAR VMCSs loaded on this cpu if needed.
-	 */
-	cpu_crash_vmclear_loaded_vmcss();
-
 	cpu_emergency_disable_virtualization();
 
 	/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d03c551defcc..299b970e5f82 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -787,6 +787,26 @@ void machine_crash_shutdown(struct pt_regs *regs)
 }
 #endif
 
+/*
+ * This is used to VMCLEAR all VMCSs loaded on the
+ * processor. And when loading kvm_intel module, the
+ * callback function pointer will be assigned.
+ *
+ * protected by rcu.
+ */
+crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
+EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
+
+static inline void cpu_crash_vmclear_loaded_vmcss(void)
+{
+	crash_vmclear_fn *do_vmclear_operation = NULL;
+
+	rcu_read_lock();
+	do_vmclear_operation = rcu_dereference(crash_vmclear_loaded_vmcss);
+	if (do_vmclear_operation)
+		do_vmclear_operation();
+	rcu_read_unlock();
+}
 
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
@@ -798,6 +818,8 @@ int crashing_cpu = -1;
  */
 void cpu_emergency_disable_virtualization(void)
 {
+	cpu_crash_vmclear_loaded_vmcss();
+
 	cpu_emergency_vmxoff();
 	cpu_emergency_svm_disable();
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..302086255be6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -41,7 +41,7 @@
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
-#include <asm/kexec.h>
+#include <asm/reboot.h>
 #include <asm/perf_event.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
@@ -743,7 +743,6 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-#ifdef CONFIG_KEXEC_CORE
 static void crash_vmclear_local_loaded_vmcss(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -753,7 +752,6 @@ static void crash_vmclear_local_loaded_vmcss(void)
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
 }
-#endif /* CONFIG_KEXEC_CORE */
 
 static void __loaded_vmcs_clear(void *arg)
 {
@@ -8553,10 +8551,9 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-#ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
-#endif
+
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8605,10 +8602,9 @@ static int __init vmx_init(void)
 		pi_init_cpu(cpu);
 	}
 
-#ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
 			   crash_vmclear_local_loaded_vmcss);
-#endif
+
 	vmx_check_vmcs12_offsets();
 
 	/*
-- 
2.40.0.rc1.284.g88254d51c5-goog

