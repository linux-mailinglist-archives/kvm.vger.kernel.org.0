Return-Path: <kvm+bounces-14366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F392E8A2249
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 01:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BBC9284C22
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED05481DA;
	Thu, 11 Apr 2024 23:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cYUfy2lq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65723FE54
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 23:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878058; cv=none; b=H1rG64RnovwV6GC70zwu/nJzqgkDiNtaWBgX1SINYQdvvVNlhaodbzvzZ7lMneiE7+gkABdEU6wLD69aDYS7thLWroUlZdlZrvEk6yApB/BfhKYgW0aw4nK7JpCohgysxYIaMCa98Vh4gL4o8xzkwA8vkEbUTLHFG44UwCMLSDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878058; c=relaxed/simple;
	bh=WXBZQqqsaarwjKUtWbCLyxoQ0wuHM1oXknYiv1gdIxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UraPUwD382ZuD2Xkdk2/d8JwP3YAXJIiVcypN3dbHD4oJ643N38I7U9IFFRTB0H9fq011BF1sdWxEZIU0aVq6TRm1d7S768v5qyQlCDXGk34XPicOQGuWRCXriNgE9n0c4IezXxoBbKROcUqF7k3f6XExPa2E9p3Owdx1P6oTIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cYUfy2lq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a2c3543b85so303246a91.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 16:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712878056; x=1713482856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFDGv1Fd6zU3rOmtKT3KuxYcvY9ab+cz/ibHascQGAo=;
        b=cYUfy2lqPfw/DkpZ13vNJmHXZQTCC6Zs1Exi3HEwYO0RdhWvTffRkjahAIKanpqKs0
         aOpl+w07kOtiBTLqzTV5+dAzsIoOi01UJAwXYcMqAgbzGyWiLfa1KM7tK7/7ibrSVVZr
         2MhuQwXCdi2ufRTNnQjx6tYTMDIk0ioC3IpfSsTda2sNxVmAkdzUb56aH26vKbO9sx9R
         4jCPZN1Nn0Nti7qk3JfKDBVNR4acn225WFEQxY8ZZSYRTdDUHyzuk55DkmFNMJCMmJty
         ZrCojFYgdRZbMqVUmd8YIgVJHxbBc/uNS8OO7gG1vmJBSng4yN6ZN4fZT7I42Jphf4MX
         W2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712878056; x=1713482856;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pFDGv1Fd6zU3rOmtKT3KuxYcvY9ab+cz/ibHascQGAo=;
        b=sFHbooJpXgYtLFsIgaWJVr2+D0IwRmlnGm5UzHN/O5rJT5towjLow9p7Ks8l6hJnHz
         /+QVvFk0IqIgHMVFCY6K4PLgj1GlFzLWzaIeTUBCSCDSP2C4SJ8NL6HcIP3O2o/QbIJ7
         LONpXNOfFYMfYGN/BPVVBvlrqBtliWHP1Rkp878xCm+I/2bfvDpVhnEgC5eOJ66t77aF
         BpaTQDzsTMyYury+Dvq8DRSc9slLJnvpNqIo6fsszgVuAwzeILFobB0JMrai6MtY+8MH
         FVK97izIbMm/bznCHJ0ugNBxkgy6GsZ6TPH3am51IlcATp7629ASay5p8/ttdhiBZFju
         M8EA==
X-Forwarded-Encrypted: i=1; AJvYcCUBarP17jFzb99IW02TN4e5RkCi6GKql1+B8vpl8SEErR30R94Cw9VDjug8tMgb0kL7xLf9dpe69tTujsz6KVgbj0xz
X-Gm-Message-State: AOJu0Yyw7tKM7B8MMQrP4DqayuALHJyzvV75qfo1pPgT7LQt3fhnsvPa
	LyI46BKx4kLbvhLVtYihnJrm6Y2nuuenwYT5dulX7Wx+G71QgrnAJ19owC1rH0DKonTXF4fEhSs
	34Q==
X-Google-Smtp-Source: AGHT+IHOPUle01tphb/6y2S3tsH8BofFyFX2qx7QzBLhpYQSpujr88lDM743fofYZ5mNuJKPwWhGM/C5qF0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2c4e:b0:2a4:69fa:8b08 with SMTP id
 p14-20020a17090a2c4e00b002a469fa8b08mr2834pjm.4.1712878055952; Thu, 11 Apr
 2024 16:27:35 -0700 (PDT)
Date: Thu, 11 Apr 2024 16:27:34 -0700
In-Reply-To: <CALMp9eQ01NJZKKYt8XhTbnu8rNpuhpk388ocvyPqWJiO+sov5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-16-xiong.y.zhang@linux.intel.com> <ZhhUZJ7rE0SbE6Vv@google.com>
 <CALMp9eQ01NJZKKYt8XhTbnu8rNpuhpk388ocvyPqWJiO+sov5g@mail.gmail.com>
Message-ID: <Zhhx5kMSpksInMq9@google.com>
Subject: Re: [RFC PATCH 15/41] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
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
> On Thu, Apr 11, 2024 at 2:21=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > > +     if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
> > > +             /*
> > > +              * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm =
entry.
> > > +              */
> > > +             if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
> > > +                     vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
> > > +             else {
> > > +                     i =3D vmx_find_loadstore_msr_slot(&vmx->msr_aut=
oload.guest,
> > > +                                                    MSR_CORE_PERF_GL=
OBAL_CTRL);
> > > +                     if (i < 0) {
> > > +                             i =3D vmx->msr_autoload.guest.nr++;
> > > +                             vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT,
> > > +                                          vmx->msr_autoload.guest.nr=
);
> > > +                     }
> > > +                     vmx->msr_autoload.guest.val[i].index =3D MSR_CO=
RE_PERF_GLOBAL_CTRL;
> > > +                     vmx->msr_autoload.guest.val[i].value =3D 0;
> >
> > Eww, no.   Just make cpu_has_load_perf_global_ctrl() and VM_EXIT_SAVE_I=
A32_PERF_GLOBAL_CTRL
> > hard requirements for enabling passthrough mode.  And then have clear_a=
tomic_switch_msr()
> > yell if KVM tries to disable loading MSR_CORE_PERF_GLOBAL_CTRL.
>=20
> Weren't you just complaining about the PMU version 4 constraint in
> another patch? And here, you are saying, "Don't support anything older
> than Sapphire Rapids."

Heh, I didn't realize VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL was SPR+ when I wr=
ote
this, I thought it existed alongside the "load" controls.

> Sapphire Rapids has PMU version 4, so if we require
> VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, PMU version 4 is irrelevant.

