Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DB8375A47
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhEFSnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbhEFSnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:43:45 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BDAC061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:42:46 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 69-20020aed304b0000b02901c6d87aed7fso4119670qte.21
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sOvqNeuGyU/ZMmaxdOA2l2pA74nfx+pU9gEcCSqkRJU=;
        b=uoosXHvihKGjquSMLz/CYZMZ4tR+g+wYMy+PQ0C6KeO5KYBM56Yk/c//Vb8khLCpLa
         YCHBvNfyl8fH5jv4BySXf883bxjZ+cUiwAKJ1zfGhX8PIIuFYLGMwj52jIzhvNJwbrdG
         ctX1VXEfR5WjkdhcV0c1eKg/C6Y6xKdg5LtFepfs9Lx49Y5kn3+C6LKUY85fNB9EBNUI
         tZejepMkiSxcVdz5z3kRvFkJ0MgkNm40VBAr7pwUVoWYY16zBkswnXhIKMmIsWItYJkX
         YakB7IEn+bKpzh6aLKFM1KSAejHXtfO3bkROa587oG0OexgaEENARbJzHsBf91VwKuP8
         sppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sOvqNeuGyU/ZMmaxdOA2l2pA74nfx+pU9gEcCSqkRJU=;
        b=rXcG3cFM27IiiZakOlDrgCOZIbNCv4nwrNAZduXma9Iy47i6LWvMTcXiLY6AGECgDf
         1KosnYMAg5YTfooodwctzhmcdCVvCT+AH/wZ5YFtLmt5cVmTXZFUL2i8HjBwU4pIzuNC
         +ob5RTWOCYxogqE8FYZ8k/3UhqwXnEn3R4PLCGnlMuKSBDfiBSoehwc6flVG7gDZ4HvV
         gP4qYbd3dutoQv7AD7Luoh9tx46fPCRsv7+Jsjc/Pj4IAESFQgiDs7cESKQgwk/iS9pq
         XWiPzLFuFkMb3f0JQbGwzvCh7fT9PnTD0tKWJHH84CpZHem2OOFkwo9Gve8PF6tpTTXN
         K5jg==
X-Gm-Message-State: AOAM5318BTIDr2dfKSDt2FH8hV9D95edP+kc2bCRS3Cm3ruvCoDj0AKT
        yAGfx/GsYNN/IFsLeFiuqtwbZOXq2gid
X-Google-Smtp-Source: ABdhPJwtioxMRraHZDM3/mQxHN62IsmMxoyEHNLt1azp+GP7XBXuMx1lN08IjxpvyrsToOHNvTb9HUS7kNjB
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:a05:6214:258d:: with SMTP id
 fq13mr6103004qvb.50.1620326565176; Thu, 06 May 2021 11:42:45 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:33 -0700
Message-Id: <20210506184241.618958-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 0/8] Lazily allocate memslot rmaps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables KVM to save memory when using the TDP MMU by waiting
to allocate memslot rmaps until they are needed. To do this, KVM tracks
whether or not a shadow root has been allocated. In order to get away
with not allocating the rmaps, KVM must also be sure to skip operations
which iterate over the rmaps. If the TDP MMU is in use and we have not
allocated a shadow root, these operations would essentially be op-ops
anyway. Skipping the rmap operations has a secondary benefit of avoiding
acquiring the MMU lock in write mode in many cases, substantially
reducing MMU lock contention.

This series was tested on an Intel Skylake machine. With the TDP MMU off
and on, this introduced no new failures on kvm-unit-tests or KVM selftests.

Changelog:
v2:
	Incorporated feedback from Paolo and Sean
	Replaced the memslot_assignment_lock with slots_arch_lock, which
	has a larger critical section.

v3:
	Removed shadow_mmu_active as suggested by Sean
	Removed everything except adding a return value to
	kvm_mmu_init_tdp_mmu from patch 1 of v2
	Added RCU protection and better memory ordering for installing the
	memslot rmaps as suggested by Paolo
	Reordered most of the patches

Ben Gardon (8):
  KVM: x86/mmu: Deduplicate rmap freeing
  KVM: x86/mmu: Factor out allocating memslot rmap
  KVM: mmu: Refactor memslot copy
  KVM: mmu: Add slots_arch_lock for memslot arch fields
  KVM: x86/mmu: Add a field to control memslot rmap allocation
  KVM: x86/mmu: Skip rmap operations if rmaps not allocated
  KVM: x86/mmu: Protect rmaps independently with SRCU
  KVM: x86/mmu: Lazily allocate memslot rmaps

 arch/x86/include/asm/kvm_host.h |   9 ++
 arch/x86/kvm/mmu/mmu.c          | 195 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              | 107 ++++++++++++++----
 include/linux/kvm_host.h        |   9 ++
 virt/kvm/kvm_main.c             |  54 +++++++--
 7 files changed, 275 insertions(+), 109 deletions(-)

-- 
2.31.1.607.g51e8a6a459-goog

