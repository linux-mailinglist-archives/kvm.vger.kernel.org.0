Return-Path: <kvm+bounces-14358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 343688A2200
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 00:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B38451F23E2F
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA17D487BC;
	Thu, 11 Apr 2024 22:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q1/m0iWf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9A224FA
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712876083; cv=none; b=LFSBtNmh1OSLJobpFFkifWP1Ll6MloSzhurdYFoQ6IuCV+GO33IuFAYEdG/YCRFl30DEoCyIMPn4PV/ycCcSVtEYLKP/XDR/09nTTDToaSUqYWiyuuHKn86zk9aJN3L6AIceN3P8WKb/8lOrUNseOwvGExm8/XnSBuHESQON4uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712876083; c=relaxed/simple;
	bh=FFF4qSI6uoBBrGIK3b9FdhqLuckQUcIQtIymnNKbd68=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MxglS3o7zrJpNrmVw87NSTX5JVY3wINBBP8BqEpJES/d4XUj2aoxIPJ0zsAY+xmDGdDfzUZfqbx6yItI1S8ErKZgX5K4xYnxfx1qCER3bz8hyjAPi4rCd6OuqsY8WzFkFsAZ6q6uJeAyCg7YINne6KvRDSXVt6K+PpQMgv7idv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q1/m0iWf; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so504802276.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 15:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712876080; x=1713480880; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x13dHL4gzEYkC5yKNBRYRVXjtZD/neiLlxBKsx/gpJ8=;
        b=Q1/m0iWf6n48oMA85o7SsuG2KOZVNmp1zhDFJG8KkaBUxRf7ZsKWmjON4/Vlsmqth3
         Y1y1Sgt6LCxttV9P3/hQA+R/n+UbAT3RuuOwYkNKgm1Oc7IxDmy6sHm4RHf0uisV2jeB
         zjCFo+ZL/uWAZnrKdtWOuRbrZxljF/Vaslm5KurmYlAvbowgu4OnTAe4rtoIM1/L2t+p
         ++UYVUtYq4BJWYVcTMrEf5ilrpapvTBEPE0pFstiGA9Tzlj+KPNTbaFLZdIVY50/3CnT
         vhrTyjp9WVxsxK3M7jOlTRGs1mSg8V9Vy8/WjqaLLbi7ydxyZOHoOdOQM4K6mpJ1QytK
         xQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712876080; x=1713480880;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x13dHL4gzEYkC5yKNBRYRVXjtZD/neiLlxBKsx/gpJ8=;
        b=nq7QLkme+gSDc50EBGHgU8ajgxLZqmNLDY7QtZpno/eV8iSa5aLQF1VCl6Ib6QALhA
         4mcCc6AQP8O0X6hoKZnOPWzaVg4YGMW5u0J/pSA7IYiaxHJyAb+L0/gPygSx8znE1LHW
         iyAv2VQn90yyTsuemqdZvhAL0SANY73B/K4Q/cCACmUGUA6O7pojTCCSliJ9kHjuphSN
         Z5SS/wtiPCgD1to0JgOh0UhF9T8OLAS4Shc68kkpZHcSIEyiZxeQLTDPfIHREmUZjFrv
         +EfRJhiJ4vSAzUbe+r27syN2qNbe014ukZNoxapGjLV2TLByh4gKNIoy8GqDbvXjCo5G
         IfFw==
X-Forwarded-Encrypted: i=1; AJvYcCUY9d2HT9GCuTaGdcMHD2CfV0LbE+C5BzdELw33qDd7rIFY0HRLGUDJBzwsgWNkDeIY8iQAQkGbsjd8DWxeArPA6aMA
X-Gm-Message-State: AOJu0YwUWWjN0D3yicqLAQdd8GfshIFK9YGRiSeDEaHQB5/UQmQFJEgN
	h2gSSu44SyJXrEXLraxdh9//L9Iyx9+TT9imB5IW0DkKMuVFb5AOBQS8LJZbjKoG7V0ciyPRSr2
	6qQ==
X-Google-Smtp-Source: AGHT+IFixyNI36LFe7Hw4/TMC13l5axHf3yR8MsrIgRSI6ngxDbATajr0w1q+zCA6CWz8k4CawvbbxVBV0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1386:0:b0:dcb:abcc:62be with SMTP id
 128-20020a251386000000b00dcbabcc62bemr238926ybt.6.1712876080655; Thu, 11 Apr
 2024 15:54:40 -0700 (PDT)
Date: Thu, 11 Apr 2024 15:54:39 -0700
In-Reply-To: <CALMp9eTQr8ndf48uHHDem2ZkycdhAuVqz18+V1reEEfv0sx8qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-29-xiong.y.zhang@linux.intel.com> <ZhhcAT7XiLHK3ZNQ@google.com>
 <CALMp9eTQr8ndf48uHHDem2ZkycdhAuVqz18+V1reEEfv0sx8qg@mail.gmail.com>
Message-ID: <ZhhqL2HKmcW9DAIY@google.com>
Subject: Re: [RFC PATCH 28/41] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at
 VM boundary
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, mizhang@google.com, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com, 
	Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024, Jim Mattson wrote:
> On Thu, Apr 11, 2024 at 2:54=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > > +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx=
 *vmx)
> > > +{
> > > +     struct kvm_pmu *pmu =3D vcpu_to_pmu(&vmx->vcpu);
> > > +     int i;
> > > +
> > > +     if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_C=
TRL) {
> > > +             pmu->global_ctrl =3D vmcs_read64(GUEST_IA32_PERF_GLOBAL=
_CTRL);
> > > +     } else {
> > > +             i =3D vmx_find_loadstore_msr_slot(&vmx->msr_autostore.g=
uest,
> > > +                                             MSR_CORE_PERF_GLOBAL_CT=
RL);
> > > +             if (i < 0)
> > > +                     return;
> > > +             pmu->global_ctrl =3D vmx->msr_autostore.guest.val[i].va=
lue;
> >
> > As before, NAK to using the MSR load/store lists unless there's a *real=
ly* good
> > reason I'm missing.
>=20
> The VM-exit control, "save IA32_PERF_GLOBAL_CTL," first appears in
> Sapphire Rapids. I think that's a compelling reason.

Well that's annoying.  When was PMU v4 introduced?  E.g. if it came in ICX,=
 I'd
be sorely tempted to make VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard require=
ment.

And has someone confirmed that the CPU saves into the MSR store list before
processing VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL?

Assuming we don't make VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL a hard requiremen=
t,
this code should be cleaned up and simplified.  It should be impossible to =
get
to this point with a passthrough PMU and no slot for saving guest GLOBAL_CT=
RL.

E.g. this could simply be:

	if (cpu_has_save_perf_global_ctrl())
		pmu->global_ctrl =3D vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
	else
		pmu->global_ctrl =3D *pmu->__global_ctrl;

where vmx_set_perf_global_ctrl() sets __global_ctrl to:

	pmu->__global_ctrl =3D &vmx->msr_autostore.guest.val[i].value;

KVM could store 'i', i.e. the slot, but in the end it's 4 bytes per vCPU (a=
ssuming
64-bit kernel, and an int to store the slot).

Oh, by the by, vmx_set_perf_global_ctrl() is buggy, as it neglects to *remo=
ve*
PERF_GLOBAL_CTRL from the lists if userspace sets CPUID multiple times.

