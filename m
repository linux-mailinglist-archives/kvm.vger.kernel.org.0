Return-Path: <kvm+bounces-19701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C451590902D
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 18:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50D5D1F23C82
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9E7180A62;
	Fri, 14 Jun 2024 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTeODXyM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EF7170847
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382363; cv=none; b=R/wFnXoUc1lSZKOvWoSDRzHDnl7FCnOrvNY2e5KzRYXCVOJQhWmCXHKfI9FoBVF5xJ3w5zS9MZ2NaoK9mYsYIOeiuAwC4EYBkMwDytOVjagNo+v6Kz6l+gDOtdAqXMQwoTzbvFA5WdLp2P/EI8/yMfJXXK3wJbOo8RWeC1JWxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382363; c=relaxed/simple;
	bh=dHTXaFjy7EDQ61BY50H4hM8tRElttWjEqiWE2DiL3eg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkiQMYOukaSZ63agM15lCPEwupMgIDZ0YvoQSQpndofKEPFJAI6wmYipgs+8koF/fE1V0nbcGCl96STtB1Q0lWif07LMvCT1spAsRiPPs4OVvaksXYtUfdtr6wCzf2t2Mqrs+rJTw3O/zKiM5O5h41D5/+6lhNkjyIvzwlA1X3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTeODXyM; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52b7e693b8aso3098089e87.1
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718382360; x=1718987160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TmirVK2iDN0C4A6D1u8AF5H9b9aKhqRi6Fpl4Wdggw=;
        b=DTeODXyMDzFf6UFX3DlGgZZjnzfgH9Nss9tEKt0ZNgVscRKUcy9AS5qgPoFk23qcc5
         rJ8xbnga19VeqAJt1sesjFxHZ7D1KL7ykYzpdqWqZS3RQkootuIP0zOsCVborTXxTzD3
         +POgpgeFoe2YqLC/oBqb6tbqaES2DmP/9HGDy20JXtT4CYQ6FXIJMkj69r4VX8V8YwQl
         0odDBDhonyRMigZnA1I4l1q3LSnsPG5Zd8Xg/aXNgfqAQX8NIEUWlWXC3EdmyESzZQ8R
         eDfL+pyOvBpfnNPBq6N+YDqVWsokKgsdWT3X0cWyX9GNX+BsW08BbahdYjaOZdxFy5Vn
         ejPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382360; x=1718987160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TmirVK2iDN0C4A6D1u8AF5H9b9aKhqRi6Fpl4Wdggw=;
        b=Ap9eD7t/fQ+xF2D+JByp4se49PHky3SSyt+zeEkDfzZvRyzBOm9hV2g9qPyRJA+fM7
         7fOAE5j1QaK1JOemakyGlC7XA6J/ayNx/HF1wtNpVaNbcsiivHAtW26vfCfVWs9CFSUI
         Pjv+gkrPVQRrPKEDlipFg+suPSvoN4CYhkzyTSo3btNIjtihWsqCLohObLAVOZOaD/AS
         nTa+ZO43OijA7YLvfDR47qrsUdwfLmCm5r7Zwo0tS59rFEXalbB3QDnV6RN8y50cgsFh
         2RI1hVCMRu9T2lerRUp2duVSeK0Eq86qXJAkY1xUdXETC2y0ssjunAR/hgbroGzKsTwO
         W67w==
X-Gm-Message-State: AOJu0YyDUVsLVg09PajpH+/oU/Tj1PlTsZPt4WFaGEbjHadJNyLsBzpB
	dzFGwVL7G7DxyM7ovuePcaFdH4khJgoISlvJC1mtPs5VsXNRqarna8K/Y3WaVgQ+OCX2RHaqfLi
	q3sbDz2vB8Tq11NJ6BWzNt7VYT0TrNizOzwyn
X-Google-Smtp-Source: AGHT+IHxH/3kEEuqimpaagS+T9Lx55dKHwfXgH3HElXACO+TRdHSIrfg7QeT+U0kH8uptq7Kw3h9vGx5ltCZneUnen8=
X-Received: by 2002:a19:9107:0:b0:52b:e2ad:7cde with SMTP id
 2adb3069b0e04-52ca6cc6e85mr918471e87.23.1718382359418; Fri, 14 Jun 2024
 09:25:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240523174056.1565133-1-coltonlewis@google.com>
In-Reply-To: <20240523174056.1565133-1-coltonlewis@google.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 14 Jun 2024 09:25:47 -0700
Message-ID: <CAAdAUtgJZxaNU0edSg1Q5hoCw+8xNqiQw+P_kPAQG-9WOUKozA@mail.gmail.com>
Subject: Re: [PATCH v6] KVM: arm64: Add early_param to control WFx trapping
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Colton,

On Thu, May 23, 2024 at 10:41=E2=80=AFAM Colton Lewis <coltonlewis@google.c=
om> wrote:
>
> Add an early_params to control WFI and WFE trapping. This is to
> control the degree guests can wait for interrupts on their own without
> being trapped by KVM. Options for each param are trap and notrap. trap
> enables the trap. notrap disables the trap. Note that when enabled,
> traps are allowed but not guaranteed by the CPU architecture. Absent
> an explicitly set policy, default to current behavior: disabling the
> trap if only a single task is running and enabling otherwise.
>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> v6:
>  * Rebase to v6.9.1
>  * Move decision to enable WFx traps back to vcpu load time
>  * Move policy enum to arm.c and mark variable as __read_mostly
>  * Add explicit disclaimer traps are not guaranteed even when setting ena=
bled
>  * Remove explicit "default" case from early param handling as it is not =
needed
>
> v5:
> https://lore.kernel.org/kvmarm/20240430181444.670773-1-coltonlewis@google=
.com/
>
> v4:
> https://lore.kernel.org/kvmarm/20240422181716.237284-1-coltonlewis@google=
.com/
>
> v3:
> https://lore.kernel.org/kvmarm/20240410175437.793508-1-coltonlewis@google=
.com/
>
> v2:
> https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@googl=
e.com/
>
> v1:
> https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@googl=
e.com/
>
>  .../admin-guide/kernel-parameters.txt         | 18 +++++
>  arch/arm64/include/asm/kvm_emulate.h          | 16 -----
>  arch/arm64/kvm/arm.c                          | 68 ++++++++++++++++++-
>  3 files changed, 83 insertions(+), 19 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentat=
ion/admin-guide/kernel-parameters.txt
> index 396137ee018d..f334265a9cfa 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2693,6 +2693,24 @@
>                         [KVM,ARM,EARLY] Allow use of GICv4 for direct
>                         injection of LPIs.
>
> +       kvm-arm.wfe_trap_policy=3D
> +                       [KVM,ARM] Control when to set WFE instruction tra=
p for
> +                       KVM VMs. Traps are allowed but not guaranteed by =
the
> +                       CPU architecture.
> +
> +                       trap: set WFE instruction trap
> +
> +                       notrap: clear WFE instruction trap
> +
> +       kvm-arm.wfi_trap_policy=3D
> +                       [KVM,ARM] Control when to set WFI instruction tra=
p for
> +                       KVM VMs. Traps are allowed but not guaranteed by =
the
> +                       CPU architecture.
> +
> +                       trap: set WFI instruction trap
> +
> +                       notrap: clear WFI instruction trap
> +
>         kvm_cma_resv_ratio=3Dn [PPC,EARLY]
>                         Reserves given percentage from system memory area=
 for
>                         contiguous memory allocation for KVM hash pagetab=
le
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 975af30af31f..68c4a170b871 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -109,22 +109,6 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcp=
u *vcpu)
>         return (unsigned long *)&vcpu->arch.hcr_el2;
>  }
>
> -static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
> -{
> -       vcpu->arch.hcr_el2 &=3D ~HCR_TWE;
> -       if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) =
||
> -           vcpu->kvm->arch.vgic.nassgireq)
> -               vcpu->arch.hcr_el2 &=3D ~HCR_TWI;
> -       else
> -               vcpu->arch.hcr_el2 |=3D HCR_TWI;
> -}
> -
> -static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
> -{
> -       vcpu->arch.hcr_el2 |=3D HCR_TWE;
> -       vcpu->arch.hcr_el2 |=3D HCR_TWI;
> -}
> -
>  static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
>  {
>         vcpu->arch.hcr_el2 |=3D (HCR_API | HCR_APK);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c4a0a35e02c7..1cd58ca5d410 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -47,6 +47,15 @@
>
>  static enum kvm_mode kvm_mode =3D KVM_MODE_DEFAULT;
>
> +enum kvm_wfx_trap_policy {
> +       KVM_WFX_NOTRAP_SINGLE_TASK, /* Default option */
> +       KVM_WFX_NOTRAP,
> +       KVM_WFX_TRAP,
> +};
> +
> +static enum kvm_wfx_trap_policy kvm_wfi_trap_policy __read_mostly =3D KV=
M_WFX_NOTRAP_SINGLE_TASK;
> +static enum kvm_wfx_trap_policy kvm_wfe_trap_policy __read_mostly =3D KV=
M_WFX_NOTRAP_SINGLE_TASK;
> +
>  DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>
>  DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> @@ -428,6 +437,24 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>
>  }
>
> +static bool kvm_vcpu_should_clear_twi(struct kvm_vcpu *vcpu)
> +{
> +       if (likely(kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP_SINGLE_TASK)=
)
> +               return single_task_running() &&
> +                       (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe=
.vlpi_count) ||
> +                        vcpu->kvm->arch.vgic.nassgireq);
> +
> +       return kvm_wfi_trap_policy =3D=3D KVM_WFX_NOTRAP;
> +}
> +
> +static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
> +{
> +       if (likely(kvm_wfe_trap_policy =3D=3D KVM_WFX_NOTRAP_SINGLE_TASK)=
)
> +               return single_task_running();
> +
> +       return kvm_wfe_trap_policy =3D=3D KVM_WFX_NOTRAP;
> +}
> +
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>         struct kvm_s2_mmu *mmu;
> @@ -461,10 +488,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int =
cpu)
>         if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
>                 kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
>
> -       if (single_task_running())
> -               vcpu_clear_wfx_traps(vcpu);
> +       if (kvm_vcpu_should_clear_twe(vcpu))
> +               vcpu->arch.hcr_el2 &=3D ~HCR_TWE;
> +       else
> +               vcpu->arch.hcr_el2 |=3D HCR_TWE;
> +
> +       if (kvm_vcpu_should_clear_twi(vcpu))
> +               vcpu->arch.hcr_el2 &=3D ~HCR_TWI;
>         else
> -               vcpu_set_wfx_traps(vcpu);
> +               vcpu->arch.hcr_el2 |=3D HCR_TWI;
>
>         if (vcpu_has_ptrauth(vcpu))
>                 vcpu_ptrauth_disable(vcpu);
> @@ -2663,6 +2695,36 @@ static int __init early_kvm_mode_cfg(char *arg)
>  }
>  early_param("kvm-arm.mode", early_kvm_mode_cfg);
>
> +static int __init early_kvm_wfx_trap_policy_cfg(char *arg, enum kvm_wfx_=
trap_policy *p)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (strcmp(arg, "trap") =3D=3D 0) {
> +               *p =3D KVM_WFX_TRAP;
> +               return 0;
> +       }
> +
> +       if (strcmp(arg, "notrap") =3D=3D 0) {
> +               *p =3D KVM_WFX_NOTRAP;
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +static int __init early_kvm_wfi_trap_policy_cfg(char *arg)
> +{
> +       return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfi_trap_policy);
> +}
> +early_param("kvm-arm.wfi_trap_policy", early_kvm_wfi_trap_policy_cfg);
> +
> +static int __init early_kvm_wfe_trap_policy_cfg(char *arg)
> +{
> +       return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfe_trap_policy);
> +}
> +early_param("kvm-arm.wfe_trap_policy", early_kvm_wfe_trap_policy_cfg);
> +
>  enum kvm_mode kvm_get_mode(void)
>  {
>         return kvm_mode;
> --
> 2.45.1.288.g0e0cd299f1-goog
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing

