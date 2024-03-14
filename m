Return-Path: <kvm+bounces-11824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C97A87C438
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:23:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87B2C1F22A43
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B35F76056;
	Thu, 14 Mar 2024 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ye7p2FvL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C606976034
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447810; cv=none; b=eVH+OiDbU6B56SWLqpdv7QF149ygZRCpMAEIsG3HjE+FjkcSeiKbaQpj7QLm3o3MRQZFOquS8Mkn2giegtLLvxN6mahdRyiOeOfBs7mjmdgwEJbVo80I10wONy95hmetYQwZ3SO3b/bD7VFEfBvCmhjrMWbw8ky4ZUDMlZ4VyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447810; c=relaxed/simple;
	bh=T77wjvoVt0NOl52aLD2eH3RmLxFBGnGRYUOiu2OSeco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=speguQtESGiQ5McLLavGygYc8cXmvTaW8RYmDM4+qaKxij3cU549KFUMwvociY4O6VXdQ1n7fH3WXjC0+zVxp10JLsFoUHz51Bntw7aFjBSyEM/XTzNHhUJeJz6EAyuTAwAdaLZRhAuzn/XTxY3YOblhbB9530shuI9mTgcyaVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ye7p2FvL; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-513d23be0b6so1145244e87.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447807; x=1711052607; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vZK7QuyaiNpIMjIwqrL5CzPHrd9TH34r0/BLtCyNFDY=;
        b=ye7p2FvLf62F4b8I7F7xajfM1HkqbvVGpbNGjb3lZe9Sw3jnn3V9Mqn9CDQR3yETPW
         SMGoJYfoLfM87+k/0NYjDev3VYKnoBFSAgMes9OuBLTTL2AAEoHeLcP6Iq4vq50xjwrz
         mqspGoYmmzA7XZb9lc1eD0SqoS9h2gdpAyfqYyPPKz/+459EsmpuDZQ6ML+EL1o5OdEk
         Uk/81hd/PmOUc4/YZXcDf25EnalRN0lPjRisq0gYKDwHCh7/c2dzkoR+hLm155ZJcOBN
         STqnS8+SQRxMgh1w5ixoXZkcA336KGHkGPhim4apldQHFrsUOH3yq3fHf0//golL+sy4
         QCtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447807; x=1711052607;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZK7QuyaiNpIMjIwqrL5CzPHrd9TH34r0/BLtCyNFDY=;
        b=UtsTRqqAKF9GzVkptsLd8lSyb5C94hf+0ZddNO7+ZcxnKdU599/TD18V01qehvy2dq
         Hwa4808GoaF1GPqj9sbIyRh5+fDmWGdYgi+Z8Ef7WQkTaWjeAc+6d5UnUgO2jr/IqgQL
         wLWUaBtCF7SpeUInRKqF9+v/nHTL4TzyD9Ey7NObRJn5shFgFeIwqdDxFZwU1coW/68n
         g9d23+RZc+VLsqCs+/sbS3INkDf/4JEL3AhhliOqn4JnMMEYJMPDdtIn+eVgLogW9/ih
         ZcybPKlYThoDlFod5+z2YuW7BanhUylN2i6NlIFJe/47l586qP3TpOlupgnf6VSC20LP
         ESjg==
X-Forwarded-Encrypted: i=1; AJvYcCWxzzGTs2XJves9dDzILo2C8PsplvbEVY4jidYo5nlS6eZ6yo/eFcrztMw08s40mD46AZFGSLkKjrPDQ/xUQIiNQ32g
X-Gm-Message-State: AOJu0Ywo18kMIaeUHE20tqGJ1+jU/VK5J7YoEQTBb5CO7r/AIjN2L2kY
	Yzq/2K0S6OC9XfKVT3IFFm/raDzx3QPMaqRDk/eqf+RPzItsVFw6CI2mVes7uw==
X-Google-Smtp-Source: AGHT+IHQUp4F505tINC00/h603tRttrCrGmHbysW4OYqjcYsqgNLrProci8dq24A2bPmtjVgq53zeg==
X-Received: by 2002:ac2:57c2:0:b0:513:d522:a647 with SMTP id k2-20020ac257c2000000b00513d522a647mr809318lfo.63.1710447806531;
        Thu, 14 Mar 2024 13:23:26 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id h11-20020a1709062dcb00b00a4662df0319sm1018769eji.65.2024.03.14.13.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:23:25 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:23:22 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Andrew Scull <ascull@google.com>
Subject: [PATCH 01/10] KVM: arm64: Fix clobbered ELR in sync abort
Message-ID: <0dfcc4c5c898941147723ba530c81ddc8399ef55.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

When the hypervisor receives a SError or synchronous exception (EL2h)
while running with the __kvm_hyp_vector and if ELR_EL2 doesn't point to
an extable entry, it panics indirectly by overwriting ELR with the
address of a panic handler in order for the asm routine it returns to to
ERET into the handler. This is done (instead of a simple function call)
to ensure that the panic handler runs with the SPSel that was in use
when the exception was triggered, necessary to support features such as
the shadow call stack.

However, this clobbers ELR_EL2 for the handler itself. As a result,
hyp_panic(), when retrieving what it believes to be the PC where the
exception happened, actually ends up reading the address of the panic
handler that called it! This results in an erroneous and confusing panic
message where the source of any synchronous exception (e.g. BUG() or
kCFI) appears to be __guest_exit_panic, making it hard to locate the
actual BRK instruction.

Therefore, store the original ELR_EL2 in a per-CPU struct and point the
sysreg to a routine that first restores it to its previous value before
running __guest_exit_panic.

Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kernel/asm-offsets.c         | 1 +
 arch/arm64/kvm/hyp/entry.S              | 9 +++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ++++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 5a7dbbe0ce63..e62353168a57 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -128,6 +128,7 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2]));
   DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
   DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index f3aa7738b477..9cdf46da3051 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,15 @@ alternative_else_nop_endif
 	eret
 	sb
 
+SYM_INNER_LABEL(__guest_exit_panic_with_restored_elr, SYM_L_GLOBAL)
+	// x0-x29,lr: hyp regs
+
+	stp	x0, x1, [sp, #-16]!
+	adr_this_cpu x0, kvm_hyp_ctxt, x1
+	ldr	x0, [x0, #CPU_ELR_EL2]
+	msr	elr_el2, x0
+	ldp	x0, x1, [sp], #16
+
 SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// x2-x29,lr: vcpu regs
 	// vcpu x0-x1 on the stack
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a038320cdb08..6a8dc8d3c193 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -747,7 +747,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic[];
+	extern char __guest_exit_panic_with_restored_elr[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -769,7 +769,9 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
 
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic, elr_el2);
+	write_sysreg(__guest_exit_panic_with_restored_elr, elr_el2);
+
+	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */

-- 
Pierre

