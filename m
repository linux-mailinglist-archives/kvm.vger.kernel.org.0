Return-Path: <kvm+bounces-54239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC16B1D51D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC53C1AA1403
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBDD26A1AF;
	Thu,  7 Aug 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ToWwfSxX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72CC2586EA;
	Thu,  7 Aug 2025 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559901; cv=none; b=OhsgGzOdpHdRhxtDHZlY5MuCqqzJxpJhmcD6WKzlbJEaSujDCsXiDM9r1slP9VU+j8HaL67aSpbTLESfp2IxAw++jXv8Jb0otuUfzyT9g2r/GBKCT9bRlEVYBOc4Dk7tBgygZAFcohkFAhtaYbkmu3yxgyhrQp2+tn2j5dK0NkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559901; c=relaxed/simple;
	bh=AE+TpKPBBIkUBUiIJi5+wJytivu1WjWuRCo+puinnPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txSM4bP9XQBwNWt0+XCvq32a7gRnnAFBulRcwVX19rFlrqt43IzKRvo4vnvqDdBG8z8IZ2R/WpcpzT+6JwRvdh//Gfs2aRulnf/Kn3rHA5YtTEtZW1xVBNcxfR4in+MXnTnfRBifY2j6GgziRlHTIdnCNgf2tuSHYq0PwzxXKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ToWwfSxX; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559900; x=1786095900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AE+TpKPBBIkUBUiIJi5+wJytivu1WjWuRCo+puinnPM=;
  b=ToWwfSxXA74g+lHd48F1q5yT/bG6CKCMTl3Kh7MXkja05vWlOb6A+ZXa
   tthA7iA56oPPO/eBzf8RFemQeD2pka13ID91jlCB2T0JR3avej6GoZq05
   Gq70hWB4KQiIhjV7Ld1cjK0xAit4WvOlT1zw4gH90mXhDe8y1Hzg9OLKi
   Czw122MU8wphCtpLUXbJpteTewWsvvJEFVKZWJ92VZEcB7HURKrfhOiRW
   kxqZKzZnl9MB5qu5BL2nkjombH9Aw4xZ+UNqGlGsk+HWB+/LUZvE1YILq
   IlL1S8pgvDh9QMpD/UbaKoEs+pDuNcG319E4/htKmGqzeZlHZvZQ4vqDk
   g==;
X-CSE-ConnectionGUID: gLQX8B/mS/m0Y/2NvDJFbA==
X-CSE-MsgGUID: 6+WrxCjjQFSkY0IpSpGCLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67157581"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67157581"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:59 -0700
X-CSE-ConnectionGUID: e3/YabrASumMGuPFM1bzKQ==
X-CSE-MsgGUID: XdoF2HlsRCSitBfJY7D1Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202196403"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:53 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if a VMExit carries level info
Date: Thu,  7 Aug 2025 17:44:23 +0800
Message-ID: <20250807094423.4644-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX requires guests to accept S-EPT mappings created by the host KVM. Due
to the current implementation of the TDX module, if a guest accepts a GFN
at a lower level after KVM maps it at a higher level, the TDX module will
emulate an EPT violation VMExit to KVM instead of returning a size mismatch
error to the guest. If KVM fails to perform page splitting in the VMExit
handler, the guest's accept operation will be triggered again upon
re-entering the guest, causing a repeated EPT violation VMExit.

The TDX module thus enables the EPT violation VMExit to carry the guest's
accept level when the VMExit is caused by the guest's accept operation.

Therefore, in TDX's EPT violation handler
(1) Set the guest inhibit bit in the lpage info to prevent KVM MMU core
    from mapping at a higher a level than the guest's accept level.

(2) Split any existing huge mapping at the fault GFN to avoid unsupported
    splitting under the shared mmu_lock by TDX.

Use write mmu_lock to pretect (1) and (2) for now. If future KVM TDX can
perform the actual splitting under shared mmu_lock with enhanced TDX
modules, (1) is possible to be called under shared mmu_lock, and (2) would
become unnecessary.

As an optimization, this patch calls hugepage_test_guest_inhibit() without
holding the mmu_lock to reduce the frequency of acquiring the write
mmu_lock. The write mmu_lock is thus only acquired if the guest inhibit bit
is not already set. This is safe because the guest inhibit bit is set in a
one-way manner while the splitting under the write mmu_lock is performed
before setting the guest inhibit bit.

Link: https://lore.kernel.org/all/a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2
- Change tdx_get_accept_level() to tdx_check_accept_level().
- Invoke kvm_split_cross_boundary_leafs() and hugepage_set_guest_inhibit()
  to change KVM mapping level in a global way according to guest accept
  level. (Rick, Sean).

RFC v1:
- Introduce tdx_get_accept_level() to get guest accept level.
- Use tdx->violation_request_level and tdx->violation_gfn* to pass guest
  accept level to tdx_gmem_private_max_mapping_level() to detemine KVM
  mapping level.
---
 arch/x86/kvm/vmx/tdx.c      | 50 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h |  3 +++
 2 files changed, 53 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 035d81275be4..71115058e5e6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2019,6 +2019,53 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
 	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
 }
 
+static inline int tdx_check_accept_level(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot = gfn_to_memslot(vcpu->kvm, gfn);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm *kvm = vcpu->kvm;
+	u64 eeq_type, eeq_info;
+	int level = -1;
+
+	if (!slot)
+		return 0;
+
+	eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
+	if (eeq_type != TDX_EXT_EXIT_QUAL_TYPE_ACCEPT)
+		return 0;
+
+	eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
+		   TDX_EXT_EXIT_QUAL_INFO_SHIFT;
+
+	level = (eeq_info & GENMASK(2, 0)) + 1;
+
+	if (level == PG_LEVEL_4K || level == PG_LEVEL_2M) {
+		if (!hugepage_test_guest_inhibit(slot, gfn, level + 1)) {
+			gfn_t base_gfn = gfn_round_for_level(gfn, level);
+			struct kvm_gfn_range gfn_range = {
+				.start = base_gfn,
+				.end = base_gfn + KVM_PAGES_PER_HPAGE(level),
+				.slot = slot,
+				.may_block = true,
+				.attr_filter = KVM_FILTER_PRIVATE,
+			};
+
+			scoped_guard(write_lock, &kvm->mmu_lock) {
+				int ret;
+
+				ret = kvm_split_cross_boundary_leafs(kvm, &gfn_range, false);
+				if (ret)
+					return ret;
+
+				hugepage_set_guest_inhibit(slot, gfn, level + 1);
+				if (level == PG_LEVEL_4K)
+					hugepage_set_guest_inhibit(slot, gfn, level + 2);
+			}
+		}
+	}
+	return 0;
+}
+
 static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
@@ -2044,6 +2091,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
 
+		if (tdx_check_accept_level(vcpu, gpa_to_gfn(gpa)))
+			return RET_PF_RETRY;
+
 		/* Only private GPA triggers zero-step mitigation */
 		local_retry = true;
 	} else {
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index a30e880849e3..af006a73ee05 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -82,7 +82,10 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTR_PERFMON		BIT_ULL(63)
 
 #define TDX_EXT_EXIT_QUAL_TYPE_MASK	GENMASK(3, 0)
+#define TDX_EXT_EXIT_QUAL_TYPE_ACCEPT  1
 #define TDX_EXT_EXIT_QUAL_TYPE_PENDING_EPT_VIOLATION  6
+#define TDX_EXT_EXIT_QUAL_INFO_MASK	GENMASK(63, 32)
+#define TDX_EXT_EXIT_QUAL_INFO_SHIFT	32
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.43.2


