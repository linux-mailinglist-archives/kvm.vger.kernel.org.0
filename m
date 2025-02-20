Return-Path: <kvm+bounces-38751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3CA7A3E200
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E5BE1627B5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56EE52253BD;
	Thu, 20 Feb 2025 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVmxm/c9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37A9222582
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071213; cv=none; b=A9bB9CylgL/sn0uyFhHxLYSG8h449bz3RBViBQBpNhGVhNVvKcpod3ZhNL16J4LKE8ZCxWx8nvpoTbWF15JNyat4UdXXmRWdgPdfIJc2Crxsc1hggXOOv6RadROP16jedh6YRMCp62w7WEY9Oasn3Knwh538cjpERfnRl3h8VSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071213; c=relaxed/simple;
	bh=7qRFF3KjBkZ/U8ObQQMR4Tcp+Qr8tUOdKL/8XILRiqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJeCI9xpye+zDq38Hz1JFsQ/2U2onfu2vCSCyKEPaBvGBLPjaXx9whZxJ2XGN5pvP/YTIm7JlJgMehgsHpuPRzdoNCJ/jvR6N7dVKcAUIYmtZSLvKTlU6ql/H4KilFU392oNQIs1fgDVDl24pA4/a5heh3XoCcf/bzecDDZTOJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hVmxm/c9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dd5Ky/N9ingEVckn7njy5YI5GcNFlAhwwbSFuVZ3CoM=;
	b=hVmxm/c918sHVCaBr7YXK4jEV98ByH7uF/t/78QbZ633nbecel/eMeLHvOjc/VYdx8SPYj
	NVsrRTxRGyq5Zf/FM3e/hyOpGipkNhUz8Ioms0+BrEurfN9q/76AX2ABu9zxT74lpiOf38
	ekLWEDNRklntU9GDCHDQsDg2bo7XvDo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-qTpmE3YdMMq2fRtEjwIhUA-1; Thu,
 20 Feb 2025 12:06:43 -0500
X-MC-Unique: qTpmE3YdMMq2fRtEjwIhUA-1
X-Mimecast-MFC-AGG-ID: qTpmE3YdMMq2fRtEjwIhUA_1740071202
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D10319039C6;
	Thu, 20 Feb 2025 17:06:42 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 344FF19412A6;
	Thu, 20 Feb 2025 17:06:41 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>
Subject: [PATCH 24/30] KVM: TDX: Make pmu_intel.c ignore guest TD case
Date: Thu, 20 Feb 2025 12:05:58 -0500
Message-ID: <20250220170604.2279312-25-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM doesn't support PMU yet, it's future work of TDX KVM support as
another patch series. For now, handle TDX by updating vcpu_to_lbr_desc()
and vcpu_to_lbr_records() to return NULL.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 - Add pragma poison for to_vmx() (Paolo)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 52 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/pmu_intel.h | 28 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       | 34 +----------------------
 3 files changed, 80 insertions(+), 34 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pmu_intel.h

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 77012b2eca0e..8a94b52c5731 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -19,6 +19,7 @@
 #include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 /*
  * Perf's "BASE" is wildly misleading, architectural PMUs use bits 31:16 of ECX
@@ -34,6 +35,24 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
+static struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return NULL;
+
+	return &to_vmx(vcpu)->lbr_desc;
+}
+
+static struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return NULL;
+
+	return &to_vmx(vcpu)->lbr_desc.records;
+}
+
+#pragma GCC poison to_vmx
+
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -129,6 +148,22 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
+static bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return cpuid_model_is_consistent(vcpu);
+}
+
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return !!vcpu_to_lbr_records(vcpu)->nr;
+}
+
 static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 {
 	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
@@ -194,6 +229,9 @@ static inline void intel_pmu_release_guest_lbr_event(struct kvm_vcpu *vcpu)
 {
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (!lbr_desc)
+		return;
+
 	if (lbr_desc->event) {
 		perf_event_release_kernel(lbr_desc->event);
 		lbr_desc->event = NULL;
@@ -235,6 +273,9 @@ int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu)
 					PERF_SAMPLE_BRANCH_USER,
 	};
 
+	if (WARN_ON_ONCE(!lbr_desc))
+		return 0;
+
 	if (unlikely(lbr_desc->event)) {
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use);
 		return 0;
@@ -466,6 +507,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	u64 perf_capabilities;
 	u64 counter_rsvd;
 
+	if (!lbr_desc)
+		return;
+
 	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
 
 	/*
@@ -542,7 +586,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
-	if (cpuid_model_is_consistent(vcpu) &&
+	if (intel_pmu_lbr_is_compatible(vcpu) &&
 	    (perf_capabilities & PMU_CAP_LBR_FMT))
 		memcpy(&lbr_desc->records, &vmx_lbr_caps, sizeof(vmx_lbr_caps));
 	else
@@ -570,6 +614,9 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (!lbr_desc)
+		return;
+
 	for (i = 0; i < KVM_MAX_NR_INTEL_GP_COUNTERS; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
@@ -677,6 +724,9 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 
+	if (WARN_ON_ONCE(!lbr_desc))
+		return;
+
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
 		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
diff --git a/arch/x86/kvm/vmx/pmu_intel.h b/arch/x86/kvm/vmx/pmu_intel.h
new file mode 100644
index 000000000000..5620d0882cdc
--- /dev/null
+++ b/arch/x86/kvm/vmx/pmu_intel.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_VMX_PMU_INTEL_H
+#define  __KVM_X86_VMX_PMU_INTEL_H
+
+#include <linux/kvm_host.h>
+
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+
+struct lbr_desc {
+	/* Basic info about guest LBR records. */
+	struct x86_pmu_lbr records;
+
+	/*
+	 * Emulate LBR feature via passthrough LBR registers when the
+	 * per-vcpu guest LBR event is scheduled on the current pcpu.
+	 *
+	 * The records may be inaccurate if the host reclaims the LBR.
+	 */
+	struct perf_event *event;
+
+	/* True if LBRs are marked as not intercepted in the MSR bitmap */
+	bool msr_passthrough;
+};
+
+extern struct x86_pmu_lbr vmx_lbr_caps;
+
+#endif /* __KVM_X86_VMX_PMU_INTEL_H */
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 299fa1edf534..a58b940f0634 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -11,6 +11,7 @@
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
+#include "pmu_intel.h"
 #include "vmcs.h"
 #include "vmx_ops.h"
 #include "../cpuid.h"
@@ -90,24 +91,6 @@ union vmx_exit_reason {
 	u32 full;
 };
 
-struct lbr_desc {
-	/* Basic info about guest LBR records. */
-	struct x86_pmu_lbr records;
-
-	/*
-	 * Emulate LBR feature via passthrough LBR registers when the
-	 * per-vcpu guest LBR event is scheduled on the current pcpu.
-	 *
-	 * The records may be inaccurate if the host reclaims the LBR.
-	 */
-	struct perf_event *event;
-
-	/* True if LBRs are marked as not intercepted in the MSR bitmap */
-	bool msr_passthrough;
-};
-
-extern struct x86_pmu_lbr vmx_lbr_caps;
-
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -664,21 +647,6 @@ static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_vmx, vcpu);
 }
 
-static inline struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
-{
-	return &to_vmx(vcpu)->lbr_desc;
-}
-
-static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
-{
-	return &vcpu_to_lbr_desc(vcpu)->records;
-}
-
-static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
-{
-	return !!vcpu_to_lbr_records(vcpu)->nr;
-}
-
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
-- 
2.43.5



