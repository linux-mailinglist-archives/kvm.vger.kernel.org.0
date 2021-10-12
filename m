Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F019429A0C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhJLAIc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51276 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhJLAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:24 -0400
Message-ID: <20211011223611.667144933@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=cfXC2sFV/i3NzxBTHk1PxgvXSNyPHXcEHXmZOp7DfuY=;
        b=RpYyauXsM/S2hlkcwjRgzawm+NOAPXepP47Y3DeAbXPdMOlar6ETJdAf03TtKwxCOaB1gx
        ulbK/glAZR6JF8eQ/oTG8YSnCDFY11+Uyqki43/BHWR00qXLfVK6NuM4D+EAYVovTk2M5n
        6bJy2DeVx+kQHx7PD7xZcq8hcK5U0ORjiJvMZHtr+XLbPLz869uS+hNbthZpU7xdwyc6xy
        AaGUvT3RmtvyM63FLf3seqebIDr1edClIafsfknGYxDlZfBqNu4uxvZrfjjwSfemWuc5JY
        9ED2Yu2EphnOO2EMO1CkE6/DInDXC/eaxaZ7Qpv18Ms+uNj4SIZ9ZX5g40ndlw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=cfXC2sFV/i3NzxBTHk1PxgvXSNyPHXcEHXmZOp7DfuY=;
        b=OzkSw4mVDMi/ZWB4KFETgypYK1Nz5fX886jnFrmpT19CrNFhFXdb3Yl32RXF53eh6PMX1M
        apMDKQOro9xnVoDQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 23/31] x86/fpu: Make WARN_ON_FPU() private
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:33 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No point in being in global headers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |    9 ---------
 arch/x86/kernel/fpu/init.c          |    2 ++
 arch/x86/kernel/fpu/internal.h      |    6 ++++++
 3 files changed, 8 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -42,15 +42,6 @@ extern void fpu__init_system(struct cpui
 extern void fpu__init_check_bugs(void);
 extern void fpu__resume_cpu(void);
 
-/*
- * Debugging facility:
- */
-#ifdef CONFIG_X86_DEBUG_FPU
-# define WARN_ON_FPU(x) WARN_ON_ONCE(x)
-#else
-# define WARN_ON_FPU(x) ({ (void)(x); 0; })
-#endif
-
 extern union fpregs_state init_fpstate;
 extern void fpstate_init_user(union fpregs_state *state);
 
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -10,6 +10,8 @@
 #include <linux/sched/task.h>
 #include <linux/init.h>
 
+#include "internal.h"
+
 /*
  * Initialize the registers found in all CPUs, CR0 and CR4:
  */
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -13,6 +13,12 @@ static __always_inline __pure bool use_f
 	return cpu_feature_enabled(X86_FEATURE_FXSR);
 }
 
+#ifdef CONFIG_X86_DEBUG_FPU
+# define WARN_ON_FPU(x) WARN_ON_ONCE(x)
+#else
+# define WARN_ON_FPU(x) ({ (void)(x); 0; })
+#endif
+
 /* Init functions */
 extern void fpu__init_prepare_fx_sw_frame(void);
 

