Return-Path: <kvm+bounces-46388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE5EAB5DC7
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F34619E4AB6
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB182C086F;
	Tue, 13 May 2025 20:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A3I/5V5V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D795C1F0E39;
	Tue, 13 May 2025 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168680; cv=none; b=UqYMnFxKiJCmucl+LIjWGsSNkALitxWp+VxzyyDxMUS9AuBgbdXU/YUcB0rOSHHDL+JmTK62YCciN5K2QmIK03QKu4LlDwaNfP2yuf5LduQAug1xBxEKkqNjFpX6Rngc2sO5SIJCCcgie3RFdILH2+sOWGfYWHRGG1RswVNuleE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168680; c=relaxed/simple;
	bh=CCrqWG8o3fDXS+ztJHEEroKwVzFUqg+t3M/ow+4MnT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtTMTBJQlll4HrBwLyrvbbQkLnwcQwjrru08vHI8tvJjiJPE6qylF2AjHLT86gm1s1w64BAulyygoGw/6idflPn8oke5IE+q9nA3Xyc/DPkUc4S2LdFOWZANEsgox0mYikLjqKfmVNI3gbLAgHPb1ylhLZ+YOfrhWtZ05kjATLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A3I/5V5V; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168679; x=1778704679;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CCrqWG8o3fDXS+ztJHEEroKwVzFUqg+t3M/ow+4MnT8=;
  b=A3I/5V5VP7ifdSDX8NsqDTrDF38LKYejWGT9PLlspjYoS32Em2vFqOTn
   gYr/938FOt2nMl6KVxGzvOFh30VoBU0zBz3c3Cp/RoOSnPI0iKPTxPUNL
   4An/veBJwbcnj4aUfIRZRUIAbDEFcofwWV7PYq4E+mgLtsmhoWhv9XBCA
   zqo4ch6A3m7a1QdyES36nS7ZrnTqcVpyPW/IuUrqi52cU1U+ZikdDOvbi
   DUkAbiCdIt6ZYzP+KZ7hocLGygRDXSY3zInakjANsrv0ztGMNTLpVbGQp
   63gcqFu+3/wTp35iY0zUpOnIPUmsYPSCN4quXlMI34NQvIn1Rm7xnBKnA
   A==;
X-CSE-ConnectionGUID: JkE9XeeIS6mShkB1UXQxeQ==
X-CSE-MsgGUID: R2LhTlFdRmmp1qZU2XDN6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160410"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160410"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:37:57 -0700
X-CSE-ConnectionGUID: Xw06lpQSSFSE75MB0qtKqA==
X-CSE-MsgGUID: ZI2hiD/kTRa1TZeilup5aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241718"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:56 -0700
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
Subject: [PATCH v6 2/9] x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
Date: Tue, 13 May 2025 13:37:56 -0700
Message-ID: <20250513203803.2636561-3-sohil.mehta@intel.com>
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

NMI-source reporting is introduced to report the sources of NMIs with
FRED event delivery based on vectors in NMI interrupt messages or the
local APIC. This enables the kernel to avoid the latency incurred by
going over the entire NMI handler list and reduces ambiguity about the
source of an NMI.

Enumerate NMI-source reporting in cpufeatures. Also, since NMI-source
reporting uses the FRED event dispatch framework, make it dependent on
FRED in the CPUID dependency table. This ensures that NMI-source
reporting gets disabled when FRED is disabled.

NMI-source reporting is intended as a kernel feature and does not need
userspace enumeration or configuration. There is no need to expose it to
userspace through /proc/cpuinfo.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v6: No change.

v5: Add NMI-source to the CPUID dependency table.
    Do not expose NMI-source feature through /proc/cpuinfo.
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..2ced1bc64548 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -321,6 +321,7 @@
 #define X86_FEATURE_FRED		(12*32+17) /* "fred" Flexible Return and Event Delivery */
 #define X86_FEATURE_LKGS		(12*32+18) /* Load "kernel" (userspace) GS */
 #define X86_FEATURE_WRMSRNS		(12*32+19) /* Non-serializing WRMSR */
+#define X86_FEATURE_NMI_SOURCE		(12*32+20) /* NMI-Source reporting with FRED */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
 #define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
 #define X86_FEATURE_LAM			(12*32+26) /* "lam" Linear Address Masking */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index a2fbea0be535..ed0fd35c9290 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -84,6 +84,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AMX_TILE,			X86_FEATURE_XFD       },
 	{ X86_FEATURE_SHSTK,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_FRED,			X86_FEATURE_LKGS      },
+	{ X86_FEATURE_NMI_SOURCE,		X86_FEATURE_FRED      },
 	{}
 };
 
-- 
2.43.0


