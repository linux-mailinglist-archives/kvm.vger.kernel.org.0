Return-Path: <kvm+bounces-22206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0013893B921
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 00:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E538B227F8
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 22:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C7A13CA93;
	Wed, 24 Jul 2024 22:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="30ORIKu/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836513C8F3
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721859883; cv=none; b=Jb7+RMHeoeP8XKZQgFs+tyoTtkXTnUGkUrwTkTZLLcdXMIvTzgDf7SZ0pW0g6RHgUoLVZNBlaFSR46wUQqBFz8EKj/olsf+eYl18dJftUahoLIOqtUmQGTqkRmTzvr4t6myt67R3ojhw7RRZZuinmtQzbz+KPEwKRWVXNnFKHFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721859883; c=relaxed/simple;
	bh=YVeTpyLQS7Fo39DFB3kzkv0+prMCtVNaZVRwGLVYm8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KuXPr0TtDJiYyuCXbpO8ywhrPmrEyRyZbMr7Rrngc4m0tkkQmK9bbEgjEpRrw5Hylgdr69lJP3mHCyOvKLc9MFrBzI2Kupk5+LYwwsa4p+R3aosuWMATdWCZQRFxjbIbiAwVTYf3Vt9fNTC4VAXeN4NBARVkiWWv2nW4uLcdJEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=30ORIKu/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb50fbebd9so373570a91.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 15:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721859882; x=1722464682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/QRUtBT695zkiPc+baUEFMOUTjFEHLVEpxt5NTb5GY=;
        b=30ORIKu/XPrs57NbtHjC40SaqsnxPix5Q1N1m7G+rDVBanTAONcev0hVkh1yhWweU6
         apfit2pH/Zo5lDNATdHAZjhiFD5aO22hWbDmd1FFgtRpReQv5t7EAmXuV9j0L3q2dfeJ
         zblAwc8TyXQxmcgYRmzlKuPltG/yCtxpRbvaezAG4tVGCvAYPsqpOa+bzB1gTDtPggbY
         pFVDSwoLcOTz5AVKJRrVN4hIca1qzjq8WDLgubgEf6ES3VANhhxHcXYqlRRGpv9fHc3k
         XY3PjGZWKwh5FE3u2Sl1DxN8TA57IBW4pZ0pEUO5grObXxn2YgCLAetlpSnv3PiII/I0
         t9dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721859882; x=1722464682;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L/QRUtBT695zkiPc+baUEFMOUTjFEHLVEpxt5NTb5GY=;
        b=WpR1zWuPNZ+g1P2I25bE6Vm3OXUDTRWyFYT9sBW2INT+2DVuNkBl7CaYwyt7d/KhOC
         ESeuKU7zsdGFg7fnWdemYwJ6fEA6vFx1BPqqE6zdYgf0ZhonBOBK3o+Ryzo2wGgduUql
         fPQCN3kQBXy0G1YZkpEgl8ZtEAeoTgvqJJuOIKEt1bE2cIcQ/2O4Ud6V8rxiZUzlAsbL
         dUAUxfOzcxOEdABRyeAfCtXrE2BYRRYt33Cit+O/6pV1yow1wtow6yrV1t14+pZaLUvJ
         RffiJ2lfXtJszRhOpuWzf8OKrSlRbsCxu/oHMavWGGyI/fAEmq8bJmDi2pItZGgqgkQ+
         4ZPg==
X-Forwarded-Encrypted: i=1; AJvYcCX2nWD3ayvtfEK8q2Z0Utkz0K9noW01+Yd8Y2sdlHj2x7kDr06yyBqf2f0tslTEUpYyHSobVJU9jgzvln5rvoQfdSLq
X-Gm-Message-State: AOJu0Yx1CB/seKmPyRS1OYIG1Fs/2tLtPCKu+h/UfSz+MTINC3vH63ih
	3iXuieL0/iWXUSQtDMxw+k2vtOTmh9oCmmFty2cvsjXRe4sPIopZuSYYaTzV2v3uQWxcPrg1xDt
	2Pg==
X-Google-Smtp-Source: AGHT+IGu5m/+SZT9ZZ6qzY5AiuNFEc1kp6NZ2DBSazvUNi30Px3Mmj/+EXBaw9mrLuXT9EHO+2AfxV+YyjA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:128e:b0:2c9:98bc:3584 with SMTP id
 98e67ed59e1d1-2cf23e1ac85mr2602a91.6.1721859881485; Wed, 24 Jul 2024 15:24:41
 -0700 (PDT)
Date: Wed, 24 Jul 2024 15:24:39 -0700
In-Reply-To: <efc0a84f2498c47579620ccdf53c7ccd93ca981e.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com> <20210916181538.968978-5-oupton@google.com>
 <efc0a84f2498c47579620ccdf53c7ccd93ca981e.camel@infradead.org>
Message-ID: <ZqF_J0I7kSBjQYW6@google.com>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK'
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Oliver Upton <oupton@google.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>, 
	Jim Mattson <jmattson@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	linux-arm-kernel@lists.infradead.org, Andrew Jones <drjones@redhat.com>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

/cast <Raise Skeleton>

On Wed, Jan 17, 2024, David Woodhouse wrote:
> On Thu, 2021-09-16 at 18:15 +0000, Oliver Upton wrote:
> >=20
> > @@ -5878,11 +5888,21 @@ static int kvm_vm_ioctl_set_clock(struct kvm *k=
vm, void __user *argp)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * is slightly ahead) h=
ere we risk going negative on unsigned
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 'system_time' when '=
data.clock' is very small.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (kvm->arch.use_master_clo=
ck)
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0now_ns =3D ka->master_kernel_ns;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (data.flags & KVM_CLOCK_R=
EALTIME) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0u64 now_real_ns =3D ktime_get_real_ns();
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/*
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Avoid stepping the kvmclock backwards.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (now_real_ns > data.realtime)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0data.c=
lock +=3D now_real_ns - data.realtime;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > +
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ka->use_master_clock)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0now_raw_ns =3D ka->master_kernel_ns;
>=20
> This looks wrong to me.
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0else
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0now_ns =3D get_kvmclock_base_ns();
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ka->kvmclock_offset =3D data=
.clock - now_ns;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0now_raw_ns =3D get_kvmclock_base_ns();
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ka->kvmclock_offset =3D data=
.clock - now_raw_ns;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvm_end_pvclock_update(=
kvm);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > =C2=A0}
>=20
> We use the host CLOCK_MONOTONIC_RAW plus the boot offset, as a
> 'kvmclock base clock', and get_kvmclock_base_ns() returns that. The KVM
> clocks for each VMs are based on this 'kvmclock base clock', each
> offset by a ka->kvmclock_offset which represents the time at which that
> VM was started =E2=80=94 so each VM's clock starts from zero.
>=20
> The values of ka->master_kernel_ns and ka->master_cycle_now represent a
> single point in time, the former being the value of
> get_kvmclock_base_ns() at that moment and the latter being the host TSC
> value. In pvclock_update_vm_gtod_copy(), kvm_get_time_and_clockread()
> is used to return both values at precisely the same moment, from the
> *same* rdtsc().
>=20
> This allows the current 'kvmclock base clock' to be calculated at any
> moment by reading the TSC, calculating a delta to that reading from
> ka->master_cycle_now to determine how much time has elapsed since
> ka->master_kernel_ns. We can then add ka->kvmclock_offset to get the
> kvmclock for this particular VM.
>=20
> Now, looking at the code quoted above. It's given a kvm_clock_data
> struct which contains a value of the KVM clock which is to be set as
> the time "now", and all it does is adjust ka->kvmclock_offset
> accordingly. Which is really simple:
>=20
> 		now_raw_ns =3D get_kvmclock_base_ns();
> 	ka->kvmclock_offset =3D data.clock - now_raw_ns;
>=20
> Et voil=C3=A0, now get_kvmclock_base_ns() + ka->kvmclock_offset at any gi=
ven
> moment in time will result in a kvmclock value according to what was
> just set. Yay!
>=20
> Except... in the case where the TSC is constant, we actually set
> 'now_raw_ns' to a value that doesn't represent *now*. Instead, we set
> it to ka->master_kernel_ns which represents some point in the *past*.
> We should add the number of TSC ticks since ka->master_cycle_now if
> we're going to use that, surely?

Somewhat ironically, without the KVM_CLOCK_REALTIME goo, there's no need to
re-read TSC, because the rdtsc() in pvclock_update_vm_gtod_copy() *just* ha=
ppened.
But the call to ktime_get_real_ns() could theoretically spin for a non-triv=
ial
amount of time if the clock is being refreshed.

