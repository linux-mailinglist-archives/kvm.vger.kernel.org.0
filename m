Return-Path: <kvm+bounces-15955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA758B26FA
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD801C20D3F
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29C2914D6E5;
	Thu, 25 Apr 2024 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3llwT5X9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7E131746
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064356; cv=none; b=jtdHcQqk7WpfSzqkjJIKc0SRZC6LfvNuZB5Nkj/NYie9x6bNupUAMHKUyDR4bFDMNDC+/zoJJlml94WaGnss9e7iVT2wMxqip5oK4MADQd7rJto+F2L33//rvfEhvn8kMNUyqqRB1T80QSrH/Z6VpEZRwzM6rAtAoPBj9pwunAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064356; c=relaxed/simple;
	bh=k9YshUQgCbTLWcIZ9NTqZp6bDZiJRu6BIqHMSvdfKn8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jf3+iGgwZQjCGTpBY9+caeK8uGfj3Yul4IEo5kmhHvnACyF6ZbDIY6gtItdrfuaploZURtUpD5m3aP0mBKtQZIsKPaOTC1ULpbOTdLbbbbB11v0cyMxr1jePi0pjYDIq6BBGKXz1Q42+d5Js4039i+H/eKRb2j04jUQrncrLj0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3llwT5X9; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de54be7066bso2252969276.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714064354; x=1714669154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1hXeo96+/vb09V/VI5ziQ0e9n0cZLQ/jDx95y8eWPXw=;
        b=3llwT5X9I+b1AaO5pq4EkTyLD6VrqUUG7olGzQv2wMkxL5+AtK8napDfLXzfIov8Iu
         vjv8S9P9yxvqVd/BIG2VYUOd4Ahp3+xfj5SCzpy3w3xwUjapFD5u8RdXu24/55yIRWB/
         pxaaF3bcUwUXFN1ZqC/reHTMdSmx2jDq5XunD2K0yMenTcSJJpBOOPbpI5PPyngCR7wT
         HzSZCLMiomytW3c9VazqGHQSxE76gU/mTe8rJVnLYMiVopFbLnuUFXhtVAlfjBpbwB2m
         eJdxSvEpJ6i9Beoy5dIPBMtUye8yibJP7AyrHDL5DZzeMzU8afLOM5o6RH3Jf0hfrIIg
         ZBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714064354; x=1714669154;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1hXeo96+/vb09V/VI5ziQ0e9n0cZLQ/jDx95y8eWPXw=;
        b=bfc0djTYedgFbTENERv9sgnuK8hWkPrIQpm00l7Zlv+sNmy+akWxxzfgegcfkl50UW
         3aVOrDLoKNaGX3oP1CHPVN1BLbahexKMAssqhybhhE18TYfDAPZ73AZX72qJNH/g96oz
         6cd1cYK8mHvvkX0+kx2b7WTs5WrQg5AQ5OTchQdYeGkgCLWdhobje6UKgP9ExKKlxkOL
         r2lldMQaMzbrIDlWM7Yz2qa5ce7cQTt+h6XAxePFaZhOpAW0SeZbFUfPhHkenKx8UeYJ
         KOBHaNnnIBDeeihId034ZB1oDW8OvI7WwJsK3bMpX25XWZBwT0GvLCr/5DTfMe/Tz+SN
         Kbcw==
X-Forwarded-Encrypted: i=1; AJvYcCXzvUEojUqhww9GmXh53/U2TzuvrcaqI8rOJCm/bWoXEx9i1Iz7bSLxqAqEXKkQVN0MgKdNKCIDxrjVVOjx2SiXsmcr
X-Gm-Message-State: AOJu0Yyput2/50vyyciBOm9K3/EAiZcc63U/514gmULlhyzoRReURTmX
	MKdtOof0pU4vjsErmIMfyJR8ZgVU+ZtDIdNHSHewcwsAMB2M4H2/Ax39ipHuLTaFxU5QJOjGH7a
	F6Q==
X-Google-Smtp-Source: AGHT+IHSzYLKg5XZ9oMM7Ds74tfJOzPyZMvU7nuQbF+0tX6pcWmAiKJDRJ/DGHMVDRbZA5M2Z3a9vozg/zs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6884:0:b0:dcc:6065:2b3d with SMTP id
 d126-20020a256884000000b00dcc60652b3dmr41398ybc.8.1714064354095; Thu, 25 Apr
 2024 09:59:14 -0700 (PDT)
Date: Thu, 25 Apr 2024 09:59:12 -0700
In-Reply-To: <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com> <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
Message-ID: <ZiqL4G-d8fk0Rb-c@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-04-25 at 23:09 +0800, Xiaoyao Li wrote:
> > > The idea is that TDX module could add the capability to configure the=
se
> > > bits as well, so that TDs could match normal VMs for cases where ther=
e is
> > > a desire for the guests MAXPA to be smaller than the hosts. The
> > > requirements would be,
> > > roughly:
> > > =C2=A0=C2=A0 - The VMM specifies the=E2=80=AF0x80000008.EAX[23:16] wh=
en creating a TD.
> > > =C2=A0=C2=A0 - The TDX module does sanity checking.=E2=80=AF
> > > =C2=A0=C2=A0 - The 0x80000008.EAX[23:16] field is used to communicate=
 the max
> > > addressable
> > > =C2=A0=C2=A0 GPA to=E2=80=AF the guest. It will be used by the guest =
firmware to make sure
> > > =C2=A0=C2=A0 resources like PCI bars are mapped into the addressable =
GPA.
> > > =C2=A0=C2=A0 - If the guest attempts to access memory beyond the max =
addressable GPA,
> > > then
> > > =C2=A0=C2=A0 the TDX module generates EPT violation to the VMM. For t=
he VMM, this case
> > > =C2=A0=C2=A0 means that the guest attempted to access "invalid" (I/O)=
 memory.
> > > =C2=A0=C2=A0 - The VMM will be expected to terminate the TD guest. Th=
e VMM may send
> > > =C2=A0=C2=A0 a notification, but the TDX module doesn't necessarily n=
eed to know how.
> >=20
> > This is not the same as how it works for normal (non-TDX) VMs.
> >=20
> > For normal VMs, when userspace configures a smaller one than what=20
> > hardware EPT/NPT supports, it doesn't cause any issue if guest accesses=
=20
> > GPA beyond [23:16] but within hardware EPT/NTP capability.
> >=20
> > It's more a hint to guest that KVM doesn't enforce the semantics of it.=
=20
> > However, for TDX case, you are proposing to make it a hard rule.
>=20
> If we limit ourselves to worrying about valid configurations,

Define "valid configurations". =20

> accessing a GPA beyond [23:16] is similar to accessing a GPA with no mems=
lot.

No, it's not.  A GPA without a memslot has *very* well-defined semantics in=
 KVM,
and KVM can provide those semantics for all guest-legal GPAs regardless of
hardware EPT/NPT support.

> Like you say, [23:16] is a hint, so there is really no change from KVM's
> perspective. It behaves like normal based on the [7:0] MAXPA.
>=20
> What do you think should happen in the case a TD accesses a GPA with no m=
emslot?
=20
Synthesize a #VE into the guest.  The GPA isn't a violation of the "real" M=
AXPHYADDR,
so killing the guest isn't warranted.  And that also means the VMM could le=
gitimately
want to put emulated MMIO above the max addressable GPA.  Synthesizing a #V=
E is
also aligned with KVM's non-memslot behavior for TDX (configured to trigger=
 #VE).

And most importantly, as you note above, the VMM *can't* resolve the proble=
m.  On
the other hand, the guest *might* be able to resolve the issue, e.g. it cou=
ld
request MMIO, which may or may not succeed.  Even if the guest panics, that=
's
far better than it being terminated by the host as it gives the guest a cha=
nce
to capture what led to the panic/crash.

The only downside is that the VMM doesn't have a chance to "bless" the #VE,=
 but
since the VMM literally cannot handle the "bad" access in any other than ki=
lling
the guest, I don't see that as a major problem.

> KVM/QEMU don't have a lot of options to recover. So are the differences h=
ere
> just the existing differences between normal VMs and TDX?

