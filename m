Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54F1521F38
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbiEJPqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346064AbiEJPqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:46:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C8F19CEFD;
        Tue, 10 May 2022 08:42:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gh6so33858978ejb.0;
        Tue, 10 May 2022 08:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dQ0+6v8bHjTUTjElyyWFtr2lf/WyO0yS6F3CevCrSmc=;
        b=EkjIls8qsRq9Vn9NcdYCpdijVFhXQv2un3GCY4tlm6XVTQ69iEl9RxlMVUOcrOCvXq
         HwbXu4lSnlMq+Hq4QIDB4Uhuddkh86ehRnA9wN/0Vysct9qXlV79cGw1lW8lxu2+Mr+g
         BXL0iM2nLiulKVtITVHWK7IlxRD52HlDUgp2d4mNBv88Z5GLG3IX0ROov512nEQ1zvY3
         DxGHOEzErNYLjLnTW9Pzv7tkLQQ3VpHXMeRR8vZNt9guu184KaQKrFOgmg5vrHx4c5e4
         H96HAshZYc+htQqUHJp2UOAQX8FSOCVssjEVh+BlAStQ1KjaLWKibqlpwywChN67eDzY
         VBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dQ0+6v8bHjTUTjElyyWFtr2lf/WyO0yS6F3CevCrSmc=;
        b=JPgzq13ULlkdX5Z1k1b73Wjv7r1hqdPgQVztxIScYdquBjhP5pXCtuEGeGeOP4Hmxx
         DMKSCwXi94vs8TWiRcFJPG5ZOBa+ij58WTyvEHJAgh7/lPNDxLdQxzFvHdHcgx2lGXlH
         Ul3q3RbOisrICvtrQjpzpkyNloxlSbqk9fALUEI8ZbAtw0Xw/sZFqDar5OFOz31m3SLF
         /MRHS2WZdmbDLx4aiVATFcihvRRCVSnvAbv293U1sKeygIaC2rpWYba7CuSL068XYUVy
         v3rewV3PMCfHKdpLv8t5aUiL+OGgK+30a91ovNnFlZ4kag8rtm6AESQDOwRKC3VwlH6Q
         s9qQ==
X-Gm-Message-State: AOAM533SvBOBs1ae0d4Xhjg97+oHgIm/JAaA1e6b6QYsI224icg9DG4w
        ZD5rMAHwgFv2OOZRTW43AEU=
X-Google-Smtp-Source: ABdhPJzWvX36nvQ6TusoV6gk/r7xovWkyRVupVGUQ+Y6yL4JdHtQhyz6hPre1H+W0c+8V61exG67tg==
X-Received: by 2002:a17:906:3c09:b0:6f3:9aff:e1a0 with SMTP id h9-20020a1709063c0900b006f39affe1a0mr20309485ejg.453.1652197369588;
        Tue, 10 May 2022 08:42:49 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id hx11-20020a170906846b00b006f3ef214e44sm6305097ejc.170.2022.05.10.08.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:42:49 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
Date:   Tue, 10 May 2022 17:42:17 +0200
Message-Id: <20220510154217.5216-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds try_cmpxchg64 to improve code around cmpxchg8b.  While
the resulting code improvements on x86_64 are minor (a compare and a move saved),
the improvements on x86_32 are quite noticeable. The code improves from:

  84:    89 74 24 30              mov    %esi,0x30(%esp)
  88:    89 fe                    mov    %edi,%esi
  8a:    0f b7 0c 02              movzwl (%edx,%eax,1),%ecx
  8e:    c1 e1 08                 shl    $0x8,%ecx
  91:    0f b7 c9                 movzwl %cx,%ecx
  94:    89 4c 24 34              mov    %ecx,0x34(%esp)
  98:    8b 96 24 1e 00 00        mov    0x1e24(%esi),%edx
  9e:    8b 86 20 1e 00 00        mov    0x1e20(%esi),%eax
  a4:    8b 5c 24 34              mov    0x34(%esp),%ebx
  a8:    8b 7c 24 30              mov    0x30(%esp),%edi
  ac:    89 44 24 38              mov    %eax,0x38(%esp)
  b0:    0f b6 44 24 38           movzbl 0x38(%esp),%eax
  b5:    8b 4c 24 38              mov    0x38(%esp),%ecx
  b9:    89 54 24 3c              mov    %edx,0x3c(%esp)
  bd:    83 e0 fd                 and    $0xfffffffd,%eax
  c0:    89 5c 24 64              mov    %ebx,0x64(%esp)
  c4:    8b 54 24 3c              mov    0x3c(%esp),%edx
  c8:    89 4c 24 60              mov    %ecx,0x60(%esp)
  cc:    8b 4c 24 34              mov    0x34(%esp),%ecx
  d0:    88 44 24 60              mov    %al,0x60(%esp)
  d4:    8b 44 24 38              mov    0x38(%esp),%eax
  d8:    c6 44 24 62 f2           movb   $0xf2,0x62(%esp)
  dd:    8b 5c 24 60              mov    0x60(%esp),%ebx
  e1:    f0 0f c7 0f              lock cmpxchg8b (%edi)
  e5:    89 d1                    mov    %edx,%ecx
  e7:    8b 54 24 3c              mov    0x3c(%esp),%edx
  eb:    33 44 24 38              xor    0x38(%esp),%eax
  ef:    31 ca                    xor    %ecx,%edx
  f1:    09 c2                    or     %eax,%edx
  f3:    75 a3                    jne    98 <t+0x98>

to:

  84:    0f b7 0c 02              movzwl (%edx,%eax,1),%ecx
  88:    c1 e1 08                 shl    $0x8,%ecx
  8b:    0f b7 c9                 movzwl %cx,%ecx
  8e:    8b 86 20 1e 00 00        mov    0x1e20(%esi),%eax
  94:    8b 96 24 1e 00 00        mov    0x1e24(%esi),%edx
  9a:    89 4c 24 64              mov    %ecx,0x64(%esp)
  9e:    89 c3                    mov    %eax,%ebx
  a0:    89 44 24 60              mov    %eax,0x60(%esp)
  a4:    83 e3 fd                 and    $0xfffffffd,%ebx
  a7:    c6 44 24 62 f2           movb   $0xf2,0x62(%esp)
  ac:    88 5c 24 60              mov    %bl,0x60(%esp)
  b0:    8b 5c 24 60              mov    0x60(%esp),%ebx
  b4:    f0 0f c7 0f              lock cmpxchg8b (%edi)
  b8:    75 d4                    jne    8e <t+0x8e>

The implementation extends the implementation of existing cmpxchg64.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Marco Elver <elver@google.com>
---
 arch/x86/include/asm/cmpxchg_32.h          | 43 ++++++++++++++++++++++
 arch/x86/include/asm/cmpxchg_64.h          |  6 +++
 include/linux/atomic/atomic-instrumented.h | 40 +++++++++++++++++++-
 scripts/atomic/gen-atomic-instrumented.sh  |  2 +-
 4 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 0a7fe0321613..e874ff7f7529 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -42,6 +42,9 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 #define arch_cmpxchg64_local(ptr, o, n)					\
 	((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
 					       (unsigned long long)(n)))
+#define arch_try_cmpxchg64(ptr, po, n)					\
+	((__typeof__(*(ptr)))__try_cmpxchg64((ptr), (unsigned long long *)(po), \
+					     (unsigned long long)(n)))
 #endif
 
 static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
@@ -70,6 +73,25 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 	return prev;
 }
 
+static inline bool __try_cmpxchg64(volatile u64 *ptr, u64 *pold, u64 new)
+{
+	bool success;
+	u64 prev;
+	asm volatile(LOCK_PREFIX "cmpxchg8b %2"
+		     CC_SET(z)
+		     : CC_OUT(z) (success),
+		       "=A" (prev),
+		       "+m" (*ptr)
+		     : "b" ((u32)new),
+		       "c" ((u32)(new >> 32)),
+		       "1" (*pold)
+		     : "memory");
+
+	if (unlikely(!success))
+		*pold = prev;
+	return success;
+}
+
 #ifndef CONFIG_X86_CMPXCHG64
 /*
  * Building a kernel capable running on 80386 and 80486. It may be necessary
@@ -108,6 +130,27 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 		       : "memory");				\
 	__ret; })
 
+#define arch_try_cmpxchg64(ptr, po, n)				\
+({								\
+	bool success;						\
+	__typeof__(*(ptr)) __prev;				\
+	__typeof__(ptr) _old = (__typeof__(ptr))(po);		\
+	__typeof__(*(ptr)) __old = *_old;			\
+	__typeof__(*(ptr)) __new = (n);				\
+	alternative_io(LOCK_PREFIX_HERE				\
+			"call cmpxchg8b_emu",			\
+			"lock; cmpxchg8b (%%esi)" ,		\
+		       X86_FEATURE_CX8,				\
+		       "=A" (__prev),				\
+		       "S" ((ptr)), "0" (__old),		\
+		       "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32))		\
+		       : "memory");				\
+	success = (__prev == __old);				\
+	if (unlikely(!success))					\
+		*_old = __prev;					\
+	likely(success);					\
+})
 #endif
 
 #define system_has_cmpxchg_double() boot_cpu_has(X86_FEATURE_CX8)
diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 072e5459fe2f..250187ac8248 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -19,6 +19,12 @@ static inline void set_64bit(volatile u64 *ptr, u64 val)
 	arch_cmpxchg_local((ptr), (o), (n));				\
 })
 
+#define arch_try_cmpxchg64(ptr, po, n)					\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	arch_try_cmpxchg((ptr), (po), (n));				\
+})
+
 #define system_has_cmpxchg_double() boot_cpu_has(X86_FEATURE_CX16)
 
 #endif /* _ASM_X86_CMPXCHG_64_H */
diff --git a/include/linux/atomic/atomic-instrumented.h b/include/linux/atomic/atomic-instrumented.h
index 5d69b143c28e..7a139ec030b0 100644
--- a/include/linux/atomic/atomic-instrumented.h
+++ b/include/linux/atomic/atomic-instrumented.h
@@ -2006,6 +2006,44 @@ atomic_long_dec_if_positive(atomic_long_t *v)
 	arch_try_cmpxchg_relaxed(__ai_ptr, __ai_oldp, __VA_ARGS__); \
 })
 
+#define try_cmpxchg64(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	kcsan_mb(); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+
+#define try_cmpxchg64_acquire(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64_acquire(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+
+#define try_cmpxchg64_release(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	kcsan_release(); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64_release(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+
+#define try_cmpxchg64_relaxed(ptr, oldp, ...) \
+({ \
+	typeof(ptr) __ai_ptr = (ptr); \
+	typeof(oldp) __ai_oldp = (oldp); \
+	instrument_atomic_write(__ai_ptr, sizeof(*__ai_ptr)); \
+	instrument_atomic_write(__ai_oldp, sizeof(*__ai_oldp)); \
+	arch_try_cmpxchg64_relaxed(__ai_ptr, __ai_oldp, __VA_ARGS__); \
+})
+
 #define cmpxchg_local(ptr, ...) \
 ({ \
 	typeof(ptr) __ai_ptr = (ptr); \
@@ -2045,4 +2083,4 @@ atomic_long_dec_if_positive(atomic_long_t *v)
 })
 
 #endif /* _LINUX_ATOMIC_INSTRUMENTED_H */
-// 87c974b93032afd42143613434d1a7788fa598f9
+// 764f741eb77a7ad565dc8d99ce2837d5542e8aee
diff --git a/scripts/atomic/gen-atomic-instrumented.sh b/scripts/atomic/gen-atomic-instrumented.sh
index 68f902731d01..77c06526a574 100755
--- a/scripts/atomic/gen-atomic-instrumented.sh
+++ b/scripts/atomic/gen-atomic-instrumented.sh
@@ -166,7 +166,7 @@ grep '^[a-z]' "$1" | while read name meta args; do
 done
 
 
-for xchg in "xchg" "cmpxchg" "cmpxchg64" "try_cmpxchg"; do
+for xchg in "xchg" "cmpxchg" "cmpxchg64" "try_cmpxchg" "try_cmpxchg64"; do
 	for order in "" "_acquire" "_release" "_relaxed"; do
 		gen_xchg "${xchg}" "${order}" ""
 		printf "\n"
-- 
2.35.1

