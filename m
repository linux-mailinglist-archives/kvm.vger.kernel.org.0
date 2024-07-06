Return-Path: <kvm+bounces-21052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA8B92901E
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 05:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30E6D1F21E09
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 03:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53E4EAE9;
	Sat,  6 Jul 2024 03:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0h+FHZA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FC91367;
	Sat,  6 Jul 2024 03:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720234836; cv=none; b=VfOT4O5EFpYcYUYfhAqoiwIPSaKG7DftqrtKO4C9w51QQsfb/O+j4uHhXMQ0UAWLMalOzyxiO4Y5ZMwuMYvf0lMNgM8gyB1M8/UEWBuEM/cSLdRynXBCRLXWxUyMKZ8YgodRZAbFGu3PtWnJY007n6GnvR2bEny+CT6B0E/VfjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720234836; c=relaxed/simple;
	bh=dxpPrVajL1gnWoK3H3BsUvtBsIYVkcyQNOmdZ0caoXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aIAKw9dDKx0RoYggMRj66eouJkdUtQTS5bgoNxAYg1T+lRFbOAs8VBcj2xW0pipO1laD8UuZ//mHZ8+iFM/WAuAAzxp76to9iyy9XN6fsCYjOwV7wwTbEO67A4On81jOpwXuOrLKQuO/Jkg1nUMTgIcD1NOpawz1ROQVvG7yrG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0h+FHZA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A62C4AF0A;
	Sat,  6 Jul 2024 03:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720234835;
	bh=dxpPrVajL1gnWoK3H3BsUvtBsIYVkcyQNOmdZ0caoXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=l0h+FHZAyCj0tfk6ZmxjGrK0W4g1qv67Ori+w33lzZu3IkLStbaD6kskV7Tcux5TF
	 AeUZl8JeffWm2vg7LKXmyijuDW8GcW3SP9yw79jdadXkZrTIy5JW4StE95JRofrfbR
	 SJhDIDh3s/8kPuHMjyMMUxrOLCZVnpjOuTeTNKm7vC6k0J9nUCpz2zlSf+5RodUuDj
	 m8WqPzDEZOaTVUy382xIMvGRb7PgS8s/wT/dbn8KaUxjuiu93CuK/HBNNtFvUgOCYL
	 1ORYd7kl5g1UdogR2wXXr8rEXXQklIVO65c714Z42zi5OMvS0hh+FTexUWL5C2bG6W
	 8N6ILmbdgpFkQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a77e5929033so7273166b.0;
        Fri, 05 Jul 2024 20:00:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUDDqC3CdQeFnIBOlulmTmbKf5sPVpi75RR2T81to1VlYsik0J4KELTXpT/qIqqne69ZRAmdlDovTSRTq8VUkiA/wswUBv+j6srFAj2ljmsqTIBSx/q6HaWlXKRqN/lyXB/
X-Gm-Message-State: AOJu0YwdyyotTfgqY3Yj32KlhTu8yWUH0+Nw9/LiFMmtjwKxvzsx14ze
	ZLkUGNXx8gmSC7EFsUZR9/IcMKRAn01CVe5aygHq5giBjRKcDHKhYrZcff9yocurGFzGZ1oseCn
	Dxvl3/OBichRE0sEWU669udrriDY=
X-Google-Smtp-Source: AGHT+IFp6pWEgG8JzQC9B8zoNUBGdnMiM4oV+Rq7m+6HGCXR0+SqywOwjCEAwSB0UPjuD1UlWZzXtPgozgpEWQmOs1E=
X-Received: by 2002:a17:906:a08:b0:a77:c525:5c64 with SMTP id
 a640c23a62f3a-a77c52571e8mr319512566b.39.1720234833974; Fri, 05 Jul 2024
 20:00:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524073812.731032-1-maobibo@loongson.cn> <20240524073812.731032-2-maobibo@loongson.cn>
In-Reply-To: <20240524073812.731032-2-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 6 Jul 2024 11:00:20 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5G7O7tbwzyaoO4iEXuN+_xbVFJDEyv1HH7GqOH24639Q@mail.gmail.com>
Message-ID: <CAAhV-H5G7O7tbwzyaoO4iEXuN+_xbVFJDEyv1HH7GqOH24639Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] LoongArch: KVM: Add steal time support in kvm side
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Fri, May 24, 2024 at 3:38=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Steal time feature is added here in kvm side, VM can search supported
> features provided by KVM hypervisor, feature KVM_FEATURE_STEAL_TIME
> is added here. Like x86, steal time structure is saved in guest memory,
> one hypercall function KVM_HCALL_FUNC_NOTIFY is added to notify KVM to
> enable the feature.
>
> One cpu attr ioctl command KVM_LOONGARCH_VCPU_PVTIME_CTRL is added to
> save and restore base address of steal time structure when VM is migrated=
.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_host.h  |   7 ++
>  arch/loongarch/include/asm/kvm_para.h  |  10 ++
>  arch/loongarch/include/asm/kvm_vcpu.h  |   4 +
>  arch/loongarch/include/asm/loongarch.h |   1 +
>  arch/loongarch/include/uapi/asm/kvm.h  |   4 +
>  arch/loongarch/kvm/Kconfig             |   1 +
>  arch/loongarch/kvm/exit.c              |  38 +++++++-
>  arch/loongarch/kvm/vcpu.c              | 124 +++++++++++++++++++++++++
>  8 files changed, 187 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/inclu=
de/asm/kvm_host.h
> index c87b6ea0ec47..2eb2f7572023 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -30,6 +30,7 @@
>  #define KVM_PRIVATE_MEM_SLOTS          0
>
>  #define KVM_HALT_POLL_NS_DEFAULT       500000
> +#define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
>
>  #define KVM_GUESTDBG_SW_BP_MASK                \
>         (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> @@ -201,6 +202,12 @@ struct kvm_vcpu_arch {
>         struct kvm_mp_state mp_state;
>         /* cpucfg */
>         u32 cpucfg[KVM_MAX_CPUCFG_REGS];
> +       /* paravirt steal time */
> +       struct {
> +               u64 guest_addr;
> +               u64 last_steal;
> +               struct gfn_to_hva_cache cache;
> +       } st;
>  };
>
>  static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *csr, in=
t reg)
> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inclu=
de/asm/kvm_para.h
> index 4ba2312e5f8c..a9ba8185d4af 100644
> --- a/arch/loongarch/include/asm/kvm_para.h
> +++ b/arch/loongarch/include/asm/kvm_para.h
> @@ -14,6 +14,7 @@
>
>  #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISOR_KVM, =
KVM_HCALL_CODE_SERVICE)
>  #define  KVM_HCALL_FUNC_IPI            1
> +#define  KVM_HCALL_FUNC_NOTIFY         2
>
>  #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(HYPERVIS=
OR_KVM, KVM_HCALL_CODE_SWDBG)
>
> @@ -24,6 +25,15 @@
>  #define KVM_HCALL_INVALID_CODE         -1UL
>  #define KVM_HCALL_INVALID_PARAMETER    -2UL
>
> +#define KVM_STEAL_PHYS_VALID           BIT_ULL(0)
> +#define KVM_STEAL_PHYS_MASK            GENMASK_ULL(63, 6)
> +struct kvm_steal_time {
> +       __u64 steal;
> +       __u32 version;
> +       __u32 flags;
I found that x86 has a preempted field here, in our internal repo the
LoongArch version also has this field. Moreover,
kvm_steal_time_set_preempted() and kvm_steal_time_clear_preempted()
seems needed.

> +       __u32 pad[12];
> +};
> +
>  /*
>   * Hypercall interface for KVM hypervisor
>   *
> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/inclu=
de/asm/kvm_vcpu.h
> index 590a92cb5416..d7e51300a89f 100644
> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> @@ -120,4 +120,8 @@ static inline void kvm_write_reg(struct kvm_vcpu *vcp=
u, int num, unsigned long v
>         vcpu->arch.gprs[num] =3D val;
>  }
>
> +static inline bool kvm_pvtime_supported(void)
> +{
> +       return !!sched_info_on();
> +}
>  #endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/incl=
ude/asm/loongarch.h
> index eb09adda54b7..7a4633ef284b 100644
> --- a/arch/loongarch/include/asm/loongarch.h
> +++ b/arch/loongarch/include/asm/loongarch.h
> @@ -169,6 +169,7 @@
>  #define  KVM_SIGNATURE                 "KVM\0"
>  #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>  #define  KVM_FEATURE_IPI               BIT(1)
> +#define  KVM_FEATURE_STEAL_TIME                BIT(2)
>
>  #ifndef __ASSEMBLY__
>
> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/inclu=
de/uapi/asm/kvm.h
> index f9abef382317..ddc5cab0ffd0 100644
> --- a/arch/loongarch/include/uapi/asm/kvm.h
> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> @@ -81,7 +81,11 @@ struct kvm_fpu {
>  #define LOONGARCH_REG_64(TYPE, REG)    (TYPE | KVM_REG_SIZE_U64 | (REG <=
< LOONGARCH_REG_SHIFT))
>  #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARC=
H_CSR, REG)
>  #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARC=
H_CPUCFG, REG)
> +
> +/* Device Control API on vcpu fd */
>  #define KVM_LOONGARCH_VCPU_CPUCFG      0
> +#define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> +#define  KVM_LOONGARCH_VCPU_PVTIME_GPA 0
>
>  struct kvm_debug_exit_arch {
>  };
> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> index c4ef2b4d9797..248744b4d086 100644
> --- a/arch/loongarch/kvm/Kconfig
> +++ b/arch/loongarch/kvm/Kconfig
> @@ -29,6 +29,7 @@ config KVM
>         select KVM_MMIO
>         select HAVE_KVM_READONLY_MEM
>         select KVM_XFER_TO_GUEST_WORK
> +       select SCHED_INFO
>         help
>           Support hosting virtualized guest machines using
>           hardware virtualization extensions. You will need
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index c86e099af5ca..e2abd97fb13f 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -24,7 +24,7 @@
>  static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>  {
>         int rd, rj;
> -       unsigned int index;
> +       unsigned int index, ret;
>
>         if (inst.reg2_format.opcode !=3D cpucfg_op)
>                 return EMULATE_FAIL;
> @@ -50,7 +50,10 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch=
_inst inst)
>                 vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNATURE;
>                 break;
>         case CPUCFG_KVM_FEATURE:
> -               vcpu->arch.gprs[rd] =3D KVM_FEATURE_IPI;
> +               ret =3D KVM_FEATURE_IPI;
> +               if (sched_info_on())
What about replacing it with your helper function kvm_pvtime_supported()?

Huacai

> +                       ret |=3D KVM_FEATURE_STEAL_TIME;
> +               vcpu->arch.gprs[rd] =3D ret;
>                 break;
>         default:
>                 vcpu->arch.gprs[rd] =3D 0;
> @@ -687,6 +690,34 @@ static int kvm_handle_fpu_disabled(struct kvm_vcpu *=
vcpu)
>         return RESUME_GUEST;
>  }
>
> +static long kvm_save_notify(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long id, data;
> +
> +       id   =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
> +       data =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
> +       switch (id) {
> +       case KVM_FEATURE_STEAL_TIME:
> +               if (!kvm_pvtime_supported())
> +                       return KVM_HCALL_INVALID_CODE;
> +
> +               if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
> +                       return KVM_HCALL_INVALID_PARAMETER;
> +
> +               vcpu->arch.st.guest_addr =3D data;
> +               if (!(data & KVM_STEAL_PHYS_VALID))
> +                       break;
> +
> +               vcpu->arch.st.last_steal =3D current->sched_info.run_dela=
y;
> +               kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> +               break;
> +       default:
> +               break;
> +       };
> +
> +       return 0;
> +};
> +
>  /*
>   * kvm_handle_lsx_disabled() - Guest used LSX while disabled in root.
>   * @vcpu:      Virtual CPU context.
> @@ -758,6 +789,9 @@ static void kvm_handle_service(struct kvm_vcpu *vcpu)
>                 kvm_send_pv_ipi(vcpu);
>                 ret =3D KVM_HCALL_SUCCESS;
>                 break;
> +       case KVM_HCALL_FUNC_NOTIFY:
> +               ret =3D kvm_save_notify(vcpu);
> +               break;
>         default:
>                 ret =3D KVM_HCALL_INVALID_CODE;
>                 break;
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 9e8030d45129..382796f1d3e6 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -31,6 +31,117 @@ const struct kvm_stats_header kvm_vcpu_stats_header =
=3D {
>                        sizeof(kvm_vcpu_stats_desc),
>  };
>
> +static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
> +{
> +       struct kvm_steal_time __user *st;
> +       struct gfn_to_hva_cache *ghc;
> +       struct kvm_memslots *slots;
> +       gpa_t gpa;
> +       u64 steal;
> +       u32 version;
> +
> +       ghc =3D &vcpu->arch.st.cache;
> +       gpa =3D vcpu->arch.st.guest_addr;
> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
> +               return;
> +
> +       gpa &=3D KVM_STEAL_PHYS_MASK;
> +       slots =3D kvm_memslots(vcpu->kvm);
> +       if (slots->generation !=3D ghc->generation || gpa !=3D ghc->gpa) =
{
> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa,
> +                                       sizeof(*st))) {
> +                       ghc->gpa =3D INVALID_GPA;
> +                       return;
> +               }
> +       }
> +
> +       st =3D (struct kvm_steal_time __user *)ghc->hva;
> +       unsafe_get_user(version, &st->version, out);
> +       if (version & 1)
> +               version +=3D 1;
> +       version +=3D 1;
> +       unsafe_put_user(version, &st->version, out);
> +       smp_wmb();
> +
> +       unsafe_get_user(steal, &st->steal, out);
> +       steal +=3D current->sched_info.run_delay -
> +               vcpu->arch.st.last_steal;
> +       vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> +       unsafe_put_user(steal, &st->steal, out);
> +
> +       smp_wmb();
> +       version +=3D 1;
> +       unsafe_put_user(version, &st->version, out);
> +out:
> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->=
gpa));
> +}
> +
> +static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
> +                                       struct kvm_device_attr *attr)
> +{
> +       if (!kvm_pvtime_supported() ||
> +                       attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GPA)
> +               return -ENXIO;
> +
> +       return 0;
> +}
> +
> +static int kvm_loongarch_pvtime_get_attr(struct kvm_vcpu *vcpu,
> +                                       struct kvm_device_attr *attr)
> +{
> +       u64 __user *user =3D (u64 __user *)attr->addr;
> +       u64 gpa;
> +
> +       if (!kvm_pvtime_supported() ||
> +                       attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GPA)
> +               return -ENXIO;
> +
> +       gpa =3D vcpu->arch.st.guest_addr;
> +       if (put_user(gpa, user))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
> +static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
> +                                       struct kvm_device_attr *attr)
> +{
> +       u64 __user *user =3D (u64 __user *)attr->addr;
> +       struct kvm *kvm =3D vcpu->kvm;
> +       u64 gpa;
> +       int ret =3D 0;
> +       int idx;
> +
> +       if (!kvm_pvtime_supported() ||
> +                       attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GPA)
> +               return -ENXIO;
> +
> +       if (get_user(gpa, user))
> +               return -EFAULT;
> +
> +       if (gpa & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
> +               return -EINVAL;
> +
> +       if (!(gpa & KVM_STEAL_PHYS_VALID)) {
> +               vcpu->arch.st.guest_addr =3D gpa;
> +               return 0;
> +       }
> +
> +       /* Check the address is in a valid memslot */
> +       idx =3D srcu_read_lock(&kvm->srcu);
> +       if (kvm_is_error_hva(gfn_to_hva(kvm, gpa >> PAGE_SHIFT)))
> +               ret =3D -EINVAL;
> +       srcu_read_unlock(&kvm->srcu, idx);
> +
> +       if (!ret) {
> +               vcpu->arch.st.guest_addr =3D gpa;
> +               vcpu->arch.st.last_steal =3D current->sched_info.run_dela=
y;
> +               kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> +       }
> +
> +       return ret;
> +}
> +
>  /*
>   * kvm_check_requests - check and handle pending vCPU requests
>   *
> @@ -48,6 +159,9 @@ static int kvm_check_requests(struct kvm_vcpu *vcpu)
>         if (kvm_dirty_ring_check_request(vcpu))
>                 return RESUME_HOST;
>
> +       if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
> +               kvm_update_stolen_time(vcpu);
> +
>         return RESUME_GUEST;
>  }
>
> @@ -671,6 +785,9 @@ static int kvm_loongarch_vcpu_has_attr(struct kvm_vcp=
u *vcpu,
>         case KVM_LOONGARCH_VCPU_CPUCFG:
>                 ret =3D kvm_loongarch_cpucfg_has_attr(vcpu, attr);
>                 break;
> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
> +               ret =3D kvm_loongarch_pvtime_has_attr(vcpu, attr);
> +               break;
>         default:
>                 break;
>         }
> @@ -703,6 +820,9 @@ static int kvm_loongarch_vcpu_get_attr(struct kvm_vcp=
u *vcpu,
>         case KVM_LOONGARCH_VCPU_CPUCFG:
>                 ret =3D kvm_loongarch_get_cpucfg_attr(vcpu, attr);
>                 break;
> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
> +               ret =3D kvm_loongarch_pvtime_get_attr(vcpu, attr);
> +               break;
>         default:
>                 break;
>         }
> @@ -725,6 +845,9 @@ static int kvm_loongarch_vcpu_set_attr(struct kvm_vcp=
u *vcpu,
>         case KVM_LOONGARCH_VCPU_CPUCFG:
>                 ret =3D kvm_loongarch_cpucfg_set_attr(vcpu, attr);
>                 break;
> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
> +               ret =3D kvm_loongarch_pvtime_set_attr(vcpu, attr);
> +               break;
>         default:
>                 break;
>         }
> @@ -1084,6 +1207,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, in=
t cpu)
>
>         /* Control guest page CCA attribute */
>         change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
> +       kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>
>         /* Don't bother restoring registers multiple times unless necessa=
ry */
>         if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
> --
> 2.39.3
>

