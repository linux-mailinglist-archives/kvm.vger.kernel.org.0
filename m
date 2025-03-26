Return-Path: <kvm+bounces-42073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A82A71FEA
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 21:11:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F24BF3B9417
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E332D1CD1F;
	Wed, 26 Mar 2025 20:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GXLjRvmZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE961253B79
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743019805; cv=none; b=nK5C1mLj30shO9DNgtOjtH6PeD9gld4UV0EH44E3V9RsaxL/3ZWvh/Gsi1T7k5ewrOxrPsZ7R1Cn7THlbiotZ/Huj2pghTqX0QjzF13PNHttfO+ovL4iwTc/Sf+V2AM+jp0ucaeUTdRNtMSHpK47YxroHuneQ8MyznbB/MQzBl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743019805; c=relaxed/simple;
	bh=Ag8lW0Ee30nrHHnKtUiBa06NaeDuCLEFAZmzJucTwuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eHuYj90vZO5R8+6Dxcn/J0O5jbI8tpuOD0ttJ4klKAQ3hxTTUm8dKby0VboFf1f840ZtN4AcLeux8iKg615D46r9vI6zg8R2t4dM8Cgo3zeDZwJdyn2uKNNCrUuq25p7gBcHmi+oIfhyMV1SD0qdQw4y6BijC3kSxNA64EldiXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GXLjRvmZ; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c542ffec37so29392085a.2
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 13:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743019802; x=1743624602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QpzfHBYhWUpsUZgJspeC/SaPXcwYDG9jrut2pHl/3X0=;
        b=GXLjRvmZhm9s9nUhh+DoncK/eqiVsfiLXRNlLOYKmMiPfZbjw6HjM6FcpKduqO5UK1
         zOlKUZS9OcxpO/JITm7kfODIsFdRzid20vXi/shhAQPrx+5QyS2QK0mhUKQYOBTbvIjc
         Y9O9vkcnTR71oSUsTbZ2srk2h+Hf+egY2F2dKqtpvQ+egRzKMBojuWfWdz677wW97FFP
         rtDZ4DbeojXCMya62MkdqN3F6BEFHWaazS1gfXNwDHdiCS4E0BnHUrhlCEsRZaA9C3k3
         6aTkunjgcD54oi/FSLMPxYhJlbk2HsdLxN9AmTefl2NRt+8ZC3OQefeI/2Zl55TNhJ4F
         XTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743019802; x=1743624602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QpzfHBYhWUpsUZgJspeC/SaPXcwYDG9jrut2pHl/3X0=;
        b=GSGibKuUoKyd/Mt9E7ePcLyg2seZCQWFJzDyvuviXyRZJqeuYNGBimbegBnQxU8MUn
         fnTPTv/xmwa9P3W4acT+jC0IVAyQrAPt+wG0BCYwiWGvjK/Xs8us7OyuHXHRLqwFt6ac
         0WstB8CSBQkLhjrB+KoOI8Q64qyWXVr5Li8WVXoGKMXa2BYuS0PgUQQG+nRr7BuptXGW
         DEnv7deIK5bZpp39f+5HlaG0S9VrWolgwLQRGiZZfrOM4TE6aGlfRd/zQiu2iEXcRGLW
         TnDN920EUn/BOMrjRh4pgmrmAU2tTfoA9pBRjH+PxgK4QrxaSfMLf+7IjZ+xVDeO9tgA
         eqKA==
X-Forwarded-Encrypted: i=1; AJvYcCUBROFkgXuijP+yKLiG3RLeD7JR5Oxe6Q6QvWCAKxya5KijL1ZS/CY26y+wseguzaHfbS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaEkVuWQEGypzcjvhL4vtK3vW13AjbQh6MpJ/wPtdNEnqlrLRm
	WBejMl+aSRgOcawbjHmxdmoLT+r9tbzlVRvEkVoMpkU7RXxl0/xPQiBOMKg476aE580lKhB1SzF
	bUY+fjwgjD6QFYBdWGL0LtoUcmGCD33xiuibY
X-Gm-Gg: ASbGnctsPQFCRyuN4jXyAEDH2CwX8FMhEgMi+Sguz9w+30AXF90h+aDj3g+mIQu5BzU
	orzhrm+gYgvsKfCcuId2cnBqntCqImtgjbkdEPt2FS0I5/m+OLDWmAtYrE2VEX/TCHSHbByXV/y
	pleXBWQ+SDnC91hCX/GAOioHlcOtw5
X-Google-Smtp-Source: AGHT+IH1TzlOPgvnqxhZbW0+a/Qg28Os3s9xAi7HFLJb4HykC2p6pqxgZdtm60nxAGnkOBbfh0dDzYZVD0aWO5W/8gc=
X-Received: by 2002:a05:6214:2507:b0:6e8:fa33:2969 with SMTP id
 6a1803df08f44-6ed238a5609mr10672636d6.10.1743019801352; Wed, 26 Mar 2025
 13:10:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-22-mizhang@google.com>
 <4d55c919-92ab-4bfe-a8c2-c0a756546f7c@intel.com>
In-Reply-To: <4d55c919-92ab-4bfe-a8c2-c0a756546f7c@intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Wed, 26 Mar 2025 13:09:24 -0700
X-Gm-Features: AQ5f1Jpcdu2iIGLEY__YZk5gVm28pOu2oG__DajpKikoWCPH2LKK5HVymiw7t9Y
Message-ID: <CAL715WLfr5k=Rz0cQ08xS=eHEyRn83PBTiqQ5H7iX4qH=jiS8A@mail.gmail.com>
Subject: Re: [PATCH v4 21/38] KVM: x86/pmu/vmx: Save/load guest
 IA32_PERF_GLOBAL_CTRL with vm_exit/entry_ctrl
To: "Chen, Zide" <zide.chen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Sandipan Das <sandipan.das@amd.com>, Eranian Stephane <eranian@google.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025 at 9:51=E2=80=AFAM Chen, Zide <zide.chen@intel.com> wr=
ote:
>
>
>
> On 3/24/2025 10:31 AM, Mingwei Zhang wrote:
> > From: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >
> > Intel processor (vmx) provides capability to save/load guest
> > IA32_PERF_GLOBAL_CTRL at vm-exit/vm-entry by setting
> > VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL bit in VM-exit-ctrl or
> > VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL bit in VM-entry-ctrl.
> >
> > Mediated vPMU leverages both capabilities to save/load guest
> > IA32_PERF_GLOBAL_CTRL automatically at vm-exit/vm-entry. Note that the
> > former was introduced in SapphireRapids and later Intel CPUs.
> >
> > If VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL is unavailable, mediated PMU will=
 be
> > disabled. Note that mediated PMU can be enabled by falling back to atom=
ic
> > msr save/retore list. However, that would cause extra overhead per
> > VM-enter/exit.
> >
> > Since these VMX capability bits perform automatic saving/restoring of t=
he
> > PMU global ctrl between VMCS and the HW MSR. No synchronization was
> > performed betwen HW MSR and pmu->global_ctrli, the KVM cached value .
> > Therefore, whenever KVM needs to use this variable, it will need to
> > explicitly read the value from MSR to pmu->global_ctrl. This is especia=
lly
> > so when guest doesn't own all PMU counters, i.e., when
> > IA32_PERF_GLOBAL_CTRL is interceped by mediated PMU.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > Co-developed-by: Mingwei Zhang <mizhang@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++++
> >  arch/x86/include/asm/vmx.h      |  1 +
> >  arch/x86/kvm/pmu.c              | 30 ++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/capabilities.h |  5 +++++
> >  arch/x86/kvm/vmx/nested.c       |  3 ++-
> >  arch/x86/kvm/vmx/pmu_intel.c    | 39 ++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++++++++-
> >  arch/x86/kvm/vmx/vmx.h          |  3 ++-
> >  8 files changed, 102 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 0b7af5902ff7..4b3bfefc2d05 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -553,6 +553,10 @@ struct kvm_pmu {
> >       unsigned available_event_types;
> >       u64 fixed_ctr_ctrl;
> >       u64 fixed_ctr_ctrl_rsvd;
> > +     /*
> > +      * kvm_pmu_sync_global_ctrl_from_vmcs() must be called to update
> > +      * this SW-maintained global_ctrl for mediated vPMU before access=
ing it.
> > +      */
> >       u64 global_ctrl;
> >       u64 global_status;
> >       u64 counter_bitmask[2];
> > diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> > index f7fd4369b821..48e137560f17 100644
> > --- a/arch/x86/include/asm/vmx.h
> > +++ b/arch/x86/include/asm/vmx.h
> > @@ -106,6 +106,7 @@
> >  #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
> >  #define VM_EXIT_PT_CONCEAL_PIP                       0x01000000
> >  #define VM_EXIT_CLEAR_IA32_RTIT_CTL          0x02000000
> > +#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL   0x40000000
> >
> >  #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR    0x00036dff
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 6ad71752be4b..4e8cefcce7ab 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -646,6 +646,30 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
> >       }
> >  }
> >
> > +static void kvm_pmu_sync_global_ctrl_from_vmcs(struct kvm_vcpu *vcpu)
> > +{
> > +     struct msr_data msr_info =3D { .index =3D MSR_CORE_PERF_GLOBAL_CT=
RL };
> > +
> > +     if (!kvm_mediated_pmu_enabled(vcpu))
> > +             return;
> > +
> > +     /* Sync pmu->global_ctrl from GUEST_IA32_PERF_GLOBAL_CTRL. */
> > +     kvm_pmu_call(get_msr)(vcpu, &msr_info);
> > +}
> > +
> > +static void kvm_pmu_sync_global_ctrl_to_vmcs(struct kvm_vcpu *vcpu, u6=
4 global_ctrl)
> > +{
> > +     struct msr_data msr_info =3D {
> > +             .index =3D MSR_CORE_PERF_GLOBAL_CTRL,
> > +             .data =3D global_ctrl };
> > +
> > +     if (!kvm_mediated_pmu_enabled(vcpu))
> > +             return;
> > +
> > +     /* Sync pmu->global_ctrl to GUEST_IA32_PERF_GLOBAL_CTRL. */
> > +     kvm_pmu_call(set_msr)(vcpu, &msr_info);
> > +}
> > +
> >  bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >  {
> >       switch (msr) {
> > @@ -680,7 +704,6 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct m=
sr_data *msr_info)
> >               msr_info->data =3D pmu->global_status;
> >               break;
> >       case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> > -     case MSR_CORE_PERF_GLOBAL_CTRL:
> >               msr_info->data =3D pmu->global_ctrl;
> >               break;
> >       case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
> > @@ -731,6 +754,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct m=
sr_data *msr_info)
>
>
> pmu->global_ctrl doesn't always have the up-to-date guest value, need to
> sync from vmcs/vmbc before comparing it against 'data'.
>
> +               kvm_pmu_sync_global_ctrl_from_vmcs(vcpu);
>                 if (pmu->global_ctrl !=3D data) {

Good catch. Thanks!

This is why I really prefer just unconditionally syncing the global
ctrl from VMCS to pmu->global_ctrl and vice versa.

We might get into similar problems as well in the future.

>
> >                       diff =3D pmu->global_ctrl ^ data;
> >                       pmu->global_ctrl =3D data;
> >                       reprogram_counters(pmu, diff);
> > +
> > +                     /* Propagate guest global_ctrl to GUEST_IA32_PERF=
_GLOBAL_CTRL. */
> > +                     kvm_pmu_sync_global_ctrl_to_vmcs(vcpu, data);
> >               }
> >               break;
> >       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> > @@ -907,6 +933,8 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u=
64 eventsel)
> >
> >       BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE !=3D X86_PM=
C_IDX_MAX);
> >
> > +     kvm_pmu_sync_global_ctrl_from_vmcs(vcpu);
> > +
> >       if (!kvm_pmu_has_perf_global_ctrl(pmu))
> >               bitmap_copy(bitmap, pmu->all_valid_pmc_idx, X86_PMC_IDX_M=
AX);
> >       else if (!bitmap_and(bitmap, pmu->all_valid_pmc_idx,
> > diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabil=
ities.h
> > index 013536fde10b..cc63bd4ab87c 100644
> > --- a/arch/x86/kvm/vmx/capabilities.h
> > +++ b/arch/x86/kvm/vmx/capabilities.h
> > @@ -101,6 +101,11 @@ static inline bool cpu_has_load_perf_global_ctrl(v=
oid)
> >       return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_=
CTRL;
> >  }
> >
> > +static inline bool cpu_has_save_perf_global_ctrl(void)
> > +{
> > +     return vmcs_config.vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CT=
RL;
> > +}
> > +
> >  static inline bool cpu_has_vmx_mpx(void)
> >  {
> >       return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 8a7af02d466e..ecf72394684d 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -7004,7 +7004,8 @@ static void nested_vmx_setup_exit_ctls(struct vmc=
s_config *vmcs_conf,
> >               VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> >               VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
> >               VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_E=
XIT |
> > -             VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> > +             VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> > +             VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
> >
> >       /* We support free control of debug control saving. */
> >       msrs->exit_ctls_low &=3D ~VM_EXIT_SAVE_DEBUG_CONTROLS;
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.=
c
> > index 2a5f79206b02..04a893e56135 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -294,6 +294,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu=
, struct msr_data *msr_info)
> >       u32 msr =3D msr_info->index;
> >
> >       switch (msr) {
> > +     case MSR_CORE_PERF_GLOBAL_CTRL:
> > +             if (kvm_mediated_pmu_enabled(vcpu))
> > +                     pmu->global_ctrl =3D vmcs_read64(GUEST_IA32_PERF_=
GLOBAL_CTRL);
> > +             msr_info->data =3D pmu->global_ctrl;
> > +             break;
> >       case MSR_CORE_PERF_FIXED_CTR_CTRL:
> >               msr_info->data =3D pmu->fixed_ctr_ctrl;
> >               break;
> > @@ -339,6 +344,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu=
, struct msr_data *msr_info)
> >       u64 reserved_bits, diff;
> >
> >       switch (msr) {
> > +     case MSR_CORE_PERF_GLOBAL_CTRL:
> > +             if (kvm_mediated_pmu_enabled(vcpu))
> > +                     vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> > +                                  pmu->global_ctrl);
> > +             break;
> >       case MSR_CORE_PERF_FIXED_CTR_CTRL:
> >               if (data & pmu->fixed_ctr_ctrl_rsvd)
> >                       return 1;
> > @@ -558,10 +568,37 @@ static void __intel_pmu_refresh(struct kvm_vcpu *=
vcpu)
> >
> >  static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
> >  {
> > +     struct kvm_pmu *pmu =3D vcpu_to_pmu(vcpu);
> > +     struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > +     bool mediated;
> > +
> >       __intel_pmu_refresh(vcpu);
> >
> > -     exec_controls_changebit(to_vmx(vcpu), CPU_BASED_RDPMC_EXITING,
> > +     exec_controls_changebit(vmx, CPU_BASED_RDPMC_EXITING,
> >                               !kvm_rdpmc_in_guest(vcpu));
> > +
> > +     mediated =3D kvm_mediated_pmu_enabled(vcpu);
> > +     if (cpu_has_load_perf_global_ctrl()) {
> > +             vm_entry_controls_changebit(vmx,
> > +                     VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, mediated);
> > +             /*
> > +              * Initialize guest PERF_GLOBAL_CTRL to reset value as SD=
M rules.
> > +              *
> > +              * Note: GUEST_IA32_PERF_GLOBAL_CTRL must be initialized =
to
> > +              * "BIT_ULL(pmu->nr_arch_gp_counters) - 1" instead of pmu=
->global_ctrl
> > +              * since pmu->global_ctrl is only be initialized when gue=
st
> > +              * pmu->version > 1. Otherwise if pmu->version is 1, pmu-=
>global_ctrl
> > +              * is 0 and guest counters are never really enabled.
> > +              */
> > +             if (mediated)
> > +                     vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> > +                                  BIT_ULL(pmu->nr_arch_gp_counters) - =
1);
> > +     }
> > +
> > +     if (cpu_has_save_perf_global_ctrl())
> > +             vm_exit_controls_changebit(vmx,
> > +                     VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
> > +                     VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, mediated);
> >  }
> >
> >  static void intel_pmu_init(struct kvm_vcpu *vcpu)
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index ff66f17d6358..38ecf3c116bd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4390,6 +4390,13 @@ void vmx_set_constant_host_state(struct vcpu_vmx=
 *vmx)
> >
> >       if (cpu_has_load_ia32_efer())
> >               vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
> > +
> > +     /*
> > +      * Initialize host PERF_GLOBAL_CTRL to 0 to disable all counters
> > +      * immediately once VM exits. Mediated vPMU then call perf_guest_=
exit()
> > +      * to re-enable host perf events.
> > +      */
> > +     vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
> >  }
> >
> >  void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
> > @@ -4457,7 +4464,8 @@ static u32 vmx_get_initial_vmexit_ctrl(void)
> >                                VM_EXIT_CLEAR_IA32_RTIT_CTL);
> >       /* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically *=
/
> >       return vmexit_ctrl &
> > -             ~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_=
EFER);
> > +             ~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_=
EFER |
> > +               VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL);
> >  }
> >
> >  void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> > @@ -7196,6 +7204,9 @@ static void atomic_switch_perf_msrs(struct vcpu_v=
mx *vmx)
> >       struct perf_guest_switch_msr *msrs;
> >       struct kvm_pmu *pmu =3D vcpu_to_pmu(&vmx->vcpu);
> >
> > +     if (kvm_mediated_pmu_enabled(&vmx->vcpu))
> > +             return;
> > +
> >       pmu->host_cross_mapped_mask =3D 0;
> >       if (pmu->pebs_enable & pmu->global_ctrl)
> >               intel_pmu_cross_mapped_check(pmu);
> > @@ -8451,6 +8462,15 @@ __init int vmx_hardware_setup(void)
> >               enable_sgx =3D false;
> >  #endif
> >
> > +     /*
> > +      * All CPUs that support a mediated PMU are expected to support l=
oading
> > +      * and saving PERF_GLOBAL_CTRL via dedicated VMCS fields.
> > +      */
> > +     if (enable_mediated_pmu &&
> > +         (WARN_ON_ONCE(!cpu_has_load_perf_global_ctrl() ||
> > +                       !cpu_has_save_perf_global_ctrl())))
> > +             enable_mediated_pmu =3D false;
> > +
> >       /*
> >        * set_apic_access_page_addr() is used to reload apic access
> >        * page upon invalidation.  No need to do anything if not
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 5c505af553c8..b282165f98a6 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -510,7 +510,8 @@ static inline u8 vmx_get_rvi(void)
> >              VM_EXIT_LOAD_IA32_EFER |                                 \
> >              VM_EXIT_CLEAR_BNDCFGS |                                  \
> >              VM_EXIT_PT_CONCEAL_PIP |                                 \
> > -            VM_EXIT_CLEAR_IA32_RTIT_CTL)
> > +            VM_EXIT_CLEAR_IA32_RTIT_CTL |                            \
> > +            VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)
> >
> >  #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL                   \
> >       (PIN_BASED_EXT_INTR_MASK |                                      \
>

