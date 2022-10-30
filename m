Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02EE6127DF
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJ3GZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJ3GYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B3310C;
        Sat, 29 Oct 2022 23:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111048; x=1698647048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KuHqjRVUBksdUjeiSc9eKEgyTsBPP0Eliqw02r0hyTk=;
  b=CtcR55sk/E6tQ2LBiliuRJG6tM63UeX0woNBCd7cOt44JOtXR16TzxlI
   Cz6Hj3dxBlmzzXytaxgl+EL1HH6jzTC4QhmLt8rVosrdjo7jlJxSlF6m3
   8kX5rJrvXVEjxPlicpYL722R78WLQrlNaY0Pbh8BTFzoVARaHK86WR1D3
   SFn9jqau8v2a3bBvlP5CvqniHl3m5Rsg0GPv/+uzlbHyB3dZtTjzpHmPC
   dWUW68wVmK+md2lTyQLWnYDqHUPiiaqrfwWE6T+yVxscb1emJWtMbcImF
   QqrhYZ1SiboJvsuBYO2HxG0eO18jD181eFYFE/9I/l6nNdIjJ2iuXHEWL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037146"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037146"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:02 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392954"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392954"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 034/108] KVM: x86/mmu: Add Suppress VE bit to shadow_mmio_{value, mask}
Date:   Sat, 29 Oct 2022 23:22:35 -0700
Message-Id: <1c480a48c2697054b1cfe068fa073f4035648f9a.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX will need shadow_mmio_mask to be VMX_SUPPRESS_VE | RWX and
shadow_mmio_value to be 0, make VMX EPT case use same value for TDX
shadow_mmio_mask.  For VMX, VMX_SUPPRESS_VE doesn't matter, it doesn't
affect VMX logic to add the bit to shadow_mmio_{value, mask}.  Note that
shadow_mmio_value will be per-VM value.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0b97a045c5f0..5d5c06d4fd89 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -437,8 +437,8 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	 * EPT Misconfigurations are generated if the value of bits 2:0
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE,
-				   VMX_EPT_RWX_MASK, 0);
+	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE | VMX_EPT_SUPPRESS_VE_BIT,
+				   VMX_EPT_RWX_MASK | VMX_EPT_SUPPRESS_VE_BIT, 0);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_ept_masks);
 
-- 
2.25.1

