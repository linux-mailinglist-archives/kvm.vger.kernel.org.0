Return-Path: <kvm+bounces-66059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D5D9CC0762
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 02:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 438BD3016193
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213AA27B34F;
	Tue, 16 Dec 2025 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lzmpMzgr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68E2222D2
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765848563; cv=none; b=I1b22sMimvVdcc1Or8N18S7srljTBm0I5kBBbz4TykK+MeV3un4a3qhxjgP6Ec+EOwpATIMSscuCqHJ9nceGNY3ERgV5GQgqPlYclRd5IDKa22Nj+r6ObwyETYmYY3LvlL07JBFvnJa+8/SsmnvrTXTCLHAUCLLvDWua8fBz1sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765848563; c=relaxed/simple;
	bh=/Z72mjCBNhAToDsEtwlKRTY1obGxGVZnyq3d38OZe3Y=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Qjsn+2e3BUSh4QCm4QA1rz4OvCmqi3XwvxBpDP7ChzBLGHzcB6Z9Dzu+DqquGNrdt2CdWa8aS0DgKYUuyVlod+1nYhXJGvu3d6bcVa8Kqx/fkqq42tYeC8CbXHexAyH5AsxOaHjIXJUsyldL2dVzMPQOFk0+dOlryA73MsE0MUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lzmpMzgr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34abec8855aso7368209a91.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 17:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765848561; x=1766453361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FCL7LHY0wF9Ikdt1KzJ+83HEGAeQ7TrD3GWbUO0GwzI=;
        b=lzmpMzgrPFpoRAW48hFJcmdcXQBq/hKGGv9xh8K2gvplDS7LH3HWeqDu/XCSCWtwjq
         84lCyPFIY2vTcx/0jIkEHV3mTy0z4W1IXDr1DGd4RILwQh05nq3ZHagbdNPML3Tr4PjR
         n2s7wjhZOvB+hJie2MWRl3EXODIjhGk+4KF1PmbimOy/GabI884+Z9jLgERcjYCv0pby
         R9SVzaXGxfByZjfmzJVYddkLskm2jI6Zi9woFgKc2nTKk9MI3n2QbOzKTRMKAHom2FWa
         r4U5CaslGAjrfMDkJsnjdzQTLINerBDwOmm+7nHRa+a3PnozYPI96XgQ2joVBKrHDhro
         +cLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765848561; x=1766453361;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCL7LHY0wF9Ikdt1KzJ+83HEGAeQ7TrD3GWbUO0GwzI=;
        b=XcvPEARkWxpPuga8zdzKJSWJqr6EvUG8AEUSl2rIh6EmamiEfr9ohsdG6T1v1NGk9t
         RuccYc+Y77GBcJs2pFboZNPs6+ZqmAxuXguPXyzPRPjfQkeZarku7dnL6GKmaCh4phXl
         j/q7o+uzFOtrQSE8wxIk8TRC6AMOoegH2Jt8eEh44ANzFIZTNPUZEx5SBuFGqTWrxh7C
         0NLHsGczurzHHAsgt16HmcsEMN98dgGTUse6barPo+4opG/Gwb9E94sk9vMnJ+bZYjxm
         j2FGGKoXe967CWThUovANn0b1U1+Y4T75WgCIg8bIohjcIP52m0k5V2GQGzJetze96Ot
         Z1JQ==
X-Gm-Message-State: AOJu0YyVskAH0k5mcoHJI4v5ZefYBcE+FjMtiPXSvgL/0TwY7lYaF3eC
	b10dWSyItYzlJqSf5IcHspLZNEk0vYN+2/FR8Go3a0uKgT6CQ/hBJqq83baosIJMk+nMOcnGZK5
	WhlTH7w==
X-Google-Smtp-Source: AGHT+IHx4Li2ZIEKf0xP3cTYDpK7FV67BrOnN4rZ2Ti+ZOk2X9O83GLHRiTcWYV8fIum9BJow6Qw0lDB6kY=
X-Received: from pgg23.prod.google.com ([2002:a05:6a02:4d97:b0:c08:6ff5:286b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1584:b0:35d:7f7:4aac
 with SMTP id adf61e73a8af0-369afa01e9emr13111683637.47.1765848561029; Mon, 15
 Dec 2025 17:29:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 15 Dec 2025 17:29:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251216012918.1707681-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Disallow access to vmcs12 fields that aren't
 supported by "hardware"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
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

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://lore.kernel.org/all/20251026201911.505204-22-xin@zytor.com
Link: https://lore.kernel.org/all/YR2Tf9WPNEzrE7Xg@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c |  6 -----
 arch/x86/kvm/vmx/vmcs.h   |  8 ++++++
 arch/x86/kvm/vmx/vmcs12.c | 55 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmcs12.h |  8 ++++--
 arch/x86/kvm/vmx/vmx.c    |  2 ++
 5 files changed, 69 insertions(+), 10 deletions(-)

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
index 4233b5ca9461..78eca9399975 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -9,7 +9,7 @@
 	FIELD(number, name),						\
 	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
 
-const unsigned short vmcs12_field_offsets[] = {
+const __initconst u16 supported_vmcs12_field_offsets[] = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
 	FIELD(POSTED_INTR_NV, posted_intr_nv),
 	FIELD(GUEST_ES_SELECTOR, guest_es_selector),
@@ -158,4 +158,55 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(HOST_SSP, host_ssp),
 	FIELD(HOST_INTR_SSP_TABLE, host_ssp_tbl),
 };
-const unsigned int nr_vmcs12_fields = ARRAY_SIZE(vmcs12_field_offsets);
+
+u16 vmcs12_field_offsets[ARRAY_SIZE(supported_vmcs12_field_offsets)] __ro_after_init;
+unsigned int nr_vmcs12_fields __ro_after_init;
+
+#define VMCS12_CASE64(enc) case enc##_HIGH: case enc
+
+static __init bool cpu_has_vmcs12_field(unsigned int idx)
+{
+	switch (VMCS12_IDX_TO_ENC(idx)) {
+	case VIRTUAL_PROCESSOR_ID: return cpu_has_vmx_vpid();
+	case POSTED_INTR_NV: return cpu_has_vmx_posted_intr();
+	VMCS12_CASE64(TSC_MULTIPLIER): return cpu_has_vmx_tsc_scaling();
+	VMCS12_CASE64(VIRTUAL_APIC_PAGE_ADDR): return cpu_has_vmx_tpr_shadow();
+	VMCS12_CASE64(APIC_ACCESS_ADDR): return cpu_has_vmx_virtualize_apic_accesses();
+	VMCS12_CASE64(POSTED_INTR_DESC_ADDR): return cpu_has_vmx_posted_intr();
+	VMCS12_CASE64(VM_FUNCTION_CONTROL): return cpu_has_vmx_vmfunc();
+	VMCS12_CASE64(EPT_POINTER): return cpu_has_vmx_ept();
+	VMCS12_CASE64(EPTP_LIST_ADDRESS): return cpu_has_vmx_vmfunc();
+	VMCS12_CASE64(XSS_EXIT_BITMAP): return cpu_has_vmx_xsaves();
+	VMCS12_CASE64(ENCLS_EXITING_BITMAP): return cpu_has_vmx_encls_vmexit();
+	VMCS12_CASE64(GUEST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
+	VMCS12_CASE64(HOST_IA32_PERF_GLOBAL_CTRL): return cpu_has_load_perf_global_ctrl();
+	case TPR_THRESHOLD: return cpu_has_vmx_tpr_shadow();
+	case SECONDARY_VM_EXEC_CONTROL: return cpu_has_secondary_exec_ctrls();
+	case GUEST_S_CET: return cpu_has_load_cet_ctrl();
+	case GUEST_SSP: return cpu_has_load_cet_ctrl();
+	case GUEST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
+	case HOST_S_CET: return cpu_has_load_cet_ctrl();
+	case HOST_SSP: return cpu_has_load_cet_ctrl();
+	case HOST_INTR_SSP_TABLE: return cpu_has_load_cet_ctrl();
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
+	for (i = 0; i < ARRAY_SIZE(supported_vmcs12_field_offsets); i++) {
+		if (!supported_vmcs12_field_offsets[i] ||
+		    !cpu_has_vmcs12_field(i))
+			continue;
+
+		vmcs12_field_offsets[i] = supported_vmcs12_field_offsets[i];
+		nr_vmcs12_fields = i + 1;
+	}
+}
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..e5905ba0bb42 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -374,8 +374,12 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(guest_pml_index, 996);
 }
 
-extern const unsigned short vmcs12_field_offsets[];
-extern const unsigned int nr_vmcs12_fields;
+extern const __initconst u16 supported_vmcs12_field_offsets[];
+
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

base-commit: 58e10b63777d0aebee2cf4e6c67e1a83e7edbe0f
-- 
2.52.0.239.gd5f0c6e74e-goog


