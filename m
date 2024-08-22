Return-Path: <kvm+bounces-24829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B310095B956
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A712285405
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAEC61CC8AB;
	Thu, 22 Aug 2024 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UMtp4cPd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5631CC899
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339408; cv=none; b=cymJrwO9v3kv05lGub/ITcyIUf5jZQNzjqSazsYqhLrsmXD1PV1D3pc+A3WWLMNFG/gu5VbSmaq9KkkFzg8BCHL7MZwwWKmxmb7a/my+rp+ie5yRSm4x9bXMVO/TMTxr9pTeMmnKveEXUHVPd8N9rMfQJV5TsXS0WT0OgRpHiw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339408; c=relaxed/simple;
	bh=c3I7buk4tUQcr/u25swN2CXyF+WBbofaqBKNbfFLBsM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLu/F8smGortIkYJW3GNI3dUCguEGM6Gf2xeLclGyPqKukgnfm4/9F/jdB6hydboJ1Y4cMxLdGwB9QCAc73NHLa4MjlUIcos6mzpHRiWz89S1VauyrpgsYfMIvqkhkJ3QArk+ve9gurdykSCUk5B7qzQw7xtNoetBOybIlWAzkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UMtp4cPd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7cd7614d826so1579096a12.1
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 08:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724339407; x=1724944207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=643YWobn45dY5QcBzGk3WYdfoAeJ4WQTeZn0Zjx4tzM=;
        b=UMtp4cPdPH5AjVLrOw1p3BSB2vcuSwUMWd6lJ2XtMksmwIMsKg8zlDIu/0/R5D/oad
         o5TPeB2SbxWeIlCRNlttLGCvi5J1vedS93NxZHIOU57rU8AubiY7D1FSIAgysjOhJho0
         Gn2a6exbI14c3RbUHop9hn53ZZFJp3OZYiC+w6GF4bENlDnwnejgvnq6rG7Qvc+bImeU
         WefvbCkR9wClmS5nVFMZiU7+iKutNXFGpnpSPcO+rDoKlFjrEtPonQIGa/SgoW0zKXK8
         IjRHsxretuJaCPCvfuQqI3cHjLi37fbja2qvdUnQIzDAF7sfIgTgLffZiTs2kt+nblxz
         tfjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724339407; x=1724944207;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=643YWobn45dY5QcBzGk3WYdfoAeJ4WQTeZn0Zjx4tzM=;
        b=D3ipz1qSkia9KZ/UXvONxIs+exh4KkqFIDBsHn2kM7yr2ZmHhMOxKtNTcg1GcCg1VT
         RiAe7XrTWb9tGaFmGNxroONUluTxlWGrkUA4VFOPRqJyjJdK4KlNw6l/scKB1gNE/IZf
         k3/1qj5pdPeZU41BbA7DuxQ/XPIfzvbTAwRSoouCSURxCGn5QlCvKRvi4PBcIa5TPWvl
         Og6PniebwMjbuUOaocbgVz5M4z8X4sbA7IL/sSquJ41wP/LPp9Ebpg4Ehd24VIVMTIeg
         lQ1YpO4XCYBgxQKBdZgaHdW2UHaU/Fgr5/lrxj4OQ2iUzoPMZEHmKBlIfn+7/bjzLAxc
         G6AA==
X-Forwarded-Encrypted: i=1; AJvYcCUJsd3/KNNwBgJOa3P54ZD+b40kARmlX834i4svJ7LvXdVpuuGcyVgJFcHBJ1EMgHG1V40=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/EK02gXinvKPBKj9QSynKhWpTdlfDBjIV6cRWixtFbBBJsAKR
	saMwQCGl/9H0AfUe0mIKgb53fyisMVmd/D0cJyO+tJpsi27xxfJS+19YibugQpFWbpdunBc8m9Q
	j1g==
X-Google-Smtp-Source: AGHT+IFUQxJ95NYOhTSaiiBKCDpgjReT2ojuWAszN/BKnOXN4Uvnr6HpbA+zv+mFGZkFF+fqJw9PcQeNPfE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:8c88:b0:2c5:2b19:4218 with SMTP id
 98e67ed59e1d1-2d6164d5f46mr23335a91.3.1724339406644; Thu, 22 Aug 2024
 08:10:06 -0700 (PDT)
Date: Thu, 22 Aug 2024 08:10:05 -0700
In-Reply-To: <CALzav=ckxa9iP8zc9oOu69DxVhEjxrqMamv6HwGB+AzRxOf0vQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com> <20240805233114.4060019-2-dmatlack@google.com>
 <Zr_XE6NG1c-rNXEl@google.com> <CALzav=ckxa9iP8zc9oOu69DxVhEjxrqMamv6HwGB+AzRxOf0vQ@mail.gmail.com>
Message-ID: <ZsdUze9lqEARxgyI@google.com>
Subject: Re: [PATCH 1/7] Revert "KVM: x86/mmu: Don't bottom out on leafs when
 zapping collapsible SPTEs"
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 16, 2024, David Matlack wrote:
> On Fri, Aug 16, 2024 at 3:47=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > The proposed approach will also ignore nx_huge_page_disallowed, and jus=
t always
> > create a huge NX page.  On the plus side, "free" NX hugepage recovery! =
 The
> > downside is that it means KVM is pretty much guaranteed to force the gu=
est to
> > re-fault all of its code pages, and zap a non-trivial number of huge pa=
ges that
> > were just created.  IIRC, we deliberately did that for the zapping case=
, e.g. to
> > use the opportunity to recover NX huge pages, but zap+create+zap+create=
 is a bit
> > different than zap+create (if the guest is still using the region for c=
ode).
>=20
> I'm ok with skipping nx_huge_page_disallowed pages during disable-dirty-l=
og.
>=20
> But why is recovering in-place is worse/different than zapping? They
> both incur the same TLB flushes. And recovering might even result in
> less vCPU faults, since vCPU faults use tdp_mmu_split_huge_page() to
> install a fully populated lower level page table (vs faulting on a
> zapped mapping will just install a 4K SPTE).

Doh, never mind, I was thinking zapping collapsible SPTEs zapped leafs to i=
nduce
faults, but it does the opposite and zaps at the level KVM thinks can be hu=
ge.

> > So rather than looking for a present leaf SPTE, what about "stopping" a=
s soon as
> > KVM find a SP that can be replaced with a huge SPTE, pre-checking
> > nx_huge_page_disallowed, and invoking kvm_mmu_do_page_fault() to instal=
l a new
> > SPTE?  Or maybe even use kvm_tdp_map_page()?  Though it might be more w=
ork to
> > massage kvm_tdp_map_page() into a usable form.
>=20
> My intuition is that going through the full page fault flow would be
> more expensive than just stepping down+up in 99.99999% of cases.

Hmm, yeah, doing the full fault flow isn't the right place to hook in.  Ugh=
, right,
and it's the whole problem with not having a vCPU for tdp_mmu_map_handle_ta=
rget_level().
But that's solvable as it's really just is_rsvd_spte(), which I would be a-=
ok
skipping.  Ah, no, host_writable is also problematic.  Blech.

That's solvable too, e.g. host_pfn_mapping_level() could get the protection=
, but
that would require checking for an ongoing mmu_notifier invalidation.  So a=
gain,
probably not worth it.  Double blech.

> And will require more code churn.

I'm not terribly concerned with code churn.  I care much more about long-te=
rm
maintenance, and especially about having multiple ways of doing the same th=
ing
(installing a shadow-present leaf SPTE).  But I agree that trying to remedy=
 that
last point (similar flows) is probably a fool's errand in this case, as cre=
ating
a new SPTE from scratch really is different than up-leveling an existing SP=
TE.

I still have concerns about the step-up code, but I'll respond to those in =
the
context of the patch I think is problematic.

