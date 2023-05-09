Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1666FC899
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbjEIOO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbjEIOO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:14:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E14E30E9;
        Tue,  9 May 2023 07:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683641665; x=1715177665;
  h=from:to:cc:subject:date:message-id;
  bh=iVlDQQpz9DCvQbjZv8eKsfsBkjZ19iJ/3jfnKsCHqwc=;
  b=SzwrZoKJ23uaJ4k422J8HQyuvE2VzGQD3czsryIwVLeQUEgz9CvqKbFU
   FYpxxNans3a/W4uGEqB5cYO+AKLDBqSITXVYmcYiiD0VjSFFTV+K3neiT
   v/g2/qyg/XGtL+17IQNU/lkzoa+BS4DRBKq4bbpXALpHqsw7smw0aZmL0
   Fu3skGl92z3hKv1x5exGR+uUcR6Lh2OKvpWO8OdA148pifKuYjzR675uP
   6ldLltBqFyISsEtZdag+CViegB8iYeHN4wTOBWA/8SlpMS+tAem6KkYW+
   +RjoAG+1BXmAf6m3G/e26WYUSruiBx5fQEE5QfLyfZLDTAx3fj9Vhmb9X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347399454"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="347399454"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:13:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="649345967"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="649345967"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:13:39 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 0/6] KVM: x86/mmu: refine memtype related mmu zap
Date:   Tue,  9 May 2023 21:48:25 +0800
Message-Id: <20230509134825.1523-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series refines mmu zap caused by EPT memory type update.

The first 3 patches will only do mmu zap when the target is to update
memory type of EPT entries by introducing a help in patch 1 to skip
non-EPT cases.

The 4th patch will trigger zapping of EPT leaf entries if non-coherent
DMA devices count goes from 0 to 1 or from 1 to 0.

The 5th-6th patches reduces EPT zap count by introducing a per-VM based
guest MTRR and only zap EPT entries when this per-VM based guest MTRR
changes.

Changelog:
v1 --> v2:
1. Added a helper to skip non EPT case in patch 1
2. Added patch 2 to skip mmu zap when guest CR0_CD changes if EPT is not
   enabled. (Chao Gao)
3. Added patch 3 to skip mmu zap when guest MTRR changes if EPT is not
   enabled.
4. Do not mention TDX in patch 4 as the code is not merged yet (Chao Gao)
5. Added patches 5-6 to reduce EPT zap during guest bootup.

v1:
https://lore.kernel.org/all/20230508034700.7686-1-yan.y.zhao@intel.com/

Yan Zhao (6):
  KVM: x86/mmu: add a new mmu zap helper to indicate memtype changes
  KVM: x86/mmu: only zap EPT when guest CR0_CD changes
  KVM: x86/mmu: only zap EPT when guest MTRR changes
  KVM: x86/mmu: Zap all EPT leaf entries according noncoherent DMA count
  KVM: x86: Keep a per-VM MTRR state
  KVM: x86/mmu: use per-VM based MTRR for EPT

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu.h              |   1 +
 arch/x86/kvm/mmu/mmu.c          |  18 ++++-
 arch/x86/kvm/mtrr.c             | 112 +++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c          |   2 +-
 arch/x86/kvm/x86.c              |  10 ++-
 arch/x86/kvm/x86.h              |   6 +-
 7 files changed, 122 insertions(+), 30 deletions(-)


base-commit: 5c291b93e5d665380dbecc6944973583f9565ee5
-- 
2.17.1

