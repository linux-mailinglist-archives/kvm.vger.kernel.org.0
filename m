Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BF642E611
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhJOBUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhJOBUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:20:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AA8C061798;
        Thu, 14 Oct 2021 18:16:43 -0700 (PDT)
Message-ID: <20211015011540.053515012@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=TMwU8z8/LQBoAYmC9g7bu6xynGD7UrpwsBXR7iUeNYg=;
        b=IZRHjyDDLGucPzxkcSjlaLcrM0hXSfsMMZH6nGNrBoLiUO38oO4YxFVd7FgvZUWCUkSTkj
        H0sgl2wXuE5QcwyrGX6UKbKaZbH+25G9E3ixXHtlHR2DqWqT5/ZaPmNUPCw8FK6eWbZk3Z
        Cwkyoa7ZE7jpQH+bf8+JNsfZLAjluiSqHCc3p+p6rAyrdSNe4cnJsMgA4206EKw0syogoi
        TInB8C9b54x4BV86Bs82yKoJzkh5VxVjPJlTSSHci96ai9v76nZJBeeJIVTN23Xz55uuxY
        AFWvFA5fGEQXxj01CoQHZ7RzknjWsEW8MIhdkGyj4qw4i5lJyZOCDnW11725AA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=TMwU8z8/LQBoAYmC9g7bu6xynGD7UrpwsBXR7iUeNYg=;
        b=l6rmTHz2EtlpCgyHhW5lMfDtFMBVI3KWBzlOBYX/EaQBbN/edXu4el9+hJ5DaVq8jLuk+z
        +At4PAhbsNd8ANDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 30/30] x86/fpu: Provide a proper function for
 ex_handler_fprestore()
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:41 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make upcoming changes for support of dynamically enabled features
simpler, provide a proper function for the exception handler which removes
exposure of FPU internals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/api.h | 4 +---
 arch/x86/kernel/fpu/core.c     | 5 +++++
 arch/x86/kernel/fpu/internal.h | 2 ++
 arch/x86/mm/extable.c          | 5 ++---
 4 files changed, 10 insertions(+), 6 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index b68d8ce599e4..5ac5e4596b53 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -113,6 +113,7 @@ static inline void update_pasid(void) { }
 /* Trap handling */
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 extern void fpu_sync_fpstate(struct fpu *fpu);
+extern void fpu_reset_from_exception_fixup(void);
 
 /* Boot, hotplug and resume */
 extern void fpu__init_cpu(void);
@@ -129,9 +130,6 @@ static inline void fpstate_init_soft(struct swregs_state *soft) {}
 /* State tracking */
 DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
-/* fpstate */
-extern union fpregs_state init_fpstate;
-
 /* fpstate-related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index c6d7a47b1b26..ac540a7d410e 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -155,6 +155,11 @@ void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
 	}
 }
 
+void fpu_reset_from_exception_fixup(void)
+{
+	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+}
+
 #if IS_ENABLED(CONFIG_KVM)
 void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
 {
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
index bd7f813242dd..479f2db6e160 100644
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -2,6 +2,8 @@
 #ifndef __X86_KERNEL_FPU_INTERNAL_H
 #define __X86_KERNEL_FPU_INTERNAL_H
 
+extern union fpregs_state init_fpstate;
+
 /* CPU feature check wrappers */
 static __always_inline __pure bool use_xsave(void)
 {
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 79c2e30d93ae..5cd2a88930a9 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -4,8 +4,7 @@
 #include <linux/sched/debug.h>
 #include <xen/xen.h>
 
-#include <asm/fpu/signal.h>
-#include <asm/fpu/xstate.h>
+#include <asm/fpu/api.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
@@ -48,7 +47,7 @@ static bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
-	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+	fpu_reset_from_exception_fixup();
 	return true;
 }
 

