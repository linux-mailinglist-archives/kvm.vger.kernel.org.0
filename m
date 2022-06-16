Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB9454DD76
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376429AbiFPItA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376282AbiFPIsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AF6140F4;
        Thu, 16 Jun 2022 01:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369262; x=1686905262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JCzwZqsQLcwAChNZSNEP8E57myWOINezNqkUJ+d22/E=;
  b=E7T2NxjN1uDnhZWqhF/IfGuj6ZqE2BJdleQZLFtSGc+Wn7trzG4Keees
   1qKyZpE0TYwql7WDDOKWxVYp+MSqPEejwWQxgxHk6WDNHh0RAajP1l15J
   gUbBVdxpy2fhz6d6fow7vxB+Itf6NGBTnXlr+ooqH3pcbABnsw/X9sXCJ
   1pqh/PXifnd37YPqYKJ/C8VkY+TYZq8lDmqgUac8swMe/Uq37Pq0S7Xb4
   P8HakVyZXt+kqyjFrYi9EX5ZRHPbQXn4XfFMYJmcuKWFsy7nF7DcnWZJ2
   pSBP6B6hIhWJqcKeJ9SoDa+i/s37EhbRgxwkldSItuuLGeJcrC+klzRJ5
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259055230"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259055230"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083163"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 12/19] KVM: VMX: Emulate reads and writes to CET MSRs
Date:   Thu, 16 Jun 2022 04:46:36 -0400
Message-Id: <20220616084643.19564-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
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

Add support for emulating read and write accesses to CET MSRs.
CET MSRs are universally "special" as they are either context
switched via dedicated VMCS fields or via XSAVES, i.e. no
additional in-memory tracking is needed, but emulated reads/writes
are more expensive.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e14e4c40007..d1f2ffa07576 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1767,6 +1767,26 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
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
@@ -1906,6 +1926,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2238,6 +2264,22 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 01493b7ae150..f6000e3fb195 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -2,6 +2,7 @@
 #ifndef ARCH_X86_KVM_X86_H
 #define ARCH_X86_KVM_X86_H
 
+#include <asm/fpu/api.h>
 #include <linux/kvm_host.h>
 #include <asm/mce.h>
 #include <asm/pvclock.h>
@@ -323,6 +324,16 @@ static inline bool kvm_mpx_supported(void)
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
@@ -491,4 +502,24 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+/*
+ * We've already loaded guest MSRs in __msr_io() when check the MSR index.
+ * In case vcpu has been preempted, we need to disable preemption, check
+ * and reload the guest fpu states before issue MSR read/write,
+ * fpu_lock_and_load() serves the purpose well.
+ */
+static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
+{
+	fpu_lock_and_load();
+	rdmsrl(msr_info->index, msr_info->data);
+	fpregs_unlock();
+}
+
+static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
+{
+	fpu_lock_and_load();
+	wrmsrl(msr_info->index, msr_info->data);
+	fpregs_unlock();
+}
+
 #endif
-- 
2.27.0

