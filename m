Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D1746BEE1
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbhLGPNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:13:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:5593 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238201AbhLGPNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:33 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237821257"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237821257"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:10:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461290058"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:09:58 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 14/19] x86/fpu: Prepare for KVM XFD_ERR handling
Date:   Tue,  7 Dec 2021 19:03:54 -0500
Message-Id: <20211208000359.2853257-15-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

When XFD causes an instruction to generate #NM, IA32_XFD_ERR
contains information about which disabled state components
are being accessed. The #NM handler is expected to check this
information and then enable the state components by clearing
IA32_XFD for the faulting task (if having permission).

if the XFD_ERR value generated in guest is consumed/clobbered by
the host before the guest itself doing so. This may lead to
non-XFD-related #NM treated as XFD #NM in host (due to non-zero
value in XFD_ERR), or XFD-related #NM treated as non-XFD #NM in
guest (XFD_ERR cleared by the host #NM handler).

This patch provides two helpers to swap the guest XFD_ERR and host
XFD_ERR. Where to call them in KVM will be discussed thoroughly
in next patch.

The guest XFD_ERR value is saved in fpu_guest::xfd_err. There is
no need to save host XFD_ERR because it's always cleared to ZERO
by the host #NM handler (which cannot be preempted by a vCPU
thread to observe a non-zero value).

The lower two bits in fpu_guest::xfd_err is borrowed for special
purposes. The state components (FP and SSE) covered by the two
bits are not XSAVE-enabled feature, thus not XFD-enabled either.
It's impossible to see hardware setting them in XFD_ERR:

  - XFD_ERR_GUEST_DISABLED (bit 0)

    Indicate that XFD extension is not exposed to the guest thus
    no need to save/restore it.

  - XFD_ERR_GUEST_SAVED (bit 1)

    Indicate fpu_guest::xfd_err already contains a saved value
    thus no need for duplicated saving (e.g. when the vCPU thread
    is preempted multiple times before re-enter the guest).

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/include/asm/fpu/api.h   |  8 ++++++
 arch/x86/include/asm/fpu/types.h | 24 ++++++++++++++++
 arch/x86/kernel/fpu/core.c       | 49 ++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 999d89026be9..c2e8f2172994 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -147,6 +147,14 @@ extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
 
+#ifdef CONFIG_X86_64
+extern void fpu_save_guest_xfd_err(struct fpu_guest *guest_fpu);
+extern void fpu_restore_guest_xfd_err(struct fpu_guest *guest_fpu);
+#else
+static inline void fpu_save_guest_xfd_err(struct fpu_guest *guest_fpu) { }
+static inline void fpu_restore_guest_xfd_err(struct fpu_guest *guest_fpu) { }
+#endif
+
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 861cffca3209..5ee98222c103 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -500,6 +500,22 @@ struct fpu {
 	 */
 };
 
+/*
+ * Use @xfd_err:bit0 to indicate whether guest XFD_ERR should be
+ * saved/restored. The x87 state covered by bit 0 is not a
+ * XSAVE-enabled feature, thus is not XFD-enabled either (won't
+ * occur in XFD_ERR).
+ */
+#define XFD_ERR_GUEST_DISABLED		(1 << XFEATURE_FP)
+
+/*
+ * Use @xfd_err:bit1 to indicate the validity of @xfd_err. Used to
+ * avoid duplicated savings in case the vCPU is preempted multiple
+ * times before it re-enters the guest. The SSE state covered by
+ * bit 1 is neither XSAVE-enabled nor XFD-enabled.
+ */
+#define XFD_ERR_GUEST_SAVED		(1 << XFEATURE_SSE)
+
 /*
  * Guest pseudo FPU container
  */
@@ -527,6 +543,14 @@ struct fpu_guest {
 	 */
 	u64				realloc_request;
 
+	/*
+	 * @xfd_err:			save the guest value. bit 0 and bit1
+	 *				have special meaning to indicate the
+	 *				requirement of saving and the validity
+	 *				of the saved value.
+	 */
+	u64				xfd_err;
+
 	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 7a0436a0cb2c..5089f2e7dc22 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -322,6 +322,55 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
+#ifdef CONFIG_X86_64
+void fpu_save_guest_xfd_err(struct fpu_guest *guest_fpu)
+{
+	if (guest_fpu->xfd_err & XFD_ERR_GUEST_DISABLED)
+		return;
+
+	/* A non-zero value indicates guest XFD_ERR already saved */
+	if (guest_fpu->xfd_err)
+		return;
+
+	/* Guest XFD_ERR must be saved before switching to host fpstate */
+	WARN_ON_ONCE(!current->thread.fpu.fpstate->is_guest);
+
+	rdmsrl(MSR_IA32_XFD_ERR, guest_fpu->xfd_err);
+
+	/*
+	 * Restore to the host value if guest xfd_err is non-zero.
+	 * Except in #NM handler, all other places in the kernel
+	 * should just see xfd_err=0. So just restore to 0.
+	 */
+	if (guest_fpu->xfd_err)
+		wrmsrl(MSR_IA32_XFD_ERR, 0);
+
+	guest_fpu->xfd_err |= XFD_ERR_GUEST_SAVED;
+}
+EXPORT_SYMBOL_GPL(fpu_save_guest_xfd_err);
+
+void fpu_restore_guest_xfd_err(struct fpu_guest *guest_fpu)
+{
+	u64 xfd_err = guest_fpu->xfd_err;
+
+	if (xfd_err & XFD_ERR_GUEST_DISABLED)
+		return;
+
+	xfd_err &= ~XFD_ERR_GUEST_SAVED;
+
+	/*
+	 * No need to restore a zero value since XFD_ERR
+	 * is always zero outside of #NM handler in the host.
+	 */
+	if (!xfd_err)
+		return;
+
+	wrmsrl(MSR_IA32_XFD_ERR, xfd_err);
+	guest_fpu->xfd_err = 0;
+}
+EXPORT_SYMBOL_GPL(fpu_restore_guest_xfd_err);
+#endif
+
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 				    unsigned int size, u32 pkru)
 {
