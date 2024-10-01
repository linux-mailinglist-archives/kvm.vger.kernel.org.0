Return-Path: <kvm+bounces-27758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B024098B69E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 10:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C10031C22111
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 08:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739981990BE;
	Tue,  1 Oct 2024 08:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X2SrU10w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B0438396
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 08:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727770713; cv=none; b=uToSDZa0Ob7Dh3xXvjlxfvccjKl7HMpyYKPINVcMPC2Lo8vGOkr29zqZrMxLTI/J0lDrgQM/bJgY8eGNMjGYOcasCTwf0j70QeuME8ETSxfwNVEFw7obJGB8DtQnC7I/oUmzGxZE6uj03cLRQRWJF/N6gVf++4FfHBDbJlRhtf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727770713; c=relaxed/simple;
	bh=FVxXA/46bA5Ju+Ip7o8RoCF1qH4WFWf5J+bvz/jXLNo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ByvidbfIQGYvrnANDrSAHKrAGpoFptduK7CYSYZpx5b5mH54HdSc0djhP/kRDuRllg32c/+7IB/5RuCOjqItlOCjTs5622rC8AptFbPH8+AIu77nMjJU/CiadiPTNA4JNXOGrdvWacKIY4Ogo/zvB32cdBYYC3nfa+XoOvLcXDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X2SrU10w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727770710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fHoFX0PDnSZTfecN4IZ6eBr8XhvG76aRuFk6iUg1wg=;
	b=X2SrU10wxz1xKAnN9Gep020hPJNhuF1E0LHb5OkGHHnIyjXNnwHt4zyTJhb00G96Ntk+Pz
	htzFvnmUy/oW1PlSulOk1aw45XeIarMPAOEe002iJBrqKpaNom4TliYbFsN8vlazXRb6fj
	b8MZPj4ICUslQEB2S1DiBHpYu7FUZa0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-g6xlseJAOQ-ZjUz2fAoUcQ-1; Tue, 01 Oct 2024 04:18:28 -0400
X-MC-Unique: g6xlseJAOQ-ZjUz2fAoUcQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42cdeac2da6so43501595e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 01:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727770707; x=1728375507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fHoFX0PDnSZTfecN4IZ6eBr8XhvG76aRuFk6iUg1wg=;
        b=g1tattynPKzE+z4IE5QyF6RuOQUxttOzWh2mNOL88VLaLYuT5XB+U0XNVrMmFUv6cs
         7M1VbSjvs5QOYB2uFVRDprm+VyfiTkKWK7XquD1Z1ugkHYcmAobuDZ6P7lgr6CPvywH7
         kZpkr+cZ7ZjzDxjJNzhhPYxHKbu9cZ3DDIKSCW+cVQOQx5ON0jRVwXEG0v0F5aad9udi
         mBPkqowMDEK/qzXc66AvG3EyroGE1RSJ1/gRPux2Oi2nZ5WyTSV9gs53UEUqo+5jQn68
         NTcvoyTN/XJ1F5QlDqihg/Oe8VdOtLRJZuAKHNzCl4aU6lUN1CHOIesyXLzCNeCVuMnM
         4mGA==
X-Forwarded-Encrypted: i=1; AJvYcCWeRzuPHnbsv8rQgHiIXL7mUgcOkBuurYhdrC2dNUfRpnlHoUXanKEAmWlDVYik97sOprQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0p90E4IkrwsJHKcbz1hT6kZMTghmW3N2BwOBcODyz4UOXgQZV
	lZIpnEP9TUzhWr7eYaZjt20+CqZtul+VXadVeRzmcRK4nzLOYqKzUyDBqqsjKTiU/1w7NHyisPD
	J4IBlEk84OkleC16PfcMn/+tsOp5uOH2pcj1Ze8UbjV6n6nvU6A==
X-Received: by 2002:a05:600c:a4b:b0:42c:b6e4:e3aa with SMTP id 5b1f17b1804b1-42f5840d0e8mr111361495e9.5.1727770707342;
        Tue, 01 Oct 2024 01:18:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFw8ufUH6F5nDbkSSNEqTEzuf4KWYsJLQeJtg49jP8WrSSKL+9gbTDJ/scSAsPl74EhIIVgvA==
X-Received: by 2002:a05:600c:a4b:b0:42c:b6e4:e3aa with SMTP id 5b1f17b1804b1-42f5840d0e8mr111361235e9.5.1727770706900;
        Tue, 01 Oct 2024 01:18:26 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd56e6875sm11227722f8f.55.2024.10.01.01.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 01:18:26 -0700 (PDT)
Date: Tue, 1 Oct 2024 10:18:25 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Eric Mackay <eric.mackay@oracle.com>
Cc: boris.ostrovsky@oracle.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
Message-ID: <20241001101825.38b23397@imammedo.users.ipa.redhat.com>
In-Reply-To: <20240930233458.27182-1-eric.mackay@oracle.com>
References: <20240927112839.1b59ca46@imammedo.users.ipa.redhat.com>
	<20240930233458.27182-1-eric.mackay@oracle.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Sep 2024 16:34:57 -0700
Eric Mackay <eric.mackay@oracle.com> wrote:

> > On Thu, 26 Sep 2024 18:22:39 -0700
> > Eric Mackay <eric.mackay@oracle.com> wrote: =20
> > > > On 9/24/24 5:40 AM, Igor Mammedov wrote:   =20
> > > >> On Fri, 19 Apr 2024 12:17:01 -0400
> > > >> boris.ostrovsky@oracle.com wrote:
> > > >>    =20
> > > >>> On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote:   =20
> > > >>>>
> > > >>>> I noticed that I was using a few months old qemu bits and now I =
am
> > > >>>> having trouble reproducing this on latest bits. Let me see if I =
can get
> > > >>>> this to fail with latest first and then try to trace why the pro=
cessor
> > > >>>> is in this unexpected state.   =20
> > > >>>
> > > >>> Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu=
 call
> > > >>> under if (!dev) in qmp_device_add()" is what makes the test to st=
op failing.
> > > >>>
> > > >>> I need to understand whether lack of failures is a side effect of=
 timing
> > > >>> changes that simply make hotplug fail less likely or if this is an
> > > >>> actual (but seemingly unintentional) fix.   =20
> > > >>=20
> > > >> Agreed, we should find out culprit of the problem.   =20
> > > >
> > > >
> > > > I haven't been able to spend much time on this unfortunately, Eric =
is=20
> > > > now starting to look at this again.
> > > >
> > > > One of my theories was that ich9_apm_ctrl_changed() is sending SMIs=
 to=20
> > > > vcpus serially while on HW my understanding is that this is done as=
 a=20
> > > > broadcast so I thought this could cause a race. I had a quick test =
with=20
> > > > pausing and resuming all vcpus around the loop but that didn't help.
> > > >
> > > >   =20
> > > >>=20
> > > >> PS:
> > > >> also if you are using AMD host, there was a regression in OVMF
> > > >> where where vCPU that OSPM was already online-ing, was yanked
> > > >> from under OSMP feet by OVMF (which depending on timing could
> > > >> manifest as lost SIPI).
> > > >>=20
> > > >> edk2 commit that should fix it is:
> > > >>      https://github.com/tianocore/edk2/commit/1c19ccd5103b
> > > >>=20
> > > >> Switching to Intel host should rule that out at least.
> > > >> (or use fixed edk2-ovmf-20240524-5.el10.noarch package from centos,
> > > >> if you are forced to use AMD host)   =20
> > >=20
> > > I haven't been able to reproduce the issue on an Intel host thus far,
> > > but it may not be an apples-to-apples comparison because my AMD hosts
> > > have a much higher core count.
> > >  =20
> > > >
> > > > I just tried with latest bits that include this commit and still wa=
s=20
> > > > able to reproduce the problem.
> > > >
> > > >
> > > >-boris   =20
> > >=20
> > > The initial hotplug of each CPU appears to complete from the
> > > perspective of OVMF and OSPM. SMBASE relocation succeeds, and the new
> > > CPU reports back from the pen. It seems to be the later INIT-SIPI-SIPI
> > > sequence sent from the guest that doesn't complete.
> > >=20
> > > My working theory has been that some CPU/AP is lagging behind the oth=
ers
> > > when the BSP is waiting for all the APs to go into SMM, and the BSP j=
ust
> > > gives up and moves on. Presumably the INIT-SIPI-SIPI is sent while th=
at
> > > CPU does finally go into SMM, and other CPUs are in normal mode.
> > >=20
> > > I've been able to observe the SMI handler for the problematic CPU will
> > > sometimes start running when no BSP is elected. This means we have a
> > > window of time where the CPU will ignore SIPI, and least 1 CPU is in
> > > normal mode (the BSP) which is capable of sending INIT-SIPI-SIPI from
> > > the guest. =20
> >=20
> > I've re-read whole thread and noticed Boris were saying: =20
> >   > On Tue, Apr 16, 2024 at 10:57=E2=80=AFPM <boris.ostrovsky@oracle.co=
m> wrote: =20
> >   > > On 4/16/24 4:53 PM, Paolo Bonzini wrote:   =20
> >   ... =20
> >   > > >
> >   > > > What is the reproducer for this?   =20
> >   > >
> >   > > Hotplugging/unplugging cpus in a loop, especially if you oversubs=
cribe
> >   > > the guest, will get you there in 10-15 minutes. =20
> >   ...
> >=20
> > So there was unplug involved as well, which was broken since forever.
> >=20
> > Recent patch
> >  https://patchew.org/QEMU/20230427211013.2994127-1-alxndr@bu.edu/202304=
27211013.2994127-2-alxndr@bu.edu/
> > has exposed issue (unexpected uplug/unplug flow) with root cause in OVM=
F.
> > Firmware was letting non involved APs run wild in normal mode.
> > As result AP that was calling _EJ0 and holding ACPI lock was
> > continuing _EJ0 and releasing ACPI lock, while BSP and a being removed
> > CPU were still in SMM world. And any other plug/unplug op
> > were able to grab ACPI lock and trigger another SMI, which breaks
> > hotplug flow expectations (aka exclusive access to hotplug registers
> > during plug/unplug op)
> > Perhaps that's what you are observing.
> >=20
> > Please check if following helps:
> >   https://github.com/kraxel/edk2/commit/738c09f6b5ab87be48d754e62deb72b=
767415158
> >  =20
>=20
> I haven't actually seen the guest crash during unplug, though certainly
> there have been unplug failures. I haven't been keeping track of the
> unplug failures as closely, but a test I ran over the weekend with this
> patch added seemed to show less unplug failures.

it's not only about unplug, unfortunately.
QEMU that includes Alexander's patch, essentially denies access to hotplug
registers if unplug is in process. So if there is hotplug going at the same
time, it may be broken by that access deny.
To exclude this issue, you need to test with edk2 fix or use older QEMU
without Alexander's patch.


> I'm still getting hotplug failures that cause a guest crash though, so
> that mystery remains.
>=20
> > So yes, SIPI can be lost (which should be expected as others noted)
> > but that normally shouldn't be an issue as wakeup_secondary_cpu_via_ini=
t()
> > do resend SIPI.
> > However if wakeup_secondary_cpu is set to another handler that doesn't
> > resend SIPI, It might be an issue. =20
>=20
> We're using wakeup_secondary_cpu_via_init(). acpi_wakeup_cpu() and
> wakeup_cpu_via_vmgexit(), for example, are a bit opaque to me, so I'm
> not sure if those code paths include a SIPI resend.

wakeup_secondary_cpu_via_init() should re-send SIPI.
If you can reproduce with KVM tracing and guest kernel debug enabled,
I'd try to do that and check if SIPI are being re-sent or not.
That at least should give a hint if we should look at guest side or at KVM/=
QEMU.


