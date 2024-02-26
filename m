Return-Path: <kvm+bounces-9931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0886B867955
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5B0428D408
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B79014EFFD;
	Mon, 26 Feb 2024 14:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGr7baVH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECE012BE82;
	Mon, 26 Feb 2024 14:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958380; cv=none; b=S2cYJGJR3YvSBT3kDZ4wodoOG/9mMYKOCXshJS6yelR8bI955A6C3VRQsqGEvlvNdnOct9eYLb9Ia8FYofktzBzNH4kOWzbRhcu01seFCn4spLdaqHy2BYFEhtVAq0HiYtZ4U22VzYIjY4N+AA38OnPwJN8MHq/BPW2ZGMtqkEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958380; c=relaxed/simple;
	bh=KM7iecQmLkLTMPKp+Fy1sVXQ4TzdbjLCokucwFll4/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KeUtJRqFIiYa/0/9/pjHflMG6f+2+NyTU6531KLrUcmZCSL4tGhoXtUXe0gaLsEZVpUtjLx8degAVN7wXwxLHPpbL9XIrrNiChZ25HUgOWhHvcldJJN5iUb3/Q2NjhQd4UdsvXJdKzeGL8iIfmiFH9nktYfm2soQ9N3EuZDxZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RGr7baVH; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dca160163dso9116875ad.3;
        Mon, 26 Feb 2024 06:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958378; x=1709563178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvvsdBL0+tpohgU9GakMz4yFaDR5z6TAfe25+CbTcnM=;
        b=RGr7baVHFaq1sTWkn7bqNCyom9xZdt2jWCMzT8AaqeUbzCLhUEsGu5LWrmxGjrawxX
         tZY5OoOppY1rs08R8lePkf3iFfSfvE89r170lZslDQ2jKsOcOwdnsqVreFjs7YDuCcQg
         LlBEA1e1furf5bJyvJft0OsX1zzN7rgq5pI3dJYMsf9KgO97v5P3V3YWDZT3wvKTsUyd
         6dyFxGosbvAL1iAFFfTcyW9HrUzibACOf0T5bR2H3rdCkGQM9Rjc69CJ9Nv1XVNV3S7G
         WeCeEAXjM6C6c0SAbSXqR7Kq7Qmoz9REDsJ50esyBwdQxNiEMxwC9Q5Ctosdqu4M8QZ+
         ls7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958378; x=1709563178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvvsdBL0+tpohgU9GakMz4yFaDR5z6TAfe25+CbTcnM=;
        b=tgm89Z9tzGte2Gm8pMA4DSys8oHzHTDOxj3spKG7wVUryYIWTZVbgMmZK+niBmtwt/
         s57qk6MmiaYpJdIQAfUUGtMSdU6FerP/pjzp25oCFyl7ageaAWVDQh+3Z1eVWhMgL9jG
         l4yBdoEyoEavdN56z+lg5cIyrpuO2Hg1gq61HKA1Sg/YPGJps2W/0tYmpPAKG6dc2D47
         FnwJrnoNI2GZeL+z++OPXmtCkQwpPPVlIFFe2cpDALFB0cHc2kQ4lUK7F/eSsE7rmRpV
         K5bdjnkGOOrjby2ks0T+aEg553Q869L7gYBeVPum/7gr9trKOCxgYZ9WQSMl8o2Ew0Sz
         AfQg==
X-Forwarded-Encrypted: i=1; AJvYcCW1pXZKYwFYNEDHuoAxla9bnYVt1P4DmvLYAWAyRrRydL7XYC4W83SXuhKU4J6oexkR5mwUfNPrH4brccycI0NUNlOj
X-Gm-Message-State: AOJu0Yyo3Rll4HvZha/UAJkGuYWbvMue+6BSg2PIhc7ClkEugnRN6gFZ
	oPZUihNISATXTaL9nW59sjknSZDStNyVjxH1gzRC6cXab5WSQkhxcJyAVs2W
X-Google-Smtp-Source: AGHT+IHq6ZYg6Su4mIb97VQAs0Gi7f0aV9fTMBhWC2JsE2QnNB9BzhNGe5Qvb9vw+7/4xxYISfTEGQ==
X-Received: by 2002:a17:903:24f:b0:1db:ccd0:e77e with SMTP id j15-20020a170903024f00b001dbccd0e77emr10543394plh.35.1708958377728;
        Mon, 26 Feb 2024 06:39:37 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id lb13-20020a170902fa4d00b001dcb308510dsm208925plb.26.2024.02.26.06.39.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:39:37 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
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
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 68/73] x86/pvm: Implement irq related PVOPS
Date: Mon, 26 Feb 2024 22:36:25 +0800
Message-Id: <20240226143630.33643-69-jiangshanlai@gmail.com>
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

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The save_fl(), irq_enable(), and irq_disable() functions are in the hot
path, so the hypervisor shares the X86_EFLAG_IF status in the PVCS
structure for the guest kernel. This allows it to be read and modified
directly without a VM exit if there is no IRQ window request.
Additionally, the irq_halt() function remains the same, and a hypercall
is used in its PVOPS to enhance performance.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/entry/entry_64_pvm.S   | 22 ++++++++++++++++++++++
 arch/x86/include/asm/pvm_para.h |  3 +++
 arch/x86/kernel/pvm.c           | 10 ++++++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/entry/entry_64_pvm.S b/arch/x86/entry/entry_64_pvm.S
index abb57e251e73..1d17bac2909a 100644
--- a/arch/x86/entry/entry_64_pvm.S
+++ b/arch/x86/entry/entry_64_pvm.S
@@ -65,6 +65,28 @@ SYM_FUNC_START(pvm_hypercall)
 	popq	%r11
 	RET
 SYM_FUNC_END(pvm_hypercall)
+
+SYM_FUNC_START(pvm_save_fl)
+	movq	PER_CPU_VAR(pvm_vcpu_struct + PVCS_event_flags), %rax
+	RET
+SYM_FUNC_END(pvm_save_fl)
+
+SYM_FUNC_START(pvm_irq_disable)
+	btrq	$X86_EFLAGS_IF_BIT, PER_CPU_VAR(pvm_vcpu_struct + PVCS_event_flags)
+	RET
+SYM_FUNC_END(pvm_irq_disable)
+
+SYM_FUNC_START(pvm_irq_enable)
+	/* set X86_EFLAGS_IF */
+	orq	$X86_EFLAGS_IF, PER_CPU_VAR(pvm_vcpu_struct + PVCS_event_flags)
+	btq	$PVM_EVENT_FLAGS_IP_BIT, PER_CPU_VAR(pvm_vcpu_struct + PVCS_event_flags)
+	jc	.L_maybe_interrupt_pending
+	RET
+.L_maybe_interrupt_pending:
+	/* handle pending IRQ */
+	movq	$PVM_HC_IRQ_WIN, %rax
+	jmp	pvm_hypercall
+SYM_FUNC_END(pvm_irq_enable)
 .popsection
 
 /*
diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index f5d40a57c423..9484a1a23568 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -95,6 +95,9 @@ void pvm_user_event_entry(void);
 void pvm_hypercall(void);
 void pvm_retu_rip(void);
 void pvm_rets_rip(void);
+void pvm_save_fl(void);
+void pvm_irq_disable(void);
+void pvm_irq_enable(void);
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PVM_PARA_H */
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 12a35bef9bb8..b4522947374d 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -148,6 +148,11 @@ static void pvm_load_tls(struct thread_struct *t, unsigned int cpu)
 	}
 }
 
+static noinstr void pvm_safe_halt(void)
+{
+	pvm_hypercall0(PVM_HC_IRQ_HALT);
+}
+
 void __init pvm_early_event(struct pt_regs *regs)
 {
 	int vector = regs->orig_ax >> 32;
@@ -387,6 +392,11 @@ void __init pvm_early_setup(void)
 	pv_ops.cpu.write_msr_safe = pvm_write_msr_safe;
 	pv_ops.cpu.load_tls = pvm_load_tls;
 
+	pv_ops.irq.save_fl = __PV_IS_CALLEE_SAVE(pvm_save_fl);
+	pv_ops.irq.irq_disable = __PV_IS_CALLEE_SAVE(pvm_irq_disable);
+	pv_ops.irq.irq_enable = __PV_IS_CALLEE_SAVE(pvm_irq_enable);
+	pv_ops.irq.safe_halt = pvm_safe_halt;
+
 	wrmsrl(MSR_PVM_VCPU_STRUCT, __pa(this_cpu_ptr(&pvm_vcpu_struct)));
 	wrmsrl(MSR_PVM_EVENT_ENTRY, (unsigned long)(void *)pvm_early_kernel_event_entry - 256);
 	wrmsrl(MSR_PVM_SUPERVISOR_REDZONE, PVM_SUPERVISOR_REDZONE_SIZE);
-- 
2.19.1.6.gb485710b


