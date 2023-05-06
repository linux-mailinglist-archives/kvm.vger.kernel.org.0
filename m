Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117F86F8E2F
	for <lists+kvm@lfdr.de>; Sat,  6 May 2023 05:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjEFDFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 23:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjEFDFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 23:05:13 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C3644AD;
        Fri,  5 May 2023 20:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683342312; x=1714878312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lBF+bPVRCpsw9+RxW6+0dovFS6dJNrvwSuV3p38PHKs=;
  b=OtuF6ARlAyUuFfVFZibkTTr1d8XmmYhCqGOCcGh07TnRdiEDEsBrpill
   EAqqdL/2RbrpNVqPapcIraIJBBxFA0nPtYb9yfAXJDzS4nhgWY1xEQK7/
   afmOlT2skL8MAlPij1mJ+f9rTNPoUTWXVpeSWSxoH/vxHv9hMBh8BiMd8
   QzS92k3Un3+TDwP2yw7+i8LjiI/Ez5BTUOCK8koALEN1Pj1uJ0WXVTIFf
   e2behek6/Wu5zQ51/GjTBGJrv9eWO+EB0O3mpH2n6ABpZMGjrqLGrUHp1
   Ee33AJZGkjHdfzapTSBZMr62ddS1v3uavnpXSXqjAWvPLCn5X8+iHjTug
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="329690813"
X-IronPort-AV: E=Sophos;i="5.99,253,1677571200"; 
   d="scan'208";a="329690813"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 20:05:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="842020225"
X-IronPort-AV: E=Sophos;i="5.99,253,1677571200"; 
   d="scan'208";a="842020225"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 20:05:08 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Date:   Sat,  6 May 2023 11:04:35 +0800
Message-Id: <20230506030435.80262-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

to avoid computing the supported value at runtime every time.

No functional change intended.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---

A new call site of kvm_get_arch_capabilities() is added by [1]. It should be
replaced with the cached value in kvm_caps.

[1] https://lore.kernel.org/all/20230504181827.130532-1-mizhang@google.com/


 arch/x86/kvm/x86.c | 5 +++--
 arch/x86/kvm/x86.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 523c39a03c00..94aa70ec169c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1670,7 +1670,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case MSR_IA32_ARCH_CAPABILITIES:
-		msr->data = kvm_get_arch_capabilities();
+		msr->data = kvm_caps.supported_arch_cap;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		msr->data = kvm_caps.supported_perf_cap;
@@ -9523,6 +9523,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_caps.max_guest_tsc_khz = max;
 	}
 	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
+	kvm_caps.supported_arch_cap = kvm_get_arch_capabilities();
 	kvm_init_msr_lists();
 	return 0;
 
@@ -11879,7 +11880,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r)
 		goto free_guest_fpu;
 
-	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+	vcpu->arch.arch_capabilities = kvm_caps.supported_arch_cap;
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_xen_init_vcpu(vcpu);
 	kvm_vcpu_mtrr_init(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..d3e524bcc169 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -29,6 +29,7 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+	u64 supported_arch_cap;
 };
 
 void kvm_spurious_fault(void);

base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
-- 
2.40.0

