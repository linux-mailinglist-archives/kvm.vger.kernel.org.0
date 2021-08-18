Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639763F0B2F
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhHRSn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbhHRSny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:43:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BB6C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r35-20020a635d230000b0290239a31e9f24so1957355pgb.9
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
        b=KyWRMVB2YjHXSj3SrlXBQ1vUcQjS4upaB1ecKlUekeQMP3aw4uhnG6uXijlPT/31ui
         Z28ax39JzZAx1Z7J8FJei5MIVv98GH6r7vIQCEG3PfaFCvB4WEuqVRxab5ga+fSTQmeY
         j5QUx4OUcKTj4AdUaQMpWPvrugwRMTrM64LTE1De5ouxE5IHLW5fPrrULhaBEHdcoHGo
         hmbDITScovX72Zyu4nY8lVbvpgAGK8k1T0EtpyvDMXvLOlNKXz+0BX/BgPjyaT1zNHnT
         rqsSfheHhwSn27ZcOd/7GIFehJ32fm81DLLxjUIGrGL2qdhydKSCw30/2SGJncJylHge
         2juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
        b=ZPdDvQhRP4EJb7sAdvzD+YD5jutRdfY+XRnluGR101tsdPg1KsR1HQ4TLSi9Iom7UJ
         b1gfXddb9vK0wXK6i126WSo0b4bgntwOAtke8UJ0T+Agi0RQETsHXF8FIVHXjXsDi9ty
         2bw+mBKYCECeFi6ndyohqGVcZohRKjdh+waMBZO7gJlGo9IzuaJ87yR6y+CJ8B8WlSCG
         N7BsQUAFSEruTLN0PWissa/pd0tmch6Ds+2LhH4EhEprhIW2wrXNh/pTaOYjJfOAfhDb
         d6ZFbI/JdII9SyZteY0IxMojoIIQo2t/2azn4I7y5w07slhsVOw0UY36qVlR4p+zDGuU
         l/RA==
X-Gm-Message-State: AOAM532sc2emibV9HQRmSLMKEwBj/AcY8fDe6dUYS7zfrzcSX6PQVxzs
        uS9A4zjQuokpjM+DHpCAvkWZy43horA+
X-Google-Smtp-Source: ABdhPJwpulpudlfIiB7CO8SfhZeZ9mfxxExEhDLOhAm5IzLeR7emCgSi+C7ROeGvaAWlJ6EMz8iciBV4Xt6V
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:396:: with SMTP id
 ga22mr92005pjb.0.1629312198788; Wed, 18 Aug 2021 11:43:18 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:02 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-2-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 01/10] KVM: arm64: selftests: Add MMIO readl/writel support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the readl() and writel() functions for the guests to
access (4-byte) the MMIO region.

The routines, and their dependents, are inspired from the kernel's
arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 27dc5c2e56b9..14f68bf55036 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -127,6 +127,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 	val;								  \
 })
 
-#define isb()	asm volatile("isb" : : : "memory")
+#define isb()		asm volatile("isb" : : : "memory")
+#define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
+#define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
+
+#define dma_wmb()	dmb(oshst)
+#define __iowmb()	dma_wmb()
+
+#define dma_rmb()	dmb(oshld)
+
+#define __iormb(v)							\
+({									\
+	unsigned long tmp;						\
+									\
+	dma_rmb();							\
+									\
+	/*								\
+	 * Courtesy of arch/arm64/include/asm/io.h:			\
+	 * Create a dummy control dependency from the IO read to any	\
+	 * later instructions. This ensures that a subsequent call	\
+	 * to udelay() will be ordered due to the ISB in __delay().	\
+	 */								\
+	asm volatile("eor	%0, %1, %1\n"				\
+		     "cbnz	%0, ."					\
+		     : "=r" (tmp) : "r" ((unsigned long)(v))		\
+		     : "memory");					\
+})
+
+static __always_inline void __raw_writel(u32 val, volatile void *addr)
+{
+	asm volatile("str %w0, [%1]" : : "rZ" (val), "r" (addr));
+}
+
+static __always_inline u32 __raw_readl(const volatile void *addr)
+{
+	u32 val;
+	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+#define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
+#define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })
+
+#define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
+#define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
 
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

