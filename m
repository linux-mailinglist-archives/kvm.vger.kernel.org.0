Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA44647A28
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiLHXgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiLHXgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:36:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6D26FF06;
        Thu,  8 Dec 2022 15:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542562; x=1702078562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6uMLGCJw4mzbJuuwI6vQO3aYEzwoK3zqbKOtUoipBg=;
  b=dKrl8SEB70NOzPikWx0wEjhhOR92vBKxlO0Q0KsEDUZ7BjeCg7g4zDUq
   LHCBM812YPRzlOS14LDRWzaataY3QKs1LrpxrKbZBl64ehTbR1hPbg0yJ
   +B507tFeRmUKcBiuGlQsbBKZTK0HIGpDPQ6cKmaaJ21bC7E7vSrMD/Ofa
   TDVrtG6KtYjWrSfBINGJuTT/2AhkkNDJlQ3jzgylp+pm40mOqbgteQfQx
   bF7WSd17gOZJ+Vme6XNttu390wDVLjdYcdDaiCn/7jDRLrxEJ/vVeiquO
   qLKZT7DDs741mvgEjGV4r6Rc0dJw8dEHe3lnuqBvIFFQacUKLEGYN/3Z+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586571"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586571"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677951044"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677951044"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:36:01 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 15/15] KVM: TDX: Allow 2MB large page for TD GUEST
Date:   Thu,  8 Dec 2022 15:35:50 -0800
Message-Id: <4533c730c0d853ac637596d71374f4573a4e91cd.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Now that everything is there to support 2MB page for TD guest.  Because TDX
module TDH.MEM.PAGE.AUG supports 4KB page and 2MB page, set struct
kvm_arch.tdp_max_page_level to 2MB page level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 arch/x86/kvm/vmx/tdx.c     | 4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 766795005a39..c133dda53e12 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1592,14 +1592,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte)) {
-			/*
-			 * TODO: large page support.
-			 * Doesn't support large page for TDX now
-			 */
-			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
+		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		} else
+		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f20e931cf983..1977a2a5b4c4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -481,8 +481,8 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm_mmu_set_mmio_spte_value(kvm, 0);
 
-	/* TODO: Enable 2mb and 1gb large page support. */
-	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+	/* TDH.MEM.PAGE.AUG supports up to 2MB page. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_2M;
 
 	kvm_tdx->hkid = -1;
 
-- 
2.25.1

