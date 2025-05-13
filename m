Return-Path: <kvm+bounces-46394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B379DAB5DDD
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A68AA19E6C12
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789412C2FDC;
	Tue, 13 May 2025 20:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OUyPI5xp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88452C17B4;
	Tue, 13 May 2025 20:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168685; cv=none; b=ncSjJl2maBQILEfIgy46H3ssL2DYx7z7uOy6tk/04u6K1Py6PUB1BDWmeupOr9Biaowal7IGeYnkxcutXvRZoWlAciuTSsyGV0+hAxsLJhHLuV45FEL2rO9zLfzyeGKST6F8LaA2IJn0QsZjl9a/Ub/8olwC3/Q3HHs0PbsOwGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168685; c=relaxed/simple;
	bh=8Lfg9L/fBQ9McgK/dl0rQJBpGwpkcPv9aMzRa9sr5kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1Ms2vF3NuxUfnT+F71N+eP2nPO/6mrcgG2FEzHIzt82CTgaQVR07WTrdmCGCkpIM+KSNJOzXBdHKAXkrQZ2004xOMK0tgk2t0sGKJYOkKLLWKzx1Uuia3HyKKEMh8cpDfd3tDJ+5CSMWHzwfDR2ThWDjSseL6DSn1zb/SlguCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OUyPI5xp; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168684; x=1778704684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Lfg9L/fBQ9McgK/dl0rQJBpGwpkcPv9aMzRa9sr5kc=;
  b=OUyPI5xpaQO5qddYja9TgsmtJW3APQXRZkxkIWms6nvh9nOP5rKhEjjF
   pEo4T3Z1xfKddAHHy8HRKCoQqkcmS++FZrzAjSUaTTsFMSH12RnyTgmXO
   zVtTsNKemEyPirWrA7L1kVSTxCMJSKaVndi9g7JT1/xe7uK0+f3mCMN/j
   07KFe6hwYtarL0j9HjlCF/djcGWWLwg+l5RM+VCcGs67Z19/6LLrYIje1
   998EMvPUpJpeA0bUy77IvCRfXZol22BCqPt7ZeR6vpVWhDH7K7g/98Efm
   68T99nyXJ2bHwFPMgusmRYK0P3FnGf+6Cod+m0zczZOtHWm6fVOD7pQPU
   g==;
X-CSE-ConnectionGUID: sHn1M0CkT5SwsCqbiKocig==
X-CSE-MsgGUID: bt2PDjDSTwGYKOTEdWgW0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160498"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160498"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:38:01 -0700
X-CSE-ConnectionGUID: DqlVOjUOSpWSPEPN/6PMmA==
X-CSE-MsgGUID: 7rhg0/1BTDuX7xq0+Blbfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241740"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:38:00 -0700
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
Subject: [PATCH v6 9/9] x86/nmi: Print source information with the unknown NMI console message
Date: Tue, 13 May 2025 13:38:03 -0700
Message-ID: <20250513203803.2636561-10-sohil.mehta@intel.com>
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

The NMI-source bitmap is critical information provided by the NMI-source
reporting feature. It is very useful in debugging unknown NMIs since it
can pinpoint the exact source that caused the NMI.

Print the source bitmap along with the "Unknown NMI" kernel log message.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v6: Drop the tracepoint modification part for now.

v5: New patch
---
 arch/x86/kernel/nmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 55ecbe2ab5e4..7a288603683f 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -376,6 +376,9 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	pr_emerg_ratelimited("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
 			     reason, smp_processor_id());
 
+	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
+		pr_emerg_ratelimited("NMI-source bitmap is 0x%lx\n", fred_event_data(regs));
+
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		nmi_panic(regs, "NMI: Not continuing");
 
-- 
2.43.0


