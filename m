Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6542E5CD
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhJOBSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:05 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46316 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhJOBSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:03 -0400
Message-ID: <20211015011538.493570236@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=820daWr24eERPD7yq1vPcOq80bu7Gqh2gnJkboAilY8=;
        b=z53ZadhVh8vsDDvHU5A/i/6fuZtxC7hf31elMkx2NVRaAhIjJw2q67Mnhzs6olSug/YRL5
        FQ3+cIofFgLm9hx4FcEDAjX6kD+ECW4cf2tdyw1osGpw8QIjBy5PNCYmf0xaC3gP9K2K0Q
        S7C3xhtlf4DQeBCO35jEu/WGLIBqAqgan+aOzSh75BsdIBrITAN8KMFPSgK5HO7vHAXfPu
        /L4TzBHDG4lI9v0ek22wdfekcT+iAFa9okU7GzA4iyK7Cyk/UUQhbndl1kXaU6qTv+g+x6
        atf13KrdqHRIrO3FoB7GKfBtbZHwW05oTqUsEGcE00jB8kVT+ixPfabl+XxkOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=820daWr24eERPD7yq1vPcOq80bu7Gqh2gnJkboAilY8=;
        b=AEPRVCARSRQzAN3pwy/nwh0mp2LFcKPazkvR5+9t3z2g5d5RMpUPFY2HmCOwHNyh2retB9
        bJFuvfjZ0pq4AtCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 02/30] x86/fpu: Update stale comments
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:15:56 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

copy_fpstate_to_sigframe() does not have a slow path anymore. Neither does
the !ia32 restore in __fpu_restore_sig().

Update the comments accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/fpu/signal.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 37dbfed29d75..64f0d4eda0b0 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -155,10 +155,8 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
  *	buf == buf_fx for 64-bit frames and 32-bit fsave frame.
  *	buf != buf_fx for 32-bit frames with fxstate.
  *
- * Try to save it directly to the user frame with disabled page fault handler.
- * If this fails then do the slow path where the FPU state is first saved to
- * task's fpu->state and then copy it to the user frame pointed to by the
- * aligned pointer 'buf_fx'.
+ * Save it directly to the user frame with disabled page fault handler. If
+ * that faults, try to clear the frame which handles the page fault.
  *
  * If this is a 32-bit frame with fxstate, put a fsave header before
  * the aligned state at 'buf_fx'.
@@ -334,12 +332,7 @@ static bool __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 	}
 
 	if (likely(!ia32_fxstate)) {
-		/*
-		 * Attempt to restore the FPU registers directly from user
-		 * memory. For that to succeed, the user access cannot cause page
-		 * faults. If it does, fall back to the slow path below, going
-		 * through the kernel buffer with the enabled pagefault handler.
-		 */
+		/* Restore the FPU registers directly from user memory. */
 		return restore_fpregs_from_user(buf_fx, user_xfeatures, fx_only,
 						state_size);
 	}

