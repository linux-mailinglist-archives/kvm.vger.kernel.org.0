Return-Path: <kvm+bounces-37419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5DCCA29E55
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 02:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 610D9167F90
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 01:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AF638DE0;
	Thu,  6 Feb 2025 01:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Wg5c8sq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116BC151998
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 01:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805394; cv=none; b=KnAvRppRhrOhiqlbpLOsUBDx+ZGTnPkB2n+0nSF91psZX6CsRAPzNGC6JlFFRkaZqQuM9ZZuA8tg3ovCAbmPKvFFQNNePvMJs1/DeaHhvTTgRKn195poV5ujLUtQc6UO++/l3ofVQmpDMV+KfMGNJRUk7X/G2CeappTI4eBFcfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805394; c=relaxed/simple;
	bh=R6UH1A8cn89rNpOS450WPLBOLVlrOPelUtl5M85AHTA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oAYNkMG47ANNrWvj+OmuVE9czvaAyZTPaCMbL4fllaywktyzubrTsfqvLRYZhWYKtqV3+yVz+qThwPp8Ix+7kJAEWsJOGaCvCr5OlAgZJl4H/GqRwdXU1eKtCW/QmD3Cz8Kde81grSCrBaWWl4Gg/NYUPMCtZFfor1VWmPUoMJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Wg5c8sq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f9c34c0048so1001815a91.3
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 17:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738805392; x=1739410192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIxvtwzmLpA97snLzsRJfxwNm03aAP0R1NKy0YT1wtQ=;
        b=2Wg5c8sq2VPgfAFdrd/2PkJB90nXb4BF+uQ2j0cqeVm0b8t1cHzcdfBfg/sKs98gUY
         J+8MOEZuP1rQ4UDYxkuuFHufgCKbI0/+rEVUhrmQCk2a6MJGknU37/Kv1DH0JhcDiRz/
         BcUHex8yKcDUeMQ57A/LSnEadXgIdON2I0VCdHWdwUobFBtE1onTHgFMlVckZu2XvaIe
         ifZlXlWlyRlCwcbteqUED0mntVNznEovugzD09ArgYSleanh68b4Gsbrw4z6LKQyILJF
         llYirpSqwV+GIYGtOQHtRTmbs9nJkSZ5A6fZAdReadrJbUdETvHg3gLqF5ftEFQ6rwpw
         dK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738805392; x=1739410192;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wIxvtwzmLpA97snLzsRJfxwNm03aAP0R1NKy0YT1wtQ=;
        b=PNhuaQkLUZs0hQpqVm+I3ac6z5JLk6Uxv7oFw1es2HBtos23SPAc1hg6cz3lpMgylj
         nC78zEnfSJD7xxhDZsqcfaKdAQricAANOINyLUHYLA3A+dXmtaLFxmIaB9EsXNb3ckkE
         hGIPUszs61wQjz0mggI2761GLTvggdmp9VD0HnOKOsK9JM8iMhw23fsVUlcpWqYPotmH
         Zl8C8aAMPIBx4cseN5hmUhC8IZu2nyldgviraRQeFJ803rrbdQRTFzsaVCzAgvXNr96F
         kiVTvEoFu1tzPbV3Dfds/LL2Ta7TzZ15OevdhSBtQv0hX1rqUzDGaKePCbp3Wa+4yqpv
         OgXg==
X-Forwarded-Encrypted: i=1; AJvYcCUDRBoZTfuzxZZiH4uUoVbzASGBEktY++lj8PHWqRK8rOPYskCIOMTbGFt/swR6cUAyPxY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypubi3/xaRk+r/azR2/KQUG13n4zkyLwj5TVOnHIUtHQAHzrbn
	JpO/bjv1vDLLd/30o1/O81Abi4zIlwv8KyaCOzoBOWycE1W08KYx1cp3Sk4rT6PVcX0VGI4t8NK
	EWQ==
X-Google-Smtp-Source: AGHT+IEc+WF9sBFeqf5d4e4mEckdMGn6b3CMOgM9mvlyLWRnENoi46S8TptBfJj5+idIW8MscGmtn3KBoRM=
X-Received: from pjbee7.prod.google.com ([2002:a17:90a:fc47:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c86:b0:2ef:31a9:95af
 with SMTP id 98e67ed59e1d1-2f9e081077cmr7520457a91.27.1738805392310; Wed, 05
 Feb 2025 17:29:52 -0800 (PST)
Date: Wed, 5 Feb 2025 17:29:50 -0800
In-Reply-To: <CABCjUKCDoHtLyX2CvrN+_D4N5ZiL2sLzyg+vY=LMkWZefrP_cA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
 <Z4qK4B6taSoZTJMp@google.com> <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
 <Z5AB-6bLRNLle27G@google.com> <CABCjUKB-4kvAg5U0D2O2aiTgfHnYx5qBTBEJJsK7edZY5g5eTQ@mail.gmail.com>
 <CABCjUKCDoHtLyX2CvrN+_D4N5ZiL2sLzyg+vY=LMkWZefrP_cA@mail.gmail.com>
Message-ID: <Z6QQjmJE4CiWtUpI@google.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2025, Suleiman Souhlal wrote:
> On Tue, Feb 4, 2025 at 4:58=E2=80=AFPM Suleiman Souhlal <suleiman@google.=
com> wrote:
> > > Given that s2idle and standby don't reset host TSC, I think the right=
 way to
> > > handle this conundrum is to address the flaw that's noted in the "bac=
kwards TSC"
> > > logic, and adjust guest TSC to be fully up-to-date in the S3 (or lowe=
r) case.
> > >
> > >          * ......................................  Unfortunately, we =
can't
> > >          * bring the TSCs fully up to date with real time, as we aren=
't yet far
> > >          * enough into CPU bringup that we know how much real time ha=
s actually
> > >          * elapsed; our helper function, ktime_get_boottime_ns() will=
 be using boot
> > >          * variables that haven't been updated yet.
> > >
> > > I have no idea why commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable =
due to S4
> > > suspend") hooked kvm_arch_enable_virtualization_cpu() instead of impl=
ementing a
> > > PM notifier, but I don't see anything that suggests it was deliberate=
, i.e. that
> > > KVm *needs* to effectively snapshot guest TSC when onlining CPUs.
> > >
> > > If that wart is fixed, then both kvmclock and TSC will account host s=
uspend time,
> > > and KVM can safely account the suspend time into steal time regardles=
s of which
> > > clock(s) the guest is using.
> >
> > I tried your suggestion of moving this to a PM notifier and I found
> > that it's possible for VCPUs to run after resume but before the PM
> > notifier has been called, because the resume notifiers get called
> > after tasks are unfrozen. Unfortunately that means that if we were to
> > do that, guest TSCs could go backwards.

Ugh.  That explains why KVM hooks the CPU online path.

> > However, I think it should be possible to keep the existing backwards
> > guest TSC prevention code but also use a notifier that further adjusts
> > the guest TSCs to advance time on suspends where the TSC did go
> > backwards. This would make both s2idle and deep suspends behave the
> > same way.
>=20
> An alternative might be to block VCPUs from newly entering the guest
> between the pre and post suspend notifiers.
> Otherwise, some of the steal time accounting would have to be done in
> kvm_arch_enable_virtualization_cpu(), to make sure it gets applied on
> the first VCPU run, in case that happens before the resume notifier
> would have fired. But the comment there says we can't call
> ktime_get_boottime_ns() there, so maybe that's not possible.

I don't think the PM notifier approach is viable.  It's simply too late.  W=
ithout
a hook in CPU online, KVM can't even tell which VMs/vCPUs were running befo=
re the
suspend, i.e. which VMs need to be updated.

One idea would be to simply fast forward guest TSC to current time when the=
 vCPU
is loaded after suspend+resume.  E.g. this hack appears to work.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcd0c12c308e..27b25f8ca413 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4824,7 +4824,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int c=
pu)
=20
        /* Apply any externally detected TSC adjustments (due to suspend) *=
/
        if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
-               adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustme=
nt);
+               u64 kernel_ns, tsc_now;
+
+               if (kvm_get_time_and_clockread(&kernel_ns, &tsc_now)) {
+                       u64 l1_tsc =3D nsec_to_cycles(vcpu, vcpu->kvm->arch=
.kvmclock_offset + kernel_ns);
+                       u64 offset =3D kvm_compute_l1_tsc_offset(vcpu, l1_t=
sc);
+
+                       kvm_vcpu_write_tsc_offset(vcpu, offset);
+               } else {
+                       adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_=
adjustment);
+               }
                vcpu->arch.tsc_offset_adjustment =3D 0;
                kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
        }

