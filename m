Return-Path: <kvm+bounces-35699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC598A14483
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D75781689B4
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7EF22BACC;
	Thu, 16 Jan 2025 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zyzl/JTw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDFC1D63CF
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737067034; cv=none; b=K9apjHii145Ej68/XhHhydeXMIwwWn9oOKMyCT+1/3MNTMw5IcUOx5tYwV9nxB7FlG4jd2U5nQgydGV+BTglwEkgkPfvF2CpKI9nq+HCqfB1xlEV/C4VAyg70XSuuUw/2Pbqf0NBQtHaro6Bs6oGh/ph2YmrP+/T68fsfbzhWZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737067034; c=relaxed/simple;
	bh=AkUyAJnqCwKJGjCxuAgqRZ9rmePlusUc55FC+aq2Lp0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bxi1mgfThmOTG5jiXQnnJDbCcsZ9qn5cHOsBB8YsrpYlZIJa1j2Qxxeji7msVHTR7w3TMlLkjh53I3XaZr3n1zfdNffuPRt956AplXIdwfkwWE1ZTfw240oi5qNBloduD1UJenRGnizqScjrcS3PEQkVfxjvrOMi5oo163kHMHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zyzl/JTw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so4161804a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 14:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737067032; x=1737671832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0o7kCOEQK3ge//6I8nmLhfWM59ihurO8yTiLFcRnjsg=;
        b=Zyzl/JTwvXlaMw2A7zdwAxYD6ivyOBwLpTLBKS/MGydCw/pwQuztmKlbgG6rIHRBLF
         tesuJa3jr3vit4FU9Ut4rqmXnrhXIaexGCLO+dxjKdGH2TzO9HA+3OmbGodzWdlf6S4q
         9kpIMgecCBCU5FVOv89WwJPZqd7MPWO4k9Iq3DKwj7+vlsMdM/XTG3ByMgJn5SoyjOd+
         JztGKEIcho4cIwmS2wMnloPaWsRc9dWJ17jyyLKG+Wd8QwMWCsP9DSACcz/obk7T0g6O
         BDQA4ZIQeMEpRVajPMcKNg0FZxjp2bVNRiJHTAbPJlorGN12wxsuuM+JagHcL6ir/SoW
         LeFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737067032; x=1737671832;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0o7kCOEQK3ge//6I8nmLhfWM59ihurO8yTiLFcRnjsg=;
        b=qX6bp2DILS+eW4OhSQisXYT6kgikxtp8los6jwY2xlnwBz4ia+YGGE+t28ovCuDCa0
         274sn5muzhDTEu+qK6Bf2CTnVdna6xVglAwaOBnCvoxBZXAJoIzOY0oF6LbZObfN+uen
         THPKaHPc/jP3Et7i81/nLDI8dVALpxzNrNVf5aFPZkWOVAZpXEbjGPQu9SGMVb/m5pV0
         XSpQQ3HMVS1gZT2rteiBjx9qzrR/1SzSimnIlIhgQ9E8TekXnL23xPFU/91jBw1ACkfC
         qZauR5j34LRJ0wT1q1qL086ZulnO8rgO9BvgWwUweNTa6lE4owolrGpl+lUrJ9Fac2AE
         bbhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU21Ks3yOcKIF02bXpU7/1gq7CDp6HYstggB1SelBykwESc8/izb1DsGtAho3GvpbOI884=@vger.kernel.org
X-Gm-Message-State: AOJu0YweusXf8zDBntfa8a4nZo6h5d41lrwgLt9auR1b0FK6Ury20VYR
	l7Uf1rGKq9UOIBfUcGE34J97y6EsAkq3KpCZY2mpsSnEULvuCqDFeAaiMTOkMV0EYtAcrEmH5CN
	fBg==
X-Google-Smtp-Source: AGHT+IGbNqgsSuWvnKn2M76Olupi9NpCU0lnQKMzncfEFcMkx8B/lwYwgkHqm6mSJ2OJvcKCdIGdhRJGtfk=
X-Received: from pjbhl13.prod.google.com ([2002:a17:90b:134d:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ece:b0:2ee:db1a:2e3c
 with SMTP id 98e67ed59e1d1-2f782c663d6mr412262a91.1.1737067032302; Thu, 16
 Jan 2025 14:37:12 -0800 (PST)
Date: Thu, 16 Jan 2025 14:37:11 -0800
In-Reply-To: <19901a08ab931a0200f7c079f36e4b27ed2e1616.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com> <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
 <Z4kcjygm19Qv1dNN@google.com> <19901a08ab931a0200f7c079f36e4b27ed2e1616.camel@intel.com>
Message-ID: <Z4mGNUPy53WfVEZU@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Kai Huang wrote:
> On Thu, 2025-01-16 at 06:50 -0800, Sean Christopherson wrote:
> > On Thu, Jan 16, 2025, Kai Huang wrote:

...

> > > Looking at the code, it seems KVM only traps EOI for level-triggered =
interrupt
> > > for in-kernel IOAPIC chip, but IIUC IOAPIC in userspace also needs to=
 be told
> > > upon EOI for level-triggered interrupt.  I don't know how does KVM wo=
rks with
> > > userspace IOAPIC w/o trapping EOI for level-triggered interrupt, but =
"force
> > > irqchip split for TDX guest" seems not right.
> >=20
> > Forcing a "split" IRQ chip is correct, in the sense that TDX doesn't su=
pport an
> > I/O APIC and the "split" model is the way to concoct such a setup.  Wit=
h a "full"
> > IRQ chip, KVM is responsible for emulating the I/O APIC, which is more =
or less
> > nonsensical on TDX because it's fully virtual world, i.e. there's no re=
ason to
> > emulate legacy devices that only know how to talk to the I/O APIC (or P=
IC, etc.).
> > Disallowing an in-kernel I/O APIC is ideal from KVM's perspective, beca=
use
> > level-triggered interrupts and thus the I/O APIC as a whole can't be fa=
ithfully
> > emulated (see below).
>=20
> Disabling in-kernel IOAPIC/PIC for TDX guests is fine to me, but I think =
that,
> "conceptually", having IOAPIC/PIC in userspace doesn't mean disabling IOA=
PIC,
> because theoretically usrespace IOAPIC still needs to be told about the E=
OI for
> emulation.  I just haven't figured out how does userpsace IOAPIC work wit=
h KVM
> in case of "split IRQCHIP" w/o trapping EOI for level-triggered interrupt=
. :-)

Userspace I/O APIC _does_ intercept EOI.  KVM scans the GSI routes provided=
 by
userspace and intercepts those that are configured to be delivered as level=
-
triggered interrupts.  Whereas with an in-kernel I/O APIC, KVM scans the GS=
I
routes *and* the I/O APIC Redirection Table (for interrupts that are routed
through the I/O APIC).

> If the point is to disable in-kernel IOAPIC/PIC for TDX guests, then I th=
ink
> both KVM_IRQCHIP_NONE and KVM_IRQCHIP_SPLIT should be allowed for TDX, bu=
t not
> just KVM_IRQCHIP_SPLIT?

No, because APICv is mandatory for TDX, which rules out KVM_IRQCHIP_NONE.

>=20
> >=20
> > > I think the problem is level-triggered interrupt,
> >=20
> > Yes, because the TDX Module doesn't allow the hypervisor to modify the =
EOI-bitmap,
> > i.e. all EOIs are accelerated and never trigger exits.
> >=20
> > > so I think another option is to reject level-triggered interrupt for =
TDX guest.
> >=20
> > This is a "don't do that, it will hurt" situation.  With a sane VMM, th=
e level-ness
> > of GSIs is controlled by the guest.  For GSIs that are routed through t=
he I/O APIC,
> > the level-ness is determined by the corresponding Redirection Table ent=
ry.  For
> > "GSIs" that are actually MSIs (KVM piggybacks legacy GSI routing to let=
 userspace
> > wire up MSIs), and for direct MSIs injection (KVM_SIGNAL_MSI), the leve=
l-ness is
> > dictated by the MSI itself, which again is guest controlled.
> >=20
> > If the guest induces generation of a level-triggered interrupt, the VMM=
 is left
> > with the choice of dropping the interrupt, sending it as-is, or convert=
ing it to
> > an edge-triggered interrupt.  Ditto for KVM.  All of those options will=
 make the
> > guest unhappy.
> >=20
> > So while it _might_ make debugging broken guests either, I don't think =
it's worth
> > the complexity to try and prevent the VMM/guest from sending level-trig=
gered
> > GSI-routed interrupts. =C2=A0
> >=20
>=20
> KVM can at least have some chance to print some error message?

No.  A guest can shoot itself any number of ways, and userspace has every
opportunity to log weirdness in this case.

