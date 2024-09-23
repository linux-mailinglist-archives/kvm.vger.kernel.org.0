Return-Path: <kvm+bounces-27319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 953F497F0D9
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 20:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03C07B21AFC
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 18:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A359C19F105;
	Mon, 23 Sep 2024 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RGuWv/Xo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74771FA5
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 18:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727117398; cv=none; b=CYkCpha9pt+Hei16BvrQd2zzJvweeNPy6TxyontfDa3/RQe7PctRPqDifK+70j4IUIbJvdsmJjnfFThKinxysEZD+OckOG6xZfJP+fRISh8qiuBaojpJlSG1QucZFczrDyuKtzmvOw4CwaE/Ru3pPYk3hO4o434GNq+eTVSEh4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727117398; c=relaxed/simple;
	bh=ZO9LXh5KHP0cU+65/5H2kZZJ/pKnjgCyTCgzqNWyjg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mc0KRDT1CTmEU/Jl/w4qMgEEQ6Y3DjAfuJkW8/3fzCltVm8QDLpVpw9KYYD6pAx3JupA57BfqPUvOqwPZc/c+j2QufveGvDNZGFnlPv2SAbgLmN2UGZzBMF2GA++eZDu8r7puMgPhdsTBZ91vGYrBW/uKM2UJqoIhOFQ2Mvp5QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RGuWv/Xo; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-53655b9bbcdso5458137e87.2
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 11:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727117395; x=1727722195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHEixKYgmrEI0xyHRhfjGRDQ/LAZ1TpNCXaxcaw46+w=;
        b=RGuWv/XoSwNe/CFlHhbSxTajCyxth7FcHtU428loFnThHtFpL6yiBvxE1pZpNdZwzP
         L3nAAy7C+f63/Ko/WvOgqeH1qABZLSNAdShnMyKs4Ju2Lr+PL5RZnBfCFgfYt+v/0KLI
         AytGQEPGkPtEMFlb+Bpb+3FCWpaFGq7sra6wGTc/SDqCJzz+OJQ87Gdq/BJJ19xUYYfd
         HdaWx8o3v6VHwNmhsxEgl9flMz0zi9BmecKwaeuBIjVuEdWGT3JhvQUtqF4kEfFb1oJz
         pPED/bIx261C6sFmZT1PGEuYgTEHsVdq+oAkkH6jVEGJE54ZFpRi0+2JPoE8g28gSb4Z
         wsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727117395; x=1727722195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHEixKYgmrEI0xyHRhfjGRDQ/LAZ1TpNCXaxcaw46+w=;
        b=LXPmGb5Nj4Oe1/fs1MLs6v/4VsO9d80S8cQmp49uVinoJj9SO56+g4asDWy6F/mE2w
         9WW37WrYCZahSRKQruYU4638yj9/E138WUpI2HgnUtSuEt/1Ohs5goijIlkDd44jVw9F
         qPl9yl4ddidFjchrbhLR9GwNw5Km8ix7qIltdKlG18srmAO4EqXIbz82cYovQREPyqYP
         C49aDdkZ73pUbULnjLkCupi7MwruKdr6I9AQKGE4KVBp7nIS54I7XaKCCLOLieaqQGcE
         SHGCKoaqtfz1ueySp0+3EOo2fboz3xa4DlvQki0/k5P7BASrmsD2MTHtkaHYkrrz0++X
         XAMw==
X-Forwarded-Encrypted: i=1; AJvYcCWffpUzkOFsTjx3dZ+r9tV8snoRsOfXN+O3dLzbGapJ0Rcibf22K1SMeGln4pf31Hbeh3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkY+cOFqvK/VJQz8VFSUqh9b0Z/uM/FEYxXneRTDSqjpr+wnx5
	g+O9bQ7ZtrVeX2gbI83JdgizUv28rI1+BuALfMyRz7MAkq2SEFWknRV041J4hKu239zxTxvgyBu
	Ut+guVKcmXp4tZC2IxHYtk5BvFgEBj/Vn5bO0
X-Google-Smtp-Source: AGHT+IFnxVySKGpDWSIEApW+kDI6injuSTM5sksPv0pnAsj22lsgtW/7QLMfV+gUo2KLV0zK5Eh0bhCvx1mn0OQ3ldI=
X-Received: by 2002:a05:6512:281c:b0:533:44a3:21b9 with SMTP id
 2adb3069b0e04-536acf6abdemr6263745e87.1.1727117394775; Mon, 23 Sep 2024
 11:49:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com> <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
 <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
In-Reply-To: <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Mon, 23 Sep 2024 20:49:17 +0200
Message-ID: <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Manali Shukla <manali.shukla@amd.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>, 
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2024 at 7:09=E2=80=AFAM Manali Shukla <manali.shukla@amd.co=
m> wrote:
>
> On 9/19/2024 6:30 PM, Liang, Kan wrote:
> >
> >
> > On 2024-09-19 2:02 a.m., Manali Shukla wrote:
> >> On 8/1/2024 10:28 AM, Mingwei Zhang wrote:
> >>> From: Kan Liang <kan.liang@linux.intel.com>
> >>>
> >>> There will be a dedicated interrupt vector for guests on some platfor=
ms,
> >>> e.g., Intel. Add an interface to switch the interrupt vector while
> >>> entering/exiting a guest.
> >>>
> >>> When PMI switch into a new guest vector, guest_lvtpc value need to be
> >>> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
> >>> bit should be cleared also, then PMI can be generated continuously
> >>> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
> >>> and switch_interrupt().
> >>>
> >>> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
> >>> be found. Since only one passthrough pmu is supported, we keep the
> >>> implementation simply by tracking the pmu as a global variable.
> >>>
> >>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> >>>
> >>> [Simplify the commit with removal of srcu lock/unlock since only one =
pmu is
> >>> supported.]
> >>>
> >>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >>> ---
> >>>  include/linux/perf_event.h |  9 +++++++--
> >>>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
> >>>  2 files changed, 41 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> >>> index 75773f9890cc..aeb08f78f539 100644
> >>> --- a/include/linux/perf_event.h
> >>> +++ b/include/linux/perf_event.h
> >>> @@ -541,6 +541,11 @@ struct pmu {
> >>>      * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
> >>>      */
> >>>     int (*check_period)             (struct perf_event *event, u64 va=
lue); /* optional */
> >>> +
> >>> +   /*
> >>> +    * Switch the interrupt vectors, e.g., guest enter/exit.
> >>> +    */
> >>> +   void (*switch_interrupt)        (bool enter, u32 guest_lvtpc); /*=
 optional */
> >>>  };
> >>>
> >>>  enum perf_addr_filter_action_t {
> >>> @@ -1738,7 +1743,7 @@ extern int perf_event_period(struct perf_event =
*event, u64 value);
> >>>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
> >>>  int perf_get_mediated_pmu(void);
> >>>  void perf_put_mediated_pmu(void);
> >>> -void perf_guest_enter(void);
> >>> +void perf_guest_enter(u32 guest_lvtpc);
> >>>  void perf_guest_exit(void);
> >>>  #else /* !CONFIG_PERF_EVENTS: */
> >>>  static inline void *
> >>> @@ -1833,7 +1838,7 @@ static inline int perf_get_mediated_pmu(void)
> >>>  }
> >>>
> >>>  static inline void perf_put_mediated_pmu(void)                     {=
 }
> >>> -static inline void perf_guest_enter(void)                  { }
> >>> +static inline void perf_guest_enter(u32 guest_lvtpc)               {=
 }
> >>>  static inline void perf_guest_exit(void)                   { }
> >>>  #endif
> >>>
> >>> diff --git a/kernel/events/core.c b/kernel/events/core.c
> >>> index 57ff737b922b..047ca5748ee2 100644
> >>> --- a/kernel/events/core.c
> >>> +++ b/kernel/events/core.c
> >>> @@ -422,6 +422,7 @@ static inline bool is_include_guest_event(struct =
perf_event *event)
> >>>
> >>>  static LIST_HEAD(pmus);
> >>>  static DEFINE_MUTEX(pmus_lock);
> >>> +static struct pmu *passthru_pmu;
> >>>  static struct srcu_struct pmus_srcu;
> >>>  static cpumask_var_t perf_online_mask;
> >>>  static struct kmem_cache *perf_event_cache;
> >>> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
> >>>
> >>> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
> >>> +{
> >>> +   /* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
> >>> +   if (!passthru_pmu)
> >>> +           return;
> >>> +
> >>> +   if (passthru_pmu->switch_interrupt &&
> >>> +       try_module_get(passthru_pmu->module)) {
> >>> +           passthru_pmu->switch_interrupt(enter, guest_lvtpc);
> >>> +           module_put(passthru_pmu->module);
> >>> +   }
> >>> +}
> >>> +
> >>>  /* When entering a guest, schedule out all exclude_guest events. */
> >>> -void perf_guest_enter(void)
> >>> +void perf_guest_enter(u32 guest_lvtpc)
> >>>  {
> >>>     struct perf_cpu_context *cpuctx =3D this_cpu_ptr(&perf_cpu_contex=
t);
> >>>
> >>> @@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
> >>>             perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
> >>>     }
> >>>
> >>> +   perf_switch_interrupt(true, guest_lvtpc);
> >>> +
> >>>     __this_cpu_write(perf_in_guest, true);
> >>>
> >>>  unlock:
> >>> @@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
> >>>     if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
> >>>             goto unlock;
> >>>
> >>> +   perf_switch_interrupt(false, 0);
> >>> +
> >>>     perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
> >>>     ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
> >>>     perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
> >>> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const=
 char *name, int type)
> >>>     if (!pmu->event_idx)
> >>>             pmu->event_idx =3D perf_event_idx_default;
> >>>
> >>> -   list_add_rcu(&pmu->entry, &pmus);
> >>> +   /*
> >>> +    * Initialize passthru_pmu with the core pmu that has
> >>> +    * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
> >>> +    */
> >>> +   if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
> >>> +           if (!passthru_pmu)
> >>> +                   passthru_pmu =3D pmu;
> >>> +
> >>> +           if (WARN_ONCE(passthru_pmu !=3D pmu, "Only one passthroug=
h PMU is supported\n")) {
> >>> +                   ret =3D -EINVAL;
> >>> +                   goto free_dev;
> >>> +           }
> >>> +   }
> >>
> >>
> >> Our intention is to virtualize IBS PMUs (Op and Fetch) using the same =
framework. However,
> >> if IBS PMUs are also using the PERF_PMU_CAP_PASSTHROUGH_VPMU capabilit=
y, IBS PMU registration
> >> fails at this point because the Core PMU is already registered with PE=
RF_PMU_CAP_PASSTHROUGH_VPMU.
> >>
> >
> > The original implementation doesn't limit the number of PMUs with
> > PERF_PMU_CAP_PASSTHROUGH_VPMU. But at that time, we could not find a
> > case of more than one PMU with the flag. After several debates, the
> > patch was simplified only to support one PMU with the flag.
> > It should not be hard to change it back.

The original implementation is by design having a terrible performance
overhead, ie., every PMU context switch at runtime requires a SRCU
lock pair and pmu list traversal. To reduce the overhead, we put
"passthrough" pmus in the front of the list and quickly exit the pmu
traversal when we just pass the last "passthrough" pmu.

I honestly do not like the idea because it is simply a hacky solution
with high maintenance cost, but I am not the right person to make the
call. So, if perf (kernel) subsystem maintainers are happy, I can
withdraw from this one.

My second point is: if you look at the details, the only reason why we
traverse the pmu list is to check if a pmu has implemented the
"switch_interrupt()" API. If so, invoke it, which will change the PMI
vector from NMI to a maskable interrupt for KVM. In AMD case, I bet
even if there are multiple passthrough pmus, only one requires
switching the interrupt vector. Let me know if this is wrong.

Thanks.
-Mingwei

> >
> > Thanks,
> > Kan
> >
>
> Yes, we have a use case to use mediated passthrough vPMU framework for IB=
S virtualization.
> So, we will need it.
>
> - Manali
>
> >>> +
> >>> +   list_add_tail_rcu(&pmu->entry, &pmus);
> >>>     atomic_set(&pmu->exclusive_cnt, 0);
> >>>     ret =3D 0;
> >>>  unlock:
> >>
> >>
>

