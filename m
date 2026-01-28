Return-Path: <kvm+bounces-69344-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOSDDyAnemlk3QEAu9opvQ
	(envelope-from <kvm+bounces-69344-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:11:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A80FA38FC
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C5B3318B371
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 15:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A7036998A;
	Wed, 28 Jan 2026 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c8LNOMBJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3436A03F
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769612667; cv=none; b=Pg+tdlwRTMG0MJUZPSiGMpSiK8CYo/9d4bX+l/WOkBYH4WPj8BlXOHhdx1JVelA/Hb94102N2+aX4ukbbxKMH2pJ6e360R597w9k0VXq56DHyixj/5PyQQSnj0c7CciYW8HI6egeYGE0Qlk0XIclZdYoTief0e6oD/wIjXcl3SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769612667; c=relaxed/simple;
	bh=9p9sY8GurF6O2zwvllKDDT1l+KKObwzM+skkBydhYaU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oa+Gsq0kl3TLF0ubw0k47XmYLN0L9xdQSf5suW/WaDPTRom1hGAbdQNNNfDAetR0DOvqJV13B1NbhVWvJRRTy3oJHoi/SZTWMi829SjI/FM3rgqxWcNxSx+dSaDdIvCIBAAhaJXMVFryOd6MzDwlbu7JdrgNzndqWU61Wpq2/Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c8LNOMBJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81f48cec0ccso5498754b3a.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769612657; x=1770217457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ySrwH5OmJgiZgYr7ivDWu26JHCODpKL/+VCc6ZHqtQc=;
        b=c8LNOMBJqjFrDq3czsZdUZx99leTsHBkzdY0mT8bxmwUxWnh5k8EATrsxbcDib3R+b
         UK3WGq0lMkLcK7Ywlt/sgscz4brMo0Vgz7BLcWpc1q9x93EocSJS39P6JEyXKP2hp6Vz
         hFuongmHHTcpnT1e2GKa5ovOUHmvTwhdjP3Ja5jUwEwA7WRJtoAIv3Mm5hGiyOBpE3DY
         ZE8s5kt7u4kq0jjlLKm8jwOOGVn6cLIxQMbORSQ1qwIpNArtdPWVF7AthInSnSk/rC0p
         SveGXBLvKSBeNFnd9XR+ieqO53SpM0yO79p/5xOsyZg3evy7JsuCELRwIOICqL9+a75h
         DxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769612657; x=1770217457;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ySrwH5OmJgiZgYr7ivDWu26JHCODpKL/+VCc6ZHqtQc=;
        b=bK/kWVtGJCQv7JvEdc9SOKCI/0jo8iM0KLEtxv/tYJ09TML+CkkdUKjee6wRYS1ucV
         /T1Sb8dCMS5DlEPU3wNM2aTdWtpGu9uP2rn/DazRSXvtNftPuRDUN5QpZnhrwtW5S133
         KL/+1DmtqjmRB5AYXt1qbQvhKr8nkp2bA1JDlHa5gnIzkmaA8258vvd0PElYMERF5HAD
         glYIZ9Fb4yS4tpIwKIAlPDOmIdBCjpNFHxOxtkwz7zbO+tJVZNedXdK3/4+kh3yDfonD
         lB3KyONY4te15BAiaVs7lRTCr4phaD0dtWbdIqEMF+gtCsx9A0DeNWpqOg3HTPwYMSMi
         n71A==
X-Forwarded-Encrypted: i=1; AJvYcCVDAcmfaK07Zp/FfJEak4w2SXTwftfb1o2J3G7f+YKXOZP/b2UBHAh1mK+fpDz08t268I0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym0cvJ6euwgg25j3jPkVZXtU2GHrrm6Y5cPUNe7m59YuEuwRR3
	ns/yKP21REhSWKobx8JCw4e5P9IbsmJtQh/nhEU0H106tfhBZ//TOAUWAsHkrSoGEKzhm3tYLuP
	RTrjgaw==
X-Received: from pghx8.prod.google.com ([2002:a63:f708:0:b0:bac:a20:5f1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1709:b0:38e:5535:bb4e
 with SMTP id adf61e73a8af0-38ec6581350mr5832803637.76.1769612656719; Wed, 28
 Jan 2026 07:04:16 -0800 (PST)
Date: Wed, 28 Jan 2026 07:04:15 -0800
In-Reply-To: <DBAD995F-C9E1-46C8-A49A-9D774D6D4612@nutanix.com>
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
 <c7eab673dd567936761a8cc6e091a432b38d08da.camel@infradead.org>
 <SA2PR02MB756478359EE9185285ACE6158891A@SA2PR02MB7564.namprd02.prod.outlook.com>
 <DBAD995F-C9E1-46C8-A49A-9D774D6D4612@nutanix.com>
Message-ID: <aXolb--54UNUJqU9@google.com>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Kai Huang <kai.huang@intel.com>, 
	Shaju Abraham <shaju.abraham@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jon Kohler <jon@nutanix.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69344-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nutanix.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:email]
X-Rspamd-Queue-Id: 8A80FA38FC
X-Rspamd-Action: no action

On Wed, Jan 28, 2026, Khushit Shah wrote:
>=20
> > On 28 Jan 2026, at 9:27=E2=80=AFAM, Khushit Shah <khushit.shah@nutanix.=
com> wrote:
> >=20
> >=20
> > On 28/01/26, 9:19=E2=80=AFAM, "David Woodhouse" <dwmw2@infradead.org> w=
rote:
> >=20
> > On Wed, 2026-01-28 at 02:22 +0000, Huang, Kai wrote:
> > > =20
> > > > Ah, so userspace which checks all the kernel's capabilities *first*
> > > > will not see KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST advertised,
> > > > because it needs to enable KVM_CAP_SPLIT_IRQCHIP first?
> > > > > > I guess that's tolerable=C2=B9 but the documentation could make=
 it clearer,
> > > > perhaps? I can see VMMs silently failing to detect the feature beca=
use
> > > > they just don't set split-irqchip before checking for it? > > > > >=
 > =C2=B9 although I still kind of hate it and would have preferred to have=
 the
> > > >    I/O APIC patch; userspace still has to intentionally *enable* th=
at
> > > >    combination. But OK, I've reluctantly conceded that.
> > > > To make it even more robust, perhaps we can grab kvm->lock mutex in
> > > kvm_vm_ioctl_enable_cap() for KVM_CAP_X2APIC_API, so that it won't ra=
ce with
> > > KVM_CREATE_IRQCHIP (which already grabs kvm->lock) and
> > > KVM_CAP_SPLIT_IRQCHIP?
> > > > Even more, we can add additional check in KVM_CREATE_IRQCHIP to ret=
urn -
> > > EINVAL when it sees kvm->arch.suppress_eoi_broadcast_mode is
> > > KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST?
> >=20
> > If we do that, then the query for KVM_CAP_X2APIC_API could advertise
> > the KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST for a freshly created KVM,
> > even before userspace has enabled *either* KVM_CREATE_IRQCHIP nor
> > KVM_CAP_SPLIT_IRQCHIP?
> >=20
> > That would be slightly better than the existing proposed awfulness
> > where the kernel doesn't *admit* to having the _ENABLE_ capability
> > until userspace first enables the KVM_CAP_SPLIT_IRQCHIP.

No.  If userspace wants to see if *KVM* supports the feature, then userspac=
e can
do KVM_CHECK_EXTENSION on /dev/kvm.  If userspace does KVM_CHECK_EXTENSION =
on a
VM fd, then KVM absolutely must report exactly what that VM supports.

> How about we make an explicit _ENABLE_ bit for split IRQCHIP?
> When/if in-kernel IRQCHIP starts supporting I/O APIC 0x20, we
> can add a separate bit for that in the CAP.=20

NAK.  Conditionally enumerating support for a feature based on the configur=
ation
of the VM has been KVM's documented behavior since KVM_CHECK_EXTENSION was =
added
by commit 92b591a4c46b ("KVM: Allow KVM_CHECK_EXTENSION on the vm fd").

I don't see any reason why KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST needs t=
o do
something different.

