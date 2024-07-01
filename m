Return-Path: <kvm+bounces-20763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D466791D8EC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0296E1C20831
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 07:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C8180035;
	Mon,  1 Jul 2024 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LFGkAIjw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F31C6F073
	for <kvm@vger.kernel.org>; Mon,  1 Jul 2024 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719818942; cv=none; b=TG0uaGEBKDioPEHcNj5M5Tpuyyw40W0qMswrVvwL65YIrK9JiXEwjckh/l5jCwYTQ9ETvjkHjLQaK5rN2cfrQfIklya9NlRNaSouLd1k9vILpID5/7GvX/vgacTTz1AgX9+69hmVuZEfv+54v4NZba0nbQdY387gwDMMei0fc+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719818942; c=relaxed/simple;
	bh=e7+jxry2SFnYtXrd/k0cTyP9s5BohouD1YnmQGsProc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1F87tD3+WKPONnJXLRGZxFprU9eb/b49qyGn/ukGerz1iCC9fRoF4HIXBvjlcerVLR2JG/xQYcOVl+wZRZtZZkM7I/A4TB+q/+2oIhnIw3dJtVmWLKKUd6/H0dygDy+HVkPT/RoL7GHz47HaWX/a+xpJcxlMbyqNRwd+l7d768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LFGkAIjw; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719818942; x=1751354942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e7+jxry2SFnYtXrd/k0cTyP9s5BohouD1YnmQGsProc=;
  b=LFGkAIjwLcu0IwOnYPVZpiaCYKzbDqmXXMvpBPUNDRD8ONTa/yXEgzx6
   JiUn2byN6gA4ARAT068sa3A7bMSSVdtGu89KeboanI76YsbX+Amoj/vfv
   bQwdUH3OgDQo55nfDUH+eRgba3Y6NhKmhFHRbKBEbhylZAkm7yfmz+4NI
   bSUhk6QKLecG/XqnDFjUwgZAhvC1m0zfo+5InnbjM3WoqMdUU41d5I1pg
   pnYt+3Ug7CjTS/F/dKpSjSUifOGTX4QSn171+NCbozPe0UUsnFtlMSFAL
   5uL4ZgZsOjL1g1y4F5dys9PcjdlPBXrJKtjTW3iwHBoGVjmiIIPHsUKk5
   g==;
X-CSE-ConnectionGUID: zshVzyjYSoSNdLAdVjHjJg==
X-CSE-MsgGUID: rIV8fUAsRvKBV/YWOk4Inw==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="34466080"
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="34466080"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:29:01 -0700
X-CSE-ConnectionGUID: vUPTGsNVRLOz1yn9/Gb3gw==
X-CSE-MsgGUID: yEqYRQJ5QmmSHYcVVXqT0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,175,1716274800"; 
   d="scan'208";a="45520778"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 00:28:58 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	robert.hoo.linux@gmail.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v7 4/5] x86: Add test cases for LAM_{U48,U57}
Date: Mon,  1 Jul 2024 15:30:09 +0800
Message-ID: <20240701073010.91417-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240701073010.91417-1-binbin.wu@linux.intel.com>
References: <20240701073010.91417-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This unit test covers:
1. CR3 LAM bits toggles.
2. Memory/MMIO access with user mode address containing LAM metadata.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
v7:
- Rename lam_{u48,u57}_active() to is_lam_{u48,u57}_enabled(), and move them to
  processor.h (Sean)
- Get lam status based on the address and vCPU state. (Sean)
- Test LAM userspace address in kernel mode directly to simplify the interface
  of test_ptr() since LAM identifies a address as kernel or user only based on
  the address itself.
- Add comments about the virtualization hole of CR3 LAM bits.
---
 lib/x86/processor.h | 12 ++++++++
 x86/lam.c           | 69 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index a38f87ed..c2cafb01 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -77,7 +77,9 @@ static inline u64 set_la_non_canonical(u64 src, u64 mask)
 
 #define X86_CR3_PCID_MASK	GENMASK(11, 0)
 #define X86_CR3_LAM_U57_BIT	(61)
+#define X86_CR3_LAM_U57		BIT_ULL(X86_CR3_LAM_U57_BIT)
 #define X86_CR3_LAM_U48_BIT	(62)
+#define X86_CR3_LAM_U48		BIT_ULL(X86_CR3_LAM_U48_BIT)
 
 #define X86_CR4_VME_BIT		(0)
 #define X86_CR4_VME		BIT(X86_CR4_VME_BIT)
@@ -988,4 +990,14 @@ static inline bool is_lam_sup_enabled(void)
 	return !!(read_cr4() & X86_CR4_LAM_SUP);
 }
 
+static inline bool is_lam_u48_enabled(void)
+{
+	return (read_cr3() & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)) == X86_CR3_LAM_U48;
+}
+
+static inline bool is_lam_u57_enabled(void)
+{
+	return !!(read_cr3() & X86_CR3_LAM_U57);
+}
+
 #endif
diff --git a/x86/lam.c b/x86/lam.c
index 2f95b6c9..40b8ecdd 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -67,7 +67,14 @@ static bool get_lam_mask(u64 address, u64* lam_mask)
 		return true;
 	}
 
-	/* TODO: Get LAM mask for userspace address. */
+	if(is_lam_u48_enabled()) {
+		*lam_mask = LAM48_MASK;
+		return true;
+	}
+
+	if(is_lam_u57_enabled())
+		return true;
+
 	return false;
 }
 
@@ -88,6 +95,17 @@ static void test_ptr(u64* ptr, bool is_mmio)
 	report(fault != lam_active, "Expected access to tagged address for %s %s LAM to %s",
 	       is_mmio ? "MMIO" : "memory", lam_active ? "with" : "without",
 	       lam_active ? "succeed" : "#GP");
+
+	/*
+	 * This test case is only triggered when LAM_U57 is active and 4-level
+	 * paging is used. For the case, bit[56:47] aren't all 0 triggers #GP.
+	 */
+	if (lam_active && (lam_mask == LAM57_MASK) && !is_la57_enabled()) {
+		ptr = (u64 *)set_la_non_canonical((u64)ptr, LAM48_MASK);
+		fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+		report(fault, "Expected access to non-LAM-canonical address for %s to #GP",
+		       is_mmio ? "MMIO" : "memory");
+	}
 }
 
 /* invlpg with tagged address is same as NOP, no #GP expected. */
@@ -199,6 +217,54 @@ static void test_lam_sup(void)
 			    "use kvm.force_emulation_prefix=1 to enable\n");
 }
 
+static void test_lam_user(void)
+{
+	void* vaddr;
+	int vector;
+	unsigned long cr3 = read_cr3() & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+	bool has_lam = this_cpu_has(X86_FEATURE_LAM);
+
+	/*
+	 * The physical address of AREA_NORMAL is within 36 bits, so that using
+	 * identical mapping, the linear address will be considered as user mode
+	 * address from the view of LAM, and the metadata bits are not used as
+	 * address for both LAM48 and LAM57.
+	 */
+	vaddr = alloc_pages_flags(0, AREA_NORMAL);
+	_Static_assert((AREA_NORMAL_PFN & GENMASK(63, 47)) == 0UL,
+			"Identical mapping range check");
+
+	/*
+	 * Note, LAM doesn't have a global control bit to turn on/off LAM
+	 * completely, but purely depends on hardware's CPUID to determine it
+	 * can be enabled or not. That means, when EPT is on, even when KVM
+	 * doesn't expose LAM to guest, the guest can still set LAM control bits
+	 * in CR3 w/o causing problem. This is an unfortunate virtualization
+	 * hole. KVM doesn't choose to intercept CR3 in this case for
+	 * performance.
+	 * Only enable LAM CR3 bits when LAM feature is exposed.
+	 */
+	if (has_lam) {
+		vector = write_cr3_safe(cr3 | X86_CR3_LAM_U48);
+		report(!vector && is_lam_u48_enabled(), "Expected CR3.LAM_U48=1 to succeed");
+	}
+	/*
+	 * Physical memory & MMIO have already been identical mapped in
+	 * setup_mmu().
+	 */
+	test_ptr(vaddr, false);
+	test_ptr(phys_to_virt(IORAM_BASE_PHYS), true);
+
+	if (has_lam) {
+		vector = write_cr3_safe(cr3 | X86_CR3_LAM_U57);
+		report(!vector && is_lam_u57_enabled(), "Expected CR3.LAM_U57=1 to succeed");
+
+		/* If !has_lam, it has been tested above, no need to test again. */
+		test_ptr(vaddr, false);
+		test_ptr(phys_to_virt(IORAM_BASE_PHYS), true);
+	}
+}
+
 int main(int ac, char **av)
 {
 	setup_vm();
@@ -209,6 +275,7 @@ int main(int ac, char **av)
 		report_info("This CPU supports LAM feature\n");
 
 	test_lam_sup();
+	test_lam_user();
 
 	return report_summary();
 }
-- 
2.43.2


