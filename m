Return-Path: <kvm+bounces-57068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A3BB4A864
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D087443900
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1132D46A9;
	Tue,  9 Sep 2025 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UjBGN1Lw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCB824111D;
	Tue,  9 Sep 2025 09:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410799; cv=none; b=VelkHAF0wP7CqiD73bqf36DCerTWWUhggWLNfmTDKFbcmufNnFtnPuCwhH6+lAUA+L7vxCyIk3i1jKESvxTXh3Wl5m6rFDhw81MC91otvZCjfEzL8gX6vpHrv/w7CasLwxkfizSDku/Dt5yjfD6x2UlFz4zCdr3timdX7mk7t2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410799; c=relaxed/simple;
	bh=1WcXSx9dlRZCXMeRBkVIh2BDcgRzm0bg1BYvgxIT0VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFXTMd5ZekELlmqJbRsGM3HdzfQd8fvHYEh/VJuViPURlN/L9w3e4Qv2Rv4I1m8H1Qs49OylmW+gwnzOdVh9FaMn4Nnx9U0SIks/C0dscBQshShJV49DH6COuaAFWUsQxBE4gzQO9cs5mymn17KwDFI0Jd9Obtmjz6IUeIHyPX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UjBGN1Lw; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410798; x=1788946798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1WcXSx9dlRZCXMeRBkVIh2BDcgRzm0bg1BYvgxIT0VQ=;
  b=UjBGN1Lw+FUAOecoCP5YPrvgBnLZGjECcX6PW4SofAkdYw+qHsahb/zm
   jWcHjv03zEBqn+APLNQBqtNPn+wezyay429/4hbMfnTK5JZVanO0wZL7f
   Ciqq3fZqyDFfWqeCb48Sl0AeBwHZywwx6o/GHZ2heIc/JJ7YsgzpIVCZh
   r6iPypn1bW5GmvzOxhvcLZLdhpjllU+OIjBj57/CvvHP/dcAivmXBw78j
   m+0sTKog/uSNAyg9qOiDmwgn9wxzgCBbFcarGKuTyxgYyYgLdv25cjaSG
   i8NG+LlYJnHufM82/JEw0epg+gQD0hwpFOZL12cOUQX/v/MO5MJrE8VEn
   A==;
X-CSE-ConnectionGUID: fbkSHPy7QzmAzyZSFQmBbA==
X-CSE-MsgGUID: /ntMDBxaSaeCWDQ7S51zNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307193"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307193"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
X-CSE-ConnectionGUID: Xv/q8nkqScygUoUOKZeYxg==
X-CSE-MsgGUID: eAHu2pMERV2LgxTEIgKZdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207394"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:54 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 03/22] KVM: x86: Check XSS validity against guest CPUIDs
Date: Tue,  9 Sep 2025 02:39:34 -0700
Message-ID: <20250909093953.202028-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Maintain per-guest valid XSS bits and check XSS validity against them
rather than against KVM capabilities. This is to prevent bits that are
supported by KVM but not supported for a guest from being set.

Opportunistically return KVM_MSR_RET_UNSUPPORTED on IA32_XSS MSR accesses
if guest CPUID doesn't enumerate X86_FEATURE_XSAVES. Since
KVM_MSR_RET_UNSUPPORTED takes care of host_initiated cases, drop the
host_initiated check.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v14 - new, introduce guest_supported_xss in a separate patch (Xiaoyao)
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  7 +++----
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0d3cc0fc27af..b2983c830247 100644
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
+	u64 ia32_xss;
+	u64 guest_supported_xss;
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ad6cadf09930..46cf616663e6 100644
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
@@ -424,6 +435,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	vcpu->arch.guest_supported_xcr0 = cpuid_get_supported_xcr0(vcpu);
+	vcpu->arch.guest_supported_xss = cpuid_get_supported_xss(vcpu);
 
 	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47b60f275fd7..6c167117018c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4011,15 +4011,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 		vcpu->arch.ia32_xss = data;
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
-- 
2.47.3


