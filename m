Return-Path: <kvm+bounces-21972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E372937D2F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 22:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1A541F21D35
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 20:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BB4148FE5;
	Fri, 19 Jul 2024 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yAmp35b/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71B814883B
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 20:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721420104; cv=none; b=dR2pVe6vRjTOAkcB1UQLKqphhKKIbv3UinLebMOWZg/FZw4dKRuBbQb2eBXnYp9Ph92Vbttwc2zMiMpZOtD5W5h7Ev6ZqDV+9rD+UT4DKM1MEVoSgk7ihTSz8Er3A5yZGYUibjJgyNivVGaii04g73YQ0hy8DodCXTCHmiYKpxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721420104; c=relaxed/simple;
	bh=hrVOSBAPxCjK3O4kjJZDIYEe2p6huW8SI+6E7CjOWL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rvPnXK0BXaDuMjHvjwA6uqyTZuGT3H3szV2Aj29RdrNTCRVYdTP2HMI/Z2VDOIREBoFCFfwM36faC/LWIK+nVz/TnRvNthbBC0sbl4MZ39Uc6Fp9lnqt2/m2/ewvxSiFcvgJpJOfS9X80C3dhlSb6gLsC6gxprVYm52GCK345eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yAmp35b/; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fd7509397bso72175ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 13:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721420102; x=1722024902; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWJCFjgtMNgtozAYiAr2A+KBfeO3km1iv1DnIaZsGgQ=;
        b=yAmp35b/rML78mnEthxIJE/0E237s/daf0h0N3q4wVDIj3IBf+tl3+9gvr8UHJtoFW
         jQU3rI4ZIpQ8sCMU4zvZxwH5SJuKn3gVAQGcJEF3OxOWMf/xs1ox4q+bM0LtQom1AUws
         Edd4meie33u1fcJhpkUVvTb12AvvSg3XMeLNEkinVpDmHlA1s5UzxJCs93CwIL+f0Lfo
         jLNVSTCclNjiUZ8RgyS+kAci2jNO0CDKNcYq+QcqqR5pFHkhyAeyHOs3OI7PlzBdgcB/
         1+6Go1+RYdGmhPfpx3v/XskVZj7pEiFTcRuRmHU/weDM6umbjhBMghTA7xOoEw+rfxCe
         zrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721420102; x=1722024902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zWJCFjgtMNgtozAYiAr2A+KBfeO3km1iv1DnIaZsGgQ=;
        b=GnMtBi6EbFP4ZnielIKH0aEK0JhXxk5YhjSZq66wlZGCVhdcq9zOkO19IMnj6+snQk
         smiqSFwo4EkvUQf72eYl2ujImL4dSsPmf0bQYHmD3cpv9x0Q2JOccUmwDDXiuIVhM8+4
         s+AULxy81dhASSoLcvj3Q7AeQFWibWSjmvO3ALtzqzuhsbJMysmTicyVHRYMP7+DDPsb
         LtlPbbVM3ktdndEbZ1Io5jhfhfFDjCtbXqSrgAEejqsAsv0TX8/++m04cxQ/lwGV0Dsh
         qkQ5XUqgMxZzVyTB3yIKMV2XY3igt1fOXkTDfcfaSJEWwZ7BPu0L0JyNVrMMtvdjSxRI
         j0dQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2TF9GKmJlJosRLrurXLmVkTL5lVRu1KbEIEXHZi+NLHDjIZ9Hv1GyZB2EXDuYXr0wRPPE1DbNlAUT5sCmFhg0A9b9
X-Gm-Message-State: AOJu0YzqAl+fdCQIoRzNYxGfdxwVypxYh7eNbflIS4oandj7oNI/6Gka
	T6vodWMPt+djG4F6QaZ4gO7C0CrtsobiEkhXE/FYpERPlVvt/cFVuMlXpwM9RwqQaExI9+8wiby
	/EazUpAQhrjYJry5w/78o1/j/GkxkTHcit8Jv
X-Google-Smtp-Source: AGHT+IHIbP8sgONKGNJNBiPGGkEdodEy9wXP050Dq8z3mdpSj/m//1k3YPuQ9qvpkgcfyQA3sY6joJjCnk+Lc7L7jWY=
X-Received: by 2002:a17:902:dac8:b0:1fd:7664:d875 with SMTP id
 d9443c01a7336-1fd7664dc73mr593255ad.22.1721420101515; Fri, 19 Jul 2024
 13:15:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c42bff52-1058-4bff-be90-5bab45ed57be@gmail.com>
 <ZpqgfETiBXfBfFqU@google.com> <70137930-fea1-4d45-b453-e6ae984c4b2b@gmail.com>
 <Zpq9Bp7T_AdbVhmP@google.com> <824a0819-a09d-40ac-820c-f7975aee1dae@gmail.com>
In-Reply-To: <824a0819-a09d-40ac-820c-f7975aee1dae@gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 19 Jul 2024 13:14:50 -0700
Message-ID: <CALMp9eStzLK7kQY41b37zvZuR7UVzOD+W7vDPhyKXYPDhUww0g@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFtCVUddIGFyY2gveDg2L2t2bS92bXgvcG11X2ludGVsLmM6NTQ6IGVycm9yOiBkZQ==?=
	=?UTF-8?B?cmVmZXJlbmNlIG9mIE5VTEwg4oCYcG1j4oCZIFtDV0UtNDc2XQ==?=
To: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 12:41=E2=80=AFPM Mirsad Todorovac
<mtodorovac69@gmail.com> wrote:
>
>
>
> On 7/19/24 21:22, Sean Christopherson wrote:
> > On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> >> On 7/19/24 19:21, Sean Christopherson wrote:
> >>> On Fri, Jul 19, 2024, Mirsad Todorovac wrote:
> >>>> Hi,
> >>>>
> >>>> In the build of 6.10.0 from stable tree, the following error was det=
ected.
> >>>>
> >>>> You see that the function get_fixed_pmc() can return NULL pointer as=
 a result
> >>>> if msr is outside of [base, base + pmu->nr_arch_fixed_counters) inte=
rval.
> >>>>
> >>>> kvm_pmu_request_counter_reprogram(pmc) is then called with that NULL=
 pointer
> >>>> as the argument, which expands to .../pmu.h
> >>>>
> >>>> #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
> >>>>
> >>>> which is a NULL pointer dereference in that speculative case.
> >>>
> >>> I'm somewhat confused.  Did you actually hit a BUG() due to a NULL-po=
inter
> >>> dereference, are you speculating that there's a bug, or did you find =
some speculation
> >>> issue with the CPU?
> >>>
> >>> It should be impossible for get_fixed_pmc() to return NULL in this ca=
se.  The
> >>> loop iteration is fully controlled by KVM, i.e. 'i' is guaranteed to =
be in the
> >>> ranage [0..pmu->nr_arch_fixed_counters).
> >>>
> >>> And the input @msr is "MSR_CORE_PERF_FIXED_CTR0 +i", so the if-statem=
ent expands to:
> >>>
> >>>     if (MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) >=
=3D MSR_CORE_PERF_FIXED_CTR0 &&
> >>>         MSR_CORE_PERF_FIXED_CTR0 + [0..pmu->nr_arch_fixed_counters) <=
 MSR_CORE_PERF_FIXED_CTR0 + pmu->nr_arch_fixed_counters)
> >>>
> >>> i.e. is guaranteed to evaluate true.
> >>>
> >>> Am I missing something?
> >>
> >> Hi Sean,
> >>
> >> Thank you for replying promptly.
> >>
> >> Perhaps I should have provided the GCC error report in the first place=
.
> >
> > Yes, though the report itself is somewhat secondary, what matters the m=
ost is how
> > you found the bug and how to reproduce the failure.  Critically, IIUC, =
this requires
> > analyzer-null-dereference, which AFAIK isn't even enabled by W=3D1, let=
 alone a base
> > build.
> >
> > Please see the 0-day bot's reports[*] for a fantastic example of how to=
 report
> > things that are found by non-standard (by kernel standards) means.
> >
> > In general, I suspect that analyzer-null-dereference will generate a _l=
ot_ of
> > false positives, and is probably not worth reporting unless you are abs=
olutely
> > 100% certain there's a real bug.  I (and most maintainers) am happy to =
deal with
> > false positives here and there _if_ the signal to noise ratio is high. =
 But if
> > most reports are false positives, they'll likely all end up getting ign=
ored.
> >
> > [*] https://lore.kernel.org/all/202406111250.d8XtA9SC-lkp@intel.com
>
> I think I understood the meaning between the lines.
>
> However, to repeat the obvious, reducing the global dependencies simplifi=
es the readability
> and the logical proof of the code. :-/

Comments would also help. :)

> Needless to say, dividing into pure functions and const functions reduces=
 the number of
> dependencies, as it is N =C3=97 (N - 1), sqr (N).
>
> For example, if a condition is always true, but the compiler cannot deduc=
e it from code,
> there is something odd.
>
> CONCLUSION: If this generated 5 out of 5 false positives, then I might be=
 giving up on this
> as a waste of your time.
>
> However, it was great fun analysing x86 KVM code. :-)

I assure you that there are plenty of actual bugs in KVM. This tool
just isn't finding them.

> Sort of cool that you guys on Google consider bug report from nobody admi=
ns from the
> universities ;-)
>
> Best regards,
> Mirsad Todorovac
>

