Return-Path: <kvm+bounces-6518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 498F2835D6A
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 09:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 034BD283077
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF9E3A1B8;
	Mon, 22 Jan 2024 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RcXx1sFR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AB39FE0
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 08:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705913648; cv=none; b=R079vsuqzO4qHhL4h8e1C1nRZeTY/3x+T2/W5fZbEPMq4hYmMyS+PXF0F9y07KJdUB9oJ5Hj13hMfYOwTWYWr9U6XX5Q95E9db/Hw2TjpqdOkEllUmsdtChJNG5QxndG5XsXPcmQVnGiUhtmMHCNqe/5QQWsWw1wyQxgwSE6tTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705913648; c=relaxed/simple;
	bh=FFUtOoz1bz1HFvQ2r50Dm9krPc8fCfiZlQcI23sRTDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qmZFyeypV1BI0l9PVZbb6uVYU6We2ou7ElRYwT/nzlgwjKLSz9nqn+FGAAAdAd+WiKH+NeTClFgz4OShwT7hecQC8iOqxko/DciujF88STIy+ifD/7FTXoN7vvV+hh2dw5rN2fNERthfIHVo0hVHhtnKP5fVWpz9e1OWLiEBoLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RcXx1sFR; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705913647; x=1737449647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FFUtOoz1bz1HFvQ2r50Dm9krPc8fCfiZlQcI23sRTDQ=;
  b=RcXx1sFR5xZ0iYwfYAiK3vmTqUmEPgNyJpxq64Z6XDJc5Z2YqQc6xmGF
   ZSkDIfRF8kuMGyuoKBRUW40dOsQk+5mTMKOndgXBCH57Vdp6VLeKci8R9
   axLrZrWSWo/us1LUarC+2oiMpASXoDeJt7CCs6rYDxsRWyR8/bZtAM4z8
   IHsM5jWAk5pu35QHu5hTJ3GYmkfIUkr215KILmSesBJMRMTVkvb8qU603
   sMWMothF6b3W1w8tNBQCCv7Oy3UQY+S7TbJcPrbc/UYVafWRjQ3o5XU7k
   yzcVd8HSHAoQUndCn6IEbDUONxbfnhztxk4juK9m/R1yJy3cY1XdT2XVw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="8536162"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="8536162"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="785611608"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="785611608"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.238.10.49])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:54:04 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com,
	binbin.wu@linux.intel.com
Subject: [kvm-unit-tests PATCH v6 3/4] x86: Add test cases for LAM_{U48,U57}
Date: Mon, 22 Jan 2024 16:53:53 +0800
Message-Id: <20240122085354.9510-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240122085354.9510-1-binbin.wu@linux.intel.com>
References: <20240122085354.9510-1-binbin.wu@linux.intel.com>
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
 lib/x86/processor.h |  2 ++
 x86/lam.c           | 76 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 2d1fe3f5..e3340f13 100644
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
diff --git a/x86/lam.c b/x86/lam.c
index 0ad16be5..3aa6b313 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -18,6 +18,9 @@
 #include "vm.h"
 #include "asm/io.h"
 #include "ioram.h"
+#include "usermode.h"
+
+#define CR3_LAM_BITS_MASK (X86_CR3_LAM_U48 | X86_CR3_LAM_U57)
 
 #define FLAGS_LAM_ACTIVE	BIT_ULL(0)
 #define FLAGS_LA57		BIT_ULL(1)
@@ -38,6 +41,16 @@ static inline bool lam_sup_active(void)
 	return !!(read_cr4() & X86_CR4_LAM_SUP);
 }
 
+static inline bool lam_u48_active(void)
+{
+	return (read_cr3() & CR3_LAM_BITS_MASK) == X86_CR3_LAM_U48;
+}
+
+static inline bool lam_u57_active(void)
+{
+	return !!(read_cr3() & X86_CR3_LAM_U57);
+}
+
 static void cr4_set_lam_sup(void *data)
 {
 	unsigned long cr4;
@@ -83,6 +96,7 @@ static void do_mov(void *mem)
 static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
 {
 	bool lam_active = !!(arg1 & FLAGS_LAM_ACTIVE);
+	bool la_57 = !!(arg1 & FLAGS_LA57);
 	u64 lam_mask = arg2;
 	u64 *ptr = (u64 *)arg3;
 	bool is_mmio = !!arg4;
@@ -96,6 +110,17 @@ static u64 test_ptr(u64 arg1, u64 arg2, u64 arg3, u64 arg4)
 	report(fault != lam_active,"Test tagged addr (%s)",
 	       is_mmio ? "MMIO" : "Memory");
 
+	/*
+	 * This test case is only triggered when LAM_U57 is active and 4-level
+	 * paging is used. For the case, bit[56:47] aren't all 0 triggers #GP.
+	 */
+	if (lam_active && (lam_mask == LAM57_MASK) && !la_57) {
+		ptr = (u64 *)set_la_non_canonical((u64)ptr, LAM48_MASK);
+		fault = test_for_exception(GP_VECTOR, do_mov, ptr);
+		report(fault,  "Test non-LAM-canonical addr (%s)",
+		       is_mmio ? "MMIO" : "Memory");
+	}
+
 	return 0;
 }
 
@@ -220,6 +245,56 @@ static void test_lam_sup(bool has_lam, bool fep_available)
 		test_invlpg(lam_mask, vaddr, true);
 }
 
+static void test_lam_user_mode(bool has_lam, u64 lam_mask, u64 mem, u64 mmio)
+{
+	unsigned r;
+	bool raised_vector;
+	unsigned long cr3 = read_cr3() & ~CR3_LAM_BITS_MASK;
+	u64 flags = 0;
+
+	if (is_la57())
+		flags |= FLAGS_LA57;
+
+	if (has_lam) {
+		if (lam_mask == LAM48_MASK) {
+			r = write_cr3_safe(cr3 | X86_CR3_LAM_U48);
+			report((r == 0) && lam_u48_active(), "Set LAM_U48");
+		} else {
+			r = write_cr3_safe(cr3 | X86_CR3_LAM_U57);
+			report((r == 0) && lam_u57_active(), "Set LAM_U57");
+		}
+	}
+	if (lam_u48_active() || lam_u57_active())
+		flags |= FLAGS_LAM_ACTIVE;
+
+	run_in_user((usermode_func)test_ptr, GP_VECTOR, flags, lam_mask, mem,
+		    false, &raised_vector);
+	run_in_user((usermode_func)test_ptr, GP_VECTOR, flags, lam_mask, mmio,
+		    true, &raised_vector);
+}
+
+static void test_lam_user(bool has_lam)
+{
+	phys_addr_t paddr;
+
+	/*
+	 * The physical address of AREA_NORMAL is within 36 bits, so that using
+	 * identical mapping, the linear address will be considered as user mode
+	 * address from the view of LAM, and the metadata bits are not used as
+	 * address for both LAM48 and LAM57.
+	 */
+	paddr = virt_to_phys(alloc_pages_flags(0, AREA_NORMAL));
+	_Static_assert((AREA_NORMAL_PFN & GENMASK(63, 47)) == 0UL,
+			"Identical mapping range check");
+
+	/*
+	 * Physical memory & MMIO have already been identical mapped in
+	 * setup_mmu().
+	 */
+	test_lam_user_mode(has_lam, LAM48_MASK, paddr, IORAM_BASE_PHYS);
+	test_lam_user_mode(has_lam, LAM57_MASK, paddr, IORAM_BASE_PHYS);
+}
+
 int main(int ac, char **av)
 {
 	bool has_lam;
@@ -238,6 +313,7 @@ int main(int ac, char **av)
 			    "use kvm.force_emulation_prefix=1 to enable\n");
 
 	test_lam_sup(has_lam, fep_available);
+	test_lam_user(has_lam);
 
 	return report_summary();
 }
-- 
2.25.1


