Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791714E58B2
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344046AbiCWSu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344033AbiCWSu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:50:57 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B791F606E0
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:26 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b4-20020a170902e94400b0015309b5c481so1294561pll.6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=slbs+omTj8xyRVbCkc6cD/g6x3OLZjyKyltZ5xxXewk=;
        b=JOgyL7wv6R8OMnIGun2hdLU6NtSAivXpQTUW4Tl2D/z/uPw4YxriqKwTLYk4wf590a
         Bosvzj4LJOxmE8QH5fFPbuBjFziPfr64viJZZ4i217n8OygNOi0pD2YsgwFbt0McL2c7
         0h8Jo39B1xmKIrXl0QiL0/kbxUb5HhiIuSKc80XSYXjE9O3ba55Ld4KjVkmu7wWIJV5f
         22QzRQTo8Sf7AHBpfaHo+YJwpbXzCRmf+ADazmAxkVP7R8SXsCWXypH9IJCyY11TFkAc
         GefZsQcIY75ToGGtbqCQy8w24Paf3EUlaCkJJuQ5oCUC2o6CmLHokr6N8Bd0TqHmPoVA
         QEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=slbs+omTj8xyRVbCkc6cD/g6x3OLZjyKyltZ5xxXewk=;
        b=m1pmLumbh7IkKB4p/eDyy7i3Gx+pzs3zqCnWM1wtgaWc7McI0lxTjw0C5uvbvkPA5B
         NkJysXK8EKArdW1oYs7APwWqA+kdWv9bG4F6qnbkRQm/KdrroT+a8rb+nFOZqznHX0v7
         uPtFaICftmdxYMbD+cZ6myLndUz+C+KQNLwBcvWaX7ptUL247FrY+wX6CK56nSZQ9xFT
         QXikB+tv/nisZh1cYqnr+mZV0n8+lhgt4q3HPn8AIVesLYNopxVcbiPieyumcbf2TUG8
         woWy2b4ZvSIo3+o3TpwItX8uSP4YKRqCeMsXfXXgUOUeNgQfh8TY/i9SsQsHVrGewPub
         G9Sw==
X-Gm-Message-State: AOAM530AhfXn3rgyq8XQFNL/GDRhO8QNs0Ip0xLFsOj5qQ8YW7krs5Gi
        VGB01SxPoPPsVTLvdSuLzSxZMyDpshVf
X-Google-Smtp-Source: ABdhPJzlBoaUIUX6DtX8d5f88vHUtRaluCuxp2990xcogvOPaTqSYv2FxYGKeJxvtICOHJJhQtfHlWI0LcxF
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP
 id h16-20020a056a00231000b004fa7eb1e855mr1170187pfh.14.1648061366233; Wed, 23
 Mar 2022 11:49:26 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 23 Mar 2022 18:49:11 +0000
In-Reply-To: <20220323184915.1335049-1-mizhang@google.com>
Message-Id: <20220323184915.1335049-2-mizhang@google.com>
Mime-Version: 1.0
References: <20220323184915.1335049-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 0/4]  Verify dirty logging works properly with page stats
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
KVM: x86: Add a cap to disable NX hugepages on a VM" [1], which completes
the selftest library functions to use the stats interface.

[1] https://lore.kernel.org/all/20220310164532.1821490-2-bgardon@google.com/T/

v2 -> v1:
 - Update the commit message. [dmatlack]
 - Update the comments in patch 3/4 to clarify the motivation. [bgardon]
 - Add another iteration in dirty_log_perf_test to regain pages [bgardon]

v1: https://lore.kernel.org/all/20220321002638.379672-1-mizhang@google.com/

Ben Gardon (2):
  selftests: KVM: Dump VM stats in binary stats test
  selftests: KVM: Test reading a single stat

Mingwei Zhang (2):
  KVM: x86/mmu: explicitly check nx_hugepage in
    disallowed_hugepage_adjust()
  selftests: KVM: use dirty logging to check if page stats work
    correctly

 arch/x86/kvm/mmu/mmu.c                        |  14 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  53 +++++
 .../selftests/kvm/include/kvm_util_base.h     |   2 +
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 196 ++++++++++++++++++
 5 files changed, 269 insertions(+), 2 deletions(-)

-- 
2.35.1.1021.g381101b075-goog

