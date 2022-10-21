Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96A6080A4
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiJUVSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiJUVS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:18:26 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773F12A4E03
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:25 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z5-20020a170903018500b00184aedd9c75so2317212plg.11
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N8pi4FJltIlkWNFG9BX4yVbAYjKE+0cZ8YftMsn/7f0=;
        b=P1hhWJv6ruyx/lry9kD7doArSA+ymRAonE5j2xCvcfXPXwk3wIH1hSLEHQXF0bovH8
         zLUW8EycNsCgYOB881sWMtwONaIJ/8EDisqJ61XsjBcRjeathoNROTEBCnSb45lJy5bd
         BslUGHiZQ4nWja4ejiNEuPhK9Fl53natuf8yCqWkbJ5Qoq+/D66+wb1E5pv1AXX8flsB
         KUx6MTFLmdZXu6BwpAOkAk/7KD3PAW/wzRh7ZjmS1PdaHVC2mnY/47l1cMXCr5qQa+hD
         Z/16pP2/UntRJGHNRLBCXM4hNStlNOB282XLZuwhdEkencJhwf0kamLpPLmTGWHDMl/E
         /80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N8pi4FJltIlkWNFG9BX4yVbAYjKE+0cZ8YftMsn/7f0=;
        b=cYtI6OxZtUsfPynVL3K3WGUwtAT97qdl/vYI9SQXKNfL9wwI4O9aBNM1Nze622eoZX
         0UeOVNLMjeb8V4s8bJMrep8X0QHXz9cnKFsAap9Ib2TLkiZrwWXKo49EEct7GG/4e/I6
         V5LKLmU1fPqHtUrCP27NM2XjAfkEczsw+Ub6RjF9gSiru41e84Ht9cP09SPd86XNk1gC
         okASC6hyQx3en4Pl9JEQpHXeA2zi5HMi8SAvCViHFEiaejZffTo/bKresPnS3wKDDDao
         WVTU4C6VLi/c9YQwo0i49pEUZyAxD2w55wjgPDtsaf1J158zaevGJe26NijP8EqEMBkZ
         NMjQ==
X-Gm-Message-State: ACrzQf2dAbqxPEkLsX+9LLKWkxBvGpL+nWKBhv1MBPJnU07uXFIkby1w
        iuzqIP8o8OXad7BFQiuSIYubEdiGCSZU
X-Google-Smtp-Source: AMsMyM6YyjZbtSNqVtsi0kRAUkGDM8/HPMtF6WfK+x7V/QbKVyQDzU3FFc80RLrc/ruyvQJRrhCxSW++ftf4
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:cac3:b0:186:6ce4:f94a with SMTP id
 y3-20020a170902cac300b001866ce4f94amr8590952pld.145.1666387104463; Fri, 21
 Oct 2022 14:18:24 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:18:11 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021211816.1525201-1-vipinsh@google.com>
Subject: [PATCH v6 0/5] dirty_log_perf_test vCPU pinning
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Pin vCPUs to a host physical CPUs (pCPUs) in dirty_log_perf_test and
optionally pin the main application thread to a physical cpu if
provided. All tests based on perf_test_util framework can take advantage
of it if needed.

While at it, I changed atoi() to atoi_paranoid(), atoi_positive,
atoi_non_negative() in other tests, sorted command line options
alphabetically in dirty_log_perf_test, and added break between -e and -g
which was missed in original commit when -e was introduced.

v6:
- Updated the shortlog of Patch 5.
- Changed formatting of help text of -c in dirty_log_perf_test

v5: https://lore.kernel.org/lkml/20221010220538.1154054-1-vipinsh@google.com/
- Added atoi_postive() and atoi_non_negative() APIs for string parsing.
- Using sched_getaffinity() to verify if a pCPU is allowed or not.
- Changed Suggested-by to add only person came up with original idea of
  pinning.
- Updated strings and commit messages.

v4: https://lore.kernel.org/lkml/20221006171133.372359-1-vipinsh@google.com/
- Moved boolean to check vCPUs pinning from perf_test_vcpu_args to
  perf_test_args.
- Changed assert statements to make error more descriptive.
- Modified break statement between 'e' and 'g' option in v3 by not copying
  dirty_log_manual_caps = 0 to 'e'.

v3: https://lore.kernel.org/lkml/20220826184500.1940077-1-vipinsh@google.com
- Moved atoi_paranoid() to test_util.c and replaced all atoi() usage
  with atoi_paranoid()
- Sorted command line options alphabetically.
- Instead of creating a vcpu thread on a specific pcpu the thread will
  migrate to the provided pcpu after its creation.
- Decoupled -e and -g option.

v2: https://lore.kernel.org/lkml/20220819210737.763135-1-vipinsh@google.com/
- Removed -d option.
- One cpu list passed as option, cpus for vcpus, followed by
  application thread cpu.
- Added paranoid cousin of atoi().

v1: https://lore.kernel.org/lkml/20220817152956.4056410-1-vipinsh@google.com


Vipin Sharma (5):
  KVM: selftests: Add missing break between -e and -g option in
    dirty_log_perf_test
  KVM: selftests: Put command line options in alphabetical order in
    dirty_log_perf_test
  KVM: selftests: Add atoi_paranoid() to catch errors missed by atoi()
  KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
    validation
  KVM: selftests: Allowing running dirty_log_perf_test on specific CPUs

 .../selftests/kvm/aarch64/arch_timer.c        | 25 ++-----
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  6 +-
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  4 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 61 +++++++++++------
 .../selftests/kvm/include/perf_test_util.h    |  6 ++
 .../testing/selftests/kvm/include/test_util.h |  4 ++
 .../selftests/kvm/kvm_page_table_test.c       |  4 +-
 .../selftests/kvm/lib/perf_test_util.c        | 65 ++++++++++++++++++-
 tools/testing/selftests/kvm/lib/test_util.c   | 35 ++++++++++
 .../selftests/kvm/max_guest_memory_test.c     |  7 +-
 .../kvm/memslot_modification_stress_test.c    |  6 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 24 ++-----
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  4 +-
 15 files changed, 177 insertions(+), 78 deletions(-)

-- 
2.38.0.135.g90850a2211-goog

