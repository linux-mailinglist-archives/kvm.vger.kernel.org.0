Return-Path: <kvm+bounces-49324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F95AD7DCE
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80FAA3B3DF8
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F8A2E0B72;
	Thu, 12 Jun 2025 21:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QR5iz42j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93302D8DB1;
	Thu, 12 Jun 2025 21:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749765030; cv=none; b=tAkTkXVN7I7FNDmJD6WC7Vsg5luViBAmtnkOBT1UOKlH3HfX8Ec1IO0AOO1GWSak1Zb49LvAXGiosyiip9yIbWjDzVv0iB24Mhbvp11nqUV22sbOwiWo8ogGvUWVrWQjp+0cZ7lwiEYNfqIkIGMexA4aofOXbr1COLPYvEN8euI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749765030; c=relaxed/simple;
	bh=137GFuU0KoBhNJyOTqbSzEaWwq8IPMkvvJDiWbT7sJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAOGX28+BOPRM1nEfh+l53M3dwjS83G6oYQM6uNeZI3gKC5PoBdPW+ZoZIM99N/wyNLsf2lS1bJVDzwEbXjNyyE4DXcZKfix/6hJcV3l25e02ALHZlLgwrA95SrNzxf5P6lSbnUOFSev7EZHHYXVpRF38R+G9HRq1bd3DCGXwvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QR5iz42j; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749765029; x=1781301029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=137GFuU0KoBhNJyOTqbSzEaWwq8IPMkvvJDiWbT7sJ8=;
  b=QR5iz42jRmqDZbXYnu6A5UCqvZrWsTp6l2IlGsmXJLv8ytZUK/WB9dvk
   fnmDX4uL4P0W/lDJEnwcVmBTY5gcQLFq2c4ctxsRupTRwMomptn4+FqZm
   fWNjT+bBb08H7d6heZQg9Qk3A8re0o+pn4YTVFBqpsHQZFcTS+9z0caMj
   IvnK3UOBLaRm2ZDdfELJ0IbSzhyUgKuQjGj37I0i319tAAK0eAQNOfk8o
   KA+c4rPPvAzHdpVt87GkOwhtaeOuarF27NQJWN4dsBEtErN0h81qleGNH
   KuKFJFC3nyX69T1RiXGL0qkV0zGynm2oiL/Ya0jSML3+0X8ZD47DDJfI/
   Q==;
X-CSE-ConnectionGUID: 8h2nae7mTO+gD/qPP4FLZg==
X-CSE-MsgGUID: sX3HBmmyRpye2YaSmRnzeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="52065307"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="52065307"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 14:50:27 -0700
X-CSE-ConnectionGUID: MIiUCDU6TLeeYuJIpa97LA==
X-CSE-MsgGUID: rkm4chbuTtGgFW6Ln+MC+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="184881943"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by orviesa001.jf.intel.com with ESMTP; 12 Jun 2025 14:50:26 -0700
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
Subject: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point from KVM
Date: Thu, 12 Jun 2025 14:48:41 -0700
Message-ID: <20250612214849.3950094-3-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250612214849.3950094-1-sohil.mehta@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the FRED NMI entry point from KVM to take an extra argument to
allow KVM to invoke the FRED event dispatch framework with event data.

This API is used to pass the NMI-source bitmap for NMI-induced VM exits.
Read the VMCS exit qualification field to get the NMI-source information
and store it as event data precisely in the format expected by the FRED
event framework.

Read the VMCS exit qualification unconditionally since almost all
upcoming CPUs are expected to enable FRED and NMI-source together. In
the rare case that NMI-source isn't enabled, the extra VMREAD would be
harmless since the exit qualification is expected to be zero.

Suggested-by: Sean Christopherson <seanjc@google.com>
Originally-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v7: Pass the event data from KVM only for NMI. (Sean)

v6: No change

v5: Read the VMCS exit qualification unconditionally. (Sean)
    Combine related patches into one.
---
 arch/x86/entry/entry_64_fred.S |  2 +-
 arch/x86/include/asm/fred.h    | 11 ++++++-----
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 29c5c32c16c3..1c9c6e036233 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -93,7 +93,7 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
 	 * +--------+-----------------+
 	 */
 	push $0				/* Reserved, must be 0 */
-	push $0				/* Event data, 0 for IRQ/NMI */
+	push %rsi			/* Event data for NMI */
 	push %rdi			/* fred_ss handed in by the caller */
 	push %rbp
 	pushf
diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 552332ca060c..bccf4a3c06b8 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -66,14 +66,14 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 
 void asm_fred_entrypoint_user(void);
 void asm_fred_entrypoint_kernel(void);
-void asm_fred_entry_from_kvm(struct fred_ss);
+void asm_fred_entry_from_kvm(struct fred_ss ss, unsigned long edata);
 
 __visible void fred_entry_from_user(struct pt_regs *regs);
 __visible void fred_entry_from_kernel(struct pt_regs *regs);
 __visible void __fred_entry_from_kvm(struct pt_regs *regs);
 
 /* Must be called from noinstr code, thus __always_inline */
-static __always_inline void fred_nmi_from_kvm(void)
+static __always_inline void fred_nmi_from_kvm(unsigned long edata)
 {
 	struct fred_ss ss = {
 		.ss	= __KERNEL_DS,
@@ -83,7 +83,7 @@ static __always_inline void fred_nmi_from_kvm(void)
 		.lm	= 1,
 	};
 
-	asm_fred_entry_from_kvm(ss);
+	asm_fred_entry_from_kvm(ss, edata);
 }
 
 static inline void fred_irq_from_kvm(unsigned int vector)
@@ -95,7 +95,8 @@ static inline void fred_irq_from_kvm(unsigned int vector)
 		.lm	= 1,
 	};
 
-	asm_fred_entry_from_kvm(ss);
+	/* Event data is always zero for IRQ */
+	asm_fred_entry_from_kvm(ss, 0);
 }
 
 void cpu_init_fred_exceptions(void);
@@ -123,7 +124,7 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs) { ret
 static inline void cpu_init_fred_exceptions(void) { }
 static inline void cpu_init_fred_rsps(void) { }
 static inline void fred_complete_exception_setup(void) { }
-static __always_inline void fred_nmi_from_kvm(void) { }
+static __always_inline void fred_nmi_from_kvm(unsigned long edata) { }
 static inline void fred_irq_from_kvm(unsigned int vector) { }
 static inline void fred_sync_rsp0(unsigned long rsp0) { }
 static inline void fred_update_rsp0(void) { }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8183886eda3d..69832ca31e5b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7264,7 +7264,7 @@ noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu)
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 	if (cpu_feature_enabled(X86_FEATURE_FRED))
-		fred_nmi_from_kvm();
+		fred_nmi_from_kvm(vmx_get_exit_qual(vcpu));
 	else
 		vmx_do_nmi_irqoff();
 	kvm_after_interrupt(vcpu);
-- 
2.43.0


