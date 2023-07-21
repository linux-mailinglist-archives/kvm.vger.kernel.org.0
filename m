Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E875D576
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjGUUTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 16:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjGUUTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 16:19:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814F4359D
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-c0d62f4487cso2306081276.0
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 13:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689970746; x=1690575546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xY+3Pnlxin9cJMvMOS3842OXvOZxwo3V1XbzLrWDw/E=;
        b=Lqb3RehZeO7ntuc5ijbgqhf+wouAzLMMAFKmweKe4G70L9uc4Bw2Jl5XydLCvynLja
         MxugEfg74h0RFAs1g/mPDWIA6CQEQjP/1tCMXpzbUBwwHi1wUVOx7FGGl6cj3EKgt4DI
         2serW/L/1xq/mdpALeeGTUFcMs8dGf7LsjjD0F7Qj7rNn0+spOMJVHUn7lKygW1pXfr6
         V4l0GVwRDsM4qqERhw/rUjtXUDV9O3+sw+gB5y+qOA/uO7E4/u1wlbkArtHA17Pz8aqj
         lI6iYWVldo4NzF+NtwvTmo0m32Ap85XnNI96DTf2N43IXGAmmG5+ay/zpvN3HuCBAR7U
         b77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689970746; x=1690575546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xY+3Pnlxin9cJMvMOS3842OXvOZxwo3V1XbzLrWDw/E=;
        b=KzJwUea2w/OAxzVjOG8OJVsi9l0KJULk3Rve24cn+ofaYW8xnFSgXW/uZuH59HtKQb
         VzoK7txRTfyiwP706hIIc9deMMu/+UkayTKZytmhX5PZL5EDlZhVipkl5mBoqiM7qpPP
         g6zoqmIN+0ezDfPYEBiqLbSMMdDUNiWwi9q915rO6fkRyG44/pOlzKm4Hfmiedn6ElaH
         FrVdpK0i0nc5/twtRqjjxSkV414f9WhmmgDCdnLrMS32j0guesU5UdcIXs506VxyAkHr
         Bjd5jw0QhRvVuTyruP31mOs4E1XXTe+VgAGt5KiU6qNVAsaMYtLPmuU2SjzE9VGgLwzT
         ZvoA==
X-Gm-Message-State: ABy/qLYif9UIQDOvx49D+L5zjyH9fmwV2BLc9FVWrHoDpwSzKMHcFxqr
        Jahjrxc2xTj4vF9L++8v82LzxEKcCYE=
X-Google-Smtp-Source: APBJJlGl5vZN06f98oGYYGpQC92l2Mt5+UVa2JPZ8raPJUCa9tUN62sdYqhFV6XvSia8+6L1I1Yz+z97vko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:428d:0:b0:c65:7352:4b5 with SMTP id
 p135-20020a25428d000000b00c65735204b5mr21381yba.0.1689970745731; Fri, 21 Jul
 2023 13:19:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 13:18:41 -0700
In-Reply-To: <20230721201859.2307736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721201859.2307736-2-seanjc@google.com>
Subject: [PATCH v4 01/19] x86/reboot: VMCLEAR active VMCSes before emergency reboot
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
index 5b77bbc28f96..819046974b99 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -205,8 +205,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image);
 #endif
 #endif
 
-typedef void crash_vmclear_fn(void);
-extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
 extern void kdump_nmi_shootdown_cpus(void);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 9177b4354c3f..dc201724a643 100644
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
index 3adbe97015c1..3fa4c6717a1d 100644
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
index 0ecf4be2c6af..7f692d97a821 100644
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
@@ -8592,10 +8590,9 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-#ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
-#endif
+
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8644,10 +8641,9 @@ static int __init vmx_init(void)
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
2.41.0.487.g6d72f3e995-goog

