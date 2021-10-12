Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A402429A34
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhJLAJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51394 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhJLAIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:25 -0400
Message-ID: <20211011223611.308125747@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Y6cv7iHtxYeZTvU/dVyQg/lgf+UNGIdtJn3H7eNlZtY=;
        b=ef7fnCdf63KiDZcX0JRHCgUo5+55U5FKcZ3vqIMeAlRBWYnXcj/QD8MmamMoXeQxFF89yx
        Fz+mFaUuNj/WXyidcob2ZFRmsg5xnG7Xl2E6EO9Rmgv/j4KGlhXUpXeeAqq115Tldxol+Q
        o6333tNbhPLETAXFu76mgQES87540jdoboLcoZLRdNY8F2mgGt39EDB8iRRaPzH5eL65S7
        A67uHcvkD/vnq0ySm7HFX2lmP4JAEyBL3RP+17jIzi1i8+5Z1nUwWIpILnlQiZTTdes9aY
        A/R7EbXQLlJo0s54kTNa4kSmhYH3LnKQ3SuDuZavHTpAahQ/hSyLB7lAdt2JYA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Y6cv7iHtxYeZTvU/dVyQg/lgf+UNGIdtJn3H7eNlZtY=;
        b=nwQPs3ElAl8xMV73iw8DvTAh0NBXJaGCySLYAiVkkOsejDYk4k9PznNCJSk4gtM0VHjwum
        gOGKCOG1ce8Oj7DA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 17/31] x86/fpu: Mark fpu__init_prepare_fx_sw_frame() as __init
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:24 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to keep it around.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/signal.h |    2 --
 arch/x86/kernel/fpu/internal.h    |    8 ++++++++
 arch/x86/kernel/fpu/signal.c      |    4 +++-
 arch/x86/kernel/fpu/xstate.c      |    1 +
 4 files changed, 12 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -31,6 +31,4 @@ fpu__alloc_mathframe(unsigned long sp, i
 
 unsigned long fpu__get_fpstate_size(void);
 
-extern void fpu__init_prepare_fx_sw_frame(void);
-
 #endif /* _ASM_X86_FPU_SIGNAL_H */
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
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -16,6 +16,8 @@
 #include <asm/trapnr.h>
 #include <asm/trace/fpu.h>
 
+#include "internal.h"
+
 static struct _fpx_sw_bytes fx_sw_reserved __ro_after_init;
 static struct _fpx_sw_bytes fx_sw_reserved_ia32 __ro_after_init;
 
@@ -514,7 +516,7 @@ unsigned long fpu__get_fpstate_size(void
  * This will be saved when ever the FP and extended state context is
  * saved on the user stack during the signal handler delivery to the user.
  */
-void fpu__init_prepare_fx_sw_frame(void)
+void __init fpu__init_prepare_fx_sw_frame(void)
 {
 	int size = fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
 
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -19,6 +19,7 @@
 
 #include <asm/tlbflush.h>
 
+#include "internal.h"
 #include "xstate.h"
 
 #define for_each_extended_xfeature(bit, mask)				\

