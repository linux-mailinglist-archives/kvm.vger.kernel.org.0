Return-Path: <kvm+bounces-43038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E954A834F5
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 02:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 901154674E6
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 00:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B171A270;
	Thu, 10 Apr 2025 00:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBBh/Wlo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADFA2114;
	Thu, 10 Apr 2025 00:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744243888; cv=none; b=p3K5eKCOWUEyh/ymEkkJbYQVd60wyuxYfSZ6qZ38u3AoyjqYdnQofkfTDBn8a6CelZPk42FYwhrNfPPn8oo4m0ILesnihAYyovqg+6Gc9tyF8qD1IhhIzA2D2NbF1LoDpCSxQf0GmyXd9hAhLg4PNQIlC2oYsW1/hXiTUUewwAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744243888; c=relaxed/simple;
	bh=5IDzi6FCSX8yvZjYvGsMcoY/WWOEXwW9nUi7OYzJos0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBkHPPX2hINuIoTsrGgUMS3g93D79se1c+llshZt3CxsV5T4U7eXWQUwKi8TjrXIREb/CEK+pkUwmIZtVh0KyxfpYdDEHJjGA9MhGAKjjdWARG7224W8GItxRm+P+s7z6y/8a9S+sFZHvSCb8bRfGDstehU49APh5NkTQrXu38s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBBh/Wlo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CDBC4CEEB;
	Thu, 10 Apr 2025 00:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744243887;
	bh=5IDzi6FCSX8yvZjYvGsMcoY/WWOEXwW9nUi7OYzJos0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBBh/Wlo58XFFa1aoFG0Wzl80tjDlb7cgliHkzKwS7SvJJyfDzrCe9pga2Gv35uSB
	 jwM9PSAVSVZdqOdbuyGbUscjrYPQMeFmk9xiSMzuBZFkoe3n98bpHclExKMhlzg6Py
	 Y7xnpVRlVwO96g0ZkZTe+17Rl6yOZ+2GaszkckKs4PTeq6YyE0Yy2O5QgxvDAliawS
	 +BM+w1pty2tXWk+wgEd7X32OuJSNwxCQsA6WpO8NHu4fFrqdZEZQbh1A3VioWDbPIs
	 Eat1fzvAXUeh1iW2c8yq0+8uada7gUe4Jjlkk5/80tEwRDM55M5jv+Ju6BM3pK4NH6
	 88dsFc3l9U0kw==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 01/10] tools headers: Update the KVM headers with the kernel sources
Date: Wed,  9 Apr 2025 17:11:16 -0700
Message-ID: <20250410001125.391820-2-namhyung@kernel.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250410001125.391820-1-namhyung@kernel.org>
References: <20250410001125.391820-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up the changes in:

  af5366bea2cb9dfb KVM: x86: Drop the now unused KVM_X86_DISABLE_VALID_EXITS
  915d2f0718a42ee0 KVM: Move KVM_REG_SIZE() definition to common uAPI header
  5c17848134ab1ffb KVM: x86/xen: Restrict hypercall MSR to unofficial synthetic range
  9364789567f9b492 KVM: x86: Add a VM type define for TDX
  fa662c9080732b1f KVM: SVM: Add Idle HLT intercept support
  3adaee78306148da KVM: arm64: Allow userspace to change the implementation ID registers
  faf7714a47a25c62 KVM: arm64: nv: Allow userland to set VGIC maintenance IRQ
  c0000e58c74eed07 KVM: arm64: Introduce KVM_REG_ARM_VENDOR_HYP_BMAP_2
  f83c41fb3dddbf47 KVM: arm64: Allow userspace to limit NV support to nVHE

Addressing this perf tools build warning:

  Warning: Kernel ABI header differences:
    diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
    diff -u tools/arch/x86/include/uapi/asm/kvm.h arch/x86/include/uapi/asm/kvm.h
    diff -u tools/arch/x86/include/uapi/asm/svm.h arch/x86/include/uapi/asm/svm.h
    diff -u tools/arch/arm64/include/uapi/asm/kvm.h arch/arm64/include/uapi/asm/kvm.h

Please see tools/include/uapi/README for further details.

Cc: kvm@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/arch/arm64/include/uapi/asm/kvm.h | 5 ++---
 tools/arch/x86/include/uapi/asm/kvm.h   | 4 ++++
 tools/arch/x86/include/uapi/asm/svm.h   | 2 ++
 tools/include/uapi/linux/kvm.h          | 9 +++++----
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 6d44f8c8a18fd98e..af9d9acaf9975a88 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -43,9 +43,6 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
-#define KVM_REG_SIZE(id)						\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 struct kvm_regs {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
@@ -108,6 +105,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
+#define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -418,6 +416,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
+#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 88585c1de416fa6f..460306b35a4bfee9 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -559,6 +559,9 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
 
+#define KVM_XEN_MSR_MIN_INDEX			0x40000000u
+#define KVM_XEN_MSR_MAX_INDEX			0x4fffffffu
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
@@ -925,5 +928,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
 #define KVM_X86_SNP_VM		4
+#define KVM_X86_TDX_VM		5
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/tools/arch/x86/include/uapi/asm/svm.h b/tools/arch/x86/include/uapi/asm/svm.h
index 1814b413fd5783d2..ec1321248dac2ab5 100644
--- a/tools/arch/x86/include/uapi/asm/svm.h
+++ b/tools/arch/x86/include/uapi/asm/svm.h
@@ -95,6 +95,7 @@
 #define SVM_EXIT_CR14_WRITE_TRAP		0x09e
 #define SVM_EXIT_CR15_WRITE_TRAP		0x09f
 #define SVM_EXIT_INVPCID       0x0a2
+#define SVM_EXIT_IDLE_HLT      0x0a6
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
@@ -224,6 +225,7 @@
 	{ SVM_EXIT_CR4_WRITE_TRAP,	"write_cr4_trap" }, \
 	{ SVM_EXIT_CR8_WRITE_TRAP,	"write_cr8_trap" }, \
 	{ SVM_EXIT_INVPCID,     "invpcid" }, \
+	{ SVM_EXIT_IDLE_HLT,     "idle-halt" }, \
 	{ SVM_EXIT_NPF,         "npf" }, \
 	{ SVM_EXIT_AVIC_INCOMPLETE_IPI,		"avic_incomplete_ipi" }, \
 	{ SVM_EXIT_AVIC_UNACCELERATED_ACCESS,   "avic_unaccelerated_access" }, \
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 502ea63b5d2e7371..b6ae8ad8934b52c7 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -617,10 +617,6 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
-#define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
-                                              KVM_X86_DISABLE_EXITS_HLT | \
-                                              KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
@@ -933,6 +929,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_PRE_FAULT_MEMORY 236
 #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
 #define KVM_CAP_X86_GUEST_MODE 238
+#define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1070,6 +1067,10 @@ struct kvm_dirty_tlb {
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
 #define KVM_REG_SIZE_U8		0x0000000000000000ULL
 #define KVM_REG_SIZE_U16	0x0010000000000000ULL
 #define KVM_REG_SIZE_U32	0x0020000000000000ULL
-- 
2.49.0.504.g3bcea36a83-goog


