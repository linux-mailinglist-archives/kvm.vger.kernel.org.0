Return-Path: <kvm+bounces-56367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAA3B3C3D4
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:36:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711E0A60413
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 20:36:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A62343D74;
	Fri, 29 Aug 2025 20:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wk0W3tb5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4B021C194
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 20:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756499778; cv=none; b=cglD5JwsfwAZ5zMB9G1QQFxXsWLy8tY8Xj1BlZalKg7UHGgycEJ8Aq/C98PAF3UGAzfL3a1KjgQpkAWgHufKBKtXD5xAddAHRL8USnWkqqMUjGsCn2sayvoLgxMlOdXp0kQ8vLicmnBkqSv2aAZF7AU8qZhpdlVRRRn/yL68VAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756499778; c=relaxed/simple;
	bh=f7FJrEwVoxFWdpi8JaS9q1mpqcfezXqHvjbf5vjaYjA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IRWwk+C49lIAim1Wgcj7V9NgaCGF7XCfIUlAVI9+TodXygmquetRSJ8g+1+sf6f4Sx/LhrpnD57kFhL+0CEbJbqgISqg1qKwB1DnUeyx8/LvwjfJtQ2aSo4NRbDJlLEhBjrFoEaZ4umPelTHrOm6QrRBibCwOZY6y54/CYTEODk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wk0W3tb5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e4c3af5fso2802260a91.3
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 13:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756499777; x=1757104577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1EnoJm+fc1GCJ0sZfgEWZ3hG+HPHGdLPejXFy3Ozn4=;
        b=Wk0W3tb51F8W4nvZS+IZz+lh1/3w50XiY6Gc9arvpDfvGAdQxyr0YOo/SMgMDJ16KX
         jvFTnOBnQ31RkP9pFs7JdRVWGS1W+Hs4zjuro3CreqEJgx4WAzAhPa8AuVuJPyIjF2QL
         SKChe9EVIwEU0Ty1t0EoCCqtUaaAIlpq3Kbjn2m1nfye5fwcUu+6S6jQ7oDmBtWDMcgW
         EBEeKN7GmV/YBFAGuEfVLkFEFRctu/vtMoFJUoZCxvpMLOHcmuMpDcQySHr16Y9g9/nB
         UXEuMM+41q6Seu4DMVXJbLYuEHnWF4l4RkXx7UB1tY8efNvVT02NCvxO7+ICs8ySLvNC
         CIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756499777; x=1757104577;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S1EnoJm+fc1GCJ0sZfgEWZ3hG+HPHGdLPejXFy3Ozn4=;
        b=oDOov8lU9XX6uTWGP/Qa8KlMp6HZRbrBuCvBxoII4Cb3tVSvxyN4kz0pw0x5vq9rwl
         UsaJFCkwM8ozIZewUlarq2ZKjAUNPVykTW9JqcWmFv49879YhM9Wy2CELMEXCino9rQe
         JhAXsBPzxqzbvXI/t7+XzUHf3xYJXD0/ECAp22z40BmsyJTZeUGCiBxiG8lU8TSyWCx7
         lUxdsbUl/P03TarAHbgdbiokZ7FPl2P9pj+zW/XhnmOVP5RkmtW5T7UQSSTICkKAe6Tc
         9M4F28iH4qioc9bclTcOkrOhCcNVKb0MAAa1fT0IU36RvSGTxp+Ms4Y/YRCa0tUCxf30
         gtNA==
X-Forwarded-Encrypted: i=1; AJvYcCWk1Gva6uQF9enWY8Az0KgZ3TtZbO0cGzgWTnXJ+imPMJbwYmdAXAII95Nesplij9kTelI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkT1VaGTbMt8FDzHLgeISwubpm/+SNPkGcNNbHdRiRvfpJaRoN
	YY1/VCrQ6w41YdY7UnpnMQ0p79b9aDf6ZsoLaWPqxA/ci2Y8D008ZpPHleQA+GfrOtq4GUUilbi
	hIfPWEg==
X-Google-Smtp-Source: AGHT+IGDq8HMhbSf1ct91NB28Eh1Vrb9NeRli4XiXTjPP+TZZznO1vcEZTtmQOOPKF5flycqX6LRHZLxqng=
X-Received: from pjbpd13.prod.google.com ([2002:a17:90b:1dcd:b0:31e:cdb5:aa34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2682:b0:327:e34e:eb0c
 with SMTP id 98e67ed59e1d1-327e34eed02mr6130218a91.7.1756499776809; Fri, 29
 Aug 2025 13:36:16 -0700 (PDT)
Date: Fri, 29 Aug 2025 13:36:15 -0700
In-Reply-To: <caf7b1ea18eb25e817af5ea907b2f6ea31ecc3e1.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6783241f1bfadad8429f66c82a2f8810a74285a0.camel@infradead.org>
 <aKeGBkv6ZjwM6V9T@google.com> <fdcc635f13ddf5c6c2ce3d5376965c81ce4c1b70.camel@infradead.org>
 <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
 <aK4LamiDBhKb-Nm_@google.com> <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
 <aLDo3F3KKW0MzlcH@google.com> <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
 <54BCC060-1C9B-4BE4-8057-0161E816A9A3@amazon.co.uk> <caf7b1ea18eb25e817af5ea907b2f6ea31ecc3e1.camel@infradead.org>
Message-ID: <aLIPPxLt0acZJxYF@google.com>
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest
 and host
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <pdurrant@amazon.co.uk>, Fred Griffoul <fgriffo@amazon.co.uk>, 
	Colin Percival <cperciva@tarsnap.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025, David Woodhouse wrote:
> On Fri, 2025-08-29 at 11:08 +0000, Durrant, Paul wrote:
> > On 29/08/2025, 10:51, "David Woodhouse" <dwmw2@infradead.org=C2=A0<mail=
to:dwmw2@infradead.org>> wrote:
> > [snip]
> > > =E2=80=A2 Declare that we don't care that it's strictly an ABI change=
, and
> > > VMMs which used to just populate the leaf and let KVM fill it in
> > > for Xen guests now *have* to use the new API.
> > >=20
> > >=20
> > > I'm actually OK with that, even the last one, because I've just notic=
ed
> > > that KVM is updating the *wrong* Xen leaf. 0x40000x03/2 EAX is suppos=
ed
> > > to be the *host* TSC frequency, and the guest frequency is supposed t=
o
> > > be in 0x40000x03/0 ECX. And Linux as a Xen guest doesn't even use it
> > > anyway, AFAICT
> > >=20
> > > Paul, it was your code originally; are you happy with removing it?
> >=20
> > Yes, if it is incorrect then please fix it. I must have become
> > confused whilst reading the original Xen code.=20
>=20
> The proposal is not to *fix* it but just to rip it out entirely and
> provide userspace with some way of knowing the effective TSC frequency.
>=20
> This does mean userspace would have to set the vCPU's TSC frequency and
> then query the kernel before setting up its CPUID. And in the absence
> of scaling, this KVM API would report the hardware TSC frequency.

Reporting the hardware TSC frequency on CPUs without scaling seems all kind=
s of
wrong (which another reason I don't like KVM shoving in the state).  Of cou=
rse,
reporting the frequency KVM is trying to provide isn't great either, as the=
 guest
will definitely observe something in between those two.=20

> I guess the API would have to return -EHARDWARETOOSTUPID if the TSC frequ=
ency
> *isn't* the same across all CPUs and all power states, etc.

What if KVM advertises the flag in KVM_GET_SUPPORTED_CPUID if and only if t=
he
TSC will be constant from the guest's perspective?  TSC scaling has been su=
pported
by AMD and Intel for ~10 years, it doesn't seem at all unreasonable to rest=
rict
the feature to somewhat modern hardware.  And if userspace or the admin kno=
ws
better than KVM, then userspace can always ignore KVM and report the freque=
ncy
anyways.

