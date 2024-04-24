Return-Path: <kvm+bounces-15743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 564108AFD83
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA4ED1F239A9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B8E4C9F;
	Wed, 24 Apr 2024 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lPM3EqdX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EEE947E
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 00:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713920320; cv=none; b=qmIsSv/0pDldlYAmPjRpUHPPdOfUx1tIxNhOWinOwZl8a5V/zoDE7YJRNpy9XLRfzJjFZaFtMt3oIcfFfY6zG0Sz+kOAhBYeLWtOTRiddBY2cx1KagO8r+7WWYb2jyOU+unMQuOJgqX/yLHpY3lqdtWpo5avH+Lge3ju8Mrj32o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713920320; c=relaxed/simple;
	bh=mmJKzpn56Y05MfN/M7Ttwvc9Q1m+oN3OU+dsYQVNYzc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EgPOeJi8jpBcdiESeLSkiNjlBGbI7Ctjc+iyKE2zhK/N8HR6FG9h/nFfS1HclAwPeU/cq2vsiGhSnC6NCbkHK3Fj8OwSxRzSG001Ew2r8uyXGtewx2QCbpzPa5OBy4nMRKebgXfNQ7u+R8M/r3NWnGORfQzKkR4rIxoAeWB5//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lPM3EqdX; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so9965011276.3
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 17:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713920317; x=1714525117; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TnFfv2/q8HD4zI2T3k05GE/1OzMTYZ/cFvDzD1pFbjs=;
        b=lPM3EqdX9usy5i4BxZs60X0T1U1uzOBVuHsbEiL1Ef6R6q70HUNdU5AYUGvEKhdC+J
         sEdIKWkNBhsACpEeNWzM4hY3VzkNHUFJxxw/tNRJq2Z4BO6rLSkNK9S5F5VH7KBLsMmz
         IaFshJMY/BT94Folc61L31lkOO5g2J7ak4a0LhMhKWMyB5z5txP+1YHGsLeAcTdIScjj
         Wn9IKuiCyDogZv3NA9Nm2JoegRpK0If5gFFTFT7VVI+C9f4tApXsMZRPj61EmBRl8UtK
         VW1b4dnLnQ9O7gIVovlGj/ElQMZlKK7EAjQwaIIQ26PyZAHVtrGv9AWTNVsGts6gOZiQ
         sr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713920317; x=1714525117;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TnFfv2/q8HD4zI2T3k05GE/1OzMTYZ/cFvDzD1pFbjs=;
        b=OoByYzqUrdeoUqvbiGR+z1cx/o/3OdwXeU7Kl3Ltnw96MOCcJ3WD2XbWD5MCNKYeIS
         3BNiAkbCyL5zr+zt7qKSflr3EIJtzu/6xFzII1ju7gYqZ39GC6xms8J38yu/Hkyo+pAI
         S0kU/arBz/L13/M+GlhZsmo7IP3riNUYkeh8JXM/0pp6lk4N+hA+HMSTOPctu2IJ5QC0
         8QcKxrSbdO4MC6VCXILBv1UVdUejFExan/GPvfdrGemPbDhW8GDnGUKcbt5jbwoev9c3
         Gg3rN+UAagVZz/jR88lapdNHWFI1M65DCzGey2x8vVTt6i5K9I4fFWyr809Ksgq17JHy
         2QdA==
X-Forwarded-Encrypted: i=1; AJvYcCU/L9iu8rXqVGyIdtzEdXg+51g1trid79zaov1GEZLhQ1hpNeCPhD4lweRAAVKzHUzvgwWY67NsF8SSyaKkS6DTPrtX
X-Gm-Message-State: AOJu0YwHsF+N5I1vKB1Gi0KTo+MLsQ360m50BtQeIvJtMvrRE8PKU8kG
	iczKdMR3wgO00PyjJWs6pxuUipEJ+bO8vIn2XBUVJQHEplwYC71DR8onFQ/5vmvDpdxZm9q1p82
	EJQ==
X-Google-Smtp-Source: AGHT+IEvNw3J6I/yHHAfvdURbb8jj1wTGZNW3lbpolt8uCEne9ZqLnMsHy6ndjJrs5y4tOm7Z4sHLAK8DkM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab2b:0:b0:dcc:8927:7496 with SMTP id
 u40-20020a25ab2b000000b00dcc89277496mr138421ybi.5.1713920317559; Tue, 23 Apr
 2024 17:58:37 -0700 (PDT)
Date: Tue, 23 Apr 2024 17:58:35 -0700
In-Reply-To: <20240409133959.2888018-5-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240409133959.2888018-1-pgonda@google.com> <20240409133959.2888018-5-pgonda@google.com>
Message-ID: <ZihZOygvuDs1wIrh@google.com>
Subject: Re: [PATCH 4/6] Add GHCB allocations and helpers
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2024, Peter Gonda wrote:
> Add GHCB management functionality similar to the ucall management.
> Allows for selftest vCPUs to acquire GHCBs for their usage.

Do we actually need a dedicated pool of GHCBs?  The conundrum with ucalls i=
s that
we have no place in the guest to store the pointer on all architectures.  O=
r rather,
we were too lazy to find one. :-)

But for SEV-ES, we have MSR_AMD64_SEV_ES_GHCB, and any test that clobbers t=
hat
obviously can't use ucalls anyways.  Argh, but we can't get a value in that=
 MSR
from the host.

Hmm, that seems like a KVM flaw.  KVM should advertise its supported GHCB p=
rotocol
to *userspace*, but userspace should control the actual information exposed=
 to
the guest.

Oof, and doesn't SNP support effectively *require* version 2?  I.e. shouldn=
't
the KVM patch[*] that adds support for the AP reset MSR protocol bump the v=
ersion?
The GHCB spec very cleary states that that's v2+.

And what if userspace wants to advertise v2 to an SEV-ES guest?  KVM should=
n't
switch *all* SEV-ES guests to v2, without a way back.  And the GHCB spec cl=
early
states that some of the features are in scope for SEV-ES, e.g.

  In addition to hypervisor feature advertisement, version 2 provides:

  SEV-ES enhancements:
     o GHCB Format Version 2:
        =E2=96=AA The addition of the XSS MSR value (if supported) when CPU=
ID 0xD is
          requested.
        =E2=96=AA The shared area specified in the GHCB SW_SCRATCH field mu=
st reside in the
          GHCB SharedBuffer area of the GHCB.
     o MSR protocol support for AP reset hold.

So I'm pretty sure KVM needs to let userspace set the initial value for
MSR_AMD64_SEV_ES_GHCB.  I suppose we could do that indirectly, e.g. through=
 a
capability.  Hrm, but even if userspace can set the initial value, KVM woul=
d need
to parse the min/max version so that KVM knows what *it* should support, wh=
ich
means that throwing in a GPA for selftests would screw things up.

Blech.  Why do CPU folks insist on using ascending version numbers to bundl=
e
features?

Anyways, back to selftests.  Since we apparently can't stuff MSR_AMD64_SEV_=
ES_GHCB
from host userspace, what if we instead use a trampoline?  Instead having
vcpu_arch_set_entry_point() point directly at guest_code, point it at a tra=
mpoline
for SEV-ES guests, and then have the trampoline set MSR_AMD64_SEV_ES_GHCB t=
o
the vCPU-specific GHCB before invoking guest_code().

Then we just need a register to stuff the GHCB into.  Ah, and the actual gu=
est=20
entry point.  GPRs are already part of selftest's "ABI", since they're set =
by
vcpu_args_set().  And this is all 64-bit only, so we can use r10+.

Ugh, the complication is that the trampoline would need to save/restore RAX=
, RCX,
and RDX in order to preserve the values from vcpu_args_set(), but that's ju=
st
annoying, not hard.  And I think it'd be less painful overall than
having to create a GHCB pool?

In rough pseudo-asm, something like this?

static void vcpu_sev_es_guest_trampoline(void)
{
	asm volatile(<save rax, rcx, rdx>
		     "mov %%r15d, %%eax\n\t"
		     "shr %%r15, $32\n\t"
		     "mov %%r15d, %%eax\n\t"
		     "mov $MSR_AMD64_SEV_ES_GHCB, %%ecx\n\t"
		     <restore rax, rcx, rdx>
		     "jmp %%r14")
}

[*] https://lore.kernel.org/all/20240421180122.1650812-3-michael.roth@amd.c=
om

