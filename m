Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929CE7320B5
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 22:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjFOUMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 16:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbjFOUMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 16:12:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DBC1715;
        Thu, 15 Jun 2023 13:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686859959; x=1718395959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pWaX7pZXuIDTaETtNDJUBd6sIkUSbiwO7+qg1weP6GA=;
  b=b95OkILWRhFGUbZWn+PyzpXv0erUNB/JwSZsLpyVLepwyjcPdlJsVFbo
   Qlwo5PiH04mJZ4DZGFjcdocY5kqwoV4QYp+tkhch/eY9idVRzlqn+3gvv
   l7ILPQjFyZOmD0x4+xxbj/CySkwCKRKtIifSen+nnm+H5lwgZlK5OaRZi
   NsUoe7icGwCI9Obzhric47nA8frxG+nJfyOr2jO20mSaeKVKynrXSWNL9
   9qwJAwg1LXWJJptAyY8W2bOWVp/mjvFxc0NGBHTqdkZBokj3ACu8YixQL
   Sl9n0peaj0TOKxUqtMVtL+gp/XFBKfuzA8bidM75joe5Oolx8ED8FAx1F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387611466"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="387611466"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="712576657"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="712576657"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 13:12:38 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH 4/6] KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
Date:   Thu, 15 Jun 2023 13:12:17 -0700
Message-Id: <02471a0e41717e40f415a96a2acbd80ba9d42e2e.1686858861.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1686858861.git.isaku.yamahata@intel.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

It is unfortunate and inflexible for kvm_mmu_do_page_fault() to call
kvm_mem_is_private(), eventually looking up memory attributes.  Later
__kvm_faultin_pfn() looks up memory attributes again.  There is a race
condition that other threads can change memory attributes due to not
gaining the mmu lock.  SNP-SEV and TDX define theri way to indicate that
the page fault is private.

Add two PFERR codes to designate that the page fault is private and that
it requires looking up memory attributes.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 arch/x86/kvm/mmu/mmu.c          | 9 +++++++--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8ae131dc645d..2763f9837a0b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -255,7 +255,9 @@ enum x86_intercept_stage;
 #define PFERR_SGX_BIT 15
 #define PFERR_GUEST_FINAL_BIT 32
 #define PFERR_GUEST_PAGE_BIT 33
+#define PFERR_GUEST_ENC_BIT 34
 #define PFERR_IMPLICIT_ACCESS_BIT 48
+#define PFERR_HASATTR_BIT 63
 
 #define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
 #define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
@@ -266,7 +268,9 @@ enum x86_intercept_stage;
 #define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
 #define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
 #define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
+#define PFERR_GUEST_ENC_MASK	BIT_ULL(PFERR_GUEST_ENC_BIT)
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
+#define PFERR_HASATTR_MASK	BIT_ULL(PFERR_HASATTR_BIT)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b8ba7f11c3cb..e9c9780bab89 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4358,6 +4358,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
+	bool is_private;
 
 	/*
 	 * Retry the page fault if the gfn hit a memslot that is being deleted
@@ -4386,8 +4387,12 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn))
-		return kvm_do_memory_fault_exit(vcpu, fault);
+	is_private = kvm_mem_is_private(vcpu->kvm, fault->gfn);
+	if (fault->error_code & PFERR_HASATTR_MASK) {
+		if (fault->is_private != is_private)
+			return kvm_do_memory_fault_exit(vcpu, fault);
+	} else
+		fault->is_private = is_private;
 
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f9ec1e5b136..22f2cd60cabf 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -203,7 +203,7 @@ struct kvm_page_fault {
 
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
-	const bool is_private;
+	bool is_private;
 	const bool nx_huge_page_workaround_enabled;
 
 	/*
@@ -301,7 +301,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = err & PFERR_GUEST_ENC_MASK,
 	};
 	int r;
 
-- 
2.25.1

