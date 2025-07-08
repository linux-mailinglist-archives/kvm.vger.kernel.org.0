Return-Path: <kvm+bounces-51746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F206AFC520
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 173833A1408
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F09B2BDC06;
	Tue,  8 Jul 2025 08:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L/V/K1pm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0EC2BD590;
	Tue,  8 Jul 2025 08:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962278; cv=none; b=j4T5r10rZ2J+gXcYRAsZ1sDI4tv5QMX7TB+ANaovkYCW6Qy2gTYFDXZvE9QYbTj9Qdgvezg9oGtXrMI3YNLDkWlqs4kZuFpqDux3l0sWOrIyNiPoaRjT8jObaui+dA+ouZPnm4sf5gbcPPFW9czuB29+CRp8puEAFKUzZOKYBR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962278; c=relaxed/simple;
	bh=ZB9nCtjrRzq0q0am81PMOUb3zQxW12guoujcDogZtQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aumv7MapxIQwwLjjLsFrNhxxBva9fsd6UI37B5OAjsl39dy6jeJqUVnQyVqzu5dB4FPmeJLYAWbNhjFVnSAoRXCSBKHrKW82d4mjUiyrW81KCm6THID8jlwT/rhCtgD4gL3CThA/CAqAy3cIiJEQL+47eGVwSE18KYdoC/Yp1Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L/V/K1pm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751962277; x=1783498277;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZB9nCtjrRzq0q0am81PMOUb3zQxW12guoujcDogZtQ0=;
  b=L/V/K1pmZxjDBfvvX5ZO1q29vTNFAIsbA1dmNNaK5bzU+kpUO8+SQi5C
   VNNhP/p7rX/NfMBLuOPsIFi+ttRzHpspvzOkS5z30YBiHqx2Nq1lgaQpm
   WywAiFHEPgm5YcJcblveuIM6YSBaCC6rIj80IBm99+WD+gYngOnKxmQnW
   A+UhEky21tQnoN/NX2A+PrbGx9DpMsbIHeTEr56uugiiqIoTtBGxHVsiH
   OF0WNppA99FHTditu0pACimOknHKDwehoSJUDokHt+ryctizLa35BMqV5
   5jTUxq+W6+RF/Sy5RM1zBplgUuVJVv80VuPe9AWEo77CJLysknl5Qtc3a
   Q==;
X-CSE-ConnectionGUID: wIUWDEzERTeAP5d2s6hFRA==
X-CSE-MsgGUID: +GvZPJo6SdqrAL3cvcysGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65543234"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="65543234"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 01:11:16 -0700
X-CSE-ConnectionGUID: mCinE0+bR5yOWsiN1/46qw==
X-CSE-MsgGUID: Te2HtNq9QlKgRWGeN5AyEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="161076605"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 Jul 2025 01:11:12 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com
Subject: [PATCH 2/2] KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
Date: Tue,  8 Jul 2025 16:03:14 +0800
Message-ID: <20250708080314.43081-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250708080314.43081-1-xiaoyao.li@intel.com>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
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


