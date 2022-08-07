Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A6D58BDE7
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbiHGWcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242221AbiHGWbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3297D18362;
        Sun,  7 Aug 2022 15:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910731; x=1691446731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CC+oCHJCHlL6/p6anZ5hH11kfUqGKD9/J/qtkJCwbqE=;
  b=F2cVsO3mNoGfp5SZA9ucssD6/NYTc5U63IcUpGWCwMICiQhlvriUK1Wu
   cFQ+4lRzl4O4TZM6sfhtt/cImlf+eovs/hg/AAARjKQbspf/IEXUqFHl0
   gWTL5uvXoUOwRj0YLeTkwKNCCPkinwrswlHHnRV7VHEOpLcCmRsvG3RiF
   jvfWjwapYKGuqtb2gehLFAokjKSzH/dJKm4dEU/Zj19ciXdtO6lRNuEsu
   P0QyvxLy4aOX3zWd7QphXQs9iFN39bu3PAbqLF1viN1jk3Tz0I+9ClDmb
   +hD1hRu43g4RnaFJ3aQRHnXkFhvRo5VMGFdkbmt9GGgMxufYMo8QqufqV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852835"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852835"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642321"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 07/13] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date:   Sun,  7 Aug 2022 15:18:40 -0700
Message-Id: <f1999fbf083e6c3f86a2d9a634c0a1e30c9c70df.1659854957.git.isaku.yamahata@intel.com>
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

Allow large page level AUG and REMOVE for TDX pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 46 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0b9f9075e1ea..cdd421fb5024 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1458,20 +1458,18 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct tdx_module_output out;
 	hpa_t source_pa;
 	u64 err;
+	int i;
 
 	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) ||
 			 !kvm_pfn_to_refcounted_page(pfn)))
 		return;
 
 	/* To prevent page migration, do nothing on mmu notifier. */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (likely(is_td_finalized(kvm_tdx))) {
-		/* TODO: handle large pages. */
-		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-			return;
-
 		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
@@ -1530,38 +1528,40 @@ static void tdx_sept_drop_private_spte(
 	hpa_t hpa_with_hkid;
 	struct tdx_module_output out;
 	u64 err = 0;
+	int i;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return;
-
-	spin_lock(&kvm_tdx->seamcall_lock);
 	if (is_hkid_assigned(kvm_tdx)) {
+		spin_lock(&kvm_tdx->seamcall_lock);
 		err = tdh_mem_page_remove(kvm_tdx->tdr.pa, gpa, tdx_level, &out);
+		spin_unlock(&kvm_tdx->seamcall_lock);
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_REMOVE, err, &out);
-			goto unlock;
+			return;
 		}
 
-		hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
-		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
-		if (WARN_ON_ONCE(err)) {
-			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
-			goto unlock;
+		for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++) {
+			hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
+			spin_lock(&kvm_tdx->seamcall_lock);
+			err = tdh_phymem_page_wbinvd(hpa_with_hkid);
+			spin_unlock(&kvm_tdx->seamcall_lock);
+			if (WARN_ON_ONCE(err))
+				pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			else
+				tdx_unpin(kvm, gfn + i, pfn + i);
+			hpa += PAGE_SIZE;
 		}
-	} else
+	} else {
 		/*
 		 * The HKID assigned to this TD was already freed and cache
 		 * was already flushed. We don't have to flush again.
 		 */
+		spin_lock(&kvm_tdx->seamcall_lock);
 		err = tdx_reclaim_page((unsigned long)__va(hpa), hpa, level,
 				       false, 0);
-
-unlock:
-	spin_unlock(&kvm_tdx->seamcall_lock);
-
-	if (!err)
-		tdx_unpin_pfn(kvm, pfn);
+		spin_unlock(&kvm_tdx->seamcall_lock);
+		if (!err)
+			tdx_unpin(kvm, gfn, pfn);
+	}
 }
 
 static int tdx_sept_link_private_sp(struct kvm *kvm, gfn_t gfn,
-- 
2.25.1

