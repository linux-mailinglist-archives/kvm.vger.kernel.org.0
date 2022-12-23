Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8500A6549E2
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 01:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiLWA5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 19:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLWA5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 19:57:47 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4E92188A
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:46 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m16-20020a170902db1000b0018fa0de6aa6so2387688plx.18
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 16:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b29o5HSnDYTmWKzTtpaXEeYgrw2TDFKr2p0Q8+HjsNM=;
        b=ElUFGASvo+SEqmf91jQ7pr4vVjOmXfyFl7KvLXWpDNbxIU5k3lCNmSBWHsYc4izHGT
         K9reZTzg3Pi/r4XOJJU5+EuAWfrR/NQCZdtaWZN4UuzSAX32pxagnCxgQAKIyqGZl1q5
         fInmcehDeJjBJFNRRpgH6ZAXA5DTPoJLacO4DmKKMttX0uFBC9UXy1PpG5QSuh9Vu/QU
         FNXDe4PQz7L3uuyUHN7Q6TjQJEogC6Fw461JKiT+qo7B1nna606DzaowIs8M33Iho1U6
         HtVF8X79gFbB2PPPLE+aK7jxdRtvJZwGkfemnOq/WGU3ktjrHYgjfc1LyUg3h2n1yF7O
         jWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b29o5HSnDYTmWKzTtpaXEeYgrw2TDFKr2p0Q8+HjsNM=;
        b=6DYxYQA+xojJ8Tuq3xq5LjmEWWhlY4lh88ZBc7uZu99k2X8Yr4ahldl+JsCZWKaeqD
         /gVGjJFR+XEbdPRaH7dVZ9e/zJK/wT52TZHU5dkqKTiPnsW0NSoQYmJI4lC0JeLF+IDA
         FCJgF6kOiLplDQMnMwfQY5HPSCpsABgcBBRzql8jC+gFr8DfI+DfrkOtpOBLTLBgOVxc
         kC6GrvAGoC4fPenq+pGHVJrx7sI3ZSmX+MTV/ezm2R6l0R1XyL86MiEf4NrktyNC9xcm
         MK+zncwAxiwECWOr2tdnDMaCZ7w6mdZ/X3x3/4Wq4WseNFIOkkDDUMOnnnLXqw7wVgcV
         wXiQ==
X-Gm-Message-State: AFqh2krr8K8HS9s6c1i8xEfQA+gAPetcjD0selfUNrIH10DewCQfERiG
        Dawzh2TmuBldDBdG/RBYCUC6XeqIALg=
X-Google-Smtp-Source: AMrXdXuJf/1b5zD4/IaCYjB6Q5P9h6Uzc5VbdwQ7fDMekMbNc7T1kuU68br45Cp13nsjugQIR+ijSCtx9Mg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c292:b0:219:828e:ba8 with SMTP id
 f18-20020a17090ac29200b00219828e0ba8mr927461pjt.118.1671757065401; Thu, 22
 Dec 2022 16:57:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Dec 2022 00:57:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221223005739.1295925-1-seanjc@google.com>
Subject: [PATCH 00/27] drm/i915/gvt: KVM: KVMGT fixes and page-track cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

Fix a variety of found-by-inspection bugs in KVMGT, and overhaul KVM's
page-track APIs to provide a leaner and cleaner interface.  The motivation
for this series is to (significantly) reduce the number of KVM APIs that
KVMGT uses, with a long-term goal of making all kvm_host.h headers
KVM-internal.  That said, I think the cleanup itself is worthwhile,
e.g. KVMGT really shouldn't be touching kvm->mmu_lock.

Note!  The KVMGT changes are compile tested only as I don't have the
necessary hardware (AFAIK).  Testing, and lots of it, on the KVMGT side
of things is needed and any help on that front would be much appreciated.

Sean Christopherson (24):
  drm/i915/gvt: Verify pfn is "valid" before dereferencing "struct page"
  KVM: x86/mmu: Factor out helper to get max mapping size of a memslot
  drm/i915/gvt: Incorporate KVM memslot info into check for 2MiB GTT
    entry
  drm/i915/gvt: Verify VFIO-pinned page is THP when shadowing 2M gtt
    entry
  drm/i915/gvt: Put the page reference obtained by KVM's gfn_to_pfn()
  drm/i915/gvt: Don't rely on KVM's gfn_to_pfn() to query possible 2M
    GTT
  drm/i915/gvt: Use an "unsigned long" to iterate over memslot gfns
  drm/i915/gvt: Hoist acquisition of vgpu_lock out to
    kvmgt_page_track_write()
  drm/i915/gvt: Protect gfn hash table with dedicated mutex
  KVM: x86/mmu: Don't rely on page-track mechanism to flush on memslot
    change
  KVM: x86/mmu: Don't bounce through page-track mechanism for guest PTEs
  KVM: drm/i915/gvt: Drop @vcpu from KVM's ->track_write() hook
  KVM: x86: Reject memslot MOVE operations if KVMGT is attached
  drm/i915/gvt: Don't bother removing write-protection on to-be-deleted
    slot
  KVM: x86/mmu: Move KVM-only page-track declarations to internal header
  KVM: x86/mmu: Use page-track notifiers iff there are external users
  KVM: x86/mmu: Drop infrastructure for multiple page-track modes
  KVM: x86/mmu: Rename page-track APIs to reflect the new reality
  KVM: x86/mmu: Assert that correct locks are held for page
    write-tracking
  KVM: x86/mmu: Bug the VM if write-tracking is used but not enabled
  KVM: x86/mmu: Drop @slot param from exported/external page-track APIs
  KVM: x86/mmu: Handle KVM bookkeeping in page-track APIs, not callers
  KVM: x86/mmu: Add page-track API to query if a gfn is valid
  drm/i915/gvt: Drop final dependencies on KVM internal details

Yan Zhao (3):
  KVM: x86: Add a new page-track hook to handle memslot deletion
  drm/i915/gvt: switch from ->track_flush_slot() to
    ->track_remove_region()
  KVM: x86: Remove the unused page-track hook track_flush_slot()

 arch/x86/include/asm/kvm_host.h       |  16 +-
 arch/x86/include/asm/kvm_page_track.h |  67 +++---
 arch/x86/kvm/mmu.h                    |   2 +
 arch/x86/kvm/mmu/mmu.c                |  61 +++---
 arch/x86/kvm/mmu/mmu_internal.h       |   2 +
 arch/x86/kvm/mmu/page_track.c         | 283 +++++++++++++++-----------
 arch/x86/kvm/mmu/page_track.h         |  59 ++++++
 arch/x86/kvm/x86.c                    |  13 +-
 drivers/gpu/drm/i915/gvt/gtt.c        |  45 ++--
 drivers/gpu/drm/i915/gvt/gvt.h        |   4 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 138 ++++++-------
 drivers/gpu/drm/i915/gvt/page_track.c |  10 +-
 drivers/gpu/drm/i915/gvt/vgpu.c       |   1 +
 13 files changed, 386 insertions(+), 315 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/page_track.h


base-commit: 9d75a3251adfbcf444681474511b58042a364863
-- 
2.39.0.314.g84b9a713c41-goog

