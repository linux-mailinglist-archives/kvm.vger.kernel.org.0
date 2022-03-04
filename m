Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E492C4CDF6A
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiCDUcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiCDUcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C03B1EE25F;
        Fri,  4 Mar 2022 12:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425888; x=1677961888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=chnZIe/+x3ImhR435lejLC/UcLc+ct7rVIglvt76Yfo=;
  b=G8rfl0w84hfIQzNW+0tr0sXs26qRQ7Srunk4d8RXjwgFJVX/wcIrqKlt
   cpVDvLGCVxck2LnDt9S0nhURztrgWk+uDjlSw0ITHCx5t96DaoVFsKL+6
   3bo6E9RmVZCmV3oKZDcwgmWQ0FCyJLG+LU8+sA6vr1uEEAdoxPDjvHGZr
   8ccY31AEl0vCrVMA5VNpyH0ADh2qfqbfOUxyOge9/yEJ2tCXK5/dOg37+
   hPXKNjzxAvLOqXDeFV+q5dZI032TPyt0AreyHvpt2cB/vmGq+FOBaZt+9
   taXdexFxVSd/rCtG8kgf8j6hQ7juzWUnUbyXL9S+ysDHpWZMoRq9oX77D
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624223"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624223"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:27 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344399"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:27 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 054/104] KVM: x86/tdp_mmu: Keep PRIVATE_PROHIBIT bit when zapping
Date:   Fri,  4 Mar 2022 11:49:10 -0800
Message-Id: <772b20e270b3451aea9714260f2c40ddcc4afe80.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

SPTE_PRIVATE_PROHIBIT specifies the share or private GPA is allowed or not.
It needs to be kept over zapping the EPT entry.  Currently the EPT entry is
initialized shadow_init_value unconditionally to clear
SPTE_PRIVATE_PROHIBIT bit.  To carry SPTE_PRIVATE_PROHIBIT bit, introduce a
helper function to get initial value for zapped entry with
SPTE_PRIVATE_PROHIBIT bit.  Replace shadow_init_value with it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1949f81027a0..6d750563824d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -610,6 +610,12 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return true;
 }
 
+static u64 shadow_init_spte(u64 old_spte)
+{
+	return shadow_init_value |
+		(is_private_prohibit_spte(old_spte) ? SPTE_PRIVATE_PROHIBIT : 0);
+}
+
 static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter)
 {
@@ -641,7 +647,8 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * shadow_init_value (which sets "suppress #VE" bit) so it
 	 * can be set when EPT table entries are zapped.
 	 */
-	WRITE_ONCE(*rcu_dereference(iter->sptep), shadow_init_value);
+	WRITE_ONCE(*rcu_dereference(iter->sptep),
+		shadow_init_spte(iter->old_spte));
 
 	return true;
 }
@@ -853,7 +860,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		if (!shared) {
 			/* see comments in tdp_mmu_zap_spte_atomic() */
-			tdp_mmu_set_spte(kvm, &iter, shadow_init_value);
+			tdp_mmu_set_spte(kvm, &iter,
+					shadow_init_spte(iter.old_spte));
 			flush = true;
 		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
@@ -1038,11 +1046,14 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		new_spte = make_mmio_spte(vcpu,
 				tdp_iter_gfn_unalias(vcpu->kvm, iter),
 				pte_access);
-	else
+	else {
 		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
 				tdp_iter_gfn_unalias(vcpu->kvm, iter),
 				fault->pfn, iter->old_spte, fault->prefetch,
 				true, fault->map_writable, &new_spte);
+		if (is_private_prohibit_spte(iter->old_spte))
+			new_spte |= SPTE_PRIVATE_PROHIBIT;
+	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1335,7 +1346,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	 * invariant that the PFN of a present * leaf SPTE can never change.
 	 * See __handle_changed_spte().
 	 */
-	tdp_mmu_set_spte(kvm, iter, shadow_init_value);
+	tdp_mmu_set_spte(kvm, iter, shadow_init_spte(iter->old_spte));
 
 	if (!pte_write(range->pte)) {
 		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-- 
2.25.1

