Return-Path: <kvm+bounces-802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 834E77E2A0E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3C021C2087D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33EF29409;
	Mon,  6 Nov 2023 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JX7NAUCp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D3628DA6
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:39:39 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FACDF3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 08:39:38 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7b9e83b70so32579347b3.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 08:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699288777; x=1699893577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s6GJqjPyHEWJBt2NqwShpg4qNSCTYad7QEEr5EefJZo=;
        b=JX7NAUCpiEM67qqL3gJDF7pnWLvohEjUq8tKurjUCCzjqmcjLSGWr95PQ3sY7zinEs
         F0UoHKaje/uy8AvKQGe0h8I0uB/I22CfoQkqTprQXXpBaN9YR1ulmi+ZWly75TtFCgpx
         RJak0HR94aZeY03pkGTbzwBUkTC7SICthPSi2JgzTrdXbjo4A6DpuDMwDwhepTgP1Fvp
         OKJ9MmNKuCN7nqyQYfP4wG7uiQfBQ+Ui8XfQXf+U/mk6qyfTuuwjwRTzd12laGVgiXuX
         Ainr92BlkiCmWil3bdlnn9C2eWVaBKjozR63WzZgMIJ3iRNgvaWcydhn6/0uKDp1OQsb
         blqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699288777; x=1699893577;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s6GJqjPyHEWJBt2NqwShpg4qNSCTYad7QEEr5EefJZo=;
        b=YVYprKzhu8PEr10VJgDLAPliCPpuu4SNyWywLICE0KX/sjWzbNO0nRUxBRCroA2jCT
         i6RJVrFbGq2ggDVrC+//I+Irm8OzGMx/8+1F7TsJsum9NJlpjb75GgCtqGaHLiH7Gtlc
         kSradpNyPqjyq6WXRR2Y3l192HqtuK931JUWsvELO62b3xL+fICR2Aa7bO4xy6k4371I
         evOrkbFZ1t4XYM4Do0lKVWLlWzb+1UGhkPmDRF12zjj7aelWqJEIi5NyvY52CXJle5Am
         tOgche7Rv5aqhm/IozOKh612PrlN90nD1h2YJ1xf3v9uuh177kISo4EgLJe1YNS+93hg
         bu3A==
X-Gm-Message-State: AOJu0Yx2FHR8Is/QiIu6Evyj/0sDZnPgSF1JUWYNvi0rglAoGqb+NduB
	gCvziwxlKjNP5iXoXCuHMnJ+vjzWsEo=
X-Google-Smtp-Source: AGHT+IHRkognXfPOdvQjyBzJ2BOeuuKhNfK1lGzPPKxyDcA2UY/godTNSWjPuOih8XOxcrUfx8DLuuZjasg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b64a:0:b0:5a7:d45d:1223 with SMTP id
 h10-20020a81b64a000000b005a7d45d1223mr243215ywk.3.1699288777668; Mon, 06 Nov
 2023 08:39:37 -0800 (PST)
Date: Mon, 6 Nov 2023 08:39:36 -0800
In-Reply-To: <CALMp9eRzvj_Ach=QySHgpkKO6z=42OJmC4DPU=tCTxcioFvZEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-12-seanjc@google.com>
 <CALMp9eRzvj_Ach=QySHgpkKO6z=42OJmC4DPU=tCTxcioFvZEw@mail.gmail.com>
Message-ID: <ZUkWyNBeaKiQrhiw@google.com>
Subject: Re: [PATCH v6 11/20] KVM: selftests: Test Intel PMU architectural
 events on fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 04, 2023, Jim Mattson wrote:
> On Fri, Nov 3, 2023 at 5:03=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >  static void guest_test_arch_event(uint8_t idx)
> >  {
> >         const struct {
> >                 struct kvm_x86_pmu_feature gp_event;
> > +               struct kvm_x86_pmu_feature fixed_event;
> >         } intel_event_to_feature[] =3D {
> > -               [INTEL_ARCH_CPU_CYCLES]            =3D { X86_PMU_FEATUR=
E_CPU_CYCLES },
> > -               [INTEL_ARCH_INSTRUCTIONS_RETIRED]  =3D { X86_PMU_FEATUR=
E_INSNS_RETIRED },
> > -               [INTEL_ARCH_REFERENCE_CYCLES]      =3D { X86_PMU_FEATUR=
E_REFERENCE_CYCLES },
> > -               [INTEL_ARCH_LLC_REFERENCES]        =3D { X86_PMU_FEATUR=
E_LLC_REFERENCES },
> > -               [INTEL_ARCH_LLC_MISSES]            =3D { X86_PMU_FEATUR=
E_LLC_MISSES },
> > -               [INTEL_ARCH_BRANCHES_RETIRED]      =3D { X86_PMU_FEATUR=
E_BRANCH_INSNS_RETIRED },
> > -               [INTEL_ARCH_BRANCHES_MISPREDICTED] =3D { X86_PMU_FEATUR=
E_BRANCHES_MISPREDICTED },
> > +               [INTEL_ARCH_CPU_CYCLES]            =3D { X86_PMU_FEATUR=
E_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
> > +               [INTEL_ARCH_INSTRUCTIONS_RETIRED]  =3D { X86_PMU_FEATUR=
E_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
> > +               /*
> > +                * Note, the fixed counter for reference cycles is NOT =
the same
> > +                * as the general purpose architectural event (because =
the GP
> > +                * event is garbage).  The fixed counter explicitly cou=
nts at
> > +                * the same frequency as the TSC, whereas the GP event =
counts
> > +                * at a fixed, but uarch specific, frequency.  Bundle t=
hem here
> > +                * for simplicity.
> > +                */
>=20
> Implementation-specific is not necessarily garbage, though it would be
> nice if there was a way to query the frequency rather than calibrating
> against another clock.

Heh, I'll drop the editorial commentry, though I still think an architectur=
al event
with implementation-specific behavior is garbage :-)

