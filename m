Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664D5377DE2
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhEJISL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:18:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:42752 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230116AbhEJISE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:18:04 -0400
IronPort-SDR: 04Ark2m64XjzLe4AWhepKrU9H9I8lu0tRziwNw6JVcPyu+EeP/f/BsAmTnJT7o+rFNa6x/NtMZ
 EpSsWJWV0y1w==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178727878"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178727878"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:16:41 -0700
IronPort-SDR: 7MqKocnl1LosT3Rmn+rr1Q+ilRGKGv9oHVD9wTGhS1fivH/aLP9U1LeWCs12aJLg+ptQQ9CklG
 qD3OsXAkM7lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="408250969"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2021 01:16:39 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v4 10/10] KVM: x86: Add XSAVE Support for Architectural LBRs
Date:   Mon, 10 May 2021 16:15:34 +0800
Message-Id: <20210510081535.94184-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510081535.94184-1-like.xu@linux.intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On processors whose XSAVE feature set supports XSAVES and XRSTORS,
the availability of support for Architectural LBR configuration state save
and restore can be determined from CPUID.(EAX=0DH, ECX=1):EDX:ECX[bit 15].
The detailed leaf for Arch LBRs is enumerated in CPUID.(EAX=0DH, ECX=0FH).

XSAVES provides a faster means than RDMSR for guest to read all LBRs.
When guest IA32_XSS[bit 15] is set, the Arch LBRs state can be saved using
XSAVES and restored by XRSTORS with the appropriate RFBM.

If the KVM fails to pass-through the LBR msrs to the guest, the LBR msrs
will be reset to prevent the leakage of host records via XSAVES. In this
case, the guest results may be inaccurate as the legacy LBR.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/vmx/vmx.c       | 4 +++-
 arch/x86/kvm/x86.c           | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9199d3974d57..7666292094ec 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -772,6 +772,8 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 	return;
 
 warn:
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
 	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
 		vcpu->vcpu_id);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d080bf163565..9f610da71649 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7370,8 +7370,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
-	if (!cpu_has_vmx_arch_lbr())
+	if (!cpu_has_vmx_arch_lbr()) {
 		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
+		supported_xss &= ~XFEATURE_MASK_LBR;
+	}
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a32bea2277e..7db24f287268 100644
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
2.31.1

