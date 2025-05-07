Return-Path: <kvm+bounces-45757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F0DAAE884
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 20:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0B055223D3
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 18:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D7C28DF2A;
	Wed,  7 May 2025 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rStKx5bL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965AB1EBFE3
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746641363; cv=none; b=ih4999qd0ENU35lgG9VFixegMrLtC+ThP/x8lDGivJzSHpRQ+YfmxPQgShsl8oCNEHZXvkSVbuFgAcsDYvZHvvTyA2I17aDUtN56ZyFMoIZM8NiYKJCzbxBHUZh3F3yirssyKZBn5WzmT0hwasfYyxrNsdBQr7XkqxLxeasSeDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746641363; c=relaxed/simple;
	bh=lQ4/BCswLY2N6ECLgvBXDQzaCsv17BjUWUhLGOcibLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqHV7PhmdtcMUfJRfIQ0HQcw56fQtC4KO2SqFfa2Q38NKH9KNqKKuygIg93ypnSA1Rr/4y0+Si3uSYrxlEyp3tZ2DyxRFyWMAkeXljBE6fcMNeSNDY0sWZcA99RIHQYB+W9CPPDGP4kOp+vvwmNR71tfr0CwRXqywpQF7eGLDJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rStKx5bL; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso1316a12.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 11:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746641360; x=1747246160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DGYhlqnhJG9IoKCyCL2sxs3rFfiV5qz+wh+tcIQTEw=;
        b=rStKx5bLHJ7SDCmNWvbqMPV4jr4v6YM8zpoRthSoA9yqXkDnNUB9hG+aa1O57FyIo0
         pYeQFsPAm/JzuWPRAkO3y2NH/Uk74BSzjXFNbz/pjUBt8F5tr19lYGGtghHfKQZ1+WbI
         PZu52Lr6319AI0bzHpZbqlLUL9hnrW97E7RUsHwN7WnyEIfDKpSOAMAmXIe/EydIJHuC
         E3VWyBvT9qkk8QEx7rrufHZezY/RvfIGz8qaZv82Q6fZjVXdt2JpY/7keanKTwBBT2Sr
         vz39lYGxL9iwIIVawWGgUA+PoJjoVUVhkyQHjlPMPhhXAYQBygmEyhzdNRaK4ymEwkJq
         6w1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746641360; x=1747246160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3DGYhlqnhJG9IoKCyCL2sxs3rFfiV5qz+wh+tcIQTEw=;
        b=UXAhNEfgtJph4EUOWuCvT4QVTtKOopzlow9LCPgdKePgZENHyYc76yZvpLk7Gu9JdX
         ttRlHfYt/LioZ92H2x7/MzGIiasmbNSj5UKFiHdF4dbb4ZT4A0Ae8M1O9NfC42BpdWIC
         Vr3to9YR7OGZ+v+TDl0+EqSDOvhR++b44eGmInOGzYF/GutEyHzlr+a+qf5Fb8DJIkLG
         W+itp1np56Qp1Vhbi94sINcxYRJrzbAIyPmnKOn3zWxlC0Ak7lzmoxFhPTCEeydySBOv
         uBazfx4TajjwaD7IgRhkBQvckjVJI4bW+jmrp6RvoSCJOLrLaeuSQ4DgPZPsdr88huB+
         h38g==
X-Forwarded-Encrypted: i=1; AJvYcCXHlWSPD2jMSDRI51CKRnjQyHjflkAvBU4GgYqhs2lTEDFT+Y0toAbbGNkSBJhXPHBFAxM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7LYZBt81TuHKm9kKj0jQV+fStHGqfDYOBodukj0ScvkVFPv5M
	8zWB9z4qPm9uKVTCwEy5d8CA0VYoGmO6JNUsEvGXuy4VKiqyzvICtihluL218mXgJ69qfF6cQEq
	4ZjJ8iYTNd9s219/E6P2N9x+tthnza8wLsSdm
X-Gm-Gg: ASbGnctHaKyn8Uk2fnuJUFJqOQ60Z4oXR1zzZWi1T5GEWGbC9+NCaYqYRpnd+hbbzRH
	MHroZMxKDi3LNR9ydq0qyBv6Y3yzIuiUKaWm2ZU8bvJG/XsIDMBUZtOUfajgx7jcoRfyh2bnXTm
	HEBaIDb2Kn5yxDGo6kF/3dJA==
X-Google-Smtp-Source: AGHT+IHLyIW4SYxyzdVGXlCCl20CHuuL7wWu4P4uR2cnzBouEN9d60OobvKz09nUeA//tsiI+wAtivlg8OUAQTJa2d0=
X-Received: by 2002:a05:6402:1cb5:b0:5fb:eab6:cdb0 with SMTP id
 4fb4d7f45d1cf-5fc496fad85mr3038a12.4.1746641359723; Wed, 07 May 2025 11:09:19
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-2-jmattson@google.com>
 <aBAIL6oGYJ7IV85X@google.com> <CALMp9eS7XHpFWMAtnJPQijYO1TVW25-UGmFqc33eAeb1AE_9YA@mail.gmail.com>
 <aBjoqW6qzoc2RGrZ@google.com>
In-Reply-To: <aBjoqW6qzoc2RGrZ@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 7 May 2025 11:09:07 -0700
X-Gm-Features: ATxdqUE9F2GnW6W5rwaaXZ00W92XYSfzH9aqeHskS5rstI1IG8xmlnI2OcXqaEc
Message-ID: <CALMp9eQBLj=Qh_70Xvbu9ZkYkWBd=yNgeG-zbvLa__F+d-+BZA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 9:34=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, May 05, 2025, Jim Mattson wrote:
> > On Mon, Apr 28, 2025 at 3:58=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > index 88a9475899c8..1675017eea88 100644
> > > --- a/arch/x86/kvm/x86.h
> > > +++ b/arch/x86/kvm/x86.h
> > > @@ -481,25 +481,15 @@ static inline u64 nsec_to_cycles(struct kvm_vcp=
u *vcpu, u64 nsec)
> > >             __rem;                                              \
> > >          })
> > >
> > > -static inline bool kvm_mwait_in_guest(struct kvm *kvm)
> > > -{
> > > -       return kvm->arch.mwait_in_guest;
> > > -}
> > > -
> > > -static inline bool kvm_hlt_in_guest(struct kvm *kvm)
> > > -{
> > > -       return kvm->arch.hlt_in_guest;
> > > -}
> > > -
> > > -static inline bool kvm_pause_in_guest(struct kvm *kvm)
> > > -{
> > > -       return kvm->arch.pause_in_guest;
> > > -}
> > > -
> > > -static inline bool kvm_cstate_in_guest(struct kvm *kvm)
> > > -{
> > > -       return kvm->arch.cstate_in_guest;
> > > -}
> > > +#define BUILD_DISABLED_EXITS_HELPER(lname, uname)                   =
           \
> > > +static inline bool kvm_##lname##_in_guest(struct kvm *kvm)          =
           \
> > > +{                                                                   =
           \
> > > +       return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_##una=
me;        \
> > > +}
> > > +BUILD_DISABLED_EXITS_HELPER(hlt, HLT);
> > > +BUILD_DISABLED_EXITS_HELPER(pause, PAUSE);
> > > +BUILD_DISABLED_EXITS_HELPER(mwait, MWAIT);
> > > +BUILD_DISABLED_EXITS_HELPER(cstate, CSTATE);
> >
> > The boilerplate is bad, but that's abhorrent.
>
> Assuming it's the macros you hate, keep the "u64 disabled_exits" change b=
ut
> manually code all of the getters?

Sounds good. I'll try to get a V4 out this week.

