Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8C85B2A77
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiIHXfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiIHXd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:33:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C558910F8E7
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 16:31:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id b9-20020a170903228900b001730a0e11e5so119680plh.19
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 16:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=7Rae3f/XG8eHxbe+XI3rjEcvv9iBFaTeOYNpjRbfcJ8=;
        b=P1HVemU5Q8l1jHsQ63dpPPBxDNfL3tb1pUm8q4PL+UgH4QBu4+NtJgd8XkKKaIWo+4
         k1CEKZkaGyuYGCVnuCKb4hFmgnLdIRztZGXNvIX5oVQBfUCzOqxLRf8mw1ERykDWH4NJ
         wy2ZzK0YQlXRJNHEoo7w63tqN+10/phJMQjAVrdtqo+M1nI1Jkl3130hL+fAKd+c0NMi
         BWLVTPqb+2OuhbG2Emeuiwo9CbXF8aCMNVNlaMCUNSMSp4E3NPdj9AdWmNb3LGydn4yg
         Y30xOFFHvJ1pOKV2OeWGI7rgXEs19ufmuhDW8TVCAPcnC1BoxH1cAR2Qw5FAO8v1478J
         wMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=7Rae3f/XG8eHxbe+XI3rjEcvv9iBFaTeOYNpjRbfcJ8=;
        b=MgFnqXfOWEs17tGW+y+BMgFN6isOp6pS4Qg3ugLd3sXhfdo3TxCbmKKYhV70gKt4g/
         9QZSTvKtF5bLw2OU4N1lnTQbVKj1KsQylFtybasqK9dhPJQYnw8ZNqsTanUFTSOPEfTc
         Mnqcc1lzZgz+ZZxH/QfXTiZxuksD6CfslQmATACXI7k+ggQb9ZWTO6aD/ZYKFSrAY3TT
         RS/PZXZUQU1TyA0Tu9HRveHXqvkQC1PLv4INHdUFyp5lhmPYgiNFotRlwKP3UeYCHKWW
         FWQIL/utg6CnJ5ihB6uZPkC6EZXdYXnFt2PbEE0x3KAAuFomPOuKtPpryapSuoJW+IGA
         1P1g==
X-Gm-Message-State: ACgBeo2FKhOYTYe0Z+ISkG+Y+00hOibtbyreuEeE222YvP4zYvClhwj3
        zDJMzi/cbelxTZBfZWon/djoq8LAk0A=
X-Google-Smtp-Source: AA6agR6+JFj4LISGeG3WjfMkkR4u9HVYWVC84UL5YJpClnQ7aQNZeM9iC7B6L5Hv/dEp8eGr9UV8LnDK+pw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr118873pje.0.1662679901039; Thu, 08 Sep
 2022 16:31:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  8 Sep 2022 23:31:30 +0000
In-Reply-To: <20220908233134.3523339-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220908233134.3523339-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908233134.3523339-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: selftests: Implement memcmp(), memcpy(), and
 memset() for guest use
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 tools/testing/selftests/kvm/Makefile          |  8 ++++-
 .../selftests/kvm/include/kvm_util_base.h     | 10 ++++++
 tools/testing/selftests/kvm/lib/kvm_string.c  | 33 +++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/lib/kvm_string.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4c122f1b1737..92a0c05645b5 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -48,6 +48,8 @@ LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
 
+LIBKVM_STRING += lib/kvm_string.c
+
 LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
 LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
@@ -220,7 +222,8 @@ LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
+LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 
 EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
 
@@ -231,6 +234,9 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
+$(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
+
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
 $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..bdb751f4825c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -173,6 +173,16 @@ struct vm_guest_mode_params {
 };
 extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
+/*
+ * Override the "basic" built-in string helpers so that they can be used in
+ * guest code.  KVM selftests don't support dynamic loading in guest code and
+ * will jump into the weeds if the compiler decides to insert an out-of-line
+ * call via the PLT.
+ */
+int memcmp(const void *cs, const void *ct, size_t count);
+void *memcpy(void *dest, const void *src, size_t count);
+void *memset(void *s, int c, size_t count);
+
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 unsigned int kvm_check_cap(long cap);
diff --git a/tools/testing/selftests/kvm/lib/kvm_string.c b/tools/testing/selftests/kvm/lib/kvm_string.c
new file mode 100644
index 000000000000..a60d56d4e5b8
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/kvm_string.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "kvm_util.h"
+
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
2.37.2.789.g6183377224-goog

