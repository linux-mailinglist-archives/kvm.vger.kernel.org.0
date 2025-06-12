Return-Path: <kvm+bounces-49332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51337AD7DEC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D06693A4B4D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EACA2E7F22;
	Thu, 12 Jun 2025 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LmtUbBWU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB432E62DA;
	Thu, 12 Jun 2025 21:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765038; cv=none; b=tKBssGT8Q/Pt5KJz04pJcGHk2zHkcsCCU88tzKHmxeRfvGy4UD3zOtjXA6ezHUSs6ruOpJYr1UXGlYlb0X80F4/lBzGX7v6BpI3IJWxVC5RSWHTk4stkFJ7VUymZJQ12IyyiHSnh2fZzuVVeFx70HSBSrsVfAsNxwDMkDKvkhUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765038; c=relaxed/simple;
	bh=HAJ/WUjo+26I25B8LZv9C58T13MdBKPP51Ed+aO6Hzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASztzlx9wtE+vt0p8j88jlfD7qYz2/oIb8aP+XlrKWmX5//IEl2m5rDtpaQXkEgwyTd6J45eGhFZcGTaOzNW+alCOLTH9+E8DgdY6obTpgh1rPd3I9G+yYJu+pOwZy16YNwX1hFxDMOBaOAgp4dONqcigTclV7FmtXRNqoATen0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LmtUbBWU; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765037; x=1781301037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAJ/WUjo+26I25B8LZv9C58T13MdBKPP51Ed+aO6Hzc=;
  b=LmtUbBWUPASfVQNSGYgP+FS0eqPi7EmSC6aDmkNtLrGtUBfNpSWxhM/B
   weos++PYbkhgJP78VLIlZhPK98vKpdFfkszpBGy/n/cha6jYvM94WBUOz
   013cZm/7Dh9OhNMGAG5MyJllBuB/3gJCYU2GNG0LpAw3LlkYUaTuGx1On
   FgpSgYsSOu5/cjMk5yIiV2yobCgCvZxe709zlbC1EUNnN8aX2HuE3Vcjj
   +4Cjb6w55X2QXQ5EqycIOqzCO+sEP9l6rFSXg4BXU7U9z+SIsvwIILvSS
   vEWPw6vP1uEdt1DCBdAJB/NHL7MOgUzHVvwjdHbnAAGb1VWpuF3tHumvH
   Q==;
X-CSE-ConnectionGUID: mpk+GHciSIaQcooH6X16jQ==
X-CSE-MsgGUID: 9DKIFj24S7GMyR2vsMxIuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065412"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065412"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:36 -0700
X-CSE-ConnectionGUID: 6shFoTgzT5Oy0swil4gfEA==
X-CSE-MsgGUID: YGQBP4BrTL+w7Bg/am6Chw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184882009"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:35 -0700
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
Subject: [PATCH v7 10/10] x86/nmi: Print source information with the unknown NMI console message
Date: Thu, 12 Jun 2025 14:48:49 -0700
Message-ID: <20250612214849.3950094-11-sohil.mehta@intel.com>
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

The NMI-source bitmap is a useful piece of information provided by the
NMI-source reporting feature. It is very helpful for debugging unknown
NMIs, as it can pinpoint the exact source that caused the NMI.

Print the complete source bitmap along with the "unknown NMI" kernel log
message, since unexpected sources might have triggered the NMI.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v7: No change.

v6: Drop the tracepoint modification part for now.

v5: New patch
---
 arch/x86/kernel/nmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 3d2b636e9379..0b5bb20c5eb7 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -379,6 +379,9 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	pr_emerg_ratelimited("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
 			     reason, smp_processor_id());
 
+	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
+		pr_emerg_ratelimited("NMI-source bitmap is 0x%lx\n", fred_event_data(regs));
+
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		nmi_panic(regs, "NMI: Not continuing");
 
-- 
2.43.0


