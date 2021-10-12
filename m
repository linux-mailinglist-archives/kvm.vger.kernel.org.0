Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE872429A2A
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhJLAJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51508 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223611.846280577@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=oEva5V/97ct5UQuKFK5IGfaw1DZ+FmPxcrD1r2aiDpI=;
        b=QZjdLY8tNuG5aFmEWSAS8f3n3JjHZn38ppgbMPIZQmyYPeGQI6K81JqY6DRVVZgh/7ywTn
        MliNBa8jWkllkYmFfoFsNdZgLLz5tdD2pBagevl1Xux5fNBkg6xRxl65UPXv8caSetPE/8
        SD0Xqwf9Nk99C0NfLapt9ofWT2IVqJN0JszLGlv8UVheUQKNa2v0k5TUCrMiTWGtjwrp7O
        c7S0dU2Jp1lVFTzgI5/OX2rq1nggyntW5m1uFSK0ENguq6GmPedJ3N5C5fR4EQz2xHm2uX
        GAdCeQvnrx5rUqbut+sS5Hf29if3lIGeU9lHiCfQLYuFVGz7TIxM48/gj+IroA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=oEva5V/97ct5UQuKFK5IGfaw1DZ+FmPxcrD1r2aiDpI=;
        b=+UsevrxoWqKsvWh7t443jgIl5arzLF/LCHtZx7iHX1w2+Tzax2kKgnLwzRRHxmYfc6Oaww
        O5PalNHNi1nxpkDQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 26/31] x86/fpu: Move fpstate functions to api.h
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:37 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move function declarations which need to be globaly available to api.h
where they belong.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/api.h      |    9 +++++++++
 arch/x86/include/asm/fpu/internal.h |    9 ---------
 arch/x86/kernel/fpu/internal.h      |    3 +++
 arch/x86/math-emu/fpu_entry.c       |    2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -110,6 +110,15 @@ extern int cpu_has_xfeatures(u64 xfeatur
 
 static inline void update_pasid(void) { }
 
+#ifdef CONFIG_MATH_EMULATION
+extern void fpstate_init_soft(struct swregs_state *soft);
+#else
+static inline void fpstate_init_soft(struct swregs_state *soft) {}
+#endif
+
+/* FPSTATE */
+extern union fpregs_state init_fpstate;
+
 /* FPSTATE related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
 
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -42,15 +42,6 @@ extern void fpu__init_system(struct cpui
 extern void fpu__init_check_bugs(void);
 extern void fpu__resume_cpu(void);
 
-extern union fpregs_state init_fpstate;
-extern void fpstate_init_user(union fpregs_state *state);
-
-#ifdef CONFIG_MATH_EMULATION
-extern void fpstate_init_soft(struct swregs_state *soft);
-#else
-static inline void fpstate_init_soft(struct swregs_state *soft) {}
-#endif
-
 extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -22,4 +22,7 @@ static __always_inline __pure bool use_f
 /* Init functions */
 extern void fpu__init_prepare_fx_sw_frame(void);
 
+/* Used in init.c */
+extern void fpstate_init_user(union fpregs_state *state);
+
 #endif
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -31,7 +31,7 @@
 #include <linux/uaccess.h>
 #include <asm/traps.h>
 #include <asm/user.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"

