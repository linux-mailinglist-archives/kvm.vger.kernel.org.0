Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1176B6936
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCLR7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjCLR7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:59:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D526279BA;
        Sun, 12 Mar 2023 10:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643889; x=1710179889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HMgSkJA+9ASw/SmAdBJZhsNLvkOGOphaDTyKynR4Rr4=;
  b=Va8pH5MKigmYaJvrPhpFVPsOLjmaxGyYRdqtW9V91kGbbRJ9hHDwgDvc
   Fk7eW11rZp21gqgFc+XoPzNKy7U0QSjBItANYuuVoR/f/v4bj7dXDpMER
   wSZtlPJb9dYComjWq0vAs8XKe0QGdz7MRrnJF3tPtxcSmn6d+gAYWZ/3r
   CaRkI+XXs6ema3ugkTVxS/N15uagTBvIh4WTyTvXdo5mabW4gsxYF7vRo
   uXfvb+KoVcAD02xhw+wDAlwTkopzTYv/SUX7ojIM1Qa0i9CBnVY90DrnS
   EOySNDVGGVHgbOPJyHtqT1vH46/DXVV4zbPDFqZkJLDthoaMS1dSpAV0o
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659857"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659857"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596611"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596611"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 041/113] KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
Date:   Sun, 12 Mar 2023 10:56:05 -0700
Message-Id: <3dff87b6888a8da17e84d04b39264c7938f38c67.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index d441d281a6d6..38d9a972f78e 100644
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
index b4fcf3eb6bd6..6c6379d4dcf9 100644
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
index a8418fd8ae9e..41973fe6bc22 100644
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

