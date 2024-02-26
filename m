Return-Path: <kvm+bounces-9901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 580FF86790C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 024A3290AC7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202001386D9;
	Mon, 26 Feb 2024 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eflfwOSF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9351386D8;
	Mon, 26 Feb 2024 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958204; cv=none; b=Eado+H3YMW6cdMS0OgXnXwBdXjl0hDPmVNDe7VTtjE/kxdG+7iBvg+/I6JUE/x4EzEtf+wUqMvDhLW2V6myem+13N2uDT9b3xlV5muRmfVnNQI9TaNe7eZMhIIliA4n7388MDcjxEqMHU2DRjotDyXiQhIzA/2Zm30ZwqBA+nlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958204; c=relaxed/simple;
	bh=l2h4Uf1QXsvH+X3OivH8HCuXCYpvpQ9MT+dXZ1HPxRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tzsruJDOY6T8liDuXGFQIyJkOdOmNm+27O5zCdLi9ea+d1/qTP5kE9TfrQcnDRMDAT2x5eDhwtOJW8NHEQ7kJlYJ2+vJNWu8lRLe4UCB1YMRnFAaaTJLC3ZgEMvL96ciliHaEzuTYDACtoF8OMH00wSlFAjvscEyXcSZNZ1b5jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eflfwOSF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dcb3e6ff3fso732925ad.2;
        Mon, 26 Feb 2024 06:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958202; x=1709563002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vE7TUqSC7cygcOHG2v4FLYxkyOZYozS8dRRg73DCalE=;
        b=eflfwOSFX0JBTEgRDJ2aEmSryMAjCO8a4x9oVLL4x4WFrb42kALxfdv1vIAKuOm1nj
         EYnUad5dl8qMZdDun9jYqTRpaBAsnKWaiT2NrKJg+izvicYGBFEYXsQ2r5JpnAW6A8tx
         r4r7+Gu85qQR5eux0BsAdOhuKjQ71R7i3FemLnFkG6aiIBCmpRBwiUpe8y70b+/UozgA
         sSPC8048Khk9HHph1sdpGS/RCj6Vs1QZcD5uAjoa5GbaRuSZTMHwZuUh5AaBv0xFs8Lt
         rnJRO9hajnTNIIHxXGiHl0JZDPpa8Pugz/4Qa9rLmXIi82h058KYpie0fR3LiVXQrSMU
         9sYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958202; x=1709563002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vE7TUqSC7cygcOHG2v4FLYxkyOZYozS8dRRg73DCalE=;
        b=RYhyc+XCq2Qr+7WRvo3PKIi0C5bI+y/qwXlVlfYCuN30FC4sHesFzlUbX4Ui/RUjAR
         MMX3u4iqzXbs/v0kpRAtwimG/kWljjFjvdqQ60pzvM6XC1vihohh6nIv9/7qkYyGU1tA
         +D2rqkhxUtTBZYENzC0C6TXOo6TWh2U0VGCD5Tl/D/GkcW7YBZbZIWgCM2SoGQF32aIw
         qevBQE2P6K+P1PPwmNZ8bfLArLRoYXzscUhwhZcPoTVKfeYXik0C6XnJljAJlL9tXya3
         tiOgVMImfB6sniEY2TnaB7AW3MG2Kk9CJs/E4Mh2GZyXvq3ibNoi8B6tyDEv6ojCo1jP
         UFOg==
X-Forwarded-Encrypted: i=1; AJvYcCVIXVZPW6o3S31OnzNqX0EnZ5zrtyZEA8zGxOczdNhkrfwhujB4XnBU1MkOu1JI53NkHWyaueVnTydGz9uYJKGn7zpG
X-Gm-Message-State: AOJu0YxlJyreDthb8GsrKgo/QafP0XB/KFZkO52VE0pXKZfesRAw+izP
	pJZQ51n3owCP7ZWSB+XmhMMGTWD0WeTeeNsp3aT6gmmvChmRDrlaV0JZY2lK
X-Google-Smtp-Source: AGHT+IFk3I4v14i2M5tN+kC8DAwFWEOf84zfaUbuMiHnbH8kQScS7ykZALTJJr9O2miKstRcIrHpXw==
X-Received: by 2002:a17:902:e545:b0:1db:7052:2f62 with SMTP id n5-20020a170902e54500b001db70522f62mr7606398plf.50.1708958201844;
        Mon, 26 Feb 2024 06:36:41 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902820200b001da34166cd2sm4013128pln.180.2024.02.26.06.36.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:41 -0800 (PST)
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
Subject: [RFC PATCH 38/73] KVM: x86/PVM: Handle hypercalls for privilege instruction emulation
Date: Mon, 26 Feb 2024 22:35:55 +0800
Message-Id: <20240226143630.33643-39-jiangshanlai@gmail.com>
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

The privileged instructions in the PVM guest will be trapped and
emulated. To reduce the emulation overhead, some privileged instructions
in the hot path, such as RDMSR/WRMSR and TLB flushing related
instructions, will be replaced by hypercalls to improve performance.
The handling of those hypercalls is the same as the associated
privileged instruction emulation.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 114 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 2d3785e7f2f3..8d8c783c72b5 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1434,6 +1434,96 @@ static int handle_synthetic_instruction_return_supervisor(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_hc_interrupt_window(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+	pvm_event_flags_update(vcpu, 0, PVM_EVENT_FLAGS_IP);
+
+	++vcpu->stat.irq_window_exits;
+	return 1;
+}
+
+static int handle_hc_irq_halt(struct kvm_vcpu *vcpu)
+{
+	kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) | X86_EFLAGS_IF);
+
+	return kvm_emulate_halt_noskip(vcpu);
+}
+
+static void pvm_flush_tlb_guest_current_kernel_user(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * sync the current pgd and user_pgd (pvm->msr_switch_cr3)
+	 * which is a subset work of KVM_REQ_TLB_FLUSH_GUEST.
+	 */
+	kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+}
+
+/*
+ * Hypercall: PVM_HC_TLB_FLUSH
+ *	Flush all TLBs.
+ */
+static int handle_hc_flush_tlb_all(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
+	return 1;
+}
+
+/*
+ * Hypercall: PVM_HC_TLB_FLUSH_CURRENT
+ *	Flush all TLBs tagged with the current CR3 and MSR_PVM_SWITCH_CR3.
+ */
+static int handle_hc_flush_tlb_current_kernel_user(struct kvm_vcpu *vcpu)
+{
+	pvm_flush_tlb_guest_current_kernel_user(vcpu);
+
+	return 1;
+}
+
+/*
+ * Hypercall: PVM_HC_TLB_INVLPG
+ *	Flush TLBs associated with a single address for all tags.
+ */
+static int handle_hc_invlpg(struct kvm_vcpu *vcpu, unsigned long addr)
+{
+	kvm_mmu_invlpg(vcpu, addr);
+
+	return 1;
+}
+
+/*
+ * Hypercall: PVM_HC_RDMSR
+ *	Write MSR.
+ *	Return with RAX = the MSR value if succeeded.
+ *	Return with RAX = 0 if it failed.
+ */
+static int handle_hc_rdmsr(struct kvm_vcpu *vcpu, u32 index)
+{
+	u64 value = 0;
+
+	kvm_get_msr(vcpu, index, &value);
+	kvm_rax_write(vcpu, value);
+
+	return 1;
+}
+
+/*
+ * Hypercall: PVM_HC_WRMSR
+ *	Write MSR.
+ *	Return with RAX = 0 if succeeded.
+ *	Return with RAX = -EIO if it failed
+ */
+static int handle_hc_wrmsr(struct kvm_vcpu *vcpu, u32 index, u64 value)
+{
+	if (kvm_set_msr(vcpu, index, value))
+		kvm_rax_write(vcpu, -EIO);
+	else
+		kvm_rax_write(vcpu, 0);
+
+	return 1;
+}
+
 static int handle_kvm_hypercall(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -1450,6 +1540,7 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	unsigned long rip = kvm_rip_read(vcpu);
+	unsigned long a0, a1;
 
 	if (!is_smod(pvm))
 		return do_pvm_user_event(vcpu, PVM_SYSCALL_VECTOR, false, 0);
@@ -1459,7 +1550,28 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 	if (rip == pvm->msr_rets_rip_plus2)
 		return handle_synthetic_instruction_return_supervisor(vcpu);
 
-	return handle_kvm_hypercall(vcpu);
+	a0 = kvm_rbx_read(vcpu);
+	a1 = kvm_r10_read(vcpu);
+
+	// handle hypercall, check it for pvm hypercall and then kvm hypercall
+	switch (kvm_rax_read(vcpu)) {
+	case PVM_HC_IRQ_WIN:
+		return handle_hc_interrupt_window(vcpu);
+	case PVM_HC_IRQ_HALT:
+		return handle_hc_irq_halt(vcpu);
+	case PVM_HC_TLB_FLUSH:
+		return handle_hc_flush_tlb_all(vcpu);
+	case PVM_HC_TLB_FLUSH_CURRENT:
+		return handle_hc_flush_tlb_current_kernel_user(vcpu);
+	case PVM_HC_TLB_INVLPG:
+		return handle_hc_invlpg(vcpu, a0);
+	case PVM_HC_RDMSR:
+		return handle_hc_rdmsr(vcpu, a0);
+	case PVM_HC_WRMSR:
+		return handle_hc_wrmsr(vcpu, a0, a1);
+	default:
+		return handle_kvm_hypercall(vcpu);
+	}
 }
 
 static int handle_exit_debug(struct kvm_vcpu *vcpu)
-- 
2.19.1.6.gb485710b


