Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47A52F63D
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354123AbiETXdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348253AbiETXdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D5219FF7F
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:08 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r14-20020a17090a1bce00b001df665a2f8bso5358256pjr.4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uIcCRTk30Rd3Z1grC6z/5SkL7Y9z8d0k84iCVKmVWzQ=;
        b=YjSiYjx2ENUy1/0HB+kQNJnmnRJmYT/VE/dNmCxKFY+yzvldUgLpr5SgkevfN6+AEt
         5nI3g62miRCQUDmYQUOZ+HHroYnhdkK4qjwlEwwbpjAiamAjjCKEFQmpUTL9Wo9g/ALT
         D9lGpcnX+JhlV1Hss986OK29PUBwBGKDZis3ub6kjX7Rqwj0aQ5zl4R8MtPIr5BdOl27
         AlGvXMZRzIh9Hqhc2V/WwmkpnHccj3Qs8XWG2F6tBJYafiO9ZFGZpv4EntuGBjJp4i5S
         PqkefuTnJ0ZC5DO0TCpP6tnmwGz0pZf8JAKs5Je3aVaDoTc5ZRttGH64jCLmfjp4dcbV
         22gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uIcCRTk30Rd3Z1grC6z/5SkL7Y9z8d0k84iCVKmVWzQ=;
        b=PrYGOTs/aYdrqB5sUKJawx/YoFpFQK7QdAQb5VfK59TGdXkiSsGSBwPiG2CnEaJ8c5
         C321kKJlOS8yqrbzLFmcVRIRFAFN2HNVFtkAhUlC6di9EW6J4da1gyVo60kp1hUYlKcX
         ZkMfqg0A+PUPVRjqBW/AGKcZaqDmUYHEJkSvkm9mvYt4QOn8bdUYmypvQTgnNkBfNexP
         ta+lDvXj2+IagVACXt6WJ71uwWGqe5UPNDnZmIQ3VWqAw7dcOUzf1lSzLngvz7VqItAa
         Xb6+ZO4GfMIC2Aj9KtksQbj9RLHPuEkjWLU0MhjplM5+dB4a8OBzBiQ/Hv/SChYzhaZE
         4ikw==
X-Gm-Message-State: AOAM533Lts7bgOUcuenZVmiXj0+3pLXaAbkyEn70I9bSVpy/DBkWCzif
        MmbRT+VM0EtOGoPezZPhB6p/PHn1B4RFiA==
X-Google-Smtp-Source: ABdhPJwUBntIs9c/BhgpeWdPf7WA+InB6rt05MG8XmHTJNz2LVRczjGwep7zsdSn39M6e3CqkqQc1yTI55PdLQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:4f05:b0:1df:afae:180b with SMTP
 id p5-20020a17090a4f0500b001dfafae180bmr13668728pjh.80.1653089587556; Fri, 20
 May 2022 16:33:07 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:46 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 08/11] KVM: selftests: Link selftests directly with lib
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

