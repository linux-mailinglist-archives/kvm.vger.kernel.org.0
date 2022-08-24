Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50E759F632
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 11:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiHXJ3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 05:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbiHXJ32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 05:29:28 -0400
Received: from out0-157.mail.aliyun.com (out0-157.mail.aliyun.com [140.205.0.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498E184EEA
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 02:29:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047198;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.P-k32Bx_1661333363;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P-k32Bx_1661333363)
          by smtp.aliyun-inc.com;
          Wed, 24 Aug 2022 17:29:23 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     David Matlack <dmatlack@google.com>
Subject: [PATCH v2 0/6] KVM: x86/mmu: Fix wrong usages of range-based tlb flushing
Date:   Wed, 24 Aug 2022 17:29:17 +0800
Message-Id: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c3134ce240eed
("KVM: Replace old tlb flush function with new one to flush a specified range.")
replaces old tlb flush function with kvm_flush_remote_tlbs_with_address()
to do tlb flushing. However, the gfn range of tlb flushing is wrong in
some cases. E.g., when a spte is dropped, the start gfn of tlb flushing
should be the gfn of spte not the base gfn of SP which contains the spte.
Although, as Paolo said, Hyper-V may treat a 1-page flush the same if the
address points to a huge page, and no fixes are reported so far. So it seems
that it works well for Hyper-V. But it would be better to use the
correct size for huge page. So this patchset would fix them and introduce
some helper functions as David suggested to make the code clear.

Changed from v1:
- Align down gfn in kvm_set_pte_rmapp() instead of change iterator->gfn
  in rmap_walk_init_level() in Patch 2.
- Introduce some helper functions for common operations as David
  suggested.

v1: https://lore.kernel.org/kvm/cover.1656039275.git.houwenlong.hwl@antgroup.com

Hou Wenlong (6):
  KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
    validate_direct_spte()
  KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
    kvm_set_pte_rmapp()
  KVM: x86/mmu: Reduce gfn range of tlb flushing in
    tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
  KVM: x86/mmu: Introduce helper function to do range-based flushing for
    given page
  KVM: x86/mmu: Use 1 as the size of gfn range for tlb flushing in
    FNAME(invlpg)()

 arch/x86/kvm/mmu/mmu.c          | 35 +++++++++++++++++++++++----------
 arch/x86/kvm/mmu/mmu_internal.h | 10 ++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++----
 4 files changed, 39 insertions(+), 16 deletions(-)

--
2.31.1

