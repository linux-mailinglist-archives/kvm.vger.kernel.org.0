Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A548C33CA01
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhCOXiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbhCOXiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:38:12 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C708C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 194so39774842ybl.5
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 16:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OJG5tHSRHGT9S+uZcZRNR3aTYP0+DUQ0Eor7atCfRB4=;
        b=JTPqPdRQbM5CiZ6rBU7vJ1rcRT+FqRrK4VFC/asvMFNG12vo/RlN42YMWGU2ajbuaC
         V0rvz/PxHaZfPwo9Ibdsj/8BeeiJnw8KbKw2gGMSHzZlR7E5FhcnNc2C3136RoreuMPb
         dSewy+veTF6Re1439u5iFaaOhRszQwnG+ZBKK9H+IRfULxUBCWsYxgq4LW5gt+ru/3Bx
         kcI5uuJpGzp+9DdD+sify9W6QRWhhrINgnMVVaTT1b6qoChRwnwVQa9QYeqG0wUKPhZw
         v08+2U5Tzb50jPT+bBMaYFmRDqtpEIOWFmFFANuW1w/10fMb+m5fWsYdXq2wuZ+sxW8c
         jXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OJG5tHSRHGT9S+uZcZRNR3aTYP0+DUQ0Eor7atCfRB4=;
        b=moEo0paSfObZUdnQRR0t7rXUmlYwWtgpPZdGsHbhpvwRsbUodjd9N5uHWU5Y9e5NC6
         nPAb0Go2H0D1TojWMnOyHMltTtGWGzIQ7tfljPBbZVx6UAji/5zzxYmpPW43YPfsxYb6
         710TUhnyxmPU/RD0bSmIhIDVU/HWt6T02BI3UjgMBrRnAK1PjQhnc9WvuRhvPHrxxaBm
         7hHp6YNJfMsjqzRzIoD+Is3y4AWvieu4B/zbfIMTDRIKcf8eKSLB45ekO2evhoDPTQXo
         JD0y7Tyg9RoLQF7x5EnqSH7+sajdEAuBortg/U8p0fFQvhNgjjLlALIkMa9MMuQemet9
         JYAA==
X-Gm-Message-State: AOAM530xEvT1XH2XRu+4ua7odSnw7YIS/tVeQea0Tp1Q9tklqiYtI93h
        BllZwGP/1Co7HkzCHgt5YZAEZyF9V4Xh
X-Google-Smtp-Source: ABdhPJyb7sgl96cn0UFQyghFSxnyvOu5a4b/lo/hS2BRsSTyGhPkX1P6I+5vprLKAn5qurT1N+F2Nc/3xvOc
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:a25:7306:: with SMTP id
 o6mr3101056ybc.132.1615851491748; Mon, 15 Mar 2021 16:38:11 -0700 (PDT)
Date:   Mon, 15 Mar 2021 16:37:59 -0700
Message-Id: <20210315233803.2706477-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v3 0/4] Fix RCU warnings in TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Linux Test Robot found a few RCU warnings in the TDP MMU:
https://www.spinics.net/lists/kernel/msg3845500.html
https://www.spinics.net/lists/kernel/msg3845521.html

Fix these warnings and cleanup a hack in tdp_mmu_iter_cond_resched.

Tested by compiling as suggested in the test robot report and confirmed
that the warnings go away with this series applied. Also ran
kvm-unit-tests on an Intel Skylake machine with the TDP MMU enabled and
confirmed that the series introduced no new failures.

Ben Gardon (3):
  KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
  KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
  KVM: x86/mmu: Factor out tdp_iter_return_to_root

Sean Christopherson (1):
  KVM: x86/mmu: Store the address space ID in the TDP iterator

 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/tdp_iter.c     | 30 +++++++++++++++----------
 arch/x86/kvm/mmu/tdp_iter.h     |  4 +++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 40 +++++++++++++--------------------
 4 files changed, 41 insertions(+), 38 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

