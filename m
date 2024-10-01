Return-Path: <kvm+bounces-27723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BCC98B357
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D71011F24416
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914CE1BDAAA;
	Tue,  1 Oct 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="jFou4zmL"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F1519307D;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758938; cv=none; b=kGfm0Ee47BPtRmHDUSYFEUe5gxH0kZaJ25srouOdxjW+Tws9GErfowoMUwUnKDQCyIZIaDSNHd7Z0yDn2hQgw4tdEunpZgC1nl3H0p/g9D15WqUQ66kWnH5zScnznfibDuUjYwPxgckHMZZwLc5W9HjZUpxCv+QzOnh2H8YfVzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758938; c=relaxed/simple;
	bh=PJ0Ruvlhl5M8W6RSvcvYhSrLqloxjrMLxWnQr2qse80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzFbG0Qpc7PPmIuTOTEPhNlfR7KgwYirSh+M8H7oDArZZnoCKFwqFMQAEWf+Bg5gPnpNL2hxc90JWQEs0YXJu9N47lH1VlNDvKFhU7Riti8YdLuyf4sA3XEDlJV4jm3O2JNfBsoLNfvrEZ0bLn+fqnMV8HcikzsMBnDCGPz/hz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=jFou4zmL; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7h3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7h3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758894;
	bh=CpAjqAnGmOHBrw112EUU3ecVY9Z5DDNeNfmxMbaNmvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFou4zmLraTdJHufGkOsayw4l/aOSyJ4anTJ2B064rz9sIG1j+h8IB7/xEHGK1bkZ
	 KbJogd6IqMOpuBaT/mYK+yB/q/AsPADrF8hxDXA565IC+5HDgNOG3TE2SNxhmBVXZQ
	 fTYJG9jtiT+XpGzY58BPoO5bPwl4IpjLIGSIXR0XB8SIKmgNUw0+WpvpaNxdFEf1GJ
	 sDbV+GN/lQEoy5eoOUR1b+PZPeQKBuIIJgj6Yb8fMmpWdQSRrGcvx7mPzba9LaySIR
	 sFw8cOtl1oFeP7JyFhl8VdNh7hyZTq/SS5pXLOqVDdcSNSga54+TU1ZEKpw6ZS3X2h
	 sgz1njE6VIJAQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 18/27] KVM: VMX: Dump FRED context in dump_vmcs()
Date: Mon, 30 Sep 2024 22:01:01 -0700
Message-ID: <20241001050110.3643764-19-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Add FRED related VMCS fields to dump_vmcs() to dump FRED context.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Change since v2:
* Use (vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED) instead of is_fred_enabled()
  (Chao Gao).

Change since v1:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
* Dump guest FRED states only if guest has FRED enabled (Nikolay Borisov).
---
 arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bfdd10773136..ef807194ccbd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6399,7 +6399,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
-	u64 tertiary_exec_control;
+	u64 tertiary_exec_control, secondary_vmexit_ctl;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -6410,6 +6410,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 
 	vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
 	vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
+	secondary_vmexit_ctl = cpu_has_secondary_vmexit_ctrls() ?
+			       vmcs_read64(SECONDARY_VM_EXIT_CONTROLS) : 0;
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
@@ -6456,6 +6458,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_FRED)
+		pr_err("FRED guest: config=0x%016llx, stack_levels=0x%016llx\n"
+		       "RSP0=0x%016llx, RSP1=0x%016llx\n"
+		       "RSP2=0x%016llx, RSP3=0x%016llx\n",
+		       vmcs_read64(GUEST_IA32_FRED_CONFIG),
+		       vmcs_read64(GUEST_IA32_FRED_STKLVLS),
+		       __rdmsr(MSR_IA32_FRED_RSP0),
+		       vmcs_read64(GUEST_IA32_FRED_RSP1),
+		       vmcs_read64(GUEST_IA32_FRED_RSP2),
+		       vmcs_read64(GUEST_IA32_FRED_RSP3));
 	efer_slot = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest, MSR_EFER);
 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
 		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
@@ -6503,6 +6515,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	       vmcs_readl(HOST_TR_BASE));
 	pr_err("GDTBase=%016lx IDTBase=%016lx\n",
 	       vmcs_readl(HOST_GDTR_BASE), vmcs_readl(HOST_IDTR_BASE));
+	if (vmexit_ctl & SECONDARY_VM_EXIT_LOAD_IA32_FRED)
+		pr_err("FRED host: config=0x%016llx, stack_levels=0x%016llx\n"
+		       "RSP0=0x%016lx, RSP1=0x%016llx\n"
+		       "RSP2=0x%016llx, RSP3=0x%016llx\n",
+		       vmcs_read64(HOST_IA32_FRED_CONFIG),
+		       vmcs_read64(HOST_IA32_FRED_STKLVLS),
+		       (unsigned long)task_stack_page(current) + THREAD_SIZE,
+		       vmcs_read64(HOST_IA32_FRED_RSP1),
+		       vmcs_read64(HOST_IA32_FRED_RSP2),
+		       vmcs_read64(HOST_IA32_FRED_RSP3));
 	pr_err("CR0=%016lx CR3=%016lx CR4=%016lx\n",
 	       vmcs_readl(HOST_CR0), vmcs_readl(HOST_CR3),
 	       vmcs_readl(HOST_CR4));
@@ -6524,25 +6546,29 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	pr_err("*** Control State ***\n");
 	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
 	       cpu_based_exec_ctrl, secondary_exec_control, tertiary_exec_control);
-	pr_err("PinBased=0x%08x EntryControls=%08x ExitControls=%08x\n",
-	       pin_based_exec_ctrl, vmentry_ctl, vmexit_ctl);
+	pr_err("PinBased=0x%08x EntryControls=0x%08x\n",
+	       pin_based_exec_ctrl, vmentry_ctl);
+	pr_err("ExitControls=0x%08x SecondaryExitControls=0x%016llx\n",
+	       vmexit_ctl, secondary_vmexit_ctl);
 	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
 	       vmcs_read32(EXCEPTION_BITMAP),
 	       vmcs_read32(PAGE_FAULT_ERROR_CODE_MASK),
 	       vmcs_read32(PAGE_FAULT_ERROR_CODE_MATCH));
-	pr_err("VMEntry: intr_info=%08x errcode=%08x ilen=%08x\n",
+	pr_err("VMEntry: intr_info=%08x errcode=%08x ilen=%08x event_data=%016llx\n",
 	       vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
 	       vmcs_read32(VM_ENTRY_EXCEPTION_ERROR_CODE),
-	       vmcs_read32(VM_ENTRY_INSTRUCTION_LEN));
+	       vmcs_read32(VM_ENTRY_INSTRUCTION_LEN),
+	       kvm_cpu_cap_has(X86_FEATURE_FRED) ? vmcs_read64(INJECTED_EVENT_DATA) : 0);
 	pr_err("VMExit: intr_info=%08x errcode=%08x ilen=%08x\n",
 	       vmcs_read32(VM_EXIT_INTR_INFO),
 	       vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 	       vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
 	pr_err("        reason=%08x qualification=%016lx\n",
 	       vmcs_read32(VM_EXIT_REASON), vmcs_readl(EXIT_QUALIFICATION));
-	pr_err("IDTVectoring: info=%08x errcode=%08x\n",
+	pr_err("IDTVectoring: info=%08x errcode=%08x event_data=%016llx\n",
 	       vmcs_read32(IDT_VECTORING_INFO_FIELD),
-	       vmcs_read32(IDT_VECTORING_ERROR_CODE));
+	       vmcs_read32(IDT_VECTORING_ERROR_CODE),
+	       kvm_cpu_cap_has(X86_FEATURE_FRED) ? vmcs_read64(ORIGINAL_EVENT_DATA) : 0);
 	pr_err("TSC Offset = 0x%016llx\n", vmcs_read64(TSC_OFFSET));
 	if (secondary_exec_control & SECONDARY_EXEC_TSC_SCALING)
 		pr_err("TSC Multiplier = 0x%016llx\n",
-- 
2.46.2


