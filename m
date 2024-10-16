Return-Path: <kvm+bounces-29033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A2D9A14E9
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 23:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 706511F2367D
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 21:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBC61865E2;
	Wed, 16 Oct 2024 21:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="DLZbzp2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A01D27B1
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729114680; cv=none; b=KdvbMZhoex7rF8D7LvMK0EVBFsiSVF9M1kdvkcHRcNEReOSLdnZdks8w9BvyrIPZwIyMnD1SdEaSJxNLp+d/e7tfGPeLUXrMwCVeKQMFQ+ZL2MjPOHauwrvJhCedewHpwhGHKUUZaqHPk2xLBoUO76kv2ZN0p3XTlrzQM+yIDM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729114680; c=relaxed/simple;
	bh=0ftiz8/PJ2BXnKXN6KtR+nBUTcWtl/DbJJX/Z6yLX5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZNmg+Amt+DtxLHwy/lfy88mNX/T+IUxDVBRxjS4yN4u9hMrOn58erYPwQLhP21e8a6d6VBsr2Dso3gW/kKgx6b86xdnBC9pX0GiMRZH+mPBk/wRMLfEFtVZLa41ge8DfHNenSNL7SbgiJyDLfB9Y1h2AfhMU2LwNcMFAiRjQ8/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=DLZbzp2E; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539e4b7409fso291861e87.0
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 14:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729114677; x=1729719477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YznlNfPmglMUg5tZFDFUIFHN41LFVDmI36C4tGvTFk=;
        b=DLZbzp2E1VAmpLQiuGykjBJDklC+r7B3t2M3c93roMJg/VWHKlj6xncOomPinD17Gr
         nTJYyZFNNXZ71nhjW0+2SHvVhFWt5mw2GMdpsrkDDhhCFB/EvoBkzmaIeyhZYTwib5bX
         Qkv2QVuW8n4PF4QMvihvBmoP1w4jXa9elmFFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729114677; x=1729719477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YznlNfPmglMUg5tZFDFUIFHN41LFVDmI36C4tGvTFk=;
        b=YgDKTqN/wpodOPZXRSxgEglfYDqeORsGiYFNghpB2jLRVX8c6U3uqYXZzYdo7vSzkT
         T5w6yhOj5P4q/Ku03/y7y7OqesPqsBabnR+uf/mS5aNru3TZiy/1y7ymADf+HEkdxxCE
         s0Rrm5JAoXvLZm31TCvzjJlqzd4YBRvYncVqdD3cTRijLDoi4F/PLTZIsQcFGloHtS8g
         dcwEHkO1pz7TTlfBJPzj8zwJJvgaacbnagRyBePoAUd7o79f9srdUq5cRt2VkLwnMqZX
         KXAAVat/exWXygG/FxFQv9FPIKhAYML26hN60hfYCnyYS9ef0axBe6mQq54Jq7jhz2W+
         QtcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9qW6qRow6pOIwtypg4TtZ1CMLFOtbG5lX1AVyCINeKhSuds5CJ4aKU4qPPBJxCYmASPM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPVk32Fq0OoGQAN150f7vdGUJbUhQPqi5z3QvI0kz47B3i1Qio
	YlSXq25tytnf8gp8UmNtcAjIJ0gzWpV/bpbiljSKbBbAiCWWkRfzertSUsvdf8fTxuINf5tKHVp
	PtJufIv1AIwlzEdDiozZQCG60ryhW1ABguFZ6
X-Google-Smtp-Source: AGHT+IFj9tyESsCJ6J96tM8hMvteUTyEpM92Iaw4llEr3qWo3ylAwmBp3kDxxSD8nRDRtkcl2BXGiAgd+cAwfJXLyIQ=
X-Received: by 2002:a05:6512:3c81:b0:53a:41a:69bb with SMTP id
 2adb3069b0e04-53a0c709c49mr241179e87.28.1729114677218; Wed, 16 Oct 2024
 14:37:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-5-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-5-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Wed, 16 Oct 2024 14:37:45 -0700
Message-ID: <CAOnJCU+4qNAsqDO4bvL9OdRdFBDavpTiLEEYSaYpHG4R=1W0Og@mail.gmail.com>
Subject: Re: [PATCH 04/13] RISC-V: KVM: Break down the __kvm_riscv_switch_to()
 into macros
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:09=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> Break down the __kvm_riscv_switch_to() function into macros so that
> these macros can be later re-used by SBI NACL extension based low-level
> switch function.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_switch.S | 52 +++++++++++++++++++++++++++---------
>  1 file changed, 40 insertions(+), 12 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index 3f8cbc21a644..9f13e5ce6a18 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -11,11 +11,7 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/csr.h>
>
> -       .text
> -       .altmacro
> -       .option norelax
> -
> -SYM_FUNC_START(__kvm_riscv_switch_to)
> +.macro SAVE_HOST_GPRS
>         /* Save Host GPRs (except A0 and T0-T6) */
>         REG_S   ra, (KVM_ARCH_HOST_RA)(a0)
>         REG_S   sp, (KVM_ARCH_HOST_SP)(a0)
> @@ -40,10 +36,12 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_S   s9, (KVM_ARCH_HOST_S9)(a0)
>         REG_S   s10, (KVM_ARCH_HOST_S10)(a0)
>         REG_S   s11, (KVM_ARCH_HOST_S11)(a0)
> +.endm
>
> +.macro SAVE_HOST_AND_RESTORE_GUEST_CSRS __resume_addr
>         /* Load Guest CSR values */
>         REG_L   t0, (KVM_ARCH_GUEST_SSTATUS)(a0)
> -       la      t1, .Lkvm_switch_return
> +       la      t1, \__resume_addr
>         REG_L   t2, (KVM_ARCH_GUEST_SEPC)(a0)
>
>         /* Save Host and Restore Guest SSTATUS */
> @@ -62,7 +60,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_S   t0, (KVM_ARCH_HOST_SSTATUS)(a0)
>         REG_S   t1, (KVM_ARCH_HOST_STVEC)(a0)
>         REG_S   t3, (KVM_ARCH_HOST_SSCRATCH)(a0)
> +.endm
>
> +.macro RESTORE_GUEST_GPRS
>         /* Restore Guest GPRs (except A0) */
>         REG_L   ra, (KVM_ARCH_GUEST_RA)(a0)
>         REG_L   sp, (KVM_ARCH_GUEST_SP)(a0)
> @@ -97,13 +97,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>
>         /* Restore Guest A0 */
>         REG_L   a0, (KVM_ARCH_GUEST_A0)(a0)
> +.endm
>
> -       /* Resume Guest */
> -       sret
> -
> -       /* Back to Host */
> -       .align 2
> -.Lkvm_switch_return:
> +.macro SAVE_GUEST_GPRS
>         /* Swap Guest A0 with SSCRATCH */
>         csrrw   a0, CSR_SSCRATCH, a0
>
> @@ -138,7 +134,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_S   t4, (KVM_ARCH_GUEST_T4)(a0)
>         REG_S   t5, (KVM_ARCH_GUEST_T5)(a0)
>         REG_S   t6, (KVM_ARCH_GUEST_T6)(a0)
> +.endm
>
> +.macro SAVE_GUEST_AND_RESTORE_HOST_CSRS
>         /* Load Host CSR values */
>         REG_L   t0, (KVM_ARCH_HOST_STVEC)(a0)
>         REG_L   t1, (KVM_ARCH_HOST_SSCRATCH)(a0)
> @@ -160,7 +158,9 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_S   t1, (KVM_ARCH_GUEST_A0)(a0)
>         REG_S   t2, (KVM_ARCH_GUEST_SSTATUS)(a0)
>         REG_S   t3, (KVM_ARCH_GUEST_SEPC)(a0)
> +.endm
>
> +.macro RESTORE_HOST_GPRS
>         /* Restore Host GPRs (except A0 and T0-T6) */
>         REG_L   ra, (KVM_ARCH_HOST_RA)(a0)
>         REG_L   sp, (KVM_ARCH_HOST_SP)(a0)
> @@ -185,6 +185,34 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         REG_L   s9, (KVM_ARCH_HOST_S9)(a0)
>         REG_L   s10, (KVM_ARCH_HOST_S10)(a0)
>         REG_L   s11, (KVM_ARCH_HOST_S11)(a0)
> +.endm
> +
> +       .text
> +       .altmacro
> +       .option norelax
> +
> +       /*
> +        * Parameters:
> +        * A0 <=3D Pointer to struct kvm_vcpu_arch
> +        */
> +SYM_FUNC_START(__kvm_riscv_switch_to)
> +       SAVE_HOST_GPRS
> +
> +       SAVE_HOST_AND_RESTORE_GUEST_CSRS .Lkvm_switch_return
> +
> +       RESTORE_GUEST_GPRS
> +
> +       /* Resume Guest using SRET */
> +       sret
> +
> +       /* Back to Host */
> +       .align 2
> +.Lkvm_switch_return:
> +       SAVE_GUEST_GPRS
> +
> +       SAVE_GUEST_AND_RESTORE_HOST_CSRS
> +
> +       RESTORE_HOST_GPRS
>
>         /* Return to C code */
>         ret
> --
> 2.34.1
>

Reviewed-by: Atish Patra <atishp@rivosinc.com>

--=20
Regards,
Atish

