Return-Path: <kvm+bounces-29208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F999A55E7
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 20:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DAA0C1F22237
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 18:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A792196C67;
	Sun, 20 Oct 2024 18:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="JNIAr7z4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D8E194AD6
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729449832; cv=none; b=RfCAO3dln8iictXwyLXqdEiKiftqNneVSK9cFczr6/P+NFOV3xOJwXHDf7Cs3hkH137pc1dLaWAl/vPoIA+EmXZGy41M5ZmohQhZEnKC1Iwmx0dw3m9tmmVFYqXtBUMacUp68wc4komVp7IbF/OAggVrcIFIymAfVHhQXJhd0Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729449832; c=relaxed/simple;
	bh=nLa29eXTaajje/s8JU3IBUQa358qs78xjS/LvudFJ2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=czjWKHIGzyOi5Nr+18Ktsto2ykpUOIsKxqo9eh5SoOTeKCFdo7L/ad3O2gS0a9CijWsuFjcIAZzDXvWdNg/FTHxtV6LH5jjUQypP5XdbktlJqEifh7PGYqmezng5EodoEmmXPObDScoL0TYXJd0L3+lh10f5mPdVUbO/cSM8jh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=JNIAr7z4; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a3a7b80447so13455835ab.1
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 11:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1729449829; x=1730054629; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrN5xawJ9rB8nBHHs778T9TAgPhN5efHfvgOHKYDP9U=;
        b=JNIAr7z4Ot6TXSiaSiCOFjPhiWyjx363aDT8gGWDofvpKYFVQZ1LiOGfs7JeU/APK1
         3yKPjytUQND9urJ5I/UGzsTqQhIpDovlYVuQVH1FYewo6tuyYNlcfVvQbHen6n6LNJ9K
         slXddxWxK93/7BksR23Us3Cg/WttaS+u5y4e2bTYq6Uz1YxF+BxTdFRDy0KtqFaIyPtU
         B7ryqPeyzDSydSJB8fFRFVRHcUCLYhfAqt4OArMHTOAozsG9ox4hbFxJTo7bYsJWCYFv
         nEphdZhxSe++ItpmDHgF80eteXYE/LZJxKe5PqSWjjagbye03WikWBkm+uUAmXrmXBZm
         rugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729449829; x=1730054629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrN5xawJ9rB8nBHHs778T9TAgPhN5efHfvgOHKYDP9U=;
        b=F5lo2uxoVnBa65A5TeD/CcBT69uEvP+TWSu2zkAgxRvTLT3sA6ETzaOuVmIQROSb0c
         1xvFvJjI/Qioj3GOp1r+LdLDligeb7+Cl/Xf2r3pkQRc8LzNM+d4JfZKCiHSK+AoIPgb
         PDl9W4nyzQW7IHyiBGax72FgevFiuKaixmybxNSptOtxbYY4u89TCDK0tM9Ir+DGrPdN
         OYvM3RrRNz5HqZw2QGlwljl8FT72Ne1HzwVtdkbWANG2La1asE/iTniVhRW3AOMvbZ2J
         RE5uY1VhEv5q4LbHcqrpAHve36FUhWNbkORCQ4mh8jfOc0pjzvTTRqentGKP7SC6Ja0x
         8QXg==
X-Forwarded-Encrypted: i=1; AJvYcCUGc4ZCXOV3dkh3zDBJ+g+DnzRQXsH74YkuSGGB2H+MBXMmALvomEzvhWqwegQLguKuuSk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr/d87ujk8raGCc28I8RfG3790W+RnBslA6GATeZu6Yege1jpA
	sPQ4w6b0o4JZmoH8cRdb/GWb8GkdM1D5lLPLLq7EIvNjr1pexLg/XGkWRQr3Ui7Z4K/xJfK/nDs
	YL9Y6oiJsHHF7Y5sjszwNJN1Yoy1me/AscGdPVg==
X-Google-Smtp-Source: AGHT+IELY6NbDz6vnKvDZUaS61fYNL0DKtDfw32+VtHQB0w8t//DOR1MlmRmfjm2Riae5fvvxlo6i+eRSJXEPcUkS8U=
X-Received: by 2002:a05:6e02:160a:b0:3a3:6b20:5e33 with SMTP id
 e9e14a558f8ab-3a3f406ff4cmr77430225ab.12.1729449829447; Sun, 20 Oct 2024
 11:43:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240719160913.342027-1-apatel@ventanamicro.com>
 <20240719160913.342027-10-apatel@ventanamicro.com> <CAOnJCU+a+axzHNM=caCE7h6bvZ5Z7RTd6fxZmOgTyXGZ+p9d=g@mail.gmail.com>
In-Reply-To: <CAOnJCU+a+axzHNM=caCE7h6bvZ5Z7RTd6fxZmOgTyXGZ+p9d=g@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 21 Oct 2024 00:13:38 +0530
Message-ID: <CAAhSdy0gn+51v0yj4qw8AVcM1QR_kYnTs4iRSVG+avcSNrzhYw@mail.gmail.com>
Subject: Re: [PATCH 09/13] RISC-V: KVM: Use nacl_csr_xyz() for accessing
 H-extension CSRs
To: Atish Patra <atishp@atishpatra.org>
Cc: Anup Patel <apatel@ventanamicro.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 19, 2024 at 1:01=E2=80=AFAM Atish Patra <atishp@atishpatra.org>=
 wrote:
>
> On Fri, Jul 19, 2024 at 9:09=E2=80=AFAM Anup Patel <apatel@ventanamicro.c=
om> wrote:
> >
> > When running under some other hypervisor, prefer nacl_csr_xyz()
> > for accessing H-extension CSRs in the run-loop. This makes CSR
> > access faster whenever SBI nested acceleration is available.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/kvm/mmu.c        |   4 +-
> >  arch/riscv/kvm/vcpu.c       | 103 +++++++++++++++++++++++++-----------
> >  arch/riscv/kvm/vcpu_timer.c |  28 +++++-----
> >  3 files changed, 87 insertions(+), 48 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> > index b63650f9b966..45ace9138947 100644
> > --- a/arch/riscv/kvm/mmu.c
> > +++ b/arch/riscv/kvm/mmu.c
> > @@ -15,7 +15,7 @@
> >  #include <linux/vmalloc.h>
> >  #include <linux/kvm_host.h>
> >  #include <linux/sched/signal.h>
> > -#include <asm/csr.h>
> > +#include <asm/kvm_nacl.h>
> >  #include <asm/page.h>
> >  #include <asm/pgtable.h>
> >
> > @@ -732,7 +732,7 @@ void kvm_riscv_gstage_update_hgatp(struct kvm_vcpu =
*vcpu)
> >         hgatp |=3D (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGAT=
P_VMID;
> >         hgatp |=3D (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
> >
> > -       csr_write(CSR_HGATP, hgatp);
> > +       ncsr_write(CSR_HGATP, hgatp);
> >
> >         if (!kvm_riscv_gstage_vmid_bits())
> >                 kvm_riscv_local_hfence_gvma_all();
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 957e1a5e081b..00baaf1b0136 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -17,8 +17,8 @@
> >  #include <linux/sched/signal.h>
> >  #include <linux/fs.h>
> >  #include <linux/kvm_host.h>
> > -#include <asm/csr.h>
> >  #include <asm/cacheflush.h>
> > +#include <asm/kvm_nacl.h>
> >  #include <asm/kvm_vcpu_vector.h>
> >
> >  #define CREATE_TRACE_POINTS
> > @@ -361,10 +361,10 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vc=
pu *vcpu)
> >         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> >
> >         /* Read current HVIP and VSIE CSRs */
> > -       csr->vsie =3D csr_read(CSR_VSIE);
> > +       csr->vsie =3D ncsr_read(CSR_VSIE);
> >
> >         /* Sync-up HVIP.VSSIP bit changes does by Guest */
> > -       hvip =3D csr_read(CSR_HVIP);
> > +       hvip =3D ncsr_read(CSR_HVIP);
> >         if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
> >                 if (hvip & (1UL << IRQ_VS_SOFT)) {
> >                         if (!test_and_set_bit(IRQ_VS_SOFT,
> > @@ -561,26 +561,49 @@ static void kvm_riscv_vcpu_setup_config(struct kv=
m_vcpu *vcpu)
> >
> >  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > +       void *nsh;
> >         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> >         struct kvm_vcpu_config *cfg =3D &vcpu->arch.cfg;
> >
> > -       csr_write(CSR_VSSTATUS, csr->vsstatus);
> > -       csr_write(CSR_VSIE, csr->vsie);
> > -       csr_write(CSR_VSTVEC, csr->vstvec);
> > -       csr_write(CSR_VSSCRATCH, csr->vsscratch);
> > -       csr_write(CSR_VSEPC, csr->vsepc);
> > -       csr_write(CSR_VSCAUSE, csr->vscause);
> > -       csr_write(CSR_VSTVAL, csr->vstval);
> > -       csr_write(CSR_HEDELEG, cfg->hedeleg);
> > -       csr_write(CSR_HVIP, csr->hvip);
> > -       csr_write(CSR_VSATP, csr->vsatp);
> > -       csr_write(CSR_HENVCFG, cfg->henvcfg);
> > -       if (IS_ENABLED(CONFIG_32BIT))
> > -               csr_write(CSR_HENVCFGH, cfg->henvcfg >> 32);
> > -       if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
> > -               csr_write(CSR_HSTATEEN0, cfg->hstateen0);
> > +       if (kvm_riscv_nacl_sync_csr_available()) {
> > +               nsh =3D nacl_shmem();
> > +               nacl_csr_write(nsh, CSR_VSSTATUS, csr->vsstatus);
> > +               nacl_csr_write(nsh, CSR_VSIE, csr->vsie);
> > +               nacl_csr_write(nsh, CSR_VSTVEC, csr->vstvec);
> > +               nacl_csr_write(nsh, CSR_VSSCRATCH, csr->vsscratch);
> > +               nacl_csr_write(nsh, CSR_VSEPC, csr->vsepc);
> > +               nacl_csr_write(nsh, CSR_VSCAUSE, csr->vscause);
> > +               nacl_csr_write(nsh, CSR_VSTVAL, csr->vstval);
> > +               nacl_csr_write(nsh, CSR_HEDELEG, cfg->hedeleg);
> > +               nacl_csr_write(nsh, CSR_HVIP, csr->hvip);
> > +               nacl_csr_write(nsh, CSR_VSATP, csr->vsatp);
> > +               nacl_csr_write(nsh, CSR_HENVCFG, cfg->henvcfg);
> > +               if (IS_ENABLED(CONFIG_32BIT))
> > +                       nacl_csr_write(nsh, CSR_HENVCFGH, cfg->henvcfg =
>> 32);
> > +               if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEE=
N)) {
> > +                       nacl_csr_write(nsh, CSR_HSTATEEN0, cfg->hstatee=
n0);
> > +                       if (IS_ENABLED(CONFIG_32BIT))
> > +                               nacl_csr_write(nsh, CSR_HSTATEEN0H, cfg=
->hstateen0 >> 32);
> > +               }
> > +       } else {
> > +               csr_write(CSR_VSSTATUS, csr->vsstatus);
> > +               csr_write(CSR_VSIE, csr->vsie);
> > +               csr_write(CSR_VSTVEC, csr->vstvec);
> > +               csr_write(CSR_VSSCRATCH, csr->vsscratch);
> > +               csr_write(CSR_VSEPC, csr->vsepc);
> > +               csr_write(CSR_VSCAUSE, csr->vscause);
> > +               csr_write(CSR_VSTVAL, csr->vstval);
> > +               csr_write(CSR_HEDELEG, cfg->hedeleg);
> > +               csr_write(CSR_HVIP, csr->hvip);
> > +               csr_write(CSR_VSATP, csr->vsatp);
> > +               csr_write(CSR_HENVCFG, cfg->henvcfg);
> >                 if (IS_ENABLED(CONFIG_32BIT))
> > -                       csr_write(CSR_HSTATEEN0H, cfg->hstateen0 >> 32)=
;
> > +                       csr_write(CSR_HENVCFGH, cfg->henvcfg >> 32);
> > +               if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEE=
N)) {
> > +                       csr_write(CSR_HSTATEEN0, cfg->hstateen0);
> > +                       if (IS_ENABLED(CONFIG_32BIT))
> > +                               csr_write(CSR_HSTATEEN0H, cfg->hstateen=
0 >> 32);
> > +               }
> >         }
> >
> >         kvm_riscv_gstage_update_hgatp(vcpu);
> > @@ -603,6 +626,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int =
cpu)
> >
> >  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  {
> > +       void *nsh;
> >         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> >
> >         vcpu->cpu =3D -1;
> > @@ -618,15 +642,28 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >                                          vcpu->arch.isa);
> >         kvm_riscv_vcpu_host_vector_restore(&vcpu->arch.host_context);
> >
> > -       csr->vsstatus =3D csr_read(CSR_VSSTATUS);
> > -       csr->vsie =3D csr_read(CSR_VSIE);
> > -       csr->vstvec =3D csr_read(CSR_VSTVEC);
> > -       csr->vsscratch =3D csr_read(CSR_VSSCRATCH);
> > -       csr->vsepc =3D csr_read(CSR_VSEPC);
> > -       csr->vscause =3D csr_read(CSR_VSCAUSE);
> > -       csr->vstval =3D csr_read(CSR_VSTVAL);
> > -       csr->hvip =3D csr_read(CSR_HVIP);
> > -       csr->vsatp =3D csr_read(CSR_VSATP);
> > +       if (kvm_riscv_nacl_available()) {
>
> Should we leave a comment here why ncsr_read is not efficient here
> i.e. due to block access ?

Each nacl_read/write() has its own static-branch so we will have one
direct (patchable) jump emitted for one nacl_read/write(). This means
multiple nacl_read/write() results in many direct (patchable) jumps.

Let me add a comment-block in kvm_nacl.h in the next revision.

>
> > +               nsh =3D nacl_shmem();
> > +               csr->vsstatus =3D nacl_csr_read(nsh, CSR_VSSTATUS);
> > +               csr->vsie =3D nacl_csr_read(nsh, CSR_VSIE);
> > +               csr->vstvec =3D nacl_csr_read(nsh, CSR_VSTVEC);
> > +               csr->vsscratch =3D nacl_csr_read(nsh, CSR_VSSCRATCH);
> > +               csr->vsepc =3D nacl_csr_read(nsh, CSR_VSEPC);
> > +               csr->vscause =3D nacl_csr_read(nsh, CSR_VSCAUSE);
> > +               csr->vstval =3D nacl_csr_read(nsh, CSR_VSTVAL);
> > +               csr->hvip =3D nacl_csr_read(nsh, CSR_HVIP);
> > +               csr->vsatp =3D nacl_csr_read(nsh, CSR_VSATP);
> > +       } else {
> > +               csr->vsstatus =3D csr_read(CSR_VSSTATUS);
> > +               csr->vsie =3D csr_read(CSR_VSIE);
> > +               csr->vstvec =3D csr_read(CSR_VSTVEC);
> > +               csr->vsscratch =3D csr_read(CSR_VSSCRATCH);
> > +               csr->vsepc =3D csr_read(CSR_VSEPC);
> > +               csr->vscause =3D csr_read(CSR_VSCAUSE);
> > +               csr->vstval =3D csr_read(CSR_VSTVAL);
> > +               csr->hvip =3D csr_read(CSR_HVIP);
> > +               csr->vsatp =3D csr_read(CSR_VSATP);
> > +       }
> >  }
> >
> >  static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
> > @@ -681,7 +718,7 @@ static void kvm_riscv_update_hvip(struct kvm_vcpu *=
vcpu)
> >  {
> >         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> >
> > -       csr_write(CSR_HVIP, csr->hvip);
> > +       ncsr_write(CSR_HVIP, csr->hvip);
> >         kvm_riscv_vcpu_aia_update_hvip(vcpu);
> >  }
> >
> > @@ -728,7 +765,9 @@ static void noinstr kvm_riscv_vcpu_enter_exit(struc=
t kvm_vcpu *vcpu)
> >         kvm_riscv_vcpu_swap_in_guest_state(vcpu);
> >         guest_state_enter_irqoff();
> >
> > -       hcntx->hstatus =3D csr_swap(CSR_HSTATUS, gcntx->hstatus);
> > +       hcntx->hstatus =3D ncsr_swap(CSR_HSTATUS, gcntx->hstatus);
> > +
> > +       nsync_csr(-1UL);
> >
> >         __kvm_riscv_switch_to(&vcpu->arch);
> >
> > @@ -863,8 +902,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                 trap.sepc =3D vcpu->arch.guest_context.sepc;
> >                 trap.scause =3D csr_read(CSR_SCAUSE);
> >                 trap.stval =3D csr_read(CSR_STVAL);
> > -               trap.htval =3D csr_read(CSR_HTVAL);
> > -               trap.htinst =3D csr_read(CSR_HTINST);
> > +               trap.htval =3D ncsr_read(CSR_HTVAL);
> > +               trap.htinst =3D ncsr_read(CSR_HTINST);
> >
> >                 /* Syncup interrupts state with HW */
> >                 kvm_riscv_vcpu_sync_interrupts(vcpu);
> > diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> > index 75486b25ac45..96e7a4e463f7 100644
> > --- a/arch/riscv/kvm/vcpu_timer.c
> > +++ b/arch/riscv/kvm/vcpu_timer.c
> > @@ -11,8 +11,8 @@
> >  #include <linux/kvm_host.h>
> >  #include <linux/uaccess.h>
> >  #include <clocksource/timer-riscv.h>
> > -#include <asm/csr.h>
> >  #include <asm/delay.h>
> > +#include <asm/kvm_nacl.h>
> >  #include <asm/kvm_vcpu_timer.h>
> >
> >  static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
> > @@ -72,12 +72,12 @@ static int kvm_riscv_vcpu_timer_cancel(struct kvm_v=
cpu_timer *t)
> >  static int kvm_riscv_vcpu_update_vstimecmp(struct kvm_vcpu *vcpu, u64 =
ncycles)
> >  {
> >  #if defined(CONFIG_32BIT)
> > -               csr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> > -               csr_write(CSR_VSTIMECMPH, ncycles >> 32);
> > +       ncsr_write(CSR_VSTIMECMP, ncycles & 0xFFFFFFFF);
> > +       ncsr_write(CSR_VSTIMECMPH, ncycles >> 32);
> >  #else
> > -               csr_write(CSR_VSTIMECMP, ncycles);
> > +       ncsr_write(CSR_VSTIMECMP, ncycles);
> >  #endif
> > -               return 0;
> > +       return 0;
> >  }
> >
> >  static int kvm_riscv_vcpu_update_hrtimer(struct kvm_vcpu *vcpu, u64 nc=
ycles)
> > @@ -289,10 +289,10 @@ static void kvm_riscv_vcpu_update_timedelta(struc=
t kvm_vcpu *vcpu)
> >         struct kvm_guest_timer *gt =3D &vcpu->kvm->arch.timer;
> >
> >  #if defined(CONFIG_32BIT)
> > -       csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
> > -       csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
> > +       ncsr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
> > +       ncsr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
> >  #else
> > -       csr_write(CSR_HTIMEDELTA, gt->time_delta);
> > +       ncsr_write(CSR_HTIMEDELTA, gt->time_delta);
> >  #endif
> >  }
> >
> > @@ -306,10 +306,10 @@ void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu=
 *vcpu)
> >                 return;
> >
> >  #if defined(CONFIG_32BIT)
> > -       csr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
> > -       csr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
> > +       ncsr_write(CSR_VSTIMECMP, (u32)t->next_cycles);
> > +       ncsr_write(CSR_VSTIMECMPH, (u32)(t->next_cycles >> 32));
> >  #else
> > -       csr_write(CSR_VSTIMECMP, t->next_cycles);
> > +       ncsr_write(CSR_VSTIMECMP, t->next_cycles);
> >  #endif
> >
> >         /* timer should be enabled for the remaining operations */
> > @@ -327,10 +327,10 @@ void kvm_riscv_vcpu_timer_sync(struct kvm_vcpu *v=
cpu)
> >                 return;
> >
> >  #if defined(CONFIG_32BIT)
> > -       t->next_cycles =3D csr_read(CSR_VSTIMECMP);
> > -       t->next_cycles |=3D (u64)csr_read(CSR_VSTIMECMPH) << 32;
> > +       t->next_cycles =3D ncsr_read(CSR_VSTIMECMP);
> > +       t->next_cycles |=3D (u64)ncsr_read(CSR_VSTIMECMPH) << 32;
> >  #else
> > -       t->next_cycles =3D csr_read(CSR_VSTIMECMP);
> > +       t->next_cycles =3D ncsr_read(CSR_VSTIMECMP);
> >  #endif
> >  }
> >
> > --
> > 2.34.1
> >
>
> Otherwise, LGTM.
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>
>
> --
> Regards,
> Atish

Regards,
Anup

