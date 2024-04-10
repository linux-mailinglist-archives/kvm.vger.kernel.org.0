Return-Path: <kvm+bounces-14161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79ABD8A02E1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 00:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2931C221DD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 22:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF4D199E9A;
	Wed, 10 Apr 2024 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HoPbbvLG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23518413A;
	Wed, 10 Apr 2024 22:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712786879; cv=none; b=Yggv+HBoSqj435W4GTQYPCbRHdIVykY822HRRstuwGu3+DW2QV+HWo/8UOhx3qckgQ2R+D8g/mcyCvEasfiv3ib9AIH0HkOlTjGg2DIJhWBqbfhG+yRwwrUq/QZXpOZPaz7g5QfKLZsCVV6Y+gv/uusTh1uqHcNXshhyZwKQ2lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712786879; c=relaxed/simple;
	bh=LZ7h9Iej+qInZVYxYjjmBmC9T0ltOy6lHnXxoRaqceg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuvZw/xh+vjjhlTbSIW5BL7CX8+0ybMx0omrIr+pqVrLBVjw+DybGvEQ7OZwANFGnaKCILyIN8uLcfGleAp5sdaXCML8yIrZK73HqpkI4Y0s38I+I0jT1ntWvVh+uviiKFTtb8Qe1OxQtNFFd702P51lI4AATSzxBBwycbCBm+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HoPbbvLG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712786878; x=1744322878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LZ7h9Iej+qInZVYxYjjmBmC9T0ltOy6lHnXxoRaqceg=;
  b=HoPbbvLG+nhdIFPRjYeA/js8K4vju57XJzD5ZE6xu1+R2TUEiSV/kbPe
   khn0wn35y6WOpYtPZDzrKLJxMC2O2qgZC5aScvBM31vCP6mNTTUGrpZHn
   z9CPfEX/PQs2LfGlC9e/Iqir55hZ8R9SghPREVWaKQ72ttphgl1QKKa8I
   voQAgCV3qWU6lwgAfjshFd/QSD3hQzTWWd3jXVJRSv/nyJElgLCp3SkjB
   epWqwVlC38B5lI4v7YjKK3XL6TKYeiFRZc8fPbHl74+Z0jEyh30ULM2uT
   0I/ZlXcdjiZ9Pp8i82+2P5pBowYLNJ9ZgZiPVMmjCm3C45xk3e9ojvonE
   A==;
X-CSE-ConnectionGUID: DM8DrhjDSsehBIfiSnIfaA==
X-CSE-MsgGUID: Pu1jXM8UQ4GegxVa27YSUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8041130"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="8041130"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:56 -0700
X-CSE-ConnectionGUID: BvAy4ABeRs2O/lb1sgiEwA==
X-CSE-MsgGUID: LJng1RPQQ7SjSAG0iiK2lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="25476311"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 15:07:55 -0700
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 05/10] KVM: x86/mmu: Introduce kvm_tdp_map_page() to populate guest memory
Date: Wed, 10 Apr 2024 15:07:31 -0700
Message-ID: <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1712785629.git.isaku.yamahata@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Introduce a helper function to call the KVM fault handler.  It allows a new
ioctl to invoke the KVM fault handler to populate without seeing RET_PF_*
enums or other KVM MMU internal definitions because RET_PF_* are internal
to x86 KVM MMU.  The implementation is restricted to two-dimensional paging
for simplicity.  The shadow paging uses GVA for faulting instead of L1 GPA.
It makes the API difficult to use.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v2:
- Make the helper function two-dimensional paging specific. (David)
- Return error when vcpu is in guest mode. (David)
- Rename goal_level to level in kvm_tdp_mmu_map_page(). (Sean)
- Update return code conversion. Don't check pfn.
  RET_PF_EMULATE => EINVAL, RET_PF_CONTINUE => EIO (Sean)
- Add WARN_ON_ONCE on RET_PF_CONTINUE and RET_PF_INVALID. (Sean)
- Drop unnecessary EXPORT_SYMBOL_GPL(). (Sean)
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e8b620a85627..51ff4f67e115 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 }
 
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+		     u8 *level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 91dd4c44b7d8..a34f4af44cbd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4687,6 +4687,38 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+		     u8 *level)
+{
+	int r;
+
+	/* Restrict to TDP page fault. */
+	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
+		return -EINVAL;
+
+	r = __kvm_mmu_do_page_fault(vcpu, gpa, error_code, false, NULL, level);
+	if (r < 0)
+		return r;
+
+	switch (r) {
+	case RET_PF_RETRY:
+		return -EAGAIN;
+
+	case RET_PF_FIXED:
+	case RET_PF_SPURIOUS:
+		return 0;
+
+	case RET_PF_EMULATE:
+		return -EINVAL;
+
+	case RET_PF_CONTINUE:
+	case RET_PF_INVALID:
+	default:
+		WARN_ON_ONCE(r);
+		return -EIO;
+	}
+}
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.43.2


