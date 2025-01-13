Return-Path: <kvm+bounces-35307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6841A0BEB7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 18:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 948371882CF6
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6041AB6FF;
	Mon, 13 Jan 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eM+Wr1aq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8211624022B
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736788600; cv=none; b=Mj63+eXDvKgAhFlEbuBnCzmClNSFuA6n3pwyF0RXeBar/s3SdMMhExsvwjTzadfo29QRMCGRW5fSwDzb+evgNBskS6HqezmhBBn4eJrAswrGamV9hbYLYqu9Q7QQ3wjqA6kGDAw/LgdFmgrfADemNudz5vGNZtqDqrrrY7C93GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736788600; c=relaxed/simple;
	bh=KXuWOL9Jmp7HkOtVP9zqjsstdlAs/AkTE/pwqMwaVIM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fOmQec0j9zS6eR5N3Y0Lu9/B1m99q3j2wAzdH9SosNkkt1MiIZUeMmcEfxYQnGDbUPY2jeWUENZv/UlpU5EV6ESi9Zo0tFONdave3ISkEgB6y/CXWEh7wE1ryLxc1RdzjLD8VfygV+x3jkZvIe5FgXp3OF+BTXj9Q8DAKYj0mpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eM+Wr1aq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so12823308a91.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 09:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736788599; x=1737393399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nEU3QcYgxcuDG/XTFhKXnhP1cGBlAjgOcs1ki5fsLkw=;
        b=eM+Wr1aqCBCgfuoC2shm2rG3NYIIqw8peNgsnt9vp1z0isGsan89B47RgYIELjedxy
         a4plkhlJe8zR+tgktN8hG551e74jnfAbGqAiLQ6h2QnUHZWcXOrEdUqD4xk4cyv3tb2N
         pOl02Oj1AXsybD/z/BcEpZcGExuVYYr8wkby0zESqJERGP9znBUuMocreqJPR9tkuX5a
         9oVgRClpYGuYSAZYOHfbm+gClNFm4FWfu31t0m0BrJiBL8wFt/sxduGk+UZQ++MiHK0u
         7WhcZrtcC66C+kYnBI13nR3uZqJIRlwHK3SV1jfzXltYeWcLL/dxCkHAYfikPp80BPiy
         RMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736788599; x=1737393399;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nEU3QcYgxcuDG/XTFhKXnhP1cGBlAjgOcs1ki5fsLkw=;
        b=wzKp7UbET6JtP1EJrbPhwYcR3OcGUqmlHgY3Pc4gKgKvDAtNCv5GiOTrCGXaOI896E
         ksL+gb6Z6GMld8vjUMmzVk6UPDvlfPViaqrVHUgk7fsI1Mwa56Jkn31gvqmQ5/LmLHbP
         jEqeCTGKUmmiYCWvFKoIBFc04EtXw72RMLsCv2sFT/0VOU2PzS8DiRMMej1AJseglGBT
         Bd9efVZWOvL7xdw9aZLkRmtCHhBxpvJLgybN1CM05jTqIOYrGP82YFpkJIwLjEencKrt
         sjae0lCiGjD+5SFnn+YeHK+FUsPO+uIVw844iPffnOEH9PxAdVsin13Q6vE7MGl0wPvd
         /TDw==
X-Forwarded-Encrypted: i=1; AJvYcCWpWzNKL8iKaz8gfrVll1je8sqqioHJg8qpINbI8kaiSvaneL4oEnrJ6fR5xnsrUheKKuI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9+K1uZdZBfTa6mcgjuhF+SDkUTZX0kyuBQExLdOLXb6IDBQzz
	Io6613YLR6HeGyHkwmfRGIV6pp/Zk3gUp8XC4jfVe/ZvkRnaau1Qeg9UQCJzbb5vZBVe4D2vG0A
	JsA==
X-Google-Smtp-Source: AGHT+IGPZlMyyc/s8MAEqiLyi+6hQD41IpNLWRbB7OHMOuLlBIzhp9XO5up8nhHz/TanxkJ5o7Qi6mygRjw=
X-Received: from pjbeu7.prod.google.com ([2002:a17:90a:f947:b0:2f2:e5c9:de99])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2709:b0:2ee:c91a:acf7
 with SMTP id 98e67ed59e1d1-2f548f0b2e1mr30689138a91.4.1736788598844; Mon, 13
 Jan 2025 09:16:38 -0800 (PST)
Date: Mon, 13 Jan 2025 09:16:37 -0800
In-Reply-To: <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
Message-ID: <Z4VKdbW1R0AoLvkB@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, 
	yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2025, Binbin Wu wrote:
> On 1/13/2025 10:03 AM, Binbin Wu wrote:
> >=20
> > On 12/9/2024 9:07 AM, Binbin Wu wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >=20
> > > Inhibit APICv for TDX guest in KVM since TDX doesn't support APICv ac=
cesses
> > > from host VMM.
> > >=20
> > > Follow how SEV inhibits APICv.=C2=A0 I.e, define a new inhibit reason=
 for TDX, set
> > > it on TD initialization, and add the flag to kvm_x86_ops.required_api=
cv_inhibits.
> >=20
> Resend due to the format mess.

That was a very impressive mess :-)

> After TDX vCPU init, APIC is set to x2APIC mode. However, userspace could
> disable APIC via KVM_SET_LAPIC or KVM_SET_{SREGS, SREGS2}.
>=20
> - KVM_SET_LAPIC
> =C2=A0 Currently, KVM allows userspace to request KVM_SET_LAPIC to set th=
e state
> =C2=A0 of LAPIC for TDX guests.
> =C2=A0 There are two options:
> =C2=A0 - Force x2APIC mode and default base address when userspace reques=
t
> =C2=A0=C2=A0=C2=A0 KVM_SET_LAPIC.
> =C2=A0 - Simply reject KVM_SET_LAPIC for TDX guest (apic->guest_apic_prot=
ected
> =C2=A0=C2=A0=C2=A0 is true), since migration is not supported yet.
> =C2=A0 Choose option 2 for simplicity for now.

Yeah.  We'll likely need to support KVM_SET_LAPIC at some point, e.g. to su=
pport
PID.PIR save/restore, but that's definitely a future problem.

> Summary about APICv inhibit reasons:
> APICv could still be disabled runtime in some corner case, e.g,
> APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED due to memory allocation failure=
.
> After checking enable_apicv in tdx_bringup(), apic->apicv_active is
> initialized as true in kvm_create_lapic().=C2=A0 If APICv is inhibited du=
e to any
> reason runtime, the refresh_apicv_exec_ctrl() callback could be used to c=
heck
> if APICv is disabled for TDX, if APICv is disabled, bug the VM.

I _think_ this is a non-issue, and that KVM could do KVM_BUG_ON() if APICv =
is
inihibited by kvm_recalculate_apic_map() for a TDX VM.  x2APIC is mandatory
(KVM_APIC_MODE_MAP_DISABLED and "APIC_ID modified" impossible), KVM emulate=
s
APIC_ID as read-only for x2APIC mode (physical aliasing impossible), and LD=
R is
read-only for x2APIC (logical aliasing impossible).

To ensure no physical aliasing, KVM would need to require KVM_CAP_X2APIC_AP=
I be
enabled, but that should probably be required for TDX no matter what.

> kvm_arch_dy_has_pending_interrupt()
> -----------------------------------
> Before enabling off-TD debug, there is no functional change because there
> is no PAUSE Exit for TDX guests.
> After enabling off-TD debug, the kvm_vcpu_apicv_active(vcpu) should be tr=
ue
> to get the pending interrupt from PID. Set APICv to active for TDX is the
> right thing to do.

And as alluded to above, for save/restore, e.g. intrahost migration.

