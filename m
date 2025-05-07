Return-Path: <kvm+bounces-45682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F43EAAD2B2
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4370B985205
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D36B1C2DB2;
	Wed,  7 May 2025 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WUnbkoOz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A7A1714B3;
	Wed,  7 May 2025 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580889; cv=none; b=euCDXOj34nJ5jMV51CZKxPvExh9G/Yfo/19WO6EMdVO7rzli0JwHtl2MZP3468jGP9VkMZTfNbbWbqxx/32uY1t2dGKd8fRyUrHdS3O5PsCAl0Qo02fQgQE9ZHZ7WFZv5VzroXzfq63o3LNgr4PSE+LEup3hUeKc71co4RDwANY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580889; c=relaxed/simple;
	bh=KB+HByhgRtuXd51rhqltkjMyOee0AX2NAGnKUwpqrs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnEGk2FAoy2BeetIJFaEDZRCNVJHF5YmrIPOZR3B4MiJHJqcIcv5R+ef/6PyiaG9E/IPf5BHpOaAMQz65nTym1qCL/BZxIOAqKQL1IjN+4z0pJFaferkGH2inJqQhKvl6GWv/1Qzs35J7BRlIYEHhxYM19Bauz4qbVS8l85FeXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WUnbkoOz; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580887; x=1778116887;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KB+HByhgRtuXd51rhqltkjMyOee0AX2NAGnKUwpqrs4=;
  b=WUnbkoOzjYDVD/ETjhNWGAA8OL0T3YhwAt9JKeGyDXqeFGq7y1ZH4DF3
   //L9DatnR/8LiMQb1qxawwjG5w79bGnaCsxRVl9ikemN9djlYK6RVIluj
   qBFghAiEftYqaFyBRuW9TgFYujnikNUylx+bzlCS2UY0tCHJRAQYdqJ4P
   N7g8cfq2p6RwINWr2YZNOLEA+r/c6kS5j1hTT/JgplQJA4G7VX1+X5pse
   H6FcwSXPpUIw3yYH2IKDnJwp9PErgRomE6Lap0EBwhnUmz3ZU3a5I7TAZ
   P9GTBT2jdpFhM/5HJDi+Khap7L0R2u6xHJ4pDm3iOLzodbWn7w3BBaclx
   Q==;
X-CSE-ConnectionGUID: H5V3P6N7QQy6pAVM0Rny2w==
X-CSE-MsgGUID: 0Z9LACPUSIq+CEMufZ7NKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47383972"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47383972"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:25 -0700
X-CSE-ConnectionGUID: +x+7ms+KRPOXaV53By1plw==
X-CSE-MsgGUID: WfrM0dn/QPGhE5NL+WoBgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808751"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:24 -0700
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
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v5 5/9] x86/nmi: Add support to handle NMIs with source information
Date: Tue,  6 May 2025 18:21:41 -0700
Message-ID: <20250507012145.2998143-6-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250507012145.2998143-1-sohil.mehta@intel.com>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
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
would always be zero.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: Significantly simplify NMI-source handling logic.
    Get rid of a separate lookup table for NMI-source vectors.
    Adhere to existing priority scheme for handling NMIs.
---
 arch/x86/kernel/nmi.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a1d672dcb6f0..183e3e717326 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -127,9 +127,25 @@ static void nmi_check_duration(struct nmiaction *action, u64 duration)
 			    action->handler, duration, decimal_msecs);
 }
 
+/*
+ * Match the NMI-source vector saved during registration with the source
+ * bitmap.
+ *
+ * Always return true when bit 0 of the source bitmap is set.
+ */
+static inline bool match_nmi_source(unsigned long source_bitmap, struct nmiaction *action)
+{
+	unsigned long match_vector;
+
+	match_vector = BIT(NMIS_VECTOR_NONE) | BIT(action->source_vector);
+
+	return (source_bitmap & match_vector);
+}
+
 static int nmi_handle(unsigned int type, struct pt_regs *regs)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
+	unsigned long source_bitmap = 0;
 	nmi_handler_t ehandler;
 	struct nmiaction *a;
 	int handled=0;
@@ -148,16 +164,40 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
 
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
+	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) && type == NMI_LOCAL)
+		source_bitmap = fred_event_data(regs);
+
 	/*
 	 * NMIs are edge-triggered, which means if you have enough
 	 * of them concurrently, you can lose some because only one
 	 * can be latched at any given time.  Walk the whole list
 	 * to handle those situations.
+	 *
+	 * However, NMI-source reporting does not have this limitation.
+	 * When NMI-source information is available, only run the
+	 * handlers that match the reported vectors.
 	 */
 	list_for_each_entry_rcu(a, &desc->head, list) {
 		int thishandled;
 		u64 delta;
 
+		if (source_bitmap && !match_nmi_source(source_bitmap, a))
+			continue;
+
 		delta = sched_clock();
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
-- 
2.43.0


