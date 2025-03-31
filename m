Return-Path: <kvm+bounces-42241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F891A7621A
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:29:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79FD83A7888
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5D91EEA49;
	Mon, 31 Mar 2025 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jg4QkVHW"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C4D1EB5CA;
	Mon, 31 Mar 2025 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409466; cv=none; b=u5f6pP53XCtskYLwDh4x7r02vYZOFStTcl1mXs/nvwnJ5jPcUD0mqHlYVZVlRaonfAE3HPz/hFqGRoq3kW1bebYWt//djE3viHTSrQHBTXwHOTlE6E/GUXJlPF85TMN9T0QPIOMD7aggyF9kuXkwKnrTwDle0zn9aE3L3tbg/LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409466; c=relaxed/simple;
	bh=FN5g8giJJxRRxCOVXKjUG367o7XXihVRjnOAVof1uB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSa83U4b6t0/eOTnBjucFOxOxCDUgTxSlT0C+Mp6OecvukFNRzH5yjLMvdAhmDQ75eVVcXcxhyCBojDRK8j5v8FjND5/ygsoo0BrUglwdBurlfhzNnhEI7QmKlGLUKrik+KoujYT2WnmDUt36zBleJzdOjekAWEcWs7M/00sDKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jg4QkVHW; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp083171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp083171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409396;
	bh=LUf6J4OHKn6Yqz/cuiPFW5gyz7UWQzJR/hPRWef8Heg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jg4QkVHWmuNxTSaNr3aLQCDAx0pfc5MzZ6zHM+wqM8DSTcQ3v/RsKHxoUQpqWtNbJ
	 m458JdmtvOkoM5D9ageqtKl9oHpcXzkGBie1zx4Z64jnAGFmPZKoyTrDoCRBO1dSLT
	 mR0rsGe9H8URcFY2CBgpai+T0h9txzTfzfHRjKd6U95Ungph1Kwv+yEPzL4fhScW5l
	 Ab8OKE5fJ02Tagt2yFWbB7GGJh/377QIshI1xuLWxMSYTo8yAwJfG0LGkBemhVlVjc
	 tTZHvLjVyjNvdRXxd7vUQNm4YDAIWKVIT4qPZoTRRR4mD09RG0QuehmydgeXZydpxd
	 2Z/C61/mQ2MUw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 08/15] x86/cpufeatures: Add a CPU feature bit for MSR immediate form instructions
Date: Mon, 31 Mar 2025 01:22:44 -0700
Message-ID: <20250331082251.3171276-9-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The immediate form of MSR access instructions are primarily motivated
by performance, not code size: by having the MSR number in an immediate,
it is available *much* earlier in the pipeline, which allows the
hardware much more leeway about how a particular MSR is handled.

Use a scattered CPU feature bit for MSR immediate form instructions.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/cpufeatures.h | 19 ++++++++++---------
 arch/x86/kernel/cpu/scattered.c    |  1 +
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..a742a3d34712 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -472,15 +472,16 @@
  *
  * Reuse free bits when adding new feature flags!
  */
-#define X86_FEATURE_AMD_LBR_PMC_FREEZE	(21*32+ 0) /* "amd_lbr_pmc_freeze" AMD LBR and PMC Freeze */
-#define X86_FEATURE_CLEAR_BHB_LOOP	(21*32+ 1) /* Clear branch history at syscall entry using SW loop */
-#define X86_FEATURE_BHI_CTRL		(21*32+ 2) /* BHI_DIS_S HW control available */
-#define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* BHI_DIS_S HW control enabled */
-#define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* Clear branch history at vmexit using SW loop */
-#define X86_FEATURE_AMD_FAST_CPPC	(21*32 + 5) /* Fast CPPC */
-#define X86_FEATURE_AMD_HETEROGENEOUS_CORES (21*32 + 6) /* Heterogeneous Core Topology */
-#define X86_FEATURE_AMD_WORKLOAD_CLASS	(21*32 + 7) /* Workload Classification */
-#define X86_FEATURE_PREFER_YMM		(21*32 + 8) /* Avoid ZMM registers due to downclocking */
+#define X86_FEATURE_AMD_LBR_PMC_FREEZE		(21*32+ 0) /* "amd_lbr_pmc_freeze" AMD LBR and PMC Freeze */
+#define X86_FEATURE_CLEAR_BHB_LOOP		(21*32+ 1) /* Clear branch history at syscall entry using SW loop */
+#define X86_FEATURE_BHI_CTRL			(21*32+ 2) /* BHI_DIS_S HW control available */
+#define X86_FEATURE_CLEAR_BHB_HW		(21*32+ 3) /* BHI_DIS_S HW control enabled */
+#define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT	(21*32+ 4) /* Clear branch history at vmexit using SW loop */
+#define X86_FEATURE_AMD_FAST_CPPC		(21*32+ 5) /* Fast CPPC */
+#define X86_FEATURE_AMD_HETEROGENEOUS_CORES	(21*32+ 6) /* Heterogeneous Core Topology */
+#define X86_FEATURE_AMD_WORKLOAD_CLASS		(21*32+ 7) /* Workload Classification */
+#define X86_FEATURE_PREFER_YMM			(21*32+ 8) /* Avoid ZMM registers due to downclocking */
+#define X86_FEATURE_MSR_IMM			(21*32+ 9) /* MSR immediate form instructions */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 16f3ca30626a..9eda656e9793 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -27,6 +27,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,		CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,			CPUID_ECX,  3, 0x00000006, 0 },
 	{ X86_FEATURE_INTEL_PPIN,		CPUID_EBX,  0, 0x00000007, 1 },
+	{ X86_FEATURE_MSR_IMM,			CPUID_ECX,  5, 0x00000007, 1 },
 	{ X86_FEATURE_RRSBA_CTRL,		CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_BHI_CTRL,			CPUID_EDX,  4, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,			CPUID_EDX,  1, 0x0000000f, 0 },
-- 
2.49.0


