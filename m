Return-Path: <kvm+bounces-54480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F7CB21B0D
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB2997AE7A1
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969A02E6130;
	Tue, 12 Aug 2025 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GA6eeptM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190672DBF5E;
	Tue, 12 Aug 2025 02:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967393; cv=none; b=JPR2LxGmOVBKaAmN4gDaOU5Sew+9CgyECAOwjoNxub016mWvMBKRkKvu8IknPZila7G3LawXB6LxYypQTlZ3e/mVMplhcMYyi5CHnvGsTrvY/jh/Qt4dvuURxcEeSl+GhR6mFWyn005X9PDtbgSrsds99ystN872nK2rMZOChW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967393; c=relaxed/simple;
	bh=2U24O1bgkAVdpdWyZ7+ZklS19rPq17HuAzXFKypFVJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5aQz9/8KmRW/vWYC5olhE9iPLpekOz4GaqirBbk5kndeYOe5pmagwJZJ9WL2osMU0PvNGnL+reI4pUySq+TTyfoZIXqFwt3TIekBa+ip64CpCG79IgTtirocWEMKvmV1FkgUWLQVs2WSV73/7AnOAtIy5LyiyriYa9iHZiZVq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GA6eeptM; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967392; x=1786503392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2U24O1bgkAVdpdWyZ7+ZklS19rPq17HuAzXFKypFVJo=;
  b=GA6eeptM5WfwigXqBEwznnQ8ZDy1AkT7qRpJym8gDc5p79ijyRm/xKI1
   fSTkAmRFko4znsb3tTDBIxpv63eRhGmnjiJd1Wob0uTiTuaBdMvORUiM+
   ZIGUDD+/jUFj30ONcEzeLg3pMKX4+Yq+j7E4VqCsdY3r+fQbTL2fINw9U
   G9pF9U6PV+tPY2jbHg5pqqLd3Mg3iqAvyIlx+5FpLfwn2Z1JTh0y9Dp1D
   pqH5kOxY4RhLn9fNvVhiCFm/JZwTJj2G9aJm/+MRzFA50wnO4pyS9ePaY
   O8ojYQGVxTUxDe/e9DEujtPgzw7RfUHqkNUDALJEzxICa4ZCcDg8TIe0I
   w==;
X-CSE-ConnectionGUID: SYvecsWHQ1Csfp3GkCcG7w==
X-CSE-MsgGUID: mv1ZcK+vSNWIlxiaqfKkOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100502"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100502"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:28 -0700
X-CSE-ConnectionGUID: fQ2aFdQISRCflwAs9t8PlA==
X-CSE-MsgGUID: Z4A/oE4oT16IoxKsvm0Dsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321265"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:28 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 08/24] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date: Mon, 11 Aug 2025 19:55:16 -0700
Message-ID: <20250812025606.74625-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
due to XSS MSR modification.
CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
before allocate sufficient xsave buffer.

Note, KVM does not yet support any XSS based features, i.e. supported_xss
is guaranteed to be zero at this time.

Opportunistically return KVM_MSR_RET_UNSUPPORTED if guest CPUID doesn't
enumerate it. Since KVM_MSR_RET_UNSUPPORTED takes care of host_initiated
cases, drop the host_initiated check.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
 arch/x86/kvm/x86.c              |  9 +++++----
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39b93642e7d2..1faf53df6259 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -811,7 +811,6 @@ struct kvm_vcpu_arch {
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
-	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
 	u64 perf_capabilities;
@@ -872,6 +871,8 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	u64 ia32_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 30fd18700972..85079caaf507 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -263,6 +263,17 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static u64 cpuid_get_supported_xss(struct kvm_vcpu *vcpu)
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
 static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
 						       struct kvm_cpuid_entry2 *entry,
 						       unsigned int x86_feature,
@@ -305,7 +316,8 @@ static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
+						 vcpu->arch.ia32_xss, true);
 }
 
 static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
@@ -424,6 +436,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
+	vcpu->arch.guest_supported_xss = cpuid_get_supported_xss(vcpu);
 
 	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0e440607e02..c91472d36717 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3998,16 +3998,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_XSS:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
-			return 1;
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+			return KVM_MSR_RET_UNSUPPORTED;
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
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 		break;
-- 
2.47.1


