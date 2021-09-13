Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96C540A159
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348836AbhIMXM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349328AbhIMXL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:56 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE3BC0613E7
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:20 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c27-20020a05620a165b00b003d3817c7c23so43813700qko.16
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
        b=DNkbp/sqJ7JxIvPqWv1ccqgt18UNr/1F5XiXnLeubqboraLkX5zaOi5Y9u+dmJkNxD
         5Jx8B7jRUF8KPPuuLbDtxtU3wcNdxfelulEqIFT9UGvhK/RcZ0SmaE6MhFDsTdh432bu
         1rmsvCUZ07vzLQpkhiW4MGccfZPXlQ/K3TK6KGTP7hexs1mQjzYIQeJMu65H10YvUID0
         LB1gvoLPjtnO1R25IEC+6GXtKzS9NajXeNsAsGbMbEpDzFE6GT5IOyCPA5lH+CYBTzRb
         Jv1YRL4hzPZkCOi78vCwUYYYZ66OUXkW6k0450vgVMQjYDJ6DqSMiOhNJIfHtNhd5dGw
         GZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HPlM28T/oJ4/6Xh6FGi+9sK76pxmz7U2+VXMGXF95EA=;
        b=Y7OzUJD7QAKLJYiDONxwCg7l6tYc35TSpGQgu/Rx0vj9n0jQjYO1bnBnvY5j1sg3bm
         LWp1Hhzhb8VWJ5cHkKRNZGNM+3b7B9fbLQ6jtbLnCOvYMg6Zkx+V6t7OQqu1nYbCo5u2
         jb+4r/Tbxr7q+1kPiHNUjqUNGCYTeW/FZJxm8rF73ddzY/OM1hd2hoII1GEx6UzDowrt
         vLrujxJLLRTTIi0iFGxd5KiEPuq/O0ddP92rmpNZFX81P87uH7EQ5Ncq0Z2zD7FCJXE7
         aGFJOCCdmJl6CPU//qgz77/hR4noNblATdGvRnzNAHALfHKVpOrcX0HQPopp+OgYNnOl
         ZYjQ==
X-Gm-Message-State: AOAM5315N8IiP/8ywvG4nC5+25Hvm9pxy+XxaLCwT/tneaja/oRlLRg6
        FVFFuFipUR44FEf6sMmtHarJ0v4oSaIY
X-Google-Smtp-Source: ABdhPJziLpu27fJWsU3sVkITkceR26u6rR5Y64vk/3J+BiXXBYz7MRm7l9Do6/o6LTGAZ3FTVFMfj0dfAm9D
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0c:db0a:: with SMTP id
 d10mr2288345qvk.28.1631574619217; Mon, 13 Sep 2021 16:10:19 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:49 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-9-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 08/14] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 265054c24481..515d04a3c27d 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -172,4 +172,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
2.33.0.309.g3052b89438-goog

