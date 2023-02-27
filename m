Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828246A3CA0
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbjB0I0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjB0IZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:25:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292031DBB1;
        Mon, 27 Feb 2023 00:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486261; x=1709022261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JDRTnO6DfbfhrWHZOZhRoRN3sYCmVHAzigG9XmEuHP4=;
  b=kziP0tWQoK0tnCANb0omX/YBtVviZN7MEAoYqECagA9LFu7411lEG6qs
   A+EXQQC4kRpZs2sJZWi5Lm3zglS0p8O3PbhDTmBxxy3ECJBMAnb6q2WM6
   sv6I4kD6B52B+jUJKihNqa/Mhn3azpd7L9ZgQe6ed4lmV5d52uYZ9tpFQ
   w825F7gX1M5KwNrCj3gh2Dmbdcm2YgLGZfqklSpT4/LrE/a5Sv1ruhtds
   d/wnMp+LfX+8Ksfgc/G7VKB3xRCoxYCoAkwcaU5Bz3nCTuP8vYTpXSsFd
   U3aAgh+0Mkd3XyfIxgeW4vT6XrK/WAohGV49PnNRbpeFBoqJtQu1bPAxe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608815"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608815"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242168"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242168"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 035/106] KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
Date:   Mon, 27 Feb 2023 00:22:34 -0800
Message-Id: <d3f292c79dac94f0a1a436c8b7cbef00ded646e8.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX support introduces private mapping, add a new member in union
kvm_mmu_page_role with access functions to check the member.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/spte.h         |  6 ++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 079503be0fb3..afe9285930b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -338,7 +338,12 @@ union kvm_mmu_page_role {
 		unsigned ad_disabled:1;
 		unsigned guest_mode:1;
 		unsigned passthrough:1;
+#ifdef CONFIG_KVM_MMU_PRIVATE
+		unsigned is_private:1;
+		unsigned :4;
+#else
 		unsigned :5;
+#endif
 
 		/*
 		 * This is left at the top of the word so that
@@ -350,6 +355,28 @@ union kvm_mmu_page_role {
 	};
 };
 
+#ifdef CONFIG_KVM_MMU_PRIVATE
+static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
+{
+	return !!role.is_private;
+}
+
+static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
+{
+	role->is_private = 1;
+}
+#else
+static inline bool kvm_mmu_page_role_is_private(union kvm_mmu_page_role role)
+{
+	return false;
+}
+
+static inline void kvm_mmu_page_role_set_private(union kvm_mmu_page_role *role)
+{
+	WARN_ON_ONCE(1);
+}
+#endif
+
 /*
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f6d81505d4ba..0111eed08c04 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -143,6 +143,11 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_private_sp(const struct kvm_mmu_page *sp)
+{
+	return kvm_mmu_page_role_is_private(sp->role);
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 256395eb593f..7046671b08cb 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -251,6 +251,12 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 	return to_shadow_page(__pa(sptep));
 }
 
+static inline bool is_private_sptep(u64 *sptep)
+{
+	WARN_ON_ONCE(!sptep);
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
-- 
2.25.1

