Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279D1558F26
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 05:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiFXDhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 23:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiFXDhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 23:37:18 -0400
Received: from out0-152.mail.aliyun.com (out0-152.mail.aliyun.com [140.205.0.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBCB53A6F
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 20:37:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.OBgNiwW_1656041821;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OBgNiwW_1656041821)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 11:37:02 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Subject: [PATCH 0/5] Fix wrong gfn range of tlb flushing with range
Date:   Fri, 24 Jun 2022 11:36:56 +0800
Message-Id: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
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
So this patchset would fix them and do some cleanups.

Hou Wenlong (5):
  KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
    validate_direct_spte()
  KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
    kvm_set_pte_rmapp()
  KVM: x86/mmu: Reduce gfn range of tlb flushing in
    tdp_mmu_map_handle_target_level()
  KVM: x86/mmu: Fix wrong start gfn of tlb flushing with range
  KVM: x86/mmu: Use 1 as the size of gfn range for tlb flushing in
    FNAME(invlpg)()

 arch/x86/kvm/mmu/mmu.c         | 15 +++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c     |  4 ++--
 3 files changed, 12 insertions(+), 9 deletions(-)

--
2.31.1

