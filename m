Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6C95153DC
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380091AbiD2SnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380079AbiD2SnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D62DD64C7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:55 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m8-20020a17090aab0800b001cb1320ef6eso7269660pjq.3
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ivJXS8ClmFOz8lWqCYwCeeuO40j2TNLdx2VYwHTzVUM=;
        b=bj8UQ3z1sTGw4fp5+0p4GZXDcr4HR/zgHyB7xpQA9mEPPKpI6HidykeH1zN8kZJlGd
         gVQ0vxNoBxtT51NUm9EvN50+ojH+LF8OZ0IkxN9mAlrFgdNR4NOF1bzZb/iiWQ4bLck4
         Ks9MdjWp8yErf4C8jiS4E9cHboG/jPNCYXLAHEiBuv0rY+KNCx9TOWd6l+goYNNqqyjt
         88fw99EZ3BUMS50gFMz+RJulnX95zOTpYBbiLdhiGIEqlFNjjdp1eNLWbs511aN3/jTB
         2u+ULxjaNs3ev8XbyUL1/ryNRalaXYHzWHXQ7gYvyEhgil74mhIAmHorGdsjHi4vH1qX
         V+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ivJXS8ClmFOz8lWqCYwCeeuO40j2TNLdx2VYwHTzVUM=;
        b=Wun1PSlp6VJlaCh3lBUp8J6oJTGXlIGhyEzNeGFy0i82DkV1LJkSyTuq3XtgfF00RV
         90GWM1xD40wuOoWxivYVQ7P1CFz7QOCWgasF2lRe8F2SI7FuMhOf5bw8UjawSTCPwgrV
         4QZwoLkB7Nwt15aBNOMYAcpj7//+h1czK0XegGTCCnTgscJIm59kTKsBXnfSIe7r+Qah
         9tot35G3K4SXRIU0AmhZVFuhFyUQoO5Dps5pOhzJ/pSZxZVTEa/7mc0HpI1j1eMb3baG
         aUptTV8aDiiQq45lbMCaPCMksweulf9JUEu1AaW1XwyfcpqZ/mNF/IylWKjz+VZ7YbUL
         zaVg==
X-Gm-Message-State: AOAM5321byFUaalEuAMx5b4Ad9NkZO4QhG5btDTtsUhyqlshn3ibdnaZ
        mdBFm9LpnwledjYQ/Dp/xjoFCmD4nwxvJA==
X-Google-Smtp-Source: ABdhPJyQXT5EpBFIvYzCOVYX2PvIbS5DIYy4dH12s8tjr4xNtodjJG1/cS4unSFXV6wHzICgJA0WJiLDXpoUQA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:d584:b0:1bc:e520:91f2 with SMTP
 id v4-20020a17090ad58400b001bce52091f2mr5525312pju.192.1651257594775; Fri, 29
 Apr 2022 11:39:54 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:33 +0000
In-Reply-To: <20220429183935.1094599-1-dmatlack@google.com>
Message-Id: <20220429183935.1094599-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 7/9] KVM: selftests: Link selftests directly with lib object files
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/Makefile | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..c1eb6acb30de 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -172,12 +172,13 @@ LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
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
@@ -186,13 +187,9 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
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
2.36.0.464.gb9c8b46e94-goog

