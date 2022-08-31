Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB635A8AEB
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiIABh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiIABhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EB815C796;
        Wed, 31 Aug 2022 18:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996229; x=1693532229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o2gn43gdnbmtorgWmrQg5Z/x0LtihyM4zIg044RVPCo=;
  b=Dzqz3LrqnaNpli0VAUiPaYj1CZzwqW4W1+WA4xfQjBz+1Ry2+62jYoMe
   Aw0nO3quzZj/L0ZL1+dK1QaC3bEFUIygGyZSTID5WTbhCbGhucsp6OsRf
   8pYB9NvfcA2dYcDI+KadYFDJ2OEmVjrWjOID8Kv5dPIzYccMX8sGUjy1V
   LFfV7XyvyK10OCcatwivzwQVNjtNYaJTZXji6D1kDZtmwVxBVSX2p9/Ur
   O7c+FczdwIsRxc9iUlV4GKBuiMUDgAO/tAd9Bv9WEYu9jFM5uhcOigaIh
   CSxfFsDd7dQDGUloEm2Ywh344ShNRaZc7v/EWENYA5u0JtdTesXYshAma
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735095"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735095"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626021"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:02 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] KVM: x86/vmx: Check Arch LBR config when return perf capabilities
Date:   Wed, 31 Aug 2022 18:34:33 -0400
Message-Id: <20220831223438.413090-11-weijiang.yang@intel.com>
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

Two new bit fields(VM_EXIT_CLEAR_IA32_LBR_CTL, VM_ENTRY_LOAD_IA32_LBR_CTL)
are added to support guest Arch LBR. These two bits should be set in order
to make Arch LBR workable in both guest and host. Since we don't support
Arch LBR in nested guest, clear the two bits before run L2 VM.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h      |  2 ++
 arch/x86/kvm/vmx/capabilities.h |  8 ++++++++
 arch/x86/kvm/vmx/nested.c       |  8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++++++++--
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 50c6f36daaea..e8781df8cc2e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -102,6 +102,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_CLEAR_IA32_LBR_CTL		0x04000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -115,6 +116,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_LBR_CTL		0x00200000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..b7147698ad82 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -401,6 +401,11 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
+static inline bool cpu_has_vmx_arch_lbr(void)
+{
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL;
+}
+
 static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = PMU_CAP_FW_WRITES;
@@ -420,6 +425,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
+		perf_cap &= ~PMU_CAP_LBR_FMT;
+
 	return perf_cap;
 }
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ddd4367d4826..d4b05354e7ab 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2338,6 +2338,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		if (guest_efer != host_efer)
 			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
 	}
+
+	if (cpu_has_vmx_arch_lbr())
+		exec_control &= ~VM_ENTRY_LOAD_IA32_LBR_CTL;
+
 	vm_entry_controls_set(vmx, exec_control);
 
 	/*
@@ -2352,6 +2356,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
 	else
 		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
+
+	if (cpu_has_vmx_arch_lbr())
+		exec_control &= ~VM_EXIT_CLEAR_IA32_LBR_CTL;
+
 	vm_exit_controls_set(vmx, exec_control);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32e41bd217e3..cdf65cdcb45a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2559,6 +2559,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_IA32_LBR_CTL,		VM_EXIT_CLEAR_IA32_LBR_CTL },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -2679,7 +2680,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_CLEAR_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2703,7 +2705,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_IA32_LBR_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -4803,6 +4806,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vpid_sync_context(vmx->vpid);
 
 	vmx_update_fb_clear_dis(vcpu, vmx);
+
+	if (!init_event) {
+		if (cpu_has_vmx_arch_lbr())
+			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	}
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
@@ -6198,6 +6206,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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

