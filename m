Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7221358BD7C
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbiHGWHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiHGWFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:05:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F05B7E2;
        Sun,  7 Aug 2022 15:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909783; x=1691445783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3mCcOnOxdxaooSM4412HI3d2SaV1+FV9yeoqdGQdcwU=;
  b=BoJENkoqVJEykH1KDDd9fp/MRd966xYZnjTe1KSuJtX2QTRAfhNRyLRy
   F868JkSlNA6w8dz/CARUCuhA31sp8pagIZ3co6WCgUpiclp7BXkXS56IL
   cC5/TvIW9MtPuMS6DMl2MygdK62LxnIJYhr6eZdZubBdEwQbP23NmVBuN
   pqqIVlUqW27S89phUkacw4BoO6B7xE86fkVBy7jxyIYvJmALero+RPPPj
   dn/CkDCnKcA4Bt8ASYK9sFCoXuiB2RbxwPuymtO+GWd1KQyChogiRP+6x
   YZPzZF1Jh7DTWFmhrLVbl/vRvToqbpjBOa1g9TdohM3dLGUGPs4hoV8bJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224129"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224129"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682573"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 041/103] KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
Date:   Sun,  7 Aug 2022 15:01:26 -0700
Message-Id: <621bbca9e03f1350e393657da3f27f295b57a490.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX support introduces private mapping, add a new member in union
kvm_mmu_page_role with access functions to check the member.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h | 11 +++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e07294fc2219..25835b8c4c12 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -334,7 +334,12 @@ union kvm_mmu_page_role {
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
@@ -346,6 +351,28 @@ union kvm_mmu_page_role {
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
+	WARN_ON(1);
+}
+#endif
+
 /*
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e1b2e84c16b5..c9446e4e16e3 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -142,6 +142,17 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }
 
+static inline bool is_private_sp(const struct kvm_mmu_page *sp)
+{
+	return kvm_mmu_page_role_is_private(sp->role);
+}
+
+static inline bool is_private_sptep(u64 *sptep)
+{
+	WARN_ON(!sptep);
+	return is_private_sp(sptep_to_sp(sptep));
+}
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
-- 
2.25.1

