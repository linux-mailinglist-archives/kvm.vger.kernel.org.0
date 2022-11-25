Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29586383D8
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiKYGKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiKYGKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:14 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0776222294;
        Thu, 24 Nov 2022 22:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356612; x=1700892612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XVMiy0FcFAZYiVIkFM8ypMBa329vVOR1LUMYPRJkpL4=;
  b=nCDcZx/L47hER35LaPRPdJFSeOs9IWi+1qk5mNnl/x0pxWunwTEZFhj+
   w1JFIxTX2rbhfOIF9wg4TuWY7s+FdnMauyyJ+gt2vaa0xik90ARllN6lU
   R4j4etuUFgOa4+qn92gIsUlshxr/dtSk5ozhtbs/SElYPx2IRFobMTlA9
   MJd7ze+iD2/4YeFgJM1JTupjxGT3yOvx7D5MhXzwQXqo7j2t8kuOqo0hh
   rYHbI+3wp+HZ7huUGgIG1VDk4BmeYnNqCqarGIleLDhzKbQP03BoNmh0j
   Ez21eXPGSamJmE/TDWRNrIcMV81RqJ3OZa+0vRcj4nneNY7d+vrzO6DAR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116827"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116827"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838496"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838496"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:06 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v2 10/15] KVM: x86/vmx: Check Arch LBR config when return perf capabilities
Date:   Thu, 24 Nov 2022 23:05:59 -0500
Message-Id: <20221125040604.5051-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/nested.c       |  8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.h          |  6 ++++--
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 8502c068202c..59f7c6baffd2 100644
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
index cd2ac9536c99..5affd2b5123e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -395,6 +395,11 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
+static inline bool cpu_has_vmx_arch_lbr(void)
+{
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL;
+}
+
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b28be793de29..59bdd9873fb5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2360,6 +2360,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		if (guest_efer != host_efer)
 			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
 	}
+
+	if (cpu_has_vmx_arch_lbr())
+		exec_control &= ~VM_ENTRY_LOAD_IA32_LBR_CTL;
+
 	vm_entry_controls_set(vmx, exec_control);
 
 	/*
@@ -2374,6 +2378,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
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
index 2ab4c33b5008..359da38a19a1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2599,6 +2599,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_IA32_LBR_CTL, 		VM_EXIT_CLEAR_IA32_LBR_CTL },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -4794,6 +4795,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vpid_sync_context(vmx->vpid);
 
 	vmx_update_fb_clear_dis(vcpu, vmx);
+
+	if (!init_event && cpu_has_vmx_arch_lbr())
+		vmcs_write64(GUEST_IA32_LBR_CTL, 0);
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
@@ -6191,6 +6195,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -7700,6 +7708,9 @@ static u64 vmx_get_perf_capabilities(void)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_ARCH_LBR) && !cpu_has_vmx_arch_lbr())
+		perf_cap &= ~PMU_CAP_LBR_FMT;
+
 	return perf_cap;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..f68c8a53a248 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -493,7 +493,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_IA32_LBR_CTL)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -515,7 +516,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_CLEAR_IA32_LBR_CTL)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.27.0

