Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E976FEC87
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjEKHPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbjEKHOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFF686B6;
        Thu, 11 May 2023 00:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789235; x=1715325235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ypN7RyU6EyWyfmcv9Dn9NuMR85kCawRsAVFQVfmjfeI=;
  b=QJP1hQ7YEDDM3+jea63L+5poI9k2DjAZ+3dtd29P/VO/j8j0prGOJhfT
   fq2Z2Lb3TGGS43Fk+qhMT23Hv5JSS51t+dkE6BPvI1XQzLUiTZydwFDb2
   Hz+aGZg617W/eB7gY5LZBL9jpcnzxTHqsv7b5ZKOilRA93HI7oRGovYEo
   UImwOz4jlNr9LGa50qAFHvJX8wcQtqQ4vAyv+U7JPALHMs88v9cixSwNQ
   E5yG+GdzXkuNUaJvDAgobm6NmG+F70x1FaobDEKEdBFkLhhv5MqZdp6vC
   aF7Gb7v2xOcfv00VbNXL67ivCo7Gzv9OdRmViZRznclV+izsqn08Af1HI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896658"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896658"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512379"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512379"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:25 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
Date:   Thu, 11 May 2023 00:08:49 -0400
Message-Id: <20230511040857.6094-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/vmx.c     | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c         | 20 ++++++++++++++++++++
 arch/x86/kvm/x86.h         | 31 +++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)

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
index c872a5aafa50..0ccaa467d7d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2093,6 +2093,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL3_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		kvm_get_xsave_msr(msr_info);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2405,6 +2411,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL3_SSP:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		if (msr_index == MSR_IA32_U_CET && (data & GENMASK(9, 6)))
+			return 1;
+		if (msr_index == MSR_IA32_PL3_SSP && (data & GENMASK(2, 0)))
+			return 1;
+		kvm_set_xsave_msr(msr_info);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6eec9143129..2e3a39c9297c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13630,6 +13630,26 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
+EXPORT_SYMBOL_GPL(kvm_cet_is_msr_accessible);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2ba7c7fc4846..93afa7631735 100644
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
@@ -546,5 +557,25 @@ int kvm_sev_es_mmio_read(struct kvm_vcpu *vcpu, gpa_t src, unsigned int bytes,
 int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
+bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr);
+
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
 
 #endif
-- 
2.27.0

