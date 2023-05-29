Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAAB7142DC
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjE2EZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjE2EZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6C319A7;
        Sun, 28 May 2023 21:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334165; x=1716870165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9G9wAoyvooIHjRdJA2jPZy8BecY0++h8s+r9jdvUDeU=;
  b=g4U44pa7LwZ/sXNdlpfrX+IlxGtOVJW9TIZWvGMEbFzUs4gho5vuV24w
   lZDDCTIubeJBa7k1nF2zsj+2j5Y1Cjts8WsW2ArCY2M7Y/o6h/xk1PhHz
   eo3qi79R0ZoU7N9zIrj0ooEmfYQ7dT2ttp+sdDuBXQPUde4jz7UooBTRB
   4h4ArHm2xcLe8WTbEYh8zP+Y6OwTRP9qwx06pPy9pkmeEtHTht4Kn7QMy
   ZNYeDVGmO/C2SMlUn2sgf+iEV/2VG3W2q8eQrX419BWFCgxPQ1T9P1Liq
   uQPGxBPM5UD6m22LDobMxtUwrcD1jJbHCy9GrkXrmoboeOfd3x7Fjb6D+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334965959"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334965959"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784278"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784278"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 041/113] KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
Date:   Sun, 28 May 2023 21:19:23 -0700
Message-Id: <1add64fe7c9c370272f9689367bbbc3334dda14c.1685333727.git.isaku.yamahata@intel.com>
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
index 5f3cace6a85f..e8484ec90c61 100644
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
index ab480e40055b..45912ab65075 100644
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

