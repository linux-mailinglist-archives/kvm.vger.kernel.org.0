Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B497012A1
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240879AbjELXuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240720AbjELXud (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:50:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0971737
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:32 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-24e02410034so10374692a91.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935432; x=1686527432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AdqZMtZaSKGgEy54ZI8iaQkXyWsGslzW0QTgtvZWoNI=;
        b=5jyM5juOrlj9NYvKkpIJw46gHGAcT58Bf9xhCB3KTTODHqeYj2xsf8mUFNX25FhdEW
         9KjzeE6uMrpwW7BlWw5I06ke8VUkemqm9LFTbtPk7/zsIbYSVOp7jqCXcE3WbSOQK8dx
         tO+eCIqRWrxaaQ6Qji0kwmzWKlrDEAS8WjuUiULGz99Q98To/tpJq6DxnbrBtR0IR/aB
         Kulv46zdcWohPA1iK3VAh3TSC0e1+OulLH6ZkhNDVWLatqvEtNvnvvQqFyCGHO6h9Nb2
         fKsxwJZTe5bjB/tVeqd80cr5X9UKPoWaTU2StoJjCMiC32Wv6Mt7AukROrJCELSX5nAM
         maEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935432; x=1686527432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdqZMtZaSKGgEy54ZI8iaQkXyWsGslzW0QTgtvZWoNI=;
        b=MgUdV9OKEmspyOnvWl3Nt/5qPL5hKOg6I3JXn10a5RCNxvK2p/CxGthjBiRQ5S7WTm
         tK0hivpl6ulEKV62l7paaeIw9Y9uuzgFqO7hBXJUvReYUjX9xxBUiR3uWq7/sQUxA1fn
         DEZo08IA+D4kPAMa8xfyILWs9E3Y5PXnA3RYiz0bOQDYMHyl4hpM96XIXqTJVhdvsO7l
         EJ3XT2IcOIp65iYD9UkeWRODQ80x9glmglf7WJCOa38dhzGIU7Gnq3MhusUwvYxFIU3a
         d+emPwDER5c+SPKy75mCBXNSIZUK9NLf+PSwrNLZWv6SuCkhFqhD/2vQnQzDruZlYje5
         ACJg==
X-Gm-Message-State: AC+VfDw8kps/CEmrr22SA3Y7R+3loj4dPr3EjPbyw+gxttGw/yu5EWL9
        k9QQQZOON26GtCWzyumnSiWV/ERnjP8=
X-Google-Smtp-Source: ACHHUZ6KKw1Ju7rMyajRdADi1++fw/wIj3ZeqRUSTB+7LLx+0cdxAEnsh86vxXJW6s56scnNjuVMkiDKG8o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1194:b0:246:fd4b:14e6 with SMTP id
 gk20-20020a17090b119400b00246fd4b14e6mr8009138pjb.7.1683935432164; Fri, 12
 May 2023 16:50:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:09 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-2-seanjc@google.com>
Subject: [PATCH v3 01/18] x86/reboot: VMCLEAR active VMCSes before emergency reboot
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
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
index 44fb619803b8..317f72baf0c3 100644
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
@@ -744,7 +744,6 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-#ifdef CONFIG_KEXEC_CORE
 static void crash_vmclear_local_loaded_vmcss(void)
 {
 	int cpu = raw_smp_processor_id();
@@ -754,7 +753,6 @@ static void crash_vmclear_local_loaded_vmcss(void)
 			    loaded_vmcss_on_cpu_link)
 		vmcs_clear(v->vmcs);
 }
-#endif /* CONFIG_KEXEC_CORE */
 
 static void __loaded_vmcs_clear(void *arg)
 {
@@ -8549,10 +8547,9 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-#ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
-#endif
+
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8601,10 +8598,9 @@ static int __init vmx_init(void)
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
2.40.1.606.ga4b1b128d6-goog

