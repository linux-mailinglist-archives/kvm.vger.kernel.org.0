Return-Path: <kvm+bounces-3244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6D6801BFA
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AEBE1C20944
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17FC15495;
	Sat,  2 Dec 2023 09:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0FBx8eH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4791E3;
	Sat,  2 Dec 2023 01:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701511103; x=1733047103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=/sZNp1HTRIQfF9DKgY191Av3Iz3lMdrk+plprrEgK+w=;
  b=g0FBx8eHz1PxIow3zhCSsV9sgvMBKfNWPsderNGvX4z2P4Osbh2W+86+
   Htv6ql1KBx9jl8Bi/Y2IJdgudgZhVqQHc4g69C89XHmAdHZ9UTfsX7Ix0
   xgxE+xv43w+Ttt1ScmAWkCTMZVPdSiTckVk13M5xqwoUqx9nUXuFvyWWY
   cvY6tmWpIB6SsisubCuda4vyfFdCZh8I+m37+tMkNmPq/cVP1+X8r2OjV
   dtjIe02uxLQvkzruxukuwcLaGxFIY8mO3f+u/FkoMCbv+J6kNzhLHv5u4
   j83luoNNQojQ+DjMFhHNf9pDH2hIab80iYrCqJz/hNdVDwFOXWizKyQx2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="393322323"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="393322323"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:58:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="804337625"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="804337625"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:58:19 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 28/42] KVM: x86/mmu: change "vcpu" to "kvm" in page_fault_handle_page_track()
Date: Sat,  2 Dec 2023 17:29:20 +0800
Message-Id: <20231202092920.15167-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

page_fault_handle_page_track() only uses param "vcpu" to refer to
"vcpu->kvm", change it to "kvm" directly.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 8 ++++----
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b461bab51255e..73437c1b1943e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4186,7 +4186,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return RET_PF_RETRY;
 }
 
-static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
+static bool page_fault_handle_page_track(struct kvm *kvm,
 					 struct kvm_page_fault *fault)
 {
 	if (unlikely(fault->rsvd))
@@ -4199,7 +4199,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_gfn_is_write_tracked(vcpu->kvm, fault->slot, fault->gfn))
+	if (kvm_gfn_is_write_tracked(kvm, fault->slot, fault->gfn))
 		return true;
 
 	return false;
@@ -4378,7 +4378,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (WARN_ON_ONCE(kvm_mmu_is_dummy_root(vcpu->arch.mmu->common.root.hpa)))
 		return RET_PF_RETRY;
 
-	if (page_fault_handle_page_track(vcpu, fault))
+	if (page_fault_handle_page_track(vcpu->kvm, fault))
 		return RET_PF_EMULATE;
 
 	r = fast_page_fault(vcpu, fault);
@@ -4458,7 +4458,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 {
 	int r;
 
-	if (page_fault_handle_page_track(vcpu, fault))
+	if (page_fault_handle_page_track(vcpu->kvm, fault))
 		return RET_PF_EMULATE;
 
 	r = fast_page_fault(vcpu, fault);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 13c6390824a3e..f685b036f6637 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -803,7 +803,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	fault->max_level = walker.level;
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
-	if (page_fault_handle_page_track(vcpu, fault)) {
+	if (page_fault_handle_page_track(vcpu->kvm, fault)) {
 		shadow_page_table_clear_flood(vcpu, fault->addr);
 		return RET_PF_EMULATE;
 	}
-- 
2.17.1


