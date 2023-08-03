Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF4376E1C9
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbjHCHhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjHCHgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:16 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDB849E2;
        Thu,  3 Aug 2023 00:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047942; x=1722583942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CmAs7m1B9VFSX+QDbvzqcYRQr/GL9RBo18A45fnyo9E=;
  b=Gmmw4GG2FxxewWsSHzLi6ZBwn/B+qUUqiNY0k86xXs/Pua4IJFVle1u8
   tQE6aW4FPsJkO074ul7OzJcdkpUoov2pCUZoS3hLZib0+KC+R0Rjz7pvF
   bzTVpxlodiDsw1uBmldnTa8arRLSMwPWyBnrpSjBv+oXb0ChCV1N9yz64
   bPUckwTYfrlgtaFxqhbo4IB+CRsaz5/Kdgv84HU9dKBwKyIGgp+sLE5gh
   6Tst/8F9U4qDsQaA0J62keE4EpgW8EyrqzwFXVEaU8TazCYOwMKr5lh0J
   PB8l405XZv43DzLA9vTDNhzgy4nYEp56EaNt46Y8UUE5Vn2hJMPqfzw6W
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708174"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708174"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888521"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888521"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 17/19] KVM:x86: Enable guest CET supervisor xstate bit support
Date:   Thu,  3 Aug 2023 00:27:30 -0400
Message-Id: <20230803042732.88515-18-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add S_CET bit in kvm_caps.supported_xss so that guest can enumerate
the feature in CPUID(0xd,1).ECX.

Guest S_CET xstate bit is specially handled, i.e., it can be exposed
without related enabling on host side, because KVM manually saves/reloads
guest supervisor SHSTK SSPs and current XSS swap logic for host/guest aslo
supports doing so, thus it's safe to enable the bit without host support.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 8 +++++++-
 arch/x86/kvm/x86.h | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aa92dec66f1e..2e200a5d00e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -230,7 +230,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER)
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
@@ -9657,8 +9658,13 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0xd, 1, &eax, &ebx, &ecx, &edx);
 		rdmsrl(MSR_IA32_XSS, host_xss);
 		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+		if (ecx & XFEATURE_MASK_CET_KERNEL)
+			kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
 	}
 
 	kvm_init_pmu_capability(ops->pmu_ops);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 373386fb9ed2..ea0ecb8f0df6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -363,7 +363,7 @@ static inline bool kvm_mpx_supported(void)
 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }
 
-#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
+#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
 /*
  * Shadow Stack and Indirect Branch Tracking feature enabling depends on
  * whether host side CET user xstate bit is supported or not.
-- 
2.27.0

