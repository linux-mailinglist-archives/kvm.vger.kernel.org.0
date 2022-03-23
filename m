Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68454E58AD
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344028AbiCWSu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243218AbiCWSuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:50:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77495606C9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:25 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ge20-20020a17090b0e1400b001c64f568305so1529517pjb.8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=vksLZSJ/1XSsrv5+Q44yzVYsU90jJzgSeUJqyoBHB3k=;
        b=Mol/t6djA6xfgUtihD1s4EYkxSSzamZSlq8W+dA2jAHEMVwdF9WxvpkKB8lwCoJMDY
         9wuW/UVP7U3AarQBF6lE4gimtHGT9ecsTfJo6IiQB5MU7bqvoiYg4e4VVxCGM3FL/TiY
         rFZqb6pGu0w+U3LTN5nFohLXarkpEHjAFQ+U4UbrePmi7F0lVs3S/quSQWLI7bwTqYHP
         VE8gTIP50G9ETEPEMG+DS358KFjYb956uzEsMtyWR/yejP+8EEE/oaSlpFi8szXttbyL
         M3iHQCK6BErBslrSku1TrBtmpcRYQh4FdJUtSrAfmpJGOA8YKjEJSOr03FSJhaWko0vl
         Ebfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=vksLZSJ/1XSsrv5+Q44yzVYsU90jJzgSeUJqyoBHB3k=;
        b=wpxWaWOTGJ+jmguH/Tgg9I30PQJwWQw4tX5J525w/eitIVaAePJutCwspLAk+akJxh
         PAirs/cP9MNlcn0WTGgJkyWiBp7ERXbbD5i6O7dF+zKmw6LyQgdMujDCHz0XEBfuXOMD
         wphfRjw6111PZMnQjqm+BJmtdW/omCkedpGQ3S4b7X/WdpbpAQW1sj4hh1UcGz2siNb/
         jIjlhy3pEUyNWY6acdgSVzajOYAV2CI+OarQcEcdP0jtbShMSgK9O/EaCd+BxJUrwr16
         IXabEgkOvvtTZBiwkqaOEU0I6+6TGMc2ZczoaOQ3ik1NUpbC4MF1gjgNQD3CHgMRO2oH
         NQ9Q==
X-Gm-Message-State: AOAM5310p33fVVg4V7r7OD1Iwugj/7qbLHUeid5Fk9mxXm55jtP+ge8/
        W9uLnj8mJcZWh3gaznEkqXjyx5TNXrey
X-Google-Smtp-Source: ABdhPJxpPj/2h7pKgUcUCSuYC1DoUpWJiS75/RmWuIi+WVtwRRkKM//2d/pTcA6go0BWa1pEsyBxi/J2CdmG
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:d3d1:b0:1bb:fdc5:182 with SMTP id
 d17-20020a17090ad3d100b001bbfdc50182mr13515326pjw.206.1648061364908; Wed, 23
 Mar 2022 11:49:24 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 23 Mar 2022 18:49:10 +0000
Message-Id: <20220323184915.1335049-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 0/4] Verify dirty logging works properly with page stats
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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

This patchset is to verify if dirty logging works properly by checking page
stats from the per-VM interface. We discovered one performance bug in
disallowed_hugepage_adjust() which prevents KVM from recovering large pages
for the guest. The selftest logic added later could help validate the
problem.

The patchset borrowes two patches come from Ben's series: "[PATCH 00/13]
KVM: x86: Add a cap to disable NX hugepages on a VM" [1], which completes the
selftest library functions to use the stats interface.

[1] https://lore.kernel.org/all/20220310164532.1821490-2-bgardon@google.com/T/

Ben Gardon (2):
  selftests: KVM: Dump VM stats in binary stats test
  selftests: KVM: Test reading a single stat

Mingwei Zhang (2):
  KVM: x86/mmu: explicitly check nx_hugepage in
    disallowed_hugepage_adjust()
  selftests: KVM: use dirty logging to check if page stats work
    correctly

 arch/x86/kvm/mmu/mmu.c                        |  14 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  52 +++++
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 196 ++++++++++++++++++
 5 files changed, 268 insertions(+), 2 deletions(-)

-- 
2.35.1.894.gb6a874cedc-goog

