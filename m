Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A6C44CE25
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhKKAPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhKKAPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:15:50 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE59DC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id d27-20020a25addb000000b005c2355d9052so6612733ybe.3
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DvX+f98zUPARZOebeQ12qND+w4xTLP+FUu/nmbytG5o=;
        b=rbuD+x6csa+0SDQyvZimvz9cHlNUDR0WDM6WokzGhpVHXLChBLIDPjUT0fZWwtMifu
         lDwvBOCJVss6s2HcGly7PvVtXwpKskndqugPzPKy9W30RkEEe7uM+6HIttv3JjMFTJKI
         3ZsX/C0qGdNeWL01Wm+hLV7CwMW0ZZsPETod/K89sfAATXEfhSoElSw4AlU9GZu0OjXT
         eiyZGhZaUHpY1JJB6aCy7Tj5DN7dboGQ9sPcr7/5e09HBgIj2/GwhOMXLWwZlwhDd1vL
         eOzXOI0lI6U8XNfQnY7vbpf446640RMxFFBI9RL/bUqLLMDNi34cBpIU3wFdWLmbyK0K
         bhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DvX+f98zUPARZOebeQ12qND+w4xTLP+FUu/nmbytG5o=;
        b=T6xABxjAydDklhnlNQJ55aEHYBGYVZSVsOlMwPhWclC/VRLs/o+8Jo5IjcYLRDEDJ4
         mx8/CesVHFVes5N/GVtKwoDXBqMpArq8NpjsOGtY9eOw/eCDnJl8OmBzOgXwYX4DFYm+
         wttaprjFjN/Us8lsII7N2+OVwFVLgsWLJyGVDDijOMu+itcP80IVaQX8zxc6tKD5eSzm
         gHCjF7qgE7yHiRaonZfMAIVXPinRT0cyijuXFPkBYXzqC5jUtPogl1HrK0YRv8N1dxkA
         Mz1NkiSuKeEGinoieYUvvS+f7ATZC4yq3ih2CwXdgQsPGowlPIKTzsQjQcyWT16PRQxe
         lVww==
X-Gm-Message-State: AOAM530DGUpHufS6yrUmYLnwaVBnXvi3i+kEXi6aF2Qk6vSmGADrB/T2
        Cl99PphmNjel3jFigULB2NO3qMsYOfcfAA==
X-Google-Smtp-Source: ABdhPJws3YFXo0VqBvOPMfALsAy4uqzBB3QnwWyCUdCVR/nI3kBRya8K91uWNCYxNpawwxHbhJZB0MaK0hCC8Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:bbc2:: with SMTP id
 c2mr3860162ybk.42.1636589581142; Wed, 10 Nov 2021 16:13:01 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:12:53 +0000
Message-Id: <20211111001257.1446428-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 0/4] KVM: selftests: Avoid mmap_sem contention during memory population
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes a performance issue in the KVM selftests, specifically
those that use perf_test_util. These tests create vCPU threads which
immediately enter guest mode and start faulting in memory. Creating
vCPU threads while faulting in memory is a recipe for generating a lot
of contention on the mmap_sem, as thread creation requires acquiring the
mmap_sem in write mode.

This series fixes this issue by ensuring that all vCPUs threads are
created before entering guest mode. As part of fixing this issue I
consolidated the code to create and join vCPU threads across all users
of perf_test_util.

The last commit is an unrelated perf_test_util cleanup.

Note: This series applies on top of
https://lore.kernel.org/kvm/20211111000310.1435032-1-dmatlack@google.com/,
although the dependency on the series is just cosmetic.

David Matlack (4):
  KVM: selftests: Start at iteration 0 instead of -1
  KVM: selftests: Move vCPU thread creation and joining to common
    helpers
  KVM: selftests: Wait for all vCPU to be created before entering guest
    mode
  KVM: selftests: Use perf_test_destroy_vm in
    memslot_modification_stress_test

 .../selftests/kvm/access_tracking_perf_test.c | 46 +++---------
 .../selftests/kvm/demand_paging_test.c        | 25 +------
 .../selftests/kvm/dirty_log_perf_test.c       | 19 ++---
 .../selftests/kvm/include/perf_test_util.h    |  5 ++
 .../selftests/kvm/lib/perf_test_util.c        | 72 +++++++++++++++++++
 .../kvm/memslot_modification_stress_test.c    | 25 ++-----
 6 files changed, 96 insertions(+), 96 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

