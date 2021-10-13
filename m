Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A864A42C427
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhJMO57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbhJMO5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:46 -0400
Message-ID: <20211013145322.765063318@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=KG53QOGc4VkNL0CVqfZ44CkyO1qKBK0wUzZF8Vb4s2w=;
        b=OZCTP/A/72BmPT/3JDBNDbOhh7w7MAuUJA0LUytdPySHhImB011hs1M0balzdGBRiWTXAL
        iPPKlKbhdn+RydEHhhwPxblk4dmJEoIQUM9v+04b5tyDYchdG2kVemObu+EyyUJoMQufhf
        amuDoyDSqf5fqZ5yew5YISVpojzReQT88GT7+nsZrG+mFpZhqr3s5+KWhg1co87ZZH5QwX
        PXkr7wlw/wCe2PdDPkkVdO9Q1U9RqZpwZYW3ABwelhg9r8nfe3OI7FnfG3UVN6hU6xiFBo
        rl94+wnqVevqzeWXJjpghn237TXTepNefsBLdLDhSFlqmS1MRNJ/v5HDtzagUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=KG53QOGc4VkNL0CVqfZ44CkyO1qKBK0wUzZF8Vb4s2w=;
        b=fAYPn/Ul13vMyZgfICAe6n0Ugo1cMALKXWgM56E5Vm+Wz199U7gp1Hg4c/jLfZgXSkmb0s
        H60/0Wbu7g7CB8AQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 11/21] x86/fpu: Remove fpu::state
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:42 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All users converted. Remove it along with the sanity checks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/types.h |   18 +++++++-----------
 arch/x86/kernel/fpu/init.c       |    4 ----
 2 files changed, 7 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -352,20 +352,16 @@ struct fpu {
 	struct fpstate			*fpstate;
 
 	/*
-	 * @state:
+	 * @__fpstate:
 	 *
-	 * In-memory copy of all FPU registers that we save/restore
-	 * over context switches. If the task is using the FPU then
-	 * the registers in the FPU are more recent than this state
-	 * copy. If the task context-switches away then they get
-	 * saved here and represent the FPU state.
+	 * Initial in-memory storage for FPU registers which are saved in
+	 * context switch and when the kernel uses the FPU. The registers
+	 * are restored from this storage on return to user space if they
+	 * are not longer containing the tasks FPU register state.
 	 */
-	union {
-		struct fpstate			__fpstate;
-		union fpregs_state		state;
-	};
+	struct fpstate			__fpstate;
 	/*
-	 * WARNING: 'state' is dynamically-sized.  Do not put
+	 * WARNING: '__fpstate' is dynamically-sized.  Do not put
 	 * anything after it here.
 	 */
 };
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -184,10 +184,6 @@ static void __init fpu__init_task_struct
 	CHECK_MEMBER_AT_END_OF(struct thread_struct, fpu);
 	CHECK_MEMBER_AT_END_OF(struct task_struct, thread);
 
-	BUILD_BUG_ON(sizeof(struct fpstate) != sizeof(union fpregs_state));
-	BUILD_BUG_ON(offsetof(struct thread_struct, fpu.state) !=
-		     offsetof(struct thread_struct, fpu.__fpstate));
-
 	arch_task_struct_size = task_size;
 }
 

