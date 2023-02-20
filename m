Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D1269D50D
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 21:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbjBTUge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 15:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBTUgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 15:36:33 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02030D536
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 12:36:33 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536bf635080so14440307b3.23
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 12:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RSymFs40i6d6OwgrTWXZfYmIbkSLNc1NhJ3pw7+PMQE=;
        b=bjEhGM845bJIaSKds6vRWBXgLFR4FmMdUqTQ9sxkGgrPg+ZUX1jSjFhk8nqKxU5DEQ
         kofTOnvNenkOahQmKrQZMPMx/iF3JXgT9Tu1hC2yxeYAyNjIpA1jwvm1s4orDd7l2k1k
         nIrKQ0PmfHfB9cw4eQqaqzMGt14dyOHcPQN1MV1RedAVmlB+yy92YhNnd4p8J6FeILYO
         h83nul3TpWYFxamnsz/B4M0LkLgWtQfQWLDzpmIOMYnfnCY+GAo0jJU79juiwPzGdJ1c
         2+83ApUKGPPPsNF1P6Ca/ZXOqSgJx2djS1phUCz8mquqNB1HzUOPXBGFu72w/PPIVlZL
         H1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RSymFs40i6d6OwgrTWXZfYmIbkSLNc1NhJ3pw7+PMQE=;
        b=o0bTpmCHVzgf2fglUHNnhE24ZXG86vNi5uumod6bH0sLLyYvMK9BCh3XKMrP0p/ULn
         urUJbu2ScZGWftBTw27PawvIeCgS54bDQnb7MjxPVvoYJLm9HmI125YssklmlduSOPPa
         NciFASWKsSWZoM6k1P37O/O1jfdEMvQ9g0aqjyzSO1cZtF6g3YGT3e36ej6nFkQvSK6F
         VUNFEA95KlAREBETapGfTtfDHPncKxc+Fu6Tp4XozKCuKrf83Rh9nVqAEWrgXpmakcad
         ycj3powjU8e7zpAu7N5sIq6kDymOJP79fksnsPI91vFcmYNF6zPKSFHF3W2Urelyiy/Y
         kDMQ==
X-Gm-Message-State: AO0yUKUuRt7Ff5kg5eS0mCRaS01B13uK6xvibVbmOIaUoDx5mJGyBO9A
        5gmtXhOekhEZ2yiyi7G4Ykwg6UB9P5tgfwnc+Q==
X-Google-Smtp-Source: AK7set+Sro9XywVF/fGDxwbk3wIOyaC3xy2nhpUUZRpUAC3DZ0rsIIMDzvwPqJQSYbkYxV7vF9Cyqj26wQQrRb8pbQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:10a:b0:985:3b30:f27 with SMTP
 id o10-20020a056902010a00b009853b300f27mr208158ybh.13.1676925392196; Mon, 20
 Feb 2023 12:36:32 -0800 (PST)
Date:   Mon, 20 Feb 2023 20:35:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230220203529.136013-1-coltonlewis@google.com>
Subject: [PATCH] KVM: selftests: Depend on kernel headers when making selftests
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
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

Add a makefile dependency for the kernel headers when building KVM
selftests. As the selftests do depend on the kernel headers, needing
to do things such as build selftests for a different architecture
requires rebuilding the headers. That is an extra annoying manual step
that should be handled by make.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

This change has been sitting in my local git repo as a stach for a
long time to make it easier to build selftests for multiple
architectures and I just realized I never sent it upstream. I don't
know if this is the best way to accomplish the goal, but it was the
only obvious one I found.

 tools/testing/selftests/kvm/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd936..857c6f78e4da 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -221,12 +221,16 @@ LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
 EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*

 x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
-$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
+$(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c headers
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

 $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

+PHONY += headers
+headers:
+	$(MAKE) -C $(top_srcdir) headers
+
 # Compile the string overrides as freestanding to prevent the compiler from
 # generating self-referential code, e.g. without "freestanding" the compiler may
 # "optimize" memcmp() by invoking memcmp(), thus causing infinite recursion.
--
2.39.2.637.g21b0678d19-goog
