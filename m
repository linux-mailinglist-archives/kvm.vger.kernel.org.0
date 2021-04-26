Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F80C36C156
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 10:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhD0I4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 04:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbhD0Iz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 04:55:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B18C061574;
        Tue, 27 Apr 2021 01:55:15 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id md17so3116982pjb.0;
        Tue, 27 Apr 2021 01:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/31Vy6dJtI8OfNAY7ghunL8gA/RZhNPFIkU577+CHEs=;
        b=A0xpPWh3R4bR9/A4KkPyHhizxphwgiPuLe9DPURlFVWpg+IfnOyhA4gsHx1cyY8rRK
         fb1szxBZolHo88h6FZblRM6nsdQjNiKBx5nVGfkBXzWNt2vpGAvxj1YuMzVQsFQp273z
         r7dudOSylQp1/3hnUkH9ByIJPy8lu1wjYVTslTHHZrfEgsQgM/McQ+Y077uRyV6JEO5c
         GnFDHskT0G+IWsta4CPbWvZkRYtXrW4S03kbOuIiahbMx+XaE2TNKnppudOfKDeW/SNw
         pk5hVLcZfp9SEH0BhUk5Xueb41D3XLHoBrnCQ5mzFyC8NJMOiq6xqT2U9YxM8tubcMXg
         srOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/31Vy6dJtI8OfNAY7ghunL8gA/RZhNPFIkU577+CHEs=;
        b=LIa/K1koORSZD7nhPIrH93lSbFYH6SyKzeDAWmb8+9pDjLOjdwfN8R8rPVsdbuPC0E
         b8v1BvZwPBIcOcrEtlkdaOj2Gi0buAIfil0CAtmRK+ePLxC0hlq2OKhawj0zKVEfBxOO
         WfrPLgHUujewEGZiV6r4IevmTUA6C891vxlPLRxi8DoggFLhJAf1u8AoT34zCgfyLWLV
         CVjjhqL+yh3X1keVLgofVs5CW++cYGmvEyM8pbWO4RVFXJgbzjXeF3W2xUr7gPpE5Zgq
         8DwwdKHMXEqBE8zu+4kjbQeu/XZjXvU36Yqvk1BE7S+39BE8BpLibC0Srm7BuRDuVJxr
         SSLA==
X-Gm-Message-State: AOAM530TnX9IIR7GgXpW1PQnzIuRFrQY9LeTfkEoBg/8ximZzENk2ck7
        0hXdd6hnPgcA4SHb5mxnMpk6Y7NnqIU=
X-Google-Smtp-Source: ABdhPJx+AJHGi3Rguoobjs/iQl6/SlIGKuNRMwZXS99zCPGUB+WyGOmVpZp9CTpHmWfFywdrAG0Bww==
X-Received: by 2002:a17:902:bf44:b029:ec:c083:7377 with SMTP id u4-20020a170902bf44b02900ecc0837377mr22822309pls.27.1619513715229;
        Tue, 27 Apr 2021 01:55:15 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id 18sm1853014pji.30.2021.04.27.01.55.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Apr 2021 01:55:14 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/4] KVM/VMX: Invoke NMI non-IST entry instead of IST entry
Date:   Tue, 27 Apr 2021 07:09:48 +0800
Message-Id: <20210426230949.3561-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210426230949.3561-1-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

In VMX, the NMI handler needs to be invoked after NMI VM-Exit.

Before the commit 1a5488ef0dcf6 ("KVM: VMX: Invoke NMI handler via
indirect call instead of INTn"), the work is done by INTn ("int $2").

But INTn microcode is relatively expensive, so the commit reworked
NMI VM-Exit handling to invoke the kernel handler by function call.
And INTn doesn't set the NMI blocked flag required by the linux kernel
NMI entry.  So moving away from INTn are very reasonable.

Yet some details were missed.  After the said commit applied, the NMI
entry pointer is fetched from the IDT table and called from the kernel
stack.  But the NMI entry pointer installed on the IDT table is
asm_exc_nmi() which expects to be invoked on the IST stack by the ISA.
And it relies on the "NMI executing" variable on the IST stack to work
correctly.  When it is unexpectedly called from the kernel stack, the
RSP-located "NMI executing" variable is also on the kernel stack and
is "uninitialized" and can cause the NMI entry to run in the wrong way.

So we should not used the NMI entry installed on the IDT table.  Rather,
we should use the NMI entry allowed to be used on the kernel stack which
is asm_noist_exc_nmi() which is also used for XENPV and early booting.

Link: https://lore.kernel.org/lkml/20200915191505.10355-3-sean.j.christopherson@intel.com/
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: kvm@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kernel/nmi.c  | 3 +++
 arch/x86/kvm/vmx/vmx.c | 8 ++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 2fb1fd59d714..919f0400d931 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -528,10 +528,13 @@ DEFINE_IDTENTRY_RAW(noist_exc_nmi)
 {
 	/*
 	 * On Xen PV and early booting stage, NMI doesn't use IST.
+	 * And when it is manually called from VMX NMI VM-Exit handler,
+	 * it doesn't use IST either.
 	 * The C part is the same as native.
 	 */
 	exc_nmi(regs);
 }
+EXPORT_SYMBOL_GPL(asm_noist_exc_nmi);
 
 void stop_nmi(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcbf0d2139e9..96e59d912637 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -36,6 +36,7 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/internal.h>
+#include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
 #include <asm/kexec.h>
@@ -6416,8 +6417,11 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
-	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
+	else if (is_nmi(intr_info)) {
+		kvm_before_interrupt(&vmx->vcpu);
+		vmx_do_interrupt_nmi_irqoff((unsigned long)asm_noist_exc_nmi);
+		kvm_after_interrupt(&vmx->vcpu);
+	}
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
-- 
2.19.1.6.gb485710b

