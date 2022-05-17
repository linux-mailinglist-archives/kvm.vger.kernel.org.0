Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AA952AB7A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbiEQTFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352496AbiEQTFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841703F317
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:37 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d125-20020a636883000000b003db5e24db27so25480pgc.13
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8SU1GuP2cyDWM63hDryguetbkZujTr91I30YEfc4GrA=;
        b=NhnGsW+szGxLYqFSjgrWkaisa8/EcBBpzaFzxQr81YElGjfsPFIx3iG/egKZtIJse9
         GeDqJiksM7SsF0RWC6lTycgI6A7OD3fchVv0vqFQxl7nqWv7xFmSuZIMKUJ9IEWr7Dtc
         w5UguQIuWZ6MX2/N/i+JW0XwoerWE4qWHlCVb6SUeRV8hGhJdc3reHMId9DYR7s8Z4Th
         LvCpT3V8bAyDTJLw+sSiPKwOSAB6zknlXe/KMRKsq/PyBsMKAElwxfHw92WVoEwbpl/t
         ypOvVJUpBsykCE7jmpbhJ7aDnQGIbFGAelGv5FWk6jK7puZexKWM9KrplECH5jlRuwaO
         OFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8SU1GuP2cyDWM63hDryguetbkZujTr91I30YEfc4GrA=;
        b=ukNu0J0L+OkrLCd/2fnAJZsgmaZMFJdniFtoYZbWp9fpo2mEASEX3jQHlcwCrGlycI
         CC47L9yEewpmaLwRxgPZQ9EqZ0GBQXWLLeJe1ImOWIwZubj0CAPxGhyfShmpWvBX+0DK
         3Jkzt1TwxLkPT9EXV5O/9h74bmd9Pg8gCxxVE0Oq70DmyD6gYCuKQ00lneAego89nMfi
         SJdmtRQloacKwSvb8ThSI7T+AzEpjq3nwwO2EleEHD8lddkRvJzzr0pXUcX5eWM5g21K
         9P8mR0b3WSERGWRV5FDxSQNyUNT08ZA5v4Z21MC+uN2AsGuGGt0eWtxu3Xcg9h6enoGS
         YFeA==
X-Gm-Message-State: AOAM531YnYO+y6XgCWMQn9AL+5jG2GCTjbXNDo9IFl7srESOnMpdPf5q
        I1YuMFrd0nhJpUtfYSXFg8IfK/674Jn2lw==
X-Google-Smtp-Source: ABdhPJwt5Ir1aSpVb7v5ikjcKlozi84JIaAt7BC6BmQMas4MM4c9O2yV0rA7KoIpnL0VVaRTie/ydjAzG2RMrg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:4515:b0:510:9ec3:e815 with SMTP
 id cw21-20020a056a00451500b005109ec3e815mr24099159pfb.65.1652814337206; Tue,
 17 May 2022 12:05:37 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:21 +0000
In-Reply-To: <20220517190524.2202762-1-dmatlack@google.com>
Message-Id: <20220517190524.2202762-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220517190524.2202762-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 07/10] KVM: selftests: Link selftests directly with lib
 object files
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

The linker does obey strong/weak symbols when linking static libraries,
it simply resolves an undefined symbol to the first-encountered symbol.
This means that defining __weak arch-generic functions and then defining
arch-specific strong functions to override them in libkvm will not
always work.

More specifically, if we have:

lib/generic.c:

  void __weak foo(void)
  {
          pr_info("weak\n");
  }

  void bar(void)
  {
          foo();
  }

lib/x86_64/arch.c:

  void foo(void)
  {
          pr_info("strong\n");
  }

And a selftest that calls bar(), it will print "weak". Now if you make
generic.o explicitly depend on arch.o (e.g. add function to arch.c that
is called directly from generic.c) it will print "strong". In other
words, it seems that the linker is free to throw out arch.o when linking
because generic.o does not explicitly depend on it, which causes the
linker to lose the strong symbol.

One solution is to link libkvm.a with --whole-archive so that the linker
doesn't throw away object files it thinks are unnecessary. However that
is a bit difficult to plumb since we are using the common selftests
makefile rules. An easier solution is to drop libkvm.a just link
selftests with all the .o files that were originally in libkvm.a.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 8c3db2f75315..cd7a9df4ad6d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -173,12 +173,13 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 # $(TEST_GEN_PROGS) starts with $(OUTPUT)/
 include ../lib.mk
 
-STATIC_LIBS := $(OUTPUT)/libkvm.a
 LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
-EXTRA_CLEAN += $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(STATIC_LIBS) cscope.*
+LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
+
+EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
 
 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
 $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
@@ -187,13 +188,9 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
-$(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
-	$(AR) crs $@ $^
-
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
-all: $(STATIC_LIBS)
-$(TEST_GEN_PROGS): $(STATIC_LIBS)
+all: $(LIBKVM_OBJS)
+$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.36.0.550.gb090851708-goog

