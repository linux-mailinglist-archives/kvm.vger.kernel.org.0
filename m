Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1185EEA28
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiI1XhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiI1Xg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:36:57 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B412EFF48
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:36:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id o1-20020a170902d4c100b00177f59a9889so9076295plg.13
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=3Yq7CLybwWK+RFrws3rXKi2UuiysUZtk+qDRhATTop0=;
        b=Ea3Z5w53CFnMPujNQZAL9/uyD/3RiI7TVHdzhFSB9a8FOkzqbjbzGOxhA4f+pYpUWw
         kjvVsSZ6gIciDfWplCOpp7+3o4acPhjH6dc+IvjtH+lE5CWHG2Ea9+G+CE11ZFELwUZK
         OssDKu/flHUvN9766NJUh8fo/586Rqz/K4gn/pdCfbVVLA++Uj/lLB4kVvEAhA+/3wc3
         wfvCwcDC1z9OuWx865t3SCfgnvkQ9d51HFyuFOuoelHQe+3oJDYrJMQe7P2gDorQH3zg
         XjCTtTjbD9jMb5aWKPys4tavSYdDCEPUg5Eq6Mjgt49Mt93NSLF3SUKoSd+FU11Koa3B
         y2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=3Yq7CLybwWK+RFrws3rXKi2UuiysUZtk+qDRhATTop0=;
        b=ANY+MSeATAd9IvjLHkYV3cn/mUcOrStltNvpJwSDO781N0EMFbH/LXtSWj9W+Dq+7O
         lBozVwMumLr7HxTZP0NYxSgVKDXstcRedVyEXHGUtpwSOuXtFvqAzNYhRNZBgAHFgLj2
         CBGOidPytJRYz4/itepO0bFPYIAi1nyypJKker56Hdce9K9RHLb0d882bhfdVgnr4KsT
         EY8ciBdkXs5qhZsT/93ra6txbGcisjVkjYc9Eh8Q/cB/gcKujQlpk+dt5vsPnrpBEhrb
         +ASlF3jCR9UioALk2CpbyHtyNiril9Le11dKnnfUm38+AVuI7rivhX4IfhtWXbR1qXgx
         tfCg==
X-Gm-Message-State: ACrzQf2cBZoq+0e6LXBDgccat4BrWxbtKr/Bt5+rSvqj2LJuyV1p5w/6
        mNEhar8B0hhL1F4k+HUX8AjOFMgC6PE=
X-Google-Smtp-Source: AMsMyM4fkY7buPPc/43yyEhSXtWDuxs9cmm2ZivmHyGaIMKrEDJWrAlpCSP0tsKKX4mKhBMrtBkfhXhZ+yA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32cc:b0:178:41c1:2e41 with SMTP id
 i12-20020a17090332cc00b0017841c12e41mr462492plr.126.1664408216145; Wed, 28
 Sep 2022 16:36:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 28 Sep 2022 23:36:46 +0000
In-Reply-To: <20220928233652.783504-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220928233652.783504-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928233652.783504-2-seanjc@google.com>
Subject: [PATCH v2 1/7] KVM: selftests: Implement memcmp(), memcpy(), and
 memset() for guest use
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement memcmp(), memcpy(), and memset() to override the compiler's
built-in versions in order to guarantee that the compiler won't generate
out-of-line calls to external functions via the PLT.  This allows the
helpers to be safely used in guest code, as KVM selftests don't support
dynamic loading of guest code.

Steal the implementations from the kernel's generic versions, sans the
optimizations in memcmp() for unaligned accesses.

Put the utilities in a separate compilation unit and build with
-ffreestanding to fudge around a gcc "feature" where it will optimize
memset(), memcpy(), etc... by generating a recursive call.  I.e. the
compiler optimizes itself into infinite recursion.  Alternatively, the
individual functions could be tagged with
optimize("no-tree-loop-distribute-patterns"), but using "optimize" for
anything but debug is discouraged, and Linus NAK'd the use of the flag
in the kernel proper[*].

https://lore.kernel.org/lkml/CAHk-=wik-oXnUpfZ6Hw37uLykc-_P0Apyn2XuX-odh-3Nzop8w@mail.gmail.com

Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          | 11 +++++-
 .../selftests/kvm/lib/string_override.c       | 39 +++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/lib/string_override.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 8b1b32628ac8..681816df69cc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -48,6 +48,8 @@ LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
 
+LIBKVM_STRING += lib/string_override.c
+
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
 LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
@@ -221,7 +223,8 @@ LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
+LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 
 EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
 
@@ -232,6 +235,12 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
+# Compile the string overrides as freestanding to prevent the compiler from
+# generating self-referential code, e.g. with "freestanding" the compiler may
+# "optimize" memcmp() by invoking memcmp(), thus causing infinite recursion.
+$(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
+
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
diff --git a/tools/testing/selftests/kvm/lib/string_override.c b/tools/testing/selftests/kvm/lib/string_override.c
new file mode 100644
index 000000000000..632398adc229
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/string_override.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <stddef.h>
+
+/*
+ * Override the "basic" built-in string helpers so that they can be used in
+ * guest code.  KVM selftests don't support dynamic loading in guest code and
+ * will jump into the weeds if the compiler decides to insert an out-of-line
+ * call via the PLT.
+ */
+int memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--) {
+		if ((res = *su1 - *su2) != 0)
+			break;
+	}
+	return res;
+}
+
+void *memcpy(void *dest, const void *src, size_t count)
+{
+	char *tmp = dest;
+	const char *s = src;
+
+	while (count--)
+		*tmp++ = *s++;
+	return dest;
+}
+
+void *memset(void *s, int c, size_t count)
+{
+	char *xs = s;
+
+	while (count--)
+		*xs++ = c;
+	return s;
+}
-- 
2.37.3.998.g577e59143f-goog

