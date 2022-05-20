Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A634552F560
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 23:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbiETV5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 17:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237685AbiETV51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 17:57:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B23F18C073
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:27 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso4825887pjp.4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 14:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NjXD0oUFKqO5u9j8d+Sl2sCwq4vXFI0JKi0ilFFuQ84=;
        b=biwfI3AahdUiD2P59pCHmvb8cEIw3bIx4E0LNFDR2agA2LuoeBctnLLP5Gb3pKW6kV
         JexTni8aVim6sAho7WgXPmmGftTsL06ajzqu8CtGM88ecBXnuLC4j5U5H8/uI4ogIqgg
         cTfKAuZxlYTTb6tyz2q4jDDgnbA36qiKr8Nk392Q1RKPQddV8Qy5CzGAMPuOch1KO+sy
         irysm2ejTS2JDFngJryWR913KLzy08htkDXZezdmf6zHF9GmWa4qwg2fXxnRoT2kdJEe
         e2k4dN/+Vun1Q607h9HF+6ndccAqBeitdqZfCtxskM5aUJDGd7fpeNlnN74zB/2VoU82
         IuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NjXD0oUFKqO5u9j8d+Sl2sCwq4vXFI0JKi0ilFFuQ84=;
        b=B7KyxCeThfOOiMU9/r2uX3Y1oWN6xVyqg2cgPZgEGjWCWp2AKILSeukSrLauIKu/i/
         5OZ784Cbe7gIx9uwXWoJZMVOq8z7xb3eaxg7ZcYMbZ+T5VVbcizzGkWV+uE2I6+wSoQd
         zs6r7ljmXQc5gqMA9Gflxkm0reylbCqi+fpveOBrl05QaQDDcr3EXpaskCI3aOBhpytK
         JShxOakWA//dBY5zFNH1HfwMSBjhZAuGUzIZUgMnwd6b1//SwdAzs/d1YvXMy0QmkhWg
         +JvQf5mX6hdWBK+4yQGJtVGItvRN1+fam/sh7sCv9kyskrV96NEnMW5LoFCnXHWihu/s
         ISag==
X-Gm-Message-State: AOAM531OFB55Y5Qzk+lcRv8ywCzbOpmtNzP/Kce8Wsy26RdDKVg9wxfI
        tOLFIs26WQNEgLKddWLh0jIe8+0LC64BCQ==
X-Google-Smtp-Source: ABdhPJypZxZpwgPFoYI8o4OmYtRFNVDzoEHpDV6JQdIgIxVf8+BKBzjb6kki7rITOs+H0MHzVORl0KpByBf5xA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:2a8a:b0:1df:26ba:6333 with SMTP
 id j10-20020a17090a2a8a00b001df26ba6333mr474147pjd.0.1653083846350; Fri, 20
 May 2022 14:57:26 -0700 (PDT)
Date:   Fri, 20 May 2022 21:57:13 +0000
Message-Id: <20220520215723.3270205-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v3 00/10] KVM: selftests: Add nested support to dirty_log_perf_test
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds support for taking any perf_test_util-based test and
configuring it to run vCPUs in L2 instead of L1, and adds an option to
dirty_log_perf_test to enable it.

This series was used to collect the performance data for eager page
spliting for nested MMUs [1].

[1] https://lore.kernel.org/kvm/20220422210546.458943-1-dmatlack@google.com/

v3:
 - Only identity map a subset of the nGPA space [Sean, Peter]
 - Fail if nested_paddr contains more than 48 bits [me]
 - Move patch to delete all rule earlier [Peter]

v2: https://lore.kernel.org/kvm/20220517190524.2202762-1-dmatlack@google.com/
 - Collect R-b tags from Peter.
 - Use level macros instead of raw numbers [Peter]
 - Remove "upper" from function name [Peter]
 - Bring back setting the A/D bits on EPT PTEs [Peter]
 - Drop "all" rule from Makefile [Peter]
 - Reserve memory for EPT pages [Peter]
 - Fix off-by-one error in nested_map_all_1g() [me]

v1: https://lore.kernel.org/kvm/20220429183935.1094599-1-dmatlack@google.com/


David Matlack (10):
  KVM: selftests: Replace x86_page_size with PG_LEVEL_XX
  KVM: selftests: Add option to create 2M and 1G EPT mappings
  KVM: selftests: Drop stale function parameter comment for nested_map()
  KVM: selftests: Refactor nested_map() to specify target level
  KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
  KVM: selftests: Add a helper to check EPT/VPID capabilities
  KVM: selftests: Drop unnecessary rule for STATIC_LIBS
  KVM: selftests: Link selftests directly with lib object files
  KVM: selftests: Clean up LIBKVM files in Makefile
  KVM: selftests: Add option to run dirty_log_perf_test vCPUs in L2

 tools/testing/selftests/kvm/Makefile          |  49 ++++--
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 .../selftests/kvm/include/perf_test_util.h    |   9 ++
 .../selftests/kvm/include/x86_64/processor.h  |  25 +--
 .../selftests/kvm/include/x86_64/vmx.h        |   6 +
 .../selftests/kvm/lib/perf_test_util.c        |  35 +++-
 .../selftests/kvm/lib/x86_64/perf_test_util.c | 112 +++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 149 +++++++++++-------
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
 11 files changed, 328 insertions(+), 104 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c


base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
-- 
2.36.1.124.g0e6072fb45-goog

