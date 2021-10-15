Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3B42E5F7
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhJOBT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46590 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbhJOBSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:40 -0400
Message-ID: <20211015011539.792363754@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=naosO9hQ1o99O1ACUu2/9fKYBwND95hze68DMEXuWms=;
        b=fNam2hCirHA1yhViuZ6D7YsmS6ZY5LGS/eDPXatTdZ6bX18PAF6QRteae6QVhugkadgKAP
        D+zOpXkeUlqFxOIEafQzdwPCGR4cdMx8sGmlRnC/+Bw0tJMFLPJrbQnkteGbPVT5s+prt2
        DVRxC64nIGHn/iKc82Gpz4EYHfCSFgZYCWZqYINSdKByRsEQPWyD8dkywUeq3d0MJ81r+1
        8dQBKdfitS9eFb6Ar67/AVS2whygkR2ndo3iXbWdVVftOxRs30dmLMY4miKo6dK8cd30Ox
        MPUM2B8KQAwBAdI4jL+VCXS4TSNhXb67EBA/EWJQP3owGTy8gvLNkvZKw/rPaw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=naosO9hQ1o99O1ACUu2/9fKYBwND95hze68DMEXuWms=;
        b=RGUhHCaqqM5uU3xWk+CYjmkQaIddYbUphS+AXwTiNK0r6J1J371dlgdVb9Mfyjgoz8v4iS
        kvj3Md9ckwDtuiBw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 25/30] x86/fpu: Move fpstate functions to api.h
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:33 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move function declarations which need to be globally available to api.h
where they belong.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Fix changelog typo - Boris
---
 arch/x86/include/asm/fpu/api.h      |  9 +++++++++
 arch/x86/include/asm/fpu/internal.h |  9 ---------
 arch/x86/kernel/fpu/internal.h      |  3 +++
 arch/x86/math-emu/fpu_entry.c       |  2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index c6f3d1add32f..ed0e2baa3f4b 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -110,6 +110,15 @@ extern int cpu_has_xfeatures(u64 xfeatures_mask, const char **feature_name);
 
 static inline void update_pasid(void) { }
 
+#ifdef CONFIG_MATH_EMULATION
+extern void fpstate_init_soft(struct swregs_state *soft);
+#else
+static inline void fpstate_init_soft(struct swregs_state *soft) {}
+#endif
+
+/* fpstate */
+extern union fpregs_state init_fpstate;
+
 /* fpstate-related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
 
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 74b7cc3d2e77..d8bb49134ebb 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -42,15 +42,6 @@ extern void fpu__init_system(struct cpuinfo_x86 *c);
 extern void fpu__init_check_bugs(void);
 extern void fpu__resume_cpu(void);
 
-extern union fpregs_state init_fpstate;
-extern void fpstate_init_user(union fpregs_state *state);
-
-#ifdef CONFIG_MATH_EMULATION
-extern void fpstate_init_soft(struct swregs_state *soft);
-#else
-static inline void fpstate_init_soft(struct swregs_state *soft) {}
-#endif
-
 extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
index 5ddc09e03c2a..bd7f813242dd 100644
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -22,4 +22,7 @@ static __always_inline __pure bool use_fxsr(void)
 /* Init functions */
 extern void fpu__init_prepare_fx_sw_frame(void);
 
+/* Used in init.c */
+extern void fpstate_init_user(union fpregs_state *state);
+
 #endif
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 8679a9d6c47f..50195e249753 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -31,7 +31,7 @@
 #include <linux/uaccess.h>
 #include <asm/traps.h>
 #include <asm/user.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"

