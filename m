Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427673B7D28
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 08:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhF3GKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 02:10:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:46946 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhF3GKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 02:10:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="195448552"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="195448552"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 23:08:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="455156489"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 29 Jun 2021 23:08:15 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v6 03/26] x86/fpu/xstate: Modify address finders to handle both static and dynamic buffers
Date:   Tue, 29 Jun 2021 23:02:03 -0700
Message-Id: <20210630060226.24652-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210630060226.24652-1-chang.seok.bae@intel.com>
References: <20210630060226.24652-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Have all the functions finding XSTATE address take a struct fpu * pointer
in preparation for dynamic state buffer support.

init_fpstate is a special case, which is indicated by a null pointer
parameter to get_xsave_addr() and __raw_xsave_addr().

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v5:
* Adjusted some call sites for the new base.

Changes from v3:
* Updated the changelog. (Borislav Petkov)
* Updated the function comment to use kernel-doc style. (Borislav Petkov)

Changes from v2:
* Updated the changelog with task->fpu removed. (Borislav Petkov)

Changes from v1:
* Rebased on the upstream kernel (5.10)
---
 arch/x86/include/asm/fpu/xstate.h |  2 +-
 arch/x86/kernel/fpu/xstate.c      | 42 ++++++++++++++++++++++++-------
 arch/x86/kvm/x86.c                | 10 +++-----
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index ede166e9d3f2..2451bccc6cac 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -134,7 +134,7 @@ extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 extern void __init update_regset_xstate_info(unsigned int size,
 					     u64 xstate_mask);
 
-void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
+void *get_xsave_addr(struct fpu *fpu, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
 int copy_uabi_from_kernel_to_xstate(struct fpu *fpu, const void *kbuf);
 int copy_sigframe_from_user_to_xstate(struct fpu *fpu, const void __user *ubuf);
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 59f08953201c..af2adc954578 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -841,19 +841,34 @@ void fpu__resume_cpu(void)
 	}
 }
 
-/*
+/**
+ * __raw_xsave_addr() - Find the address where the feature state is saved.
+ *
  * Given an xstate feature nr, calculate where in the xsave
  * buffer the state is.  Callers should ensure that the buffer
  * is valid.
+ *
+ * If @fpu is NULL, use init_fpstate.
+ *
+ * @fpu:	A struct fpu * pointer
+ *
+ * Return:	An address of the feature state in the buffer
  */
-static void *__raw_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
+static void *__raw_xsave_addr(struct fpu *fpu, int xfeature_nr)
 {
+	void *xsave;
+
 	if (!xfeature_enabled(xfeature_nr)) {
 		WARN_ON_FPU(1);
 		return NULL;
 	}
 
-	return (void *)xsave + xstate_comp_offsets[xfeature_nr];
+	if (fpu)
+		xsave = &fpu->state.xsave;
+	else
+		xsave = &init_fpstate.xsave;
+
+	return xsave + xstate_comp_offsets[xfeature_nr];
 }
 /*
  * Given the xsave area and a state inside, this function returns the
@@ -866,15 +881,18 @@ static void *__raw_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
  * this will return NULL.
  *
  * Inputs:
- *	xstate: the thread's storage area for all FPU data
+ *	fpu: the thread's FPU data to reference xstate buffer(s).
+ *	     (A null pointer parameter indicates init_fpstate.)
  *	xfeature_nr: state which is defined in xsave.h (e.g. XFEATURE_FP,
  *	XFEATURE_SSE, etc...)
  * Output:
  *	address of the state in the xsave area, or NULL if the
  *	field is not present in the xsave buffer.
  */
-void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
+void *get_xsave_addr(struct fpu *fpu, int xfeature_nr)
 {
+	struct xregs_state *xsave;
+
 	/*
 	 * Do we even *have* xsave state?
 	 */
@@ -887,6 +905,12 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 	 */
 	WARN_ONCE(!(xfeatures_mask_all & BIT_ULL(xfeature_nr)),
 		  "get of unsupported state");
+
+	if (fpu)
+		xsave = &fpu->state.xsave;
+	else
+		xsave = &init_fpstate.xsave;
+
 	/*
 	 * This assumes the last 'xsave*' instruction to
 	 * have requested that 'xfeature_nr' be saved.
@@ -901,7 +925,7 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 	if (!(xsave->header.xfeatures & BIT_ULL(xfeature_nr)))
 		return NULL;
 
-	return __raw_xsave_addr(xsave, xfeature_nr);
+	return __raw_xsave_addr(fpu, xfeature_nr);
 }
 EXPORT_SYMBOL_GPL(get_xsave_addr);
 
@@ -1061,8 +1085,8 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 			membuf_write(&to, &pkru, sizeof(pkru));
 		} else {
 			copy_feature(header.xfeatures & BIT_ULL(i), &to,
-				     __raw_xsave_addr(xsave, i),
-				     __raw_xsave_addr(xinit, i),
+				     __raw_xsave_addr(&tsk->thread.fpu, i),
+				     __raw_xsave_addr(NULL, i),
 				     xstate_sizes[i]);
 		}
 		/*
@@ -1129,7 +1153,7 @@ static int copy_uabi_to_xstate(struct fpu *fpu, const void *kbuf,
 		u64 mask = ((u64)1 << i);
 
 		if (hdr.xfeatures & mask) {
-			void *dst = __raw_xsave_addr(xsave, i);
+			void *dst = __raw_xsave_addr(fpu, i);
 
 			offset = xstate_offsets[i];
 			size = xstate_sizes[i];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c3a52f6d490..8c5a328c9631 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4617,7 +4617,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 			memcpy(dest + offset, &vcpu->arch.pkru,
 			       sizeof(vcpu->arch.pkru));
 		} else {
-			src = get_xsave_addr(xsave, xfeature_nr);
+			src = get_xsave_addr(vcpu->arch.guest_fpu, xfeature_nr);
 			if (src)
 				memcpy(dest + offset, src, size);
 		}
@@ -4660,7 +4660,7 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 			memcpy(&vcpu->arch.pkru, src + offset,
 			       sizeof(vcpu->arch.pkru));
 		} else {
-			void *dest = get_xsave_addr(xsave, xfeature_nr);
+			void *dest = get_xsave_addr(vcpu->arch.guest_fpu, xfeature_nr);
 
 			if (dest)
 				memcpy(dest, src + offset, size);
@@ -10498,12 +10498,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		 */
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
-					XFEATURE_BNDREGS);
+		mpx_state_buffer = get_xsave_addr(vcpu->arch.guest_fpu, XFEATURE_BNDREGS);
 		if (mpx_state_buffer)
 			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndreg_state));
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
-					XFEATURE_BNDCSR);
+		mpx_state_buffer = get_xsave_addr(vcpu->arch.guest_fpu, XFEATURE_BNDCSR);
 		if (mpx_state_buffer)
 			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndcsr));
 		if (init_event)
-- 
2.17.1

