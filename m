Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B698D7598A9
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjGSOlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjGSOlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:41:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CFA1A6;
        Wed, 19 Jul 2023 07:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777699; x=1721313699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e+BE2T/0MGsakXu38dYWFsSUBBN/4RIFrzl8jcqCSP4=;
  b=cKTI2hp6COTO3hRQsTAukwXFYY1S94LQuqfojVUJF6mIE/DREKMYjxJG
   wxB/ONYrDHx28jmeV9BH0ZbizG1IwMxe9LaAxmmmn4zObRG9NsQCNIS1L
   Jp+c5bilcRuTfIuFzuRIcykaITDZbL1MHwiSQDkhPwHalxxgtLCZwqcDE
   FMZD+gNef47RKqBuBaEoohz3vje0ZglDuYnVuEPKhekiLNRI2/EzbW+Fw
   RC0PrfITHgvugXU7UcCOqXsxDg0wSfjMzKFJGUhRDtI0kj5PYLZynnLav
   6KjtIaoUNthn8hgXZLPYNZXqzIss8LYikzsTsqg0dVsagohI0unhQR/RV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788129"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788129"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503246"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:37 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 1/9] KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK
Date:   Wed, 19 Jul 2023 22:41:23 +0800
Message-Id: <20230719144131.29052-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d39af5639ce9..7d2105432d66 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -21,6 +21,7 @@ extern bool dbg;
 #endif
 
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
+#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
 #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
 	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
 #define __PT_INDEX(address, level, bits_per_level) \
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0662e0278e70..00c8193f5991 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -62,7 +62,7 @@
 #endif
 
 /* Common logic, but per-type values.  These also need to be undefined. */
-#define PT_BASE_ADDR_MASK	((pt_element_t)(((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1)))
+#define PT_BASE_ADDR_MASK	((pt_element_t)__PT_BASE_ADDR_MASK)
 #define PT_LVL_ADDR_MASK(lvl)	__PT_LVL_ADDR_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_LVL_OFFSET_MASK(lvl)	__PT_LVL_OFFSET_MASK(PT_BASE_ADDR_MASK, lvl, PT_LEVEL_BITS)
 #define PT_INDEX(addr, lvl)	__PT_INDEX(addr, lvl, PT_LEVEL_BITS)
-- 
2.25.1

