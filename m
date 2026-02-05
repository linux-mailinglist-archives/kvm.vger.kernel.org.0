Return-Path: <kvm+bounces-70329-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yIV9FoqthGk14QMAu9opvQ
	(envelope-from <kvm+bounces-70329-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:47:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EF0F4389
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 15:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AB52B3002B65
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 14:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FF641C312;
	Thu,  5 Feb 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KA27P/VY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B45341C2F8
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770302851; cv=none; b=ZQGSh+N0w1T0sX3IllUI2P7nNig2wGcsoQTj1BR1LLB2pLSj8HvS/a798iANE9ljoYtaq16WA67Jvg/9mvsfSO6fGaBLJkzbHMAGmva+SgfmYQMBAhpG86c0Wjq3uQbJEquubZM6swpsa/4yU4wqeB3bCAVpeMuVHUnOKRmHK9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770302851; c=relaxed/simple;
	bh=Al9I5MA6vIgi2hkQurICxKYpe+BnExJooDYvY5CEiMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R8WhGEgQzpH7rjvKCS679EM6q5nU5kiL5VOqneF7VVEz2BCNZIRXmUa/4OVaQ4KycNGkd2Ni5iaNvUz3TAdbrdjTQ+L+YwnoT+MraQ2jatzUU+jXD2jaZzwr2XxQ8ons/LgggPN34d1ENPtNlIZ515ewSGHEgBGvNuS28yTvqFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KA27P/VY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81ecb6279d9so1210724b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 06:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770302851; x=1770907651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CgILAxS+m5JUdDFMZC79/7BWVz1saQRFdnOWPRq9iwM=;
        b=KA27P/VYBqsbrASmjwG66x4waLJBPF9pRjJz2RvnajVDt36SWcMaZteN//lHSkjY/t
         FHe8H0HMvoUbHg5u1VqGfh3sKhBoojA+grR+AA0qcd3I3w1LUFtbuvXN3d0+emeIJzxh
         Jn9QbwPPnHivn7r6UTJpwVh6v9KZezr3E61Mz2eC7VFuY/REmbAyRlHzkCfiC+U20VnR
         pw2aW/zwyLuvtknoTdsxmWCtn4sqUScrd2o9o7r3WsMmbfG4ZYEPl78uSGOvGj9ABnT5
         3GWQisPP8pGjS+U5J9Uf+pRlTSkknwDGjwEn0saCbarmfFW/EVuEf4lClfsMVjHEiHdy
         jWMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770302851; x=1770907651;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CgILAxS+m5JUdDFMZC79/7BWVz1saQRFdnOWPRq9iwM=;
        b=nscgVTVjo8nwD6mlp5q9WxPlwb4d+Zwxl3p/fsCQp1Wols2OhLxZ/uje9OSx066MrG
         hbFqXpcaxXVfXL6lqtqNPIPoeiZhqf4X8usnR5Aglgzf/FASLwdV0/u3MDZ4+K/SlwyL
         HIYHqwTwS578/taSwVNj/Nwn8G8Rmezcfva/qGGMs4Bv0Pjmq+0DUhyQS+eGX9SlqHR5
         8lqBIHSiEz+qHFHPf4Kg7OZhmYvwqvxHMkLqTz+sxMVaRj9JryYeqCZdYqo45WAT1qD3
         hYKUuHCGAD9i4NMZyhP4/UJpwAN5uLukolF+aQQgVYJNDzWfQ3+BwsvV9V/yrxJIQOxI
         JN6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXryR4rZ7GNFRP17qmNTULZ6/iv7THX/QhMuPZ1BPT5EbFCJ9wKfpzYBCIrEf4s08Lcqig=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWBeCxJKi85Tdukl2yVsADPq3D5y+u1qBZa/eYewt5zvRKxu5P
	CpyGbAx6Zso/ND2Pa71EPkW+Gj7BlY66ig4FUiDt3rd/1516dFWpbX1hlA7sUDwVQobp4t5kQP5
	wJmztnQ==
X-Received: from pfbjs17.prod.google.com ([2002:a05:6a00:9191:b0:7b9:b24:c851])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1783:b0:81a:7d1e:8132
 with SMTP id d2e1a72fcca58-8241c25553amr6268941b3a.21.1770302850691; Thu, 05
 Feb 2026 06:47:30 -0800 (PST)
Date: Thu, 5 Feb 2026 06:47:28 -0800
In-Reply-To: <CALMp9eR4trBDwgDnyEJmrHnStKnAMiRgehty=xu=NMnLVN2vtw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
 <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
 <CALMp9eQx7EVim4iYGbAhoHrei2YmTra6oxtdmKaY7bw-M0PHbw@mail.gmail.com>
 <aYKoJ74MWboBuE_M@google.com> <CALMp9eSc=0zS+6Rk-c_0P-Q1Y8_9Xv58G5BYxieKpv_XaSj0wg@mail.gmail.com>
 <aYPvyMDipM9Z9Z7t@google.com> <CALMp9eR4trBDwgDnyEJmrHnStKnAMiRgehty=xu=NMnLVN2vtw@mail.gmail.com>
Message-ID: <aYStVN5MyME-Pkwt@google.com>
Subject: Re: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70329-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 61EF0F4389
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Jim Mattson wrote:
> On Wed, Feb 4, 2026 at 5:18=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Feb 04, 2026, Jim Mattson wrote:
> > > On Tue, Feb 3, 2026 at 6:00=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > >
> > > > On Thu, Jan 22, 2026, Jim Mattson wrote:
> > > > > On Tue, Jan 13, 2026 at 7:47=E2=80=AFPM Jim Mattson <jmattson@goo=
gle.com> wrote:
> > > > > > On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <se=
anjc@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jan 13, 2026, Jim Mattson wrote:
> > > > > > > > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > > > > > > > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX=
.  Prior to
> > > > > > > > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > > > > > > > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 cou=
ld set
> > > > > > > > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM =
coincident
> > > > > > > > with L2's execution.  The quirk is enabled by default for b=
ackwards
> > > > > > > > compatibility; userspace can disable it via KVM_CAP_DISABLE=
_QUIRKS2 if
> > > > > > > > consistency with WRMSR(IA32_DEBUGCTL) is desired.
> > > > > > >
> > > > > > > It's probably worth calling out that KVM will still drop FREE=
ZE_IN_SMM in vmcs02
> > > > > > >
> > > > > > >         if (vmx->nested.nested_run_pending &&
> > > > > > >             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_=
CONTROLS)) {
> > > > > > >                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > > > > >                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_=
ia32_debugctl &
> > > > > > >                                                vmx_get_suppor=
ted_debugctl(vcpu, false)); <=3D=3D=3D=3D
> > > > > > >         } else {
> > > > > > >                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > > > > >                 vmx_guest_debugctl_write(vcpu, vmx->nested.pr=
e_vmenter_debugctl);
> > > > > > >         }
> > > > > > >
> > > > > > > both from a correctness standpoint and so that users aren't m=
islead into thinking
> > > > > > > the quirk lets L1 control of FREEZE_IN_SMM while running L2.
> > > > > >
> > > > > > Yes, it's probably worth pointing out that the VM is now subjec=
t to
> > > > > > the whims of the L0 administrators.
> > > > > >
> > > > > > While that makes some sense for the legacy vPMU, where KVM is j=
ust
> > > > > > another client of host perf, perhaps the decision should be rev=
isited
> > > > > > in the case of the MPT vPMU, where KVM owns the PMU while the v=
CPU is
> > > > > > in VMX non-root operation.
> > > >
> > > > Eh, running guests with FREEZE_IN_SMM=3D0 seems absolutely crazy fr=
om a security
> > > > perspective.  If an admin wants to disable FREEZE_IN_SMM, they get =
to keep the
> > > > pieces.  And KVM definitely isn't going to override the admin, e.g.=
 to allow the
> > > > guest to profile host SMM.
> > >
> > > I'm not sure what you mean by "they get to keep the pieces." What is
> > > the security problem with allowing L1 to freeze *guest-owned* PMCs
> > > during SMM?
> >
> > To give L1 the option to freeze PMCs, KVM would also need to give L1 th=
e option
> > to *not* freeze PMCs.  At that point, the guest can use its PMCs to pro=
file host
> > SMM code.  Maybe even leverage a PMI to attack a poorly written SMM han=
dler.
>=20
> Perhaps I'm missing something. I was thinking, essentially, of a logical =
or:
>=20
> vmcs02.debugctl.freeze_in_smm =3D vmcs12.debugctl.freeze_in_smm |
> vmcs01.debugctl.freeze_in_smm
>=20
> So, an L1 request to freeze counters in SMM would be granted, but an
> L1 request to *not* freeze counters could be overruled by the host.

/facepalm

Sorry, I misunderstood what you were suggesting.  Not sure how, it's super =
obvious,
at least in hindsight.

> I'm not suggesting this in the context of the legacy vPMU, because
> some PMCs may be counting host-initiated perf events, and L1 should
> not have any say in what those PMCs count. However, with the mediated
> vPMU, L1 owns the entire PMU while L2 is running, so it seems
> reasonable to allow it to freeze the counters during physical SMM.

Agreed.

> > In other words, unless I'm missing something, the only reasonable optio=
n is to
> > run the guest with FREEZE_IN_SMM=3D1, which means ignoring the guest's =
wishes.
> > Or I guess another way to look at it: you can have any color car you wa=
nt, as
> > long as it's black :-)
>=20
> I would be happy with FREEZE_IN_SMM=3D1. I'm not happy with the host
> dictating FREEZE_IN_SMM=3D0.

Yep, make sense.

