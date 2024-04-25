Return-Path: <kvm+bounces-15976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E01AF8B2B19
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DC6F1F218EB
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 21:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 383B2157460;
	Thu, 25 Apr 2024 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DsMASKQz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EAB156F37
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 21:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714081153; cv=none; b=f7IAHKprMNfg/F7JN8G9e8PVYANH0WCT1lzPooDKGe1ecqi6r3ELZLn/EVaR6yI9BpAVMZXaFxG37Q74It5XLMrfE9Gmr/WroFb57NrThiQibpkkec+KIaHP8dXk1V5cB/761VT7HH+kcFeuXDILaqZoBocKNqj/+n/uw0PK8aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714081153; c=relaxed/simple;
	bh=yd5u1oOGbhyw2Zvum0gm5GqaQ9oLc76yFir4VJM97zA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RPfNd1qufag3VTxNkBYjQVx+RS3HpCsrh1nwkXcJt7CmyKoQNU7kWXTgiXgaUgy4TVbe+FkeMy6YoZiipGfTimkcQB349zVlge+E0xef9utMMOAiT2hezY51/h5F3UiKAwE2abIlraYM+WKMqHelDXl8Dxljmprx9z7gR88MYqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DsMASKQz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a48ed89c7eso1759065a91.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714081151; x=1714685951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKP/ivq5scsi0oRgSnjHb6xCz9q0E17Uir7siKnQvWc=;
        b=DsMASKQzXHawzxdoLoKnUS/ikPX1DUWS6VLjvOdUjeIwLPpR+pmoEILSIlX25I3/Nw
         9EiBd4L80XLpgawAhVk8i9TpU6KVMmel0gz3Od10kAAuC36HCv8b4F/+S8XDdSotaH5+
         PV/efA9uKsg67aTp4sfJk5Hiru20lix7/W16J9F4KuTJhwqYT3L6HkxdLsfyWr4OinW7
         sfdjmwlX5urdgCRfzqqooSfOnEL7qr6NuLYHUDl+a9gCFKd76HwBZjmm5Ogqg+6F+9sk
         SQIZSQvx9Ki/SKBJFbJgmfYmsIXUuYKuo5tifwIGxI0/lV3ua80ZrKXfScMfITEOLX1w
         HWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714081151; x=1714685951;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bKP/ivq5scsi0oRgSnjHb6xCz9q0E17Uir7siKnQvWc=;
        b=QH262D29kBW5QMjgNHvQC3yx3p3GImy9YDbpM8oln2l5reDdZAeHObnOhQpgMqN9Z+
         vKe8leLb67AUCl9dk7Xq6igF19QLwDj+081AwPuI5jQr9EprEpl4q/OgM+4qiiv++N5b
         UYhMNeth3CIIjVVcR7w9kdf6osMX/Zzs1OKnaYz0Gl6zXXZlYOCTfTIQ5/lM9KDZb4EN
         ODumdDGJXeWiwgTMWk6pjv1W99NHgFCVhBK73a2bsDyIEilu3CgXkp7JhIL5lBoVGMoB
         BT25jAZXtSHiIbn3zI2AdXP+iWjoR+RVGArizbxlUWlystlVlHjaSiBAbWa9UYmbhyBz
         gXeA==
X-Forwarded-Encrypted: i=1; AJvYcCXL1YneGrknJ3xDBX3XbKJ+F/9BU+I3mXWkIPdKSP8wN214SL+ehr9swBoXRV4DqmLbiv+Pl5IQY1Nsn0+lVyihFw/8
X-Gm-Message-State: AOJu0Yyh5f16DInWq6362RQdXZH0V85uXKcOrBK6fX8UVHHgWayX320u
	xUJ+ZyxcPFhI7Bjyxe4t1bHQeSdrmwaMJXHORtnyRDI5hfH3xjWl/qJ9ZRM8oyLA1YRQ/h+Bc9P
	hJA==
X-Google-Smtp-Source: AGHT+IELF5UQrJyfyJLrtg5xHpbEZ5nWMugMI9MyCdB5GEui+AJ/mK2hZFiG68SL9AcpNU9zPB24OFqm65c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d30f:b0:2a2:709d:955b with SMTP id
 p15-20020a17090ad30f00b002a2709d955bmr2623pju.7.1714081151201; Thu, 25 Apr
 2024 14:39:11 -0700 (PDT)
Date: Thu, 25 Apr 2024 14:39:09 -0700
In-Reply-To: <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com> <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
 <ZiqL4G-d8fk0Rb-c@google.com> <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
Message-ID: <ZirNfel6-9RcusQC@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-04-25 at 09:59 -0700, Sean Christopherson wrote:
> > > accessing a GPA beyond [23:16] is similar to accessing a GPA with no
> > > memslot.
> >=20
> > No, it's not.=C2=A0 A GPA without a memslot has *very* well-defined sem=
antics in
> > KVM, and KVM can provide those semantics for all guest-legal GPAs
> > regardless of hardware EPT/NPT support.
>=20
> Sorry, not following. Are we expecting there to be memslots above the gue=
st
> maxpa 23:16? If there are no memslots in that region, it seems exactly li=
ke
> accessing a GPA with no memslots. What is the difference between before a=
nd
> after the introduction of guest MAXPA? (there will be normal VMs and TDX
> differences of course).

If there are no memslots, nothing from a functional perspectives, just a ve=
ry
slight increase in latency.  Pre-TDX, KVM can always emulate in reponse to =
an EPT
violation on an unmappable GPA.  I.e. as long as there is no memslot, KVM d=
oesn't
*need* to create SPTEs, and so whether or not a GPA is mappable is complete=
ly
irrelevant.

Enter TDX, and suddenly that doesn't work because KVM can't emulate without=
 guest
cooperation.  And to get guest cooperation, _something_ needs to kick the g=
uest
with a #VE.

> > > Like you say, [23:16] is a hint, so there is really no change from KV=
M's
> > > perspective. It behaves like normal based on the [7:0] MAXPA.
> > >=20
> > > What do you think should happen in the case a TD accesses a GPA with =
no
> > > memslot?
> > =C2=A0
> > Synthesize a #VE into the guest.=C2=A0 The GPA isn't a violation of the=
 "real"
> > MAXPHYADDR, so killing the guest isn't warranted.=C2=A0 And that also m=
eans the
> > VMM could legitimately want to put emulated MMIO above the max addressa=
ble
> > GPA.=C2=A0 Synthesizing a #VE is also aligned with KVM's non-memslot be=
havior
> > for TDX (configured to trigger #VE).
> >=20
> > And most importantly, as you note above, the VMM *can't* resolve the
> > problem.=C2=A0 On the other hand, the guest *might* be able to resolve =
the
> > issue, e.g. it could request MMIO, which may or may not succeed.=C2=A0 =
Even if
> > the guest panics, that's far better than it being terminated by the hos=
t as
> > it gives the guest a chance to capture what led to the panic/crash.
> >=20
> > The only downside is that the VMM doesn't have a chance to "bless" the =
#VE,
> > but since the VMM literally cannot handle the "bad" access in any other
> > than killing the guest, I don't see that as a major problem.
>=20
> Ok, so we want the TDX module to expect the TD to continue to live. Then =
we need
> to handle two things:
> 1. Trigger #VE for a GPA that is mappable by the EPT level (we can alread=
y do
> this)
> 2. Trigger #VE for a GPA that is not mappable by the EPT level
>=20
> We could ask the TDX module to just handle both of these cases. But this =
means
> KVM loses a bit of control and debug-ability from the host side.

Why would the TDX module touch #1?  Just leave it as is.

> Also, it adds complexity for cases where KVM maps GPAs above guest maxpa
> anyway.

That should be disallowed.  If KVM tries to map an address that it told the=
 guest
was impossible to map, then the TDX module should throw an error.

> So maybe we want it to just handle 2? It might have some nuances still.

I'm sure there are nuances, but I don't know that we care.  I see three opt=
ions:

 1. Resume the guest without doing anything and hang the guest.

 2. Punt the issue to the VMM and kill the guest.

 3. Inject #VE into the guest and maybe the guest lives.

#1 is terrible for obvious reasons, so given the choice between guaranteed =
death
and a slim chance of survival, I'll take that slim chance of survival :-)=
=20

> Another question, should we just tie guest maxpa to GPAW?

Yes

> Either enforce they are the same, or expose 23:16 based on GPAW.

I can't think of any reason not to derive 23:16 from GPAW, unless I'm missi=
ng
some subtlety, they're quite literally the same thing.

