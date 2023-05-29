Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300D97142D0
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjE2EYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjE2EYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:24:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772C3106;
        Sun, 28 May 2023 21:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334124; x=1716870124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rs9siQmGkWD0kkxvOvY78UQr/CfxLxFiWBJaWPdXnrI=;
  b=gFiNbuY87H3HvxnmAOj5wzne0o5hh8bFH6UOLTgparlY+YF018ge7P3J
   jCKZcyNXkz6osN9mKQCsXvOL86+kPtHWrcWwAY88HQNH6h7TOuqksaXUd
   LUNRvMHM2DQ3nHqAxSgwjgeNM/lrxslu9/i3LAxYBaCGQG5LGBr9tQH7j
   4CLEJplR19xdLbdA4PRYx6n9ydIM4V0mTularmq4iiHCFKyL+rDQN5cpO
   bRp8Yq8CPiuQ3k/jhajJgl+sGXr/sZSG3Whc4xR/E0xy+Z5xYVYd5fUaY
   oOBJPY/2iiZ8Ot9zqRUivh+H5Cjowhn/zgDCEpWhgFweeBjQSa/VIaJDL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334965927"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334965927"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784246"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784246"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:11 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v14 036/113] KVM: x86/mmu: Allow per-VM override of the TDP max page level
Date:   Sun, 28 May 2023 21:19:18 -0700
Message-Id: <6d4b28ba7039a703e77a41db1122272fddd08c45.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX requires special handling to support large private page.  For
simplicity, only support 4K page for TD guest for now.  Add per-VM maximum
page level support to support different maximum page sizes for TD guest and
conventional VMX guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 619ddba86e86..5f3cace6a85f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1232,6 +1232,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	int tdp_max_page_level;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8035e96cb687..544df394b085 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6315,6 +6315,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
+	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f1786698ae00..ab480e40055b 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -298,7 +298,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.max_level = vcpu->kvm->arch.tdp_max_page_level,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
-- 
2.25.1

