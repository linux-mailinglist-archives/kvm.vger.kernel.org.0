Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03F05153D5
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 20:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380069AbiD2SnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 14:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359759AbiD2SnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 14:43:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F82D64C7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id t3-20020a656083000000b0039cf337edd6so4124364pgu.18
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 11:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4KrtaoottHFKwBmoLfKPi3vYafOZyYW9mpYMZwW73u8=;
        b=fLNBs67h5Y638d+ag3yrs/r/0a3L29XM5HrAy1IcUHEoCRe4qaX+KU1IhB3BZl2zGV
         det56XWjm0WPdRlbm7DbMpcYlqR2n8bQzzgXN//NieroyHQVbt3/qJVmipLmm1Wfe1xQ
         Z9nklbpUad0lK0GJkLTGCpVgq9wvAwjQSFk9dmigmt55MwuGuMLeWnngwC7WLkDlrJ7+
         1jA3vO9KC+lGBL09lSYYwuifcwPpREN3pPjX+DUKdKLXN+NBVDPEJWKdlHrY7Ey3q68s
         yFF/DXr7Tr4C3jmLUb5WaDZD4OX86b45xw94Vyv3u+62giZhlWRl6ZBrNarLAsAdrAA4
         PCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4KrtaoottHFKwBmoLfKPi3vYafOZyYW9mpYMZwW73u8=;
        b=OH3J8ZA3dTJb9NN8o07sYpDUsZHI2EGVReDWeoCMvJwviyH1O9/KqAIk74Fg2b8fn8
         w0aGhSiJrHc0GlI1WoKfL4b4EWYd4RBa9COdh7xkDb2DoYD15Jm0CWiUGUe/YH1iuu2R
         UnzbaURgmMZgmHSoc2oKX+NMD58DyovI/k2y5vAMNYPhi2iKUd644NBjzFe0fDYBvL6+
         LaCVoRyQlhQ0GrhbHyWutZgcc4fSnypvmTGxgrJH+f1TAGWq0fO1X1mD2bWwWAXPU1bf
         msneSV35ZjGLzuhnhfY11+3r8v4bsn8wSjfUdpEoFhy6jIriSRyhSUmZbXaHkmpNnONy
         9jLA==
X-Gm-Message-State: AOAM530dFbMhJZhaaGFcA4J+TFu5o1/5IOXZOP7SFrjL/1RLhgyxGJI7
        IvU/m3y4pS/YKljyGgeybGtGR1/pZBYTZQ==
X-Google-Smtp-Source: ABdhPJzWfNdtqr0cDMPOMybIE2VccI4UJVRv6K1s7brvYI2i7trrD1mpJ3pxIzWATKWLlXc5+yP59W+Otq1d2g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:10d3:b0:4fe:5d:75c8 with SMTP id
 d19-20020a056a0010d300b004fe005d75c8mr299292pfu.6.1651257582868; Fri, 29 Apr
 2022 11:39:42 -0700 (PDT)
Date:   Fri, 29 Apr 2022 18:39:26 +0000
Message-Id: <20220429183935.1094599-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 0/9] KVM: selftests: Add nested support to dirty_log_perf_test
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

David Matlack (9):
  KVM: selftests: Replace x86_page_size with raw levels
  KVM: selftests: Add option to create 2M and 1G EPT mappings
  KVM: selftests: Drop stale function parameter comment for nested_map()
  KVM: selftests: Refactor nested_map() to specify target level
  KVM: selftests: Move VMX_EPT_VPID_CAP_AD_BITS to vmx.h
  KVM: selftests: Add a helper to check EPT/VPID capabilities
  KVM: selftests: Link selftests directly with lib object files
  KVM: selftests: Clean up LIBKVM files in Makefile
  KVM: selftests: Add option to run dirty_log_perf_test vCPUs in L2

 tools/testing/selftests/kvm/Makefile          |  50 +++++--
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 .../selftests/kvm/include/perf_test_util.h    |   5 +
 .../selftests/kvm/include/x86_64/processor.h  |  17 +--
 .../selftests/kvm/include/x86_64/vmx.h        |   5 +
 .../selftests/kvm/lib/perf_test_util.c        |  13 +-
 .../selftests/kvm/lib/x86_64/perf_test_util.c |  89 +++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  27 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 140 +++++++++++-------
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
 11 files changed, 262 insertions(+), 98 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c


base-commit: 84e5ffd045f33e4fa32370135436d987478d0bf7
-- 
2.36.0.464.gb9c8b46e94-goog

