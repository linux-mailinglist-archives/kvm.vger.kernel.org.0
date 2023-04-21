Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D846EAFA7
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbjDUQvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbjDUQvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:51:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EFD15467;
        Fri, 21 Apr 2023 09:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095852; x=1713631852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P8MbqvwNSHVEvrq5IezQJzNUXAAb4/xulx5aS8UOL0A=;
  b=OtAgzQI4CpMUMZw//+X9x7UKz7pwGgG/+TpVP0MSYh0GqkfmFiWG68/Z
   TKF4YvOYaHFyAtfX7FniXLABAhwbHAS1DW5WNFYcairfEq8FoGyol8b8f
   AXuKJxBsAGYANb5PPzlEsMPso+fIgoId1bC/5G3DpbFqrSt0g/ocws3E1
   ER9cKhYUwa8aou4k4XvbtLiWXRMjpuiwyP/L+rpWmWCWw7hOJcLcnFC6q
   SBKeGy+C9I/vyxr3mEM9vaKxMNTdr4h/fNdw7Y6EyFF4UaStuskj+18ZJ
   t9ak0OTG7xg5fj1al/QYNy9cynKFsTc8QFSskCQRWJ/dC7bxrALai442q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787042"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787042"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817402"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817402"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
Date:   Fri, 21 Apr 2023 09:46:07 -0400
Message-Id: <20230421134615.62539-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
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

Add support for emulating read and write accesses to CET MSRs.
CET MSRs are universally "special" as they are either context switched
via dedicated VMCS fields or via XSAVES, i.e. no additional in-memory
tracking is needed, but emulated reads/writes are more expensive.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kernel/fpu/core.c |  1 +
 arch/x86/kvm/vmx/vmx.c     | 42 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h         | 30 +++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index f851558b673f..b4e28487882c 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -770,6 +770,7 @@ void fpregs_lock_and_load(void)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		fpregs_restore_userregs();
 }
+EXPORT_SYMBOL_GPL(fpregs_lock_and_load);
 
 #ifdef CONFIG_X86_DEBUG_FPU
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c872a5aafa50..ae816c1c7367 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1955,6 +1955,26 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	}
 }
 
+static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
+				  struct msr_data *msr)
+{
+	if (!kvm_cet_user_supported())
+		return false;
+
+	if (msr->host_initiated)
+		return true;
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+		return false;
+
+	if (msr->index == MSR_IA32_PL3_SSP &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+		return false;
+
+	return true;
+}
+
 /*
  * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
  * Returns 0 on success, non-0 otherwise.
@@ -2093,6 +2113,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL3_SSP:
+		if (!cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2405,6 +2431,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_U_CET:
+		if (!cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if ((data & GENMASK(9, 6)) ||
+		    is_noncanonical_address(data, vcpu))
+			return 1;
+		kvm_set_xsave_msr(msr_info);
+		break;
+	case MSR_IA32_PL3_SSP:
+		if (!cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if ((data & GENMASK(2, 0)) ||
+		    is_noncanonical_address(data, vcpu))
+			return 1;
+		kvm_set_xsave_msr(msr_info);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index daadd5330dae..52cd02a6bfec 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -2,6 +2,7 @@
 #ifndef ARCH_X86_KVM_X86_H
 #define ARCH_X86_KVM_X86_H
 
+#include <asm/fpu/api.h>
 #include <linux/kvm_host.h>
 #include <asm/fpu/xstate.h>
 #include <asm/mce.h>
@@ -370,6 +371,16 @@ static inline bool kvm_mpx_supported(void)
 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }
 
+/*
+ * Guest CET user mode states depend on host XSAVES/XRSTORS to save/restore
+ * when vCPU enter/exit user space. If host doesn't support CET user bit in
+ * XSS msr, then treat this case as KVM doesn't support CET user mode.
+ */
+static inline bool kvm_cet_user_supported(void)
+{
+	return !!(kvm_caps.supported_xss & XFEATURE_MASK_CET_USER);
+}
+
 extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
@@ -550,4 +561,23 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+/*
+ * We've already loaded guest MSRs in __msr_io() after check the MSR index.
+ * In case vcpu has been preempted, we need to disable preemption, check
+ * and reload the guest fpu states before read/write xsaves-managed MSRs.
+ */
+static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
+{
+	fpregs_lock_and_load();
+	rdmsrl(msr_info->index, msr_info->data);
+	fpregs_unlock();
+}
+
+static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
+{
+	fpregs_lock_and_load();
+	wrmsrl(msr_info->index, msr_info->data);
+	fpregs_unlock();
+}
+
 #endif
-- 
2.27.0

