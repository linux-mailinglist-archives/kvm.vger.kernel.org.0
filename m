Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D921340A156
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349193AbhIMXMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349375AbhIMXL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:56 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D8EC061766
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h10-20020a65404a000000b00253122e62a0so8258995pgp.0
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S2j8r1BCKqhVhJ+8bR7t/dA2J/PIIE/Rns3zAg7zZww=;
        b=CuGfX+E1SqFTT5eOBisvWSFYoND4dvqTTB/VIJqY1O8Go94s/YODwQAdP0+plX7Q8H
         BgNk6fCKeOnA3t5HJ28w95v7aemtW3uKMH2yLOf2i7fygyTU3qd6e1V16BGwiYtoY8Im
         6hNV5kQSYMzzuvz8lIuTMXWqUzyNCmIdYiyUP1tD/mn9B/ta7METDZDh7iRmPBrosoAh
         RiYVxGVxn7XnFrwnuiba1o/9AY07Rzs3AfP932QMyHlF+FN8hJyAtNGINbaH1ENfNh1E
         ZSjSdxbkzhVPwRlU/LVQ9SFgXvvNMVNBN+A+8zyTqpgbhMYo7sGbl68its1/49FBrf64
         mEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S2j8r1BCKqhVhJ+8bR7t/dA2J/PIIE/Rns3zAg7zZww=;
        b=aoRoxcSK447rNUEieCDwes4ye1iLRK362xb+QO73UEo//YBBREbDo0SfSx9FjI1gJv
         139+BlhnOsGg1vWPqMVtlUP8bbzDt6Kzg6a5uj8++rUc40YSt+PPyS/zPU4wZICTYwk0
         eVyFxZZW2hFWnpl/ejJhatOWBErfZlgQV2a/lRU8YWlr3SSlWuIFBzuffEPktArdzu9k
         OuMoRz/+UwrV5dV5qlkQ4tS+fjyRghl3HkiXEqnw4PhZfbbpzsORhkj0l6E1+UjwSHIV
         O7WNFlWwCZFGAq8s97KHzK+4TFvOpqU8aVZuXl/goJmL2ZkTFz2laOXhqNgndWyLAR5y
         xHiQ==
X-Gm-Message-State: AOAM530ef1HG1thPIhq/cThODsQBdKXiyFcNWc+MAAwGfLoSaoGNoyfz
        Zsy1EhqkVcvnQLfViSo3FOMbrbegB4GT
X-Google-Smtp-Source: ABdhPJwD1Aonn1tWnz16FFRS8kMdQAVk8VivmMOSg0aueBPRNHSF3UfjmuS89nFUfgrdLtxMU5EM5OZnjby+
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:8c83:b029:129:17e5:a1cc with SMTP
 id t3-20020a1709028c83b029012917e5a1ccmr12488624plo.49.1631574603783; Mon, 13
 Sep 2021 16:10:03 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:42 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-2-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 01/14] KVM: arm64: selftests: Add MMIO readl/writel support
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

