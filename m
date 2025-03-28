Return-Path: <kvm+bounces-42194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFD2A74EF8
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:14:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CBE63B3B99
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8708A1E3796;
	Fri, 28 Mar 2025 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RMk1QUpS"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2911CCB40;
	Fri, 28 Mar 2025 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181995; cv=none; b=L84Lwb9LLsWyVICj/y1h0zX1Gp8Eao/0DC+hzG5su3rRTd+BYi6kjGPO5KuABbp4+fYQsZDY2owG4+eg7ZyZE5COFlBRF19xGRY9dJR25QVGNjXgc3Q8Z1YfJ74Pc9DHJUYJuaC3QEoHAxZA7b0AnhZl1wRs7Hc0on0Ph5udC6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181995; c=relaxed/simple;
	bh=dW2HeoMtqelwz6O59/q0DiXoFyVUFCNavwvXitWFCj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHqe5EvLppJhs0Duja0CqZ/1rGZy+WgqQfrhjnlubzo5/0aO/kddM5aEnJH6wwxCUO7vJB8pSgkrF80uoSZwVok37t9l0WJen9kwuwDws2EZsHy3dPvGojUQDYZmmFoP+nZlxDq2pg8f9K7CKkp/kT4TmFKKnkueOO22I7f8Q7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RMk1QUpS; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vk2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vk2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181947;
	bh=BS7xz7iTWycVOZltNWA6vRzLaDaTCxHM+ZWDv+qm6NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMk1QUpSbmdJBA0N58hzlQH9o2jYjm60BgXcImO0zfo+AT9WuTgLxvwFl/lP/2ve6
	 0CmLBCHjh09XfZVEc0ic1YjYttiwFkM7vki7qRUS2yrRBWcPobOVMrlyXzxDXv0xCn
	 UGIW89MDmeMsvq8EA5+C3ARZPK4V2ofJoCPIjUGwGcE8Bus8epnkyMx2EGyEDrdEul
	 x3dMwe/wMOtUwYDQqV0kzj9y05vS+5P6CyBQKaCvgWcz4lId7HL4dGBSuVv4pCqE7q
	 9hnQI2WLNCoGAII7c0qm5WJwinnRs5UjVE4qyAd9VGMARMGic30vZEELEu+9ID0da3
	 5m09MJaltqa7g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 14/19] KVM: VMX: Dump FRED context in dump_vmcs()
Date: Fri, 28 Mar 2025 10:12:00 -0700
Message-ID: <20250328171205.2029296-15-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
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

Change in v3:
* Use (vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED) instead of is_fred_enabled()
  (Chao Gao).

Changes in v2:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
* Dump guest FRED states only if guest has FRED enabled (Nikolay Borisov).
---
 arch/x86/kvm/vmx/vmx.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c76015e1e3f8..03855d6690b2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6462,7 +6462,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
-	u64 tertiary_exec_control;
+	u64 tertiary_exec_control, secondary_vmexit_ctl;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -6473,6 +6473,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 
 	vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
 	vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
+	secondary_vmexit_ctl = cpu_has_secondary_vmexit_ctrls() ?
+			       vmcs_read64(SECONDARY_VM_EXIT_CONTROLS) : 0;
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
@@ -6519,6 +6521,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6566,6 +6578,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6587,25 +6609,29 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
2.48.1


