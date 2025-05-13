Return-Path: <kvm+bounces-46387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E158FAB5DC1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7285319E2F3C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E8D2BFC9E;
	Tue, 13 May 2025 20:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IMzBGrsm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E32C1A3A8D;
	Tue, 13 May 2025 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747168679; cv=none; b=tBWIaImVTpr1wlrCktyrUtfaKXpGZxjRekjR24gEy6dsEJh9AiV2AeQ/Qjb7MU3G9Yy8fFdud2s81cl4B6CEHK6E2/79eRTzTZjd9WO0tVvrHfadrZ81mFC1fP87V91umSzd+XvBu604Rlm7/094YY2DCtmP0AdqaVzyQPYgXmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747168679; c=relaxed/simple;
	bh=hyHqRWQkgZHimpVOiM5Vr4ymbwLjjHj3vyxzS3WaAW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mexyEP6OzDEov+HgZ3wWIUEQoWm/Kp/GefiR7GGMKvyT2FWVU7KNai7s1nS6l2OHqJtmiBdKKgafpaE2awtzMBPirqaQoUlbg0TnN48GCWjPvvhKCih6xVe8zzYcQ9csPCUL3Z88dwrdBDr+6XbWIqeLtzwzh2OFQrgg7HclzyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IMzBGrsm; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747168678; x=1778704678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hyHqRWQkgZHimpVOiM5Vr4ymbwLjjHj3vyxzS3WaAW8=;
  b=IMzBGrsmUbyh3LZjHw5+6kasJf94KGAF0odU2T35e+oa/iEyQj8uEdst
   fjL/StFctUBF/HiTnH+YEslKoYQDyBhMbL2jUHjNfaOKOk2C4jqIUfLsE
   tgTrRSZenKwEVfG9aEfRyIyWXiH0qxjh3VaUQmQqaNxeOTBZryMiyJ0jC
   WDwYyujh2Vfv6DHu3z36fH2VJ2XMzsa+8hAdHLs5crId00JOxYl2SKlv2
   tyac11XutO49DmxZI7XdMcJeAyU/NDbtqkOfAkvfeJIz8wN8AUJXIxUcB
   XIeK/yKZb5LzkgElA9nvEskZ6TDxquRGNQX7gExZs1IbpxZytD7uBOqfy
   w==;
X-CSE-ConnectionGUID: Wa1Coh/cTGiPqoayBXJSMg==
X-CSE-MsgGUID: mDH0WrUqRiKRDEvIl3zFsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="49160397"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="49160397"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 13:37:56 -0700
X-CSE-ConnectionGUID: Vhzvh1imRuGZrVTfH1G2PQ==
X-CSE-MsgGUID: OduXNNR1QUS8yfqCK9BMdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138241714"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa008.fm.intel.com with ESMTP; 13 May 2025 13:37:55 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v6 1/9] x86/fred, KVM: VMX: Pass event data to the FRED entry point from KVM
Date: Tue, 13 May 2025 13:37:55 -0700
Message-ID: <20250513203803.2636561-2-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250513203803.2636561-1-sohil.mehta@intel.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zeng Guang <guang.zeng@intel.com>

Extend the FRED entry point from KVM to take an extra argument to allow
KVM to invoke the FRED event dispatch framework with event data.

The first use of this extended API is to pass the NMI-source bitmap for
NMI-induced VM exits. Read the VMCS exit qualification field to get the
NMI-source information and store it as event data precisely in the
format expected by the FRED event framework.

Read the VMCS exit qualification unconditionally since almost all
upcoming CPUs are expected to enable FRED and NMI-source together. In
the rare case that NMI-source isn't enabled, the extra VMREAD would be
harmless since the exit qualification is expected to be zero.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v6: No change

v5: Read the VMCS exit qualification unconditionally. (Sean)
    Combine related patches into one.
---
 arch/x86/entry/entry_64_fred.S | 2 +-
 arch/x86/include/asm/fred.h    | 9 +++++----
 arch/x86/kvm/vmx/vmx.c         | 5 +++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 29c5c32c16c3..a61256be9703 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -93,7 +93,7 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
 	 * +--------+-----------------+
 	 */
 	push $0				/* Reserved, must be 0 */
-	push $0				/* Event data, 0 for IRQ/NMI */
+	push %rsi			/* Event data for IRQ/NMI */
 	push %rdi			/* fred_ss handed in by the caller */
 	push %rbp
 	pushf
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 2a29e5216881..a4de57e578c4 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -64,14 +64,15 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 
 void asm_fred_entrypoint_user(void);
 void asm_fred_entrypoint_kernel(void);
-void asm_fred_entry_from_kvm(struct fred_ss);
+void asm_fred_entry_from_kvm(struct fred_ss ss, unsigned long edata);
 
 __visible void fred_entry_from_user(struct pt_regs *regs);
 __visible void fred_entry_from_kernel(struct pt_regs *regs);
 __visible void __fred_entry_from_kvm(struct pt_regs *regs);
 
 /* Can be called from noinstr code, thus __always_inline */
-static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int vector)
+static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int vector,
+						unsigned long edata)
 {
 	struct fred_ss ss = {
 		.ss     =__KERNEL_DS,
@@ -81,7 +82,7 @@ static __always_inline void fred_entry_from_kvm(unsigned int type, unsigned int
 		.lm     = 1,
 	};
 
-	asm_fred_entry_from_kvm(ss);
+	asm_fred_entry_from_kvm(ss, edata);
 }
 
 void cpu_init_fred_exceptions(void);
@@ -109,7 +110,7 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs) { ret
 static inline void cpu_init_fred_exceptions(void) { }
 static inline void cpu_init_fred_rsps(void) { }
 static inline void fred_complete_exception_setup(void) { }
-static inline void fred_entry_from_kvm(unsigned int type, unsigned int vector) { }
+static inline void fred_entry_from_kvm(unsigned int type, unsigned int vector, unsigned long edata) { }
 static inline void fred_sync_rsp0(unsigned long rsp0) { }
 static inline void fred_update_rsp0(void) { }
 #endif /* CONFIG_X86_FRED */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c5766467a61..1d43d4a2f6b6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7079,7 +7079,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	if (cpu_feature_enabled(X86_FEATURE_FRED))
-		fred_entry_from_kvm(EVENT_TYPE_EXTINT, vector);
+		fred_entry_from_kvm(EVENT_TYPE_EXTINT, vector, 0);
 	else
 		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
 	kvm_after_interrupt(vcpu);
@@ -7393,7 +7393,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	    is_nmi(vmx_get_intr_info(vcpu))) {
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 		if (cpu_feature_enabled(X86_FEATURE_FRED))
-			fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
+			fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR,
+					    vmx_get_exit_qual(vcpu));
 		else
 			vmx_do_nmi_irqoff();
 		kvm_after_interrupt(vcpu);
-- 
2.43.0


