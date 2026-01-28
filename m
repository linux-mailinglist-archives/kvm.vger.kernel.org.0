Return-Path: <kvm+bounces-69343-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IPMWF0Ylemlk3QEAu9opvQ
	(envelope-from <kvm+bounces-69343-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:03:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B0B4A377C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:03:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27E673062FAA
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 14:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673F4359FA5;
	Wed, 28 Jan 2026 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1JIj5pfU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D506364E84
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769612274; cv=none; b=dyyvz/FYPMMymIRjquK+mBZSKkvLt9G9/XFfDSI8wjDRRT7Uqbk25Rnr95Jt2VGdPO+x1exMKWUsWPwJCJuioliASETcbZe92R5llbkxMNOaM+ECt48u6fOOcxFuya/5BuaoUm8wR/vG8NQdcj+sNNuWdHvHq96+yy9I+ajTj2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769612274; c=relaxed/simple;
	bh=yebS04Hxz4BxTnCCtfbmbzDzU7jowVcW8ColTGD6D+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nL9B+gc+K08I+P1wbOKCS0crggGj79Ji3R5XTK+OSjjdAXE7KTYjFzoM1GbmJJG09BdNW9uDFFlusS4CDO5HUxyQvs/K9yh5YFH/2QpHiZ7OwWJ1lK57OCSmQ1ZEEXU9Kd8tJzSyMpb7eOVe1soT86UvuLkZCX8QVCbW+fwIp9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1JIj5pfU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a77040ede0so68249055ad.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 06:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769612268; x=1770217068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BlhfUqNWBKQQsjzMJU0yFzL0lyP1pAGl+/dA5Nu7M+4=;
        b=1JIj5pfUR++5bSvCUN9XTQ/OmAYe9UzW3xLxzZXy1N/G4LvOtCB2sDqJ0J4kTzNSOb
         +iK0mEDV/DtjjW3UJdVw2SJ7GKZEZlE58ipcA/UYqY8nokXt4oPLwG6LFZW3JkBVYahG
         IgXv9pai0BT5X9GE9ISS33VIsJPvqmc2UBRhYpyy1Tbx+lNBdTApNFfRDrNL3Z3Q1w1h
         nUMZOdTQ0YnUlI3vfJfdkuaOaazBnUPu20uWEPcUHr0zBXjgze6xJYghX3bXWOFh0MGp
         sbbUUmWuHs8VMzA2TwtgsiPS4JmQ573pp10l6QBoSowM2K7EtY2cuwmzsBsG3dEfOb2u
         gY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769612268; x=1770217068;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BlhfUqNWBKQQsjzMJU0yFzL0lyP1pAGl+/dA5Nu7M+4=;
        b=Drt3UiVVSox5Ki120N7W/oNQw1NBmdTiNPTOT5ZCpOmzeFzHdVI83/c1FrRX8clcNf
         a6Hyw5cT28VQTzGccrv/aXQ7c2ReKZOd+4mw5OYif0aEo4Ot6VkwVd4FhZQR/EseWDNb
         YLfk7x7+XAxoTVJlJZUonn6KHRg+qwLs9dxgESKmT0H1t8Rx5fO08PLPVwKWbghfoEcU
         GAoXkTYYJRPx7AW4f0pl11pkkPVQ/gSRbZwacQkISRQERORdXgPOqb65wmqr5hhD7kJg
         QAElCoMvANvSzodedVAPp6LSJ/79HlFSc4TJSl82k9b29f3fEEJuBScaW+CRVBxWbBMa
         EtNw==
X-Forwarded-Encrypted: i=1; AJvYcCUHTCInb8k9Y/1HAgS0WYZpWAQEulmPofM9665OS5eZ9p6BBxwwWqVJzyaDwOkR1mzymkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsAg2x/DxBXz6TthAemIfdBta/p9Plbiom+1ldnSejPTVudIwv
	jNFuua3WhQrKWnUg8kln3A2lp/r96/u4mXD775xUVwODwCZDX1/EBHT8xFnHzg4zS3sdpBxUy9m
	nVdPZOg==
X-Received: from pjbna6.prod.google.com ([2002:a17:90b:4c06:b0:34f:8ef8:5834])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2344:b0:2a0:b461:c883
 with SMTP id d9443c01a7336-2a870dd56e0mr53437585ad.45.1769612268488; Wed, 28
 Jan 2026 06:57:48 -0800 (PST)
Date: Wed, 28 Jan 2026 06:57:46 -0800
In-Reply-To: <62f9bdb9f3c7f55db747a29c292fa632bb6ec749.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
 <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
 <aXkyz3IbBOphjNEi@google.com> <ea294969d05fc9c37e72053d7343e11fa9ffdded.camel@infradead.org>
 <699708d7f3da2e2a41e3282c1a87e6f4d69a4e89.camel@intel.com>
 <c7eab673dd567936761a8cc6e091a432b38d08da.camel@infradead.org> <62f9bdb9f3c7f55db747a29c292fa632bb6ec749.camel@intel.com>
Message-ID: <aXoj6szBMy6BSzYO@google.com>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>, Jon Kohler <jon@nutanix.com>, 
	"khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69343-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B0B4A377C
X-Rspamd-Action: no action

On Wed, Jan 28, 2026, Kai Huang wrote:
> On Tue, 2026-01-27 at 19:48 -0800, David Woodhouse wrote:
> > On Wed, 2026-01-28 at 02:22 +0000, Huang, Kai wrote:
> > > =C2=A0
> > > > Ah, so userspace which checks all the kernel's capabilities *first*
> > > > will not see KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST advertised,
> > > > because it needs to enable KVM_CAP_SPLIT_IRQCHIP first?
> > > >=20
> > > > I guess that's tolerable=C2=B9 but the documentation could make it =
clearer,
> > > > perhaps? I can see VMMs silently failing to detect the feature beca=
use
> > > > they just don't set split-irqchip before checking for it?=20
> > > >=20
> > > >=20
> > > > =C2=B9 although I still kind of hate it and would have preferred to=
 have the
> > > > =C2=A0=C2=A0 I/O APIC patch; userspace still has to intentionally *=
enable* that
> > > > =C2=A0=C2=A0 combination. But OK, I've reluctantly conceded that.
> > >=20
> > > To make it even more robust, perhaps we can grab kvm->lock mutex in
> > > kvm_vm_ioctl_enable_cap() for KVM_CAP_X2APIC_API, so that it won't ra=
ce with
> > > KVM_CREATE_IRQCHIP (which already grabs kvm->lock) and
> > > KVM_CAP_SPLIT_IRQCHIP?
> > >=20
> > > Even more, we can add additional check in KVM_CREATE_IRQCHIP to retur=
n -
> > > EINVAL when it sees kvm->arch.suppress_eoi_broadcast_mode is
> > > KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST?
> >=20
> > If we do that, then the query for KVM_CAP_X2APIC_API could advertise
> > the KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST for a freshly created KVM,
> > even before userspace has enabled *either* KVM_CREATE_IRQCHIP nor
> > KVM_CAP_SPLIT_IRQCHIP?
>=20
> No IIUC it doesn't change that?
>=20
> The change I mentioned above is only related to "enable" part, but not
> "query" part.
>=20
> The "query" is done via kvm_vm_ioctl_check_extension(KVM_CAP_X2APIC_API),
> and in this patch, it does:
>=20
> @@ -4931,6 +4933,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, l=
ong
> ext)
>  		break;
>  	case KVM_CAP_X2APIC_API:
>  		r =3D KVM_X2APIC_API_VALID_FLAGS;
> +		if (kvm && !irqchip_split(kvm))
> +			r &=3D ~KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST;
>=20
> IIRC if this is called before KVM_CREATE_IRQCHIP and KVM_CAP_SPLIT_IRQCHI=
P,
> then !irqchip_split() will be true, so it will NOT advertise
> KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST.
>=20
> If it is called after KVM_CAP_SPLIT_IRQCHIP, then it will advertise
> KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST.

Yep.  And when called at system-scope, i.e. with @kvm=3DNULL, userspace wil=
l see
the maximal support with KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST.

> Btw, it doesn't grab kvm->lock either, so theoretically it could race wit=
h
> KVM_CREATE_IRQCHIP and kvm_vm_ioctl_enable_cap(KVM_CAP_SPLIT_IRQCHIP) too=
.

That's totally fine.

> > That would be slightly better than the existing proposed awfulness
> > where the kernel doesn't *admit* to having the _ENABLE_ capability
> > until userspace first enables the KVM_CAP_SPLIT_IRQCHIP.
>=20
> We could also make kvm_vm_ioctl_check_extension(KVM_CAP_X2APIC_API) to
> _always_ advertise KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST if that's
> better.

No, because then we'd need new uAPI if we add support for ENABLE_SUPPRESS_E=
OI_BROADCAST
with an in-kernel I/O APIC.

> I suppose what we need is to document such behaviour -- that albeit=20
> KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST is advertise as supposed, but it
> cannot be enabled together with KVM_CREATE_IRQCHIP -- one will fail
> depending on which is called first.

No, we don't need to explicitly document this, because it's super duper bas=
ic
multi-threaded programming.  KVM only needs to documented that
KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST requires a VM with KVM_CAP_SPLIT_I=
RQCHIP.

> As a bonus, it can get rid of "calling irqchip_split() w/o holding kvm-
> >lock" awfulness too.

No, it's not awfulness.  It's userspace's responsibility to not be stupid. =
 KVM
taking kvm->lock changes *nothing*.  All holding kvm->lock does is serializ=
e KVM
code, it doesn't prevent a race.  I.e. it just changes whether tasks are ra=
cing
to acquire kvm->lock versus racing against irqchip_mode.

If userspace invokes KVM_CAP_SPLIT_IRQCHIP and KVM_ENABLE_CAP concurrently =
on two
separate tasks, then KVM_ENABLE_CAP will fail ~50% of the time regardless o=
f
whether or not KVM takes kvm->lock.

CPU0                         CPU1

1. Locked Failure
----------------------------------------------------
                             lock(kvm->lock)
			     KVM_ENABLE_CAP =3D EINVAL
			     unlock(kvm->lock)
lock(kvm->lock)
KVM_CAP_SPLIT_IRQCHIP =3D 0
unlock(kvm->lock)

1. Locked Success
----------------------------------------------------
lock(kvm->lock)
KVM_CAP_SPLIT_IRQCHIP =3D 0
unlock(kvm->lock)
                             lock(kvm->lock)
			     KVM_ENABLE_CAP =3D 0
			     unlock(kvm->lock)

3. Lockless Failure
----------------------------------------------------
			     KVM_ENABLE_CAP =3D EINVAL
KVM_CAP_SPLIT_IRQCHIP =3D 0


4. Lockless Success
----------------------------------------------------
CPU0                         CPU1
KVM_CAP_SPLIT_IRQCHIP =3D 0
			     KVM_ENABLE_CAP =3D 0

