Return-Path: <kvm+bounces-52163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0660CB01DC5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 514033AAF66
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FA92E718B;
	Fri, 11 Jul 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VRLfRBpG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDAF2E62D3;
	Fri, 11 Jul 2025 13:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240872; cv=none; b=ByX6B3IWfbUSntGb26+DOCa2YTJG91frx0UHka0U9DnA/8nflJ96rKqSAZNQUfMmfE8AP0rPZCO+y+T9nULjU0drMyv1ajpXvVDuBHge1TYbA17eUaGpbAwn2+8zvcldu0G0PlnP8mrH0Ev2RmcdQmDwJ3TGOSC3lCq4qDzUNmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240872; c=relaxed/simple;
	bh=x092r1fSBa4wry6ULv5QvHdrP4+so9lToB70GqLJWdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dpm2TO/1CSQGR5rZ5fPG8YHrJqpket3W3/Ee93dnPzBfur8i7xP0Q3v5P9GLva1iD6eBctGBbCGUzOmBzelLNABB1JDnGezpI2PlaL8dMsHmAPEoPondABrj6tkGpcEDM+4pnN88O2zTvCWdQ3VbTFjp0rxfOVdrlX16m2NS2g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VRLfRBpG; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752240871; x=1783776871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x092r1fSBa4wry6ULv5QvHdrP4+so9lToB70GqLJWdY=;
  b=VRLfRBpGu3kAR+TbTYLRW19bjBuHATl3PRomjvTkeQGAxtYjOzBtpQOc
   wmxYSR2jN9WTCM4VTs2qQeEW8LW8aDF0RYqjazEtS4UAKVkceLs1wSt8w
   JBuY778uo5H0emdEFF2iCOSAZ6xuIeJPSctOjOouTdg7IgUaAvaIjptbm
   gUUTXvDNLihVFnikIU7gQZ+hJoaR6ClSqOo4y3nz5QpAZANWKYBymGuS8
   lYislGbN/TBfR+ODs+Mzp3Koz5Leq6HUTuMSS6HEs/eqZ9wYC37m5+13i
   N2x7nS3vjtNP1gIF710oMkjS7Gj24r33UMtrtOPru9VxOkZLSuXWOsNv1
   g==;
X-CSE-ConnectionGUID: 27+XAylsT1au5ZV0WJC2jw==
X-CSE-MsgGUID: o0mFUdvDSvmKuYK90GkNhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="65603412"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="65603412"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 06:34:30 -0700
X-CSE-ConnectionGUID: 83wPkaMNSOWVzz6LEjItFA==
X-CSE-MsgGUID: 7q3m3/5PSkewfH07OzvUbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="187349234"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 11 Jul 2025 06:34:26 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v2 2/3] KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
Date: Fri, 11 Jul 2025 21:26:19 +0800
Message-ID: <20250711132620.262334-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250711132620.262334-1-xiaoyao.li@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are definitions of TD attributes bits inside asm/shared/tdx.h as
TDX_ATTR_*.

Remove KVM's definitions and use the ones in asm/shared/tdx.h

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c      | 4 ++--
 arch/x86/kvm/vmx/tdx_arch.h | 6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c539c2e6109f..efb7d589b672 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -62,7 +62,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
 }
 
-#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
+#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
 {
@@ -700,7 +700,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.l1_tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
 
 	vcpu->arch.guest_state_protected =
-		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_ATTR_DEBUG);
 
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index a30e880849e3..350143b9b145 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -75,12 +75,6 @@ struct tdx_cpuid_value {
 	u32 edx;
 } __packed;
 
-#define TDX_TD_ATTR_DEBUG		BIT_ULL(0)
-#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
-#define TDX_TD_ATTR_PKS			BIT_ULL(30)
-#define TDX_TD_ATTR_KL			BIT_ULL(31)
-#define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
-
 #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
 #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
 /*
-- 
2.43.0


