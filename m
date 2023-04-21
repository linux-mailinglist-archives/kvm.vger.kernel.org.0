Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832906EAF94
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjDUQvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjDUQuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:50:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24EF8691;
        Fri, 21 Apr 2023 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095849; x=1713631849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FUetmM3QAjP8/HE1ypNjPP89xC2eIzQHpTYHL+d52N8=;
  b=GQen9tZXMQ5tGqlYFeKwdZEvI2LKq9EhzTYwev0+qQTpiFMeaKRBRkn1
   5PNkyF+Pl50QLx3TJNtQ/C0A/D5YdCT3LJVShK0dP3EUUFGjTRWUMXmh+
   JwmMIlW+xguinL3Ros4EXQLRNNei2gAPLzJ4enYNeY41SeNChXdq4EMIs
   IWgMxprbbpQcgzl+6BviX4w/+MtRi7yqWxpZ5QFwfcDlMcD2Z9esvmh2U
   vqSLHEdwRxCzp0z1xqcMDI0C4eIQOGhd7itYrP0z5EHv14MczIVDakUHI
   xeHGo0YEjZ+NHkAlNZGpHN44Q5p0GfKqRaOBaGzGfcOz7+qoUXyWey2HF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787000"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787000"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817386"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817386"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:43 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 08/21] KVM:x86: Init kvm_caps.supported_xss with supported feature bits
Date:   Fri, 21 Apr 2023 09:46:02 -0400
Message-Id: <20230421134615.62539-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
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

Initialize kvm_caps.supported_xss with host XSS msr value AND XSS mask.
KVM_SUPPORTED_XSS holds all potential supported feature bits, the result
represents all KVM supported feature bits which is used for swapping guest
and host FPU contents.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..c872a5aafa50 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7806,7 +7806,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab3360a10933..d2975ca96ac5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -223,6 +223,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -9472,8 +9474,10 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	kvm_init_pmu_capability(ops->pmu_ops);
 
-- 
2.27.0

