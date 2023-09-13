Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D06379ED6E
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjIMPlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjIMPkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2346A2D4F;
        Wed, 13 Sep 2023 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619618; x=1726155618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jK+AajhiYbJthCQ+cLTTr7Oh8eI0CFMhVbE28MQ0SNE=;
  b=GPdsFgy+dihqp+1LVz1OBCf8GZY1JiFOAzL5kkbSki+CE+w2okKY6T9w
   SeI0VuhUu/oNz5aTRQCaPc36K/GLS19yDMNcky6unmJL2vobs/z5rnBet
   JVH06V+HJHsd3ukcMhglSOaY6lIqHWbNdgV5VP7HMtJhHVjE0t6JQ+qgN
   NrCf1y2XfPcl91MqsmeRwkgTgXqrMYEn6aLxskNqHxecPNj0RwCWAJF2W
   Bqsp/ab8lqSKcHD64eNb8NywdWMlz27xjVNyQ6YNhn8Nbu1sLJexbrMkH
   huQ5kTkjKaGe39ye6N8IRkHsu/xHF801RtAM1ow/aSCGY+zcuBrKJ3gF5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030284"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030284"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852253"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852253"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:15 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 13/16] KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
Date:   Wed, 13 Sep 2023 20:42:24 +0800
Message-Id: <20230913124227.12574-14-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the governed feature framework to track if Linear Address Masking (LAM)
is "enabled", i.e. if LAM can be used by the guest.

Using the framework to avoid the relative expensive call guest_cpuid_has()
during cr3 and vmexit handling paths for LAM.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/cpuid.h             | 3 +--
 arch/x86/kvm/governed_features.h | 1 +
 arch/x86/kvm/mmu.h               | 3 +--
 arch/x86/kvm/vmx/vmx.c           | 1 +
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3c579ce2f60f..93c63ba29337 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -275,8 +275,7 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
 
 static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
-	if (kvm_cpu_cap_has(X86_FEATURE_LAM) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+	if (guest_can_use(vcpu, X86_FEATURE_LAM))
 		cr3 &= ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
 
 	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 423a73395c10..ad463b1ed4e4 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -16,6 +16,7 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
+KVM_GOVERNED_X86_FEATURE(LAM)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e700f1f854ae..f04cc5ade1cd 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -148,8 +148,7 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 
 static inline unsigned long kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_cpu_cap_has(X86_FEATURE_LAM) ||
-	    !guest_cpuid_has(vcpu, X86_FEATURE_LAM))
+	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
 		return 0;
 
 	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 23eac6bb4fac..3bdeebee71cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7767,6 +7767,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LAM);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.25.1

