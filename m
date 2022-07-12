Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01775710A8
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 05:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiGLDI6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 23:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGLDI4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 23:08:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039C2E088
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 20:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657595335; x=1689131335;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Gs47P2Js8NLzZNS5P9Eb4UGsBPUEfvUNz3MkIxZjftE=;
  b=R+a9l1m88uRQl4bzJW5lFsgvPwK9rBYAhsS16aIwwuRShvi+1phZ45h4
   e/Ud8PfDsl2IcifMoLNiXAB2BLFCcjzwTLRWESYv1kZlAmhRFHSS385v0
   bAJs3eX5SAttjo4/j0Mo9HHnvNwuKEXVJ4LEaFAK6FsGvuX4rEgZ3isZ/
   RyuUszhvIQ23e2Gwn8ExrcbZw8H+34xaCJWZ+M1++1Axw39BBC0qp0cmA
   lKPE1JeWkRqedXPhCiGN/liBeR/ZyfbawsgpQ7kFT3NF58qUdwEy8+96I
   cHUq6JCe33MwJ58R7EG2wYaQCnj/aqZEbvbYI9Nxh1D+RgrfUTDVAjV22
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="285567273"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="285567273"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 20:08:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="622335175"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 20:08:53 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, bgardon@google.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM, x86/mmu: Fix the comment around kvm_tdp_mmu_zap_leafs()
Date:   Tue, 12 Jul 2022 15:08:35 +1200
Message-Id: <20220712030835.286052-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now kvm_tdp_mmu_zap_leafs() only zaps leaf SPTEs but not any non-root
pages within that GFN range anymore, so the comment isn't right.

Fixes: f47e5bbbc92f ("KVM: x86/mmu: Zap only TDP MMU leafs in zap range and mmu_notifier unmap")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f3a430d64975..7692e6273462 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -969,10 +969,9 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 
 /*
- * Tears down the mappings for the range of gfns, [start, end), and frees the
- * non-root pages mapping GFNs strictly within that range. Returns true if
- * SPTEs have been cleared and a TLB flush is needed before releasing the
- * MMU lock.
+ * Zap leafs SPTEs for the range of gfns, [start, end) for all roots. Returns
+ * true if SPTEs have been cleared and a TLB flush is needed before releasing
+ * the MMU lock.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 			   bool can_yield, bool flush)
-- 
2.36.1

