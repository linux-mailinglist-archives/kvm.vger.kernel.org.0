Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5495473AEE
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 03:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244847AbhLNCul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 21:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244826AbhLNCu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 21:50:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A746C061574;
        Mon, 13 Dec 2021 18:50:29 -0800 (PST)
Message-ID: <20211214024948.048572883@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639450227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=KTh/MmV1NCI2VEvu8uI5K9xmC/2WyQ2j+jnNgVOSLT8=;
        b=wM2coTx6Z4ewf2DL0BjWj/ed7LRCX+j2DxqO8RCJ7jU2/TUIAntmU8RR9KEJYoSem1FSJi
        Q2pD3MlEzlNmvPoCSrETbQ/LdWj5XKHUl4UnBWUZdEdFS4sOBHRZCYvPbMDjyQvJ2zwq/7
        DrP7sIlkeOB0hbeUVCQh9qUsLZt776quqzgfcm7GS5ErtoY2vGDuR4JunqIw8QKD5K60o2
        afYh35R4ROKem/5mgPgzJS5g29apDTFuUcQB8IpWr+r1TqxuXBx5ySxJ/q0EB+B/wQifeW
        uOx8882+Gui1XF+m+bZ+wGwEaGVhEpWWUERsJK00JotOxS5t8mUVSZRXjhuzgg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639450227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=KTh/MmV1NCI2VEvu8uI5K9xmC/2WyQ2j+jnNgVOSLT8=;
        b=dFDey59X+3bPFQm33CFo+zocO1z9tezXaDdyu0O1dB+CaJ+aKrVp6eFEH73q5R7FMFijxt
        Zx7GSBJe7cupcfCA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
References: <20211214022825.563892248@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Dec 2021 03:50:27 +0100 (CET)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM can require fpstate expansion due to updates to XCR0 and to the XFD
MSR. In both cases it is required to check whether:

  - the requested values are correct or permitted

  - the resulting xfeature mask which is relevant for XSAVES is a subset of
    the guests fpstate xfeature mask for which the register buffer is sized.

    If the feature mask does not fit into the guests fpstate then
    reallocation is required.

Provide a common update function which utilizes the existing XFD enablement
mechanics and two wrapper functions, one for XCR0 and one for XFD.

These wrappers have to be invoked from XSETBV emulation and the XFD MSR
write emulation.

XCR0 modification can only proceed when fpu_update_guest_xcr0() returns
success.

XFD modification is done by the FPU core code as it requires to update the
software state as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
New version to handle the restore case and XCR0 updates correctly.
---
 arch/x86/include/asm/fpu/api.h |   57 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c     |   57 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -136,6 +136,63 @@ extern void fpstate_clear_xstate_compone
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
+extern int __fpu_update_guest_features(struct fpu_guest *guest_fpu, u64 xcr0, u64 xfd);
+
+/**
+ * fpu_update_guest_xcr0 - Update guest XCR0 from XSETBV emulation
+ * @guest_fpu:	Pointer to the guest FPU container
+ * @xcr0:	Requested guest XCR0
+ *
+ * Has to be invoked before making the guest XCR0 update effective. The
+ * function validates that the requested features are permitted and ensures
+ * that @guest_fpu->fpstate is properly sized taking @guest_fpu->fpstate->xfd
+ * into account.
+ *
+ * If @guest_fpu->fpstate is not the current tasks active fpstate then the
+ * caller has to ensure that @guest_fpu->fpstate cannot be concurrently in
+ * use, i.e. the guest restore case.
+ *
+ * Return:
+ * 0		- Success
+ * -EPERM	- Feature(s) not permitted
+ * -EFAULT	- Resizing of fpstate failed
+ */
+static inline int fpu_update_guest_xcr0(struct fpu_guest *guest_fpu, u64 xcr0)
+{
+	return __fpu_update_guest_features(guest_fpu, xcr0, guest_fpu->fpstate->xfd);
+}
+
+/**
+ * fpu_update_guest_xfd - Update guest XFD from MSR write emulation
+ * @guest_fpu:	Pointer to the guest FPU container
+ * @xcr0:	Current guest XCR0
+ * @xfd:	Requested XFD value
+ *
+ * Has to be invoked to make the guest XFD update effective. The function
+ * validates the XFD value and ensures that @guest_fpu->fpstate is properly
+ * sized by taking @xcr0 into account.
+ *
+ * The caller must not modify @guest_fpu->fpstate->xfd or the XFD MSR
+ * directly.
+ *
+ * If @guest_fpu->fpstate is not the current tasks active fpstate then the
+ * caller has to ensure that @guest_fpu->fpstate cannot be concurrently in
+ * use, i.e. the guest restore case.
+ *
+ * On success the buffer size is valid, @guest_fpu->fpstate.xfd == @xfd and
+ * if the guest fpstate is active then MSR_IA32_XFD == @xfd.
+ *
+ * On failure the previous state is retained.
+ *
+ * Return:
+ * 0		- Success
+ * -ENOTSUPP	- XFD value not supported
+ * -EFAULT	- Resizing of fpstate failed
+ */
+static inline int fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xcr0, u64 xfd)
+{
+	return __fpu_update_guest_features(guest_fpu, xcr0, xfd);
+}
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -261,6 +261,63 @@ void fpu_free_guest_fpstate(struct fpu_g
 }
 EXPORT_SYMBOL_GPL(fpu_free_guest_fpstate);
 
+/**
+ * __fpu_update_guest_features - Validate and enable guest XCR0 and XFD updates
+ * @guest_fpu:	Pointer to the guest FPU container
+ * @xcr0:	Guest XCR0
+ * @xfd:	Guest XFD
+ *
+ * Note: @xcr0 and @xfd must either be the already validated values or the
+ * requested values (guest emulation or host write on restore).
+ *
+ * Do not invoke directly. Use the provided wrappers fpu_validate_guest_xcr0()
+ * and fpu_update_guest_xfd() instead.
+ *
+ * Return: 0 on success, error code otherwise
+ */
+int __fpu_update_guest_features(struct fpu_guest *guest_fpu, u64 xcr0, u64 xfd)
+{
+	u64 expand, requested;
+
+	lockdep_assert_preemption_enabled();
+
+	/* Only permitted features are allowed in XCR0 */
+	if (xcr0 & ~guest_fpu->perm)
+		return -EPERM;
+
+	/* Check for unsupported XFD values */
+	if (xfd & ~XFEATURE_MASK_USER_DYNAMIC || xfd & ~fpu_user_cfg.max_features)
+		return -ENOTSUPP;
+
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return 0;
+
+	/*
+	 * The requested features are set in XCR0 and not set in XFD.
+	 * Feature expansion is required when the requested features are
+	 * not a subset of the xfeatures for which @guest_fpu->fpstate
+	 * is sized.
+	 */
+	requested = xcr0 & ~xfd;
+	expand = requested & ~guest_fpu->xfeatures;
+	if (!expand) {
+		/*
+		 * fpstate size is correct, update the XFD value in fpstate
+		 * and if @guest_fpu->fpstate is active also the per CPU
+		 * cache and the MSR.
+		 */
+		fpregs_lock();
+		guest_fpu->fpstate->xfd = xfd;
+		if (guest_fpu->fpstate->in_use)
+			xfd_update_state(guest_fpu->fpstate);
+		fpregs_unlock();
+		return 0;
+	}
+
+	return __xfd_enable_feature(expand, guest_fpu);
+}
+EXPORT_SYMBOL_GPL(__fpu_update_guest_features);
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
 	struct fpstate *guest_fps = guest_fpu->fpstate;

