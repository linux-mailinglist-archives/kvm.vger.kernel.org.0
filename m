Return-Path: <kvm+bounces-520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E80B37E07E6
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 19:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42C36281CC3
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D061321342;
	Fri,  3 Nov 2023 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MuHx6ToR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8718626
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 18:03:11 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17C41B9
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 11:03:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da04fb79246so2704118276.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 11:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699034589; x=1699639389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yOW9lJ/pb/LNUWLip6vU1IMGdPjrtEEEy/T6WmZb0ws=;
        b=MuHx6ToRr9TAkxyM5dcLrxh5PWM/ET52FZ38tbYhn8Bf9Nor2QjlAjlCenK7hvnJo9
         JFYrW2zPioF0uDs+vLURWTrcyOhS9mSt+qhH6s27LL/VtM7SWXAUFl1BjWPQ2I40I9U/
         5eoM4Kz0mflCnnLB7WCC6zOzrHYFZUrPg/HTgKsuM6ScMZFMQTCSzKN1Zl/hueufHqkd
         W+VqQyW7gGE7qMniyblzpMdgYYZ1hX7efGo338vx+NfnqdcGyUAitd357s3oW5n5Ffxf
         2KcFaJVgiJ8ZmiMStoAiqS993dZpX4K8twQ9IinN2XPer7QkZOZWgy3H+mrdq7fUFgYN
         hD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699034589; x=1699639389;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yOW9lJ/pb/LNUWLip6vU1IMGdPjrtEEEy/T6WmZb0ws=;
        b=SiYDRRbU15JFC4hQE41RVVGLxoFjp6pFacf3+sRZtg+bOMeafsF3U3eHWwb+JfKZHQ
         i5nMRhSUoGRSh0/wMSU+OuCbgS3vILKDlerXbYFWmhYRdDRSTsqWkyHaX+sEKve8/isC
         VNHAZEyuvGWEG/LnqGBgumjz97lgUSK8rtZigFYt258vSfUGBCZvx/uGf7y1CYHhZUbr
         ChKSt69xIkWahZD9JWVt69i995mskE766SBrqn2zQ6lAwYoKXww4nHzGZoC/WV3lS8e+
         OXi+e/VmJ67fzXmNri+85qfClRAUb1ZpAoKXX0RhNfzLMtG5UelJTkFfhPuxmyVBRlNT
         IPug==
X-Gm-Message-State: AOJu0Yy9lIpbbkimPCI+bzYGc24Py3t7gouVa5Fu60yb6+n97e9t+Jmd
	nSsKfhjp7eFxv3nRv3nBQGX4WyDij+E=
X-Google-Smtp-Source: AGHT+IGSBg/O3LivVPjS+v6jcL60T1QSIGTzrjd2zPs8MafiMCI1rYqG76LlWrYEwyavu5jHKMZUEChBZaY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4dc2:0:b0:d9c:bdff:e45a with SMTP id
 a185-20020a254dc2000000b00d9cbdffe45amr380948ybb.12.1699034589126; Fri, 03
 Nov 2023 11:03:09 -0700 (PDT)
Date: Fri, 3 Nov 2023 11:03:07 -0700
In-Reply-To: <CALMp9eQkWtfppw2XemFpf2WT7PPpvPTuBjjmGbR6RP_i9mCENQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231031090613.2872700-2-dapeng1.mi@linux.intel.com>
 <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
 <c3f0e4ac-1790-40c1-a09e-209a09e3d230@linux.intel.com> <CALMp9eTDAiJ=Kuh7KkwdAY8x1BL2ZjdgFiPFRHXSSVCpcXp9rw@mail.gmail.com>
 <baa64cf4-11de-4581-89b6-3a86448e3a6e@linux.intel.com> <a14147e7-0b35-4fba-b785-ef568474c69b@linux.intel.com>
 <85706bd7-7df0-4d4b-932c-d807ddb14f9e@linux.intel.com> <CALMp9eS3NdTUnRrYPB+mMoGKj5NnsYXNUfUJX8Gv=wWCN4dkoQ@mail.gmail.com>
 <2004baa6-b494-462c-a11f-8104ea152c6a@linux.intel.com> <CALMp9eQkWtfppw2XemFpf2WT7PPpvPTuBjjmGbR6RP_i9mCENQ@mail.gmail.com>
Message-ID: <ZUU12-TUR_1cj47u@google.com>
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 03, 2023, Jim Mattson wrote:
> On Fri, Nov 3, 2023 at 8:13=E2=80=AFAM Liang, Kan <kan.liang@linux.intel.=
com> wrote:
> >
> >
> >
> > On 2023-11-02 1:45 p.m., Jim Mattson wrote:
> > > On Wed, Nov 1, 2023 at 7:07=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.i=
ntel.com> wrote:
> > >>
> > >>
> > >> On 11/1/2023 9:33 PM, Liang, Kan wrote:
> > >>>
> > >>> On 2023-10-31 11:31 p.m., Mi, Dapeng wrote:
> > >>>> On 11/1/2023 11:04 AM, Jim Mattson wrote:
> > >>>>> On Tue, Oct 31, 2023 at 6:59=E2=80=AFPM Mi, Dapeng
> > >>>>> <dapeng1.mi@linux.intel.com> wrote:
> > >>>>>> On 11/1/2023 2:22 AM, Jim Mattson wrote:
> > >>>>>>> On Tue, Oct 31, 2023 at 1:58=E2=80=AFAM Dapeng Mi
> > >>>>>>> <dapeng1.mi@linux.intel.com> wrote:
> > >>>>>>>> This patch adds support for the architectural topdown slots ev=
ent
> > >>>>>>>> which
> > >>>>>>>> is hinted by CPUID.0AH.EBX.
> > >>>>>>> Can't a guest already program an event selector to count event =
select
> > >>>>>>> 0xa4, unit mask 1, unless the event is prohibited by
> > >>>>>>> KVM_SET_PMU_EVENT_FILTER?
> > >>>>>> Actually defining this new slots arch event is to do the sanity =
check
> > >>>>>> for supported arch-events which is enumerated by CPUID.0AH.EBX.
> > >>>>>> Currently vPMU would check if the arch event from guest is suppo=
rted by
> > >>>>>> KVM. If not, it would be rejected just like intel_hw_event_avail=
able()
> > >>>>>> shows.
> > >>>>>>
> > >>>>>> If we don't add the slots event in the intel_arch_events[] array=
, guest
> > >>>>>> may program the slots event and pass the sanity check of KVM on =
a
> > >>>>>> platform which actually doesn't support slots event and program =
the
> > >>>>>> event on a real GP counter and got an invalid count. This is not
> > >>>>>> correct.
> > >>>>> On physical hardware, it is possible to program a GP counter with=
 the
> > >>>>> event selector and unit mask of the slots event whether or not th=
e
> > >>>>> platform supports it. Isn't KVM wrong to disallow something that =
a
> > >>>>> physical CPU allows?
> > >>>>
> > >>>> Yeah, I agree. But I'm not sure if this is a flaw on PMU driver. I=
f an
> > >>>> event is not supported by the hardware,  we can't predict the PMU'=
s
> > >>>> behavior and a meaningless count may be returned and this could mi=
slead
> > >>>> the user.
> > >>> The user can program any events on the GP counter. The perf doesn't
> > >>> limit it. For the unsupported event, 0 should be returned. Please k=
eep
> > >>> in mind, the event list keeps updating. If the kernel checks for ea=
ch
> > >>> event, it could be a disaster. I don't think it's a flaw.
> > >>
> > >>
> > >> Thanks Kan, it would be ok as long as 0 is always returned for
> > >> unsupported events. IMO, it's a nice to have feature that KVM does t=
his
> > >> sanity check for supported arch events, it won't break anything.
> > >
> > > The hardware PMU most assuredly does not return 0 for unsupported eve=
nts.
> > >
> > > For example, if I use host perf to sample event selector 0xa4 unit
> > > mask 1 on a Broadwell host (406f1), I get...
> >
> > I think we have different understanding about the meaning of the
> > "unsupported". There is no enumeration of the Architectural Topdown
> > Slots, which only means the Topdown Slots/01a4 is not an architectural
> > event on the platform. It doesn't mean that the event encoding is
> > unsupported. It could be used by another event, especially on the
> > previous platform.
>=20
> If the same event encoding could be used by a microarchitectural event
> on a prior platform, then it is *definitely* wrong for KVM to refuse
> to monitor the event just because it isn't enumerated as a supported
> architectural event.

+1000!  Thanks Kan, this is exactly the info we need!

I'll add a patch to build on "Always treat Fixed counters as available when
supported"[*] and rip out intel_hw_event_available().

[*] https://lore.kernel.org/all/20231024002633.2540714-4-seanjc@google.com

