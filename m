Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED4A429A2E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhJLAJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbhJLAI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41099C06161C;
        Mon, 11 Oct 2021 17:06:27 -0700 (PDT)
Message-ID: <20211011223610.404292507@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=EFhq4BlDAnV4q8GVsDZZiqlvWQFfxiu85EHWBzdICcc=;
        b=VCNQ0YYqHaHhvR6GAnFWkdWVKikPaplqds9wAmKjS/2xCPbmC63V4rn8t76+jiSQ6l3eJy
        zKR2EvMVeCS38BTAJjoIsebbL5ABSJU2Vp0CWS1ISyr3fAyPC0GKrHJuoUEyIbF9O3BB0d
        5IXV36pdUaqQn3t+0mLaXE9LnrP2UHDfwqJsjmJsFDujew/+tbx7hZDX40iGAUh+CGKJnG
        ysXI2IFv9v2MkWz9583q8Jt3QxXZt/I63S91rGNyBsnjmXdjTjskbpH2+MqpBztw9NqLiS
        o+L+Rtq8iNi3gycnPsS60e9++9pkB/xFXN0ep9LxHqHiUDsc7958oKPUgvh6fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=EFhq4BlDAnV4q8GVsDZZiqlvWQFfxiu85EHWBzdICcc=;
        b=CV8UjHd/t1bsVIIXwU4JXiPd5LH4dqDOMlNC0DxsNjXzgU5yx/iaLlGKXHXLDAJ2YQxGeL
        h5WoxoGIbEHGvSDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 02/31] x86/fpu: Update stale comments
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:00 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

copy_fpstate_to_sigframe() does not have a slow path anymore. Neither does
the !ia32 restore in __fpu_restore_sig().

Update the comments accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/signal.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -155,10 +155,8 @@ static inline int copy_fpregs_to_sigfram
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
@@ -334,12 +332,7 @@ static bool __fpu_restore_sig(void __use
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

