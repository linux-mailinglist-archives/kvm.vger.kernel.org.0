Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADF51C754
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355158AbiEESWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383262AbiEESTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE571A3A4;
        Thu,  5 May 2022 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774557; x=1683310557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4lquZTTZV+C6DaVeZCPZttfWMjtz7WKuO5kSC5oLrCc=;
  b=ncbbpo+iOMr9fnU4Pttlw7Kb3dZaXtZ7I6tJP1TnSvZvCSmxmLmDqjQC
   yoiKAPKx2LTWiYoHP/GNO/kc4A3lTjRpsmKLdmfOs066B6Y+0HMQXZ8iP
   8yamuRLJEpqBmlZRGYQEWp+SpD+6KF75lvmI2WvBLy86HfKfXJMa8ojP9
   zs8hSk0voyeit+kuWp16CHTlypGV629Nnbjt+3FauDrKK11U/5HbEEfDY
   jkl/am5mzZ7SH3UqyFRGG2VOVDluMFvhxoKqLLa/JJpDwNZVGn6n5jEkB
   rYXNDDjNvorvcc8WS1yAa1x4vRRDVu/8+idGQGeGPEDe4x+FBUfZrU5la
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742025"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742025"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083275"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:45 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 040/104] KVM: x86/mmu: Allow per-VM override of the TDP max page level
Date:   Thu,  5 May 2022 11:14:34 -0700
Message-Id: <83e129bcd111c4dec472c377c43926f338b80ac1.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

TODO: This is a transient workaround patch until the large page support for
TDX is implemented.  Support large page for TDX and remove this patch.

At this point, large page for TDX isn't supported, and need to allow guest
TD to work only with 4K pages.  On the other hand, conventional VMX VMs
should continue to work with large page.  Allow per-VM override of the TDP
max page level.

In the existing x86 KVM MMU code, there is already max_level member in
struct kvm_page_fault with KVM_MAX_HUGEPAGE_LEVEL initial value.  The KVM
page fault handler denies page size larger than max_level.

Add per-VM member to indicate the allowed maximum page size with
KVM_MAX_HUGEPAGE_LEVEL as default value and initialize max_level in struct
kvm_page_fault with it.  For the guest TD, the set per-VM value for allows
maximum page size to 4K page size.  Then only allowed page size is 4K.  It
means large page is disabled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu.h              | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c9c113316fd3..60223c21f16a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1063,6 +1063,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	int tdp_max_page_level;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index eecb5e27b6a5..a37b2efec4a8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -239,7 +239,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
 		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
 
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.max_level = vcpu->kvm->arch.tdp_max_page_level,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8b26729cb9c4..8a684a7b1883 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5865,6 +5865,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
 	kvm_mmu_set_mmio_spte_mask(kvm, shadow_default_mmio_mask,
 				   shadow_default_mmio_mask,
 				   ACC_WRITE_MASK | ACC_USER_MASK);
-- 
2.25.1

