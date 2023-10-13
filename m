Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF647C918C
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 01:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjJMXsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 19:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjJMXsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 19:48:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8221ECE
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 16:48:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9a45e7e0f9so3692086276.0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 16:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697240893; x=1697845693; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6hgi/RKQNNDqwrxZJncVIOXkyEQBa0Kuqd6mL/NONVI=;
        b=cM+88SkIyAEUBSJJxa2scpPupiGxaygLbvQXpG7FHVaUy5F1FLf/zpKDk3iWmPBPiR
         PhGjpYQ14TMjFe/sUj46UOdjE9rSHOfWcuiwxCMJW58dyzWepJm8VwVgH+sStAPr9Bgk
         gtfQfB3qmEtTHhFD57LJWsFlgXd7qRtXZprumU9YfNZXvWBe2k4ChXhWCXXDZIox2f+R
         ueangIuyu8AibzHP7aba+xQvkSPvP3bDz4lPm0Bdz/6LXkfQPOcsLorPsDEOEEnSuyMY
         H2m69hYIGqTqH6tewUX25QtrvaM8JilZTw8r25x7gCBSj4+M3sKBw5JYibLEiGD4ATpq
         tc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697240893; x=1697845693;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hgi/RKQNNDqwrxZJncVIOXkyEQBa0Kuqd6mL/NONVI=;
        b=MEXlwpIRvvOIRo7FSs0pJp2AwYbTz0yzDOwaggO2w4Z2ll5jKXTult4Wa/E4HQCD60
         HHeoq5MA67YBKayG19J2UjI35ifXCz0PRBdCTypS8Eo3kyYlAgd+GoEuPseFJnQo5UTl
         oLUf0k48UrN6kz9Ibso5r/2Sr92CXRQuQq8lOQKOplgjCGzR0wqPhuU35hGI+tkBScXc
         7SvsEXtOLgztYH6zKwjpKiZKuzDGed0bTtan9/4fQ9etfLN64cOaMZKO70P/SOKWRtY7
         i9TsIp96erAOYKdsg40vVGTgUsvdEXeE7NRKR3m4g9fLA4FDdZYBY0FeIY/5BI7NtXi5
         90jg==
X-Gm-Message-State: AOJu0YyQ/fYiZIO+6kXCc4d/LGcGBMAbCfgnsAHgVci+PjU7vyn2twhC
        8lpkr4ckHyMSXG8WHMyK0eOjNl2qns8=
X-Google-Smtp-Source: AGHT+IHaivMuzoQDghTJEKzI1bs9UMGvipIMbx4EEnKO2yCa0CNcQRZgRYvNj3XkMQz/dTzpu6OTB7mBb50=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2643:0:b0:d9a:b957:116e with SMTP id
 m64-20020a252643000000b00d9ab957116emr173396ybm.3.1697240893763; Fri, 13 Oct
 2023 16:48:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 13 Oct 2023 16:48:07 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231013234808.1115781-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: PMU fixes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull three PMU fixes for 6.6.  These aren't super urgent and have all
existed from some time, i.e. don't absolutely need to go into 6.6, but I also
don't see a good reason to hold them back (they're all tagged for stable, so
it's kind of a moot point).

The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6d3:

  Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux into HEAD (2023-09-23 05:35:55 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pmu-6.6-fixes

for you to fetch changes up to 73554b29bd70546c1a9efc9c160641ef1b849358:

  KVM: x86/pmu: Synthesize at most one PMI per VM-exit (2023-09-25 14:42:52 -0700)

----------------------------------------------------------------
KVM x86/pmu fixes for 6.6:

 - Truncate writes to PMU counters to the counter's width to avoid spurious
   overflows when emulating counter events in software.

 - Set the LVTPC entry mask bit when handling a PMI (to match Intel-defined
   architectural behavior).

 - Treat KVM_REQ_PMI as a wake event instead of queueing host IRQ work to
   kick the guest out of emulated halt.

----------------------------------------------------------------
Jim Mattson (2):
      KVM: x86: Mask LVTPC when handling a PMI
      KVM: x86/pmu: Synthesize at most one PMI per VM-exit

Roman Kagan (1):
      KVM: x86/pmu: Truncate counter value to allowed width on write

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/lapic.c            |  8 ++++++--
 arch/x86/kvm/pmu.c              | 27 +--------------------------
 arch/x86/kvm/pmu.h              |  6 ++++++
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
 arch/x86/kvm/x86.c              |  3 +++
 7 files changed, 19 insertions(+), 32 deletions(-)
