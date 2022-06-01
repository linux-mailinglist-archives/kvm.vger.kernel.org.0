Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB053B030
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 00:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiFAV6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 17:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiFAV6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 17:58:43 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAB6431
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 14:58:40 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id b200so2399794qkc.7
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 14:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tgjb0daVcZ+IxzK5+K8hAdNIPu4d7hC8GnrZOqSwoN0=;
        b=Ghuj/TACltxgQ/qpUet331XfuJgaB6Z2YkEYiMiwuB8fdhAo3c1Of00hejwmjkqALQ
         BbSIg9Tk4/maD4I7llZbk2FzzVly6GcWkQDI46+Ym/X1Zla8D60RPqUGctWysqzkYu7C
         KEUON7wLZn9UIFBegU1uNnirC/AaKqXHLoqq8MN+UJAJKTX0Qf4a70bzPmCzxij9Getu
         d3xLhYnZZ2347q5ZArFrPCxiMpqZQUHuIkHJiVnTUqnN09MKgC9QfH7oZ7PhyZklLK4x
         bgBlqWKiSvmyT93ce0YuWr4NyOiRhFsfvXeOJio6MXct/o68Y/kshXWlMWS0gwzjwFgH
         or8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tgjb0daVcZ+IxzK5+K8hAdNIPu4d7hC8GnrZOqSwoN0=;
        b=icMhoff/qCuJGB5c+EMQrohOuDtuldZjhfn4FkJKQU0CV/rs+jVjc2EWrIekytbUlD
         yS+42q6yF3E2qPlmK5np5iXnq8ptLYaEuvA0Y4jPwuaBl+Osjw2fFBHcc/W++j5CR3rJ
         dRI+5c110BZUqTzlVFjaZeyAgU09SPulW8QzXPCane/NNklq2LyyBnbOl4CC57m5fTA7
         BCCy1ImiyHvX9ErEt/H6QgNH7L9MATOWUG+DKD4N+zPmrUFNbDizermTf3XmsZ8zrW41
         b6y/i8wUXk50NrX21UvMkFgN1qDSGd+paQ3psuxPXzTYhjdExkqw08mVxcl900otIpCF
         82Bg==
X-Gm-Message-State: AOAM530lzejLGv75Ml53Q9JARBL0LdGfLGMH6bDcui/Z+yH5cG/jYrCJ
        Yg9vtQ9rInko/2UiIa/dhauWV4Unt1BCwg==
X-Google-Smtp-Source: ABdhPJzpDjOwijipiuI/dRL4sl6GmrzzfbzfbVSAnb6rSW2RU7fJD7j54ClEMPw83qrQDKuMmJ5HSQ==
X-Received: by 2002:a37:2c41:0:b0:6a6:4022:728d with SMTP id s62-20020a372c41000000b006a64022728dmr1526642qkh.150.1654120719408;
        Wed, 01 Jun 2022 14:58:39 -0700 (PDT)
Received: from igor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id f4-20020a05620a20c400b006a659ce9821sm1823611qka.63.2022.06.01.14.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 14:58:38 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH v4 2/2] kvm-unit-tests: invoke $LD explicitly
Date:   Wed,  1 Jun 2022 21:57:49 +0000
Message-Id: <20220601215749.30223-3-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601215749.30223-1-cross@oxidecomputer.com>
References: <CAA9fzEHQ49hsCMKG_=R_6R6wN8V8fDDibLJee1a1xLCcrkom-Q@mail.gmail.com>
 <20220601215749.30223-1-cross@oxidecomputer.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change x86/Makefile.common to invoke the linker directly instead
of using the C compiler as a linker driver.  Plumb LDFLAGS through
to the linker.

This supports building on illumos, allowing the user to use
gold instead of the Solaris linker.  Tested on Linux and illumos.

Signed-off-by: Dan Cross <cross@oxidecomputer.com>
---
 x86/Makefile.common | 9 +++++----
 x86/Makefile.i386   | 1 +
 x86/Makefile.x86_64 | 2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/x86/Makefile.common b/x86/Makefile.common
index b903988..a600c72 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -30,7 +30,7 @@ endif
 
 OBJDIRS += lib/x86
 
-$(libcflat): LDFLAGS += -nostdlib
+$(libcflat): LDFLAGS += -nostdlib $(arch_LDFLAGS)
 $(libcflat): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I lib
 
 COMMON_CFLAGS += -m$(bits)
@@ -61,8 +61,9 @@ else
 # We want to keep intermediate file: %.elf and %.o
 .PRECIOUS: %.elf %.o
 
+%.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
-	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
+	$(LD) $(LDFLAGS) -T $(SRCDIR)/x86/flat.lds -o $@ \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@
 
@@ -98,8 +99,8 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
-	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(LD) -m elf_i386 -nostdlib -o $@ \
+	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index 7d19d55..0a845e6 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -4,6 +4,7 @@ ldarch = elf32-i386
 exe = flat
 bin = elf
 COMMON_CFLAGS += -mno-sse -mno-sse2
+arch_LDFLAGS = -m elf_i386
 
 cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f18c1e2..e19284a 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -6,9 +6,11 @@ exe = efi
 bin = so
 FORMAT = efi-app-x86_64
 cstart.o = $(TEST_DIR)/efi/efistart64.o
+arch_LDFLAGS = ''
 else
 exe = flat
 bin = elf
+arch_LDFLAGS = -m elf_x86_64
 endif
 
 fcf_protection_full := $(call cc-option, -fcf-protection=full,)
-- 
2.36.1

