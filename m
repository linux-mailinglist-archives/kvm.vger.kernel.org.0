Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F662DBC72
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 09:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLPIHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 03:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPIHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 03:07:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B794FC0613D6;
        Wed, 16 Dec 2020 00:06:41 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r5so23794418eda.12;
        Wed, 16 Dec 2020 00:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WiqtPjd/js6CZTuGoiZofY3uvp09PMvJ3JUNNxlan84=;
        b=DE5oaqJ3vyS4oiPOJTQmR4NOm/RfY6ZOo4/k5OSR+TR3vDapVHTtEEKisb22SxNTW2
         kKIpcqg7LyLqX72kqPkzH9VkToRm96OYXwmG5Nq8kgf5Am0xZ90Z1zwzlzX2Rpy7OVJa
         feWeYroF2A2IgO9uamM585WQV4BHqJkGRDFYOh1K9yVn5WmTqSne6vx8kLZw8nS2pd46
         sV+8HOO763HfsMK75SQtKObkP/GsawUNdvcln8bL8O/s6WNoA28/o4F4RWDQlbC3jory
         5aeh6/VnRxlQRiZlJt9sfJgwIf6z8xwKOsseYtdnoAIie1UDVzqar/YymWQzXCdvc3+Q
         o38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WiqtPjd/js6CZTuGoiZofY3uvp09PMvJ3JUNNxlan84=;
        b=C6afoAyNY5xg5sY/C8zrQz6DuWR91zsn+g/Yv/J9e/QMyst+IQPLIzSo7deyiBzC22
         It/FaW+mskRJFJTq1AW8ZTrs97RidWIF/sJIMdlaTW9D8Aocjf9F5eWnqoyBUpJb9yH5
         iKzexre1dinTpBPF0VQIecWdfipdKLtn5SBcnqPThApbUU0cfgtkNHcrzwLkB/MTqvVE
         wj0v7XiREoMxZT8KawSL2+1yzdv0lbmoDbiiukczK27bav77fKkMcM0hGkhCFHYAu0mD
         sQ6QZY1rF8QX5O2xB6a17mpdOXf6madCO26RjGNbjyi6xla641IMxauac7xrOTEie2ff
         iAxA==
X-Gm-Message-State: AOAM5331wg/dYc68qWuxC1E4x5FfZyyYyJfBp4EQ1Y41K42JegXcf1jy
        FOJQ5KCa8RZDsQ4RakA3lbeut5VefNyLJ1Bd
X-Google-Smtp-Source: ABdhPJy2j30t7eDxmfIN066lb8awYMuxtPbkAxdnh5WYjjy5dQDkvCXPcYhas6GNsQ01BdaNpwosgg==
X-Received: by 2002:a05:6402:404:: with SMTP id q4mr33389998edv.295.1608106000499;
        Wed, 16 Dec 2020 00:06:40 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id n20sm798334ejo.83.2020.12.16.00.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 00:06:39 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/3] locking/atomic/x86: Introduce arch_try_cmpxchg64()
Date:   Wed, 16 Dec 2020 09:05:20 +0100
Message-Id: <20201216080519.55600-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add arch_try_cmpxchg64(), similar to arch_try_cmpxchg(), that
operates with 64 bit operands. This function provides the same
interface for 32 bit and 64 bit targets.

v2: Use correct #ifdef.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/cmpxchg_32.h | 64 ++++++++++++++++++++++++++-----
 arch/x86/include/asm/cmpxchg_64.h |  6 +++
 2 files changed, 60 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 0a7fe0321613..f3684c0413b1 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -35,15 +35,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-#ifdef CONFIG_X86_CMPXCHG64
-#define arch_cmpxchg64(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o), \
-					 (unsigned long long)(n)))
-#define arch_cmpxchg64_local(ptr, o, n)					\
-	((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
-					       (unsigned long long)(n)))
-#endif
-
 static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
 {
 	u64 prev;
@@ -70,7 +61,40 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 	return prev;
 }
 
-#ifndef CONFIG_X86_CMPXCHG64
+#ifdef CONFIG_X86_CMPXCHG64
+#define arch_cmpxchg64(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr), (unsigned long long)(o), \
+					 (unsigned long long)(n)))
+#define arch_cmpxchg64_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
+
+#define __raw_try_cmpxchg64(_ptr, _pold, _new, lock)		\
+({								\
+	bool success;						\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);	\
+	__typeof__(*(_ptr)) __old = *_old;			\
+	__typeof__(*(_ptr)) __new = (_new);			\
+	asm volatile(lock "cmpxchg8b %1"			\
+		     CC_SET(z)					\
+		     : CC_OUT(z) (success),			\
+		       "+m" (*_ptr),				\
+		       "+A" (__old)				\
+		     : "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32))		\
+		     : "memory");				\
+	if (unlikely(!success))					\
+		*_old = __old;					\
+	likely(success);					\
+})
+
+#define __try_cmpxchg64(ptr, pold, new)				\
+	__raw_try_cmpxchg64((ptr), (pold), (new), LOCK_PREFIX)
+
+#define arch_try_cmpxchg64(ptr, pold, new) 			\
+	__try_cmpxchg64((ptr), (pold), (new))
+
+#else
+
 /*
  * Building a kernel capable running on 80386 and 80486. It may be necessary
  * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
@@ -108,6 +132,26 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 		       : "memory");				\
 	__ret; })
 
+#define arch_try_cmpxchg64(ptr, po, n)				\
+({								\
+	bool success;						\
+	__typeof__(ptr) _old = (__typeof__(ptr))(po);		\
+	__typeof__(*(ptr)) __old = *_old;			\
+	__typeof__(*(ptr)) __new = (n);				\
+	alternative_io(LOCK_PREFIX_HERE				\
+			"call cmpxchg8b_emu",			\
+			"lock; cmpxchg8b (%%esi)" ,		\
+		       X86_FEATURE_CX8,				\
+		       "+A" (__old),				\
+		       "S" ((ptr)),				\
+		       "b" ((unsigned int)__new),		\
+		       "c" ((unsigned int)(__new>>32))		\
+		       : "memory");				\
+	success = (__old == *_old);				\
+	if (unlikely(!success))					\
+		*_old = __old;					\
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
-- 
2.26.2

