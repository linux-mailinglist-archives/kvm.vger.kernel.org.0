Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4792A3173E9
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhBJXHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbhBJXHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:07:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B015DC061574
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n81so4197554ybg.20
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=lEvJNf+eeRBlW12CD2hGETxb4z2rF+2HjSgOd3i59N4=;
        b=EtP2zMcj9He4HNUCSKuttQNySDsBqi1ZFBdhPZjDXSzxacN8PGSoJ1aA/bNqHr26np
         lm/gO+046j/WVp1Lnb7WOP8ix1jcu3LvnZMtkfU/KFvVMhPlOXE3UKpCbgzTjnQGk0KD
         hPrA3sQzfMYMa/bCG9W5TDrxAuMLqgz8PRzJ4fyd8yqEIp95QmeysR+VAykYWzsTWG8e
         2FBlLPp6EhPCTPEJ2oALEzQKLMBhsd9I9G7mU/SZna34pkK8LMuwnIeAAHR0rgiT1psO
         MmFaAUeRnPN9GQawQf1wv01h1HanZAtVMuKkDPUXCfXEsLAJtKIrUNBXDM+7VR/bSrSo
         Q2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=lEvJNf+eeRBlW12CD2hGETxb4z2rF+2HjSgOd3i59N4=;
        b=ewfv7ZfymWpi4mBMN2lBHrSnJColi8DMk1f3PvZWZxqqNvDY5vOMaHEcav23bVBJ1f
         3ezYmV8M4LBuRUj7PI/PkSgkVIFKyJX4X6/hXoyhw5Awrpj5yJWHPS8v+L5rIkajagML
         Da4hYbet652CG4HwEMLXaWRJtC8eWLfDCIlLk2F3gm1pw/VRdAGfkuVqNDZnYGl2fYt1
         +LV9LQW6vtQ0w5caKbqZRVNJEgwJwmtrxlRJ+Zdvf0HwqhIOK743+ZjYFHxcAmy+oQDF
         aW2aQhMRyq1dmZEB4Zpt31uGV6EH3xZ52wHLw67/FYOaTM0Zu2WEuEV1OPHfNzikOvcF
         qyNw==
X-Gm-Message-State: AOAM530Bf5eHQay+cjlN5QKV0rjs+TfkwSzeqsSBYEu5ctw0FeWFsRm3
        Ic6qs3SKQsFEzkTGzO5aW4GnjpOEpzE=
X-Google-Smtp-Source: ABdhPJwHI09nguSTMiySI5MlS1toxb2QJl5U/U1345plc//rwpzjcITxlVORplYLs2I4WgWuXSP0gmKvkhs=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:e052:: with SMTP id x79mr7761396ybg.378.1612998391954;
 Wed, 10 Feb 2021 15:06:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:10 -0800
Message-Id: <20210210230625.550939-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 00/15] VM: selftests: Hugepage fixes and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix hugepage bugs in the KVM selftests that specifically affect dirty
logging and demand paging tests.  Found while attempting to verify KVM
changes/fixes related to hugepages and dirty logging (patches incoming in
a separate series).

Clean up the perf_test_args util on top of the hugepage fixes to clarify
what "page size" means, and to improve confidence in the code doing what
it thinks it's doing.  In a few cases, users of perf_test_args were
duplicating (approximating?) calculations made by perf_test_args, and it
wasn't obvious that both pieces of code were guaranteed to end up with the
same result.

Sean Christopherson (15):
  KVM: selftests: Explicitly state indicies for vm_guest_mode_params
    array
  KVM: selftests: Expose align() helpers to tests
  KVM: selftests: Align HVA for HugeTLB-backed memslots
  KVM: selftests: Force stronger HVA alignment (1gb) for hugepages
  KVM: selftests: Require GPA to be aligned when backed by hugepages
  KVM: selftests: Use shorthand local var to access struct
    perf_tests_args
  KVM: selftests: Capture per-vCPU GPA in perf_test_vcpu_args
  KVM: selftests: Use perf util's per-vCPU GPA/pages in demand paging
    test
  KVM: selftests: Move per-VM GPA into perf_test_args
  KVM: selftests: Remove perf_test_args.host_page_size
  KVM: selftests: Create VM with adjusted number of guest pages for perf
    tests
  KVM: selftests: Fill per-vCPU struct during "perf_test" VM creation
  KVM: selftests: Sync perf_test_args to guest during VM creation
  KVM: selftests: Track size of per-VM memslot in perf_test_args
  KVM: selftests: Get rid of gorilla math in memslots modification test

 .../selftests/kvm/demand_paging_test.c        |  39 ++---
 .../selftests/kvm/dirty_log_perf_test.c       |  10 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  28 ++++
 .../selftests/kvm/include/perf_test_util.h    |  18 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  36 ++---
 .../selftests/kvm/lib/perf_test_util.c        | 139 ++++++++++--------
 .../kvm/memslot_modification_stress_test.c    |  16 +-
 7 files changed, 145 insertions(+), 141 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

