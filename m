Return-Path: <kvm+bounces-18285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CECDA8D3614
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF4001C23ABA
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91688181310;
	Wed, 29 May 2024 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cqzHle9b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFD6180A96
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984876; cv=none; b=mMqvDXhj95c0m942eJUCGCDABMRsORdFeMk3nJg0E7iWCmAmRA6a4Q50vWnXmD3HtkqBqlJ4xxewWbX9D5Kt+F/vMF8QF+9b//FSmiV2tDbaQcuS1ly2OXMK78UCYmNvgkWNyKCWKdNzVFvJeBevd9epkNwqssMy1OAnyyp6t3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984876; c=relaxed/simple;
	bh=BRujChrM4VFfYrpRS71aJErzF3wII2UsmVJlHzt0Ypw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ed+88tbz7cPDgUIQpXirFe2CMhI4N7K/7L73ZSbP9i5WPkGxqQrsHTGxyN7hFUDDuq3ioJwQ5T8h8qL35INxG2PL0cSGzRqTZrEC+KD3w+extX0BmOOszf+lkj/KZ/WRlhwgRjMoHsg1k4mKdqpa6u/rvRzwgdhkt1DL9ZW6SeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cqzHle9b; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-579cced186eso891366a12.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984873; x=1717589673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tLmL1So5x4FnLH0kyn2ty29vEdym4EM/KIgVNMwbuEQ=;
        b=cqzHle9bxHtRS5QZhxySFLYVqHaztfaxfqnVL9R01yujk+0qDSGKdJxZmzpJ5Zp8WA
         x4SP8mZxR4a1YSz9qm8vaSU/jcRGgSpggYIKxIVBRCWJ6w3hXMkDkEgRC8r5f9HGFKT8
         z2PNFvQWm0muCZ9DQyALXAMh9PIPuiVioPzAm6XCTYcYyJslv6vk1r1Zx5U0MPRRDPoT
         fcZu5nESXPkGWdQ5jolYpXoGIYQRMHWQMeASdVXBAq3xvhf3DterDrpOQv6eSkRDl2qT
         VCcX+h09bDYZch5672EROt9gdWanesoSnWwwY5+grLxEcG3eRE7jfQ2MMAg9P21AQlkn
         d6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984873; x=1717589673;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tLmL1So5x4FnLH0kyn2ty29vEdym4EM/KIgVNMwbuEQ=;
        b=T29IF4U38lzP53ymR6ZttHiwSYQeutH/QNuBO5LTSY5/5a0VbSqrWCIaWFtzxGrN7V
         os+KcebzGtJLq9SU4Jy3gaGAYsj4tpmOVYjxREQT6S/CajT+r/t1fP6kydDGq66VYBMZ
         hbozKiQurWY2KjiMKwdFEaIXiCzDeIJMdVKxpKNqdt7YNGkSmtfU8I6DnSmsbDJiwX/M
         kkfL43sw560H+niN8EnyhCAMhA8CbCxT7o4SVYtwepDAXAQxrD0F1msAHQ7IOKnRGcPh
         2TrX41x7Z7OKTbcDSnkDZ7+hIJ4J+33PsDPBpB+tqghz3+ZwT85banTo0YstWY94LtaE
         c5rw==
X-Forwarded-Encrypted: i=1; AJvYcCXDzce/H1l+W9TK2RAxwSItoRAEujpXBaIxsO6Lg45stwYaqxU/a0Kq3NcmkrDTLhX8fY4wm9sBE8CEq2Mdr951M26g
X-Gm-Message-State: AOJu0YzzqvJXQNjT8Yvcc4cQehL+7NU3nbcPGD1DRV+utPz79jicmtVq
	2fr+NQ5or3tKiuxSR/RuIs0mrEyl5MYPBhPN3jGZ8c7WjMIvi3EgJUowjYqR9165Xkf01s8+/Q=
	=
X-Google-Smtp-Source: AGHT+IFoWb2krclv9TkDbcARu8wLLSDlMlxLJgD2KUqfjrU7i3St1EL1/OV74yeBjy7fXa7WBSwaGQ6E2A==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:3223:b0:572:6e36:f0f7 with SMTP id
 4fb4d7f45d1cf-578519bbf75mr18449a12.6.1716984873520; Wed, 29 May 2024
 05:14:33 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:08 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-3-ptosi@google.com>
Subject: [PATCH v4 02/13] KVM: arm64: Fix __pkvm_init_switch_pgd call ABI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Fix the mismatch between the (incorrect) C signature, C call site, and
asm implementation by aligning all three on an API passing the
parameters (pgd and SP) separately, instead of as a bundled struct.

Remove the now unnecessary memory accesses while the MMU is off from the
asm, which simplifies the C caller (as it does not need to convert a VA
struct pointer to PA) and makes the code slightly more robust by
offsetting the struct fields from C and properly expressing the call to
the C compiler (e.g. type checker and kCFI).

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL=
2")
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 +--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 17 +++++++++--------
 arch/arm64/kvm/hyp/nvhe/setup.c    |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3e80464f8953..58b5a2b14d88 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index 2994878d68ea..d859c4de06b6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -265,33 +265,34 @@ alternative_else_nop_endif
=20
 SYM_CODE_END(__kvm_handle_stub_hvc)
=20
+/*
+ * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void)=
);
+ */
 SYM_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
-	mrs	x2, sctlr_el2
-	bic	x3, x2, #SCTLR_ELx_M
+	mrs	x9, sctlr_el2
+	bic	x3, x9, #SCTLR_ELx_M
 	msr	sctlr_el2, x3
 	isb
=20
 	tlbi	alle2
=20
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x4, x0
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
 alternative_else_nop_endif
 	msr	ttbr0_el2, x4
=20
 	/* Set the new stack pointer */
-	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
-	mov	sp, x0
+	mov	sp, x1
=20
 	/* And turn the MMU back on! */
 	dsb	nsh
 	isb
-	set_sctlr_el2	x2
-	ret	x1
+	set_sctlr_el2	x9
+	ret	x2
 SYM_FUNC_END(__pkvm_init_switch_pgd)
=20
 	.popsection
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index 859f22f754d3..1cbd2c78f7a1 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt =3D hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
=20
 	BUG_ON(kvm_check_pvm_sysreg_table());
@@ -340,7 +340,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 	/* Jump in the idmap page to switch to the new page-tables */
 	params =3D this_cpu_ptr(&kvm_init_params);
 	fn =3D (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
-	fn(__hyp_pa(params), __pkvm_init_finalise);
+	fn(params->pgd_pa, (void *)params->stack_hyp_va, __pkvm_init_finalise);
=20
 	unreachable();
 }
--=20
2.45.1.288.g0e0cd299f1-goog


