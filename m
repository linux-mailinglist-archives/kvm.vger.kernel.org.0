Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4C58BDE2
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiHGWcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242290AbiHGWbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAA91836E;
        Sun,  7 Aug 2022 15:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910732; x=1691446732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vpSLndbfs6RqeobMkXPOe0+TrlAhD95ZYYobrsGmqRk=;
  b=gn8LeKaOUkE35m8TWsHu8qzlPVV0wTswctvdWp6KiB5FBonCZs/YOSve
   TzsKPBauYKqi5JnwL8Qkuj+nQR3S5SPUt3ieqcKVIcdQRWzFLzsYrefDn
   TmqxTwg0newHLHfYE5q5eRwxhoAzFt3af7ncpWODibqaGVXpKflpIRDMQ
   AxEVeucARptk38FZBeTxs/Pmmt+SyBH5GmNbsjLSHuNhdkDCVI32nPULm
   PrY0WYvp+6l2hZ1kpNEGfg+VNEffAqklGl034eljytNXG6aZvKVHih6aB
   Na/kgwRe7STn/BNB1I+VpdDjy7VJNxkunJUYwv3otA4AKy3dIqC3x+aVy
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852841"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642339"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 11/13] KVM: TDP_MMU: Split the large page when zap leaf
Date:   Sun,  7 Aug 2022 15:18:44 -0700
Message-Id: <c72d561d715bebdc4f402291dbd610e5a737567a.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854957.git.isaku.yamahata@intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

When TDX enabled, a large page cannot be zapped if it contains mixed
pages. In this case, it has to split the large page.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index faf278e0c740..e5d31242677a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1033,6 +1033,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return true;
 }
 
+
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       bool shared);
+
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
+
 /*
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -1075,6 +1083,24 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (kvm_gfn_shared_mask(kvm) && is_large_pte(iter.old_spte)) {
+			gfn_t gfn = iter.gfn & ~kvm_gfn_shared_mask(kvm);
+			gfn_t mask = KVM_PAGES_PER_HPAGE(iter.level) - 1;
+			struct kvm_memory_slot *slot;
+			struct kvm_mmu_page *sp;
+
+			slot = gfn_to_memslot(kvm, gfn);
+			if (kvm_mem_attr_is_mixed(slot, gfn, iter.level) ||
+			    (gfn & mask) < start ||
+			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
+				sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, false);
+				WARN_ON(!sp);
+
+				tdp_mmu_split_huge_page(kvm, &iter, sp, false);
+				continue;
+			}
+		}
+
 		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
@@ -1642,8 +1668,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
 	WARN_ON(kvm_mmu_page_role_is_private(role) !=
 		is_private_sptep(iter->sptep));
-	/* TODO: Large page isn't supported for private SPTE yet. */
-	WARN_ON(kvm_mmu_page_role_is_private(role));
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
-- 
2.25.1

