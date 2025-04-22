Return-Path: <kvm+bounces-43787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 629D3A961D9
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4D063A72D1
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AECC278154;
	Tue, 22 Apr 2025 08:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iINnLEAJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E684268FC9;
	Tue, 22 Apr 2025 08:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310244; cv=none; b=OAQqal0xf7b6sG33GXPAPwD0Yf4sYyqRLtlITOew70dIahpzyWOFcrzLkFkvTEqSr1qZG45Ly+QFH46w/l2US0DzRMIAgZqldR0wRPLrtuYyeoa2TlYmjdQggcZVTGuexayo6r9G1rtFdH9ozzNyiXyOvJyD0SwMOOqG1ZDxRqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310244; c=relaxed/simple;
	bh=57aledrtjTyJniVEjMBePQcfcJElNq3o5rE+X81q8qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckaeNNd0IYMdYoApT455H7vei8RAsB0X1pPAgxZbrwRG66rnQhMABn9+h29/vTR+Ho5HwhdIjgfzOuNlvBh/jC8eOM+6f05EHhHHASlQfD1HEvZP7Icb760Txe+SoQtcZA+AtMiTuFddnMYMV35SvZvbBlenaYngXw7jgpZe1o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iINnLEAJ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9L1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9L1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310156;
	bh=SmxUyQE70FAaQfnW45bmQwaH3mwMqOlVkW3bcWeB26U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iINnLEAJhcfm25VHl9BH+Xo0l16Q/sZPGlx7+WlqwP0ehPqqqkvu6yHy+O8PgHs+U
	 HfKtD70R5fYl6gfI4Aq77Ni0VspmRxRN8t/+ITP8PDqwROmTzqcDXDTKOUl0q52O/x
	 kNkqR3HxfpOlmjRDDomZzOrYqYYw57goThrvNGJJID8guCi8b7ijNhaYFxhN1wAMhF
	 L3BQU2gHq7JcftvX/oI1VX96HpWG/uYVG1kvop7kafKputBaothCF8urBXatakpG1d
	 lsmMt0d4XXmNk6/s+RcushWv8vPzSElNBFN11k4tscFnEQOF1BooWUiLW6lx3kHW43
	 sf5HDD0ajYtew==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 07/34] x86/msr: Convert __wrmsr() uses to native_wrmsr{,q}() uses
Date: Tue, 22 Apr 2025 01:21:48 -0700
Message-ID: <20250422082216.1954310-8-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__wrmsr() is the lowest level primitive MSR write API, and its direct
use is NOT preferred.  Use its wrapper function native_wrmsrq() instead.

No functional change intended.

This change also prepares for using the alternatives mechanism to access
MSRs: uses of native_wrmsr{,q}() don't need to change, but the approaches
how they perform MSR operations are binary patched during boot time upon
availability of MSR instructions.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Change in v2:
* Use native_wrmsr() where natural [rmid_p, closid_p] high/lo parameters
  can be used, without the shift-uglification (Ingo).
---
 arch/x86/events/amd/brs.c                 | 2 +-
 arch/x86/include/asm/apic.h               | 2 +-
 arch/x86/include/asm/msr.h                | 6 ++++--
 arch/x86/kernel/cpu/mce/core.c            | 2 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 6 +++---
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index ec4e8a4cace4..3f5ecfd80d1e 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -44,7 +44,7 @@ static inline unsigned int brs_to(int idx)
 static __always_inline void set_debug_extn_cfg(u64 val)
 {
 	/* bits[4:3] must always be set to 11b */
-	__wrmsr(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3, val >> 32);
+	native_wrmsrq(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);
 }
 
 static __always_inline u64 get_debug_extn_cfg(void)
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1c136f54651c..0174dd548327 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -214,7 +214,7 @@ static inline void native_apic_msr_write(u32 reg, u32 v)
 
 static inline void native_apic_msr_eoi(void)
 {
-	__wrmsr(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK, 0);
+	native_wrmsrq(APIC_BASE_MSR + (APIC_EOI >> 4), APIC_EOI_ACK);
 }
 
 static inline u32 native_apic_msr_read(u32 reg)
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 33cf506e2fd6..b50cbd3299b3 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -149,10 +149,12 @@ static inline u64 native_read_msr_safe(u32 msr, int *err)
 static inline void notrace
 native_write_msr(u32 msr, u32 low, u32 high)
 {
-	__wrmsr(msr, low, high);
+	u64 val = (u64)high << 32 | low;
+
+	native_wrmsrq(msr, val);
 
 	if (tracepoint_enabled(write_msr))
-		do_trace_write_msr(msr, ((u64)high << 32 | low), 0);
+		do_trace_write_msr(msr, val, 0);
 }
 
 /* Can be uninlined because referenced by paravirt */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 255927f0284e..1ae75ec7ac95 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1306,7 +1306,7 @@ static noinstr bool mce_check_crashing_cpu(void)
 		}
 
 		if (mcgstatus & MCG_STATUS_RIPV) {
-			__wrmsr(MSR_IA32_MCG_STATUS, 0, 0);
+			native_wrmsrq(MSR_IA32_MCG_STATUS, 0);
 			return true;
 		}
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 276ffab194f6..9ab033d6856a 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -483,7 +483,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * cache.
 	 */
 	saved_msr = __rdmsr(MSR_MISC_FEATURE_CONTROL);
-	__wrmsr(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits, 0x0);
+	native_wrmsrq(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 	closid_p = this_cpu_read(pqr_state.cur_closid);
 	rmid_p = this_cpu_read(pqr_state.cur_rmid);
 	mem_r = plr->kmem;
@@ -495,7 +495,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * pseudo-locked followed by reading of kernel memory to load it
 	 * into the cache.
 	 */
-	__wrmsr(MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
+	native_wrmsr(MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
 
 	/*
 	 * Cache was flushed earlier. Now access kernel memory to read it
@@ -532,7 +532,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * Critical section end: restore closid with capacity bitmask that
 	 * does not overlap with pseudo-locked region.
 	 */
-	__wrmsr(MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
+	native_wrmsr(MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
 
 	/* Re-enable the hardware prefetcher(s) */
 	wrmsrq(MSR_MISC_FEATURE_CONTROL, saved_msr);
-- 
2.49.0


