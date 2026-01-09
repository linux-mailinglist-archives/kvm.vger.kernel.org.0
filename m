Return-Path: <kvm+bounces-67516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A25D0719F
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 05:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54BF930519ED
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 04:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50022DB79A;
	Fri,  9 Jan 2026 04:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uxgrCk27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC6727A465
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 04:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767932138; cv=none; b=iC6GMJ9baGUuDdSIkeJn2TYS9TIY3izLDJhKCtuH9ObryTQjcnEZJT9ZzMIPQWuz6uoU+y+UB8ByvHFUYMObtePoPuWIfKAZTzDAUROU3s2jZkrVE7pLMXFhwoweHR7FxUlrs0Y80NesYNl00PbOd75gqTo32goNzyZO4Eq5xeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767932138; c=relaxed/simple;
	bh=dSjYIOKofd36YGyci8KZb4cwxfXwGl54yOm/gRvzkpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a0RKYgCXyDuCPY+3Bx6BimiZ1CqMiXuLfLxd3pDreCZcOU+b0ih/mMBB02IQT6j4ZXyCq3imBRI67Gt9sV8NC/En4CesNCXHDc5w7oAfYVEwpBmOrR/QxhoPsybENozkxFdxJJkkxxzKXzbob8B27xyCUMUEJR35lAIRCX25MdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uxgrCk27; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c7d0c5ed2so3757405a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 20:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767932131; x=1768536931; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UrqaA4srvEY3o9khi6jh7CcKrviRSf24OaZfPNUv3DE=;
        b=uxgrCk27GrsH+ge+NpVdzoUiOQvR2AR1USBuzE2FmLeqbgsaWfICZfX8SGKqqTSbZ4
         b/e3kjo4ZNWN+LNE8ccLyVCeK/CRsGJ3Okq4TY43asDzSYVOAf9ycM1yLyFXJ+Ry71b4
         bumzxbE3EOm16Vgl7gRnxF/uaTd33f+cWktlLw1eU4VAksurNIZbiSFY5rSLq5woiKgw
         txWFQUzRIC5v4gIEuiPpgEERiFGm5Q8b+jap0dmFXgrNkAU18r82dwE7Tw5ReGuslmi1
         3R4CVcSabqgdtZETtWCmn12Fa+J1vYBOkXGVnLx333I9BPdjoJW/T/B/rq66G8zlRG+B
         Wl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767932131; x=1768536931;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrqaA4srvEY3o9khi6jh7CcKrviRSf24OaZfPNUv3DE=;
        b=WRebSNZhm7tAl6feV14jjkL6esQfvIRL2Zs2/wZl1ur9qcqXS/tcsiMQmUJyK4aCMx
         6kX06vL7EkdK8VKGrhNz7phCAgop/VNnIxm1OhE9Kp0lZTVQWddJoN44RfJ+cUzW9Hop
         1XOBrVVbUErFh6JdxbB37Iz+AWajGyr3lAs4QtBUmjidNVs9PY0bgWMMGUrEyWqmX6AY
         aABDgNoJTtWRQZfsGXMO7n8FB2ImqjdoY6xF6jzJmn4u2dh/2iOgvourQJfozmcyB3M5
         rz/HSn9WRXPGeRsHtsSCW3+Igi87kl3aa+UJu2pKm63QtzUaQTxP0cwaKceO4flnKecQ
         MQ+Q==
X-Gm-Message-State: AOJu0Yy10PyL5idd33K9wBhp3raBcSB1gxafX2kHjHejIihJpljUHpvk
	7g5ZgIfXQq5C1z94WI55P+FrFL58SMD3TJvb5eCxSbdB+tL4HeZsz0c+tu4xca6GRcBJHVgpiAF
	QwXjeSg==
X-Google-Smtp-Source: AGHT+IFE/67yba6hPA+b8vLirH7hId58WfEp5916YRvDTSOyjQ2NfnsTDXh1javTa5MMXSzGv8biAwA4laI=
X-Received: from pjbiq12.prod.google.com ([2002:a17:90a:fb4c:b0:34e:9b4f:a5a6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5287:b0:343:7714:4caa
 with SMTP id 98e67ed59e1d1-34f68b4c72dmr7671978a91.3.1767932130761; Thu, 08
 Jan 2026 20:15:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 20:15:22 -0800
In-Reply-To: <20260109041523.1027323-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109041523.1027323-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109041523.1027323-4-seanjc@google.com>
Subject: [PATCH v3 3/4] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Disallow access (VMREAD/VMWRITE), both emulated and via a shadow VMCS, to
VMCS fields that the loaded incarnation of KVM doesn't support, e.g. due
to lack of hardware support, as a middle ground between allowing access to
any vmcs12 field defined by KVM (current behavior) and gating access based
on the userspace-defined vCPU model (the most functionally correct, but
very costly, implementation).

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

Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Xin Li <xin@zytor.com
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
Link: https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 15 +++++----
 arch/x86/kvm/vmx/vmcs.h   |  8 +++++
 arch/x86/kvm/vmx/vmcs12.c | 70 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++--
 4 files changed, 89 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 61113ead3d7b..ac7a17560c8f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -111,6 +111,9 @@ static void init_vmcs_shadow_fields(void)
 			  field <= GUEST_TR_AR_BYTES,
 			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
 
+		if (get_vmcs12_field_offset(field) < 0)
+			continue;
+
 		/*
 		 * PML and the preemption timer can be emulated, but the
 		 * processor cannot vmwrite to fields that don't exist
@@ -7074,12 +7077,6 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
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
@@ -7407,6 +7404,12 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
+	/*
+	 * Note!  The set of supported vmcs12 fields is consumed by both VMX
+	 * MSR and shadow VMCS setup.
+	 */
+	nested_vmx_setup_vmcs12_fields();
+
 	nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
 
 	if (!cpu_has_vmx_shadow_vmcs())
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 9aa204c87661..66d747e265b1 100644
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
+#define VMCS12_IDX_TO_ENC(idx) ROL16(idx, 10)
 #define ENC_TO_VMCS12_IDX(enc) ROL16(enc, 6)
 
 struct vmcs_hdr {
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index c2ac9e1a50b3..1ebe67c384ad 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -9,7 +9,7 @@
 	FIELD(number, name),						\
 	[ENC_TO_VMCS12_IDX(number##_HIGH)] = VMCS12_OFFSET(name) + sizeof(u32)
 
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
index 7a5fdd9b27ba..21cd1b75e4fd 100644
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
-- 
2.52.0.457.g6b5491de43-goog


