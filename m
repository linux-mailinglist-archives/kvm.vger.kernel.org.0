Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6668A52F639
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354136AbiETXdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354123AbiETXdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:00 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC96A1AB799
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:53 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 92-20020a17090a09e500b001d917022847so4919792pjo.1
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZFbHKezqD4ard5zVRPlKPV/RXS+hW0JLupAlha4Sooo=;
        b=ID9IAuldVtmQUcLL0dWA3rN0OsToRdFn5pDaFtKL8PlsvuIAhkBoP9nd+GuO+fBV99
         K2paG4yHde6DNDv2jwScX8k1zOPfEVOwawYvuO9yv0SqsRNXixqkoXdib4+zh29QoXYR
         dBo3HFi1G+uaGx7qIejLNOUBU3Y1PEjU/FM/7LrE/otZyxpmd2Zu/EykOKl9FhCumRlq
         jWawww6VI8RHaeE19eK8BZwAziWkEYz1IR6WdAEluXwtsLCSYA0E4OlxRL0KbpZ5tnPe
         iB/shlsmSp6ah4CKVMjRF0jxcipIRLwn1EWRjFovjN3u07Z5R9W9SLXM3SnEo4mliLrC
         eDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZFbHKezqD4ard5zVRPlKPV/RXS+hW0JLupAlha4Sooo=;
        b=HoUqee7uVo/Rf7N+W7HkAN5q7d0vpqbYiCFjlJwO6SFEn8apqN2Mg/N5rztAsd8KTE
         RQdNP4MVgaKEzYJeLe8WjsMh0fUrNcHk+NiFh8prN2iNlxiq30ViGCo3EW7JcLPYYS7i
         cPFp+exw643L+WODQ410AjMF2kxthcrjpnm/E+HIAJX2XI4GScVL2c3JLSVXRwvrMRz5
         7WjFtmlLJs7MhCX99zNy2wYgSmq4dv3yGGMS98s99o3gSRwg08qB7GomgWtiKKa0YKZJ
         +G0fSSbn8Qr1dvfNEcARVKBY9q3stZpkR8UuB2QscdhWM5UAQ6PdZdHUZhI0B/RQqxKh
         rJYQ==
X-Gm-Message-State: AOAM530Wu0YyghUSAEmoc3FzAjvqglo/0rIiLjjVExzyY99BF3SQZOt/
        6kAsCpqGHY8FfhjFNV0BqXzc18f4lVUCFA==
X-Google-Smtp-Source: ABdhPJxxdDbKslNJaaxnjbRJ+56in0NJqMbSO4Sf4LwKY0uHEo+mQxlLS3t60tvTH0PTpeX7OO3QsVQ3jynUcQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:21c7:b0:4fd:f89f:ec17 with SMTP
 id t7-20020a056a0021c700b004fdf89fec17mr12415166pfj.72.1653089573041; Fri, 20
 May 2022 16:32:53 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:38 +0000
Message-Id: <20220520233249.3776001-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 00/11] KVM: selftests: Add nested support to dirty_log_perf_test
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

v4:
 - Add patch 11 to support for hosts with MAXPHYADDR > 48 [Sean]

v3: https://lore.kernel.org/kvm/20220520215723.3270205-1-dmatlack@google.com/
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


David Matlack (11):
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
  KVM: selftests: Restrict test region to 48-bit physical addresses when
    using nested

 tools/testing/selftests/kvm/Makefile          |  49 ++++--
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 .../selftests/kvm/include/perf_test_util.h    |   9 ++
 .../selftests/kvm/include/x86_64/processor.h  |  25 +--
 .../selftests/kvm/include/x86_64/vmx.h        |   6 +
 .../selftests/kvm/lib/perf_test_util.c        |  53 ++++++-
 .../selftests/kvm/lib/x86_64/perf_test_util.c | 112 +++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      |  33 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 149 +++++++++++-------
 .../selftests/kvm/max_guest_memory_test.c     |   2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |   2 +-
 11 files changed, 343 insertions(+), 107 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/perf_test_util.c


base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
-- 
2.36.1.124.g0e6072fb45-goog

