Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A015F9EA1
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiJJMUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 08:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiJJMT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 08:19:58 -0400
Received: from out0-138.mail.aliyun.com (out0-138.mail.aliyun.com [140.205.0.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6721ADBB
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 05:19:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047201;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---.PYDhJqN_1665404357;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PYDhJqN_1665404357)
          by smtp.aliyun-inc.com;
          Mon, 10 Oct 2022 20:19:17 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v4 0/6] KVM: x86/mmu: Fix wrong usages of range-based tlb flushing
Date:   Mon, 10 Oct 2022 20:19:11 +0800
Message-Id: <cover.1665214747.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c3134ce240eed ("KVM: Replace old tlb flush function with new one
to flush a specified range.") replaces old tlb flush function with
kvm_flush_remote_tlbs_with_address() to do tlb flushing. However, the
gfn range of tlb flushing is wrong in some cases. E.g., when a spte is
dropped, the start gfn of tlb flushing should be the gfn of spte not the
base gfn of SP which contains the spte. Although, as Paolo said, Hyper-V
may treat a 1-page flush the same if the address points to a huge page,
and no fixes are reported so far. So it seems that it works well for
Hyper-V. But it would be better to use the correct size for huge page.
So this patchset would fix them and introduce some helper functions as
David suggested to make the code clear.

Changed from v3:
- Move patch 1 after kvm_flush_remote_tlbs_sptep() is introduced,
  Drop kvm_flush_remote_tlbs_direct_sp() helper and use
  kvm_flush_remote_tlbs_sptep() instead.
- Wrap changelogs at ~75 chars.

Changed from v2:
- Introduce kvm_flush_remote_tlbs_gfn() in Patch 1 early.
- Move round_gfn_for_level() in tdp_iter.c into mmu_internal.h for
  common usage and cleanup the call sites of rounding down the GFN.
- Drop Patch 6.

Changed from v1:
- Align down gfn in kvm_set_pte_rmapp() instead of change iterator->gfn
  in rmap_walk_init_level() in Patch 2.
- Introduce some helper functions for common operations as David
  suggested.

v3: https://lore.kernel.org/kvm/cover.1663929851.git.houwenlong.hwl@antgroup.com

Hou Wenlong (6):
  KVM: x86/mmu: Move round_gfn_for_level() helper into mmu_internal.h
  KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
    kvm_set_pte_rmapp()
  KVM: x86/mmu: Reduce gfn range of tlb flushing in
    tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
  KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
    validate_direct_spte()
  KVM: x86/mmu: Cleanup range-based flushing for given page

 arch/x86/kvm/mmu/mmu.c          | 36 +++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h | 15 ++++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  |  5 ++---
 arch/x86/kvm/mmu/tdp_iter.c     | 11 +++-------
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++----
 5 files changed, 45 insertions(+), 28 deletions(-)

--
2.31.1

