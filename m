Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE31B42E5E7
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhJOBS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhJOBSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D1BC061779;
        Thu, 14 Oct 2021 18:16:17 -0700 (PDT)
Message-ID: <20211015011539.191902137@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=LZ4s65C2Wf05ubve26y4ecylgzNISNCMKFTBqqOPuVM=;
        b=jBLoYWz0Kyuf9IQvDQi7QlQNLA4f/z1vivHCdA1xMoNCqXnUE/s5H3RtU7zXcQx4JpLtYk
        njY8yfWKNieAhOxdoHazuFgAtBGKwdXqEXxBfJQ9W8yGrXIFeL9IVSi44LnHS+MVACWoa3
        QSa+LOTYF9DcjYMti1GdABavOxGHq9IC/SSODsLFJ/V5tZOySpb8F4/Qk1d4HsHhNDHi+N
        X9KUQXhbVntKTRMOgZWtH2CdDsi2a/JtdwvXhTXtstfnE1Txo1KMqqws520k5sgVk7qtSD
        7u/6ElE6Ay+CmWhQEW+Sq66XHwUbja61j8t0Xap5sOUsiZot4cmOeL8+3ltZgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=LZ4s65C2Wf05ubve26y4ecylgzNISNCMKFTBqqOPuVM=;
        b=Uou+9QaIU4ceAj51/cc5oSHG4o5f3dBbT1Fc3obyXD10jBQMC22MYVUnCc877HU1+5K6g+
        x81Fng+eLbVDECAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 14/30] x86/fpu: Rework copy_xstate_to_uabi_buf()
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:15 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare for replacing the KVM copy xstate to user function by extending
copy_xstate_to_uabi_buf() with a pkru argument which allows the caller to
hand in the pkru value, which is required for KVM because the guest PKRU is
not accessible via current. Fixup all callsites accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/fpu/xstate.c | 34 ++++++++++++++++++++++++++--------
 arch/x86/kernel/fpu/xstate.h |  3 +++
 2 files changed, 29 insertions(+), 8 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index eeeb807b9717..b2537a8203ee 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -940,9 +940,10 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
 }
 
 /**
- * copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
+ * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
  * @to:		membuf descriptor
- * @tsk:	The task from which to copy the saved xstate
+ * @xsave:	The xsave from which to copy
+ * @pkru_val:	The PKRU value to store in the PKRU component
  * @copy_mode:	The requested copy mode
  *
  * Converts from kernel XSAVE or XSAVES compacted format to UABI conforming
@@ -951,11 +952,10 @@ static void copy_feature(bool from_xstate, struct membuf *to, void *xstate,
  *
  * It supports partial copy but @to.pos always starts from zero.
  */
-void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
-			     enum xstate_copy_mode copy_mode)
+void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
+			       u32 pkru_val, enum xstate_copy_mode copy_mode)
 {
 	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
-	struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
 	struct xregs_state *xinit = &init_fpstate.xsave;
 	struct xstate_header header;
 	unsigned int zerofrom;
@@ -1033,10 +1033,9 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 			struct pkru_state pkru = {0};
 			/*
 			 * PKRU is not necessarily up to date in the
-			 * thread's XSAVE buffer.  Fill this part from the
-			 * per-thread storage.
+			 * XSAVE buffer. Use the provided value.
 			 */
-			pkru.pkru = tsk->thread.pkru;
+			pkru.pkru = pkru_val;
 			membuf_write(&to, &pkru, sizeof(pkru));
 		} else {
 			copy_feature(header.xfeatures & BIT_ULL(i), &to,
@@ -1056,6 +1055,25 @@ void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 		membuf_zero(&to, to.left);
 }
 
+/**
+ * copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
+ * @to:		membuf descriptor
+ * @tsk:	The task from which to copy the saved xstate
+ * @copy_mode:	The requested copy mode
+ *
+ * Converts from kernel XSAVE or XSAVES compacted format to UABI conforming
+ * format, i.e. from the kernel internal hardware dependent storage format
+ * to the requested @mode. UABI XSTATE is always uncompacted!
+ *
+ * It supports partial copy but @to.pos always starts from zero.
+ */
+void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
+			     enum xstate_copy_mode copy_mode)
+{
+	__copy_xstate_to_uabi_buf(to, &tsk->thread.fpu.state.xsave,
+				  tsk->thread.pkru, copy_mode);
+}
+
 static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 			    const void *kbuf, const void __user *ubuf)
 {
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 0789a04ee705..81f4202781ac 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -15,4 +15,7 @@ static inline void xstate_init_xcomp_bv(struct xregs_state *xsave, u64 mask)
 		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
 }
 
+extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
+				      u32 pkru_val, enum xstate_copy_mode copy_mode);
+
 #endif

