Return-Path: <kvm+bounces-30318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0815B9B94CF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26FD41C20EEA
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3737B1C9B97;
	Fri,  1 Nov 2024 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kt0RV8G7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673AF1A0B16
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730476760; cv=none; b=b7g0L2HWGGyEkyyTMSKatBtFgQXcP2SxE2HUTYbt1dHYar6YewgsCUWkLuf28VsXXtLfLC4zro4T0KcdI69agsPWX5B8R1yo/O9RLRhinoVBNKmh62LWzqRzOucSM19+stJU4vrD/Q/1oCtUUH3XnvSJ1qzsMZBYpWi6N4REEAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730476760; c=relaxed/simple;
	bh=oUD7RnhWQWlMRs16xW0PhkgQoTIgz9ocJOKfciQcXtk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mAbK2bGSKhdhx+A8iq9h7gd+A10OA1NDNzEjrA3/l9tBlvXCCyl4Okrr5xt+c7wMscsiVOxV8gyczezH6ctIM7ymsybBXHTU1izH+D/L1LW2QnNWrl0UPLhDAFhD4PC8XLAn+TH0COlmpTX5cEzP00y8AauDKvTwfiCxZCwg1rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kt0RV8G7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eb07db7812so1715097a12.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 08:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730476758; x=1731081558; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G7C7udYDSGtBe+UDNEgx3LKkpcEb5Jn+SrINvorUJ5I=;
        b=Kt0RV8G7b3Qd4Y/oFoB9taPX4OU3QJoXTYcRxSeF+4Nkguif7YVX707ADXwJZxtSTv
         Kp9196S/XH4olDmZQqlbN2BZxrAHSbuGra64Eu22QEIC3grekPJlia4St2Tqf34oBC/U
         F1ECdCHGCfwdZSnxdUYXIhHOLpwdEVbaro6vzFAIqTkV27UkQFzqSlbuwRsYMwjptPrB
         wKfB4wTo1hze/f1yQFSfDdNjrLPPd07Nor8cu6N+D4yOj5Vb8eS4eDvVxXcS7/uTSfP/
         DQkfH95OcTeQpR1bvV6cTYcA+zUIuHKK/0GOSYaQ2m+FwnNmhijR5td5XS5XkAGc3Xem
         GgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730476758; x=1731081558;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G7C7udYDSGtBe+UDNEgx3LKkpcEb5Jn+SrINvorUJ5I=;
        b=fHkLGmJS3M7gU9HFxWWB64SLgYzwpKW6zaoE/a1IVlZlZzO8tEtarwRj3s4uawoJOm
         XyK01SIfH9EF2i5/TYBaqpUvZryv0FL6Eya55CLKTKehj0v6O3hFlqP2di+poHdY0+SB
         5kXEo3+0gDipW6QdUto5TO5VczYEaT/yMB2p4oe0/xfvoe4RMf1MWlk1BVY9B/TtTXcA
         cyzcVAEYFSOMCytdpOgzQtCFqoJLDkQZ/VCQPm7xxfWXFmbWhuus5XLiqPaXrd8/9Jw/
         KtfyZDOsOlCOmr9nzcTJxiCSBIDme6Kd8xfgaZE3d7TBT7+VDJkkwveOXv04UFMElvNC
         UIEA==
X-Forwarded-Encrypted: i=1; AJvYcCWPYA2Ni8jTprKD3fMF1p4IPM+Czx/9j7ULR+NrqFelnPwTVMLpduyEOA/CI5VzE5U5RFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZqVM3F/wbjQ2Oah8vv/o16D7IF9hXEhKVT9o3XqjLYdcxPoKT
	x7D39vn4xJUNooMsRJFbrCWKq9w5C7TaAdEX+qQE3ERjgmLeZAYF9/AgI4Fqtodxf2WxzD6laF2
	RzQ==
X-Google-Smtp-Source: AGHT+IHdP6G2fJCdE/LEn9b4GNy3yTcluEwmDEOjmuidoXhD2Yg5GyJmi1fYyuRyUM0NRBeCXSVah99A4Vc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:5658:0:b0:7ea:d01a:e37a with SMTP id
 41be03b00d2f7-7ee44becc77mr9923a12.4.1730476757639; Fri, 01 Nov 2024 08:59:17
 -0700 (PDT)
Date: Fri, 1 Nov 2024 08:59:16 -0700
In-Reply-To: <ZyT2CB6zodtbWEI9@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk> <ZyTpwwm0s89iU9Pk@google.com>
 <ZyT2CB6zodtbWEI9@linux.dev>
Message-ID: <ZyT61FF0-g8gKZfc@google.com>
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2024, Oliver Upton wrote:
> Hey,
>=20
> On Fri, Nov 01, 2024 at 07:48:00AM -0700, Sean Christopherson wrote:
> > On Fri, Nov 01, 2024, Mark Brown wrote:
> > > On Wed, Oct 09, 2024 at 08:49:42AM -0700, Sean Christopherson wrote:
> > > > Return a uint64_t from vcpu_get_reg() instead of having the caller =
provide
> > > > a pointer to storage, as none of the vcpu_get_reg() usage in KVM se=
lftests
> > > > accesses a register larger than 64 bits, and vcpu_set_reg() only ac=
cepts a
> > > > 64-bit value.  If a use case comes along that needs to get a regist=
er that
> > > > is larger than 64 bits, then a utility can be added to assert succe=
ss and
> > > > take a void pointer, but until then, forcing an out param yields ug=
ly code
> > > > and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg=
().
> > >=20
> > > This commit, which is in today's -next as 5c6c7b71a45c9c, breaks the
> > > build on arm64:
> > >=20
> > > aarch64/psci_test.c: In function =E2=80=98host_test_system_off2=E2=80=
=99:
> > > aarch64/psci_test.c:247:9: error: too many arguments to function =E2=
=80=98vcpu_get_reg=E2=80=99
> > >   247 |         vcpu_get_reg(target, KVM_REG_ARM_PSCI_VERSION, &psci_=
version);
> > >       |         ^~~~~~~~~~~~
> > > In file included from aarch64/psci_test.c:18:
> > > include/kvm_util.h:705:24: note: declared here
> > >   705 | static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, ui=
nt64_t id)
> > >       |                        ^~~~~~~~~~~~
> > > At top level:
> > > cc1: note: unrecognized command-line option =E2=80=98-Wno-gnu-variabl=
e-sized-type-not-at
> > > -end=E2=80=99 may have been intended to silence earlier diagnostics
> > >=20
> > > since the updates done to that file did not take account of 72be5aa6b=
e4
> > > ("KVM: selftests: Add test for PSCI SYSTEM_OFF2") which has been merg=
ed
> > > in the kvm-arm64 tree.
> >=20
> > Bugger.  In hindsight, it's obvious that of course arch selftests would=
 add usage
> > of vcpu_get_reg().
> >=20
> > Unless someone has a better idea, I'll drop the series from kvm-x86, po=
st a new
> > version that applies on linux-next, and then re-apply the series just b=
efore the
> > v6.13 merge window (rinse and repeat as needed if more vcpu_get_reg() u=
sers come
> > along).
>=20
> Can you instead just push out a topic branch and let the affected
> maintainers deal with it? This is the usual way we handle conflicts
> between trees...

That'd work too, but as you note below, doing that now throws a wrench in t=
hings
because essentially all arch maintainers would need merge that topic branch=
,
otherwise linux-next would end up in the same state.

> > That would be a good oppurtunity to do the $(ARCH) directory switch[*] =
too, e.g.
> > have a "selftests_late" or whatever topic branch.
>=20
> The right time to do KVM-wide changes (even selftests) is *early* in the
> development cycle, not last minute. It gives us plenty of time to iron ou=
t
> the wrinkles.

Yeah, that was the original plan, then the stupid strict aliasing bug happe=
ned,
and I honestly forgot the vcpu_get_reg() changes would need to be consumed =
by
other architectures.

Other than letting me forget about this mess a few weeks earlier, there's n=
o
good reason to force this into 6.13.  So, I'll drop the series from 6.13, p=
ost
new versions of the this and the $(ARCH) series just before the merge windo=
w,
and then either send a pull request to Paolo for 6.14 as soon as the 6.13 m=
erge
window closes, or ask/bribe Paolo to apply everything directly.

