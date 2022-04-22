Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74DD50B247
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445272AbiDVH66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445235AbiDVH63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF32135A92;
        Fri, 22 Apr 2022 00:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614137; x=1682150137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pAOqoNuEK5xt3RU8SAS9DL8x+sdEGAP/GqlMqeaHO1I=;
  b=RrgABR7hDPwsLAlsstbHzSm1jMiRUhTtI6lAWf//TTnlPA6pGYip+BLm
   eqhB3y2scbYZwchcOCnUuzrrWJZspHjtGCsSCBl6PDRUkW8V4C6QIsb9v
   JjB0UwOyn4u/PRFAUXp32HBG8lOq8KuGr0HQ/lWV2pTzf/R/cLQl7bS0T
   qmVG5ItIjL3U2z/vzoCMJvYTc/VRW+MxUfIW7znsnT5iOXNnU3g/y4exk
   HHWLhZumiaGovVnmRVwDh80XWIJ+x5O3q4BNwOAVVnS9kaYLvFwBjd/1C
   P0hPtEcfNo8wHV1t10NAjkGQ2F3lJ0VvflTrOIBXjl5jP3B89nXWuHHHZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384835"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384835"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741350"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 10/16] KVM: x86: Add XSAVE Support for Architectural LBR
Date:   Fri, 22 Apr 2022 03:55:03 -0400
Message-Id: <20220422075509.353942-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220422075509.353942-1-weijiang.yang@intel.com>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

On processors supporting XSAVES and XRSTORS, Architectural LBR XSAVE
support is enumerated from CPUID.(EAX=0DH, ECX=1):ECX[bit 15].
The detailed sub-leaf for Arch LBR is enumerated in CPUID.(0DH, 0FH).

XSAVES provides a faster means than RDMSR for guest to read all LBRs.
When guest IA32_XSS[bit 15] is set, the Arch LBR state can be saved using
XSAVES and restored by XRSTORS with the appropriate RFBM.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b29c8e75f902..60d92a459f4c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7427,6 +7427,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (!cpu_has_vmx_arch_lbr()) {
+		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
+		supported_xss &= ~XFEATURE_MASK_LBR;
+	}
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13475563c3f6..e33315662db9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -224,7 +224,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS     XFEATURE_MASK_LBR
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
-- 
2.27.0

