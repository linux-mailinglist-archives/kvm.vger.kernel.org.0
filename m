Return-Path: <kvm+bounces-55692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1183FB34E90
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E9B61B2293C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC1A2BEC2B;
	Mon, 25 Aug 2025 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ddie5KjX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857152BDC28;
	Mon, 25 Aug 2025 21:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756159148; cv=none; b=aAtHModUMXMUInKyNE7pYdQvckZa0IyyoUnqVnOPxns0/kICbF2nPtaM0mmSSh1kG2MhV0RKjLBirG3i3rTU9LKCMKy2wSCYKnhfv27dg882HFW+Y3Zs5/pGs22WefOjIwCKqhyXCfWrD/EGIzMWqAcAPK055pc/ScEQw1QOfSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756159148; c=relaxed/simple;
	bh=LYuUlL/4j71mwTqF59AOgVT+CQ085OA7+H045tIbRPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu+GXgWp3z0LtPa2lCVB9IGq9QpFe8mNzJWqUbAKIMBOuVvKWP2yiKYpUKn7ky1381T1MTiA59cJYsERqJkCl53CpE6H+ofcVJddcS8BK8kUraDU6YX8rB2qTQYWzMrUCVglsCTHcwvj/Xpji5cBQyDBYBCbNtcnzbV2RvX4wV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ddie5KjX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AECC116B1;
	Mon, 25 Aug 2025 21:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756159148;
	bh=LYuUlL/4j71mwTqF59AOgVT+CQ085OA7+H045tIbRPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ddie5KjX34+IeoV+IbrDg5rK7E2OT1syJKf7lFx5SZDzNiKv4MTzC3BlENRxIfcln
	 eDb3yab6UwpIQnwlEunsBOMyfhWLVSWda5JLCmhx5U2qx2DpMMAaoji2k/pUiizmUR
	 Kv/ofaAnsVIzjXfcqcuFdQwtl0dNWpNt+C8yallC7CLyYd9DdklImtU/BxaQL3c5rA
	 YX2svEdzePd4/1jrqMrPvuUE6ZoxJYXMNEg5SUYbAmTS1bFRgJuQz4Ur48Gjeanley
	 MJ/P+fRslyEw5uZI5KU07r/gTP2E5CIPXseSpjYesMVVzDKOB10kUMoUz76P1RynET
	 JAUceHkmQ0hsw==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 01/11] tools headers: Sync KVM headers with the kernel source
Date: Mon, 25 Aug 2025 14:58:53 -0700
Message-ID: <20250825215904.2594216-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250825215904.2594216-1-namhyung@kernel.org>
References: <20250825215904.2594216-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up the changes in this cset:

  f55ce5a6cd33211c KVM: arm64: Expose new KVM cap for cacheable PFNMAP
  28224ef02b56fcee KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities
  4580dbef5ce0f95a KVM: TDX: Exit to userspace for SetupEventNotifyInterrupt
  25e8b1dd4883e6c2 KVM: TDX: Exit to userspace for GetTdVmCallInfo
  cf207eac06f661fb KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>

This addresses these perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
    diff -u tools/arch/x86/include/uapi/asm/kvm.h arch/x86/include/uapi/asm/kvm.h

Please see tools/include/uapi/README for further details.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/arch/x86/include/uapi/asm/kvm.h |  8 +++++++-
 tools/include/uapi/linux/kvm.h        | 27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 6f3499507c5efb56..0f15d683817d6a77 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -965,7 +965,13 @@ struct kvm_tdx_cmd {
 struct kvm_tdx_capabilities {
 	__u64 supported_attrs;
 	__u64 supported_xfam;
-	__u64 reserved[254];
+
+	__u64 kernel_tdvmcallinfo_1_r11;
+	__u64 user_tdvmcallinfo_1_r11;
+	__u64 kernel_tdvmcallinfo_1_r12;
+	__u64 user_tdvmcallinfo_1_r12;
+
+	__u64 reserved[250];
 
 	/* Configurable CPUID bits for userspace */
 	struct kvm_cpuid2 cpuid;
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 7415a3863891c042..f0f0d49d25443552 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -178,6 +178,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX              40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -447,6 +448,31 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX */
+		struct {
+			__u64 flags;
+			__u64 nr;
+			union {
+				struct {
+					__u64 ret;
+					__u64 data[5];
+				} unknown;
+				struct {
+					__u64 ret;
+					__u64 gpa;
+					__u64 size;
+				} get_quote;
+				struct {
+					__u64 ret;
+					__u64 leaf;
+					__u64 r11, r12, r13, r14;
+				} get_tdvmcall_info;
+				struct {
+					__u64 ret;
+					__u64 vector;
+				} setup_event_notify;
+			};
+		} tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -935,6 +961,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.51.0.261.g7ce5a0a67e-goog


