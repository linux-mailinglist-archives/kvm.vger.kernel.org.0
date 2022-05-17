Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558D852A725
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350378AbiEQPlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350508AbiEQPlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:39 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7313F898;
        Tue, 17 May 2022 08:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802098; x=1684338098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PEE3mQVMSR/fqfCf50ayuVEOVG8e9W8WgPEHCAb6QW8=;
  b=XW+puTOVDsZ8AO0YAUJV3MUHM1oO7R6DBbFas2swvBUhP+hzFEQKOR/B
   J0h/Qrhr1xu72shGHSkOFDmo1T2HWVRSM9MeCRREflsFebLB2+zvKyJCj
   gmhT8edilxTzgIgzVHm+nXZHANa5EeKD+RGZ1HsHdTS8QQ/JcDmMVKYG+
   u0qUfIY+QOO/NyW4V/zqZbT9+y276io6KkKisErLK++elYrDBHnDOE7qM
   nUb7YD6rLi0OopJCaQ0cuifSBHUikLdCWaOGSw4wNPiiflZ1LWH+2Brme
   w0+4fezM4yuARk+51YaVGsa+g2f92YM8+5cEHujlYlkPJJf/N3TO/+wKO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632109"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632109"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533592"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v12 10/16] KVM: x86/vmx: Check Arch LBR config when return perf capabilities
Date:   Tue, 17 May 2022 11:40:54 -0400
Message-Id: <20220517154100.29983-11-weijiang.yang@intel.com>
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

Two new bit fields(VM_EXIT_CLEAR_IA32_LBR_CTL, VM_ENTRY_LOAD_IA32_LBR_CTL)
are added to support guest Arch LBR. These two bits should be set in order
to make Arch LBR workable in both guest and host.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/vmx/capabilities.h |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a84d902952ce..ba991066f4a9 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -101,6 +101,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_CLEAR_IA32_LBR_CTL		0x04000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -114,6 +115,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_LBR_CTL		0x00200000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f14c4bef97e0..dc2cb8a16e76 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -404,6 +404,12 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
+static inline bool cpu_has_vmx_arch_lbr(void)
+{
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_LBR_CTL) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL);
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
@@ -420,6 +426,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
+		perf_cap &= ~PMU_CAP_LBR_FMT;
+
 	return perf_cap;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e442b30f1ca3..7238628acb90 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2564,7 +2564,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_CLEAR_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2588,7 +2589,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -6024,6 +6026,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	    vmentry_ctl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 		pr_err("PerfGlobCtl = 0x%016llx\n",
 		       vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL));
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    vmentry_ctl & VM_ENTRY_LOAD_IA32_LBR_CTL)
+		pr_err("ArchLBRCtl = 0x%016llx\n",
+		       vmcs_read64(GUEST_IA32_LBR_CTL));
 	if (vmentry_ctl & VM_ENTRY_LOAD_BNDCFGS)
 		pr_err("BndCfgS = 0x%016llx\n", vmcs_read64(GUEST_BNDCFGS));
 	pr_err("Interruptibility = %08x  ActivityState = %08x\n",
-- 
2.27.0

