Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F252F75BE51
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjGUGI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjGUGIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5629610F3;
        Thu, 20 Jul 2023 23:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919733; x=1721455733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/gv95RjbJ1ZnOGolXJm9SfRqqkclE9mWMbdAK0FExE=;
  b=WvAYZkG0NoKdCYBMjyHU2N9VlCmie9nsCDLNLJfHv+h7DbtXpswJjBT4
   KMCfO9rnWWPTKggmzfDFJjVCM7LxbGUWl8OUpQvwnViOsb8zHsCc9dky5
   JJnYl44YhQtUaEk4UjowR0wF3/i5wxFeB9mXDC9dZUYd5Ar7yeZXvcArR
   TUnRqVe4LOmIvk0/Fz4pQrZO/AIHaY9dRh4OV2HHOXPxv9smO4fG/cwmx
   WIXHg89mrHovJIfY1NqQsEm1dCtKFTQBvDnQbZyYj5SYUY5EA+yNScKDU
   g62NRMQ66AxfU51lM7bPHvZVAJtL5seK2eCc9CEbUI/7LhYim1gGiBeL+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547512"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547512"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721890"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721890"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 05/20] KVM:x86: Initialize kvm_caps.supported_xss
Date:   Thu, 20 Jul 2023 23:03:37 -0400
Message-Id: <20230721030352.72414-6-weijiang.yang@intel.com>
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

Set kvm_caps.supported_xss to host_xss && KVM XSS mask.
host_xss contains the host supported xstate feature bits for thread
context switch, KVM_SUPPORTED_XSS includes all KVM enabled XSS feature
bits, the operation result represents all KVM supported feature bits.
Since the result is subset of host_xss, the related XSAVE-managed MSRs
are automatically swapped for guest and host when vCPU exits to
userspace.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ecf4be2c6af..c8d9870cfecb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7849,7 +7849,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26edb8fa857a..8bdcbcf13146 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -225,6 +225,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -9499,8 +9501,10 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	kvm_init_pmu_capability(ops->pmu_ops);
 
-- 
2.27.0

