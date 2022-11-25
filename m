Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C205E638AAF
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiKYM73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiKYM7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:59:07 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812AC4B9A9;
        Fri, 25 Nov 2022 04:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381139; x=1700917139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2dlacMSLYc4en8Dy6BoVcxx+ZaMBjc+9W62cGBZqkas=;
  b=WnotmkjajYrTZeeLL+uDHmgkQ3LwVow+FyxR36shLkWd4ql+pvOt3Na+
   O+AHb49hffycnRgNoOHUHRKR3YVMxSWiziua0ALU0kIK7w+aSfjeKc0M2
   kn95FiMbEwzX0lcQq9l9hPq+Bn8L0A1aZWsPSZj5ZyDeemHECP0/kItGy
   bI1XLUX5NtTRpjdDvUGIv1rSbOK8q9Kr3wdTh98keAJvwJR6ENzmS49of
   Oj8AhMga9sUiG7EvTUe67A0m6WVOlARHyOFA2HPjkxk6mzNb+zfmVNBPp
   3suieWf829Zs0oD9aJaihAERIBifCGB2XavwgSG5ALK/dupi4AMZIAAeX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294180576"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294180576"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:58:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="706061253"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="706061253"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2022 04:58:47 -0800
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
Subject: [PATCH v5 3/8] x86: KVM: Advertise CMPccXADD CPUID to user space
Date:   Fri, 25 Nov 2022 20:58:40 +0800
Message-Id: <20221125125845.1182922-4-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
References: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CMPccXADD is a new set of instructions in the latest Intel platform
Sierra Forest. This new instruction set includes a semaphore operation
that can compare and add the operands if condition is met, which can
improve database performance.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 7]

CMPccXADD is on an expected-dense CPUID leaf and some other bits on this
leaf have kernel usages. Given that, define this feature bit like
X86_FEATURE_<name> in kernel. Considering CMPccXADD itself has no truly
kernel usages and /proc/cpuinfo has too much unreadable flags, hide this
one in /proc/cpuinfo.

Advertise CMPCCXADD to KVM userspace. This is safe because there are no
new VMX controls or additional host enabling required for guests to use
this feature.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b71f4f2ecdd5..5cdd57133d90 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -308,6 +308,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
+#define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* "" CMPccXADD instructions */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a3adac48766b..f8bf4fb30b96 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -663,7 +663,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.27.0

