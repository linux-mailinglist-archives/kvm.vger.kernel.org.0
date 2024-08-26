Return-Path: <kvm+bounces-25068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0276D95F90E
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3208E1C21B00
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 18:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DBC195FE3;
	Mon, 26 Aug 2024 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZL9Uahdq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85A22C1AC
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724697423; cv=none; b=uHiOGR+ZYh15/x0offwmWy9auZQ8gm3zvljC+12BcOv6pbXx7VCVISeoW/UJlamPXFWqdTtH+YdXABBeFd6uGiUWSfaQuXon2+8ucnmj99JkO0yeB5CK52bxQGeFXttHB/6xRHFRwUDNyHal7jVmc61W9pvkWuEnxxqV+HuLNSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724697423; c=relaxed/simple;
	bh=F2bGAIq/SyQpHRmW+WdYNDuv2v4vSNVtj2Hj/PYXPP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qQRHE7AHgVvr/LCNwEKRpuaea84zYz8CusnKmsdEvo2Kf6t2woSQEWqyuXg+vrx5OlmagAvk18yMWWtn7VFw/P7dVIqrdceJXkDepRdJYlTpUUaxwQLFw7q3Vq45avWEO/c8KL2XqDte+SueT67d8A+iM1XkwarwvjVqFT6Ydt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZL9Uahdq; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-44fee2bfd28so45671cf.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 11:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724697420; x=1725302220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vURFcU6ADDOTmVhDKyrAk3cPd0Fm2lk/LqgZ0w5nVng=;
        b=ZL9UahdqL+r2tCJMhQBmjrauvFKd6Z57+wLWz8/4LokwHR6PoG+2RY1eKlyle7E94B
         4y0alcS5nW/0xOYwdZ2fCKq5wpfMHBKEGh5aHuhxUHQk5lPqkuhBFXIOMiR8+28wXnC3
         bdu31NcPa6UeqiIoUYE/O6Dz2Nx9+Y755HXKgkSWRDvTFbd/QsIJ18p2DwL2px91iDBw
         DVhdBL+WIsiHI4eF0ravWgosJUueg0fD7YD9JrXpgVLZw5YvQdPTdfenFt3heTi5gLkW
         Os35DD+qFureawAcPD3REGXh1sRcJW3UlDmwwGdEJjgCdIVF2kLikUli1qRQ5/+O12Ae
         BXgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724697420; x=1725302220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vURFcU6ADDOTmVhDKyrAk3cPd0Fm2lk/LqgZ0w5nVng=;
        b=AJEIEKFoXyIfuCt0Y/gE1tpjLGaoVhtsAoqpFNI63IY+j7ocm2/BXMvYBShFP95FNP
         OjBFigBlEZ3E17+rXEdNt+lwZ5ZLMogUd/2oOntDfpwEz8yuNNJ4aYHhKN16BTVQoNbg
         +yBgwGol4kfBZsJRZGmjyjD6vusjY3y2EKpNk6E4oq7vG+yMKYdq/P1bNVARBFkY1M87
         GH4W4hvHtg3h7aj2IYaTUO8CsTbG5JOiUHY0eVW9/Q0bSoIeIZw/Iv4Kbdt+8eoCcRPt
         PdMhMy8QDQfM89aZ0T9uEkLE3lEr+/FO+JdeuqJ7oqBRjM6fuQ2U3mNQEnZVdjsjQbYI
         /w6g==
X-Forwarded-Encrypted: i=1; AJvYcCUhSc//gglH2HbkLwKiKHkUspIMmWk6fLiAZ2nK0kXuyKlEbhG+OPSxseirfGfu+8M7tWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLAQRzWrvC/tNPl+gjCuPeimbnPdbP/5+LcubeEJ2xaYLqNwhA
	Ylx5/DhGGYV7AiCYucg37jbglpUTk+KcIhMylufnag9X1BhTlV3+7RMlqKElOoNC7KkDoPJmfhU
	mYfyk9OPwL/WccPPfOJ5LSX9HKd0YCYyr3pFi
X-Google-Smtp-Source: AGHT+IF3dJs7l5g9ShNm59a0pA4JxT8pFbJ2+vwM3A3c1BJbeVOik5qd+MFiTJHOsSiPTXA6CyLZz9k3PDK+gUlIZdE=
X-Received: by 2002:a05:622a:53ce:b0:447:d555:7035 with SMTP id
 d75a77b69052e-45661e10d73mr281211cf.13.1724697420350; Mon, 26 Aug 2024
 11:37:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
 <20240703095712.64202-7-dapeng1.mi@linux.intel.com> <CALMp9eSEuA70itad7oQUo=Ak6MVJYLo4kG4zJwEXkiUG6MgdnA@mail.gmail.com>
 <cea61aab-3feb-4008-adb9-2f2645589714@linux.intel.com>
In-Reply-To: <cea61aab-3feb-4008-adb9-2f2645589714@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 26 Aug 2024 11:36:49 -0700
Message-ID: <CALMp9eT2pc0qDaySuyNcHr5+tO4gfvrqmYo=a3Ay-0=rfhiksg@mail.gmail.com>
Subject: Re: [Patch v5 06/18] x86: pmu: Add asserts to warn inconsistent fixed
 events and counters
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 25, 2024 at 11:56=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel=
.com> wrote:
>
>
> On 8/23/2024 2:22 AM, Jim Mattson wrote:
> > On Tue, Jul 2, 2024 at 7:12=E2=80=AFPM Dapeng Mi <dapeng1.mi@linux.inte=
l.com> wrote:
> >> Current PMU code deosn't check whether PMU fixed counter number is
> >> larger than pre-defined fixed events. If so, it would cause memory
> >> access out of range.
> >>
> >> So add assert to warn this invalid case.
> >>
> >> Reviewed-by: Mingwei Zhang <mizhang@google.com>
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> ---
> >>  x86/pmu.c | 10 ++++++++--
> >>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/x86/pmu.c b/x86/pmu.c
> >> index b4de2680..3e0bf3a2 100644
> >> --- a/x86/pmu.c
> >> +++ b/x86/pmu.c
> >> @@ -113,8 +113,12 @@ static struct pmu_event* get_counter_event(pmu_co=
unter_t *cnt)
> >>                 for (i =3D 0; i < gp_events_size; i++)
> >>                         if (gp_events[i].unit_sel =3D=3D (cnt->config =
& 0xffff))
> >>                                 return &gp_events[i];
> >> -       } else
> >> -               return &fixed_events[cnt->ctr - MSR_CORE_PERF_FIXED_CT=
R0];
> >> +       } else {
> >> +               unsigned int idx =3D cnt->ctr - MSR_CORE_PERF_FIXED_CT=
R0;
> >> +
> >> +               assert(idx < ARRAY_SIZE(fixed_events));
> > Won't this assertion result in a failure on bare metal, for CPUs
> > supporting fixed counter 3?
>
> Yes, this is intended use. Currently KVM vPMU still doesn't support fixed
> counter 3. If it's supported in KVM vPMU one day but forget to add
> corresponding support in this pmu test, this assert would remind this.

These tests are supposed to run (and pass) on bare metal. Hence, they
should not be dependent on a non-architectural quirk of the KVM
implementation.

Perhaps a warning would serve as a reminder?

>
> >
> >> +               return &fixed_events[idx];
> >> +       }
> >>
> >>         return (void*)0;
> >>  }
> >> @@ -740,6 +744,8 @@ int main(int ac, char **av)
> >>         printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
> >>         printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
> >>
> >> +       assert(pmu.nr_fixed_counters <=3D ARRAY_SIZE(fixed_events));
> >> +
> > And this one as well?
> >
> >>         apic_write(APIC_LVTPC, PMI_VECTOR);
> >>
> >>         check_counters();
> >> --
> >> 2.40.1
> >>

