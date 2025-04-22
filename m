Return-Path: <kvm+bounces-43761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A4EA9622F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A0D13BDFAE
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72F3259CAB;
	Tue, 22 Apr 2025 08:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="OmKf37nj"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4D71EB1A7;
	Tue, 22 Apr 2025 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310230; cv=none; b=hQN7PeypLdOsJj3XQ1d2crMN2RLs+C9X315Qsdq4h38uW3V3WQnOpWIfEAEZX2Yxwc4s6FMwAOKpvc26lWO50b6jKvMBFoR8Shqt9aho9J+dY4nHgJT5Yu+irPdKNddtqS54hMjeBagKlXI5nLw/cgsvHfvRxUB3o5MZrQ8KS7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310230; c=relaxed/simple;
	bh=gCCWGNArlIe5QDq/ZlbbEF1UPukyQ4I5goYB8Ysgc50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAss0VEg70F8fvecbSca2/+Gb4j/DcOMgrdy+QvIu15Qzi7S6yESqGduW3DJGzQBEsObYTEdl+vSKQNZAGDWfsLp+QwNvPBAONwiYPd+eC+JmEyU9AnsRx+VCa5JEfVxaLFYzIQt4rkTxPLiit+lOO27czcx/RNm86/agofJpRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=OmKf37nj; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9e1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:23:13 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9e1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310195;
	bh=q4OhUI0rI50amKpqfciINYanq1RzzEK8yJ83O6y9rJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmKf37njdufOCKOu1+/pioZjS9aCdJkKDwOrFoBSJhYk4elP9gADQavcBJBzNl94M
	 EIiY4v+5MJyXJSD3W/yIBbOBl42wgPprtbbrq1AfBAyn6/JOU6QaZPM3JueHwmQQ1g
	 +KoW7aGTIXud9UNjjTcoKiR/eFW2JlRTjAThtiGF+xCNvMVYrZ7lw2ZIbbUz9KNdY0
	 lPhh9NdtSqPJkUj5p+Wp804iYdMmNhvdZECXFxI2/+4EvygMdqQCV95AoKEVyrcLOd
	 JUQ0rKKSP9GX6VJZM+ZRBvVN+7dPJtDzIyqhp4lXTnJyvDE1Q5Ebb4iaj/H5En1k1N
	 N66LR8lz6prnw==
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
Subject: [RFC PATCH v2 26/34] x86/msr: Rename native_wrmsr() to native_wrmsr_no_trace()
Date: Tue, 22 Apr 2025 01:22:07 -0700
Message-ID: <20250422082216.1954310-27-xin@zytor.com>
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

native_wrmsr() doesn't do trace thus can be used in noinstr context,
rename it to native_wrmsr_no_trace() to make it explicit.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h                | 8 ++++----
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index d130bdeed3ce..2a62a899f7a5 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -367,9 +367,9 @@ static __always_inline int rdmsrq_safe(u32 msr, u64 *val)
  *                            /     \                                |
  *                           /       \                               |
  *        native_wrmsrq_no_trace()    native_write_msr_safe()        |
- *                   /    \                                          |
- *                  /      \                                         |
- *      native_wrmsr()    native_write_msr()                         |
+ *                   /        \                                      |
+ *                  /          \                                     |
+ * native_wrmsr_no_trace()    native_write_msr()                     |
  *                                                                   |
  *                                                                   |
  *                                                                   |
@@ -467,7 +467,7 @@ static __always_inline void native_wrmsrq_no_trace(u32 msr, u64 val)
 	__native_wrmsrq(msr, val, EX_TYPE_WRMSR);
 }
 
-static __always_inline void native_wrmsr(u32 msr, u32 low, u32 high)
+static __always_inline void native_wrmsr_no_trace(u32 msr, u32 low, u32 high)
 {
 	native_wrmsrq_no_trace(msr, (u64)high << 32 | low);
 }
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index e970a0de894f..184bc1b3fb02 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -495,7 +495,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * pseudo-locked followed by reading of kernel memory to load it
 	 * into the cache.
 	 */
-	native_wrmsr(MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
+	native_wrmsr_no_trace(MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
 
 	/*
 	 * Cache was flushed earlier. Now access kernel memory to read it
@@ -532,7 +532,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * Critical section end: restore closid with capacity bitmask that
 	 * does not overlap with pseudo-locked region.
 	 */
-	native_wrmsr(MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
+	native_wrmsr_no_trace(MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
 
 	/* Re-enable the hardware prefetcher(s) */
 	wrmsrq(MSR_MISC_FEATURE_CONTROL, saved_msr);
-- 
2.49.0


