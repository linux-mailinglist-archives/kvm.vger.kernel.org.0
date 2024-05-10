Return-Path: <kvm+bounces-17167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F168C2367
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9546A1F25668
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8254C17556E;
	Fri, 10 May 2024 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ptJj/9MW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A63171E5A
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340448; cv=none; b=m/R4HSBwKPFsBc1mB8b59eQ1xE61C5i8F1nlGEvuLSheoJeYz+HBEE3e5iWm3m5aWgPg8Uy/DJb9mcIcTXx4BgorwoVf/li1weDhFusbOQJjMBDvIzNw4d9vqFlSCSzH5TuavMwrQrQFni3QKJgUl54nKkVBgThvzZezz8MKzcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340448; c=relaxed/simple;
	bh=FqP+W3H7ODA8nGAmitghr0+uUjjfekAcblOIn5trRhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IIvniinl7WFBlZGZNlBHEgUlKOFigrdC/cpUKsMS1KJGpcVczkXlquStIW3P7dZvJHJrCkFCIZ/+5vkin6dpsq6isUFCW1gsiXQSyap/w7iIMd1ca3dvcrJdmNE1yMEDHrOYf0frsN7UaXXSIDnYZE9Mk+3qnhxP3zSfn1x4COY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ptJj/9MW; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dee5f035dd6so25284276.0
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340445; x=1715945245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1X74EzIbLgwkSZ3RCE9vimfqgbYyFErrsdDhyQP2Whk=;
        b=ptJj/9MWTl1bhZl9YTkdXxv+XbF/7BTzo+fPgFAVXueFeR6jGsMhEuA13nyLkQznVC
         U3dzd22V9YdVxfgToHjvism0QptPsm8Rxva2iiwF8FGYqA2kjk7vdCP0UrcS88voWlG6
         L80xz0XRJoUzhxm1VaBD5Gtt77xjw9KyiiKkXDmI1Gb/rz07gfJSUPiAMHTv50QKAqdK
         fqCmmD3xf81jd/GFve+XxujMDi25SjjXTHACaMmFikO/Xs2yKfKsji/XZcspt31GhYlV
         biVX6qkbaFs17n+0O01a3W7GsynE2A7e2Oc20JA9YrSiSMk1qTod63xo4sq1KkgAG00w
         aISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340445; x=1715945245;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1X74EzIbLgwkSZ3RCE9vimfqgbYyFErrsdDhyQP2Whk=;
        b=ek+OvSxrwiGRwFj+dxAw3o9AtYaNRCnsumefRt5Yh+CyWh/VvAerzwPwbtO7T0Ch2a
         64tg1GO/g2rzEm0JaKUa0LQOsFRFqRo0cac5SmScah/4Xd9NZmvUV0RO70Qr5mysNjfA
         y2gJBUb6fSK8ZYr0tjhKfHIstciIlF2LYD8G14p6KwlA9TS682SfL1zlK6d8bM/an0St
         qyFA3ypRssiUeBtlpfWjAlQcKVjEilWgTAi7dheP5RV2EGqst7UrUp7irPeq9+Vxm0XO
         LezXNKPlVp0OPpJFvwlwgNbgl7ZuXqr9NSomMgDhFt6eLIApprYILYe5ZcVcyoz3p4rB
         sYFA==
X-Forwarded-Encrypted: i=1; AJvYcCWzKkN4yx6hhUBNhDwlihnnTVPlAVMBcOFV5eYChL0RrHEGC7PgSA7aANYQulouAoRQRB03eyEKfY40rjAh9HN8ex+b
X-Gm-Message-State: AOJu0YxRejN15V7bjLUWLDkFgDr48DsXl630f2z2mphmi64uuruiBhLs
	ja7aTk/kXv5a/BnNYu4vlCmsi4Vd0lAgScJZumvzPhwOxUhXDi6SLzdWrhF8eQ19uDE5cHMkEQ=
	=
X-Google-Smtp-Source: AGHT+IE2vI8V+31DiouhAYXxHwv2C3egPY5JlN+7fyVhlwS8yXv78dpY0cirHvo9+5p4Wx/GqO7X9Ryw0g==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:2b88:b0:dcd:3172:7265 with SMTP id
 3f1490d57ef6-dee4f3036e5mr593281276.8.1715340445332; Fri, 10 May 2024
 04:27:25 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:32 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-4-ptosi@google.com>
Subject: [PATCH v3 03/12] KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Make the function take a VA pointer, instead of a phys_addr_t, to fully
take advantage of the high-level C language and its type checker.

Perform all accesses to the kvm_nvhe_init_params before disabling the
MMU, removing the need to access it using physical addresses, which was
the reason for taking a phys_addr_t.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 12 +++++++++---
 arch/arm64/kvm/hyp/nvhe/setup.c    |  4 +---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 96daf7cf6802..c195e71d0746 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,7 +123,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void))=
;
+void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
+			    void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index 2994878d68ea..5a15737b4233 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -265,7 +265,15 @@ alternative_else_nop_endif
=20
 SYM_CODE_END(__kvm_handle_stub_hvc)
=20
+/*
+ * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
+ *                             void (*finalize_fn)(void));
+ */
 SYM_FUNC_START(__pkvm_init_switch_pgd)
+	/* Load the inputs from the VA pointer before turning the MMU off */
+	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
+	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
+
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x2, sctlr_el2
@@ -276,15 +284,13 @@ SYM_FUNC_START(__pkvm_init_switch_pgd)
 	tlbi	alle2
=20
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x4, x5
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
 alternative_else_nop_endif
 	msr	ttbr0_el2, x4
=20
 	/* Set the new stack pointer */
-	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
 	mov	sp, x0
=20
 	/* And turn the MMU back on! */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index bcaeb0fafd2d..45b83f3ed012 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -314,7 +314,6 @@ void __noreturn __pkvm_init_finalise(void)
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits)
 {
-	struct kvm_nvhe_init_params *params;
 	void *virt =3D hyp_phys_to_virt(phys);
 	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
@@ -338,9 +337,8 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 	update_nvhe_init_params();
=20
 	/* Jump in the idmap page to switch to the new page-tables */
-	params =3D this_cpu_ptr(&kvm_init_params);
 	fn =3D (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
-	fn(__hyp_pa(params), __pkvm_init_finalise);
+	fn(this_cpu_ptr(&kvm_init_params), __pkvm_init_finalise);
=20
 	unreachable();
 }
--=20
2.45.0.118.g7fe29c98d7-goog


