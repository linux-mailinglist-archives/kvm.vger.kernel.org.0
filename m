Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88AF46BEB7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhLGPMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:12:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:5480 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhLGPMl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:12:41 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237820979"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237820979"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:09:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461289739"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:05 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 01/19] x86/fpu: Extend prctl() with guest permissions
Date:   Tue,  7 Dec 2021 19:03:41 -0500
Message-Id: <20211208000359.2853257-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Add guest permission control for dynamic XSTATE components, including
extension to prctl() with two new options (ARCH_GET_XCOMP_GUEST_PERM
and ARCH_REQ_XCOMP_GUEST_PERM) and to struct fpu with a new member
(guest_perm).

Userspace VMM has to request guest permissions before it exposes any
XSAVE feature using dynamic XSTATE components. The permission can be
set only once when the first vCPU is created. A new flag
FPU_GUEST_PERM_LOCKED is introduced to lock the change for this purpose

Similar to native permissions this doesn't actually enable the
permitted feature. KVM is expected to install a larger kernel buffer
and enable the feature when detecting the intention from the guest.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
(To Thomas) We change the definition of xstate_get_guest_group_perm()
from xstate.h to api.h since this will be called by KVM.

 arch/x86/include/asm/fpu/api.h    |  2 ++
 arch/x86/include/asm/fpu/types.h  |  9 ++++++
 arch/x86/include/uapi/asm/prctl.h | 26 ++++++++--------
 arch/x86/kernel/fpu/core.c        |  3 ++
 arch/x86/kernel/fpu/xstate.c      | 50 +++++++++++++++++++++++--------
 arch/x86/kernel/fpu/xstate.h      | 13 ++++++--
 arch/x86/kernel/process.c         |  2 ++
 7 files changed, 78 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 6053674f9132..7532f73c82a6 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -138,6 +138,8 @@ static inline void fpstate_free(struct fpu *fpu) { }
 /* fpstate-related functions which are exported to KVM */
 extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
+extern inline u64 xstate_get_guest_group_perm(void);
+
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 3c06c82ab355..6ddf80637697 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -387,6 +387,8 @@ struct fpstate {
 	/* @regs is dynamically sized! Don't add anything after @regs! */
 } __aligned(64);
 
+#define FPU_GUEST_PERM_LOCKED		BIT_ULL(63)
+
 struct fpu_state_perm {
 	/*
 	 * @__state_perm:
@@ -476,6 +478,13 @@ struct fpu {
 	 */
 	struct fpu_state_perm		perm;
 
+	/*
+	 * @guest_perm:
+	 *
+	 * Permission related information for guest pseudo FPUs
+	 */
+	struct fpu_state_perm		guest_perm;
+
 	/*
 	 * @__fpstate:
 	 *
diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
index 754a07856817..500b96e71f18 100644
--- a/arch/x86/include/uapi/asm/prctl.h
+++ b/arch/x86/include/uapi/asm/prctl.h
@@ -2,20 +2,22 @@
 #ifndef _ASM_X86_PRCTL_H
 #define _ASM_X86_PRCTL_H
 
-#define ARCH_SET_GS		0x1001
-#define ARCH_SET_FS		0x1002
-#define ARCH_GET_FS		0x1003
-#define ARCH_GET_GS		0x1004
+#define ARCH_SET_GS			0x1001
+#define ARCH_SET_FS			0x1002
+#define ARCH_GET_FS			0x1003
+#define ARCH_GET_GS			0x1004
 
-#define ARCH_GET_CPUID		0x1011
-#define ARCH_SET_CPUID		0x1012
+#define ARCH_GET_CPUID			0x1011
+#define ARCH_SET_CPUID			0x1012
 
-#define ARCH_GET_XCOMP_SUPP	0x1021
-#define ARCH_GET_XCOMP_PERM	0x1022
-#define ARCH_REQ_XCOMP_PERM	0x1023
+#define ARCH_GET_XCOMP_SUPP		0x1021
+#define ARCH_GET_XCOMP_PERM		0x1022
+#define ARCH_REQ_XCOMP_PERM		0x1023
+#define ARCH_GET_XCOMP_GUEST_PERM	0x1024
+#define ARCH_REQ_XCOMP_GUEST_PERM	0x1025
 
-#define ARCH_MAP_VDSO_X32	0x2001
-#define ARCH_MAP_VDSO_32	0x2002
-#define ARCH_MAP_VDSO_64	0x2003
+#define ARCH_MAP_VDSO_X32		0x2001
+#define ARCH_MAP_VDSO_32		0x2002
+#define ARCH_MAP_VDSO_64		0x2003
 
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 8ea306b1bf8e..ab19b3d8b2f7 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -450,6 +450,8 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
+	/* Same defaults for guests */
+	fpu->guest_perm = fpu->perm;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
@@ -460,6 +462,7 @@ static inline void fpu_inherit_perms(struct fpu *dst_fpu)
 		spin_lock_irq(&current->sighand->siglock);
 		/* Fork also inherits the permissions of the parent */
 		dst_fpu->perm = src_fpu->perm;
+		dst_fpu->guest_perm = src_fpu->guest_perm;
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 }
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d28829403ed0..9856d579aa6e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1595,7 +1595,7 @@ static int validate_sigaltstack(unsigned int usize)
 	return 0;
 }
 
-static int __xstate_request_perm(u64 permitted, u64 requested)
+static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 {
 	/*
 	 * This deliberately does not exclude !XSAVES as we still might
@@ -1605,6 +1605,7 @@ static int __xstate_request_perm(u64 permitted, u64 requested)
 	 */
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XSAVES);
 	struct fpu *fpu = &current->group_leader->thread.fpu;
+	struct fpu_state_perm *perm;
 	unsigned int ksize, usize;
 	u64 mask;
 	int ret;
@@ -1621,15 +1622,18 @@ static int __xstate_request_perm(u64 permitted, u64 requested)
 	mask &= XFEATURE_MASK_USER_SUPPORTED;
 	usize = xstate_calculate_size(mask, false);
 
-	ret = validate_sigaltstack(usize);
-	if (ret)
-		return ret;
+	if (!guest) {
+		ret = validate_sigaltstack(usize);
+		if (ret)
+			return ret;
+	}
 
+	perm = guest ? &fpu->guest_perm : &fpu->perm;
 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
-	WRITE_ONCE(fpu->perm.__state_perm, requested);
+	WRITE_ONCE(perm->__state_perm, requested);
 	/* Protected by sighand lock */
-	fpu->perm.__state_size = ksize;
-	fpu->perm.__user_state_size = usize;
+	perm->__state_size = ksize;
+	perm->__user_state_size = usize;
 	return ret;
 }
 
@@ -1640,7 +1644,7 @@ static const u64 xstate_prctl_req[XFEATURE_MAX] = {
 	[XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE_DATA,
 };
 
-static int xstate_request_perm(unsigned long idx)
+static int xstate_request_perm(unsigned long idx, bool guest)
 {
 	u64 permitted, requested;
 	int ret;
@@ -1661,14 +1665,19 @@ static int xstate_request_perm(unsigned long idx)
 		return -EOPNOTSUPP;
 
 	/* Lockless quick check */
-	permitted = xstate_get_host_group_perm();
+	permitted = xstate_get_group_perm(guest);
 	if ((permitted & requested) == requested)
 		return 0;
 
 	/* Protect against concurrent modifications */
 	spin_lock_irq(&current->sighand->siglock);
-	permitted = xstate_get_host_group_perm();
-	ret = __xstate_request_perm(permitted, requested);
+	permitted = xstate_get_group_perm(guest);
+
+	/* First vCPU allocation locks the permissions. */
+	if (guest && (permitted & FPU_GUEST_PERM_LOCKED))
+		ret = -EBUSY;
+	else
+		ret = __xstate_request_perm(permitted, requested, guest);
 	spin_unlock_irq(&current->sighand->siglock);
 	return ret;
 }
@@ -1713,12 +1722,17 @@ int xfd_enable_feature(u64 xfd_err)
 	return 0;
 }
 #else /* CONFIG_X86_64 */
-static inline int xstate_request_perm(unsigned long idx)
+static inline int xstate_request_perm(unsigned long idx, bool guest)
 {
 	return -EPERM;
 }
 #endif  /* !CONFIG_X86_64 */
 
+inline u64 xstate_get_guest_group_perm(void)
+{
+	return xstate_get_group_perm(true);
+}
+EXPORT_SYMBOL_GPL(xstate_get_guest_group_perm);
 /**
  * fpu_xstate_prctl - xstate permission operations
  * @tsk:	Redundant pointer to current
@@ -1742,6 +1756,7 @@ long fpu_xstate_prctl(struct task_struct *tsk, int option, unsigned long arg2)
 	u64 __user *uptr = (u64 __user *)arg2;
 	u64 permitted, supported;
 	unsigned long idx = arg2;
+	bool guest = false;
 
 	if (tsk != current)
 		return -EPERM;
@@ -1760,11 +1775,20 @@ long fpu_xstate_prctl(struct task_struct *tsk, int option, unsigned long arg2)
 		permitted &= XFEATURE_MASK_USER_SUPPORTED;
 		return put_user(permitted, uptr);
 
+	case ARCH_GET_XCOMP_GUEST_PERM:
+		permitted = xstate_get_guest_group_perm();
+		permitted &= XFEATURE_MASK_USER_SUPPORTED;
+		return put_user(permitted, uptr);
+
+	case ARCH_REQ_XCOMP_GUEST_PERM:
+		guest = true;
+		fallthrough;
+
 	case ARCH_REQ_XCOMP_PERM:
 		if (!IS_ENABLED(CONFIG_X86_64))
 			return -EOPNOTSUPP;
 
-		return xstate_request_perm(idx);
+		return xstate_request_perm(idx, guest);
 
 	default:
 		return -EINVAL;
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 86ea7c0fa2f6..98a472775c97 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -20,10 +20,19 @@ static inline void xstate_init_xcomp_bv(struct xregs_state *xsave, u64 mask)
 		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
 }
 
-static inline u64 xstate_get_host_group_perm(void)
+static inline u64 xstate_get_group_perm(bool guest)
 {
+	struct fpu *fpu = &current->group_leader->thread.fpu;
+	struct fpu_state_perm *perm;
+
 	/* Pairs with WRITE_ONCE() in xstate_request_perm() */
-	return READ_ONCE(current->group_leader->thread.fpu.perm.__state_perm);
+	perm = guest ? &fpu->guest_perm : &fpu->perm;
+	return READ_ONCE(perm->__state_perm);
+}
+
+static inline u64 xstate_get_host_group_perm(void)
+{
+	return xstate_get_group_perm(false);
 }
 
 enum xstate_copy_mode {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 04143a653a8a..d7bc23589062 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -993,6 +993,8 @@ long do_arch_prctl_common(struct task_struct *task, int option,
 	case ARCH_GET_XCOMP_SUPP:
 	case ARCH_GET_XCOMP_PERM:
 	case ARCH_REQ_XCOMP_PERM:
+	case ARCH_GET_XCOMP_GUEST_PERM:
+	case ARCH_REQ_XCOMP_GUEST_PERM:
 		return fpu_xstate_prctl(task, option, arg2);
 	}
 
