Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D433FE4B0
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344330AbhIAVPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbhIAVPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2795C0613D9
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o76-20020a25414f000000b0059bb8130257so962454yba.0
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yth3I1/Bzi0ikfWfrqGMTpl+hA4YL1ynlKPMvmODV/s=;
        b=n+Mx5PnDMeXxTqhyx09Lxlu6aOsb0KQ/uyjPoe28ripI+2Ygdz2N3UndU2pED2GvKh
         L5Pu0q87yxjRhcfWRTRdqCXBHeLJfjJdU/MxvpDVmpYrA1KsFv9DEyy6GXeA7DCFEYTR
         775EpFel2mtm1UUP6GB8R4NlDQaEInR3n8US/9dTv5bltIYL9J3FJyesrvONIvCVlNOi
         1rdkU0Po7mNSxxZMaDFzJGjU7S/lsJNQ+HZEkNtuSPkjCfhDoOiPWfrSUWl2pL7T9sDg
         gJ7U1aqZ3OsAYAGIn5lbBtPyBNAn3/NdeU4t4RO0EFzppBJ+zT++m6/Awu/y7BXwc0Z6
         ItWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yth3I1/Bzi0ikfWfrqGMTpl+hA4YL1ynlKPMvmODV/s=;
        b=NZYOSJ8+ofPp/irwunW1g1I1BFdhFrCFfO2lKUMuTLcOmPR80GzKRfFeA6WsFpaK62
         uTwNno0gMTsjglOSgklwYPh70hagMOmgJMCL8DoGbLI6nyiN0sQGS1siBkZV1kc6DgEu
         PM1y2tbYqmSfQ1aohXrzuRC20KntHccCrQ8joDHjoRmkUr5X4XB9hBWTqQqCNxqCYI4w
         4Zl8xotuZmliPQ5DSplcDModJav+GMJJhQOlmdqUtbVqIPFt5a/kXJzn8QNM7sYlEBDa
         UJT/CQ3Whurl50gP6pz4bkBo7VWbYbLEeY7gsx56oTIqvKtfB9MiIR9eFCUHJvwVJ2je
         C0yQ==
X-Gm-Message-State: AOAM532mkcWSXlgCVDc/AEWX0nyNH4i2gXVF+jXLHwzc9+35PTGec37e
        AJMbK7HDEwdX6Rsd6/ccWIQdxE9KrM/a
X-Google-Smtp-Source: ABdhPJz26u67QH5f0GMtWLqojzruIAuJdhj/sKV8WtFRpAoQZS8rLzSA3x/FYnDXY1vyi7ExgKp5zhxIPX+z
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c647:: with SMTP id
 k68mr2013806ybf.349.1630530875111; Wed, 01 Sep 2021 14:14:35 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:06 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-7-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 06/12] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 78df059dc974..c35bb7b8e870 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -241,4 +241,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
 #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c));})
 #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(__v); __v; })
 
+static inline void local_irq_enable(void)
+{
+	asm volatile("msr daifclr, #3" : : : "memory");
+}
+
+static inline void local_irq_disable(void)
+{
+	asm volatile("msr daifset, #3" : : : "memory");
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.153.gba50c8fa24-goog

