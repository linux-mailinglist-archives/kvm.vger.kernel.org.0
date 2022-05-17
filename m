Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8179452A71D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350315AbiEQPmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350499AbiEQPli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80AA41318;
        Tue, 17 May 2022 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802097; x=1684338097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z7fia9oToB15GCd1Yc1rfWsEIimPCVJTziCOUL77EO4=;
  b=cUSp/S4Zgrs5+fPW7Vib0KAhDuvMezrhzbXAi9kiOuFl5zr2f2CUAb2O
   mqyMcksk3L+eFFkyC9HVZA4aHWUEDOHbEt5xfpSXZpMEh0fvhymm437tB
   feQN+TfsKw4fAW9DTUcQZBmGA38VjELFLHgpvGkE/nMa0anhyfnYI6lpG
   qkBgLp4adQWvUizKa/yKHrpy9d5u6IOeNNaiR47WEn9rFysXj0nfj4KW4
   2kwTwnqIMGPMTv4xFSoIbnRQf3XGo0e4ksFc8UaAhMd/+TJckZy4vI4kt
   qpSbBibAi4DapopE21P0QI2ocSxvHWK0V9RZD2ZIhc95Zh3T4hjzWUFxC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632108"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632108"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533584"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 09/16] KVM: x86: Refine the matching and clearing logic for supported_xss
Date:   Tue, 17 May 2022 11:40:53 -0400
Message-Id: <20220517154100.29983-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

Refine the code path of the existing clearing of supported_xss in this way:
initialize the supported_xss with the filter of KVM_SUPPORTED_XSS mask and
update its value in a bit clear manner (rather than bit setting).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe4bb9b610ae..e442b30f1ca3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7552,9 +7552,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	supported_xss = 0;
-	if (!cpu_has_vmx_xsaves())
+	if (!cpu_has_vmx_xsaves()) {
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+		supported_xss = 0;
+	}
 
 	/* CPUID 0x80000001 and 0x7 (RDPID) */
 	if (!cpu_has_vmx_rdtscp()) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b027aed2f3..90b3129a2fbe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -224,6 +224,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -11702,8 +11704,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	kvm_init_pmu_capability();
 
-- 
2.27.0

