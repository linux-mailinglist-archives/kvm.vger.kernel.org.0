Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9D55EE499
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiI1StA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiI1Ss6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:48:58 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F690E1195
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:48:58 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 2-20020a621502000000b00541081df73eso7833469pfv.9
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=io6BqNSpkQquOtdf74ygDAsh5dGfoLIKnRnnBP4wfhQ=;
        b=OKVp9U72WDQqF0ebWOwsI1gkZKyp9kPFJnlG5qNT9espTkshDfn6VTeKOeQNNHS0l4
         FIUeMU6iD4qB6Itrl4fgrVnyJndEtE1FOTIATf7ZLe+6e1wzyTg5N/+WFydf3ZBaUVoU
         HdbIdWut+EH62pE2oZETYGFy8Z6WoM5LHg/4FqIyI8UTLVhs5XQbNl9LbTGGvFtXsyPb
         JMoJjaF0RqoVIi6ntcObsnOoyUfMOFIyJvN+gRn7Wq62jO46l8MWX9vOX7SuNyXFXH5E
         TDjKmnk/qYl5ZugOwB/QH0VIjcH0AMZCl/S4K3oMn5xfIOuucChL8XN0rb2HTz79EJEX
         /nzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=io6BqNSpkQquOtdf74ygDAsh5dGfoLIKnRnnBP4wfhQ=;
        b=4GIeWTKCFF9/JBGr/QSbHT2a615GnqYwLrreMD8t5FgNwk7cmdGb1fBe3ln8lnxnzn
         sOqlq8/wfgHTd1x+6vXED/6iPYj2ucZIKRfRldvKDWwKr7brUem66lGAUcOhjErFcuCp
         hthuwITxG6CA8ODpoqTmHbV5D12DKTesihOCWRsfRiDOgnP1QOWF7f1vaqfQC8Dvpaph
         ajaLNQLlwwIJOpPYLIoK+irtYlIDpevDalKaDhyaK49ThdC8n6kclNPFYu6QSSDT7Fkv
         91nOaqgAryBEUl26sNe9TwovaHwJ3XucTW7FCSik1Svm1gNdjP4sxZA5PxLSczILobIm
         Dcmg==
X-Gm-Message-State: ACrzQf3idEN/6aeTGnJ81QGfO643aThx8mBB5z9Jmx92rfoWqP2wvtuU
        v0pH0ZfrM54zYBadvl/i3dD+taiu1/RRgg==
X-Google-Smtp-Source: AMsMyM647dif9GEjefdUouJDULcXzwS7Qw0HPQAxN7SnUrVhMRM2FDw5E8nCVzMW0YnZk7z+FSnVq2ffNEfXcw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f803:b0:17a:45e:7cf4 with SMTP id
 ix3-20020a170902f80300b0017a045e7cf4mr1173889plb.44.1664390937774; Wed, 28
 Sep 2022 11:48:57 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:48:50 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928184853.1681781-1-dmatlack@google.com>
Subject: [PATCH v2 0/3] KVM: selftests: Fix nx_huge_pages_test when TDP is disabled
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
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

This builds on the v1 fix for nx_huge_pages_test for TDP-disabled hosts.
Originally this was just 1 patch but now it is 3 to add the necessary
infrastructure to check if TDP is enabled or not so that we can
conditionally use 4KiB or 2MiB mappings in the test.

Sean, I opted not to refactor virt_map() to take nr_bytes since that
will take a bit more work than I have cycles for at the moment and I
want to get this fix in. That being said, I coded up the new
virt_map_level() using nr_bytes so that there will be less to clean up
in the future.

v2:
 - Still use 4K mappins on TDP-enabled hosts [Sean]
 - Generalize virt_map_2m() to virt_map_level() [me]
 - Pass nr_bytes instead of nr_pages to virt_map_level() [Sean]

v1: https://lore.kernel.org/kvm/20220926175219.605113-1-dmatlack@google.com/

David Matlack (3):
  KVM: selftests: Tell the compiler that code after TEST_FAIL() is
    unreachable
  KVM: selftests: Add helper to read boolean module parameters
  KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts

 .../testing/selftests/kvm/include/test_util.h |  7 +++-
 .../selftests/kvm/include/x86_64/processor.h  |  4 ++
 tools/testing/selftests/kvm/lib/test_util.c   | 31 ++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 40 +++++++++++++------
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 19 ++++++++-
 5 files changed, 85 insertions(+), 16 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.3.998.g577e59143f-goog

