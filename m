Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1995A797C
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiHaIxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiHaIxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:51 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F4C9EAC;
        Wed, 31 Aug 2022 01:53:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z3-20020a17090abd8300b001fd803e34f1so11836502pjr.1;
        Wed, 31 Aug 2022 01:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=EtfpPipxaW8gJbQRusVJqqakLf3mLYiJynILWk3VcFA=;
        b=LZFmVIUlMPPfJ2Lh2pa/yqKPoyfdjSdUh8yQiHO+svmA+vpxYIoIO/24aw06VYAbtK
         6O+HHsF9FXEl5t01f3dqp876lqAUrRnLWyIcbY7chmVgBpLo/VXx8BwAto5O/M1VG4aH
         6jGEWsG21yy0A98OwJj60RpxKgJlyU7tzyQQqqv+HdH/5dQcLcxGCDHBgMjkFP2lSH7n
         KyQ6qPFjw1M6EOqYDFn40PEI3aHFoempxJRqL4uTVZMkBJRgHRgGJ0Kw5RSS2viPj7Wu
         jU3U/ZG6OVMqI5PE07LB3WzQDAK7gVT7XBA9WVMATT77vRxXRpMk18o6lUaGue42ILCz
         9eNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=EtfpPipxaW8gJbQRusVJqqakLf3mLYiJynILWk3VcFA=;
        b=VhwrOW8tnfciBK+dAgbDyrom7aULSDkP1idVHEH2cikpkSJsfICKOrawOtLO5Bkh9r
         zCAl5OEaI9ul0fbSVsLVTd2K1W7fAand5ZlY3ttjRaG76x3UAWSauPRQqSHKHR+2fK48
         adXzxZDmHXWLgNAYU6Sa101xn5bV0dngeyGl6y/AnWo2Yc6UbyFaHmdMT8A6kNmS+OvJ
         kOx8VJvrCivnWXbZvxEjlj5+Y9sG18rz7mnqSL3YSjq8CKwF+M6dBzR3rBpBEtWZqX54
         F3HBy4KbqvtuW2WUmYTxtqj2o6A9i7sCyMu5GkHCq+XYo7V6fTHAF82/6ou+hkRZonWt
         9Djw==
X-Gm-Message-State: ACgBeo2UTwRTKVyqJfnOeOosOplw0VkSxHbckC0k9SjTiaUdAk2vp4rk
        1MYvfYpXtPWSDJDzHi/wSWuoqji0izy0PA==
X-Google-Smtp-Source: AA6agR6eW3gmh/aLXPnvXb/50VGuHpMZWdbCUfgu/KKBZKzWD7ifu1JR0ABX4s/LFyycblPuseWb1w==
X-Received: by 2002:a17:90a:4402:b0:1fd:c07d:a815 with SMTP id s2-20020a17090a440200b001fdc07da815mr2163409pjg.188.1661936027173;
        Wed, 31 Aug 2022 01:53:47 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:46 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] x86/pmu: Corner cases fixes and optimization
Date:   Wed, 31 Aug 2022 16:53:21 +0800
Message-Id: <20220831085328.45489-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Good well-designed tests can help us find more bugs, especially when
the test steps differ from the Linux kernel behaviour in terms of the
timing of access to virtualized hw resources.

Please feel free to run tests, add more or share comments.

Previous:
https://lore.kernel.org/kvm/20220823093221.38075-1-likexu@tencent.com/

V2 RESEND -> V3 Changelog:
- Post perf change as a separate patch to the perf folks; (Sean)
- Rewrite the deferred logic using imperative mood; (Sean)
- Drop some useless comment; (Sean)
- Rename __reprogram_counter() to kvm_pmu_request_counter_reprogam(); (Sean)
- Replace a play-by-play of the code changes with a high level description; (); (Sean)
- Rename pmc->stale_counter to pmc->prev_counter; (Sean)
- Drop an unnecessary check about pmc->prev_counter; (Sean)
- Simply the code about "CTLn is even, CTRn is odd"; (Sean)
- Refine commit message to avoid pronouns; (Sean)

Like Xu (7):
  KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
  KVM: x86/pmu: Don't generate PEBS records for emulated instructions
  KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
  KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
  KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter
  KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement
    amd_*_to_pmc()
  KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters
    scalability

 arch/x86/include/asm/kvm_host.h |   6 +-
 arch/x86/kvm/pmu.c              |  44 +++++++-----
 arch/x86/kvm/pmu.h              |   6 +-
 arch/x86/kvm/svm/pmu.c          | 121 ++++++--------------------------
 arch/x86/kvm/vmx/pmu_intel.c    |  36 +++++-----
 5 files changed, 75 insertions(+), 138 deletions(-)

-- 
2.37.3

