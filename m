Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF66383D3
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiKYGKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiKYGKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:11 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33A41FFB6;
        Thu, 24 Nov 2022 22:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356610; x=1700892610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b0HflqpockXVYHP3iADSezT3+7UDyiWMjXkwdZSqFCg=;
  b=mBQKPIQQCPtGFRuenM7zc53TkNMuXdWh+SdA050qvxUm4KTSn58S0sJu
   EOxh3b+BghG/X7E674OOzi3YA8rSuZZrSgV2llcStjYnE7hLh4jXNiYzt
   tvquV/ZgwQFRIZHVHMsgJActubZ79p6lt5xaRAZ67T4zSxooo35pQdkXH
   jKL9Sfo5HWOSW0oK/KnwfP0c3Hb0qryUXLDJQywrkYchFBlxQrYOhOW+L
   TMsq2NZLIhA8vdOUohfXzQXmmvmF8V39Nsx0e2tsI9JNinl1uWZ+CjeO/
   11k3AyhtFhA4Y3+HK1XGKJ3o/9HAQyQchG3gyU4xgFXo9rFw9TPKVCaLK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116824"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116824"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838490"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838490"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:06 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 09/15] KVM: x86: Refine the matching and clearing logic for supported_xss
Date:   Thu, 24 Nov 2022 23:05:58 -0500
Message-Id: <20221125040604.5051-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Refine the code path of the existing clearing of supported_xss in this way:
initialize the supported_xss with the filter of KVM_SUPPORTED_XSS mask and
update its value in a bit clear manner (rather than bit setting).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9bd52ad3bbf4..2ab4c33b5008 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7738,9 +7738,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
-	if (!cpu_has_vmx_xsaves())
+	if (!cpu_has_vmx_xsaves()) {
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+		kvm_caps.supported_xss = 0;
+	}
 
 	/* CPUID 0x80000001 and 0x7 (RDPID) */
 	if (!cpu_has_vmx_rdtscp()) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74c858eaa1ea..889be0c9176d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -217,6 +217,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -11999,8 +12001,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	kvm_init_pmu_capability();
 
-- 
2.27.0

