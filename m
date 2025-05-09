Return-Path: <kvm+bounces-46020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3958EAB0B0C
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:55:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9969716F932
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 06:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC6926FA4E;
	Fri,  9 May 2025 06:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="yW4PjU61"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD526B2A5
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 06:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746773738; cv=none; b=MNodL/aQcQh7F2QoEaaeD3Xuf/3eeYSrUQk9/OUHMHXOmG/lbMyz7mVipQIIS+9pVG7/LIdV+uN4PIO1d2veK7tdsaC4xWLI/LQ/ZQKhEAFk0PguhQL1plxOXfhG/+pu0wwKB1rXT6wJBe6Eq+Mqn3+YtQwv4hnHdhlbjxHQZkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746773738; c=relaxed/simple;
	bh=r1uT0vfhZz8rqL8YHKHCeHJxXYq/kQRaX/DEWmxbk9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h4KnLCs9hQ7r8L7hYJHLfhUknh2/agw8dIreOOHbDi1vLLd3lzO0JHS5TCj4epjFTfSe7kjNVPw1zDCPt6ipyXnRNYDveR2keJNvdUggSZJBtEXOFf9eSaQc6/YN7B6C+uyEQl+rfSsXCt7hFhJtAScy6Ab+q+3JHyDJF77OmQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=yW4PjU61; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3da73e9cf17so16510955ab.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 23:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1746773736; x=1747378536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2K+K4ysTxIY1s7VZfE1zqqa1c22Z4tedDy7K3x67jg=;
        b=yW4PjU61CjfCVePMxxk6lNYcSpq5KJD/ropV4VFtLKEYIKz9dMgAkiKFxrwi1lpye4
         cCeePV8k9199wIQyhWPAgHM2OFQDX4Yonl52lses/i/oZw0okzTmJuaXDSe1iYLiIqmS
         DjNgu7lyp6KnPj/uBa1xxFmTqQ98JXshEGJFoHGsgi0Ckk48MDHu/YPoi/J4Jyu39y3b
         0EZDD53i7V9mW/kjhg8J/UBZr4WYm2NAL+irsuHbqW1OtSMH1jeOEb4nyOcDpJoNMJPy
         I+RgwIxlCNnCqDLx16MyzTY68C+ktTiWO1C5LaaCcGQ+P3u6BroC/ZG++kfy7c9/jcrI
         04aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746773736; x=1747378536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2K+K4ysTxIY1s7VZfE1zqqa1c22Z4tedDy7K3x67jg=;
        b=ZJCxBQ2+37Z01XfFW76XZU8X8foBLsBPK9UGkbSMFZxwzL99y5S1ySPhVTnyGYaEOw
         zYgKRzMqMIwNyyGkKKV6IZt5aSARn66CwxBVqwLjtuMIIM7iYztF7CfFD0UQ8gh8AQly
         ufxyKBtvhJvxx6UWhJImUu67h9KwGvHvTu0g7PXC/QSdH+RxJ+PKh12nd/KyWwudQlte
         P5QwX8GoN2HRyu+NKInvRqcQLDpe1mpoT2RXb9BYsJIfcOdOWWOQ1bYaRsks+SQvkDjW
         y2I4nDUzDo8nY2QvSggxm1UsqkvlZOp+MXHrxMXYU5W1g0cnH+V+x+s1xlqlK6FVwhdw
         gjwA==
X-Forwarded-Encrypted: i=1; AJvYcCXG9UYvkE3mXaEPAjaVdk/9ZZGPtIEaaG5iS7BHGhhzw8NkEMcZy/+OlGIyRq5a0JxzKio=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+IOb/TFoKd6PQXWK/Cbw9BT0VjR7F/Q+09Gy1J0rXqnkNHhTp
	TNHxBQxLwnmyQHecmASy4Gx1f+wwPFB/ZqfzLaQ5jCDjSC0aBx1vzy43w1j042lKUJdEz2ZdF7l
	Hz8rdvQrH3yEwNZ7kJB492Ntin3+SmvKOERiAOA==
X-Gm-Gg: ASbGnctGy+FJ1bX7uLdcF0ldRPDLAgR7YaYKS7Fj0S/kOXzQSQ0oxI4ysUq7ohRzyIo
	1Ql8Jb5yLWrXHsWB9I6ESz4azoHR2qX7R2pn478pBZ6rFOaqrhK8eBF2h7tEhyDsHBfGyOECnJK
	Y7QqozcayHqGH+1xEHfbkWFeQ=
X-Google-Smtp-Source: AGHT+IEol6fVzT/BccjuK+Wns1TTgI68Ca/f4TFG7teRR8qU1dGibcK89s05lwF8cnGEl4nX7LmmJWaJWwBbVgb2uGM=
X-Received: by 2002:a05:6e02:1fc6:b0:3d8:2085:a188 with SMTP id
 e9e14a558f8ab-3da7e1e2709mr30487455ab.1.1746773735567; Thu, 08 May 2025
 23:55:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250508142842.1496099-2-rkrcmar@ventanamicro.com> <20250508142842.1496099-4-rkrcmar@ventanamicro.com>
In-Reply-To: <20250508142842.1496099-4-rkrcmar@ventanamicro.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 9 May 2025 12:25:24 +0530
X-Gm-Features: AX0GCFvKJXUjERJnAnK8ToYyHDXiZoMYzMDLIBtjedvirOGSUjHPE3x6guRm-is
Message-ID: <CAAhSdy2nOBndtJ46yHbdjc2f0cNoPV3kjXth-q57cXt8jZA6bQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] RISC-V: KVM: add KVM_CAP_RISCV_MP_STATE_RESET
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 8:01=E2=80=AFPM Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar=
@ventanamicro.com> wrote:
>
> Add a toggleable VM capability to modify several reset related code
> paths.  The goals are to
>  1) Allow userspace to reset any VCPU.
>  2) Allow userspace to provide the initial VCPU state.
>
> (Right now, the boot VCPU isn't reset by KVM and KVM sets the state for
>  VCPUs brought up by sbi_hart_start while userspace for all others.)
>
> The goals are achieved with the following changes:
>  * Reset the VCPU when setting MP_STATE_INIT_RECEIVED through IOCTL.

Rather than using separate MP_STATE_INIT_RECEIVED ioctl(), we can
define a capability which when set, the set_mpstate ioctl() will reset the
VCPU upon changing VCPU state from RUNNABLE to STOPPED state.

>  * Preserve the userspace initialized VCPU state on sbi_hart_start.
>  * Return to userspace on sbi_hart_stop.

There is no userspace involvement required when a Guest VCPU
stops itself using SBI HSM stop() call so STRONG NO to this change.

>  * Don't make VCPU reset request on sbi_system_suspend.

The entry state of initiating VCPU is already available on SBI system
suspend call. The initiating VCPU must be resetted and entry state of
initiating VCPU must be setup.

>
> The patch is reusing MP_STATE_INIT_RECEIVED, because we didn't want to
> add a new IOCTL, sorry. :)
>
> Signed-off-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@ventanamicro.com>
> ---
> If you search for cap 7.42 in api.rst, you'll see that it has a wrong
> number, which is why we're 7.43, in case someone bothers to fix ARM.
>
> I was also strongly considering creating all VCPUs in RUNNABLE state --
> do you know of any similar quirks that aren't important, but could be
> fixed with the new userspace toggle?

Upon creating a VM, only one VCPU should be RUNNABLE and all
other VCPUs must remain in OFF state. This is intentional because
imagine a large number of VCPUs entering Guest OS at the same
time. We have spent a lot of effort in the past to get away from this
situation even in the host boot flow. We can't expect user space to
correctly set the initial MP_STATE of all VCPUs. We can certainly
think of some mechanism using which user space can specify
which VCPU should be runnable upon VM creation.

The current approach is to do HSM state management in kernel
space itself and not rely on user space. Allowing userspace to
resetting any VCPU is fine but this should not affect the flow for
SBI HSM, SBI System Reset, and SBI System Suspend.

Regards,
Anup

> ---
>  Documentation/virt/kvm/api.rst        | 15 +++++++++++
>  arch/riscv/include/asm/kvm_host.h     |  3 +++
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
>  arch/riscv/kvm/vcpu.c                 | 36 +++++++++++++++++----------
>  arch/riscv/kvm/vcpu_sbi.c             | 17 +++++++++++++
>  arch/riscv/kvm/vcpu_sbi_hsm.c         |  7 +++++-
>  arch/riscv/kvm/vcpu_sbi_system.c      |  3 ++-
>  arch/riscv/kvm/vm.c                   | 13 ++++++++++
>  include/uapi/linux/kvm.h              |  1 +
>  9 files changed, 81 insertions(+), 15 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 47c7c3f92314..63e6d23d34f0 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8496,6 +8496,21 @@ aforementioned registers before the first KVM_RUN.=
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
> +When this capability is enabled, KVM:
> +* Resets the VCPU when setting MP_STATE_INIT_RECEIVED through IOCTL.
> +  The original MP_STATE is preserved.
> +* Preserves the userspace initialized VCPU state on sbi_hart_start.
> +* Returns to userspace on sbi_hart_stop.
> +* Doesn't make VCPU reset request on sbi_system_suspend.
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
> index a78f9ec2fa0e..961b22c05981 100644
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
> @@ -84,10 +79,19 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_v=
cpu *vcpu)
>         csr->scounteren =3D 0x7;
>  }
>
> -static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
> +static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu, bool kvm_sbi_res=
et)
>  {
>         bool loaded;
>
> +       /*
> +        * The userspace should have triggered a full reset earlier and c=
ould
> +        * have set initial state that needs to be preserved.
> +        */
> +       if (kvm_sbi_reset && vcpu->kvm->arch.mp_state_reset) {
> +               kvm_riscv_vcpu_sbi_load_reset_state(vcpu);
> +               return;
> +       }
> +
>         /**
>          * The preemption should be disabled here because it races with
>          * kvm_sched_out/kvm_sched_in(called from preempt notifiers) whic=
h
> @@ -100,7 +104,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcp=
u)
>
>         vcpu->arch.last_exit_cpu =3D -1;
>
> -       kvm_riscv_vcpu_context_reset(vcpu);
> +       kvm_riscv_vcpu_context_reset(vcpu, kvm_sbi_reset);
>
>         kvm_riscv_vcpu_fp_reset(vcpu);
>
> @@ -177,7 +181,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         kvm_riscv_vcpu_sbi_init(vcpu);
>
>         /* Reset VCPU */
> -       kvm_riscv_reset_vcpu(vcpu);
> +       kvm_riscv_reset_vcpu(vcpu, false);
>
>         return 0;
>  }
> @@ -526,6 +530,12 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu =
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
> @@ -714,7 +724,7 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_=
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
> diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.=
c
> index f26207f84bab..d1bf1348eefd 100644
> --- a/arch/riscv/kvm/vcpu_sbi_hsm.c
> +++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
> @@ -89,7 +89,12 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>                 ret =3D kvm_sbi_hsm_vcpu_start(vcpu);
>                 break;
>         case SBI_EXT_HSM_HART_STOP:
> -               ret =3D kvm_sbi_hsm_vcpu_stop(vcpu);
> +               if (vcpu->kvm->arch.mp_state_reset) {
> +                       kvm_riscv_vcpu_sbi_forward(vcpu, run);
> +                       retdata->uexit =3D true;
> +               } else {
> +                       ret =3D kvm_sbi_hsm_vcpu_stop(vcpu);
> +               }
>                 break;
>         case SBI_EXT_HSM_HART_STATUS:
>                 ret =3D kvm_sbi_hsm_vcpu_get_status(vcpu);
> diff --git a/arch/riscv/kvm/vcpu_sbi_system.c b/arch/riscv/kvm/vcpu_sbi_s=
ystem.c
> index 359be90b0fc5..0482968705f8 100644
> --- a/arch/riscv/kvm/vcpu_sbi_system.c
> +++ b/arch/riscv/kvm/vcpu_sbi_system.c
> @@ -44,7 +44,8 @@ static int kvm_sbi_ext_susp_handler(struct kvm_vcpu *vc=
pu, struct kvm_run *run,
>                         }
>                 }
>
> -               kvm_riscv_vcpu_sbi_request_reset(vcpu, cp->a1, cp->a2);
> +               if (!vcpu->kvm->arch.mp_state_reset)
> +                       kvm_riscv_vcpu_sbi_request_reset(vcpu, cp->a1, cp=
->a2);
>
>                 /* userspace provides the suspend implementation */
>                 kvm_riscv_vcpu_sbi_forward(vcpu, run);
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

