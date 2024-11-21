Return-Path: <kvm+bounces-32257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DEC9D4C7E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 901E6B289CC
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 12:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45AD1D63FD;
	Thu, 21 Nov 2024 11:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GCOteERi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89E1D2B13;
	Thu, 21 Nov 2024 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732190382; cv=none; b=dCtaEe0egEXsLy7r11A/RXZPTWb8DOYKjFVH2t1rViaWUFQR4s4Raj+goSMOc1Cd6/MmCi8v7Vow9n0PMHrhxNmulAFThN6/J3ZiTXgSHIIqZj8+vOU6+IrmLNynMnsDKc92lCKmDv+G9Z1OAu2hN1B2kUv0UhWtJydP6FZvUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732190382; c=relaxed/simple;
	bh=5kBYzGS748MhlX9s7PCCnBu6ZsoqdrDORvYFy2xenI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3vNFOZvvT/wWVswbt3cQLRrXpz5hsZA+24exAN6eM/+kiZAakqVjafw/5wVN9eNc08lcncKL6/HNCRf7I52C6Cd0paARHJsp2dJJdDoUxfD2knPQdTbeVqGsKYzBmKS91P2LC+MAvPCipUPb1pyS9dfZaSv/ZWJFjUKqgefGYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GCOteERi; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732190381; x=1763726381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5kBYzGS748MhlX9s7PCCnBu6ZsoqdrDORvYFy2xenI8=;
  b=GCOteERiDEB3YO/+Wsr+R+I5Zg9e0Do4WIuyTpSF8c+1BLw419/0XIp8
   XdiyhxA6i/SbU31J16qwpNdfaloOVG48xiHGs4q+aVN9l0kr0/YhWoRh7
   MlRs4YraELM0tOKfFdUux9QCl0TN2ptD6JvXiloL7lQfL0+BU3sKqnDVR
   dQt1tpWqL0dyCZgBZYtMed65KWZTWbNQiyKLe5tOZ69X83NHtq4fgA+G5
   DVeKg9taxOqmxDJpW5LThsZ/doVn+6qCxydrao1KYlfIR7rYXyeDb6Spo
   B1Ke+pBS2ndIEIF1d3ulYLi6uhbDVnqLAmEQ7nYc31H8sSdD2cpUhtLF3
   A==;
X-CSE-ConnectionGUID: sEYwAnhzTsepN4XriEofkg==
X-CSE-MsgGUID: UBFczQvRQ4CqTxKUbrpH+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="42940726"
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="42940726"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 03:59:40 -0800
X-CSE-ConnectionGUID: rWfNUW8lTry9FZZJvCmqXg==
X-CSE-MsgGUID: 6zeHSrmDQ0CVQUgTFQoYlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,172,1728975600"; 
   d="scan'208";a="90398304"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 03:59:36 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy during TD page removal
Date: Thu, 21 Nov 2024 19:57:03 +0800
Message-ID: <20241121115703.26381-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241121115139.26338-1-yan.y.zhao@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove(),

- Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only once.
- During the retry, kick off all vCPUs and prevent any vCPU from entering
  to avoid potential contentions.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/tdx.c          | 49 +++++++++++++++++++++++++--------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 521c7cf725bc..bb7592110337 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -123,6 +123,8 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_NO_VCPU_ENTER_INPROGRESS \
+	KVM_ARCH_REQ_FLAGS(33, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 60d9e9d050ad..ed6b41bbcec6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -311,6 +311,20 @@ static void tdx_clear_page(unsigned long page_pa)
 	__mb();
 }
 
+static void tdx_no_vcpus_enter_start(struct kvm *kvm)
+{
+	kvm_make_all_cpus_request(kvm, KVM_REQ_NO_VCPU_ENTER_INPROGRESS);
+}
+
+static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_clear_request(KVM_REQ_NO_VCPU_ENTER_INPROGRESS, vcpu);
+}
+
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
 static int __tdx_reclaim_page(hpa_t pa)
 {
@@ -1648,15 +1662,20 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
 		return -EINVAL;
 
-	do {
-		/*
-		 * When zapping private page, write lock is held. So no race
-		 * condition with other vcpu sept operation.  Race only with
-		 * TDH.VP.ENTER.
-		 */
+	/*
+	 * When zapping private page, write lock is held. So no race
+	 * condition with other vcpu sept operation.  Race only with
+	 * TDH.VP.ENTER.
+	 */
+	err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
+				  &level_state);
+	if ((err & TDX_OPERAND_BUSY)) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_page_remove(kvm_tdx->tdr_pa, gpa, tdx_level, &entry,
 					  &level_state);
-	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 
 	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE &&
 		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
@@ -1728,8 +1747,12 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	WARN_ON_ONCE(level != PG_LEVEL_4K);
 
 	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
-	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
-		return -EAGAIN;
+	if (unlikely(err & TDX_OPERAND_BUSY)) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
 		return -EIO;
@@ -1772,9 +1795,13 @@ static void tdx_track(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	do {
+	err = tdh_mem_track(kvm_tdx->tdr_pa);
+	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY) {
+		/* After no vCPUs enter, the second retry is expected to succeed */
+		tdx_no_vcpus_enter_start(kvm);
 		err = tdh_mem_track(kvm_tdx->tdr_pa);
-	} while (unlikely((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY));
+		tdx_no_vcpus_enter_stop(kvm);
+	}
 
 	if (KVM_BUG_ON(err, kvm))
 		pr_tdx_error(TDH_MEM_TRACK, err);
-- 
2.43.2


