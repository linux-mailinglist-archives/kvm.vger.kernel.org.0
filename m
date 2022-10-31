Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9D613C3E
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiJaRi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 13:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJaRiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 13:38:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585025F63
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso4619110pjb.6
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3BtbEpvfqHYn/j1Sd71NMbQHJxzVSScV/f8Wl+EPLMY=;
        b=sT9mufTqJYS8hyYLVwbmlzKMtFFN95tzOYRmJ9/Wpoa1JlGZHNNGh+/sXTTOh3Arrs
         37S6IQhkXrV39zQTRDp4ybVhFRUGgpihye0T+PIn0WGP4CpOQBzOUqi8rFB0NDp2Q1ZD
         /E5rkgFP57ZdvGF7AZqUVLQKiCyFzWYivrg1VC9aA6Q1QveLDe4IYOSBemZ8YMf9g2SC
         5Hq5wQsixUsZvIVyXXk8Y+FDOYKgqusYxGvO+ystL+V+nkglQaQ09n/fMDJI0vLAm5M+
         1U393RNaT9n/ooI5Nj3yUgriuoBdDhmGeXHcb5LElKYa1MvZt2p4SYpmcFup+lIl44Yb
         3Spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3BtbEpvfqHYn/j1Sd71NMbQHJxzVSScV/f8Wl+EPLMY=;
        b=h1AxjsZVYLQo2oCVwYg/5CtzKbrnVUSEzSEq/YtHIQRK59aQwQsFX3WCNVDF/z3rRB
         Q0ZynBNEcNJGTPJiS1K1BziNIdc0khiLI8c/NN2A1+jfiCt27DV+b4VP/s2J+oh541c+
         TOd4SRlmT7ppowGFAJSCnbLLitryFdYsnrMl5rs2+EiPPRoXSD8LiKfwmE4Msncww8tt
         M0ohocWeSBylc5jtjCL18oCTT2Kw09hBygNOBOgkklRxM3j9OZ74F2DmYEdAMU7cTmp5
         PJWQSq0hDIhXQiD+ATCXWkMY36eQMTuPT3WxqUdv5P43W1MBN9/q1PTXQYAIQ4e3x3en
         Seag==
X-Gm-Message-State: ACrzQf0EFxkJ8dRKBRIiEVE0Uq12UeadMamgJFFJxgGW5lUHs0+1d/R7
        BGU0OyRraK1f5h4BD/o5tFh6cHGUnJQr
X-Google-Smtp-Source: AMsMyM4d9yf387NBdrR2ze8xxDxL0b0dvN9j/cddBMXLM5GTKg4nEhVc3AldTqmN6+RpS32LihIuzqHMiNni
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:198d:b0:56b:fa7b:56ed with SMTP
 id d13-20020a056a00198d00b0056bfa7b56edmr15180062pfl.81.1667237902771; Mon,
 31 Oct 2022 10:38:22 -0700 (PDT)
Date:   Mon, 31 Oct 2022 10:38:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031173819.1035684-1-vipinsh@google.com>
Subject: [PATCH v7 0/5] dirty_log_perf_test vCPU pinning
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Pin vCPUs to a host physical CPUs (pCPUs) in dirty_log_perf_test and
optionally pin the main application thread to a physical cpu if
provided. All tests based on perf_test_util framework can take advantage
of it if needed.

While at it, I changed atoi() to atoi_paranoid(), atoi_positive,
atoi_non_negative() in other tests, sorted command line options
alphabetically in dirty_log_perf_test, and added break between -e and -g
which was missed in original commit when -e was introduced.

v7:
- Moved pinning APIs from perf_test_util.c to kvm_util.c.
- Missed one atoi() call in aarch64/debug-exceptions.c, changed it to
  atoi_positive().

v6: https://lore.kernel.org/lkml/20221021211816.1525201-1-vipinsh@google.com/
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

 .../selftests/kvm/aarch64/arch_timer.c        | 25 ++------
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  6 +-
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  4 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 64 +++++++++++++------
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 .../selftests/kvm/include/perf_test_util.h    |  4 ++
 .../testing/selftests/kvm/include/test_util.h |  4 ++
 .../selftests/kvm/kvm_page_table_test.c       |  4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 54 ++++++++++++++++
 .../selftests/kvm/lib/perf_test_util.c        |  8 ++-
 tools/testing/selftests/kvm/lib/test_util.c   | 35 ++++++++++
 .../selftests/kvm/max_guest_memory_test.c     |  7 +-
 .../kvm/memslot_modification_stress_test.c    |  6 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 24 ++-----
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  4 +-
 18 files changed, 180 insertions(+), 79 deletions(-)

-- 
2.38.1.273.g43a17bfeac-goog

