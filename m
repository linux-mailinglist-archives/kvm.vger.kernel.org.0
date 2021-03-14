Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFECF33A5F1
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 17:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhCNQBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 12:01:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:7174 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234015AbhCNQA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 12:00:56 -0400
IronPort-SDR: XJgfbQfToSSTzcUc7hdItZzb5+M/YTy+8AN3XlUQZ+3HhFI7cDIlHQ19S/aUygCZleEatN8l6b
 3mxSzGob0z2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="188360764"
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="188360764"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 09:00:56 -0700
IronPort-SDR: lc+ow3R5Kk4ix3YIjqkit245+MKgI0kYw6w9k1FMsmcM+Y9qwnxXYpp7rpBtv4fpEmGm3Pjw2v
 KG+/EZBkfOng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,248,1610438400"; 
   d="scan'208";a="439530741"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2021 09:00:54 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v4 11/11] KVM: x86: Add XSAVE Support for Architectural LBRs
Date:   Sun, 14 Mar 2021 23:52:24 +0800
Message-Id: <20210314155225.206661-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314155225.206661-1-like.xu@linux.intel.com>
References: <20210314155225.206661-1-like.xu@linux.intel.com>
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
index 14ed3251376f..659be0d708ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7295,8 +7295,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
-	if (!cpu_has_vmx_arch_lbr())
+	if (!cpu_has_vmx_arch_lbr()) {
 		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
+		supported_xss &= ~XFEATURE_MASK_LBR;
+	}
 
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 171605dcbd65..2e0935795502 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -205,7 +205,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS     XFEATURE_MASK_LBR
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
-- 
2.29.2

