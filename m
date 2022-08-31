Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA75A8AEC
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiIABhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiIABhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CAA15C7A2;
        Wed, 31 Aug 2022 18:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996230; x=1693532230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=An8CLRxjOxfQySqbVQCCPBwU05ER2TI9Q891SfZu5/8=;
  b=TfOFVEph+mrEeFysEnVGWIJZIcwJOJjPw6PLqMDPa8aclJ4E7Yeda/YH
   8D7+/GXk3ZxFdaARL2iujXbuxcHwe5Tr3lgIG3Y7MQqvW3Z/HdTtazqvq
   TN1ZksCrnEjU+yr/xTu6yx9iRnZxEAolOrIEeVRtVFUFlWDFSPiE6nsXs
   2P0YQmQyJPunUSwM6rNPrl22x0O2qy5SjyiqayPKwCQm30R2n30QkftAr
   rZ9lmWjxyUURG0u8gH71tUraIsMVDnBncAhVmJLQrlKf0PKeQHdYBk7EY
   /HJ0iTJwrk4docjvlOB1xg+xdYcKu9SBALJiaoldP8hyvs5D5ZN7dDiP2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735098"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735098"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626028"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:02 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] KVM: x86: Add XSAVE Support for Architectural LBR
Date:   Wed, 31 Aug 2022 18:34:34 -0400
Message-Id: <20220831223438.413090-12-weijiang.yang@intel.com>
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

From: Like Xu <like.xu@linux.intel.com>

On processors supporting XSAVES and XRSTORS, Architectural LBR XSAVE
support is enumerated from CPUID.(EAX=0DH, ECX=1):ECX[bit 15].
The detailed sub-leaf for Arch LBR is enumerated in CPUID.(0DH, 0FH).

XSAVES provides a faster means than RDMSR for guest to read all LBRs.
When guest IA32_XSS[bit 15] is set, the Arch LBR state can be saved using
XSAVES and restored by XRSTORS with the appropriate RFBM.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20220517154100.29983-12-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cdf65cdcb45a..9d50e3703ea2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7714,6 +7714,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
 	}
+	if (!cpu_has_vmx_arch_lbr()) {
+		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_LBR;
+	}
 
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19cb5840300b..e9f0f97014de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -213,7 +213,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS     XFEATURE_MASK_LBR
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
-- 
2.27.0

