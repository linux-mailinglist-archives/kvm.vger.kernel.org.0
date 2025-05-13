Return-Path: <kvm+bounces-46391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61ABCAB5DD4
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D012586802B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2197E2C1E1A;
	Tue, 13 May 2025 20:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8dmZ8UG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C512C0333;
	Tue, 13 May 2025 20:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168683; cv=none; b=qcZ2PRm+xPgDlotxiTKntSd8TG6SvoIRaN1TNtWM1sHO3q6FsP5OyKiBIOaZr5towh40XsiLRP8klEJSxVZTAr5+Z/lfux5cTo/BrNCyHmGuodP6WQ7uX4QYsoJHbpmdpuwCCrhMouAkgmp6BNuHKvzFZAwAMycMAlW05av8+pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168683; c=relaxed/simple;
	bh=UsS8b44BK8xWm+Kpa+GFLO2iwDJW/KAOeH2MgmgPXow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh243Oxe7CwvVAKN4um8rNpYuha0b2spmFXXoH3/bIRtyQ5iWjbHBsed4b5dG8Yr6X9Z7ycd1omEqxfscIz2cPdP4CPYO2SUwdOr9q90tMhhppdId9xOdcE1z0KUZJaOs7Eg++VWoGpMk8zOS6cUrrPrz7NvbnzM31yrt07mGlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8dmZ8UG; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168681; x=1778704681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UsS8b44BK8xWm+Kpa+GFLO2iwDJW/KAOeH2MgmgPXow=;
  b=U8dmZ8UGNKAZz6ZafgFlmSbIgOA34jseBR1YS+gL2rU2SLKbyGB1m+RX
   kMO8wD1yDowPMjlxbJ6bqhRUliPQbxhjLisTtPojoRq4sM5QcZX1Hk1Cx
   c7kzvgVmCu0t4pRoNpo4sQYl+LHPxZGsilZDf7NrSWxQBS10XHv/d7ivu
   JokqfqL7o492oNj9UIB9Sw+eb88OGRYg8ySBexnYwS8gKgY9f7Xe2mGP5
   Twz6Ihmw9TuFpbDjmq3P1GEQiEw3BWyR2XVnXucPC5KAabiMzsPLjwTVT
   T40jw+gegcgA6Yf4oA5kDSrF6QJ0b+GkKno4nHX1FDh1LgXHEZPHOREYL
   w==;
X-CSE-ConnectionGUID: TzEh+w4OSOCXF2wXS+fE4w==
X-CSE-MsgGUID: tJ5lom61R8mNeBGXJJxLFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160450"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160450"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:37:59 -0700
X-CSE-ConnectionGUID: j5ZqVJErRvSOkvaqAtfg7g==
X-CSE-MsgGUID: dYb9E6QLRbqVzxTBiol/cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241727"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:58 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v6 5/9] x86/nmi: Add support to handle NMIs with source information
Date: Tue, 13 May 2025 13:37:59 -0700
Message-ID: <20250513203803.2636561-6-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250513203803.2636561-1-sohil.mehta@intel.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The NMI-source bitmap is delivered as FRED event data to the kernel.
When available, use NMI-source based filtering to determine the exact
handlers to run.

Activate NMI-source based filtering only for Local NMIs. While handling
platform NMI types (such as SERR and IOCHK), do not use the source
bitmap. They have only one handler registered per type, so there is no
need to disambiguate between multiple handlers.

Some third-party chipsets may send NMI messages with a hardcoded vector
of 2, which would result in bit 2 being set in the NMI-source bitmap.
Skip the local NMI handlers in this situation.

Bit 0 of the source bitmap is set by the hardware whenever a source
vector was not used while generating an NMI, or the originator could not
be reliably identified. Poll all the registered handlers in that case.

When multiple handlers need to be executed, adhere to the existing
priority scheme and execute the handlers registered with NMI_FLAG_FIRST
before others.

The logic for handling legacy NMIs is unaffected since the source bitmap
would always have all bits set.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v6: Get rid of a separate NMI source matching function
    Set source_bitmap to ULONG_MAX to match all sources by default

v5: Significantly simplify NMI-source handling logic.
    Get rid of a separate lookup table for NMI-source vectors.
    Adhere to existing priority scheme for handling NMIs.
---
 arch/x86/kernel/nmi.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 1a24e8df1bdf..55ecbe2ab5e4 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -130,6 +130,7 @@ static void nmi_check_duration(struct nmiaction *action, u64 duration)
 static int nmi_handle(unsigned int type, struct pt_regs *regs)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
+	unsigned long source_bitmap = ULONG_MAX;
 	nmi_handler_t ehandler;
 	struct nmiaction *a;
 	int handled=0;
@@ -148,16 +149,45 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
 
 	rcu_read_lock();
 
+	/*
+	 * Activate NMI source-based filtering only for Local NMIs.
+	 *
+	 * Platform NMI types (such as SERR and IOCHK) have only one
+	 * handler registered per type, so there is no need to
+	 * disambiguate between multiple handlers.
+	 *
+	 * Also, if a platform source ends up setting bit 2 in the
+	 * source bitmap, the local NMI handlers would be skipped since
+	 * none of them use this reserved vector.
+	 *
+	 * For Unknown NMIs, avoid using the source bitmap to ensure all
+	 * potential handlers have a chance to claim responsibility.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL) {
+		source_bitmap = fred_event_data(regs);
+
+		/* Reset the bitmap if a valid source could not be identified */
+		if (WARN_ON_ONCE(!source_bitmap) || (source_bitmap & BIT(NMIS_VECTOR_NONE)))
+			source_bitmap = ULONG_MAX;
+	}
+
 	/*
 	 * NMIs are edge-triggered, which means if you have enough
 	 * of them concurrently, you can lose some because only one
 	 * can be latched at any given time.  Walk the whole list
 	 * to handle those situations.
+	 *
+	 * However, NMI-source reporting does not have this limitation.
+	 * When NMI sources have been identified, only run the handlers
+	 * that match the reported vectors.
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
 		int thishandled;
 		u64 delta;
 
+		if (!(source_bitmap & BIT(a->source_vector)))
+			continue;
+
 		delta = sched_clock();
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
-- 
2.43.0


