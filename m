Return-Path: <kvm+bounces-9927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD6886794A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3B772961FA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3174B12F5BA;
	Mon, 26 Feb 2024 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfkHOCHs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E6C12A17C;
	Mon, 26 Feb 2024 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958358; cv=none; b=lJRk3wZ4xjnV905vtjEQDOWztHEHeK76eKf6PqtJ2d451/2ABhx6pkn2ctxRiLcwoXU8/p1ZRqccY79BHGoExLK2Hvu0eCDNmce7b4VjQf38VKopz4AzJ7uyrlLhEiEAJXNqSWp/G0oEv/6yTvsmp8N77k0c27PeEpOZJXaAsag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958358; c=relaxed/simple;
	bh=kTY4wS3zVP5woxSl7wt9Hijoz3oVrwUyvBkwFVIbomc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FlzKZDYdg6M7g94+I1N3EkwZ1nTDUInpwSI0mh3RQT/IGeODYKPLCz2crI/58STb6Bsu4IkigShPlrXSufnRxIv8q48U7aq44YIz7xe1Xraw5ZHDAxnPxXNuc/U5nkywmoK9DtxekL6bpWnN3xPZFZdne26nGHtAL2LJthhGHv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XfkHOCHs; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d93edfa76dso26738595ad.1;
        Mon, 26 Feb 2024 06:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958356; x=1709563156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7gAp+Q6U/3m+V7ykKpuxVMkNBKRu+hZ/ADpZ+xq1uU=;
        b=XfkHOCHs+x3Z4AU9u5ryAMXeLOr/Cm+xUARi6Up7yciL/uZppayl5rizPCgCAlYadH
         PrP0bsJCEaGpsQ6NYu1kmmEGcX4XjHViS+uq44uPQwdPjCdra4MVSaVOg+gS211kOzVd
         eqHSZcPJeuUY5KqsMdMQB6PoBQbDBIpir3mbCK7Vj2HeypAfuAYuX3eS5P7dF4+7Dhpb
         /2ugYapBz+v20WwrD32G46JccE5NI/kNDPcCg6oZm5FpFGf9Lr2HTU7qqMjfGlcuczUH
         ljtkoVXBSDmFQnc+s/u0GDkZGO6FAF8CaXfmFUSsUiMlU+lbY8aZqJwkVr7wJ7heT9Ny
         6oEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958356; x=1709563156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7gAp+Q6U/3m+V7ykKpuxVMkNBKRu+hZ/ADpZ+xq1uU=;
        b=qmBM6LpGxSIiJuzBnZb/rR+06pBjJbdbjRh0Om3oqobBgryZUB0AE4ij4zb9KRx6Na
         k7MdkKwN6GHnY3ljOUV1HbHD5lD/Mecdns3s5KINTlkQHi1nUcgKDMBou0Fp0Fmlv0SV
         3jQfea6vyx2nwES177vUlVZ1jznFpG8ck4qlpztK29gIZbopVBBUGmLO53O3kq+qedgz
         xDPo9Ft5GndPmdXsNh2+DdNiV8ysIvxGBAKvBgVtfAUosnDi1AjhOh8JsVYZEBi2BqMS
         /ZOwf8bXKcLdfmfZfXZkpwlN0622scRKwLKGv/DggkenJqGdEtNQcJNDLOdaZ87v+Juk
         dp8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUDaNbEEffeyf786PyhIAr8qo7i3VX/1yyYo9JMfIISGsO1MGlI/rESJ8yJzs54JQtLvCGsJ0hNclAJMMTWvb91Fmde
X-Gm-Message-State: AOJu0YxUNEE1V0tEOUGEgTcw8Up8fH+rmD+hcKqQSaKr2rYo1bdqEN7i
	h93AayUrx+lvRw7pc0o4iwR8kTOTi5VICukEjP101usYM/mRj13eIxoxoIJg
X-Google-Smtp-Source: AGHT+IEWneBeaY+Xy8kg73z80/nF6qwXfZ9Jwoz7WSuwfJtgWsOkxvKS+hM3vdKwbX01UpLW/z6NYQ==
X-Received: by 2002:a17:902:f54f:b0:1dc:78b6:bbcf with SMTP id h15-20020a170902f54f00b001dc78b6bbcfmr9108923plf.63.1708958356107;
        Mon, 26 Feb 2024 06:39:16 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id ji22-20020a170903325600b001dc23e877bfsm4019205plb.268.2024.02.26.06.39.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:15 -0800 (PST)
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
	Nikolay Borisov <nik.borisov@suse.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Adam Dunlap <acdunlap@google.com>,
	Yuntao Wang <ytcoode@gmail.com>,
	Wang Jinchao <wangjinchao@xfusion.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH 64/73] x86/pvm: Enable PVM event delivery
Date: Mon, 26 Feb 2024 22:36:21 +0800
Message-Id: <20240226143630.33643-65-jiangshanlai@gmail.com>
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

Invoke pvm_early_setup() after idt_setup_early_handler() to enable early
kernel event delivery. Also, modify cpu_init_exception_handling() to
call pvm_setup_event_handling() in order to enable event delivery for
the current CPU. Additionally, for the syscall event, change MSR_LSTAR
to PVM specific entry.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/entry_64.S       |  9 ++++++--
 arch/x86/include/asm/pvm_para.h |  5 +++++
 arch/x86/kernel/cpu/common.c    | 11 ++++++++++
 arch/x86/kernel/head64.c        |  3 +++
 arch/x86/kernel/idt.c           |  2 ++
 arch/x86/kernel/pvm.c           | 37 +++++++++++++++++++++++++++++++++
 6 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 5b25ea4a16ae..fe12605b3c05 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -124,10 +124,12 @@ SYM_INNER_LABEL(entry_SYSCALL_64_after_hwframe, SYM_L_GLOBAL)
 	 * a completely clean 64-bit userspace context.  If we're not,
 	 * go to the slow exit path.
 	 * In the Xen PV case we must use iret anyway.
+	 * In the PVM guest case we must use eretu synthetic instruction.
 	 */
 
-	ALTERNATIVE "testb %al, %al; jz swapgs_restore_regs_and_return_to_usermode", \
-		"jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV
+	ALTERNATIVE_2 "testb %al, %al; jz swapgs_restore_regs_and_return_to_usermode", \
+		"jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV, \
+		"jmp swapgs_restore_regs_and_return_to_usermode", X86_FEATURE_KVM_PVM_GUEST
 
 	/*
 	 * We win! This label is here just for ease of understanding
@@ -597,6 +599,9 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
 #ifdef CONFIG_XEN_PV
 	ALTERNATIVE "", "jmp xenpv_restore_regs_and_return_to_usermode", X86_FEATURE_XENPV
 #endif
+#ifdef CONFIG_PVM_GUEST
+	ALTERNATIVE "", "jmp pvm_restore_regs_and_return_to_usermode", X86_FEATURE_KVM_PVM_GUEST
+#endif
 
 	POP_REGS pop_rdi=0
 
diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index 72c74545dba6..f5d40a57c423 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -15,6 +15,7 @@ typedef void (*idtentry_t)(struct pt_regs *regs);
 void __init pvm_early_setup(void);
 void __init pvm_setup_early_traps(void);
 void __init pvm_install_sysvec(unsigned int sysvec, idtentry_t handler);
+void pvm_setup_event_handling(void);
 bool __init pvm_kernel_layout_relocate(void);
 
 static inline void pvm_cpuid(unsigned int *eax, unsigned int *ebx,
@@ -79,6 +80,10 @@ static inline void pvm_install_sysvec(unsigned int sysvec, idtentry_t handler)
 {
 }
 
+static inline void pvm_setup_event_handling(void)
+{
+}
+
 static inline bool pvm_kernel_layout_relocate(void)
 {
 	return false;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 45f214e41a9a..89874559dbc2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -66,6 +66,7 @@
 #include <asm/set_memory.h>
 #include <asm/traps.h>
 #include <asm/sev.h>
+#include <asm/pvm_para.h>
 
 #include "cpu.h"
 
@@ -2066,7 +2067,15 @@ static void wrmsrl_cstar(unsigned long val)
 void syscall_init(void)
 {
 	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
+
+#ifdef CONFIG_PVM_GUEST
+	if (boot_cpu_has(X86_FEATURE_KVM_PVM_GUEST))
+		wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64_pvm);
+	else
+		wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
+#else
 	wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
+#endif
 
 	if (ia32_enabled()) {
 		wrmsrl_cstar((unsigned long)entry_SYSCALL_compat);
@@ -2217,6 +2226,8 @@ void cpu_init_exception_handling(void)
 
 	/* Finally load the IDT */
 	load_current_idt();
+
+	pvm_setup_event_handling();
 }
 
 /*
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index d0e8d648bd38..17cd11dd1f03 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -42,6 +42,7 @@
 #include <asm/sev.h>
 #include <asm/tdx.h>
 #include <asm/init.h>
+#include <asm/pvm_para.h>
 
 /*
  * Manage page tables very early on.
@@ -286,6 +287,8 @@ asmlinkage __visible void __init __noreturn x86_64_start_kernel(char * real_mode
 
 	idt_setup_early_handler();
 
+	pvm_early_setup();
+
 	/* Needed before cc_platform_has() can be used for TDX */
 	tdx_early_init();
 
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 660b601f1d6c..0dc3ded6da01 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -12,6 +12,7 @@
 #include <asm/hw_irq.h>
 #include <asm/ia32.h>
 #include <asm/idtentry.h>
+#include <asm/pvm_para.h>
 
 #define DPL0		0x0
 #define DPL3		0x3
@@ -259,6 +260,7 @@ void __init idt_setup_early_pf(void)
 {
 	idt_setup_from_table(idt_table, early_pf_idts,
 			     ARRAY_SIZE(early_pf_idts), true);
+	pvm_setup_early_traps();
 }
 #endif
 
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 352d74394c4a..c38e46a96ad3 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -286,12 +286,49 @@ __visible noinstr void pvm_event(struct pt_regs *regs)
 		common_interrupt(regs, vector);
 }
 
+extern void pvm_early_kernel_event_entry(void);
+
+/*
+ * Reserve a fixed-size area in the current stack during an event from
+ * supervisor mode. This is for the int3 handler to emulate a call instruction.
+ */
+#define PVM_SUPERVISOR_REDZONE_SIZE	(2*8UL)
+
 void __init pvm_early_setup(void)
 {
 	if (!pvm_range_end)
 		return;
 
 	setup_force_cpu_cap(X86_FEATURE_KVM_PVM_GUEST);
+
+	wrmsrl(MSR_PVM_VCPU_STRUCT, __pa(this_cpu_ptr(&pvm_vcpu_struct)));
+	wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_early_kernel_event_entry - 256);
+	wrmsrl(MSR_PVM_SUPERVISOR_REDZONE, PVM_SUPERVISOR_REDZONE_SIZE);
+	wrmsrl(MSR_PVM_RETS_RIP, (unsigned long)(void *)pvm_rets_rip);
+}
+
+void pvm_setup_event_handling(void)
+{
+	if (boot_cpu_has(X86_FEATURE_KVM_PVM_GUEST)) {
+		u64 xpa = slow_virt_to_phys(this_cpu_ptr(&pvm_vcpu_struct));
+
+		wrmsrl(MSR_PVM_VCPU_STRUCT, xpa);
+		wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_user_event_entry);
+		wrmsrl(MSR_PVM_SUPERVISOR_REDZONE, PVM_SUPERVISOR_REDZONE_SIZE);
+		wrmsrl(MSR_PVM_RETU_RIP, (unsigned long)(void *)pvm_retu_rip);
+		wrmsrl(MSR_PVM_RETS_RIP, (unsigned long)(void *)pvm_rets_rip);
+
+		/*
+		 * PVM spec requires the hypervisor-maintained
+		 * MSR_KERNEL_GS_BASE to be the same as the kernel GSBASE for
+		 * event delivery for user mode. wrmsrl(MSR_KERNEL_GS_BASE)
+		 * accesses only the user GSBASE in the PVCS via
+		 * pvm_write_msr() without hypervisor involved, so use
+		 * PVM_HC_WRMSR instead.
+		 */
+		pvm_hypercall2(PVM_HC_WRMSR, MSR_KERNEL_GS_BASE,
+			       cpu_kernelmode_gs_base(smp_processor_id()));
+	}
 }
 
 #define TB_SHIFT	40
-- 
2.19.1.6.gb485710b


