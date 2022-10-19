Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9FB605416
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiJSXlA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJSXk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:40:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5360133315
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:40:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i16-20020a056902069000b006c3ef07d22eso9686122ybt.13
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WYkINj1A9BGtFalFSCIGnLYTGlc3I8xkMwL0N6XY/zQ=;
        b=WII7F9HY0/k42iC29ZkAK7R+Lk7hZbfEV6yMqgAndw84BAiUakMlCOIUOsopI0Q0GN
         aXMraT76NZclopnS2QzbkPWjCc7HWKT//sOTynIFNnpdJ1QdbfgFoCaydoNDea8v3gLR
         xVRgqEEM/sI3FS3mISCMcMYWSGT9ZbWM6TYHJ7DHp0g8V3SWpozvCR0VFu6EbhSQtJD8
         hWnTOiQt/diPBc1LSBiQb3TpKrn1c6QV9tqwIp3PczgnB0gTW5bOudrb0f5EM7CFv76P
         OGZp2w2k21o/3OLdgY1s/pjsbscY+Dandt0Lb4lsvdv9Z+FNNJx1F2UByprmUdWZetxH
         NxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WYkINj1A9BGtFalFSCIGnLYTGlc3I8xkMwL0N6XY/zQ=;
        b=vKFioL+Wkwmr24Gmp2xbwY1KX8GqYqe/c3pd73opt1oQz5iIb6CZpiVm3CDMSJlCtj
         0sllSReh4WVI4u1r4rp2itm7nyd2KGHifliQxuv5PJBZWykHwyXGuQRGtJhwArLCuF6r
         fv2l8RCnZHy5xw6HwZvQ9SM3iLeaVKVAhcgpG3A8ZYttFaES5nCTPBt9oaN/X0XPwMrN
         0+2nhpQ6ghgQ5TvwNPqsl6nZp8c+xGg0BvSzJVUTPbjKzEhIKByLxN8vXtYWHD4cSnhU
         Fl35h0ZVqIW+CsV1ZUErm8ReaOHBtc3gUJZ4Q9Q1xAjdAYheokLTYPNNv9afVUDWUeKw
         3uzQ==
X-Gm-Message-State: ACrzQf19pv6/dqc+GEU4mHoegsKX+Fi+f9YwZ+q2anLPPtDCSZdab9xa
        b1P9nb278uwCBQ03BCDT/nG5kGI/dBoeSw==
X-Google-Smtp-Source: AMsMyM66SesV4D5X7PuWAnrVhkJpTvXoCAgDV7ZvM1h5pUWcsNc0oTqeYt6aeAu1qxFE6bJwkYEkFhO7HOApYQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:4941:0:b0:367:d6d4:4697 with SMTP id
 w62-20020a814941000000b00367d6d44697mr2362411ywa.402.1666222857167; Wed, 19
 Oct 2022 16:40:57 -0700 (PDT)
Date:   Wed, 19 Oct 2022 16:40:48 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019234050.3919566-1-dmatlack@google.com>
Subject: [PATCH v2 0/2] KVM: Split huge pages mapped by the TDP MMU on fault
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
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

Now that the TDP MMU has a mechanism to split huge pages, it is trivial
to use it in the fault path whenever a huge page needs to be replaced
with a mapping at a lower level.

The main beneficiary of this change is NX HugePages, which now no longer
unmaps huge pages when instructions are fetched from them. This means
that the VM does not have to take faults when accessing other parts of
the huge page (for whatever reason). The other beneficiary of this
change is workloads that set eage_page_split=N, which can be desirable
for read-heavy workloads. The performance impacts are discussed in more
detail in PATCH 3.

To validate the performance impact on NX HugePages, this series
introduces a new selftest that leverages perf_test_util.c to execute
from a given region of memory across a variable number of vCPUS.

This new selftest is short but contains a lot of duplicate code with
access_tracking_perf_test.c, and the changes to perf_test_util.c to
support execution are a bit gross. I'd be fine with deferring this test
to a later series, but I want to include it here to demonstrate how I
tested the TDP MMU patch.

Tested: Ran all kvm-unit-tests and KVM selftests.

Cc: Mingwei Zhang <mizhang@google.com>

v2:
 - Rebased on top of Sean's precise NX series
   (https://lore.kernel.org/kvm/20221019165618.927057-1-seanjc@google.com/)

David Matlack (2):
  KVM: selftests: Introduce a selftest to measure execution performance
  KVM: x86/mmu: Split huge pages mapped by the TDP MMU on fault

 arch/x86/kvm/mmu/tdp_mmu.c                    |  72 ++++---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/execute_perf_test.c | 185 ++++++++++++++++++
 .../selftests/kvm/include/perf_test_util.h    |   2 +
 .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
 6 files changed, 246 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c


base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
prerequisite-patch-id: 6ac49676365593be76e374e5954bf496629f6f22
prerequisite-patch-id: 0244295d523e3b3658e1fa3a56b7e8604d574e34
prerequisite-patch-id: 0504728c79c7dee21f6692cd884b86be3fb2b618
prerequisite-patch-id: 177194a755adc0088726343fc813eb0cd71205fc
prerequisite-patch-id: 0feb2a75d346d2281c101bec2b9a6b495c85bae4
prerequisite-patch-id: 2bef32f68d262787e2c6de8ae4491abe6b8dd1c3
prerequisite-patch-id: ba643d747ba284b823180729e2070058358172bf
prerequisite-patch-id: 983d17cf1db03290802035b21de80852c6d370c9
-- 
2.38.0.413.g74048e4d9e-goog

