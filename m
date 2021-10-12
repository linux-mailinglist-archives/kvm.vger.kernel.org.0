Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3DA429A28
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbhJLAJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2A0C061749;
        Mon, 11 Oct 2021 17:06:29 -0700 (PDT)
Message-ID: <20211011223612.145363780@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+DDPznsqgrt6mGetm00zwJ7IWc7hobGjiUCJd9lybJk=;
        b=fS7P9nLP5NEzaJTFb/loVeS8dt+CcQRX4IyxpRXrPJhbIK7WJPbkYsPGrfB8faiGevEHg3
        /3dt2XlavVuoO2ADZPvyyzepeBRS9tCwzbmD/KdZJSVuJFf/t9LAfBZkl4ATzk+puTKij4
        zXjKBClMHCC346oXHU2agFmB+fti3HiSRwg488YwfjD3d7jP5+bLHh6R7jj5dpg0GsC+VS
        Ma95grsxmSmlEI59eHdU1BvUI/JoqDFnq339ZtUEyJC2cN5vBV3NQrD2nJQeihxZQTuErK
        CJnnpcy+qI4bderRSIIaKAssymZUFrwIz+zJ4bINOmENeo8GuK46wmSByMCWSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=+DDPznsqgrt6mGetm00zwJ7IWc7hobGjiUCJd9lybJk=;
        b=TfTcEaElMUW4s8tDhEa+hGdo/bV/oRUEEmqy/t+jcwY8ZEuKAkbo1PvAmMLFd+2eZbWrlW
        24tx2i2YnhmaOCBQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 31/31] x86/fpu: Provide a proper function for ex_handler_fprestore()
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:45 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make upcoming changes for support of dynamically enabled features
simpler, provide a proper function for the exception handler which removes
exposure of FPU internals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/api.h |    4 +---
 arch/x86/kernel/fpu/core.c     |    5 +++++
 arch/x86/kernel/fpu/internal.h |    2 ++
 arch/x86/mm/extable.c          |    5 ++---
 4 files changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -113,6 +113,7 @@ static inline void update_pasid(void) {
 /* Trap handling */
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 extern void fpu_sync_fpstate(struct fpu *fpu);
+extern void fpu_reset_from_exception_fixup(void);
 
 /* Boot, hotplug and resume */
 extern void fpu__init_cpu(void);
@@ -129,9 +130,6 @@ static inline void fpstate_init_soft(str
 /* State tracking */
 DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
-/* FPSTATE */
-extern union fpregs_state init_fpstate;
-
 /* FPSTATE related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -155,6 +155,11 @@ void restore_fpregs_from_fpstate(union f
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
@@ -48,7 +47,7 @@ static bool ex_handler_fprestore(const s
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
-	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+	fpu_reset_from_exception_fixup();
 	return true;
 }
 

