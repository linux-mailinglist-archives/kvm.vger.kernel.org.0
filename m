Return-Path: <kvm+bounces-53706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF28DB155BB
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 01:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B28518A7DC3
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 23:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39800283128;
	Tue, 29 Jul 2025 23:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y3Wnh/dE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DCE253F2C
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 23:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753830514; cv=none; b=IR7kZgT1jKCRnMlQ5nw7gw7O6tXLQurIRt7JOy9+1I2YWm52zjPoGNtfTqod82wTvvGNqt1Y9uV0YiDusHyWKY4d2TVwAYRJx4n1kOSGnNtBPypaF8ZSBQtFru3s2UWYvxEaSpmT+RUW4U02lRV4u6e6l5ACrqENAdvpsgFXVZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753830514; c=relaxed/simple;
	bh=0qJxsC49CDR508iKW1WBl6QLhRYxBufKIgrL6bgW4pc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YEbZQqWm8NK50BMDIib3I7YQVMj+gIGSYbpOVbWoo2P2hiyVxZv1WSqpxxbBUon1mAHqdOgQL16JoThNfTdvaleN6x19VVozYJwqyvkWfFhXpFp1/FeA80vLioLnYFEROK2IJ4aodFpCYAkG6lg0vEjmY6HwJrqFJdOm6r5Zv04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y3Wnh/dE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24011ceafc8so2555555ad.3
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 16:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753830512; x=1754435312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LqZ3rHUmVe6G0p0/31oKw+qMwbPcZALS7DvYpljMN9M=;
        b=y3Wnh/dEyD1vBKLpWhr3yoJanPTgJXf/9KOu4CBbanX256psOj9N7Qajp88SR7mxMi
         xnVNt1YpE96YXvKUMrjmmGO2aVCrXztsFC2zTbTqdLEGoaY0Re9LgOQni3PBg1x/ROG5
         Mqvmre7DTry9N+dkp0i17lHwmnMhTGz8jfHkorNRhTWGUYweOhGog/XDo8wlNEdZbaoa
         f9eu2tDut9APr+7UqOwx1xh2hV7peTJDrPuxl5FJvaiFhU+ilonXEoR5XNHlM/3Fy71d
         /V+HyUUo3OQ5Ko8tO9J44sOAbXqqQm0RtED7CBax2NvJ5nqhLicociddEaPliHcnnwqk
         h2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753830512; x=1754435312;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LqZ3rHUmVe6G0p0/31oKw+qMwbPcZALS7DvYpljMN9M=;
        b=CXM2l89NSRZb9LEU9p8ZQuwTRG6iJsCbOiVBZiH7JNXFXviqQ1RbDXzsOgp814m04S
         mObO41zfn35/H+cY7+eQJ69vHD73QkU8PFH3UNzUEJ5iSQah3YwjLTi1k1tiXFEZFN/i
         Bmhrg7UlOAxY3BADd9JNvTRE4jxtpU1WKJ/4SOsH7x0H/PmubPZQOO3+xkhfb7IAb5iv
         CNWaJ4F6HI7fHA9XuUHeYwGjJoZK/GQw4QoMbhQXgzt2tWMqfDzhLJ6X0xZOumVIv/JJ
         egksWeS0KYGxwTnVSkjKXEst/Qz4u3pC9ehRhP47duAvN4UnSs4uJoVzvHOZjJAbRPpJ
         EOxA==
X-Forwarded-Encrypted: i=1; AJvYcCV+E5Iua9/znm6Wz5kF136bp7islIpanulh/SWxqBJAhzHV0YArbgjgKVq7jPGKSACrIIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7DKlymSE4Pw1EsXIGWIktk0F7sj3yjsK0RN4ZoDJkzyMFDvZo
	LnNjMB/TJi1zZ8FlHzshM/JODtT3bHGScK2q3jOFU41USFmbO+lx2Sk9Sb4OTokV7TfPcFRlGky
	H2IosOQ==
X-Google-Smtp-Source: AGHT+IEyEA4YX1TwqE1OHkPIShxbjzy59E1nb5MsO32y1ZAQO9ZQMLAuLwnLMldTTuOlaQTIYiJv0rnX0uU=
X-Received: from pjpo16.prod.google.com ([2002:a17:90a:9f90:b0:31f:1dad:d0a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc45:b0:240:3915:99d8
 with SMTP id d9443c01a7336-24096b2f983mr14218495ad.47.1753830512332; Tue, 29
 Jul 2025 16:08:32 -0700 (PDT)
Date: Tue, 29 Jul 2025 16:08:30 -0700
In-Reply-To: <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com> <20250729193341.621487-3-seanjc@google.com>
 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
 <aIlRONVnWJiVbcCv@google.com> <e45806c6ae3eef2c707f0c3886cb71015341741b.camel@intel.com>
Message-ID: <aIlUbpQlYqaSO6wr@google.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	Adrian Hunter <adrian.hunter@intel.com>, "maz@kernel.org" <maz@kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-07-29 at 15:54 -0700, Sean Christopherson wrote:
> > > The vm_dead was added because mirror EPT will KVM_BUG_ON() if there i=
s an
> > > attempt to set the mirror EPT entry when it is already present. And t=
he
> > > unaccepted memory access will trigger an EPT violation for a mirror P=
TE
> > > that is already set. I think this is a better solution irrespective o=
f
> > > the vm_dead changes.
> >=20
> > In that case, this change will expose KVM to the KVM_BUG_ON(), because =
nothing
> > prevents userspace from re-running the vCPU.=C2=A0
>=20
> If userspace runs the vCPU again then an EPT violation gets triggered aga=
in,
> which again gets kicked out to userspace. The new check will prevent it f=
rom
> getting into the fault handler, right?

Yes?  But I'm confused about why you mentioned vm_dead, and why you're call=
ing
this a "new check".  This effectively does two things: drops kvm_vm_dead() =
and
switches from EOI =3D> EFAULT.  _If_ setting vm_dead was necessary, then we=
 have a
problem.

I assume by "The vm_dead was added" you really mean "forcing an exit to use=
rspace",
and that kvm_vm_dead()+EIO was a somewhat arbitrary way of forcing an exit?

> >  Which KVM_BUG_ON() exactly gets hit?
>=20
> Should be:
>=20
> static int __must_check set_external_spte_present(struct kvm *kvm, tdp_pt=
ep_t
> sptep,
> 						 gfn_t gfn, u64 old_spte,
> 						 u64 new_spte, int level)
> {
> 	bool was_present =3D is_shadow_present_pte(old_spte);
> 	bool is_present =3D is_shadow_present_pte(new_spte);
> 	bool is_leaf =3D is_present && is_last_spte(new_spte, level);
> 	kvm_pfn_t new_pfn =3D spte_to_pfn(new_spte);
> 	int ret =3D 0;
>=20
> 	KVM_BUG_ON(was_present, kvm);

Yeah, I don't see how that can be reach in this scenario.=20

