Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8105070EDC4
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 08:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbjEXGRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 02:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239584AbjEXGRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 02:17:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC1B18B;
        Tue, 23 May 2023 23:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684909027; x=1716445027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NIz83zwBrx9rPoQnot0IXhX1IJvrd8Dsfj/8OSzuMes=;
  b=mWY+6Sbd4wV6GW2VUoMFH482Tw8hYRSYqynGjx48Rd3Lmz75Yq3Xtyuz
   k7UV9mcGux5A0CY+WtW7AZUUK96xztQStS1jpJNvN8E0gUvUXa7HiMiWP
   wAOcxnqZkNnEf62DhiVpuIoRjMP2KsXdPihm2WZa9rh4lvUSTxKiJhodA
   GiWfpF+KcMjVfFXa325uvNA/UGPpoDSEKr67YfCo/stVEafsBTJUtTAaG
   dYhIEN86XjekIUGDZMYpUiVWbv8u2mqDBXTkGy/K+MptRi6j6V7uEvl9g
   jgLyFg/eG/VVvo0dtipyY0e1DpU9cBtKlWsQPjgm3LhpBqK2A4pEsV9hN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="356695105"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="356695105"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:17:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="704212453"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="704212453"
Received: from spr.sh.intel.com ([10.239.53.106])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 23:17:01 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org
Cc:     xiaoyao.li@intel.com, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] x86/cpu, KVM: Use helper function to read MSR_IA32_ARCH_CAPABILITIES
Date:   Wed, 24 May 2023 14:16:33 +0800
Message-Id: <20230524061634.54141-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230524061634.54141-1-chao.gao@intel.com>
References: <20230524061634.54141-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM open-codes x86_read_arch_cap_msr() in a few places. Eliminate them
by exposing the helper function and using it directly.

No functional change intended.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/cpu/common.c |  1 +
 arch/x86/kvm/vmx/vmx.c       | 19 +++++--------------
 arch/x86/kvm/x86.c           |  7 +------
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 80710a68ef7d..b34dd3f3e6c4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1315,6 +1315,7 @@ u64 x86_read_arch_cap_msr(void)
 
 	return ia32_cap;
 }
+EXPORT_SYMBOL_GPL(x86_read_arch_cap_msr);
 
 static bool arch_cap_mmio_immune(u64 ia32_cap)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8274ef5e89e5..3dec4a4f637e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -255,14 +255,9 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 		return 0;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
-		u64 msr;
-
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
-		if (msr & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
-			l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
-			return 0;
-		}
+	if (x86_read_arch_cap_msr() & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
+		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
+		return 0;
 	}
 
 	/* If set to auto use the default l1tf mitigation method */
@@ -394,13 +389,9 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 
 static void vmx_setup_fb_clear_ctrl(void)
 {
-	u64 msr;
-
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
-	    !boot_cpu_has_bug(X86_BUG_MDS) &&
+	if (!boot_cpu_has_bug(X86_BUG_MDS) &&
 	    !boot_cpu_has_bug(X86_BUG_TAA)) {
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
-		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
+		if (x86_read_arch_cap_msr() & ARCH_CAP_FB_CLEAR_CTRL)
 			vmx_fb_clear_ctrl_available = true;
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7838260c183..b1bdb84ac10f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1612,12 +1612,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
 
 static u64 kvm_get_arch_capabilities(void)
 {
-	u64 data = 0;
-
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
-		data &= KVM_SUPPORTED_ARCH_CAP;
-	}
+	u64 data = x86_read_arch_cap_msr() & KVM_SUPPORTED_ARCH_CAP;
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
-- 
2.40.0

