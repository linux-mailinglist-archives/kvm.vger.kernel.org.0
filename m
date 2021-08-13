Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB2A3EBDBF
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 23:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbhHMVM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhHMVM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 17:12:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87190C061756
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n200-20020a25d6d10000b02905935ac4154aso10300230ybg.23
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 14:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
        b=LJO5U00ZjaOZ215Q3zQBNAPbMmqLU4kJbRYeMS0C3oR9Q0pS36G9P72tHYnL9f1TmL
         eYQtnM3qkeMEicbovSeP50ZrM2B4Np2JYkPEvunq2dUIfENdFZ6WwmmWce5QmsnmA5Yq
         uRyfhUD58L5wJfyrxi+LZwfuf8b0+BGTDjTkWEkbvgyPao9BFLbHpzjXr7ZcRY/OJuWb
         yR3u7arud7z7b3q+ApZGI0ojHzeCHi9oNV9STxe2ldebvsT5G3mTIDv/VRIxQ5AwvJoF
         mDMepVoQek8NI1KclrY1V+3lfCc823x0+5eK1b/OJvdkyXV7fz/7wW60yRevcXCZr7VG
         0/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sybk7YcBeZufJ2AiOux9y0QLju0ZjmiMoQ+rDeqF05I=;
        b=EkDh0Rk16P++rRc/BW7vC7Mu7NIiDQCwgiLXpIKEOznw017oO8H+EVMmm/gC10DGxq
         gwZLuPmAE00MfLuS7oL4klYY33GK+jOXDfK/wb3g5s9yx2yajhp89CUEWYNhWXeO8CKq
         wlA1/rsX5xPvGp36J/UmBK9c+ffYAuLAYh+kbYgtSUyJTjmATPfnH89QjkbDHnPxnjaX
         UmnNObPEy6Hxp8vhJFyFHNy/x+9+L0J5h2d9hLkUZ0pcNvx2JSkMYxegYFMvANSoT7mA
         Pih54vBBj/BRWrUmyPU+F4l4aj8hvYjjIGT4MKNZ3HmqxAccjN7LnXeXdMVz4ulfMcgh
         jJqw==
X-Gm-Message-State: AOAM531s0Yt0HMtrNvg1uAd5e+CO4ULnzPQ+ex1pkimu2LWzQ7Tdzkyf
        34aCx8Zh3zduLC56dcs3lNkAC1PTIkeO
X-Google-Smtp-Source: ABdhPJxmtYDI1q+46n5THoeKsu7C2PelKcdfRaw5GLTlL9837eljYe1WdU4FvJftPG+amvHn+6hOD64bw2YW
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:25ce:: with SMTP id
 l197mr5713620ybl.255.1628889148791; Fri, 13 Aug 2021 14:12:28 -0700 (PDT)
Date:   Fri, 13 Aug 2021 21:12:02 +0000
In-Reply-To: <20210813211211.2983293-1-rananta@google.com>
Message-Id: <20210813211211.2983293-2-rananta@google.com>
Mime-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 01/10] KVM: arm64: selftests: Add MMIO readl/writel support
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

