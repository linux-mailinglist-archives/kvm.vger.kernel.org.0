Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57F8667B7F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbjALQnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240199AbjALQid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:33 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D3D1BEA3;
        Thu, 12 Jan 2023 08:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541243; x=1705077243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xLEJWQLYzY+JO7Q0MkVG9KzB+lHqhL0n1uYJldM9dOU=;
  b=DkIUr6kSbZY63AWrPM/4nTStVBjN8rJ3pSLqZ/Y08uqydnMFO8btHWgl
   u+mTZvC4qxTctWU/H48IeH76xpdDFS/MYkEPZp7dbN4FFhFDpF8NHZ1tj
   qOHeq/05dNIbpY/G3tJ7IZE9wLqm5YkuLg3Eg5UfVV8Nj1GjcRkrfoI6y
   g1+dQzIRy3kHhu8yRQ3YyI3L5N+XEBQ9h5hb7Ifeo6HIsxgTawxz/2Y/j
   XQeSfN9UNGjD0fSKDR2S35cUnEJqx8zgbsE55WPfdZ6xl0VKnKfg7Gq3h
   Q8/tR0oEBXVXRvVLSUsmWJrDusJErr7b7cxZIybn4OxrZoXJuye0UmS8P
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811870"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811870"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151791"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151791"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:27 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 045/113] KVM: x86/mmu: Make make_spte() aware of shared GPA for MTRR
Date:   Thu, 12 Jan 2023 08:31:53 -0800
Message-Id: <5d9a6b899ea9a25a1192efd0ef5e43ecb1a0f250.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

For TDX MTRR support of shared GPA, get_mt_mask() method needs to know if
the given gfn is shared or private.  Make make_spte() aware of shared GPA
and rename gfn of make_spte() to gfn_including_shared to make it explicit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.c | 5 +++--
 arch/x86/kvm/mmu/spte.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index a23e9205fc42..7171df3e262a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -136,13 +136,14 @@ bool spte_has_volatile_bits(u64 spte)
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       unsigned int pte_access, gfn_t gfn_including_shared, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
+	gfn_t gfn = gfn_including_shared & ~kvm_gfn_shared_mask(vcpu->kvm);
 
 	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
 
@@ -190,7 +191,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= PT_PAGE_SIZE_MASK;
 
 	if (shadow_memtype_mask)
-		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
+		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn_including_shared,
 							 kvm_is_mmio_pfn(pfn));
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 7046671b08cb..067ea1ae3a13 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -481,7 +481,7 @@ bool spte_has_volatile_bits(u64 spte);
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       unsigned int pte_access, gfn_t gfn_including_shared, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
 u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte,
-- 
2.25.1

