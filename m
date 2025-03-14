Return-Path: <kvm+bounces-41062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B101DA6133F
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 14:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC76F3BB3D7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D509E200136;
	Fri, 14 Mar 2025 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oc6RBS7/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870791FCF7D
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 13:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741960786; cv=none; b=ErqJZJLXWSLhU2DNotx6QWlPkK03d7iRXECtBzMW1wx7bCeBptMQd4QGYSUZfbfsDuNsIHH1hpiG36rMupr6qETKq4c5E8NPt3K1Y72YTlio5PkDhfLFO0b58Z7qVWtTeu0n4UCGhdRd1gip+5Wx6qWPkU/dGH4KjHIBr8PTUYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741960786; c=relaxed/simple;
	bh=o3oN2teH7/7o/cu7y1Rd54JOjYsOskM2i0aoFrFKLiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EOIu3eafv6CnBq7qKF+xCRwceiljo7eNQIxS/fpRPL0KW/bTxYcODibz3TiQkNQ0rabcoLL8AeZsE9PByxHCIsEKCPnupKgTheVRo7L0aIBgAn1yHRThKZCYwdWg8Ci2k5iS/LFx0ws+QAHfkIXRkcyy+vy2gT9ChtA5uywY1Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oc6RBS7/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff799be8f5so3493638a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 06:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741960785; x=1742565585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Z5anCDrhhJBcWeJWw8bzxe9xmdp2wEmwmhN3IyuUVI=;
        b=Oc6RBS7/sf/VuH8SbzjmiOdeRUCSmi8+qomLdeXMV3fZK38DW20M4tsSAyte7bKsTN
         Iz8Hck2mH+3e6tsSyumKyC1/QBV/FrOTxLyLT7alYexjx2M5K2TiwVuMr+jTCI3h1+iw
         W6yAHZOkIvgbByqA3dpI5JMPuBlWUXBIma8vxvAbNF+AI7JPIcuNiFQRh5pG+jbIadxB
         tCqSIczWBeREPEBbt3dWJjWyD9DxGtaB79j8MJEs36wW8T5wm2s6dNpMzXxDKmruD7iS
         o+mg573yQYzVNBl8sSt30aQ1+nuyc4Gr6hMgDVJr+GwQV4SbsAdAeEclHehh8RaQrNQ6
         rnKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741960785; x=1742565585;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9Z5anCDrhhJBcWeJWw8bzxe9xmdp2wEmwmhN3IyuUVI=;
        b=fER5aalyO+iIk5AtEz2Fl+Zt0tuxCwU9XHdLrBhVcHYgAnPM19SSX27Cnl13WEidVW
         XqxtejEXivAX9dNYaODF3uYgY3K8lzsJWJb4sj5fpOjGfP6oAvPllVxmAwzrCoxRJm9u
         7JZeYL6VEkO/jO3Z4w73gGpC+sDi+r41bxQJuIOFgGk3+ZksFKKBtaNlLGqTLjdiP20V
         HnGoUZN2bSzJKTlb358ADHVwcudmTbSepTD7ujkThODwh4U8+jbhg5wgZ8iPuZ6XX9OC
         vAOK9V0C1ShvB68izvPej1j27dJoW4IoEhQfQrsUMnuCqUguMMOcK5FnDt4dvpSfzCQI
         XgUg==
X-Forwarded-Encrypted: i=1; AJvYcCUlcjNsmhkW2q0shZDS+aj2OAurQ0kTMb66M8W9pwtV+KzqjsqIYIJ6HkzO0LdFgHR73LM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpv8kKB3EV4frhxVT+JEARKX5q7lzdPORzlofU3Bv5I7zFSiyK
	Z3ABGtmo2xbVdSAPCDn9e/K3bUPw7gJI+spnkW2FQJdHWHiYJnpMIu4hwPxQ9S5Bu+hoVnx1HES
	Nvw==
X-Google-Smtp-Source: AGHT+IGgEhJygXWlQRTO92MWBmqXs9qWrE1SN+ZobB60ohCV46iptd/VxXMOsljTLGS/n3Tl5HFX5KwPYeY=
X-Received: from pjboi8.prod.google.com ([2002:a17:90b:3a08:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4986:b0:2ee:f550:3848
 with SMTP id 98e67ed59e1d1-30151c75fcamr3212802a91.5.1741960784871; Fri, 14
 Mar 2025 06:59:44 -0700 (PDT)
Date: Fri, 14 Mar 2025 06:59:42 -0700
In-Reply-To: <CALMp9eRHrEZX4-JWyGXNRvafU2dNbfa6ZjT5HhrDBYujGYEvaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250225004708.1001320-1-jmattson@google.com> <CALMp9eRHrEZX4-JWyGXNRvafU2dNbfa6ZjT5HhrDBYujGYEvaw@mail.gmail.com>
Message-ID: <Z9Q2Tl50AjxpwAKG@google.com>
Subject: Re: [PATCH] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025, Jim Mattson wrote:
> On Mon, Feb 24, 2025 at 4:47=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> >
> > Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
> > without interception.
> >
> > The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are not
> > handled at all. The MSR values are not zeroed on vCPU creation, saved
> > on suspend, or restored on resume. No accommodation is made for
> > processor migration or for sharing a logical processor with other
> > tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
> > do not account for time the same way as the comparable PMU events,
> > whether the PMU is virtualized by the traditional emulation method or
> > the new mediated pass-through approach.
> >
> > Nonetheless, in a properly constrained environment, this capability
> > can be combined with a guest CPUID table that advertises support for
> > CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
> > effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
> > no performance cost for this capability.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---

...

> Any thoughts?

It's absolutely absurd, but I like it.  I would much rather provide functio=
nality
that is flawed in obvious ways, as opposed to functionality that is flawed =
in
subtle and hard-to-grok ways.  Especially when the former is orders of magn=
itude
less complex.

I have no objections, so long as we add very explicit disclaimers in the do=
cs.

FWIW, the only reason my response was delayed is because I was trying to fi=
gure
out if there's a clean way to avoid adding a large number of a capabilities=
 for
things like this.  E.g. if we can add generic uAPI to let userspace disable=
 MSR
interception.  But AFAICT, there aren't very many MSRs where it would be sa=
ne to
let the guest read unadultered MSRs, so it's probably not worth the complex=
ity.

