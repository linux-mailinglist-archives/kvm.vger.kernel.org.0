Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B000E473AE8
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 03:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhLNCu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 21:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244795AbhLNCuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 21:50:25 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F123AC06173F;
        Mon, 13 Dec 2021 18:50:24 -0800 (PST)
Message-ID: <20211214024947.818549574@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639450221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=fJxzP8wFoqTPFAbKqbp6U1FvjxOS3qQgs3MEqow/2YY=;
        b=x+R+2a7MO4B3p0rWEeTTbTnskMqBD+URy1YvDTqRCsdDAyzCBR+BkAz+ItLhSHHuNMnO2A
        IqrmThzgudykmoI5O6ItnpIsP4IDlijzTEWaI/f8EZ5CmEZcrI4FxyXGvmSFZzRUbsYkkO
        RbjMLUjrTbKHNHB4jbaLF9+9TYa5uoRdpXH/rnl9j/15oeRePXch7+2kbcgMozCSMukvvj
        bc7V4WeTth7hmPLHDlHRnJdmlv+miQKCQmYNE/QkBPXeFSjHEFJsgBb4tD3JQ2M/GWR0rJ
        gRPaE7dQQ+gXMPS95/t4Hxpz7R0xpuvPex9h9Lq8Y7ZgPf1LoE3k+6/upzI2WA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639450221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=fJxzP8wFoqTPFAbKqbp6U1FvjxOS3qQgs3MEqow/2YY=;
        b=jYwXP4w/5mEt/sUg+nbbLh+iAyZg+8yAPsd290o0cBC680sFk6fIzNaj0y4uOtUh2IFbl/
        nvs7mOKMPUzUmiBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [patch 1/6] x86/fpu: Extend fpu_xstate_prctl() with guest permissions
References: <20211214022825.563892248@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Dec 2021 03:50:21 +0100 (CET)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires a clear separation of host user space and guest permissions
for dynamic XSTATE components.

Add a guest permissions member to struct fpu and a separate set of prctl()
arguments: ARCH_GET_XCOMP_GUEST_PERM and ARCH_REQ_XCOMP_GUEST_PERM.

The semantics are equivalent to the host user space permission control
except for the following constraints:

  1) Permissions have to be requested before the first vCPU is created

  2) Permissions are frozen when the first vCPU is created to ensure
     consistency. Any attempt to expand permissions via the prctl() after
     that point is rejected.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/types.h  |    9 +++++++
 arch/x86/include/uapi/asm/prctl.h |   26 +++++++++++----------
 arch/x86/kernel/fpu/core.c        |    3 ++
 arch/x86/kernel/fpu/xstate.c      |   45 +++++++++++++++++++++++++++-----------
 arch/x86/kernel/fpu/xstate.h      |   18 +++++++++++++--
 arch/x86/kernel/process.c         |    2 +
 6 files changed, 76 insertions(+), 27 deletions(-)

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
@@ -477,6 +479,13 @@ struct fpu {
 	struct fpu_state_perm		perm;
 
 	/*
+	 * @guest_perm:
+	 *
+	 * Permission related information for guest pseudo FPUs
+	 */
+	struct fpu_state_perm		guest_perm;
+
+	/*
 	 * @__fpstate:
 	 *
 	 * Initial in-memory storage for FPU registers which are saved in
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
@@ -460,6 +462,7 @@ static inline void fpu_inherit_perms(str
 		spin_lock_irq(&current->sighand->siglock);
 		/* Fork also inherits the permissions of the parent */
 		dst_fpu->perm = src_fpu->perm;
+		dst_fpu->guest_perm = src_fpu->guest_perm;
 		spin_unlock_irq(&current->sighand->siglock);
 	}
 }
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1595,7 +1595,7 @@ static int validate_sigaltstack(unsigned
 	return 0;
 }
 
-static int __xstate_request_perm(u64 permitted, u64 requested)
+static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 {
 	/*
 	 * This deliberately does not exclude !XSAVES as we still might
@@ -1605,6 +1605,7 @@ static int __xstate_request_perm(u64 per
 	 */
 	bool compacted = cpu_feature_enabled(X86_FEATURE_XSAVES);
 	struct fpu *fpu = &current->group_leader->thread.fpu;
+	struct fpu_state_perm *perm;
 	unsigned int ksize, usize;
 	u64 mask;
 	int ret;
@@ -1621,15 +1622,18 @@ static int __xstate_request_perm(u64 per
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
 
@@ -1640,7 +1644,7 @@ static const u64 xstate_prctl_req[XFEATU
 	[XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE_DATA,
 };
 
-static int xstate_request_perm(unsigned long idx)
+static int xstate_request_perm(unsigned long idx, bool guest)
 {
 	u64 permitted, requested;
 	int ret;
@@ -1661,14 +1665,19 @@ static int xstate_request_perm(unsigned
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
@@ -1713,7 +1722,7 @@ int xfd_enable_feature(u64 xfd_err)
 	return 0;
 }
 #else /* CONFIG_X86_64 */
-static inline int xstate_request_perm(unsigned long idx)
+static inline int xstate_request_perm(unsigned long idx, bool guest)
 {
 	return -EPERM;
 }
@@ -1742,6 +1751,7 @@ long fpu_xstate_prctl(struct task_struct
 	u64 __user *uptr = (u64 __user *)arg2;
 	u64 permitted, supported;
 	unsigned long idx = arg2;
+	bool guest = false;
 
 	if (tsk != current)
 		return -EPERM;
@@ -1760,11 +1770,20 @@ long fpu_xstate_prctl(struct task_struct
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
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -20,10 +20,24 @@ static inline void xstate_init_xcomp_bv(
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
+}
+
+static inline u64 xstate_get_guest_group_perm(void)
+{
+	return xstate_get_group_perm(true);
 }
 
 enum xstate_copy_mode {
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -993,6 +993,8 @@ long do_arch_prctl_common(struct task_st
 	case ARCH_GET_XCOMP_SUPP:
 	case ARCH_GET_XCOMP_PERM:
 	case ARCH_REQ_XCOMP_PERM:
+	case ARCH_GET_XCOMP_GUEST_PERM:
+	case ARCH_REQ_XCOMP_GUEST_PERM:
 		return fpu_xstate_prctl(task, option, arg2);
 	}
 

