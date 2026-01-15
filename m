Return-Path: <kvm+bounces-68211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18670D26AFD
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3595F305C63E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFF93C1983;
	Thu, 15 Jan 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lcBnO4k1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5B73C1976
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498478; cv=none; b=hjtyCBo7z+T7oOLSg6cw6LquMmevGJjzfVke4JBgcXUwNn4vFVWCT0l2RqHbVVMcufcHt967YILs9R9mQSJH7KGVhVGsVGlO7X6STpDbza+avmXisvedHMl8Ncoi6XQUVWBOylyLjzBNrmxyYc+AUVpQ97r5zjlcCpM4Y5QsDzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498478; c=relaxed/simple;
	bh=a29kfVQbaPp7CL6nh43UYnA2FIvtz0V5vUDDoqZnygQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q4FFxS9GqC7ouD7O2EU6MWF1NZGsJUzu/undR8vomjcYrxX1b1gYF5Hmg/aFQ449ADNuZ/9fXoqth9Y3a/VEk5HvecSZtfd41KDhCDEKde/GuKXlk0ITBQCRPt9Xql6+jiJaET8QT9f89SibEIsNx/DCllfTAT1P1JNh8HXqfSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lcBnO4k1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0a0bad5dfso20290865ad.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768498475; x=1769103275; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GknNrx0RB+4hyuco2A9oXPYAJzVu+spP9PFyC46nLS8=;
        b=lcBnO4k1kooy/26mQXocVka8Fg+9kCHQd6V4rVbiy1Wbb574Ze50qWNH2vIaufjv/Q
         7TteYie8TSoJojTkVdlRY3D7SIf1HTAHRazgeK0g7vMp9us7PZ5cKT41zo9yj8b8eUOH
         FpRYSRH//kYL30CaVck034mcgIk43rlwUbf7JHvlOzbgjBcYRPEkBh2J9NDKEch+F0+F
         IvYXcXr/Wd2nZ/RlJ7PvLDomW/Vx7s86UxZSi/rnJobu03+t1u/x2NsDokHv22bA49lq
         Z8DcAxU1KJLgHQrBFoKJbGX5qyL5KOMR6+3f+ZSMNK9abTbzuvOL011Sq+AYH1kPWb/t
         9rrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498475; x=1769103275;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GknNrx0RB+4hyuco2A9oXPYAJzVu+spP9PFyC46nLS8=;
        b=UuXk3GasEBUXKtwzJOUuMkdDjPTt3WTtRcDNwpalJEwn9QTq38VtTPh3R9ffRrR9QZ
         gVaFszTdO+AaedTfqmD2qwq7W2p31mNHGJMmhldWLUSObnfB2iRmz+L7dThxskWeVbXx
         ai1NEXa/smitGS43Gcri787/VRhkovXWLGvka4meEDBNJRQvS8bg7i1uaekWrXHeqdEa
         koYPaU1rb3ZxIrDaj1DsYPVZ19pw0mWOoU7bWh0RPNQwB1msY+X0ye1/WM7Qg94w1wZc
         ZrEgmRVng8YUFD4joIdTR37JBQkyQA31k2i/likufqUPVmZFtYmboDIEQ/45UHovk2u0
         RsjA==
X-Gm-Message-State: AOJu0YxnBLAFGmoTr2309ZtDM1LoJuTN237JAUdMV8aSS5MJx4pDIvDm
	jvyTy7TlO6cVJxPX/+BrwJHdwToDmLwOOw3yFmRENPe997DizuoT2CMYNZNshSse7yPQ/w5zljj
	7BjEFdA==
X-Received: from pleg22.prod.google.com ([2002:a17:902:e396:b0:29f:272e:e3bb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fae:b0:2a0:cb8d:2ed8
 with SMTP id d9443c01a7336-2a7175a2473mr2488235ad.30.1768498475237; Thu, 15
 Jan 2026 09:34:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 15 Jan 2026 09:34:26 -0800
In-Reply-To: <20260115173427.716021-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115173427.716021-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115173427.716021-4-seanjc@google.com>
Subject: [PATCH v4 3/4] KVM: nVMX: Disallow access to vmcs12 fields that
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
Reviewed-by: Xin Li <xin@zytor.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
Link: https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 18 ++++++----
 arch/x86/kvm/vmx/vmcs.h   |  8 +++++
 arch/x86/kvm/vmx/vmcs12.c | 70 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h |  6 ++--
 4 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76b08ea7c109..34d54edb2851 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -86,6 +86,9 @@ static void init_vmcs_shadow_fields(void)
 			pr_err("Missing field from shadow_read_only_field %x\n",
 			       field + 1);
 
+	       if (get_vmcs12_field_offset(field) < 0)
+			continue;
+
 		clear_bit(field, vmx_vmread_bitmap);
 		if (field & 1)
 #ifdef CONFIG_X86_64
@@ -111,6 +114,9 @@ static void init_vmcs_shadow_fields(void)
 			  field <= GUEST_TR_AR_BYTES,
 			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
 
+		if (get_vmcs12_field_offset(field) < 0)
+			continue;
+
 		/*
 		 * PML and the preemption timer can be emulated, but the
 		 * processor cannot vmwrite to fields that don't exist
@@ -7034,12 +7040,6 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void)
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
@@ -7367,6 +7367,12 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
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


