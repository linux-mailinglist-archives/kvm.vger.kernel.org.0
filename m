Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4F2409E70
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344738AbhIMUvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244868AbhIMUvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:51:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13225C061762
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:45 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g15-20020a63564f000000b00261998c1b70so8041100pgm.5
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S2j8r1BCKqhVhJ+8bR7t/dA2J/PIIE/Rns3zAg7zZww=;
        b=HhlIi3zOq8nN2/PIzYwdWzxYruhZ3ZGEFTCukDG3CHU33zR+QnniRcYj7haQyqqB/Q
         ntXvSsHqHdGuqS+u451AJvAzjlVzZuPSza4IEtAhhPEryAgylWYKb8GdnjEkKkch9pzV
         rjeSnlBr7yQJDk1M7U37dx1o7M0nyUK1zhJTdAZ40JK48YAYyMXixVEU+d8cZOxNBss9
         wzfL1WgVfX2yx/wyKTixQzdnRy4UNUaE9ZxkNEocqYyIo7B8zgwsQ1cI0PSF51cd3SIU
         OGfI6ZbEQpPHQkQDwyR3i+rWtdELT36/PGSG31A17wgrW1Wnal/Xj1C4SKVnCLTplgKt
         F/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S2j8r1BCKqhVhJ+8bR7t/dA2J/PIIE/Rns3zAg7zZww=;
        b=PxH4hYB1XlHk/bLKfkQt4skFRR2r2CkOnZqM8XUamCgfEBiVsm1xs6ZxLXUHqp+Cc4
         h5dnVL0RbS1O18D7EYKxV1BjWWyKfPMIJEaDRzoXCLd0RWTY4u2fZG8Y1TMo7LiMzNls
         +EB79v1ra4cMsiXMDIUPLbBOFLLYP0bGIVCtryoZ1xN8rntaR2S5FafiJM+JBC//AomC
         O5XN1NfuP8OCUegVk1/BOrVEZagrW/VPuxIot9pGLi19SKkWsIYvYQgGm0be5HksT0CF
         VFeK3yyixVXV7DoPCEQmGXsxgWUaMRaTTiQT4hKdvs0iHdlfdTVh18Ty2tyuOWPznCh1
         jKCA==
X-Gm-Message-State: AOAM532JGYqzsl8osggwXK7p9jtEhqD42EDO8TRaw/PFTkzcAXa+6Tjt
        WXcCkZ169zTW20OCn6oPSqYbmcS3ppWL
X-Google-Smtp-Source: ABdhPJwavf+m1k95x4s0lYCEaHGS3JkYo5ZlD39C9d7UbWbRHbLaosZSi5AcEL7nvgFKY7Ruhkw3tioFmZs/
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:90b:fd7:: with SMTP id
 gd23mr1103667pjb.1.1631566184150; Mon, 13 Sep 2021 13:49:44 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:49:17 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-2-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 01/14] KVM: arm64: selftests: Add MMIO readl/writel support
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define the readl() and writel() functions for the guests to
access (4-byte) the MMIO region.

The routines, and their dependents, are inspired from the kernel's
arch/arm64/include/asm/io.h and arch/arm64/include/asm/barrier.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 46 ++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c0273aefa63d..96578bd46a85 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -9,6 +9,7 @@
 
 #include "kvm_util.h"
 #include <linux/stringify.h>
+#include <linux/types.h>
 
 
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
@@ -130,6 +131,49 @@ void vm_install_sync_handler(struct kvm_vm *vm,
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
2.33.0.309.g3052b89438-goog

