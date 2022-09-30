Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440DB5F088C
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiI3KU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiI3KTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94120166F04;
        Fri, 30 Sep 2022 03:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533143; x=1696069143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X+8KgY5TeqLFzYI/x6X9VtsO1xS9mi4pv83tPlKvJjE=;
  b=PnrZUJmq/oB0Pt8YfngUI7+aGtF2ELl9uHucGrP4GDzK4HM+qmkDkn8Y
   fjc4NGbG+6tZ++xduvnq6xwlxVghst9XAqslQT4vLEw9ZP78xE6dPojXO
   OyHDJshGhYl45DJ4LFAl70cPnRAx0ATxU97jx83d9U5CwwRIUln0uswbR
   C6tpJ5hLctuwcwaIhb/cjcd3JmpMPR/pH701fhQK8hOj7RznVm0PArv21
   hUDKE/jHM1KZsf8vk4W7xp9+1QbGBQSxu6K5HeAcwYHkJGo+PhmS0dCQ4
   3MvsswfNG31k2HhHqXMgl1gB+0F0n7NEQIqaOQ869iwuOmc9Cn0OLOkRy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870094"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870094"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807622"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807622"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v9 037/105] KVM: x86/mmu: Allow per-VM override of the TDP max page level
Date:   Fri, 30 Sep 2022 03:17:31 -0700
Message-Id: <b25e411050eaa24f5407244397533c867dfb390c.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 4d4794789c42..122e1baef012 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1150,6 +1150,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	int tdp_max_page_level;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2fd70876d346..97d575f787cc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6083,6 +6083,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
+	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b27d5ae01cd8..486d719ca2e1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -277,7 +277,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.max_level = vcpu->kvm->arch.tdp_max_page_level,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
-- 
2.25.1

