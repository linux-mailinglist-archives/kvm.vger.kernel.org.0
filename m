Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4C683501
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 19:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjAaSS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 13:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAaSSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 13:18:24 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05D92BF08
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:18:23 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id s8-20020a056a00178800b00593e2189278so2364982pfg.19
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 10:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WG4JpoiMii42ipY3eUc5x3VppysZgl8p2dC8kvhLf3M=;
        b=Xgn01Yv5aSNZI779Uc30n/qInl1dWVuWWpaFj1e5bwDqA2UECvux/B4QCJCx44xw4D
         R620NxEdqzm0mwOPzGcUc8XOB79mVKdDLCZRw2dOA/ULrF68hcQOzbm8718GKhAmzKtp
         mxQ2jdDKy+ZYmPSjIfdsnUl+AgO0hwLPF0NJtp6Lwit4v/D2p5eLCrIolZDrTKNSgjzy
         pXSU/VPHOejMfDBZvnXZ658ozSRGZfPi5xtslW1zDhYCnihMN8k55MatHyql+yFuWtwg
         uHd45MeY0SzQJ7SMyRa9Y6iuKRVihkmgYX5Jxt6HhDvw4FEjLWu13vLan80/8DhV/13+
         RSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WG4JpoiMii42ipY3eUc5x3VppysZgl8p2dC8kvhLf3M=;
        b=hk8y+91zYAbrFRbLaZGQeBiEMvZ7cRmL33mr0LeDvfrVADE0kzIeJ9F4AOAASIaEI8
         8V60JjnGyiHZ+4XKlX/cdel1ZWT2wP8RjMxvGCMthhpYDcq61WYsKDZsCw37SUjvE4Rs
         rKZQtKQsYiIF+ruKt3jULj/ZJZ7YNR6AehSv9BqMKeuP/Y4E+p1DwZ6I+V2jz2FUhj2t
         kTFlXBQHhbm7YySnvqXpGCArgqAyjl4jCzj9cUXhh7+P5NY65EDaeg9XlUIoZ/j/a69Z
         YC8DWTuUGRPYXsp2fYw3RPL6hDB8W1GxfIzHOiQgE6F342Num9FHBSur7NC8tVVpJPvi
         4ReQ==
X-Gm-Message-State: AO0yUKURbgMl8QpiyCd+CGLOYn26SeGGcKaX9ys7TMitUKLJ47Qm+VlK
        Gb/uO6MVB3NboL5uURQjmyS8f8LXcTB5
X-Google-Smtp-Source: AK7set+CAIl8pXaIDylEO+0It2kuPx0uXVfppeW/vij6LJtOqrFM/81/dwuG1AO16NvNhhF7V9Wak29vo2um
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:e54e:b0:196:5cd3:d88a with SMTP id
 n14-20020a170902e54e00b001965cd3d88amr2445592plf.12.1675189103207; Tue, 31
 Jan 2023 10:18:23 -0800 (PST)
Date:   Tue, 31 Jan 2023 18:18:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230131181820.179033-1-bgardon@google.com>
Subject: [PATCH V5 0/2] selftests: KVM: Add a test for eager page splitting
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
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

David Matlack recently added a feature known as eager page splitting
to x86 KVM. This feature improves vCPU performance during dirty
logging because the splitting operation is moved out of the page
fault path, avoiding EPT/NPT violations or allowing the vCPU threads
to resolve the violation in the fast path.

While this feature is a great performance improvement, it does not
have adequate testing in KVM selftests. Add a test to provide coverage
of eager page splitting.

Patch 1 is a quick refactor to be able to re-use some code from
dirty_log_perf_test.
Patch 2 adds the actual test.

V4->V5:
 - V4: https://lore.kernel.org/all/Y9lIfGtMEEsaw6cd@google.com/
 - Separated a helper function to just run vCPUs for an iteration and
   not also collect the stats. Suggested by Vipin.
 - Added a log message when the host does not support MANUAL_PROTECT,
   and so testing with that capability is skipped. Also suggested by
   Vipin.
 - Added RB from Vipin.

V3->V4:
 - Added the copyright notices back. Thanks Vipin for the right
   thing to do there.

V2->V3:
 - Removed copyright notice from the top of dirty_log_page_splitting.c
 - Adopted ASSERT_EQ for test assertions
 - Now skipping testing with MANUAL_PROTECT if unsupported

V1->V2:
 - Run test in multiple modes, as suggested by David and Ricardo
 - Cleanups from shameful copy-pasta, as suggested by David

Ben Gardon (2):
  selftests: KVM: Move dirty logging functions to memstress.(c|h)
  selftests: KVM: Add dirty logging page splitting test

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/dirty_log_perf_test.c       |  84 +-----
 .../selftests/kvm/include/kvm_util_base.h     |   1 +
 .../testing/selftests/kvm/include/memstress.h |   8 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
 tools/testing/selftests/kvm/lib/memstress.c   |  72 +++++
 .../x86_64/dirty_log_page_splitting_test.c    | 260 ++++++++++++++++++
 7 files changed, 354 insertions(+), 77 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c

-- 
2.39.1.456.gfc5497dd1b-goog

