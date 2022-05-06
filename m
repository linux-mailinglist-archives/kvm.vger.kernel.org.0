Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9653851CFA4
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388790AbiEFDhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388669AbiEFDhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F264712;
        Thu,  5 May 2022 20:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808015; x=1683344015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gX9uB5gznaE7rsHQRo+mk7T0qksJuhu0tdrno+/vm2o=;
  b=CbQazf3lRZXKiGKcGUiSlgFT/DkjPTXHwifUY2OlbI30u6W2SC8FYOEH
   osUDk30fA22WQpSEvYpDFAzaODJYLfJqfQiR42ks8tBHNUdcT5Kaax3iK
   BBv0GDiMVJLw3I+Wth7UYGVHNsh7zbLKVtXixC4h3F0Yvqc9GWzijNtzQ
   IAF9b71WtTID/jRq3jQTqV2UmoD7tK37vWLMN2IZdpkjBYe+4O/4x6zT5
   PHIoiJJzZzeozy7c+QHNfUwl5Sgwqkp2GDS5aVm58My/+D7Jwwh5lfjNz
   UumWnhSbMRRNcSA4JAJLvnuOQEmTK3QxY3ZtSxTInHXYJnBdWUyxXHpYT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241442"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241442"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745197"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:34 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 11/16] KVM: x86/vmx: Check Arch LBR config when return perf capabilities
Date:   Thu,  5 May 2022 23:33:00 -0400
Message-Id: <20220506033305.5135-12-weijiang.yang@intel.com>
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

Two new bit fields(VM_EXIT_CLEAR_IA32_LBR_CTL, VM_ENTRY_LOAD_IA32_LBR_CTL)
are added to support guest Arch LBR. These two bits should be set in order
to make Arch LBR workable in both guest and host.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/vmx/capabilities.h |  8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 10 ++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index ea3be961cc8e..d9b1dffc4638 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -95,6 +95,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_CLEAR_IA32_LBR_CTL		0x04000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -108,6 +109,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_LBR_CTL		0x00200000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3f430e218375..68fbb76ba439 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -385,6 +385,12 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 	return pt_mode == PT_MODE_HOST_GUEST;
 }
 
+static inline bool cpu_has_vmx_arch_lbr(void)
+{
+	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_LBR_CTL) &&
+		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL);
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = 0;
@@ -396,6 +402,8 @@ static inline u64 vmx_get_perf_capabilities(void)
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
 	perf_cap &= PMU_CAP_LBR_FMT;
+	if (boot_cpu_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
+		perf_cap &= ~PMU_CAP_LBR_FMT;
 
 	/*
 	 * Since counters are virtualized, KVM would support full
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 97b123b18e57..e6384ef1d115 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2532,7 +2532,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_CLEAR_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2556,7 +2557,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -5930,6 +5932,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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

