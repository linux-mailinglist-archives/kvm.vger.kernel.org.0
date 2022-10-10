Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BAD5FA77F
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 00:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJJWFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 18:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJJWFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 18:05:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7095A3D3
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:05:43 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m3-20020a170902bb8300b0017f7e7e4385so8705905pls.20
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kFMAmFqP24s+wNJU6nadYvqB6k/Y/68Nq9OPzf9rX9k=;
        b=JENqDTIl5HZBAFN8s0Ygiktu+sJGC9lZrY28uqglYNNBlDXG0SuuLkWftrPKFs8qB5
         lRVF+WRFtH8zMjrf2zmg1EWKDMAi6J3Y19q5QpO7IMAvpBxC7iIRfXKgnS+VA2vTua4Q
         X8zLKYn9VaqPm9P2thPaeQmx5AUoFoVOiAbrBZUFPP6rA4gs4DuauOmId9arfugBkHmE
         dzEhqrHll6dUva+yOxHMCemB/uRDC8c1buMCKYeHaiHDzHcGdjSEUUL1zwAH1L00uMrn
         hYnfqrULDbJmGWKellT8Redapj/hyD4wDHVNIh/pXQe3UUM3DEd9wtYtPTLH+Sum8hAO
         pPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kFMAmFqP24s+wNJU6nadYvqB6k/Y/68Nq9OPzf9rX9k=;
        b=GFqdDnp5gONt9Dho38yR9udmOIpOjugjqe2UV53DZTwWtjDZHCxJ2t1/JY3L0tmSgY
         Psc5nwpCFCvAgGPPFRD3VGDqmAGVEDiu6Xm4uzWoGNkYww7dSKUSnizkWAjGWnBOHt+T
         zXE/0sAhwAGDpX99gTvZgiMkZt9e5Y92pCO5KsuTQ5um6QlGqSrJy2adgmGf4JDfOm2G
         Z8Y0Za8eX7OzM2TqueZxzRvwiNfP/XaZmZ/Hs+qzg75T9apvDfxzwZYhBXDy1enELXqX
         EKcZ/z3lZN+9M/12HDUArQIt5SM1uUFTTrhCjNmNOA7wCwWxfuEhe14qFhjRn0qi2H7F
         LiZw==
X-Gm-Message-State: ACrzQf04siwYSf8C+JgM3b2x3SPXqkowfNcMvayqBXhKH5CgLW6TLc0Q
        Ik5KbnswuTwWlQuJk9so3YeVBGZPpPEQ
X-Google-Smtp-Source: AMsMyM6C9jlDdYKMer8KBxXB5EtELhc3potAK7HKuVoUQhBwKfZhKPkYmRKl8nvlNwOnce28DfSZAV/BWU/P
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:cd06:b0:203:ae0e:6a21 with SMTP id
 d6-20020a17090acd0600b00203ae0e6a21mr1863639pju.0.1665439542737; Mon, 10 Oct
 2022 15:05:42 -0700 (PDT)
Date:   Mon, 10 Oct 2022 15:05:33 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221010220538.1154054-1-vipinsh@google.com>
Subject: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, kvm@vger.kernel.org,
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

v5:
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
  KVM: selftests: Run dirty_log_perf_test on specific CPUs

 .../selftests/kvm/aarch64/arch_timer.c        | 25 ++-----
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  6 +-
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  4 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 62 ++++++++++++------
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
 15 files changed, 178 insertions(+), 78 deletions(-)

-- 
2.38.0.rc1.362.ged0d419d3c-goog

