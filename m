Return-Path: <kvm+bounces-55277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC66B2FAB9
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 961B33B1CE4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EBC33A003;
	Thu, 21 Aug 2025 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOwIqL3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4145B3376AD;
	Thu, 21 Aug 2025 13:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783122; cv=none; b=RgZzh3flDZsP2wiZXIMLUi1WiV08KlveXPwnQtWXZx9g/lzADkxOXAbgGvFRlN9eMejtBefrffvcR8KdQXHpR4B7xycMlN1xIYVTGomO7uPGf+yYaNP3uKJ3ZSXAoKWYxwAOZazKvl4nRp+Wev9T8DEHtVxMFe35Bq6ty5PdaL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783122; c=relaxed/simple;
	bh=LnkI/taDh9G8rvGYlet88D/zmHnRXiBO23qSPITbDhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6eonJS4lc1J+TSHghjSMrOjL6Nug5DvJGsP5HSaHWRmy3kGzYxwyq0rXqD+k65wooEJxTE0YMs6hkDO0wc7/EZLLGvieJ0zz0TYZwDBp/75vnK8CItWfmrmDDS4fJCkoNrt5+qgmRUkpvCgnwqV1BJMOtvmh88q5F87n0nc8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOwIqL3U; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783120; x=1787319120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LnkI/taDh9G8rvGYlet88D/zmHnRXiBO23qSPITbDhg=;
  b=lOwIqL3UbdKMP/Z3HOD8ChyJQrxL0uKNUuUZBelnMUXOE54kbvy/NlSv
   aZlFQHuLxw8N2pBQ+r2y3kqUSoGNoERgbIYKw3xNnfUgod4cDo+Qiu8n8
   GMbPQyLnFXzbUU2LqBDbXbFHrtRKyThvCT9ORL4x6kHnDY+RkmaYPcZdF
   Q3liZSiIdjqLJGufZV1d65+fps6QdlhmPlyX+UyA3VNDu82cLAtHZT/Sw
   dA5iwQvNDYKYasonQgjN45js/Jrlvrxii6qEKSBZWZTbqdm5MiCnS8arS
   Vrwv1zpbnoBaIaHBBWnlyigzO7rNbbPSwKZmfuARAAwkrbJ56/l23oFgF
   g==;
X-CSE-ConnectionGUID: NTCjBKdPTTCvkDygmo/kow==
X-CSE-MsgGUID: 6d2J96MwQ6S2fmgwuUVsCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446065"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446065"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:00 -0700
X-CSE-ConnectionGUID: u2kW4UvfR2iJu4COB3s6ZQ==
X-CSE-MsgGUID: DIFumWKWR/WmpNzYvS4F1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285392"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:40 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: [PATCH v13 03/21] KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
Date: Thu, 21 Aug 2025 06:30:37 -0700
Message-ID: <20250821133132.72322-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
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
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
 arch/x86/kvm/x86.c              |  9 +++++----
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0d3cc0fc27af..b7f82a421718 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -815,7 +815,6 @@ struct kvm_vcpu_arch {
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
-	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
 	u64 perf_capabilities;
@@ -876,6 +875,8 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	u64 ia32_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ad6cadf09930..b5f87254ced7 100644
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
index 569583943779..75b7a29721bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4011,16 +4011,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.47.3


