Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6030352A729
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbiEQPmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350530AbiEQPll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7E341300;
        Tue, 17 May 2022 08:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802099; x=1684338099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lhC2usiG+1H5H2VssG+zdF+wUakdHjKd7UumL0U69io=;
  b=n6zojqx3ie9muSs0h+yTCWuxWWnml5Et35o5GzGlGtyhFEF2Pof8yCbk
   8NVBuBPuzlzTtmZC/0CMnfh629eEU+6DOv6wOZhAdQW6j78p1ubnaej+4
   BSB1T0QUVKQpLWqIjtgdUIqhi4qqPIbsJ7CfDWt4OxHxQzdDL+txRDKXb
   qp0M6OIRzyaDgAh/s9vsw37i3Yi+YrVEYWHwnshGfG/EmEoAtVSrJl6+r
   Ht6dXX9roiY0MK0OWpxYdRmo67doGdsDKtH49+xu81EqwW/zVEMOwIBPb
   eGLvw10PZ9vdAuKyYULhX54ZDHyexf9ESLiBNKJzfk1m3segHMr537ypV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632113"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632113"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533600"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 12/16] KVM: nVMX: Add necessary Arch LBR settings for nested VM
Date:   Tue, 17 May 2022 11:40:56 -0400
Message-Id: <20220517154100.29983-13-weijiang.yang@intel.com>
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

Arch LBR is not supported in nested VM now. This patch is to add
necessary settings to make it pass host KVM checks before L2 VM is
launched and also to avoid some warnings reported from L1.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c    | 7 +++++--
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/vmx/vmcs12.c    | 1 +
 arch/x86/kvm/vmx/vmcs12.h    | 3 ++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a6688663da4d..5028a8bfa4e1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6580,7 +6580,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
 #endif
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
-		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
+		VM_EXIT_CLEAR_IA32_LBR_CTL;
+
 	msrs->exit_ctls_high |=
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
@@ -6600,7 +6602,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		VM_ENTRY_IA32E_MODE |
 #endif
 		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
-		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_LBR_CTL;
+
 	msrs->entry_ctls_high |=
 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 41a9c7fbad45..f5499f391a8b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -183,6 +183,8 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 		return false;
 
 	if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL) {
+		if (is_guest_mode(vcpu))
+			return false;
 		return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
 		       guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
 	}
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 2251b60920f8..bcda664e4d26 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -65,6 +65,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(HOST_IA32_PAT, host_ia32_pat),
 	FIELD64(HOST_IA32_EFER, host_ia32_efer),
 	FIELD64(HOST_IA32_PERF_GLOBAL_CTRL, host_ia32_perf_global_ctrl),
+	FIELD64(GUEST_IA32_LBR_CTL, guest_lbr_ctl),
 	FIELD(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control),
 	FIELD(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control),
 	FIELD(EXCEPTION_BITMAP, exception_bitmap),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 746129ddd5ae..bf50227fe401 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -71,7 +71,7 @@ struct __packed vmcs12 {
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
 	u64 tsc_multiplier;
-	u64 padding64[1]; /* room for future expansion */
+	u64 guest_lbr_ctl;
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -254,6 +254,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(tsc_multiplier, 328);
+	CHECK_OFFSET(guest_lbr_ctl, 336);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
-- 
2.27.0

