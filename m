Return-Path: <kvm+bounces-14904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5DB8A77D2
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF9061F22985
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D9484E13;
	Tue, 16 Apr 2024 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y4YxzMZk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C721384BF
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 22:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713306900; cv=none; b=LDKtiRfRo0N2jbntoXSGa45SY2xlB5fbYJg2pR3fbGBCNJKxMFjQjQ7rOOtzKDcYvXzYHSQMKOgoklbP8RvtaLaRfUWbbfj0fOPcESGiiUMzIM6UgRZEY02qXGsv6CqiEaSpnRhomifTmYFGVwGNhOmh1YNiOWcQZAvrr9c7+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713306900; c=relaxed/simple;
	bh=D6DW7vU+Ud1j1ZMm6riVY8+oFgwa63RdFWc+QIYQMB4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zwm2w/8eE+/vQ6efgTkFnZUmdF0wMe0gvTIlYpiLDeJLfaOUB6svcXDQiGt4zpWGc1IEG5oPbR5HCqxavGxb2yqGNn6vlykggLJRXP6RXKzfMEZGk4aXpBBeKAxAPRbT8hJ+bgll1oZUvihh3xAAnW1kExIg3nBcN33LCuvTJgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y4YxzMZk; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so6230631276.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 15:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713306897; x=1713911697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N28jPTevDRZgDwN0Qgro9sWm7eqto+/tqAfBob/PiVg=;
        b=Y4YxzMZkR7X03bGpIEEzVGQEnMLLB6bp3HvIraqvg+6pJOfvGlYod05bmxKJkH0qdY
         ZWJ147Z4evUiZxFNPN14J89+LtJxzX87+xzbmUR49ifiTnqVnR/Lv8vU5WBxMdFJK7OO
         GN1rZ17f0R3s2xRogLCPOkKDnir/zNtn39fh7NW1BjpGZf6kZVvBDtxJ4FDd5CFrfyI3
         xLql/0/+IqY0Heztup1FIK3B18BdLSRBroRApYG8+sxDhDsfTpXgyXLiA3WQFztuCqx1
         r5DipAYqErnWiOAv1xBR1BW5CyRG+wuEF+N0hZYREYYnXIqCDVfoIw7TwGOGcsjhUtjG
         U1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713306897; x=1713911697;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N28jPTevDRZgDwN0Qgro9sWm7eqto+/tqAfBob/PiVg=;
        b=kNsQlIYXecra7ctUaxM4K9wNN/he/5eTMoTqNqmAFRFU71v9mS1XOmhO99fPt8g5r3
         nDMuQ5zFLt14PdAkUfNu67/tovm5hEzsjUpMCeNuGtkGDQZjWItuxKAojj9VFyWqzeRq
         qj8dNdZuSob6f5zBzULqLbb7mOJSjG5kjx3T/i29z7i9wR+PabwskchlF6W1bEfW9HSB
         mtzylb5RY7tTrjxotN7GV7XXjD3kHxYQqkhXi+xYNiHbC49fpHl+huCEu1+A+c+oZjX4
         ucsjZKwPd9HItsjCFByjmmK/8mejvnwvNoTAhH8886tTgA0B/vPdXU4icNJDRWRMZ0JQ
         cqSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUORHQBm12mr5n+ZBryqLfzeL9nLcUMrgs0cmbFcwpiLWb09zDnmJ1PhWxJ49LitbeJdo2Nt1WCbyMcayO+Eah/f4ER
X-Gm-Message-State: AOJu0Yx4xwdy/ZuiCxgn3+74DhSwePKkchoceh7opuXdnDiE8k9HN40r
	8RjpvFKVKYWk2deToj8MuonijkXRDZ+EFxcVy8yAls1619RLOy3pXWaxRtJ6LlPxDk9yzs/EfxL
	uPA==
X-Google-Smtp-Source: AGHT+IHijFgIMHcHKSmLYnGXqSMY0ztzAIixleUp7N8npxxMg8gLVi3C6uLdSPFh4cTT41VSi7yudkzO7dM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ad23:0:b0:de1:2203:2031 with SMTP id
 y35-20020a25ad23000000b00de122032031mr836200ybi.6.1713306897370; Tue, 16 Apr
 2024 15:34:57 -0700 (PDT)
Date: Tue, 16 Apr 2024 15:34:55 -0700
In-Reply-To: <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <Zh6-h0lBCpYBahw7@google.com> <CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6OqA35HzA@mail.gmail.com>
Message-ID: <Zh79D2BdtS0jKO6W@google.com>
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, joao.m.martins@oracle.com, 
	boris.ostrovsky@oracle.com, mark.kanda@oracle.com, 
	suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024, Paolo Bonzini wrote:
> On Tue, Apr 16, 2024 at 8:08=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Feb 15, 2024, Alejandro Jimenez wrote:
> > > The goal of this RFC is to agree on a mechanism for querying the stat=
e (and
> > > related stats) of APICv/AVIC. I clearly have an AVIC bias when approa=
ching this
> > > topic since that is the side that I have mostly looked at, and has th=
e greater
> > > number of possible inhibits, but I believe the argument applies for b=
oth
> > > vendor's technologies.
> > >
> > > Currently, a user or monitoring app trying to determine if APICv is a=
ctually
> > > being used needs implementation-specific knowlegde in order to look f=
or specific
> > > types of #VMEXIT (i.e. AVIC_INCOMPLETE_IPI/AVIC_NOACCEL), checking GA=
Log events
> > > by watching /proc/interrupts for AMD-Vi*-GA, etc. There are existing =
tracepoints
> > > (e.g. kvm_apicv_accept_irq, kvm_avic_ga_log) that make this task easi=
er, but
> > > tracefs is not viable in some scenarios. Adding kvm debugfs entries h=
as similar
> > > downsides. Suravee has previously proposed a new IOCTL interface[0] t=
o expose
> > > this information, but there has not been any development in that dire=
ction.
> > > Sean has mentioned a preference for using BPF to extract info from th=
e current
> > > tracepoints, which would require reworking existing structs to access=
 some
> > > desired data, but as far as I know there isn't any work done on that =
approach
> > > yet.
> > >
> > > Recently Joao mentioned another alternative: the binary stats framewo=
rk that is
> > > already supported by kernel[1] and QEMU[2].
> >
> > The hiccup with stats are that they are ABI, e.g. we can't (easily) dit=
ch stats
> > once they're added, and KVM needs to maintain the exact behavior.
>=20
> Stats are not ABI---why would they be?

Because they exposed through an ioctl(), and userspace can and will use sta=
ts for
functional purposes?  Maybe I just had the wrong takeaway from an old threa=
d about
adding a big pile of stats[1], where unfortunately (for me) you weighed in =
on
whether or not tracepoints are ABI, but not stats.

And because I've have been operating under the assumption that stats are AB=
I, I've
been guiding people to using stats to make decisions in userspace.  E.g. KV=
M doesn't
currently expose is_guest_mode() in kvm_run, but it is a stat, so it's not =
hard
to imagine userspace using the stat to make decisions without needing to ca=
ll back
into KVM[2].

And based on the old discussion[1] I doubt I'm though only one that has thi=
s view.

That said, I'm definitely not opposed to stats _not_ being ABI, because tha=
t would
give us a ton of flexibility.  E.g. we have a non-trivial number of interna=
l stats
that are super useful _for us_, but are rather heavy and might not be desir=
able
for most environments.  If stats aren't considered ABI, then I'm pretty sur=
e we
could land some of the more generally useful ones upstream, but off-by-defa=
ult
and guarded by a Kconfig.  E.g. we have a pile of stats related to mmu_lock=
 that
are very helpful in identifying performance issues, but they aren't things =
I would
want enabled by default.

But if we do decide stats aren't ABI, then we need to document and dissemin=
ate
that information.

[1] https://lore.kernel.org/all/CALzav=3DcuzT=3Du6G0TCVZUfEgAKOCKTSCDE8x2v5=
qc-Gd_NL-pzg@mail.gmail.com
[2] https://lore.kernel.org/all/Zh6-e9hy7U6DD2QM@google.com

> They have an established meaning and it's not a good idea to change it, b=
ut
> it's not an absolute no-no(*); and removing them is not a problem at all.
>=20
> For example, if stats were ABI, there would be no need for the
> introspection mechanism, you could just use a struct like ethtool
> stats (which *are* ABO).
>=20
> Not everything makes a good stat but, if in doubt and it's cheap
> enough to collect it, go ahead and add it.

Marc raised the (IMO) valid concern that "if it's cheap, add it" will lead =
to
death by a thousand cuts.  E.g. add a few hundred vCPU stats and suddenly v=
CPUs
consumes an extra KiB or three of memory.

A few APIC stats obviously aren't going to move the needle much, I'm just p=
ointing
out that not everyone agrees that KVM should be hyper permissive when it co=
mes to
adding new stats.

> Cheap collection is the important point, because tracepoints in a hot pat=
h
> can be so expensive as to slow down the guest substantially, at least in
> microbenchmarks.
>=20
> In this case I'm not sure _all_ inhibits makes sense and I certainly
> wouldn't want a bitmask, but a generic APICv-enabled stat certainly
> makes sense, and perhaps another for a weirdly-configured local APIC.
>=20
> Paolo
>=20
> (*) you have to draw a line somewhere. New processor models may
> virtualize parts of the CPU in such a way that some stats become
> meaningless or just stay at zero. Should KVM not support those
> features because it is not possible anymore to introspect the guest
> through stat?

