Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD393C21EA
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 11:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhGIJyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 05:54:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:54438 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhGIJyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 05:54:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="295316526"
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="295316526"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 02:51:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,226,1620716400"; 
   d="scan'208";a="498856350"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jul 2021 02:51:28 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 11/13] KVM: x86: Add XSAVE Support for Architectural LBR
Date:   Fri,  9 Jul 2021 18:05:09 +0800
Message-Id: <1625825111-6604-12-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

On processors supporting XSAVES and XRSTORS, Architectural LBR XSAVE
support is enumerated from CPUID.(EAX=0DH, ECX=1):ECX[bit 15].
The detailed sub-leaf for Arch LBR is enumerated in CPUID.(0DH, 0FH).

XSAVES provides a faster means than RDMSR for guest to read all LBRs.
When guest IA32_XSS[bit 15] is set, the Arch LBR state can be saved using
XSAVES and restored by XRSTORS with the appropriate RFBM.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 arch/x86/kvm/x86.c     | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 636c50b95038..3eccda710495 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7337,6 +7337,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (!cpu_has_vmx_arch_lbr()) {
+		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
+		supported_xss &= ~XFEATURE_MASK_LBR;
+	}
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2424d475a4d7..c09522c1f3ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -203,7 +203,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS     XFEATURE_MASK_LBR
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
-- 
2.21.1

