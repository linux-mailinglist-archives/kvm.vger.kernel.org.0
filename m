Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C80264AC3B
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiLMASF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiLMARZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:25 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B917E1CB33
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:17 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j21-20020a63fc15000000b00476d6932baeso8625895pgi.23
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xj/6XiZ0FcL9g/cIOTUKNxH2a5zHGMGnhonaffOKQyU=;
        b=Ynr5HNzm6tcPWug6yfLA7uxzPSFdxsDbFS0g0RKFnUjDpg1KpLtNRGj/Gf5/eVmZS7
         /E+4Syq2m0k2o5pz9jJkKOO6Sj8cSiSA59XiRJyOIRS4qCG3ooDGOujDsXFak0y3HWEH
         JVE64IrNpMB7KkNprBOvUTG/cEurYq5To2UJjMVj8f7IjF8u6mpzW6rAt4PhQmyqLhQB
         1i18xIcii3lgptRuB9CPP2XNPfFgre8ZBl8B6sbn4hkuTa1njt/nq23+dRz4CjgSzC33
         AdeV5GwIU5qK4qiw325lbgQvG6tA0I6pTb5gl4H3ZodnnRxzTiH/D2U7oooCiaGH4QZQ
         TQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xj/6XiZ0FcL9g/cIOTUKNxH2a5zHGMGnhonaffOKQyU=;
        b=VOTStPN0Jd4mSqf77kOgVa8vdexe2c3H9uAfAnuW+yBDlCol4maIeq5NBPtoKwuauJ
         dzKTPSF+y2NDKBgr5Giv944HOgUWOhadfu7mfmfRmJcVPvF2EKFtYRTGH26aCI8bKNVg
         AkzJgBWrfHNs/Rj8c9yZzu8fVIzDaHeQywbr7+EtJsJQ8M5hOV+/Hdg04lhSKaCwab7K
         6SHLSU3BfSmOyLo8lfJSL+MHQ/42kB2u5GGc4TNhXv1N4CG8mZjJ+gp3j2am9DilelYk
         XhTsh702bMhjbbXsKLHOWXHxUOLRURoU08k63Y4K0HVmyXCx/F3yMKKUG0xKVZvXQfUb
         x0NA==
X-Gm-Message-State: ANoB5pmdk48xa5W30yizImZUXXV2oF4SgCPjCqL/uc9FGtlJ5LdfGt6i
        g2ffF4zEjAnQHfLtlOCk8BPQP9o3AO4=
X-Google-Smtp-Source: AA0mqf7B6mgUqxDLQ3i89LPKmIpCGPzYFo4QfxqabC4YmJpdYxUAVEO/jE0NsIR7MXoyw3EdaxVTTeKRQcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1b21:b0:218:e3e8:c024 with SMTP id
 q30-20020a17090a1b2100b00218e3e8c024mr75063pjq.125.1670890637231; Mon, 12 Dec
 2022 16:17:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:51 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-13-seanjc@google.com>
Subject: [PATCH 12/14] KVM: selftests: Use wildcards to find library source files
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Use $(wildcard ...) to find the library source files instead of manually
defining the inputs, which is a maintenance burden and error prone.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 45 ++++------------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 9cff99a1cb2e..a9930e9197da 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -19,44 +19,6 @@ else
 $(error Unknown architecture '$(ARCH)')
 endif
 
-LIBKVM += lib/assert.c
-LIBKVM += lib/elf.c
-LIBKVM += lib/guest_modes.c
-LIBKVM += lib/io.c
-LIBKVM += lib/kvm_util.c
-LIBKVM += lib/memstress.c
-LIBKVM += lib/rbtree.c
-LIBKVM += lib/sparsebit.c
-LIBKVM += lib/test_util.c
-LIBKVM += lib/ucall_common.c
-LIBKVM += lib/userfaultfd_util.c
-
-LIBKVM_STRING += lib/string_override.c
-
-LIBKVM_x86_64 += lib/x86_64/apic.c
-LIBKVM_x86_64 += lib/x86_64/handlers.S
-LIBKVM_x86_64 += lib/x86_64/hyperv.c
-LIBKVM_x86_64 += lib/x86_64/memstress.c
-LIBKVM_x86_64 += lib/x86_64/processor.c
-LIBKVM_x86_64 += lib/x86_64/svm.c
-LIBKVM_x86_64 += lib/x86_64/ucall.c
-LIBKVM_x86_64 += lib/x86_64/vmx.c
-
-LIBKVM_aarch64 += lib/aarch64/gic.c
-LIBKVM_aarch64 += lib/aarch64/gic_v3.c
-LIBKVM_aarch64 += lib/aarch64/handlers.S
-LIBKVM_aarch64 += lib/aarch64/processor.c
-LIBKVM_aarch64 += lib/aarch64/spinlock.c
-LIBKVM_aarch64 += lib/aarch64/ucall.c
-LIBKVM_aarch64 += lib/aarch64/vgic.c
-
-LIBKVM_s390x += lib/s390x/diag318_test_handler.c
-LIBKVM_s390x += lib/s390x/processor.c
-LIBKVM_s390x += lib/s390x/ucall.c
-
-LIBKVM_riscv += lib/riscv/processor.c
-LIBKVM_riscv += lib/riscv/ucall.c
-
 # Non-compiled test targets
 TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 
@@ -213,10 +175,13 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
 LDLIBS += -ldl
 LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 
-LIBKVM_C := $(filter %.c,$(LIBKVM))
-LIBKVM_S := $(filter %.S,$(LIBKVM))
+LIBKVM_C := $(filter-out lib/string_override.c,$(wildcard lib/*.c))
+LIBKVM_C += $(wildcard lib/$(ARCH_DIR)/*.c)
+LIBKVM_S := $(wildcard lib/*.S)
+LIBKVM_S += $(wildcard lib/$(ARCH_DIR)/*.S)
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
 LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
+LIBKVM_STRING := lib/string_override.c
 LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
 LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

