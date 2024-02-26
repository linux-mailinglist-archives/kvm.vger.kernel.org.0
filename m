Return-Path: <kvm+bounces-9902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F198679D0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43D48B30500
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C7613959D;
	Mon, 26 Feb 2024 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NT6QslRW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0D013957D;
	Mon, 26 Feb 2024 14:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958207; cv=none; b=b/7STdHRXFy652//vztELCH3Qw6jsI9hECkMwqQbn08JoukQinEoXj1soY2/X3/gx4POJsKjDtjjHtOIHCz5ZEfIAGtQFVgLzaEjIJC7OKKdY/2UwBBJ8b4irTYCfDqQM8gT4S975vZ4TkJ99xXGBeTRTDTjQ9U3iS2EjE7Q/ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958207; c=relaxed/simple;
	bh=2EvDgfFMmHJpG+Kyi4MXHgiwVk6T3MZMRKHRe3Ga2WY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WDorP+ey4u5aQH85A8Jd6ey6kiWRmI2mBbLzDbW1R9RT+G3hf4KBmHYVNQAJHsvZJpYEz9wS4vSNtEnBN7ep8wm7sL5wGyfZfz/VTmLhY1lJFiYSqGlWnypkHvT+F5rOubzJ3naY6WnRezuMMTgjQKenyo6gC0jYbH1Lg+IO00g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NT6QslRW; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e4c359e48aso1843557b3a.1;
        Mon, 26 Feb 2024 06:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958205; x=1709563005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkYvm4imcF9izb+MCYYTd7W/K0PihGpy1Nsmpgapn0o=;
        b=NT6QslRWtANR2d4Ug4ofmXD5nRqzASuXvikBU1TIpT2OpKX6UWg9EiYVVjL5PbbD5C
         TmDjfFRCi9ihAiQz0yQjgWoB5O8ZsWSKfEE8DLPrrRI2BBzyZ44fkQ1i6V0naBhtDRQk
         XI8cZWYbYccN21jAocswxBqj7P6WRFoOrEgg4apn4XGavX7/Qiv48rRizzyD4KC7WVf3
         a7eHw+hYUqHMgjw4mlKL4dDOMyXmMX3iV75zWU8qdhshTLt3751Z4dGSlq1YHFcb1nzB
         b/vttIIBM1TcRiWRbuUEmMpXbgKqwc6lbWpn/bX7JZqiTwGHMr1rYzK6eaDYJiPpADf6
         KcnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958205; x=1709563005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkYvm4imcF9izb+MCYYTd7W/K0PihGpy1Nsmpgapn0o=;
        b=SM0XOtLqaTy9zRyiMZieLvhZxb3TwajhG33Ukng6jDN18slGQP/7qa2BlAW9DSMnIU
         kmrDKAUraeLSfGRqrZBb06yPYEE6MFgQij6TMmYy+GFJI3jE0Upgaq0aMVnXu3RzKseE
         mgp3909Y24qsMzWtCYqSU4rVobTRXgnkw/wrM8nM8FeEjGsr0CU3cheQtufW01Qv3zYj
         JgrzkL2F4k9j8T6D3lh3RV3Tgle0XPT5BaJuaBzf2nxXF+TiqjfWGkZpfITyRSvg17gZ
         1V3ddRMMw+2fT2nj8HLitv9uiZFWz3ixAiGNV9EIZZftT/ZJzgdKILsCft8sT4m72IPR
         qpvg==
X-Forwarded-Encrypted: i=1; AJvYcCXPgUcagAo/w1WfEhvtN0NyhoyCwivUduOkJ6LZkRkLYX21xTMJfTFw67XDORRpBB+ep0Fpama2QZru/P10GOgHPaXf
X-Gm-Message-State: AOJu0YyjWBePJ+n776zMwA57o7a0UmGshCvXvUXg95Hbk+8bEgGHZ1ku
	opF4g5Knga6khk6ZM7KVw/yx/55/R3qTkuPn4XUjDW7kHsILJ+aBGoUawmjL
X-Google-Smtp-Source: AGHT+IFX6Q1PAX5b88PnbLkr1fmmS4bOoCFR7ZFSnjGP+cqhwuCSK+KLG6OQGg7tbsK8DsGnXYHjxA==
X-Received: by 2002:a05:6a20:2114:b0:1a0:e4a6:2d86 with SMTP id y20-20020a056a20211400b001a0e4a62d86mr6549874pzy.59.1708958204920;
        Mon, 26 Feb 2024 06:36:44 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id n7-20020aa78a47000000b006e50bbf4e71sm2634040pfa.9.2024.02.26.06.36.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:44 -0800 (PST)
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
Subject: [RFC PATCH 39/73] KVM: x86/PVM: Handle hypercall for CR3 switching
Date: Mon, 26 Feb 2024 22:35:56 +0800
Message-Id: <20240226143630.33643-40-jiangshanlai@gmail.com>
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

If the guest uses the same page table for supervisor mode and user mode,
then the user mode can access the supervisor mode address space.
Therefore, for safety, the guest needs to provide two different page
tables for one process, which is similar to KPTI. When switching CR3
during the process switching, the guest uses the hypercall to provide
the two page tables for the hypervisor, and then the hypervisor can
switch CR3 during the mode switch automatically. Additionally, an extra
flag is introduced to perform TLB flushing at the same time.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 8d8c783c72b5..ad08643c098a 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1459,6 +1459,42 @@ static void pvm_flush_tlb_guest_current_kernel_user(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
 }
 
+/*
+ * Hypercall: PVM_HC_LOAD_PGTBL
+ *	Load two PGDs into the current CR3 and MSR_PVM_SWITCH_CR3.
+ *
+ * Arguments:
+ *	flags:	bit0: flush the TLBs tagged with @pgd and @user_pgd.
+ *		bit1: 4 (bit1=0) or 5 (bit1=1 && cpuid_has(LA57)) level paging.
+ *	pgd: to be loaded into CR3.
+ *	user_pgd: to be loaded into MSR_PVM_SWITCH_CR3.
+ */
+static int handle_hc_load_pagetables(struct kvm_vcpu *vcpu, unsigned long flags,
+				     unsigned long pgd, unsigned long user_pgd)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long cr4 = vcpu->arch.cr4;
+
+	if (!(flags & 2))
+		cr4 &= ~X86_CR4_LA57;
+	else if (guest_cpuid_has(vcpu, X86_FEATURE_LA57))
+		cr4 |= X86_CR4_LA57;
+
+	if (cr4 != vcpu->arch.cr4) {
+		vcpu->arch.cr4 = cr4;
+		kvm_mmu_reset_context(vcpu);
+	}
+
+	kvm_mmu_new_pgd(vcpu, pgd);
+	vcpu->arch.cr3 = pgd;
+	pvm->msr_switch_cr3 = user_pgd;
+
+	if (flags & 1)
+		pvm_flush_tlb_guest_current_kernel_user(vcpu);
+
+	return 1;
+}
+
 /*
  * Hypercall: PVM_HC_TLB_FLUSH
  *	Flush all TLBs.
@@ -1540,7 +1576,7 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	unsigned long rip = kvm_rip_read(vcpu);
-	unsigned long a0, a1;
+	unsigned long a0, a1, a2;
 
 	if (!is_smod(pvm))
 		return do_pvm_user_event(vcpu, PVM_SYSCALL_VECTOR, false, 0);
@@ -1552,6 +1588,7 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 
 	a0 = kvm_rbx_read(vcpu);
 	a1 = kvm_r10_read(vcpu);
+	a2 = kvm_rdx_read(vcpu);
 
 	// handle hypercall, check it for pvm hypercall and then kvm hypercall
 	switch (kvm_rax_read(vcpu)) {
@@ -1559,6 +1596,8 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 		return handle_hc_interrupt_window(vcpu);
 	case PVM_HC_IRQ_HALT:
 		return handle_hc_irq_halt(vcpu);
+	case PVM_HC_LOAD_PGTBL:
+		return handle_hc_load_pagetables(vcpu, a0, a1, a2);
 	case PVM_HC_TLB_FLUSH:
 		return handle_hc_flush_tlb_all(vcpu);
 	case PVM_HC_TLB_FLUSH_CURRENT:
-- 
2.19.1.6.gb485710b


