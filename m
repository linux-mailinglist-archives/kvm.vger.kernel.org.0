Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8963F0B39
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhHRSoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbhHRSoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:44:05 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964E9C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t62-20020a625f410000b029032bc3dda599so1779001pfb.17
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
        b=M4v7edVYyKBY+V84oWDNulNY+yx4Uze2wbZlUXRS2Aln9eqOffhXiBXP5DqvkJiSS6
         ixVqUwuDxfj3hQwR3DyYk3Rg1Es+zp4/+Bndw5JEEMqIa2SqRk9ViwSiUkA2wFuFM5xB
         EDVY79ZV26X/y44fJVpZSzHM0O24OQkHsMiGP5NVaAgMOxCNwyzeNlaj98UnYeNLSiVV
         3NPTU3nkl3+FXba1M7nb9zipmihuU6BPali7X4+fro6+nVTtq7oJkwx3jU0X53Bb+xsz
         zfnz4UOTYUCfp5iGx6vwnuOZu6kevvHSd+WSbDX4FYIDV6ERrruszwVx7V3PRnFU8XAO
         Dyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hVS0vPea/E7ymOuCPsOem1y67EWYYT9eWBeHAHepsoY=;
        b=l+OYHYrRGQKkKzjxlexyMfIsydsomCi+ot6mQf5Q1u/wDHBODE8KylXyLG+Qq1XOIm
         J1M2UfGYUApycFVoJ/AEhhcQBqHpSBdgJF7NCZc0eGpseiIBDoD0jjXjmBzzoo2RZrkh
         YLIAqjzwO8MxA1pmMeQfwZVUOToGEKmPu27GRY/bh6FWr9ZNwKxKVHxzjEH9G2qAlb/m
         myD2DbT8xKg8rPMqpjpYugEvTJ84BIEgWoDXO71jzi09OPl9wfJuRQwycAYfgeuvV8UK
         P99MykOAIoRV1JAwnBBw6PRfNBcVF11Ktt9wsn0USR7TcRnjPJlVqqD5wxrDimHklWkC
         SQIA==
X-Gm-Message-State: AOAM530cUtOaj63mwfNLLKhx1DWeByfY0Ml5wemCYpyIOyh5mFUTj87E
        8SI5hcAd4lzyzLA6InmK8eFoh2LUmRRu
X-Google-Smtp-Source: ABdhPJwYcXARLYf9x4AaQrRYJ8sgbNkV+MLILfJmXoYMtcvFdw4v4vbdtvvWUMKaPFR8/UlVv8HOd2W4xggq
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:e850:b0:12d:91c6:1cd with SMTP id
 t16-20020a170902e85000b0012d91c601cdmr8429954plg.16.1629312210095; Wed, 18
 Aug 2021 11:43:30 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:07 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-7-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 06/10] KVM: arm64: selftests: Add support to disable and
 enable local IRQs
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

Add functions local_irq_enable() and local_irq_disable() to
enable and disable the IRQs from the guest, respectively.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/include/aarch64/processor.h  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c83ff99282ed..ae7a079ae180 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -238,4 +238,14 @@ static __always_inline u32 __raw_readl(const volatile void *addr)
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
2.33.0.rc1.237.g0d66db33f3-goog

