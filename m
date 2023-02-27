Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4116A3C92
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjB0IZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjB0IY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2F11CAC2;
        Mon, 27 Feb 2023 00:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486256; x=1709022256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6fv/A0IW7uL9kDyROAGN7ITa97YOBlnR3nZihL0cU0I=;
  b=F90DRcbz0educKrzqilo8gEUCMkRA1r+RKN68UUyl17EgCKwv8OP7M8s
   r25UxKDGlAKHSqg9J+jQ47VPBsMmQhZ2cXV/9or6ChK/oHM25RbXNwJ78
   l3nIY2w2DEUCuzgxfWYmn7TcN58kWLO08030LWYssVuqDjNXd73D1ZVGW
   VBL3SWFYEEma0wuqfPxfzmWq7UZRB6B3VRcarEx9Y0VbT05VYFoK5RFVD
   LW3zwKEBuccZaJYmw+EOA+lp6wj7N9dw5uQubDNRWM+ACExPegiAtTT2p
   nLZPg7z0QYLJV+kpsoIDSxfam77Z9SuiuiaDi05CUFzAufUjJUnYJZl/L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608779"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608779"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242142"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242142"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 027/106] KVM: x86/mmu: Add Suppress VE bit to shadow_mmio_mask/shadow_present_mask
Date:   Mon, 27 Feb 2023 00:22:26 -0800
Message-Id: <a6a83678c386507e081b9c1babfbdabb396eaecc.1677484918.git.isaku.yamahata@intel.com>
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

To make use of the same value of shadow_mmio_mask and shadow_present_mask
for TDX and VMX, add Suppress-VE bit to shadow_mmio_mask and
shadow_present_mask so that they can be common for both VMX and TDX.

TDX will require shadow_mmio_mask and shadow_present_mask to include
VMX_SUPPRESS_VE for shared GPA so that EPT violation is triggered for
shared GPA.  For VMX, VMX_SUPPRESS_VE doesn't matter for MMIO because the
spte value is required to cause EPT misconfig.  the additional bit doesn't
affect VMX logic to add the bit to shadow_mmio_{value, mask}.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 arch/x86/kvm/mmu/spte.c    | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..cdbf12c1a83c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -511,6 +511,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
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

