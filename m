Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4BC6308D9
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 02:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbiKSBxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 20:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbiKSBws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 20:52:48 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7EAC4C01
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:35:06 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x8-20020aa79568000000b0056dd717e051so3990738pfq.11
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 17:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qzw3IRf6ZKe9LngiNeoq0Xsow8qMnOMLe6mysjx7GEY=;
        b=WWS9khtEqbOMUnGtkkRMFWvzWDeu4ayjWFRQDGu0iXtOVJDbGSrq/gFRGxrZKKJlGY
         5URd5JYCZgwjvnTNl+Ti4rcPQweserrYFuLxS4+F3t/CDOTOr8AEBOZfx3Z2J7idO5c3
         IDrXNJR03kAw8HpcOlPfCE2+OuJJLGuPU94IZVw40YREPb5/vCeSYvPEvia9tHwTfU1C
         3eBObmpTzOi0i9sxvSozcBhsXpCtw6mLFCvyTAoFKa+x82RFPn06o73N3tlHftgOtE6+
         Xi5hjcYeXjmsl23MApz3bUysNrg7rYzS/9ickjvQa7GqFIN4rdzGd0NiV/GRPNAISoz2
         56jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qzw3IRf6ZKe9LngiNeoq0Xsow8qMnOMLe6mysjx7GEY=;
        b=CEiiQx5DF/c+GK9JbOVA1aydalTJg+WOIPZ4iQQhCaZYtgjNo/Ga/YNLWP/ZMW9zO4
         5vaH7TI7w9o8e2GR/8+zKyYivEWnjdG14IZxhgP3fFxldW49qUm43nOmwMQCrPEwg6m/
         jHvjkgA/ilJBPJ/abXC+SsAfoyd2GkOdsWqF1LaN/iHoPzv9YRnGPII4KxYyK7Guq5fY
         iFXXfN/0zFU5gyGyOZ9oWiPHMMkjoK8uSzDx52KPxC5RfmO0+mTnBpNxJi4eozy2V/Rf
         HWgYCYpmBXU70VhG8FWcavujZi99Rb9E9c6/XvQV+eBVRqP2vRWa7omWnFy5/muf6Tzm
         4F8w==
X-Gm-Message-State: ANoB5plIBv+gkyhy0/7uL0EG/7s6EE/rOO8lLjA8Wp7l+gszflFlol71
        UUQrNtwZdcTXpeV/nARgqkrl7ixcxNM=
X-Google-Smtp-Source: AA0mqf7p4CLtuFVtgdl7Bc/NuOg5CLDSNQp6GUYPt/V6N4R/KHWFFrAEPbFAt9/8yfYfs5xqa5KFvyBu1UA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ce09:0:b0:470:537b:9d23 with SMTP id
 y9-20020a63ce09000000b00470537b9d23mr8701437pgf.185.1668821706323; Fri, 18
 Nov 2022 17:35:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 19 Nov 2022 01:34:49 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-9-seanjc@google.com>
Subject: [PATCH 8/9] tools: Drop "atomic_" prefix from atomic test_and_set_bit()
From:   Sean Christopherson <seanjc@google.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the "atomic_" prefix from tools' atomic_test_and_set_bit() to
match the kernel nomenclature where test_and_set_bit() is atomic,
and __test_and_set_bit() provides the non-atomic variant.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/asm/atomic.h            | 3 +--
 tools/include/asm-generic/atomic-gcc.h         | 2 +-
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
index 01cc27ec4520..a42733af7d51 100644
--- a/tools/arch/x86/include/asm/atomic.h
+++ b/tools/arch/x86/include/asm/atomic.h
@@ -71,10 +71,9 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return cmpxchg(&v->counter, old, new);
 }
 
-static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+static inline int test_and_set_bit(long nr, unsigned long *addr)
 {
 	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
-
 }
 
 #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
diff --git a/tools/include/asm-generic/atomic-gcc.h b/tools/include/asm-generic/atomic-gcc.h
index 6daa68bf5b9e..37ef522aaac4 100644
--- a/tools/include/asm-generic/atomic-gcc.h
+++ b/tools/include/asm-generic/atomic-gcc.h
@@ -70,7 +70,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int oldval, int newval)
 	return cmpxchg(&(v)->counter, oldval, newval);
 }
 
-static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+static inline int test_and_set_bit(long nr, unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	long old;
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index fcae96461e46..820ce6c82829 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -44,7 +44,7 @@ static struct ucall *ucall_alloc(void)
 	GUEST_ASSERT(ucall_pool);
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
+		if (!test_and_set_bit(i, ucall_pool->in_use)) {
 			uc = &ucall_pool->ucalls[i];
 			memset(uc->args, 0, sizeof(uc->args));
 			return uc;
-- 
2.38.1.584.g0f3c55d4c2-goog

