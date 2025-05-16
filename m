Return-Path: <kvm+bounces-46792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E93B1AB9BF2
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7754C4A5CC5
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 12:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A9D23C4F8;
	Fri, 16 May 2025 12:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="lwHqUuEW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1BAA32
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747398318; cv=none; b=FJw+4cYQpj00QcGSkXI11rVoz3L39dDGvSSccHTgLt6xxq6RIwhKMB9yNhHAcAIUpn7yQkIEF2/fEzYpzv1NsdGQImRnHd/8ylpVC0F/Lz7L2+XRQU13N9ItcCGeWH5ldVHOYOC8tbOXJNAu7Frpr8BNbdlPEAC7rHbHln+JFJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747398318; c=relaxed/simple;
	bh=IfwHj4hXkENcr27VCiQj43X0I1+ByxSbJW7c3tceRls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Slf1WfeI7yumV6AwgOeolUb8rifuu54x1v7o4KXT/1Zbn5z3OUCpa3xgalxmhsyQ4QKECM4eT97AT6U5m48JQHA/tWjkaUbj4V6nxuihOm/USdH3rsvLnSnMQkmYvRof278LkOuC+IhlAzvpoAadsGQw1O+DXUZdZuT40EQrXbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=lwHqUuEW; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85db3475637so105666639f.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 05:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747398316; x=1748003116; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtzmSwvWraldTd8lkysDlNoQ1DXQCdHXLloM1BvhiIM=;
        b=lwHqUuEWmu8+2TWR90qRcRsZQA8SQnqMsDsflSzOUFeempZVG2sIFYA7xT4OfmXZ8G
         3kXpwsJkHdd3hIjqIutnfgn6YQJ9NaZrtiTkInAKpcyHJtOSFEIEdkD9Q3ZrtpuBLEFw
         l2qSqID83xXJvTpbRkjjp9spni5qN/07c9a7lzgEZvsm7kofoUoMnuSs+xmJaBs0YygO
         r4K4a3TUKT1Sm4KFdCChINoHsb3j6zs3ONyfYl/LALOdXJl9mHYEuIgpaYw+K2BcdW7t
         eY7EbEsR1VZxOuD1i/FRYKhnpvWcMMmIcqbxMCnFFVmQlJr4mL4tdZwc9SaLfkDqCKWP
         2Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747398316; x=1748003116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtzmSwvWraldTd8lkysDlNoQ1DXQCdHXLloM1BvhiIM=;
        b=UuEvyTKSFQZ8JXhKt7KR28dEYHnwTddLIEIcP/0IeyRHhtrtEzG+2NS3fUJE75Opf+
         ivaDCqs6tck8gm0DDiSL1WnAmbGiyUFlQORZcsF2bzrQ+8lKabVrh9OLEmcSGk8d/4LM
         nZOYSR0iJUkeMmMM6k/U1tb71gioxZeGb7IltnoqGwj1mNx1iDoa7+FJXxdktMDL74DN
         dbQeTqSqMzd0Ri8rsLxPFr7QeF+R3ueV24avIVFw61YAO4nHcHi2fx+KWmK71zuhlAMn
         3Jc+AJVmfrn3DzggJoVI3tRh8rHCUaIZFTs0oZtK7Y+VLgNCDj3O3oaFOUZsfZuPcZ30
         w7CA==
X-Forwarded-Encrypted: i=1; AJvYcCVDPgrMxLS9aPEbZMwZ9BtvOnnv5tmd62ma3MpMVkfFtslLXNed6ArqZCatLl+1SHa1m9M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfxWr8sszSPqpBv38awW0BPXfDHdiBJHXrffD7xwlqk9P/XJdD
	qvsjwXH/pebtRNCiKeS5J2TufirWfa33hx5z1YqQLbQwZ/eVoa794R/oQwNOS1SDWyZoglPmAkV
	CavNBF+YTTJfRAzjnnjhZ5SDVx4FcSIqPCA5Od2LOzL1xm3inW3egyfk=
X-Gm-Gg: ASbGnctjI3rne5UskKgzz0scsbwET4xmGZ3KZ/aQavUZoVOvGJKtP0c2718RG8U1FeF
	fWW1G91c7bKZoO8glT5q5knLne31bTPqSQf/iMADLstnS/beinO2T5wxDiGexkeF4yU+wnbzrYP
	i4gzRapGua4qjp97dSKoSpLBvAr6+Y0GFqTQ==
X-Google-Smtp-Source: AGHT+IHPWwPiAwYxbRgOwbLJ8Wt1LFZ7gCqAZ6zYj80ECcVPBuog5ktr4uSIzb0vvBVZ5Sec9lqalAGFy3YMrIrrsvw=
X-Received: by 2002:a05:6602:3a81:b0:867:973:f2cb with SMTP id
 ca18e2360f4ac-86a23840913mr446523339f.7.1747398316181; Fri, 16 May 2025
 05:25:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515143723.2450630-4-rkrcmar@ventanamicro.com> <20250515143723.2450630-5-rkrcmar@ventanamicro.com>
In-Reply-To: <20250515143723.2450630-5-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 16 May 2025 17:55:05 +0530
X-Gm-Features: AX0GCFvgO4Z_DUSR0CTeFhf6b_B2_U8BewNneA58JqHvGUyRV6T-_YfvZD5T4C4
Message-ID: <CAAhSdy1Z43xRC7tGS21-5rcX7uMeuWCHhABSuqNzELbp26aj0Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2025 at 8:22=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcma=
r@ventanamicro.com> wrote:
>
> Add a toggleable VM capability to reset the VCPU from userspace by
> setting MP_STATE_INIT_RECEIVED through IOCTL.
>
> Reset through a mp_state to avoid adding a new IOCTL.
> Do not reset on a transition from STOPPED to RUNNABLE, because it's
> better to avoid side effects that would complicate userspace adoption.
> The MP_STATE_INIT_RECEIVED is not a permanent mp_state -- IOCTL resets
> the VCPU while preserving the original mp_state -- because we wouldn't
> gain much from having a new state it in the rest of KVM, but it's a very
> non-standard use of the IOCTL.
>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
> If we want a permanent mp_state, I think that MP_STATE_UNINITIALIZED
> would be reasonable.  KVM could reset on transition to any other state.

Yes, MP_STATE_UNINITIALIZED looks better. I also suggest
that VCPU should be reset when set_mpstate() is called with
MP_STATE_UNINITIALIZED and the current state is
MP_STATE_STOPPED.

Regards,
Anup

>
> v3: do not allow allow userspace to set the HSM reset state [Anup]
> v2: new
> ---
>  Documentation/virt/kvm/api.rst        | 11 +++++++++++
>  arch/riscv/include/asm/kvm_host.h     |  3 +++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
>  arch/riscv/kvm/vcpu.c                 | 27 ++++++++++++++-------------
>  arch/riscv/kvm/vcpu_sbi.c             | 17 +++++++++++++++++
>  arch/riscv/kvm/vm.c                   | 13 +++++++++++++
>  include/uapi/linux/kvm.h              |  1 +
>  7 files changed, 60 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 47c7c3f92314..e107694fb41f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8496,6 +8496,17 @@ aforementioned registers before the first KVM_RUN.=
 These registers are VM
>  scoped, meaning that the same set of values are presented on all vCPUs i=
n a
>  given VM.
>
> +7.43 KVM_CAP_RISCV_MP_STATE_RESET
> +---------------------------------
> +
> +:Architectures: riscv
> +:Type: VM
> +:Parameters: None
> +:Returns: 0 on success, -EINVAL if arg[0] is not zero
> +
> +When this capability is enabled, KVM resets the VCPU when setting
> +MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserve=
d.
> +
>  8. Other capabilities.
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/k=
vm_host.h
> index f673ebfdadf3..85cfebc32e4c 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -119,6 +119,9 @@ struct kvm_arch {
>
>         /* AIA Guest/VM context */
>         struct kvm_aia aia;
> +
> +       /* KVM_CAP_RISCV_MP_STATE_RESET */
> +       bool mp_state_reset;
>  };
>
>  struct kvm_cpu_trap {
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/a=
sm/kvm_vcpu_sbi.h
> index da28235939d1..439ab2b3534f 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -57,6 +57,7 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *v=
cpu,
>                                      u32 type, u64 flags);
>  void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
>                                       unsigned long pc, unsigned long a1)=
;
> +void kvm_riscv_vcpu_sbi_load_reset_state(struct kvm_vcpu *vcpu);
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run=
);
>  int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
>                                    const struct kvm_one_reg *reg);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index a78f9ec2fa0e..521cd41bfffa 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -51,11 +51,11 @@ const struct kvm_stats_header kvm_vcpu_stats_header =
=3D {
>                        sizeof(kvm_vcpu_stats_desc),
>  };
>
> -static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
> +static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu,
> +                                        bool kvm_sbi_reset)
>  {
>         struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
>         struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
> -       struct kvm_vcpu_reset_state *reset_state =3D &vcpu->arch.reset_st=
ate;
>         void *vector_datap =3D cntx->vector.datap;
>
>         memset(cntx, 0, sizeof(*cntx));
> @@ -65,13 +65,8 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vc=
pu *vcpu)
>         /* Restore datap as it's not a part of the guest context. */
>         cntx->vector.datap =3D vector_datap;
>
> -       /* Load SBI reset values */
> -       cntx->a0 =3D vcpu->vcpu_id;
> -
> -       spin_lock(&reset_state->lock);
> -       cntx->sepc =3D reset_state->pc;
> -       cntx->a1 =3D reset_state->a1;
> -       spin_unlock(&reset_state->lock);
> +       if (kvm_sbi_reset)
> +               kvm_riscv_vcpu_sbi_load_reset_state(vcpu);
>
>         /* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
>         cntx->sstatus =3D SR_SPP | SR_SPIE;
> @@ -84,7 +79,7 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcp=
u *vcpu)
>         csr->scounteren =3D 0x7;
>  }
>
> -static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> +static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu, bool kvm_sbi_res=
et)
>  {
>         bool loaded;
>
> @@ -100,7 +95,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu=
)
>
>         vcpu->arch.last_exit_cpu =3D -1;
>
> -       kvm_riscv_vcpu_context_reset(vcpu);
> +       kvm_riscv_vcpu_context_reset(vcpu, kvm_sbi_reset);
>
>         kvm_riscv_vcpu_fp_reset(vcpu);
>
> @@ -177,7 +172,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         kvm_riscv_vcpu_sbi_init(vcpu);
>
>         /* Reset VCPU */
> -       kvm_riscv_reset_vcpu(vcpu);
> +       kvm_riscv_reset_vcpu(vcpu, false);
>
>         return 0;
>  }
> @@ -526,6 +521,12 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
*vcpu,
>         case KVM_MP_STATE_STOPPED:
>                 __kvm_riscv_vcpu_power_off(vcpu);
>                 break;
> +       case KVM_MP_STATE_INIT_RECEIVED:
> +               if (vcpu->kvm->arch.mp_state_reset)
> +                       kvm_riscv_reset_vcpu(vcpu, false);
> +               else
> +                       ret =3D -EINVAL;
> +               break;
>         default:
>                 ret =3D -EINVAL;
>         }
> @@ -714,7 +715,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_=
vcpu *vcpu)
>                 }
>
>                 if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
> -                       kvm_riscv_reset_vcpu(vcpu);
> +                       kvm_riscv_reset_vcpu(vcpu, true);
>
>                 if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
>                         kvm_riscv_gstage_update_hgatp(vcpu);
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index 0afef0bb261d..31fd3cc98d66 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -167,6 +167,23 @@ void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcp=
u *vcpu,
>         kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
>  }
>
> +void kvm_riscv_vcpu_sbi_load_reset_state(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
> +       struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
> +       struct kvm_vcpu_reset_state *reset_state =3D &vcpu->arch.reset_st=
ate;
> +
> +       cntx->a0 =3D vcpu->vcpu_id;
> +
> +       spin_lock(&vcpu->arch.reset_state.lock);
> +       cntx->sepc =3D reset_state->pc;
> +       cntx->a1 =3D reset_state->a1;
> +       spin_unlock(&vcpu->arch.reset_state.lock);
> +
> +       cntx->sstatus &=3D ~SR_SIE;
> +       csr->vsatp =3D 0;
> +}
> +
>  int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run=
)
>  {
>         struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
> index 7396b8654f45..b27ec8f96697 100644
> --- a/arch/riscv/kvm/vm.c
> +++ b/arch/riscv/kvm/vm.c
> @@ -209,6 +209,19 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lo=
ng ext)
>         return r;
>  }
>
> +int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
> +{
> +       switch (cap->cap) {
> +       case KVM_CAP_RISCV_MP_STATE_RESET:
> +               if (cap->flags)
> +                       return -EINVAL;
> +               kvm->arch.mp_state_reset =3D true;
> +               return 0;
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
>  int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned lo=
ng arg)
>  {
>         return -EINVAL;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..454b7d4a0448 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -930,6 +930,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>  #define KVM_CAP_X86_GUEST_MODE 238
>  #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> +#define KVM_CAP_RISCV_MP_STATE_RESET 240
>
>  struct kvm_irq_routing_irqchip {
>         __u32 irqchip;
> --
> 2.49.0
>

