Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A36D8DB6
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 04:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbjDFCwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 22:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbjDFCv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 22:51:58 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20CF93D6
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 19:51:20 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54bfc4e0330so25982847b3.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 19:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680749479;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kJ0xEgQF9ySSZkJ1udWUusKRKhHJ/x4BBEAEW3s63M=;
        b=ZA9GOLXdyzoyY+9iiwIFLqzxJXLyR+0iFvRT8QKkPklW260WCfGz5CDbQhPhsU+cUs
         5iKKcZoWWdCFMje0YqdCqFzFAL0MB1XkyxHbPOOOSF86nDeZKTFpCd0VbkCpArbz0qi/
         Z2lkfgmzylgKv88TN7HneodnACnhZTP7ayzNKMe9JQUdJ1LmUtGEkXh9k9KEBEY/W0ak
         Vl0zLacKGqCNQt7Zvpmu1uEimaY5ZigunhWRiotJu1xfHpoQER+davqqEP+iAV6ZSJA5
         X1d3jcPm3qTTa4UWCQNCcY9euhzKJToJCO9rPMosMjvos6HBSzJihjhI8J5UpdfXkQJm
         NiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749479;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0kJ0xEgQF9ySSZkJ1udWUusKRKhHJ/x4BBEAEW3s63M=;
        b=EOQTJKc6VkUsRIaRwkqNtBHHnyKeNekLM6I7Gf+hYyfzdgCAtYNj0sdDoW8B/VZODE
         kyv6f77jU0SuL4MQdznwtYkZK7X21Iwao6PYieUTSEfLCY59xNFq9s+Erk/ChsFhw5/c
         Dcf8rabQguvOCHANQpeqpmtp77vtOzN29iGChIg87cqpQ7TnbK5OuFjVDKc7TtZgBfFy
         u7OixG6Em7qIbsxY6Rn0/WhDOMEeXtMfD6BhxFRVzr43ffTQsDceubzywUSMDnY2eWTy
         mhbbaigWtYaKx5ovFYN6iQfj0dDFPEY3VioDBrEbdiCI28+uGJyeNIUyoYHsfw9422q7
         xkIw==
X-Gm-Message-State: AAQBX9fuhdwi1EeFt4+zhtWQYRl4oePO9rjqpNSqKOm/wYwovwjpIEvX
        7z4NcjIQOq85NlBt3OkTXTZE6jMduoI=
X-Google-Smtp-Source: AKy350bnWUBwM2NBq9rOrpbzeELzmIDwZod5dJN1REkZCcOk/1YKCKHWmwRpIZbleUwSzXBUl0kitzOd4TQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:431f:0:b0:54c:bf7:5210 with SMTP id
 q31-20020a81431f000000b0054c0bf75210mr581175ywa.4.1680749479410; Wed, 05 Apr
 2023 19:51:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 19:51:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230406025117.738014-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/5] x86: Add "safe" macros to wrap ASM_TRY()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide macros to wrap single instructions with ASM_TRY(), and to
automagically report success/fault as appropriate.  In other words, make
it easier to write code for testing (non)faulting instruction behavior.

Sean Christopherson (5):
  x86: Add macros to wrap ASM_TRY() for single instructions
  x86: Convert inputs-only "safe" instruction helpers to asm_safe()
  x86: Add macros to wrap ASM_TRY() for single instructions with
    output(s)
  x86: Move invpcid_safe() to processor.h and convert to asm_safe()
  x86: Move XSETBV and XGETBV "safe" helpers to processor.h

 lib/x86/desc.h      | 48 ++++++++++++++++++++++++++
 lib/x86/processor.h | 82 +++++++++++++++++++++++++--------------------
 x86/memory.c        | 60 ++++++++-------------------------
 x86/pcid.c          |  8 -----
 x86/xsave.c         | 31 ++---------------
 5 files changed, 110 insertions(+), 119 deletions(-)


base-commit: 408e9eaae1c628b4895c213ee1eeb9ab3f42effb
-- 
2.40.0.348.gf938b09366-goog

