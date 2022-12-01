Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D863FBEF
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiLAX1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiLAX1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB539C9366
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:04 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b17-20020a25b851000000b006e32b877068so3326339ybm.16
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DA91i2oZnY42qV1reMA6fFQYAyKGGbDT6HRfvlU2Axc=;
        b=dknQcxepnbfWDiba9noWUVCaonlLdg8B/11fnai9Q3F7mag317asvQdsf+FqFF9fd4
         YU6VtAXT0iwrRI/BP8oIfrzZ36BYaLecoa0Y+JQWbdR6ND1/pSbs9yG/uIb3zLfB99HR
         15iYofue1KKJehKnekWfgNyetv0tN219KR31yZ3OcGv4/JAeBpNwsSBwFIV0ivD6Ehu1
         E7lV6r966hKxFtahrqXwdoN7YkcvS/eenu2dh/wg16EfPdX0lqpSxYgUfidTR97UrPzn
         SEerIUXx6vUxrXpJCoAJqGccyLjb49C80+wqNcmXB0tDuKET6CkPYqMRRrTRc4OvePrg
         LKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DA91i2oZnY42qV1reMA6fFQYAyKGGbDT6HRfvlU2Axc=;
        b=TsEWXQRk+cSSYMZovRACWmiw33eRgRrroOHxtKa+zd5EzxzECmLLtltdK/+yvzdtNw
         8KYbDd6l2Qm/OmZIBGIGGymMOe80EFY2GefJxwOp1rtAtob6VY7orsPOls8Xyi+n9RM6
         TF0fBkXdvPfXl32h5JIEjriZJI6FZMFZf5F1Udbnx6mBw08SBarciZjtv6LP/xE6SVjN
         iZ8lrqkd7FwAaqNvlBUFLeMzZzpi6qUdbjL0kBJdb3kixWlZx5w3Lr/DsmElQ4U1DUnv
         iRiIdklFpiMuLuV0TYGt+xV+FR/YTeSZ9WnGUJi7tRSJifokWRvgkPueKFJxOpLtHHnq
         PsNw==
X-Gm-Message-State: ANoB5pkJYjst1+voTCiRC1yxjpmh5UxJNA4jBRSfSHNBgnf+HnS8b5pT
        1U2DEofysRDNYngv7qOvjt0czg46pkI=
X-Google-Smtp-Source: AA0mqf6dkOhcaMQiyxN3fkH601nOEExPewEW+pyile2P+J24RgXs+/6gCa65uTJ+QuTJBaVSe9Q2aACc8oE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6602:0:b0:6f9:890c:6468 with SMTP id
 a2-20020a256602000000b006f9890c6468mr12986187ybc.610.1669937223951; Thu, 01
 Dec 2022 15:27:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:40 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-2-seanjc@google.com>
Subject: [PATCH 01/16] x86/reboot: VMCLEAR active VMCSes before emergency reboot
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
index 6b8a6aae02e3..7611dd5f90a4 100644
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
index 39dd3082fcd8..7ea020456dd0 100644
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
@@ -8528,10 +8526,9 @@ static void __vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
-#ifdef CONFIG_KEXEC_CORE
 	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
 	synchronize_rcu();
-#endif
+
 	vmx_cleanup_l1d_flush();
 }
 
@@ -8580,10 +8577,9 @@ static int __init vmx_init(void)
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
2.39.0.rc0.267.gcb52ba06e7-goog

