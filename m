Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE961889D
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiKCTTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiKCTTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:19:24 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593CB21E1D
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:17:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id j21-20020a17090a7e9500b00212b3905d87so1196183pjl.9
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V5ShnTa1jHvkmSSuOGq0oPwfWcLkpSb0qmkA9knQiXw=;
        b=IRzHdInd99dJ5ML8O2zTA4ZFKkv3y+Vb5wCpQoLer2QrtN/hsVttQnpX1NfUwz4Vw1
         QNlOliKRei9dLkR5VIgUmyAmLxmJbf3oNlH94ASVN7gtEe9YqNzKV5NmfKF6mxJiBuFZ
         VEbzL9/GbjU5I43jQmECYMtNaVSV7CUAZBBF5T66ftBv7QMPe7CCzB35yvnAFA2Ka/ej
         5ERkY19pNCgvDd9WS03HSeZjnt30iYLtRDJcooR2DkasrqxsY8J2ohFVZ8gvg1VfoJgN
         Les++RyICut+ftVun0JgrjV8om4gu3ArE20yABLC694g+JhWbvJzflzRhfkARKZLBtTx
         7q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V5ShnTa1jHvkmSSuOGq0oPwfWcLkpSb0qmkA9knQiXw=;
        b=Jj6PfiXot0u9E3yvTVNC+229aHsy5jUj/k8UWB02XQZKlEMMG1IILOhtTw1PrjoOmx
         QKf67VVGTJfv7vkMNihiOzQiu1wkyLXsZEtv5pvS84o4Nd02pbu4+CiBQdHSCxCxiZpu
         Eqhw5Ijvq3KXe/QpN2iuyiFj5VlhK0iGtCqlcfbE/gvq6cZRLUM3+S/PCjBfIzitPlVl
         mAlJ6GDnUUP67q2nSfC7b1hI7NMxQJO0E7NaENXJKxTsJw/V5Irf5TDlIWCDpP+Wt9Ah
         UvHxBObbRT52NFZbhyAeY0oJnB4yrXlmxzNCjk5nDl3/CZPgddKlJTWH5HIxxIJx1YpR
         Waig==
X-Gm-Message-State: ACrzQf2ktO7URNFqKjHNMTRszdtaLA0NSnyDH7EUxDUuWY/D6fcPUrx8
        7qPA9pt74QoSnglDMv/ylVxKTzhFT1ZB
X-Google-Smtp-Source: AMsMyM6DvleSxoBRVnkg7LQ5uxy5YJV0YI2dDUNW/jEBAecP3MMKh/wKI/1VbVQVkd4Q0jwOPZjOdAoQTTgg
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:f291:b0:20a:eab5:cf39 with SMTP id
 fs17-20020a17090af29100b0020aeab5cf39mr144116pjb.1.1667503045409; Thu, 03 Nov
 2022 12:17:25 -0700 (PDT)
Date:   Thu,  3 Nov 2022 12:17:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221103191719.1559407-1-vipinsh@google.com>
Subject: [PATCH v9 0/7] dirty_log_perf_test vCPU pinning
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
provided.

While at it, I changed following:

1. atoi() replaced with atoi_paranoid(), atoi_positive and
   atoi_non_negative()
2. Sorted the command line options alphabetically in
   dirty_log_perf_test.
3. Added the missing break between -e and -g in dirty_log_perf_test.c
4. Replaced size_1gb in max_guest_memory_test.c with SZ_* macros from
   sizes.h.
5. Shortened the test args name in memslot_modification_stress_test.c

v9:
- Changed commit message of patch 4.
- Changed some line wrapping in memslot_modification_stress_test.c
- Added Reviewed-by and Suggested-by.

v8: https://lore.kernel.org/lkml/20221102232737.1351745-1-vipinsh@google.com/
- Changed atoi_positive() and atoi_non_negative() to accept variable name also.
- Moved atoi_positive() and atoi_non_negative() definition to test_util.h
- Removed new line character from TEST_ASSERT() statements.
- Using official SZ_1G from sizes.h header file in max_guest_memory_test.c
- Shortened test args name in memslot_modification_stress_test.c

v7: https://lore.kernel.org/lkml/20221031173819.1035684-1-vipinsh@google.com/
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


Vipin Sharma (7):
  KVM: selftests: Add missing break between -e and -g option in
    dirty_log_perf_test
  KVM: selftests: Put command line options in alphabetical order in
    dirty_log_perf_test
  KVM: selftests: Add atoi_paranoid() to catch errors missed by atoi()
  KVM: selftests: Use SZ_* macros from sizes.h in
    max_guest_memory_test.c
  KVM: selftests: Shorten the test args in
    memslot_modification_stress_test.c
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
 .../testing/selftests/kvm/include/test_util.h | 18 ++++++
 .../selftests/kvm/kvm_page_table_test.c       |  4 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 54 ++++++++++++++++
 .../selftests/kvm/lib/perf_test_util.c        |  8 ++-
 tools/testing/selftests/kvm/lib/test_util.c   | 19 ++++++
 .../selftests/kvm/max_guest_memory_test.c     | 21 +++---
 .../kvm/memslot_modification_stress_test.c    | 22 +++----
 .../testing/selftests/kvm/memslot_perf_test.c | 24 ++-----
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  5 +-
 18 files changed, 190 insertions(+), 98 deletions(-)

-- 
2.38.1.273.g43a17bfeac-goog

