Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76009473AED
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 03:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244814AbhLNCui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 21:50:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38724 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244802AbhLNCu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 21:50:27 -0500
Message-ID: <20211214024947.991506193@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639450226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Xhob9i26aMnIhu5e3J6big+XhKyBnh5u7ivGf3/wwW4=;
        b=4s92kom1JLvJ8jLDx4GYWxh1/6GU6NqEIX4ziwaEknJusKj4xZODuMsagU3NhAR87sTFck
        abj1JYl09JNUU3QeCi7BFnVn9bi+2mpwelG7Vo7E8oo7uVsgV5Zb3eVORQdtlJCuYZF+Kj
        ZmCj/axlhSl98s0rnUIBRNJjsJ1PGkMODrS9oRZmcN88i6R9gsAr6wAuZ+C9NxH6Z5CONv
        f9TDlPHzb2MGxvgriIofBYqiJHbh+6/sZFU+tAgJR4RfOvUvyNLQGSxG/PtSTNRLsax5wl
        /mDAZfpI/elmzcIT4M++4XRGs4v1iAxLtpEJIT1x/vnM30pmS+pV8KlvZVlviw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639450226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Xhob9i26aMnIhu5e3J6big+XhKyBnh5u7ivGf3/wwW4=;
        b=gq9or/SaClB4Wop6DhJZZK5h9dh6vfcarArpLOiW/1u5ji0oa4Y2xMTzwxjFaXCKOdQYAi
        wnWN3ZF6cqtKNKBA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
References: <20211214022825.563892248@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Dec 2021 03:50:25 +0100 (CET)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest support for dynamically enabling FPU features requires a few
modifications to the enablement function which is currently invoked from
the #NM handler:

  1) Use guest permissions and sizes for the update

  2) Update fpu_guest state accordingly

  3) Take into account that the enabling can be triggered either from a
     running guest via XSETBV and MSR_IA32_XFD write emulation and from
     a guest restore. In the latter case the guests fpstate is not the
     current tasks active fpstate.

Split the function and implement the guest mechanics throughout the
callchain.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
Split out from combo patch. Add fpstate.in_use initialization.
---
 arch/x86/kernel/fpu/xstate.c |   73 ++++++++++++++++++++++---------------------
 arch/x86/kernel/fpu/xstate.h |    2 +
 2 files changed, 41 insertions(+), 34 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1500,35 +1500,13 @@ void fpstate_free(struct fpu *fpu)
 }
 
 /**
- * fpu_install_fpstate - Update the active fpstate in the FPU
- *
- * @fpu:	A struct fpu * pointer
- * @newfps:	A struct fpstate * pointer
- *
- * Returns:	A null pointer if the last active fpstate is the embedded
- *		one or the new fpstate is already installed;
- *		otherwise, a pointer to the old fpstate which has to
- *		be freed by the caller.
- */
-static struct fpstate *fpu_install_fpstate(struct fpu *fpu,
-					   struct fpstate *newfps)
-{
-	struct fpstate *oldfps = fpu->fpstate;
-
-	if (fpu->fpstate == newfps)
-		return NULL;
-
-	fpu->fpstate = newfps;
-	return oldfps != &fpu->__fpstate ? oldfps : NULL;
-}
-
-/**
  * fpstate_realloc - Reallocate struct fpstate for the requested new features
  *
  * @xfeatures:	A bitmap of xstate features which extend the enabled features
  *		of that task
  * @ksize:	The required size for the kernel buffer
  * @usize:	The required size for user space buffers
+ * @guest_fpu:	Pointer to a guest FPU container. NULL for host allocations
  *
  * Note vs. vmalloc(): If the task with a vzalloc()-allocated buffer
  * terminates quickly, vfree()-induced IPIs may be a concern, but tasks
@@ -1537,7 +1515,7 @@ static struct fpstate *fpu_install_fpsta
  * Returns: 0 on success, -ENOMEM on allocation error.
  */
 static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
-			   unsigned int usize)
+			   unsigned int usize, struct fpu_guest *guest_fpu)
 {
 	struct fpu *fpu = &current->thread.fpu;
 	struct fpstate *curfps, *newfps = NULL;
@@ -1553,6 +1531,13 @@ static int fpstate_realloc(u64 xfeatures
 	newfps->user_size = usize;
 	newfps->is_valloc = true;
 
+	if (guest_fpu) {
+		newfps->is_guest = true;
+		newfps->is_confidential = curfps->is_confidential;
+		newfps->in_use = curfps->in_use;
+		guest_fpu->xfeatures |= xfeatures;
+	}
+
 	fpregs_lock();
 	/*
 	 * Ensure that the current state is in the registers before
@@ -1566,15 +1551,25 @@ static int fpstate_realloc(u64 xfeatures
 	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
 	newfps->xfd = curfps->xfd & ~xfeatures;
 
-	curfps = fpu_install_fpstate(fpu, newfps);
-
 	/* Do the final updates within the locked region */
 	xstate_init_xcomp_bv(&newfps->regs.xsave, newfps->xfeatures);
-	xfd_update_state(newfps);
 
+	if (guest_fpu) {
+		curfps = xchg(&guest_fpu->fpstate, newfps);
+		/* If curfps is active, update the FPU fpstate pointer */
+		if (fpu->fpstate == curfps)
+			fpu->fpstate = newfps;
+	} else {
+		curfps = xchg(&fpu->fpstate, newfps);
+	}
+
+	xfd_update_state(fpu->fpstate);
 	fpregs_unlock();
 
-	vfree(curfps);
+	/* Only free valloc'ed state */
+	if (curfps && curfps->is_valloc)
+		vfree(curfps);
+
 	return 0;
 }
 
@@ -1682,14 +1677,16 @@ static int xstate_request_perm(unsigned
 	return ret;
 }
 
-int xfd_enable_feature(u64 xfd_err)
+int __xfd_enable_feature(u64 xfd_err, struct fpu_guest *guest_fpu)
 {
 	u64 xfd_event = xfd_err & XFEATURE_MASK_USER_DYNAMIC;
+	struct fpu_state_perm *perm;
 	unsigned int ksize, usize;
 	struct fpu *fpu;
 
 	if (!xfd_event) {
-		pr_err_once("XFD: Invalid xfd error: %016llx\n", xfd_err);
+		if (!guest_fpu)
+			pr_err_once("XFD: Invalid xfd error: %016llx\n", xfd_err);
 		return 0;
 	}
 
@@ -1697,14 +1694,16 @@ int xfd_enable_feature(u64 xfd_err)
 	spin_lock_irq(&current->sighand->siglock);
 
 	/* If not permitted let it die */
-	if ((xstate_get_host_group_perm() & xfd_event) != xfd_event) {
+	if ((xstate_get_group_perm(!!guest_fpu) & xfd_event) != xfd_event) {
 		spin_unlock_irq(&current->sighand->siglock);
 		return -EPERM;
 	}
 
 	fpu = &current->group_leader->thread.fpu;
-	ksize = fpu->perm.__state_size;
-	usize = fpu->perm.__user_state_size;
+	perm = guest_fpu ? &fpu->guest_perm : &fpu->perm;
+	ksize = perm->__state_size;
+	usize = perm->__user_state_size;
+
 	/*
 	 * The feature is permitted. State size is sufficient.  Dropping
 	 * the lock is safe here even if more features are added from
@@ -1717,10 +1716,16 @@ int xfd_enable_feature(u64 xfd_err)
 	 * Try to allocate a new fpstate. If that fails there is no way
 	 * out.
 	 */
-	if (fpstate_realloc(xfd_event, ksize, usize))
+	if (fpstate_realloc(xfd_event, ksize, usize, guest_fpu))
 		return -EFAULT;
 	return 0;
 }
+
+int xfd_enable_feature(u64 xfd_err)
+{
+	return __xfd_enable_feature(xfd_err, NULL);
+}
+
 #else /* CONFIG_X86_64 */
 static inline int xstate_request_perm(unsigned long idx, bool guest)
 {
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -60,6 +60,8 @@ extern void fpu__init_system_xstate(unsi
 
 extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 
+extern int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu);
+
 static inline u64 xfeatures_mask_supervisor(void)
 {
 	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;

