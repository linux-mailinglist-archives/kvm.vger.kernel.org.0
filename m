Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A7A457B65
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhKTEyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbhKTEyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:32 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF55C06174A
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:55 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j18-20020a63fc12000000b002dd2237eb1cso5056017pgi.5
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=4IhrBchGEy/kZk/jdMT8RTgApJngWrlTssCYuVoSOPk=;
        b=HOTIk1mHuXrt1xdMa/OyjKJbTCn6KhyEoHZFHd/d2t6jKpDrOgtYIecsVCBTltwsk2
         o6IV2cTDbdYO9jmka/xsOg+g4i49JSlwfx2voR8UU4WUrhpH/HuJ9gAZE5+/C4ebpD3u
         lkfUoPBs8BosmnY5eYnIZvRMAbnK5O8thS63mVBNDdazFSzw0VpGyE/4Xyq0coR8tTcc
         su6O8oRk83xs0fPmB9oKY2dMIbzSReGkf2/Q/CVVUwtgtwVww1VqFgPFgX5eRaoaQnDk
         Y3X8KLUgthcPwCjn3I5dA8uE/4eWZwp1AziNFmAqkSlE6QRUe4YHn3GbTBRH6pto/zDc
         YVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=4IhrBchGEy/kZk/jdMT8RTgApJngWrlTssCYuVoSOPk=;
        b=VJXbkZfxTATxIVttNqb5qHx6dEhiYLOkOkkpfj7P9GjDY+quxtRxxdwJbJFb8M60Ga
         r8bJJMKIdkoNBo42awZZ/k9QgnEQU0CmpUVVVsvbXwlYDLtIwvseHz0nY88PgcgDU5Mq
         jXURh5ZXkolnVFi9IVdgriFgzCB+jt96WZ07P8+D+TGuSAwrP73qesH65icOnQDC0dri
         C6IlvmWYBEGRiJHpI8m9EoROZPeInaaGaT5XjARQedYfR0XKpdOvE4+GABhG5VgPE3Xh
         npOJY94bym/5m7QRdTYmF9iv4rHN3nA6k32vQjSifcP9Pf2m4jJk6HoR6HJVCM6X3Wk/
         K01Q==
X-Gm-Message-State: AOAM533nJKVVFMT8XRNO2WWufx2oufS7keHTemxevmcCE8UkKQvDP+lM
        LpXVEXYT4cxllxou4+QbUAkAseWkctI=
X-Google-Smtp-Source: ABdhPJzdECgrL9HRZqvqAW+QyFzCtsdEv4HMdhY076bm7gsZJQ8OlhiNCO29qojVVEh/s5+F/PV2lcKDP5A=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr729650pjf.1.1637383854852; Fri, 19 Nov 2021 20:50:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:18 +0000
Message-Id: <20211120045046.3940942-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 00/28] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
number of TLB flushes, and to clean up the zapping code.  The final patch
realizes the biggest change, which is to use RCU to defer any TLB flush
due to zapping a SP to the caller.  The largest cleanup is to separate the
flows for zapping roots (zap _everything_), zapping leaf SPTEs (zap guest
mappings for whatever reason), and zapping a specific SP (NX recovery).
They're currently smushed into a single zap_gfn_range(), which was a good
idea at the time, but became a mess when trying to handle the different
rules, e.g. TLB flushes aren't needed when zapping a root because KVM can
safely zap a root if and only if it's unreachable.

For booting an 8 vCPU, remote_tlb_flush (requests) goes from roughly
180 (600) to 130 (215).

Please don't apply patches 02 and 03, they've been posted elsehwere and by
other people.  I included them here because some of the patches have
pseudo-dependencies on their changes.  Patch 01 is also posted separately.
I had a brain fart and sent it out realizing that doing so would lead to
oddities.

Hou Wenlong (1):
  KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()

Sean Christopherson (27):
  KVM: x86/mmu: Use yield-safe TDP MMU root iter in MMU notifier
    unmapping
  KVM: x86/mmu: Remove spurious TLB flushes in TDP MMU zap collapsible
    path
  KVM: x86/mmu: Retry page fault if root is invalidated by memslot
    update
  KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP
    MMU
  KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush
    logic
  KVM: x86/mmu: Document that zapping invalidated roots doesn't need to
    flush
  KVM: x86/mmu: Drop unused @kvm param from kvm_tdp_mmu_get_root()
  KVM: x86/mmu: Require mmu_lock be held for write in unyielding root
    iter
  KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU
    root
  KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP
    removal
  KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier
    change_spte
  KVM: x86/mmu: Drop RCU after processing each root in MMU notifier
    hooks
  KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
  KVM: x86/mmu: Take TDP MMU roots off list when invalidating all roots
  KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in non-atomic path
  KVM: x86/mmu: Terminate yield-friendly walk if invalid root observed
  KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw
    vals
  KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
  KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap
    hook
  KVM: x86/mmu: Add TDP MMU helper to zap a root
  KVM: x86/mmu: Skip remote TLB flush when zapping all of TDP MMU
  KVM: x86/mmu: Use "zap root" path for "slow" zap of all TDP MMU SPTEs
  KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
  KVM: x86/mmu: Require mmu_lock be held for write to zap TDP MMU range
  KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
  KVM: x86/mmu: Do remote TLB flush before dropping RCU in TDP MMU
    resched
  KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow
    pages

 arch/x86/kvm/mmu/mmu.c          |  74 +++--
 arch/x86/kvm/mmu/mmu_internal.h |   7 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |   3 +-
 arch/x86/kvm/mmu/tdp_iter.c     |   6 +-
 arch/x86/kvm/mmu/tdp_iter.h     |  15 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 526 +++++++++++++++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.h      |  48 +--
 7 files changed, 406 insertions(+), 273 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

