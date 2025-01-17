Return-Path: <kvm+bounces-35846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F4CA1566F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7499188A7B1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E351A83EC;
	Fri, 17 Jan 2025 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L6H3F54N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2CC1A23A8
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 18:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737138079; cv=none; b=c0ADROhSTeOIFbRF4sORv0mwQtPi7Naubm24xCCuF+SOdtWt03WJvCMwmLKUY20eLTeX3vy+/As0+yVpEk3YKKn7DKxEX9swvQvhC4k1A0AR6KlaM5tpdPzUb6HphaQjThFPFvVZzv+CZruSyDgSK1Q0XF5qwClNMizUL3MAyZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737138079; c=relaxed/simple;
	bh=ndunmA6grE8t3VVKCs/1lCVSzpaGiZXopTIS3ZCrUaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dxv6eoGa1t0Y9CRwbxlQOzgqk9UXzROw7nYIqWpk6ulz9TkRxrwuFPTots+/i9fNOw9t6WKWHh3Z0ZIkm8uvneHcSqCz8LHXfHB+uLNc32pWnVO9zWiWdCOCpT0VsY/3LQIfUxAv6A5v6zVsSLtcqKTwUwOHOMWsYgr+ubWU58s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L6H3F54N; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6dd1962a75bso22027146d6.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737138076; x=1737742876; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li1GilM8aFcl+CyEdI/I7btgLBGV3YXKTIdi9VlH+SE=;
        b=L6H3F54NN8p+EEMTWc6t6E5/R7cfZlqX04oQVuJCTCStiUPn/7lA04iJDSoXIc2YO8
         3uEDe3XHE60Ku+WxafFq1cfvoaiv3AHdwE/ygJkRT/9FGUSiLJKnASTvEHmFk2a7I8wj
         lVPCctl+2WpzR1Q0Ch1Y7SJ8KpIqb9oyca7lW+thg3mBp42VjTNUbMXR5kxWvy0h+RBb
         tjYy9inv5/0t2ptm6xevFFAQu3EIP6r7y8mOxij+eK9AtZf2FXWt6GodEaMmfH3H+88f
         JJ2P7vqEJBqJ9LyRWzx86rVjk8JjBKjNN/2qAXvB88I0korlbYadjsd6S+tcn0emYIlw
         6EnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737138076; x=1737742876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=li1GilM8aFcl+CyEdI/I7btgLBGV3YXKTIdi9VlH+SE=;
        b=BQA3fmlJN2LES6PKVZRTTBqVLM+6u4QnkxtMNXgSCaEAo0K4FJjEDbSgOKDrAbtfLW
         TSi7eGWJvmB6EC4dbTkjiIsr4Mn05ZptK/YKoIIK5tdxPdslMq5ZkqVe+wdOhft/u4OJ
         NSrZeilXFPAyTA60doj73+sv2RJrEa1VWKqASe1+9GBbwGrxlnnqiEhp8EkSkcezGrf9
         0/K3TE0HRYLGZY4NmVlIa6+sqQ0iMGFyUley7eM2RRX90QKL8A5RKyri48F+1Yzw6MWA
         fL2vI7hn4wlwUQtephK20lPSlhvwKJM4YJvxe/KlCzP+nRhqTmA1IBvPn6IVLoodSJJh
         nlqQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9nvPQu6XGlevn+QyLq41vZ70tms4zNaPaXGoEWg5rjef9cV1QHMYMzBb4FSNBtGbtKe4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKXuc+CIp7wgxjJB6ksgL84tWjL4etkbh6kI7HFHV3OrGb815a
	99H0k8JV+u9hJEok7LYYrqp0fAgcLmKBuuYD7W7TVad7lcGfwOiKw6vHXOl/XepEoLFHdk/ORT9
	SwcvweFuJ57LRlprCmlAxrSuiw1Oqs8y7kl+Z
X-Gm-Gg: ASbGncuWLbtbJnGSMnMkgu2DhMNan6Rpesxdgiu/Jt1SKhHytpZ7pLeKl9dB29l3jP2
	b/jDyPp6BsGxk9ItQsotBnrenR6G/6kuT68E=
X-Google-Smtp-Source: AGHT+IGDGbX/puupdC5GZuwQIII3i75gnOPoKL5PfczeMTzAEEKUPpn7C3tYUtasV7JDy3rY/fsfPhNibSYKwWnfltc=
X-Received: by 2002:a05:6214:3006:b0:6d8:8aa6:ef27 with SMTP id
 6a1803df08f44-6e1b2230914mr64564696d6.38.1737138075511; Fri, 17 Jan 2025
 10:21:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com> <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
 <Z4mlsr-xJnKxnDKc@google.com> <CAJD7tkahmyjXvwKO2=EfQRWu_BHPJ-8+eSEteZH5TGG3+jHtWw@mail.gmail.com>
 <Z4qbDBduEYWEwjkS@google.com>
In-Reply-To: <Z4qbDBduEYWEwjkS@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 17 Jan 2025 10:20:38 -0800
X-Gm-Features: AbW1kvZGNf4SoJVliURuTgNgjXyMJDQMNi49eE7U9ONRphU74ygsEvi3nENRZWg
Message-ID: <CAJD7tkaa1cqUeUUKNdQADBqXH-G9h=5Liv+wj=5gitgbdO9Tsw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 10:01=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > On Thu, Jan 16, 2025 at 4:35=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > > > On Thu, Jan 16, 2025 at 2:35=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > > How about:
> > > > >
> > > > >          * Note, only the hardware TLB entries need to be flushed=
, as VPID is
> > > > >          * fully enabled from L1's perspective, i.e. there's no a=
rchitectural
> > > > >          * TLB flush from L1's perspective.
> > > >
> > > > I hate to bikeshed, but I want to explicitly call out that we do no=
t
> > > > need to synchronize the MMU.
> > >
> > > Why?  Honest question, I want to understand what's unclear.  My hesit=
ation to
> > > talk about synchronizing MMUs is that it brings things into play that=
 aren't
> > > super relevant to this specific code, and might even add confusion.  =
Specifically,
> > > kvm_vcpu_flush_tlb_guest() does NOT synchronize MMUs when EPT/TDP is =
enabled, but
> > > the fact that this path is reachable if and only if EPT is enabled is=
 completely
> > > coincidental.
> >
> > Personally, the main thing that was unclear to me and I wanted to add
> > a comment to clarify was why we use KVM_REQ_TLB_FLUSH_GUEST in the
> > first two cases but KVM_REQ_TLB_FLUSH_CURRENT in the last one.
> >
> > Here's my understanding:
> >
> > In the first case (i.e. !nested_cpu_has_vpid(vmcs12)), the flush is
> > architecturally required from L1's perspective to we need to flush
> > guest-generated TLB entries (and potentially synchronize KVM's MMU).
> >
> > In the second case, KVM does not track the history of VPID12, so the
> > flush *may* be architecturally required from L1's perspective, so we
> > do the same thing.
> >
> > In the last case though, the flush is NOT architecturally required
> > from L1's perspective, it's just an artifact of KVM's potential
> > failure to allocate a dedicated VPID for L2 despite L1 asking for it.
> >
> > So ultimately, I don't want to specifically call out synchronizing
> > MMUs, as much as I want to call out why this case uses
> > KVM_REQ_TLB_FLUSH_CURRENT and not KVM_REQ_TLB_FLUSH_GUEST like the
> > others. I only suggested calling out the MMU synchronization since
> > it's effectively the only difference between the two in this case.
>
> Yep.  I suspect the issue is lack of documentation for TLB_FLUSH_GUEST an=
d
> TLB_FLUSH_CURRENT.  I'm not entirely sure where it would be best to docum=
ent
> them.  I guess maybe where they are #defined?

I guess at the #define we can just mention that they result in calling
kvm_vcpu_flush_tlb_{guest/current}() before entering the guest, if
anything.

The specific documentation about what they do could be above the
functions themselves, and describing the potential MMU sync is
naturally part of documenting kvm_vcpu_flush_tlb_guest() (kinda
already there).

The flush_tlb_guest() callback is documented in kvm_host.h, but not
flush_tlb_current(). I was going to suggest just documenting that. But
kvm_vcpu_flush_tlb_guest() does not only call flush_tlb_guest(), but
it also potentially synchronizes the MMU. So only documenting the
callbacks does not paint a full picture.

FTR, I initially confused myself because all kvm_vcpu_flush_tlb_*()
functions are more-or-less thin wrappers around the per-vendor
callbacks -- except kvm_vcpu_flush_tlb_guest().

>
> TLB_FLUSH_GUEST is used when a flush of the guest's TLB, from the guest's
> perspective, is architecturally required.  The one oddity with TLB_FLUSH_=
GUEST
> is that it does NOT include guest-physical mappings, i.e. TLB entries tha=
t are
> associated with an EPT root.

The way I think about this is how it's documented above the per-vendor
callback. It flushes translations created by the guest. The guest does
not (directly) create guest-physical translations, only linear and
combined translations.

>
> TLB_FLUSH_CURRENT is used when KVM needs to flush the hardware TLB(s) for=
 the
> current CPU+context.  The most "obvious" case is for when KVM has modifie=
d its
> page tables.  More subtle cases are things like changing which physical C=
PU the
> vCPU is running on, and this case where KVM is switching the shadow CR3, =
VPID is
> enabled in the host (i.e. hardware won't flush TLBs), and the L1 vs. L2 s=
hadow
> CR3s are not tagged (i.e. use the same hardware VPID).
>
> The use of TLB_FLUSH_GUEST *may* result in an MMU sync, but that's a side=
 effect
> of an architectural guest TLB flush occurring, not the other way around.

Agreed.

