Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193863C21E0
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 11:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhGIJyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 05:54:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:54437 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhGIJyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 05:54:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="295316512"
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="295316512"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 02:51:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="498856312"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jul 2021 02:51:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
Date:   Fri,  9 Jul 2021 18:05:04 +0800
Message-Id: <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
and reload it after vm-exit.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a79ac1757af..0d714e76e2d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1397,6 +1397,26 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 		decache_tsc_multiplier(vmx);
 }
 
+static inline unsigned long get_lbrctlmsr(void)
+{
+	unsigned long lbrctlmsr = 0;
+
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR))
+		return 0;
+
+	rdmsrl(MSR_ARCH_LBR_CTL, lbrctlmsr);
+
+	return lbrctlmsr;
+}
+
+static inline void update_lbrctlmsr(unsigned long lbrctlmsr)
+{
+	if (!static_cpu_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	wrmsrl(MSR_ARCH_LBR_CTL, lbrctlmsr);
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -1410,6 +1430,7 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vmx_vcpu_pi_load(vcpu, cpu);
 
 	vmx->host_debugctlmsr = get_debugctlmsr();
+	vmx->host_lbrctlmsr = get_lbrctlmsr();
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -6797,6 +6818,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
 	if (vmx->host_debugctlmsr)
 		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vmx->host_lbrctlmsr)
+		update_lbrctlmsr(vmx->host_lbrctlmsr);
 
 #ifndef CONFIG_X86_64
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cc362e2d3eaa..69e243fea23d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -328,6 +328,7 @@ struct vcpu_vmx {
 	u64 current_tsc_ratio;
 
 	unsigned long host_debugctlmsr;
+	unsigned long host_lbrctlmsr;
 
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
-- 
2.21.1

