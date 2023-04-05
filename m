Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0636D8B02
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 01:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjDEXQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 19:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjDEXQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:16:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4254146B7
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:16:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d83-20020a25e656000000b00b8befc985b5so1697900ybh.22
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680736570;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YT43EBmfsq69cBeLyMuKXrzVUMQA2ypSKJrpRk2iGxY=;
        b=UIkhJKCv7Em0i2EaWFrvzu2rJoFHCpOYI/Mqa5/Pf0b+vaql4DYYtuoRcg5jjuPHST
         duOp9NgSMgSycmYvLVpUKOMB0IL1++bi0VotFg57/1kGyg1UAewAC6WmMnqGaEEDtp0Z
         Zap1DYtXX4hWxGG65yy9/hp5BtLHRys+JR7E4RlG54b5u9lvXqbRBnmCq0wwrUpz917n
         Gso2KvNDLQDh5n6Xk3wMwK8n65YKkhLBDrlnnFhOnIBaF4egdOqbh+raCv0F1jNRbfW5
         fE4PEqJvteH8asMNCziz6elzsHn+BMDodNl44fRipCZewF7HcoX+uQKFewbxafepBQt+
         Ie2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680736570;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YT43EBmfsq69cBeLyMuKXrzVUMQA2ypSKJrpRk2iGxY=;
        b=oxWgyg6yjZW4UIKSz/UQeyUon+W5NusnufwvoIzJjIrqoDeAsOYd1nxUN6XbsKmjFd
         miXkKxUKZkdGJdGdRIonDEE64Z3BYmSELXj8leCsXp0Mce+DfvAAuj5+CG9wahb25VNr
         HiTXbh3i+q6Hp3F7Qo1Gp0q50kcMaBEv2DEyAXtQoWscRnC9KolhDhgX5i9vmH0QJ/ao
         ZYbrHmGAFfYHqrb9KlCfye5xZtY1TdLHrRt9fHjarUe4aJOL8J96gZY8aBt2mSoUrNxj
         0XC7cBTJKuvlqwlRSTGUwEdbaWEsd280VwhAl+4NeVlnzRaf0dYjr1OyxQzxY3+n4XFU
         9dGg==
X-Gm-Message-State: AAQBX9dKi/beW0Em4s/sSsCBN7pVdfOjgh/h4zZfSZOWwZb7hnZUoLX9
        nZZLXvO6EBABvVetvLJQ2BP/pnf8WcU=
X-Google-Smtp-Source: AKy350b8UTKcis8pyC063r/wr5/On68fva/TUDepa4gASJ+H4pom6iXa/azzX7CpCXH5KBUZ9MGu+n4JYyM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af42:0:b0:546:8e4:703f with SMTP id
 x2-20020a81af42000000b0054608e4703fmr4785682ywj.8.1680736570585; Wed, 05 Apr
 2023 16:16:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 16:16:06 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405231606.621650-1-seanjc@google.com>
Subject: [kvm-unit-tests GIT PULL] x86: Fixes, cleanups, and new testcases
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

Please pull a smattering of changes, most of which have been floating around
for quite some time.

Thanks!

The following changes since commit 723a5703848d91f7aea8bc01d12fe8b1a6fc2391:

  nVMX: Add forced emulation variant of #PF access test (2023-04-04 13:10:21 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/kvm-unit-tests.git tags/kvm-x86-2023.04.05

for you to fetch changes up to 408e9eaae1c628b4895c213ee1eeb9ab3f42effb:

  x86/msr: Add testcases for MSR_IA32_FLUSH_CMD and its L1D_FLUSH command (2023-04-05 14:34:06 -0700)

----------------------------------------------------------------
x86 fixes, cleanups, and new testcases:

 - Fix goofs in the configuration related to the new FEP access testcases
 - Add a FEP test for an CPL>DPL non-conforming segment load
 - Fix issues with the RDPID testcase in the "tsc" test
 - Fix various assembler warnings
 - Add x2APIC testcases to the "msr" test
 - Add PRED_CMD and FLUSH_CMD testscases to the "msr" test

----------------------------------------------------------------
David Matlack (2):
      x86: Run the tsc test with -cpu max
      x86: Mark RDPID asm volatile to avoid dropping instructions

Michal Luczaj (1):
      x86: Test CPL=3 DS/ES/FS/GS RPL=DPL=0 segment descriptor load

Sean Christopherson (8):
      x86: Set forced emulation access timeouts to 240
      x86: Exclude forced emulation #PF access test from base "vmx" test
      x86/msr: Skip built-in testcases if user provides custom MSR+value to test
      x86/apic: Refactor x2APIC reg helper to provide exact semantics
      x86/msr: Add testcases for x2APIC MSRs
      x86: Add define for MSR_IA32_PRED_CMD's PRED_CMD_IBPB (bit 0)
      x86/msr: Add testcases for MSR_IA32_PRED_CMD and its IBPB command
      x86/msr: Add testcases for MSR_IA32_FLUSH_CMD and its L1D_FLUSH command

Thomas Huth (2):
      x86/syscall: Add suffix to "sysret" to silence an assembler warning
      x86/flat.lds: Silence warnings about empty loadable segments

 lib/x86/apic.h      |  59 +++++++++---
 lib/x86/msr.h       |   4 +
 lib/x86/processor.h |   1 +
 x86/emulator64.c    |  16 ++++
 x86/flat.lds        |  14 ++-
 x86/msr.c           | 267 +++++++++++++++++++++++++++++++++++++---------------
 x86/syscall.c       |   2 +-
 x86/tsc.c           |   2 +-
 x86/unittests.cfg   |   6 +-
 x86/vmexit.c        |   2 +-
 x86/vmx_tests.c     |   6 +-
 11 files changed, 279 insertions(+), 100 deletions(-)
