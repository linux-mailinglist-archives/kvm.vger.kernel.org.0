Return-Path: <kvm+bounces-9890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB49D8678EA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1EF2297C55
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C651350E9;
	Mon, 26 Feb 2024 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PGXfzOtC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524D4134CE3;
	Mon, 26 Feb 2024 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958168; cv=none; b=tMAN3qyT4luAXi5eUKKBSZ2Mcocscb0R2vvUMtvs8Tkkck8gUet97YMNPSb/xvHMJfeyd5OLFgHL0uUvJzT6BqmMMW33+TlnMo2g+xK1hp8WqQ5IsmtBT/5UdCo815ZaF7InRJfTIBiDCOm0ad/LV7F687kwy4Ccq465WqASXds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958168; c=relaxed/simple;
	bh=/mEAVcSbJaQJo/7ORL9ShODHv0ZFinR5lEggkdY6Xvs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BqUj07t8b/s50qEJD03GXTHWTlyMg9UBJ+djHcgcaD4XFVqLd5obznQhQvPpXM7kcYyMu6F7dZthseFkULFGOggRmkLxXFmz8T5CapLRA0gp/qeTCtjfrWYXDIG95ZD2ReiYd/hQkLI1hdYRIPoBnNm6gDRyFGA6LWNgwadD+vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PGXfzOtC; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-5ca29c131ebso2498113a12.0;
        Mon, 26 Feb 2024 06:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958166; x=1709562966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ToY5GgR/8oR+7K/4zBA63JoSPDOzZ4MQ9j4bv4bYPWw=;
        b=PGXfzOtCAJUxFDzLiPReuWMgxcwjrF0XUYik1kfmclYHgM/Td/3zvvlqOZl+cGuknI
         THmzg4G+VmwNUeq+JA1ErGdyuWT0wb8OESxLuE5XRML2L9Mu/LJJZJmt2wBuYTBY+nHm
         YCvA0IPrbCy2wYZeo6WJJAsrVtFhkOgKPDIeHS7r1ExKOLJ+BwMp8fQ0XRBHEqZq6BSB
         VqGfKi4tnPe6sm6DwgXJTrr6sgnCghsi8RWakKXBX+9cWg4/lUfrmxJSuxECWHyjW/+q
         AU5yv808mcEHf1MKbHTdXi4EWNB+ZKaRwQ9ga8whrYw8/ElKBsZPQ2d66NL3zu7QoT6l
         ouHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958166; x=1709562966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ToY5GgR/8oR+7K/4zBA63JoSPDOzZ4MQ9j4bv4bYPWw=;
        b=vg2xU4liRH84UN6SgwHCxn7opDgWZbwwY+KOOVmCFa6nduz8LlBA2IdlNuVknFAlo5
         Fq/aB/6cION3sgJhB4UXd+5MJoaBsT0pNdlPvSv/iNmbYW3NS74k4tZ95v2tv49+0JHe
         qgFumPUSjSjSB4iA4avShydjhPcwwTLvvm1KUqMm1npv955NzRJwbJIAc1nw9cpsThpq
         sPekMlzG3upvCxq42ncWPNlMM1ZBgG/v2Us6cLQZ3518Z+fT4goAbeS4f783ygSSGtVL
         RlrzNpXk/2iBDGjjr7+v2EKHkhqXYfWO7ka0LQi6VVnY/EEJi7ca1lcmW9EW9HllMblc
         ck6A==
X-Forwarded-Encrypted: i=1; AJvYcCW8BbSdu4NWV/KgTwdHF5U0QOQ1OnrvwV/C1345MKK5rzhFxH8Bu9KgV0sod9goorUcZlOekWEDaW1SZUNTPKpoHGo2
X-Gm-Message-State: AOJu0YxilQrdCqLgqwC0Lu6qJ8utXKQtGgtqCSHuXLcKR8QiZhkTIsw2
	cRARUMk4ti/JzGVeeeRbg9R2+23sSuIYuSR/35pIRj/7Jiily7ixIgHWYBAa
X-Google-Smtp-Source: AGHT+IGXXJTeR/ZrfgQ6mnuG0H2PJAJ5iD62Ai9ROjwtr1SkKhwKPvQVD+EpFqd2UqCYBTCdwjrj/Q==
X-Received: by 2002:a17:903:2450:b0:1db:bbe0:9e9 with SMTP id l16-20020a170903245000b001dbbbe009e9mr10410428pls.58.1708958166218;
        Mon, 26 Feb 2024 06:36:06 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id kf14-20020a17090305ce00b001db45bae92dsm4074496plb.74.2024.02.26.06.36.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:05 -0800 (PST)
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
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 27/73] KVM: x86/PVM: Implement event injection related callbacks
Date: Mon, 26 Feb 2024 22:35:44 +0800
Message-Id: <20240226143630.33643-28-jiangshanlai@gmail.com>
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

In PVM, events are injected and consumed directly. The PVM hypervisor
does not follow the IDT-based event delivery mechanism but instead
utilizes a new PVM-specific event delivery ABI, which is similar to FRED
event delivery.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 193 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |   1 +
 2 files changed, 194 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 3d2a3c472664..57d987903791 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -648,6 +648,150 @@ static void pvm_event_flags_update(struct kvm_vcpu *vcpu, unsigned long set,
 	pvm_put_vcpu_struct(pvm, new_flags != old_flags);
 }
 
+static void pvm_standard_event_entry(struct kvm_vcpu *vcpu, unsigned long entry)
+{
+	// Change rip, rflags, rcx and r11 per PVM event delivery specification,
+	// this allows to use sysret in VM enter.
+	kvm_rip_write(vcpu, entry);
+	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
+	kvm_rcx_write(vcpu, entry);
+	kvm_r11_write(vcpu, X86_EFLAGS_IF | X86_EFLAGS_FIXED);
+}
+
+/* handle pvm user event per PVM Spec. */
+static int do_pvm_user_event(struct kvm_vcpu *vcpu, int vector,
+			     bool has_err_code, u64 err_code)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long entry = vector == PVM_SYSCALL_VECTOR ?
+			      pvm->msr_lstar : pvm->msr_event_entry;
+	struct pvm_vcpu_struct *pvcs;
+
+	pvcs = pvm_get_vcpu_struct(pvm);
+	if (!pvcs) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+
+	pvcs->user_cs = pvm->hw_cs;
+	pvcs->user_ss = pvm->hw_ss;
+	pvcs->eflags = kvm_get_rflags(vcpu);
+	pvcs->pkru = 0;
+	pvcs->user_gsbase = pvm_read_guest_gs_base(pvm);
+	pvcs->rip = kvm_rip_read(vcpu);
+	pvcs->rsp = kvm_rsp_read(vcpu);
+	pvcs->rcx = kvm_rcx_read(vcpu);
+	pvcs->r11 = kvm_r11_read(vcpu);
+
+	if (has_err_code)
+		pvcs->event_errcode = err_code;
+	if (vector != PVM_SYSCALL_VECTOR)
+		pvcs->event_vector = vector;
+
+	if (vector == PF_VECTOR)
+		pvcs->cr2 = vcpu->arch.cr2;
+
+	pvm_put_vcpu_struct(pvm, true);
+
+	switch_to_smod(vcpu);
+
+	pvm_standard_event_entry(vcpu, entry);
+
+	return 1;
+}
+
+static int do_pvm_supervisor_exception(struct kvm_vcpu *vcpu, int vector,
+				       bool has_error_code, u64 error_code)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long stack;
+	struct pvm_supervisor_event frame;
+	struct x86_exception e;
+	int ret;
+
+	memset(&frame, 0, sizeof(frame));
+	frame.cs = kernel_cs_by_msr(pvm->msr_star);
+	frame.ss = kernel_ds_by_msr(pvm->msr_star);
+	frame.rip = kvm_rip_read(vcpu);
+	frame.rflags = kvm_get_rflags(vcpu);
+	frame.rsp = kvm_rsp_read(vcpu);
+	frame.errcode = ((unsigned long)vector << 32) | error_code;
+	frame.r11 = kvm_r11_read(vcpu);
+	frame.rcx = kvm_rcx_read(vcpu);
+
+	stack = ((frame.rsp - pvm->msr_supervisor_redzone) & ~15UL) - sizeof(frame);
+
+	ret = kvm_write_guest_virt_system(vcpu, stack, &frame, sizeof(frame), &e);
+	if (ret) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+
+	if (vector == PF_VECTOR) {
+		struct pvm_vcpu_struct *pvcs;
+
+		pvcs = pvm_get_vcpu_struct(pvm);
+		if (!pvcs) {
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+			return 1;
+		}
+
+		pvcs->cr2 = vcpu->arch.cr2;
+		pvm_put_vcpu_struct(pvm, true);
+	}
+
+	kvm_rsp_write(vcpu, stack);
+
+	pvm_standard_event_entry(vcpu, pvm->msr_event_entry + 256);
+
+	return 1;
+}
+
+static int do_pvm_supervisor_interrupt(struct kvm_vcpu *vcpu, int vector,
+				       bool has_error_code, u64 error_code)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long stack = kvm_rsp_read(vcpu);
+	struct pvm_vcpu_struct *pvcs;
+
+	pvcs = pvm_get_vcpu_struct(pvm);
+	if (!pvcs) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return 1;
+	}
+	pvcs->eflags = kvm_get_rflags(vcpu);
+	pvcs->rip = kvm_rip_read(vcpu);
+	pvcs->rsp = stack;
+	pvcs->rcx = kvm_rcx_read(vcpu);
+	pvcs->r11 = kvm_r11_read(vcpu);
+
+	pvcs->event_vector = vector;
+	if (has_error_code)
+		pvcs->event_errcode = error_code;
+
+	pvm_put_vcpu_struct(pvm, true);
+
+	stack = (stack - pvm->msr_supervisor_redzone) & ~15UL;
+	kvm_rsp_write(vcpu, stack);
+
+	pvm_standard_event_entry(vcpu, pvm->msr_event_entry + 512);
+
+	return 1;
+}
+
+static int do_pvm_event(struct kvm_vcpu *vcpu, int vector,
+			bool has_error_code, u64 error_code)
+{
+	if (!is_smod(to_pvm(vcpu)))
+		return do_pvm_user_event(vcpu, vector, has_error_code, error_code);
+
+	if (vector < 32)
+		return do_pvm_supervisor_exception(vcpu, vector,
+						   has_error_code, error_code);
+
+	return do_pvm_supervisor_interrupt(vcpu, vector, has_error_code, error_code);
+}
+
 static unsigned long pvm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	return to_pvm(vcpu)->rflags;
@@ -722,6 +866,51 @@ static int pvm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !pvm->nmi_mask && !pvm->int_shadow;
 }
 
+/* Always inject the exception directly and consume the event. */
+static void pvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+	unsigned int vector = vcpu->arch.exception.vector;
+	bool has_error_code = vcpu->arch.exception.has_error_code;
+	u32 error_code = vcpu->arch.exception.error_code;
+
+	kvm_deliver_exception_payload(vcpu, &vcpu->arch.exception);
+
+	if (do_pvm_event(vcpu, vector, has_error_code, error_code))
+		kvm_clear_exception_queue(vcpu);
+}
+
+/* Always inject the interrupt directly and consume the event. */
+static void pvm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
+{
+	int irq = vcpu->arch.interrupt.nr;
+
+	trace_kvm_inj_virq(irq, vcpu->arch.interrupt.soft, false);
+
+	if (do_pvm_event(vcpu, irq, false, 0))
+		kvm_clear_interrupt_queue(vcpu);
+
+	++vcpu->stat.irq_injections;
+}
+
+/* Always inject the NMI directly and consume the event. */
+static void pvm_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	if (do_pvm_event(vcpu, NMI_VECTOR, false, 0)) {
+		vcpu->arch.nmi_injected = false;
+		pvm_set_nmi_mask(vcpu, true);
+	}
+
+	++vcpu->stat.nmi_injections;
+}
+
+static void pvm_cancel_injection(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Nothing to do. Since exceptions/interrupts are delivered immediately
+	 * during event injection, so they cannot be cancelled and reinjected.
+	 */
+}
+
 static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
@@ -1282,6 +1471,10 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.handle_exit = pvm_handle_exit,
 	.set_interrupt_shadow = pvm_set_interrupt_shadow,
 	.get_interrupt_shadow = pvm_get_interrupt_shadow,
+	.inject_irq = pvm_inject_irq,
+	.inject_nmi = pvm_inject_nmi,
+	.inject_exception = pvm_inject_exception,
+	.cancel_injection = pvm_cancel_injection,
 	.interrupt_allowed = pvm_interrupt_allowed,
 	.nmi_allowed = pvm_nmi_allowed,
 	.get_nmi_mask = pvm_get_nmi_mask,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index b0c633ce2987..39506ddbe5c5 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -7,6 +7,7 @@
 
 #define SWITCH_FLAGS_INIT	(SWITCH_FLAGS_SMOD)
 
+#define PVM_SYSCALL_VECTOR		SWITCH_EXIT_REASONS_SYSCALL
 #define PVM_FAILED_VMENTRY_VECTOR	SWITCH_EXIT_REASONS_FAILED_VMETNRY
 
 #define PT_L4_SHIFT		39
-- 
2.19.1.6.gb485710b


