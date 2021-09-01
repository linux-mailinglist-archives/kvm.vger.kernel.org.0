Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C6D3FE4B2
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344705AbhIAVPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343901AbhIAVPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:35 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD3CC061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:37 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h10-20020a65404a000000b00253122e62a0so432590pgp.0
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ped5Qc1MM58GGqP18bC+JKvQQkEpWjp7CacWspbiPtU=;
        b=RF+xTrhE1y86Km4Tb2P3P9x56sxf1fIXwOzrKjBM264X3P2jQzCHZAFGTfbfshgqxp
         I3ViPwQGHlQjxAgXUxwylm+7TJXn1t0vKlHBNeiWKYzy32FmgouYKSW1+zXACYXOmERd
         r1JAAHqU3TM8b+t9jnwQP7qDF27X9+iLHlb0cDiMAmb0Wv6zsY9lrfRDcfkC7z9IKFmJ
         Uc7FZRXODjWUGiyg8Nis9o3gpVnPnwn0kNKJwfzsPYJn6kCiBtbCuEpwLZQ4Djl/A/PM
         DwP067BHcP+WdQiUBG6ujxS/hVn3djeGiHvZAJqMiAbzGV9d3zi7VZkLieJlF4xW7BsM
         jeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ped5Qc1MM58GGqP18bC+JKvQQkEpWjp7CacWspbiPtU=;
        b=R15E6Vn7sT7QW6UOPyIdHpMbGiir9qaofZ9lbg9+mOapogeYYHPIMWFdWm386Sdu/s
         aUZClRnkQ9S3ncFqFV7joCwnXSEZ17/nW+jV6uB66ypSHteTVOvANek6j4b45hhlfDNn
         W4uYPzTZjvSzGNM3YTqytis+YBSR6Lv++GojLZHvfoRTsJ7g+vY/Ojivr6S+5QCc9aMH
         AFq+djDPKo70nzc5u99/NO+ZKa5XdKwKNxo15bgyZNmP+jqoNBTzeeIZASXy/Ta5aL2C
         6YzAbr8qP1kOsd65zaNXjSS1oPKlKsiUm1Usc1coz5Ubb+TlQd4R8HyZUiqkjmQQQwqS
         t2QQ==
X-Gm-Message-State: AOAM532MzbWZCLnpztbnECVQovz3aYL2tdxJusszJd5dtMn8Dy8ugBS+
        Bt4GY2sWq6YlCTp+xgfBt3gdpoeSCgDi
X-Google-Smtp-Source: ABdhPJzrG1HjvKDU2BB/zBmu2XADs6gKwEPEuy+cbmfKmRvnNPWrGZDzEUEU4Y01W3RLEFRXnQKuk3qmFLfy
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:7d4a:0:b0:3ef:ea37:1422 with SMTP id
 y71-20020a627d4a000000b003efea371422mr1327446pfc.0.1630530877389; Wed, 01 Sep
 2021 14:14:37 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:07 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-8-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 07/12] KVM: arm64: selftests: Add support to get the vcpuid
 from MPIDR_EL1
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

At times, such as when in the interrupt handler, the guest wants to
get the vCPU-id that it's running on. As a result, introduce
get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
requested caller.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c35bb7b8e870..8b372cd427da 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -251,4 +251,23 @@ static inline void local_irq_disable(void)
 	asm volatile("msr daifset, #3" : : : "memory");
 }
 
+#define MPIDR_LEVEL_BITS 8
+#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
+#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
+#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
+
+static inline uint32_t get_vcpuid(void)
+{
+	uint32_t vcpuid = 0;
+	uint64_t mpidr = read_sysreg(mpidr_el1);
+
+	/* KVM limits only 16 vCPUs at level 0 */
+	vcpuid = mpidr & 0x0f;
+	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
+	vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
+
+	return vcpuid;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.33.0.153.gba50c8fa24-goog

