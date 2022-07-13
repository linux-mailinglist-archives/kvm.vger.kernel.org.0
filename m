Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A57F572A58
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 02:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiGMApH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 20:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiGMApG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 20:45:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D676AD858
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 17:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657673105; x=1689209105;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=v+xwxL4dpglpiwmCrzVpGAj/8ZQ6Z4WrdjDHCFA0Gfs=;
  b=XuRtNz1tay7kX6wnU5/T/lj6Riu5gTc0qi+071Dxt2nZMt4y4BTO9ban
   JtcQ+U6ERqefR/nA7U9u/eUov0wfkWJsiYXWZax9A36Rw7SOBvvwYVYzW
   whmk6IFwbEEoFX94dTy8guFtrqss+e3RUsoVRdMuOqIa8ER6Hrzy3ytsv
   UdMqxVMCqVMiuxT2Y2M+niTzeOCISVtKxhk9/Eps15EGexxF/vuAbMrUR
   vP3rEdgWov3P09HS9vQRFU8UcJJQbNj72mn1hAMrN820fx9gpbQucqDo9
   ByTGLYfl4v/f355i2bYNN+K20AI3JIHlnrDJblN8VQA+mTkaZI3lmxfJG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="264864197"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="264864197"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:45:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="737678871"
Received: from ifatima-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.1.196])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 17:45:03 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, bgardon@google.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2] KVM, x86/mmu: Fix the comment around kvm_tdp_mmu_zap_leafs()
Date:   Wed, 13 Jul 2022 12:44:52 +1200
Message-Id: <20220713004452.7631-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
pages within that GFN range anymore, so the comment around it isn't
right.

Fix it by shifting the comment from tdp_mmu_zap_leafs() instead of
duplicating it, as tdp_mmu_zap_leafs() is static and is only called by
kvm_tdp_mmu_zap_leafs().

Opportunistically tweak the blurb about SPTEs being cleared to (a) say
"zapped" instead of "cleared" because "cleared" will be wrong if/when
KVM allows a non-zero value for non-present SPTE (i.e. for Intel TDX),
and (b) to clarify that a flush is needed if and only if a SPTE has been
zapped since MMU lock was last acquired.

Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f3a430d64975..58b34f7cd0f5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -924,9 +924,6 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 /*
- * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
- * have been cleared and a TLB flush is needed before releasing the MMU lock.
- *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
  * function cannot yield, it will not release the MMU lock or reschedule and
@@ -969,10 +966,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Tears down the mappings for the range of gfns, [start, end), and frees the
- * non-root pages mapping GFNs strictly within that range. Returns true if
- * SPTEs have been cleared and a TLB flush is needed before releasing the
- * MMU lock.
+ * Zap leafs SPTEs for the range of gfns, [start, end), for all roots. Returns
+ * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
+ * more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 			   bool can_yield, bool flush)
-- 
2.36.1

