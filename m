Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB45487C80
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbiAGSz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:55:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbiAGSzZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nzSEd8Ogpx3OLkc84xK+Y1cLXlnrtVT7x26yWF5SArg=;
        b=AXNU7W5L0aCFAp3Vx2FJy1aVPLe1dOQZU5doXdDUlmRdKepqM1FqMyX1M9EJdiLd2ah9GC
        gda2OP/uDcaHb4F7O2zJApjS//aWcyOqjfPd67LT6s8UdlrV+qDDN+G+zbpeONluTX9iOZ
        SGxcAcecvhXRAbyvGtaCQX5Mp23t7Z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-HmUly594OHeE_DDcKdO0pA-1; Fri, 07 Jan 2022 13:55:21 -0500
X-MC-Unique: HmUly594OHeE_DDcKdO0pA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74EC064A7A;
        Fri,  7 Jan 2022 18:55:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CF9F838F0;
        Fri,  7 Jan 2022 18:55:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 06/21] x86/fpu: Add guest support to xfd_enable_feature()
Date:   Fri,  7 Jan 2022 13:54:57 -0500
Message-Id: <20220107185512.25321-7-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Guest support for dynamically enabled FPU features requires a few
modifications to the enablement function which is currently invoked from
the #NM handler:

  1) Use guest permissions and sizes for the update

  2) Update fpu_guest state accordingly

  3) Take into account that the enabling can be triggered either from a
     running guest via XSETBV and MSR_IA32_XFD write emulation or from
     a guest restore. In the latter case the guests fpstate is not the
     current tasks active fpstate.

Split the function and implement the guest mechanics throughout the
callchain.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-7-yang.zhong@intel.com>
[Add 32-bit stub for __xfd_enable_feature. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/fpu/xstate.c | 93 +++++++++++++++++++++---------------
 arch/x86/kernel/fpu/xstate.h |  6 +++
 2 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 5f01d463859d..0c0b2323cdec 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1499,29 +1499,6 @@ void fpstate_free(struct fpu *fpu)
 		vfree(fpu->fpstate);
 }
 
-/**
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
 /**
  * fpstate_realloc - Reallocate struct fpstate for the requested new features
  *
@@ -1529,6 +1506,7 @@ static struct fpstate *fpu_install_fpstate(struct fpu *fpu,
  *		of that task
  * @ksize:	The required size for the kernel buffer
  * @usize:	The required size for user space buffers
+ * @guest_fpu:	Pointer to a guest FPU container. NULL for host allocations
  *
  * Note vs. vmalloc(): If the task with a vzalloc()-allocated buffer
  * terminates quickly, vfree()-induced IPIs may be a concern, but tasks
@@ -1537,13 +1515,13 @@ static struct fpstate *fpu_install_fpstate(struct fpu *fpu,
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
@@ -1553,28 +1531,55 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
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
+		guest_fpu->fpstate = newfps;
+		/* If curfps is active, update the FPU fpstate pointer */
+		if (in_use)
+			fpu->fpstate = newfps;
+	} else {
+		fpu->fpstate = newfps;
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
 
@@ -1682,14 +1687,16 @@ static int xstate_request_perm(unsigned long idx, bool guest)
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
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 98a472775c97..67ed6bbc19b8 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -158,8 +158,14 @@ static inline void xfd_update_state(struct fpstate *fpstate)
 		}
 	}
 }
+
+extern int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu);
 #else
 static inline void xfd_update_state(struct fpstate *fpstate) { }
+
+static inline int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu) {
+	return -EPERM;
+}
 #endif
 
 /*
-- 
2.31.1


