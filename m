Return-Path: <kvm+bounces-29184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9903B9A479D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 22:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 269691F2550D
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 20:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025A8205AC2;
	Fri, 18 Oct 2024 20:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b="Wqqn+rsZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F5A383
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 20:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729281824; cv=none; b=FTd+Y8CHCPjMOnNJOdlCjqPTv6RIVntb2sLkmwDkewSSXR7KdctlFygqWXNW8WbFrAoDggVKF/NTBsYKnv5HhXs8LCHEDySRi8vbBW1FPWw+l8xkgThW9AK+EUDgqY9FQMgqJLxW1GKfH/fFT2ECRgBLew+RLi1EEGhR/cZZpeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729281824; c=relaxed/simple;
	bh=WzAfvF1gL0V+TInebGYjO2cajb1J5JnUbl2PrgUF1EQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LnDI+Omh4BwUlTa5899ngg6FlmqLZQcdrDRWl3SltjlatFcR83UQJt1QWTpjfYRx5qv6TvND1XW89z9ipOccwNU2Lb6DG8ZWG+xQF4tQZIfLFsrxFdw+zht28uDBE0lVDAQISCpQcr+4bZUV6mITGdfIrNZEgts3jG+Ny2rUQWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org; spf=pass smtp.mailfrom=atishpatra.org; dkim=pass (1024-bit key) header.d=atishpatra.org header.i=@atishpatra.org header.b=Wqqn+rsZ; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atishpatra.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atishpatra.org
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539f8490856so3018820e87.2
        for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 13:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1729281819; x=1729886619; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pYatGbzHpPf/eUgS637h+Whp9vo5lmEoMXno6C9b2Cc=;
        b=Wqqn+rsZFzLx/dHvdhN03i8+wnFROc+PkIY+4uhH8pwDCwnreV4EZO84R0IjuxId+c
         5GR876sOgmo4FJsWasFCAAQ8YQ8I7jHapChiFqDJQBVo5nbcFF6xZRrwXb18OK3cWBc9
         4KdzT9v2dNLMBCc+6sUqX0EK+naezc8hZYyPo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729281819; x=1729886619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pYatGbzHpPf/eUgS637h+Whp9vo5lmEoMXno6C9b2Cc=;
        b=BvSISsshD1hELpJ+dbGqaDnikAu2ice9sYIx7WFVWAOvGkZhviEp12thP5Xu1/IGyL
         FA4z2H4Ob49MdyM/8EhCWktSxgM8A0gHY7dRZepaHUH0++HN8rgsBddXkaZ2LHAtKPZn
         xMNj76HafmvZuxLGqoyD21fkaSTQQyXA37KudHcfZ5AIBLUUEVGTqPcVp7g3LA7Nflwp
         jpflWOUP/WjFupU+OPDKth9HmKk1vh5Mkg7x1xBVr87mIe1BkZxzMQ8zk7zRXmTEQQjm
         r9SlUDTh+fyIu3JkDxtK9KLLVS4K4yvzsmxfNvCzVYvrn0CWs9zlTRfm4e1tST+CHKJ3
         AuhA==
X-Forwarded-Encrypted: i=1; AJvYcCXY7isf49nf+LqusvDnWdXVMSbpD7LWngxJgnps//PzIiKcY19ruChQhDsP554Qv6kXdOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLpbUJhWdGXDS86bTCvaHybB7lvDjbLEVleepI3zIzhHJ+gXp1
	qG3+vE9a2my3q1LXKPqL0hGhbeRvl3pp4XiY4mx2S2YrGybg4dLtOwDDIVGLsEXxjkLJQyeBAtd
	vb3YvrI6hh0J/HAwIyIiGXWHnF53o0HO0CzzO
X-Google-Smtp-Source: AGHT+IFdbTtG7sDF7kqFab9oC8x0FqfZ8vBcRVnP/A2kKG0DxefaC9GUZcyQBdYPMMsFWCk/wOfiRnrd0xb3SaYJZrY=
X-Received: by 2002:a05:6512:318e:b0:539:f26f:d285 with SMTP id
 2adb3069b0e04-53a15440cebmr2695842e87.3.1729281818502; Fri, 18 Oct 2024
 13:03:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com> <20240719160913.342027-12-apatel@ventanamicro.com>
In-Reply-To: <20240719160913.342027-12-apatel@ventanamicro.com>
From: Atish Patra <atishp@atishpatra.org>
Date: Fri, 18 Oct 2024 13:03:26 -0700
Message-ID: <CAOnJCU+rORtJecgZA1inp7pzjoK8Rc_q46JNcsEcnm31M8bjJg@mail.gmail.com>
Subject: Re: [PATCH 11/13] RISC-V: KVM: Use SBI sync SRET call when available
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 9:10=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> Implement an optimized KVM world-switch using SBI sync SRET call
> when SBI nested acceleration extension is available. This improves
> KVM world-switch when KVM RISC-V is running as a Guest under some
> other hypervisor.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_nacl.h | 32 +++++++++++++++++++++
>  arch/riscv/kvm/vcpu.c             | 48 ++++++++++++++++++++++++++++---
>  arch/riscv/kvm/vcpu_switch.S      | 29 +++++++++++++++++++
>  3 files changed, 105 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/k=
vm_nacl.h
> index a704e8000a58..5e74238ea525 100644
> --- a/arch/riscv/include/asm/kvm_nacl.h
> +++ b/arch/riscv/include/asm/kvm_nacl.h
> @@ -12,6 +12,8 @@
>  #include <asm/csr.h>
>  #include <asm/sbi.h>
>
> +struct kvm_vcpu_arch;
> +
>  DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
>  #define kvm_riscv_nacl_available() \
>         static_branch_unlikely(&kvm_riscv_nacl_available)
> @@ -43,6 +45,10 @@ void __kvm_riscv_nacl_hfence(void *shmem,
>                              unsigned long page_num,
>                              unsigned long page_count);
>
> +void __kvm_riscv_nacl_switch_to(struct kvm_vcpu_arch *vcpu_arch,
> +                               unsigned long sbi_ext_id,
> +                               unsigned long sbi_func_id);
> +
>  int kvm_riscv_nacl_enable(void);
>
>  void kvm_riscv_nacl_disable(void);
> @@ -64,6 +70,32 @@ int kvm_riscv_nacl_init(void);
>  #define nacl_shmem_fast()                                              \
>         (kvm_riscv_nacl_available() ? nacl_shmem() : NULL)
>
> +#define nacl_scratch_read_long(__shmem, __offset)                      \
> +({                                                                     \
> +       unsigned long *__p =3D (__shmem) +                               =
 \
> +                            SBI_NACL_SHMEM_SCRATCH_OFFSET +            \
> +                            (__offset);                                \
> +       lelong_to_cpu(*__p);                                            \
> +})
> +
> +#define nacl_scratch_write_long(__shmem, __offset, __val)              \
> +do {                                                                   \
> +       unsigned long *__p =3D (__shmem) +                               =
 \
> +                            SBI_NACL_SHMEM_SCRATCH_OFFSET +            \
> +                            (__offset);                                \
> +       *__p =3D cpu_to_lelong(__val);                                   =
 \
> +} while (0)
> +
> +#define nacl_scratch_write_longs(__shmem, __offset, __array, __count)  \
> +do {                                                                   \
> +       unsigned int __i;                                               \
> +       unsigned long *__p =3D (__shmem) +                               =
 \
> +                            SBI_NACL_SHMEM_SCRATCH_OFFSET +            \
> +                            (__offset);                                \
> +       for (__i =3D 0; __i < (__count); __i++)                          =
 \
> +               __p[__i] =3D cpu_to_lelong((__array)[__i]);              =
 \
> +} while (0)
> +

This should be in a separate patch along with other helpers ?

>  #define nacl_sync_hfence(__e)                                          \
>         sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_HFENCE,               \
>                   (__e), 0, 0, 0, 0, 0)
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 00baaf1b0136..fe849fb1aaab 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -759,19 +759,59 @@ static __always_inline void kvm_riscv_vcpu_swap_in_=
host_state(struct kvm_vcpu *v
>   */
>  static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>  {
> +       void *nsh;
>         struct kvm_cpu_context *gcntx =3D &vcpu->arch.guest_context;
>         struct kvm_cpu_context *hcntx =3D &vcpu->arch.host_context;
>
>         kvm_riscv_vcpu_swap_in_guest_state(vcpu);
>         guest_state_enter_irqoff();
>
> -       hcntx->hstatus =3D ncsr_swap(CSR_HSTATUS, gcntx->hstatus);
> +       if (kvm_riscv_nacl_sync_sret_available()) {
> +               nsh =3D nacl_shmem();
>
> -       nsync_csr(-1UL);
> +               if (kvm_riscv_nacl_autoswap_csr_available()) {
> +                       hcntx->hstatus =3D
> +                               nacl_csr_read(nsh, CSR_HSTATUS);
> +                       nacl_scratch_write_long(nsh,
> +                                               SBI_NACL_SHMEM_AUTOSWAP_O=
FFSET +
> +                                               SBI_NACL_SHMEM_AUTOSWAP_H=
STATUS,
> +                                               gcntx->hstatus);
> +                       nacl_scratch_write_long(nsh,
> +                                               SBI_NACL_SHMEM_AUTOSWAP_O=
FFSET,
> +                                               SBI_NACL_SHMEM_AUTOSWAP_F=
LAG_HSTATUS);
> +               } else if (kvm_riscv_nacl_sync_csr_available()) {
> +                       hcntx->hstatus =3D nacl_csr_swap(nsh,
> +                                                      CSR_HSTATUS, gcntx=
->hstatus);
> +               } else {
> +                       hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx->h=
status);
> +               }
>
> -       __kvm_riscv_switch_to(&vcpu->arch);
> +               nacl_scratch_write_longs(nsh,
> +                                        SBI_NACL_SHMEM_SRET_OFFSET +
> +                                        SBI_NACL_SHMEM_SRET_X(1),
> +                                        &gcntx->ra,
> +                                        SBI_NACL_SHMEM_SRET_X_LAST);
> +
> +               __kvm_riscv_nacl_switch_to(&vcpu->arch, SBI_EXT_NACL,
> +                                          SBI_EXT_NACL_SYNC_SRET);
> +
> +               if (kvm_riscv_nacl_autoswap_csr_available()) {
> +                       nacl_scratch_write_long(nsh,
> +                                               SBI_NACL_SHMEM_AUTOSWAP_O=
FFSET,
> +                                               0);
> +                       gcntx->hstatus =3D nacl_scratch_read_long(nsh,
> +                                                               SBI_NACL_=
SHMEM_AUTOSWAP_OFFSET +
> +                                                               SBI_NACL_=
SHMEM_AUTOSWAP_HSTATUS);
> +               } else {
> +                       gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->h=
status);
> +               }
> +       } else {
> +               hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx->hstatus);
>
> -       gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->hstatus);
> +               __kvm_riscv_switch_to(&vcpu->arch);
> +
> +               gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->hstatus);
> +       }
>
>         vcpu->arch.last_exit_cpu =3D vcpu->cpu;
>         guest_state_exit_irqoff();
> diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
> index 9f13e5ce6a18..47686bcb21e0 100644
> --- a/arch/riscv/kvm/vcpu_switch.S
> +++ b/arch/riscv/kvm/vcpu_switch.S
> @@ -218,6 +218,35 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
>         ret
>  SYM_FUNC_END(__kvm_riscv_switch_to)
>
> +       /*
> +        * Parameters:
> +        * A0 <=3D Pointer to struct kvm_vcpu_arch
> +        * A1 <=3D SBI extension ID
> +        * A2 <=3D SBI function ID
> +        */
> +SYM_FUNC_START(__kvm_riscv_nacl_switch_to)
> +       SAVE_HOST_GPRS
> +
> +       SAVE_HOST_AND_RESTORE_GUEST_CSRS .Lkvm_nacl_switch_return
> +
> +       /* Resume Guest using SBI nested acceleration */
> +       add     a6, a2, zero
> +       add     a7, a1, zero
> +       ecall
> +
> +       /* Back to Host */
> +       .align 2
> +.Lkvm_nacl_switch_return:
> +       SAVE_GUEST_GPRS
> +
> +       SAVE_GUEST_AND_RESTORE_HOST_CSRS
> +
> +       RESTORE_HOST_GPRS
> +
> +       /* Return to C code */
> +       ret
> +SYM_FUNC_END(__kvm_riscv_nacl_switch_to)
> +
>  SYM_CODE_START(__kvm_riscv_unpriv_trap)
>         /*
>          * We assume that faulting unpriv load/store instruction is
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish

