Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ECA52F568
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353805AbiETV5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353811AbiETV5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:45 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311781A074E
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x23-20020a170902b41700b0015ea144789fso4635448plr.13
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uIcCRTk30Rd3Z1grC6z/5SkL7Y9z8d0k84iCVKmVWzQ=;
        b=EYtQDvWp5wBfanyb1D6exMeBbT7nrNc+auo5+cFdRJ2DE20oLu9Gi0DyNzf/T6zb+Y
         XdEVmYsRuE1BD9Wiube3BwIH8VKrjCTWyo7Z4UCsbvX89EU3K2T8lsVBrY/8H+4cpCKZ
         O5vzbA+4ImpFttuaJXcFwThXM79fiarmSwlnmQJCPtICSClsUabS5+X5JLpLQEBn/8Mt
         RZox5TlGHcwbXsjekM1wFngCwVQfT1zphIbavrL8EBRPkENmUXgZlNQSYNNXjxZELnbM
         9VQUi7wgJ6LwPzDAcLZcVBwObeGOYj4ZbGQOFAsonBRgorpos+3fPae3WHAcyF4ZQmfe
         btrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uIcCRTk30Rd3Z1grC6z/5SkL7Y9z8d0k84iCVKmVWzQ=;
        b=OaizRMlhkhGK0gbec3kpWMgQZJrZD04TNWju5DRlWxnfXhCFEn18s2Q0MK2ZH6ZMAv
         yNCdSVkaKNuAsKqtZVDrw54zpTyW8imAT6ZTh5WTsEe5Y2rQQD0u6km/mw6Zft5egBu3
         5bzD5yuldhU0m5uTYkb1Yzq5G8j+XMEnA3BMW/gpBzgVYxRjKASxL3iPBXsHIK4D/G8A
         tQerdk4jnHST7x7fNFLVG88aq0U69OflIC8vLLoRNgmA4djZYV0D0tT29XzE73ARFhAP
         Cyzk1WPqIDG1FzRBK5wscC+BhLwLYI0unxN2KDPMuzapCdf2VJc+in/MSS78Pdy+2qEG
         2pgw==
X-Gm-Message-State: AOAM530JLxxv0jxAK0y/2EpoCOKW4MkUn9F3vhmiaHlfpbVovgU9CCI0
        4LRYArpbJ/TgTOhRru0gCx0W4DqFppDu6g==
X-Google-Smtp-Source: ABdhPJwo5l12LfoisYsB2jcK5fLSiEC52KVseoy5cSbiqNBDIIua+fn3ipBal+FIf6V52RiuGbg3W3q8Xvqo5A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:6b83:b0:15d:1ea2:4f80 with SMTP
 id p3-20020a1709026b8300b0015d1ea24f80mr11527203plk.41.1653083860694; Fri, 20
 May 2022 14:57:40 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:21 +0000
In-Reply-To: <20220520215723.3270205-1-dmatlack@google.com>
Message-Id: <20220520215723.3270205-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520215723.3270205-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 08/10] KVM: selftests: Link selftests directly with lib
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
 tools/testing/selftests/kvm/Makefile | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ae49abe682a7..0889fc17baa5 100644
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
@@ -187,12 +188,8 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
-$(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
-	$(AR) crs $@ $^
-
 x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
-$(TEST_GEN_PROGS): $(STATIC_LIBS)
+$(TEST_GEN_PROGS): $(LIBKVM_OBJS)
 
 cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
 cscope:
-- 
2.36.1.124.g0e6072fb45-goog

