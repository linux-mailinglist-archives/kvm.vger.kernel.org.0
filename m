Return-Path: <kvm+bounces-8142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D4A84BE52
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:50:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FFF4287695
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 19:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF541798A;
	Tue,  6 Feb 2024 19:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hY9Ge8W6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D846D1773F
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 19:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707248998; cv=none; b=AU8XZ8I2jvt0yu3jcTcdWup/8sRdTYdDLkbouYwo1Bff4sH2nDxJnQTBEx8ghvOsvobrKfy2l1FHReOS8cjk414GEmeHz38CUdOqCovQyjVs9a9UykAX1VGOObrYrLOiKjPBL2KaCCAnGdpMK5LRVsaFtGf5jOkXk17WEpKwHtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707248998; c=relaxed/simple;
	bh=V/krS/opY65lR9nnD02+WqJRWaSjpHxy6LQCN9z7kMA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fid37IHHU2+cFsb9XZEfqrEFGXKf6M/lgyWmontPlpaZHlAUPvUfBUZBFJmZOgH/pKhv4cjod9wsEXAfrFG8cchTMe7r3eBRp+c8ibKAwq8FefrvspbQDhZs3RwL5eedBKOoZxvN5rGVSskFyMqBEt0rcrfv7qux5a6/69xM+wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hY9Ge8W6; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso8510976276.0
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 11:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707248996; x=1707853796; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V/krS/opY65lR9nnD02+WqJRWaSjpHxy6LQCN9z7kMA=;
        b=hY9Ge8W62r+ciPbZT4ZzemKW2oQCaR4PwTbZtZO3KKAa4fzi2afRNt1KXwlvhUss4w
         lhLbJGeWVXZV0Xs3a9k01xCA3zUH9c2V4GtPOPNAt97+e6p2oLySPEkT58//2eKPEg7I
         UirZx+WIOWNH+zAyYhTlVmyux9pDcf0mX3fLKe1efsjwxBhM8bDdwb85Izbp+wmorjb8
         YNNQMuluB5TYGqPZyYxaKwmIHecmEtMLcaU73uODu9KQlTtgNQjy/IyojawneYyJ850w
         TVMX3hvoxIcMv4h/Nb3KJwR/k8hzqrzKZlEySzqRakrVzOtmUEIIXfNdSE4rm/qlLXFZ
         wOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707248996; x=1707853796;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V/krS/opY65lR9nnD02+WqJRWaSjpHxy6LQCN9z7kMA=;
        b=mMU54Jt5+ruMoGT6vJsIcut+1gcq1VygxgBUkqbZb69zyPVagX6WPpgioch46pEKf8
         XqZTY/a8ZZP/EcJfMwP+z2qaDGd1s0gr9S7MYCFeqm0Kkf1oc/FUUg4kSrz7TcDl0y7t
         Q4uqPERpRYFuiTZOBFZO5u7DEPypBEdOvVQ6A2UPRHust9EpOsrJKJfgdy9Yd+R/U+bB
         bp6KLsw/i2Omxm0m2D2W06U/CbYXsKXgg8kZjq3xF9PIh5YPH0ijzwQPpZttuWCSb23/
         wwJdGbJreq7yQs3N5znyX0KDKGVXqO/cR1QCcshYdnkqPxSx1IpvDYcmq5Z41edJGlxN
         47nw==
X-Gm-Message-State: AOJu0YyDVwOn/WVwunmjeAdQVxgzKUsjBEfLKC5xTqG0SY8q+lENvdBE
	c1iywRmdQXymlhLNvPnLLCSfJ1OIz9TdWqx3JOcLmZfJdZbYHR+esRH3Ox62JhysnSJztJrt8Yy
	lzA==
X-Google-Smtp-Source: AGHT+IG4EAgjvFXbQPCAt4aTpqw30nYIDa1fkJewPTFpyjKblCGDCOdF3RNG++6xRnGbSmJvq+9kxtOuhKA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b07:b0:dbe:d0a9:2be8 with SMTP id
 eh7-20020a0569021b0700b00dbed0a92be8mr122267ybb.0.1707248995864; Tue, 06 Feb
 2024 11:49:55 -0800 (PST)
Date: Tue, 6 Feb 2024 11:49:54 -0800
In-Reply-To: <17435518cb127e7c1493edac09704623de9ae3f8.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6150a0a8c3d911c6c2ada23c0b9c8b35991bd235.camel@infradead.org>
 <ZcKGVoaituZPkNTU@google.com> <17435518cb127e7c1493edac09704623de9ae3f8.camel@infradead.org>
Message-ID: <ZcKNYq5OZxkSs_Z2@google.com>
Subject: Re: [PATCH v4] KVM: x86/xen: Inject vCPU upcall vector when local
 APIC is enabled
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2024, David Woodhouse wrote:
> On Tue, 2024-02-06 at 11:19 -0800, Sean Christopherson wrote:
> >=20
> > Patch is corrupt.
> >=20
> > git am /home/seanjc/patches/v4_20240116_dwmw2_kvm_x86_xen_inject_vcpu_u=
pcall_vector_when_local_apic_is_enabled.mbx
> > Applying: KVM: x86/xen: Inject vCPU upcall vector when local APIC is en=
abled
> > error: corrupt patch at line 17
> >=20
> > cat ~/patches/v4_20240116_dwmw2_kvm_x86_xen_inject_vcpu_upcall_vector_w=
hen_local_apic_is_enabled.mbx | patch -p 1 --merge
> > patching file arch/x86/kvm/lapic.c
> > patch: **** malformed patch at line 59: =C2=A0#include "ioapic.h"
> >=20
> > Based on what I see in a web view, I suspect something on your end is c=
onverting
> > whitespace to fancy unicode equivalents.
> >=20
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 3242f3da2457..75bc7d3f0022 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -41,6 +41,7 @@
> > =3DC2=3DA0#include "ioapic.h"
> > =3DC2=3DA0#include "trace.h"
> > =3DC2=3DA0#include "x86.h"
>=20
> That isn't Unicode. Well, it *is*, but it's the subset of Unicode which
> is also plain old legacy 8-bit ISO8859-1. For some reason, Evolution
> has converted those spaces to non-breaking spaces. I have no idea why
> it's suddenly started doing that; this is a Long Term Nosupport distro
> that $employer forces me to use, and it hasn't even been updated for
> over a year.

Out of genuine curiosity, why not use `git send-email`?

> The patch is in
> https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=3Dref=
s/heads/xenfv
> where I'd gathered everything that was pending, but if you prefer I'll
> also resend it later when I deal with the locking thing we discussed a
> few minutes ago.=20

I'd prefer a resend so that I generate a lore link to exactly what I applie=
d.
No rush on either patch, I'm going to be mostly offline from now-ish throug=
h
tomorrow.

