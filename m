Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41CA464AC2B
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiLMARr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbiLMARY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:17:24 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCEA1C923
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:14 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170902ccca00b001898329db72so11758265ple.21
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8EoQ5xUEc1FhkDzFjTM8ar5jGOrCyi+Uxx/y/QqNxRU=;
        b=ipDKG2JVkVU4OEFWDzPMjQvpwLjKrvLtAsE0Q12Ig0QpxJrg8GZmiIm/+azC7Rsqa2
         1pdKNzn7q+j8SVvNFFE1MwcgltFtLpVT1j20hR2QXC2Javgns9JomPzKxX8az0MVR8Lr
         xwxNQ4L+57LcZAeNwj6COf48lC0gORWpzAAh4EHs1sxnOZZrp+oLMfA4c+3AeRny/IkJ
         jwTjCm1aa2Xqxkk8MuRjUDMVdOpUJRa/4/CvkiRx5C364j7RnnRN0GmaWDsiuRVgQoLD
         8mXK/UHXSQfeZuLkyN4NIw4jy3LAgiOHXlbk3sYihSHK7Kz3E1BePP1k4h5mJdMfm87Z
         NXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8EoQ5xUEc1FhkDzFjTM8ar5jGOrCyi+Uxx/y/QqNxRU=;
        b=eRY6+hRA/7IVKFJNcZhd+dou8HcTNgeMpUYIvp8a8wbuQtqarZgNHWPF1ief9o4w7Z
         Dc8741iKPyShf+9D7OE19M12E880FAiHDfRa7i43BAUsSGfd8GcGhzYRexR4biRnu87F
         2lrwbV8MAGzjcufY2TxaHGo3/h5z3IqPZb1+Ddy0BVzh+/RbY6uJxnHi3F5Krlw0ihg/
         olocO5ES9XYJfqvhSz73QLVlnKdJApJz0jGxoM8sMLk5+GNGvgq7FHyhvLsDIGvNIZh2
         QA/qOBdBQjfNS/sGyyiVyVbjGgv3uSkC1OMiqO+yMggfUDcbbblzQ0Vk5bEiCsZqfF5w
         JQvw==
X-Gm-Message-State: ANoB5pmm2AgYzyhHIK1DnZSv4egYeYqRCAn1hL3jvU6ATJCjBDMXYrjM
        J/GwcloySL5liJoB5uNh95PhwsYZWxs=
X-Google-Smtp-Source: AA0mqf41e8RRAh+qKfNTJDDY/qqZQdHGGB0nRmZ6p6Bfn39lpFfpCEPh+Tpnh5gE0AblUZ/3qOhiatioU1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bc86:b0:189:6ab:a97c with SMTP id
 bb6-20020a170902bc8600b0018906aba97cmr77809422plb.39.1670890633860; Mon, 12
 Dec 2022 16:17:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 00:16:49 +0000
In-Reply-To: <20221213001653.3852042-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213001653.3852042-11-seanjc@google.com>
Subject: [PATCH 10/14] KVM: selftests: Include lib.mk before consuming $(CC)
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

Include lib.mk before consuming $(CC) and document that lib.mk overwrites
$(CC) unless make was invoked with -e or $(CC) was specified after make
(which apparently makes the environment override the Makefile?!?!).
Including lib.mk after using it for probing, e.g. for -no-pie, can lead
to weirdness.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 6594ed51eeea..2487db21b177 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -182,6 +182,11 @@ TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH_DIR))
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH_DIR))
 LIBKVM += $(LIBKVM_$(ARCH_DIR))
 
+# lib.mak defines $(OUTPUT), prepends $(OUTPUT)/ to $(TEST_GEN_PROGS), and most
+# importantly defines, i.e. overwrites, $(CC) (unless `make -e` or `make CC=`,
+# which causes the environment variable to override the makefile).
+include ../lib.mk
+
 INSTALL_HDR_PATH = $(top_srcdir)/usr
 LINUX_HDR_PATH = $(INSTALL_HDR_PATH)/include/
 LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
@@ -207,10 +212,6 @@ pgste-option = $(call try-run, echo 'int main(void) { return 0; }' | \
 LDLIBS += -ldl
 LDFLAGS += -pthread $(no-pie-option) $(pgste-option)
 
-# After inclusion, $(OUTPUT) is defined and
-# $(TEST_GEN_PROGS) starts with $(OUTPUT)/
-include ../lib.mk
-
 LIBKVM_C := $(filter %.c,$(LIBKVM))
 LIBKVM_S := $(filter %.S,$(LIBKVM))
 LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
-- 
2.39.0.rc1.256.g54fd8350bd-goog

