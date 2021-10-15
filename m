Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D949C42E603
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhJOBUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbhJOBTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:19:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B65C0613E9;
        Thu, 14 Oct 2021 18:16:30 -0700 (PDT)
Message-ID: <20211015011539.628516182@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=k0x+7z+1KYAdgY8we3nsR4L/sClon/Ac7bDr44uQ7wo=;
        b=rO6vOAixtFynqmqo5OyawLf57C7yuXIqN1jmQWhJtaYJ675UccbJJEUsgwFn9TxnqeQodB
        vkxHFx0q55+0mjgJjsCRUOiyGQ2A6/P7fxO0ZPBXOZJocCgOIqctu4Cm/Cope9c8jnzapd
        NFNGA6mQ0McA7+7P/XmUb8ZNOD0i/rLXUPQfZ8NGEWsfakcGkvBlbdvS8K9BfWMhOGl9xf
        vuNu2JtHgNYc9yLZpe8+anC7CfDmduElg9YNw6fQuQC4xdGGu55LldkyrrYXX+bZLaqJhZ
        6XDq5dpEtZ4gmGxp5HKNrD2O/xh+aTbbtGXCD1DD9ejDRHunVH/I47PEr1LNmA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=k0x+7z+1KYAdgY8we3nsR4L/sClon/Ac7bDr44uQ7wo=;
        b=plMA5KPR/+QYQBEnA/Pi03H+Msyx097R+bap2IN8RtwYDcp4iC7fd0YIFwbsUTVM/DjfTQ
        jnk5V0YrW0zhFWAQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 22/30] x86/fpu: Make WARN_ON_FPU() private
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:28 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No point in being in global headers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h |  9 ---------
 arch/x86/kernel/fpu/init.c          |  2 ++
 arch/x86/kernel/fpu/internal.h      |  6 ++++++
 3 files changed, 8 insertions(+), 9 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 7722aadc3278..f8413a509ba5 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -42,15 +42,6 @@ extern void fpu__init_system(struct cpuinfo_x86 *c);
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
 
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 545c91c723b8..24873dfe2dba 100644
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
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
index a8aac21ba364..5ddc09e03c2a 100644
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -13,6 +13,12 @@ static __always_inline __pure bool use_fxsr(void)
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
 

