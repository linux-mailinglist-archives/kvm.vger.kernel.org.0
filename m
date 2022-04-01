Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79DFD4EFD1E
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 01:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353405AbiDAXjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 19:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiDAXjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 19:39:42 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7711C39BBD
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 16:37:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id r28-20020a63205c000000b00398344a2582so2295279pgm.20
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 16:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uFPpjgTa/chRjLY7b+mPattt0xyCZEYokmBd8NoZh2c=;
        b=D4xCkOuaYDG1sn+kr7E5q45L4Y2Htar2eFDmeVJq6rkZXAwGwiABY9Cge0WbtfgCJD
         3o3+HWH7iH3IwSjfXps0pJfLYyyjFhc3g4Rr0XV25istcHbl5kEzU/tK5Le3UdO9ch0X
         Fb9Haa0NW1KgwN1P0Ptomlt0ZL7c6/nDMGk43eGChdxwGr7az1oK/wHeUnY0a1R/iPcu
         nEgzSad1zx9eUWCeOttJcz4k0UUqhqvV4QqYiKhuO9AmQPIHkWMRv6T9g+vRQhMRCHqD
         r1vNB8tieBe8XS4rWOfYhC5JyWNySjZxwdcJ1S2xLOw8Cc0IR3olV+SqqWR5q50PV2j/
         RhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uFPpjgTa/chRjLY7b+mPattt0xyCZEYokmBd8NoZh2c=;
        b=jkkTT/7wgtjbT/3bPKbF4WswXvNzWw7aIaX0hYKqdhzJFb25HWkLPA6Oy3woW5DpBH
         L6W5kaUjivSJIHD0g6qmMqr3nETeK36y/1yBWzLudTy+GryA2eZ4Dbnqxqgnp4Sb4jJT
         6rXSBiTpaAvWbvHbW6pjFCHmYXLgden2CkwMPL5lR/ujWoiXTgulAXedagIIqk5D38Qr
         hM5E5Vy+tKe5aid9btZ+MnekBJbzAbZkHwj3zX0qz9sEbJahgad3CZ3ed/bnUKqHyYIi
         tnYWH2aKD5da/aiutczi6O01XRuiu48iEmQVtYt4w4kH1sQJEzD2Fo/7EOhjELZiz0Iq
         35tw==
X-Gm-Message-State: AOAM533ANyQH8nPfi1S+S+LeqZjrlJyYpVSnOddkavuJI7dWZR5bnvOP
        J/3dtmNVrC27HCzgtEP7gUXZA0NFr7pZJQ==
X-Google-Smtp-Source: ABdhPJyijwWJiuI86wA9lRlTAJYWbHSIpyyrT//rSar0fjgeHZrk5S0nmfgEb3lsbM2EYSV8U9vEtibEfgRQGA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP
 id m11-20020a17090a858b00b001c65bc8781amr683145pjn.0.1648856271367; Fri, 01
 Apr 2022 16:37:51 -0700 (PDT)
Date:   Fri,  1 Apr 2022 23:37:34 +0000
Message-Id: <20220401233737.3021889-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 0/3] KVM: Split huge pages mapped by the TDP MMU on fault
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>, Peter Xu <peterx@redhat.com>
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

Now that the TDP MMU has a mechanism to split huge pages, it is trivial
to use it in the fault path whenever a huge page needs to be replaced
with a mapping at a lower level.

The main beneficiary of this change is NX HugePages, which now no longer
unmaps huge pages when instructions are fetched from them. This means
that the VM does not have to take faults when accessing other parts of
the huge page (for whatever reason). The other beneficiary of this
change is workloads that set eage_page_split=N, which can be desirable
for read-heavy workloads. The performance impacts are discussed in more
detail in PATCH 3.

To validate the performance impact on NX HugePages, this series
introduces a new selftest that leverages perf_test_util.c to execute
from a given region of memory across a variable number of vCPUS.

This new selftest, while only 188 lines, is largely a whittled down
copy-paste of access_tracking_perf_test.c. So there is obviously some
room for improvement and refactoring that I am procrastinating on.

Tested: Ran all kvm-unit-tests and KVM selftests.

David Matlack (3):
  KVM: selftests: Introduce a selftest to measure execution performance
  KVM: x86/mmu: Pass account_nx to tdp_mmu_split_huge_page()
  KVM: x86/mmu: Split huge pages mapped by the TDP MMU on fault

 arch/x86/kvm/mmu/tdp_mmu.c                    |  44 ++--
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/execute_perf_test.c | 188 ++++++++++++++++++
 .../selftests/kvm/include/perf_test_util.h    |   2 +
 .../selftests/kvm/lib/perf_test_util.c        |  25 ++-
 6 files changed, 244 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/execute_perf_test.c


base-commit: d1fb6a1ca3e535f89628193ab94203533b264c8c
-- 
2.35.1.1094.g7c7d902a7c-goog

