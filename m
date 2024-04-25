Return-Path: <kvm+bounces-15889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F02158B19E7
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 06:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74ED0284C8C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 04:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A81F376EC;
	Thu, 25 Apr 2024 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wtJ1cnIq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C2E2C697
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 04:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714019092; cv=none; b=O11U99v50insLtkT5i4bGETwA9iHZ9f965CyIyp8+/SVwmE707qRwnZUJBDyg4WntRT9Bd4WbDFIfLW6Txthg5BWzxrqG+1hXUbjAosnOYb+ho5AygvjgPcUT8/Wyn2cXgR7XGPLxaDo9SOQ/K/1e5ZaIB0u2mjBqj1D5tFyBww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714019092; c=relaxed/simple;
	bh=vizLPpDz77XHtZLteOOI1a/fr6BKUXFJsNe42QhGao4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGCHo5mrv4FKbpJXsXQ97HmiU1vbmsbLCj6EZxpqOONrMeCXnJDsaA8uHMHms9ilmuUB9UN262AcqcwjUvvcEkafl9LFsKq1/5vEdTYT3Z1hEaGkLEDwZWa6fIMv2Qg4g3bxuUqxPT/fpZ+lUoUQDZ5fjvtUBNvzevWmYT2dgpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wtJ1cnIq; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51bab51e963so633033e87.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 21:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714019089; x=1714623889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IrvuwiS3D7ejDmTROQaAmlrQLvgYgyzhfvA7OnGDQQ=;
        b=wtJ1cnIqZcZ8WGxSMYDjNj8LyZciAEihxRh9DEHmyGnPncStbcRCicxPbFckXlPOlq
         OyrkbZiWl3+7G5uy9hYnL2m/9lXMoe8QyNTVSdZZz5GoQUOJiZH3SltF1T3mAPDwZXVD
         m7T0A0f1Kj1RGjXMzPTRF8/DBH0/r/dY3gTruv65ylO/lJW1kcisbmo3SRR5Cwf604pH
         87AyI9/dwsMG/3IY9McxaM8Xxwg/yGjnCxgnY65menyt7FwZ80stwzNiEsPcezH1DbVt
         dD9MfmXhZYG2mx5Ku3cDQwU/9P5/Wb/1fJKBBhj6yTwuuirePsrVMEYfPaNltvOGD+cY
         v0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714019089; x=1714623889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7IrvuwiS3D7ejDmTROQaAmlrQLvgYgyzhfvA7OnGDQQ=;
        b=XUjeS6kU5Q0KbPR4yWxLmHzvVaJF8BjA57FEVV1AMP369uInZMbm5MPP+GtF/CpD2J
         9zTcDzOezdBRZ4tzDmPUVwNb5cmJHDeTWfY9c/32LS0PZj8C3EcuopuTz4YQPlm/clrN
         OxH2vmKUM8SxIsZWaueMYWMSn67/4runON7JvIdSL+FrNbiskj636DFognI633CIKhS9
         KVk/pVJ2gaMd1Ph2Ee/0OeeaEu6vaJxam4HscY/XrdHzdRL7f63fGZD6sqxetsZgfbbd
         S9O+VoMaiXtPXo6ruSoG2L0bSX/3R2x+7iikaaxBkklJXKa2yz6G+Bo48SnWnI3hXHIm
         SqvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+GOngP9fyFhZFrp6CmyItno1Da2DXi8xhMQv8FJ7CknJ5FEA6Pqv4cXq+cqLNamCnZFuqRJeS24dZdcO1qlAt9Grr
X-Gm-Message-State: AOJu0Ywvie922Krn7hLQpoqpi7HipDRaetY27zUAUujlWNlIbUawxxcH
	W63oXAV9uf9k9kUzH9l4gz1MqsLZByPmumnXdOMy1qvstiwSmID4TXDJERdw3iCq96jqw8MFad8
	tRow2FcK5P4Myct8amLbwvCvrNZ8RDsWdBeSO
X-Google-Smtp-Source: AGHT+IEfUvui+52+qEcBDxTr1I+atQ6NoQjh90cU28I8b/8zvD7XHdTLRCq77QQHNVeBNssifFW7F7FKpHuLBaL/bns=
X-Received: by 2002:ac2:4841:0:b0:51a:cfca:ca3f with SMTP id
 1-20020ac24841000000b0051acfcaca3fmr2858795lfy.36.1714019088770; Wed, 24 Apr
 2024 21:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZiaX3H3YfrVh50cs@google.com> <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com> <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com> <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn> <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com> <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com>
In-Reply-To: <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Wed, 24 Apr 2024 21:24:12 -0700
Message-ID: <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, maobibo <maobibo@loongson.cn>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, peterz@infradead.org, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2024 at 8:56=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 4/24/2024 11:00 PM, Sean Christopherson wrote:
> > On Wed, Apr 24, 2024, Dapeng Mi wrote:
> >> On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
> >>>>> Maybe, (just maybe), it is possible to do PMU context switch at vcp=
u
> >>>>> boundary normally, but doing it at VM Enter/Exit boundary when host=
 is
> >>>>> profiling KVM kernel module. So, dynamically adjusting PMU context
> >>>>> switch location could be an option.
> >>>> If there are two VMs with pmu enabled both, however host PMU is not
> >>>> enabled. PMU context switch should be done in vcpu thread sched-out =
path.
> >>>>
> >>>> If host pmu is used also, we can choose whether PMU switch should be
> >>>> done in vm exit path or vcpu thread sched-out path.
> >>>>
> >>> host PMU is always enabled, ie., Linux currently does not support KVM
> >>> PMU running standalone. I guess what you mean is there are no active
> >>> perf_events on the host side. Allowing a PMU context switch drifting
> >>> from vm-enter/exit boundary to vcpu loop boundary by checking host
> >>> side events might be a good option. We can keep the discussion, but I
> >>> won't propose that in v2.
> >> I suspect if it's really doable to do this deferring. This still makes=
 host
> >> lose the most of capability to profile KVM. Per my understanding, most=
 of
> >> KVM overhead happens in the vcpu loop, exactly speaking in VM-exit han=
dling.
> >> We have no idea when host want to create perf event to profile KVM, it=
 could
> >> be at any time.
> > No, the idea is that KVM will load host PMU state asap, but only when h=
ost PMU
> > state actually needs to be loaded, i.e. only when there are relevant ho=
st events.
> >
> > If there are no host perf events, KVM keeps guest PMU state loaded for =
the entire
> > KVM_RUN loop, i.e. provides optimal behavior for the guest.  But if a h=
ost perf
> > events exists (or comes along), the KVM context switches PMU at VM-Ente=
r/VM-Exit,
> > i.e. lets the host profile almost all of KVM, at the cost of a degraded=
 experience
> > for the guest while host perf events are active.
>
> I see. So KVM needs to provide a callback which needs to be called in
> the IPI handler. The KVM callback needs to be called to switch PMU state
> before perf really enabling host event and touching PMU MSRs. And only
> the perf event with exclude_guest attribute is allowed to create on
> host. Thanks.

Do we really need a KVM callback? I think that is one option.

Immediately after VMEXIT, KVM will check whether there are "host perf
events". If so, do the PMU context switch immediately. Otherwise, keep
deferring the context switch to the end of vPMU loop.

Detecting if there are "host perf events" would be interesting. The
"host perf events" refer to the perf_events on the host that are
active and assigned with HW counters and that are saved when context
switching to the guest PMU. I think getting those events could be done
by fetching the bitmaps in cpuc. I have to look into the details. But
at the time of VMEXIT, kvm should already have that information, so it
can immediately decide whether to do the PMU context switch or not.

oh, but when the control is executing within the run loop, a
host-level profiling starts, say 'perf record -a ...', it will
generate an IPI to all CPUs. Maybe that's when we need a callback so
the KVM guest PMU context gets preempted for the host-level profiling.
Gah..

hmm, not a fan of that. That means the host can poke the guest PMU
context at any time and cause higher overhead. But I admit it is much
better than the current approach.

The only thing is that: any command like 'perf record/stat -a' shot in
dark corners of the host can preempt guest PMUs of _all_ running VMs.
So, to alleviate that, maybe a module parameter that disables this
"preemption" is possible? This should fit scenarios where we don't
want guest PMU to be preempted outside of the vCPU loop?

Thanks. Regards
-Mingwei

-Mingwei

>
>
> >
> > My original sketch: https://lore.kernel.org/all/ZR3eNtP5IVAHeFNC@google=
.com

