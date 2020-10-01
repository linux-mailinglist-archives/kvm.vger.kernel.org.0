Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E472808AF
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbgJAUoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:44:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:58726 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbgJAUm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:42:58 -0400
IronPort-SDR: OxPcjmLujwzBFihNYeTARm7LXUrUznOBIO85BlHeCtrQHBOBysFK7Oj8lweeglT2mahLPT3u+i
 ZRseESIXKSRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="160170707"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="160170707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:42:51 -0700
IronPort-SDR: SaNYuE0iXU5uewmHliv4GyDnOhLuLvHsQHdAPgbTpOPWkJXv2RfIZAd1y2gWMVMEzN7t6QMDFf
 s/ZbKFptNkYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351297034"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 13:42:51 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [RFC PATCH 03/22] x86/fpu/xstate: Modify address finder prototypes to access all the possible areas
Date:   Thu,  1 Oct 2020 13:38:54 -0700
Message-Id: <20201001203913.9125-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001203913.9125-1-chang.seok.bae@intel.com>
References: <20201001203913.9125-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The xstate infrastructure is not flexible to support dynamic areas in
task->fpu. Change the prototype of some address finding functions to access
task->fpu directly. Make changes for both outer and inner helpers:
get_xsave_addr() and __raw_xsave_addr().

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/fpu/internal.h |  2 +-
 arch/x86/include/asm/fpu/xstate.h   |  2 +-
 arch/x86/include/asm/pgtable.h      |  2 +-
 arch/x86/kernel/cpu/common.c        |  2 +-
 arch/x86/kernel/fpu/xstate.c        | 43 ++++++++++++++++++++---------
 arch/x86/kvm/x86.c                  | 26 +++++++++++------
 arch/x86/mm/pkeys.c                 |  2 +-
 7 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index c404fedf1a75..baca80e877a6 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -578,7 +578,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
 	if (current->mm) {
-		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
+		pk = get_xsave_addr(new_fpu, XFEATURE_PKRU);
 		if (pk)
 			pkru_val = pk->pkru;
 	}
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index a315b055212f..3fbf45727ad6 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -100,7 +100,7 @@ extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 extern void __init update_regset_xstate_info(unsigned int size,
 					     u64 xstate_mask);
 
-void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
+void *get_xsave_addr(struct fpu *fpu, int xfeature_nr);
 const void *get_xsave_field_ptr(int xfeature_nr);
 int using_compacted_format(void);
 int xfeature_size(int xfeature_nr);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b836138ce852..e24a8fb8f479 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -142,7 +142,7 @@ static inline void write_pkru(u32 pkru)
 	if (!boot_cpu_has(X86_FEATURE_OSPKE))
 		return;
 
-	pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
+	pk = get_xsave_addr(&current->thread.fpu, XFEATURE_PKRU);
 
 	/*
 	 * The PKRU value in xstate needs to be in sync with the value that is
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d0363e15ec2e..183ee7f77065 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -478,7 +478,7 @@ static __always_inline void setup_pku(struct cpuinfo_x86 *c)
 		return;
 
 	cr4_set_bits(X86_CR4_PKE);
-	pk = get_xsave_addr(&init_fpstate.xsave, XFEATURE_PKRU);
+	pk = get_xsave_addr(NULL, XFEATURE_PKRU);
 	if (pk)
 		pk->pkru = init_pkru_value;
 	/*
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index e3a9bddc39d9..bab22766b79b 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -891,15 +891,23 @@ void fpu__resume_cpu(void)
  * buffer the state is.  Callers should ensure that the buffer
  * is valid.
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
+
 /*
  * Given the xsave area and a state inside, this function returns the
  * address of the state.
@@ -911,15 +919,18 @@ static void *__raw_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
  * this will return NULL.
  *
  * Inputs:
- *	xstate: the thread's storage area for all FPU data
+ *	fpu: the thread's FPU data to access all the FPU state storages.
+	     (If a null pointer is given, assume the init_fpstate)
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
@@ -932,6 +943,12 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
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
@@ -946,7 +963,7 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 	if (!(xsave->header.xfeatures & BIT_ULL(xfeature_nr)))
 		return NULL;
 
-	return __raw_xsave_addr(xsave, xfeature_nr);
+	return __raw_xsave_addr(fpu, xfeature_nr);
 }
 EXPORT_SYMBOL_GPL(get_xsave_addr);
 
@@ -977,7 +994,7 @@ const void *get_xsave_field_ptr(int xfeature_nr)
 	 */
 	fpu__save(fpu);
 
-	return get_xsave_addr(&fpu->state.xsave, xfeature_nr);
+	return get_xsave_addr(fpu, xfeature_nr);
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -1112,7 +1129,7 @@ void copy_xstate_to_kernel(struct membuf to, struct fpu *fpu)
 		 * Copy only in-use xstates:
 		 */
 		if ((header.xfeatures >> i) & 1) {
-			void *src = __raw_xsave_addr(xsave, i);
+			void *src = __raw_xsave_addr(fpu, i);
 
 			copy_part(&to, &last, xstate_offsets[i],
 				  xstate_sizes[i], src);
@@ -1141,13 +1158,11 @@ int copy_kernel_to_xstate(struct fpu *fpu, const void *kbuf)
 	if (validate_user_xstate_header(&hdr))
 		return -EINVAL;
 
-	xsave = &fpu->state.xsave;
-
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = ((u64)1 << i);
 
 		if (hdr.xfeatures & mask) {
-			void *dst = __raw_xsave_addr(xsave, i);
+			void *dst = __raw_xsave_addr(fpu, i);
 
 			offset = xstate_offsets[i];
 			size = xstate_sizes[i];
@@ -1156,6 +1171,8 @@ int copy_kernel_to_xstate(struct fpu *fpu, const void *kbuf)
 		}
 	}
 
+	xsave = &fpu->state.xsave;
+
 	if (xfeatures_mxcsr_quirk(hdr.xfeatures)) {
 		offset = offsetof(struct fxregs_state, mxcsr);
 		size = MXCSR_AND_FLAGS_SIZE;
@@ -1198,13 +1215,11 @@ int copy_user_to_xstate(struct fpu *fpu, const void __user *ubuf)
 	if (validate_user_xstate_header(&hdr))
 		return -EINVAL;
 
-	xsave = &fpu->state.xsave;
-
 	for (i = 0; i < XFEATURE_MAX; i++) {
 		u64 mask = ((u64)1 << i);
 
 		if (hdr.xfeatures & mask) {
-			void *dst = __raw_xsave_addr(xsave, i);
+			void *dst = __raw_xsave_addr(fpu, i);
 
 			offset = xstate_offsets[i];
 			size = xstate_sizes[i];
@@ -1214,6 +1229,8 @@ int copy_user_to_xstate(struct fpu *fpu, const void __user *ubuf)
 		}
 	}
 
+	xsave = &fpu->state.xsave;
+
 	if (xfeatures_mxcsr_quirk(hdr.xfeatures)) {
 		offset = offsetof(struct fxregs_state, mxcsr);
 		size = MXCSR_AND_FLAGS_SIZE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9da8cb4b8589..c4b8d3705625 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4182,10 +4182,15 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
-	u64 xstate_bv = xsave->header.xfeatures;
+	struct xregs_state *xsave;
+	struct fpu *guest_fpu;
+	u64 xstate_bv;
 	u64 valid;
 
+	guest_fpu = vcpu->arch.guest_fpu;
+	xsave = &guest_fpu->state.xsave;
+	xstate_bv = xsave->header.xfeatures;
+
 	/*
 	 * Copy legacy XSAVE area, to avoid complications with CPUID
 	 * leaves 0 and 1 in the loop below.
@@ -4204,7 +4209,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 	while (valid) {
 		u64 xfeature_mask = valid & -valid;
 		int xfeature_nr = fls64(xfeature_mask) - 1;
-		void *src = get_xsave_addr(xsave, xfeature_nr);
+		void *src = get_xsave_addr(guest_fpu, xfeature_nr);
 
 		if (src) {
 			u32 size, offset, ecx, edx;
@@ -4224,10 +4229,14 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 
 static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
 	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
+	struct xregs_state *xsave;
+	struct fpu *guest_fpu;
 	u64 valid;
 
+	guest_fpu = vcpu->arch.guest_fpu;
+	xsave = &guest_fpu->state.xsave;
+
 	/*
 	 * Copy legacy XSAVE area, to avoid complications with CPUID
 	 * leaves 0 and 1 in the loop below.
@@ -4247,7 +4256,7 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	while (valid) {
 		u64 xfeature_mask = valid & -valid;
 		int xfeature_nr = fls64(xfeature_mask) - 1;
-		void *dest = get_xsave_addr(xsave, xfeature_nr);
+		void *dest = get_xsave_addr(guest_fpu, xfeature_nr);
 
 		if (dest) {
 			u32 size, offset, ecx, edx;
@@ -9662,6 +9671,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.apf.halted = false;
 
 	if (kvm_mpx_supported()) {
+		struct fpu *guest_fpu = vcpu->arch.guest_fpu;
 		void *mpx_state_buffer;
 
 		/*
@@ -9670,12 +9680,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		 */
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
-					XFEATURE_BNDREGS);
+		mpx_state_buffer = get_xsave_addr(guest_fpu, XFEATURE_BNDREGS);
 		if (mpx_state_buffer)
 			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndreg_state));
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
-					XFEATURE_BNDCSR);
+		mpx_state_buffer = get_xsave_addr(guest_fpu, XFEATURE_BNDCSR);
 		if (mpx_state_buffer)
 			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndcsr));
 		if (init_event)
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 8873ed1438a9..772e8bc3d49d 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -177,7 +177,7 @@ static ssize_t init_pkru_write_file(struct file *file,
 		return -EINVAL;
 
 	WRITE_ONCE(init_pkru_value, new_init_pkru);
-	pk = get_xsave_addr(&init_fpstate.xsave, XFEATURE_PKRU);
+	pk = get_xsave_addr(NULL, XFEATURE_PKRU);
 	if (!pk)
 		return -EINVAL;
 	pk->pkru = new_init_pkru;
-- 
2.17.1

