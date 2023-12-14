Return-Path: <kvm+bounces-4535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D76C813B1A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 20:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF3D71F222A9
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 19:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F69F6A35B;
	Thu, 14 Dec 2023 19:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="f1uo5HYh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A363769794
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 19:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3b9e7f4a0d7so5885668b6e.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 11:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702583646; x=1703188446; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=whJNqJEvK2equSL1Yk+tP3TQhBfQ0dYWdrlrbsekLXg=;
        b=f1uo5HYhacHQM29wEytt4BCuaOs3nSnGdNN68mQiN3C9sRjhU8qDmOd+pdhr+jEWFa
         FdWYwgCp7lk8SdvbPq7u8GytcRg5d6vtY2tcQneCIjPQtBIthu5VXdQZ0CcnF8+WSx9G
         fpEnuxP5vMf3ufKmrd/mJTCA6YE2mY0CCsqe22C5MU4HMBxI8SHfA7826rCuKm5w2SfZ
         IXz8erUmGN09japhqPn24R5SbnlKh7EAIIn83K0MiGVTFbYjaI3Dv8tYNhR37bYOCYWO
         rDIPP7DR1At7928LenT7tH1qG2UmosbuufqBiA+4CrZUbgSsiuDfdjzq6ETFicCP6nEZ
         3RBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702583646; x=1703188446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=whJNqJEvK2equSL1Yk+tP3TQhBfQ0dYWdrlrbsekLXg=;
        b=PL1VlH/1OKvnpXzlD2rnbT5oxSrmpOgFWGaPdLO/lsMzJUKi6+zDRfLGqSIuFhhBpt
         WcTHtaPSi/lYiATdyE4QWYDESIv22drYrx0nUu6LtxrMNw7lhev7ttSemzTKCvjdCNeZ
         8kixAL2rEU5zKGpq2kdRJ+s7eu+M7asrd7SvBCdUNvqUS6ifc+vY1I08iU0k6nY0lCn7
         lPhGDb4sm8AZsviV3uqvIU8TTMrfR48JUPYvBom3TgfhzGt+SotfB1D3DgzwarJu3yN9
         vKPsSyJ2uW3xMPmDV/49qN6MhN5cGjDidDRroecJEpsrhkiMuYudNGlNmta/GxnYj4dl
         hdNw==
X-Gm-Message-State: AOJu0YyIM2a1kP5UiYH7bTnHTQ16vm0BGMuMcxgsnz2a/rg+NGL2LXUk
	mueFU/8pigJi9UawKr1M8m3e8vldaXZ6Fs7K0dxNMg==
X-Google-Smtp-Source: AGHT+IHaLrp5FbFQ3YpWs9+aTsAYCEx3GzWSlZGvk1xuyNLtqt4BpMhYleL1VDKPiiKksmT1W/bLP9mBsZ1SfhoaBUc=
X-Received: by 2002:a05:6870:219e:b0:203:27a5:cf21 with SMTP id
 l30-20020a056870219e00b0020327a5cf21mr3585305oae.26.1702583646337; Thu, 14
 Dec 2023 11:54:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
 <20231214024727.3503870-2-vineeth@bitbyteword.org> <877clhkqct.fsf@redhat.com>
In-Reply-To: <877clhkqct.fsf@redhat.com>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Thu, 14 Dec 2023 14:53:55 -0500
Message-ID: <CAO7JXPg9wN3SQOciAjVTn6fdgdpKA0CjaYg5UvXosYHT=1CeuA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] kvm: x86: MSR for setting up scheduler info
 shared memory
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Suleiman Souhlal <suleiman@google.com>, Masami Hiramatsu <mhiramat@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, 
	Joel Fernandes <joel@joelfernandes.org>, Ben Segall <bsegall@google.com>, 
	Borislav Petkov <bp@alien8.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Mel Gorman <mgorman@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 14, 2023 at 5:53=E2=80=AFAM Vitaly Kuznetsov <vkuznets@redhat.c=
om> wrote:
>
> "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> writes:
>
> > Implement a kvm MSR that guest uses to provide the GPA of shared memory
> > for communicating the scheduling information between host and guest.
> >
> > wrmsr(0) disables the feature. wrmsr(valid_gpa) enables the feature and
> > uses the gpa for further communication.
> >
> > Also add a new cpuid feature flag for the host to advertise the feature
> > to the guest.
> >
> > Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> > ---
> >  arch/x86/include/asm/kvm_host.h      | 25 ++++++++++++
> >  arch/x86/include/uapi/asm/kvm_para.h | 24 +++++++++++
> >  arch/x86/kvm/Kconfig                 | 12 ++++++
> >  arch/x86/kvm/cpuid.c                 |  2 +
> >  arch/x86/kvm/x86.c                   | 61 ++++++++++++++++++++++++++++
> >  include/linux/kvm_host.h             |  5 +++
> >  6 files changed, 129 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index f72b30d2238a..f89ba1f07d88 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -987,6 +987,18 @@ struct kvm_vcpu_arch {
> >       /* Protected Guests */
> >       bool guest_state_protected;
> >
> > +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> > +     /*
> > +      * MSR to setup a shared memory for scheduling
> > +      * information sharing between host and guest.
> > +      */
> > +     struct {
> > +             enum kvm_vcpu_boost_state boost_status;
> > +             u64 msr_val;
> > +             struct gfn_to_hva_cache data;
> > +     } pv_sched;
> > +#endif
> > +
> >       /*
> >        * Set when PDPTS were loaded directly by the userspace without
> >        * reading the guest memory
> > @@ -2217,4 +2229,17 @@ int memslot_rmap_alloc(struct kvm_memory_slot *s=
lot, unsigned long npages);
> >   */
> >  #define KVM_EXIT_HYPERCALL_MBZ               GENMASK_ULL(31, 1)
> >
> > +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> > +static inline bool kvm_arch_vcpu_pv_sched_enabled(struct kvm_vcpu_arch=
 *arch)
> > +{
> > +     return arch->pv_sched.msr_val;
> > +}
> > +
> > +static inline void kvm_arch_vcpu_set_boost_status(struct kvm_vcpu_arch=
 *arch,
> > +             enum kvm_vcpu_boost_state boost_status)
> > +{
> > +     arch->pv_sched.boost_status =3D boost_status;
> > +}
> > +#endif
> > +
> >  #endif /* _ASM_X86_KVM_HOST_H */
> > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/ua=
pi/asm/kvm_para.h
> > index 6e64b27b2c1e..6b1dea07a563 100644
> > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > @@ -36,6 +36,7 @@
> >  #define KVM_FEATURE_MSI_EXT_DEST_ID  15
> >  #define KVM_FEATURE_HC_MAP_GPA_RANGE 16
> >  #define KVM_FEATURE_MIGRATION_CONTROL        17
> > +#define KVM_FEATURE_PV_SCHED         18
> >
> >  #define KVM_HINTS_REALTIME      0
> >
> > @@ -58,6 +59,7 @@
> >  #define MSR_KVM_ASYNC_PF_INT 0x4b564d06
> >  #define MSR_KVM_ASYNC_PF_ACK 0x4b564d07
> >  #define MSR_KVM_MIGRATION_CONTROL    0x4b564d08
> > +#define MSR_KVM_PV_SCHED     0x4b564da0
> >
> >  struct kvm_steal_time {
> >       __u64 steal;
> > @@ -150,4 +152,26 @@ struct kvm_vcpu_pv_apf_data {
> >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> >  #define KVM_PV_EOI_DISABLED 0x0
> >
> > +/*
> > + * VCPU boost state shared between the host and guest.
> > + */
> > +enum kvm_vcpu_boost_state {
> > +     /* Priority boosting feature disabled in host */
> > +     VCPU_BOOST_DISABLED =3D 0,
> > +     /*
> > +      * vcpu is not explicitly boosted by the host.
> > +      * (Default priority when the guest started)
> > +      */
> > +     VCPU_BOOST_NORMAL,
> > +     /* vcpu is boosted by the host */
> > +     VCPU_BOOST_BOOSTED
> > +};
> > +
> > +/*
> > + * Structure passed in via MSR_KVM_PV_SCHED
> > + */
> > +struct pv_sched_data {
> > +     __u64 boost_status;
> > +};
> > +
> >  #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 89ca7f4c1464..dbcba73fb508 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -141,4 +141,16 @@ config KVM_XEN
> >  config KVM_EXTERNAL_WRITE_TRACKING
> >       bool
> >
> > +config PARAVIRT_SCHED_KVM
> > +     bool "Enable paravirt scheduling capability for kvm"
> > +     depends on KVM
> > +     help
> > +       Paravirtualized scheduling facilitates the exchange of scheduli=
ng
> > +       related information between the host and guest through shared m=
emory,
> > +       enhancing the efficiency of vCPU thread scheduling by the hyper=
visor.
> > +       An illustrative use case involves dynamically boosting the prio=
rity of
> > +       a vCPU thread when the guest is executing a latency-sensitive w=
orkload
> > +       on that specific vCPU.
> > +       This config enables paravirt scheduling in the kvm hypervisor.
> > +
> >  endif # VIRTUALIZATION
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 7bdc66abfc92..960ef6e869f2 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1113,6 +1113,8 @@ static inline int __do_cpuid_func(struct kvm_cpui=
d_array *array, u32 function)
> >                            (1 << KVM_FEATURE_POLL_CONTROL) |
> >                            (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> >                            (1 << KVM_FEATURE_ASYNC_PF_INT);
> > +             if (IS_ENABLED(CONFIG_PARAVIRT_SCHED_KVM))
> > +                     entry->eax |=3D (1 << KVM_FEATURE_PV_SCHED);
> >
> >               if (sched_info_on())
> >                       entry->eax |=3D (1 << KVM_FEATURE_STEAL_TIME);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 7bcf1a76a6ab..0f475b50ac83 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3879,6 +3879,33 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, st=
ruct msr_data *msr_info)
> >                       return 1;
> >               break;
> >
> > +#ifdef CONFIG_PARAVIRT_SCHED_KVM
> > +     case MSR_KVM_PV_SCHED:
> > +             if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED))
> > +                     return 1;
> > +
> > +             if (!(data & KVM_MSR_ENABLED))
> > +                     break;
> > +
> > +             if (!(data & ~KVM_MSR_ENABLED)) {
> > +                     /*
> > +                      * Disable the feature
> > +                      */
> > +                     vcpu->arch.pv_sched.msr_val =3D 0;
> > +                     kvm_set_vcpu_boosted(vcpu, false);
> > +             } if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
> > +                             &vcpu->arch.pv_sched.data, data & ~KVM_MS=
R_ENABLED,
> > +                             sizeof(struct pv_sched_data))) {
> > +                     vcpu->arch.pv_sched.msr_val =3D data;
> > +                     kvm_set_vcpu_boosted(vcpu, false);
> > +             } else {
> > +                     pr_warn("MSR_KVM_PV_SCHED: kvm:%p, vcpu:%p, "
> > +                             "msr value: %llx, kvm_gfn_to_hva_cache_in=
it failed!\n",
> > +                             vcpu->kvm, vcpu, data & ~KVM_MSR_ENABLED)=
;
>
> As this is triggerable by the guest please drop this print (which is not
> even ratelimited!). I think it would be better to just 'return 1;' in cas=
e
> of kvm_gfn_to_hva_cache_init() failure but maybe you also need to
> account for 'msr_info->host_initiated' to not fail setting this MSR from
> the host upon migration.
>
Makes sense, shall remove the pr_warn.
I hadn't thought about migration, thanks for bringing this up. Will
make modifications to account for migration as well.

Thanks,
Vineeth

