Return-Path: <kvm+bounces-66868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EA2CEAC0C
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A797F3032FED
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39C42D2491;
	Tue, 30 Dec 2025 22:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TpI51X4U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4796F2580DE
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767132145; cv=none; b=fwYY4/6SNOnqRtpVLNYy7Mst8XavBoKFlSMthcdqc2hw1xBuXiHtbTVEGByii2ScLc6fN5Oi1FG+KTMXIbYBoRMDpqzMmE6e+xl6EDk1/SszwnUxIPHDmxGP/oFRaEhVXoKDgxE62kYW9afAG2O9n8yXpcSVCrQoAJnCH5A6smk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767132145; c=relaxed/simple;
	bh=WWL/w6RT2JkkWpyg3EZm702erNzC6TrlEvJkAF/LmuU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MjxOMgC2QQl5ogYSZktQEvHRDgIlcBnrSri1xQ6FGO3U6F5E1/F7M28kYy5Hf66+htDHbOSjV0pwBmCEp663Lwpgg90CHxj4kkC4seT9pNk0SUIi0zGVy3IY/4aDsW9w45+t7N3CAJ+jqvVi7JtNIvWi8mfO0G12r0rgOzMs1lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TpI51X4U; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c21341f56so30703881a91.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 14:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767132143; x=1767736943; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wcRfBb9W6yvyXNQTpVEcHYDm8hBSVDaYL06kjIq2By4=;
        b=TpI51X4Uo4Bp3MTemFLeJfrcMItvgThP/Zc7geX4UKTaYLZgaHmUahDzKqZJd4Caaw
         pGL+sHzlVJ+HkPV1+9aLoviamPh2aLheRrRvnaCCm/GD4tknAs+7j96yMCbj7PZSX5bi
         KtEDGETCYLGua5ZuOXlCJh7rNH+01CHIx+m2vwtRE6wQ+MW/b20ZLAO48LRF3uDLRNfm
         bWm9Nw0PV1RvaUgMGG5+w3P+75jC1z7hheNbGC3qFpjGN7GmocUMbYHZG8ZLhlhGjwxH
         R2uBjCzF0P16/3w5xr4u1aBpnzhTMpY5RirgFOWwl6R6g21yhk+NpQWDeIYwhmoRcERc
         0kmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767132143; x=1767736943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wcRfBb9W6yvyXNQTpVEcHYDm8hBSVDaYL06kjIq2By4=;
        b=wUpJ5tYk/jGpRdk5qqiJharik8io7RWSjDieZJqy5HG8sjbqAZ/eeQrrIrgUk4NMNP
         XBg1odO1lf23wP0NrNaeel5289B7zvPZHpVLzpiQR1cRJb8FpW/0bFnU3fOjbAfn282f
         xGISQyiz2BUjMfKDwLIcDw+fi55zN1Mv8MZe7TKKCCATFTvIOdInFZLHyj6FKjiRvm6X
         M4O+kx7iIR+Xmc+buQxpBSWwEEL3ELYOffqYOMIBjbB2+R4mKQva3NTu38n8DeJAIMYM
         7qaH31kJ+iQCqkO8Q+9AR0yZ3DzSIR759C3Bg8BRrxgAcZJK3dr++MeBpaj293+sUvld
         xQjw==
X-Gm-Message-State: AOJu0Yw//0tQP0Sxtu62thjZEfnNvh0R5dIkjAI1yk5RE38IrwEXkqAq
	E9U3IGHXGQ1iFPKfo3+QU/oMZN6sivyHQZQXd6tzxdPpARcgbkLzAXzN25IfLnSbK+pjI89Svt8
	Mse3m/A==
X-Google-Smtp-Source: AGHT+IFFdSVlY5BAR2ku8/C5vcryzYOtzMxDvehbH4Ylp8NjYHfwhkDx88S5as59IpdQrhZjTLceh5U+SwM=
X-Received: from pjxx11.prod.google.com ([2002:a17:90b:58cb:b0:349:a1a3:75fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5607:b0:340:e517:4e05
 with SMTP id 98e67ed59e1d1-34e92139901mr34187249a91.12.1767132143642; Tue, 30
 Dec 2025 14:02:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 14:02:19 -0800
In-Reply-To: <20251230220220.4122282-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230220220.4122282-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230220220.4122282-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Chao Gao <chao.gao@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Disallow access (VMREAD/VMWRITE) to fields that the loaded incarnation of
KVM doesn't support, e.g. due to lack of hardware support, as a middle
ground between allowing access to any vmcs12 field defined by KVM (current
behavior) and gating access based on the userspace-defined vCPU model (the
most correct, but costly, implementation).

Disallowing access to unsupported fields helps a tiny bit in terms of
closing the virtualization hole (see below), but the main motivation is to
avoid having to weed out unsupported fields when synchronizing between
vmcs12 and a shadow VMCS.  Because shadow VMCS accesses are done via
VMREAD and VMWRITE, KVM _must_ filter out unsupported fields (or eat
VMREAD/VMWRITE failures), and filtering out just shadow VMCS fields is
about the same amount of effort, and arguably much more confusing.

As a bonus, this also fixes a KVM-Unit-Test failure bug when running on
_hardware_ without support for TSC Scaling, which fails with the same
signature as the bug fixed by commit ba1f82456ba8 ("KVM: nVMX: Dynamically
compute max VMCS index for vmcs12"):

  FAIL: VMX_VMCS_ENUM.MAX_INDEX expected: 19, actual: 17

Dynamically computing the max VMCS index only resolved the issue where KVM
was hardcoding max index, but for CPUs with TSC Scaling, that was "good
enough".

Cc: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
Link: https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  6 ----
 arch/x86/kvm/vmx/vmcs.h   |  8 +++++
 arch/x86/kvm/vmx/vmcs12.c | 70 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++--
 arch/x86/kvm/vmx/vmx.c    |  2 ++
 5 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6137e5307d0f..9d8f84e3f2da 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7074,12 +7074,6 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
 	}
 }
 
-/*
- * Indexing into the vmcs12 uses the VMCS encoding rotated left by 6.  Undo
- * that madness to get the encoding for comparison.
- */
-#define VMCS12_IDX_TO_ENC(idx) ((u16)(((u16)(idx) >> 6) | ((u16)(idx) << 10)))
-
 static u64 nested_vmx_calc_vmcs_enum_msr(void)
 {
 	/*
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..98281e019e38 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -11,7 +11,15 @@
 
 #include "capabilities.h"
 
+/*
+ * Indexing into the vmcs12 uses the VMCS encoding rotated left by 6 as a very
+ * rudimentary compression of the range of indices.  The compression ratio is
+ * good enough to allow KVM to use a (very sparsely populated) array without
+ * wasting too much memory, while the "algorithm" is fast enough to be used to
+ * lookup vmcs12 fields on-demand, e.g. for emulation.
+ */
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
+#define VMCS12_IDX_TO_ENC(idx) ((u16)(((u16)(idx) >> 6) | ((u16)(idx) << 10)))
 
 struct vmcs_hdr {
 	u32 revision_id:31;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..b92db4768346 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -9,7 +9,7 @@
 	FIELD(number, name),						\
 	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
 
-const unsigned short vmcs12_field_offsets[] = {
+static const u16 kvm_supported_vmcs12_field_offsets[] __initconst = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
 	FIELD(POSTED_INTR_NV, posted_intr_nv),
 	FIELD(GUEST_ES_SELECTOR, guest_es_selector),
@@ -158,4 +158,70 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_SSP, host_ssp),
 	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
-const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
+
+u16 vmcs12_field_offsets[ARRAY_SIZE(kvm_supported_vmcs12_field_offsets)] __ro_after_init;
+unsigned int nr_vmcs12_fields __ro_after_init;
+
+#define VMCS12_CASE64(enc) case enc##_HIGH: case enc
+
+static __init bool cpu_has_vmcs12_field(unsigned int idx)
+{
+	switch (VMCS12_IDX_TO_ENC(idx)) {
+	case VIRTUAL_PROCESSOR_ID:
+		return cpu_has_vmx_vpid();
+	case POSTED_INTR_NV:
+		return cpu_has_vmx_posted_intr();
+	VMCS12_CASE64(TSC_MULTIPLIER):
+		return cpu_has_vmx_tsc_scaling();
+	case TPR_THRESHOLD:
+	VMCS12_CASE64(VIRTUAL_APIC_PAGE_ADDR):
+		return cpu_has_vmx_tpr_shadow();
+	VMCS12_CASE64(APIC_ACCESS_ADDR):
+		return cpu_has_vmx_virtualize_apic_accesses();
+	VMCS12_CASE64(POSTED_INTR_DESC_ADDR):
+		return cpu_has_vmx_posted_intr();
+	case GUEST_INTR_STATUS:
+		return cpu_has_vmx_virtual_intr_delivery();
+	VMCS12_CASE64(VM_FUNCTION_CONTROL):
+	VMCS12_CASE64(EPTP_LIST_ADDRESS):
+		return cpu_has_vmx_vmfunc();
+	VMCS12_CASE64(EPT_POINTER):
+		return cpu_has_vmx_ept();
+	VMCS12_CASE64(XSS_EXIT_BITMAP):
+		return cpu_has_vmx_xsaves();
+	VMCS12_CASE64(ENCLS_EXITING_BITMAP):
+		return cpu_has_vmx_encls_vmexit();
+	VMCS12_CASE64(GUEST_IA32_PERF_GLOBAL_CTRL):
+	VMCS12_CASE64(HOST_IA32_PERF_GLOBAL_CTRL):
+		return cpu_has_load_perf_global_ctrl();
+	case SECONDARY_VM_EXEC_CONTROL:
+		return cpu_has_secondary_exec_ctrls();
+	case GUEST_S_CET:
+	case GUEST_SSP:
+	case GUEST_INTR_SSP_TABLE:
+	case HOST_S_CET:
+	case HOST_SSP:
+	case HOST_INTR_SSP_TABLE:
+		return cpu_has_load_cet_ctrl();
+
+	/* KVM always emulates PML and the VMX preemption timer in software. */
+	case GUEST_PML_INDEX:
+	case VMX_PREEMPTION_TIMER_VALUE:
+	default:
+		return true;
+	}
+}
+
+void __init nested_vmx_setup_vmcs12_fields(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(kvm_supported_vmcs12_field_offsets); i++) {
+		if (!kvm_supported_vmcs12_field_offsets[i] ||
+		    !cpu_has_vmcs12_field(i))
+			continue;
+
+		vmcs12_field_offsets[i] = kvm_supported_vmcs12_field_offsets[i];
+		nr_vmcs12_fields = i + 1;
+	}
+}
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..f2c0721fe3e2 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -374,8 +374,10 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(guest_pml_index, 996);
 }
 
-extern const unsigned short vmcs12_field_offsets[];
-extern const unsigned int nr_vmcs12_fields;
+extern u16 vmcs12_field_offsets[] __ro_after_init;
+extern unsigned int nr_vmcs12_fields __ro_after_init;
+
+void __init nested_vmx_setup_vmcs12_fields(void);
 
 static inline short get_vmcs12_field_offset(unsigned long field)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b96f7aea20b..e5ad3853f51d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8670,6 +8670,8 @@ __init int vmx_hardware_setup(void)
 	 * can hide/show features based on kvm_cpu_cap_has().
 	 */
 	if (nested) {
+		nested_vmx_setup_vmcs12_fields();
+
 		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
 
 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
-- 
2.52.0.351.gbe84eed79e-goog


