Return-Path: <kvm+bounces-58247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62547B8B850
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E7C3B61644
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33432ED85F;
	Fri, 19 Sep 2025 22:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ts83Oy/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B122EC0A6
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321222; cv=none; b=SY6PwQkYl+eQ/F60o3+j05jjmuQwt9Nr5QtMeLJPRxrhG7AbcMEEy8IfZgDp9tvnPuvpuhvDb9bLBXZaW9+7R1mpH0I0jRxZuyztNV9Q7ET3nJqJLQGUBMcX/2P5OvLAVOI1zr1xS71+/xOVbDvMjq7O5AQkyeZXhT7N5UF0SgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321222; c=relaxed/simple;
	bh=uG9bXWDIWzkiZpTlZg3ixCoLZTrBCn9VZQhCLroy1xM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m0yj8bQOKSTe++B9/5vwCN1DMD33rSgIdI6QxAQkOJj930t7RPzV3uY+F+f6r7YYnKpXHOj6EhMl8KS+w4gDacCLTBAbCY+r8ZgUoLVH++y/TCGvHCHPj/pgVrkc67CHML7SW+sELvvbhrg5nss8eULirzSvW/+lT+LznnzB8U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ts83Oy/I; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-25bdf8126ceso51486845ad.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321220; x=1758926020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jXbbUJTAlZz0ESr1zTujfBxBxuUlILmrloK4p7bMQkI=;
        b=Ts83Oy/IDGe6K5GD7XdDpe65dqzKc8PWBUHREzWnbI2AKf/yvFBk3m19h1EM677IBc
         qGenBPQOp+N/23cvIX24hPgnS57fEvUtMDDPp1ZMQ38SEQtdMDs2zh8mghac5+Ng9vDD
         92xvE1pJ+gib6vEs+v7BiM6YPeH14G6TnkUtUIwx3LYBxHwxc+okQBsloG+VQqcChkfj
         cEBqWY33qk9Nq5x834wjPKgBTgnDh+fCBBY7qcXrVrFXQoqVwXKibNzk4sYLPnkwq7qQ
         MYBE6utyqiQICjk5Gp50uszq/NtN5j5XX0vCZ4Ss5mdTGiPxhiO98X67Vze1NsdxnQx0
         Qn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321220; x=1758926020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXbbUJTAlZz0ESr1zTujfBxBxuUlILmrloK4p7bMQkI=;
        b=M91gB1+Yx772nZpe6c26L2B9kMnV1j0YCsDxlqwfZAfgvb/fYf4UMGPu796S0H8clT
         QFHdGOKWzab6LMZcsoHzgTT9To2VKyQRaZ6uOvjpR7T8zDgwpM8Zh+dS2cHaGP6TTJ0F
         u1oMY4g1wNJwixXt4Mr9jSk7CDabRPaPowz/zufhfCvWumG9wXMddPLgv3uwCTj6BbGU
         aZacI7h+MgmeJNJyYe/+lCNb9IQdsGY4DNJXzOe323sE1Phx/oObSj/Aof7vEfmJUYpj
         9gNGQpFZhc+kTE/PNA+AyvBp0aWXK8NIaWtxF7/5mK8rP60QY4smub61yNy2qnOYyblW
         p2Ow==
X-Gm-Message-State: AOJu0YwJo9/rl+EqOeXLbbZJtrhEZ2n5HxWG/1+ZF6sbhFtACIRzFC5a
	2OGs8tC+w8UGXIE7DmmfBn5D0vaPKk3Dlok1vmRJvN510fANNTxQ66/IpY0eZJ1HCzwJ7GZdDF5
	aOFT6yw==
X-Google-Smtp-Source: AGHT+IGQL7tEj9y3QqIy9rxMayS2h3ZvzQjM9aM2+GrEwNHAtkUXVl4yGiUS3J18F9JoCCXAg1ftO+S5XNY=
X-Received: from pjbqx8.prod.google.com ([2002:a17:90b:3e48:b0:32e:3830:65f2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cccc:b0:263:3e96:8c21
 with SMTP id d9443c01a7336-269ba40208amr52153615ad.9.1758321219818; Fri, 19
 Sep 2025 15:33:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:26 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-20-seanjc@google.com>
Subject: [PATCH v16 19/51] KVM: x86: Don't emulate task switches when IBT or
 SHSTK is enabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Exit to userspace with KVM_INTERNAL_ERROR_EMULATION if the guest triggers
task switch emulation with Indirect Branch Tracking or Shadow Stacks
enabled, as attempting to do the right thing would require non-trivial
effort and complexity, KVM doesn't support emulating CET generally, and
it's extremely unlikely that any guest will do task switches while also
utilizing CET.  Defer taking on the complexity until someone cares enough
to put in the time and effort to add support.

Per the SDM:

  If shadow stack is enabled, then the SSP of the task is located at the
  4 bytes at offset 104 in the 32-bit TSS and is used by the processor to
  establish the SSP when a task switch occurs from a task associated with
  this TSS. Note that the processor does not write the SSP of the task
  initiating the task switch to the TSS of that task, and instead the SSP
  of the previous task is pushed onto the shadow stack of the new task.

Note, per the SDM's pseudocode on TASK SWITCHING, IBT state for the new
privilege level is updated.  To keep things simple, check both S_CET and
U_CET (again, anyone that wants more precise checking can have the honor
of implementing support).

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Closes: https://lore.kernel.org/all/819bd98b-2a60-4107-8e13-41f1e4c706b1@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2cccc7594d4..0c060e506f9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12178,6 +12178,25 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 	int ret;
 
+	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_CET)) {
+		u64 u_cet, s_cet;
+
+		/*
+		 * Check both User and Supervisor on task switches as inter-
+		 * privilege level task switches are impacted by CET at both
+		 * the current privilege level and the new privilege level, and
+		 * that information is not known at this time.  The expectation
+		 * is that the guest won't require emulation of task switches
+		 * while using IBT or Shadow Stacks.
+		 */
+		if (__kvm_emulate_msr_read(vcpu, MSR_IA32_U_CET, &u_cet) ||
+		    __kvm_emulate_msr_read(vcpu, MSR_IA32_S_CET, &s_cet))
+			return EMULATION_FAILED;
+
+		if ((u_cet | s_cet) & CET_SHSTK_EN)
+			goto unhandled_task_switch;
+	}
+
 	init_emulate_ctxt(vcpu);
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
@@ -12187,17 +12206,19 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 	 * Report an error userspace if MMIO is needed, as KVM doesn't support
 	 * MMIO during a task switch (or any other complex operation).
 	 */
-	if (ret || vcpu->mmio_needed) {
-		vcpu->mmio_needed = false;
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return 0;
-	}
+	if (ret || vcpu->mmio_needed)
+		goto unhandled_task_switch;
 
 	kvm_rip_write(vcpu, ctxt->eip);
 	kvm_set_rflags(vcpu, ctxt->eflags);
 	return 1;
+
+unhandled_task_switch:
+	vcpu->mmio_needed = false;
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 0;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_task_switch);
 
-- 
2.51.0.470.ga7dc726c21-goog


