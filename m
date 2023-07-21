Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5775BE72
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjGUGJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjGUGJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:09:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6247E19A6;
        Thu, 20 Jul 2023 23:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919741; x=1721455741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z1qCzT0ZMxvYsf0S3vJ/qE/swqLkzSDdT/v3wrwsFro=;
  b=D9GPpHcSK/ixBg5X4yqRAN6Otgh1mlOd5XXnKJC4rE8dtt05vyH27TaU
   0JOAPnCURdKjyEdPUJnlKS/5OOKAvG0whkc/2tsPFFFKjQtqqQU/sWCe1
   iVGf9Vl3Z/pO9V6N9k/ZKvJDgtIheuytvke+pO+w2va66HNgGS8muZ7+x
   G/btLIo7C8VS/kG2L6tPDQhKappD3pP6qFh2Z2pjP1YCJUXJGVVTKVFoA
   HTO8Sy0FOMwaosvRE4ydhkGCVfahS7vr2IjrssIbU1HMXfWWS7f4C5Prf
   AjJgroiCTmJQaNgChZ8zetbo/tFC2nr2Ykg/b94tIvNdf0X4ByiK27Bul
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547628"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547628"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721990"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721990"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 18/20] KVM:x86: Enable guest CET supervisor xstate bit support
Date:   Thu, 20 Jul 2023 23:03:50 -0400
Message-Id: <20230721030352.72414-19-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/x86.c | 4 +++-
 arch/x86/kvm/x86.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 665593d75251..f68e36ef34b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -228,7 +228,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER)
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
@@ -9638,6 +9639,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
 		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+		kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
 	}
 
 	kvm_init_pmu_capability(ops->pmu_ops);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9c88ddfb3e97..66733e01b0ce 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -362,7 +362,7 @@ static inline bool kvm_mpx_supported(void)
 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }
 
-#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)
+#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)
 /*
  * Shadow Stack and Indirect Branch Tracking feature enabling depends on
  * whether host side CET user xstate bit is supported or not.
-- 
2.27.0

