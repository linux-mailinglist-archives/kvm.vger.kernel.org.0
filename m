Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56BF75BE6A
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjGUGJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjGUGI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DBE19B3;
        Thu, 20 Jul 2023 23:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919738; x=1721455738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nqMR9J+OHoyRkGbaLaT7762FsalTwr5apnr/WAlbq54=;
  b=D/NJzhLhOiHaUwUmuSqFSaPo42d86HbCegCmPy2YA3JkhdmhZnPdXc4r
   WnyaebliVPLiw9fYpaV8kauUBtxkEDh36PKIInNj9VACYZIPgT8LZjywh
   7eGri9exPcRvCUiAycAFhnfuBZ7X9uMDYX4iUl9oY9dDy5T+VunH4cuHu
   Ps8FkZL88SJpPz81Qpb7RZ+QFIPgseNOQG9k7dBMHqETlYznpIq2XqFVk
   rCawOSoBI77RyQXoOtHpmoc0RU3f/YHFZ+EiH8e6Lcbx9QO6tht1FQWST
   wZteWJE1ZVv9HcZhg0zvtgTOUNAFOlvsv/YcBgSaJ3IUPdvZuuBJ0FToD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547568"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547568"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721985"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721985"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 16/20] KVM:x86: Optimize CET supervisor SSP save/reload
Date:   Thu, 20 Jul 2023 23:03:48 -0400
Message-Id: <20230721030352.72414-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make PL{0,1,2}_SSP as write-intercepted to detect whether
guest is using these MSRs. Disable intercept to the MSRs
if they're written with non-zero values. KVM does save/
reload for the MSRs only if they're used by guest.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 34 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c              | 15 ++++++++++-----
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 69cbc9d9b277..c50b555234fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -748,6 +748,7 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 	bool xsaves_enabled;
 	bool xfd_no_write_intercept;
+	bool cet_sss_active;
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cba24acf1a7a..3eb4fe9c9ab6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2155,6 +2155,18 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
+static void vmx_disable_write_intercept_sss_msr(struct kvm_vcpu *vcpu)
+{
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK)) {
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+					  MSR_TYPE_RW, false);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+					  MSR_TYPE_RW, false);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+					  MSR_TYPE_RW, false);
+	}
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2427,7 +2439,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
 #define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
-		return kvm_set_msr_common(vcpu, msr_info);
+		if (kvm_set_msr_common(vcpu, msr_info))
+			return 1;
+		/*
+		 * Write to the base SSP MSRs should happen ahead of toggling
+		 * of IA32_S_CET.SH_STK_EN bit.
+		 */
+		if (msr_index != MSR_IA32_PL3_SSP && data) {
+			vmx_disable_write_intercept_sss_msr(vcpu);
+			wrmsrl(msr_index, data);
+		}
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_S_CET:
@@ -7774,12 +7795,17 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 					  MSR_TYPE_RW, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
 					  MSR_TYPE_RW, false);
+		/*
+		 * Supervisor shadow stack MSRs are intercepted until
+		 * they're written by guest, this is designed to
+		 * optimize the save/restore overhead.
+		 */
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
-					  MSR_TYPE_RW, false);
+					  MSR_TYPE_R, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
-					  MSR_TYPE_RW, false);
+					  MSR_TYPE_R, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
-					  MSR_TYPE_RW, false);
+					  MSR_TYPE_R, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
 					  MSR_TYPE_RW, false);
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e200f22cdaad..49049454caf4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4051,6 +4051,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
 		    msr == MSR_IA32_PL2_SSP) {
 			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
+			if (!vcpu->arch.cet_sss_active && data)
+				vcpu->arch.cet_sss_active = true;
 		} else if (msr == MSR_IA32_PL3_SSP) {
 			kvm_set_xsave_msr(msr_info);
 		}
@@ -11252,7 +11254,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
-	kvm_reload_cet_supervisor_ssp(vcpu);
+	if (vcpu->arch.cet_sss_active)
+		kvm_reload_cet_supervisor_ssp(vcpu);
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
@@ -11341,7 +11344,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	r = vcpu_run(vcpu);
 
 out:
-	kvm_save_cet_supervisor_ssp(vcpu);
+	if (vcpu->arch.cet_sss_active)
+		kvm_save_cet_supervisor_ssp(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
@@ -12430,15 +12434,16 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
-
-	kvm_reload_cet_supervisor_ssp(vcpu);
+	if (vcpu->arch.cet_sss_active)
+		kvm_reload_cet_supervisor_ssp(vcpu);
 
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
 void kvm_arch_sched_out(struct kvm_vcpu *vcpu, int cpu)
 {
-	kvm_save_cet_supervisor_ssp(vcpu);
+	if (vcpu->arch.cet_sss_active)
+		kvm_save_cet_supervisor_ssp(vcpu);
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
-- 
2.27.0

