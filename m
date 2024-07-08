Return-Path: <kvm+bounces-21093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6197929F7D
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 11:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D0A0288BBB
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 09:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DDB762D2;
	Mon,  8 Jul 2024 09:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPnjHn4k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F43E48CCD;
	Mon,  8 Jul 2024 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720432052; cv=none; b=P/2xfpRBZzvgs8QKFgvm+oS7yPxKCv5vH/FBzmKtvpzeFWsZCDEmU9+gXTEiAhYxEkRwFuvBXYTItg9CU5NbkokNKH8bAoSL5F/z6XAIhFLmuges2vyuQEN/V/rDMu2V0f/CPXgYVj1YSFnp0f8sbJwJ4Pvcy8HQ5SyU9zwh+7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720432052; c=relaxed/simple;
	bh=6ZQTAiQVbQo9uYcXEBcFrxIQPxojeGwZ9owxOifNEfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sJNUChu1JOLWFiLFFB/JnD7FPpQudoXfuoZYvS+E1Ktwrnk5LURX8QYUupy0xK4AlxeeCFT4tCzNYdPitqTF8W4NQMR6Zq2trRHSnSm3aIA7rrOGOG3J/tA47tMUt3bAgmbvywHCqVTJIG3Ox3x3VlwY2VyDTlTAuHPQIhsE3sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPnjHn4k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DF7C4AF0D;
	Mon,  8 Jul 2024 09:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720432052;
	bh=6ZQTAiQVbQo9uYcXEBcFrxIQPxojeGwZ9owxOifNEfw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mPnjHn4krM2syVwybaGnTF5CDuHuUV7OIDsB4/SD0yV2/ZuD5JOEBlt7+W7QceF4O
	 ezpArvKBPCYN8DvExkhVlIwRj271gWD0dOxdAGxdHmGfoTuoLeZUjmwWSBdxANgi6v
	 jX3Arzy+pJATi+puf1J6/wd0o8GIYWPfjj1ezbrRCrOq0MW7cZVXtCpJCjCEq04f2I
	 xPCI6/93vVV+Jb5pOjRTzl0rW47YmSBftmb6XtWapztDWZWh3rmslx6pit8QGyRubW
	 b21ohGibTtymkWHUt8cLThQeWCMJC54NmDBgHv1P4yVYvUfJTS4uQQm7IUC0blSIxx
	 vQhZmS1Q0Hb0g==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57ccd1111aeso4739244a12.0;
        Mon, 08 Jul 2024 02:47:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW5rb+jFG+fiBDyFa0qLFGt82epOp2/X2ZXCJ7Z6RWuZg6NCHjO6So40PxsMT49rdVABMrDqLleouC/omlzqGbSmD0G1/zlHmzsLZ+wnQyMpVvR2uRbMrH5q01wnSRagaH+
X-Gm-Message-State: AOJu0YzyWlCIiJVYwQuUY3904IACtRSqYaONi9Uzl+RBz2db5dfXRlqi
	NgJpoF5tZCnzawCYVvzbLWsopRJx5OhCDZbTINNAudvzvM0j3OfffyxhdH9bFQRUxbOxV7kjaV7
	s1OsZoG+xH9rAWcQLPpj41mHxK2U=
X-Google-Smtp-Source: AGHT+IHT7P4R9Gj2HJxbgNAzMvzU8XXQI2iU6qxaLmu63ghvfY2DhAYH0v7X1A/WX9w1E/RHXEXCEzqRX2Tl6sw4ncI=
X-Received: by 2002:a17:906:4686:b0:a72:5a8c:87c6 with SMTP id
 a640c23a62f3a-a77ba454c31mr780998566b.10.1720432050300; Mon, 08 Jul 2024
 02:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240524073812.731032-1-maobibo@loongson.cn> <20240524073812.731032-2-maobibo@loongson.cn>
 <CAAhV-H5G7O7tbwzyaoO4iEXuN+_xbVFJDEyv1HH7GqOH24639Q@mail.gmail.com>
 <1aa110a8-28b9-d1d0-4b39-bc894b31f26c@loongson.cn> <CAAhV-H5oS+KrcGH+1wJCGKCjs2VKHkWyZ5QnorPjFMuE_eBb3g@mail.gmail.com>
 <ae21f9ef-e043-0f8c-b088-6645fc1f3c30@loongson.cn>
In-Reply-To: <ae21f9ef-e043-0f8c-b088-6645fc1f3c30@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 8 Jul 2024 17:47:16 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7QKqOX0fSyN=wnf_Y_5=CDE2ysP2O3Shj2zex8ce1ZMA@mail.gmail.com>
Message-ID: <CAAhV-H7QKqOX0fSyN=wnf_Y_5=CDE2ysP2O3Shj2zex8ce1ZMA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] LoongArch: KVM: Add steal time support in kvm side
To: maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 9:16=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/7/6 =E4=B8=8B=E5=8D=885:41, Huacai Chen wrote:
> > On Sat, Jul 6, 2024 at 2:59=E2=80=AFPM maobibo <maobibo@loongson.cn> wr=
ote:
> >>
> >> Huacai,
> >>
> >> On 2024/7/6 =E4=B8=8A=E5=8D=8811:00, Huacai Chen wrote:
> >>> Hi, Bibo,
> >>>
> >>> On Fri, May 24, 2024 at 3:38=E2=80=AFPM Bibo Mao <maobibo@loongson.cn=
> wrote:
> >>>>
> >>>> Steal time feature is added here in kvm side, VM can search supporte=
d
> >>>> features provided by KVM hypervisor, feature KVM_FEATURE_STEAL_TIME
> >>>> is added here. Like x86, steal time structure is saved in guest memo=
ry,
> >>>> one hypercall function KVM_HCALL_FUNC_NOTIFY is added to notify KVM =
to
> >>>> enable the feature.
> >>>>
> >>>> One cpu attr ioctl command KVM_LOONGARCH_VCPU_PVTIME_CTRL is added t=
o
> >>>> save and restore base address of steal time structure when VM is mig=
rated.
> >>>>
> >>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >>>> ---
> >>>>    arch/loongarch/include/asm/kvm_host.h  |   7 ++
> >>>>    arch/loongarch/include/asm/kvm_para.h  |  10 ++
> >>>>    arch/loongarch/include/asm/kvm_vcpu.h  |   4 +
> >>>>    arch/loongarch/include/asm/loongarch.h |   1 +
> >>>>    arch/loongarch/include/uapi/asm/kvm.h  |   4 +
> >>>>    arch/loongarch/kvm/Kconfig             |   1 +
> >>>>    arch/loongarch/kvm/exit.c              |  38 +++++++-
> >>>>    arch/loongarch/kvm/vcpu.c              | 124 ++++++++++++++++++++=
+++++
> >>>>    8 files changed, 187 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/=
include/asm/kvm_host.h
> >>>> index c87b6ea0ec47..2eb2f7572023 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_host.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_host.h
> >>>> @@ -30,6 +30,7 @@
> >>>>    #define KVM_PRIVATE_MEM_SLOTS          0
> >>>>
> >>>>    #define KVM_HALT_POLL_NS_DEFAULT       500000
> >>>> +#define KVM_REQ_STEAL_UPDATE           KVM_ARCH_REQ(1)
> >>>>
> >>>>    #define KVM_GUESTDBG_SW_BP_MASK                \
> >>>>           (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP)
> >>>> @@ -201,6 +202,12 @@ struct kvm_vcpu_arch {
> >>>>           struct kvm_mp_state mp_state;
> >>>>           /* cpucfg */
> >>>>           u32 cpucfg[KVM_MAX_CPUCFG_REGS];
> >>>> +       /* paravirt steal time */
> >>>> +       struct {
> >>>> +               u64 guest_addr;
> >>>> +               u64 last_steal;
> >>>> +               struct gfn_to_hva_cache cache;
> >>>> +       } st;
> >>>>    };
> >>>>
> >>>>    static inline unsigned long readl_sw_gcsr(struct loongarch_csrs *=
csr, int reg)
> >>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/=
include/asm/kvm_para.h
> >>>> index 4ba2312e5f8c..a9ba8185d4af 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_para.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_para.h
> >>>> @@ -14,6 +14,7 @@
> >>>>
> >>>>    #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISO=
R_KVM, KVM_HCALL_CODE_SERVICE)
> >>>>    #define  KVM_HCALL_FUNC_IPI            1
> >>>> +#define  KVM_HCALL_FUNC_NOTIFY         2
> >>>>
> >>>>    #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(H=
YPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
> >>>>
> >>>> @@ -24,6 +25,15 @@
> >>>>    #define KVM_HCALL_INVALID_CODE         -1UL
> >>>>    #define KVM_HCALL_INVALID_PARAMETER    -2UL
> >>>>
> >>>> +#define KVM_STEAL_PHYS_VALID           BIT_ULL(0)
> >>>> +#define KVM_STEAL_PHYS_MASK            GENMASK_ULL(63, 6)
> >>>> +struct kvm_steal_time {
> >>>> +       __u64 steal;
> >>>> +       __u32 version;
> >>>> +       __u32 flags;
> >>> I found that x86 has a preempted field here, in our internal repo the
> >>> LoongArch version also has this field. Moreover,
> >>> kvm_steal_time_set_preempted() and kvm_steal_time_clear_preempted()
> >>> seems needed.
> >> By my understanding, macro vcpu_is_preempted() is used together with p=
v
> >> spinlock, and pv spinlock depends on pv stealtime. So I think preempte=
d
> >> flag is not part of pv stealtime, it is part of pv spinlock.
> >>
> >> We are going to add preempted field if pv spinlock is added.
> >>>
> >>>> +       __u32 pad[12];
> >>>> +};
> >>>> +
> >>>>    /*
> >>>>     * Hypercall interface for KVM hypervisor
> >>>>     *
> >>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/=
include/asm/kvm_vcpu.h
> >>>> index 590a92cb5416..d7e51300a89f 100644
> >>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
> >>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
> >>>> @@ -120,4 +120,8 @@ static inline void kvm_write_reg(struct kvm_vcpu=
 *vcpu, int num, unsigned long v
> >>>>           vcpu->arch.gprs[num] =3D val;
> >>>>    }
> >>>>
> >>>> +static inline bool kvm_pvtime_supported(void)
> >>>> +{
> >>>> +       return !!sched_info_on();
> >>>> +}
> >>>>    #endif /* __ASM_LOONGARCH_KVM_VCPU_H__ */
> >>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch=
/include/asm/loongarch.h
> >>>> index eb09adda54b7..7a4633ef284b 100644
> >>>> --- a/arch/loongarch/include/asm/loongarch.h
> >>>> +++ b/arch/loongarch/include/asm/loongarch.h
> >>>> @@ -169,6 +169,7 @@
> >>>>    #define  KVM_SIGNATURE                 "KVM\0"
> >>>>    #define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
> >>>>    #define  KVM_FEATURE_IPI               BIT(1)
> >>>> +#define  KVM_FEATURE_STEAL_TIME                BIT(2)
> >>>>
> >>>>    #ifndef __ASSEMBLY__
> >>>>
> >>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/=
include/uapi/asm/kvm.h
> >>>> index f9abef382317..ddc5cab0ffd0 100644
> >>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
> >>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
> >>>> @@ -81,7 +81,11 @@ struct kvm_fpu {
> >>>>    #define LOONGARCH_REG_64(TYPE, REG)    (TYPE | KVM_REG_SIZE_U64 |=
 (REG << LOONGARCH_REG_SHIFT))
> >>>>    #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_L=
OONGARCH_CSR, REG)
> >>>>    #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_L=
OONGARCH_CPUCFG, REG)
> >>>> +
> >>>> +/* Device Control API on vcpu fd */
> >>>>    #define KVM_LOONGARCH_VCPU_CPUCFG      0
> >>>> +#define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
> >>>> +#define  KVM_LOONGARCH_VCPU_PVTIME_GPA 0
> >>>>
> >>>>    struct kvm_debug_exit_arch {
> >>>>    };
> >>>> diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
> >>>> index c4ef2b4d9797..248744b4d086 100644
> >>>> --- a/arch/loongarch/kvm/Kconfig
> >>>> +++ b/arch/loongarch/kvm/Kconfig
> >>>> @@ -29,6 +29,7 @@ config KVM
> >>>>           select KVM_MMIO
> >>>>           select HAVE_KVM_READONLY_MEM
> >>>>           select KVM_XFER_TO_GUEST_WORK
> >>>> +       select SCHED_INFO
> >>>>           help
> >>>>             Support hosting virtualized guest machines using
> >>>>             hardware virtualization extensions. You will need
> >>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> >>>> index c86e099af5ca..e2abd97fb13f 100644
> >>>> --- a/arch/loongarch/kvm/exit.c
> >>>> +++ b/arch/loongarch/kvm/exit.c
> >>>> @@ -24,7 +24,7 @@
> >>>>    static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
> >>>>    {
> >>>>           int rd, rj;
> >>>> -       unsigned int index;
> >>>> +       unsigned int index, ret;
> >>>>
> >>>>           if (inst.reg2_format.opcode !=3D cpucfg_op)
> >>>>                   return EMULATE_FAIL;
> >>>> @@ -50,7 +50,10 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, =
larch_inst inst)
> >>>>                   vcpu->arch.gprs[rd] =3D *(unsigned int *)KVM_SIGNA=
TURE;
> >>>>                   break;
> >>>>           case CPUCFG_KVM_FEATURE:
> >>>> -               vcpu->arch.gprs[rd] =3D KVM_FEATURE_IPI;
> >>>> +               ret =3D KVM_FEATURE_IPI;
> >>>> +               if (sched_info_on())
> >>> What about replacing it with your helper function kvm_pvtime_supporte=
d()?
> >> Sure, will replace it with helper function kvm_pvtime_supported().
> > If you are sure this is the only issue, then needn't submit a new versi=
on.
> OK, thanks.
>
> By searching orginal submit of vcpu_is_preempt(), it can be located at
> https://lore.kernel.org/lkml/1477642287-24104-1-git-send-email-xinhui.pan=
@linux.vnet.ibm.com/
>
> It is separated one, only that is depends on pv-spinlock and
> pv-stealtime. And there is no capability indicator for guest kernel, it
> is enabled by default.
Series applied with some modifications here, you can double-check the
correctness.
https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/log/?h=3Dloongarch-kvm

Huacai
>
> Regards
> Bibo Mao
>
> >
> > Huacai
> >
> >>
> >> Regards
> >> Bibo Mao
> >>>
> >>> Huacai
> >>>
> >>>> +                       ret |=3D KVM_FEATURE_STEAL_TIME;
> >>>> +               vcpu->arch.gprs[rd] =3D ret;
> >>>>                   break;
> >>>>           default:
> >>>>                   vcpu->arch.gprs[rd] =3D 0;
> >>>> @@ -687,6 +690,34 @@ static int kvm_handle_fpu_disabled(struct kvm_v=
cpu *vcpu)
> >>>>           return RESUME_GUEST;
> >>>>    }
> >>>>
> >>>> +static long kvm_save_notify(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +       unsigned long id, data;
> >>>> +
> >>>> +       id   =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
> >>>> +       data =3D kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
> >>>> +       switch (id) {
> >>>> +       case KVM_FEATURE_STEAL_TIME:
> >>>> +               if (!kvm_pvtime_supported())
> >>>> +                       return KVM_HCALL_INVALID_CODE;
> >>>> +
> >>>> +               if (data & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VA=
LID))
> >>>> +                       return KVM_HCALL_INVALID_PARAMETER;
> >>>> +
> >>>> +               vcpu->arch.st.guest_addr =3D data;
> >>>> +               if (!(data & KVM_STEAL_PHYS_VALID))
> >>>> +                       break;
> >>>> +
> >>>> +               vcpu->arch.st.last_steal =3D current->sched_info.run=
_delay;
> >>>> +               kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> >>>> +               break;
> >>>> +       default:
> >>>> +               break;
> >>>> +       };
> >>>> +
> >>>> +       return 0;
> >>>> +};
> >>>> +
> >>>>    /*
> >>>>     * kvm_handle_lsx_disabled() - Guest used LSX while disabled in r=
oot.
> >>>>     * @vcpu:      Virtual CPU context.
> >>>> @@ -758,6 +789,9 @@ static void kvm_handle_service(struct kvm_vcpu *=
vcpu)
> >>>>                   kvm_send_pv_ipi(vcpu);
> >>>>                   ret =3D KVM_HCALL_SUCCESS;
> >>>>                   break;
> >>>> +       case KVM_HCALL_FUNC_NOTIFY:
> >>>> +               ret =3D kvm_save_notify(vcpu);
> >>>> +               break;
> >>>>           default:
> >>>>                   ret =3D KVM_HCALL_INVALID_CODE;
> >>>>                   break;
> >>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> >>>> index 9e8030d45129..382796f1d3e6 100644
> >>>> --- a/arch/loongarch/kvm/vcpu.c
> >>>> +++ b/arch/loongarch/kvm/vcpu.c
> >>>> @@ -31,6 +31,117 @@ const struct kvm_stats_header kvm_vcpu_stats_hea=
der =3D {
> >>>>                          sizeof(kvm_vcpu_stats_desc),
> >>>>    };
> >>>>
> >>>> +static void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
> >>>> +{
> >>>> +       struct kvm_steal_time __user *st;
> >>>> +       struct gfn_to_hva_cache *ghc;
> >>>> +       struct kvm_memslots *slots;
> >>>> +       gpa_t gpa;
> >>>> +       u64 steal;
> >>>> +       u32 version;
> >>>> +
> >>>> +       ghc =3D &vcpu->arch.st.cache;
> >>>> +       gpa =3D vcpu->arch.st.guest_addr;
> >>>> +       if (!(gpa & KVM_STEAL_PHYS_VALID))
> >>>> +               return;
> >>>> +
> >>>> +       gpa &=3D KVM_STEAL_PHYS_MASK;
> >>>> +       slots =3D kvm_memslots(vcpu->kvm);
> >>>> +       if (slots->generation !=3D ghc->generation || gpa !=3D ghc->=
gpa) {
> >>>> +               if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa,
> >>>> +                                       sizeof(*st))) {
> >>>> +                       ghc->gpa =3D INVALID_GPA;
> >>>> +                       return;
> >>>> +               }
> >>>> +       }
> >>>> +
> >>>> +       st =3D (struct kvm_steal_time __user *)ghc->hva;
> >>>> +       unsafe_get_user(version, &st->version, out);
> >>>> +       if (version & 1)
> >>>> +               version +=3D 1;
> >>>> +       version +=3D 1;
> >>>> +       unsafe_put_user(version, &st->version, out);
> >>>> +       smp_wmb();
> >>>> +
> >>>> +       unsafe_get_user(steal, &st->steal, out);
> >>>> +       steal +=3D current->sched_info.run_delay -
> >>>> +               vcpu->arch.st.last_steal;
> >>>> +       vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> >>>> +       unsafe_put_user(steal, &st->steal, out);
> >>>> +
> >>>> +       smp_wmb();
> >>>> +       version +=3D 1;
> >>>> +       unsafe_put_user(version, &st->version, out);
> >>>> +out:
> >>>> +       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(=
ghc->gpa));
> >>>> +}
> >>>> +
> >>>> +static int kvm_loongarch_pvtime_has_attr(struct kvm_vcpu *vcpu,
> >>>> +                                       struct kvm_device_attr *attr=
)
> >>>> +{
> >>>> +       if (!kvm_pvtime_supported() ||
> >>>> +                       attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GP=
A)
> >>>> +               return -ENXIO;
> >>>> +
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +static int kvm_loongarch_pvtime_get_attr(struct kvm_vcpu *vcpu,
> >>>> +                                       struct kvm_device_attr *attr=
)
> >>>> +{
> >>>> +       u64 __user *user =3D (u64 __user *)attr->addr;
> >>>> +       u64 gpa;
> >>>> +
> >>>> +       if (!kvm_pvtime_supported() ||
> >>>> +                       attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GP=
A)
> >>>> +               return -ENXIO;
> >>>> +
> >>>> +       gpa =3D vcpu->arch.st.guest_addr;
> >>>> +       if (put_user(gpa, user))
> >>>> +               return -EFAULT;
> >>>> +
> >>>> +       return 0;
> >>>> +}
> >>>> +
> >>>> +static int kvm_loongarch_pvtime_set_attr(struct kvm_vcpu *vcpu,
> >>>> +                                       struct kvm_device_attr *attr=
)
> >>>> +{
> >>>> +       u64 __user *user =3D (u64 __user *)attr->addr;
> >>>> +       struct kvm *kvm =3D vcpu->kvm;
> >>>> +       u64 gpa;
> >>>> +       int ret =3D 0;
> >>>> +       int idx;
> >>>> +
> >>>> +       if (!kvm_pvtime_supported() ||
> >>>> +                       attr->attr !=3D KVM_LOONGARCH_VCPU_PVTIME_GP=
A)
> >>>> +               return -ENXIO;
> >>>> +
> >>>> +       if (get_user(gpa, user))
> >>>> +               return -EFAULT;
> >>>> +
> >>>> +       if (gpa & ~(KVM_STEAL_PHYS_MASK | KVM_STEAL_PHYS_VALID))
> >>>> +               return -EINVAL;
> >>>> +
> >>>> +       if (!(gpa & KVM_STEAL_PHYS_VALID)) {
> >>>> +               vcpu->arch.st.guest_addr =3D gpa;
> >>>> +               return 0;
> >>>> +       }
> >>>> +
> >>>> +       /* Check the address is in a valid memslot */
> >>>> +       idx =3D srcu_read_lock(&kvm->srcu);
> >>>> +       if (kvm_is_error_hva(gfn_to_hva(kvm, gpa >> PAGE_SHIFT)))
> >>>> +               ret =3D -EINVAL;
> >>>> +       srcu_read_unlock(&kvm->srcu, idx);
> >>>> +
> >>>> +       if (!ret) {
> >>>> +               vcpu->arch.st.guest_addr =3D gpa;
> >>>> +               vcpu->arch.st.last_steal =3D current->sched_info.run=
_delay;
> >>>> +               kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> >>>> +       }
> >>>> +
> >>>> +       return ret;
> >>>> +}
> >>>> +
> >>>>    /*
> >>>>     * kvm_check_requests - check and handle pending vCPU requests
> >>>>     *
> >>>> @@ -48,6 +159,9 @@ static int kvm_check_requests(struct kvm_vcpu *vc=
pu)
> >>>>           if (kvm_dirty_ring_check_request(vcpu))
> >>>>                   return RESUME_HOST;
> >>>>
> >>>> +       if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
> >>>> +               kvm_update_stolen_time(vcpu);
> >>>> +
> >>>>           return RESUME_GUEST;
> >>>>    }
> >>>>
> >>>> @@ -671,6 +785,9 @@ static int kvm_loongarch_vcpu_has_attr(struct kv=
m_vcpu *vcpu,
> >>>>           case KVM_LOONGARCH_VCPU_CPUCFG:
> >>>>                   ret =3D kvm_loongarch_cpucfg_has_attr(vcpu, attr);
> >>>>                   break;
> >>>> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
> >>>> +               ret =3D kvm_loongarch_pvtime_has_attr(vcpu, attr);
> >>>> +               break;
> >>>>           default:
> >>>>                   break;
> >>>>           }
> >>>> @@ -703,6 +820,9 @@ static int kvm_loongarch_vcpu_get_attr(struct kv=
m_vcpu *vcpu,
> >>>>           case KVM_LOONGARCH_VCPU_CPUCFG:
> >>>>                   ret =3D kvm_loongarch_get_cpucfg_attr(vcpu, attr);
> >>>>                   break;
> >>>> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
> >>>> +               ret =3D kvm_loongarch_pvtime_get_attr(vcpu, attr);
> >>>> +               break;
> >>>>           default:
> >>>>                   break;
> >>>>           }
> >>>> @@ -725,6 +845,9 @@ static int kvm_loongarch_vcpu_set_attr(struct kv=
m_vcpu *vcpu,
> >>>>           case KVM_LOONGARCH_VCPU_CPUCFG:
> >>>>                   ret =3D kvm_loongarch_cpucfg_set_attr(vcpu, attr);
> >>>>                   break;
> >>>> +       case KVM_LOONGARCH_VCPU_PVTIME_CTRL:
> >>>> +               ret =3D kvm_loongarch_pvtime_set_attr(vcpu, attr);
> >>>> +               break;
> >>>>           default:
> >>>>                   break;
> >>>>           }
> >>>> @@ -1084,6 +1207,7 @@ static int _kvm_vcpu_load(struct kvm_vcpu *vcp=
u, int cpu)
> >>>>
> >>>>           /* Control guest page CCA attribute */
> >>>>           change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
> >>>> +       kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
> >>>>
> >>>>           /* Don't bother restoring registers multiple times unless =
necessary */
> >>>>           if (vcpu->arch.aux_inuse & KVM_LARCH_HWCSR_USABLE)
> >>>> --
> >>>> 2.39.3
> >>>>
> >>
>
>

