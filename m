Return-Path: <kvm+bounces-72495-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4HR7LwtUpmkbOAAAu9opvQ
	(envelope-from <kvm+bounces-72495-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:22:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2049F1E876E
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:22:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDAA730CDE81
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 03:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3362937CD28;
	Tue,  3 Mar 2026 03:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Opfq9025"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57648374E4D;
	Tue,  3 Mar 2026 03:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772507812; cv=none; b=cGrDKSdiqbHcHxGYbCbnHT/ziHAFn/XSXD8DWyWzycHLW30wLSw2mo6J2QOrsqLTyQQk1Tshi4KsFGZi4XT7pbhFjHIrMPSqWniwHTSSUTRJ0rRy8ZOkSsNA2rF5SuxQPbm6pRNQJeHuPIUQaWJBRclp9IGuodUkWQM5CkM/cBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772507812; c=relaxed/simple;
	bh=cO6gTo5gb/mRT/VUg5dkUUNUKelVmCsergc8KaPfF84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcZr+dKFrMpye32fw0WfbcgfS4ZW8y6pQymBfX0WRplTg9ycGQ6Qtql/Ood4poQfzhbRNe/U3eBPcmrFbIwLyNDan6rpcV0XxsG+70/0eNwpdWOuItc6Rp98ZBxQNUO7wDD8EN/J4dOm799JE/j+o0cN1qbnXfAefYX2RWan7AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Opfq9025; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772507811; x=1804043811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cO6gTo5gb/mRT/VUg5dkUUNUKelVmCsergc8KaPfF84=;
  b=Opfq9025pgguq0Vx2btjPdKM+nWeXtb8S4xNTzj4MUkB3ErUHOzX2ob8
   NS0xQ4fDT9ch8YZdm12REsH+uPtMdBqr+gaRV0kNYjeA0JAoHBf5X/8zd
   x8uEIsfSqYhY597pHBlAciTBUUH5qV+XRI2iOOOHB9TC9UsBogzqp2klW
   ptrDZfmpMKlQvNFmzebN7U0IDn2EP7Li/p5U+EJQyzMOVLW/08Uo9xSBe
   rOPyLw5NvijYobbs9E5Ou4fGRNhOw5eJ8fBAKBKIByM3zKL+JzNB6ra+t
   iZljZiX2XcN1dP/92msy2xRabBSzAFA/z6QJlxy9bhCL8SMRxtHzqjCap
   Q==;
X-CSE-ConnectionGUID: m0AZRi8gSlOlxr1t/LCXYg==
X-CSE-MsgGUID: PyeXM+KBSWiP4YCsqs8hQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="83869731"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="83869731"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:16:49 -0800
X-CSE-ConnectionGUID: ZGydwWZXQmWOa2ogw1zOdw==
X-CSE-MsgGUID: YUh1fIc1TcSPdb7H/5Aj0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="216988911"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa006.jf.intel.com with ESMTP; 02 Mar 2026 19:16:46 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
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
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v4 2/4] KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
Date: Tue,  3 Mar 2026 11:03:33 +0800
Message-ID: <20260303030335.766779-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260303030335.766779-1-xiaoyao.li@intel.com>
References: <20260303030335.766779-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2049F1E876E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72495-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

There are definitions of TD attributes bits inside asm/shared/tdx.h as
TDX_ATTR_*.

Remove KVM's definitions and use the ones in asm/shared/tdx.h

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c      | 4 ++--
 arch/x86/kvm/vmx/tdx_arch.h | 6 ------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c5065f84b78b..f38e492fb3d5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -75,7 +75,7 @@ void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 	pr_err("TDH_VP_WR[%s.0x%x]%s0x%llx failed: 0x%llx\n", uclass, field, op, val, err);
 }
 
-#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
+#define KVM_SUPPORTED_TD_ATTRS (TDX_ATTR_SEPT_VE_DISABLE)
 
 static __always_inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
 {
@@ -707,7 +707,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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


