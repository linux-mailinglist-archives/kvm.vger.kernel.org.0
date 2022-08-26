Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAEE5A2F4B
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345137AbiHZStI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbiHZSsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:48:24 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46766E833B
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:45:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so1207943pgl.8
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=GiOMEUaR02qX5Gm07mLfZU1zm4cqDTei2RBST1bzNRA=;
        b=eW5ZYnSw2FOj4BYqOIscZSQtmCy1Z9DUTbXt7t6DlXZNbbmggQqECy5jRGeakjYSEG
         IA/hJ+NwGniKMtcJbqDxDsxbLCa+ENZdG7T6IOF+ih0iHy8Nxz65CdZ6LR4Fhu1R1ybY
         xASdoztO1dAtm2byb0nbg32VdoNR9v6cuaJssFtbsS6mc8CDorVkNkd14/MLSX/Iz5z8
         KSXf9mQZrzG1dXA1ubOvPSpTa8/vYHOd2Q1O4E1O06fv47y8C6Yjst8w5m1DBXxM9cxd
         /rQlbDMwM9da0WxKRI59Qu3Ypzc5nKL01Ef77u6JGu77v9ucP3fbnPZ9F/hwlaubthdf
         4jAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=GiOMEUaR02qX5Gm07mLfZU1zm4cqDTei2RBST1bzNRA=;
        b=rcVXLZ8rlt0Le1aAw+UdJIR0UrskMXacxpS4GeOYD/4ISLMIiF9YviO/CZd3285THP
         f8XsCZ6yFJnUyEsmEkwWmZeQPSXXluKAr80o6xGlC++v2qaEsBkyV8v/sYD+CiRrrKH/
         xQLXXHixEwGFaI2NjfH+l8qb8FYI9bdQr4pq7rO1h2sk2lby6LsREhyTGgwhQAiQK2Hy
         qJBMuHQdiEUmnO+JSwAY5mz6CNcnVCQm0pOaZmfDEQ4eYN1samkjHrPny46yUFgoeVNt
         DQYGYFwAv1IzURQ3YgJN4rpOI0BnG2sTj6kzTW88qrJpQw+deRYTDrdcYtPTWk9y91Fk
         5Y0Q==
X-Gm-Message-State: ACgBeo0JEOEZMtt6h69XAZJydck2rkulqOoMtN0pGvsAEZkQZmTU2ViG
        faAAtwA8CrKj+zKsoGmrS1tvxsax0niY
X-Google-Smtp-Source: AA6agR7mFSwSnqWdxTD7kgZ4nilCuP+7FqhRjsqpyZTvySv5Vwa3ZJHVWYpKDp2AUsGE9NSWPLJYgD2JoxRa
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:114c:b0:528:2c7a:630e with SMTP
 id b12-20020a056a00114c00b005282c7a630emr5038459pfm.86.1661539529715; Fri, 26
 Aug 2022 11:45:29 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:44:56 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826184500.1940077-1-vipinsh@google.com>
Subject: [PATCH v3 0/4] dirty_log_perf_test cpu pinning and some goodies
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pin vcpus to a host physical cpus in dirty_log_perf_test and optionally
pin the main application thread to a physical cpu if provided. All tests
based on perf_test_util framework can take advantage of it if needed.

While at it, I changed atoi() to atoi_paranoid() in other tests, sorted
command line options alphabetically, and made switch case logic of -e
option less error prone to code changes by adding break and decoupling
it from -g.

v3:
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

Vipin Sharma (4):
  KVM: selftests: Explicitly set variables based on options in
    dirty_log_perf_test
  KVM: selftests: Put command line options in alphabetical order in
    dirty_log_perf_test
  KVM: selftests: Add atoi_paranoid to catch errors missed by atoi
  KVM: selftests: Run dirty_log_perf_test on specific cpus

 .../selftests/kvm/aarch64/arch_timer.c        |  8 +--
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  6 +-
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       | 65 +++++++++++++------
 .../selftests/kvm/include/perf_test_util.h    |  4 ++
 .../testing/selftests/kvm/include/test_util.h |  2 +
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 .../selftests/kvm/lib/perf_test_util.c        | 62 +++++++++++++++++-
 tools/testing/selftests/kvm/lib/test_util.c   | 14 ++++
 .../selftests/kvm/max_guest_memory_test.c     |  6 +-
 .../kvm/memslot_modification_stress_test.c    |  4 +-
 .../testing/selftests/kvm/memslot_perf_test.c | 10 +--
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  4 +-
 15 files changed, 148 insertions(+), 45 deletions(-)

-- 
2.37.2.672.g94769d06f0-goog

