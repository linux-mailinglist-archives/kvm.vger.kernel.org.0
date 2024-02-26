Return-Path: <kvm+bounces-9636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 331F4866C4C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B628E1F21282
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3566851C34;
	Mon, 26 Feb 2024 08:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kmACF3An"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD84D13F;
	Mon, 26 Feb 2024 08:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936067; cv=none; b=cuMTIgxm7wjTuKgTCtbHuZm60Bsszl/ydhcpsvxh9urWlQgczLEpU4N4rwQfxKSoMRXSYWPpDBYZucB/YGuIVY1kWE/WaN/+cj2plOcBSy9tehfnQgipO9Avdm+fNAZWTyj6dcvdY2ZFvcjn0ww6QC74KVPwHGWv1zTntUeQyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936067; c=relaxed/simple;
	bh=fCJNKDBsJ1N8mTGUepr1GXYGBkdZ1JmNWyjOeM03/hk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sRGfqMWeQUkNJCedbFiYZFPhT3AUfYBNxYHX40KvnCqsco9QZv97C4rKOcTcvZH/SssHfkCY5O/99C2uakwYGNNQxh4DrI2tVDuPjwpuez8IG1N/N+4o8VY923an00glBQbwFSl1yn9dhRVinvyWKYt8s3kochxC6GQEZHosQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kmACF3An; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936065; x=1740472065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fCJNKDBsJ1N8mTGUepr1GXYGBkdZ1JmNWyjOeM03/hk=;
  b=kmACF3AnTgRi2uLqSma9rlfPeecxSZEdpKIr6Y3+QAxexDBsPWfDp2BT
   at8yfjlsNGCvCvISSbM38LUSsC5J6Uxyn0rTQ3gWw6ff4yzd+DbfEpNaD
   XMUoy+LA/g7gg0GO2Gvw+QT/TkHcFeo8iX4QZYSGrPo8GMhWXyAP7q4t6
   siIkQ9gcrdhLriROr/o7l11Zxia6aFAtlr3DPMecJbx0ZgL+etdT0MTxW
   EQGnZVe+4cyYyvLcKGCKmuX37Y7db7k8Qs8+Jx1uueEKwrGtqMcMauS8o
   9ZsK4H5JYbFcsLjvRoRa+1X5GzX3PseAmUzjh6HlaNKCnJvsObDClKJjn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631474"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631474"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474330"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:41 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 012/130] KVM: x86/mmu: Pass around full 64-bit error code for the KVM page fault
Date: Mon, 26 Feb 2024 00:25:14 -0800
Message-Id: <d98899e51a7dd52f4512595b3d0ff44174ba839d.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because the full 64-bit error code, or more info about the fault, for the
KVM page fault will be needed for protected VM, TDX and SEV-SNP, update
kvm_mmu_do_page_fault() to accept the 64-bit value so it can pass it to the
callbacks.

The upper 32 bits of error code are discarded at kvm_mmu_page_fault()
by lower_32_bits().  Now it's passed down as full 64 bits.
Currently two hardware defined bits, PFERR_GUEST_FINAL_MASK and
PFERR_GUEST_PAGE_MASK, and one software defined bit, PFERR_IMPLICIT_ACCESS,
is defined.

PFERR_IMPLICIT_ACCESS:
commit 4f4aa80e3b88 ("KVM: X86: Handle implicit supervisor access with SMAP")
introduced a software defined bit PFERR_IMPLICIT_ACCESS at bit 48 to
indicate implicit access for SMAP with instruction emulator.  Concretely
emulator_read_std() and emulator_write_std() set the bit.
permission_fault() checks the bit as smap implicit access.  The vendor page
fault handler shouldn't pass the bit to kvm_mmu_page_fault().

PFERR_GUEST_FINAL_MASK and PFERR_GUEST_PAGE_MASK:
commit 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
introduced them to optimize the nested page fault handling.  Other code
path doesn't use the bits.  Those two bits can be safely passed down
without functionality change.

The accesses of fault->error_code are as follows
- FNAME(page_fault): PFERR_IMPLICIT_ACCESS shouldn't be passed down.
                     PFERR_GUEST_FINAL_MASK and PFERR_GUEST_PAGE_MASK
                     aren't used.
- kvm_mmu_page_fault(): explicit mask with PFERR_RSVD_MASK, and
                        PFERR_NESTED_GUEST_PAGE is used outside of the
                        masking upper 32 bits.
- mmutrace: change u32 -> u64

No functional change is intended.  This is a preparation to pass on more
info with page fault error code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v3 -> v4:
- Dropped debug print part as it was deleted in the kvm-x86-next

Changes v2 -> v3:
- Make depends on a patch to clear PFERR_IMPLICIT_ACCESS
- drop clearing the upper 32 bit, instead just pass whole 64 bits
- update commit message to mention about PFERR_IMPLICIT_ACCESS and
  PFERR_NESTED_GUEST_PAGE

Changes v1 -> v2:
- no change

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 22db1a9f528a..ccdbff3d85ec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5822,8 +5822,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..21f55e8b4dc6 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -190,7 +190,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -280,7 +280,7 @@ enum {
 };
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ae86820cef69..195d98bc8de8 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -260,7 +260,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
-- 
2.25.1


