Return-Path: <kvm+bounces-53295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46DBBB0F9C9
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24426AA3A86
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4522264BA;
	Wed, 23 Jul 2025 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="mUTjzNyC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9B6224B07;
	Wed, 23 Jul 2025 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293281; cv=none; b=OVLYahInWzCMXo5bC24tZMtayTHbLB6OeY6NSV/GI/EurQLjGGOLY5Um4sP26rWZ3x+yyaRpo475hHfK1bmwL4oTrD9yvyUBfuW18xe2rSpjyQxIrtwshpYlsrMjtsbwOKOi49L8IKXkI1VgibkqjCTMjE6OMZ7OM028/85YUUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293281; c=relaxed/simple;
	bh=j21WdZ+wd9RRAfQbWDIOAbgnrsMuOoAXcfqQaZ4HBso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCKBUzW9/Uv+YiG9NgALjnH6O38lINFnPwulRi7JhCYiXTLaltTy5ZlOPdPNeVifHICirsJVvxDj9koCYUQ9l//ENcD+UlYudYzo9PBvSd69tifXQhB6dKqvf0lvLEX4SBOl8GF/G3xnHUB5LVWAkS1hMgS3jvuH/gM4r11aCvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=mUTjzNyC; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrf071284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:54:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrf071284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293242;
	bh=9sTk7GlM4pzW7YhSsUUJXP4SlDFbJfiCcxa4ExZ1RRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUTjzNyCZN1hd65haVrsxkh3LldR8mOeRfbRQvl84kfF0MBlRb1wD1SSQT5Lsx1+W
	 GcrmCv0tAWK3UE/kx7h9biuT8lI4/nY+308ugxtInVz1CO0BdUUuzKWlT+vxLjDbna
	 JSnKa7J/0Gq4zkyq+v9weP46y6BWoGLA2PaTsyDLebqjMMZ2iVLQKd0hznrBe4s0QT
	 L5OJA98fPYUfez226nhyljp9yOaSMTff4vDsdTBpv+KU4fzuLYhOZC9kGlyzkw2HCL
	 QmKJtsI3urjc9cyRYhWHSCIAn1f/EzGAgRueze43FAc18vrhaS/MNWszeddcVJuh2v
	 rdKcw4dO1DgvA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 17/23] KVM: VMX: Dump FRED context in dump_vmcs()
Date: Wed, 23 Jul 2025 10:53:35 -0700
Message-ID: <20250723175341.1284463-18-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
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
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v5:
* Read guest FRED RSP0 with vmx_read_guest_fred_rsp0() (Sean).
* Add TB from Xuelian Guo.

Change in v3:
* Use (vmentry_ctrl & VM_ENTRY_LOAD_IA32_FRED) instead of is_fred_enabled()
  (Chao Gao).

Changes in v2:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
* Dump guest FRED states only if guest has FRED enabled (Nikolay Borisov).
---
 arch/x86/kvm/vmx/vmx.c | 43 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ca01980295e..90f0573c8187 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1400,6 +1400,9 @@ static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
 	vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
 				 &vmx->msr_guest_fred_rsp0);
 }
+#else
+/* To make sure dump_vmcs() compile on 32-bit */
+static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx) { return 0; }
 #endif
 
 static void grow_ple_window(struct kvm_vcpu *vcpu)
@@ -6343,7 +6346,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
-	u64 tertiary_exec_control;
+	u64 tertiary_exec_control, secondary_vmexit_ctl;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -6354,6 +6357,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 
 	vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
 	vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
+	secondary_vmexit_ctl = cpu_has_secondary_vmexit_ctrls() ?
+			       vmcs_read64(SECONDARY_VM_EXIT_CONTROLS) : 0;
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
@@ -6400,6 +6405,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	vmx_dump_sel("LDTR:", GUEST_LDTR_SELECTOR);
 	vmx_dump_dtsel("IDTR:", GUEST_IDTR_LIMIT);
 	vmx_dump_sel("TR:  ", GUEST_TR_SELECTOR);
+	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_FRED)
+		pr_err("FRED guest: config=0x%016llx, stack_levels=0x%016llx\n"
+		       "RSP0=0x%016llx, RSP1=0x%016llx\n"
+		       "RSP2=0x%016llx, RSP3=0x%016llx\n",
+		       vmcs_read64(GUEST_IA32_FRED_CONFIG),
+		       vmcs_read64(GUEST_IA32_FRED_STKLVLS),
+		       vmx_read_guest_fred_rsp0(vmx),
+		       vmcs_read64(GUEST_IA32_FRED_RSP1),
+		       vmcs_read64(GUEST_IA32_FRED_RSP2),
+		       vmcs_read64(GUEST_IA32_FRED_RSP3));
 	efer_slot = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest, MSR_EFER);
 	if (vmentry_ctl & VM_ENTRY_LOAD_IA32_EFER)
 		pr_err("EFER= 0x%016llx\n", vmcs_read64(GUEST_IA32_EFER));
@@ -6447,6 +6462,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6468,25 +6493,29 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
2.50.1


