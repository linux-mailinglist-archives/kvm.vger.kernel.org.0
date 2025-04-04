Return-Path: <kvm+bounces-42656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 696DCA7BFE6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 16:50:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FFF13B33D7
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 14:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25C61F463E;
	Fri,  4 Apr 2025 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cTu5lGVY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6041F3D30
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 14:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743778107; cv=none; b=A8dCI8wXcLjNZT9NwRS3dwHs5Pks0MVAb//jEH71DPZ+37553cX4Ib2A2DPVs/nSMjedIvbfnM3I6pIRtsA21ApxJN2v2ydUVnQpSj/kswg7JIpzrj3a19zUdtTdEL8oIoxG1UZfFVvQV7rGPxdmxHsNOnALjjBUQlKQfnOruU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743778107; c=relaxed/simple;
	bh=7GoSdsG/z6MpG2BagU+D4l810H5dr152SZ9Pl+lLkHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I7KO6U2mJXQhao/EkAha2GXzoVYg9rR8H8LmRVZ5Eair+b1Y61aL5ctLSSFStnEiMDVAOutuB1n4k/HrtdAzEp6O5WHtjx3nmHnXtoUC7Pvg/0Fg6poQ5gUZnG6vWy+d1d9fNEfcAd5MnBezal9ux8ZuG/JbIqpio7Vjs5pejh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cTu5lGVY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7395d07a3dcso1734734b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 07:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743778104; x=1744382904; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJhPpgrch93rw9qEOeOeCjiRRouixDVFkUmIy3HUxXE=;
        b=cTu5lGVYLdmbLfYh2hUqzaSQ9t3uYG73iXUTiuVj+B13ux9VIsF5/A3Ku7P+APCmj3
         pR2k1BH/cjeSh2vXr/yCxAZYzze9WyMwJFGd+/47XEN8WaOuy0UUN1BDr4NbPmI5YNyR
         KWjO8T9lhIxfvb6wNTcyXJiFYc6+IvAebUeYp8xJIX9uvOU1T4XQqqwysWK6oUTHIQTt
         agxZYLmaVH9HmgaKeLNdegK/aXuMnSyAvvWXdnahsu7AOgmYgI4wxfR+EJsBtGFiNocI
         TGvxJvFnkK3zFg5hrdhvw70zI4E8YhbCFbh94VJDA5RcCkIOvfQbaQDycF9Rb/x9cG0e
         EB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743778104; x=1744382904;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AJhPpgrch93rw9qEOeOeCjiRRouixDVFkUmIy3HUxXE=;
        b=AvEIA+vbhKAQKM7r/K86VECRQMMhitVZVm6+1AjS4M/79npd3pcGx3ntNuB7S22VDk
         +EerL/fs5DiRS5kOrGh/PEa1BTCrtyTQ29HbBHDahgYB7h0sZPJkBwIwZNL37ZNqkXjt
         RK6TnsadCPh6VA/+zWxa4kTtCFLRg6k58D2UVqh6StWZX2M/RLoT2l6LoZLRfzJSbBgv
         zYXna83i1FJVquwRVEM7hRTE/HBLJhqEbhZ4VpFhEuKexPk880qOQunPqgKMK+2WlyLP
         9qpvlFNuuiV71lfcHTRzc/X2qvky4wOeAbZXO+wVdiCfKK2CvmtYfpw5rbkmv9dVaA8P
         V8gg==
X-Gm-Message-State: AOJu0YwUojLRYH6hl2UxAgV3ZNoSsWqNOZ1Me+3dy/aL1SY1g1TKZppb
	ssmjj756TcE7vW+6l/6L/BPx3MnCgdXqNPcpCToySxp6uA+K9xKEhrlu+n/BHjCW3d82tmNnY+A
	ndw==
X-Google-Smtp-Source: AGHT+IHFvdwrET8Y6QcdUiOgpiO855/145zExvENJh/buRtt+mH/PTvvhnAGZvIkGKaQJbDWqiOBm8BuNwU=
X-Received: from pffk21.prod.google.com ([2002:aa7:88d5:0:b0:736:6fb6:804])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c991:b0:1f5:87a0:60ed
 with SMTP id adf61e73a8af0-2010800c6b8mr4326139637.19.1743778104358; Fri, 04
 Apr 2025 07:48:24 -0700 (PDT)
Date: Fri, 4 Apr 2025 07:48:22 -0700
In-Reply-To: <676ed22f-9c3f-4013-99d8-37c4c73bb9ac@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250317091917.72477-1-liamni-oc@zhaoxin.com> <Z9gl5dbTfZsUCJy-@google.com>
 <676ed22f-9c3f-4013-99d8-37c4c73bb9ac@zhaoxin.com>
Message-ID: <Z-_xNpgsYDW0_4Jn@google.com>
Subject: Re: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT
 state to reduce the performance overhead caused by hrtimer during guest stop.
From: Sean Christopherson <seanjc@google.com>
To: LiamNioc <LiamNi-oc@zhaoxin.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, LiamNi@zhaoxin.com, 
	CobeChen@zhaoxin.com, LouisQi@zhaoxin.com, EwanHai@zhaoxin.com, 
	FrankZhu@zhaoxin.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025, LiamNioc wrote:
> On 2025/3/17 21:38, Sean Christopherson wrote:
> > On Mon, Mar 17, 2025, Liam Ni wrote:
> > > When using the dump-guest-memory command in QEMU to dump
> > > the virtual machine's memory,the virtual machine will be
> > > paused for a period of time.If the guest (i.e., UEFI) uses
> > > the PIT as the system clock,it will be observed that the
> > > HRTIMER used by the PIT continues to run during the guest
> > > stop process, imposing an additional burden on the system.
> > > Moreover, during the guest restart process,the previously
> > > established HRTIMER will be canceled,and the accumulated
> > > timer events will be flushed.However, before the old
> > > HRTIMER is canceled,the accumulated timer events
> > > will "surreptitiously" inject interrupts into the guest.
> > >=20
> > > SO during the process of saving the KVM PIT state,
> > > the HRTIMER need to be canceled to reduce the performance overhead
> > > caused by HRTIMER during the guest stop process.
> > >=20
> > > i.e. if guest
> > >=20
> > > Signed-off-by: Liam Ni <liamni-oc@zhaoxin.com>
> > > ---
> > >   arch/x86/kvm/x86.c | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > >=20
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 045c61cc7e54..75355b315aca 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -6405,6 +6405,8 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm=
, struct kvm_pit_state *ps)
> > >=20
> > >        mutex_lock(&kps->lock);
> > >        memcpy(ps, &kps->channels, sizeof(*ps));
> > > +     hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
> > > +     kthread_flush_work(&kvm->arch.vpit->expired);
> >=20
> > KVM cannot assume userspace wants to stop the PIT when grabbing a snaps=
hot.  It's
> > a significant ABI change, and not desirable in all cases.
>=20
> When VM Pause, all devices of the virtual machine are frozen, so the PIT
> freeze only saves the PIT device status, but does not cancel HRTIMER, but
> chooses to cancel HRTIMER when VM resumes and refresh the pending task.
> According to my observation, before refreshing the pending task, these
> pending tasks will secretly inject interrupts into the guest.
>=20
> So do we need to cancel the HRTIMER when VM pause=EF=BC=9F

The problem is that KVM has no real concept of pausing a VM.  There are a v=
ariety
of hacky hooks here and there, but no KVM-wide notion of "pause".

For this case, after getting PIT state, you should be able to use KVM_SET_P=
IT2 to
set the mode of channel[0] to 0xff, which call destroy_pit_timer() via
pit_load_count().

