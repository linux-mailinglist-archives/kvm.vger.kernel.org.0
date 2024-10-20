Return-Path: <kvm+bounces-29209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3F89A562D
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B1E91C20C7A
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BD0197A8E;
	Sun, 20 Oct 2024 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="gi+y7nvw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920C9194C67
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729452500; cv=none; b=Qi+rboPpBGztf1l8XIdUnkOko/CBfVbXQQloNJmb981JVMlVmXhpDt/ou7W0BapQRo2lyOZgE/k9YmThWI+vJCamgszI71LemsSNmsOZzQOhw1mzQ225NGGclDwKWeVwE+ccAUG6RxIj571qw+WszPY3RRou8hsfmiNVVeDCp9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729452500; c=relaxed/simple;
	bh=5Bi3G8Fq72dernPiyu+wY4Ywa0YDykwXEnkAZctMsZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FuUFnDmVU4JSVZ1ngVakTNeXP8iRnnehrxy1vhtHtlHodHBcnfSuNZHliWloYJ9hzH6YkbOtn6UWob37avGvAY06dJI5SPqPNZH81bqMlCzw6ccARq6HWbaLVSvo7r6O3mV0qGl9eWPLEoCdQKTsVJ+pyrvy11icJt6ZvZDbbHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=gi+y7nvw; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a3b6b281d4so15499765ab.0
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1729452497; x=1730057297; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lo1sYL9XZDOCFMQlGLlMPtl2RTXyX/oraDhwcNdvML0=;
        b=gi+y7nvw38aSB6VR3X2GSBMdhlH0NPzX8vpXooeoLH2ETJnENXHTEEhW6noxMWn+Dm
         LMGZGMWSCT+vVX5evhFYyhbadRUVZ5zSoR8KchTLLdd7NjEIIZA0czoPdOuKmB1x/hyS
         hjpJrQt80kD17dmolk2ozfdMfLkzAmibd2pisvFtMAKD68C1sUP1BMc0vB7TL/ukRUuE
         wbhrgRCyOVgp0itdXMyt5mGt/v7UPQTSqG7sWyqUBMI5+JKl23Hw9PdQlQkSwZXlyA3b
         lh7i4U9rWpQnUERvrTKgzYEYU0a2GjNizqnxKZI66Id5FAdSvWKwYyGSkuNfQFrqTv/C
         MQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729452497; x=1730057297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lo1sYL9XZDOCFMQlGLlMPtl2RTXyX/oraDhwcNdvML0=;
        b=q+jMJWULduL+SxwJCv+eF4ky+JR3tyFVz480x34syRdHpliWks+IqPhfvrOk3JQcPB
         CzC69zwK+TPqwn7NKyRXUFek0t96ub0PE/a0bIN5B06yC8X3KL2BURw/GMkGuRlhYiOm
         m4pww9G5rHzJLi3EzywEq6xSJ4tC4jNcupmliccOHiiIJgc8GPxHHw0s3t5rC6NwxJ+l
         IFmRiSFXPCh7ULk6fCNL/MstZyp7ybtX+L9Q1HPMyyzXEZB4MylZx3+iRMpOiiE/+EkF
         VnZ7Z+OXt+hoZgNnVqLxvyav7yPlETJyZoq5rwaaoa4WWSrDKAieX9GADqsm57lYqLgn
         XEMg==
X-Forwarded-Encrypted: i=1; AJvYcCUohPR74WKZ2YBHVTLxJMWlxGg0UyS0MV7iVqdKWn7x75JHScS9SwBJN288hW9WziAhNBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm5ytoW2yBRMVv/pvPC5Ekv9m3QRbZtRP6sMg4z75naiZ+4fzt
	aS7WT9szP2u4Th6iL++r0i+2hSythoKyd/FEUcD5t+qCKS4N4LisjZwPKMD/+cQYl0S2NMT2/oA
	kGLDzn9tdY0ZV1pRGpbNmR+XqcK0mx4T/lFeprA==
X-Google-Smtp-Source: AGHT+IF/05AGlms0paeIinKOowlDh+Z4PGQr0LRA6CuYMYavOxYaakTODKHu7n2oJbjlXgoQHpva7fdFPPHuHLBVnsc=
X-Received: by 2002:a05:6e02:1fc3:b0:3a1:a243:c7a6 with SMTP id
 e9e14a558f8ab-3a3f40531c5mr76368905ab.10.1729452497490; Sun, 20 Oct 2024
 12:28:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com>
 <20240719160913.342027-12-apatel@ventanamicro.com> <CAOnJCU+rORtJecgZA1inp7pzjoK8Rc_q46JNcsEcnm31M8bjJg@mail.gmail.com>
In-Reply-To: <CAOnJCU+rORtJecgZA1inp7pzjoK8Rc_q46JNcsEcnm31M8bjJg@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 21 Oct 2024 00:58:06 +0530
Message-ID: <CAAhSdy1RYERiApvxwgz4rc53qq_6D0Rp90GBBhAJq2uMwqf4mA@mail.gmail.com>
Subject: Re: [PATCH 11/13] RISC-V: KVM: Use SBI sync SRET call when available
To: Atish Patra <atishp@atishpatra.org>
Cc: Anup Patel <apatel@ventanamicro.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 19, 2024 at 1:33=E2=80=AFAM Atish Patra <atishp@atishpatra.org>=
 wrote:
>
> On Fri, Jul 19, 2024 at 9:10=E2=80=AFAM Anup Patel <apatel@ventanamicro.c=
om> wrote:
> >
> > Implement an optimized KVM world-switch using SBI sync SRET call
> > when SBI nested acceleration extension is available. This improves
> > KVM world-switch when KVM RISC-V is running as a Guest under some
> > other hypervisor.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/kvm_nacl.h | 32 +++++++++++++++++++++
> >  arch/riscv/kvm/vcpu.c             | 48 ++++++++++++++++++++++++++++---
> >  arch/riscv/kvm/vcpu_switch.S      | 29 +++++++++++++++++++
> >  3 files changed, 105 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm=
/kvm_nacl.h
> > index a704e8000a58..5e74238ea525 100644
> > --- a/arch/riscv/include/asm/kvm_nacl.h
> > +++ b/arch/riscv/include/asm/kvm_nacl.h
> > @@ -12,6 +12,8 @@
> >  #include <asm/csr.h>
> >  #include <asm/sbi.h>
> >
> > +struct kvm_vcpu_arch;
> > +
> >  DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
> >  #define kvm_riscv_nacl_available() \
> >         static_branch_unlikely(&kvm_riscv_nacl_available)
> > @@ -43,6 +45,10 @@ void __kvm_riscv_nacl_hfence(void *shmem,
> >                              unsigned long page_num,
> >                              unsigned long page_count);
> >
> > +void __kvm_riscv_nacl_switch_to(struct kvm_vcpu_arch *vcpu_arch,
> > +                               unsigned long sbi_ext_id,
> > +                               unsigned long sbi_func_id);
> > +
> >  int kvm_riscv_nacl_enable(void);
> >
> >  void kvm_riscv_nacl_disable(void);
> > @@ -64,6 +70,32 @@ int kvm_riscv_nacl_init(void);
> >  #define nacl_shmem_fast()                                             =
 \
> >         (kvm_riscv_nacl_available() ? nacl_shmem() : NULL)
> >
> > +#define nacl_scratch_read_long(__shmem, __offset)                     =
 \
> > +({                                                                    =
 \
> > +       unsigned long *__p =3D (__shmem) +                             =
   \
> > +                            SBI_NACL_SHMEM_SCRATCH_OFFSET +           =
 \
> > +                            (__offset);                               =
 \
> > +       lelong_to_cpu(*__p);                                           =
 \
> > +})
> > +
> > +#define nacl_scratch_write_long(__shmem, __offset, __val)             =
 \
> > +do {                                                                  =
 \
> > +       unsigned long *__p =3D (__shmem) +                             =
   \
> > +                            SBI_NACL_SHMEM_SCRATCH_OFFSET +           =
 \
> > +                            (__offset);                               =
 \
> > +       *__p =3D cpu_to_lelong(__val);                                 =
   \
> > +} while (0)
> > +
> > +#define nacl_scratch_write_longs(__shmem, __offset, __array, __count) =
 \
> > +do {                                                                  =
 \
> > +       unsigned int __i;                                              =
 \
> > +       unsigned long *__p =3D (__shmem) +                             =
   \
> > +                            SBI_NACL_SHMEM_SCRATCH_OFFSET +           =
 \
> > +                            (__offset);                               =
 \
> > +       for (__i =3D 0; __i < (__count); __i++)                        =
   \
> > +               __p[__i] =3D cpu_to_lelong((__array)[__i]);            =
   \
> > +} while (0)
> > +
>
> This should be in a separate patch along with other helpers ?

Okay, I will move these macros to PATCH8.

>
> >  #define nacl_sync_hfence(__e)                                         =
 \
> >         sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_HFENCE,              =
 \
> >                   (__e), 0, 0, 0, 0, 0)
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 00baaf1b0136..fe849fb1aaab 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -759,19 +759,59 @@ static __always_inline void kvm_riscv_vcpu_swap_i=
n_host_state(struct kvm_vcpu *v
> >   */
> >  static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
> >  {
> > +       void *nsh;
> >         struct kvm_cpu_context *gcntx =3D &vcpu->arch.guest_context;
> >         struct kvm_cpu_context *hcntx =3D &vcpu->arch.host_context;
> >
> >         kvm_riscv_vcpu_swap_in_guest_state(vcpu);
> >         guest_state_enter_irqoff();
> >
> > -       hcntx->hstatus =3D ncsr_swap(CSR_HSTATUS, gcntx->hstatus);
> > +       if (kvm_riscv_nacl_sync_sret_available()) {
> > +               nsh =3D nacl_shmem();
> >
> > -       nsync_csr(-1UL);
> > +               if (kvm_riscv_nacl_autoswap_csr_available()) {
> > +                       hcntx->hstatus =3D
> > +                               nacl_csr_read(nsh, CSR_HSTATUS);
> > +                       nacl_scratch_write_long(nsh,
> > +                                               SBI_NACL_SHMEM_AUTOSWAP=
_OFFSET +
> > +                                               SBI_NACL_SHMEM_AUTOSWAP=
_HSTATUS,
> > +                                               gcntx->hstatus);
> > +                       nacl_scratch_write_long(nsh,
> > +                                               SBI_NACL_SHMEM_AUTOSWAP=
_OFFSET,
> > +                                               SBI_NACL_SHMEM_AUTOSWAP=
_FLAG_HSTATUS);
> > +               } else if (kvm_riscv_nacl_sync_csr_available()) {
> > +                       hcntx->hstatus =3D nacl_csr_swap(nsh,
> > +                                                      CSR_HSTATUS, gcn=
tx->hstatus);
> > +               } else {
> > +                       hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx-=
>hstatus);
> > +               }
> >
> > -       __kvm_riscv_switch_to(&vcpu->arch);
> > +               nacl_scratch_write_longs(nsh,
> > +                                        SBI_NACL_SHMEM_SRET_OFFSET +
> > +                                        SBI_NACL_SHMEM_SRET_X(1),
> > +                                        &gcntx->ra,
> > +                                        SBI_NACL_SHMEM_SRET_X_LAST);
> > +
> > +               __kvm_riscv_nacl_switch_to(&vcpu->arch, SBI_EXT_NACL,
> > +                                          SBI_EXT_NACL_SYNC_SRET);
> > +
> > +               if (kvm_riscv_nacl_autoswap_csr_available()) {
> > +                       nacl_scratch_write_long(nsh,
> > +                                               SBI_NACL_SHMEM_AUTOSWAP=
_OFFSET,
> > +                                               0);
> > +                       gcntx->hstatus =3D nacl_scratch_read_long(nsh,
> > +                                                               SBI_NAC=
L_SHMEM_AUTOSWAP_OFFSET +
> > +                                                               SBI_NAC=
L_SHMEM_AUTOSWAP_HSTATUS);
> > +               } else {
> > +                       gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx-=
>hstatus);
> > +               }
> > +       } else {
> > +               hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx->hstatus=
);
> >
> > -       gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->hstatus);
> > +               __kvm_riscv_switch_to(&vcpu->arch);
> > +
> > +               gcntx->hstatus =3D csr_swap(CSR_HSTATUS, hcntx->hstatus=
);
> > +       }
> >
> >         vcpu->arch.last_exit_cpu =3D vcpu->cpu;
> >         guest_state_exit_irqoff();
> > diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.=
S
> > index 9f13e5ce6a18..47686bcb21e0 100644
> > --- a/arch/riscv/kvm/vcpu_switch.S
> > +++ b/arch/riscv/kvm/vcpu_switch.S
> > @@ -218,6 +218,35 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
> >         ret
> >  SYM_FUNC_END(__kvm_riscv_switch_to)
> >
> > +       /*
> > +        * Parameters:
> > +        * A0 <=3D Pointer to struct kvm_vcpu_arch
> > +        * A1 <=3D SBI extension ID
> > +        * A2 <=3D SBI function ID
> > +        */
> > +SYM_FUNC_START(__kvm_riscv_nacl_switch_to)
> > +       SAVE_HOST_GPRS
> > +
> > +       SAVE_HOST_AND_RESTORE_GUEST_CSRS .Lkvm_nacl_switch_return
> > +
> > +       /* Resume Guest using SBI nested acceleration */
> > +       add     a6, a2, zero
> > +       add     a7, a1, zero
> > +       ecall
> > +
> > +       /* Back to Host */
> > +       .align 2
> > +.Lkvm_nacl_switch_return:
> > +       SAVE_GUEST_GPRS
> > +
> > +       SAVE_GUEST_AND_RESTORE_HOST_CSRS
> > +
> > +       RESTORE_HOST_GPRS
> > +
> > +       /* Return to C code */
> > +       ret
> > +SYM_FUNC_END(__kvm_riscv_nacl_switch_to)
> > +
> >  SYM_CODE_START(__kvm_riscv_unpriv_trap)
> >         /*
> >          * We assume that faulting unpriv load/store instruction is
> > --
> > 2.34.1
> >
>
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
> --
> Regards,
> Atish

Regards,
Anup

