Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE591667C5F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbjALRQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239063AbjALRP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:15:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017F680AD5;
        Thu, 12 Jan 2023 08:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542173; x=1705078173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OeLsEo50hbC8XkGy3XlTL2j0FeJ7MRnEC1GCFgbITOk=;
  b=Q4mjjgqKyldQygCYOOFzHFwDmJRoFW0S/TeU/tjDDMH1/m0p4fENp2hN
   NY7DLCzdlsvVBALlOC3FzFJtd+FGMuzGk2u8h+L0Kom6HKtoFx+OB4zgV
   bDDKXv15cpf4qfzkTBM/9xeEgCj+T/9JTkJJHB7d4IUFcw+9QvToxsAnP
   YIrynhekqauC0TzustQEWqL8WWby9vcYdUYm28FZS7N4WMmy5xenT3x8k
   RdjiItWm03zQeVyHT+lGYJODztQvVJASNpKU3cKvpFyTfUXMP6ODxQqu/
   M885kFY6PReXOrckPl2/bv+AavdXSmqOBX2cqbAj2dVZtnWYhl5caZ6Vq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816350"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816350"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658370"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658370"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:18 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 16/16] KVM: TDX: Allow 2MB large page for TD GUEST
Date:   Thu, 12 Jan 2023 08:44:08 -0800
Message-Id: <e2b402cba068c8ed85e9ce1927a2185112e0a34d.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

Now that everything is there to support 2MB page for TD guest.  Because TDX
module TDH.MEM.PAGE.AUG supports 4KB page and 2MB page, set struct
kvm_arch.tdp_max_page_level to 2MB page level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 arch/x86/kvm/vmx/tdx.c     | 4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index fc8f457292b9..7091c45697ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1630,14 +1630,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte)) {
-			/*
-			 * TODO: large page support.
-			 * Doesn't support large page for TDX now
-			 */
-			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
+		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		} else
+		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4ed76ef46b0d..3084fa846460 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -487,8 +487,8 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm_mmu_set_mmio_spte_value(kvm, 0);
 
-	/* TODO: Enable 2mb and 1gb large page support. */
-	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+	/* TDH.MEM.PAGE.AUG supports up to 2MB page. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_2M;
 
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
-- 
2.25.1

