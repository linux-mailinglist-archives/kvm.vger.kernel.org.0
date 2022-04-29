Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4C1515538
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 22:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380582AbiD2UPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 16:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380567AbiD2UPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 16:15:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15DB3BBEB
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 13:11:45 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g5-20020a62e305000000b0050d2dba0c5dso4643057pfh.8
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 13:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=an+yRArve5ZrSQoHDO73aNF7aPP+aWpAaWAPrlB9pIk=;
        b=rVCOmuzI6Jkg0VCtxq3Vv4tNhvcYa/7dy0aktfX+JU+3ABY/r1NuUYg6gNufzdzZyl
         TDx1/jOeHCUYV9kesQSDCM7gJuIkuCPZ3CI4xBiGyBYzao4KJxWyjV/wpOnUty7d2gkO
         xxgzezsPH49IA+C2wqMwqPUxHg+sr/u2pJ62e25BKh1gnBlY4tBxVuP6uCBRMMN8Bn0A
         o1aa0m514YE3U+J37NsZZ2A48FIIXDI4WlykXmRNEDZ9x5sTM9dO2kFgrvtI4EV9z//v
         PwFQ3hahtu5wgS2IyOj4qxw1dMwLZ0jJ58K/MjgmBn8W0hkXkDKsnnvkTtmina/ADpu8
         G4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=an+yRArve5ZrSQoHDO73aNF7aPP+aWpAaWAPrlB9pIk=;
        b=XOqkHZnGwhpVKMe3PCIbToI0qqkcMC2/6RxYICj39NlLX9MI2J0IUKSXP6ihgmv7Ow
         XFrV9XuV17oftra0PN2UNnl3/wBiquxAfGCxkd7nFgt+R5hJ7uqv0UpaO9k4HmzivyG/
         Hy/OtyuBW07d9CdOe4v+enYgASeQ8qzVP4yknqH33c7g3tBzNJebb6U8xEHVbCGA3Rei
         lijnUZZnisVJ2Qlf2yUZin88yQAITK1zFJQ8NClZj1wh6ufvhfp6n3+9fUW/TiSa+TIN
         6G+riayuaC37qyYbS2QtVWbNr6WbCusoKs47/FEtXeuzbAkGRIjH1JBI1uNuuHXJhqa7
         0HQw==
X-Gm-Message-State: AOAM532O2ahOKVI0csKMCkOiAcPRI/l++ckG1396ZNlCjLQ9mfP5Wqpv
        kQ6VpeTWczWOMAr845dPvyB0WhRLb+iljuuc
X-Google-Smtp-Source: ABdhPJxGZ1WYv4PcG6KKKG7/eOxb6RjoyzIw3GgB/7NGUVZUE3/7d2UGeWsMnv6NDpe3G1grI1WrkTwZdxjSyZ2c
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP
 id t16-20020a17090ae51000b001d9ee239fa1mr438392pjy.0.1651263104394; Fri, 29
 Apr 2022 13:11:44 -0700 (PDT)
Date:   Fri, 29 Apr 2022 20:11:27 +0000
Message-Id: <20220429201131.3397875-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 0/4] KVM: mm: count KVM mmu usage in memory stats
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
NR_SECONDARY_PAGETABLE stat.

---

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
  KVM: mmu: add a helper to account memory used by KVM mmu.
  KVM: x86/mmu: count KVM mmu usage in secondary pagetable stats.
  KVM: arm64/mmu: count KVM s2 mmu usage in secondary pagetable stats

 Documentation/admin-guide/cgroup-v2.rst |  5 ++++
 Documentation/filesystems/proc.rst      |  4 +++
 arch/arm64/kvm/mmu.c                    | 35 ++++++++++++++++++++++---
 arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c              | 16 +++++++++--
 drivers/base/node.c                     |  2 ++
 fs/proc/meminfo.c                       |  2 ++
 include/linux/kvm_host.h                |  9 +++++++
 include/linux/mmzone.h                  |  1 +
 mm/memcontrol.c                         |  1 +
 mm/page_alloc.c                         |  6 ++++-
 mm/vmstat.c                             |  1 +
 12 files changed, 89 insertions(+), 9 deletions(-)

-- 
2.36.0.464.gb9c8b46e94-goog

