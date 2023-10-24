Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC227D43E7
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjJXA0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjJXA0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:26:39 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E23D10C
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:37 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f61a639b9so55115927b3.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107197; x=1698711997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbzzjILwprMa7QV/3rEm9217vDHRa2W9i0FThHihDYc=;
        b=xGRuFJVMi5QWO6WElspl/zpMuWQu4WXiv6m7rDSEHFe0kjcC3tNFhHkSqV9BteIIAG
         1JfrJcakG94sB0NGf1ocOBY4Kc3Mse9aEbj4wb7p6Ymd38Xe16PwdETotMNTKePjo849
         I1MbI28tLLG39Gh6BywNP2cBmjygwLfsS+sfY7TKee145t2YrtNesIp35glUFH28U/2Q
         QrAeRRGEETHFuWcwrHEI0fEnzDPpRaCdaa1H3l3cbc8WKudA+KM8rSXN38PGmiZrvMCG
         l46edwoa6HntJEsMFSKMkWT+lCO99Ybg69hcG4oO8bgesLIl+uFUc+mRONPbFAyWHKqB
         Fwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107197; x=1698711997;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wbzzjILwprMa7QV/3rEm9217vDHRa2W9i0FThHihDYc=;
        b=c/QtZgpPsGbvCoxqtICeeiohQty/l9sJeSXXc8YJUoQxpLyec8758g+y1lHhkf7Wzh
         gcvY9GaqObwxEErJqPQH259hmSNNFSh9lKm2FReMK3XRyfbh7rnZksOkaTXZAgnqasTj
         IMhBUemaHh2Hn3KdeF8RnQ3YZzTTlLE6iwIppVK57FFAv9l4n5uzBRfdC0S7Hh2iUiwp
         Oo9dtUstadqgCN6ITDWm46XCt+LbTrwHxjXW+BiVs85KL/5ekHW+5cdFid1Pt5jKI0cU
         Go54G2NRzrC0i94mwhleDXlCrJZwCXklY2jxvfiDYTForilwIhFnx2N4YFnW6xTg7yNi
         JfeA==
X-Gm-Message-State: AOJu0YzGZ8oRsVgp45/keUplwejbARGKGkGZmdGGiq8Wo39sBy36L1vB
        DqCuvFxfETHN3RCaqE3nczdyEqQxABw=
X-Google-Smtp-Source: AGHT+IEDf6HVokTg+TScAicCggH03dnOgtAAf9RD4sxzHsycabcRurbuKZlZNoPZaxJHGjT54i0LKDIady8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e0e:0:b0:5a7:a929:5b1d with SMTP id
 c14-20020a814e0e000000b005a7a9295b1dmr234676ywb.4.1698107196918; Mon, 23 Oct
 2023 17:26:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:20 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-1-seanjc@google.com>
Subject: [PATCH v5 00/13] KVM: x86/pmu: selftests: Fixes and new tests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
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

This is effectively v5 of Jinrong's series to add more PMU selftests, with
a focus on architectural events, fixed counters, and CPUID configurations.
I reworked things quite a bit, but the core concepts and what's being tested
are more or less unchanged.

The first three patches are minor fixes for KVM's handling of fixed
counters.  Patch 3 deals with an area in the PMU architecture that is
somewhat open to interpretation, i.e. could probably use a bit of dicsussion
to make sure we're all on the same page.

Jinrong and/or Like, please double check and rerun everything, my confidence
level with PMU stuff is still quite low relative to the rest of KVM.

v4: https://lore.kernel.org/all/20230911114347.85882-1-cloudliang@tencent.com
v3: https://lore.kernel.org/kvm/20230814115108.45741-1-cloudliang@tencent.com

Jinrong Liang (7):
  KVM: selftests: Add vcpu_set_cpuid_property() to set properties
  KVM: selftests: Add pmu.h and lib/pmu.c for common PMU assets
  KVM: selftests: Test Intel PMU architectural events on gp counters
  KVM: selftests: Test Intel PMU architectural events on fixed counters
  KVM: selftests: Test consistency of CPUID with num of gp counters
  KVM: selftests: Test consistency of CPUID with num of fixed counters
  KVM: selftests: Add functional test for Intel's fixed PMU counters

Sean Christopherson (6):
  KVM: x86/pmu: Don't allow exposing unsupported architectural events
  KVM: x86/pmu: Don't enumerate support for fixed counters KVM can't
    virtualize
  KVM: x86/pmu: Always treat Fixed counters as available when supported
  KVM: selftests: Drop the "name" param from KVM_X86_PMU_FEATURE()
  KVM: selftests: Extend {kvm,this}_pmu_has() to support fixed counters
  KVM: selftests: Extend PMU counters test to permute on vPMU version

 arch/x86/kvm/pmu.h                            |   4 +
 arch/x86/kvm/vmx/pmu_intel.c                  |  48 +-
 tools/testing/selftests/kvm/Makefile          |   2 +
 tools/testing/selftests/kvm/include/pmu.h     |  84 ++++
 .../selftests/kvm/include/x86_64/processor.h  |  67 ++-
 tools/testing/selftests/kvm/lib/pmu.c         |  28 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  12 +-
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 438 ++++++++++++++++++
 .../kvm/x86_64/pmu_event_filter_test.c        |  32 +-
 .../smaller_maxphyaddr_emulation_test.c       |   2 +-
 10 files changed, 669 insertions(+), 48 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/pmu.h
 create mode 100644 tools/testing/selftests/kvm/lib/pmu.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c


base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4
-- 
2.42.0.758.gaed0368e0e-goog

