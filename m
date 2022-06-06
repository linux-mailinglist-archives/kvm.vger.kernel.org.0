Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B537D53F210
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 00:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiFFWVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 18:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiFFWVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 18:21:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41F66D871
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 15:21:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l7-20020a170903244700b001675991fb6aso4096922pls.6
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 15:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IJS83ZKmvay92IEqxRhRKAGkk5kusGJyLJThB250L6U=;
        b=OBqMy3wK2eu42u4CbtznTgnyseS6gsaJLr5FDK08zli4P+8VmL18aLuhw+bSnMdM7k
         iFz03jncbwfAA7r/AGTwPC55fSnuiaen+bze1yfaaUyFA+CNkxQfCc05giglU0XkUEVo
         t0wTaD5v0fh6UuTsvLua6zwa4GLFp9MUBqwGr5TCmjvLaGNwvrJnSC+2h7QKCddI9v2O
         1AvKbLWw/YHC21qUQMpix/9u1/qvIqsCc78g0RrjeITNLQzJr0ZmEpnbP1xHYGLnKYVq
         HF3gC2h07Gg4ZKzkzeDiB+DLw++z+7xHgEUcgkjKGWNrPJUIIGcun4GT14NaNl+uGKgC
         0Sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IJS83ZKmvay92IEqxRhRKAGkk5kusGJyLJThB250L6U=;
        b=qz8K/jOU0LRACF61I+0EejkQGfkAp9zDHpo3PurlS1H8p1F+ZiOq5d1fwAM7ZAcJMt
         X2urdlw0/kyE8dh/Ejr0KQnuVongNYNsAE9jJxrNOlmUw8XrNhOlwZ12HYpDNKZV0YUJ
         xZtLYTbb/KKSdBrWNOsSyxQP+SrjjQLIp2Dc3NUFL7SnSSLq9JqPo3ap+1zE19M/RTyC
         zy+1X5NXtbGu/2ftzczIyYZVo1U76c+H5/FsyupmuZhaaletZHvQZ8/3T402QLIpGXer
         MQLJBdETqT/4Xb5eSWLG2HgxAylbhwjxQPLVIjO52KVwckAbdTctITghpeJpg730QBQJ
         hm7Q==
X-Gm-Message-State: AOAM531oRqjyKNZEBAwUz7IQtNYRov56Hc/wOti2fmRH/8HGkH3FDRWR
        UlViFrlOGfSct4o0PhjI9OD1MpIOQTolHwE/
X-Google-Smtp-Source: ABdhPJx1wdZontdtDHAURSxbRB7De+X97i6gu5k06GDDv+Ku0jwJHaJ3ZGwcu97YUcHYEb+wa/3Y2TiM5NS+scjm
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:d584:b0:167:6ab9:b094 with SMTP
 id k4-20020a170902d58400b001676ab9b094mr12694803plh.16.1654554067166; Mon, 06
 Jun 2022 15:21:07 -0700 (PDT)
Date:   Mon,  6 Jun 2022 22:20:54 +0000
Message-Id: <20220606222058.86688-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 0/4] KVM: mm: count KVM mmu usage in memory stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
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

We keep track of several kernel memory stats (total kernel memory, page
tables, stack, vmalloc, etc) on multiple levels (global, per-node,
per-memcg, etc). These stats give insights to users to how much memory
is used by the kernel and for what purposes.

Currently, memory used by kvm mmu is not accounted in any of those
kernel memory stats. This patch series accounts the memory pages
used by KVM for page tables in those stats in a new
NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
for other types of secondary pages tables (e.g. iommu page tables).

KVM has a decent number of large allocations that aren't for page
tables, but for most of them, the number/size of those allocations
scales linearly with either the number of vCPUs or the amount of memory
assigned to the VM. KVM's secondary page table allocations do not scale
linearly, especially when nested virtualization is in use.

From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
per-VM pages_{4k,2m,1g} stats unless the guest is doing something
bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
forced to allocate a large number of page tables even though the guest
isn't accessing that much memory). However, someone would need to either
understand how KVM works to make that connection, or know (or be told) to
go look at KVM's stats if they're running VMs to better decipher the stats.

Also, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE is
informative. For example, when backing a VM with THP vs. HugeTLB,
NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
of magnitude higher with THP. So having this stat will at the very least
prove to be useful for understanding tradeoffs between VM backing types,
and likely even steer folks towards potential optimizations.

---

Chnages in V5:
- Updated cover letter to explain more the rationale behind the change
  (Thanks to contributions by Sean Christopherson).
- Removed extraneous + in arm64 patch (Oliver Upton, Marc Zyngier).
- Shortened secondary_pagetables to sec_pagetables (Shakeel Butt).
- Removed dependency on other patchsets (applies to queue branch).

Changes in V4:
- Changed accounting hooks in arm64 to only account s2 page tables and
  refactored them to a much cleaner form, based on recommendations from
  Oliver Upton and Marc Zyngier.
- Dropped patches for mips and riscv. I am not interested in those archs
  anyway and don't have the resources to test them. I posted them for
  completeness but it doesn't seem like anyone was interested.

Changes in V3:
- Added NR_SECONDARY_PAGETABLE instead of piggybacking on NR_PAGETABLE
  stats.

Changes in V2:
- Added accounting stats for other archs than x86.
- Changed locations in the code where x86 KVM page table stats were
  accounted based on suggestions from Sean Christopherson.

---

Yosry Ahmed (4):
  mm: add NR_SECONDARY_PAGETABLE to count secondary page table uses.
  KVM: mmu: add a helper to account memory used by KVM MMU.
  KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
  KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats

 Documentation/admin-guide/cgroup-v2.rst |  5 ++++
 Documentation/filesystems/proc.rst      |  4 +++
 arch/arm64/kvm/mmu.c                    | 35 ++++++++++++++++++++++---
 arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c              | 12 +++++++++
 drivers/base/node.c                     |  2 ++
 fs/proc/meminfo.c                       |  2 ++
 include/linux/kvm_host.h                |  9 +++++++
 include/linux/mmzone.h                  |  1 +
 mm/memcontrol.c                         |  1 +
 mm/page_alloc.c                         |  6 ++++-
 mm/vmstat.c                             |  1 +
 12 files changed, 87 insertions(+), 7 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

