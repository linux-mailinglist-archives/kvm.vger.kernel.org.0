Return-Path: <kvm+bounces-49327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2103AAD7DD9
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE0571895F74
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA712E6138;
	Thu, 12 Jun 2025 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fAM7Zdky"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8FF2E2EEC;
	Thu, 12 Jun 2025 21:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765034; cv=none; b=HIdh+VoLQl8w/jShVABUB7rdiv35aByfkHEZ2UvfMwDUKLJBsBDlPZHZnCAa/9QoBlqwNe5fqOBaXlIHzkbIHBrECqfj/GChEIrifPxcWaj0KWu56u38kgSlOXb3D5IC8F6i6m3g8MdtjnMogsSVwQBUwZyC0E617oYzomCyrqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765034; c=relaxed/simple;
	bh=v8IGRkYnJLZLDYhftOsNKqQqUFvuebbUgG7/IWeuerM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHzBwOhWjj7WktkKsoqzSH8KLMQ3KirdmUj+wXglYnQ8+Z1pWGPDZ0dxE2Bsm3rX0CV0Ba/vy2IXGV5oaCIl25hYJ9I0zps2nRoTXLjtbuL52N1Xah/ADvTDxbDLXWATfDXrpSPNXlm4uiKK54n4S/oiUWrERSHcJArBRxXxcmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fAM7Zdky; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765033; x=1781301033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v8IGRkYnJLZLDYhftOsNKqQqUFvuebbUgG7/IWeuerM=;
  b=fAM7ZdkyQNVrdJe7BGEJj9cUSASVh5ir8RwTsl5DbxvgEXKz8DGNTpJt
   6qf7W57/BAoeGj2/qfHnRYyxLoA/cniZCoaI+lIJcKwHXPJs6GGhlrNzG
   eMPFvNf8cv8KwaCI12F4FMWaiYpzCVUWa+KQ0cvCwcQ+cVUegz98iMmul
   +fW7/iDuhRuv5cURLGo9H4pANkFPxdKneiTHYaJk0J+XpKhweeS39L7+q
   6vrl+MuV2D1QRTGo3jgxlpWIeW8+MqYMitEcSnw4pn9Wze55fnBmg4bAs
   TJ+q/CLBntT9bM7pRbht6znivRsL9vwriDmrIuTIZ1eYWXIYEz586Yop7
   w==;
X-CSE-ConnectionGUID: qdfBvkzUSHKYhIivfnMhDw==
X-CSE-MsgGUID: 0T6BYliTQiKRFxITCtTMXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065364"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065364"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:32 -0700
X-CSE-ConnectionGUID: 3HJwHsJBTNWKFrQsScjvfQ==
X-CSE-MsgGUID: lETVjOBQRau+SbsplJ/Hfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881973"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:31 -0700
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
Subject: [PATCH v7 06/10] x86/nmi: Add support to handle NMIs with source information
Date: Thu, 12 Jun 2025 14:48:45 -0700
Message-ID: <20250612214849.3950094-7-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
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

Some third-party chipsets may send NMI messages with a fixed vector of
2, which would result in bit 2 being set in the NMI-source bitmap. Skip
the local NMI handlers in this situation.

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
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
---
v7: Add review tag from Xin.

v6: Get rid of a separate NMI source matching function (PeterZ)
    Set source_bitmap to ULONG_MAX to match all sources by default

v5: Significantly simplify NMI-source handling logic.
    Get rid of a separate lookup table for NMI-source vectors.
    Adhere to existing priority scheme for handling NMIs.
---
 arch/x86/kernel/nmi.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 8071ad32aa11..3d2b636e9379 100644
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
+		if (WARN_ON_ONCE(!source_bitmap) || (source_bitmap & BIT(NMIS_NO_SOURCE)))
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


