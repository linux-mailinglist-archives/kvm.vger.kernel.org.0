Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1358583747
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 05:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiG1DFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 23:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiG1DFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 23:05:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3276E50049
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 20:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658977536; x=1690513536;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fGubeBxIMQn2vH+ixpp4JkC9UaNq6lyfV5nZjmAXFSo=;
  b=lgF56OHHlUBIpnjPje1xbsvPwCB4tm2gT/FihC7+8nRokfJJCFpkoHYo
   dbUsk2XmXmfDMnGeRObaRGVk2KURIiDkzHAXiXMlxqMHD2CG6oit2hOfI
   ITyB4qVq7lSplsgbDQx9qXaZ0t8AYPrODQb1w96XSjWXA1EE6XOWT3RAn
   3+kV6qjz0ziPRtpIl6oAxrxb0VaauzodM0wiA39DrcTx3Tgmh8oNzDDCO
   9hdttdknGKQgMczyXAlrebwOYRlP2V1kk3cFK1wDQ9KhY9Km4j6nWoiNs
   MQMWAwSLqgBxEdybwvYTYENw2E+KZc9Vl8jpyMsc0fIp6jXg4Oc5KUduo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="374708387"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="374708387"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 20:05:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="600663818"
Received: from byeongky-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.170.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 20:05:34 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, bgardon@google.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3] KVM, x86/mmu: Fix the comment around kvm_tdp_mmu_zap_leafs()
Date:   Thu, 28 Jul 2022 15:04:52 +1200
Message-Id: <20220728030452.484261-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v2->v3:

 - s/leafs/leaf
 - Added Sean's Reviewed-by.

---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 40ccb5fba870..bf2ccf9debca 100644
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
+ * Zap leaf SPTEs for the range of gfns, [start, end), for all roots. Returns
+ * true if a TLB flush is needed before releasing the MMU lock, i.e. if one or
+ * more SPTEs were zapped since the MMU lock was last acquired.
  */
 bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 			   bool can_yield, bool flush)
-- 
2.36.1

