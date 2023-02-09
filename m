Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C55B68FD33
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBIClN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbjBIClL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E524F28856
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910466; x=1707446466;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pObK/qxpk4aUNUa7CYE0Iry67DmXBqIZNCMxNTvf4xE=;
  b=m0wGXEczk1VSWlaBodegGtM9qczVvGJyMxlLDKIUEjIXavwLWn8LfrQ8
   qX395dg0OtMwAJcvR7ivrbv0KDQ/PggSAWXeKXeTpaFfyCjAdDT3Nyabe
   AKbxyqqiIOnkaPHSPfC2LuOMOo/WVr/IT5R5FrU0K6QCL4OIm4J2BtxTV
   gKRQXofF1RiJfUj2k4YV0rP2btYwyoo5sHAlTEk29NBs+S/EJ0JKmRmS/
   H21Y9XWZPF/F5OyqrBaE17+IwgouaNUCaD3DcbuzFzPZn18/SVawi0lPe
   IgLLAEsldEDAb9euNrGWy4P9S97BB/AhMxxGLL9uRG+HzHa9Hh3+12C/7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586596"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586596"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:40:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094344"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094344"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:40:55 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 1/9] KVM: x86: Intercept CR4.LAM_SUP when LAM feature is enabled in guest
Date:   Thu,  9 Feb 2023 10:40:14 +0800
Message-Id: <20230209024022.3371768-2-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove CR4.LAM_SUP (bit 28) from default CR4_RESERVED_BITS, while reserve
it in __cr4_reserved_bits() by feature testing.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/x86.h              | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f35f1ff4427b..4684896698f4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -125,7 +125,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_LAM_SUP))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9de72586f406..8ec5cc983062 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -475,6 +475,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_LAM))		\
+		__reserved_bits |= X86_CR4_LAM_SUP;	\
 	__reserved_bits;                                \
 })
 
-- 
2.31.1

