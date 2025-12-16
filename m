Return-Path: <kvm+bounces-66078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B6B3BCC41C4
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77CCA305BFDF
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 16:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1453821D3CA;
	Tue, 16 Dec 2025 16:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W5DKYl8t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DF2BE5E
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765900867; cv=none; b=qcLX8rxuXYhQrIjop9I3Il8IlZQGMpI6/qfSZNUlfVpfa4HruPcdnSPr+7WNHJMYQLBFDHRvXh6M5/ZVVHwvidRDId4nY8T4uyQtzEt1WXdsLFmxKTAdTmqeGmQricM8vgOeyo7IK7x8lEP9GTlAG/Q/4X9/hKMic8MKpvTmFsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765900867; c=relaxed/simple;
	bh=yNFnE3QRWlC1z1b1Pzzpu0pYl/KVYC+2f5/9GLoa/4w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RhFHI/S94jgZ8AwI0ttiTvG82ZNr138ZxfVfIoe8oTqWVMODW/oQbCsNhZSsnze0DLclngpKgDRSJXn3ug7goSnvK4w018pLISIysBhFtM57pjfzLvfQGMScIFJ2Oix+1SEjb97d5aQcvSag6xVyjokIpFp43pTKhf4wCx/uxsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W5DKYl8t; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so11539786a91.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 08:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765900865; x=1766505665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ed0NKnHXDUx6y67ShmBXuv80GX62o6+xq78eUXQD85M=;
        b=W5DKYl8tlV1YqJlX20UbYj5sbOZ3rtQsFDAAWEMDGiAJc/gvpmXmzCTNh09o7uRn8y
         h13hCy1/lfk38zguFoV6CRQAodYP0Ft89Ecn/jB4tirNfcTZwsWkr0vMOc58UPZTF2iI
         4sqLCHIJhTgulsUNCdjTDdiGGwiLyBE6vB2oYxOxn8j1RVePvaNuzjxVJHL4OgLo91Is
         enxHbTx1xhuTP2myZOpnVumgHuFJ9bX504WxbQQtF/FKhgSgP8wmxZoCW0QE9NrOUWpi
         Jy3ePjNgyJJ8EfrmcXDWpADtDXR19W38OFkE8zFtpcp0Xc2QT+9req7N03HHYS4RNMJv
         S3sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765900865; x=1766505665;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ed0NKnHXDUx6y67ShmBXuv80GX62o6+xq78eUXQD85M=;
        b=BE/g80F2eFoQKPLbgjehE7ycnHLs8Qiae06+L/mrvR/MTkjAuhPHeLBgeGF5ZJSNPj
         /3jkKCWqXQrOfCWAAFK3GCmbXt26tY7jguf1H47CyO+/8EGgYIw/naW+na/EsgB1DhRZ
         SlaBo4XRtWBaQ+AwBdb2Dfe83jSpW3lCdj0ohH+gTIEc7Dm9h54jDC+T+ONXRovHiVBZ
         dhMTf0pkJO5xLuX8k2WSMQQ1GmQMjGe+pJMAliLi1EgRxO5c496lAgm2UZptP1EWlXnI
         fVVMmhkJwwLb/NI7T+JckzKaqxfyaI0JyFajvoqifbdSle9Ah1XWQmw7lDc7oRqA7t6e
         q8TA==
X-Forwarded-Encrypted: i=1; AJvYcCWAEGOwPxyz1nW+51C8dyHrXlXPBoYR+geg0Ru9Pryy94IRdSlPs+SmqWn0mz5FPtEELEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzryRNjOowXOEHBvxqCA5gUhlurE82XakvLQsstdW7jX2ecZQsE
	+RJyrbsm77TC0CWWw07z/nefFdpwGdKHLd0T3P5IAQWRXBqFWP+qT2KghPiOaWX/IYzXQ9N+AQU
	/VWx4ew==
X-Google-Smtp-Source: AGHT+IHxGgJVMrExe1w1FALuUErnemaqW+x4EsczgP3V99F1HVfGLEgM+LG40KSurJS2g3VWhV/ZeVpDzeA=
X-Received: from pjbqx13.prod.google.com ([2002:a17:90b:3e4d:b0:34c:811d:e3ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d450:b0:34c:f92a:ad05
 with SMTP id 98e67ed59e1d1-34cf92ac1ebmr161260a91.11.1765900864883; Tue, 16
 Dec 2025 08:01:04 -0800 (PST)
Date: Tue, 16 Dec 2025 08:01:03 -0800
In-Reply-To: <CAE6NW_ZwdpGN0F_8NVe77tgGPw7nO5Mi-t1455gGoLcUVpVbpw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205070630.4013452-1-chengkev@google.com> <aThT5d5WdMSszN9b@google.com>
 <CAE6NW_ZwdpGN0F_8NVe77tgGPw7nO5Mi-t1455gGoLcUVpVbpw@mail.gmail.com>
Message-ID: <aUGCP_n74pzTKLY6@google.com>
Subject: Re: [PATCH] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, jmattson@google.com, yosry.ahmed@linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 13, 2025, Kevin Cheng wrote:
> On Tue, Dec 9, 2025 at 11:52=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Fri, Dec 05, 2025, Kevin Cheng wrote:
> > static
> > void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> >                                          struct vmcb_ctrl_area_cached *=
to,
> >                                          struct vmcb_control_area *from=
)
> > {
> >         unsigned int i;
> >
> >         for (i =3D 0; i < MAX_INTERCEPT; i++)
> >                 to->intercepts[i] =3D from->intercepts[i];
> >
> >         nested_svm_sanitize_intercept(vcpu, to, RDTSCP);
> >         nested_svm_sanitize_intercept(vcpu, to, SKINIT);
> >         __nested_svm_sanitize_intercept(vcpu, to, XSAVE, XSETBV);
> >         nested_svm_sanitize_intercept(vcpu, to, RDPRU);
> >         nested_svm_sanitize_intercept(vcpu, to, INVPCID);
> >
> > Side topic, do we care about handling the case where userspace sets CPU=
ID after
> > stuffing guest state?  I'm very tempted to send a patch disallowing KVM=
_SET_CPUID
> > if is_guest_mode() is true, and hoping no one cares.
>=20
> Hmm good point I haven't thought about that. Would it be better to
> instead update the nested state in svm_vcpu_after_set_cpuid() if
> KVM_SET_CPUID is executed when is_guest_mode() is true?

Allowing CPUID to change (or VMX feature MSRs) when the vCPU is in L2 creat=
es a
massive set of potential complications that would be all but impossible to =
handle.
E.g. if userspace clears features that are being used to run L2, then KVM c=
ould
end up with conflicting/nonsensical state for the vCPU.

Note, the same holds true for non-nested features, which is largely what le=
d to
63f5a1909f9e ("KVM: x86: Alert userspace that KVM_SET_CPUID{,2} after KVM_R=
UN is
broken") and feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RU=
N").

> Also sorry if this is a dumb question, but in general if KVM_SET_CPUID
> is disallowed, then how does userspace handle a failed IOCTL call?

The VMM logs an error and exits.

> Do they just try again later or accept that the call has failed? Or is th=
ere
> an error code that signals that the vcpu is executing in guest mode and
> should wait until not in guest mode to call the IOCTL?

In practice, CPUID (and feature MSRs) are set very early on, when userspace=
 is
creating vCPUs.  With one exception, any other approach simply can't work, =
because
as above CPUID can't be configured after the vCPU has run.  The only way fo=
r the
vCPU to be "running" L2 is if userspace stuffed guest state via KVM_SET_NES=
TED_STATE,
and actually changing CPUID after that point simply can't work (it'll "succ=
eed",
but KVM provides no guarantees as to the viability of the vCPU).

The exception is that KVM allows setting _identical_ CPUID after KVM_RUN to
support QEMU's vCPU hotplug implementation, which is what commit c6617c61e8=
fe
("KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN") is all about.

Trying to _completely_ protect userspace from itself is a fool's errand, as=
 KVM's
granular set of ioctls for loading vCPU state and the subjectivity of what =
is a
"sane" vCPU model make it all but impossible to fully prevent userspace fro=
m
hurting itself without creating a maintenance nightmare.  But I can't think=
 of
any scenario where it would be useful for userspace to set nested state, th=
en go
back and change the vCPU model.

I'll send a patch and see what happens.  Worst case scenario we break users=
pace
and get to learn about crazy VMM behavior :-)

