Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAB3656E00
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 19:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiL0Siv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 13:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiL0Sis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 13:38:48 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19EA25DA
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:47 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j21-20020a63fc15000000b00476d6932baeso7021149pgi.23
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 10:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SCmoLP/gcCtcU6FM3P+vz85yuQZJQpoQUgQ/KHEDKb0=;
        b=VFOfiOuN+y9jASmarE3/9xjbvJE0C7qtpQVESNL+/Wa1/oKMdW08/qSLtZqS9tC8Fq
         ZL0Q/X7VylGYEcZX3afK/VwqFrMOuB/kBYDOYoYm/ueJV5ofLYS2mXGWmb7t6NcRUhZ1
         enF/F1wFLbFzh0o7lRpq8FCF0OdqhswGf3REVc+YQmllXo4rqAUrT327sVdNweA7zaIN
         aNESTsupqhWZ0Xu2bPwVTa9CzYUv9E/njUyB+8a9esQ/J9FHJ86B+UF8O+rH0b1hAAqL
         jJaKbdIfXvs5gSa+QACLKKTOFFHttCANx2RpE8Zu4mUuT4hnWKGGTkD2IOQkHiaVlu9S
         ZAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SCmoLP/gcCtcU6FM3P+vz85yuQZJQpoQUgQ/KHEDKb0=;
        b=R3wZdPT0gUXayklgZuRUUShk887dzfY8PIz+3B7GRn0gInROuEfWUE7wnGBgMli7H1
         em/WyBlgxwr0VVrOOBXRCgTdvLwsSvk9Q7F6wiLwtb0mFgPimRyjONKxdNnby5Vr1SN8
         kM3MjGP4U31mqTrMewFOaPgQ/WTzyx81ApBoBYM65dKnM69vNILnzl9Uy5087UiZfPRE
         ym8IjmhtgALeFCce05HI8X7YaQpbfF9Cgpo7Nqy+aApHtgJN1uqoDPm6y09O66w3IVoX
         tdw2n6P37WhqDFyFz9Zi+PoAZ8SOgJhf1ebmAIj63JpbjP/lNSlstF7a+VMbkWp72gy1
         vbpA==
X-Gm-Message-State: AFqh2kqoscGXNmMJDZsB0FByJrG2jCOfnC+kgb2AuUoPotdMjrtRwRj9
        2cPx8HK2PxuqBXmb30I1NDqVJuYnmd9hwQ+7wjk00tNZGzR/qF3ahSdFemyT3BSHX7uaRopd6sx
        l1mMyjZB+aQCUiM3ITz2nRz7sSN67kuErwCnx5K41iA/rep50di2tMnmqoaezz3L9Z2/9
X-Google-Smtp-Source: AMrXdXupClzX5P2mfbuek8wvrw1OQEo8LBatT1OmS4ZJADftKl4yHz5Co7AAcj0RG4xa0FZTnB5K9/Sa4Qb7AMyj
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:e811:0:b0:558:991a:6671 with SMTP
 id c17-20020a62e811000000b00558991a6671mr1446279pfi.58.1672166327310; Tue, 27
 Dec 2022 10:38:47 -0800 (PST)
Date:   Tue, 27 Dec 2022 18:37:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221227183713.29140-1-aaronlewis@google.com>
Subject: [PATCH 0/3] Clean up AMX cpuid bits XTILE_CFG and XTILE_DATA
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

When running a SPR guest without AMX enabled
CPUID.(EAX=0DH,ECX=0):EAX.XTILE_CFG[bit-17] will be set and
CPUID.(EAX=0DH,ECX=0):EAX.XTILE_DATA[bit-18] will be clear.  While this
is architecturally correct it can be a little awkward for userspace
or a guest when using them.  Instead of leaving the CPUID leaf in a
half baked state, either clear them both or leave them both set.

Additionally, add testing to verify the CPUID isn't in such a state.

Aaron Lewis (3):
  KVM: x86: Clear XTILE_CFG if XTILE_DATA is clear
  KVM: selftests: Hoist XGETBV and XSETBV to make them more accessible
  KVM: selftests: Add XCR0 Test

 arch/x86/kvm/cpuid.c                          |   4 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  19 +++
 tools/testing/selftests/kvm/x86_64/amx_test.c |  24 +---
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 134 ++++++++++++++++++
 5 files changed, 161 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c

-- 
2.39.0.314.g84b9a713c41-goog

