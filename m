Return-Path: <kvm+bounces-56330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C61B8B3BF51
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9DBD1CC0CB4
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF1432A3D7;
	Fri, 29 Aug 2025 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AKaL+HIs"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85F1FDA8E;
	Fri, 29 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481589; cv=none; b=rxiShqnGatrLMePwFx3o6EsuLNW1WyOWZtVn2ZbIkVHEdmtjZajY607AuIXpMGFcGqebRSP57WQQ97Zfnqz2w8j2l8V0by+XaqTtF6A/t+pqDQ9v/jHAYzlrxg5ed80tCj+Op0J1nhHg1PB1c9ywmiLV4rSzGSVLcxjUmT1diqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481589; c=relaxed/simple;
	bh=ARFaGoblNDj/7V5u02fzaPmoWcAukAa38gvCZrRWPrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJXI6UBss+rYQp9d8RrxWo6ttLgyfIO2W23mu3U3aLzGv0MnOLT/EYYAW+1A/XlJZLMZFmKgNfCCHOEaTeY7bMx1tsfssIsMvVNibpbuhx2jgO8/CzmUEbVGvh2WE28omO4ofNcv8DcA9EgtFIATGMQQpvZcD/323RLO8XyUAAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AKaL+HIs; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4L2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4L2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481546;
	bh=u76jAY9BM212NYWyi3pL6oF5mg9gsqc88AxmrQcbX2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKaL+HIsA8JKK+0dSA+Ti8415+LPr0w8MlX6A0bM8jzwhj9PsWoeaycgkAdYdR70K
	 MgbHv2BaC/h2WChdF96DhLWk0xU8hhRLJBKyZnidGc7TpcvMOkBSsIicM/mw6iUWmO
	 UkB3Er1hZf8C7kelHUICVQjipqXDxsCLIjAf5LtFgdL2YuJ1Y+Nb8vODPfXSSSvBKX
	 4500mr3PXGtBfWftANn6LD9/SxcWFlOzECVGbXxbWclQcOLWnn+AAmIcouN2l6jRrn
	 8a/Wh6kso7JkWM2hxOGtgsCfcijL1SGCN9LodAISwPi7qf1R5uOnABS2FwQuMslfX5
	 vJOEyWpzwaJ8g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 15/21] KVM: VMX: Dump FRED context in dump_vmcs()
Date: Fri, 29 Aug 2025 08:31:43 -0700
Message-ID: <20250829153149.2871901-16-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
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
index 3d968584d854..c280e4cd4485 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1399,6 +1399,9 @@ static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
 	vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
 				 &vmx->msr_guest_fred_rsp0);
 }
+#else
+/* Make sure it builds on 32-bit */
+static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx) { return 0; }
 #endif
 
 static void grow_ple_window(struct kvm_vcpu *vcpu)
@@ -6436,7 +6439,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
-	u64 tertiary_exec_control;
+	u64 tertiary_exec_control, secondary_vmexit_ctl;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -6447,6 +6450,8 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 
 	vmentry_ctl = vmcs_read32(VM_ENTRY_CONTROLS);
 	vmexit_ctl = vmcs_read32(VM_EXIT_CONTROLS);
+	secondary_vmexit_ctl = cpu_has_secondary_vmexit_ctrls() ?
+			       vmcs_read64(SECONDARY_VM_EXIT_CONTROLS) : 0;
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
@@ -6493,6 +6498,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6544,6 +6559,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6569,25 +6594,29 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
2.51.0


