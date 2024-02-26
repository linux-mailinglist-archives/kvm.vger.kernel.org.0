Return-Path: <kvm+bounces-9929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D17867A5E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88C48B32C8F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF51A14E2DA;
	Mon, 26 Feb 2024 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a20LGOAj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7608512FB08;
	Mon, 26 Feb 2024 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958368; cv=none; b=hnXoYfOtI+kIgFX/ZL/qaFjJDO4i89dwh8xGZevNyFqpHLb+cwmi1f9hWQ6VOU5Vs47wqu5poLRcDZTaJiK5+8QaD7ttdZdYg+2UrYkoJr5vlVwlaLqkF/itqake3TmTmjk8yE3ERGRISwxPlSbtdZr7qST9Lki6tWNukH7NWW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958368; c=relaxed/simple;
	bh=tzGizjCiHx7zVuGTWahlp4kf7Af8DRrnW2IXT6ESIME=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cEBeZ4IqKC0GYtw1LevP55PjDEFDbHPHxoJglVr7BEEv7I6Td9e9IPVrbD3Ritim/XnLLEx3gWJXhwehargq6MWzb0f/2Du/N061pFhRLwUC9PkxNV0p6n7mILbD3sUZOv9+BBHi93ZsLkVBSzPKxqsrR+nkXpPTUqq53VSj4Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a20LGOAj; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e46dcd8feaso829836b3a.2;
        Mon, 26 Feb 2024 06:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958365; x=1709563165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3obabIc0frWAPcp78SCT093DaVOW3OCMmYlsqxV6Jrg=;
        b=a20LGOAjh7ORdwZqHljJ9i+OAx1bqLix4/ayuMZVSwWI3jFeRATKYRSqeo7Gu5Ueyr
         aPTI5wS10Y/sOgfndViduFl3qrLp3EsMcMmhP1IoETtcOjwekdYVw7NlhbahHszwNTjT
         uuNGjRb7NTPL3SN4nS64zke3IyZGMSoTuuDLoR+O737g41gfbdca06j9sAWt97s10gRd
         eOEUZAZ++BueRF6RXCLLzAkPMq2lhq/zNfrPmbYCLyarZ5YYpT+USs4C8WXk7vB1L1vH
         PA6iZG2FQe5P4bsGVORbm2V9GcCb30eihZN0IjnekZ2U/m2LjvPCpdLiUHslxIeyP++w
         A4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958365; x=1709563165;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3obabIc0frWAPcp78SCT093DaVOW3OCMmYlsqxV6Jrg=;
        b=Z+5/nn8Qup1dDdky/IenWsAXEBCTUroEp0BU9uVvUHxsCF8OcJUKJICiblqyeAyqfd
         2pgTmhQTSFG4gyzzL0OT6nmoZQ8ECk7KK2Vg4D2DjGjeb0IPyiBrRqTEPFpTYdD898bX
         I+S2mm9jG1+EpEDbY9Cuk3+kdmin8fKXBuFCFmsi0vgX0PhzTLeWzllAiCMLLqgepor7
         uHetIy/ywQ28IYwiz9vPCZPOxrdLYvQ1/5f0fHtnwDus2sIdCVuEJ3HdbLO+xlc/7X5n
         04/YVzYHkbtcVr22RoTVWWxiThA2WDt4KjCrC4xY9MVFp5UhOqykQ0ne6mbCPg9RwCY8
         fwfw==
X-Forwarded-Encrypted: i=1; AJvYcCWZqFywSI3WEG1d5UuRjKIT8rR25ZtrbznBoi499nqWNgf+JSuI6BsXmdL8yXI2/hhibjqME0qNV/vC/64n/Eq22IPL
X-Gm-Message-State: AOJu0Yw6xwUos0C8uoj6IQ33SPT0sA/ug30kYjxIIQ72NLge/fNo5Zz6
	FS3myGu/I0desxNoFx15vietS7bmqb9GgIrmC3zgI1VdJplElC990Gv7WMGy
X-Google-Smtp-Source: AGHT+IHxB1SRDNUAQcM9eSd8jCrvT5j7mxZc3ehl/sTVGmSJcJcMTqd/bRM8vjNK9o0eC3pRQdhkvg==
X-Received: by 2002:a05:6a00:1817:b0:6e4:5a0f:b87a with SMTP id y23-20020a056a00181700b006e45a0fb87amr8639641pfa.12.1708958365514;
        Mon, 26 Feb 2024 06:39:25 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id l3-20020a62be03000000b006e04553a4c5sm4068362pff.52.2024.02.26.06.39.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:25 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <akaher@vmware.com>,
	Alexey Makhalov <amakhalov@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH 66/73] x86/pvm: Use new cpu feature to describe XENPV and PVM
Date: Mon, 26 Feb 2024 22:36:23 +0800
Message-Id: <20240226143630.33643-67-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Some PVOPS are patched as the native version directly if the guest is
not a XENPV guest. However, this approach will not work after
introducing a PVM guest. To address this, use a new CPU feature to
describe XENPV and PVM, and ensure that those PVOPS are patched only
when it is not a paravirtual guest.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/entry_64.S          |  5 ++---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/paravirt.h    | 14 +++++++-------
 arch/x86/kernel/pvm.c              |  1 +
 arch/x86/xen/enlighten_pv.c        |  1 +
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index fe12605b3c05..6b41a1837698 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -127,9 +127,8 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
 	 * In the PVM guest case we must use eretu synthetic instruction.
 	 */
 
-	ALTERNATIVE_2 "testb %al, %al; jz swapgs_restore_regs_and_return_to_usermode", \
-		"jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV, \
-		"jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_KVM_PVM_GUEST
+	ALTERNATIVE "testb %al, %al; jz swapgs_restore_regs_and_return_to_usermode", \
+		"jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_PV_GUEST
 
 	/*
 	 * We win! This label is here just for ease of understanding
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index e17e72f13423..72ef58a2db19 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -238,6 +238,7 @@
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* "" PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* Intel Trust Domain Extensions Guest */
 #define X86_FEATURE_KVM_PVM_GUEST	( 8*32+23) /* KVM Pagetable-based Virtual Machine guest */
+#define X86_FEATURE_PV_GUEST		( 8*32+24) /* "" Paravirtual guest */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index deaee9ec575e..a864ee481ca2 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -143,7 +143,7 @@ static __always_inline unsigned long read_cr2(void)
 {
 	return PVOP_ALT_CALLEE0(unsigned long, mmu.read_cr2,
 				"mov %%cr2, %%rax;",
-				ALT_NOT(X86_FEATURE_XENPV));
+				ALT_NOT(X86_FEATURE_PV_GUEST));
 }
 
 static __always_inline void write_cr2(unsigned long x)
@@ -154,13 +154,13 @@ static __always_inline void write_cr2(unsigned long x)
 static inline unsigned long __read_cr3(void)
 {
 	return PVOP_ALT_CALL0(unsigned long, mmu.read_cr3,
-			      "mov %%cr3, %%rax;", ALT_NOT(X86_FEATURE_XENPV));
+			      "mov %%cr3, %%rax;", ALT_NOT(X86_FEATURE_PV_GUEST));
 }
 
 static inline void write_cr3(unsigned long x)
 {
 	PVOP_ALT_VCALL1(mmu.write_cr3, x,
-			"mov %%rdi, %%cr3", ALT_NOT(X86_FEATURE_XENPV));
+			"mov %%rdi, %%cr3", ALT_NOT(X86_FEATURE_PV_GUEST));
 }
 
 static inline void __write_cr4(unsigned long x)
@@ -694,17 +694,17 @@ bool __raw_callee_save___native_vcpu_is_preempted(long cpu);
 static __always_inline unsigned long arch_local_save_flags(void)
 {
 	return PVOP_ALT_CALLEE0(unsigned long, irq.save_fl, "pushf; pop %%rax;",
-				ALT_NOT(X86_FEATURE_XENPV));
+				ALT_NOT(X86_FEATURE_PV_GUEST));
 }
 
 static __always_inline void arch_local_irq_disable(void)
 {
-	PVOP_ALT_VCALLEE0(irq.irq_disable, "cli;", ALT_NOT(X86_FEATURE_XENPV));
+	PVOP_ALT_VCALLEE0(irq.irq_disable, "cli;", ALT_NOT(X86_FEATURE_PV_GUEST));
 }
 
 static __always_inline void arch_local_irq_enable(void)
 {
-	PVOP_ALT_VCALLEE0(irq.irq_enable, "sti;", ALT_NOT(X86_FEATURE_XENPV));
+	PVOP_ALT_VCALLEE0(irq.irq_enable, "sti;", ALT_NOT(X86_FEATURE_PV_GUEST));
 }
 
 static __always_inline unsigned long arch_local_irq_save(void)
@@ -776,7 +776,7 @@ void native_pv_lock_init(void) __init;
 .endm
 
 #define SAVE_FLAGS	ALTERNATIVE "PARA_IRQ_save_fl;", "pushf; pop %rax;", \
-				    ALT_NOT(X86_FEATURE_XENPV)
+				    ALT_NOT(X86_FEATURE_PV_GUEST)
 #endif
 #endif /* CONFIG_PARAVIRT_XXL */
 #endif	/* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index c38e46a96ad3..d39550a8159f 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -300,6 +300,7 @@ void __init pvm_early_setup(void)
 		return;
 
 	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
+	setup_force_cpu_cap(X86_FEATURE_PV_GUEST);
 
 	wrmsrl(MSR_PVM_VCPU_STRUCT, __pa(this_cpu_ptr(&pvm_vcpu_struct)));
 	wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_early_kernel_event_entry - 256);
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index aeb33e0a3f76..c56483051528 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -335,6 +335,7 @@ static bool __init xen_check_xsave(void)
 static void __init xen_init_capabilities(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_XENPV);
+	setup_force_cpu_cap(X86_FEATURE_PV_GUEST);
 	setup_clear_cpu_cap(X86_FEATURE_DCA);
 	setup_clear_cpu_cap(X86_FEATURE_APERFMPERF);
 	setup_clear_cpu_cap(X86_FEATURE_MTRR);
-- 
2.19.1.6.gb485710b


