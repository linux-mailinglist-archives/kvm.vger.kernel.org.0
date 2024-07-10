Return-Path: <kvm+bounces-21310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5240192D366
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:52:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E51E283413
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 13:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC11193470;
	Wed, 10 Jul 2024 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dRpNqBuA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A13192B8F
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720619543; cv=none; b=BTQVp2dseuBGYCWuMReKuBWe6RmarvWljhdRKmoFQJIf6zPg05p3JNR1nFjn4zg5VIM2lTfeefUPHa+LnCKp7YenaO+P5jktbB7gHVxFsvglW7jqxRJkoakY8AFMHoDpavnH34Qp0B/tTIEWyFPkibFi+aD6oFzMgItmTphp63I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720619543; c=relaxed/simple;
	bh=K+zPsZi+srywBZDuKcnUQzrg2Z14hU1r6iCS86pvCkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aQtDxGMUDpDFLNIuqzzV7CLAm4nZUgousP+8IoiCRzx9WcIPOOyKUH6WU4w3wDLesecqZ4PKkN7cGGXRjyLZ9Q/KPpp8rZ06ISvTm54J2Ggr6XVX8Ni+JM0FVRHkdkez6bh2QxoWSoCPpjudKvBJ4tTGeP9hA07ooMkRhYteyr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dRpNqBuA; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0360f8d773so10844079276.3
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 06:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720619540; x=1721224340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8rUr00jWkE2y0/1opy/I3K41SPy3FE0JTaHuvcV+2TE=;
        b=dRpNqBuAQuO1J6v6hO4DnGr3Gqqbi8Wc66iOsMBaTG5iU1gVzFVBixfskCP7gQA0lK
         YESOiDro4mGFxd2IbCvPMwmL4XOBed6DqWXBvQnWbXKalR7fzeQR4fCvyWbXu0Q8JjOo
         hnMmJr4GGstSWg6r/GOXUBvPqylcfgM4EhlpmIVez7/iDDEsk+TqKr2+5vMutO2pDOoV
         aVSYVoVqhvoOa/9LZa4QOYG6+v28P1QrNI2RPxb4KUmKL1pEyLjsiJHMhSVlqVIJQCEn
         NAtAEfUZA3DC01UBWKhIO40c/wzVcjydwLPYGnvzsoGyfRUWWZU5CddvEV1Uyf+8GowZ
         YS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720619540; x=1721224340;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8rUr00jWkE2y0/1opy/I3K41SPy3FE0JTaHuvcV+2TE=;
        b=wNVdRR9NlLe5bSL1YACgt01f9/Cj+7lQlcnnvTN6MA/bOUD33oDtw/AJ7xBbPP5Igu
         JVZI8BzC6O2HR3hsLjbUoGCiBhVtw2hMbNSlu+am3wGh3BkhSe++EaVtJD9ezS6HGrU+
         X9SAO95MReYu3MxLkQDEA+YnewvN5Z+M6/X0Dc1nMAh5sbWRB/mmL1jdHutcDzMmQlj1
         2T+R1ruzVRLEsKiiP/0XTdloGcK4EjBkMtAIkU00qXQc9g03CBbtNVijqPJNhz0lSpgl
         YFwsHtdKtzGlwrFnHfrF5ExpUFxa8k242M5EWkV58LZj+ScQQ8+Gf/jxKET520b7UOnz
         fU6A==
X-Forwarded-Encrypted: i=1; AJvYcCXtbY+NGygHujc3PINOuRqA5zJOEDVNGKS9K9RJ2klhW87kj30upbPgFfScHwfvLfgwGGRrOkkZXea9B+RAYHEVDfdx
X-Gm-Message-State: AOJu0YwkLZfiGdK6CjYKw9RpR2/PC77/MR64ygS/CHHSn7E+L/65Xv5o
	3ohJqWQruZuyBR8tkIoRWbG4YAgRElYcLlkynx27Js1LP+yZbudQHBK4XBNSX8FAhXIDchDEpbR
	g/Q==
X-Google-Smtp-Source: AGHT+IF5FKCCSgKayU+3HxtAmEuD2r8g64i5mfbrkGAq2HRAzkjanq7IuF/cbMLIHkKt50yZooyzb0oBz6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2005:b0:e03:c033:1ce3 with SMTP id
 3f1490d57ef6-e041b04e66emr273986276.4.1720619540454; Wed, 10 Jul 2024
 06:52:20 -0700 (PDT)
Date: Wed, 10 Jul 2024 06:52:18 -0700
In-Reply-To: <CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429060643.211-1-ravi.bangoria@amd.com> <20240429060643.211-4-ravi.bangoria@amd.com>
 <Zl5jqwWO4FyawPHG@google.com> <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com>
 <ZmB_hl7coZ_8KA8Q@google.com> <59381f4f-94de-4933-9dbd-f0fbdc5d5e4a@amd.com>
 <Zmj88z40oVlqKh7r@google.com> <0b74d069-51ed-4e5e-9d76-6b1a60e689df@amd.com> <CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com>
Message-ID: <Zo6RxnGJrxh9mi7g@google.com>
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk, 
	peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com, 
	arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn, 
	nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ananth.narayan@amd.com, 
	sandipan.das@amd.com, manali.shukla@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2024, Jim Mattson wrote:
> On Tue, Jul 9, 2024 at 7:25=E2=80=AFPM Ravi Bangoria <ravi.bangoria@amd.c=
om> wrote:
> >
> > Sean,
> >
> > Apologies for the delay. I was waiting for Bus Lock Threshold patches t=
o be
> > posted upstream:
> >
> >   https://lore.kernel.org/r/20240709175145.9986-1-manali.shukla@amd.com
> >
> > On 12-Jun-24 7:12 AM, Sean Christopherson wrote:
> > > On Wed, Jun 05, 2024, Ravi Bangoria wrote:
> > >> On 6/5/2024 8:38 PM, Sean Christopherson wrote:
> > >>> Some of the problems on Intel were due to the awful FMS-based featu=
re detection,
> > >>> but those weren't the only hiccups.  E.g. IIRC, we never sorted out=
 what should
> > >>> happen if both the host and guest want bus-lock #DBs.
> > >>
> > >> I've to check about vcpu->guest_debug part, but keeping that aside, =
host and
> > >> guest can use Bus Lock Detect in parallel because, DEBUG_CTL MSR and=
 DR6
> > >> register are save/restored in VMCB, hardware cause a VMEXIT_EXCEPTIO=
N_1 for
> > >> guest #DB(when intercepted) and hardware raises #DB on host when it'=
s for the
> > >> host.
> > >
> > > I'm talking about the case where the host wants to do something in re=
sponse to
> > > bus locks that occurred in the guest.  E.g. if the host is taking pun=
itive action,
> > > say by stalling the vCPU, then the guest kernel could bypass that beh=
avior by
> > > enabling bus lock detect itself.
> > >
> > > Maybe it's moot point in practice, since it sounds like Bus Lock Thre=
shold will
> > > be available at the same time.
> > >
> > > Ugh, and if we wanted to let the host handle guest-induced #DBs, we'd=
 need code
> > > to keep Bus Lock Detect enabled in the guest since it resides in DEBU=
G_CTL.  Bah.
> > >
> > > So I guess if the vcpu->guest_debug part is fairly straightforward, i=
t probably
> > > makes to virtualize Bus Lock Detect because the only reason not to vi=
rtualize it
> > > would actually require more work/code in KVM.
> >
> > KVM forwards #DB to Qemu when vcpu->guest_debug is set and it's Qemu's
> > responsibility to re-inject exception when Bus Lock Trap is enabled
> > inside the guest. I realized that it is broken so I've prepared a
> > Qemu patch, embedding it at the end.
> >
> > > I'd still love to see Bus Lock Threshold support sooner than later th=
ough :-)
> >
> > With Bus Lock Threshold enabled, I assume the changes introduced by thi=
s
> > patch plus Qemu fix are sufficient to support Bus Lock Trap inside the
> > guest?
>=20
> In any case, it seems that commit 76ea438b4afc ("KVM: X86: Expose bus
> lock debug exception to guest") prematurely advertised the presence of
> X86_FEATURE_BUS_LOCK to userspace on non-Intel platforms. We should
> probably either accept these changes or fix up that commit. Either
> way, something should be done for all active branches back to v5.15.

Drat.  Yeah, we need a patch to clear BUS_LOCK_DETECT in svm_set_cpu_caps()=
, marked
for stable@.  Then this series can remove that clearing.

At least I caught it for CET[*]!  It'd be nice to not have to rely on human=
s to
detect potential issues like this, but I can't think of a way to programmat=
ically
handle this situation without incurring an annoying amount of overhead and/=
or
duplicate code between VMX and SVM.

[*] https://lore.kernel.org/all/ZjLRnisdUgeYgg8i@google.com


