Return-Path: <kvm+bounces-38972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F40BFA415F9
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 08:09:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C6B63A99E4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 07:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D210D18E377;
	Mon, 24 Feb 2025 07:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eVli4zsi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126291A072C;
	Mon, 24 Feb 2025 07:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740380991; cv=none; b=L0mG/hsSv3snpj9MJwtz7VIm1eY5TOQwiCNO9wgNYHAAohd50lVguQVlGj7zr/CiIfRja99kvkQW3R+5hd8unOuF5WNQB8L+R1H2VNV4BM7NaeZ2FkuCCQgsilJ/GNZ1a+D2Mlr2DXt8y/xZCKdEcZoMEJpADik5xIdS5Ka3fYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740380991; c=relaxed/simple;
	bh=XUC1UkF9PtibPdWLdRDQzE8kWmuC6oCyYfcuGn1Rg5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pw6bLKWn+Bfn7MHK7YTukHPEu9+z1O7tLew0eaMU9UKRduSB9YBVQSLodm0/SPONgif5sxqAkWz2eqfCGAiSx3UMR+vMldF9/612TeivV7PmYmqO6DaMrvrl72mKdQfbifJruqP/ekW1qo1YVhxUK61I3DmSjNodnrSa9cQAMFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eVli4zsi; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740380989; x=1771916989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XUC1UkF9PtibPdWLdRDQzE8kWmuC6oCyYfcuGn1Rg5Y=;
  b=eVli4zsi7SK0nIbTC4pvjM+QCyPSV2nrCChsJLY2rRPQYOEYw4p6OIJ4
   ePElTssFg08RR9P921fPV4zRRM+JWkppFWUi6Qo6CH8CZvMtlADkrpF5m
   /1BZtjLUWmCmI2DroTo9cxK8GUxan2arF4iQRFFiCxzEV+f72gmqqBEWO
   4Ol2a5EMwQ/LAkg2+G5TeEFt7iXkgm4+gVNh2ho/qEZgI5AfOAcNx1KaE
   A+a16H8gtSAYSL1aw2mKOQN62EtjZvNS15Rkslp1YrcSBtvfOhiYn8h11
   9EseFZLr5b5QwhYzu3g0sPzh9uzqUhFxMcvLDdcKUcj06xKd71Zv+9Tfj
   Q==;
X-CSE-ConnectionGUID: +YnJobzGQbu1qCg9lMPJTQ==
X-CSE-MsgGUID: NhbB/1Q/SFKNDh18jrRLTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="52117295"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="52117295"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:09:48 -0800
X-CSE-ConnectionGUID: 2XeGKsmEQWuIi6HZTF31Yg==
X-CSE-MsgGUID: qSoedMXWRd6KpW7p2bbz8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="120951840"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:09:47 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kevin.tian@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/3] KVM: x86: Introduce supported_quirks for platform-specific valid quirks
Date: Mon, 24 Feb 2025 15:08:32 +0800
Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224070716.31360-1-yan.y.zhao@intel.com>
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce supported_quirks in kvm_caps to store platform-specific valid
quirks.

Rename KVM_X86_VALID_QUIRKS to KVM_X86_VALID_QUIRKS_COMMON, representing
valid quirks common to all x86 platforms. Initialize
kvm_caps.supported_quirks to KVM_X86_VALID_QUIRKS_COMMON in the common
vendor initializer kvm_x86_vendor_init().

Use kvm_caps.supported_quirks to respond to user queries about valid quirks
and to mask out unsupported quirks provided by the user.

In kvm_check_has_quirk(), in additional to check if a quirk is not
explicitly disabled by the user, also verify if the quirk is supported by
the platform. This ensures KVM does not treat a quirk as enabled if it's
not explicitly disabled by the user but is outside the platform supported
mask.

This is a preparation for introducing quirks specific to certain platforms,
e.g., quirks present only on Intel platforms and not on AMD.

No functional changes intended.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/x86.c              |  5 +++--
 arch/x86/kvm/x86.h              | 12 +++++++-----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 089cf2c82414..8d15e604613b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2409,7 +2409,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 #define KVM_CLOCK_VALID_FLAGS						\
 	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
 
-#define KVM_X86_VALID_QUIRKS			\
+#define KVM_X86_VALID_QUIRKS_COMMON		\
 	(KVM_X86_QUIRK_LINT0_REENABLED |	\
 	 KVM_X86_QUIRK_CD_NW_CLEARED |		\
 	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3078e09fc841..4f1b73620c6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
 		break;
 	case KVM_CAP_DISABLE_QUIRKS2:
-		r = KVM_X86_VALID_QUIRKS;
+		r = kvm_caps.supported_quirks;
 		break;
 	case KVM_CAP_X86_NOTIFY_VMEXIT:
 		r = kvm_caps.has_notify_vmexit;
@@ -6521,7 +6521,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	switch (cap->cap) {
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = -EINVAL;
-		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
+		if (cap->args[0] & ~kvm_caps.supported_quirks)
 			break;
 		fallthrough;
 	case KVM_CAP_DISABLE_QUIRKS:
@@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
+	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS_COMMON;
 
 	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8ce6da98b5a2..772d5c320be1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -34,6 +34,7 @@ struct kvm_caps {
 	u64 supported_xcr0;
 	u64 supported_xss;
 	u64 supported_perf_cap;
+	u64 supported_quirks;
 };
 
 struct kvm_host_values {
@@ -354,11 +355,6 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu,
 	return kvm_register_write_raw(vcpu, reg, val);
 }
 
-static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
-{
-	return !(kvm->arch.disabled_quirks & quirk);
-}
-
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 u64 get_kvmclock_ns(struct kvm *kvm);
@@ -394,6 +390,12 @@ extern struct kvm_host_values kvm_host;
 
 extern bool enable_pmu;
 
+static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
+{
+	return (kvm_caps.supported_quirks & quirk) &&
+	       !(kvm->arch.disabled_quirks & quirk);
+}
+
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
  * features for which the current process doesn't (yet) have permission to use.
-- 
2.43.2


