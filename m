Return-Path: <kvm+bounces-8233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E53A84CDBD
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 16:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 047C6281FD0
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 15:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29CB7FBC4;
	Wed,  7 Feb 2024 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AtX7nhxl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617AA7F481
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707318633; cv=none; b=mi114vKRU8/xNtzaq66C71raRv8tIo7ugY3uJ/PI1J1GrN5oZHtj32QYlmDKQq3XyN7geq4lc+jQ4El5m35bk3wEe0/YkU0LdISAoCE5+q8U4sSjWCY+eZAz0ElMW95Jv/UGr+zLQrvix1qC45zARj7X0Q6Ayu1jmfb3kumpS5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707318633; c=relaxed/simple;
	bh=TDeuMYw3V5mfviFayWil0sUeiH295xl/tQfWNiFIdFg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c5cP8crJan6ef7nilO8tm8LT2tSHuZFgPERiyrQf/kbpr3gIJlHzYHKy/4M3Bv/4RGmp470zvGlpWPIc9AeTA01KgI9B7SRZCgiLMenPFa/2dKHZbxww8jAsEUD2uO6L20/6mcYU6386HbrpLNnBOhicPDoriT31AOteivlKPOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AtX7nhxl; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26eef6cso966507276.3
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 07:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707318630; x=1707923430; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C/5FPgGvRtWIxXt/NaMkBCrrVZJi2vGASXviIWBw83Q=;
        b=AtX7nhxlgibTRw+/Xuk1ltRXz6DAeXR1MOjqdE8mMFF5Q1PrKrmwcQ2E2imBhe5l+E
         DVVO95MQh6dG2yMwt7utxjtaBVlTlk4qd11EO6K3i+l8CLvR6kdlxt8m6kJSQw9DsS1D
         EIx8NoYelrredMlJj7KtQDH3JM90e/KNnwpYkUEuKjCsQkv8OzXuHuZ3ZzMIosC3rWKI
         N5UqY4+VBR5F8oFEn8wVaUa93sIi4LDQnoXlUlVSfCemXIfkCOHriP4SGwLopFs5d0EE
         /keGIyll82Q24nQQHjsDbdV+4cz2aq3IzBC+Hhxd5rXpbkVy88gzZWC5DQUKVyZ3p928
         UcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707318630; x=1707923430;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C/5FPgGvRtWIxXt/NaMkBCrrVZJi2vGASXviIWBw83Q=;
        b=gNZ8owu92ervLZfrxliKBv5Ot9gR8e/saF6r5TdGPbS1SXm5bc9lrwmrr5/cRQbrvu
         9ZAeT75NrjNhsrGmh7nGauRWNT2gw4+Ncl3qCWR5eqQcRDdCczsBsaKQrvmG2EQrRkMb
         TeWiulOruVZ/0HHPy3eYtXi+bSuzSeKAylESPFj8eS8CUAmuUFUDJOldJZMA6xDvLFpU
         KnD+0OmuwarvwrKaM/WjejtVHcB2CH1B/qclvgipE6nzrgSI8VeMFsJvH6wLuYA8xe/U
         1pZ3bLf+02ceP/WJdM+xzZhXaqcLZY2CXPEJeF0pju5zRBmYXDZk1Sl2f+HZswLwzwPz
         ovBg==
X-Gm-Message-State: AOJu0YzbFTZGuHeYLBTXQyK5Rni9z53eEmmla6O9xhCAWWQexyzcWOBH
	PvdKmH+lxlD1ZGfxwdJ9WkjmBcvUAqgvKwOEtg8moZCS2kBj4JqTUqJTi0jfdFwrWn7WXbAxmR9
	Ifw==
X-Google-Smtp-Source: AGHT+IFvJL9oypygwTLZ3VHM332NyBw8WKMDivEtxpFXSaOzxlyiHKWCNbhIvXGG/Y4f74o4QcvLCt4/dbI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:220c:b0:dc2:5456:d9ac with SMTP id
 dm12-20020a056902220c00b00dc25456d9acmr181054ybb.5.1707318630365; Wed, 07 Feb
 2024 07:10:30 -0800 (PST)
Date: Wed, 7 Feb 2024 07:10:28 -0800
In-Reply-To: <a817d64f3fe7b935a02e78df02dc0c6281e61af3.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <20240115125707.1183-19-paul@xen.org>
 <ZcMFb1epchA7Mbzo@google.com> <bbd59a2c0897d8ca642ea8c4787b829190e75a4d.camel@infradead.org>
 <ZcMLX5Omum3riZe8@google.com> <a817d64f3fe7b935a02e78df02dc0c6281e61af3.camel@infradead.org>
Message-ID: <ZcOdZKmmYz3kMgwp@google.com>
Subject: Re: [PATCH v12 18/20] KVM: pfncache: check the need for invalidation
 under read lock first
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 06, 2024, David Woodhouse wrote:
> On Tue, 2024-02-06 at 20:47 -0800, Sean Christopherson wrote:
> >=20
> > I'm saying this:
> >=20
> > =C2=A0 When processing mmu_notifier invalidations for gpc caches, pre-c=
heck for
> > =C2=A0 overlap with the invalidation event while holding gpc->lock for =
read, and
> > =C2=A0 only take gpc->lock for write if the cache needs to be invalidat=
ed.=C2=A0 Doing
> > =C2=A0 a pre-check without taking gpc->lock for write avoids unnecessar=
ily
> > =C2=A0 contending the lock for unrelated invalidations, which is very b=
eneficial
> > =C2=A0 for caches that are heavily used (but rarely subjected to mmu_no=
tifier
> > =C2=A0 invalidations).
> >=20
> > is much friendlier to readers than this:
> >=20
> > =C2=A0 Taking a write lock on a pfncache will be disruptive if the cach=
e is
> > =C2=A0 heavily used (which only requires a read lock). Hence, in the MM=
U notifier
> > =C2=A0 callback, take read locks on caches to check for a match; only t=
aking a
> > =C2=A0 write lock to actually perform an invalidation (after a another =
check).
>=20
> That's a somewhat subjective observation. I actually find the latter to
> be far more succinct and obvious.
>=20
> Actually... maybe I find yours harder because it isn't actually stating
> the situation as I understand it. You said "unrelated invalidation" in
> your first email, and "overlap with the invalidation event" in this
> one... neither of which makes sense to me because there is no *other*
> invalidation here.

I am referring to the "mmu_notifier invalidation event".  While a particula=
r GPC
may not be affected by the invalidation, it's entirely possible that a diff=
erent
GPC and/or some chunk of guest memory does need to be invalidated/zapped.

> We're only talking about the MMU notifier gratuitously taking the write

It's not "the MMU notifier" though, it's KVM that unnecessarily takes a loc=
k.  I
know I'm being somewhat pedantic, but the distinction does matter.  E.g. wi=
th
guest_memfd, there will be invalidations that get routed through this code,=
 but
that do not originate in the mmu_notifier.

And I think it's important to make it clear to readers that an mmu_notifier=
 really
just is a notification from the primary MMU, albeit a notification that com=
es with
a rather strict contract.

> lock on a GPC that it *isn't* going to invalidate (the common case),
> and that disrupting users which are trying to take the read lock on
> that GPC.

