Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF9F59CD62
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbiHWAqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbiHWAqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:46:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C164D153
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:43 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l190-20020a6388c7000000b00429eadd0a58so5401297pgd.19
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=+5ILiONNT2Raf8lvKVWoFP9Lx9r+QT/j1xkxXvfLAg4=;
        b=o+XzIuiX0mVrmTljlwxKQE5BPa7fWhxeXonBF2ujsHDIIkmrP/BArjGG8vKGXZzxHZ
         aGCyHZQGHV5fEhDCrdkCSs+rAYyXOsbuGhwIvEGUIpM+alq9pj57H5dboCmNEc09TK0z
         c6heO/8eSor/4/h1izel8Myn9DtJfj72/a/q7U1fFyl1Dno74zfJPMJQRSCl7AkmFpA2
         YVxX7c0VRywxlO0x4/jEhIDRhafho11s7qXBSJr3SCWVNdlEtnYGvZenzxKVAARYwX+f
         oi9flWWlqVqqz3XGywpOOfYXa3KiMvQtqdVJT3SmOpYgrc6NAr9neqgsbzx2bpt4Hix/
         1rNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=+5ILiONNT2Raf8lvKVWoFP9Lx9r+QT/j1xkxXvfLAg4=;
        b=m6ECFsRF/WCRPuy+/5hkxv2qGTbcXZj/Xp6Tj9Ub2M1l8UfC3RhhJizGM4k4a7BVD3
         +ayHVxXT4VdHHA7BFylPL3g5Db1d0dHSxzas+rIxHQya/RySm4osPs9K8ew2Oks2Zu6I
         ZjWcnvRnbbpl7opydFpxStlMoKnZ4rs5plQQXMfX2Yy47+IzEpdo2jEXtpKQy/6FV+1H
         b7iTiNOo1dTLhSpn56/fJO0JOTTMqSMnVPN9/zmqAxoYwAK9lQTLC61Vj1SYvVW6Fn2C
         pm0yOFRFXQc+z0RC26hg9HwNAKtZBq1koBa8ERk9GH43I1JQzXvOYBilsmxz9ybEodjE
         q2+Q==
X-Gm-Message-State: ACgBeo3mC0cMsCiaprzfjX/7epDhbF543ziPoaDLV9XA9YGJA3HSFEGr
        hsygu0KXa0I2cShhC23uuxV0MArhO/lMiC1H
X-Google-Smtp-Source: AA6agR7n4HaZkWJXrjZPxJF0LYP1shjmb62PXEmeLlBFj/2/BudXQckF9s5n2JZ4jSwiCza7N/CifAgyNs456d/H
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:4c8c:b0:1fa:c44f:473a with SMTP
 id my12-20020a17090b4c8c00b001fac44f473amr840678pjb.195.1661215603362; Mon,
 22 Aug 2022 17:46:43 -0700 (PDT)
Date:   Tue, 23 Aug 2022 00:46:35 +0000
Message-Id: <20220823004639.2387269-1-yosryahmed@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 0/4] KVM: mm: count KVM mmu usage in memory stats
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
Cc:     Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
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

Add NR_SECONDARY_PAGETABLE memory stat and use it to account KVM mmu
usage as the first type of accounted secondary page tables. This stat
can be later extended to account for other types of secondary pages
tables (e.g. iommu page tables).

Rationale behind why this is useful and link to extended discussion in
the first patch.

---

Changes in V7:
- Rebased on top of kvm/queue.
- Fixed doc spaces in proc.rst (Sean).
- Commit message s/kvm/KVM (Sean).
- Example of NR_SECONDARY_PAGETABLE s/KVM shadow pagetables/KVM pagetables
  (Sean).
- Added comment that kvm_account_pgtable_pages() is thread-safe (Sean).
- Collected Acks and Reviewed-by's from Sean and Marc (Thanks!).

Changes in V6:
- Rebased on top of kvm/queue and fixed conflicts.
- Fixed docs spaces and tabs (Sean).
- More narrative commit logs (Sean and Oliver).
- Updated kvm_account_pgtable_pages() documentation to describe the
  rules of using it more clearly (Sean).
- Collected Acks and Reviewed-by's by Shakeel and Oliver (Thanks!)

Changes in V5:
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
 arch/arm64/kvm/mmu.c                    | 36 ++++++++++++++++++++++---
 arch/x86/kvm/mmu/mmu.c                  | 16 +++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c              | 12 +++++++++
 drivers/base/node.c                     |  2 ++
 fs/proc/meminfo.c                       |  2 ++
 include/linux/kvm_host.h                | 13 +++++++++
 include/linux/mmzone.h                  |  1 +
 mm/memcontrol.c                         |  1 +
 mm/page_alloc.c                         |  6 ++++-
 mm/vmstat.c                             |  1 +
 12 files changed, 92 insertions(+), 7 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

