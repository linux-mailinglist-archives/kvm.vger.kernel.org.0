Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2940F617478
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiKCCvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiKCCu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:50:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3B313E9B;
        Wed,  2 Nov 2022 19:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443855; x=1698979855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lg09VbI/60vYnXZzpwRBHqC+c64eQ+EJZudgsq58kIU=;
  b=WrcQQ9l7ltZb7HpcXDVAO+QcAL+f83wQBO2shMQDiR/mz68mJSf/ZIyb
   HxpliXC3OhCwEvE9cT8epwkCDAbFO4DwR8mZ86PRzWnDO2fj4o45XON7n
   7xRo7bvSsr2PzRDvMl+pSURgq6liAbmzqtyZzRJRtJXQkReo8992iY/xr
   TyQIhH8+rnnMjk7VKhGYleFn+HxRY/+UbSGXryaS6VrsK0Jgg7GG/RBqO
   3/4tWk7iaJ7LWuDPshDP4C3t7rIDP2pTr02aVX04TiWxY6uaexG65VIuz
   rrb7imCSJbnIrcdommYv+XZA3BArRVHHhjwSMXZb4LR+i4cDSd7+8d6iO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="308289844"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="308289844"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:50:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047897"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047897"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:50:50 -0700
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] x86: KVM: Advertise AMX-FP16 CPUID to user space
Date:   Thu,  3 Nov 2022 10:50:26 +0800
Message-Id: <20221103025030.78371-5-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Latest Intel platform Granite Rapids has introduced a new instruction -
AMX-FP16, which performs dot-products of two FP16 tiles and accumulates
the results into a packed single precision tile. This instrucion needs
no additional enabling on top of the existing kernel AMX enabling.

AMX-FP16 adds FP16 capability and also allows a FP16 GPU trained model
to run faster without loss of accuracy or added SW overhead.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 21]

This CPUID is exposed to user space. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b388ef52f8c8..19ef02d5b11b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -657,7 +657,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 24f570ddb225..05fd43ebd226 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -29,6 +29,7 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX_VNNI            KVM_X86_FEATURE(CPUID_7_1_EAX, 4)
 #define X86_FEATURE_AVX512_BF16         KVM_X86_FEATURE(CPUID_7_1_EAX, 5)
 #define X86_FEATURE_CMPCCXADD           KVM_X86_FEATURE(CPUID_7_1_EAX, 7)
+#define X86_FEATURE_AMX_FP16            KVM_X86_FEATURE(CPUID_7_1_EAX, 21)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

