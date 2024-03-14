Return-Path: <kvm+bounces-11827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8928587C43B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED9301F22430
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 20:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA26776054;
	Thu, 14 Mar 2024 20:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wf7HEDqD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277E47317E
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 20:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447861; cv=none; b=ez002zvXq/fTbPdocNb6UZe28yTTs/BGx/0lBP3CqoC2swjTDvbzXiI6RLqAdkEPOdgL1I020eRAf15JJk3am9JASYcSnK6kkdwRlnDaVyRPhMyLWXRNe6blTbRBP8LEnxabPIKEVt+rsDx0lIqEqnYLdGsKFBn1h+lLUBhbQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447861; c=relaxed/simple;
	bh=VNW8QZydmWpg/n7NPOfyNLIqspWVeZ/mxJN8WQ/9sL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szC6f2bRGjDVx185yLT2PN63A0IPKpiwH1wiu3yuLQ0QuBEkNAQxEMIBhan0KYViYEBy7ac0205R987xIsRLHJk2Nk8+mzLls/fwXz4wsCPrctsf1atZRyM7s4oE8R9wrk4jXxXXoQIN0POoX2DyBcEwdemeNpP/WxejBqGk1E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wf7HEDqD; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-568aa282ccdso275464a12.3
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447858; x=1711052658; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FGHXKr9Rrdhb7ltTqwpYqVe2UrsjZifyrXsCqgg5SVI=;
        b=Wf7HEDqD89CIX62zz0HCMTgJZYFd2w+Vg+gKUV4D4BW3W60gmNc4WQ/LyWEmbXKh0p
         walKocegqY1iBfhHEWOn6SINtNRau22ObMKk538O0nn7vemuVn3PDhswtw/MgdXUg7sQ
         bPPDH8GPbIeJT0JUi3dzDsYkBvDqbJFt+BPA/8hoSAAnrIsjmhCo6L1uHNYHAxHObQ+1
         eT12ZbAkFMfULbcV7NVwPC3uQPmLDjfH+gOHiKJxgb8qtJ8TIQ2WFBnx9L2MsByVT/U2
         Eu2i99h90YYTSLJy8qZcpN2Lm2eF2YnUTldgVt7jjjQ6lfhceA1h/n1nrIrg5Ii1Kj02
         8Oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447858; x=1711052658;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FGHXKr9Rrdhb7ltTqwpYqVe2UrsjZifyrXsCqgg5SVI=;
        b=t2me3gwEu04uLPQmSNXXh+aksiVku118J3i1ooJ4tSuJgfpjNaGvIkyuOnVCVN2Trt
         xP1aFLXFhUftiA2hxsi7JjBkBjrDIquX1vHvNA0Ql/e/wmXIeY++l3dm6Ts9jtScobC/
         IwoI0NcCsqcICD/gL2QuuVyiCePc+vuBglnSCjnJp3bqcrsF6QtaVY7qJS/K0Sufs6LM
         i1Mgzkfcv6f9phvKpz11GnhOo9QED8RXrmBAaGmcwfl9gXDQHdTHTpaZI/UbYfjhf5L8
         ApQj5HK1NqK/OvADjXB28p94BZ33Q7ocJTeEMyLnD0h/9hi6UBF2BasmH4coF9ghN17v
         /2gA==
X-Forwarded-Encrypted: i=1; AJvYcCV+D+qExaFI3S+TU/71VqrsJPam1mjwnefDBvkCM7aIipoEn33HI7N9RFMVE4YbNSR5vg9BVaZ8GjYmS6LppmA9uuio
X-Gm-Message-State: AOJu0Yy/VH5AKYy1UgdPBogrsfMV60/Nx5dfH3nf8IUKNdQxS/jMEUBg
	e9FSYwBs3fCQ3wjMN6iRfkIAR8SD8vOy0hygAIGh33apE1qOE63v0TenPrjGjP0xj12o1h32Q0G
	sQMsf
X-Google-Smtp-Source: AGHT+IGDSjzpxZf8AVYQE+b2VkhZATxpfpcqloyDmGyoEsgY/Kxfu5Lu+ucHeadFj0dWnxHl32HuWQ==
X-Received: by 2002:a05:6402:160c:b0:568:335d:a95d with SMTP id f12-20020a056402160c00b00568335da95dmr1235050edv.18.1710447858444;
        Thu, 14 Mar 2024 13:24:18 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7d358000000b0056729e902f7sm1019134edr.56.2024.03.14.13.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:24:18 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:24:14 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Andrew Scull <ascull@google.com>
Subject: [PATCH 04/10] KVM: arm64: nVHE: Simplify __guest_exit_panic path
Message-ID: <b13ddc391fce3ea01cffae9c694d997381598616.1710446682.git.ptosi@google.com>
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

Immediately jump to __guest_exit_panic when taking an invalid EL2
exception with the nVHE host vector table instead of first duplicating
the vCPU context check that __guest_exit_panic will also perform.

Fix the wrong (probably bitrotten) __guest_exit_panic ABI doc to reflect
how it is used by VHE and (now) nVHE and rename the routine to
__hyp_panic to better reflect that it might not exit through the guest
but will always (directly or indirectly) end up executing hyp_panic().

Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/entry.S              | 14 +++++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  8 +-------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 9cdf46da3051..ac8aa8571b2f 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
 
-SYM_INNER_LABEL(__guest_exit_panic_with_restored_elr, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_panic_with_restored_elr, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
 
 	stp	x0, x1, [sp, #-16]!
@@ -92,13 +92,15 @@ SYM_INNER_LABEL(__guest_exit_panic_with_restored_elr, SYM_L_GLOBAL)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
 
-SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
-	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
+SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: vcpu regs
+
+	stp	x0, x1, [sp, #-16]!
 
 	// If the hyp context is loaded, go straight to hyp_panic
 	get_loaded_vcpu x0, x1
 	cbnz	x0, 1f
+	ldp	x0, x1, [sp], #16
 	b	hyp_panic
 
 1:
@@ -110,10 +112,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
 	adr_l	x1, hyp_panic
-	str	x1, [x0, #CPU_XREG_OFFSET(30)]
+	str	x1, [x0, #CPU_LR_OFFSET]
 
 	get_vcpu_ptr	x1, x0
 
+	// Keep x0-x1 on the stack for __guest_exit
+
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
 	// x1: vcpu
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 03f97d71984c..7e65ef738ec9 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -122,7 +122,7 @@ el2_error:
 	eret
 	sb
 
-.macro invalid_vector	label, target = __guest_exit_panic
+.macro invalid_vector	label, target = __hyp_panic
 	.align	2
 SYM_CODE_START_LOCAL(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6a8dc8d3c193..0dc721ced358 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -747,7 +747,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_panic_with_restored_elr[];
+	extern char __hyp_panic_with_restored_elr[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -769,7 +769,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 	}
 
 	/* Trigger a panic after restoring the hyp context. */
-	write_sysreg(__guest_exit_panic_with_restored_elr, elr_el2);
+	write_sysreg(__hyp_panic_with_restored_elr, elr_el2);
 
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 7693a6757cd7..27c989c4976d 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -196,19 +196,13 @@ SYM_FUNC_END(__host_hvc)
 	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
 	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
 	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
-
 	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	hyp_panic
+	b	__hyp_panic
 
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */

-- 
Pierre

