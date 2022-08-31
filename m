Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94E55A8AE3
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiIABhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiIABhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9664515C790;
        Wed, 31 Aug 2022 18:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996229; x=1693532229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mt1aYBxWqrCJptPlJD3ONa5hNFpPuXusTwbvDwuh43A=;
  b=cePgIkmhU0rFwyOH/JLjfra91PRc0f63mqOBHD4af5AJAF/C5pVJOh19
   SLqcCTxIZnUvRbL2qLjdKpGgFu5m24cW4Lk63EgVGDPd6ZYSZdMC3PEED
   GKWP34vxxJ/JJ6fYlEfZ2fK0R6GQ/AKD/BRwGAhysQNCEtUZVf2jR9d1c
   e2nCboRNHGGKi7/eiuBS90vhj6s/FfFDYRORySQkZWDuGmjHTwGr8d41X
   yA2pIrRcVC64LT/jESp3U1+boHV3G9cqa6axOBHMOWEsCdvVTvarhpE/F
   vGfJy5gvIP1oBtZf8BixkZWZb6ViyLhiBE0NVE+IPlDyOQNpMUuj+LycW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735092"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735092"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626015"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:01 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] KVM: x86: Refine the matching and clearing logic for supported_xss
Date:   Wed, 31 Aug 2022 18:34:32 -0400
Message-Id: <20220831223438.413090-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20220517154100.29983-10-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77bad663d804..32e41bd217e3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7717,9 +7717,10 @@ static __init void vmx_set_cpu_caps(void)
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
index b3d2a7ad1d18..19cb5840300b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -213,6 +213,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -11965,8 +11967,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	kvm_init_pmu_capability();
 
-- 
2.27.0

