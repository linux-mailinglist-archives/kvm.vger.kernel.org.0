Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750B242E5E6
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhJOBS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46486 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbhJOBSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:25 -0400
Message-ID: <20211015011539.296435736@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zdW2877c8QrzBJVc70/FSm1yd0CzzH/G41JEp9X+xGc=;
        b=f96R+daJK0xsP8Msl6ECe0LcEVSRjlCOnATpoMhB1P+AoDbxwAr0rxxs67XoKVG8BjrGiE
        BXuGRxVzptTJbP+bw+6AHxdfoTkVboDY5+myu1zAa5y5/Pe5V+AoCRMxYpKIlj1FpHSlbZ
        zXuPva3jwn6JGRpHaVFVOXwuSeGSLs1pByzjSI23wnGVU/rrMfoMg9CMvfR43hX27obnGc
        G4AM7g3x+9cZ/GRlqzVYJrL2ZQ6sU6G+L3Dm2W4BKEIrpdAsO6Nfy1HvVAMBQUqXqE3RwE
        K7u7qwF9upm4waZuTE2XZfHrgs7jxvHNv+1LAZcCkoKdCLQYkFD3y8yYcEFO2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zdW2877c8QrzBJVc70/FSm1yd0CzzH/G41JEp9X+xGc=;
        b=m0N8F+OJ9dTeTSj74mAzfHXQVgRw8dFqWbmVjE2BP+l7W1hCXjxhVyZWLXITvlYki6Mszt
        v8Q1KjZDTJGXcRBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 16/30] x86/fpu: Mark fpu__init_prepare_fx_sw_frame() as __init
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:18 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to keep it around.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/signal.h | 2 --
 arch/x86/kernel/fpu/internal.h    | 8 ++++++++
 arch/x86/kernel/fpu/signal.c      | 4 +++-
 arch/x86/kernel/fpu/xstate.c      | 1 +
 4 files changed, 12 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/fpu/internal.h
---
diff --git a/arch/x86/include/asm/fpu/signal.h b/arch/x86/include/asm/fpu/signal.h
index 8b6631dffefd..04868a76239a 100644
--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -31,6 +31,4 @@ fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 
 unsigned long fpu__get_fpstate_size(void);
 
-extern void fpu__init_prepare_fx_sw_frame(void);
-
 #endif /* _ASM_X86_FPU_SIGNAL_H */
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
new file mode 100644
index 000000000000..036f84c236dd
--- /dev/null
+++ b/arch/x86/kernel/fpu/internal.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __X86_KERNEL_FPU_INTERNAL_H
+#define __X86_KERNEL_FPU_INTERNAL_H
+
+/* Init functions */
+extern void fpu__init_prepare_fx_sw_frame(void);
+
+#endif
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 64f0d4eda0b0..404bbb4a0f60 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -16,6 +16,8 @@
 #include <asm/trapnr.h>
 #include <asm/trace/fpu.h>
 
+#include "internal.h"
+
 static struct _fpx_sw_bytes fx_sw_reserved __ro_after_init;
 static struct _fpx_sw_bytes fx_sw_reserved_ia32 __ro_after_init;
 
@@ -514,7 +516,7 @@ unsigned long fpu__get_fpstate_size(void)
  * This will be saved when ever the FP and extended state context is
  * saved on the user stack during the signal handler delivery to the user.
  */
-void fpu__init_prepare_fx_sw_frame(void)
+void __init fpu__init_prepare_fx_sw_frame(void)
 {
 	int size = fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index b2537a8203ee..1f5a66a38671 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -19,6 +19,7 @@
 
 #include <asm/tlbflush.h>
 
+#include "internal.h"
 #include "xstate.h"
 
 #define for_each_extended_xfeature(bit, mask)				\

