Return-Path: <kvm+bounces-2408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8517F6D76
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:00:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29C91281C76
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90C41799B;
	Fri, 24 Nov 2023 07:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZiSVb/e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2503310E5;
	Thu, 23 Nov 2023 23:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812726; x=1732348726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jVspOmCjg1McK1b3XG5KaxcWZtyy3fHwRn/aLy9fqlo=;
  b=gZiSVb/eJLERdZxx0/7iO0dENOirLCU5mgdVBx+a0PIaIfMWODmg7LTh
   ThNp5b8Qw4/66zNwey7p20y3Rm5FP3wZG7ss9U9iN7P2yQVHSzDvgPjb5
   s82rQaOaoo1m2NJbfDGB3FmImBaSFxuXc+4wz18DMtWgUkMw2ECYg+qbe
   GAs8E5pI5VeM/Axyr/wybILa0XXAk6L29Yarxg7iokHB6ImKi2ok/MRFS
   +YcUB66TRl3amrZxrJx17BbKQCj40a7hJgy9xEy9OqKH8AAHpXi/Err6b
   3pgEZ1ikp4ol4hAFB21J6qyUJvVTyBBOlgkP9O6BOozccF8XOhuh7J0vt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872343"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872343"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629830"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629830"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:39 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v7 13/26] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date: Fri, 24 Nov 2023 00:53:17 -0500
Message-Id: <20231124055330.138870-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
due to XSS MSR modification.
CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
before allocate sufficient xsave buffer.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Opportunistically modify XSS write access logic as:
If XSAVES is not enabled in the guest CPUID, forbid setting IA32_XSS msr
to anything but 0, even if the write is host initiated.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
 arch/x86/kvm/x86.c              | 16 ++++++++++++----
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 499bd42e3a32..f536102f1eca 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -756,7 +756,6 @@ struct kvm_vcpu_arch {
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
-	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
 	u64 perf_capabilities;
@@ -812,6 +811,8 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	u64 ia32_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0351e311168a..1d9843b34196 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
+						 vcpu->arch.ia32_xss, true);
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
@@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
+	if (!best)
+		return 0;
+
+	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
+}
+
 static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 {
 	struct kvm_cpuid_entry2 *entry;
@@ -358,6 +370,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
+	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
 
 	kvm_update_pv_runtime(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7d4cc61bc55..649a100ffd25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3901,20 +3901,28 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_tsc_adjust_msr += adj;
 		}
 		break;
-	case MSR_IA32_XSS:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+	case MSR_IA32_XSS: {
+		/*
+		 * If KVM reported support of XSS MSR, even guest CPUID doesn't
+		 * support XSAVES, still allow userspace to set default value(0)
+		 * to this MSR.
+		 */
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
+		    !(msr_info->host_initiated && data == 0))
 			return 1;
 		/*
 		 * KVM supports exposing PT to the guest, but does not support
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~kvm_caps.supported_xss)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
+		if (vcpu->arch.ia32_xss == data)
+			break;
 		vcpu->arch.ia32_xss = data;
 		kvm_update_cpuid_runtime(vcpu);
 		break;
+	}
 	case MSR_SMI_COUNT:
 		if (!msr_info->host_initiated)
 			return 1;
-- 
2.27.0


