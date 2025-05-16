Return-Path: <kvm+bounces-46791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 607FBAB9BD4
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 862EB9E1F6A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A3622F76C;
	Fri, 16 May 2025 12:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="NhvkQ2Iq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB71FBC94
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747397911; cv=none; b=gtHhq7u04BpOVMK5Xyo8rLQ3xxWccQEukU0OItGqtGK8kf7r8SpSOvbr6dAmiTDpjV/xnNwsX9xFiaTl2V9sBvkzXZ3qgRLo2IPr2uZ4C0/p6svMNckjujiBNVa9oobVMBge7hmQlp8jUvCEWtVHWOoBxhDDnRmcczKcfwszJ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747397911; c=relaxed/simple;
	bh=i0ExAqzof2XFCLPmeASsLkrB22kGZnWGGeFJvHlps+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MPsJ+XfFYFKRmiIn3Lz3iNTzJGZ2EMWd/efdX8I7JiXErwEwtJQsm8e/7yIZ8cMD5dQd0SphAS8UoILfeZTyuTE4jQr+GNB1Yl1twh55YvKxbPQDsSs2Raj4J1Nx8k/FOnlaXVpNZuh8lmYeEUH63+/sZXQFO5+NL1qF6oPUAsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=NhvkQ2Iq; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86192b6946eso59636939f.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 05:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747397909; x=1748002709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FXLHJHBQsbaoIB4GIfSa4RhdBp3kCgsZPB8o/GVOJzA=;
        b=NhvkQ2IqKwboYX75ONSl1R+8ITRnzUgQ7mFaqVNHxEHUg9Erzp6oxYTeJNYz8HPCAx
         jcXtyAhVQMUNB1ZTazmSb0GANnT256neVUXKUpMK3eLrhqLpHMiKIO75ZOMgAut/oI4Q
         rYV0qOkOTtUwbWVRTNkyJXR1Q5R5tIpFeGahpa8rIfSAtDcIbe7feseWPbOdg32ZR4kn
         UCdaxc+oKf8f8kF4BhEoQpqQk5AOy9Z+KN8wO5HtP32qLYRosGWtX1X61iI7KIpc+ytX
         bUOgy1IIDYaJROuBIYWinDTdNlCe7+mH6z5ltnSdfYaNrbhLidaS0xqmz9FHoWi7eXJx
         5sgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747397909; x=1748002709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FXLHJHBQsbaoIB4GIfSa4RhdBp3kCgsZPB8o/GVOJzA=;
        b=NksyEsC3rjEnyZI2WD5w1bvoON+sGcq4G1crEd3BC6dWCEtXymT4JyqKcWGT/d5Djd
         zAvzEIPZ0Wgi0NSX9D7LNfa+gzK41LYjAqi2Ow+kuDSaijao5RehC78X8ojoWSb1sKD6
         JYEd2JvEtbUMozzAQgyulPkvjQMcg+4yKxBe2gPVIO8JdmWvWiAOXwVzNNxx3Tuy4ZHd
         vTLADwio3fftY7vWbpClRAXtj/I3AnTX/U1aBWHd59WPGAt0H57cqzDK/XClvhXmgiE8
         oIsjr2zD0WoK0FRL99M7TnOCf58KoekHaBdJHdoHUmgT2yn7WeNCSfZCvIruO8Sr8te8
         4ftw==
X-Forwarded-Encrypted: i=1; AJvYcCWMKVKCuk63B6XT2gsNEgGfRRXuRHRjOMOUG68j7v7Tr8Co93e8dhDGvwVbv9VTuHH39/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWAZygobqfmA0gsgDZonERpoeHctJcMZv76Z32l5+Vggtu8Uiv
	FHesi+/aDa2IXvnQuekjaoZTm9mHVlgmQQYMUFIqP9sjXeP39Gtsj2AkHDe5GpVR8jm9J8807gE
	wT+yHAUlGu9A2PgdsPBDylq+UL79FAMb4MhfEzs0tww==
X-Gm-Gg: ASbGnctsZY3X4SqSlPPe6a7BvlLwo23qtXvIOjWsb/bDNh9QHbT8itx0GSg1unqlWcC
	qmevhdtn3fD/hLKfuYkF4fxiTMYK6elcFLD0mbzIPBGn/PtdBgYftx4D79FbzcogBbHsQI7iF+a
	xsSmiSUrfmYrhsGouTpEImaU5bxCn1sRFl1A==
X-Google-Smtp-Source: AGHT+IHD34D+aR8KNoG6UkMJChpNYbMrPeEL3hYF56R0IoB3miRbKE+gadHVNrNRu+Eu4UN/LJ5mYFMMVGXgscMuLoE=
X-Received: by 2002:a05:6602:388b:b0:85b:b82f:965b with SMTP id
 ca18e2360f4ac-86a24cd615cmr292088439f.12.1747397908949; Fri, 16 May 2025
 05:18:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com>
In-Reply-To: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 16 May 2025 17:48:18 +0530
X-Gm-Features: AX0GCFurvQGwK_iA09j5NRc65qTDV-rGIIByVlNf-XtMe4x-bC4mOj899x_A1VI
Message-ID: <CAAhSdy38s0WWc7Cv4KF+0_pGC3xKU3_PLgeedz7Pu04-xKm4jw@mail.gmail.com>
Subject: Re: [PATCH v3] RISC-V: KVM: Remove scounteren initialization
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 4:41=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> Scounteren CSR controls the direct access the hpmcounters and cycle/
> instret/time from the userspace. It's the supervisor's responsibility
> to set it up correctly for it's user space. They hypervisor doesn't
> need to decide the policy on behalf of the supervisor.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Changes in v3:
> - Removed the redundant declaration
> - Link to v2: https://lore.kernel.org/r/20250515-fix_scounteren_vs-v2-1-1=
fd8dc0693e8@rivosinc.com
>
> Changes in v2:
> - Remove the scounteren initialization instead of just setting the TM bit=
.
> - Link to v1: https://lore.kernel.org/r/20250513-fix_scounteren_vs-v1-1-c=
1f52af93c79@rivosinc.com
> ---
>  arch/riscv/kvm/vcpu.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 60d684c76c58..9bfaae9a11ea 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -111,7 +111,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>         int rc;
>         struct kvm_cpu_context *cntx;
> -       struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
>
>         spin_lock_init(&vcpu->arch.mp_state_lock);
>
> @@ -146,9 +145,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
>                 return -ENOMEM;
>
> -       /* By default, make CY, TM, and IR counters accessible in VU mode=
 */
> -       reset_csr->scounteren =3D 0x7;
> -
>         /* Setup VCPU timer */
>         kvm_riscv_vcpu_timer_init(vcpu);
>
>
> ---
> base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
> change-id: 20250513-fix_scounteren_vs-fdd86255c7b7
> --

Overall, this looks good.

Reviewed-by: Anup Patel <anup@brainfault.org>

Currently, the scounteren.TM bit is only set by the Linux SBI PMU
driver but KVM RISC-V only provides SBI PMU for guest when
Sscofpmf is available in host so we need the below hunk to
completely get rid-off scounteren initialization in KVM RISC-V.

diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 356d5397b2a2..bdf3352acf4c 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -131,6 +131,12 @@ secondary_start_sbi:
     csrw CSR_IE, zero
     csrw CSR_IP, zero

+#ifndef CONFIG_RISCV_M_MODE
+    /* Enable time CSR */
+    li t0, 0x2
+    csrw CSR_SCOUNTEREN, t0
+#endif
+
     /* Load the global pointer */
     load_global_pointer

@@ -226,6 +232,10 @@ SYM_CODE_START(_start_kernel)
      * to hand it to us.
      */
     csrr a0, CSR_MHARTID
+#else
+    /* Enable time CSR */
+    li t0, 0x2
+    csrw CSR_SCOUNTEREN, t0
 #endif /* CONFIG_RISCV_M_MODE */

     /* Load the global pointer */

I have queued this patch for Linux-6.16 with the above hunk squashed.

Thanks,
Anup

