Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDBA79ED5C
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjIMPkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjIMPkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E551BFC;
        Wed, 13 Sep 2023 08:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619595; x=1726155595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rYEBqAIo0P765JtuiX1UKxLDu6cAJk+hM7akS4M4yss=;
  b=a2wrrql0Qyy931qD2s1d3PnwYKRIRJGdc0Ex6doTexFeyHZ9MUjmhmKf
   olZAW+ad5gxQ0DGMlwiFN/TRkDHE3kT3KwgtpcX9FJBfFlez1UfBSurMF
   Vi1wbzBlfg2YhjLgE+VCCLMS8yh0Nf/Yuw/4e12MvVrd38SEslQdHBGK1
   oUPN0+zEiNtcKlJf92AvTcbN7ulnhgKrJ7sPfU5nHp6Srhn8r3wyY/d6t
   1bk5c/kavXZrRwgzoJspk9E6vhmLx+l6rHCNOpyxGwPuRk3vKGAFmkQZN
   5ikYABVfZptb8eYoIyodrNn+vj739Qk+rRuIU/43cpp49zihb8o0s2WO4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030175"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030175"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852088"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852088"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:39:52 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 05/16] KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
Date:   Wed, 13 Sep 2023 20:42:16 +0800
Message-Id: <20230913124227.12574-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop non-PA bits when getting GFN for guest's PGD with the maximum theoretical
mask for guest MAXPHYADDR.

Do it unconditionally because it's harmless for 32-bit guests, querying 64-bit
mode would be more expensive, and for EPT the mask isn't tied to guest mode.
Using PT_BASE_ADDR_MASK would be technically wrong (PAE paging has 64-bit
elements _excpet_ for CR3, which has only 32 valid bits), it wouldn't matter
in practice though.

Opportunistically use GENMASK_ULL() to define __PT_BASE_ADDR_MASK.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 1 +
 arch/x86/kvm/mmu/paging_tmpl.h  | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e1d011c67cc6..f316df038e61 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3774,7 +3774,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	hpa_t root;
 
 	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
-	root_gfn = root_pgd >> PAGE_SHIFT;
+	root_gfn = (root_pgd & __PT_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
 		mmu->root.hpa = kvm_mmu_get_dummy_root();
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b102014e2c60..b5aca7560fd0 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -13,6 +13,7 @@
 #endif
 
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
+#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)
 #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
 	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
 #define __PT_INDEX(address, level, bits_per_level) \
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c85255073f67..4d4e98fe4f35 100644
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

