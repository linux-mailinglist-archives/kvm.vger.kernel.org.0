Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E430E32C64D
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355424AbhCDA2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:43939 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242937AbhCCORw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:17:52 -0500
IronPort-SDR: j1QjgAT8Iqae2ikARb887Z9Fydk9cHuyIqITX3KrhsZQNSdyfLkn5HtTF9TdeDnRqSmjyTRKwQ
 Ya54bTTwD4SA==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="183819036"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="183819036"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 06:05:49 -0800
IronPort-SDR: ecxHEOlHBFfFnjozlZD6z1qWXR9uIlSWO0SQaPqDmno39TC+Nj2JcvHWNMQea+FxTAahHPXyve
 TPTWlrK6zexw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399729490"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 06:05:45 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 9/9] KVM: x86: Add XSAVE Support for Architectural LBRs
Date:   Wed,  3 Mar 2021 21:57:55 +0800
Message-Id: <20210303135756.1546253-10-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210303135756.1546253-1-like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
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
 arch/x86/kvm/vmx/vmx.c       | 2 ++
 arch/x86/kvm/x86.c           | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 48a817be60ab..08114f70c496 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -768,6 +768,8 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 	return;
 
 warn:
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
 	pr_warn_ratelimited("kvm: vcpu-%d: fail to passthrough LBR.\n",
 		vcpu->vcpu_id);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 034708a3df20..ec4593e0ee6d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7268,6 +7268,8 @@ static __init void vmx_set_cpu_caps(void)
 	supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+	else if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		supported_xss |= XFEATURE_MASK_LBR;
 
 	/* CPUID 0x80000001 */
 	if (!cpu_has_vmx_rdtscp())
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d773836ceb7a..bca2e318ff24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10433,6 +10433,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
+	else
+		supported_xss &= host_xss;
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
-- 
2.29.2

