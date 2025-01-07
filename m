Return-Path: <kvm+bounces-34713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16475A04B72
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 22:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0193F166840
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 21:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168F21F37C0;
	Tue,  7 Jan 2025 21:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C7JibWba"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF10193404
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 21:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736284560; cv=none; b=GONpI5CRHYKdFm3xOSewFTiVh6cTHdcORLbsj3Miq+hnEhsUqhOvt3jT0QIpxnVBWbP1wVstEMOPyNBxvbQ4odPlUNaE38XucaGYcSfS1aH8+hDFqa4NGAIYL7aUUUvqAyX0Ht4OpvmdS/9icG3J/D/2sWJUdqjYf/hLCSRi/uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736284560; c=relaxed/simple;
	bh=2FpNaEXQ8xQA2MTVke+4O0H5c2+DdJHfxrMdHw8J22Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bRNO4DKqI0OqoPhaBdgXhc47tR5r+RhcsbGnuBZakc5pXv87rxCc1A5a2qa8RCbxPWuI4R+HWL+voL7zcNM3vKKQfBc7FSpyLeCqJpb2gZnabJi+rZ6DLiMbRNWiSEo2ImBosdP08d8IZ+oD7eLCWQeZxlaaU1DY4I+4n1FgLtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C7JibWba; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216430a88b0so231923625ad.0
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 13:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736284557; x=1736889357; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tpykW6aRa97Fn/TAsIxTWJnIe1BxGqwoS1e1wLY1NxQ=;
        b=C7JibWbatkfm8Gj56yZ4Ygmomoil+V5U8Ftws75IiGW4t+ZNLCAyyT6MDbcfXsc2tS
         zg5zMcBc5z7TaN8hZQBoQDs/IWYBk2AXnK1z5EA6x0i7OvJ6HoX8Eoaa3CgXR8aZQmQu
         ie7bs2ukxiJxgBzkWgZ3ojOPRoVxF5msq8iNU9IABgJB3sR3h9oiMdJ5GZd9hZ5AIxKT
         DccRc9Q+GEKPaGdu9xgHsjD3wkGaqyQmTvW/WCp+DLM0/m/rDPuuFl936sWMDmRaSfQO
         dVz8VDryfMjth79RzuFjNFoyLxcUq+vn749suBjyMsrQGQh/IaEX2a9DAe6FlIcvJrrE
         J6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736284557; x=1736889357;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tpykW6aRa97Fn/TAsIxTWJnIe1BxGqwoS1e1wLY1NxQ=;
        b=MVJYxRaU5+N7+vsZgw8Rd0oePtY0fQsj5kNWjzYyoTuS/fkleNlFuWcFkLuQ7xaea/
         S1oL+wxYGokL4+5zn3H93wVLHeoLHFejjbI7YvAJ0BnIo09Yusvdh9c0jBePSH4SQNUo
         74UYSLSV/jeuSUyKWsfDYADSoGSFLn/ZyKc2CN2KzvxQamUw0w5IWV9/RZC65vd+3bjI
         NP8EIZV+Qb5KGCk/hbsrGUa3ZrgR55xhlisivj+ZjaQFPXDG9IwGqb3tTxvu+vojNoUX
         0fuJ9DPNmRHdIXGs+4Kf7dAEu9+sHYnIbUFV01Aigi8Ta9DCefcwEbXe4rGE1E13wsNh
         +ldA==
X-Forwarded-Encrypted: i=1; AJvYcCWcrUJkvP53jvNGpuystCfa7oXXgJImtgDbWMk0pAb/TIYsYB5WSc/DG72xIyz9pF8DKiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNyDZ6MPcqS4vgsYhfHTyyA3ZsuoC0tR5zJmAlbEK81KMODkBI
	Sw20IzBd03Ugw0BfLu1ladpNVjDTc8Ks9sPrjRNTTD7WNAbl0H+HH7OBDLyJ+932X5i6KL/tZ6w
	eag==
X-Google-Smtp-Source: AGHT+IHn9oiNuhAf4IW3SY/bFOYkHHz7vyz4CtxQI658bYKRE7q8bKAyNwRbP7N0cn7Qh1Wdpuli3qvVfKI=
X-Received: from pfms15.prod.google.com ([2002:aa7:828f:0:b0:72a:bcc3:4c9a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a05:b0:1e1:bdae:e058
 with SMTP id adf61e73a8af0-1e88d0d6b86mr1274231637.37.1736284557351; Tue, 07
 Jan 2025 13:15:57 -0800 (PST)
Date: Tue, 7 Jan 2025 13:15:56 -0800
In-Reply-To: <ef29512a-2ca0-47c4-8b6e-6553bce1e273@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-13-binbin.wu@linux.intel.com> <CAGtprH9UBZe64zay0HjZRg5f--xM85Yt+jYijKZw=sfxRH=2Ow@mail.gmail.com>
 <fc6294b7-f648-4daa-842d-0b74211f8c3a@linux.intel.com> <CAGtprH_JYQvBimSLkb3qgshPbrUE+Z2dTz8vEvEwV1v+OMD6Mg@mail.gmail.com>
 <Z3xqBpIgU6-OGWaj@google.com> <Z3yeWvg+JZ//wbLZ@intel.com> <ef29512a-2ca0-47c4-8b6e-6553bce1e273@linux.intel.com>
Message-ID: <Z32ZjGH72WPKBMam@google.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2025, Binbin Wu wrote:
> On 1/7/2025 11:24 AM, Chao Gao wrote:
> > > Note, kvm_use_posted_timer_interrupt() uses a heuristic of HLT/MWAIT =
interception
> > > being disabled to detect that it's worth trying to post a timer inter=
rupt, but off
> > > the top of my head I'm pretty sure that's unnecessary and pointless. =
 The
> > Commit 1714a4eb6fb0 gives an explanation:
> >=20
> >    if only some guests isolated and others not, they would not
> >    have any benefit from posted timer interrupts, and at the same time =
lose
> >    VMX preemption timer fast paths because kvm_can_post_timer_interrupt=
()
> >    returns true and therefore forces kvm_can_use_hv_timer() to false.

But that's only relevant for setup.  Upon expiration, if the target vCPU is=
 in
guest mode and APICv is active, then from_timer_fn must be true, which in t=
urn
means that hrtimers are in use.

> Userspace uses KVM_CAP_X86_DISABLE_EXITS to enable mwait_in_guest or/and
> hlt_in_guest for non TDX guest. The code doesn't work for TDX guests.
> - Whether mwait in guest is allowed for TDX depends on the cpuid
> =C2=A0 configuration in TD_PARAMS, not the capability of physical cpu che=
cked by
> =C2=A0 kvm_can_mwait_in_guest().
> - hlt for TDX is via TDVMCALL, i.e. hlt_in_guest should always be false
> =C2=A0 for TDX guests.
>=20
> For TDX guests, not sure if it worths to fix kvm_{mwait,hlt}_in_guest()
> or add special handling (i.e., skip checking mwait/hlt in guest) because
> VMX preemption timer can't be used anyway, in order to allow housekeeping
> CPU to post timer interrupt for TDX vCPUs when nohz_full is configured
> after changing APICv active to true.

Yes, but I don't think we need any TDX-specific logic beyond noting that th=
e
VMX preemption can't be used.  As above, consulting kvm_can_post_timer_inte=
rrupt()
in the expiration path is silly.

And after staring at all of this for a few hours, I think we should ditch t=
he
entire lapic_timer.pending approach, because at this point it's doing more =
harm
than good.  Tracking pending timer IRQs was primarily done to support deliv=
ery
of *all* timer interrupts when multiple interrupts were coalesced in the ho=
st,
e.g. because a vCPU was scheduled out.  But that got removed by commit
f1ed0450a5fa ("KVM: x86: Remove support for reporting coalesced APIC IRQs")=
,
partly because posted interrupts threw a wrench in things, but also because
delivering multiple periodic interrupts in quick succession is problematic =
in
its own right.

With the interrupt coalescing logic gone, I can't think of any reason KVM n=
eeds
to kick the vCPU out to the main vcpu_run() loop just to deliver the interr=
upt,
i.e. pending interrupts before delivering them is unnecessary.  E.g. condit=
ioning
direct deliverly on apicv_active in the !from_timer_fn case makes no sense,=
 because
KVM is going to manually move the interrupt from the PIR to the IRR anyways=
.

I also don't like that the behavior for the posting path is subtly differen=
t than
!APICv.  E.g. if an hrtimer fires while KVM is handling a write to TMICT, K=
VM will
deliver the interrupt if configured to post timer, but not if APICv is disa=
bled,
because the latter will increment "pending", and "pending" will be cleared =
before
handling the new TMICT.  Ditto for switch APIC timer modes.

Unfortunately, there is a lot to disentangle before KVM can directly delive=
r all
APIC timer interupts, as KVM has built up a fair bit of ugliness on top of =
"pending".=20

E.g. when switching back to the VMX preemption timer (after a blocking vCPU=
 is
scheduled back in), KVM leaves the hrtimer active.  start_hv_timer() accoun=
ts for
that by checking lapic_timer.pending, but leaving the hrtimer running in th=
is case
is absurd and unnecessarily relies on "pending" being incremented.

	if (kvm_x86_call(set_hv_timer)(vcpu, ktimer->tscdeadline, &expired))
		return false;

	ktimer->hv_timer_in_use =3D true;
	hrtimer_cancel(&ktimer->timer);

	/*
	 * To simplify handling the periodic timer, leave the hv timer running
	 * even if the deadline timer has expired, i.e. rely on the resulting
	 * VM-Exit to recompute the periodic timer's target expiration.
	 */
	if (!apic_lvtt_period(apic)) {
		/*
		 * Cancel the hv timer if the sw timer fired while the hv timer
		 * was being programmed, or if the hv timer itself expired.
		 */
		if (atomic_read(&ktimer->pending)) {
			cancel_hv_timer(apic);
		} else if (expired) {
			apic_timer_expired(apic, false);
			cancel_hv_timer(apic);
		}
	}

I'm also not convinced that letting the hrtimer run on a different CPU in t=
he
"normal" case is a good idea.  KVM explicitly migrates the timer, *except* =
for
the posting case, and so not pinning the hrtimer is likely counter-producti=
ve,
not to mention confusing.

  void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
  {
	struct hrtimer *timer;

	if (!lapic_in_kernel(vcpu) ||
		kvm_can_post_timer_interrupt(vcpu))
		return;

	timer =3D &vcpu->arch.apic->lapic_timer.timer;
	if (hrtimer_cancel(timer))
		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_HARD);
  }

And if the hrtimer is pinned to the pCPU, then in practice it should be imp=
ossible
for KVM to post a timer IRQ into a vCPU that's in guest mode.

Seapking of which, posting a timer IRQ into a vCPU that's in guest mode is =
a bit
dodgy.  I _think_ it's safe, because all of the flows that can be coinciden=
t are
actually mutually exclusive.  E.g. apic_timer_expired()'s call to
__kvm_wait_lapic_expire() can't collide with the call from the entry path, =
as the
entry path's invocation happens with IRQs disabled.

But all of this makes me wary, so I'd much prefer to clean up, harden, and =
document
the existing code before we try to optimize timer IRQ delivery for more cas=
es.
That's especially true for TDX as we're already adding significant compexli=
ty
and multiple novel paths for TDX; we don't need more at this time :-)

