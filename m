Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD5152AB73
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 21:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352457AbiEQTFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 15:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237339AbiEQTF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 15:05:27 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42393F30C
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d10-20020a17090a7bca00b001df1d7dd8cfso4840729pjl.8
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=p8KKOJFXLr8CtV9CTtnEv6qLeWwnDBwtgr7/IWFEgXc=;
        b=eWkox+WnCzDS+gw6bl7DgpEI60pgNXGNX46p/hU/gJ7v18+iWnmJLBIEkjAbFVBSNv
         u+cp/j/7mh4SO5V79jII2I8uRulErHgt0G9fU0aLX0SDJjqcyqKK+NnR7fzE8xYl9Phd
         Gbg5YlN8VxFqMQ/e1gPSkHxJB1VsqymYg95ZMVpH1dcfchRSLKSyLDHPs5JH/sIE+V1a
         lvP9hxaRYoX62ARi+nQc0k4A5Q/9TyjEoCrPLpWy1Sxim80ZM7YZ9Rz/oHZyp+0U71aR
         GjRIdFrRfDq0pwJ+4a9ZHSDD3O2p2M8O1Lw4fYdyZlBKf/QQwPF2xHNv2UoVfm+W+c0h
         vmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=p8KKOJFXLr8CtV9CTtnEv6qLeWwnDBwtgr7/IWFEgXc=;
        b=c1Ep95QKuSS37CVjP96HXf9ape7jF6rbf5noOKdFP3WyTzfIvmW7zT2l+d4wYbXhC1
         B3TP+1CZ8N+9RiNimFHYwo+RLd/2Fz5YDQRHVm7XicGmD6GPU0bas5PRSmAPgNU7Izkn
         Xrq2w+fCPKbOGAQ4VdJxZEusfvi566hCtHtW/VFEFhOhz8yRfC4affmo6Sywxsr2wx+j
         ULLseXlFxAc3k47thbLkfyUnNFnWEq4XXZk2J9eU2gg8W85GWbLKbrqS9feic6eELiNB
         D0FN6LJeTy1zLD1el9vwnaT4XoOtBjwL4/bF33vApgd2uypaOuSC74Dr2lWJIfs3/gH9
         WKPQ==
X-Gm-Message-State: AOAM5327VvH3NBo9oqRPet7s21+mlOmoq0RYySOIiF05r5Gm/IYeNVxN
        nyiKkOdzT5X/BpaSHG+fyrXIT6YMia5HUw==
X-Google-Smtp-Source: ABdhPJx8hNSsiWE3KeGso3OzIi/Yz4WmXsZorss1FYzDIko3oReRWWaPeKDZI8EB4VbjR7Sggyuh7aVyvdHrcg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:b47:b0:50e:141a:f01a with SMTP
 id p7-20020a056a000b4700b0050e141af01amr23884542pfo.22.1652814326232; Tue, 17
 May 2022 12:05:26 -0700 (PDT)
Date:   Tue, 17 May 2022 19:05:14 +0000
Message-Id: <20220517190524.2202762-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v2 00/10] KVM: selftests: Add nested support to dirty_log_perf_test
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

v2:
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
  KVM: selftests: Link selftests directly with lib object files
  KVM: selftests: Drop unnecessary rule for $(LIBKVM_OBJS)
  KVM: selftests: Clean up LIBKVM files in Makefile
  KVM: selftests: Add option to run dirty_log_perf_test vCPUs in L2

 tools/testing/selftests/kvm/Makefile          |  49 ++++--
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 .../selftests/kvm/include/perf_test_util.h    |   7 +
 .../selftests/kvm/include/x86_64/processor.h  |  21 +--
 .../selftests/kvm/include/x86_64/vmx.h        |   5 +
 .../selftests/kvm/lib/perf_test_util.c        |  29 +++-
 .../selftests/kvm/lib/x86_64/perf_test_util.c |  98 ++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 147 +++++++++++-------
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
 11 files changed, 300 insertions(+), 103 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c


base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
-- 
2.36.0.550.gb090851708-goog

