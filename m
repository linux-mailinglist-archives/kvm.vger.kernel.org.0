Return-Path: <kvm+bounces-36600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 836E1A1C61E
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 03:17:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72109188853E
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 02:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DEE017B4FF;
	Sun, 26 Jan 2025 02:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NVCWzRTe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2A58828
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 02:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737857829; cv=none; b=MToS2npZfk7f6y4B0HxA+Oekn9mPaOKHGSfX4+m7utcXlrX9r3ZcK9Az1VbxUVRjBNRVchORebFEMIDaRa9XZd3JIdeqATdyT6UT1uJOm+rrMSp1T9Aw0vuYKYmNtncn2N+EUeZM937kpxP3PenK+C3YWc5pxMr3Zq5FMgmDri0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737857829; c=relaxed/simple;
	bh=K6OvjbgqkbA5CaKTVR7GLsx60H7pk7TnVFJoDViDpX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CVINkUQYGh4RemwVXkXQ1tU9USlS8IRE4GZeKmeOlPsj2d0H4DnyBOqRSCIXOnHbFrSLO/HG1+QfAmaTckja0LPVeD/RhNBrp6EmtKEA3mVsdBsifN8bj6jXX74x0oP/eQ5kAHth7+gjc60kMA0fil59X9cidWy61X63vkGZuQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NVCWzRTe; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6d8f65ef5abso27668606d6.3
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 18:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737857827; x=1738462627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tF1uyXTvwd6pArYohJui8Q+99jcuQAa9aISjfsvKWI=;
        b=NVCWzRTeI1hBeL3lmEp8DxzNfQep6IOmGd8zrSEK+yNtZKmoFB88MTRR8Qqaln+bg9
         CV1rJy1TDbTDGlzrcUZYqzAbJdbT+qX1P114JKzBA2FQh4w0qkhwxPjGfeenwgwtmMQv
         vOjC+9JCzE/JAvmi1g9ogr5uLwVUji7HoEYw+BFpB9O0Uz2zB/JcwRR8esz1amta1Vn0
         4FFnyvi2XcvezET3jcYYP8rOm4xvGs3RrbYqxphz6usy34piTcMhOsSneptJxagDVF5x
         +TtyzpZjZRpink3BDaMV32jj+73HU8DgVVlK/kpCjEmKwy/h4CO12GWonksAu/shfnrS
         Ai4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737857827; x=1738462627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tF1uyXTvwd6pArYohJui8Q+99jcuQAa9aISjfsvKWI=;
        b=u17SDIsLZTACcjVFee7ABTTuMPC9KBmKIQzZzSqArJGlBFl45BrhQiwPPoRxMVhdMY
         sA50QmvZhkvVv52766UZx9eMErLFqCGbiyun2CRn/Kb/DgQI010FPe+slAFN+919F0n2
         cMHZu5rJQ14iRDCWfrpnGKFMe+ccD5JlCbS8IRmTApcf1KwrRG3ZcychFB8ZwacJnSCv
         /xrUeaGTf6neTUtAwIhSAKwg8GU7JtcX17mFihl9nq8xKkwqbYhEkmpH/nxAPRHYmLpK
         HmuK1PVjL93labKlrlMAQBBltjPYZ1kVll6SuFiZ+JHHJ/qdOXLOUwpP4C/vPMCT8a96
         WGvA==
X-Forwarded-Encrypted: i=1; AJvYcCVq22DGdiLppmUwDRMV2NbhMWYxopsTQZj/CoDcc39Ads2PWyHt7kUz35TRjyGQmiS2NDY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5e9dhrfOShb2TfiDjantrLVQOf+iDaz0m5ItbCGa6RewgP6P3
	C3rxf0jKh3Oic/HiugqLdSUDw5d5iIGNWGQrCjigFQK8vp+28eG9aDVf7rjLUQOmdLVJ5lklUHO
	3mcQc6gbajhb5U7P0r0yDyZ79ev8=
X-Gm-Gg: ASbGnctqxEJLGZKQJcyJXAzX2XAq06vYRIG5s8iAj8ug2Ix3fpHNnpmE5EPnuvt2Qyl
	QbeDY1lLhnEArQ/UChnBK0rWDFRJR04pIwVMeoS+EZcNa/8g1+4wYlxlCBnLwP38D
X-Google-Smtp-Source: AGHT+IHDFDQBY8ixYmpcCPiuiey6kCqj87bSUeJhGbkmNhKVD7XRe0J9LOEMIOO+WBGld4FghYQxSHqWZtewJIpm9Tg=
X-Received: by 2002:a05:6214:27e2:b0:6d1:9e72:596a with SMTP id
 6a1803df08f44-6e1b21d8673mr561577096d6.37.1737857826650; Sat, 25 Jan 2025
 18:17:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain>
 <Z4qYrXJ4YtvpNztT@google.com> <pfx63yk5euw6zsjmmpuetfuhhk7jcann3trlirp6y5u26lljn7@mtbwoswzoae3>
 <Z5OzjYqOVz7nrnJ1@google.com>
In-Reply-To: <Z5OzjYqOVz7nrnJ1@google.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 26 Jan 2025 10:16:30 +0800
X-Gm-Features: AWEUYZmEerlnNPG-GFxy3fgJqGKAYAi-zTKU8TPbJMgkaqlN1b1LRRDLG2eEsYU
Message-ID: <CALOAHbCj6JMaiLau-tojKtOZoRRH1gzmsJ2FxSuNvOnTUr=X0A@mail.gmail.com>
Subject: Re: [bug report] KVM: x86: Unify TSC logic (sleeping in atomic?)
To: Sean Christopherson <seanjc@google.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025 at 11:36=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, Jan 24, 2025, Michal Koutn=C3=BD wrote:
> > On Fri, Jan 17, 2025 at 09:51:41AM -0800, Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > That's not the problematic commit.  This popped because commit 872290=
3cbb8f
> > > ("sched: Define sched_clock_irqtime as static key") in the tip tree t=
urned
> > > sched_clock_irqtime into a static key (it was a simple "int").
> > >
> > > https://lore.kernel.org/all/20250103022409.2544-2-laoar.shao@gmail.co=
m
> >
> > Thanks for the analysis, it's spot on. What a bad luck.
> >
> > Is there a precedent for static key switching in non-preemptible
> > contexts?
>
> Abuse static_key_deferred to push the patching to a workqueue?
>
> > More generally, why does KVM do this tsc check in vcpu_load?
>
> The logic triggers when a vCPU migrates to a different pCPU.  The code de=
tects
> that the case where TSC is inconsistent between pCPUs, and would cause ti=
me to go
> backwards from the guest's perspective.  E.g. TSC =3D X on CPU0, migrate =
to CPU1
> where TSC =3D X - Y.
>
> > Shouldn't possible unstability for that cpu be already checked and deci=
ded at
> > boot (regardless of KVM)? (Unless unstability itself is not stable prop=
erty.
> > Which means any previously measured IRQ times are skewed.)
>
> This isn't a problem that's unique to KVM.  The clocksource watchdog also=
 marks
> TSC unstable from non-preemptible context (presumably from IRQ context?)
>
>   clocksource_watchdog()
>   |
>   -> spin_lock(&watchdog_lock);
>      |
>      -> __clocksource_unstable()
>         |
>         -> clocksource.mark_unstable() =3D=3D tsc_cs_mark_unstable()
>            |
>            -> disable_sched_clock_irqtime()
>
> Uh, and sched_clock_register() toggles the static key on with IRQs disabl=
ed...
>
>         /* Cannot register a sched_clock with interrupts on */
>         local_irq_save(flags);
>
>         ...
>
>         /* Enable IRQ time accounting if we have a fast enough sched_cloc=
k() */
>         if (irqtime > 0 || (irqtime =3D=3D -1 && rate >=3D 1000000))
>                 enable_sched_clock_irqtime();
>
>         local_irq_restore(flags);
>
> > (Or a third option to revert the static-keyness if Yafang doesn't have
>
> Given there are issues all over the place, either a revert or a generic f=
ix.

It seems that introducing a generic fix for this static key change
might not be worth it. I=E2=80=99ll proceed with sending a revert.


--
Regards
Yafang

