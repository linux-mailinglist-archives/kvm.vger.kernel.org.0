Return-Path: <kvm+bounces-46495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54EC8AB6BDF
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FECB1B618E1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14182797B4;
	Wed, 14 May 2025 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oyFZlwyP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896F31F0E2E
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227324; cv=none; b=e9dquLipUa3MDJf00fwXJmkorRtyUXcpIiNTeeB3KdEzY/G//d0E0gblAjTsGiEv4ZPsdozu+Dr+uRhUeIFEkz31PvBBtvaZXR9lEUtLKtRl9r03eJHtzTWj1FogafRsDWbXTHyrCzNqLfeUG/hKquBn+H+qakNMpHCxtANyCis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227324; c=relaxed/simple;
	bh=T5PpBd950yZbcaPaQpt7z7UBm/RSooDGs8zCDWqEuNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fvRSAL67OLBqW5v1rPfV0khy3sodBj4eo5I6rR7stztw+awEKRqXZpNGhsqIG/WO/bj/1pBMTqh2a6dlADMqZH+Pktfa2kBRcplSwFJmYqjQ8D13iY9f9HuhzecjfR1d/V5lS+cI6NuDe4DrQzebopZRdDK9nI5IMw7Y5jnMnOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oyFZlwyP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30c9b0aa4ccso3482130a91.3
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 05:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747227322; x=1747832122; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=76k7pW5NZ1udEa5NXUL313ttjbsC0PLRtgt+LZ6uYAM=;
        b=oyFZlwyPU+iCuGI3Ql/gVGyvK5qd0gig7JrA5Kx/ZautjK2nWPmpK6DwW7jhY+Osge
         CVC60stkBQ25z7CaAK0xpCrVvpBKcHGPuwlrkkTyxjg0+ziQbSWMEFCjEgRD8sqRQWxR
         9bUOsL8czpr85CxErNMa2Iin6jon3B8qspLuYa/FHWonX8+9GkhjAvSaXxnZBcT+kUms
         RmfXJ60VMRtJSpPmRM12e0l92ZbzmLD2o5pDFyegCaBn/9u/QaDncNvoBoVcFpuNWtkd
         /AalTzMrxUqp7DOPbqSrnx4T7qmLq+YHEf1Rb0DozqG0Utar8DyLjVMZwsQOlWLPyAb5
         fOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747227322; x=1747832122;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=76k7pW5NZ1udEa5NXUL313ttjbsC0PLRtgt+LZ6uYAM=;
        b=e6dQ3cJsU9TijlMVwPMSWI+cXjbx2e52JI2G74turLQxjyJeqqa1goPIWyR19DOhsf
         S2LuobRimXjzud4BcsqK6KR54k32RhZlqTwiUpU+LTCIHMbT7dhfzxjmsaDOzdesXpF/
         5i4S+x06Y+qXvAo10KRiePaYbmrbwyfBySeYCZzVLej9xru6yOHLPMi5mATAuPirQqpV
         0ZmqPDe7A+hGWGzjaHMNO7LrG5cZcKNSu0vrshptxs7AWM4LKreWO0pKK5IWdKwLsH2C
         BVmK7pLxRqrFXw7cM5+nPX2A+iRsBPeY/4ffyPnNcXd97vmX1mlMV0C9jxogfJdtN03r
         dKBA==
X-Forwarded-Encrypted: i=1; AJvYcCX1tiSOY/ZNQfypbfJyu9Dq++eizVxkI9cerRWyf51JmjIGDaTrowApuf5MZ6rxtlvAxf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf8WFtsLshRrx333cwQTn6Nkp8Sbffn414iz5SJbi7/w/brVtz
	5dcgIFwBxugCGbu3uLasuy/XyGDxwVxsIzMMmNi807mZYXEZ7nOQRpdrPP40y7SlFV6tI+lg0pw
	kYQ==
X-Google-Smtp-Source: AGHT+IFgT95GBLG9hEKtLuWwErvNNL8LufLyA++dQg8RnFH/PcKmjBUD945AxPlGLzg/yAtEYCrcuPF5pXY=
X-Received: from pjbso17.prod.google.com ([2002:a17:90b:1f91:b0:301:2679:9d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc1:b0:30c:523e:89e3
 with SMTP id 98e67ed59e1d1-30e2e5ba2a8mr5425349a91.11.1747227321794; Wed, 14
 May 2025 05:55:21 -0700 (PDT)
Date: Wed, 14 May 2025 05:55:19 -0700
In-Reply-To: <6dd4eee79fec75a47493251b87c74595826f97bc.camel@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com> <20250313203702.575156-7-jon@nutanix.com>
 <aCI8pGJbn3l99kq8@google.com> <49556BAF-9244-4FE5-9BA9-846F2959ABD1@nutanix.com>
 <aCNI72KuMLfWb9F2@google.com> <6dd4eee79fec75a47493251b87c74595826f97bc.camel@amd.com>
Message-ID: <aCSSptnxW7EBEzSQ@google.com>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable logic
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <Amit.Shah@amd.com>
Cc: "jon@nutanix.com" <jon@nutanix.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025, Amit Shah wrote:
> On Tue, 2025-05-13 at 06:28 -0700, Sean Christopherson wrote:
> > On Tue, May 13, 2025, Jon Kohler wrote:
> > > > On May 12, 2025, at 2:23=E2=80=AFPM, Sean Christopherson
> > > > This is wrong and unnecessary.=C2=A0 As mentioned early, the input =
that
> > > > matters is vmcs12.=C2=A0 This flag should *never* be set for vmcs01=
.
> > >=20
> > > I=E2=80=99ll page this back in, but I=E2=80=99m like 75% sure it didn=
=E2=80=99t work when I
> > > did it that way.
> >=20
> > Then you had other bugs.=C2=A0 The control is per-VMCS and thus needs t=
o
> > be emulated
> > as such.=C2=A0 Definitely holler if you get stuck, there's no need to
> > develop this in
> > complete isolation.
>=20
> Looking at this from the AMD GMET POV, here's how I think support for
> this feature for a Windows guest would be implemented:
>=20
> * Do not enable the GMET feature in vmcb01.  Only the Windows guest (L1
> guest) sets this bit for its own guest (L2 guest).  KVM (L0) should see
> the bit set in vmcb02 (and vmcb12).  OTOH, pass on the CPUID bit to the
> L1 guest.
>=20
> * KVM needs to propagate the #NPF to Windows (instead of handling
> anything itself -- ie no shadow page table adjustments or walks
> needed).  Windows spawns an L2 guest that causes the #NPF, and Windows
> is the one that needs to consume that fault.
>=20
> * KVM needs to differentiate an #NPF exit due to GMET or non-GMET
> condition -- check the CPL and U/S bits from the exit, and the NX bit
> from the PTE that faulted.  If due to GMET, propagate it to the guest.
> If not, continue handling it

Yes, but no.  KVM shouldn't need to do anything special here other than tea=
ching
update_permission_bitmask() to understand the GMET fault case.  Ditto for M=
BEC.
I'd type something up, but I would quickly encounter -ENOCOFFE :-)

With the correct mmu->permissions[], permission_fault() will naturally dete=
ct
that a #NPF (or EPT Violation) from L2 due to a GMET/MBEC violation is a fa=
ult
in the nNPT/nEPT domain and route the exit to L1.

> (btw KVM MMU API question -- from the #NPF, I have the GPA of the L2
> guest.  How to go from that guest GPA to look up the NX bit for that
> page?  I skimmed and there doesn't seem to be an existing API for it -
> so is walking the tables the only solution?)

As above, KVM doesn't manually look up individual bits while handling fault=
s.
The walk of the guest page tables (L1's NPT/EPT for this scenario) performe=
d by
FNAME(walk_addr_generic) will gather the effective permissions in walker->p=
te_access,
and check for a permission_fault() after the walk is completed.

