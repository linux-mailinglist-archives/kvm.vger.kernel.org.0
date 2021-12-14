Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA923474342
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 14:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbhLNNPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 08:15:45 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41688 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbhLNNPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 08:15:45 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639487743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Y534tHX2TqPsdgSVQYHGTSXqoz9tYVG5PVyuPDBvjc=;
        b=P+F7bjhojezTxjpWzqnNf70rtCWnHV97U82RZ40bGo8DKI6VxMDFJPsYUugKdxIR+D8rLo
        b89pbOAb2r7ohsgxPNC6LasqyH/q7EAZzkKJAPQo4TSVj37QecsgNgPIscaL8mHq1lLu1Y
        yDPDwNvzWmzAOmPZAGpOiL55vWccSt7600S87SSFj9rcFX/rs9/fXqkVqiFdO1V68OcA9K
        Y4VX4IfuvAE02foHcJzDCD4nQRxB0Th/jKmPRZe5iVs+VQDRTdESz779efmidAebbs1d2C
        8hStASe051iTwAjRooxSnIlslQLAGtxEMZXX9YzWcdbOnl55F6+MP9bUNzU34w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639487743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Y534tHX2TqPsdgSVQYHGTSXqoz9tYVG5PVyuPDBvjc=;
        b=yrNGW3u3ygfj9R1QNG3JLK1LjaoOHR9iLGhW/sHHNZB/10BNzKsGjBVldBz+Bzyz4QX+kj
        t5Qep7PMRnj91yBw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
In-Reply-To: <f49f9358-a903-3ee1-46f8-1662911390ef@redhat.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.991506193@linutronix.de>
 <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f49f9358-a903-3ee1-46f8-1662911390ef@redhat.com>
Date:   Tue, 14 Dec 2021 14:15:43 +0100
Message-ID: <87a6h3tji8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14 2021 at 11:21, Paolo Bonzini wrote:
> On 12/14/21 07:05, Tian, Kevin wrote:
>>> +	if (guest_fpu) {
>>> +		newfps->is_guest = true;
>>> +		newfps->is_confidential = curfps->is_confidential;
>>> +		newfps->in_use = curfps->in_use;
>>> +		guest_fpu->xfeatures |= xfeatures;
>>> +	}
>>> +
>> As you explained guest fpstate is not current active in the restoring
>> path, thus it's not correct to always inherit attributes from the
>> active one.

Good catch!

> Indeed, guest_fpu->fpstate should be used instead of curfps.

Something like the below.

Thanks,

        tglx
---
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
@@ -1537,13 +1515,13 @@ static struct fpstate *fpu_install_fpsta
  * Returns: 0 on success, -ENOMEM on allocation error.
  */
 static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
-			   unsigned int usize)
+			   unsigned int usize, struct fpu_guest *guest_fpu)
 {
 	struct fpu *fpu = &current->thread.fpu;
 	struct fpstate *curfps, *newfps = NULL;
 	unsigned int fpsize;
+	bool in_use;
 
-	curfps = fpu->fpstate;
 	fpsize = ksize + ALIGN(offsetof(struct fpstate, regs), 64);
 
 	newfps = vzalloc(fpsize);
@@ -1553,28 +1531,55 @@ static int fpstate_realloc(u64 xfeatures
 	newfps->user_size = usize;
 	newfps->is_valloc = true;
 
+	/*
+	 * When a guest FPU is supplied, use @guest_fpu->fpstate
+	 * as reference independent whether it is in use or not.
+	 */
+	curfps = guest_fpu ? guest_fpu->fpstate : fpu->fpstate;
+
+	/* Determine whether @curfps is the active fpstate */
+	in_use = fpu->fpstate == curfps;
+
+	if (guest_fpu) {
+		newfps->is_guest = true;
+		newfps->is_confidential = curfps->is_confidential;
+		newfps->in_use = curfps->in_use;
+		guest_fpu->xfeatures |= xfeatures;
+	}
+
 	fpregs_lock();
 	/*
-	 * Ensure that the current state is in the registers before
-	 * swapping fpstate as that might invalidate it due to layout
-	 * changes.
+	 * If @curfps is in use, ensure that the current state is in the
+	 * registers before swapping fpstate as that might invalidate it
+	 * due to layout changes.
 	 */
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+	if (in_use && test_thread_flag(TIF_NEED_FPU_LOAD))
 		fpregs_restore_userregs();
 
 	newfps->xfeatures = curfps->xfeatures | xfeatures;
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
+		if (in_use)
+			fpu->fpstate = newfps;
+	} else {
+		curfps = xchg(&fpu->fpstate, newfps);
+	}
+
+	if (in_use)
+		xfd_update_state(fpu->fpstate);
 	fpregs_unlock();
 
-	vfree(curfps);
+	/* Only free valloc'ed state */
+	if (curfps && curfps->is_valloc)
+		vfree(curfps);
+
 	return 0;
 }
 
@@ -1682,14 +1687,16 @@ static int xstate_request_perm(unsigned
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
 
@@ -1697,14 +1704,16 @@ int xfd_enable_feature(u64 xfd_err)
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
@@ -1717,10 +1726,16 @@ int xfd_enable_feature(u64 xfd_err)
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

