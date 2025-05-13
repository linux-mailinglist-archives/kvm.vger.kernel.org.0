Return-Path: <kvm+bounces-46298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBD8AB4CA3
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 09:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5524C17F26D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97371F2C45;
	Tue, 13 May 2025 07:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bt8DpvLI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E831F03CF
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 07:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747120992; cv=none; b=EDhix2HaPN3l8qSySLGl3x050V8Pf6lt6hmpFUFHTBwV2dsXqEO0gFLQMScPL05JQvn39K+LApRRBwlqj+25Uou5MyE88K/aEnI2jFQm712D/QuHqO5jau8NAw0JG6wGDXRxt9Qe/AexMcpMMd437dtxGb02Pd7aYsA3sQi0YWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747120992; c=relaxed/simple;
	bh=iL9IHodsWG7yrsq3tPYrUNmzLWH2gIJrjMwoMz335BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6Jt7u2YTCZuDkFsdYDClpYeL9Yryo2jAb549iFvZYWOaNC0Eseo6nQixvMgfC0wT9EgtKw733EqCZ/H1TUUniQim1MyqOwWLv/dphdgnGsfxYFFnmMDsn+tgJrrKEt2uK/5JhSlbz5O5cQqxUM2mjaCy9tIDq3P2IwDYvQjjVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bt8DpvLI; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747120991; x=1778656991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iL9IHodsWG7yrsq3tPYrUNmzLWH2gIJrjMwoMz335BE=;
  b=Bt8DpvLIn04do5HRjOZw/QtkUiQqGZjjvaWsDZ40i2ZsMNqqa2khwTRK
   AaxuJGwq/fWoSbqFR86ENZGChmw1420uw9Ghsz5QBdYMmzZrf/pgRznkp
   2BWbRcw/5IEuSJ6zVp/rEjLcokVw3r0wMl5MWfNzmCxQ8XxwIZBU+5/8c
   tBM55rdO47N8dh2mP3HoHvIJU+uqhUaF65fpCcBvfh1wYjzjpefo3T3DE
   tTGB8sz8O32YN8Uj4JWxQQ7RKvFRiIsToA1G/URk6ApLUQRG7dxcNr9SX
   68/hBFen/htsbE8QHEjJ+1+qJLUawYTrgXj6+RWpdJVbV8T58limaiUBM
   g==;
X-CSE-ConnectionGUID: GO2uHPQvTdqeNCPAbL/D1Q==
X-CSE-MsgGUID: mzAHb/EpREeVR6Dfknj2bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48941006"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48941006"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:04 -0700
X-CSE-ConnectionGUID: nO2YklddRTaQhac7XZfR0Q==
X-CSE-MsgGUID: iH2zz7uIRgO8n1YWG38xAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142740606"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 00:23:03 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [kvm-unit-tests PATCH v1 3/8] x86: cet: Directly check for #CP exception in run_in_user()
Date: Tue, 13 May 2025 00:22:45 -0700
Message-ID: <20250513072250.568180-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
References: <20250513072250.568180-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current CET tests validate if a #CP exception is raised by registering
a #CP handler. This handler counts the #CP exceptions and raises a #GP
exception, which is then caught by the run_in_user() infrastructure to
switch back to the kernel. This is convoluted.

Catch the #CP exception directly by run_in_user() to avoid the manual
counting of #CP exceptions and the #CP->#GP dance.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/cet.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/x86/cet.c b/x86/cet.c
index 214976f9..3e18e3b4 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -8,9 +8,6 @@
 #include "alloc_page.h"
 #include "fault_test.h"
 
-static int cp_count;
-static unsigned long invalid_offset = 0xffffffffffffff;
-
 static u64 cet_shstk_func(void)
 {
 	unsigned long *ret_addr, *ssp;
@@ -54,15 +51,6 @@ static u64 cet_ibt_func(void)
 #define ENABLE_SHSTK_BIT 0x1
 #define ENABLE_IBT_BIT   0x4
 
-static void handle_cp(struct ex_regs *regs)
-{
-	cp_count++;
-	printf("In #CP exception handler, error_code = 0x%lx\n",
-		regs->error_code);
-	/* Below jmp is expected to trigger #GP */
-	asm("jmpq *%0": :"m"(invalid_offset));
-}
-
 int main(int ac, char **av)
 {
 	char *shstk_virt;
@@ -70,7 +58,6 @@ int main(int ac, char **av)
 	pteval_t pte = 0;
 	bool rvc;
 
-	cp_count = 0;
 	if (!this_cpu_has(X86_FEATURE_SHSTK)) {
 		printf("SHSTK not enabled\n");
 		return report_summary();
@@ -82,7 +69,6 @@ int main(int ac, char **av)
 	}
 
 	setup_vm();
-	handle_exception(CP_VECTOR, handle_cp);
 
 	/* Allocate one page for shadow-stack. */
 	shstk_virt = alloc_vpage();
@@ -105,15 +91,14 @@ int main(int ac, char **av)
 	write_cr4(read_cr4() | X86_CR4_CET);
 
 	printf("Unit test for CET user mode...\n");
-	run_in_user((usermode_func)cet_shstk_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed shadow-stack protection test successfully.");
-	cp_count = 0;
+	run_in_user((usermode_func)cet_shstk_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc, "Shadow-stack protection test.");
 
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-	run_in_user((usermode_func)cet_ibt_func, GP_VECTOR, 0, 0, 0, 0, &rvc);
-	report(cp_count == 1, "Completed Indirect-branch tracking test successfully.");
+	run_in_user((usermode_func)cet_ibt_func, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc, "Indirect-branch tracking test.");
 
 	write_cr4(read_cr4() & ~X86_CR4_CET);
 	wrmsr(MSR_IA32_U_CET, 0);
-- 
2.47.1


