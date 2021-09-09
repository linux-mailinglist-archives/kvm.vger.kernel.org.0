Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE84042DE
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349375AbhIIBjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349302AbhIIBjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:39:37 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527D6C061757
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:27 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 70-20020a370b49000000b003d2f5f0dcc6so672051qkl.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=j0qpPBycoBdEl6sY/API9Q0J9uLD1RrCFMtLgmLF8gE=;
        b=bUoqxmY7HcmvG77dTImuqBEdab2qMSQs5HoUsLegW8AXIk0EiUpM0rSu7+Gqc8+/Sh
         c4vT1Q+sMeqS9Kv4psB5uhRLECiDwVC/aaywZs7SOoiBsKB9nKRfqMQnmXIGBAZB36ty
         TotP3WKaMcqup3lpWAOdv16aJgj5UYXA1GUb2oWWY20junH9Ek/ijWzjjDAUAGeioc9o
         QeXTQQ2zm52bGdsUcUezcNKX6oXBLdrpwJEAE+QHw/GjeN4q7BUly9Kmrm6j62aXf5Kk
         h710sw9Ywaf2DTClb8udsY+af81ykVYyKQFSW0JFvR2Vj9xbZq+qxByJ6yiEkotWXpnl
         QYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j0qpPBycoBdEl6sY/API9Q0J9uLD1RrCFMtLgmLF8gE=;
        b=zmcVJstBr7QnoJlWSULuyeX3VOo8HSxRJ8nwyKhKOPWIXFcd1E6I28TRRWQl1oBxiz
         mMyeC+DSdZuhUCWcV0S5o5zmUXYucEACTGdWDvrOeTxhCDXTSDzs/Ln8GF+6oT6SdanG
         i1XvHN69n14SVBFXLkjPJ77qbTFXNjKMZLdQsMsVHj2lWQnz+w38yPfnPi9aIeccaR1S
         oewRbuFL+QK/kt0cKjo9Av9B9UEsgc1Ur9R/3yl4uZYdDQnjyW3fCxDeMf3svBQf3Lw6
         IsTfZvO/juzWzdTSyXKVZxkX3PoEiUtedzPwyh4/qG1EtQx3gaZGxVGa70EzqepxbNYK
         Q4MA==
X-Gm-Message-State: AOAM530+6PbaNrsDoHsI1aDW3uimneYRjyCJ8ROFLaTY4dcbl60AVxmB
        fjDE9AcYfu3W4E3XrU2gcaXP2uhih5uP
X-Google-Smtp-Source: ABdhPJxrQ89uQwSSNVlMeh1gefqK0dwcO+yDwcTSqQJjEPHYnry8Zh2OKdBzBwuDafUyTmF1Yuywix34zd6t
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0c:d450:: with SMTP id
 r16mr492884qvh.30.1631151506484; Wed, 08 Sep 2021 18:38:26 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:01 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-2-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 01/18] KVM: arm64: selftests: Add MMIO readl/writel support
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
2.33.0.153.gba50c8fa24-goog

