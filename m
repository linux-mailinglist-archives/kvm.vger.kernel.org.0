Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46B5667B6B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbjALQm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjALQiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758351A051;
        Thu, 12 Jan 2023 08:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541240; x=1705077240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QpfNDx7/KJKdchEl7tT4kjgvGQPEw+SMrUiZAfwHf2Y=;
  b=OiiLwE/z4UUoQ4x4+dxrpUCCCkg7stVX5T/1zn6u+aPjoPrFd6BJHE48
   PTmY3XOuaMr8JdFyGc4c+MQXoPhxZYKadT8V9wG1rg1dIVjs/ezljhX9b
   92XNcbV8raUBh7do4xV00+U4RrvDBAPI3SbTxuOrs0AXdAkgMumnauuVw
   3Eh8ZpBoo0qCl2EGNU3cI0AHox30j08vDT+ZS45TYE9QybFKfxo51gtKG
   1GYoR79C9/7/0ClAtJPtberetj/9HVMcwivFAPSuWEa5t0EayzU/O/DTL
   hg9H9aVIoOnAUZmq+BT61a64VOG1MC/qVjYz4OOlJh350eAZqnnr/HAAN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811806"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811806"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151736"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151736"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:25 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 032/113] KVM: x86/mmu: Add Suppress VE bit to shadow_mmio_mask
Date:   Thu, 12 Jan 2023 08:31:40 -0800
Message-Id: <8cb87ec35b24d9cf5b47b650597c3005a8adf247.1673539699.git.isaku.yamahata@intel.com>
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

To make use of the same value of shadow_mmio_mask for TDX and VMX, add
Suppress-VE bit to shadow_mmio_mask so that shadow_mmio_mask can be common
for both VMX and TDX.

TDX will need shadow_mmio_mask to be VMX_SUPPRESS_VE | RWX and
shadow_mmio_value to be 0 so that EPT violation is triggered.  For VMX,
VMX_SUPPRESS_VE doesn't matter because the spte value is required to cause
EPT misconfig.  the additional bit doesn't affect VMX logic to add the bit
to shadow_mmio_{value, mask}.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fce6f047399f..cc0bc058fb25 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -431,7 +431,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
-	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
+	shadow_present_mask	=
+		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
 	/*
 	 * EPT overrides the host MTRRs, and so KVM must program the desired
 	 * memtype directly into the SPTEs.  Note, this mask is just the mask
@@ -448,7 +450,7 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
 	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
+				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
-- 
2.25.1

