Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C593CB496
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 10:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238819AbhGPIjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 04:39:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:15690 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238388AbhGPIjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 04:39:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10046"; a="210687319"
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="210687319"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 01:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,244,1620716400"; 
   d="scan'208";a="460679863"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 16 Jul 2021 01:36:36 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 09/12] KVM: x86: Refine the matching and clearing logic for supported_xss
Date:   Fri, 16 Jul 2021 16:50:03 +0800
Message-Id: <1626425406-18582-10-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626425406-18582-1-git-send-email-weijiang.yang@intel.com>
References: <1626425406-18582-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

Refine the code path of the existing clearing of supported_xss in this way:
initialize the supported_xss with the filter of KVM_SUPPORTED_XSS mask and
update its value in a bit clear manner (rather than bit setting).

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 arch/x86/kvm/x86.c     | 6 +++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 11d15f11ff17..3815a32166a6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7326,9 +7326,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	supported_xss = 0;
-	if (!cpu_has_vmx_xsaves())
+	if (!cpu_has_vmx_xsaves()) {
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+		supported_xss = 0;
+	}
 
 	/* CPUID 0x80000001 and 0x7 (RDPID) */
 	if (!cpu_has_vmx_rdtscp()) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c225260c949e..2424d475a4d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -203,6 +203,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
+#define KVM_SUPPORTED_XSS     0
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -10654,8 +10656,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	r = ops->hardware_setup();
 	if (r != 0)
-- 
2.21.1

