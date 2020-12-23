Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B26B2E1F1E
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 17:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgLWQCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 11:02:42 -0500
Received: from mga12.intel.com ([192.55.52.136]:48955 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgLWQCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 11:02:37 -0500
IronPort-SDR: 5nIQ91golwfchmcoQacwZNdGjYRpjuszv/NL99/r2RrAzfOrGaf4pvdjv0fDdMqDW5qwDOKVWh
 8I+FRW0RI3+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="155241861"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="155241861"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 08:01:37 -0800
IronPort-SDR: 2bEND8Bc9Ac5/Xl8yP3w9v0/SwK6qXu9BPshB1Mq64qYGp97rmohPJk8/KOIC8Y9/sj1hiKybJ
 FmJMqxDioigA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="458027927"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2020 08:01:37 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 03/21] x86/fpu/xstate: Modify address finders to handle both static and dynamic buffers
Date:   Wed, 23 Dec 2020 07:56:59 -0800
Message-Id: <20201223155717.19556-4-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223155717.19556-1-chang.seok.bae@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for dynamic xstate buffer expansion, update the buffer
address finder function parameters to equally handle static in-line xstate
buffer, as well as dynamically allocated xstate buffer.

init_fpstate is a special case, which is indicated by a null pointer
parameter to get_xsave_addr() and __raw_xsave_addr().

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v2:
* Updated the changelog with task->fpu removed. (Boris Petkov)

Changes from v1:
* Rebased on the upstream kernel (5.10)
---
 arch/x86/include/asm/fpu/internal.h |  2 +-
 arch/x86/include/asm/fpu/xstate.h   |  2 +-
 arch/x86/include/asm/pgtable.h      |  2 +-
 arch/x86/kernel/cpu/common.c        |  2 +-
 arch/x86/kernel/fpu/xstate.c        | 50 +++++++++++++++++++----------
 arch/x86/kvm/x86.c                  | 26 +++++++++------
 arch/x86/mm/pkeys.c                 |  2 +-
 7 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index d81d8c407dc0..0153c4d4ca77 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -579,7 +579,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
 	if (current->mm) {
-		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
+		pk = get_xsave_addr(new_fpu, XFEATURE_PKRU);
 		if (pk)
 			pkru_val = pk->pkru;
 	}
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index e0f1b22f53ce..24bf8d3f559a 100644
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
index a02c67291cfc..83268b41444f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -141,7 +141,7 @@ static inline void write_pkru(u32 pkru)
 	if (!boot_cpu_has(X86_FEATURE_OSPKE))
 		return;
 
-	pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
+	pk = get_xsave_addr(&current->thread.fpu, XFEATURE_PKRU);
 
 	/*
 	 * The PKRU value in xstate needs to be in sync with the value that is
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35ad8480c464..860b19db208b 100644
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
index 6156dad0feb6..2010c31d25e1 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -894,15 +894,24 @@ void fpu__resume_cpu(void)
  * Given an xstate feature nr, calculate where in the xsave
  * buffer the state is.  Callers should ensure that the buffer
  * is valid.
+ *
+ * A null pointer parameter indicates to use init_fpstate.
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
@@ -915,15 +924,18 @@ static void *__raw_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
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
@@ -936,6 +948,12 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
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
@@ -950,7 +968,7 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 	if (!(xsave->header.xfeatures & BIT_ULL(xfeature_nr)))
 		return NULL;
 
-	return __raw_xsave_addr(xsave, xfeature_nr);
+	return __raw_xsave_addr(fpu, xfeature_nr);
 }
 EXPORT_SYMBOL_GPL(get_xsave_addr);
 
@@ -981,7 +999,7 @@ const void *get_xsave_field_ptr(int xfeature_nr)
 	 */
 	fpu__save(fpu);
 
-	return get_xsave_addr(&fpu->state.xsave, xfeature_nr);
+	return get_xsave_addr(fpu, xfeature_nr);
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -1116,7 +1134,7 @@ void copy_xstate_to_kernel(struct membuf to, struct fpu *fpu)
 		 * Copy only in-use xstates:
 		 */
 		if ((header.xfeatures >> i) & 1) {
-			void *src = __raw_xsave_addr(xsave, i);
+			void *src = __raw_xsave_addr(fpu, i);
 
 			copy_part(&to, &last, xstate_offsets[i],
 				  xstate_sizes[i], src);
@@ -1145,13 +1163,11 @@ int copy_kernel_to_xstate(struct fpu *fpu, const void *kbuf)
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
@@ -1160,6 +1176,8 @@ int copy_kernel_to_xstate(struct fpu *fpu, const void *kbuf)
 		}
 	}
 
+	xsave = &fpu->state.xsave;
+
 	if (xfeatures_mxcsr_quirk(hdr.xfeatures)) {
 		offset = offsetof(struct fxregs_state, mxcsr);
 		size = MXCSR_AND_FLAGS_SIZE;
@@ -1202,13 +1220,11 @@ int copy_user_to_xstate(struct fpu *fpu, const void __user *ubuf)
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
@@ -1218,6 +1234,8 @@ int copy_user_to_xstate(struct fpu *fpu, const void __user *ubuf)
 		}
 	}
 
+	xsave = &fpu->state.xsave;
+
 	if (xfeatures_mxcsr_quirk(hdr.xfeatures)) {
 		offset = offsetof(struct fxregs_state, mxcsr);
 		size = MXCSR_AND_FLAGS_SIZE;
@@ -1441,16 +1459,14 @@ void update_pasid(void)
 	} else {
 		struct fpu *fpu = &current->thread.fpu;
 		struct ia32_pasid_state *ppasid_state;
-		struct xregs_state *xsave;
 
 		/*
 		 * The CPU's xstate registers are not currently active. Just
 		 * update the PASID state in the memory buffer here. The
 		 * PASID MSR will be loaded when returning to user mode.
 		 */
-		xsave = &fpu->state.xsave;
-		xsave->header.xfeatures |= XFEATURE_MASK_PASID;
-		ppasid_state = get_xsave_addr(xsave, XFEATURE_PASID);
+		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_PASID;
+		ppasid_state = get_xsave_addr(fpu, XFEATURE_PASID);
 		/*
 		 * Since XFEATURE_MASK_PASID is set in xfeatures, ppasid_state
 		 * won't be NULL and no need to check its value.
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 45704f106815..09368201d9cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4396,10 +4396,15 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
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
@@ -4418,7 +4423,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 	while (valid) {
 		u64 xfeature_mask = valid & -valid;
 		int xfeature_nr = fls64(xfeature_mask) - 1;
-		void *src = get_xsave_addr(xsave, xfeature_nr);
+		void *src = get_xsave_addr(guest_fpu, xfeature_nr);
 
 		if (src) {
 			u32 size, offset, ecx, edx;
@@ -4438,10 +4443,14 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 
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
@@ -4461,7 +4470,7 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	while (valid) {
 		u64 xfeature_mask = valid & -valid;
 		int xfeature_nr = fls64(xfeature_mask) - 1;
-		void *dest = get_xsave_addr(xsave, xfeature_nr);
+		void *dest = get_xsave_addr(guest_fpu, xfeature_nr);
 
 		if (dest) {
 			u32 size, offset, ecx, edx;
@@ -10031,6 +10040,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.apf.halted = false;
 
 	if (kvm_mpx_supported()) {
+		struct fpu *guest_fpu = vcpu->arch.guest_fpu;
 		void *mpx_state_buffer;
 
 		/*
@@ -10039,12 +10049,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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

