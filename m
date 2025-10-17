Return-Path: <kvm+bounces-60338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DE8BEABAA
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18DD3962018
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 15:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA0533291C;
	Fri, 17 Oct 2025 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bP/6ez0w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4642242935
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716743; cv=none; b=H8v6lKLnduqlYi09IQZv7eEFyyMcvLqJbkNEtUDKMPq82QHelm5awEuWC92w26s/udzfpJEGphhEqJXiYLl0VKJsW9nwKghfVCMgd2RXrXgMtIUIKv1cTErr4wlfZ8mEoq5RSlKrVz4A1fNWh/A599r0x1fA5t4E2b+NuP5BkfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716743; c=relaxed/simple;
	bh=7fl0KjSvtJeicpmVq+/OdIfpNUR2VSd6oXVRqLYUIFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bMU7rFazHubyQd35LjPyKdelLSxu+d4bxXF0ZaWwyZ7vd+AuSX+vu3nUihybdbW31ZxGqUt7XB1dL+7D+LhPCURIetV4/41uhaZxCALhvyZJBvT5AEWKlspU0I5Uuv5phkOoBB9bQkPv5NudhNDeKYkKjZ6PgMdJXm3Bo8IV5pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bP/6ez0w; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269880a7bd9so26127075ad.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 08:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760716741; x=1761321541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ySYChoJkXBUDqdm5DBMPKJeV9dwj7FHlSZpAh9VLTC4=;
        b=bP/6ez0wuy0JGcbTTbfHSkSAuXezpDmNkOIQZ0Rbvua4Hm/WWDd7GKMs5ManXnY7ug
         TuAuOae2oaNDRdUkpC3J+QSwrAY50jWObOpqOTy6dAt2EFYqmp4DmzgxYe5LwpMs+bwm
         MA2aREp2JmrJhtc55ufe8hGR+FzImALroxUtjXu9OdbrFoxB54tx+3zWw3HaG0uJGNZK
         V7Kk3g6X78qXSQEvPw5YIMA88UdeD1KQsSVjMT+Nj25QgXHhYOmzFoYg13cUcXfuls8S
         E1ABsLOcWV5Kh+lsqUwTMVOZE+vf5MpXqL6dRgfN96KTOnVm0j/CFjaA0mGnWltiIyPr
         Xc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760716741; x=1761321541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ySYChoJkXBUDqdm5DBMPKJeV9dwj7FHlSZpAh9VLTC4=;
        b=MBQX4r+OWN0weHcgUTwZMU7Eo5Ln3ZIZyPWIqwSxuO+sbMNYSQM/yiEum11Klocofd
         kfiDxhXHrySmsD/103uMUEr2FqNuYMlWuH7iI8m/lICk58D2cGPeJyAAJNNd0NP8FkjE
         Fbi2jfiiDQdrHOvnoE0PHqtNwZgU3n9zh3fa/621dFQaB1HuFKc7jg9SDwy2JEzvX9ih
         49GPBIzCyZS4tIPUGQBD7Q2wgvEyxt2/MB6HbXjlWgRgxzbCte9RZFJesG4RGr4InBM8
         AVGLVuci9eLWLqyEI2USpm1u/y+vJCMKfWErRWhSLpj0LBIP0bPtYTdJVELMoaiGNzxM
         bQmw==
X-Forwarded-Encrypted: i=1; AJvYcCVpJnpHKhb0e2WCnaqadv3AGG4LKRTLmk432Vg/100e6EEiVBn3LBSpz4ggVlyjQ8AC/OM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpYXuMh4cH9ej6p+riUgh+bpTVrUWiG048nmRhUC9fbcgW1hLA
	L2E3HG/6lGY8pBQAwcI6S6vq/bXAczFNga2FCfgTsd8Mi3MT34N+husNCqEN636+gHuZt5Vk8Zg
	WCIr8qQ==
X-Google-Smtp-Source: AGHT+IFvhZU4k4UyUUtMv02PhZxeJRwR9FSUA/Rx9yT3Ja3zRBASFQYqNG0snthgBLAQf4JQNkNaFhuqbPA=
X-Received: from pjbku18.prod.google.com ([2002:a17:90b:2192:b0:33b:a383:f4df])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce11:b0:28d:1936:ee9a
 with SMTP id d9443c01a7336-290cba4eec9mr56116035ad.29.1760716741316; Fri, 17
 Oct 2025 08:59:01 -0700 (PDT)
Date: Fri, 17 Oct 2025 08:59:00 -0700
In-Reply-To: <c87d11a7-b4dd-463e-b40a-188fd2219b3b@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251013125117.87739-1-fuqiang.wng@gmail.com> <aO2LV-ipewL59LC6@google.com>
 <c87d11a7-b4dd-463e-b40a-188fd2219b3b@gmail.com>
Message-ID: <aPJnxDj4mFSJc0tV@google.com>
Subject: Re: [PATCH RESEND] avoid hv timer fallback to sw timer if delay
 exceeds period
From: Sean Christopherson <seanjc@google.com>
To: fuqiang wang <fuqiang.wng@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yu chen <chen.yu@easystack.com>, 
	dongxu zhang <dongxu.zhang@easystack.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025, fuqiang wang wrote:
> On 10/14/25 7:29 AM, Sean Christopherson wrote:
> > On Wed, Oct 01, 2025, fuqiang wang wrote:
> > The only code that cares is __kvm_wait_lapic_expire(), and the only dow=
nside to
> > setting tscdeadline=3DL1.TSC is that adjust_lapic_timer_advance() won't=
 adjust as
> > aggressively as it probably should.
>=20
> I am not sure which type of timers should use the "advanced tscdeadline h=
rtimer
> expiration feature".
>=20
> I list the history of this feature.
>=20
> 1. Marcelo first introduce this feature, only support the tscdeadline sw =
timer.
> 2. Yunhong introduce vmx preemption timer(hv), only support for tscdeadli=
ne.
> 3. Liwanpeng extend the hv timer to oneshot and period timers.
> 4. Liwanpeng extend this feature to hv timer.
> 5. Sean and liwanpeng fix some BUG extend this feature to hv period/onesh=
ot timer.
>=20
> [1] d0659d946be0("KVM: x86: add option to advance tscdeadline hrtimer exp=
iration")
>     Marcelo Tosatti     Dec 16 2014
> [2] ce7a058a2117("KVM: x86: support using the vmx preemption timer for ts=
c deadline timer")
>     Yunhong Jiang       Jun 13 2016
> [3] 8003c9ae204e("KVM: LAPIC: add APIC Timer periodic/oneshot mode VMX pr=
eemption timer support")
>     liwanpeng           Oct 24 2016
> [4] c5ce8235cffa("KVM: VMX: Optimize tscdeadline timer latency")
>     liwanpeng           May 29 2018
> [5] ee66e453db13("KVM: lapic: Busy wait for timer to expire when using hv=
_timer")
>     Sean Christopherson Apr 16 2019
>=20
>     d981dd15498b("KVM: LAPIC: Accurately guarantee busy wait for timer to=
 expire when using hv_timer")
>     liwanpeng           Apr 28 2021
>=20
> Now, timers supported for this feature includes:
> - sw: tscdeadline
> - hv: all (tscdeadline, oneshot, period)
>=20
> =3D=3D=3D=3D
> IMHO
> =3D=3D=3D=3D
>=20
> 1. for period timer
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I think for periodic timers emulation, the expiration time is already adj=
usted
> to compensate for the delays introduced by timer emulation, so don't need=
 this
> feature to adjust again. But after use the feature, the first timer expir=
ation
> may be relatively accurate.
>=20
> E.g., At time 0, start a periodic task (period: 10,000 ns) with a simulat=
ed
> delay of 100 ns.
>=20
> With this feature enabled and reasonably accurate prediction, the expirat=
ion
> time set seen by the guest are: 10000, 20000, 30000...
>=20
> With this feature not enabled, the expiration times set: 10100, 20100, 30=
100...
>=20
> But IMHO, for periodic timers, accuracy of the period seems to be the mai=
n
> concern, because it does not frequently start and stop. The incorrect per=
iod
> caused by the first timer expiration can be ignored.

I agree it's superfluous, but applying the advancement also does no harm, a=
nd
avoiding it would be moreeffort than simply letting KVM predict the first e=
xpiration.

> 2. for oneshot timer
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> In [1], Marcelo treated oneshot and tscdeadline differently. Shouldn=E2=
=80=99t the
> behavior of these two timers be similar?

Yes, but they aren't identical, and so supporting both would require additi=
onal
code, complexity, and testing.

> Unlike periodic timers, both oneshot and tscdeadline timers set a specifi=
c
> expiration time, and what the guest cares about is whether the expiration
> time is accurate. Moreover, this feature is mainly intended to mitigate t=
he
> latency introduced by timer virtualization.  Since software timers have
> higher latency compared to hardware virtual timers, the need for this fea=
ture
> is actually more urgent for software timers.

Yep.

> However, in the current implementation, the feature is applied to hv
> oneshot/period timers, but not to sw oneshot/period timers.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Summary of IMHO
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The feature should be applied to the following timer types:
> sw/hv tscdeadline and sw/hv oneshot

In a perfect world, probably?  But I don't know that it's worth changing at=
 this
time.  Much of this is balancing complexity with benefit, though it's also =
most
definitely a reflection of the initial implementation.

KVM unconditionally emulates TSC-deadline mode, and AFAIK every real-world =
kernel
prefers TSC-deadline over one-shot, and so in practice the benefits of appl=
ying
the advancement to one-shot hrtimers.  That was also the way the world was =
headed
back when Marcelo first implemented the support.  I don't know for sure why=
 the
initial implementation targeted only TSC-deadline mode, but I think it's sa=
fe to
assume that the use case Marcelo was targeting exclusively used TSC-deadlin=
e.

I'm not entirely opposed to playing the advancement games with one-shot hrt=
imers,
but it's also not clear to me that it's worth doing.  E.g. supporting one-s=
hot
hrtimers would likely require a bit of extra complexity to juggle the diffe=
rent
time domains.  And if the only use cases that are truly sensitive to timer
programming latency exclusively use TSC-deadline mode (because one-shot mod=
e is
inherently "fuzzy"), then any amount of extra complexity is effectively dea=
d weight.

> should not be applied to:
> sw/hv period

I wouldn't say "should not be applied to", I think it's more "doesn't provi=
de much
benefit to".

