Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9351CFB4
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388809AbiEFDiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388660AbiEFDhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126346470F;
        Thu,  5 May 2022 20:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808015; x=1683344015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z+g065sqg/lU7/m93+W33DW/zDrAjHJNX3Jy3duhM4o=;
  b=WV13mlLdk8O2gR09P258++uDq0ymxrXdFKdU8KmpEi9okggUk8yXfP0j
   egJ9orLA3pwL6LytgdI5ftD1XeYQX5MA0LzkrLb/MqAi0cx+KHLlhTumv
   OWLrhS9ggmSKZCoX49u/QeQotgdp58YBKGi31IkXuYPytIz349I80wvix
   oVt5sbqyvk9ZOKrEfgmYeVnN6NV2y1/a8IB//52Quwr6LX+JaZA7Nn5Cy
   NutFQIlFo8yVn5bQo5Bbba/M7h2KzD9dydV7gIBKHIhaRezAzjLcH+T2A
   ysM5sramH3LbUDKgKm6ZEk+TTyclkDAiamCVtraTK0Eu6p8ar6KgA+6jb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241441"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241441"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745193"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 10/16] KVM: x86: Add XSAVE Support for Architectural LBR
Date:   Thu,  5 May 2022 23:32:59 -0400
Message-Id: <20220506033305.5135-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 379d13aa65c0..97b123b18e57 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7432,6 +7432,10 @@ static __init void vmx_set_cpu_caps(void)
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
index 7a181bd34b82..a722fe6e18ff 100644
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

