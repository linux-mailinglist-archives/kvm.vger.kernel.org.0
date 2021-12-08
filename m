Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A2F46BEC1
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhLGPNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238582AbhLGPNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821089"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821089"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289817"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:26 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 06/19] x86/fpu: Add reallocation mechanims for KVM
Date:   Tue,  7 Dec 2021 19:03:46 -0500
Message-Id: <20211208000359.2853257-7-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Extend fpstate reallocation mechanism to cover guest fpu. Unlike native
tasks which have reallocation triggered from #NM handler, guest fpstate
reallocation is requested by KVM when detecting the guest intention
on using a dynamically-enabled XSAVE feature.

Since KVM currently swaps host/guest fpstate when exiting to userspace
VMM (see fpu_swap_kvm_fpstate()), deal with fpstate reallocation also
at this point.

The implication - KVM must break vcpu_run() loop to exit to userspace
VMM instead of immediately returning back to the guest when fpstate
requires reallocation. In this case KVM should set
guest_fpu::realloc_request to mark those features in related VM exit
handlers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kernel/fpu/core.c   | 26 +++++++++++++++++++---
 arch/x86/kernel/fpu/xstate.c | 43 ++++++++++++++++++++++++++++++------
 arch/x86/kernel/fpu/xstate.h |  2 ++
 3 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index fae44fa27cdb..7a0436a0cb2c 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -261,11 +261,31 @@ void fpu_free_guest_fpstate(struct fpu_guest *gfpu)
 }
 EXPORT_SYMBOL_GPL(fpu_free_guest_fpstate);
 
+static int fpu_guest_realloc_fpstate(struct fpu_guest *guest_fpu,
+				     bool enter_guest)
+{
+	/*
+	 * Reallocation requests can only be handled when
+	 * switching from guest to host mode.
+	 */
+	if (WARN_ON_ONCE(enter_guest || !IS_ENABLED(CONFIG_X86_64))) {
+		guest_fpu->realloc_request = 0;
+		return -EUNATCH;
+	}
+	return xfd_enable_guest_features(guest_fpu);
+}
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
-	struct fpstate *guest_fps = guest_fpu->fpstate;
+	struct fpstate *guest_fps, *cur_fps;
 	struct fpu *fpu = &current->thread.fpu;
-	struct fpstate *cur_fps = fpu->fpstate;
+	int ret = 0;
+
+	if (unlikely(guest_fpu->realloc_request))
+		ret = fpu_guest_realloc_fpstate(guest_fpu, enter_guest);
+
+	guest_fps = guest_fpu->fpstate;
+	cur_fps = fpu->fpstate;
 
 	fpregs_lock();
 	if (!cur_fps->is_confidential && !test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -298,7 +318,7 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 9856d579aa6e..fe3d8ed3db0e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1529,6 +1529,7 @@ static struct fpstate *fpu_install_fpstate(struct fpu *fpu,
  *		of that task
  * @ksize:	The required size for the kernel buffer
  * @usize:	The required size for user space buffers
+ * @guest_fpu:	Pointer to a guest FPU container. NULL for host allocations
  *
  * Note vs. vmalloc(): If the task with a vzalloc()-allocated buffer
  * terminates quickly, vfree()-induced IPIs may be a concern, but tasks
@@ -1537,7 +1538,7 @@ static struct fpstate *fpu_install_fpstate(struct fpu *fpu,
  * Returns: 0 on success, -ENOMEM on allocation error.
  */
 static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
-			   unsigned int usize)
+			   unsigned int usize, struct fpu_guest *guest_fpu)
 {
 	struct fpu *fpu = &current->thread.fpu;
 	struct fpstate *curfps, *newfps = NULL;
@@ -1553,6 +1554,12 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
 	newfps->user_size = usize;
 	newfps->is_valloc = true;
 
+	if (guest_fpu) {
+		newfps->is_guest = true;
+		newfps->is_confidential = curfps->is_confidential;
+		guest_fpu->user_xfeatures |= xfeatures;
+	}
+
 	fpregs_lock();
 	/*
 	 * Ensure that the current state is in the registers before
@@ -1566,12 +1573,14 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
 	newfps->user_xfeatures = curfps->user_xfeatures | xfeatures;
 	newfps->xfd = curfps->xfd & ~xfeatures;
 
+	if (guest_fpu)
+		guest_fpu->fpstate = newfps;
+
 	curfps = fpu_install_fpstate(fpu, newfps);
 
 	/* Do the final updates within the locked region */
 	xstate_init_xcomp_bv(&newfps->regs.xsave, newfps->xfeatures);
 	xfd_update_state(newfps);
-
 	fpregs_unlock();
 
 	vfree(curfps);
@@ -1682,9 +1691,10 @@ static int xstate_request_perm(unsigned long idx, bool guest)
 	return ret;
 }
 
-int xfd_enable_feature(u64 xfd_err)
+static int __xfd_enable_feature(u64 xfd_err, struct fpu_guest *guest_fpu)
 {
 	u64 xfd_event = xfd_err & XFEATURE_MASK_USER_DYNAMIC;
+	struct fpu_state_perm *perm;
 	unsigned int ksize, usize;
 	struct fpu *fpu;
 
@@ -1697,14 +1707,16 @@ int xfd_enable_feature(u64 xfd_err)
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
@@ -1717,10 +1729,27 @@ int xfd_enable_feature(u64 xfd_err)
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
+int xfd_enable_guest_features(struct fpu_guest *guest_fpu)
+{
+	u64 xfd_err = guest_fpu->realloc_request & XFEATURE_MASK_USER_SUPPORTED;
+
+	guest_fpu->realloc_request = 0;
+
+	if (!xfd_err)
+		return 0;
+	return __xfd_enable_feature(xfd_err, guest_fpu);
+}
+
 #else /* CONFIG_X86_64 */
 static inline int xstate_request_perm(unsigned long idx, bool guest)
 {
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 98a472775c97..3254e2b5f17f 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -55,6 +55,8 @@ extern void fpu__init_system_xstate(unsigned int legacy_size);
 
 extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 
+extern int xfd_enable_guest_features(struct fpu_guest *guest_fpu);
+
 static inline u64 xfeatures_mask_supervisor(void)
 {
 	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
