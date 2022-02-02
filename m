Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2424A6956
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 01:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbiBBAuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 19:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243543AbiBBAuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 19:50:02 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A68C06173B
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 16:50:02 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id w18-20020a17090a461200b001b7ea83e29dso2650481pjg.4
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 16:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zqC7ErNhTDTy1v1hLoDrXbuxVMv5IRrOrkRyOKcUaeg=;
        b=XKb4zPuXIIwctcSOmCDmgJfg8NTQ92lvtVXEJu/4qhXFU2LKeL42KXV03TYMTCs379
         8jXzoYm/94swbvUY5Yg0Lg8i2wfq2DciirhQjJKTV0wsndl1BybrIiAh71gb7u9tCo1k
         dwFSXfs4lpOeoZM3HVz0ZJpLOadK8AQM2fzyfb7JWWnxZFIOdlNqo+7ptVmHZE7ovoLs
         /hN4L1bzTHmRpRhrNvh9qdo/RDzN6WhEleS5YKjMBTYDm5d/ymorEkf3y3+ZycMpvFa0
         H8jmh01pHfFQUFK4r4r4yV/EbZYPMn2DV5E3leaXgCMzaWZ/8qSaeKJa+6RLnvIjEZm8
         imdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zqC7ErNhTDTy1v1hLoDrXbuxVMv5IRrOrkRyOKcUaeg=;
        b=FDjTQKNHx3eFZ24GOUDfQkmWpGpRuwbvuR27pTtPc3qKvWikK+XPu0djKbudyKPw3U
         4slYID+yTuzxCodSo0XirK9Q5gPHIUmYl4jCq0mPaMW2PoWGeDTSVMW+eIvnl7HzrTDh
         EBW3cd/8NT22Wfwx8FZ3tq3yIz0CgLXqw+Rwsj24Qyy9g4atuuMwfclpTldFTsYPLn5K
         CvZqSCtOPvMKHaZHDnxp6T02asZTItwJGcdCfvZnXpB7258bT+MK+9NmBSJnoT4GkW0g
         UxQ/pEngzaBJGfVrVsv1FTWhw3gIz49nUml4HxPU/dphfq488KKHZ3BAsfuN+tGYrT4S
         ElbQ==
X-Gm-Message-State: AOAM531vT2zwI+btM+dTrW1qQ9OStyMjHM4lMtlKF+udKdPzLmCI3HJI
        CrxAB5jAzJH2ke/mPvDe/0s2ZR60hs0=
X-Google-Smtp-Source: ABdhPJyK+/wekACSBU7YDtI0MDyZWi14PbNwtr0sorptRCs82INgfWofplxqnj/Mp3fClTt/ZVZdVz23RM0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:da90:: with SMTP id
 j16mr28314536plx.101.1643763001854; Tue, 01 Feb 2022 16:50:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Feb 2022 00:49:42 +0000
In-Reply-To: <20220202004945.2540433-1-seanjc@google.com>
Message-Id: <20220202004945.2540433-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220202004945.2540433-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH v2 2/5] x86/uaccess: Implement macros for CMPXCHG on user addresses
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Add support for CMPXCHG loops on userspace addresses.  Provide both an
"unsafe" version for tight loops that do their own uaccess begin/end, as
well as a "safe" version for use cases where the CMPXCHG is not buried in
a loop, e.g. KVM will resume the guest instead of looping when emulation
of a guest atomic accesses fails the CMPXCHG.

Provide 8-byte versions for 32-bit kernels so that KVM can do CMPXCHG on
guest PAE PTEs, which are accessed via userspace addresses.

Guard the asm_volatile_goto() variation with CC_HAS_ASM_GOTO_TIED_OUTPUT,
the "+m" constraint fails on some compilers that otherwise support
CC_HAS_ASM_GOTO_OUTPUT.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/uaccess.h | 142 +++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index ac96f9b2d64b..1c14bcce88f2 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -409,6 +409,103 @@ do {									\
 
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+#ifdef CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+#endif // CONFIG_X86_32
+#else  // !CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	int __err = 0;							\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     CC_SET(z)						\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
+					   %[errout])			\
+		     : CC_OUT(z) (success),				\
+		       [errout] "+r" (__err),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory", "cc");					\
+	if (unlikely(__err))						\
+		goto label;						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+/*
+ * Unlike the normal CMPXCHG, hardcode ECX for both success/fail and error.
+ * There are only six GPRs available and four (EAX, EBX, ECX, and EDX) are
+ * hardcoded by CMPXCHG8B, leaving only ESI and EDI.  If the compiler uses
+ * both ESI and EDI for the memory operand, compilation will fail if the error
+ * is an input+output as there will be no register available for input.
+ */
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	int __result;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     "mov $0, %%ecx\n\t"				\
+		     "setz %%cl\n"					\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %%ecx) \
+		     : [result]"=c" (__result),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory", "cc");					\
+	if (unlikely(__result < 0))					\
+		goto label;						\
+	if (unlikely(!__result))					\
+		*_old = __old;						\
+	likely(__result);					})
+#endif // CONFIG_X86_32
+#endif // CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct __user *)(x))
@@ -501,6 +598,51 @@ do {										\
 } while (0)
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+extern void __try_cmpxchg_user_wrong_size(void);
+
+#ifndef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _oldp, _nval, _label)		\
+	__try_cmpxchg_user_asm("q", "r", (_ptr), (_oldp), (_nval), _label)
+#endif
+
+/*
+ * Force the pointer to u<size> to match the size expected by the asm helper.
+ * clang/LLVM compiles all cases and only discards the unused paths after
+ * processing errors, which breaks i386 if the pointer is an 8-byte value.
+ */
+#define unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label) ({			\
+	bool __ret;								\
+	__chk_user_ptr(_ptr);							\
+	switch (sizeof(*(_ptr))) {						\
+	case 1:	__ret = __try_cmpxchg_user_asm("b", "q",			\
+					       (__force u8 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 2:	__ret = __try_cmpxchg_user_asm("w", "r",			\
+					       (__force u16 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 4:	__ret = __try_cmpxchg_user_asm("l", "r",			\
+					       (__force u32 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 8:	__ret = __try_cmpxchg64_user_asm((__force u64 *)(_ptr), (_oldp),\
+						 (_nval), _label);		\
+		break;								\
+	default: __try_cmpxchg_user_wrong_size();				\
+	}									\
+	__ret;						})
+
+/* "Returns" 0 on success, 1 on failure, -EFAULT if the access faults. */
+#define __try_cmpxchg_user(_ptr, _oldp, _nval, _label)	({		\
+	int __ret = -EFAULT;						\
+	__uaccess_begin_nospec();					\
+	__ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);	\
+_label:									\
+	__uaccess_end();						\
+	__ret;								\
+							})
+
 /*
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
-- 
2.35.0.rc2.247.g8bbb082509-goog

