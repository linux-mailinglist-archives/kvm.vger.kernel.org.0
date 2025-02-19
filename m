Return-Path: <kvm+bounces-38611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18628A3CC11
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A00F3BA78B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 22:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C8425C71F;
	Wed, 19 Feb 2025 22:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tw/BFH3l"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D60325B69E;
	Wed, 19 Feb 2025 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002939; cv=none; b=eF7EJL92PW6dK+EnVVgugOX6wSfbZm6CZAg/bex7V3d9FM7dsxBtnmVHUZkdr7oJQfJEQBqvfukPbiJimdShPH0VdiC2R3EYUZv18mLdKEmOx92OVLpc/HN6JigxQpDC24+18K8uZFQT7+Rd3U+NZvOhUaK2lGQtSFx90U1Ap9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002939; c=relaxed/simple;
	bh=gJYltYWvQGxXc3wnsucrGWItTnwrdpVt4j4/NaxVFlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8mAAufZ8bJknL1LhzWqWruC7m5e59dHtYJZzMWZ3GnOVvJpmdScJNVrTZxUAwx50YZGNJkC5OOuTWi8E86SdKdsIk1Nl0dRoJH8Iyktd38oLOTlEQPNndoXeKQTna10IIqYhO70LC0GvUkAArVt/+0TqwUGUDwVF8OEs3PknDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tw/BFH3l; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740002935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n3uDgnB1JfePCZ1Yv7ORTCdXluvXhllFaHOSsc62VzE=;
	b=Tw/BFH3lJvFdSFFXhVMo7f/3q2ci5CSXp+/EHN3BiY2GHWCZaSDR+6xmF6cJgnh31h1Maq
	v79XeIWahb0LK0weDJhSSdoLiLAXRGRhnPl4H0oKlihWpA4RcT+64t4ev2FctSU3RguTZ2
	LmZMrWDNrmzQaeW31SUoeJ2ztE9mCVc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] x86/bugs: Remove X86_FEATURE_USE_IBPB
Date: Wed, 19 Feb 2025 22:08:26 +0000
Message-ID: <20250219220826.2453186-7-yosry.ahmed@linux.dev>
In-Reply-To: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

X86_FEATURE_USE_IBPB was introduced in commit 2961298efe1e
("x86/cpufeatures: Clean up Spectre v2 related CPUID flags") to have
separate flags for when the CPU supports IBPB (i.e. X86_FEATURE_IBPB)
and when an IBPB is actually used to mitigate Spectre v2.

Ever since then, the uses of IBPB expanded. The name became confusing
because it does not control all IBPB executions in the kernel.
Furthermore, because its name is generic and it's buried within
indirect_branch_prediction_barrier(), it's easy to use it not knowing
that it is specific to Spectre v2.

X86_FEATURE_USE_IBPB is no longer needed because all the IBPB executions
it used to control are now controlled through other means (e.g.
switch_mm_*_ibpb static branches). Remove the unused feature bit.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/cpufeatures.h       | 1 -
 arch/x86/kernel/cpu/bugs.c               | 1 -
 tools/arch/x86/include/asm/cpufeatures.h | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116bc..5033b23db86d2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -210,7 +210,6 @@
 #define X86_FEATURE_MBA			( 7*32+18) /* "mba" Memory Bandwidth Allocation */
 #define X86_FEATURE_RSB_CTXSW		( 7*32+19) /* Fill RSB on context switches */
 #define X86_FEATURE_PERFMON_V2		( 7*32+20) /* "perfmon_v2" AMD Performance Monitoring Version 2 */
-#define X86_FEATURE_USE_IBPB		( 7*32+21) /* Indirect Branch Prediction Barrier enabled */
 #define X86_FEATURE_USE_IBRS_FW		( 7*32+22) /* Use IBRS during runtime firmware calls */
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
 #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 685a6f97fea8f..d5642f787ebcb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1368,7 +1368,6 @@ spectre_v2_user_select_mitigation(void)
 
 	/* Initialize Indirect Branch Prediction Barrier */
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
-		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
 		static_branch_enable(&vcpu_load_ibpb);
 
 		spectre_v2_user_ibpb = mode;
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 17b6590748c00..ec9911379c617 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -210,7 +210,6 @@
 #define X86_FEATURE_MBA			( 7*32+18) /* "mba" Memory Bandwidth Allocation */
 #define X86_FEATURE_RSB_CTXSW		( 7*32+19) /* Fill RSB on context switches */
 #define X86_FEATURE_PERFMON_V2		( 7*32+20) /* "perfmon_v2" AMD Performance Monitoring Version 2 */
-#define X86_FEATURE_USE_IBPB		( 7*32+21) /* Indirect Branch Prediction Barrier enabled */
 #define X86_FEATURE_USE_IBRS_FW		( 7*32+22) /* Use IBRS during runtime firmware calls */
 #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE	( 7*32+23) /* Disable Speculative Store Bypass. */
 #define X86_FEATURE_LS_CFG_SSBD		( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
-- 
2.48.1.601.g30ceb7b040-goog


