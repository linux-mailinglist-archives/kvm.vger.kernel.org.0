Return-Path: <kvm+bounces-53669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CEEFB153C1
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 21:44:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BC1A5A2C19
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 19:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27208254AE1;
	Tue, 29 Jul 2025 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kMTF12wc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97BB254876
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 19:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753818261; cv=none; b=EyVMa201h9bhhkcJzHDuT1mlKo766vrP9oJPYRTwL0q6xq/wdufhfCEmLEBPEpS144lf6mLv2uW+WCKKpz5AA8UPmEtC5ctLRUUEaXgdePQ6nWzTsBnYnk8RvjxoSdtq/5jXxTabf9kkOY53DkIROayLnA1IEVzlHY+lBD6lrys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753818261; c=relaxed/simple;
	bh=4NhlkQG5nwfS/M+XM7YALx4FrZl/obGidC+Z8jkLhZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CGaF1nqnl1v3IDqZqJ/tC00hyUHy7fmSVlZwnpqGy3PnZvogkpvsS2uIWs8JpP2Rp2fdDHaUg35uQh52yOnzT3LQ0dOBDudBm1BUIo/hzvWlC6YgWzzc1npgTG2wygMWdM3i5ZecQ/hWDaPYtBbKCXgYv2Py+3p76wAm3wK1v5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kMTF12wc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3928ad6176so102424a12.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 12:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753818259; x=1754423059; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVG8KH1bhcF8abnqt3jf4aA5/80VQ7aWwN+Mg1mK9eE=;
        b=kMTF12wcbu2OwFgglDZ207JD29OJ7e7QaoRal8valC9XRKwQgJ/zK5VpXmYhEHzIxB
         JFpQKmP9pdtrzKun43unC5XXiXcfdrvPf1RBFNFjXZicRQ5Mo69McMCKeRj9keqyOriD
         mCpfnDHgimhZHLkMP9aTHDU3UVaszgyP8jYvEZx6FnvoNMaWl0fmnV80Qw4W9+Ymz7Ha
         CW7rszlX6xqf3p1MZE7ELRwZoQ9A5y5UtHBuda15WPapflkLmR7afDkDRZclFJU/AeGR
         G9Gh7exuEWa5njItMqMYeW8s3vZFx9wqjjCv8Vdr7lB1LalRjcHV46mPgsCH1i2hd55Q
         blxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753818259; x=1754423059;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eVG8KH1bhcF8abnqt3jf4aA5/80VQ7aWwN+Mg1mK9eE=;
        b=ODShCiJF/Xcq3YPeg5lnEzG5MK50DBSi/OInc6qoGBOT2P31KP18bH7mNFdWH4wi93
         +GTQtqz5myvcCaJYH/e8hXoW/OfMK+ZwbVJACjyDEAMO591uoTUkqiwMl/j0Uem4jmh2
         fQ3oHlOrFSTnBRelW8yGD351yvignqjuY3FH/PP7Cq9cGAZ3o7HJWstiEoanu1t9bp8x
         Sqp7/QFfyfO7dkM/73jQ0VYsRJ1M3FLPDIVXdjjz5hDUhWDHPZivBykKJKZeI/ApSyA2
         F4e/3Ac1OKSHlqxGbh4jyBuxtCxEaMDfrYpkh6k3+GdppMpWrDyxNnL/df+SGQnZvMzp
         T4pQ==
X-Gm-Message-State: AOJu0YwiDiQdxvEpbAaJcvGlyA/3MJyAQX9rSDrQFBC/FIl3Zi1+ee42
	z5UB5jzx7hznmnTB3gH/S3m8bMSYA+BJOpOA9FlBEhgeTv7Lp+HKEbR4udgl/ybyCjbJWXjs9B2
	3pOrFNQ==
X-Google-Smtp-Source: AGHT+IEleXU6AO56sL1Ffo3R7yl8PCA/VHXbTByIKMTDyDAdpjv6mAuy4Yn1q8GPIS+x/U/g0Sv32OU9yJ8=
X-Received: from pjvf8.prod.google.com ([2002:a17:90a:da88:b0:31c:2fe4:33be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48cf:b0:2fe:85f0:e115
 with SMTP id 98e67ed59e1d1-31f5de6c834mr785000a91.26.1753818259287; Tue, 29
 Jul 2025 12:44:19 -0700 (PDT)
Date: Tue, 29 Jul 2025 12:44:17 -0700
In-Reply-To: <CABgObfZWvtskg-m94LRHqN=_FtJpFtTzOi3sEhiAKZx1rzr=ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250725220713.264711-1-seanjc@google.com> <20250725220713.264711-13-seanjc@google.com>
 <CABgObfZWvtskg-m94LRHqN=_FtJpFtTzOi3sEhiAKZx1rzr=ng@mail.gmail.com>
Message-ID: <aIkkkaqTbc9vG_x3@google.com>
Subject: Re: [GIT PULL] KVM: x86: VMX changes for 6.17
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025, Paolo Bonzini wrote:
> On Sat, Jul 26, 2025 at 12:07=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > Add a sub-ioctl to allow getting TDX VMs into TEARDOWN before the last =
reference
> > to the VM is put, so that reclaiming the VM's memory doesn't have to ju=
mp
> > through all the hoops needed to reclaim memory from a live TD, which ar=
e quite
> > costly, especially for large VMs.
> >
> > The following changes since commit 347e9f5043c89695b01e66b3ed111755afcf=
1911:
> >
> >   Linux 6.16-rc6 (2025-07-13 14:25:58 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.17
> >
> > for you to fetch changes up to dcab95e533642d8f733e2562b8bfa5715541e0cf=
:
> >
> >   KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM (2025-07-21 16:23:02 -07=
00)
>=20
> I haven't pulled this for now because I wonder if it's better to make
> this a general-purpose ioctl and cap (plus a kvm_x86_ops hook).  The
> faster teardown is a TDX module quirk, but for example would it be
> useful if you could trigger kvm_vm_dead() in the selftests?

I'm leaning "no" (leaning is probably an understatement).

Mainly because I think the current behavior of vm_dead is a mistake.  Rejec=
ting
all ioctls if kvm->vm_dead is true sounds nice on paper, but in practice it=
 gives
us a false sense of security due to the check happening before acquiring kv=
m->lock,
e.g. see the SEV-ES migration bug found by syzbot.

Enforcing vm_dead with 100% accuracy would be painful given that there are =
ioctls
that deliberately avoid kvm->lock (vCPU ioctls could simply check KVM_REQ_V=
M_DEAD),
and I'm not at all convinced that truly making the VM off-limits is actuall=
y
desirable.  E.g. it prevents quickly freeing resources by nuking memslots.

I do think it makes sense to reject ioctls if vm_bugged is set, because vm_=
bugged
is all about limiting the damage when something has already gone wrong, i.e=
.
providing any kind of ABI is very much a non-goal.

And if the vm_dead behavior is gone, I don't think a generic KVM_TERMINATE_=
VM
adds much, if any value.  Blocking KVM_RUN isn't terribly interesting, beca=
use
VMMs can already accomplish that with signals+immediate_exit, and AFAIK, re=
al-world
use cases don't have problems with KVM_RUN being called at unexpected times=
.

One thing that we've discussed internally (though not in much depth) is a w=
ay to
block accesses to guest memory, e.g. to guard against accesses to guest mem=
ory
while saving vCPU state during live migration, when the VMM might expect th=
at
guest memory is frozen, i.e. can't be dirtied.  But we wouldn't want to ter=
minate
the VM in that case, e.g. so that the VM could be resumed if the migration =
is
aborted at the last minute.

So I think we want something more along the lines of KVM_PAUSE_VM, with spe=
cific
semantics and guarantees.

As for this pull request, I vote to drop it for 6.17 and give ourselves tim=
e to
figure out what we want to do with vm_dead.  I want to land "terminate VM" =
in
some form by 6.18 (as the next LTS), but AFAIK there's no rush to get it in=
to
6.17.

I posted a series with a slightly modified version of the KVM_TDX_TERMINATE=
_VM
patch[1] to show where I think we should go.  We discussed the topic in v4 =
of the
KVM_TDX_TERMINATE_VM patch[2], but I opted to post it separate (at the time=
)
because there wasn't a strict dependency.

[1] https://lore.kernel.org/all/20250729193341.621487-1-seanjc@google.com
[2] https://lore.kernel.org/all/aFNa7L74tjztduT-@google.com

> As a side effect it would remove the supported_caps field and separate
> namespace for KVM_TDX_CAP_* capabilities, at least for now.

