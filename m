Return-Path: <kvm+bounces-14360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E9078A221B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 01:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F6D21C233BB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FA847A74;
	Thu, 11 Apr 2024 23:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OFX64rYP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A4B481CE
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 23:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712876947; cv=none; b=aysKuYlgzwK3rtBqiZd15r47tl/Li8osvt+T50zg48S94fj5bfivAMEXP08RPdt0jhnkZGipaWvMLQuKGSm6epNShVDZdEU5AXLZCufm+ppz1J/OCpGSFxCGHT54s1jefvmVJnKG4/NmTDoN9y7S25yRElxMYzM786TiBY5Lz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712876947; c=relaxed/simple;
	bh=QWxPbywU79EbshCBlfa1l4nYQ1WLinyIfiyU/gvdwg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PWcchSp3Jvc6vjGQ0ugppURsiL21lBeack8HD+KyXbIiMq7zvSkCB7n5JhwcOhQ6AXgMHbFIMhBKYehiWuNflqq4SeiTVCMPyCL37wWXW9trR7KyGSNyZlxNJziyFOqoA31h3AYajWe2TbJmkox2qivFqXSeUn4KU2w/WBkOSBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OFX64rYP; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56e2e851794so2495a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712876944; x=1713481744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRt0Ft5K85BJFAwKY/YyFYZFShSHCAWggantBcv7H3Q=;
        b=OFX64rYPf0vwhnxPW/bkravmCuvhBR3+jaND6v6Qgzj8qj8QaLX07TILDCmK/F015h
         295Ipoa7N9o9RqdO1Qsmlpa+96yL43ALLt9qnSgltYRBI/fPdWAXnufqtvSkER4/atqX
         6+9E0lUwGsp7lyWdcZz8Vmu99eJFGb02gsYoUutF4u+9hzu9YGn+NtNVKjN07uYCopuX
         sakrkogzTh5NXBtpIBlxNBJsisRE0SlQs6s+xET8Y3z7ZmTE5jkPVKduhl/vciK60k39
         35gSsV7S4mmDKgDNBMauis58YhyBKZOXeYfGpRNvmzsrDJbL+QImSBrz1sHeNVZ4su+n
         ogyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712876944; x=1713481744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRt0Ft5K85BJFAwKY/YyFYZFShSHCAWggantBcv7H3Q=;
        b=WCyc/OoMKm8aevSZWIlwQ7yez01PkX0HYqdFZA06j6AhDTwyh6kUtehUyaLC23xIrd
         gY9q5NmoCckry+cHSihN8nqelvpgem06VbBJ4bsl+22usjHZ0zc3irN0a4XGBzpro97i
         0bfHxx1nHBXVsOuX6DMYht0OMypmCgAlca1fTa87dfOiXPiQM8IijPBSOFP/HnZITW4N
         om2FVRgCrl/CtMicxLzbqqHSTa6XwvxFZLLea4M4kyY4r2cS4nHYlRqOUEqUzgrfFzVI
         4MgWZ/itMgBegYLeWcRkdHhFpKZRu99DLz9TrmUtNKArTfEZvfW0KwO+3UnCGECAppcL
         w5DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVODtb3vX47gOQHEIfZ3Q+64KlvLe1Bd2QOp6IpqMiGpfvAiaJ/O2dIbVBZ4+mi+FQqz+h3JlmwfP3BON9/SSrwK7vC
X-Gm-Message-State: AOJu0Yz/fQvH3hVjD2UXKc/UExpw4DxVZaY+Xl86mElJVAuLBXcMzVu9
	TikgU65+OESdaOK1G57AvROZnTieRKkiihsyFmKmpYmqkZi0QKzzr1GBgNPyePv0hQo0NR3jjyc
	2JA99LLWx3G2OwjX6cDtb61Oqce84cwI9h5T2
X-Google-Smtp-Source: AGHT+IFie6kWXAuIKFD19BDQmEVuYkXyygSoVtc7g5k6fJ83evlUpB/kUdYyYkH1hFW80mrYrAAbpNBPLDkRavi0P4E=
X-Received: by 2002:a05:6402:2917:b0:56f:ce8d:8f9 with SMTP id
 ee23-20020a056402291700b0056fce8d08f9mr24010edb.3.1712876943905; Thu, 11 Apr
 2024 16:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-29-xiong.y.zhang@linux.intel.com> <ZhhcAT7XiLHK3ZNQ@google.com>
 <CALMp9eTQr8ndf48uHHDem2ZkycdhAuVqz18+V1reEEfv0sx8qg@mail.gmail.com> <ZhhqL2HKmcW9DAIY@google.com>
In-Reply-To: <ZhhqL2HKmcW9DAIY@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 11 Apr 2024 16:08:48 -0700
Message-ID: <CALMp9eQ+-wcj8QMmFR07zvxFF22-bWwQgV-PZvD04ruQ=0NBBA@mail.gmail.com>
Subject: Re: [RFC PATCH 28/41] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at
 VM boundary
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, mizhang@google.com, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com, 
	Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 3:54=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Apr 11, 2024, Jim Mattson wrote:
> > On Thu, Apr 11, 2024 at 2:54=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > > > +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_v=
mx *vmx)
> > > > +{
> > > > +     struct kvm_pmu *pmu =3D vcpu_to_pmu(&vmx->vcpu);
> > > > +     int i;
> > > > +
> > > > +     if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL=
_CTRL) {
> > > > +             pmu->global_ctrl =3D vmcs_read64(GUEST_IA32_PERF_GLOB=
AL_CTRL);
> > > > +     } else {
> > > > +             i =3D vmx_find_loadstore_msr_slot(&vmx->msr_autostore=
.guest,
> > > > +                                             MSR_CORE_PERF_GLOBAL_=
CTRL);
> > > > +             if (i < 0)
> > > > +                     return;
> > > > +             pmu->global_ctrl =3D vmx->msr_autostore.guest.val[i].=
value;
> > >
> > > As before, NAK to using the MSR load/store lists unless there's a *re=
ally* good
> > > reason I'm missing.
> >
> > The VM-exit control, "save IA32_PERF_GLOBAL_CTL," first appears in
> > Sapphire Rapids. I think that's a compelling reason.
>
> Well that's annoying.  When was PMU v4 introduced?  E.g. if it came in IC=
X, I'd
> be sorely tempted to make VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard requi=
rement.

Broadwell was v3. Skylake was v4.

> And has someone confirmed that the CPU saves into the MSR store list befo=
re
> processing VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL?

It's at the top of chapter 28 in volume 3 of the SDM.  MSRs may be
saved in the VM-exit MSR-store area before processor state is loaded
based in part on the host-state area and some VM-exit controls.
Anything else would be stupid. (Yes, I know that this is CPU design
we're talking about!)

