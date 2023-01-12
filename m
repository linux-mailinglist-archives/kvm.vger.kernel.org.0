Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81E667B69
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbjALQmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbjALQiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:11 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74DF192B2;
        Thu, 12 Jan 2023 08:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541241; x=1705077241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7AYt+ti6N5nDJ5ZMj6hfChIbH8ruv4Q5NaBbk/wsw8c=;
  b=TTU+8WrD7hh+q064Ey5OZiLDktLegZtL7Ldb+EUOmQ/2QjNmT5WjvR7u
   9QKpHhjRxv6hS3mj4Q7+KzmJDApDpxQv2p6KZS3jesHjXLBE6zBfQfiiJ
   LZOrXa7ZVgbe1DlOC4MAPlrzeolx0C3q1f9/z/58zB2RvdC6p/ZfA+W9H
   lcfJHloGP5/sa25/w6TZML94a9YloSGr7DgYTJBNUxZzEkAtCAtMCjqBV
   0Sf+40BdZ7vOU+3S16rU5bveBTjcLZdE8ybtghboBB6RFMXs1gVTcZxpq
   xI9bPFJMpW/uYvf/J1hjIyCOFc1dTaIOymXFmMKWzOgEsGlrQVz45Cmcb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811820"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811820"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151748"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151748"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:25 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 035/113] KVM: x86/mmu: Allow per-VM override of the TDP max page level
Date:   Thu, 12 Jan 2023 08:31:43 -0800
Message-Id: <c0e874de58d172d490a565a9ec7b3361bcc74907.1673539699.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX requires special handling to support large private page.  For
simplicity, only support 4K page for TD guest for now.  Add per-VM maximum
page level support to support different maximum page sizes for TD guest and
conventional VMX guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 807da4b95aba..f5b51bdef0c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1217,6 +1217,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	int tdp_max_page_level;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5b111a325434..801ef6c41847 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6141,6 +6141,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
+	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5ccf08183b00..6767bc9b7c5c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -276,7 +276,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.max_level = vcpu->kvm->arch.tdp_max_page_level,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
-- 
2.25.1

