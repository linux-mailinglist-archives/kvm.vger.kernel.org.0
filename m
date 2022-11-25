Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991FB638AB3
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKYM7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiKYM7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:59:12 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D599528E2F;
        Fri, 25 Nov 2022 04:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381142; x=1700917142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v4fej//7FpkGY53wVCQwPqHO2iJNyMNdkMs+y+xX9pI=;
  b=j0RotfVV9pC3r9m9PGRVJ4i4RKhevmsXfYUTNUNbOx9Yp1znoeK1HYa0
   M7vm0lqBlb/Yskyu4tHQI8yiQLEm+rkuCsQtIV8V9ODAz2S/VxW50cLus
   WF5GqRLkAsoUGYrqMiU+mmYYkgm2GfFVf3D5EwL/rWf9QxD45SRk8qs9b
   aqOMNug0hMUL0haVCi1ivEGurgD80H8tYD6gBgH627QxmDwZVd6DJecrx
   QWpryQFtZcXQXp4s2pDSCkU7Eeguw2z7gJCjK/GWmKhoZW9LRqHdyoE9U
   lg5irSsn+CkdsEqebn8Dr00+HMUzekAJF5kefUWPkfOs3IMktRj5RFchT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="341381295"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="341381295"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="706061282"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="706061282"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2022 04:58:57 -0800
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
Subject: [PATCH v5 5/8] x86: KVM: Advertise AVX-IFMA CPUID to user space
Date:   Fri, 25 Nov 2022 20:58:42 +0800
Message-Id: <20221125125845.1182922-6-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
References: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVX-IFMA is a new instruction in the latest Intel platform Sierra
Forest. This instruction packed multiplies unsigned 52-bit integers and
adds the low/high 52-bit products to Qword Accumulators.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 23]

AVX-IFMA is on an expected-dense CPUID leaf and some other bits on this
leaf have kernel usages. Given that, define this feature bit like
X86_FEATURE_<name> in kernel. Considering AVX-IFMA itself has no truly
kernel usages and /proc/cpuinfo has too much unreadable flags, hide this
one in /proc/cpuinfo.

Advertise AVX-IFMA to KVM userspace. This is safe because there are no
new VMX controls or additional host enabling required for guests to use
this feature.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 20059dc33d24..1419c4e04d45 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -310,6 +310,7 @@
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* "" CMPccXADD instructions */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
+#define X86_FEATURE_AVX_IFMA            (12*32+23) /* "" Support for VPMADD52[H,L]UQ */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0e04d1138bca..8612cddd9838 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -663,7 +663,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
+		F(AVX_IFMA)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.27.0

