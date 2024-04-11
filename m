Return-Path: <kvm+bounces-14353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CAB48A2133
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 23:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C91041C23C8B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47103CF65;
	Thu, 11 Apr 2024 21:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dv9A711f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E983AC08
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712872627; cv=none; b=JUPA4iSkuCea55xeVNL9nRyEOslpentj8dfZLXwR9BSIQMq6ywpHZ6pJyo5ayN2O2GeEVm0P5FUb8qCwndGGCb2mCHzp3ZdWaVLiz5ykwbeqTISKYcpuy7pvZfrrB15PifJg99ZoOk63YHkSBQAcSD+LaW73+jv7wPRZP/RcksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712872627; c=relaxed/simple;
	bh=+ZmTzQByvFIOG43ztGwvq/MFcJJJ50PhnkFNQc1T7RQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KE49+DxSkW7F2goJfQUPG9uQUKEvWE9iC/TjXT95iz27nXNOBX8YCCyX6RpB6TG15eRYor5XwR4HPlxzFw8g0Bxh25L84A/UZ+iFYH9yF++b7p8LN/fdfI5+t9vDo4HJWS8kcVYAGezCvdZ/oDGufNSMn7zawvz4ZpsKP8QkEwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dv9A711f; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-56e2e851794so1833a12.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712872625; x=1713477425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LR5h6hXBJ1ddFZtXvkQC/6wTnyda1YJpe8L7WAUAxYY=;
        b=dv9A711fREYxTL8m8l4v9+v8CO9l0QnhzqLAgdlqF23uUDMk7Ydu8rD7iu2UGtL7rW
         T0MM2Qty/H2MnApG9JESzr8nALvZk38XFc0VgxcABuV8OneFjIAWFzBmhbIbbwpVv3e5
         eeDCysjON4DdK07axIaeO2MlAw91Z5QUmGyU8nQhB8ynM6IzD/Fmr9ejVPCOVu5ZBOm2
         jLAWDLADPH9H9K4weJMLypOWGMkql4AWoBNtGq2xT1vVhRQJTq0tAHiEIOWl4bSVXBoI
         u7w8DlBQ89mazwJp0p8nUGjvS/EfOzi7AXa7KyjSSM5Ia1+7D8wqXpOllylPlOGenAqH
         9gLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712872625; x=1713477425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LR5h6hXBJ1ddFZtXvkQC/6wTnyda1YJpe8L7WAUAxYY=;
        b=rMDY9dkVOVhTCNx5NLad8+PX79HkjHWo/e+9wWGa8EajOFB+S5rSt/eU75K42k8MEL
         6adgr9ccuFowbt1ITJYNipas73DIYmbXqj3Eq+NXHi6O6u7NpmqFpj2YjghX907Pp1QR
         iRjUGJ3GRqIzvlhELxumCqdkKoID9YI/PuG9sa591EPF30weLe3jWA19xNt2wiSocqI8
         Lmmb1e6VRrPo31uDeiIfBpSzrWQUkmsucJlcC/KMT9fyRoRakq7J63SeP131O2EH0jqq
         jJ0lY3toS7lW8d4idPI0YaI3mNJFkL4Jv3tfj7T2bEzW39G8k/kZnnv+f1ZilqURpEtS
         QiRA==
X-Forwarded-Encrypted: i=1; AJvYcCUvJSdtM7+VlbJ4y93QzFC2vh+88ex/mu47/8nr5F+jIiS272JoOoj8Ele0a5i6nHfd3fMA/YkqFqYTUZTKxFyAjk2v
X-Gm-Message-State: AOJu0YyYuM8FSaD1bDxII+dtUbRzIBu1uipF9qUIBrgHXb7+17A9O1wP
	0g3G1OnHWCgIOncbG/L7CXFH0QPNsrnZuUi/3Z2eZe2ElV2X+wx1wyOCBMPxaOTbEcPkK5bqVKn
	bfl5fStJt0CYrroTuZr9jSCkAbLgvORpIN98b
X-Google-Smtp-Source: AGHT+IEA165d/e/1bv4Wcf6LIBv9KPpN4t3Usc83/fEPplec2kRP11rlTVrGIjWCzTVCsB/IHnLT6bNP0rAz4PWqDYo=
X-Received: by 2002:a50:ee9a:0:b0:56f:3a0b:8e05 with SMTP id
 f26-20020a50ee9a000000b0056f3a0b8e05mr60835edr.0.1712872624480; Thu, 11 Apr
 2024 14:57:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-25-xiong.y.zhang@linux.intel.com> <ZhhXxV3Z1UHLp1M1@google.com>
In-Reply-To: <ZhhXxV3Z1UHLp1M1@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 11 Apr 2024 14:56:52 -0700
Message-ID: <CALMp9eQeOnySY2d3p=H=uvH+tt0tONazPiLC4NQ-ReFjszX_3g@mail.gmail.com>
Subject: Re: [RFC PATCH 24/41] KVM: x86/pmu: Zero out unexposed
 Counters/Selectors to avoid information leakage
To: Sean Christopherson <seanjc@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, mizhang@google.com, kan.liang@intel.com, 
	zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com, 
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024 at 2:36=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > From: Mingwei Zhang <mizhang@google.com>
> >
> > Zero out unexposed counters/selectors because even though KVM intercept=
s
> > all accesses to unexposed PMU MSRs, it does pass through RDPMC instruct=
ion
> > which allows guest to read all GP counters and fixed counters. So, zero=
 out
> > unexposed counter values which might contain critical information for t=
he
> > host.
>
> This belongs in the previous patch, it's effectively a bug fix.  I apprec=
iate
> the push for finer granularity, but introducing a blatant bug and then im=
mediately
> fixing it goes too far.
>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.=
c
> > index f79bebe7093d..4b4da7f17895 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -895,11 +895,27 @@ static void intel_restore_pmu_context(struct kvm_=
vcpu *vcpu)
> >               wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, pmc->eventsel);
> >       }
> >
> > +     /*
> > +      * Zero out unexposed GP counters/selectors to avoid information =
leakage
> > +      * since passthrough PMU does not intercept RDPMC.
>
> Zeroing the selectors is unnecessary.  KVM still intercepts MSR_CORE_PERF=
_GLOBAL_CTRL,
> so just ensure the PMCs that aren't exposed the guest are globally enable=
d.
>
> > +      */
> > +     for (i =3D pmu->nr_arch_gp_counters; i < kvm_pmu_cap.num_counters=
_gp; i++) {
> > +             wrmsrl(MSR_IA32_PMC0 + i, 0);
> > +             wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + i, 0);
> > +     }
> > +
> >       wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl);
> >       for (i =3D 0; i < pmu->nr_arch_fixed_counters; i++) {
> >               pmc =3D &pmu->fixed_counters[i];
> >               wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, pmc->counter);
> >       }
> > +
> > +     /*
> > +      * Zero out unexposed fixed counters to avoid information leakage
> > +      * since passthrough PMU does not intercept RDPMC.
>
> I would call out that RDPMC interception is all or nothing, i.e. KVM can'=
t
> selectively intercept _some_ PMCs, and the MSR bitmaps don't apply to RDP=
MC.

Yes. RDPMC must be intercepted, unless KVM knows that all possible
PMCs are passthrough. It must also be intercepted if
enable_vmware_backdoor is true.

> > +      */
> > +     for (i =3D pmu->nr_arch_fixed_counters; i < kvm_pmu_cap.num_count=
ers_fixed; i++)
> > +             wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> >  }
> >
> >  struct kvm_pmu_ops intel_pmu_ops __initdata =3D {
> > --
> > 2.34.1
> >

