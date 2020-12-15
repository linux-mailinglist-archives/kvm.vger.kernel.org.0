Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7222DB3C5
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbgLOS3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 13:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730346AbgLOS3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 13:29:22 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76378C0611CE;
        Tue, 15 Dec 2020 10:28:30 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id i24so22060223edj.8;
        Tue, 15 Dec 2020 10:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C/f96L+Qey1SIv38JhHlB/Gh2jbhdjxdYrDSCqGmPs4=;
        b=GRG7AbYTBer5jpfXbhM3wUrl3QJMvscjSBggN7duh9Fhm4RsKTw8PHfQHKOA2znL3z
         pN3+LB+kVCIdyHOmFLOmQSWS3p036gDp0B9I4tQfs43ju+Bh3Iby9ACFbWl67pPoSd2P
         NQ1niL4otPZDso5tI23KnkOtStq2juV4a6wsLNjvdjxEL6IH7taBBwKGaBd98XXaxDLt
         lVKYWdn0fxg9b2ynQlUsRysrujzt4cWogoepI31hwCPg7q0egFEGz4PgdGhzoFh16XaA
         lPDDel5pk3cbfX1TDajdXqz4r1r7Eaoukw/n+MLC+cvM1QcI5l7UuEXSEUc59q3CQ7YP
         SPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C/f96L+Qey1SIv38JhHlB/Gh2jbhdjxdYrDSCqGmPs4=;
        b=HZH1wSQWBbFsr2fA17WdXIoLfLn1FbErqzRBH79WIJJhDgwKPuMFQejCBrfsAy+2l0
         dJ+xLH+h+vz9KXEouUMVL5IQZ+ItEqWoonoKzogSaTAVsqRqX8nXGaebqX4y4ZBCyeWO
         ryw5AHbu18VwXTXnijS0VRvUUdzVShv8vz/PclZBBbx1arsIxGTttuHV4nky11F6MQC9
         wB9i6YusvDc8rOAcEUoybRknHAx6bQooTjVldbfaW4U04gisiSSShHvj7n5v4B95PXxI
         u6r6LqxWs08kldvxL3RdV0E3i86GlC2AVqKUhc6RAbS93+vtKRLG5z8UgD3afAJoKkHn
         BoVg==
X-Gm-Message-State: AOAM533dep4N2jqGOPUHGSmKj4GI1f3cnqEEzQhWJIyFZLNDHRlHOcQa
        T4XOLmKyV+erfKvoUj9V48g=
X-Google-Smtp-Source: ABdhPJxgSdvIleJuuGkLQ7F6EYdxASBIk7AjEcW6asusXT5HS15COUxjJM+w9octiJriD6AS/MAR0g==
X-Received: by 2002:a05:6402:1d9a:: with SMTP id dk26mr31091139edb.283.1608056909156;
        Tue, 15 Dec 2020 10:28:29 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id r21sm7369228eds.91.2020.12.15.10.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 10:28:28 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] locking/atomic/x86: Introduce arch_try_cmpxchg64()
Date:   Tue, 15 Dec 2020 19:28:04 +0100
Message-Id: <20201215182805.53913-3-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215182805.53913-1-ubizjak@gmail.com>
References: <20201215182805.53913-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add arch_try_cmpxchg64(), similar to arch_try_cmpxchg(), that
operates with 64 bit operands. This function provides the same
interface for 32 bit and 64 bit targets.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/cmpxchg_32.h | 62 ++++++++++++++++++++++++++-----
 arch/x86/include/asm/cmpxchg_64.h |  6 +++
 2 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 0a7fe0321613..8dcde400244e 100644
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
@@ -71,6 +62,39 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
 }
 
 #ifndef CONFIG_X86_CMPXCHG64
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

