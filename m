Return-Path: <kvm+bounces-37269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE579A27B16
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2912B7A279D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 19:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DD7217647;
	Tue,  4 Feb 2025 19:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XW9xwq9e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFEE204F85
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 19:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738697020; cv=none; b=qngaEup6WS4BIZgonp0LRtQRUziSB7qTUWeDtoRy9ljqQJCGHvF/sTZzIBDmFCnilN66vVLiPKu+llPiJh3fftBEfhKHCRpyWMDslUmw/g/VSMzFk0R3xLIbZkbN+l5/3H4Ti+9fbyir5ujPN/N4JNMIy9LrOuMTAbLQ5Sq/AC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738697020; c=relaxed/simple;
	bh=Oxor8wKExkt7gAhD/gJtNC9sIwWG1V1vV3++fquZZDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ubPpPAu3s6FcF6rAW3ESufNQ6+qNMK4uquHAtj1WqmAsEpdKu2ek8I3SkLo5enz9hZFgoQBwlCxqdtUOOS7ObA41nXP3VchhUJ99tJk9FHGQJLwYQd4vqXldr07p4VSO9x3sHWUsxe8yUnKrzvl6QC3ozsIVXRmfkVXs4e/3meQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XW9xwq9e; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so17030659a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 11:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738697018; x=1739301818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mU6NEWjLFlBth9JekcNPIXJtuRcysaOik+DY1sDAAPo=;
        b=XW9xwq9e0h5s9AfzGVXgTVQvjw4wGThsv8XFUE4qVoiGavcc6dTGufdiYN9EQhzuSn
         awvkeMYvtkbu6Uw09DpjvkayAXqMyPHIvcTlRW2ciqm2hu4dSHhmHQAy2eQHw5IErTyP
         oVD0IH4fwVcDLrLNOH3duAynrM20y3hdl6eZR0cnGwAZtfeKJlTVWQKjbR7o0T0sCRJq
         jp3FBvLKfCX/xT0otbX4mDt0G8vliPyiI2SHmkyijZ80jw6RAY7UxZAsedKW1sItL8aS
         JZpZqH5QeFiPYOPI2zezMrTKP6p4W61j2EnA1RUCVmBLAi848haa+j1sa3IavykUFBCB
         FXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738697018; x=1739301818;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mU6NEWjLFlBth9JekcNPIXJtuRcysaOik+DY1sDAAPo=;
        b=Gg2A3+Pmw8MU+9kMxOhfoCtdrSzg54B99wZK83pmilgwaQ7tOJvRbCvrRfhyf0ds2g
         1zKRWH4SwDbrTo4NiOuY8ZGF9IheEfDZWCyur5D3sJse+S2Ab/WD1APKgGtxGMW4MEh2
         eUoc4Llj7fsTfOuLkkkruc4DlQ0fm2VP91CEA2YE6VFx3mQ6m/oBzQANUF/xF/8bQCc9
         LFZDqM4BfKhDDc9J8Zncx/rK92aJVIvGCekV234qjnrOk++vvKDSOXht9ysn2jR2HWVQ
         kQIRA+Sk7aQTBPgXx6bNZuWgZeX8/hvUlcsv2Exy4VKdkqn5cuAKhx9Jevf+FB+PLwHa
         Ju1g==
X-Forwarded-Encrypted: i=1; AJvYcCX+h885HcPHAARoXUs3PxzLrqkHvjaN+LWe0zmMr2PwVK/xVhGwc/lDT5asWr9zuOH9MaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YypHk9BvDzRsQBWqC5FjJ7KtLT9g9dgr3crLxmaoSkcWxx7c7oU
	IbtxmRyaCWES8NcoYcfV+0pb0s52yIidmmjkSI6HGXg9x8CPmrOUMRajQ0W8JSG8QcG2tcFYzZp
	HJg==
X-Google-Smtp-Source: AGHT+IEth4W4eKneJyToCoULIhy1nd7LV+EXAj9+a+XknG5txgwUqYrL0IEC6qEWjMx4Oqa+94Y+2pCo9yU=
X-Received: from pfbfh3.prod.google.com ([2002:a05:6a00:3903:b0:726:d6e6:a38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2187:b0:72a:bc54:84f7
 with SMTP id d2e1a72fcca58-730351428bemr168769b3a.12.1738697018181; Tue, 04
 Feb 2025 11:23:38 -0800 (PST)
Date: Tue, 4 Feb 2025 11:23:36 -0800
In-Reply-To: <6b2d960c-1340-4e91-ad17-0ccadd378a81@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201013827.680235-1-seanjc@google.com> <20250201013827.680235-9-seanjc@google.com>
 <792ae6f4-903f-41b2-a0f2-369d92a1fc3f@xen.org> <6b2d960c-1340-4e91-ad17-0ccadd378a81@xen.org>
Message-ID: <Z6JpOOP1-GpFw7lR@google.com>
Subject: Re: [PATCH v2 08/11] KVM: x86: Pass reference pvclock as a param to kvm_setup_guest_pvclock()
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2025, Paul Durrant wrote:
> On 04/02/2025 09:33, Paul Durrant wrote:
> > On 01/02/2025 01:38, Sean Christopherson wrote:
> > > -static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> > > +static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info
> > > *ref_hv_clock,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_vcpu *vcpu,
> >=20
> > So, here 'v' becomes 'vcpu'
> >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct gfn_to_pfn=
_cache *gpc,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int offs=
et,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool force_tsc_un=
stable)
> > > =C2=A0 {
> > > -=C2=A0=C2=A0=C2=A0 struct kvm_vcpu_arch *vcpu =3D &v->arch;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pvclock_vcpu_time_info *guest_h=
v_clock;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pvclock_vcpu_time_info hv_clock=
;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long flags;
> > > -=C2=A0=C2=A0=C2=A0 memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_cloc=
k));
> > > +=C2=A0=C2=A0=C2=A0 memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock))=
;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 read_lock_irqsave(&gpc->lock, flags);
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (!kvm_gpc_check(gpc, offset + si=
zeof(*guest_hv_clock))) {

...

> > > @@ -3272,18 +3272,18 @@ static int kvm_guest_time_update(struct
> > > kvm_vcpu *v)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 vcpu->hv_clock.flags |=3D PVCLOCK_GUEST_STOPPED;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 vcpu->pvclock_set_guest_stopped_request =3D false;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_setup_guest_pvclock(v=
, &vcpu->pv_time, 0, false);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_setup_guest_pvclock(&=
vcpu->hv_clock, v, &vcpu->pv_time,
> > > 0, false);
> >=20
> > Yet here an below you still use 'v'. Does this actually compile?
> >=20
>=20
> Sorry, my misreading of the patch... this is in caller context so no
> problem. The inconsistent naming was misleading me.

I feel your pain, the use of "vcpu" for kvm_vcpu_arch in kvm_guest_time_upd=
ate()
kills me.  I forget if David's rework of kvm_guest_time_update() fixes that=
 wart.
If it doesn't, I'll suggest that addition.  The only reason I haven't poste=
d a
patch was to avoid a bunch of churn for a rename, but if the function is ge=
tting
ripped apart anyways...

